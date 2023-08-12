
----------------------------------------------------------------------------------------------------

USE RYPlatformDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_LoadCheckInReward]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_LoadCheckInReward]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_CheckInQueryInfo]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_CheckInQueryInfo]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_CheckInDone]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_CheckInDone]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- 加载奖励
CREATE PROC GSP_GP_LoadCheckInReward
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN

	-- 查询奖励
	SELECT * FROM SigninConfig	

END

RETURN 0

GO

----------------------------------------------------------------------------------------------------
-- 查询签到
CREATE PROC GSP_GR_CheckInQueryInfo
	@dwUserID INT,								-- 用户 I D
	@strPassword NCHAR(32),						-- 用户密码
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN

	-- 查询用户
	IF not exists(SELECT * FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo WHERE UserID=@dwUserID AND LogonPass=@strPassword)
	BEGIN
		SET @strErrorDescribe = N'抱歉，你的用户信息不存在或者密码不正确！'
		return 1
	END

	-- 签到记录
	DECLARE @wSeriesDate INT	
	DECLARE @StartDateTime DateTime
	DECLARE @LastDateTime DateTime
	SELECT @StartDateTime=StartDateTime,@LastDateTime=LastDateTime,@wSeriesDate=SeriesDate FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsSignin 	
	WHERE UserID=@dwUserID
	IF @StartDateTime IS NULL OR @LastDateTime IS NULL OR @wSeriesDate IS NULL
	BEGIN
		SELECT @StartDateTime=GetDate(),@LastDateTime=GetDate(),@wSeriesDate=0
		INSERT INTO RYAccountsDBLink.RYAccountsDB.dbo.AccountsSignin VALUES(@dwUserID,@StartDateTime,@LastDateTime,0)		
	END

	-- 调整日期
	IF @wSeriesDate > 7 SET @wSeriesDate = 7

	-- 日期判断
	DECLARE @TodayCheckIned TINYINT
	SET @TodayCheckIned = 0
	IF DateDiff(dd,@LastDateTime,GetDate()) = 0 	
	BEGIN
		IF @wSeriesDate > 0 SET @TodayCheckIned = 1
	END ELSE
	BEGIN		
		IF DateDiff(dd,@StartDateTime,GetDate()) <> @wSeriesDate OR @wSeriesDate >= 7 
		BEGIN
			SET @wSeriesDate = 0
			UPDATE RYAccountsDBLink.RYAccountsDB.dbo.AccountsSignin SET StartDateTime=GetDate(),LastDateTime=GetDate(),SeriesDate=0 WHERE UserID=@dwUserID									
		END
	END

	-- 抛出数据
	SELECT @wSeriesDate AS SeriesDate,@TodayCheckIned AS TodayCheckIned	
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

-- 查询奖励
CREATE PROC GSP_GR_CheckInDone
	@dwUserID INT,								-- 用户 I D
	@strPassword NCHAR(32),						-- 用户密码
	@strClientIP NVARCHAR(15),					-- 连接地址
	@strMachineID NVARCHAR(32),					-- 机器标识
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN

	-- 查询用户
	IF NOT EXISTS(SELECT * FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo WHERE UserID=@dwUserID AND LogonPass=@strPassword)
	BEGIN
		SET @strErrorDescribe = N'用户信息不存在或者密码不正确！'
		RETURN 1
	END
	
	-- 领取限制
	DECLARE @LimitMachineCount AS  SMALLINT
	SELECT @LimitMachineCount=StatusValue FROM RYAccountsDBLink.RYAccountsDB.dbo.SystemStatusInfo WHERE StatusName=N'SignInLimitMachine'
	IF @LimitMachineCount IS NULL SET @LimitMachineCount=0

	-- 限制判断
	IF @LimitMachineCount <> 0
	BEGIN
		DECLARE @TodayMachineCount INT
		SELECT @TodayMachineCount = COUNT(ClinetMachine) FROM RYRecordDB.dbo.RecordSignin WHERE DateDiff(d,CollectDate,GetDate())=0 AND @strMachineID = ClinetMachine
		IF @TodayMachineCount >= @LimitMachineCount
		BEGIN
			SET @strErrorDescribe = N'当前机器已经超过限制！'	
		RETURN 4		
		END
	END


	-- 签到记录
	DECLARE @wSeriesDate INT	
	DECLARE @StartDateTime DateTime
	DECLARE @LastDateTime DateTime
	SELECT @StartDateTime=StartDateTime,@LastDateTime=LastDateTime,@wSeriesDate=SeriesDate FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsSignin 
	WHERE UserID=@dwUserID
	IF @StartDateTime IS NULL OR @LastDateTime IS NULL OR @wSeriesDate IS NULL
	BEGIN
		SELECT @StartDateTime = GetDate(),@LastDateTime = GetDate(),@wSeriesDate = 0
		INSERT INTO RYAccountsDBLink.RYAccountsDB.dbo.AccountsSignin VALUES(@dwUserID,@StartDateTime,@LastDateTime,0)		
	END

	-- 签到判断
	IF DateDiff(dd,@LastDateTime,GetDate()) = 0 AND @wSeriesDate > 0
	BEGIN
		SET @strErrorDescribe = N'抱歉，您今天已经签到了！'
		return 3		
	END

	-- 日期越界
	IF @wSeriesDate > 7
	BEGIN
		SET @strErrorDescribe = N'您的签到信息出现异常，请与我们的客服人员联系！'
		return 2				
	END

	-- 更新记录
	SET @wSeriesDate = @wSeriesDate+1
	UPDATE RYAccountsDBLink.RYAccountsDB.dbo.AccountsSignin SET LastDateTime = GetDate(),SeriesDate = @wSeriesDate WHERE UserID = @dwUserID

	-- 查询奖励
	DECLARE @lRewardGold BIGINT
	SELECT @lRewardGold=RewardGold FROM RYPlatformDBLink.RYPlatformDB.dbo.SigninConfig WHERE DayID=@wSeriesDate
	IF @lRewardGold IS NULL 
	BEGIN
		SET @lRewardGold = 0
	END	

	-- 查询金币
	DECLARE @CurrScore BIGINT
	DECLARE @CurrInsure BIGINT
	SELECT @CurrScore=Score,@CurrInsure=InsureScore FROM RYTreasureDBLink.RYTreasureDB.dbo.GameScoreInfo  WHERE UserID=@dwUserID
	
	IF @CurrScore IS NULL SET @CurrScore=0
	IF @CurrInsure IS NULL SET @CurrInsure=0
	
	-- 奖励金币	
	UPDATE RYTreasureDBLink.RYTreasureDB.dbo.GameScoreInfo SET Score = Score + @lRewardGold WHERE UserID = @dwUserID
	IF @@rowcount = 0
	BEGIN
		-- 插入资料
		INSERT INTO RYTreasureDBLink.RYTreasureDB.dbo.GameScoreInfo (UserID,Score, LastLogonIP, LastLogonMachine, RegisterIP, RegisterMachine)
		VALUES (@dwUserID, @lRewardGold, @strClientIP, @strMachineID, @strClientIP, @strMachineID)
	END
	

	-- 插入记录
	INSERT INTO RYRecordDB.dbo.RecordSignin(UserID,Gold,ClinetIP,ClinetMachine,CollectDate) VALUES (@dwUserID,@lRewardGold,@strClientIP,@strMachineID,GETDATE())	
	
	-- 流水账
	INSERT INTO RYTreasureDBLink.RYTreasureDB.dbo.RecordPresentInfo(UserID,PreScore,PreInsureScore,PresentScore,TypeID,IPAddress,CollectDate)
	VALUES (@dwUserID,@CurrScore,@CurrInsure,@lRewardGold,3,@strClientIP,GETDATE())	
	
	-- 日统计
	DECLARE @DateID INT
	SET @DateID=CAST(CAST(GETDATE() AS FLOAT) AS INT)
	UPDATE RYTreasureDBLink.RYTreasureDB.dbo.StreamPresentInfo SET DateID=@DateID, PresentCount=PresentCount+1,PresentScore=PresentScore+@lRewardGold WHERE UserID=@dwUserID AND TypeID=3
	IF @@ROWCOUNT=0
	BEGIN
		INSERT RYTreasureDBLink.RYTreasureDB.dbo.StreamPresentInfo(DateID,UserID,TypeID,PresentCount,PresentScore) VALUES(@DateID,@dwUserID,3,1,@lRewardGold)
	END	

	-- 查询金币
	DECLARE @lScore BIGINT	
	SELECT @lScore=Score FROM RYTreasureDBLink.RYTreasureDB.dbo.GameScoreInfo WHERE UserID = @dwUserID 	
	IF @lScore IS NULL SET @lScore = 0
	
	-- 抛出数据
	SELECT @lScore AS Score	
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------
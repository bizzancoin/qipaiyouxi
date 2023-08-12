
----------------------------------------------------------------------------------------------------

USE RYPlatformDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_LoadBaseEnsure]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_LoadBaseEnsure]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_TakeBaseEnsure]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_TakeBaseEnsure]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------
-- 加载低保
CREATE PROC GSP_GP_LoadBaseEnsure
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN

	-- 领取条件
	DECLARE @ScoreCondition AS BIGINT
	SELECT @ScoreCondition=StatusValue FROM RYAccountsDBLink.RYAccountsDB.dbo.SystemStatusInfo WHERE StatusName=N'SubsistenceCondition'
	IF @ScoreCondition IS NULL SET @ScoreCondition=0

	-- 领取次数
	DECLARE @TakeTimes AS SMALLINT
	SELECT @TakeTimes=StatusValue FROM RYAccountsDBLink.RYAccountsDB.dbo.SystemStatusInfo WHERE StatusName=N'SubsistenceNumber'
	IF @TakeTimes IS NULL SET @TakeTimes=0

	-- 领取数量
	DECLARE @ScoreAmount AS BIGINT
	SELECT @ScoreAmount=StatusValue FROM RYAccountsDBLink.RYAccountsDB.dbo.SystemStatusInfo WHERE StatusName=N'SubsistenceGold'
	IF @ScoreAmount IS NULL SET @ScoreAmount=0

	-- 抛出数据
	SELECT @ScoreCondition AS ScoreCondition,@TakeTimes AS TakeTimes,@ScoreAmount AS ScoreAmount
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

-- 领取低保
CREATE PROC GSP_GP_TakeBaseEnsure
	@dwUserID INT,								-- 用户 I D
	@strPassword NCHAR(32),						-- 用户密码
	@strClientIP NVARCHAR(15),					-- 连接地址
	@strMachineID NVARCHAR(32),					-- 机器标识
	@strNotifyContent NVARCHAR(127) OUTPUT		-- 提示内容
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN

	-- 查询用户
	IF NOT EXISTS(SELECT * FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo WHERE UserID=@dwUserID AND LogonPass=@strPassword)
	BEGIN
		SET @strNotifyContent = N'用户信息不存在或者密码不正确！'
		RETURN 1
	END

	-- 领取条件
	DECLARE @ScoreCondition AS BIGINT
	SELECT @ScoreCondition=StatusValue FROM RYAccountsDBLink.RYAccountsDB.dbo.SystemStatusInfo WHERE StatusName=N'SubsistenceCondition'
	IF @ScoreCondition IS NULL SET @ScoreCondition=0

	-- 领取次数
	DECLARE @TakeTimes AS SMALLINT
	SELECT @TakeTimes=StatusValue FROM RYAccountsDBLink.RYAccountsDB.dbo.SystemStatusInfo WHERE StatusName=N'SubsistenceNumber'
	IF @TakeTimes IS NULL SET @TakeTimes=0

	-- 领取数量
	DECLARE @ScoreAmount AS BIGINT
	SELECT @ScoreAmount=StatusValue FROM RYAccountsDBLink.RYAccountsDB.dbo.SystemStatusInfo WHERE StatusName=N'SubsistenceGold'
	IF @ScoreAmount IS NULL SET @ScoreAmount=0
	
	-- 领取限制
	DECLARE @LimitMachineCount AS  SMALLINT
	SELECT @LimitMachineCount=StatusValue FROM RYAccountsDBLink.RYAccountsDB.dbo.SystemStatusInfo WHERE StatusName=N'SubsistenceLimitMachine'
	IF @LimitMachineCount IS NULL SET @LimitMachineCount=0

	-- 限制判断
	IF @LimitMachineCount <> 0
	BEGIN
		DECLARE @TodayMachineCount INT
		SELECT @TodayMachineCount = COUNT(ClinetMachine) FROM RYRecordDB.dbo.RecordBaseEnsure WHERE DateDiff(d,CollectDate,GetDate())=0 AND @strMachineID = ClinetMachine
		IF @TodayMachineCount >= @LimitMachineCount
		BEGIN
			SET @strNotifyContent = N'当前机器已经超过限制！'	
		RETURN 4
		END
	END	
		
	-- 读取金币
	DECLARE @CurrScore BIGINT
	DECLARE @CurrInsure BIGINT
	SELECT @CurrScore=Score,@CurrInsure=InsureScore FROM RYTreasureDBLink.RYTreasureDB.dbo.GameScoreInfo WHERE UserID=@dwUserID
	IF @@rowcount = 0
	BEGIN
		-- 插入资料
		INSERT INTO RYTreasureDBLink.RYTreasureDB.dbo.GameScoreInfo (UserID,Score,LastLogonIP, LastLogonMachine, RegisterIP, RegisterMachine)
		VALUES (@dwUserID, 0, @strClientIP, @strMachineID, @strClientIP, @strMachineID)

		-- 设置金币
		SELECT @CurrScore=0,@CurrInsure=0
	END

	-- 调整金币	
	SET @CurrScore = @CurrScore + @CurrInsure

	-- 领取判断
	IF @CurrScore >= @ScoreCondition
	BEGIN
		SET @strNotifyContent = N'您的游戏币不低于 '+CAST(@ScoreCondition AS NVARCHAR)+N'，不可领取！'	
		RETURN 1	
	END	

	-- 领取记录
	DECLARE @TodayDateID INT
	DECLARE @TodayTakeTimes INT	
	SET @TodayDateID=CAST(CAST(GetDate() AS FLOAT) AS INT)	
	SELECT @TodayTakeTimes=TakeTimes FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsBaseEnsure WHERE UserID=@dwUserID AND TakeDateID=@TodayDateID
	IF @TodayTakeTimes IS NULL SET @TodayTakeTimes=0	

	-- 次数判断
	IF @TodayTakeTimes >= @TakeTimes
	BEGIN
		SET @strNotifyContent = N'您今日已领取 '+CAST(@TodayTakeTimes AS NVARCHAR)+N' 次，领取失败！'
		return 3		
	END
	


	-- 更新记录
	IF @TodayTakeTimes=0
	BEGIN
		SET @TodayTakeTimes = 1
		INSERT INTO RYAccountsDBLink.RYAccountsDB.dbo.AccountsBaseEnsure(UserID,TakeDateID,TakeTimes,TakeGold) VALUES(@dwUserID,@TodayDateID,@TodayTakeTimes,@ScoreAmount)		
	END ELSE
	BEGIN
		SET @TodayTakeTimes = @TodayTakeTimes+1
		UPDATE RYAccountsDBLink.RYAccountsDB.dbo.AccountsBaseEnsure SET TakeTimes=@TodayTakeTimes,TakeGold=TakeGold+@ScoreAmount WHERE UserID = @dwUserID AND TakeDateID=@TodayDateID		
	END	

	-- 领取金币	
	UPDATE RYTreasureDBLink.RYTreasureDB.dbo.GameScoreInfo SET Score = Score + @ScoreAmount WHERE UserID = @dwUserID
	
	-- 流水账
	INSERT INTO RYTreasureDBLink.RYTreasureDB.dbo.RecordPresentInfo(UserID,PreScore,PreInsureScore,PresentScore,TypeID,IPAddress,CollectDate)
	VALUES (@dwUserID,@CurrScore,@CurrInsure,@ScoreAmount,2,@strClientIP,GETDATE())	
	
	-- 日统计
	DECLARE @DateID INT
	SET @DateID=CAST(CAST(GETDATE() AS FLOAT) AS INT)
	UPDATE RYTreasureDBLink.RYTreasureDB.dbo.StreamPresentInfo SET DateID=@DateID, PresentCount=PresentCount+1,PresentScore=PresentScore+@ScoreAmount WHERE UserID=@dwUserID AND TypeID=2
	IF @@ROWCOUNT=0
	BEGIN
		INSERT RYTreasureDBLink.RYTreasureDB.dbo.StreamPresentInfo(DateID,UserID,TypeID,PresentCount,PresentScore) VALUES(@DateID,@dwUserID,2,1,@ScoreAmount)
	END		
	
	-- 插入记录
	INSERT INTO RYRecordDB.dbo.RecordBaseEnsure(UserID,Gold,ClinetIP,ClinetMachine,CollectDate) VALUES (@dwUserID,@ScoreAmount,@strClientIP,@strMachineID,GETDATE())

	-- 查询金币
	DECLARE @Score BIGINT
	SELECT @Score=Score FROM RYTreasureDBLink.RYTreasureDB.dbo.GameScoreInfo WHERE UserID = @dwUserID 	

	-- 输出提示
	SET @strNotifyContent = N'恭喜您，低保领取成功！您今日还可领取 '+CAST(@TakeTimes-@TodayTakeTimes AS NVARCHAR)+N' 次！'
	
	-- 抛出数据
	SELECT @Score AS Score	
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------

USE RYAccountsDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[NET_PW_Signin]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[NET_PW_Signin]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- 查询奖励
CREATE PROC NET_PW_Signin
	@dwUserID INT,								-- 用户 I D
	@strClientIP NVARCHAR(15),					-- 客户端IP
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN
	-- 查询用户
	IF NOT EXISTS(SELECT UserID FROM AccountsInfo WHERE UserID=@dwUserID)
	BEGIN
		SET @strErrorDescribe = N'抱歉，用户不存在！'
		RETURN 1
	END

	-- 签到记录
	DECLARE @SeriesDate INT	
	DECLARE @StartDateTime DateTime
	DECLARE @LastDateTime DateTime
	SELECT @StartDateTime=StartDateTime,@LastDateTime=LastDateTime,@SeriesDate=SeriesDate FROM AccountsSignin 
	WHERE UserID=@dwUserID
	IF @StartDateTime IS NULL OR @LastDateTime IS NULL OR @SeriesDate IS NULL
	BEGIN
		SELECT @StartDateTime=GETDATE(),@LastDateTime=GETDATE(),@SeriesDate=0
		INSERT INTO AccountsSignin VALUES(@dwUserID,@StartDateTime,@LastDateTime,0)		
	END

	-- 签到判断
	IF DATEDIFF(dd,@LastDateTime,GETDATE())=0 AND @SeriesDate > 0
	BEGIN
		SET @strErrorDescribe=N'抱歉，您今天已经签到了！'
		RETURN 3		
	END

	-- 日期越界
	IF @SeriesDate>7
	BEGIN
		SET @strErrorDescribe=N'您的签到信息出现异常，请与我们的客服人员联系！'
		RETURN 2				
	END

	-- 更新记录
	SET @SeriesDate=@SeriesDate+1
	UPDATE AccountsSignin SET LastDateTime=GETDATE(),SeriesDate=@SeriesDate WHERE UserID=@dwUserID

	-- 查询奖励
	DECLARE @RewardGold BIGINT
	SELECT @RewardGold=RewardGold FROM RYPlatformDBLink.RYPlatformDB.dbo.SigninConfig WHERE DayID=@SeriesDate
	IF @RewardGold IS NULL 
	BEGIN
		SET @RewardGold=0
	END	

	-- 奖励金币	
	UPDATE RYTreasureDBLink.RYTreasureDB.dbo.GameScoreInfo SET Score=Score+@RewardGold WHERE UserID=@dwUserID
	IF @@ROWCOUNT=0
	BEGIN	
		INSERT INTO RYTreasureDBLink.RYTreasureDB.dbo.GameScoreInfo(UserID,Score,LastLogonIP,LastLogonMachine,RegisterIP,RegisterMachine)
		VALUES(@dwUserID,@RewardGold,@strClientIP,'',@strClientIP,'')
	END

	-- 写入记录
	INSERT INTO RYRecordDBLink.RYRecordDB.dbo.RecordSignin(UserID,Gold,ClinetIP,CollectDate) 
	VALUES(@dwUserID,@RewardGold,@strClientIP,GETDATE())
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------

USE RYAccountsDB
GO



IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_RealAuth]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_RealAuth]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO


----------------------------------------------------------------------------------------------------

-- 实名认证
CREATE PROC GSP_GP_RealAuth
	@dwUserID INT,								-- 用户 I D	
	@strPassword NCHAR(32),						-- 用户密码
	@strCompellation NVARCHAR(16),				-- 真实名字
	@strPassPortID NVARCHAR(18),				-- 证件号码
	@strClientIP NVARCHAR(15),					-- 连接地址
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN

	-- 查询信息
	DECLARE @Password NCHAR(32)
	SELECT @Password=LogonPass FROM AccountsInfo WHERE UserID=@dwUserID

	-- 用户判断
	IF @Password IS NULL
	BEGIN 
		SET @strErrorDescribe=N'用户信息不存在，认证失败！'
		RETURN 1
	END

	-- 密码判断
	IF @Password<>@strPassword
	BEGIN 
		SET @strErrorDescribe=N'帐号密码不正确，认证失败！'
		RETURN 3
	END

	--简单验证
	IF LEN(@strPassPortID) = 0 OR LEN(@strCompellation) = 0
	BEGIN
		SET @strErrorDescribe=N'证件号码或真实姓名不正确，认证失败！'
		RETURN 4	
	END	
	
	--重复验证
	IF EXISTS (SELECT UserID FROM RYRecordDBLink.RYRecordDB.dbo.RecordAuthentPresent WHERE UserID=@dwUserID)
	BEGIN
		SET @strErrorDescribe=N'已经认证，认证失败！'
		RETURN 5		
	END
	
	-- 实名修改
	UPDATE AccountsInfo SET  Compellation=@strCompellation, PassPortID=@strPassPortID 	WHERE UserID=@dwUserID
	
	-- 成功判断
	IF @@ROWCOUNT=0
	BEGIN
		SET @strErrorDescribe=N'执行实名认证错误，请联系客户服务中心！'
		RETURN 6
	END
	
	-- 实名记录
	INSERT INTO RYRecordDBLink.RYRecordDB.dbo.RecordAuthentPresent(UserID,PassPortID,Compellation,IpAddress) VALUES(@dwUserID,@strPassPortID,@strCompellation,@strClientIP)	

	--查询奖励
	DECLARE @AuthentPresentCount AS BIGINT
	SELECT @AuthentPresentCount=StatusValue FROM SystemStatusInfo(NOLOCK) WHERE StatusName=N'AuthentPresent'
	IF @AuthentPresentCount IS NULL or @AuthentPresentCount=0
	BEGIN
		SET @strErrorDescribe=N'实名认证成功！'
		RETURN 0		
	END	
	
	-- 查询金币
	DECLARE @CurrScore BIGINT
	DECLARE @CurrInsure BIGINT
	DECLARE @CurrMedal INT
	SELECT @CurrScore=Score,@CurrInsure=InsureScore FROM RYTreasureDBLink.RYTreasureDB.dbo.GameScoreInfo  WHERE UserID=@dwUserID
	SELECT @CurrMedal=UserMedal FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo WHERE UserID=@dwUserID
	
	
	--发放奖励
	DECLARE @DateID INT
	SET @DateID=CAST(CAST(GETDATE() AS FLOAT) AS INT)
	-- 赠送金币
	UPDATE RYTreasureDBLink.RYTreasureDB.dbo.GameScoreInfo SET Score=Score+@AuthentPresentCount WHERE UserID=@dwUserID	
	
	-- 流水账
	INSERT INTO RYTreasureDBLink.RYTreasureDB.dbo.RecordPresentInfo(UserID,PreScore,PreInsureScore,PresentScore,TypeID,IPAddress,CollectDate)
	VALUES (@dwUserID,@CurrScore,@CurrInsure,@AuthentPresentCount,8,@strClientIP,GETDATE())
	
	-- 日统计
	UPDATE RYTreasureDBLink.RYTreasureDB.dbo.StreamPresentInfo SET DateID=@DateID, PresentCount=PresentCount+1,PresentScore=PresentScore+@AuthentPresentCount WHERE UserID=@dwUserID AND TypeID=8
	IF @@ROWCOUNT=0
	BEGIN
		INSERT RYTreasureDBLink.RYTreasureDB.dbo.StreamPresentInfo(DateID,UserID,TypeID,PresentCount,PresentScore) VALUES(@DateID,@dwUserID,8,1,@AuthentPresentCount)
	END	
	-- 游戏信息
	DECLARE @SourceScore BIGINT
	SELECT @SourceScore=Score FROM RYTreasureDBLink.RYTreasureDB.dbo.GameScoreInfo WHERE UserID=@dwUserID	
	SELECT @SourceScore AS SourceScore
	SET @strErrorDescribe=N'实名认证成功，奖励金币'+ CAST(@AuthentPresentCount AS NVARCHAR)  +N'！'			 							
	RETURN 0

END

GO

----------------------------------------------------------------------------------------------------

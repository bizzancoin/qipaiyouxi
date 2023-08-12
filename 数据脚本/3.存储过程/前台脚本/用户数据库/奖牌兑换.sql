----------------------------------------------------------------------------------------------------
-- 版权：2011
-- 时间：2012-02-23
-- 用途：奖牌兑换
----------------------------------------------------------------------------------------------------

USE RYAccountsDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].NET_PW_ConvertMedal') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].NET_PW_ConvertMedal
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_NULLS ON
GO

----------------------------------------------------------------------------------------------------
-- 奖牌兑换
CREATE PROCEDURE NET_PW_ConvertMedal
	@dwUserID	INT,						-- 用户 I D
	@dwMedals	INT,						-- 兑换数量
	@strClientIP VARCHAR(15),				-- 兑换地址
	@strErrorDescribe NVARCHAR(127) OUTPUT	-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 用户信息
DECLARE @UserID INT
DECLARE @Nullity BIT
DECLARE @StunDown BIT
DECLARE @CurrentMedals INT

-- 金币信息
DECLARE @InsureScore BIGINT

-- 兑换金币
DECLARE @ConvertGold BIGINT

-- 兑换比例
DECLARE @ConvertRate INT

-- 执行逻辑
BEGIN
	-- 查询用户
	SELECT @UserID=UserID, @Nullity=Nullity, @StunDown=StunDown,@CurrentMedals=UserMedal
	FROM AccountsInfo(NOLOCK) WHERE UserID=@dwUserID

	-- 查询用户
	IF @UserID IS NULL
	BEGIN
		SET @strErrorDescribe=N'您的帐号不存在或者密码输入有误，请查证后再次尝试登录！'
		RETURN 1
	END	
	
	-- 帐号禁止
	IF @Nullity<>0
	BEGIN
		SET @strErrorDescribe=N'您的帐号暂时处于冻结状态，请联系客户服务中心了解详细情况！'
		RETURN 2
	END	

	-- 帐号关闭
	IF @StunDown<>0
	BEGIN
		SET @strErrorDescribe=N'您的帐号使用了安全关闭功能，必须重新开通后才能继续使用！'
		RETURN 3
	END		

	-- 数量判断
	IF @dwMedals > @CurrentMedals 
	BEGIN
		SET @strErrorDescribe=N'非常抱歉,您的奖牌数不足！'
		RETURN 4
	END
	
	-- 查询金币
	SELECT @InsureScore = InsureScore FROM RYTreasureDBLink.RYTreasureDB.dbo.GameScoreInfo 
	WHERE UserID = @dwUserID
	IF @InsureScore IS NULL
	BEGIN
		SET @InsureScore = 0
	END

	-- 兑换率
	SELECT @ConvertRate=StatusValue FROM SystemStatusInfo WHERE StatusName=N'MedalExchangeRate'
	IF @ConvertRate IS NULL OR @ConvertRate=0
		SET @ConvertRate=1

	-- 兑换记录
	INSERT INTO RYRecordDBLink.RYRecordDB.dbo.RecordConvertUserMedal(
		UserID,CurInsureScore,CurUserMedal,ConvertUserMedal,ConvertRate,IsGamePlaza,ClientIP)
	VALUES(@UserID,@InsureScore,@CurrentMedals,@dwMedals,@ConvertRate,1,@strClientIP)
	
	-- 兑换
	SET @ConvertGold =  Convert(BIGINT,@dwMedals)*@ConvertRate
	UPDATE RYTreasureDBLink.RYTreasureDB.dbo.GameScoreInfo SET
		InsureScore = InsureScore+@ConvertGold
	WHERE UserID = @dwUserID

	IF @@ROWCOUNT = 0 
	BEGIN
		INSERT INTO RYTreasureDBLink.RYTreasureDB.dbo.GameScoreInfo(UserID,InsureScore,RegisterIP,LastLogonIP)
		VALUES(@UserID,@ConvertGold,@strClientIP,@strClientIP)
	END

	-- 更新奖牌数
	UPDATE AccountsInfo SET UserMedal = @CurrentMedals-@dwMedals
	WHERE UserID = @dwUserID
	SET @strErrorDescribe=N'奖牌兑换成功！' 
END

RETURN 0

GO
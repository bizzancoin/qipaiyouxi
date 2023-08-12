----------------------------------------------------------------------
-- 版权：2011
-- 时间：2011-09-1
-- 用途：金币存款
----------------------------------------------------------------------

USE [RYTreasureDB]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].NET_PW_InsureIn') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].NET_PW_InsureIn
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--------------------------------------------------------------------------------
-- 存款
CREATE PROCEDURE NET_PW_InsureIn
	@dwUserID			INT,						-- 用户标识

	@dwSwapScore		BIGINT,						-- 存款金额

	@strClientIP		NVARCHAR(15),				-- 操作地址
	@strCollectNote		NVARCHAR(63),				-- 备注
	@strErrorDescribe	NVARCHAR(127) OUTPUT		-- 输出信息	
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 基本信息
DECLARE @UserID			INT
DECLARE @ProtectID		INT
DECLARE @Nullity		TINYINT
DECLARE @StunDown		TINYINT

-- 金币信息	
DECLARE @Score BIGINT			
DECLARE @InsureScore BIGINT

-- 金币余额
DECLARE @ScoreBalance	BIGINT
DECLARE @InsureBalance	BIGINT

-- 执行逻辑
BEGIN

	DECLARE @EnjoinInsure INT
	-- 系统暂停
	SELECT @EnjoinInsure=StatusValue FROM RYAccountsDBLink.RYAccountsDB.dbo.SystemStatusInfo WHERE StatusName=N'EnjoinInsure'
	IF @EnjoinInsure IS NOT NULL AND @EnjoinInsure<>0
	BEGIN
		SELECT @strErrorDescribe=StatusString FROM RYAccountsDBLink.RYAccountsDB.dbo.SystemStatusInfo WHERE StatusName=N'EnjoinInsure'
		RETURN 1
	END

	-- 查询用户	
	SELECT	@UserID=UserID,@ProtectID=ProtectID, @Nullity=Nullity, @StunDown=StunDown		
	FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo WHERE UserID=@dwUserID

	-- 验证用户
	IF @UserID IS NULL
	BEGIN
		SET @strErrorDescribe=N'您的帐号不存在或者密码输入有误，请查证后再次尝试登录！'
		RETURN 1
	END

	-- 帐号封停
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

	-- 房间锁定
	IF EXISTS (SELECT UserID FROM GameScoreLocker(NOLOCK) WHERE UserID=@dwUserID)
	BEGIN
		SET @strErrorDescribe='您已经在财富房间了，需要进行保管操作，请先退出财富游戏房间！'	
		RETURN 4
	END	
	
	-- 最小存款额		
	DECLARE @MinSwapScore INT
	SELECT @MinSwapScore=StatusValue FROM RYAccountsDBLink.RYAccountsDB.dbo.SystemStatusInfo WHERE StatusName=N'BankPrerequisite'
	IF @MinSwapScore IS NULL
		SET @MinSwapScore=0

	IF @dwSwapScore < @MinSwapScore
	BEGIN
		SET @strErrorDescribe=N'非常抱歉,您每笔保管的数目至少为' + Convert(NVARCHAR(30), @MinSwapScore) + '金币！'
		RETURN 5
	END

	-- 金币查询
	SELECT @Score= Score, @InsureScore=InsureScore
	FROM GameScoreInfo WHERE UserID=@dwUserID	

	-- 增加金币负数判断
	IF @Score IS NULL OR @Score<0 OR @Score < @dwSwapScore
	BEGIN
		SET @strErrorDescribe=N'非常抱歉,您所携带的现金数目不足!'	
		RETURN 6
	END

	-- 余额计算
	SET @ScoreBalance = @Score - @dwSwapScore
	SET @InsureBalance = @InsureScore + @dwSwapScore

	-- 存款记录
	INSERT INTO RecordInsure(
		SourceUserID,SourceGold,SourceBank,SwapScore,IsGamePlaza,TradeType,ClientIP,CollectNote)
	VALUES(@UserID,@Score,@InsureScore,@dwSwapScore,1,1,@strClientIP,@strCollectNote)

	-- 存款操作
	UPDATE GameScoreInfo SET Score=@ScoreBalance, InsureScore=@InsureBalance
	WHERE UserID=@dwUserID

	SET @strErrorDescribe=N'存款成功!'
	SELECT @ScoreBalance AS Score,@InsureBalance AS InsureScore
	
END

SET NOCOUNT OFF

RETURN 0
GO



----------------------------------------------------------------------------------------------------
-- 版权：2011
-- 时间：2011-09-02
-- 用途：负分清零
----------------------------------------------------------------------------------------------------
USE RYGameScoreDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].NET_PW_ResetGameScore') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].NET_PW_ResetGameScore
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_NULLS ON
GO

---------------------------------------------------------------------------------------
--	负分清零
CREATE  PROCEDURE dbo.NET_PW_ResetGameScore
	@dwUserID INT,		-- 用户标识

	@strClientIP VARCHAR(15),				-- 地址
	@strErrorDescribe	NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 用户信息
DECLARE @UserID INT
DECLARE @Nullity BIT
DECLARE @StunDown BIT
DECLARE @MemberOrder TINYINT

-- 用户积分
DECLARE @Score BIGINT

BEGIN
	-- 查询用户
	SELECT @UserID=UserID, @Nullity=Nullity, @StunDown=StunDown,@MemberOrder=MemberOrder
	FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo WHERE UserID=@dwUserID

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

	-- 非会员
	IF @MemberOrder=0
	BEGIN
		SET @strErrorDescribe=N'您的帐号不是会员，必须开通会员后才能使用该功能！'
		RETURN 4
	END

	-- 查询积分
	SELECT @Score=Score FROM GameScoreInfo(NOLOCK) WHERE UserID=@dwUserID

	-- 积分判断
	IF @Score IS NULL OR @Score>=0
	BEGIN
		SET @strErrorDescribe=N'恭喜！您的游戏成绩保持的非常好，没有负分需要清零。'
		RETURN 5
	END
	
	UPDATE GameScoreInfo SET Score=0 WHERE UserID=@dwUserID

	SET @strErrorDescribe=N'负分清零成功！' 
END

SET NOCOUNT OFF

RETURN 0
GO
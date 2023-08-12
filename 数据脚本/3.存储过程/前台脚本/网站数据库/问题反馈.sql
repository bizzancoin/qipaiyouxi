----------------------------------------------------------------------------------------------------
-- 版权：2011
-- 时间：2011-09-02
-- 用途：问题反馈
----------------------------------------------------------------------------------------------------
USE RYNativeWebDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].NET_PW_AddGameFeedback') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].NET_PW_AddGameFeedback
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------
-- 问题反馈
CREATE PROCEDURE NET_PW_AddGameFeedback
	@strAccounts	NVARCHAR(31),			-- 用户帐号

	@strTitle		NVARCHAR(512),			-- 反馈主题
	@strContent		NVARCHAR(4000),			-- 反馈内容

	@strClientIP	NVARCHAR(15),			-- 反馈地址
	@strErrorDescribe	NVARCHAR(127) OUTPUT	--输出信息	
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 基本信息
DECLARE @UserID INT
DECLARE @Nullity BIT
DECLARE @StunDown BIT

-- 执行逻辑
BEGIN
	SET @UserID=0
	IF @strAccounts<>''
	BEGIN
		-- 查询用户
		SELECT @UserID=UserID,@Nullity=Nullity, @StunDown=StunDown
		FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo WHERE Accounts=@strAccounts

		-- 用户存在
		IF @UserID IS NULL OR @UserID=0
		BEGIN
			SET @strErrorDescribe=N'您的帐号不存在，请查证后再次输入！'
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
	END	

	-- 新增反馈
	INSERT INTO GameFeedbackInfo(FeedbackTitle,FeedbackContent,UserID,ClientIP,Nullity)
	VALUES(@strTitle,@strContent,@UserID,@strClientIP,1)

	SET @strErrorDescribe=N'问题反馈新增成功！'
END
RETURN 0
GO
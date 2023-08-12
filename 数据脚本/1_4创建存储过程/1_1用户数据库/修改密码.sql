
----------------------------------------------------------------------------------------------------

USE RYAccountsDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_ModifyLogonPassword]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_ModifyLogonPassword]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_ModifyInsurePassword]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_ModifyInsurePassword]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- 修改密码
CREATE PROC GSP_GP_ModifyLogonPassword
	@dwUserID INT,								-- 用户 I D
	@strSrcPassword NCHAR(32),					-- 用户密码
	@strNewPassword NCHAR(32),					-- 用户密码
	@strClientIP NVARCHAR(15),					-- 连接地址
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN

	-- 变量定义
	DECLARE @UserID INT
	DECLARE @Nullity BIT
	DECLARE @StunDown BIT
	DECLARE @InsurePass AS NCHAR(32)
	DECLARE @LogonPass AS NCHAR(32)

	-- 查询用户
	SELECT @UserID=UserID,@InsurePass=InsurePass, @LogonPass=LogonPass, @Nullity=Nullity, @StunDown=StunDown
	FROM AccountsInfo(NOLOCK) WHERE UserID=@dwUserID

	-- 查询用户
	IF @UserID IS NULL
	BEGIN
		SET @strErrorDescribe=N'您的帐号不存在或者密码输入有误，请查证后再次尝试！'
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
		RETURN 2
	END	
	
	-- 密码判断
	IF @LogonPass<>@strSrcPassword
	BEGIN
		SET @strErrorDescribe=N'您的帐号不存在或者密码输入有误，请查证后再次尝试！'
		RETURN 3
	END

	-- 密码判断
	IF @strNewPassword=N''
	BEGIN
		SET @strErrorDescribe=N'新帐号密码为空，不允许设置密码为空，请查证后再次尝试！'
		RETURN 3
	END

	-- 密码校验
	IF @strNewPassword = @InsurePass
	BEGIN
		SET @strErrorDescribe=N'密码不能与银行密码相同，请查证后再次尝试！'
		RETURN 1		
	END	
	
	-- 修改密码
	UPDATE AccountsInfo SET LogonPass=@strNewPassword WHERE UserID=@dwUserID

	-- 修改密码记录
	INSERT INTO RYRecordDBLink.RYRecordDB.dbo.RecordPasswdExpend(OperMasterID,UserID,ReLogonPasswd,ReInsurePasswd,ClientIP)
	VALUES(0,@dwUserID,@strNewPassword,N'',@strClientIP)

	-- 设置信息
	IF @@ERROR=0 
	BEGIN
		SET @strErrorDescribe=N'帐号密码修改成功，请牢记您的新帐号密码！'
	END

END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

-- 修改密码
CREATE PROC GSP_GP_ModifyInsurePassword
	@dwUserID INT,								-- 用户 I D
	@strSrcPassword NCHAR(32),					-- 用户密码
	@strNewPassword NCHAR(32),					-- 用户密码
	@strClientIP NVARCHAR(15),					-- 连接地址
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN

	-- 变量定义
	DECLARE @UserID INT
	DECLARE @Nullity BIT
	DECLARE @StunDown BIT
	DECLARE @InsurePass AS NCHAR(32)
	DECLARE @LogonPass AS NCHAR(32)

	-- 查询用户
	SELECT @UserID=UserID, @InsurePass=InsurePass, @Nullity=Nullity, @StunDown=StunDown ,@LogonPass = LogonPass
	FROM AccountsInfo(NOLOCK) WHERE UserID=@dwUserID

	-- 查询用户
	IF @UserID IS NULL
	BEGIN
		SET @strErrorDescribe=N'您的帐号不存在或者密码输入有误，请查证后再次尝试！'
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
		RETURN 2
	END	

	-- 密码判断
	IF @InsurePass = N'' 
	BEGIN
		SET @strErrorDescribe=N'抱歉，您还没有设置初始银行密码，请先开通银行功能！'
		RETURN 3
	END
	
	-- 密码判断
	IF @InsurePass IS NOT NULL AND @InsurePass<>@strSrcPassword
	BEGIN
		SET @strErrorDescribe=N'您的密码输入有误，请查证后再次尝试！'
		RETURN 3
	END

	-- 密码判断
	IF @strNewPassword=N''
	BEGIN
		SET @strErrorDescribe=N'新帐号密码为空，不允许设置密码为空，请查证后再次尝试！'
		RETURN 3
	END

	-- 密码校验
	IF @strNewPassword = @LogonPass
	BEGIN
		SET @strErrorDescribe=N'密码不能与登录密码相同，请查证后再次尝试！'
		RETURN 1		
	END	
	
	-- 修改密码
	UPDATE AccountsInfo SET InsurePass=@strNewPassword WHERE UserID=@dwUserID

	-- 修改密码记录
	INSERT INTO RYRecordDBLink.RYRecordDB.dbo.RecordPasswdExpend(OperMasterID,UserID,ReLogonPasswd,ReInsurePasswd,ClientIP)
	VALUES(0,@dwUserID,N'',@strNewPassword,@strClientIP)

	-- 设置信息
	IF @@ERROR=0 
	BEGIN
		SET @strErrorDescribe=N'保险柜密码修改成功，请牢记您的新保险柜密码！'
	END

	RETURN 0

END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

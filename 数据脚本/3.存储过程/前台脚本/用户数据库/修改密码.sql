----------------------------------------------------------------------------------------------------
-- 版权：2011
-- 时间：2011-08-31
-- 用途：修改密码
----------------------------------------------------------------------------------------------------

USE RYAccountsDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].NET_PW_ModifyLogonPass') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].NET_PW_ModifyLogonPass
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].NET_PW_ModifyInsurePass') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].NET_PW_ModifyInsurePass
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- 修改登录密码
CREATE PROCEDURE NET_PW_ModifyLogonPass
	@dwUserID INT,								-- 用户 I D

	@strSrcPassword NCHAR(32),					-- 用户密码
	@strDesPassword NCHAR(32),					-- 用户密码

	@strClientIP NVARCHAR(15),					-- 连接地址
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN

	-- 查询用户
	DECLARE @UserID INT
	DECLARE @Nullity BIT
	DECLARE @StunDown BIT
	DECLARE @LogonPass AS NCHAR(32)
	SELECT @UserID=UserID, @LogonPass=LogonPass, @Nullity=Nullity, @StunDown=StunDown
	FROM AccountsInfo(NOLOCK) WHERE UserID=@dwUserID

	-- 查询用户并且判断密码
	IF @UserID IS NULL OR @LogonPass<>@strSrcPassword
	BEGIN
		SET @strErrorDescribe=N'原登录密码输入错误,请重新输入！'
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

	-- 修改密码
	UPDATE AccountsInfo SET LogonPass=@strDesPassword WHERE UserID=@UserID
	
	-- 添加记录
	INSERT INTO RYRecordDB.dbo.RecordPasswdExpend(OperMasterID,UserID,ReLogonPasswd,ReInsurePasswd,ClientIP,CollectDate)
	VALUES(0,@dwUserID,@strDesPassword,'',@strClientIP,GETDATE())

	-- 设置信息	
	SET @strErrorDescribe= N'恭喜您，您的登录密码修改成功了！'

END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

-- 修改银行密码
CREATE PROCEDURE NET_PW_ModifyInsurePass
	@dwUserID INT,								-- 用户 I D

	@strSrcPassword NCHAR(32),					-- 用户密码
	@strDesPassword NCHAR(32),					-- 用户密码

	@strClientIP NVARCHAR(15),					-- 连接地址
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN

	-- 查询用户
	DECLARE @UserID INT
	DECLARE @Nullity BIT
	DECLARE @StunDown BIT
	DECLARE @InsurePass AS NCHAR(32)
	SELECT @UserID=UserID, @InsurePass=InsurePass, @Nullity=Nullity, @StunDown=StunDown
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
		RETURN 3
	END	
	
	-- 密码判断
	IF @InsurePass<>@strSrcPassword
	BEGIN
		SET @strErrorDescribe=N'您的保险柜密码输入有误，请查证后再次尝试！'
		RETURN 4
	END

	-- 修改密码
	UPDATE AccountsInfo SET InsurePass=@strDesPassword WHERE UserID=@UserID
	
	-- 添加记录
	INSERT INTO RYRecordDB.dbo.RecordPasswdExpend(OperMasterID,UserID,ReLogonPasswd,ReInsurePasswd,ClientIP,CollectDate)
	VALUES(0,@dwUserID,'',@strDesPassword,@strClientIP,GETDATE())

	-- 设置信息	
	SET @strErrorDescribe= N'恭喜您，您的保险柜密码修改成功了！'

END

RETURN 0

GO
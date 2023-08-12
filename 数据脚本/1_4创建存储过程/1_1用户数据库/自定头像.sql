

USE RYAccountsDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_SystemFaceInsert]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_SystemFaceInsert]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_CustomFaceInsert]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_CustomFaceInsert]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_CustomFaceDelete]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_CustomFaceDelete]
GO

----------------------------------------------------------------------------------------------------

-- 插入头像
CREATE PROC GSP_GP_SystemFaceInsert
	@dwUserID INT,								-- 用户标识
	@strPassword NCHAR(32),						-- 用户密码
	@wFaceID SMALLINT,							-- 头像标识
	@strClientIP NVARCHAR(15),					-- 连接地址
	@strMachineSerial NVARCHAR(32),				-- 机器标识
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN

	-- 查询用户
	DECLARE @LogonPass AS NCHAR(32)
	SELECT @LogonPass=LogonPass FROM AccountsInfo(NOLOCK) WHERE UserID=@dwUserID

	-- 密码判断
	IF @LogonPass IS NULL OR @LogonPass<>@strPassword
	BEGIN
		SET @strErrorDescribe=N'您的帐号不存在或者密码输入有误，请查证后再次尝试！'
		RETURN 1
	END

	-- 更新用户
	UPDATE AccountsInfo SET FaceID=@wFaceID, CustomID=0 WHERE UserID=@dwUserID

	-- 返回结果
	SELECT @wFaceID AS FaceID

END	

RETURN 0

GO

----------------------------------------------------------------------------------------------------

-- 插入头像
CREATE PROC GSP_GP_CustomFaceInsert
	@dwUserID INT,								-- 用户标识
	@strPassword NCHAR(32),						-- 用户密码
	@cbCustomFace IMAGE,						-- 图像数据
	@strClientIP NVARCHAR(15),					-- 连接地址
	@strMachineSerial NVARCHAR(12),				-- 机器标识
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN

	-- 查询用户
	DECLARE @LogonPass AS NCHAR(32)
	SELECT @LogonPass=LogonPass FROM AccountsInfo(NOLOCK) WHERE UserID=@dwUserID

	-- 密码判断
	IF @LogonPass IS NULL OR @LogonPass<>@strPassword
	BEGIN
		SET @strErrorDescribe=N'您的帐号不存在或者密码输入有误，请查证后再次尝试！'
		RETURN 1
	END

	-- 插入头像
	INSERT AccountsFace (UserID, CustomFace, InsertAddr, InsertMachine)
	VALUES (@dwUserID, @cbCustomFace, @strClientIP, @strMachineSerial)

	-- 更新用户
	DECLARE @CustomID INT
	SELECT @CustomID=SCOPE_IDENTITY()
	UPDATE AccountsInfo SET CustomID=@CustomID WHERE UserID=@dwUserID

	-- 返回结果
	SELECT @CustomID AS CustomID

END	

RETURN 0

GO

----------------------------------------------------------------------------------------------------

-- 删除头像
CREATE PROC GSP_GP_CustomFaceDelete 
	@dwUserID INT,								-- 用户标识
	@strPassword NCHAR(32),						-- 用户密码
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN

	-- 查询用户
	DECLARE @LogonPass AS NCHAR(32)
	SELECT @LogonPass=LogonPass FROM AccountsInfo(NOLOCK) WHERE UserID=@dwUserID

	-- 密码判断
	IF @LogonPass<>@strPassword
	BEGIN
		SET @strErrorDescribe=N'您的帐号不存在或者密码输入有误，请查证后再次尝试！'
		RETURN 1
	END

	-- 更新用户
	UPDATE AccountsInfo SET CustomID=0 WHERE UserID=@dwUserID

END	

RETURN 0

GO

----------------------------------------------------------------------------------------------------

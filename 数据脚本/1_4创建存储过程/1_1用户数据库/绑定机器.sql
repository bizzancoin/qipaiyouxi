
----------------------------------------------------------------------------------------------------

USE RYAccountsDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_MoorMachine]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_MoorMachine]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_UnMoorMachine]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_UnMoorMachine]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- 绑定机器
CREATE PROC GSP_GP_MoorMachine
	@dwUserID INT,								-- 用户 I D	
	@strPassword NCHAR(32),						-- 用户密码
	@strClientIP NVARCHAR(15),					-- 连接地址
	@strMachineSerial NVARCHAR(32),				-- 机器标识
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN

	-- 查询信息
	DECLARE @Password NCHAR(32)
	DECLARE @MoorMachine AS TINYINT
	DECLARE	@MachineSerial NCHAR(32)
	SELECT @Password=InsurePass, @MoorMachine=MoorMachine, @MachineSerial=LastLogonMachine FROM AccountsInfo WHERE UserID=@dwUserID

	-- 用户判断
	IF @Password IS NULL
	BEGIN 
		SET @strErrorDescribe=N'用户信息不存在，机器绑定失败！'
		RETURN 1
	END

	IF LEN(@Password)=0
	BEGIN 
		SET @strErrorDescribe=N'机器绑定失败，请先设置您的银行密码！'
		RETURN 5
	END	

	-- 绑定判断
	IF @MoorMachine=1 AND @MachineSerial<>@strMachineSerial
	BEGIN
		SET @strErrorDescribe=N'您的帐号已经绑定了其他机器了，必须解除后才能进行本机绑定操作！'
		RETURN 2
	END

	-- 密码判断
	IF @Password<>@strPassword
	BEGIN 
		SET @strErrorDescribe=N'由于您输入的银行密码不正确，机器绑定失败！'
		RETURN 3
	END

	-- 绑定操作
	UPDATE AccountsInfo SET MoorMachine=1, LastLogonMachine=@strMachineSerial WHERE UserID=@dwUserID

	-- 成功判断
	IF @@ROWCOUNT=0
	BEGIN 
		SET @strErrorDescribe=N'帐号绑定操作执行错误，请联系客户服务中心！'
		RETURN 4
	END

	-- 输出信息
	SET @strErrorDescribe=N'您的帐号与此机器绑定成功了，若需要解除绑定需在本机器进行！'
	
	RETURN 0

END

GO

----------------------------------------------------------------------------------------------------

-- 解除绑定
CREATE PROC GSP_GP_UnMoorMachine
	@dwUserID INT,								-- 用户 I D	
	@strPassword NCHAR(32),						-- 用户密码
	@strClientIP NVARCHAR(15),					-- 连接地址
	@strMachineSerial NVARCHAR(32),				-- 机器标识
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN

	-- 查询信息
	DECLARE @Password NCHAR(32)
	DECLARE @MoorMachine AS TINYINT
	DECLARE	@MachineSerial NCHAR(32)
	SELECT @Password=InsurePass, @MoorMachine=MoorMachine, @MachineSerial=LastLogonMachine FROM AccountsInfo WHERE UserID=@dwUserID

	-- 用户判断
	IF @MachineSerial IS NULL
	BEGIN 
		SET @strErrorDescribe=N'用户信息不存在，机器绑定失败！'
		RETURN 1
	END

	-- 本机判断
	IF @MoorMachine=1 AND @MachineSerial<>@strMachineSerial
	BEGIN
		SET @strErrorDescribe=N'您的帐号与其他机器进行了绑定，机器解除绑定失败！'
		RETURN 5
	END

	-- 密码判断
	IF @Password<>@strPassword
	BEGIN
		SET @strErrorDescribe=N'由于您输入的银行密码不正确，机器解除绑定失败！'
		RETURN 3
	END

	-- 解除操作
	UPDATE AccountsInfo SET MoorMachine=0 WHERE UserID=@dwUserID

	-- 成功判断
	IF @@ROWCOUNT=0
	BEGIN 
		SET @strErrorDescribe=N'帐号解除绑定操作执行错误，请联系客户服务中心！'
		RETURN 4
	END

	-- 输出信息
	SET @strErrorDescribe=N'您的帐号与机器解除绑定成功了！'
	
	RETURN 0

END

GO

----------------------------------------------------------------------------------------------------

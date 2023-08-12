
----------------------------------------------------------------------------------------------------

USE RYAccountsDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_ModifyUnderWrite]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_ModifyUnderWrite]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- 修改签名
CREATE PROC GSP_GP_ModifyUnderWrite
	@dwUserID INT,								-- 用户 I D	
	@strPassword NCHAR(32),						-- 用户密码
	@strUnderWrite NVARCHAR(31),				-- 用户密码
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
		SET @strErrorDescribe=N'用户信息不存在，机器绑定失败！'
		RETURN 1
	END

	-- 密码判断
	IF @Password<>@strPassword
	BEGIN 
		SET @strErrorDescribe=N'由于您提供的帐号密码不正确，个性签名修改失败！'
		RETURN 3
	END

	-- 设置签名
	UPDATE AccountsInfo SET UnderWrite=@strUnderWrite WHERE UserID=@dwUserID

	-- 成功判断
	IF @@ROWCOUNT=0
	BEGIN
		SET @strErrorDescribe=N'修改个性签名操作执行错误，请联系客户服务中心！'
		RETURN 4
	END

	RETURN 0

END

GO

----------------------------------------------------------------------------------------------------

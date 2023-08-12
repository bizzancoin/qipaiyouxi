
----------------------------------------------------------------------------------------------------

USE RYAccountsDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_VerifyIndividual]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_VerifyIndividual]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- 查询资料
CREATE PROC GSP_GP_VerifyIndividual
	@wVerifyMask INT,							-- 校验掩码
	@strVerifyContent NVARCHAR(32),				-- 校验内容
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN

	-- 校验帐号
	IF @wVerifyMask=1
	BEGIN
		IF exists(SELECT * FROM AccountsInfo WHERE Accounts=@strVerifyContent)
		BEGIN
			SET @strErrorDescribe=N'该帐号已被占用！'
			RETURN 1			
		END
	END

	-- 校验昵称
	IF @wVerifyMask=2
	BEGIN
		IF exists(SELECT * FROM AccountsInfo WHERE NickName=@strVerifyContent)
		BEGIN
			SET @strErrorDescribe=N'该昵称已被占用！'
			RETURN 1
		END
	END

	RETURN 0

END

RETURN 0

GO

----------------------------------------------------------------------------------------------------
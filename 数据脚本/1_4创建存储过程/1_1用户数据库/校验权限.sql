
----------------------------------------------------------------------------------------------------

USE RYAccountsDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_CheckUserRight]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_CheckUserRight]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- 检查权限
CREATE PROC GSP_GP_CheckUserRight
	@strAccounts	NVARCHAR(31),		-- 用户帐号
	@dwcheckRight	INT,					-- 校验权限	
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN

	-- 查询权限
	DECLARE @dwMasterRight INT
	SELECT @dwMasterRight=MasterRight FROM AccountsInfo WHERE Accounts=@strAccounts AND MasterOrder>0
	
	-- 调整权限
	IF @dwMasterRight IS NULL
	BEGIN
		SET @dwMasterRight=0
	END

	-- 检查权限
	IF (@dwMasterRight&@dwcheckRight)=0
	BEGIN
		SET @strErrorDescribe=N'抱歉,由于您权限不足,登录失败！'
		RETURN 1
	END	
			
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

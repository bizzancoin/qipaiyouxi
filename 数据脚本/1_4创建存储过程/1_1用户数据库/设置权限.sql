
----------------------------------------------------------------------------------------------------

USE RYAccountsDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_ManageUserRight]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_ManageUserRight]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- 设置权限
CREATE PROC GSP_GR_ManageUserRight
	@dwUserID		INT,				-- 用户 I D
	@dwAddRight		INT,				-- 增加权限
	@dwRemoveRight	INT					-- 删除权限
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN
	-- 设置权限
	UPDATE AccountsInfo SET UserRight=UserRight|@dwAddRight WHERE UserID=@dwUserID
	UPDATE AccountsInfo SET UserRight=(~@dwRemoveRight)&UserRight WHERE UserID=@dwUserID	
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

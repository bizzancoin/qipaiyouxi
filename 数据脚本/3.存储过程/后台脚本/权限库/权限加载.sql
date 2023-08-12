----------------------------------------------------------------------
-- 时间：2011-09-26
-- 用途：权限加载
----------------------------------------------------------------------

USE RYPlatformManagerDB
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[NET_PM_GetPermissionByUserID]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[NET_PM_GetPermissionByUserID]
GO

----------------------------------------------------------------------
CREATE PROC [NET_PM_GetPermissionByUserID]
	@dwUserID INT							-- 管理员标识	
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 角色标识
DECLARE @RoleID	INT

-- 执行逻辑
BEGIN
	-- 角色获取
	IF @dwUserID=1 SET @RoleID=1
	ELSE 
		SELECT @RoleID=RoleID FROM Base_Users(NOLOCK) WHERE UserID=@dwUserID

	-- 超级管理员
	IF @dwUserID=1 OR @RoleID=1
		BEGIN
			SELECT ModuleID,ParentID,0 AS OperationPermission
			FROM Base_Module 
			WHERE Nullity=0
			ORDER BY ParentID,OrderNo
		END
	ELSE
		BEGIN
			SELECT rip.ModuleID, m.ParentID, rip.OperationPermission
			FROM Base_RolePermission (NOLOCK) AS rip, Base_Module (NOLOCK) AS m
			WHERE rip.RoleID=@RoleID AND m.ModuleID=rip.ModuleID AND m.Nullity=0 
			ORDER BY m.ParentID,m.OrderNo
		END
END
RETURN 0
GO
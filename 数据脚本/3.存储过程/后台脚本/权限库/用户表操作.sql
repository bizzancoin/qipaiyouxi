----------------------------------------------------------------------
-- 时间：2010-04-21
-- 用途：管理用户操作(新增/更新/删除)
----------------------------------------------------------------------

USE RYPlatformManagerDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[BaseUser_OP]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[BaseUser_OP]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------

CREATE PROCEDURE [dbo].[BaseUser_OP]
	
	@Username NVARCHAR(40),					-- 用户名称
	@Password NVARCHAR(40),					-- 用户密码
	@RoleID		int,					        -- 权限组别
	@DataTable_Action_  varchar(10) = ''	-- 操作方法 Insert:增加 Update:修改 Delete:删除
AS

SET NOCOUNT ON

DECLARE @ReturnValue varchar(18) -- 返回操作结果

BEGIN
	-- 新增
	IF(@DataTable_Action_='Insert')
	BEGIN
		
		INSERT INTO Base_Users(
			Username,Password,RoleID)
		VALUES(
			@Username,@Password,@RoleID)
		SET @ReturnValue = SCOPE_IDENTITY()
		SELECT @ReturnValue
	END

SELECT @ReturnValue
END









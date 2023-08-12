----------------------------------------------------------------------
-- 时间：2010-03-16
-- 用途：赠送经验
----------------------------------------------------------------------

USE RYRecordDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[WSP_PM_GrantExperience]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[WSP_PM_GrantExperience]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO
----------------------------------------------------------------------
CREATE PROCEDURE WSP_PM_GrantExperience
	@MasterID INT,				-- 管理员标识
	@ClientIP VARCHAR(15),		-- 赠送地址
	@UserID INT,				-- 用户标识
	@AddExperience INT,			-- 赠送经验
	@Reason NVARCHAR(32)		-- 赠送原因
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 用户经验
DECLARE @CurExperience INT

-- 执行逻辑
BEGIN
	
	-- 获取用户经验
	SELECT @CurExperience = Experience FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo
	WHERE UserID = @UserID

	-- 新增记录信息
	INSERT INTO RecordGrantExperience(MasterID,ClientIP,UserID,CurExperience,AddExperience,Reason)
	VALUES(@MasterID,@ClientIP,@UserID,@CurExperience,@AddExperience,@Reason)

	-- 赠送经验
	UPDATE RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo SET Experience = Experience + @AddExperience
	WHERE UserID = @UserID
END
RETURN 0

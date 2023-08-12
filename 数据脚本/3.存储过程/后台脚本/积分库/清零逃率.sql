----------------------------------------------------------------------
-- 版权：2009
-- 时间：2010-03-16
-- 用途：清零逃率
----------------------------------------------------------------------
USE RYGameScoreDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[WSP_PM_GrantClearFlee]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[WSP_PM_GrantClearFlee]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO
----------------------------------------------------------------------

CREATE PROCEDURE WSP_PM_GrantClearFlee
	@MasterID INT,				-- 管理员标识
	@ClientIP VARCHAR(15),		-- 清零地址
	@UserID INT,				-- 用户标识
	@KindID INT,				-- 游戏标识
	@Reason NVARCHAR(32)		-- 清零原因
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 用户逃跑次数
DECLARE @CurFlee INT

-- 返回信息
DECLARE @ReturnValue NVARCHAR(127)

-- 执行逻辑
BEGIN
	
	-- 获取用户逃率次数
	SELECT @CurFlee = FleeCount FROM GameScoreInfo WHERE UserID=@UserID
	IF @CurFlee = 0 OR @CurFlee IS NULL
	BEGIN
		SET @ReturnValue = N'没有逃跑记录，不需要清零！'
		SELECT @ReturnValue
		RETURN 1
	END

	-- 新增记录信息
	INSERT INTO RYRecordDBLink.RYRecordDB.dbo.RecordGrantClearFlee(MasterID,ClientIP,UserID,KindID,CurFlee,Reason)
	VALUES(@MasterID,@ClientIP,@UserID,@KindID,@CurFlee,@Reason)

	-- 清零逃率
	UPDATE GameScoreInfo SET FleeCount = 0 WHERE UserID=@UserID	

	SELECT ''
END
RETURN 0

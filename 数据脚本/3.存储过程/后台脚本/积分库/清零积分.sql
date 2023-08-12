----------------------------------------------------------------------
-- 版权：2009
-- 时间：2010-03-16
-- 用途：清零积分
----------------------------------------------------------------------
USE RYGameScoreDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[WSP_PM_GrantClearScore]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[WSP_PM_GrantClearScore]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO
----------------------------------------------------------------------

CREATE PROCEDURE WSP_PM_GrantClearScore
	@MasterID INT,				-- 管理员标识
	@ClientIP VARCHAR(15),		-- 赠送地址
	@UserID INT,				-- 用户标识
	@KindID INT,				-- 游戏标识
	@Reason NVARCHAR(32)		-- 清零原因
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 用户积分
DECLARE @CurScore BIGINT

-- 返回信息
DECLARE @ReturnValue NVARCHAR(127)

-- 执行逻辑
BEGIN
	
	-- 获取用户积分
	SELECT 	@CurScore = Score FROM GameScoreInfo WHERE UserID=@UserID
	IF @CurScore>=0 OR @CurScore IS NULL
	BEGIN
		SET @ReturnValue = N'没有负分信息，不需要清零！'
		SELECT @ReturnValue
		RETURN 1
	END

	-- 新增记录信息
	INSERT INTO RYRecordDBLink.RYRecordDB.dbo.RecordGrantClearScore(MasterID,ClientIP,UserID,KindID,CurScore,Reason)
	VALUES(@MasterID,@ClientIP,@UserID,@KindID,@CurScore,@Reason)

	-- 清零积分
	UPDATE GameScoreInfo SET Score = 0 WHERE UserID=@UserID	

	SELECT ''
END
RETURN 0
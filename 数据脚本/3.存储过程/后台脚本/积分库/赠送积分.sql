----------------------------------------------------------------------
-- 版权：2009
-- 时间：2010-03-16
-- 用途：赠送积分
----------------------------------------------------------------------

USE RYGameScoreDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[WSP_PM_GrantGameScore]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[WSP_PM_GrantGameScore]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO
----------------------------------------------------------------------

CREATE PROCEDURE WSP_PM_GrantGameScore
	@MasterID INT,				-- 管理员标识
	@ClientIP VARCHAR(15),		-- 赠送地址	
	@UserID INT,				-- 用户标识
	@KindID INT,				-- 游戏标识
	@AddScore BIGINT,			-- 赠送积分
	@Reason NVARCHAR(32)		-- 赠送原因
	
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 用户积分
DECLARE @CurScore BIGINT

-- 执行逻辑
BEGIN
	
	-- 获取用户积分
	SELECT 	@CurScore = Score FROM GameScoreInfo WHERE UserID=@UserID
	IF @CurScore IS NULL
	BEGIN
		SET @CurScore = 0
	END

	-- 新增记录信息
	INSERT INTO RYRecordDBLink.RYRecordDB.dbo.RecordGrantGameScore(MasterID,ClientIP,UserID,KindID,CurScore,AddScore,Reason)
	VALUES(@MasterID,@ClientIP,@UserID,@KindID,@CurScore,@AddScore,@Reason)

	-- 赠送积分
	UPDATE GameScoreInfo SET Score = Score + @AddScore
	WHERE UserID=@UserID
	
	IF @@ROWCOUNT = 0 
	BEGIN
		INSERT INTO GameScoreInfo(UserID,Score,RegisterIP,LastLogonIP)
		VALUES(@UserID,@AddScore,@ClientIP,@ClientIP)
	END
END
RETURN 0
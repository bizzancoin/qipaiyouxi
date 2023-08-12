
----------------------------------------------------------------------------------------------------

USE RYGameScoreDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'dbo.GSP_GR_LoadSystemMessage') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE dbo.GSP_GR_LoadSystemMessage
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- 加载机器
CREATE PROC GSP_GR_LoadSystemMessage
	@wServerID SMALLINT							-- 房间 I D
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN

	-- 查询机器
	SELECT * FROM RYPlatformDBLink.RYPlatformDB.dbo.SystemMessage
	WHERE (StartTime <= GETDATE()) AND (ConcludeTime > GETDATE()) AND (StartTime<ConcludeTime) AND Nullity=0 ORDER BY ID

END

RETURN 0

GO

----------------------------------------------------------------------------------------------------
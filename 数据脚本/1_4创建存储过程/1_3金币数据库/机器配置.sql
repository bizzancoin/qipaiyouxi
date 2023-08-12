
----------------------------------------------------------------------------------------------------

USE RYTreasureDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'dbo.GSP_GR_LoadAndroidConfigure') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE dbo.GSP_GR_LoadAndroidConfigure
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- 加载机器配置
CREATE PROC GSP_GR_LoadAndroidConfigure
	@wKindID SMALLINT,							-- 游戏 I D
	@wServerID SMALLINT							-- 房间 I D
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN

	-- 查询机器
	SELECT BatchID,ServiceMode,AndroidCount,EnterTime,LeaveTime,EnterMinInterval,EnterMaxInterval,LeaveMinInterval,
		LeaveMaxInterval,TakeMinScore,TakeMaxScore,SwitchMinInnings,SwitchMaxInnings,AndroidCountMember0,AndroidCountMember1,AndroidCountMember2
           ,AndroidCountMember3,AndroidCountMember4,AndroidCountMember5 FROM RYAccountsDBLink.RYAccountsDB.dbo.Androidconfigure
	WHERE ServerID=@wServerID ORDER BY BatchID

END

RETURN 0

GO

----------------------------------------------------------------------------------------------------
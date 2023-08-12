
----------------------------------------------------------------------------------------------------

USE RYAccountsDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_LoadAgentGameKindItem]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_LoadAgentGameKindItem]
GO


SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO



----------------------------------------------------------------------------------------------------

-- 代理列表
CREATE PROC GSP_GP_LoadAgentGameKindItem
	@dwUserID INT,								-- 用户标识
	@dwDeviceID INT,							-- 设备标识	
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN 

	-- 查询信息
	DECLARE @AgentID INT
	SET @AgentID =0
	SELECT @AgentID = AgentID FROM AccountsAgent WHERE UserID IN (SELECT SpreaderID FROM AccountsInfo WHERE @dwUserID = UserID )
	
	SELECT KindID ,SortID FROM AccountsAgentGame(NOLOCK) WHERE AgentID = @AgentID AND DeviceID = @dwDeviceID
END

GO



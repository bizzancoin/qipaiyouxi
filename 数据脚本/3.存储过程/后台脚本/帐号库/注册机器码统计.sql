----------------------------------------------------------------------
-- 时间：2010-03-16
-- 用途：赠送经验
----------------------------------------------------------------------

USE RYAccountsDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[WSP_PM_GetMachineRegisterTop100]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[WSP_PM_GetMachineRegisterTop100]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO
----------------------------------------------------------------------
CREATE PROCEDURE WSP_PM_GetMachineRegisterTop100

WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 用户经验
DECLARE @CurExperience INT
	
-- 执行逻辑
BEGIN
	
	SELECT TOP 100 COUNT(UserID) AS Counts,RegisterMachine,
	ISNULL((SELECT EnjoinLogon FROM ConfineMachine WHERE MachineSerial=RegisterMachine),0) AS EnjoinLogon,
	ISNULL((SELECT EnjoinRegister FROM ConfineMachine WHERE MachineSerial=RegisterMachine),0) AS EnjoinRegister,
	(SELECT EnjoinOverDate FROM ConfineMachine WHERE MachineSerial=RegisterMachine) AS EnjoinOverDate
	FROM AccountsInfo WHERE RegisterMachine!='------------'
	GROUP BY RegisterMachine 
	ORDER BY COUNT(UserID) DESC
END
RETURN 0



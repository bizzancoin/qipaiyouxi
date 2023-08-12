----------------------------------------------------------------------
-- 时间：2010-03-16
-- 用途：赠送经验
----------------------------------------------------------------------

USE RYAccountsDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[WSP_PM_GetIPRegisterTop100]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[WSP_PM_GetIPRegisterTop100]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO
----------------------------------------------------------------------
CREATE PROCEDURE WSP_PM_GetIPRegisterTop100

WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 用户经验
DECLARE @CurExperience INT
	
-- 执行逻辑
BEGIN
	
	SELECT TOP 100 COUNT(UserID) AS Counts,RegisterIP,
	ISNULL((SELECT EnjoinLogon FROM ConfineAddress WHERE AddrString=RegisterIP),0) AS EnjoinLogon,
	ISNULL((SELECT EnjoinRegister FROM ConfineAddress WHERE AddrString=RegisterIP),0) AS EnjoinRegister,
	(SELECT EnjoinOverDate FROM ConfineAddress WHERE AddrString=RegisterIP) AS EnjoinOverDate
	FROM AccountsInfo 
	GROUP BY RegisterIP 
	ORDER BY COUNT(UserID) DESC
END
RETURN 0



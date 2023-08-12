
----------------------------------------------------------------------------------------------------

USE RYPlatformDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_LoadPlatformParameter]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_LoadPlatformParameter]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- 加载配置
CREATE PROC GSP_GR_LoadPlatformParameter
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN
	-- 兑换比率
	DECLARE @ExchangeRate AS INT
	DECLARE @PresentExchangeRate AS INT
	DECLARE @RateGold AS INT
	SELECT @ExchangeRate=StatusValue FROM RYAccountsDBLink.RYAccountsDB.dbo.SystemStatusInfo WHERE StatusName=N'MedalExchangeRate'
	SELECT @PresentExchangeRate=StatusValue FROM RYAccountsDBLink.RYAccountsDB.dbo.SystemStatusInfo WHERE StatusName=N'PresentExchangeRate'
	SELECT @RateGold=StatusValue FROM RYAccountsDBLink.RYAccountsDB.dbo.SystemStatusInfo WHERE StatusName=N'RateGold'

	-- 输出结果
	SELECT @ExchangeRate AS ExchangeRate, @PresentExchangeRate AS PresentExchangeRate, @RateGold AS RateGold
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------

USE RYTreasureDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_LoadParameter]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_LoadParameter]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- 加载配置
CREATE PROC GSP_GR_LoadParameter
	@wKindID SMALLINT,							-- 游戏 I D
	@wServerID SMALLINT							-- 房间 I D
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN

	-- 奖牌汇率
	DECLARE @MedalRate AS INT
	SELECT @MedalRate=StatusValue FROM RYAccountsDBLink.RYAccountsDB.dbo.SystemStatusInfo WHERE StatusName=N'MedalRate'

	-- 银行税率
	DECLARE @RevenueRate AS INT
	SELECT @RevenueRate=StatusValue FROM RYAccountsDBLink.RYAccountsDB.dbo.SystemStatusInfo WHERE StatusName=N'RevenueRate'

	-- 兑换比率
	DECLARE @ExchangeRate AS INT
	SELECT @ExchangeRate=StatusValue FROM RYAccountsDBLink.RYAccountsDB.dbo.SystemStatusInfo WHERE StatusName=N'MedalExchangeRate'

	-- 赢局经验
	DECLARE @WinExperience AS INT
	SELECT @WinExperience=WinExperience FROM RYAccountsDBLink.RYPlatformDB.dbo.GameConfig WHERE KindID=@wKindID

	--调整经验
	IF @WinExperience IS NULL
	BEGIN
		SELECT @WinExperience=StatusValue FROM RYAccountsDBLink.RYAccountsDB.dbo.SystemStatusInfo WHERE StatusName=N'WinExperience'	
	END

	-- 参数调整
	IF @MedalRate IS NULL SET @MedalRate=1
	IF @RevenueRate IS NULL SET @RevenueRate=1
	IF @WinExperience IS NULL SET @WinExperience=0

	-- 程序版本
	DECLARE @ClientVersion AS INT
	DECLARE @ServerVersion AS INT
	SELECT @ClientVersion=TableGame.ClientVersion, @ServerVersion=TableGame.ServerVersion
	FROM RYPlatformDBLink.RYPlatformDB.dbo.GameGameItem TableGame,RYPlatformDBLink.RYPlatformDB.dbo.GameKindItem TableKind
	WHERE TableGame.GameID=TableKind.GameID	AND TableKind.KindID=@wKindID

	-- 兑换比率
	DECLARE @PresentExchangeRate AS INT
	SELECT @PresentExchangeRate=StatusValue FROM RYAccountsDBLink.RYAccountsDB.dbo.SystemStatusInfo WHERE StatusName=N'PresentExchangeRate'

	-- 兑换比率
	DECLARE @RateGold AS INT
	SELECT @RateGold=StatusValue FROM RYAccountsDBLink.RYAccountsDB.dbo.SystemStatusInfo WHERE StatusName=N'RateGold'

	-- 参数调整
	IF @PresentExchangeRate IS NULL SET @PresentExchangeRate=0
	IF @RateGold IS NULL SET @RateGold=0

	-- 输出结果
	SELECT @MedalRate AS MedalRate, @RevenueRate AS RevenueRate,@ExchangeRate AS ExchangeRate,@WinExperience AS WinExperience, 
		@ClientVersion AS ClientVersion, @ServerVersion AS ServerVersion, @PresentExchangeRate AS PresentExchangeRate, @RateGold AS RateGold

END

RETURN 0

GO

----------------------------------------------------------------------------------------------------
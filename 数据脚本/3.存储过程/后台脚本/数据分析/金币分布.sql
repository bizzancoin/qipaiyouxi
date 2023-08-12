----------------------------------------------------------------------
-- 版本：2013
-- 时间：2013-04-22
-- 用途：金币分布
----------------------------------------------------------------------
USE [RYTreasureDB]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[NET_PM_AnalGoldDistribution]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[NET_PM_AnalGoldDistribution]
GO

----------------------------------------------------------------------
CREATE PROC [NET_PM_AnalGoldDistribution]

WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 金币区域用户数
DECLARE	@ZeroNumber INT				-- 小于10,000玩家数
DECLARE @OneNumber INT				-- 10,000至100,000之间玩家数
DECLARE @TwoNumber INT				-- 100,000至500,000之间玩家数
DECLARE @ThreeNumber INT			-- 500,000至1,000,000之间玩家数
DECLARE @FourNumber INT				-- 1,000,000至5,000,000之间玩家数
DECLARE @FiveNumber INT				-- 5,000,000至10,000,000之间玩家数
DECLARE @SixNumber INT				-- 10,000,000至30,000,000之间玩家数
DECLARE @SevenNumber INT			-- 大于30,000,000玩家数
DECLARE @UserCount INT				-- 用户总数

-- 系统货币信息
DECLARE @PayAmountTotal BIGINT		-- 充值RMB总数
DECLARE @CurrencyTotal BIGINT		-- 平台币总数
DECLARE @GoldTotal BIGINT			-- 金币总数
DECLARE @RMBRate INT				-- RMB与平台币的兑换比例
DECLARE @CurrencyRate INT			-- 平台币与游戏币的比例

-- 执行逻辑
BEGIN
	-- 金币分布
	SET @ZeroNumber=0
	SET @OneNumber=0
	SET @TwoNumber=0
	SET @ThreeNumber=0
	SET @FourNumber=0
	SET @FiveNumber=0
	SET @SixNumber=0
	SET @SevenNumber=0
	SET @UserCount=0
	
	-- 金币区域分布数
	SELECT @ZeroNumber=Count(*) FROM GameScoreInfo WHERE Score+InsureScore<10000 
	SELECT @OneNumber=Count(*) FROM GameScoreInfo WHERE Score+InsureScore>=10000 AND Score+InsureScore<100000
	SELECT @TwoNumber=Count(*) FROM GameScoreInfo WHERE Score+InsureScore>=100000 AND Score+InsureScore<500000
	SELECT @ThreeNumber=Count(*) FROM GameScoreInfo WHERE Score+InsureScore>=500000 AND Score+InsureScore<1000000
	SELECT @FourNumber=Count(*) FROM GameScoreInfo WHERE Score+InsureScore>=1000000 AND Score+InsureScore<5000000
	SELECT @FiveNumber=Count(*) FROM GameScoreInfo WHERE Score+InsureScore>=5000000 AND Score+InsureScore<10000000
	SELECT @SixNumber=Count(*) FROM GameScoreInfo WHERE Score+InsureScore>=10000000 AND Score+InsureScore<30000000
	SELECT @SevenNumber=Count(*) FROM GameScoreInfo WHERE Score+InsureScore>=30000000
	
	-- 充值RMB总数
	SELECT @PayAmountTotal=SUM(PayAmount) FROM RYTreasureDBLink.RYTreasureDB.dbo.ShareDetailInfo
	
	-- 金币总数
	SELECT @GoldTotal=SUM(Score+InsureScore) FROM GameScoreInfo 
	WHERE UserID NOT IN(SELECT UserID FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo WHERE IsAndroid=1)
	
	-- 平台币总数
	SELECT @CurrencyTotal=ISNULL(SUM(Currency),0) FROM RYTreasureDBLink.RYTreasureDB.dbo.UserCurrencyInfo 
	WHERE UserID NOT IN(SELECT UserID FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo WHERE IsAndroid=1)
	 	
	-- 用户总数
	SET @UserCount=@ZeroNumber+@OneNumber+@TwoNumber+@ThreeNumber+@FourNumber+@FiveNumber+@SixNumber+@SevenNumber
	
	-- 返回分布
	SELECT @ZeroNumber AS ZeroNumber,@OneNumber AS OneNumber,@TwoNumber AS TwoNumber,@ThreeNumber AS ThreeNumber,
		@FourNumber AS FourNumber,@FiveNumber AS FiveNumber,@SixNumber AS SixNumber,@SevenNumber AS SevenNumber,@UserCount AS UserCount
		
	-- 赋默认值
	IF @PayAmountTotal IS NULL
		SET @PayAmountTotal=0
	IF @GoldTotal IS NULL
		SET @GoldTotal=0
	IF @CurrencyTotal IS NULL
		SET @CurrencyTotal=0
	
	-- 兑换比例
	--SELECT @RMBRate=Field1,@CurrencyRate=Field3 FROM UCPlatformDBLink.UCPlatformDB.dbo.SystemConfigInfo WHERE ConfigKey='PayConfig'
	SELECT @RMBRate=StatusValue FROM RYAccountsDB.dbo.SystemStatusInfo WHERE StatusName='RateCurrency'
	SELECT @CurrencyRate=StatusValue FROM RYAccountsDB.dbo.SystemStatusInfo WHERE StatusName='RateGold'
	-- 返回参数
	SELECT @PayAmountTotal AS PayAmountTotal,@CurrencyTotal AS CurrencyTotal,@GoldTotal AS GoldTotal,@RMBRate AS RMBRate,@CurrencyRate AS CurrencyRate

END
GO


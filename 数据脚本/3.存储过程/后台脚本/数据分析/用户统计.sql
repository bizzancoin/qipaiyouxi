----------------------------------------------------------------------
-- 时间：2012-10-23
-- 用途：充值统计
----------------------------------------------------------------------
USE [RYAccountsDB]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[NET_PM_AnalUserStat]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[NET_PM_AnalUserStat]
GO

----------------------------------------------------------------------
CREATE PROC [NET_PM_AnalUserStat]
			
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON
DECLARE @UserTotal INT						-- 总用户数
DECLARE @CurrentMonthRegUserCounts INT		-- 当月注册用户数
DECLARE @MaxUserRegCounts INT				-- 日注册最高值
DECLARE @OnlineUserAVGCounts INT			-- 平均在线人数,暂未实现
DECLARE @OnlineUserMaxCounts INT			-- 最高在线人数，暂未实现
DECLARE @UserAVGOnlineTime INT				-- 用户平均在线时长
DECLARE @ActiveUserCounts INT				-- 活跃用户数
DECLARE @LossUserCounts INT					-- 流失用户数

DECLARE @PayMaxAmount INT					-- 最高充值金额
DECLARE @CurrentDateMaxAmount INT			-- 今日最高充值金额 
DECLARE @PayUserCounts INT					-- 充值总人数
DECLARE @PayTotalAmount BIGINT				-- 总充值额度
DECLARE @PayTwoUserCounts INT				-- 二次充值人数
DECLARE @PayCurrencyAmount BIGINT			-- 充值货币总金额
DECLARE @MaxShareID INT						-- 充值最多渠道
DECLARE @PayUserOutflowTotal INT			-- 充值用户流失数
DECLARE @VIPPayUserTotal INT				-- 充值金额大于2000RMN玩家数
DECLARE @CurrencyTotal BIGINT				-- 平台币总数
DECLARE @GoldTotal BIGINT					-- 金币总数
DECLARE @GameTax DECIMAL					-- 游戏税收
DECLARE @RMBRate INT						-- RMB与平台币的兑换比例
DECLARE @CurrencyRate INT					-- 平台币与游戏币的比例

DECLARE @CurrentTime DATETIME				-- 当前时间

-- 执行逻辑
BEGIN
	SET @CurrentTime=GETDATE()
	
	-- 总用户数
	SELECT @UserTotal=COUNT(UserID) FROM AccountsInfo WHERE IsAndroid=0
	
	-- 当月注册用户数
	SELECT @CurrentMonthRegUserCounts=Sum(WebRegisterSuccess+GameRegisterSuccess) FROM SystemStreamInfo 
	WHERE CONVERT(char(7),CollectDate,120)=CONVERT(char(7),@CurrentTime,120)
	
	-- 日注册最高值
	SELECT @MaxUserRegCounts=MAX(WebRegisterSuccess+GameRegisterSuccess) FROM SystemStreamInfo	
	
	-- 平均在线时长
	SELECT @UserAVGOnlineTime=AVG(CONVERT(BIGINT,OnLineTimeCount)) FROM AccountsInfo WHERE IsAndroid=0
	
	-- 活跃用户数
	SELECT @ActiveUserCounts=COUNT(UserID) FROM RYTreasureDBLink.RYTreasureDB.dbo.StreamScoreInfo 
	WHERE DateID= CAST(CAST(@CurrentTime AS FLOAT) AS INT) AND OnlineTimeCount>=60*60 
	AND UserID NOT IN(SELECT UserID FROM AccountsInfo WHERE IsAndroid=1)
	
	-- 流失用户数
	SELECT @LossUserCounts=Count(UserID) FROM AccountsInfo 
	WHERE LastLogonDate<DATEADD(mm,-1,Convert(varchar(10),@CurrentTime,120)) AND IsAndroid=0
	
	-- 最大、总充值金额
	SELECT @PayMaxAmount=MAX(PayAmount),@PayTotalAmount=SUM(PayAmount) FROM RYTreasureDBLink.RYTreasureDB.dbo.ShareDetailInfo
	
	-- 充值货币的充值金额
	SELECT @PayCurrencyAmount=MAX(PayAmount),@PayTotalAmount=SUM(PayAmount) FROM RYTreasureDBLink.RYTreasureDB.dbo.ShareDetailInfo
	
	-- 今日充值最高额度
	SELECT @CurrentDateMaxAmount=ISNULL(0,Max(PayAmount)) FROM RYTreasureDBLink.RYTreasureDB.dbo.ShareDetailInfo 
	WHERE ApplyDate>=CONVERT(VARCHAR(10),@CurrentTime,120) AND ApplyDate<DATEADD(dd,1,Convert(varchar(10),@CurrentTime,120))
	
	-- 充值总人数
	SELECT @PayUserCounts=COUNT(UserID) FROM (SELECT UserID FROM RYTreasureDBLink.RYTreasureDB.dbo.ShareDetailInfo GROUP BY UserID) AS A
	
	-- 二次充值玩家
	SELECT @PayTwoUserCounts=COUNT(Total) FROM (SELECT COUNT(UserID) AS Total 
	FROM RYTreasureDBLink.RYTreasureDB.dbo.ShareDetailInfo GROUP BY UserID) AS A WHERE Total>1
	
	-- 充值最多渠道
	--SELECT TOP 1 @MaxShareID=ShareID FROM THTreasureDBLink.THTreasureDB.dbo.ShareCollectInfo 
	--GROUP BY ShareID ORDER BY Sum(StatSellCash) DESC
	
	-- 充值用户流失数
	SELECT @PayUserOutflowTotal=Count(UserID) FROM AccountsInfo 
	WHERE UserID IN(SELECT USERID FROM RYTreasureDBLink.RYTreasureDB.dbo.ShareDetailInfo) 
	AND LastLogonDate<DATEADD(mm,-1,Convert(varchar(10),GetDate(),120)) AND IsAndroid=0
	
	-- 充值大户
	SELECT @VIPPayUserTotal=COUNT(UserID) 
	FROM (SELECT UserID FROM RYTreasureDBLink.RYTreasureDB.dbo.ShareDetailInfo GROUP BY UserID HAVING SUM(PayAmount)>=2000  ) AS A
	
	-- 金币总数
	SELECT @GoldTotal=SUM(Score+InsureScore) 
	FROM RYTreasureDBLink.RYTreasureDB.dbo.GameScoreInfo 
	WHERE UserID NOT IN (SELECT UserID FROM AccountsInfo WHERE IsAndroid=1)
	
	-- 平台币总数
	SELECT @CurrencyTotal=SUM(Currency) FROM RYTreasureDBLink.RYTreasureDB.dbo.UserCurrencyInfo

	-- 兑换比例
	SELECT @RMBRate=StatusValue FROM SystemStatusInfo WHERE StatusName='RateCurrency'
	SELECT @CurrencyRate=StatusValue FROM SystemStatusInfo WHERE StatusName='RateGold'
	
	-- 税收
	SELECT @GameTax=SUM(Revenue) FROM RYTreasureDBLink.RYTreasureDB.dbo.StreamScoreInfo
	
	-- 赋默认值
	IF @MaxUserRegCounts IS NULL
		SET @MaxUserRegCounts=0
	IF @UserAVGOnlineTime IS NULL 
		SET @UserAVGOnlineTime=0
	IF @PayMaxAmount IS NULL
		SET @PayMaxAmount=0
	IF @PayTotalAmount IS NULL
		SET @PayTotalAmount=0
	IF @PayCurrencyAmount IS NULL
		SET @PayCurrencyAmount=0
	IF @CurrentDateMaxAmount IS NULL 
		SET @CurrentDateMaxAmount=0
	IF @GoldTotal IS NULL
		SET @GoldTotal=0
	IF @CurrencyTotal IS NULL
		SET @CurrencyTotal=0
	IF @RMBRate IS NULL
		SET @RMBRate=0
	IF @CurrencyRate IS NULL
		SET @CurrencyRate=0
	IF @GameTax IS NULL
		SET @GameTax=0
	IF @MaxShareID IS NULL
		SET @MaxShareID=0
	IF @CurrentMonthRegUserCounts IS NULL
		SET @CurrentMonthRegUserCounts=0

	-- 返回数据
	SELECT @UserTotal AS UserTotal,@CurrentMonthRegUserCounts AS CurrentMonthRegUserCounts,@MaxUserRegCounts AS MaxUserRegCounts,
		@UserAVGOnlineTime AS UserAVGOnlineTime,@ActiveUserCounts AS ActiveUserCounts,@LossUserCounts AS LossUserCounts,
		@PayMaxAmount AS PayMaxAmount,@CurrentDateMaxAmount AS CurrentDateMaxAmount,@PayUserCounts AS PayUserCounts,
		@PayTotalAmount AS PayTotalAmount,@PayCurrencyAmount AS PayCurrencyAmount,@CurrentDateMaxAmount AS CurrentDateMaxAmount,
		@CurrentDateMaxAmount AS CurrentDateMaxAmount,@PayUserCounts AS PayUserCounts,@PayTwoUserCounts AS PayTwoUserCounts,
		@PayTwoUserCounts AS PayTwoUserCounts,@MaxShareID AS MaxShareID,@PayUserOutflowTotal AS PayUserOutflowTotal,
		@VIPPayUserTotal AS VIPPayUserTotal,@GoldTotal AS GoldTotal,@CurrencyTotal AS CurrencyTotal,@RMBRate AS RMBRate,
		@CurrencyRate AS CurrencyRate,@GameTax AS GameTax
END
GO
----------------------------------------------------------------------
-- 时间：2011-10-20
-- 用途：数据汇总统计。
----------------------------------------------------------------------
USE RYTreasureDB
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].NET_PM_StatInfo') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].NET_PM_StatInfo
GO

----------------------------------------------------------------------
CREATE PROC NET_PM_StatInfo
			
WITH ENCRYPTION AS

BEGIN
	-- 属性设置
	SET NOCOUNT ON;	
	--用户统计
	DECLARE @OnLineCount BIGINT		--在线人数
	DECLARE @DisenableCount BIGINT		--停权用户
	DECLARE @AllCount BIGINT			--注册总人数
	SELECT  TOP 1 @OnLineCount=ISNULL(OnLineCountSum,0) FROM RYPlatformDBLink.RYPlatformDB.dbo.OnLineStreamInfo ORDER BY InsertDateTime DESC
	SELECT  @DisenableCount=COUNT(UserID) FROM RYAccountsDB.dbo.AccountsInfo(NOLOCK) WHERE Nullity = 1
	SELECT  @AllCount=COUNT(UserID) FROM RYAccountsDB.dbo.AccountsInfo(NOLOCK)

	--金币统计
	DECLARE @Score BIGINT		--身上金币总量
	DECLARE @InsureScore BIGINT	--银行总量
	DECLARE @AllScore BIGINT
	SELECT  @Score=ISNULL(SUM(Score),0),@InsureScore=ISNULL(SUM(InsureScore),0),@AllScore=ISNULL(SUM(Score+InsureScore),0) 
	FROM GameScoreInfo(NOLOCK)
	
	--赠送统计
	DECLARE @RegPresent BIGINT				--注册赠送(1)
	DECLARE @AgentRegPresent BIGINT			--代理注册赠送(13)
	DECLARE @DBPresent BIGINT				--低保赠送(2)
	DECLARE @QDPresent BIGINT				--签到赠送(3)
	DECLARE @YBPresent BIGINT				--元宝兑换(4)
	DECLARE @MLPresent BIGINT				--魅力兑换(5)
	DECLARE @OnlinePresent BIGINT			--在线时长赠送(6)
	DECLARE @RWPresent BIGINT				--任务奖励(7)
	DECLARE @SMPresent BIGINT				--实名验证(8)
	DECLARE @DayPresent BIGINT				--会员每日送金(9)
	DECLARE @MatchPresent BIGINT			--比赛奖励(10)
	DECLARE @DJPresent BIGINT				--等级升级(11)
	DECLARE @SharePresent BIGINT			--分享赠送(12)
	DECLARE @LotteryPresent BIGINT			--转盘赠送(14)
	DECLARE @WebPresent BIGINT				--后台赠送
	SELECT @RegPresent=ISNULL(SUM(CONVERT(BIGINT,[PresentScore])),0) FROM [dbo].[StreamPresentInfo](NOLOCK) WHERE [TypeID]=1
	SELECT @AgentRegPresent=ISNULL(SUM([PresentScore]),0) FROM [dbo].[StreamPresentInfo](NOLOCK) WHERE [TypeID]=13
	SELECT @DBPresent=ISNULL(SUM([PresentScore]),0) FROM [dbo].[StreamPresentInfo](NOLOCK) WHERE [TypeID]=2
	SELECT @QDPresent=ISNULL(SUM([PresentScore]),0) FROM [dbo].[StreamPresentInfo](NOLOCK) WHERE [TypeID]=3
	SELECT @YBPresent=ISNULL(SUM([PresentScore]),0) FROM [dbo].[StreamPresentInfo](NOLOCK) WHERE [TypeID]=4
	SELECT @MLPresent=ISNULL(SUM([PresentScore]),0) FROM [dbo].[StreamPresentInfo](NOLOCK) WHERE [TypeID]=5
	SELECT @OnlinePresent=ISNULL(SUM([PresentScore]),0) FROM [dbo].[StreamPresentInfo](NOLOCK) WHERE [TypeID]=6
	SELECT @RWPresent=ISNULL(SUM([PresentScore]),0) FROM [dbo].[StreamPresentInfo](NOLOCK) WHERE [TypeID]=7
	SELECT @SMPresent=ISNULL(SUM([PresentScore]),0) FROM [dbo].[StreamPresentInfo](NOLOCK) WHERE [TypeID]=8
	SELECT @DayPresent=ISNULL(SUM([PresentScore]),0) FROM [dbo].[StreamPresentInfo](NOLOCK) WHERE [TypeID]=9
	SELECT @MatchPresent=ISNULL(SUM([PresentScore]),0) FROM [dbo].[StreamPresentInfo](NOLOCK) WHERE [TypeID]=10
	SELECT @DJPresent=ISNULL(SUM([PresentScore]),0) FROM [dbo].[StreamPresentInfo](NOLOCK) WHERE [TypeID]=11
	SELECT @SharePresent=ISNULL(SUM([PresentScore]),0) FROM [dbo].[StreamPresentInfo](NOLOCK) WHERE [TypeID]=12
	SELECT @LotteryPresent=ISNULL(SUM([PresentScore]),0) FROM [dbo].[StreamPresentInfo](NOLOCK) WHERE [TypeID]=14
	SELECT @WebPresent=ISNULL(SUM(CONVERT(BIGINT,AddGold)),0) FROM RYRecordDBLink.RYRecordDB.dbo.RecordGrantTreasure
	
	--魅力统计
	DECLARE @LoveLiness BIGINT		--魅力总量
	DECLARE @Present BIGINT			--已兑换魅力总量
	DECLARE @ConvertPresent BIGINT	--已兑换金币量
	SELECT @LoveLiness=SUM(CONVERT(BIGINT,LoveLiness)),@Present=SUM(CONVERT(BIGINT,Present)) FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo
	SELECT @ConvertPresent=SUM(CONVERT(BIGINT,ConvertPresent)*ConvertRate) FROM RYRecordDBLink.RYRecordDB.dbo.RecordConvertPresent

	--税收统计
	DECLARE @Revenue BIGINT			--税收总量
	DECLARE @TransferRevenue BIGINT	--转账税收
	SELECT @Revenue=ISNULL(SUM(Revenue),0) FROM GameScoreInfo(NOLOCK)
	SELECT @TransferRevenue=ISNULL(SUM(Revenue),0) FROM RecordInsure(NOLOCK)

	--损耗统计
	DECLARE @Waste BIGINT   --损耗总量
	SELECT @Waste=ISNULL(SUM(Waste),0) FROM RYRecordDBLink.RYRecordDB.dbo.RecordEveryDayData

	--点卡统计
	DECLARE @CardCount BIGINT			--生成张数
	DECLARE @CardGold BIGINT		--金币总量
	DECLARE @CardPrice DECIMAL(18,2)--面额总量
	SELECT  @CardCount=COUNT(CardID),@CardGold=ISNULL(SUM(Currency),0),@CardPrice=SUM(CardPrice) FROM LivcardAssociator(NOLOCK)

	DECLARE @CardPayCount BIGINT 		--充值张数
	DECLARE @CardPayGold BIGINT		--充值金币
	DECLARE @CardPayPrice DECIMAL(18,2)--充值人民币总数
	SELECT @CardPayCount=COUNT(CardID),@CardPayGold=ISNULL(SUM(Currency),0),@CardPayPrice=SUM(CardPrice) FROM LivcardAssociator(NOLOCK) WHERE ApplyDate IS NOT NULL 

	DECLARE @MemberCardCount BIGINT	--实卡张数
	SELECT @MemberCardCount=COUNT(CardID) FROM LivcardAssociator(NOLOCK)

	--返回
	SELECT  @OnLineCount AS	OnLineCount,				--在线人数
			@DisenableCount AS DisenableCount,			--停权用户
			@AllCount AS AllCount,						--注册总人数
			@Score AS Score,							--身上金币总量
			@InsureScore AS InsureScore,				--银行总量
			@AllScore AS AllScore,						--金币总数
			
			@RegPresent AS RegPresent,					--注册赠送
			@AgentRegPresent AS AgentRegPresent,		--代理注册赠送
			@DBPresent AS DBPresent,					--低保赠送
			@QDPresent AS QDPresent,					--签到赠送
			@YBPresent AS YBPresent,					--元宝兑换
			@MLPresent AS MLPresent,					--魅力兑换
			@OnlinePresent AS OnlinePresent,			--在线时长赠送
			@RWPresent AS RWPresent,					--任务奖励
			@SMPresent AS SMPresent,					--实名验证
			@DayPresent AS DayPresent,					--会员每日送金
			@MatchPresent AS MatchPresent,				--比赛奖励
			@DJPresent AS DJPresent,					--等级升级
			@SharePresent AS SharePresent,				--分享赠送
			@LotteryPresent AS LotteryPresent,			--转盘赠送
			@WebPresent AS WebPresent,					--后台赠送

			@LoveLiness AS LoveLiness,					--魅力总量
			@Present AS Present,						--已兑换魅力总量
			(@LoveLiness-@Present) AS RemainLove,		--未兑换魅力总量
			@ConvertPresent AS ConvertPresent,			--已兑换金币量
			@Revenue AS Revenue,						--税收总量
			@TransferRevenue AS TransferRevenue,		--转账税收	
			@Waste AS Waste,							--损耗总量
	
			@CardCount AS CardCount,					--生成张数
			@CardGold AS CardGold,						--金币总量
			@CardPrice AS CardPrice,					--面额总量
			@CardPayCount AS CardPayCount, 				--充值张数
			@CardPayGold AS CardPayGold,				--充值金币
			@CardPayPrice AS CardPayPrice,				--充值人民币总数
			@MemberCardCount AS MemberCardCount			--会员卡张数
END
































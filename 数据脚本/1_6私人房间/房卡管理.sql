
----------------------------------------------------------------------------------------------------

USE RYTreasureDB
GO



IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_ExchangeRoomCardByScore]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_ExchangeRoomCardByScore]
GO




----------------------------------------------------------------------------------------------------

-- 兑换游戏币
CREATE PROC GSP_GR_ExchangeRoomCardByScore

	-- 用户信息
	@dwUserID INT,								-- 用户标识
	@ExchangeRoomCard INT,						-- 兑换房卡	

	-- 系统信息	
	@strClientIP NVARCHAR(15),					-- 连接地址
	@strMachineID NVARCHAR(32),					-- 机器标识
	@strNotifyContent NVARCHAR(127) OUTPUT		-- 输出信息

WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN

	-- 查询会员
	DECLARE @Nullity BIT
	DECLARE @UserRoomCard INT	
	SELECT @Nullity=Nullity FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo WHERE UserID=@dwUserID
	SELECT @UserRoomCard=RoomCard FROM UserRoomCard WHERE UserID=@dwUserID

	-- 用户判断
	IF @UserRoomCard IS NULL
	BEGIN
		SET @strNotifyContent=N'您没有房卡请购买！'
		RETURN 1
	END	

	-- 帐号禁止
	IF @Nullity<>0
	BEGIN
		SET @strNotifyContent=N'您的帐号暂时处于冻结状态，请联系客户服务中心了解详细情况！'
		RETURN 2
	END

	-- 元宝判断
	IF @UserRoomCard < @ExchangeRoomCard
	BEGIN
		SET @strNotifyContent=N'您的房卡不足，请调整好兑换房卡后再试！'
		RETURN 3		
	END

	-- 兑换比率
	DECLARE @ExchangeRate INT
	--SELECT @ExchangeRate=StatusValue FROM RYAccountsDBLink.RYAccountsDB.dbo.SystemStatusInfo WHERE StatusName=N'GeneralRoomCardExchRate'
	SELECT @ExchangeRate=UseResultsGold FROM RYPlatformDBLink.RYPlatformDB.dbo.GameProperty WHERE ID=501

	-- 系统错误
	IF @ExchangeRate IS NULL
	BEGIN
		SET @strNotifyContent=N'抱歉！房卡兑换失败，请联系客户服务中心了解详细情况。'
		RETURN 4			
	END

	-- 计算游戏币
	DECLARE @ExchangeScore BIGINT
	SET @ExchangeScore = @ExchangeRate*@ExchangeRoomCard

	-- 查询银行
	DECLARE @InsureScore BIGINT
	SELECT @InsureScore=InsureScore FROM GameScoreInfo WHERE UserID=@dwUserID

	-- 插入资料
	IF @InsureScore IS NULL
	BEGIN
		-- 设置变量
		SET @InsureScore=0

		-- 插入资料
		INSERT INTO GameScoreInfo (UserID, LastLogonIP, LastLogonMachine, RegisterIP, RegisterMachine)
		VALUES (@dwUserID, @strClientIP, @strMachineID, @strClientIP, @strMachineID)		
	END	

	-- 更新银行
	UPDATE GameScoreInfo SET InsureScore=InsureScore+@ExchangeScore WHERE UserID=@dwUserID	
	
	-- 更新元宝
	SET @UserRoomCard=@UserRoomCard-@ExchangeRoomCard
	UPDATE UserRoomCard SET RoomCard=@UserRoomCard WHERE UserID=@dwUserID			

	-- 查询游戏币
	DECLARE @CurrScore BIGINT
	SELECT @CurrScore=Score FROM GameScoreInfo WHERE UserID=@dwUserID

	-- 查询游戏豆
	DECLARE @CurrRoomCard decimal(18, 2)
	SELECT @CurrRoomCard=RoomCard FROM UserRoomCard WHERE UserID=@dwUserID	

	-- 调整游戏豆
	IF @CurrRoomCard IS NULL SET @CurrRoomCard=0


	--获取金币和游戏豆
	DECLARE @lGold  BIGINT
	DECLARE @Currency  DECIMAL
	SELECT  @lGold = Score FROM GameScoreInfo WHERE UserID = @dwUserID
	SELECT  @Currency = Currency FROM UserCurrencyInfo WHERE UserID = @dwUserID
	IF @Currency IS NULL SET @Currency=0

	INSERT INTO RYRecordDB..RecordRoomCard(SourceUserID, SBeforeCard, RoomCard, TargetUserID, TBeforeCard, TypeID, Currency, Gold, Remarks, ClientIP, CollectDate)
	VALUES (@dwUserID, @UserRoomCard, @ExchangeRoomCard, 0, 0, 2, @Currency, @lGold, '兑换房卡', @strClientIP, GETDATE())
		

	-- 成功提示
	SET @strNotifyContent=N'恭喜您，游戏币兑换成功！'

	-- 输出记录
	SELECT @CurrRoomCard AS RoomCard,@CurrScore AS CurrScore

END

RETURN 0

GO

----------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------

USE RYTreasureDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[NET_PW_LotteryUserInfo]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[NET_PW_LotteryUserInfo]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[NET_PW_LotteryStart]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[NET_PW_LotteryStart]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------
-- 加载奖励
CREATE PROC NET_PW_LotteryUserInfo
	@dwUserID INT,								-- 用户标识
	@strLogonPass NCHAR(32),					-- 用户密码
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

DECLARE @nAlreadyCount INT
DECLARE @nFreeCount INT
DECLARE @nChargeFee INT
DECLARE @nIsCharge TINYINT

-- 执行逻辑
BEGIN

	DECLARE @strPassword NCHAR(32)
	SELECT @strPassword=LogonPass FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo WHERE UserID=@dwUserID
	IF @strPassword IS NULL
	BEGIN
		SET @strErrorDescribe=N'抱歉，您的个人信息出现异常，抽奖配置查询失败！'
		RETURN 1
	END

	IF @strPassword<>@strLogonPass
	BEGIN
		SET @strErrorDescribe=N'抱歉，您的登录密码不正确，抽奖配置查询失败！'
		RETURN 2
	END

	DECLARE @DateID INT
	SET @DateID=CAST(CAST(GETDATE() AS FLOAT) AS INT)

	-- 今日已领免费次数
	SELECT @nAlreadyCount=COUNT(*) FROM RYRecordDBLink.RYRecordDB.dbo.RecordLottery 
	WHERE UserID=@dwUserID AND ChargeFee=0 AND DATEDIFF(DAY,CollectDate,GETDATE())=0

	SELECT @nFreeCount=FreeCount,@nChargeFee=ChargeFee,@nIsCharge=IsCharge FROM LotteryConfig WHERE ID=1
	IF @nFreeCount IS NULL
	BEGIN
		SET @nFreeCount=3
		SET @nChargeFee=600
		SET @nIsCharge=0
	END

	SELECT @nFreeCount AS FreeCount, @nChargeFee AS ChargeFee, @nAlreadyCount AS AlreadyCount,@nIsCharge AS IsCharge

END

RETURN 0

GO

----------------------------------------------------------------------------------------------------
-- 抽奖开始
CREATE PROC NET_PW_LotteryStart
	@dwUserID INT,								-- 用户标识
	@strLogonPass NCHAR(32),					-- 用户密码
	@strClientIP NVARCHAR(15),					-- 连接地址	
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

DECLARE @nWined INT
DECLARE @nWinItemIndex INT
DECLARE @nWinItemType INT
DECLARE @nWinItemQuota INT
DECLARE @Score INT
DECLARE @Currency DECIMAL(18,2)
DECLARE @UserMedal INT

-- 执行逻辑
BEGIN

	DECLARE @strPassword NCHAR(32)
	SELECT @strPassword=LogonPass FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo WHERE UserID=@dwUserID
	IF @strPassword IS NULL
	BEGIN
		SET @strErrorDescribe=N'抱歉，您的个人信息出现异常，抽奖失败！'
		RETURN 1
	END

	IF @strPassword<>@strLogonPass
	BEGIN
		SET @strErrorDescribe=N'抱歉，您的登录密码不正确，抽奖失败！'
		RETURN 2
	END

	--变量定义
	DECLARE @nAlreadyCount INT
	DECLARE @nUserChargeFee INT
	DECLARE @nFreeCount INT
	DECLARE @nChargeFee INT
	DECLARE @IsCharge TINYINT
	DECLARE @nItemCount INT	

	-- 今日已领免费次数
	SELECT @nAlreadyCount=COUNT(*) FROM RYRecordDBLink.RYRecordDB.dbo.RecordLottery 
	WHERE UserID=@dwUserID AND ChargeFee=0 AND DATEDIFF(DAY,CollectDate,GETDATE())=0

	-- 总共免费次数
	SELECT @nFreeCount=FreeCount,@nChargeFee=ChargeFee,@IsCharge=IsCharge FROM LotteryConfig WHERE ID=1
	IF @nFreeCount IS NULL
	BEGIN
		SET @nFreeCount=3
		SET @nChargeFee=600
		SET @IsCharge=0
	END

	IF @IsCharge=0 -- 不允许付费抽奖
	BEGIN
		IF @nAlreadyCount>=@nFreeCount
		BEGIN
			SET @strErrorDescribe=N'抱歉，您今日的免费次数已经用完，不能继续参与抽奖！'
			RETURN 3
		END
		ELSE
		BEGIN
			SET @nUserChargeFee=0
		END
	END
	ELSE -- 允许付费抽奖
	BEGIN		
		IF @nAlreadyCount>=@nFreeCount SET @nUserChargeFee=@nChargeFee
		ELSE SET @nUserChargeFee=0
	END

	-- 游戏币
	SELECT @Score=Score FROM GameScoreInfo WHERE UserID=@dwUserID
	IF @Score IS NULL SET @Score=0
	IF @nUserChargeFee>@Score
	BEGIN
		SET @strErrorDescribe=N'抱歉，您的游戏币不够，不能参与抽奖，请充值后再次尝试！'
		RETURN 3
	END

	-- 奖项总数
	SELECT @nItemCount=Count(*) FROM LotteryItem

	----------------------------------------------------------------------------------------------------
	-- 全局变量初始化
	SET @nWined=0
	SET @nWinItemIndex=0
	SET @nWinItemType=0
	SET @nWinItemQuota=0

	-- 临时变量
	DECLARE @nItemIndex INT
	DECLARE @nItemType INT
	DECLARE @nItemQuota INT
	DECLARE @nItemRate INT
	DECLARE @nTotalRate INT
	DECLARE @nRandData INT
	
	-- 临时变量初始化
	SET @nItemIndex=0
	SET @nItemType=0
	SET @nItemQuota=0
	SET @nItemRate=0
	SET @nTotalRate=0
	SET @nRandData=CAST(FLOOR(RAND()*100) AS INT)

	IF @nItemCount>0
	BEGIN
		-- 临时变量
		DECLARE @nIndex INT
		SET @nIndex=1

		-- 循环判断中奖率
		WHILE @nIndex<=@nItemCount
		BEGIN
			SELECT @nItemIndex=ItemIndex, @nItemType=ItemType, @nItemQuota=ItemQuota, @nItemRate=ItemRate FROM LotteryItem WHERE ItemIndex=@nIndex
				
			IF @nItemType IS NULL BREAK

			IF @nRandData>=@nTotalRate AND @nRandData<@nTotalRate+@nItemRate
			BEGIN
				SET @nWinItemIndex=@nItemIndex
				SET @nWinItemType=@nItemType
				SET @nWinItemQuota=@nItemQuota
				BREAK		
			END
			ELSE
			BEGIN
				SET @nTotalRate=@nTotalRate+@nItemRate
				SET @nIndex=@nIndex+1
			END
		END
	END
	----------------------------------------------------------------------------------------------------

	-- 玩家中奖
	IF @nWinItemIndex>0
	BEGIN
		SET @nWined=1

		-- 扣除抽奖费用
		IF @nUserChargeFee>0
		BEGIN
			SET @Score=@Score-@nUserChargeFee;
		END

		-- 奖励到帐
		IF @nWinItemQuota>0
		BEGIN
			-- 刷新游戏币
			IF @nWinItemType=0
			BEGIN
				UPDATE GameScoreInfo SET Score=@Score+@nWinItemQuota WHERE UserID=@dwUserID
				IF @@ROWCOUNT=0
				BEGIN
					INSERT INTO GameScoreInfo(UserID,Score,LastLogonIP,RegisterIP)
					VALUES(@dwUserID,@nWinItemQuota,@strClientIP,@strClientIP)
				END
			END
			
			-- 刷新游戏豆
			IF @nWinItemType=1
			BEGIN
				UPDATE UserCurrencyInfo SET Currency=Currency+@nWinItemQuota WHERE UserID=@dwUserID
				IF @@ROWCOUNT=0
				BEGIN
					INSERT INTO UserCurrencyInfo(UserID,Currency)
					VALUES (@dwUserID,@nWinItemQuota)
				END
			END

			-- 刷新元宝
			IF @nWinItemType=2
			BEGIN
				UPDATE RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo SET UserMedal = UserMedal + @nWinItemQuota WHERE UserID=@dwUserID
			END
		END

		-- 抽奖记录
		INSERT INTO RYRecordDBLink.RYRecordDB.dbo.RecordLottery(UserID,ChargeFee,ItemIndex,ItemType,ItemQuota)
		VALUES (@dwUserID,@nUserChargeFee,@nWinItemIndex,@nWinItemType,@nWinItemQuota)
	END

	-- 刷新财富
	SELECT @Score=Score FROM GameScoreInfo WHERE UserID=@dwUserID
	SELECT @Currency=Currency FROM UserCurrencyInfo WHERE UserID=@dwUserID
	SELECT @UserMedal=UserMedal FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo WHERE UserID=@dwUserID

	-- 查询奖励
	SELECT @nWined AS Wined, @nWinItemIndex AS ItemIndex, @nWinItemType AS ItemType, @nWinItemQuota AS ItemQuota, 
			@Score AS Score, @Currency AS Currency, @UserMedal AS UserMedal

END

RETURN 0

GO

----------------------------------------------------------------------------------------------------
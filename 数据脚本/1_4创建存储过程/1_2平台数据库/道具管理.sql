
----------------------------------------------------------------------------------------------------

USE RYPlatformDB
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_LoadGamePropertyTypeItem]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_LoadGamePropertyTypeItem]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_LoadGamePropertyRelatItem]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_LoadGamePropertyRelatItem]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_LoadGamePropertyItem]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_LoadGamePropertyItem]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_LoadGamePropertySubItem]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_LoadGamePropertySubItem]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_BuyProperty]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_BuyProperty]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_LoadUserGameBuff]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_LoadUserGameBuff]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_LoadUserGameTrumpet]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_LoadUserGameTrumpet]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_QuerySendPresent]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_QuerySendPresent]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_UserSendPresentByID]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_UserSendPresentByID]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_UserSendPresentByNickName]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_UserSendPresentByNickName]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_GetSendPresent]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_GetSendPresent]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_PropertQuerySingle]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_PropertQuerySingle]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- 加载类型
CREATE PROC GSP_GP_LoadGamePropertyTypeItem
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN

	SELECT * FROM GamePropertyType(NOLOCK) WHERE Nullity=0 AND TagID = 0
	
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

-- 加载关系
CREATE PROC GSP_GP_LoadGamePropertyRelatItem
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN

	SELECT * FROM GamePropertyRelat(NOLOCK) WHERE  TagID = 0
	
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

-- 加载道具
CREATE PROC GSP_GP_LoadGamePropertyItem
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN
	-- 加载道具
	SELECT * FROM GameProperty(NOLOCK) WHERE Nullity=0 AND Kind <> 11
	
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

-- 加载道具
CREATE PROC GSP_GP_LoadGamePropertySubItem
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN
	-- 加载道具
	SELECT * FROM GamePropertySub(NOLOCK) 
	
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO


-- 消费道具
CREATE PROC GSP_GP_BuyProperty
	@dwUserID INT,								-- 用户标识
	@dwPropertyID INT,							-- 道具标识
	@dwItemCount INT,							-- 道具数目
	@cbConsumeType SMALLINT,					-- 消费类型
	@strPassword NCHAR(32),						-- 用户密码
	@strClientIP NVARCHAR(15),					-- 连接地址
	@strMachineID NVARCHAR(32),					-- 机器标识
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息

WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN

	-- 变量定义
	DECLARE @GoldPrice AS BIGINT
	DECLARE @CashPrice AS DECIMAL(18,2)
	DECLARE @UserMedalPrice AS BIGINT
	DECLARE @LoveLinessPrice AS BIGINT
	DECLARE @Discount AS SMALLINT
	DECLARE @PropertyName AS NVARCHAR(31)

	DECLARE @ConsumeGold AS BIGINT
	DECLARE @ConsumeUserMedal AS BIGINT
	DECLARE @ConsumeCash AS DECIMAL(18,2)
	DECLARE @ConsumeLoveLiness AS BIGINT

	DECLARE @Gold AS BIGINT
	DECLARE @UserMedal AS BIGINT
	DECLARE @Cash AS DECIMAL(18,2)
	DECLARE @LoveLiness AS BIGINT
	
	DECLARE @BuyResultsGold AS BIGINT
	DECLARE @Nullity BIT
	DECLARE @CurrMemberOrder SMALLINT	
	
	SELECT @Nullity=Nullity, @CurrMemberOrder=MemberOrder FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo WHERE UserID=@dwUserID AND LogonPass=@strPassword

	-- 用户判断
	IF @CurrMemberOrder IS NULL
	BEGIN
		SET @strErrorDescribe=N'帐号不存在，请联系客户服务中心了解详细情况！'
		RETURN 1
	END	

	-- 帐号禁止
	IF @Nullity<>0
	BEGIN
		SET @strErrorDescribe=N'帐号暂时处于冻结状态，请联系客户服务中心了解详细情况！'
		RETURN 2
	END

	-- 初始信息
	SET @ConsumeGold=0
	SET @ConsumeUserMedal=0
	SET @ConsumeCash=0
	SET @ConsumeLoveLiness=0
	SET @BuyResultsGold = 0

	-- 道具判断
	SELECT @PropertyName=Name, @GoldPrice=Gold, @CashPrice=Cash, @UserMedalPrice=UserMedal, @LoveLinessPrice=Loveliness,@BuyResultsGold=BuyResultsGold	FROM GameProperty(NOLOCK) WHERE Nullity=0 AND ID=@dwPropertyID
	IF @PropertyName IS NULL
	BEGIN
		SET @strErrorDescribe=N'购买的道具商品不存在或者正在维护中！'
		RETURN 3
	END
	
	IF @dwItemCount = 0
	BEGIN
		SET @strErrorDescribe=N'购买的道具商品不存在或者正在维护中！'
		RETURN 3
	END
	
	--会员折扣
	SELECT @Discount=ShopRate FROM RYAccountsDBLink.RYAccountsDB.dbo.MemberProperty where MemberOrder=@CurrMemberOrder
	IF @Discount is null
	BEGIN
		SET @Discount=100
	END
	
	-- 金币消费
	IF @cbConsumeType=1
	BEGIN
			
		-- 费用计算
		IF @CurrMemberOrder=0
		BEGIN
			SET @ConsumeGold=@GoldPrice*@dwItemCount
		END		
		ELSE
		BEGIN
			SET @ConsumeGold=@GoldPrice*@dwItemCount*@Discount/100
		END
		
		-- 读取银行
		SELECT @Gold=InsureScore FROM RYTreasureDBLink.RYTreasureDB.dbo.GameScoreInfo WHERE UserID=@dwUserID

		-- 数量判断
		IF @Gold<@ConsumeGold OR @Gold IS NULL
		BEGIN
			-- 错误信息
			SET @strErrorDescribe=N'银行游戏币不足，请选择其他的购买方式或者往银行存入足够的游戏币后再次尝试！'
			RETURN 4
		END

		-- 银行扣费
		UPDATE RYTreasureDBLink.RYTreasureDB.dbo.GameScoreInfo SET InsureScore=InsureScore-@ConsumeGold WHERE UserID=@dwUserID

	END

	--元宝消费
	IF @cbConsumeType=2
	BEGIN

		-- 费用计算
		IF @CurrMemberOrder=0 
		BEGIN
			SET @ConsumeUserMedal=@UserMedalPrice*@dwItemCount
		END
		ELSE 
		BEGIN
			SET @ConsumeUserMedal=@UserMedalPrice*@dwItemCount*@Discount/100
		END
		
		-- 读取元宝
		SELECT @UserMedal=UserMedal FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo WHERE UserID=@dwUserID
				
		-- 数量判断
		IF @UserMedal<@ConsumeUserMedal OR @UserMedal IS NULL
		BEGIN

			-- 错误信息
			SET @strErrorDescribe=N'元宝不足，请选择其他的购买方式后再次尝试！'
			RETURN 5
		END

		-- 银行扣费
		UPDATE RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo SET UserMedal=UserMedal-@ConsumeUserMedal WHERE UserID=@dwUserID

	END
	
	--游戏豆消费
	IF @cbConsumeType=3
	BEGIN
	
		-- 费用计算
		IF @CurrMemberOrder=0 
		BEGIN
			SET @ConsumeCash=@CashPrice*@dwItemCount
		END
		ELSE
		BEGIN
			SET @ConsumeCash=@CashPrice*@dwItemCount*@Discount/100.00
		END

		-- 读取游戏豆
		SELECT @Cash=Currency FROM RYTreasureDBLink.RYTreasureDB.dbo.UserCurrencyInfo WHERE UserID=@dwUserID
		
		-- 数量判断
		IF @Cash<@ConsumeCash OR @Cash IS NULL
		BEGIN
		
			-- 错误信息
			SET @strErrorDescribe=N'游戏豆不足，请选择其他的购买方式后再次尝试！'
			RETURN 6
		END

		-- 银行扣费
		UPDATE RYTreasureDBLink.RYTreasureDB.dbo.UserCurrencyInfo SET Currency=@Cash-@ConsumeCash WHERE UserID=@dwUserID
		
	END
	--魅力值消费
	IF @cbConsumeType=4
	BEGIN

		-- 费用计算
		IF @CurrMemberOrder=0 
		BEGIN
			SET @ConsumeLoveLiness=@LoveLinessPrice*@dwItemCount
		END
		ELSE
		BEGIN
			SET @ConsumeLoveLiness=@LoveLinessPrice*@dwItemCount*@Discount/100
		END

		-- 读取魅力值
		SELECT @LoveLiness=LoveLiness FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo WHERE UserID=@dwUserID
		-- 银行判断
		IF @LoveLiness<@ConsumeLoveLiness OR @LoveLiness IS NULL
		BEGIN
			-- 错误信息
			SET @strErrorDescribe=N'魅力值不足，请选择其他的购买方式后再次尝试！'
			RETURN 7
		END

		-- 银行扣费
		UPDATE RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo SET LoveLiness=LoveLiness-@ConsumeLoveLiness WHERE UserID=@dwUserID


	END

    IF @BuyResultsGold <> 0
	BEGIN
	
		DECLARE @DateID INT
		SET @DateID=CAST(CAST(GETDATE() AS FLOAT) AS INT)
		-- 查询金币
		DECLARE @CurrScore BIGINT
		DECLARE @CurrInsure BIGINT
		DECLARE @CurrMedal INT
		SELECT @CurrScore=Score,@CurrInsure=InsureScore FROM RYTreasureDBLink.RYTreasureDB.dbo.GameScoreInfo  WHERE UserID=@dwUserID
		SELECT @CurrMedal=UserMedal FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo WHERE UserID=@dwUserID
		
		-- 赠送金币
		SET @BuyResultsGold = @BuyResultsGold * @dwItemCount
		UPDATE RYTreasureDBLink.RYTreasureDB.dbo.GameScoreInfo SET InsureScore = InsureScore+@BuyResultsGold WHERE UserID = @dwUserID  
	
		-- 流水账
		INSERT INTO RYTreasureDBLink.RYTreasureDB.dbo.RecordPresentInfo(UserID,PreScore,PreInsureScore,PresentScore,TypeID,IPAddress,CollectDate)
		VALUES (@dwUserID,@CurrScore,@CurrInsure,@BuyResultsGold,17,@strClientIP,GETDATE())	
		
	    -- 日统计
	    UPDATE RYTreasureDBLink.RYTreasureDB.dbo.StreamPresentInfo SET DateID=@DateID, PresentCount=PresentCount+1,PresentScore=PresentScore+@BuyResultsGold WHERE UserID=@dwUserID AND TypeID=17
		IF @@ROWCOUNT=0
		BEGIN
			INSERT RYTreasureDBLink.RYTreasureDB.dbo.StreamPresentInfo(DateID,UserID,TypeID,PresentCount,PresentScore) VALUES(@DateID,@dwUserID,17,1,@BuyResultsGold)
		END	
		
	END


	--如果是购买的房卡道具，则需要改变房卡表
	IF @dwPropertyID = 501
	BEGIN
		UPDATE RYTreasureDBLink.RYTreasureDB.dbo.UserRoomCard SET RoomCard = RoomCard + @dwItemCount  WHERE UserID=@dwUserID 
		IF @@ROWCOUNT =0
		BEGIN
			INSERT RYTreasureDBLink.RYTreasureDB.dbo.UserRoomCard(UserID,RoomCard)	VALUES(@dwUserID,@dwItemCount )
		END
	END 
	ELSE
	BEGIN
		--加入背包
		UPDATE RYAccountsDBLink.RYAccountsDB.dbo.AccountsPackage SET GoodShowID=0, GoodsCount=GoodsCount+ @dwItemCount, PushTime=GETDATE() WHERE UserID=@dwUserID AND GoodsID=@dwPropertyID
		IF @@ROWCOUNT = 0
		BEGIN
			INSERT RYAccountsDBLink.RYAccountsDB.dbo.AccountsPackage(UserID,GoodsID,GoodShowID,GoodsCount,PushTime)	VALUES(@dwUserID, @dwPropertyID,0,@dwItemCount,GETDATE())
		END
	END

	--购买记录
	INSERT RYRecordDBLink.RYRecordDB.dbo.RecordBuyProperty(UserID,PropertyID,PropertyName,Cash,Gold,UserMedal,LoveLiness,PropertyCount,MemberDiscount,BuyCash,BuyGold,BuyUserMedal,BuyLoveLiness,ClinetIP,CollectDate)
	VALUES(@dwUserID,@dwPropertyID,@PropertyName,@CashPrice,@GoldPrice,@UserMedalPrice,@LoveLinessPrice,@dwItemCount,@Discount,@ConsumeCash,@ConsumeGold,@ConsumeUserMedal,@ConsumeLoveLiness,@strClientIP,GETDATE())

	
	SELECT @Gold=InsureScore FROM RYTreasureDBLink.RYTreasureDB.dbo.GameScoreInfo WHERE UserID=@dwUserID
	SELECT @UserMedal=UserMedal,@LoveLiness=LoveLiness,@CurrMemberOrder=MemberOrder FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo WHERE UserID=@dwUserID
	SELECT @Cash=Currency FROM RYTreasureDBLink.RYTreasureDB.dbo.UserCurrencyInfo WHERE UserID=@dwUserID
	
	IF @Gold IS NULL SET @Gold=0
	IF @UserMedal IS NULL SET @UserMedal=0
	IF @Cash IS NULL SET @Cash=0
	IF @LoveLiness IS NULL SET @LoveLiness=0		
	SET @strErrorDescribe=N'恭喜您！购买' + @PropertyName + N' ×' + CAST(@dwItemCount AS NVARCHAR) +N' ' + N'成功！'
	
	--输出记录
	SELECT @dwPropertyID AS PropertyID,@dwItemCount AS ItemCount,@Gold AS Gold, @UserMedal AS UserMedal, @Cash AS Cash, @LoveLiness AS LoveLiness,@CurrMemberOrder AS MemberOrder
	RETURN 0
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

-- 加载Buff
CREATE PROC GSP_GP_LoadUserGameBuff
	@dwUserID	INT						-- 用户 I D
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN
	--删除过期
	DELETE RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfoPoperty WHERE UserID=@dwUserID and dateadd(second,UseResultsValidTime,UseTime) < GETDATE()
	--有效查询
	SELECT * FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfoPoperty  WHERE UserID=@dwUserID and dateadd(second,UseResultsValidTime,UseTime) > GETDATE()
	RETURN 0
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

-- 加载Buff
CREATE PROC GSP_GP_LoadUserGameTrumpet
	@dwUserID	INT						-- 用户 I D
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN
	DECLARE @TrumpetCount INT 
	DECLARE @TyphonCount INT 
	SET @TrumpetCount = 0
	SET @TyphonCount = 0
	SELECT @TrumpetCount=GoodsCount FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsPackage WHERE UserID=@dwUserID and GoodsID=307
	SELECT @TyphonCount=GoodsCount FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsPackage WHERE UserID=@dwUserID and GoodsID=306
	SELECT @TrumpetCount as TrumpetCount, @TyphonCount as TyphonCount
END

RETURN 0

GO
----------------------------------------------------------------------------------------------------


SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

--赠送道具
CREATE PROC GSP_GP_QuerySendPresent
	@dwUserID				INT			-- 用户ID
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN

	SELECT * FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsSendPresent AS a, GameProperty AS b 
	WHERE a.ReceiverUserID=@dwUserID and a.PropID = b.ID
	
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

--赠送道具 按照游戏ID
CREATE PROC GSP_GP_UserSendPresentByID
	@dwUserID				INT,			-- 赠送者用户ID
	@dwReceiverGameID		INT,			-- 接收者游戏ID
	@dwPropID				INT,			-- 赠送的道具ID
	@dwPropCount			INT,			-- 赠送的数量
	@strClientIP			NVARCHAR(15),	-- 赠送者的IP 
	@strErrorDescribe NVARCHAR(127) OUTPUT	-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN

	--查询用户
	DECLARE @dwReceiverUserID INT
	SELECT @dwReceiverUserID=UserID FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo WHERE GameID=@dwReceiverGameID
	IF @dwReceiverUserID is null
	BEGIN
		set @strErrorDescribe = N'查找不到接收者信息'
		RETURN 1
	END

	if @dwPropCount <= 0
	BEGIN
		set @strErrorDescribe = N'输入的道具数量信息有误'
		RETURN 2
	END
	
	IF @dwReceiverUserID=@dwUserID
	BEGIN
		set @strErrorDescribe = N'不能自己赠送给自己'
		RETURN 3
	END
	
	--查找道具
	DECLARE @UserPropCount INT
	SELECT @UserPropCount=GoodsCount FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsPackage where UserID=@dwUserID and GoodsID=@dwPropID
	IF @UserPropCount is null or @UserPropCount < @dwPropCount
	BEGIN
		set @strErrorDescribe = N'赠送者的背包没有足够的该道具，不能赠送'
		RETURN 4
	END
	
	--减掉道具
	UPDATE RYAccountsDBLink.RYAccountsDB.dbo.AccountsPackage set GoodsCount=GoodsCount-@dwPropCount where UserID=@dwUserID and GoodsID=@dwPropID
	
	--插入状态
	INSERT RYAccountsDBLink.RYAccountsDB.dbo.AccountsSendPresent(UserID, ReceiverUserID, PropID, PropCount, SendTime, PropStatus, ClientIP) 
	VALUES (@dwUserID, @dwReceiverUserID, @dwPropID, @dwPropCount, GETDATE(), 0, @strClientIP)
	
	--赠送记录
	INSERT RYRecordDBLink.RYRecordDB.dbo.RecordUserSendPresent(UserID,ReceiverUserID,PropID,PropCount,SendTime,PropStatus,ClientIP)
	VALUES(@dwUserID,@dwReceiverUserID,@dwPropID,@dwPropCount,GETDATE(),0,@strClientIP)
	
	set @strErrorDescribe = N'赠送成功'
	
	SELECT @dwReceiverUserID AS RecvUserID
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

--赠送道具 按照 昵称
CREATE PROC GSP_GP_UserSendPresentByNickName
	@dwUserID				INT,			-- 赠送者用户ID
	@strReceiverNickName	NVARCHAR(16),	-- 接收者昵称
	@dwPropID				INT,			-- 赠送的道具ID
	@dwPropCount			INT,			-- 赠送的数量
	@strClientIP			NVARCHAR(16),	-- 赠送者的IP 
	@strErrorDescribe NVARCHAR(64) OUTPUT	-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN

	--查询用户
	DECLARE @dwReceiverUserID INT
	SELECT @dwReceiverUserID=UserID FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo WHERE NickName=@strReceiverNickName
	IF @dwReceiverUserID is null
	BEGIN
		set @strErrorDescribe = N'查找不到接收者信息'
		RETURN 1
	END
	
	if @dwPropCount <= 0
	BEGIN
		set @strErrorDescribe = N'输入的道具数量信息有误'
		RETURN 2
	END
	
	IF @dwReceiverUserID=@dwUserID
	BEGIN
		set @strErrorDescribe = N'不能自己赠送给自己'
		RETURN 3
	END
	
	--查找赠送者背包有没有该数量的道具
	DECLARE @UserPropCount INT
	SELECT @UserPropCount=GoodsCount FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsPackage where UserID=@dwUserID and GoodsID=@dwPropID
	IF @UserPropCount is null or @UserPropCount < @dwPropCount
	BEGIN
		set @strErrorDescribe = N'赠送者的背包没有足够的该道具，不能赠送'
		RETURN 4
	END
	
	--减掉赠送者背包的道具
	UPDATE RYAccountsDBLink.RYAccountsDB.dbo.AccountsPackage set GoodsCount=GoodsCount-@dwPropCount where UserID=@dwUserID and GoodsID=@dwPropID
	
	--写用户赠送状态
	INSERT RYAccountsDBLink.RYAccountsDB.dbo.AccountsSendPresent(UserID, ReceiverUserID, PropID, PropCount, SendTime, PropStatus, ClientIP) 
	VALUES (@dwUserID, @dwReceiverUserID, @dwPropID, @dwPropCount, GETDATE(), 0, @strClientIP)
	
	--赠送记录
	INSERT RYRecordDBLink.RYRecordDB.dbo.RecordUserSendPresent(UserID,ReceiverUserID,PropID,PropCount,SendTime,PropStatus,ClientIP)
	VALUES(@dwUserID,@dwReceiverUserID,@dwPropID,@dwPropCount,GETDATE(),0,@strClientIP)
	
	set @strErrorDescribe = N'赠送成功'
	
	SELECT @dwReceiverUserID AS RecvUserID
	
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

--获取赠送
SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

--赠送道具
CREATE PROC GSP_GP_GetSendPresent
	@dwUserID				INT,			-- 用户ID
	@szPassword			NVARCHAR(33),		-- 用户密码
	@strClientIP		NVARCHAR(15)		-- 客户IP 
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN

	DECLARE @Password NVARCHAR(33)
	SELECT @Password = LogonPass FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo where UserID=@dwUserID
	--查询错误
	IF @Password is null
		RETURN 1
	
	--密码错误
	IF @szPassword != @Password
		RETURN 2
	
	DECLARE @PresentCount INT
	SELECT @PresentCount = COUNT(*) FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsSendPresent
	WHERE ReceiverUserID=@dwUserID and PropStatus=0
	--没有物品
	IF @PresentCount = 0
		RETURN 3
	
	--放入背包
	DECLARE @PropID INT
	DECLARE @PropCount INT
	DECLARE @ItemCount INT
	DECLARE auth_cur CURSOR FOR
	SELECT PropID,PropCount FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsSendPresent AS a, GameProperty AS b 
	WHERE a.ReceiverUserID=@dwUserID and a.PropID = b.ID and a.PropStatus=0
	OPEN auth_cur
	FETCH NEXT FROM auth_cur INTO @PropID,@PropCount
	WHILE (@@fetch_status=0)
	BEGIN
		SELECT @ItemCount=COUNT(*) FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsPackage WHERE UserID=@dwUserID and GoodsID=@PropID
		IF @ItemCount = 0
		BEGIN
			INSERT RYAccountsDBLink.RYAccountsDB.dbo.AccountsPackage(UserID,GoodsID,GoodShowID,GoodsSortID,GoodsCount,PushTime)
			VALUES(@dwUserID,@PropID,0,0,@PropCount,GETDATE())
		END
		ELSE
		BEGIN
			UPDATE RYAccountsDBLink.RYAccountsDB.dbo.AccountsPackage SET GoodsCount=GoodsCount+@PropCount
			WHERE UserID=@dwUserID and GoodsID=@PropID
		END
		FETCH NEXT FROM auth_cur INTO @PropID,@PropCount
	END
	close auth_cur
	deallocate auth_cur
	
	--更新状态
	UPDATE RYRecordDBLink.RYRecordDB.dbo.RecordUserSendPresent SET ReceiveTime=GETDATE(), ReceiverClientIP=@strClientIP, PropStatus=1 
	WHERE  ReceiverUserID = @dwUserID and PropStatus=0
	
	--查询返回
	SELECT * FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsSendPresent AS a, GameProperty AS b 
	WHERE a.ReceiverUserID=@dwUserID and a.PropID = b.ID and a.PropStatus=0
	
	--删除状态
	DELETE RYAccountsDBLink.RYAccountsDB.dbo.AccountsSendPresent WHERE  ReceiverUserID=@dwUserID and PropStatus=0
	
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------


SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

--赠送道具
CREATE PROC GSP_GP_PropertQuerySingle
	@dwUserID INT,								-- 用户标识
	@dwPropertyID INT,							-- 道具标识
	@strPassword NCHAR(32)						-- 用户密码
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN

	DECLARE @Nullity INT
	SELECT @Nullity=Nullity FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo WHERE UserID=@dwUserID AND LogonPass=@strPassword

	-- 用户判断
	IF @Nullity IS NULL
	BEGIN
		RETURN 1
	END	

	-- 帐号禁止
	IF @Nullity<>0
	BEGIN
		RETURN 2
	END
	DECLARE @GoodsCount INT
	SET @GoodsCount = 0
	SELECT @GoodsCount = GoodsCount	FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsPackage WHERE UserID=@dwUserID and GoodsID=@dwPropertyID
	
	SELECT @dwPropertyID AS PropertyID,@GoodsCount AS ItemCount
	
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------
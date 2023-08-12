----------------------------------------------------------------------------------------------------
-- 版权：2011
-- 时间：2012-02-23
-- 用途：房卡购买
----------------------------------------------------------------------------------------------------

USE RYTreasureDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].NET_PW_BuyRoomCardGeneral') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].NET_PW_BuyRoomCardGeneral
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_NULLS ON
GO

----------------------------------------------------------------------------------------------------

CREATE PROCEDURE NET_PW_BuyRoomCardGeneral
	@dwUserID	INT,						-- 用户 I D
	@dwBuyNum	INT,						-- 购买数量
	@dwTypeID	INT,						-- 支付类型（0、游戏豆 1、游戏币）
	@strPassword NCHAR(32),					-- 银行密码
	@strClientIP NVARCHAR(15),				-- 操作地址
	@strErrorDescribe NVARCHAR(127) OUTPUT	-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 用户信息
DECLARE @UserID INT
DECLARE @Nullity BIT
DECLARE @StunDown BIT
DECLARE @InsurePass NCHAR(32)
DECLARE @UserCurrency DECIMAL(18,2)
DECLARE @UserRoomCard INT
DECLARE @UserGold BIGINT

-- 产品信息
DECLARE @Rate BIGINT
DECLARE @RoomCard INT
DECLARE @Currency DECIMAL(18,2)
DECLARE @Gold BIGINT

-- 执行逻辑
BEGIN
	-- 查询用户
	SELECT @UserID=UserID, @Nullity=Nullity, @StunDown=StunDown,@InsurePass=InsurePass FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo WHERE UserID=@dwUserID

	-- 查询用户
	IF @UserID IS NULL
	BEGIN
		SET @strErrorDescribe=N'您的帐号不存在或者密码输入有误，请查证后再次尝试登录！'
		RETURN 1
	END	
	
	-- 帐号禁止
	IF @Nullity<>0
	BEGIN
		SET @strErrorDescribe=N'您的帐号暂时处于冻结状态，请联系客户服务中心了解详细情况！'
		RETURN 2
	END	

	-- 帐号关闭
	IF @StunDown<>0
	BEGIN
		SET @strErrorDescribe=N'您的帐号使用了安全关闭功能，必须重新开通后才能继续使用！'
		RETURN 3
	END		

	-- 验证银行密码
	IF @InsurePass!=@strPassword
	BEGIN
		SET @strErrorDescribe=N'非常抱歉，您的银行密码输入错误！'
		RETURN 3
	END

	--游戏豆购买
	IF @dwTypeID = 0
	BEGIN
		--验证配置
		SELECT @Rate = CAST(Cash AS BIGINT) FROM RYPlatformDBLink.RYPlatformDB.dbo.GameProperty WHERE ID = 501
		IF @Rate IS NULL OR @Rate <= 0
		BEGIN
			SET @strErrorDescribe=N'非常抱歉,房卡购买比例未配置，请联系管理员！'
			RETURN 4
		END

		-- 获取支付游戏豆
		SET @Currency = @Rate * @dwBuyNum

		-- 开启事务
		BEGIN TRAN

		SELECT @UserCurrency=Currency FROM UserCurrencyInfo(ROWLOCK) WHERE UserID=@UserID
		IF @UserCurrency IS NULL OR @UserCurrency<@Currency
		BEGIN
			SET @strErrorDescribe=N'非常抱歉,您的游戏豆余额不足，请先充值！'
			ROLLBACK TRAN
			RETURN 5
		END

		UPDATE UserCurrencyInfo SET Currency = Currency - @Currency WHERE UserID=@UserID
		IF @@ROWCOUNT <= 0
		BEGIN
			SET @strErrorDescribe=N'非常抱歉,购买失败！'
			ROLLBACK TRAN
			RETURN 6
		END

		SELECT @UserRoomCard=RoomCard FROM UserRoomCard WHERE UserID=@UserID
		IF @UserRoomCard IS NULL
		BEGIN
			SET @UserRoomCard = 0
			INSERT INTO UserRoomCard VALUES(@UserID,@dwBuyNum)
		END
		ELSE
		BEGIN
			UPDATE UserRoomCard SET RoomCard = RoomCard + @dwBuyNum WHERE UserID=@UserID
		END

		IF @@ROWCOUNT <= 0
		BEGIN
			SET @strErrorDescribe=N'非常抱歉,购买失败！'
			ROLLBACK TRAN
			RETURN 6
		END

		COMMIT TRAN

		-- 写入操作记录
		INSERT INTO RYRecordDBLink.RYRecordDB.dbo.RecordRoomCard(SourceUserID,SBeforeCard,RoomCard,TypeID,Currency,SBeforeCurrency,ClientIP) VALUES(@UserID,@UserRoomCard,@dwBuyNum,0,@Currency,@UserCurrency,@strClientIP)
	END
	--游戏币购买
	ELSE
	BEGIN
		--验证配置
		SELECT @Rate = Gold FROM RYPlatformDBLink.RYPlatformDB.dbo.GameProperty WHERE ID = 501
		IF @Rate IS NULL OR @Rate <= 0
		BEGIN
			SET @strErrorDescribe=N'非常抱歉,房卡购买比例未配置，请联系管理员！'
			RETURN 4
		END

		-- 获取支付游戏豆
		SET @Gold = @Rate * @dwBuyNum

		-- 开启事务
		BEGIN TRAN

		SELECT @UserGold=InsureScore FROM GameScoreInfo(ROWLOCK) WHERE UserID=@UserID
		IF @UserGold IS NULL OR @UserGold<@Gold
		BEGIN
			SET @strErrorDescribe=N'非常抱歉,您的银行的游戏币余额不足！'
			ROLLBACK TRAN
			RETURN 5
		END

		UPDATE GameScoreInfo SET InsureScore = InsureScore - @Gold WHERE UserID=@UserID
		IF @@ROWCOUNT <= 0
		BEGIN
			SET @strErrorDescribe=N'非常抱歉,购买失败！'
			ROLLBACK TRAN
			RETURN 6
		END

		SELECT @UserRoomCard=RoomCard FROM UserRoomCard WHERE UserID=@UserID
		IF @UserRoomCard IS NULL
		BEGIN
			SET @UserRoomCard = 0
			INSERT INTO UserRoomCard VALUES(@UserID,@dwBuyNum)
		END
		ELSE
		BEGIN
			UPDATE UserRoomCard SET RoomCard = RoomCard + @dwBuyNum WHERE UserID=@UserID
		END

		IF @@ROWCOUNT <= 0
		BEGIN
			SET @strErrorDescribe=N'非常抱歉,购买失败！'
			ROLLBACK TRAN
			RETURN 6
		END

		COMMIT TRAN

		-- 写入操作记录
		INSERT INTO RYRecordDBLink.RYRecordDB.dbo.RecordRoomCard(SourceUserID,SBeforeCard,RoomCard,TypeID,Gold,SBeforeGold,ClientIP) VALUES(@UserID,@UserRoomCard,@dwBuyNum,4,@Gold,@UserGold,@strClientIP)
	END

	SET @strErrorDescribe=N'房卡购买成功！' 
END

RETURN 0

GO
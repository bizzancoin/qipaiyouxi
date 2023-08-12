----------------------------------------------------------------------
-- 版权：2011
-- 时间：2011-09-1
-- 用途：在线充值
----------------------------------------------------------------------

USE [RYTreasureDB]
GO

-- 在线充值
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].NET_PW_FilledApp') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].NET_PW_FilledApp
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

---------------------------------------------------------------------------------------
-- 在线充值
CREATE PROCEDURE NET_PW_FilledApp
	@dwUserID			INT,					-- 用户标识
	@strOrdersID		NVARCHAR(50),			-- 订单编号
	@PayAmount			DECIMAL(18,2),			-- 付款金额
	@strProductID		NVARCHAR(100),			-- APP产品标识
	@dwShareID			INT,					-- 服务标识
	@strErrorDescribe	NVARCHAR(127) OUTPUT	-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 订单信息
DECLARE @UserID INT
DECLARE @Accounts NVARCHAR(31)
DECLARE @GameID INT
DECLARE @Nullity TINYINT

-- 产品信息
DECLARE @ProductID NVARCHAR(100)
DECLARE @Price DECIMAL(18,2)
DECLARE @AttachCurrency DECIMAL(18,2)
DECLARE @PresentCurrency DECIMAL(18,2)
DECLARE @Currency DECIMAL(18,2)

-- 金币信息
DECLARE @Score BIGINT

-- 执行逻辑
BEGIN	
	-- 订单重复
	IF EXISTS(SELECT OrderID FROM ShareDetailInfo(NOLOCK) WHERE OrderID=@strOrdersID) 
	BEGIN
		SET @strErrorDescribe=N'抱歉！充值订单重复。'
		RETURN 1
	END

	-- 验证用户
	SELECT @UserID=UserID,@GameID=GameID,@Accounts=Accounts,@Nullity=Nullity
	FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo
	WHERE UserID=@dwUserID

	IF @UserID IS NULL
	BEGIN
		SET @strErrorDescribe=N'抱歉！您要充值的用户账号不存在。'
		RETURN 2
	END

	IF @Nullity=1
	BEGIN
		SET @strErrorDescribe=N'抱歉！您要充值的用户账号暂时处于冻结状态，请联系客户服务中心了解详细情况。'
		RETURN 3
	END	

	-- 查询APP产品信息
	SELECT @ProductID=ProductID,@Price=Price,@AttachCurrency=AttachCurrency,@PresentCurrency=PresentCurrency FROM GlobalAppInfo(NOLOCK) WHERE ProductID=@strProductID
	IF @ProductID IS NULL
	BEGIN
		SET @strErrorDescribe=N'抱歉！产品信息不存在。'
		RETURN 4
	END

	IF @PayAmount<>@Price
	BEGIN
		SET @strErrorDescribe=N'抱歉！支付金额错误。'
		RETURN 4
	END

	-- 货币汇率
	--DECLARE @Rate INT
	--SELECT @Rate=StatusValue FROM RYAccountsDBLink.RYAccountsDB.dbo.SystemStatusInfo WHERE StatusName='RateCurrency'
	--IF @Rate=0 OR @Rate IS NULL
	--	SET @Rate=1

	-- 货币查询
	DECLARE @BeforeCurrency DECIMAL(18,2)
	SELECT @BeforeCurrency=Currency FROM UserCurrencyInfo WHERE UserID=@UserID
	IF @BeforeCurrency IS NULL
		SET @BeforeCurrency=0

	-- 充值货币	
	--DECLARE @Currency DECIMAL(18,2)
	--DECLARE @PresentCurrency DECIMAL(18,2)
	--SET @Currency = @PayAmount*@Rate
	--SET @PresentCurrency=@Currency
	SET @Currency = @PresentCurrency

	-- 首充奖励
	IF @AttachCurrency<>0
	BEGIN
		IF NOT EXISTS (SELECT OrderID FROM ShareDetailInfo(NOLOCK) WHERE UserID=@UserID AND DATEDIFF(d,ApplyDate,GETDATE())=0)
		BEGIN
			SET @PresentCurrency=@Currency+@AttachCurrency
		END
	END

	UPDATE UserCurrencyInfo SET Currency=Currency+@PresentCurrency WHERE UserID=@UserID
	IF @@ROWCOUNT=0
	BEGIN
		INSERT UserCurrencyInfo(UserID,Currency) VALUES(@UserID,@PresentCurrency)
	END
	
	-- 产生记录
	INSERT INTO ShareDetailInfo(
		OperUserID,ShareID,UserID,GameID,Accounts,OrderID,OrderAmount,DiscountScale,PayAmount,
		Currency,BeforeCurrency,IPAddress)
	VALUES(
		0,@dwShareID,@UserID,@GameID,@Accounts,@strOrdersID,@PayAmount,0,@PayAmount,
		@PresentCurrency,@BeforeCurrency,'0.0.0.0')

	--------------------------------------------------------------------------------
	-- 推广系统&代理系统
	DECLARE @SpreaderID INT	
	SELECT @SpreaderID=SpreaderID FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo
	WHERE UserID = @UserID
	IF @SpreaderID<>0
	BEGIN
		-- 货币与金币的汇率
		DECLARE @GoldRate INT
		SELECT @GoldRate=StatusValue FROM RYAccountsDBLink.RYAccountsDB.dbo.SystemStatusInfo WHERE StatusName='RateGold'
		IF @GoldRate=0 OR @GoldRate IS NULL
			SET @GoldRate=1

		-- 代理系统
		DECLARE @AgentUserID INT
		DECLARE @AgentType INT
		DECLARE @AgentScale DECIMAL(18,3)
		DECLARE @PayScore BIGINT
		DECLARE @AgentScore BIGINT
		DECLARE @AgentDateID INT	
		SELECT @AgentUserID=UserID,@AgentType=AgentType,@AgentScale=AgentScale FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsAgent WHERE UserID=@SpreaderID AND Nullity=0
		IF @AgentUserID IS NOT NULL
		BEGIN
			IF @AgentType=1 -- 充值分成
			BEGIN
				-- 充值金币计算
				SET @PayScore=@Currency*@GoldRate
				SET @AgentScore=@PayScore*@AgentScale
				SET @AgentDateID=CAST(CAST(GETDATE() AS FLOAT) AS INT)	
				-- 新增分成记录
				INSERT INTO RecordAgentInfo(DateID,UserID,AgentScale,TypeID,PayScore,Score,ChildrenID,CollectIP) VALUES(@AgentDateID,@AgentUserID,@AgentScale,1,@PayScore,@AgentScore,@UserID,'')
				-- 代理日统计
				UPDATE StreamAgentPayInfo SET PayAmount=PayAmount+@PayAmount,Currency=Currency+@Currency,PayScore=PayScore+@PayScore,LastCollectDate=GETDATE() WHERE DateID=@AgentDateID AND UserID=@AgentUserID
				IF @@ROWCOUNT=0
				BEGIN
					INSERT INTO StreamAgentPayInfo(DateID,UserID,PayAmount,Currency,PayScore) VALUES(@AgentDateID,@AgentUserID,@PayAmount,@Currency,@PayScore)
				END
			END
		END
		ELSE
		BEGIN
			DECLARE @SpreadRate DECIMAL(18,2)
			DECLARE @GrantScore BIGINT
			DECLARE @Note NVARCHAR(512)
			-- 推广分成
			SELECT @SpreadRate=FillGrantRate FROM GlobalSpreadInfo
			IF @SpreadRate IS NULL
			BEGIN
				SET @SpreadRate=0.1
			END
			
			SET @GrantScore = @Currency*@GoldRate*@SpreadRate
			SET @Note = N'充值'+LTRIM(STR(@PayAmount))+'元'
			INSERT INTO RecordSpreadInfo(UserID,Score,TypeID,ChildrenID,CollectNote)
			VALUES(@SpreaderID,@GrantScore,3,@UserID,@Note)		
		END
	END

	-- 记录日志
	DECLARE @DateID INT
	SET @DateID=CAST(CAST(GETDATE() AS FLOAT) AS INT)

	UPDATE StreamShareInfo
	SET ShareTotals=ShareTotals+1
	WHERE DateID=@DateID AND ShareID=@dwShareID

	IF @@ROWCOUNT=0
	BEGIN
		INSERT StreamShareInfo(DateID,ShareID,ShareTotals)
		VALUES (@DateID,@dwShareID,1)
	END	 
	
END 
RETURN 0
GO




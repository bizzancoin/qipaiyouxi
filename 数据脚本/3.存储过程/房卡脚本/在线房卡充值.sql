----------------------------------------------------------------------
-- 版权：2011
-- 时间：2011-09-1
-- 用途：在线充值
----------------------------------------------------------------------

USE [RYTreasureDB]
GO

-- 在线充值
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].NET_PW_FilledOnLineFK') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].NET_PW_FilledOnLineFK
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

---------------------------------------------------------------------------------------
-- 在线充值
CREATE PROCEDURE NET_PW_FilledOnLineFK
	@strOrdersID		NVARCHAR(50),			--	订单编号
	@PayAmount			DECIMAL(18,2),			--  支付金额
	@strIPAddress		NVARCHAR(31),			--	用户帐号	
	@strErrorDescribe	NVARCHAR(127) OUTPUT	--	输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 订单信息
DECLARE @OperUserID INT
DECLARE @ShareID INT
DECLARE @UserID INT
DECLARE @GameID INT
DECLARE @Accounts NVARCHAR(31)
DECLARE @OrderAmount DECIMAL(18,2)
DECLARE @IPAddress NVARCHAR(15)
DECLARE @OrderID NVARCHAR(50)
DECLARE @RoomCard INT
DECLARE @BeforeRoomCard INT

-- 用户信息
DECLARE @Score BIGINT

-- 其他信息
DECLARE @Rate INT

-- 执行逻辑
BEGIN
	-- 订单查询
	SELECT @OperUserID=OperUserID,@ShareID=ShareID,@UserID=UserID,@GameID=GameID,@Accounts=Accounts,
		@OrderID=OrderID,@OrderAmount=OrderAmount,@RoomCard=RoomCard  
	FROM OnLineOrder WHERE OrderID=@strOrdersID

	-- 订单存在
	IF @OrderID IS NULL 
	BEGIN
		SET @strErrorDescribe=N'抱歉！充值订单不存在。'
		RETURN 1
	END

	-- 订单重复
	IF EXISTS(SELECT OrderID FROM ShareDetailInfo(NOLOCK) WHERE OrderID=@strOrdersID) 
	BEGIN
		SET @strErrorDescribe=N'抱歉！充值订单重复。'
		RETURN 2
	END

	-- 验证金额
	IF @OrderAmount != @PayAmount
	BEGIN
		SET @strErrorDescribe=N'抱歉！支付金额错误。'
		RETURN 2
	END

	-- 房卡查询
	SELECT @BeforeRoomCard=RoomCard FROM UserRoomCard WHERE UserID=@UserID
	IF @BeforeRoomCard IS NULL
	BEGIN
		SET @BeforeRoomCard=0
		INSERT INTO UserRoomCard VALUES(@UserID,@RoomCard)
	END
	ELSE
	BEGIN
		UPDATE UserRoomCard SET RoomCard = RoomCard + @RoomCard WHERE UserID=@UserID
	END

	-- 产生记录
	INSERT INTO ShareDetailInfo(
		OperUserID,ShareID,UserID,GameID,Accounts,OrderID,OrderAmount,DiscountScale,PayAmount,
		RoomCard,BeforeRoomCard,IPAddress)
	VALUES(
		@OperUserID,@ShareID,@UserID,@GameID,@Accounts,@OrderID,@OrderAmount,1,@PayAmount,
		@RoomCard,@BeforeRoomCard,@strIPAddress)

	-- 更新订单状态
	UPDATE OnLineOrder SET OrderStatus=2,PayAmount=@PayAmount 
	WHERE OrderID=@OrderID

	--------------------------------------------------------------------------------
	-- 推广系统&代理系统
	--DECLARE @SpreaderID INT	
	--SELECT @SpreaderID=SpreaderID FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo
	--WHERE UserID = @UserID
	--IF @SpreaderID<>0
	--BEGIN
	--	-- 货币与金币的汇率
	--	DECLARE @GoldRate INT
	--	SELECT @GoldRate=StatusValue FROM RYAccountsDBLink.RYAccountsDB.dbo.SystemStatusInfo WHERE StatusName='RateGold'
	--	IF @GoldRate=0 OR @GoldRate IS NULL
	--		SET @GoldRate=1

	--	-- 代理系统
	--	DECLARE @AgentUserID INT
	--	DECLARE @AgentType INT
	--	DECLARE @AgentScale DECIMAL(18,3)
	--	DECLARE @PayScore BIGINT
	--	DECLARE @AgentScore BIGINT
	--	DECLARE @AgentDateID INT	
	--	SELECT @AgentUserID=UserID,@AgentType=AgentType,@AgentScale=AgentScale FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsAgent WHERE UserID=@SpreaderID AND Nullity=0
	--	IF @AgentUserID IS NOT NULL
	--	BEGIN
	--		IF @AgentType=1 -- 充值分成
	--		BEGIN
	--			-- 充值金币计算
	--			SET @PayScore=@Currency*@GoldRate
	--			SET @AgentScore=@PayScore*@AgentScale
	--			SET @AgentDateID=CAST(CAST(GETDATE() AS FLOAT) AS INT)	
	--			-- 新增分成记录
	--			INSERT INTO RecordAgentInfo(DateID,UserID,AgentScale,TypeID,PayScore,Score,ChildrenID,CollectIP) VALUES(@AgentDateID,@AgentUserID,@AgentScale,1,@PayScore,@AgentScore,@UserID,@strIPAddress)
	--			-- 代理日统计
	--			UPDATE StreamAgentPayInfo SET PayAmount=PayAmount+@PayAmount,Currency=Currency+@Currency,PayScore=PayScore+@PayScore,LastCollectDate=GETDATE() WHERE DateID=@AgentDateID AND UserID=@AgentUserID
	--			IF @@ROWCOUNT=0
	--			BEGIN
	--				INSERT INTO StreamAgentPayInfo(DateID,UserID,PayAmount,Currency,PayScore) VALUES(@AgentDateID,@AgentUserID,@PayAmount,@Currency,@PayScore)
	--			END
	--		END
	--	END
	--	ELSE -- 推广系统
	--	BEGIN
	--		DECLARE @SpreadRate DECIMAL(18,2)
	--		DECLARE @GrantScore BIGINT
	--		DECLARE @Note NVARCHAR(512)
	--		-- 推广分成
	--		SELECT @SpreadRate=FillGrantRate FROM GlobalSpreadInfo
	--		IF @SpreadRate IS NULL
	--		BEGIN
	--			SET @SpreadRate=0.1
	--		END
			
	--		SET @GrantScore = @Currency*@GoldRate*@SpreadRate
	--		SET @Note = N'充值'+LTRIM(STR(@PayAmount))+'元'
	--		INSERT INTO RecordSpreadInfo(UserID,Score,TypeID,ChildrenID,CollectNote)
	--		VALUES(@SpreaderID,@GrantScore,3,@UserID,@Note)		
	--	END	
	--END

	-- 记录日志
	DECLARE @DateID INT
	SET @DateID=CAST(CAST(GETDATE() AS FLOAT) AS INT)

	UPDATE StreamShareInfo
	SET ShareTotals=ShareTotals+1
	WHERE DateID=@DateID AND ShareID=@ShareID

	IF @@ROWCOUNT=0
	BEGIN
		INSERT StreamShareInfo(DateID,ShareID,ShareTotals)
		VALUES (@DateID,@ShareID,1)
	END	 
	
END 
RETURN 0
GO




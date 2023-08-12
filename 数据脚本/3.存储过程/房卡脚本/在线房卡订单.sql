----------------------------------------------------------------------
-- 版权：2011
-- 时间：2011-09-1
-- 用途：在线房卡订单
----------------------------------------------------------------------

USE [RYTreasureDB]
GO

-- 申请订单
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].NET_PW_ApplyOnLineOrderFK') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].NET_PW_ApplyOnLineOrderFK
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----------------------------------------------------------------------------------
-- 申请订单
CREATE PROCEDURE NET_PW_ApplyOnLineOrderFK
	@strOrderID			NVARCHAR(32),				-- 订单标识
	@dwOperUserID		INT,						-- 操作用户

	@dwShareID			INT,						-- 服务类型
	@dwConfigID			INT,						-- 充值配置
	@dwGameID			INT,						-- 充值ID
	
	@strIPAddress		NVARCHAR(15),				-- 支付地址
	@strErrorDescribe	NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 帐号资料
DECLARE @Accounts NVARCHAR(31)
DECLARE @GameID INT
DECLARE @UserID INT
DECLARE @Nullity TINYINT
DECLARE @StunDown TINYINT

-- 订单信息
DECLARE @OrderID NVARCHAR(32)
DECLARE @RoomCard INT
DECLARE @Amount INT

-- 执行逻辑
BEGIN
	-- 验证用户
	SELECT @UserID=UserID,@GameID=GameID,@Accounts=Accounts,@Nullity=Nullity,@StunDown=StunDown
	FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo
	WHERE GameID=@dwGameID

	IF @UserID IS NULL
	BEGIN
		SET @strErrorDescribe=N'抱歉！您要充值的用户账号不存在。'
		RETURN 1
	END

	IF @Nullity=1
	BEGIN
		SET @strErrorDescribe=N'抱歉！您要充值的用户账号暂时处于冻结状态，请联系客户服务中心了解详细情况。'
		RETURN 2
	END

	IF @StunDown<>0
	BEGIN
		SET @strErrorDescribe=N'抱歉！您要充值的用户账号使用了安全关闭功能，必须重新开通后才能继续使用。'
		RETURN 3
	END

	-- 订单查询
	SELECT @OrderID=OrderID FROM OnLineOrder WHERE OrderID=@strOrderID
	IF @OrderID IS NOT NULL
	BEGIN
		SET @strErrorDescribe=N'抱歉！该订单已存在,请重新充值。'
		RETURN 4
	END

	-- 房间锁定
	--IF EXISTS (SELECT UserID FROM GameScoreLocker(NOLOCK) WHERE UserID=@UserID)
	--BEGIN
	--	SET @strErrorDescribe='抱歉！您已经在金币游戏房间了，不能进行充值操作，请先退出金币游戏房间！'	
	--	RETURN 5
	--END
	
	-- 充值汇率
	SELECT @RoomCard=RoomCard,@Amount=Amount FROM RoomCardConfig WHERE ConfigID = @dwConfigID AND Nullity = 0
	IF @Amount IS NULL OR @Amount <=0
	BEGIN
		SET @strErrorDescribe=N'抱歉！充值额度配置不存在。'
		RETURN 4
	END

	-- 新增订单
	INSERT INTO OnLineOrder(
		OperUserID,ShareID,UserID,GameID,Accounts,OrderID,OrderAmount,PayAmount,Rate,RoomCard,IPAddress)
	VALUES(
		@dwOperUserID,@dwShareID,@UserID,@GameID,@Accounts,@strOrderID,@Amount,0,0,@RoomCard,@strIPAddress)
	
	SELECT @dwOperUserID AS OperUserID,@dwShareID AS ShareID,@UserID AS UserID,@GameID AS GameID,@Accounts AS Accounts,
		   @strOrderID AS OrderID, @Amount AS OrderAmount,0 AS PayAmount,0 AS Rate,0 AS Currency,@strIPAddress AS IPAddress

END
RETURN 0
GO




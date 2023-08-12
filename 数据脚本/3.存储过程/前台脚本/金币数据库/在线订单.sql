----------------------------------------------------------------------
-- 版权：2011
-- 时间：2011-09-1
-- 用途：在线订单
----------------------------------------------------------------------

USE [RYTreasureDB]
GO

-- 申请订单
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].NET_PW_ApplyOnLineOrder') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].NET_PW_ApplyOnLineOrder
GO

-- 快钱支付记录
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].NET_PW_AddReturnKQInfo') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].NET_PW_AddReturnKQInfo
GO

-- 电话支付记录
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].NET_PW_AddReturnVBInfo') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].NET_PW_AddReturnVBInfo

-- 易宝支付记录
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].NET_PW_AddReturnYBInfo') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].NET_PW_AddReturnYBInfo
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----------------------------------------------------------------------------------
-- 申请订单
CREATE PROCEDURE NET_PW_ApplyOnLineOrder
	@strOrderID			NVARCHAR(32),				-- 订单标识
	@dwOperUserID		INT,						-- 操作用户

	@dwShareID			INT,						-- 服务类型
	@dwProductType		INT,						-- 充值标识
	@dwAppID			INT,						-- 手机充值标识
	@strAccounts		NVARCHAR(31),				-- 充值用户
	@dcOrderAmount		DECIMAL(18,2),				-- 订单金额
	
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
DECLARE @OrderAmount DECIMAL(18,2)
DECLARE @PayAmount DECIMAL(18,2)
DECLARE @Currency DECIMAL(18,2)
DECLARE @Rate INT

-- 执行逻辑
BEGIN
	-- 验证用户
	SELECT @UserID=UserID,@GameID=GameID,@Accounts=Accounts,@Nullity=Nullity,@StunDown=StunDown
	FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo
	WHERE Accounts=@strAccounts

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
	IF @dwProductType = 1000
	BEGIN
		SELECT @Currency=PresentCurrency,@OrderAmount=Price FROM GlobalAppInfo WHERE AppID = @dwAppID
		IF @Currency IS NULL
		BEGIN
			SET @strErrorDescribe=N'抱歉！该充值额度配置不存在。'
			RETURN 4
		END
		IF @OrderAmount != @dcOrderAmount
		BEGIN
			SET @strErrorDescribe=N'抱歉！该充值金额异常。'
			RETURN 4
		END
	END
	ELSE
	BEGIN
		SELECT @Currency=PresentCurrency FROM GlobalWebInfo WHERE ProductType=@dwProductType AND Price = @dcOrderAmount
		IF @Currency IS NULL
		BEGIN
			SET @strErrorDescribe=N'抱歉！该充值额度配置不存在。'
			RETURN 4
		END
	END

	--SELECT @Rate=StatusValue FROM RYAccountsDBLink.RYAccountsDB.dbo.SystemStatusInfo 
	--WHERE StatusName='RateCurrency'
	--IF @Rate IS NULL
	--	SET @Rate=1

	-- 订单金额
	SET @OrderAmount=@dcOrderAmount
	SET @PayAmount=@dcOrderAmount
	--SET @Currency = @PayAmount*@Rate

	-- 新增订单
	INSERT INTO OnLineOrder(
		OperUserID,ShareID,UserID,GameID,Accounts,OrderID,OrderAmount,PayAmount,Rate,Currency,IPAddress)
	VALUES(
		@dwOperUserID,@dwShareID,@UserID,@GameID,@Accounts,@strOrderID,@OrderAmount,@PayAmount,0,@Currency,@strIPAddress)

	SELECT @dwOperUserID AS OperUserID,@dwShareID AS ShareID,@UserID AS UserID,@GameID AS GameID,@Accounts AS Accounts,
		   @strOrderID AS OrderID, @OrderAmount AS OrderAmount,@PayAmount AS PayAmount,@Rate AS Rate,@Currency AS Currency,@strIPAddress AS IPAddress	   
	
END
RETURN 0
GO

----------------------------------------------------------------------------------
-- 快钱支付记录
CREATE PROCEDURE NET_PW_AddReturnKQInfo      
        @strMerchantAcctID	NVARCHAR(64),				-- 收款人民币帐号
        @strVersion			NVARCHAR(20),				-- 快钱版本
        @dwLanguage			INT,						-- 网关页面语言类别
        @dwSignType			INT,						-- 签名类别
        @strPayType	 		NCHAR(10),					-- 支付方式
        @strBankID	 		NCHAR(20),					-- 银行代码

        @strOrderID	 		NVARCHAR(60),				-- 订单ID
        @dtOrderTime		DATETIME,					-- 订单日期
        @fOrderAmount		DECIMAL(18,2),				-- 订单金额(元)

        @strDealID			NVARCHAR(60),				-- 快钱交易号
        @strBankDealID		NVARCHAR(60),				-- 银行交易号
        @dtDealTime			DATETIME,					-- 快钱交易时间
        
		@fPayAmount			DECIMAL(18,2),				-- 订单实际支付金额（元）		
		@fFee				DECIMAL(18,3),				-- 快钱收取商户的手续费（元）

        @strPayResult		NVARCHAR(20),				-- 处理结果  10：支付成功 11：支付失败
        @strErrCode			NVARCHAR(40),				-- 错误代码
        @strSignMsg			NVARCHAR(64),				-- 签名字符串

        @strExt1			NVARCHAR(256),				-- 扩展字段1
        @strExt2			NVARCHAR(256),				-- 扩展字段2	
		
		@CardNumber			NVARCHAR(30) = '',				-- 支付卡号
		@CardPwd			NVARCHAR(30) = '',				-- 支付卡密
		@BossType			NVARCHAR(2) = '',				-- 支付类型(只适合充值卡)
		@ReceiveBossType	NVARCHAR(2) = '',				-- 实际支付类型
		@ReceiverAcctId		NVARCHAR(32) = ''				-- 实际收款账户

WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN	
	
	UPDATE ReturnKQDetailInfo
	SET MerchantAcctID=@strMerchantAcctID,Version=@strVersion,[Language]=@dwLanguage,SignType=@dwSignType,PayType=@strPayType,
		OrderTime=@dtOrderTime,OrderAmount=@fOrderAmount,DealID=@strDealID, BankDealID=@strBankDealID,DealTime=@dtDealTime,
		PayAmount=@fOrderAmount,Fee=@fFee,PayResult=@strPayResult, ErrCode=@strErrCode,SignMsg=@strSignMsg,Ext1=@strExt1, Ext2=@strExt2,
		CardNumber=@CardNumber,CardPwd=@CardPwd,BossType=@BossType,ReceiveBossType=@ReceiveBossType,ReceiverAcctId=@ReceiverAcctId
	WHERE OrderID=@strOrderID

	IF @@ROWCOUNT=0
	BEGIN
		INSERT ReturnKQDetailInfo
		(        
			MerchantAcctID,Version,[Language],SignType, PayType, BankID,
			OrderID,OrderTime,OrderAmount,DealID, BankDealID,DealTime,
			PayAmount,Fee,PayResult, ErrCode,SignMsg,Ext1, Ext2,
			CardNumber,CardPwd,BossType,ReceiveBossType,ReceiverAcctId
		)
		VALUES 
		(	
			@strMerchantAcctID,@strVersion,@dwLanguage,@dwSignType,@strPayType,@strBankID,
			@strOrderID,@dtOrderTime,@fOrderAmount,@strDealID,@strBankDealID,@dtDealTime,
			@fPayAmount,@fFee,@strPayResult,@strErrCode,@strSignMsg,@strExt1,@strExt2,
			@CardNumber,@CardPwd,@BossType,@ReceiveBossType,@ReceiverAcctId
		)
	END
END
RETURN 0
GO

----------------------------------------------------------------------------------
-- 电话充值记录
CREATE PROCEDURE NET_PW_AddReturnVBInfo 
	@Rtmd5			NVARCHAR(32),			--	V币服务器MD5
	@Rtka			NVARCHAR(15),			--	V币号码
	@Rtmi			NVARCHAR(6),			--	V币密码
	@Rtmz			INT,					--	面值
	@Rtlx			INT,					--	卡的类型(1:正式卡 2:测试卡 3 :促销卡)
	@Rtoid			NVARCHAR(10),			--	盈华讯方服务器端订单
	@OrderID			NVARCHAR(32),			--	订单号码
	@Rtuserid		NVARCHAR(31),			--	商户的用户ID
	@Rtcustom		NVARCHAR(128),			--	商户自己定义数据
	@Rtflag			INT,					--	返回状态(1:为正常发送回来,2:为补单发送回来)
	@EcryptStr		NVARCHAR(1024),			--	回传字符
	@SignMsg			NVARCHAR(32),			--	签名字符串
	@strErrorDescribe	NVARCHAR(127)	OUTPUT	-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 会员卡类型
DECLARE @CardTypeID INT

-- 执行逻辑
BEGIN	
	
	UPDATE ReturnVBDetailInfo SET
		Rtmd5=@Rtmd5, Rtka=@Rtka, Rtmi=@Rtmi, Rtmz=@Rtmz, Rtlx=@Rtlx, Rtoid=@Rtoid
		, OrderID=@OrderID, Rtuserid=@Rtuserid, Rtcustom=@Rtcustom, Rtflag=@Rtflag, EcryptStr=@EcryptStr, SignMsg=@SignMsg
	WHERE OrderID=@OrderID

	IF @@ROWCOUNT=0
	BEGIN
		INSERT INTO ReturnVBDetailInfo(
			Rtmd5, Rtka, Rtmi, Rtmz, Rtlx, Rtoid
			, OrderID, Rtuserid, Rtcustom, Rtflag, EcryptStr, SignMsg)
		VALUES(@Rtmd5, @Rtka, @Rtmi, @Rtmz, @Rtlx, @Rtoid
			, @OrderID, @Rtuserid, @Rtcustom, @Rtflag, @EcryptStr, @SignMsg)
	END
END
RETURN 0
GO

----------------------------------------------------------------------------------
-- 易宝返回记录
CREATE PROCEDURE NET_PW_AddReturnYBInfo
	@p1_MerId	NVARCHAR(22),			-- 商户编号
	@r0_Cmd		NVARCHAR(40),			-- 业务类型
	@r1_Code	NVARCHAR(2),			-- 支付结果
	@r2_TrxId	NVARCHAR(100),			-- 易宝支付交易流水号
	@r3_Amt		DECIMAL(18,2),			-- 支付金额
	@r4_Cur		NVARCHAR(20),			-- 交易币种
	@r5_Pid		NVARCHAR(40),			-- 商品名称
	@r6_Order	NVARCHAR(64),			-- 商户订单号
	@r7_Uid		NVARCHAR(100),			-- 易宝支付会员ID
	@r8_MP		NVARCHAR(400),			-- 商户扩展信息
	@r9_BType	NCHAR(2),				-- 交易结果返回类型
	@rb_BankId	NVARCHAR(64),			-- 支付通道编码
	@ro_BankOrderId	NVARCHAR(128),		-- 银行订单号
	@rp_PayDate	NVARCHAR(64),			-- 支付成功时间
	@rq_CardNo	NVARCHAR(128),			-- 神州行充值卡序列号
	@ru_Trxtime	NVARCHAR(64),			-- 交易结果通知时间
	@hmac		NCHAR(64)				-- 签名数据
WITH ENCRYPTION AS

-- 执行逻辑
BEGIN	
	IF NOT EXISTS(SELECT * FROM ReturnYPDetailInfo WHERE r6_Order=@r6_Order)
	BEGIN
		INSERT INTO ReturnYPDetailInfo(
			p1_MerId,r0_Cmd,r1_Code,r2_TrxId,r3_Amt,r4_Cur,r5_Pid,r6_Order,r7_Uid,r8_MP,r9_BType,
			rb_BankId,ro_BankOrderId,rp_PayDate,rq_CardNo,ru_Trxtime,hmac)
		VALUES(@p1_MerId,@r0_Cmd,@r1_Code,@r2_TrxId,@r3_Amt,@r4_Cur,@r5_Pid,@r6_Order,@r7_Uid,@r8_MP,@r9_BType,
			@rb_BankId,@ro_BankOrderId,@rp_PayDate,@rq_CardNo,@ru_Trxtime,@hmac)
	END
	ELSE
	BEGIN
		UPDATE ReturnYPDetailInfo SET
			p1_MerId=@p1_MerId,r0_Cmd=@r0_Cmd,r1_Code=@r1_Code,r2_TrxId=@r2_TrxId,r3_Amt=@r3_Amt,r4_Cur=@r4_Cur,
			r5_Pid=@r5_Pid,r7_Uid=@r7_Uid,r8_MP=@r8_MP,r9_BType=@r9_BType,rb_BankId=@rb_BankId,ro_BankOrderId=@ro_BankOrderId,
			rp_PayDate=@rp_PayDate,rq_CardNo=@rq_CardNo,ru_Trxtime=@ru_Trxtime,hmac=@hmac
		WHERE r6_Order=@r6_Order
	END
END
RETURN 0
GO




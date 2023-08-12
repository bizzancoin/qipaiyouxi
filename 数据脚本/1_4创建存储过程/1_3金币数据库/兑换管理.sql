
----------------------------------------------------------------------------------------------------

USE RYTreasureDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_LoadMemberParameter]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_LoadMemberParameter]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_PurchaseMember]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_PurchaseMember]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_ExchangeScoreByIngot]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_ExchangeScoreByIngot]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_ExchangeScoreByBeans]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_ExchangeScoreByBeans]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- 加载会员
CREATE PROC GSP_GR_LoadMemberParameter	
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN
	-- 加载会员
	SELECT MemberName, MemberOrder, MemberPrice, PresentScore FROM MemberType(NOLOCK)

END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

-- 购买会员
CREATE PROC GSP_GR_PurchaseMember

	-- 用户信息
	@dwUserID INT,								-- 用户标识
	@cbMemberOrder INT,							-- 会员标识
	@PurchaseTime INT,							-- 购买时间

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
	DECLARE @CurrMemberOrder SMALLINT	
	SELECT @Nullity=Nullity, @CurrMemberOrder=MemberOrder FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo WHERE UserID=@dwUserID

	-- 用户判断
	IF @CurrMemberOrder IS NULL
	BEGIN
		SET @strNotifyContent=N'您的帐号不存在，请联系客户服务中心了解详细情况！'
		RETURN 1
	END	

	-- 帐号禁止
	IF @Nullity<>0
	BEGIN
		SET @strNotifyContent=N'您的帐号暂时处于冻结状态，请联系客户服务中心了解详细情况！'
		RETURN 2
	END

	-- 变量定义	
	DECLARE @MemberName AS NVARCHAR(16)
	DECLARE @MemberPrice AS DECIMAL(18,2)
	DECLARE @PresentScore AS BIGINT
	DECLARE @MemberRight AS INT	

	-- 读取会员
	SELECT @MemberName=MemberName,@MemberPrice=MemberPrice, @PresentScore=PresentScore,@MemberRight=UserRight	
	FROM MemberType(NOLOCK) WHERE MemberOrder=@cbMemberOrder	

	-- 存在判断
	IF @MemberName IS NULL
	BEGIN
		SET @strNotifyContent=N'抱歉地通知您，您所购买的会员不存在或者正在维护中，请联系客户服务中心了解详细情况！'
		RETURN 4
	END

	-- 费用计算
	DECLARE @ConsumeCurrency DECIMAL(18,2)
	SELECT @ConsumeCurrency=@MemberPrice*@PurchaseTime	

	-- 开始事务
	SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
	BEGIN TRAN

	-- 读取游戏豆
	DECLARE @Currency DECIMAL(18,2)
	SELECT @Currency=Currency FROM UserCurrencyInfo(NOLOCK) WHERE UserID=@dwUserID
	IF @Currency IS NULL Set @Currency=0

	-- 游戏豆判断
	IF @Currency<@ConsumeCurrency
	BEGIN
		-- 结束事务
		ROLLBACK TRAN
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED

		-- 错误信息
		SET @strNotifyContent=N'您身上的游戏豆余额不足，请充值后再次尝试！'
		RETURN 5
	END

	-- 读取游戏币
	DECLARE @Score BIGINT
	SELECT @Score=Score FROM GameScoreInfo(NOLOCK) WHERE UserID=@dwUserID

	-- 插入资料
	IF @Score IS NULL
	BEGIN
		-- 插入资料
		INSERT INTO GameScoreInfo (UserID, LastLogonIP, LastLogonMachine, RegisterIP, RegisterMachine)
		VALUES (@dwUserID, @strClientIP, @strMachineID, @strClientIP, @strMachineID)

		-- 查询游戏币
		SELECT @Score=Score	FROM GameScoreInfo WHERE UserID=@dwUserID
	END	

	-- 赠送计算
	DECLARE @TotalPreSentScore BIGINT
	SELECT @TotalPreSentScore=@PreSentScore*@PurchaseTime		

	-- 兑换日志
	INSERT INTO RecordBuyMember(UserID,MemberOrder,MemberMonths,MemberPrice,Currency,PresentScore,BeforeCurrency,BeforeScore,ClinetIP,InputDate)
	VALUES(@dwUserID,@cbMemberOrder,@PurchaseTime,@MemberPrice,@ConsumeCurrency,@TotalPreSentScore,@Currency,@Score,@strClientIP,GETDATE())
	
	-- 变化日志
	INSERT INTO RecordCurrencyChange(UserID,ChangeCurrency,ChangeType,BeforeCurrency,AfterCurrency,ClinetIP,InputDate,Remark)
	VALUES(@dwUserID,@ConsumeCurrency,10,@Currency,@Currency-@ConsumeCurrency,@strClientIP,GETDATE(),'兑换游戏币')	

	-- 游戏豆扣费
	UPDATE UserCurrencyInfo SET Currency=Currency-@ConsumeCurrency WHERE UserID=@dwUserID

	-- 赠送游戏币
	UPDATE GameScoreInfo SET Score=Score+@TotalPreSentScore WHERE UserID=@dwUserID	

	-- 结束事务
	COMMIT TRAN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
		
	-- 会员资料
	DECLARE @MaxUserRight INT
	DECLARE @MemberValidMonth INT
	DECLARE @MaxMemberOrder TINYINT	 
	DECLARE @MemberOverDate DATETIME
	DECLARE @MemberSwitchDate DATETIME

	-- 有效期限
	SELECT @MemberValidMonth= @PurchaseTime

	-- 删除过期
	DELETE FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsMember
	WHERE UserID=@dwUserID AND MemberOrder=@cbMemberOrder AND MemberOverDate<=GETDATE()

	-- 更新会员
	UPDATE RYAccountsDBLink.RYAccountsDB.dbo.AccountsMember SET MemberOverDate=DATEADD(mm,@MemberValidMonth, MemberOverDate)
	WHERE UserID=@dwUserID AND MemberOrder=@cbMemberOrder
	IF @@ROWCOUNT=0
	BEGIN
		INSERT RYAccountsDBLink.RYAccountsDB.dbo.AccountsMember(UserID,MemberOrder,UserRight,MemberOverDate)
		VALUES (@dwUserID,@cbMemberOrder,@MemberRight,DATEADD(mm,@MemberValidMonth, GETDATE()))
	END

	-- 绑定会员,(会员期限与切换时间)
	SELECT @MaxMemberOrder=MAX(MemberOrder),@MemberOverDate=MAX(MemberOverDate),@MemberSwitchDate=MIN(MemberOverDate)
	FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsMember WHERE UserID=@dwUserID

	-- 会员权限
	SELECT @MaxUserRight=UserRight FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsMember
	WHERE UserID=@dwUserID AND MemberOrder=@MaxMemberOrder
	
	-- 附加会员卡信息
	UPDATE RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo
	SET MemberOrder=@MaxMemberOrder,UserRight=@MaxUserRight,MemberOverDate=@MemberOverDate,MemberSwitchDate=@MemberSwitchDate
	WHERE UserID=@dwUserID

	-- 会员等级
	SELECT @CurrMemberOrder=MemberOrder FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo WHERE UserID=@dwUserID

	-- 查询游戏币
	DECLARE @CurrScore BIGINT
	SELECT @CurrScore=Score FROM GameScoreInfo WHERE UserID=@dwUserID	

	-- 查询游戏豆
	DECLARE @CurrBeans BIGINT
	SELECT @CurrBeans=Currency FROM UserCurrencyInfo WHERE UserID=@dwUserID

	-- 成功提示
	SET @strNotifyContent=N'恭喜您，会员购买成功！' 

	-- 输出记录
	SELECT @CurrMemberOrder AS MemberOrder,@MaxUserRight AS UserRight,@CurrScore AS CurrScore,@CurrBeans AS CurrBeans

END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

-- 兑换游戏币
CREATE PROC GSP_GR_ExchangeScoreByIngot

	-- 用户信息
	@dwUserID INT,								-- 用户标识
	@ExchangeIngot INT,							-- 兑换元宝	

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
	DECLARE @UserIngot INT	
	SELECT @Nullity=Nullity, @UserIngot=UserMedal FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo WHERE UserID=@dwUserID

	-- 用户判断
	IF @UserIngot IS NULL
	BEGIN
		SET @strNotifyContent=N'您的帐号不存在，请联系客户服务中心了解详细情况！'
		RETURN 1
	END	

	-- 帐号禁止
	IF @Nullity<>0
	BEGIN
		SET @strNotifyContent=N'您的帐号暂时处于冻结状态，请联系客户服务中心了解详细情况！'
		RETURN 2
	END

	-- 元宝判断
	IF @UserIngot < @ExchangeIngot
	BEGIN
		SET @strNotifyContent=N'您的元宝不足，请调整好兑换金额后再试！'
		RETURN 3		
	END

	-- 兑换比率
	DECLARE @ExchangeRate INT
	SELECT @ExchangeRate=StatusValue FROM RYAccountsDBLink.RYAccountsDB.dbo.SystemStatusInfo WHERE StatusName=N'MedalExchangeRate'

	-- 系统错误
	IF @ExchangeRate IS NULL
	BEGIN
		SET @strNotifyContent=N'抱歉！元宝兑换失败，请联系客户服务中心了解详细情况。'
		RETURN 4			
	END

	-- 计算游戏币
	DECLARE @ExchangeScore BIGINT
	SET @ExchangeScore = @ExchangeRate*@ExchangeIngot

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
	SET @UserIngot=@UserIngot-@ExchangeIngot
	UPDATE RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo SET UserMedal=@UserIngot WHERE UserID=@dwUserID			

	-- 查询游戏币
	DECLARE @CurrScore BIGINT
	SELECT @CurrScore=Score FROM GameScoreInfo WHERE UserID=@dwUserID

	-- 查询游戏豆
	DECLARE @CurrBeans decimal(18, 2)
	SELECT @CurrBeans=Currency FROM UserCurrencyInfo WHERE UserID=@dwUserID	

	-- 调整游戏豆
	IF @CurrBeans IS NULL SET @CurrBeans=0

	-- 插入记录
	INSERT RYRecordDBLink.RYRecordDB.dbo.RecordConvertUserMedal (UserID, CurInsureScore, CurUserMedal, ConvertUserMedal, ConvertRate, IsGamePlaza, ClientIP, CollectDate)
	VALUES(@dwUserID, @InsureScore, @UserIngot, @ExchangeIngot, @ExchangeRate, 0, @strClientIP, GetDate())

	-- 成功提示
	SET @strNotifyContent=N'恭喜您，游戏币兑换成功！'

	-- 输出记录
	SELECT @UserIngot AS CurrIngot,@CurrScore AS CurrScore,@CurrBeans AS CurrBeans

END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

-- 兑换游戏币
CREATE PROC GSP_GR_ExchangeScoreByBeans

	-- 用户信息
	@dwUserID INT,								-- 用户标识
	@ExchangeBeans decimal(18, 2),				-- 兑换游戏豆	

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
	SELECT @Nullity=Nullity FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo WHERE UserID=@dwUserID

	-- 用户判断
	IF @Nullity IS NULL
	BEGIN
		SET @strNotifyContent=N'您的帐号不存在，请联系客户服务中心了解详细情况！'
		RETURN 1
	END	

	-- 帐号禁止
	IF @Nullity<>0
	BEGIN
		SET @strNotifyContent=N'您的帐号暂时处于冻结状态，请联系客户服务中心了解详细情况！'
		RETURN 2
	END

	-- 读取游戏豆
	DECLARE @UserBeans decimal(18, 2)
	SELECT @UserBeans=Currency FROM UserCurrencyInfo WHERE UserID=@dwUserID	

	-- 调整游戏豆
	IF @UserBeans IS NULL SET @UserBeans=0

	-- 游戏豆判断
	IF @UserBeans < @ExchangeBeans
	BEGIN
		SET @strNotifyContent=N'您的游戏豆不足，请调整好兑换金额后再试！'
		RETURN 3		
	END

	-- 兑换比率
	DECLARE @ExchangeRate INT
	SELECT @ExchangeRate=StatusValue FROM RYAccountsDBLink.RYAccountsDB.dbo.SystemStatusInfo WHERE StatusName=N'RateGold'

	-- 系统错误
	IF @ExchangeRate IS NULL
	BEGIN
		SET @strNotifyContent=N'抱歉！游戏豆兑换失败，请联系客户服务中心了解详细情况。'
		RETURN 4			
	END

	-- 计算游戏币
	DECLARE @ExchangeScore BIGINT
	SET @ExchangeScore=@ExchangeRate*@ExchangeBeans

	-- 更新银行
	UPDATE GameScoreInfo SET Score=Score+@ExchangeScore WHERE UserID=@dwUserID

	-- 插入资料
	IF @@ROWCOUNT=0
	BEGIN

		-- 插入资料
		INSERT INTO GameScoreInfo (UserID, Score, LastLogonIP, LastLogonMachine, RegisterIP, RegisterMachine)
		VALUES (@dwUserID, @ExchangeScore, @strClientIP, @strMachineID, @strClientIP, @strMachineID)		
	END	

	-- 更新游戏豆
	SET @UserBeans=@UserBeans-@ExchangeBeans	
	UPDATE UserCurrencyInfo SET Currency=@UserBeans WHERE UserID=@dwUserID			

	-- 查询游戏币
	DECLARE @CurrScore BIGINT
	SELECT @CurrScore=Score FROM GameScoreInfo WHERE UserID=@dwUserID

	-- 查询元宝
	DECLARE @CurrIngot BIGINT
	SELECT @CurrIngot=UserMedal FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo WHERE UserID=@dwUserID

	-- 变化日志
	INSERT INTO RecordCurrencyChange(UserID,ChangeCurrency,ChangeType,BeforeCurrency,AfterCurrency,ClinetIP,InputDate,Remark)
	VALUES(@dwUserID,@ExchangeBeans,10,@UserBeans+@ExchangeBeans,@UserBeans,@strClientIP,GETDATE(),'兑换游戏币')	

	-- 成功提示
	SET @strNotifyContent=N'恭喜您，游戏币兑换成功！'

	-- 输出记录
	SELECT @CurrIngot AS CurrIngot,@CurrScore AS CurrScore,@UserBeans AS CurrBeans

END

RETURN 0

GO

----------------------------------------------------------------------------------------------------
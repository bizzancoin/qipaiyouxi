----------------------------------------------------------------------
-- 版权：2011
-- 时间：2011-09-1
-- 用途：实卡充值
----------------------------------------------------------------------

USE [RYTreasureDB]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].NET_PW_FilledLivcard') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].NET_PW_FilledLivcard
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------
-- 实卡充值
CREATE PROC NET_PW_FilledLivcard
	@dwOperUserID		INT,						--	操作用户

	@strSerialID		NVARCHAR(32),				--	会员卡号
	@strPassword		NCHAR(32),					--	会员卡密	
	@strAccounts		NVARCHAR(31),				--	充值玩家帐号

	@strClientIP		NVARCHAR(15),				--	充值地址
	@strErrorDescribe	NVARCHAR(127) OUTPUT		--	输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 实卡信息
DECLARE @CardID INT
DECLARE @SerialID NVARCHAR(15)
DECLARE @Password NCHAR(32)
DECLARE @CardTypeID INT
DECLARE @CardPrice DECIMAL(18,2)
DECLARE @Currency INT
DECLARE @Gold INT
DECLARE @ValidDate DATETIME
DECLARE @ApplyDate DATETIME
DECLARE @UseRange INT

-- 帐号资料
DECLARE @Accounts NVARCHAR(31)
DECLARE @GameID INT
DECLARE @UserID INT
DECLARE @SpreaderID INT
DECLARE @Nullity TINYINT
DECLARE @StunDown TINYINT
DECLARE @WebLogonTimes INT
DECLARE @GameLogonTimes INT
DECLARE @BeforeCurrency DECIMAL(18,2)
DECLARE @BeforeGold INT
DECLARE @UserRight INT
DECLARE @MasterRight INT
DECLARE @MasterOrder INT
DECLARE @RegisterIP NVARCHAR(15)
DECLARE @RegisterDate DATETIME
DECLARE @RegisterMachine NVARCHAR(32)

-- 执行逻辑
BEGIN
	DECLARE @ShareID INT
	SET @ShareID=1		-- 1 实卡
	
	-- 卡号查询
	SELECT	@CardID=CardID,@SerialID=SerialID,@Password=[Password],@CardTypeID=CardTypeID,
			@CardPrice=CardPrice,@Currency=Currency,@Gold=Gold,@ValidDate=ValidDate,@ApplyDate=ApplyDate,
			@UseRange=UseRange,@Nullity=Nullity
	FROM LivcardAssociator WHERE SerialID = @strSerialID

	-- 验证卡信息
	IF @CardID IS NULL
	BEGIN
		SET @strErrorDescribe=N'抱歉！您要充值的卡号不存在。如有疑问请联系客服中心。'
		RETURN 101
	END	

	IF @strPassword=N'' OR @strPassword IS NULL OR @Password<>@strPassword
	BEGIN
		SET @strErrorDescribe=N'抱歉！充值失败，请检查卡号或密码是否填写正确。如有疑问请联系客服中心。'
		RETURN 102
	END

	IF @ApplyDate IS NOT NULL
	BEGIN
		SET @strErrorDescribe=N'抱歉！该充值卡已被使用，请换一张再试。如有疑问请联系客服中心。'
		RETURN 103
	END

	IF @Nullity=1
	BEGIN
		SET @strErrorDescribe=N'抱歉！该会员卡已被禁用。'
		RETURN 104
	END

	IF @ValidDate < GETDATE()
	BEGIN
		SET @strErrorDescribe=N'抱歉！该会员卡已经过期。'
		RETURN 105
	END
	
	-- 验证用户
	SELECT @UserID=UserID,@GameID=GameID,@Accounts=Accounts,@Nullity=Nullity,@StunDown=StunDown,@SpreaderID=SpreaderID,
		   @WebLogonTimes=WebLogonTimes,@GameLogonTimes=GameLogonTimes,@UserRight=UserRight,@MasterRight=MasterRight,
		   @MasterOrder=MasterOrder,@RegisterIP=RegisterIP,@RegisterDate=RegisterDate,@RegisterMachine=RegisterMachine 
	FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo
	WHERE Accounts=@strAccounts

	IF @UserID IS NULL
	BEGIN
		SET @strErrorDescribe=N'抱歉！您要充值的用户账号不存在。'
		RETURN 201
	END

	IF @Nullity=1
	BEGIN
		SET @strErrorDescribe=N'抱歉！您要充值的用户账号暂时处于冻结状态，请联系客户服务中心了解详细情况。'
		RETURN 202
	END

	IF @StunDown<>0
	BEGIN
		SET @strErrorDescribe=N'抱歉！您要充值的用户账号使用了安全关闭功能，必须重新开通后才能继续使用。'
		RETURN 203
	END

	-- 实卡使用范围
	-- 新注册用户
	IF @UseRange = 1
	BEGIN
		IF @WebLogonTimes+@GameLogonTimes>1
		BEGIN
			SET @strErrorDescribe=N'抱歉！该会员卡只适合新注册的用户使用。'
			RETURN 301
		END 
	END
	-- 第一次充值用户
	IF @UseRange = 2
	BEGIN
		DECLARE @FILLCOUNT INT
		SELECT @FillCount=COUNT(USERID) FROM ShareDetailInfo WHERE UserID=@UserID
		IF @FillCount>0
		BEGIN
			SET @strErrorDescribe=N'抱歉！该会员卡只适合第一次充值的用户使用。'
			RETURN 302
		END
	END

	-- 充值货币
	SELECT @BeforeCurrency=Currency FROM UserCurrencyInfo WHERE UserID=@UserID
	IF @BeforeCurrency IS NULL
		SET @BeforeCurrency=0

	UPDATE UserCurrencyInfo SET Currency=Currency+@Currency WHERE UserID=@UserID
	IF @@ROWCOUNT=0
	BEGIN
		INSERT UserCurrencyInfo(UserID,Currency) VALUES(@UserID,@Currency)
	END
	--------------------------------------------------------------------------------

	-- 充值游戏币
	SELECT @BeforeGold=InsureScore FROM GameScoreInfo WHERE UserID = @UserID
	IF @BeforeGold IS NULL
		SET @BeforeGold=0
	
	UPDATE GameScoreInfo SET InsureScore = InsureScore + @Gold WHERE UserID = @UserID
	IF @@ROWCOUNT=0
	BEGIN
		INSERT GameScoreInfo(UserID,Score,InsureScore,UserRight,MasterRight,MasterOrder,LastLogonIP,LastLogonDate,LastLogonMachine,RegisterIP,RegisterDate,RegisterMachine) 
		VALUES(@UserID,0,@Gold,@UserRight,@MasterRight,@MasterOrder,@RegisterIP,@RegisterDate,@RegisterMachine,@RegisterIP,@RegisterDate,@RegisterMachine)
	END

	-- 推广系统&代理系统
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
				SET @PayScore=@Currency*@GoldRate + @Gold
				SET @AgentScore=@PayScore*@AgentScale
				SET @AgentDateID=CAST(CAST(GETDATE() AS FLOAT) AS INT)	
				-- 新增分成记录
				INSERT INTO RecordAgentInfo(DateID,UserID,AgentScale,TypeID,PayScore,Score,ChildrenID,CollectIP) VALUES(@AgentDateID,@AgentUserID,@AgentScale,1,@PayScore,@AgentScore,@UserID,@strClientIP)
				-- 代理日统计
				UPDATE StreamAgentPayInfo SET PayAmount=PayAmount+@CardPrice,Currency=Currency+@Currency,PayScore=PayScore+@PayScore,LastCollectDate=GETDATE() WHERE DateID=@AgentDateID AND UserID=@AgentUserID
				IF @@ROWCOUNT=0
				BEGIN
					INSERT INTO StreamAgentPayInfo(DateID,UserID,PayAmount,Currency,PayScore) VALUES(@AgentDateID,@AgentUserID,@CardPrice,@Currency,@PayScore)
				END
			END
		END
		ELSE
		BEGIN
			-- 推广系统
			DECLARE @Rate DECIMAL(18,2)
			DECLARE @GrantScore BIGINT
			DECLARE @Note NVARCHAR(512)
			SELECT @Rate=FillGrantRate FROM GlobalSpreadInfo
			IF @Rate IS NULL
			BEGIN
				SET @Rate=0.1
			END		

			SET @GrantScore = @Currency*@Rate*@GoldRate
			SET @Note = N'充值'+LTRIM(STR(@CardPrice))+'元'
			INSERT INTO RecordSpreadInfo(
				UserID,Score,TypeID,ChildrenID,CollectNote)
			VALUES(@SpreaderID,@GrantScore,3,@UserID,@Note)		
		END
	END

	-- 设置卡已使用
	UPDATE LivcardAssociator SET ApplyDate=GETDATE() WHERE CardID=@CardID

	-- 写卡充值记录
	INSERT INTO ShareDetailInfo(
		OperUserID,ShareID,UserID,GameID,Accounts,SerialID,CardTypeID,OrderAmount,Currency,BeforeCurrency,PayAmount,IPAddress,ApplyDate,Gold,BeforeGold)
	VALUES(@dwOperUserID,@ShareID,@UserID,@GameID,@Accounts,@SerialID,@CardTypeID,@CardPrice,@Currency,@BeforeCurrency,@CardPrice,@strClientIP,GETDATE(),@Gold,@BeforeGold)

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

	SET @strErrorDescribe=N'实卡充值成功。'
END 

RETURN 0
GO




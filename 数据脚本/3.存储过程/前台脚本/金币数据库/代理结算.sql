----------------------------------------------------------------------
-- 版权：2015
-- 时间：2015-12-20
-- 用途：代理结算
----------------------------------------------------------------------

USE [RYTreasureDB]
GO

-- 代理结算
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].NET_PW_AgentBalance') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].NET_PW_AgentBalance
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_NULLS ON
GO

----------------------------------------------------------------------------------------------------------------
-- 代理结算
CREATE PROCEDURE NET_PW_AgentBalance
	@dwUserID			INT,					-- 用户标识

	@dwBalance			INT,					-- 结算金额

	@strClientIP		NVARCHAR(15),			-- 操作地址
	@strErrorDescribe	NVARCHAR(127) OUTPUT	-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 基本信息
DECLARE @UserID				INT
DECLARE @GameID				INT
DECLARE @Accounts			NVARCHAR(31)
DECLARE @SpreaderID			INT

-- 帐号状态
DECLARE @Nullity BIT
DECLARE @StunDown BIT

-- 代理信息
DECLARE @MinBalanceScore BIGINT   -- 最低结算金额

-- 执行逻辑
BEGIN
	-- 用户资料
	SELECT	@UserID=UserID,@GameID=GameID,@Accounts=Accounts,@Nullity=Nullity,@StunDown=StunDown,@SpreaderID=SpreaderID
	FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo
	WHERE UserID=@dwUserID

	-- 查询用户
	IF @UserID IS NULL
	BEGIN
		SET @strErrorDescribe= N'您的帐号不存在或者密码输入有误，请查证后再次尝试登录！'
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

	-- 最小结算金额
	SELECT @MinBalanceScore=StatusValue FROM RYAccountsDBLink.RYAccountsDB.dbo.SystemStatusInfo WHERE StatusName='AgentBalance'
	IF @MinBalanceScore IS NULL
	BEGIN
		SET @MinBalanceScore=200000
	END
	IF @dwBalance < @MinBalanceScore
	BEGIN
		SET @strErrorDescribe=N'非常抱歉,您每笔结算的数目必须大于' + Convert(NVARCHAR(30), @MinBalanceScore) + '金币！'
		RETURN 4
	END

	-- 查询代理余额
	DECLARE @AgentRevenue BIGINT -- 税收分成
	DECLARE @AgentPayInfo BIGINT -- 充值分成
	DECLARE @AgentBalance BIGINT -- 代理余额
	SELECT @AgentRevenue=ISNULL(SUM(AgentRevenue),0) FROM RecordUserRevenue WHERE AgentUserID=@dwUserID
	SELECT @AgentPayInfo=ISNULL(SUM(Score),0) FROM RecordAgentInfo WHERE UserID=@dwUserID
	SET @AgentBalance=@AgentRevenue+@AgentPayInfo
	IF @AgentBalance<0 OR @dwBalance>@AgentBalance
	BEGIN
		SET @strErrorDescribe=N'非常抱歉,您当前结算余额不足!'
		RETURN 5
	END

	-- 查询银行金币
	DECLARE @InsureScore BIGINT
	SELECT @InsureScore=InsureScore FROM GameScoreInfo(NOLOCK) WHERE UserID = @dwUserID
	IF @InsureScore IS NULL
	BEGIN
		SET @InsureScore=0
	END

	-- 结算记录
	INSERT INTO RecordAgentInfo(UserID,TypeID,Score,InsureScore,CollectIP) VALUES(@dwUserID,3,-@dwBalance,@InsureScore,@strClientIP)

	-- 更新银行金币
	UPDATE GameScoreInfo SET InsureScore = InsureScore+@dwBalance
	WHERE UserID = @UserID
	IF @@ROWCOUNT = 0 
	BEGIN
		INSERT INTO GameScoreInfo(UserID,InsureScore,RegisterIP,LastLogonIP)
		VALUES(@UserID,@dwBalance,@strClientIP,@strClientIP)
	END
END
RETURN 0
GO

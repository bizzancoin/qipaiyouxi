----------------------------------------------------------------------
-- 版权：2011
-- 时间：2011-09-1
-- 用途：推广中心
----------------------------------------------------------------------

USE [RYTreasureDB]
GO

-- 获取推广信息
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].NET_PW_GetUserSpreadInfo') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].NET_PW_GetUserSpreadInfo
GO

-- 推广结算
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].NET_PW_SpreadBalance') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].NET_PW_SpreadBalance
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_NULLS ON
GO

----------------------------------------------------------------------------------------------------
-- 获取用户推广信息
CREATE PROCEDURE NET_PW_GetUserSpreadInfo
	@dwUserID			INT,					-- 用户标识
	@strErrorDescribe	NVARCHAR(127) OUTPUT	--输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 基本信息
DECLARE @UserID				INT
DECLARE @GameID				INT
DECLARE @Accounts			NVARCHAR(31)

-- 帐号状态
DECLARE @Nullity BIT
DECLARE @StunDown BIT

-- 财富信息
DECLARE @Score			BIGINT
DECLARE @InsureScore	BIGINT

-- 推广信息
DECLARE @SpreadIn  BIGINT
DECLARE @SpreadOut BIGINT
DECLARE @SpreadBalance BIGINT

-- 执行逻辑
BEGIN
	-- 用户资料
	SELECT	@UserID=UserID,@GameID=GameID,@Accounts=Accounts,@Nullity=Nullity,@StunDown=StunDown
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

	-- 银行信息
	SELECT @Score=Score,@InsureScore=InsureScore FROM GameScoreInfo(NOLOCK) WHERE UserID = @dwUserID
	IF @Score IS NULL
	BEGIN
		SET @Score=0
		SET @InsureScore=0
	END

	-- 推广信息
	SELECT @SpreadIn = SUM(Score) FROM RecordSpreadInfo WHERE UserID=@dwUserID AND Score>0
	IF @SpreadIn IS NULL
	BEGIN
		SET @SpreadIn=0
	END
	
	SELECT @SpreadOut = -SUM(Score) FROM RecordSpreadInfo WHERE UserID=@dwUserID AND Score<0
	IF @SpreadOut IS NULL
	BEGIN
		SET @SpreadOut=0
	END
	SET @SpreadBalance = @SpreadIn-@SpreadOut
	
	-- 输出信息
	SELECT @UserID AS UserID,@SpreadIn AS Score, @SpreadOut AS InsureScore,@SpreadBalance AS RecordID
END
RETURN 0 
GO


----------------------------------------------------------------------------------------------------------------
-- 推广结算
CREATE PROCEDURE NET_PW_SpreadBalance
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

-- 推广信息
DECLARE @SpreadBalance BIGINT     -- 推广余额
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
	SELECT @MinBalanceScore=MinBalanceScore FROM GlobalSpreadInfo
	IF @MinBalanceScore IS NULL
	BEGIN
		SET @MinBalanceScore=200000
	END
	IF @dwBalance < @MinBalanceScore
	BEGIN
		SET @strErrorDescribe=N'非常抱歉,您每笔结算的数目必须大于' + Convert(NVARCHAR(30), @MinBalanceScore) + '金币！'
		RETURN 4
	END

	-- 查询推广余额
	SELECT @SpreadBalance = SUM(Score) FROM RecordSpreadInfo WHERE UserID = @dwUserID
	IF @SpreadBalance IS NULL OR @SpreadBalance<0 OR @dwBalance>@SpreadBalance
	BEGIN
		SET @strErrorDescribe=N'非常抱歉,您当前推广余额不足!'
		RETURN 5
	END

	-- 查询银行金币
	DECLARE @InsureScore BIGINT
	SELECT @InsureScore=InsureScore FROM GameScoreInfo(NOLOCK) WHERE UserID = @UserID
	IF @InsureScore IS NULL
	BEGIN
		SET @InsureScore=0
	END

	-- 结算记录
	INSERT INTO RecordSpreadInfo(
		UserID,Score,TypeID,ChildrenID,InsureScore,CollectNote)
	VALUES(
		@UserID,-@dwBalance,4,0,@InsureScore,N'结算支出，结算地址：'+@strClientIP)

	-- 更新银行金币
	UPDATE GameScoreInfo SET InsureScore = InsureScore+@dwBalance
	WHERE UserID = @UserID
	IF @@ROWCOUNT = 0 
	BEGIN
		INSERT INTO GameScoreInfo(UserID,InsureScore,RegisterIP,LastLogonIP)
		VALUES(@UserID,@dwBalance,@strClientIP,@strClientIP)
	END

	-- 上级提成
	IF @SpreaderID<>0 
	BEGIN
		DECLARE @Rate DECIMAL(18,2)		 -- 上级提成比例
		DECLARE @ParentBanlance  BIGINT  -- 上级提成金额
		DECLARE @Note NVARCHAR(512)		 -- 备注
		SELECT @Rate=BalanceRate FROM GlobalSpreadInfo
		IF @Rate IS NULL
		BEGIN
			SET @Rate=0.1
		END
		SET @ParentBanlance = @dwBalance*@Rate
		SET @Note = N'结算'+LTRIM(STR(@dwBalance))

		INSERT INTO RecordSpreadInfo(UserID,Score,TypeID,ChildrenID,CollectNote)
		VALUES(@SpreaderID,@ParentBanlance,4,@UserID,@Note)
	END

	SET @strErrorDescribe=N'结算成功!'
END
RETURN 0
GO




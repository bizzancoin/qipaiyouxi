----------------------------------------------------------------------------------------------------
-- 版权：2011
-- 时间：2011-09-02
-- 用途：比赛报名
----------------------------------------------------------------------------------------------------
USE RYNativeWebDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].NET_PW_AddGameMatchUser') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].NET_PW_AddGameMatchUser
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------
-- 比赛报名
CREATE PROCEDURE NET_PW_AddGameMatchUser
	@dwMatchID			INT,				-- 比赛标识 
	@strAccounts		NVARCHAR(31),		-- 用户帐号
	@strPassword		NCHAR(32),			-- 用户密码

	@strCompellation	NVARCHAR(16),		-- 用户姓名
	@dwGender			TINYINT,			-- 性别
	@strPassportID		NVARCHAR(32),		-- 身份证
	@strMobilePhone		NVARCHAR(16),		-- 联系电话
	@strEMail			NVARCHAR(32),		-- 电子邮箱
	@strQQ				NVARCHAR(16),		-- QQ
	@strDwellingPlace	NVARCHAR(128),		-- 详细地址
	@strPostalCode		NVARCHAR(8),		-- 邮编

	@strClientIP		NVARCHAR(15),		-- 报名地址
	@strErrorDescribe	NVARCHAR(127) OUTPUT	-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 基本信息
DECLARE @UserID INT
DECLARE @Accounts NVARCHAR(31)
DECLARE @GameID	INT
DECLARE @LogonPass	NCHAR(32)
DECLARE @Nullity BIT
DECLARE @StunDown BIT

-- 比赛信息
DECLARE @MatchID INT
DECLARE @ApplyBeginDate DATETIME
DECLARE @ApplyEndDate DATETIME

-- 执行逻辑
BEGIN
	-- 查询用户
	SELECT @UserID=UserID,@Accounts=Accounts,@GameID=GameID,@LogonPass=LogonPass,@Nullity=Nullity, @StunDown=StunDown
	FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo WHERE Accounts=@strAccounts

	IF @UserID IS NULL
	BEGIN
		SET @strErrorDescribe=N'您的帐号不存在或者密码输入有误，请查证后再次尝试登录！'
		RETURN 100
	END	

	-- 帐号禁止
	IF @Nullity<>0
	BEGIN
		SET @strErrorDescribe=N'您的帐号暂时处于冻结状态，请联系客户服务中心了解详细情况！'
		RETURN 101
	END	

	-- 帐号关闭
	IF @StunDown<>0
	BEGIN
		SET @strErrorDescribe=N'您的帐号使用了安全关闭功能，必须重新开通后才能继续使用！'
		RETURN 102
	END	

	-- 密码判断
	IF @LogonPass<>@strPassword
	BEGIN
		SET @strErrorDescribe=N'您的帐号不存在或者密码输入有误，请查证后再次尝试登录！'
		RETURN 103
	END

	-- 查询比赛
	SELECT @MatchID=MatchID,@ApplyBeginDate=ApplyBeginDate,@ApplyEndDate=ApplyEndDate
	FROM GameMatchInfo WHERE Nullity=0 AND MatchID=@dwMatchID

	IF @MatchID IS NULL
	BEGIN
		SET @strErrorDescribe=N'比赛不存在或被禁止，请联系客户服务中心了解详细情况！'
		RETURN 200
	END

	IF @ApplyBeginDate > GETDATE()
	BEGIN
		SET @strErrorDescribe=N'比赛报名未开始，请查看赛事公告了解详细情况！'
		RETURN 201
	END

	IF @ApplyEndDate < GETDATE()
	BEGIN
		SET @strErrorDescribe=N'比赛报名已截止！'
		RETURN 202
	END

	-- 是否已报名
	IF EXISTS (SELECT UserID FROM GameMatchUserInfo WHERE MatchID=@MatchID AND UserID=@UserID)
	BEGIN
		SET @strErrorDescribe=N'您已报名,不可重复报名！'
		RETURN 300
	END

	-- 新增报名信息
	INSERT INTO GameMatchUserInfo(
		MatchID,UserID,Accounts,GameID,Compellation,Gender,PassportID,MobilePhone,EMail,QQ,DwellingPlace,PostalCode,ClientIP)
	VALUES(
		@MatchID,@UserID,@Accounts,@GameID,@strCompellation,@dwGender,@strPassportID,@strMobilePhone,
		@strEMail,@strQQ,@strDwellingPlace,@strPostalCode,@strClientIP)

	SET @strErrorDescribe=N'报名成功！'
END
RETURN 0
GO
----------------------------------------------------------------------------------------------------
-- 版权：2011
-- 时间：2011-08-31
-- 用途：获取用户信息
----------------------------------------------------------------------------------------------------

USE RYAccountsDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].NET_PW_GetUserBaseInfo') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].NET_PW_GetUserBaseInfo

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].NET_PW_GetUserContactInfo') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].NET_PW_GetUserContactInfo
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_NULLS ON
GO

----------------------------------------------------------------------------------------------------

-- 获取用户基本资料
CREATE  PROCEDURE NET_PW_GetUserBaseInfo
	@dwUserID INT,                            		-- 用户ID	
	@strErrorDescribe NVARCHAR(127) OUTPUT			-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 帐号信息
DECLARE @UserID INT
DECLARE @Account NVARCHAR(31)
DECLARE @NikeName NVARCHAR(31)	
DECLARE @GameID	INT
DECLARE @UserMedal INT

-- 用户资料
DECLARE @Gender TINYINT
DECLARE @UnderWrite NVARCHAR(63)

-- 帐号状态
DECLARE @Nullity BIT
DECLARE @StunDown BIT
DECLARE @AgentID INT

-- 执行逻辑
BEGIN
	-- 用户资料
	SELECT	@UserID=UserID,
		@Account=Accounts,
		@UserMedal = UserMedal,
		@NikeName = Nickname,
		@GameID=GameID,
		@Gender=Gender,
		@UnderWrite=UnderWrite,		
		@Nullity=Nullity,
		@StunDown=StunDown,
		@AgentID=AgentID
	FROM AccountsInfo (NOLOCK) WHERE UserID=@dwUserID
	
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
	
	-- 输出变量
	SELECT	@UserID AS UserID, 
			@Account AS Accounts,
			@NikeName as Nickname,
			@GameID AS GameID,
			@Gender AS Gender,
			@UnderWrite as UnderWrite,
			@UserMedal AS UserMedal,
			@AgentID AS AgentID
END

RETURN 0

GO


--------------------------------------------------------------------------------
-- 获取用户扩展资料
CREATE  PROCEDURE NET_PW_GetUserContactInfo
	@dwUserID INT,                            		-- 用户ID	
	@strErrorDescribe NVARCHAR(127) OUTPUT			-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 帐号信息
DECLARE @UserID INT
DECLARE @Account NVARCHAR(31)
DECLARE @NikeName NVARCHAR(31)	
DECLARE @GameID	INT



-- 详细资料
DECLARE @Compellation NVARCHAR(16)
DECLARE @QQ NVARCHAR(16)
DECLARE @Email NVARCHAR(32)
DECLARE @SeatPhone NVARCHAR(32)
DECLARE @MobilePhone NVARCHAR(16)
DECLARE @DwellingPlace NVARCHAR(128)
DECLARE @UserNote NVARCHAR(256)

-- 帐号状态
DECLARE @Nullity BIT
DECLARE @StunDown BIT

-- 执行逻辑
BEGIN
	-- 用户资料
	SELECT	@UserID=UserID,
		@Account=Accounts,
		@NikeName = Nickname,
		@GameID=GameID,	
		@Nullity=Nullity,
		@StunDown=StunDown
	FROM AccountsInfo (NOLOCK) WHERE UserID=@dwUserID
	
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
	
	-- 详细资料
	SELECT  @QQ=QQ,
			@Email=EMail,
			@MobilePhone=MobilePhone,
			@SeatPhone=SeatPhone,
			@DwellingPlace=DwellingPlace,				
			@UserNote=UserNote
	FROM IndividualDatum (NOLOCK) WHERE UserID = @dwUserID
	
	-- 输出变量
	SELECT	@QQ AS QQ,
			@Email AS Email,
			@MobilePhone AS MobilePhone,
			@SeatPhone AS SeatPhone,
			@DwellingPlace AS DwellingPlace,				
			@UserNote As UserNote	

END

RETURN 0

GO
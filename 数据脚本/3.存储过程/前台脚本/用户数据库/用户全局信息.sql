----------------------------------------------------------------------------------------------------
-- 版权：2011
-- 时间：2011-08-31
-- 用途：获取用户全局信息
----------------------------------------------------------------------------------------------------

USE RYAccountsDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].NET_PW_GetUserGlobalsInfo') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].NET_PW_GetUserGlobalsInfo
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_NULLS ON
GO

----------------------------------------------------------------------------------------------------
-- 获取用户资料
CREATE  PROCEDURE NET_PW_GetUserGlobalsInfo
	@dwUserID			INT,					-- 用户标识
	@dwGameID			INT,					-- 游戏号码
	@strAccounts		NVARCHAR(31),			-- 用户账号
	@strErrorDescribe	NVARCHAR(127) OUTPUT	-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 基本信息
DECLARE @UserID				INT
DECLARE @GameID				INT
DECLARE @Accounts			NVARCHAR(31)
DECLARE @NikeName			NVARCHAR(31)

-- 扩展信息
DECLARE @FaceID				SMALLINT
DECLARE @CustomID			INT
DECLARE @Gender				TINYINT
DECLARE @Experience			INT
DECLARE @Present			INT
DECLARE @LoveLiness			INT
DECLARE @UserMedal			INT
DECLARE @UserRight			INT
DECLARE @ServiceRight		INT
DECLARE @MasterOrder		INT
DECLARE @MemberOrder		TINYINT
DECLARE @MemberOverDate		DATETIME
DECLARE @MemberSwitchDate	DATETIME
DECLARE @UnderWrite			NVARCHAR(63)
DECLARE @Compellation		NVARCHAR(50)

-- 安全信息
DECLARE @ProtectID			INT
DECLARE @LogonPass			NVARCHAR(32)
DECLARE @DynamicPass		NVARCHAR(32)
DECLARE @DynamicPassTime	DATETIME
DECLARE @StunDown			TINYINT
DECLARE @MoorMachine		TINYINT
DECLARE @Nullity			TINYINT

-- 登录信息
DECLARE @LastLogonIP		NVARCHAR(15)
DECLARE @LastLogonDate		DATETIME

-- 执行逻辑
BEGIN
	-- 查询用户
	IF @dwUserID <= 0 AND @dwGameID <= 0
	BEGIN
		-- 用户账号
		SELECT	@UserID=UserID,@GameID=GameID,@Accounts=Accounts,@NikeName=Nickname,@Compellation=Compellation,
				@FaceID=FaceID,@CustomID=CustomID,@Gender=Gender,@Experience=Experience,@Present=Present,@LoveLiness=LoveLiness,@UserMedal=UserMedal,
				@UserRight=UserRight,@ServiceRight=ServiceRight,@MasterOrder=MasterOrder,@MemberOrder=MemberOrder,
				@MemberOverDate=MemberOverDate,@MemberSwitchDate=MemberSwitchDate,@UnderWrite=UnderWrite,
				@ProtectID=ProtectID,@LogonPass=LogonPass,@DynamicPass=DynamicPass,@DynamicPassTime=DynamicPassTime,@StunDown=StunDown,@MoorMachine=MoorMachine,
				@Nullity=Nullity,@LastLogonIP=LastLogonIP,@LastLogonDate=LastLogonDate
		FROM AccountsInfo(NOLOCK) WHERE Accounts=@strAccounts
	END
	ELSE
	BEGIN
		-- 用户标识
		IF  @dwUserID > 0
		BEGIN	
			SELECT	@UserID=UserID,@GameID=GameID,@Accounts=Accounts,@NikeName=Nickname,@Compellation=Compellation,
					@FaceID=FaceID,@CustomID=CustomID,@Gender=Gender,@Experience=Experience,@Present=Present,@LoveLiness=LoveLiness,@UserMedal=UserMedal,
					@UserRight=UserRight,@ServiceRight=ServiceRight,@MasterOrder=MasterOrder,@MemberOrder=MemberOrder,
					@MemberOverDate=MemberOverDate,@MemberSwitchDate=MemberSwitchDate,@UnderWrite=UnderWrite,
					@ProtectID=ProtectID,@LogonPass=LogonPass,@DynamicPass=DynamicPass,@DynamicPassTime=DynamicPassTime,@StunDown=StunDown,@MoorMachine=MoorMachine,@Nullity=Nullity,
					@LastLogonIP=LastLogonIP,@LastLogonDate=LastLogonDate
			FROM AccountsInfo(NOLOCK) WHERE UserID=@dwUserID
		END
		ELSE
		BEGIN
			-- 游戏标识
			SELECT	@UserID=UserID,@GameID=GameID,@Accounts=Accounts,@NikeName=Nickname,@Compellation=Compellation,
					@FaceID=FaceID,@CustomID=CustomID,@Gender=Gender,@Experience=Experience,@Present=Present,@LoveLiness=LoveLiness,@UserMedal=UserMedal,
					@UserRight=UserRight,@ServiceRight=ServiceRight,@MasterOrder=MasterOrder,@MemberOrder=MemberOrder,
					@MemberOverDate=MemberOverDate,@MemberSwitchDate=MemberSwitchDate,@UnderWrite=UnderWrite,
					@ProtectID=ProtectID,@LogonPass=LogonPass,@DynamicPass=DynamicPass,@DynamicPassTime=DynamicPassTime,@StunDown=StunDown,@MoorMachine=MoorMachine,@Nullity=Nullity,
					@LastLogonIP=LastLogonIP,@LastLogonDate=LastLogonDate
			FROM AccountsInfo(NOLOCK) WHERE GameID=@dwGameID
		END
	END
	
	-- 用户存在
	IF @UserID IS NULL
	BEGIN
		SET @strErrorDescribe = N'您的帐号不存在或者密码输入有误，请查证后再次尝试登录！'
		RETURN 1
	END	

	-- 帐号禁止
	IF @Nullity<>0
	BEGIN
		SET @strErrorDescribe=N'您的帐号暂时处于冻结状态，请联系客户服务中心了解详细情况！'
		RETURN 2
	END			

	-- 会员等级
	IF GETDATE()>@MemberOverDate SET @MemberOrder=0
	
	-- 输出变量
	SELECT @UserID AS UserID,@GameID AS GameID,@Accounts AS Accounts,@NikeName AS NickName,@Compellation AS Compellation,
	@FaceID AS FaceID,@CustomID AS CustomID,@Gender AS Gender,@Experience AS Experience,@Present AS Present,@LoveLiness AS LoveLiness, @UserMedal AS UserMedal,
	@UserRight AS UserRight,@ServiceRight AS ServiceRight,@MasterOrder AS MasterOrder,@MemberOrder AS MemberOrder,
	@MemberOverDate AS MemberOverDate,@MemberSwitchDate AS MemberSwitchDate,@UnderWrite AS UnderWrite,
	@ProtectID AS ProtectID,@LogonPass AS LogonPass,@DynamicPass AS DynamicPass,@DynamicPassTime AS DynamicPassTime,@StunDown AS StunDown,@MoorMachine AS MoorMachine,
	@Nullity AS Nullity,@LastLogonIP AS LastLogonIP,@LastLogonDate AS LastLogonDate

END

SET NOCOUNT OFF

RETURN 0

GO

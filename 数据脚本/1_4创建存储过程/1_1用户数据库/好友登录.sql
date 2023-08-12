
----------------------------------------------------------------------------------------------------

USE RYAccountsDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_EfficacyAccountsChat]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_EfficacyAccountsChat]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_LoadUserGroups]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_LoadUserGroups]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_LoadUserFriends]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_LoadUserFriends]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_LoadFriendRemarks]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_LoadFriendRemarks]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- 帐号登录
CREATE PROC GSP_GP_EfficacyAccountsChat
	@dwUserID INT,								-- 用户标识
	@strPassword NCHAR(33),						-- 用户密码
	@strClientIP nvarchar(15),	                -- 连接地址
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 基本信息
DECLARE @UserID INT
DECLARE @GameID INT
DECLARE @NickName NVARCHAR(31)
DECLARE @FaceID INT
DECLARE @CustomID INT
DECLARE @Gender TINYINT
DECLARE @MemberOrder INT
DECLARE @GrowLevel INT
DECLARE @UnderWrite NVARCHAR(32)
DECLARE @Compellation NVARCHAR(16)

--用户资料
DECLARE @QQ NVARCHAR(16)
DECLARE @EMail NVARCHAR(16)
DECLARE @SeatPhone NVARCHAR(32)
DECLARE @MobilePhone NVARCHAR(16)
DECLARE @DwellingPlace NVARCHAR(128)
DECLARE @PostalCode NVARCHAR(8)

-- 执行逻辑
BEGIN

	SET @GameID = 0
	SET @UnderWrite=N''
	SET @Compellation=N''
    SET @QQ =N''
    SET @EMail =N''
    SET @SeatPhone =N''
    SET @MobilePhone =N''
    SET @DwellingPlace =N''
    SET @PostalCode =N''

	-- 查询用户
	DECLARE @Nullity TINYINT
	DECLARE @LogonPass AS NCHAR(32)
	SELECT @UserID= UserID ,@GameID=GameID,@NickName = NickName, @LogonPass= LogonPass , @FaceID=  FaceID,@CustomID= CustomID,@Gender=Gender,
	@MemberOrder =MemberOrder,@GrowLevel=GrowLevelID,@UnderWrite=UnderWrite,@Compellation =Compellation FROM AccountsInfo(NOLOCK) WHERE UserID=@dwUserID

	-- 查询用户
	IF @UserID IS NULL
	BEGIN
		SET @strErrorDescribe=N'您的帐号不存在或者密码输入有误，请查证后再次尝试登录！'
		RETURN 1
	END	

	-- 帐号禁止
	IF @Nullity<>0
	BEGIN
		SET @strErrorDescribe=N'您的帐号暂时处于冻结状态，请联系客户服务中心了解详细情况！'
		RETURN 2
	END	

	-- 密码判断
	IF @LogonPass<>@strPassword
	BEGIN
		SET @strErrorDescribe=N'您的帐号不存在或者密码输入有误，请查证后再次尝试登录！'
		RETURN 3
	END
	SELECT @QQ = QQ,@EMail = EMail,@SeatPhone = SeatPhone,@MobilePhone = MobilePhone,@DwellingPlace = DwellingPlace ,
	@PostalCode =PostalCode FROM IndividualDatum(NOLOCK)WHERE UserID=@dwUserID
	
	-- 输出变量
	SELECT @UserID AS UserID,@GameID AS GameID, @NickName AS NickName, @FaceID AS FaceID, @CustomID AS CustomID, @Gender AS Gender, @MemberOrder AS MemberOrder,
	@UnderWrite AS UnderWrite,@Compellation AS Compellation,@QQ AS QQ, @EMail AS EMail, @SeatPhone AS SeatPhone, @MobilePhone AS MobilePhone,
	@DwellingPlace AS DwellingPlace,@PostalCode AS PostalCode,@GrowLevel AS GrowLevel

END

RETURN 0

GO
----------------------------------------------------------------------------------------------------

-- 加载分组
CREATE PROC GSP_GP_LoadUserGroups
	@dwUserID INT,								-- 用户标识
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN 
	-- 更新信息
	SELECT GroupID,GroupName FROM AccountsGroup WHERE UserID=@dwUserID ORDER BY GroupID
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

-- 加载好友
CREATE PROC GSP_GP_LoadUserFriends
	@dwUserID INT,								-- 用户标识
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN 

	-- 查询信息
	SELECT a.UserID,a.GameID,a.NickName,a.FaceID,a.CustomID,a.Gender,a.MemberOrder,a.GrowLevelID AS GrowLevel,ISNULL(a.UnderWrite,N'') AS UnderWrite,ISNULL(a.Compellation,N'') AS Compellation,
	b.GroupID,ISNULL(c.QQ,N'') AS QQ,ISNULL(c.EMail,N'') AS EMail,ISNULL(c.SeatPhone,N'')  AS SeatPhone,ISNULL(c.MobilePhone,N'')AS MobilePhone,
	ISNULL(c.DwellingPlace,N'') AS DwellingPlace,ISNULL(c.PostalCode,N'')   AS PostalCode
	FROM AccountsInfo a 
	INNER JOIN AccountsRelation b ON b.MainUserID=@dwUserID	AND b.SubUserID=a.UserID 
	LEFT OUTER JOIN IndividualDatum c ON c.UserID=a.UserID ORDER BY a.UserID
END

GO

----------------------------------------------------------------------------------------------------

-- 加载好友
CREATE PROC GSP_GP_LoadFriendRemarks
	@dwUserID INT,								-- 用户标识
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN 
	
	DECLARE @UserNote NVARCHAR(256)
	SET @UserNote = ''
	-- 查询信息
	SELECT @UserNote= UserNote FROM IndividualDatum WHERE UserID=@dwUserID
	SELECT @dwUserID AS UserID,@UserNote AS UserNote

END

GO




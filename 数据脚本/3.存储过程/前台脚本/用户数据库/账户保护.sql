----------------------------------------------------------------------------------------------------
-- 版权：2011
-- 时间：2011-08-31
-- 用途：账户保护
----------------------------------------------------------------------------------------------------

USE RYAccountsDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].NET_PW_AddAccountProtect') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].NET_PW_AddAccountProtect
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].NET_PW_ModifyAccountProtect') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].NET_PW_ModifyAccountProtect
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].NET_PW_GetAccountProtectByUserID') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].NET_PW_GetAccountProtectByUserID
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].NET_PW_GetAccountProtectByAccounts') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].NET_PW_GetAccountProtectByAccounts
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].NET_PW_GetAccountProtectByGameID') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].NET_PW_GetAccountProtectByGameID
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].NET_PW_ConfirmAccountProtect') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].NET_PW_ConfirmAccountProtect
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON
GO

----------------------------------------------------------------------------------------------------

-- 申请密码保护
CREATE PROCEDURE NET_PW_AddAccountProtect
	@dwUserID INT,								-- 用户 I D

	@strQuestion1 NVARCHAR(32),					-- 问题一
	@strResponse1 NVARCHAR(32),					-- 答案一
	@strQuestion2 NVARCHAR(32),					-- 问题二
	@strResponse2 NVARCHAR(32),					-- 答案二
	@strQuestion3 NVARCHAR(32),					-- 问题三
	@strResponse3 NVARCHAR(32),					-- 答案三

	@strPassportID NVARCHAR(32),				-- 证件号码
	@dwPassportType TINYINT,					-- 证件类型
	@strSafeEmail NVARCHAR(32),					-- 邮箱号码

	@strClientIP NVARCHAR(15),					-- 连接地址
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN
	-- 查询用户
	DECLARE @UserID INT
	DECLARE @StunDown BIT
	DECLARE @Nullity BIT
	DECLARE @ProtectID INT
	DECLARE @LogonPass NCHAR(32)
	SELECT @UserID=UserID, @ProtectID=ProtectID, @LogonPass=LogonPass, @Nullity=Nullity, @StunDown=StunDown
	FROM AccountsInfo(NOLOCK) WHERE UserID=@dwUserID

	-- 查询用户
	IF @UserID IS NULL 
	BEGIN
		SET @strErrorDescribe=N'您的帐号不存在或者密码输入有误，请查证后再次尝试！'
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

	-- 密保效验
	IF @ProtectID<>0
	BEGIN
		SET @strErrorDescribe=N'您的帐号已经申请了“帐号保护”功能，无法再次申请“帐号保护”！'
		RETURN 4
	END

	-- 密码保护
	INSERT INTO AccountsProtect(UserID,Question1,Response1,Question2,Response2,Question3,Response3,
		PassportID,PassportType,SafeEmail,CreateIP,ModifyIP)
	VALUES(@UserID,@strQuestion1,@strResponse1,@strQuestion2,@strResponse2,@strQuestion3,@strResponse3,
		@strPassportID,@dwPassportType,@strSafeEmail,@strClientIP,@strClientIP)

	-- 设置用户
	IF @@ERROR=0 
	BEGIN
		UPDATE AccountsInfo SET ProtectID=@@IDENTITY WHERE UserID = @dwUserID
		SET @strErrorDescribe=N'恭喜您，“帐号保护”功能申请成功了，请紧记您的“帐号保护”内容！'
		RETURN 0
	END
	ELSE
	BEGIN
		SET @strErrorDescribe=N'“帐号保护”功能申请失败了，请联系客户服务中心了解详细情况！'
		RETURN 5
	END
END

SET NOCOUNT OFF
RETURN 0

GO

----------------------------------------------------------------------------------------------------

-- 更新密码保护
CREATE PROCEDURE NET_PW_ModifyAccountProtect
	@dwUserID INT,								-- 用户 I D

	@strQuestion1 NVARCHAR(32),					-- 问题一
	@strResponse1 NVARCHAR(32),					-- 答案一
	@strQuestion2 NVARCHAR(32),					-- 问题二
	@strResponse2 NVARCHAR(32),					-- 答案二
	@strQuestion3 NVARCHAR(32),					-- 问题三
	@strResponse3 NVARCHAR(32),					-- 答案三

	@strSafeEmail NVARCHAR(32),					-- 邮箱号码

	@strClientIP NVARCHAR(15),					-- 连接地址
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN
	-- 查询用户
	DECLARE @UserID INT
	DECLARE @StunDown BIT
	DECLARE @Nullity BIT
	DECLARE @ProtectID INT
	DECLARE @LogonPass NCHAR(32)
	SELECT @UserID=UserID, @ProtectID=ProtectID, @LogonPass=LogonPass, @Nullity=Nullity, @StunDown=StunDown
	FROM AccountsInfo(NOLOCK) WHERE UserID=@dwUserID

	-- 查询用户与密码判断
	IF @UserID IS NULL 
	BEGIN
		SET @strErrorDescribe=N'您的帐号不存在或者密码输入有误，请查证后再次尝试！'
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

	-- 密保效验
	IF @ProtectID=0
	BEGIN
		SET @strErrorDescribe=N'您的帐号还没有申请“帐号保护”功能，无法修改“帐号保护”资料！'
		RETURN 4
	END

	-- 密码保护
	UPDATE AccountsProtect SET Question1 = @strQuestion1,Response1 = @strResponse1,Question2 = @strQuestion2,
		Response2 = @strResponse2,Question3 = @strQuestion3,Response3 = @strResponse3,SafeEmail = @strSafeEmail,		
		ModifyIP = @strClientIP,ModifyDate = getdate()
	WHERE UserID = @dwUserID
	
	-- 设置信息
	SET @strErrorDescribe=N'恭喜您，“帐号保护”资料修改成功了，请紧记您的“帐号保护”内容！'
	RETURN 0
END

SET NOCOUNT OFF
RETURN 0

GO

----------------------------------------------------------------------------------------------------

-- 获取密保问题
CREATE PROCEDURE NET_PW_GetAccountProtectByUserID
	@dwUserID			INT,						-- 用户标识
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 基本信息
DECLARE @UserID			INT
DECLARE @ProtectID		INT
DECLARE @Nullity		TINYINT
DECLARE @StunDown		TINYINT

-- 保护信息
DECLARE @PassportType	TINYINT
DECLARE @Question1		NVARCHAR(32)
DECLARE @Question2		NVARCHAR(32)
DECLARE @Question3		NVARCHAR(32)

-- 执行逻辑
BEGIN	
	-- 查询用户	
	SELECT @UserID=UserID, @ProtectID=ProtectID, @Nullity=Nullity,@StunDown=StunDown
	FROM AccountsInfo(NOLOCK) WHERE UserID=@dwUserID

	-- 用户存在
	IF @UserID IS NULL
	BEGIN
		SET @strErrorDescribe=N'您的帐号不存在或者密码输入有误，请查证后再次尝试！'
		RETURN 1
	END	

	-- 帐号禁止
	IF @Nullity<>0
	BEGIN
		SET @strErrorDescribe=N'您的帐号暂时处于冻结状态，请联系客服中心了解详细情况！'
		RETURN 2
	END	

	-- 帐号关闭
	IF @StunDown<>0
	BEGIN
		SET @strErrorDescribe=N'您的帐号使用了安全关闭功能，必须重新开通后才能继续使用！'
		RETURN 3
	END	
	
	-- 密保效验
	IF @ProtectID=0
	BEGIN
		SET @strErrorDescribe=N'抱歉，您的帐号还没有申请“帐号保护”功能！'
		RETURN 4
	END	

	-- 密码保护
	DECLARE @TmpProtectID INT
	SELECT @TmpProtectID=ProtectID, @PassportType=PassportType, @Question1=Question1
		, @Question2=Question2, @Question3=Question3
	FROM AccountsProtect(NOLOCK) WHERE UserID=@dwUserID

	-- 密保效验
	IF @TmpProtectID IS NULL
	BEGIN
		SET @strErrorDescribe=N'抱歉，您的帐号还没有申请了“帐号保护”功能！'
		RETURN 5
	END

	-- 变量输出
	SELECT @UserID AS UserID, @TmpProtectID AS ProtectID, @PassportType AS PassportType
		, @Question1 AS Question1, @Question2 AS Question2, @Question3 AS Question3
END

SET NOCOUNT OFF

RETURN 0
GO

----------------------------------------------------------------------------------------------------

-- 获取密保问题
CREATE PROCEDURE NET_PW_GetAccountProtectByAccounts
	@strAccounts	NVARCHAR(31),						-- 用户帐号
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 基本信息
DECLARE @UserID			INT
DECLARE @ProtectID		INT
DECLARE @Nullity		TINYINT
DECLARE @StunDown		TINYINT

-- 保护信息
DECLARE @PassportType	TINYINT
DECLARE @Question1		NVARCHAR(32)
DECLARE @Question2		NVARCHAR(32)
DECLARE @Question3		NVARCHAR(32)

-- 执行逻辑
BEGIN	
	-- 查询用户	
	SELECT @UserID=UserID, @ProtectID=ProtectID, @Nullity=Nullity,@StunDown=StunDown
	FROM AccountsInfo(NOLOCK) WHERE Accounts=@strAccounts

	-- 用户存在
	IF @UserID IS NULL
	BEGIN
		SET @strErrorDescribe=N'您的帐号不存在，请查证后再次尝试！'
		RETURN 1
	END	

	-- 帐号禁止
	IF @Nullity<>0
	BEGIN
		SET @strErrorDescribe=N'您的帐号暂时已冻结！'
		RETURN 2
	END	

	-- 帐号关闭
	IF @StunDown<>0
	BEGIN
		SET @strErrorDescribe=N'您的帐号使用了安全关闭功能！'
		RETURN 3
	END	
	
	-- 密保效验
	IF @ProtectID=0
	BEGIN
		SET @strErrorDescribe=N'抱歉，您的帐号还没有申请“帐号保护”功能！'
		RETURN 4
	END	

	-- 密码保护
	DECLARE @TmpProtectID INT
	SELECT @TmpProtectID=ProtectID, @PassportType=PassportType, @Question1=Question1
		, @Question2=Question2, @Question3=Question3
	FROM AccountsProtect(NOLOCK) WHERE UserID=@UserID

	-- 密保效验
	IF @TmpProtectID IS NULL
	BEGIN
		SET @strErrorDescribe=N'抱歉，您的帐号还没有申请“帐号保护”功能！'
		RETURN 5
	END

	-- 变量输出
	SELECT @UserID AS UserID, @TmpProtectID AS ProtectID, @PassportType AS PassportType
		, @Question1 AS Question1, @Question2 AS Question2, @Question3 AS Question3
END

SET NOCOUNT OFF

RETURN 0
GO

----------------------------------------------------------------------------------------------------

-- 获取密保问题
CREATE PROCEDURE NET_PW_GetAccountProtectByGameID
	@dwGameID			INT,						-- 游戏 I D	
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 基本信息
DECLARE @UserID			INT
DECLARE @ProtectID		INT
DECLARE @Nullity		TINYINT
DECLARE @StunDown		TINYINT

-- 保护信息
DECLARE @PassportType	TINYINT
DECLARE @Question1		NVARCHAR(32)
DECLARE @Question2		NVARCHAR(32)
DECLARE @Question3		NVARCHAR(32)

-- 执行逻辑
BEGIN	
	-- 查询用户	
	SELECT @UserID=UserID, @ProtectID=ProtectID, @Nullity=Nullity,@StunDown=StunDown
	FROM AccountsInfo(NOLOCK) WHERE GameID=@dwGameID

	-- 用户存在
	IF @UserID IS NULL
	BEGIN
		SET @strErrorDescribe=N'您的帐号不存在！'
		RETURN 1
	END	

	-- 帐号禁止
	IF @Nullity<>0
	BEGIN
		SET @strErrorDescribe=N'您的帐号暂时已冻结状态！'
		RETURN 2
	END	

	-- 帐号关闭
	IF @StunDown<>0
	BEGIN
		SET @strErrorDescribe=N'您的帐号使用了安全关闭功能！'
		RETURN 3
	END	
	
	-- 密保效验
	IF @ProtectID=0
	BEGIN
		SET @strErrorDescribe=N'抱歉，您的帐号还没有申请“帐号保护”功能！'
		RETURN 4
	END	

	-- 密码保护
	DECLARE @TmpProtectID INT
	SELECT @TmpProtectID=ProtectID, @PassportType=PassportType, @Question1=Question1
		, @Question2=Question2, @Question3=Question3
	FROM AccountsProtect(NOLOCK) WHERE UserID=@UserID

	-- 密保效验
	IF @TmpProtectID IS NULL
	BEGIN
		SET @strErrorDescribe=N'抱歉，您的帐号还没有申请“帐号保护”功能！'
		RETURN 5
	END

	-- 变量输出
	SELECT @UserID AS UserID, @TmpProtectID AS ProtectID, @PassportType AS PassportType
		, @Question1 AS Question1, @Question2 AS Question2, @Question3 AS Question3
END

SET NOCOUNT OFF

RETURN 0
GO

----------------------------------------------------------------------------------------------------
CREATE PROCEDURE NET_PW_ConfirmAccountProtect
	@dwUserID			INT,                   		-- 用户标识	

	@strResponse1		NVARCHAR(32),             	-- 提示答案1
	@strResponse2		NVARCHAR(32),             	-- 提示答案2
	@strResponse3		NVARCHAR(32),             	-- 提示答案3

	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 基本信息
DECLARE @UserID			INT
DECLARE @Nullity		TINYINT
DECLARE @StunDown		TINYINT

-- 密保信息
DECLARE @ProtectID		INT
DECLARE @Response1		NVARCHAR(32)
DECLARE @Response2		NVARCHAR(32)
DECLARE @Response3		NVARCHAR(32)

-- 执行逻辑
BEGIN	
	-- 查询用户	
	SELECT @UserID=UserID, @ProtectID=ProtectID, @Nullity=Nullity,@StunDown=StunDown
	FROM AccountsInfo(NOLOCK) WHERE UserID=@dwUserID

	-- 用户存在
	IF @UserID IS NULL
	BEGIN
		SET @strErrorDescribe=N'您的帐号不存在或者密码输入有误，请查证后再次尝试！'
		RETURN 1
	END	

	-- 帐号禁止
	IF @Nullity<>0
	BEGIN
		SET @strErrorDescribe=N'您的帐号暂时处于冻结状态，请联系客服中心了解详细情况！'
		RETURN 2
	END	

	-- 帐号关闭
	IF @StunDown<>0
	BEGIN
		SET @strErrorDescribe=N'您的帐号使用了安全关闭功能，必须重新开通后才能继续使用！'
		RETURN 3
	END	
	
	-- 密保效验
	IF @ProtectID=0
	BEGIN
		SET @strErrorDescribe=N'抱歉，您的帐号还没有申请了“帐号保护”功能！'
		RETURN 4
	END	

	-- 读取密保
	DECLARE @TmpProtectID INT
	SELECT @TmpProtectID=ProtectID, @Response1=Response1,@Response2=Response2,@Response3=Response3
	FROM AccountsProtect(NOLOCK) WHERE ProtectID=@ProtectID AND UserID=@dwUserID

	-- 密保效验
	IF @TmpProtectID IS NULL
	BEGIN
		SET @strErrorDescribe=N'抱歉，您的帐号还没有申请“帐号保护”功能！'
		RETURN 5		
	END
	
	-- 答案无效
	IF ((@strResponse1 IS NULL OR @strResponse1=N'') OR
		(@strResponse2 IS NULL OR @strResponse2=N'') OR
		(@strResponse3 IS NULL OR @strResponse3=N''))
	BEGIN
		SET @strErrorDescribe=N'您的密码保护答案输入有误，请查证后再次尝试！'
		RETURN 6	
	END

	-- 答案效验一
	IF @strResponse1 IS NOT NULL AND @strResponse1<>N''
	BEGIN
		IF @strResponse1<>@Response1
		BEGIN
			SET @strErrorDescribe=N'您的密码保护答案输入有误，请查证后再次尝试！'
			RETURN 7	
		END
	END

	-- 答案效验二
	IF @strResponse2 IS NOT NULL AND @strResponse2<>N''
	BEGIN
		IF @strResponse2<>@Response2
		BEGIN
			SET @strErrorDescribe=N'您的密码保护答案输入有误，请查证后再次尝试！'
			RETURN 8	
		END
	END

	-- 答案效验三
	IF @strResponse3 IS NOT NULL AND @strResponse3<>N''
	BEGIN
		IF @strResponse3<>@Response3
		BEGIN
			SET @strErrorDescribe=N'您的密码保护答案输入有误，请查证后再次尝试！'
			RETURN 9	
		END
	END	

	SELECT 0
END

SET NOCOUNT OFF

RETURN 0
GO

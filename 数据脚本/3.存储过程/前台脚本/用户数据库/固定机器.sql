----------------------------------------------------------------------------------------------------
-- 版权：2011
-- 时间：2011-08-31
-- 用途：固定机器
----------------------------------------------------------------------------------------------------

USE RYAccountsDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].NET_PW_ApplyMoorMachine') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].NET_PW_ApplyMoorMachine
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].NET_PW_CancelMoorMachine') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].NET_PW_CancelMoorMachine
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- 申请绑定
CREATE PROCEDURE NET_PW_ApplyMoorMachine
	@dwUserID			INT,					-- 用户标识

	@strResponse1		NVARCHAR(32),			-- 密保答案1
	@strResponse2		NVARCHAR(32),			-- 密保答案2
	@strResponse3		NVARCHAR(32),			-- 密保答案3

	@strClientIP		NVARCHAR(15),			-- 连接地址
	@strErrorDescribe	NVARCHAR(127) OUTPUT	-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 基本信息
DECLARE @UserID			INT
DECLARE @Nullity		TINYINT
DECLARE @StunDown		TINYINT
DECLARE @MoorMachine	TINYINT

-- 密保信息
DECLARE @ProtectID		INT
DECLARE @Response1		NVARCHAR(32)
DECLARE @Response2		NVARCHAR(32)
DECLARE @Response3		NVARCHAR(32)

-- 执行逻辑
BEGIN	
	-- 查询用户	
	SELECT @UserID=UserID, @ProtectID=ProtectID,@Nullity=Nullity, @StunDown=StunDown, @MoorMachine=MoorMachine
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

	-- 启用服务
	UPDATE AccountsInfo 
	SET MoorMachine=2,LastLogonIP=@strClientIP,LastLogonDate=GETDATE()
	WHERE UserID=@UserID

	-- 设置信息
	SET @strErrorDescribe= N'恭喜您，“固定机器”功能申请成功了，建议你立刻使用客户端登录游戏，我们将会为您完成机器的绑定工作！'
END
RETURN 0

GO

----------------------------------------------------------------------------------------------------
-- 解除绑定
CREATE PROCEDURE NET_PW_CancelMoorMachine
	@dwUserID			INT,					-- 用户标识

	@strResponse1		NVARCHAR(32),			-- 密保答案1
	@strResponse2		NVARCHAR(32),			-- 密保答案2
	@strResponse3		NVARCHAR(32),			-- 密保答案3

	@strClientIP		NVARCHAR(15),			-- 连接地址
	@strErrorDescribe	NVARCHAR(127) OUTPUT	-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 基本信息
DECLARE @UserID			INT
DECLARE @Nullity		TINYINT
DECLARE @StunDown		TINYINT
DECLARE @MoorMachine	TINYINT

-- 密保信息
DECLARE @ProtectID		INT
DECLARE @Response1		NVARCHAR(32)
DECLARE @Response2		NVARCHAR(32)
DECLARE @Response3		NVARCHAR(32)

-- 辅助变量
DECLARE @ErrorDescribe AS NVARCHAR(128)

-- 执行逻辑
BEGIN	
	-- 查询用户	
	SELECT @UserID=UserID, @ProtectID=ProtectID,@Nullity=Nullity, @StunDown=StunDown, @MoorMachine=MoorMachine
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

	-- 解除服务
	UPDATE AccountsInfo 
	SET MoorMachine=0,LastLogonIP=@strClientIP,LastLogonDate=GETDATE()
	WHERE UserID=@UserID

	-- 设置信息
	SET @strErrorDescribe= N'恭喜您，“固定机器”解除成功了！'
END
RETURN 0

GO

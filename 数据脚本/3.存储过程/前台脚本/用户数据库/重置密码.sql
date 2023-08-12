----------------------------------------------------------------------------------------------------
-- 版权：2011
-- 时间：2011-08-31
-- 用途：重置密码
----------------------------------------------------------------------------------------------------

USE RYAccountsDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].NET_PW_ResetLogonPasswd') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].NET_PW_ResetLogonPasswd
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].NET_PW_ResetLoginPasswdByLossReport') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].NET_PW_ResetLoginPasswdByLossReport
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].NET_PW_ResetInsurePasswd') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].NET_PW_ResetInsurePasswd
GO


SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------
-- 找回登录密码
CREATE PROCEDURE NET_PW_ResetLogonPasswd
	@dwUserID			INT,						-- 用户标识
	
	@strPassword		NCHAR(32),					-- 用户密码
	@strResponse1		NVARCHAR(32),				-- 保护答案1
	@strResponse2		NVARCHAR(32),				-- 保护答案2
	@strResponse3		NVARCHAR(32),				-- 保护答案3
	
	@strClientIP		NVARCHAR(15),				-- 连接地址
	@strErrorDescribe	NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 基本信息
DECLARE @UserID			INT
DECLARE @Nullity		TINYINT
DECLARE @StunDown		TINYINT
DECLARE @ProtectID		INT
DECLARE @Response1		NVARCHAR(32)
DECLARE @Response2		NVARCHAR(32)
DECLARE @Response3		NVARCHAR(32)

-- 执行逻辑
BEGIN
	-- 查询用户	
	SELECT @UserID=UserID, @ProtectID=ProtectID, @Nullity=Nullity, @StunDown=StunDown
	FROM AccountsInfo(NOLOCK) WHERE UserID=@dwUserID

	-- 用户存在
	IF @UserID IS NULL
	BEGIN
		SET @strErrorDescribe=N'您的帐号不存在或者密码输入有误，请查证后再次尝试登录！'
		RETURN 1
	END	

	-- 帐号禁止
	IF @Nullity<>0
	BEGIN
		SET @strErrorDescribe=N'您的帐号暂时处于冻结状态，请联系客服中心了解详细情况！'
		RETURN 2
	END	
	
	-- 密保效验
	IF @ProtectID=0
	BEGIN
		SET @strErrorDescribe=N'您的帐号还没有申请“帐号保护”，无法进行“密码重置”！'
		RETURN 4
	END

	-- 密保查询
	DECLARE @TmpProtectID INT
	SELECT @TmpProtectID=ProtectID, @Response1=Response1, @Response2=Response2,@Response3=Response3
	FROM AccountsProtect(NOLOCK) WHERE ProtectID=@ProtectID AND UserID=@UserID

	-- 密保效验
	IF @TmpProtectID IS NULL
	BEGIN
		SET @strErrorDescribe=N'您的帐号还没有申请“帐号保护”，无法进行“密码重置”！'
		RETURN 5		
	END
	
	-- 答案无效
	IF ((@strResponse1 IS NULL OR @strResponse1=N'') OR
		(@strResponse2 IS NULL OR @strResponse2=N'') OR
		(@strResponse3 IS NULL OR @strResponse3=N''))
	BEGIN
		SET @strErrorDescribe=N'您的密码保护答案输入有误，请查证后再次尝试“密码重置”！'
		RETURN 6	
	END

	-- 答案效验一
	IF @strResponse1 IS NOT NULL AND @strResponse1<>N''
	BEGIN
		IF @strResponse1<>@Response1
		BEGIN
			SET @strErrorDescribe=N'您的密码保护答案输入有误，请查证后再次尝试“密码重置”！'
			RETURN 7	
		END
	END

	-- 答案效验二
	IF @strResponse2 IS NOT NULL AND @strResponse2<>N''
	BEGIN
		IF @strResponse2<>@Response2
		BEGIN
			SET @strErrorDescribe=N'您的密码保护答案输入有误，请查证后再次尝试“密码重置”！'
			RETURN 8	
		END
	END

	-- 答案效验三
	IF @strResponse3 IS NOT NULL AND @strResponse3<>N''
	BEGIN
		IF @strResponse3<>@Response3
		BEGIN
			SET @strErrorDescribe=N'您的密码保护答案输入有误，请查证后再次尝试“密码重置”！'
			RETURN 9	
		END
	END	

	-- 设置密码
	UPDATE AccountsInfo 
	SET LogonPass=@strPassword,LastLogonIP=@strClientIP
	WHERE UserID=@UserID
	
	-- 设置信息
	BEGIN		
		SET @strErrorDescribe=N'恭喜您！您的帐号密码重置成功了，现在请您使用新密码进行游戏登录。'
		RETURN 0
	END
END

SET NOCOUNT OFF

RETURN 0

GO

----------------------------------------------------------------------------------------------------
-- 通过申述重置密码
CREATE PROCEDURE NET_PW_ResetLoginPasswdByLossReport
	@dwUserID			INT,						-- 用户标识
	@strLogonPass		NCHAR(32),					-- 用户密码
	@strReportNo		NVARCHAR(30),				-- 申述号码
	@strClientIP		NVARCHAR(15),				-- 操作地址
	@strErrorDescribe	NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 基本信息
DECLARE @UserID			INT
DECLARE @Nullity		TINYINT
DECLARE @StunDown		TINYINT
DECLARE @OldLogonPass	NCHAR(32)

-- 执行逻辑
BEGIN
	-- 查询用户	
	SELECT @UserID=UserID,@Nullity=Nullity,@StunDown=StunDown,@OldLogonPass=LogonPass
	FROM AccountsInfo(NOLOCK) WHERE UserID=@dwUserID

	-- 用户存在
	IF @UserID IS NULL
	BEGIN
		SET @strErrorDescribe=N'您的帐号不存在'
		RETURN 1
	END

	-- 帐号禁止
	IF @Nullity<>0
	BEGIN
		SET @strErrorDescribe=N'您的帐号暂时处于冻结状态，请联系客服中心了解详细情况！'
		RETURN 2
	END

	-- 设置密码
	UPDATE AccountsInfo SET LogonPass=@strLogonPass,LastLogonIP=@strClientIP WHERE UserID=@UserID

	-- 插入日志
	INSERT INTO RYRecordDBLink.RYRecordDB.dbo.RecordPasswdExpend(OperMasterID,UserID,ReLogonPasswd,ReInsurePasswd,ClientIP,CollectDate)
	VALUES(0,@UserID,@OldLogonPass,'',@strClientIP,GETDATE())

	-- 更新申述记录
	UPDATE RYNativeWebDBLink.RYNativeWebDB.dbo.LossReport SET ProcessStatus=3,SolveDate=GETDATE()
	WHERE ReportNo=@strReportNo

	-- 设置信息
	BEGIN		
		SET @strErrorDescribe=N'恭喜您！您的帐号密码重置成功了，现在请您使用新密码进行游戏登录。'
		RETURN 0
	END
END

SET NOCOUNT OFF

RETURN 0

GO

----------------------------------------------------------------------------------------------------
-- 找回保险柜密码
CREATE PROCEDURE NET_PW_ResetInsurePasswd
	@dwUserID			INT,						-- 用户标识

	@strInsurePass		NCHAR(32),					-- 用户密码
	@strResponse1		NVARCHAR(32),				-- 保护答案1
	@strResponse2		NVARCHAR(32),				-- 保护答案2
	@strResponse3		NVARCHAR(32),				-- 保护答案3

	@strClientIP		NVARCHAR(15),				-- 连接地址
	@strErrorDescribe	NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 基本信息
DECLARE @UserID			INT
DECLARE @Nullity		TINYINT
DECLARE @StunDown		TINYINT
DECLARE @ProtectID		INT
DECLARE @Response1		NVARCHAR(32)
DECLARE @Response2		NVARCHAR(32)
DECLARE @Response3		NVARCHAR(32)

-- 执行逻辑
BEGIN
	-- 查询用户	
	SELECT @UserID=UserID, @ProtectID=ProtectID, @Nullity=Nullity, @StunDown=StunDown
	FROM AccountsInfo(NOLOCK) WHERE UserID=@dwUserID

	-- 用户存在
	IF @UserID IS NULL
	BEGIN
		SET @strErrorDescribe=N'您的帐号不存在或者密码输入有误，请查证后再次尝试登录！'
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
		SET @strErrorDescribe=N'您的帐号还没有申请“帐号保护”，无法进行“密码重置”！'
		RETURN 4
	END

	-- 密保查询
	DECLARE @TmpProtectID INT
	SELECT @TmpProtectID=ProtectID, @Response1=Response1, @Response2=Response2,@Response3=Response3
	FROM AccountsProtect(NOLOCK) WHERE ProtectID=@ProtectID AND UserID=@UserID

	-- 密保效验
	IF @TmpProtectID IS NULL
	BEGIN
		SET @strErrorDescribe=N'您的帐号还没有申请“帐号保护”，无法进行“密码重置”！'
		RETURN 5		
	END
	
	-- 答案无效
	IF ((@strResponse1 IS NULL OR @strResponse1=N'') OR
		(@strResponse2 IS NULL OR @strResponse2=N'') OR
		(@strResponse3 IS NULL OR @strResponse3=N''))
	BEGIN
		SET @strErrorDescribe=N'您的密码保护答案输入有误，请查证后再次尝试“密码重置”！'
		RETURN 6	
	END

	-- 答案效验一
	IF @strResponse1 IS NOT NULL AND @strResponse1<>N''
	BEGIN
		IF @strResponse1<>@Response1
		BEGIN
			SET @strErrorDescribe=N'您的密码保护答案输入有误，请查证后再次尝试“密码重置”！'
			RETURN 7	
		END
	END

	-- 答案效验二
	IF @strResponse2 IS NOT NULL AND @strResponse2<>N''
	BEGIN
		IF @strResponse2<>@Response2
		BEGIN
			SET @strErrorDescribe=N'您的密码保护答案输入有误，请查证后再次尝试“密码重置”！'
			RETURN 8	
		END
	END

	-- 答案效验三
	IF @strResponse3 IS NOT NULL AND @strResponse3<>N''
	BEGIN
		IF @strResponse3<>@Response3
		BEGIN
			SET @strErrorDescribe=N'您的密码保护答案输入有误，请查证后再次尝试“密码重置”！'
			RETURN 9	
		END
	END	

	-- 设置密码
	UPDATE AccountsInfo 
	SET InsurePass=@strInsurePass,LastLogonIP=@strClientIP
	WHERE UserID=@UserID
	
	-- 设置信息
	BEGIN		
		SET @strErrorDescribe=N'恭喜您！您的保险柜密码重置成功了，现在请您使用新密码进行财富管理。'
		RETURN 0
	END
END

SET NOCOUNT OFF

RETURN 0

GO
----------------------------------------------------------------------------------------------------
-- 版权：2011
-- 时间：2011-08-31
-- 用途：修改资料
----------------------------------------------------------------------------------------------------

USE RYAccountsDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].NET_PW_ModifyUserInfo') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].NET_PW_ModifyUserInfo

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].NET_PW_ModifyUserFace') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].NET_PW_ModifyUserFace

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].NET_PW_ModifyUserNickName') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].NET_PW_ModifyUserNickName

GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_NULLS ON
GO

----------------------------------------------------------------------------------------------------

-- 修改用户资料
CREATE PROCEDURE NET_PW_ModifyUserInfo
	-- 验证信息
	@dwUserID INT,								-- 用户 I D

	-- 用户资料
	@dwGender TINYINT,							-- 用户性别
	@strUnderWrite NVARCHAR(63),				-- 用户签名

	-- 详细资料
	@strQQ NVARCHAR(16),						-- Q Q 号码
	@strEmail NVARCHAR(32),						-- 邮件地址
	@strMobilePhone NVARCHAR(16),				-- 手机号码
	@strSeatPhone NVARCHAR(32),					-- 固定电话
	@strDwellingPlace NVARCHAR(128),			-- 联系地址
	@strUserNote NVARCHAR(256),					-- 其他资料	

	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN

	-- 查询用户
	DECLARE @UserID INT
	DECLARE @Nullity BIT
	DECLARE @StunDown BIT
	SELECT @UserID=UserID, @Nullity=Nullity, @StunDown=StunDown FROM AccountsInfo(NOLOCK) WHERE UserID=@dwUserID

	-- 帐号禁止
	IF @Nullity<>0
	BEGIN
		SET @strErrorDescribe=N'您的帐号暂时处于冻结状态，请联系客户服务中心了解详细情况！'
		RETURN 1
	END	

	-- 帐号关闭
	IF @StunDown<>0
	BEGIN
		SET @strErrorDescribe=N'您的帐号使用了安全关闭功能，必须重新开通后才能继续使用！'
		RETURN 2
	END		

	-- 更新信息
	UPDATE AccountsInfo SET Gender=@dwGender,UnderWrite=@strUnderWrite WHERE UserID=@dwUserID

	-- 更新资料
	UPDATE IndividualDatum SET QQ=@strQQ, EMail=@strEMail, MobilePhone=@strMobilePhone,SeatPhone=@strSeatPhone,
		DwellingPlace=@strDwellingPlace, UserNote=@strUserNote WHERE UserID=@dwUserID

	-- 插入处理
	IF @@ROWCOUNT=0
	BEGIN
		INSERT IndividualDatum (UserID,QQ,EMail,MobilePhone,SeatPhone,DwellingPlace,UserNote)
		VALUES (@dwUserID,@strQQ,@strEMail,@strMobilePhone,@strSeatPhone,@strDwellingPlace,@strUserNote)
	END

	-- 设置信息	
	SET @strErrorDescribe= N'恭喜您，您的个人资料修改成功了！'
END

RETURN 0

GO


----------------------------------------------------------------------------------------------------

-- 修改用户头像
CREATE PROCEDURE NET_PW_ModifyUserFace
	-- 验证信息
	@dwUserID INT,								-- 用户 I D

	-- 用户资料
	@dwFaceID SMALLINT,							-- 用户头像

	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN

	-- 查询用户
	DECLARE @UserID INT
	DECLARE @Nullity BIT
	DECLARE @StunDown BIT
	SELECT @UserID=UserID, @Nullity=Nullity, @StunDown=StunDown FROM AccountsInfo(NOLOCK) WHERE UserID=@dwUserID

	-- 帐号禁止
	IF @Nullity<>0
	BEGIN
		SET @strErrorDescribe=N'您的帐号暂时处于冻结状态，请联系客户服务中心了解详细情况！'
		RETURN 1
	END	

	-- 帐号关闭
	IF @StunDown<>0
	BEGIN
		SET @strErrorDescribe=N'您的帐号使用了安全关闭功能，必须重新开通后才能继续使用！'
		RETURN 2
	END		

	-- 更新头像
	UPDATE AccountsInfo SET FaceID=@dwFaceID,CustomID=0 WHERE UserID=@dwUserID

	-- 设置信息	
	SET @strErrorDescribe= N'恭喜您，您的头像修改成功了！'
END

RETURN 0

GO


----------------------------------------------------------------------------------------------------

-- 修改用户昵称
CREATE PROCEDURE NET_PW_ModifyUserNickName
	-- 验证信息
	@dwUserID INT,								-- 用户 I D
	@ClientIP NVARCHAR(31),	
	-- 用户资料
	@strNickName NVARCHAR(31),					-- 用户昵称

	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN

	-- 查询用户
	DECLARE @UserID INT
	DECLARE @Nullity BIT
	DECLARE @StunDown BIT
	DECLARE @OldNickName NVARCHAR(32)
	SELECT @UserID=UserID,@Nullity=Nullity,@StunDown=StunDown,@OldNickName=NickName FROM AccountsInfo(NOLOCK) WHERE UserID=@dwUserID

	-- 帐号禁止
	IF @Nullity<>0
	BEGIN
		SET @strErrorDescribe=N'您的帐号暂时处于冻结状态，请联系客户服务中心了解详细情况！'
		RETURN 1
	END	

	-- 帐号关闭
	IF @StunDown<>0
	BEGIN
		SET @strErrorDescribe=N'您的帐号使用了安全关闭功能，必须重新开通后才能继续使用！'
		RETURN 2
	END		

	-- 效验昵称
	IF EXISTS (SELECT [String] FROM ConfineContent(NOLOCK) WHERE CHARINDEX(String,@strNickName)>0 AND (EnjoinOverDate>GETDATE() OR EnjoinOverDate IS NULL))
	BEGIN
		SET @strErrorDescribe=N'抱歉地通知您，您所输入的昵称含有限制字符串，请更换昵称后再次申请帐号！'
		RETURN 3
	END

	IF EXISTS (SELECT UserID FROM AccountsInfo(NOLOCK) WHERE NickName=@strNickName)
	BEGIN
		SET @strErrorDescribe=N'此昵称已被注册，请换另一昵称尝试再次注册！'
		RETURN 3
	END

	-- 更新昵称
	UPDATE AccountsInfo SET NickName = @strNickName WHERE UserID=@dwUserID
	
    -- 添加修改记录
    INSERT INTO RYRecordDB.dbo.RecordAccountsExpend(OperMasterID,UserID,ReAccounts,[Type],ClientIP,CollectDate)
    VALUES(0,@dwUserID,@OldNickName,1,@ClientIP,GETDATE())

	-- 设置信息	
	SET @strErrorDescribe= N'恭喜您，您的昵称修改成功了！'
END

RETURN 0

GO



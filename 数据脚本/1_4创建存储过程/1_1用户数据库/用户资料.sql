
----------------------------------------------------------------------------------------------------

USE RYAccountsDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_QueryUserIndividual]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_QueryUserIndividual]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_ModifyUserIndividual]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_ModifyUserIndividual]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- 查询资料
CREATE PROC GSP_GP_QueryUserIndividual
	@dwUserID INT,								-- 用户 I D
	@strPassword NCHAR(32),						-- 用户密码
	@strClientIP NVARCHAR(15),					-- 连接地址
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN

	-- 变量定义
	DECLARE @LogonPass AS NCHAR(32)

	-- 查询用户
	SELECT @LogonPass=LogonPass FROM AccountsInfo(NOLOCK) WHERE UserID=@dwUserID

	-- 密码判断
	IF @LogonPass<>@strPassword
	BEGIN
		SET @strErrorDescribe=N'您的用户密码不正确，个人信息查询失败！'
		RETURN 1
	END

	-- 变量定义
	DECLARE @UserID INT
	DECLARE @QQ NVARCHAR(16)
	DECLARE @EMail NVARCHAR(33)
	DECLARE @UserNote NVARCHAR(256)
	DECLARE @SeatPhone NVARCHAR(32)
	DECLARE @MobilePhone NVARCHAR(16)
	DECLARE @Compellation NVARCHAR(16)
	DECLARE @DwellingPlace NVARCHAR(128)
	DECLARE @PassPortID NVARCHAR(18)
	DECLARE	@Spreader NVARCHAR(31)
	
	SET @QQ=N''	
	SET @EMail=N''	
	SET @UserNote=N''	
	SET @SeatPhone=N''	
	SET @MobilePhone=N''	
	SET @Compellation=N''	
	SET @DwellingPlace=N''	
	SET @PassPortID=N''		
	SET @Spreader=N''

	-- 查询用户
	SELECT @UserID=UserID, @QQ=QQ, @EMail=EMail, @UserNote=UserNote, @SeatPhone=SeatPhone,@MobilePhone=MobilePhone, @DwellingPlace=DwellingPlace FROM IndividualDatum(NOLOCK) WHERE UserID=@dwUserID

	-- 查询姓名
	DECLARE @SpreaderID INT	
	SELECT @Compellation=Compellation,@PassPortID = PassPortID,@SpreaderID = SpreaderID FROM AccountsInfo(NOLOCK) WHERE UserID=@dwUserID
	
	-- 查询推广
	SELECT @Spreader = GAMEID FROM AccountsInfo  WHERE UserID=@SpreaderID

	-- 输出信息
	SELECT @dwUserID AS UserID,
	       @Compellation AS Compellation,
	       @PassPortID AS PassPortID, 
	       @QQ AS QQ, 
	       @EMail AS EMail, 
	       @SeatPhone AS SeatPhone,
		   @MobilePhone AS MobilePhone,
		   @DwellingPlace AS DwellingPlace, 
		   @UserNote AS UserNote,
		   @Spreader AS Spreader

	RETURN 0

END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

-- 更新资料
CREATE PROC GSP_GP_ModifyUserIndividual
	@dwUserID INT,								-- 用户 I D
	@strPassword NCHAR(32),						-- 用户密码
	@cbGender TINYINT,							-- 用户性别
	@strNickName NVARCHAR(32),					-- 用户昵称
	@strUnderWrite NVARCHAR(63),				-- 个性签名
	@strCompellation NVARCHAR(16),				-- 真实名字
	@strPassPortID NVARCHAR(18),				-- 证件号码	
	@strQQ NVARCHAR(16),						-- Q Q 号码
	@strEMail NVARCHAR(33),						-- 电子邮电
	@strSeatPhone NVARCHAR(32),					-- 固定电话
	@strMobilePhone NVARCHAR(16),				-- 移动电话
	@strDwellingPlace NVARCHAR(128),			-- 详细地址
	@strUserNote NVARCHAR(256),					-- 用户备注	
	@strSpreader NVARCHAR(31),					-- 推荐帐号				
	@strClientIP NVARCHAR(15),					-- 连接地址
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN

	-- 变量定义
	DECLARE @UserID INT
	DECLARE @NickName NVARCHAR(31)
	DECLARE @Nullity BIT
	DECLARE @StunDown BIT
	DECLARE @LogonPass AS NCHAR(32)
	-- 金币变量
	DECLARE @SourceScore BIGINT

	-- 查询用户
	SELECT @UserID=UserID, @NickName=NickName, @LogonPass=LogonPass, @Nullity=Nullity, @StunDown=StunDown
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
		RETURN 2
	END	
	
	-- 密码判断
	IF @LogonPass<>@strPassword
	BEGIN
		SET @strErrorDescribe=N'您的帐号不存在或者密码输入有误，请查证后再次尝试登录！'
		RETURN 3
	END

	-- 效验昵称
	IF (SELECT COUNT(*) FROM ConfineContent(NOLOCK) WHERE CHARINDEX(String,@strNickName)>0)>0
	BEGIN
		SET @strErrorDescribe=N'您所输入的游戏昵称名含有限制字符串，请更换昵称名后再次修改！'
		RETURN 4
	END

	-- 存在判断
	IF EXISTS (SELECT UserID FROM AccountsInfo(NOLOCK) WHERE NickName=@strNickName AND UserID<>@UserID)
	BEGIN
		SET @strErrorDescribe=N'此昵称已被其他玩家使用了，请更换昵称名后再次修改！'
		RETURN 4
	END
	
	-- 查推广员
	DECLARE @SpreaderID INT	
	IF @strSpreader<>''
	BEGIN
		-- 查推广员
		DECLARE @CurrSpreaderID INT
		SET @CurrSpreaderID = CONVERT(INT,@strSpreader)

		SELECT @SpreaderID=UserID FROM AccountsInfo(NOLOCK) WHERE GameID = @CurrSpreaderID 
		
		-- 结果处理
		IF @SpreaderID IS NULL
		BEGIN
			SET @SpreaderID=0
			SET @strErrorDescribe=N'您所填写的推广员不存在或者填写错误，请检查后再提交！'
			RETURN 5
		END
		
		-- 查询重复
		
		IF EXISTS (SELECT SpreaderID FROM AccountsInfo WHERE @SpreaderID=SpreaderID and UserID=@dwUserID)
		BEGIN
			SET @SpreaderID=0
			SET @strErrorDescribe=N'已经提交推广员，提交失败！'
			RETURN 5
		END
		
	END
	ELSE SET @SpreaderID=0
	
	-- 推广提成
	IF @SpreaderID<>0
	BEGIN
		DECLARE @RegisterGrantScore INT
		DECLARE @Note NVARCHAR(512)
		SET @Note = N'推广员'
		SELECT @RegisterGrantScore = RegisterGrantScore FROM RYTreasureDBLink.RYTreasureDB.dbo.GlobalSpreadInfo
		IF @RegisterGrantScore IS NULL
		BEGIN
			SET @RegisterGrantScore=5000
		END
		INSERT INTO RYTreasureDBLink.RYTreasureDB.dbo.RecordSpreadInfo(
			UserID,Score,TypeID,ChildrenID,CollectNote)
		VALUES(@SpreaderID,@RegisterGrantScore,1,@UserID,@Note)	
		
		-- 推荐记录
		UPDATE AccountsInfo SET SpreaderID = @SpreaderID WHERE UserID=@dwUserID		
	END
	
	
	-- 修改资料
	UPDATE AccountsInfo SET NickName=@strNickName, UnderWrite=@strUnderWrite, Gender=@cbGender	WHERE UserID=@dwUserID	
		
	-- 昵称记录
	IF @NickName<>@strNickName
	BEGIN
		INSERT INTO RYRecordDBLink.RYRecordDB.dbo.RecordAccountsExpend(UserID,ReAccounts,ClientIP)
		VALUES(@dwUserID,@strNickName,@strClientIP)
	END

	-- 修改资料
	UPDATE IndividualDatum SET QQ=@strQQ, EMail=@strEMail, SeatPhone=@strSeatPhone,
		MobilePhone=@strMobilePhone, DwellingPlace=@strDwellingPlace, UserNote=@strUserNote WHERE UserID=@dwUserID
		
	-- 修改资料
	IF @@ROWCOUNT=0
	INSERT IndividualDatum (UserID, QQ, EMail, SeatPhone, MobilePhone, DwellingPlace, UserNote)
	VALUES (@dwUserID, @strQQ, @strEMail, @strSeatPhone, @strMobilePhone, @strDwellingPlace, @strUserNote)

	-- 设置信息
	IF @@ERROR=0 SET @strErrorDescribe=N'服务器已经接受了您的新资料！'
		
	RETURN 0

END

RETURN 0

GO

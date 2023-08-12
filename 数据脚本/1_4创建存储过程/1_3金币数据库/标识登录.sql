
----------------------------------------------------------------------------------------------------

USE RYTreasureDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_EfficacyUserID]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_EfficacyUserID]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_EfficacyMobile]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_EfficacyMobile]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- I D 登录
CREATE PROC GSP_GR_EfficacyUserID
	@dwUserID INT,								-- 用户 I D
	@strPassword NCHAR(32),						-- 用户密码
	@strClientIP NVARCHAR(15),					-- 连接地址
	@strMachineID NVARCHAR(32),					-- 机器标识
	@wKindID SMALLINT,							-- 游戏 I D
	@wServerID SMALLINT,						-- 房间 I D
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 基本信息
DECLARE @UserID INT
DECLARE @FaceID SMALLINT
DECLARE @CustomID INT
DECLARE @NickName NVARCHAR(31)
DECLARE @UnderWrite NVARCHAR(63)

-- 附属信息
DECLARE @QQ NVARCHAR(16)
DECLARE @EMail NVARCHAR(16)
DECLARE @SeatPhone NVARCHAR(32)
DECLARE @MobilePhone NVARCHAR(16)
DECLARE @DwellingPlace NVARCHAR(128)
DECLARE @PostalCode NVARCHAR(8)

-- 扩展信息
DECLARE @GameID INT
DECLARE @GroupID INT
DECLARE @UserRight INT
DECLARE @Gender TINYINT
DECLARE @MasterRight INT
DECLARE @MasterOrder SMALLINT
DECLARE @MemberOrder SMALLINT
DECLARE @GroupName NVARCHAR(31)

-- 积分变量
DECLARE @Score BIGINT
DECLARE @Grade BIGINT
DECLARE @Insure BIGINT
DECLARE @Beans decimal(18, 2)
DECLARE @WinCount INT
DECLARE @LostCount INT
DECLARE @DrawCount INT
DECLARE @FleeCount INT
DECLARE @UserMedal INT
DECLARE @Experience INT
DECLARE @LoveLiness INT
DECLARE @AgentID AS INT
DECLARE @IntegralCount BIGINT 
-- 执行逻辑
BEGIN

	-- 辅助变量
	DECLARE @EnjoinLogon INT

	-- 系统暂停
	SELECT @EnjoinLogon=StatusValue FROM RYAccountsDBLink.RYAccountsDB.dbo.SystemStatusInfo WHERE StatusName=N'EnjoinLogon'
	IF @EnjoinLogon IS NOT NULL AND @EnjoinLogon<>0
	BEGIN
		SELECT @strErrorDescribe=StatusString FROM RYAccountsDBLink.RYAccountsDB.dbo.SystemStatusInfo WHERE StatusName=N'EnjoinLogon'
		RETURN 2
	END

	-- 效验地址
	SELECT @EnjoinLogon=EnjoinLogon FROM ConfineAddress(NOLOCK) WHERE AddrString=@strClientIP AND GETDATE()<EnjoinOverDate
	IF @EnjoinLogon IS NOT NULL AND @EnjoinLogon<>0
	BEGIN
		SET @strErrorDescribe=N'抱歉地通知您，系统禁止了您所在的 IP 地址的游戏登录权限，请联系客户服务中心了解详细情况！'
		RETURN 4
	END
	
	-- 效验机器
	SELECT @EnjoinLogon=EnjoinLogon FROM ConfineMachine(NOLOCK) WHERE MachineSerial=@strMachineID AND GETDATE()<EnjoinOverDate
	IF @EnjoinLogon IS NOT NULL AND @EnjoinLogon<>0
	BEGIN
		SET @strErrorDescribe=N'抱歉地通知您，系统禁止了您的机器的游戏登录权限，请联系客户服务中心了解详细情况！'
		RETURN 7
	END
 
	-- 查询用户
	DECLARE @Nullity BIT
	DECLARE @StunDown BIT
	DECLARE @LogonPass AS NCHAR(32)
	DECLARE @DynamicPass AS NCHAR(32)
	DECLARE	@MachineID NVARCHAR(32)
	DECLARE @MoorMachine AS TINYINT
	DECLARE @SpreaderID INT
	SET @AgentID = 0	
	SELECT @UserID=UserID, @GameID=GameID, @NickName=NickName,@SpreaderID = SpreaderID, @UnderWrite=UnderWrite, @LogonPass=DynamicPass,@FaceID=FaceID, @CustomID=CustomID,
		@Gender=Gender, @Nullity=Nullity, @StunDown=StunDown, @UserMedal=UserMedal, @Experience=Experience, @LoveLiness=LoveLiness, @UserRight=UserRight,
		@MasterRight=MasterRight, @MasterOrder=MasterOrder, @MemberOrder=MemberOrder, @MoorMachine=MoorMachine, @MachineID=LastLogonMachine,@AgentID=AgentID
	FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo WHERE UserID=@dwUserID
	
	--查询代理
	SELECT @AgentID = UserID FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsAgent  where UserID = @SpreaderID

	-- 附属信息
    SET @QQ =N''
    SET @EMail =N''
    SET @SeatPhone =N''
    SET @MobilePhone =N''
    SET @DwellingPlace =N''
    SET @PostalCode =N''
    SELECT @QQ = QQ,@EMail = EMail,@SeatPhone = SeatPhone,@MobilePhone = MobilePhone,@DwellingPlace = DwellingPlace ,@PostalCode =PostalCode 
    FROM RYAccountsDBLink.RYAccountsDB.dbo.IndividualDatum WHERE UserID=@dwUserID
    
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

	-- 帐号关闭
	IF @StunDown<>0
	BEGIN
		SET @strErrorDescribe=N'您的帐号使用了安全关闭功能，必须重新开通后才能继续使用！'
		RETURN 2
	END	
	
	-- 固定机器
	IF @MoorMachine=1
	BEGIN
		IF @MachineID<>@strMachineID
		BEGIN
			SET @strErrorDescribe=N'您的帐号使用固定机器登录功能，您现所使用的机器不是所指定的机器！'
			RETURN 2
		END
	END

	-- 密码判断
	IF @LogonPass<>@strPassword AND @strClientIP<>N'0.0.0.0'
	BEGIN
		SET @strErrorDescribe=N'抱歉,由于您的帐号在其它地方登录,请重新登录平台后再次尝试！'
		RETURN 3
	END

	-- 固定机器
	IF @MoorMachine=2
	BEGIN
		SET @MoorMachine=1
		SET @strErrorDescribe=N'您的帐号成功使用了固定机器登录功能！'
		UPDATE RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo SET MoorMachine=@MoorMachine, LastLogonMachine=@strMachineID WHERE UserID=@UserID
	END

	-- 开始事务
	SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
	BEGIN TRAN

	-- 游戏信息
	DECLARE @AllLogonTimes INT
	DECLARE @GameUserRight INT
	DECLARE @GameMasterRight INT
	DECLARE @GameMasterOrder SMALLINT
	SELECT @Score=Score, @Insure=InsureScore, @WinCount=WinCount, @LostCount=LostCount, @DrawCount=DrawCount, @DrawCount=DrawCount,
		@FleeCount=FleeCount, @GameUserRight=UserRight, @GameMasterRight=MasterRight, @GameMasterOrder=MasterOrder, @AllLogonTimes=AllLogonTimes
	FROM GameScoreInfo WHERE UserID=@dwUserID

	-- 信息判断
	IF @Score IS NULL
	BEGIN
		-- 插入资料
		INSERT INTO GameScoreInfo (UserID, LastLogonIP, LastLogonMachine, RegisterIP, RegisterMachine)
		VALUES (@dwUserID, @strClientIP, @strMachineID, @strClientIP, @strMachineID)

		-- 游戏信息
		SELECT @Score=Score, @Insure=InsureScore, @WinCount=WinCount, @LostCount=LostCount, @DrawCount=DrawCount, @DrawCount=DrawCount,
			@FleeCount=FleeCount, @GameUserRight=UserRight, @GameMasterOrder=MasterOrder, @GameMasterRight=MasterRight, @AllLogonTimes=AllLogonTimes
		FROM GameScoreInfo WHERE UserID=@dwUserID
	END

	-- 异常判断
	IF @Score<0
	BEGIN
		-- 结束事务
		ROLLBACK TRAN
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED

		-- 错误信息
		SET @strErrorDescribe=N'抱歉地通知你，您的游戏币数据出现了异常情况，请联系客户服务中心了解详细情况！'
		RETURN 14
	END

	-- 查询锁定
	IF @strClientIP<>N'0.0.0.0'
	BEGIN
		-- 锁定解除
		DELETE GameScoreLocker WHERE UserID=@dwUserID AND ServerID=@wServerID

		-- 查询锁定
		DECLARE @LockKindID INT
		DECLARE @LockServerID INT
		SELECT @LockKindID=KindID, @LockServerID=ServerID FROM GameScoreLocker WHERE UserID=@dwUserID

		-- 锁定判断
		IF @LockKindID IS NOT NULL AND @LockServerID IS NOT NULL
		BEGIN

			-- 结束事务
			ROLLBACK TRAN
			SET TRANSACTION ISOLATION LEVEL READ COMMITTED

			-- 查询类型
			IF @LockKindID<>0
			BEGIN
				-- 查询信息
				DECLARE @KindName NVARCHAR(31)
				DECLARE @ServerName NVARCHAR(31)
				SELECT @KindName=KindName FROM RYPlatformDBLink.RYPlatformDB.dbo.GameKindItem WHERE KindID=@LockKindID
				SELECT @ServerName=ServerName FROM RYPlatformDBLink.RYPlatformDB.dbo.GameRoomInfo WHERE ServerID=@LockServerID

				-- 错误信息
				IF @KindName IS NULL SET @KindName=N'未知游戏'
				IF @ServerName IS NULL SET @ServerName=N'未知房间'
				SET @strErrorDescribe=N'您正在 [ '+@KindName+N' ] 的 [ '+@ServerName+N' ] 游戏房间中，不能同时再进入此游戏房间！'
				RETURN 4

			END
			ELSE
			BEGIN
				-- 提示消息
				SELECT [ErrorDescribe]=N'您正在进行保险柜处理过程中，暂时无法进入此游戏房间！'
				RETURN 4
			END
		END
	END

	-- 保留变量
	SET @Grade=0
	SET @GroupID=0
	SET @GroupName=''

	-- 权限标志
	SET @UserRight=@UserRight|@GameUserRight
	SET @UserRight=@UserRight&~256
	SET @MasterRight=@MasterRight|@GameMasterRight

	-- 权限等级
	IF @GameMasterOrder>@MasterOrder SET @MasterOrder=@GameMasterOrder

	-- 进入记录
	INSERT RecordUserInout (UserID, EnterScore, EnterGrade, EnterInsure, EnterUserMedal,EnterLoveliness, KindID, ServerID, EnterClientIP, EnterMachine)
	VALUES (@UserID, @Score, @Grade, @Insure, @UserMedal, @Loveliness, @wKindID, @wServerID, @strClientIP, @strMachineID)

	-- 记录标识
	DECLARE @InoutIndex BIGINT
	SET @InoutIndex=SCOPE_IDENTITY()

	-- 插入锁表
	IF @strClientIP<>N'0.0.0.0'
	BEGIN
		-- 插入锁表
		INSERT GameScoreLocker (UserID, ServerID, KindID, EnterID, EnterIP, EnterMachine) VALUES (@dwUserID, @wServerID, @wKindID, @InoutIndex, @strClientIP, @strMachineID)
		IF @@ERROR<>0
		BEGIN
			-- 结束事务
			ROLLBACK TRAN
			SET TRANSACTION ISOLATION LEVEL READ COMMITTED

			-- 错误信息
			SET @strErrorDescribe=N'抱歉地通知你，游戏币锁定操作失败，请联系客户服务中心了解详细情况！'
			RETURN 14
		END
	END

	--更新信息
	UPDATE GameScoreInfo SET AllLogonTimes=AllLogonTimes+1, LastLogonDate=GETDATE(), 
		LastLogonIP=@strClientIP,LastLogonMachine=@strMachineID WHERE UserID=@dwUserID

	-- 登录统计
	DECLARE @DateID INT
	SET @DateID=CAST(CAST(GETDATE() AS FLOAT) AS INT)

	-- 插入记录
	IF @AllLogonTimes>0
	BEGIN
		UPDATE SystemStreamInfo SET LogonCount=LogonCount+1 WHERE DateID=@DateID AND KindID=@wKindID AND ServerID=@wServerID
		IF @@ROWCOUNT=0 INSERT SystemStreamInfo (DateID, KindID, ServerID, LogonCount) VALUES (@DateID, @wKindID, @wServerID, 1)
	END
	ELSE
	BEGIN
		UPDATE SystemStreamInfo SET RegisterCount=RegisterCount+1 WHERE DateID=@DateID AND KindID=@wKindID AND ServerID=@wServerID
		IF @@ROWCOUNT=0 INSERT SystemStreamInfo (DateID, KindID, ServerID, RegisterCount) VALUES (@DateID, @wKindID, @wServerID, 1)
	END

	-- 结束事务
	COMMIT TRAN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED

	-- 查询游戏豆
	SELECT @Beans=Currency FROM RYTreasureDBLink.RYTreasureDB.dbo.UserCurrencyInfo WHERE UserID=@UserID		
	IF @Beans IS NULL SET @Beans=0

	-- 房间参数
	SET @IntegralCount = 0
	SELECT  @IntegralCount=IntegralCount FROM GameScoreAttribute WHERE UserID=@dwUserID And ServerID=@wServerID And KindID = @wKindID
	

    
	-- 输出变量
	SELECT @UserID AS UserID, @GameID AS GameID, @GroupID AS GroupID, @NickName AS NickName, @UnderWrite AS UnderWrite,  @FaceID AS FaceID, @Beans AS Beans,
		@CustomID AS CustomID, @Gender AS Gender, @GroupName AS GroupName, @MasterOrder AS MemberOrder, @UserRight AS UserRight, @MasterRight AS MasterRight,
		@MasterOrder AS MasterOrder, @MemberOrder AS MemberOrder, @Score AS Score,  @Grade AS Grade, @Insure AS Insure,@UserMedal AS Ingot, @WinCount AS WinCount,
		@LostCount AS LostCount, @DrawCount AS DrawCount, @FleeCount AS FleeCount,@Experience AS Experience, @LoveLiness AS LoveLiness,@InoutIndex AS InoutIndex,
		@IntegralCount AS IntegralCount,@AgentID AS AgentID,@QQ AS QQ, @EMail AS EMail, @SeatPhone AS SeatPhone, @MobilePhone AS MobilePhone,
		@DwellingPlace AS DwellingPlace,@PostalCode AS PostalCode

END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

-- 手机登录
CREATE PROC GSP_GR_EfficacyMobile
	@dwUserID INT,								-- 用户 I D
	@strPassword NCHAR(32),						-- 用户密码
	@strClientIP NVARCHAR(15),					-- 连接地址
	@strMachineID NVARCHAR(32),					-- 机器标识
	@wKindID SMALLINT,							-- 游戏 I D
	@wServerID SMALLINT,						-- 房间 I D
	@cbPersonalServer SMALLINT,					-- 私人房间
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 基本信息
DECLARE @UserID INT
DECLARE @FaceID SMALLINT
DECLARE @CustomID INT
DECLARE @NickName NVARCHAR(31)
DECLARE @UnderWrite NVARCHAR(63)

-- 附属信息
DECLARE @QQ NVARCHAR(16)
DECLARE @EMail NVARCHAR(16)
DECLARE @SeatPhone NVARCHAR(32)
DECLARE @MobilePhone NVARCHAR(16)
DECLARE @DwellingPlace NVARCHAR(128)
DECLARE @PostalCode NVARCHAR(8)

-- 扩展信息
DECLARE @GameID INT
DECLARE @GroupID INT
DECLARE @UserRight INT
DECLARE @Gender TINYINT
DECLARE @MasterRight INT
DECLARE @MasterOrder SMALLINT
DECLARE @MemberOrder SMALLINT
DECLARE @GroupName NVARCHAR(31)

-- 积分变量
DECLARE @Score BIGINT
DECLARE @Grade BIGINT
DECLARE @Insure BIGINT
DECLARE @Beans decimal(18, 2)
DECLARE @WinCount INT
DECLARE @LostCount INT
DECLARE @DrawCount INT
DECLARE @FleeCount INT
DECLARE @UserMedal INT
DECLARE @Experience INT
DECLARE @LoveLiness INT
DECLARE @AgentID AS INT
DECLARE @IntegralCount BIGINT 

-- 执行逻辑
BEGIN

	-- 辅助变量
	DECLARE @EnjoinLogon BIGINT

	-- 系统暂停
	SELECT @EnjoinLogon=StatusValue FROM RYAccountsDBLink.RYAccountsDB.dbo.SystemStatusInfo WHERE StatusName=N'EnjoinLogon'
	IF @EnjoinLogon IS NOT NULL AND @EnjoinLogon<>0
	BEGIN
		SELECT @strErrorDescribe=StatusString FROM RYAccountsDBLink.RYAccountsDB.dbo.SystemStatusInfo WHERE StatusName=N'EnjoinLogon'
		RETURN 2
	END	

	-- 效验地址
	SELECT @EnjoinLogon=EnjoinLogon FROM ConfineAddress(NOLOCK) WHERE AddrString=@strClientIP AND GETDATE()<EnjoinOverDate
	IF @EnjoinLogon IS NOT NULL AND @EnjoinLogon<>0
	BEGIN
		SET @strErrorDescribe=N'抱歉地通知您，系统禁止了您所在的 IP 地址的游戏登录权限，请联系客户服务中心了解详细情况！'
		RETURN 4
	END
	
	-- 查询用户
	DECLARE @Nullity BIT
	DECLARE @StunDown BIT
	DECLARE @LogonPass AS NCHAR(32)
	DECLARE	@MachineID NVARCHAR(32)
	DECLARE @MoorMachine AS TINYINT
	DECLARE @SpreaderID INT
	SET @AgentID = 0
	SELECT @UserID=UserID, @GameID=GameID, @NickName=NickName ,@SpreaderID = SpreaderID, @UnderWrite=UnderWrite, @LogonPass=DynamicPass, @FaceID=FaceID, @CustomID=CustomID,
		@Gender=Gender, @Nullity=Nullity, @StunDown=StunDown, @UserMedal=UserMedal, @Experience=Experience, @LoveLiness=LoveLiness, @UserRight=UserRight,
		@MasterRight=MasterRight, @MasterOrder=MasterOrder, @MemberOrder=MemberOrder, @MoorMachine=MoorMachine, @MachineID=LastLogonMachine,@AgentID=AgentID
	FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo WHERE UserID=@dwUserID

	--查询代理
	SELECT @AgentID = UserID FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsAgent  where UserID = @SpreaderID
	
	-- 附属信息
    SET @QQ =N''
    SET @EMail =N''
    SET @SeatPhone =N''
    SET @MobilePhone =N''
    SET @DwellingPlace =N''
    SET @PostalCode =N''
    SELECT @QQ = QQ,@EMail = EMail,@SeatPhone = SeatPhone,@MobilePhone = MobilePhone,@DwellingPlace = DwellingPlace ,@PostalCode =PostalCode 
    FROM RYAccountsDBLink.RYAccountsDB.dbo.IndividualDatum WHERE UserID=@dwUserID
    
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

	-- 帐号关闭
	IF @StunDown<>0
	BEGIN
		SET @strErrorDescribe=N'您的帐号使用了安全关闭功能，必须重新开通后才能继续使用！'
		RETURN 2
	END	
	
	-- 固定机器
	IF @MoorMachine=1
	BEGIN
		IF @MachineID<>@strMachineID
		BEGIN
			SET @strErrorDescribe=N'您的帐号使用固定机器登录功能，您现所使用的机器不是所指定的机器！'
			RETURN 2
		END
	END

	-- 密码判断
	IF @LogonPass<>@strPassword AND @strClientIP<>N'0.0.0.0'
	BEGIN
		SET @strErrorDescribe=N'抱歉,由于您的帐号在其它地方登录,请重新登录平台后再次尝试！'
		RETURN 3
	END

	-- 开始事务
	SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
	BEGIN TRAN

	-- 游戏信息
	DECLARE @AllLogonTimes INT
	DECLARE @GameUserRight INT
	DECLARE @GameMasterRight INT
	DECLARE @GameMasterOrder SMALLINT
	SELECT @Score=Score, @Insure=InsureScore, @WinCount=WinCount, @LostCount=LostCount, @DrawCount=DrawCount, @DrawCount=DrawCount,
		@FleeCount=FleeCount, @GameUserRight=UserRight, @GameMasterRight=MasterRight, @GameMasterOrder=MasterOrder, @AllLogonTimes=AllLogonTimes
	FROM GameScoreInfo WHERE UserID=@dwUserID

	-- 信息判断
	IF @Score IS NULL
	BEGIN
		-- 插入资料
		INSERT INTO GameScoreInfo (UserID, LastLogonIP, LastLogonMachine, RegisterIP, RegisterMachine)
		VALUES (@dwUserID, @strClientIP, @strMachineID, @strClientIP, @strMachineID)

		-- 游戏信息
		SELECT @Score=Score, @Insure=InsureScore, @WinCount=WinCount, @LostCount=LostCount,@DrawCount=DrawCount, @DrawCount=DrawCount,
			@FleeCount=FleeCount, @GameUserRight=UserRight, @GameMasterOrder=MasterOrder, @GameMasterRight=MasterRight, @AllLogonTimes=AllLogonTimes
		FROM GameScoreInfo WHERE UserID=@dwUserID
	END

	-- 异常判断
	IF @Score<0
	BEGIN
		-- 结束事务
		ROLLBACK TRAN
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED

		-- 错误信息
		SET @strErrorDescribe=N'抱歉地通知你，您的游戏币数据出现了异常情况，请联系客户服务中心了解详细情况！'
		RETURN 14
	END

	-- 锁定解除
	DELETE GameScoreLocker WHERE UserID=@dwUserID AND ServerID=@wServerID

	-- 查询锁定
	DECLARE @LockKindID INT
	DECLARE @LockServerID INT
	SELECT @LockKindID=KindID, @LockServerID=ServerID FROM GameScoreLocker WHERE UserID=@dwUserID

	-- 锁定判断
	IF @LockKindID IS NOT NULL AND @LockServerID IS NOT NULL
	BEGIN

		-- 结束事务
		ROLLBACK TRAN
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED

		-- 查询类型
		IF @LockKindID<>0
		BEGIN
			-- 查询信息
			DECLARE @KindName NVARCHAR(31)
			DECLARE @ServerName NVARCHAR(31)
			SELECT @KindName=KindName FROM RYPlatformDBLink.RYPlatformDB.dbo.GameKindItem WHERE KindID=@LockKindID
			SELECT @ServerName=ServerName FROM RYPlatformDBLink.RYPlatformDB.dbo.GameRoomInfo WHERE ServerID=@LockServerID

			-- 错误信息
			IF @KindName IS NULL SET @KindName=N'未知游戏'
			IF @ServerName IS NULL SET @ServerName=N'未知房间'
			SET @strErrorDescribe=N'您正在 [ '+@KindName+N' ] 的 [ '+@ServerName+N' ] 游戏房间中，不能同时再进入此游戏房间！'
			RETURN 4

		END
		ELSE
		BEGIN
			-- 提示消息
			SELECT [ErrorDescribe]=N'您正在进行保险柜处理过程中，暂时无法进入此游戏房间！'
			RETURN 4
		END
	END

	-- 保留变量
	SET @Grade=0
	SET @GroupID=0
	SET @GroupName=''

	-- 权限标志
	SET @UserRight=@UserRight|@GameUserRight
	SET @MasterRight=@MasterRight|@GameMasterRight

	-- 权限等级
	IF @GameMasterOrder>@MasterOrder SET @MasterOrder=@GameMasterOrder

	-- 进入记录
	INSERT RecordUserInout (UserID, EnterScore, EnterGrade, EnterInsure, EnterUserMedal,EnterLoveliness, KindID, ServerID, EnterClientIP, EnterMachine)
	VALUES (@UserID, @Score, @Grade, @Insure, @UserMedal, @Loveliness, @wKindID, @wServerID, @strClientIP, @strMachineID)

	-- 记录标识
	DECLARE @InoutIndex BIGINT
	SET @InoutIndex=SCOPE_IDENTITY()

	-- 插入锁表
	INSERT GameScoreLocker (UserID, ServerID, KindID, EnterID, EnterIP, EnterMachine) VALUES (@dwUserID, @wServerID, @wKindID, @InoutIndex, @strClientIP, @strMachineID)
	IF @@ERROR<>0
	BEGIN
		-- 结束事务
		ROLLBACK TRAN
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED

		-- 错误信息
		SET @strErrorDescribe=N'抱歉地通知你，游戏币锁定操作失败，请联系客户服务中心了解详细情况！'
		RETURN 14
	END

	--更新信息
	UPDATE GameScoreInfo SET AllLogonTimes=AllLogonTimes+1, LastLogonDate=GETDATE(), 
		LastLogonIP=@strClientIP,LastLogonMachine=@strMachineID WHERE UserID=@dwUserID

	-- 登录统计
	DECLARE @DateID INT
	SET @DateID=CAST(CAST(GETDATE() AS FLOAT) AS INT)

	-- 插入记录
	IF @AllLogonTimes>0
	BEGIN
		UPDATE SystemStreamInfo SET LogonCount=LogonCount+1 WHERE DateID=@DateID AND KindID=@wKindID AND ServerID=@wServerID
		IF @@ROWCOUNT=0 INSERT SystemStreamInfo (DateID, KindID, ServerID, LogonCount) VALUES (@DateID, @wKindID, @wServerID, 1)
	END
	ELSE
	BEGIN
		UPDATE SystemStreamInfo SET RegisterCount=RegisterCount+1 WHERE DateID=@DateID AND KindID=@wKindID AND ServerID=@wServerID
		IF @@ROWCOUNT=0 INSERT SystemStreamInfo (DateID, KindID, ServerID, RegisterCount) VALUES (@DateID, @wKindID, @wServerID, 1)
	END	

	-- 结束事务
	COMMIT TRAN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED

	-- 查询游戏豆
	SELECT @Beans=Currency FROM RYTreasureDBLink.RYTreasureDB.dbo.UserCurrencyInfo WHERE UserID=@UserID		
	IF @Beans IS NULL SET @Beans=0

	-- 房间参数
	SET @IntegralCount = 0
	SELECT  @IntegralCount=IntegralCount FROM GameScoreAttribute WHERE UserID=@dwUserID And ServerID=@wServerID And KindID = @wKindID
	
	-- 输出变量
	SELECT @UserID AS UserID, @GameID AS GameID, @GroupID AS GroupID, @NickName AS NickName, @UnderWrite AS UnderWrite,	@FaceID AS FaceID, @Beans AS Beans,
		@CustomID AS CustomID, @Gender AS Gender, @GroupName AS GroupName, @MasterOrder AS MemberOrder, @UserRight AS UserRight, @MasterRight AS MasterRight,
		@MasterOrder AS MasterOrder, @MemberOrder AS MemberOrder, @Score AS Score,  @Grade AS Grade, @Insure AS Insure, @UserMedal AS Ingot, @WinCount AS WinCount,
		@LostCount AS LostCount, @DrawCount AS DrawCount, @FleeCount AS FleeCount,@Experience AS Experience, @LoveLiness AS LoveLiness,@InoutIndex AS InoutIndex,
		@IntegralCount AS IntegralCount,@AgentID AS AgentID,@QQ AS QQ, @EMail AS EMail, @SeatPhone AS SeatPhone, @MobilePhone AS MobilePhone,
		@DwellingPlace AS DwellingPlace,@PostalCode AS PostalCode


END

RETURN 0

GO

----------------------------------------------------------------------------------------------------
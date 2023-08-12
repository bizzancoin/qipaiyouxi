USE RYTreasureDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_CreateTableFee]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_CreateTableFee]

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_CreateTableQuit]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_CreateTableQuit]

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_InsertCreateRecord]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_InsertCreateRecord]



---加载私人房间信息
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GS_QueryPersonalRoomInfo]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GS_QueryPersonalRoomInfo]
GO





SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- 扣除费用
CREATE PROC GSP_GR_CreateTableFee
	@dwUserID INT,								-- 用户 I D
	@dwServerID INT,							-- 房间 I D
	@dwDrawCountLimit INT,						-- 时间限制
	@dwDrawTimeLimit INT,						-- 局数限制
	@strClientIP NVARCHAR(15),					-- 连接地址
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 设置属性
SET NOCOUNT ON

-- 执行逻辑
BEGIN	
	DECLARE @ReturnValue INT
	DECLARE @dUserBeans DECIMAL(18,2)
	DECLARE @dCurBeans DECIMAL(18,2)
	DECLARE @Fee INT
	DECLARE @lRoomCard bigint
	DECLARE @cbIsJoinGame TINYINT
	DECLARE @MemberOrder TINYINT
	DECLARE @CreateRight TINYINT

	DECLARE @wKindID INT
	SELECT  @wKindID = KindID FROM RYPlatformDBLink.RYPlatformDB.dbo.GameRoomInfo WHERE ServerID = @dwServerID 
	-- 查询费用 及 房主是否参与游戏
	SELECT  @CreateRight = CreateRight FROM RYPlatformDBLink.RYPlatformDB.dbo.PersonalRoomInfo WHERE KindID = @wKindID 

	--检测玩家会员等级，不是vip会员不能创建私人房间
	SELECT @MemberOrder=MemberOrder FROM RYAccountsDB..AccountsInfo WHERE UserID=@dwUserID
	IF @MemberOrder < @CreateRight
	BEGIN
		SET @strErrorDescribe=N'您不具有创建私人房间的权限!'
		RETURN 1
	END

	--用户游戏豆
	SELECT @dUserBeans=Currency FROM RYTreasureDB..UserCurrencyInfo WHERE UserID=@dwUserID


	--用户房卡
	SELECT @lRoomCard=RoomCard FROM RYTreasureDB..UserRoomCard WHERE UserID=@dwUserID


		-- 查询锁定
	DECLARE @LockServerID INT
	SELECT @LockServerID=ServerID FROM GameScoreLocker WHERE UserID=@dwUserID

		-- 锁定判断
	IF  @LockServerID IS NOT NULL AND @LockServerID<>@dwServerID
	BEGIN
		-- 查询信息
		DECLARE @ServerName NVARCHAR(31)
		SELECT @ServerName=ServerName FROM RYPlatformDBLink.RYPlatformDB.dbo.GameRoomInfo WHERE ServerID=@LockServerID

		-- 错误信息
		IF @ServerName IS NULL SET @ServerName=N'未知房间'
		SET @strErrorDescribe=N'您正在 [ '+@ServerName+N' ] 游戏房间中，不能同时再进入此游戏房间！'
		RETURN 2
	END


	DECLARE @cbBeanOrRoomCard TINYINT

	SELECT  @cbBeanOrRoomCard = CardOrBean, @cbIsJoinGame = IsJoinGame FROM RYPlatformDBLink.RYPlatformDB.dbo.PersonalRoomInfo WHERE KindID = @wKindID 
		--SET @strErrorDescribe=N'数据库查 1' + '局数' +  CONVERT(nvarchar(32), @dwDrawCountLimit)+ '时间' +  CONVERT(nvarchar(32), @dwDrawTimeLimit) + '类型' +  CONVERT(nvarchar(32), @wKindID)
		--RETURN 1
	-- 查询费用
	SELECT @Fee=TableFee FROM RYPlatformDBLink.RYPlatformDB.dbo.PersonalTableFee WHERE DrawCountLimit=@dwDrawCountLimit AND DrawTimeLimit=@dwDrawTimeLimit AND KindID = @wKindID
	IF @Fee IS NULL OR @Fee=0
	BEGIN
		SET @strErrorDescribe=N'数据库查询费用失败，请重新尝试！'
		RETURN 3
	END


	IF @Fee IS NULL OR @Fee=0
	BEGIN
		SET @strErrorDescribe=N'数据库查询费用失败，请重新尝试！'
		RETURN 3
	END
	
	IF @cbBeanOrRoomCard = 0
	BEGIN

		IF @dUserBeans IS NULL
		BEGIN
			SET @strErrorDescribe=N'用户游戏豆不足，请购买！'
			RETURN 1
		END
				-- 写入费用
		IF @dUserBeans < @Fee
		BEGIN
			SET @strErrorDescribe=N'您的余额不足，请先充值。'
			RETURN 4
		END
		ELSE
		BEGIN
		
			-- 变化日志
			INSERT INTO RecordCurrencyChange(UserID,ChangeCurrency,ChangeType,BeforeCurrency,AfterCurrency,ClinetIP,InputDate,Remark)
			VALUES(@dwUserID,@Fee,1,@dUserBeans,@dUserBeans-@Fee,@strClientIP,GETDATE(),'创建私人房间')	

			UPDATE RYTreasureDB..UserCurrencyInfo SET Currency=@dUserBeans-@Fee WHERE UserID=@dwUserID		
		END
	END
	ELSE
	BEGIN

		IF @lRoomCard IS NULL
		BEGIN
			SET @strErrorDescribe=N'用户房卡不足，请购买！'
			RETURN 1
		END

		-- 写入费用
		IF @lRoomCard < @Fee
		BEGIN
			SET @strErrorDescribe=N'您的房卡不足，请先充值。'
			RETURN 4
		END
		ELSE
		BEGIN
		

			UPDATE RYTreasureDB..UserRoomCard SET RoomCard=@lRoomCard-@Fee WHERE UserID=@dwUserID	
			
			--获取金币和游戏豆
			DECLARE @lGold  BIGINT
			DECLARE @Currency  DECIMAL
			SELECT  @lGold = Score FROM GameScoreInfo WHERE UserID = @dwUserID
			SELECT  @Currency = Currency FROM UserCurrencyInfo WHERE UserID = @dwUserID
			IF @Currency IS NULL SET @Currency=0

			INSERT INTO RYRecordDB..RecordRoomCard(SourceUserID, SBeforeCard, RoomCard, TargetUserID, TBeforeCard, TypeID, Currency, Gold, Remarks, ClientIP, CollectDate)
			VALUES (@dwUserID, @lRoomCard, @Fee, 0, 0, 3, @Currency, @lGold, '解散房间退还房卡', @strClientIP, GETDATE())
	

		END		
	END


	SELECT @dCurBeans=Currency FROM RYTreasureDB..UserCurrencyInfo WHERE UserID=@dwUserID
	IF @dCurBeans IS NULL SET @dCurBeans=0

		--用户房卡
	SELECT @lRoomCard=RoomCard FROM RYTreasureDB..UserRoomCard WHERE UserID=@dwUserID
	IF @lRoomCard IS NULL SET @lRoomCard=0

	SELECT @dCurBeans AS dCurBeans, @lRoomCard AS RoomCard, @cbIsJoinGame AS IsJoinGame
END

RETURN 0
GO

----------------------------------------------------------------------------------------------------

-- 退还费用
CREATE PROC GSP_GR_CreateTableQuit
	@dwUserID INT,								-- 用户 I D
	@strRoomID NVARCHAR(6),							-- 房间标识
	@dwServerID INT,							-- 房间标识
	@dwDrawCountLimit INT,						-- 时间限制
	@dwDrawTimeLimit INT,						-- 局数限制
	@strClientIP NVARCHAR(15),					-- 连接地址
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 设置属性
SET NOCOUNT ON

-- 执行逻辑
BEGIN
	

	DECLARE @ReturnValue INT
	SET @ReturnValue=0

	DECLARE @Fee INT
	DECLARE @cbBeanOrRoomCard TINYINT
	DECLARE @cbJoin TINYINT

	DECLARE @wKindID INT
	SELECT  @wKindID = KindID FROM RYPlatformDBLink.RYPlatformDB.dbo.GameRoomInfo WHERE ServerID = @dwServerID 
	-- 查询费用 及 房主是否参与游戏
	SELECT  @cbBeanOrRoomCard = CardOrBean, @cbJoin = IsJoinGame FROM RYPlatformDBLink.RYPlatformDB.dbo.PersonalRoomInfo WHERE KindID = @wKindID 

	-- 查询费用
	SELECT @Fee=TableFee FROM RYPlatformDBLink.RYPlatformDB.dbo.PersonalTableFee WHERE DrawCountLimit=@dwDrawCountLimit AND DrawTimeLimit=@dwDrawTimeLimit AND KindID = @wKindID 

	IF @Fee IS NULL OR @Fee=0
	BEGIN
		SET @strErrorDescribe=N'数据库查询费用失败，请重新尝试！'
		RETURN 3
	END

	IF @cbBeanOrRoomCard = 0
	BEGIN
		IF  EXISTS(SELECT * FROM RYTreasureDB..UserCurrencyInfo WHERE UserID=@dwUserID)
		BEGIN
			DECLARE @dUserBeans DECIMAL(18,2)
			SELECT @dUserBeans=Currency FROM RYTreasureDB..UserCurrencyInfo WHERE UserID=@dwUserID

			-- 变化日志
			INSERT INTO RecordCurrencyChange(UserID,ChangeCurrency,ChangeType,BeforeCurrency,AfterCurrency,ClinetIP,InputDate,Remark)
			VALUES(@dwUserID,@Fee,1,@dUserBeans,@dUserBeans+@Fee,@strClientIP,GETDATE(),'私人房间退还费用')
			
			UPDATE UserCurrencyInfo SET Currency=Currency+@Fee WHERE UserID=@dwUserID
			SET @ReturnValue=0
		END	
		ELSE
		BEGIN
			SET @ReturnValue=2
			SET @strErrorDescribe=N'找不到用户信息'
		END
	END
	ELSE
	BEGIN
		IF  EXISTS(SELECT * FROM RYTreasureDB..UserRoomCard WHERE UserID=@dwUserID)
		BEGIN
			DECLARE @lRoomCard bigint
			SELECT @lRoomCard=RoomCard FROM RYTreasureDB..UserRoomCard WHERE UserID=@dwUserID

			
			UPDATE UserRoomCard SET RoomCard=@lRoomCard+@Fee WHERE UserID=@dwUserID
			SET @ReturnValue=0

			--获取金币和游戏豆
			DECLARE @lGold  BIGINT
			DECLARE @Currency  DECIMAL
			SELECT  @lGold = Score FROM GameScoreInfo WHERE UserID = @dwUserID
			SELECT  @Currency = Currency FROM UserCurrencyInfo WHERE UserID = @dwUserID
			IF @Currency IS NULL SET @Currency=0

			INSERT INTO RYRecordDB..RecordRoomCard(SourceUserID, SBeforeCard, RoomCard, TargetUserID, TBeforeCard, TypeID, Currency, Gold, Remarks, ClientIP, CollectDate)
			VALUES (@dwUserID, @lRoomCard + @Fee, @Fee, 0, 0, 3, @Currency, @lGold, '创建房间消耗房卡', @strClientIP, GETDATE())

		END	
		ELSE
		BEGIN
			SET @ReturnValue=2
			SET @strErrorDescribe=N'找不到用户信息'
		END
	END

	--必须参与游戏房主解锁
	IF @cbJoin = 1
	BEGIN
		DELETE FROM GameScoreLocker WHERE UserID = @dwUserID
	END

	DECLARE @dCurBeans DECIMAL(18,2)
	SELECT @dCurBeans=Currency FROM RYTreasureDB..UserCurrencyInfo WHERE UserID=@dwUserID
	IF @dCurBeans IS NULL SET @dCurBeans=0

		--用户房卡
	SELECT @lRoomCard=RoomCard FROM RYTreasureDB..UserRoomCard WHERE UserID=@dwUserID
	IF @lRoomCard IS NULL SET @lRoomCard=0

	SELECT @dCurBeans AS dCurBeans, @lRoomCard AS RoomCard

END

RETURN @ReturnValue
GO


-----------------------------------------------------------------------
-- 创建房间记录
CREATE PROC GSP_GR_InsertCreateRecord
	@dwUserID INT,								-- 用户 I D
	@dwServerID INT,							-- 房间 标识
	@RoomID nvarchar(6),						-- 房间 ID
	@lCellScore INT,							-- 房间 底分
	@dwDrawCountLimit INT,						-- 时间限制
	@dwDrawTimeLimit INT,						-- 局数限制
	@szPassWord NVARCHAR(15),					-- 连接地址
	@wJoinGamePeopleCount SMALLINT,				-- 时间限制
	@dwRoomTax BIGINT,							-- 私人房间税收
	@strClientAddr NVARCHAR(15),
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 设置属性
SET NOCOUNT ON

-- 执行逻辑
BEGIN	

	DECLARE @Fee INT
	DECLARE @Nicname NVARCHAR(31)
	DECLARE @lPersonalRoomTax BIGINT

		-- 查询费用 及 房主是否参与游戏
	DECLARE @cbBeanOrRoomCard TINYINT
	DECLARE @wKindID INT
	SELECT  @wKindID = KindID FROM RYPlatformDBLink.RYPlatformDB.dbo.GameRoomInfo  WHERE ServerID = @dwServerID 
	-- 查询费用
	SELECT @Fee=TableFee FROM RYPlatformDBLink.RYPlatformDB.dbo.PersonalTableFee WHERE DrawCountLimit=@dwDrawCountLimit AND DrawTimeLimit=@dwDrawTimeLimit AND KindID = @wKindID 
	IF @Fee IS NULL OR @Fee=0
	BEGIN
		SET @strErrorDescribe=N'数据库查询费用失败，请重新尝试！'
		RETURN 3
	END

	-- 获取创建房间玩家的昵称
	SELECT @Nicname =NickName FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo WHERE UserID = @dwUserID
	IF @Nicname IS NULL
	SET @Nicname =''
		
	SELECT   @cbBeanOrRoomCard = CardOrBean, @lPersonalRoomTax = PersonalRoomTax FROM RYPlatformDBLink.RYPlatformDB.dbo.PersonalRoomInfo WHERE KindID = @wKindID 
	
	--如果是消耗房卡，查询代理税收
	DECLARE @lTaxAgency BIGINT
	SELECT  @lTaxAgency = AgentScale FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsAgent WHERE UserID = @dwUserID 
	IF @lTaxAgency IS NOT NULL
	BEGIN
		SET @lPersonalRoomTax = @lTaxAgency
	END

	--获取金币和游戏豆
	DECLARE @lGold  BIGINT
	DECLARE @Currency  DECIMAL
	SELECT  @lGold = Score FROM GameScoreInfo WHERE UserID = @dwUserID
	SELECT  @Currency = Currency FROM UserCurrencyInfo WHERE UserID = @dwUserID

	IF @cbBeanOrRoomCard = 1
	BEGIN
		--用户房卡
		DECLARE @lRoomCard BIGINT
		SELECT @lRoomCard=RoomCard FROM RYTreasureDB..UserRoomCard WHERE UserID=@dwUserID
		IF @lRoomCard IS NULL SET @lRoomCard=0
		IF @Currency IS NULL SET @Currency=0

		INSERT INTO RYRecordDB..RecordRoomCard(SourceUserID, SBeforeCard, RoomCard, TargetUserID, TBeforeCard, TypeID, Currency, Gold, Remarks, ClientIP, CollectDate)
		VALUES (@dwUserID, @lRoomCard + @Fee, @Fee, 0, 0, 3, @Currency, @lGold, '创建房间消耗房卡', @strClientAddr, GETDATE())
	END

	-- 写入消耗放开记录
	INSERT INTO RYPlatformDB..StreamCreateTableFeeInfo(UserID,NickName, ServerID, RoomID, CellScore, CardOrBean, CountLimit,TimeLimit,CreateTableFee,CreateDate, TaxAgency, JoinGamePeopleCount)
												VALUES(@dwUserID,@Nicname, @dwServerID, @RoomID, @lCellScore,@cbBeanOrRoomCard, @dwDrawCountLimit, @dwDrawTimeLimit, @Fee,GETDATE(), @dwRoomTax, @wJoinGamePeopleCount)	


END

RETURN 0
GO

-----------------------------------------------------------------------------------------------------



----------------------------------------------------------------------------------------------------------
-- 请求私人房间信息
CREATE  PROCEDURE dbo.GSP_GS_QueryPersonalRoomInfo
	@dwRoomID NVARCHAR(7),								-- 房间标识
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 设置属性
SET NOCOUNT ON

-- 执行逻辑
BEGIN
	DECLARE @dwUserID	INT
	DECLARE @Nicname NVARCHAR(31)
	DECLARE @dwPlayTurnCount INT
	DECLARE @dwPlayTimeLimit INT
	DECLARE @cbIsDisssumRoom TINYINT
	DECLARE @sysCreateTime DATETIME
	DECLARE @sysDissumeTime DATETIME
	DECLARE @lTaxCount BIGINT
	DECLARE @cbRoomCardOrBean TINYINT
	DECLARE @lCreateFee TINYINT
	DECLARE @bnryRoomScoreInfo varbinary(MAX)
	-- 加载房间
	SELECT @dwUserID = UserID, @dwPlayTurnCount=CountLimit, @dwPlayTimeLimit = TimeLimit, @sysCreateTime = CreateDate, @sysDissumeTime = DissumeDate, @lTaxCount = TaxRevenue, @lCreateFee = CreateTableFee,
	 @cbRoomCardOrBean = CardOrBean, @bnryRoomScoreInfo = RoomScoreInfo
	FROM RYPlatformDB..StreamCreateTableFeeInfo WHERE RoomID = @dwRoomID
	IF @sysDissumeTime IS NULL
	BEGIN
		SET @cbIsDisssumRoom = 0
		SET @sysDissumeTime = @sysCreateTime
	END
	ELSE
	BEGIN
		SET @cbIsDisssumRoom = 1
	END

	declare @strRoomScoreInfo varchar(8000),@i int
	select @strRoomScoreInfo='',@i=datalength(@bnryRoomScoreInfo)
	while @i>0
		select @strRoomScoreInfo=substring('0123456789ABCDEF',substring(@bnryRoomScoreInfo,@i,1)/16+1,1)
				+substring('0123456789ABCDEF',substring(@bnryRoomScoreInfo,@i,1)%16+1,1)
				+@strRoomScoreInfo
			,@i=@i-1

	-- 获取玩家昵称
	SELECT @Nicname =NickName FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo WHERE UserID = @dwUserID
	IF @Nicname IS NULL
	SET @Nicname =''


	if @dwPlayTurnCount is null
	set @dwPlayTurnCount=0

	if @dwPlayTimeLimit is null
	set @dwPlayTimeLimit=0

	if @cbIsDisssumRoom is null
	set @cbIsDisssumRoom=0

	if @sysDissumeTime is null
	set @sysDissumeTime=GETDATE()

	if @sysCreateTime is null
	set @sysCreateTime=GETDATE()

	if @lTaxCount is null
	set @lTaxCount=0

	if @cbRoomCardOrBean is null
	set @cbRoomCardOrBean=0

	if @lCreateFee is null
	set @lCreateFee=0

	SELECT @Nicname AS UserNicname, @dwPlayTurnCount AS dwPlayTurnCount, @dwPlayTimeLimit AS dwPlayTimeLimit, @cbIsDisssumRoom AS cbIsDisssumRoom, @sysCreateTime AS sysCreateTime, 
	@sysDissumeTime AS sysDissumeTime, @lTaxCount AS lTaxCount, @lCreateFee AS CreateTableFee,@cbRoomCardOrBean AS CardOrBean, @bnryRoomScoreInfo AS RoomScoreInfo, @strRoomScoreInfo AS strRoomScoreInfo

END

RETURN 0

GO


-------------------------------------

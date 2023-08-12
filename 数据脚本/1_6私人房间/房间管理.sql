
----------------------------------------------------------------------------------------------------

USE RYPlatformDB
GO


IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GS_DeleteGameRoom]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GS_DeleteGameRoom]
GO



---插入私人房间参数
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GS_InsertPersonalRoomParameter]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GS_InsertPersonalRoomParameter]
GO

--修改私人房间参数
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GS_ModifyPersonalRoomParameter]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GS_ModifyPersonalRoomParameter]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_DissumePersonalRoom]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_DissumePersonalRoom]
GO


SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------



----------------------------------------------------------------------------------------------------

-- 删除房间
CREATE  PROCEDURE dbo.GSP_GS_DeleteGameRoom
	@wServerID INT,								-- 房间标识
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 设置属性
SET NOCOUNT ON

-- 执行逻辑
BEGIN

	-- 查找房间
	DECLARE @ServerID INT
	SELECT @ServerID=ServerID FROM GameRoomInfo(NOLOCK) WHERE ServerID=@wServerID

	-- 结果判断
	IF @ServerID IS NULL
	BEGIN
		SET @strErrorDescribe=N'游戏房间不存在或者已经被删除了，房间修改失败！'
		RETURN 1
	END

	-- 删除房间
	DELETE GameRoomInfo WHERE ServerID=@wServerID

	-- 删除私人房间参数
	DELETE PersonalRoomInfo WHERE ServerID=@wServerID

END

RETURN 0

GO

----------------------------------------------------------------------------------------------------



----------------------------------------------------------------------------------------------------

-- 插入房间
CREATE  PROCEDURE dbo.GSP_GS_InsertPersonalRoomParameter

	-- 索引变量
	@wServerID INT,								-- 房间标识
	@wKindID INT,								-- 房间ID
	@cbCardOrBean TINYINT,						-- 使用房卡还是游戏豆
	@lFeeBeanOrRoomCard BIGINT,					-- 消耗房卡或游戏豆的数量
	@cbIsJoinGame TINYINT,						-- 是否参与游戏
	@cbMinPeople TINYINT,						-- 参与游戏的最小人数
	@cbMaxPeople TINYINT,						-- 参与游戏的最大人数

	-- 积分配置
	@lPersonalRoomTax  BIGINT,					-- 私人房间游戏税收
	@lMaxCellScore BIGINT,						-- 最大底分
	@wCanCreateCount SMALLINT,					-- 可以创建的最大房间数目
	@wPlayTurnCount INT,						-- 房间能够进行游戏的最大局数

	-- 限制配置
	@wPlayTimeLimit	INT,						-- 房间能够进行游戏的最大时间
	@wTimeAfterBeginCount	INT,				-- 一局游戏开始后多长时间后解散桌子
	@wTimeOffLineCount	INT,					-- 玩家掉线多长时间后解散桌子
	@wTimeNotBeginGame	INT,					-- 玩家坐下后多长时间后还未开始游戏解散桌子
	@wTimeNotBeginAfterCreateRoom	INT,		-- 房间创建后多长时间后还未开始游戏解散桌子
	@cbCreateRight	TINYINT,					-- 创建私人房间权限
		-- 输出信息
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 设置属性
SET NOCOUNT ON

-- 执行逻辑
BEGIN

	-- 插入私人房间参数
	INSERT INTO PersonalRoomInfo (ServerID,  KindID, CardOrBean, FeeBeanOrRoomCard, IsJoinGame, MinPeople, MaxPeople, PersonalRoomTax, MaxCellScore, CanCreateCount, 
				PlayTurnCount, PlayTimeLimit, TimeAfterBeginCount, TimeOffLineCount,TimeNotBeginGame, TimeNotBeginAfterCreateRoom, CreateRight)
	VALUES (@wServerID,@wKindID,  @cbCardOrBean, @lFeeBeanOrRoomCard, @cbIsJoinGame, @cbMinPeople, @cbMaxPeople, @lPersonalRoomTax, @lMaxCellScore, @wCanCreateCount, @wPlayTurnCount, 
	@wPlayTimeLimit, @wTimeAfterBeginCount, @wTimeOffLineCount, @wTimeNotBeginGame, @wTimeNotBeginAfterCreateRoom, @cbCreateRight)


END

RETURN 0

GO


----------------------------------------------------------------------------------------------------
-- 修改私人房间参数
CREATE  PROCEDURE dbo.GSP_GS_ModifyPersonalRoomParameter

	-- 索引变量
	@wServerID INT,								-- 房间标识
	@wKindID INT,								-- 房间标识
	@cbCardOrBean TINYINT,						-- 使用房卡还是游戏豆
	@lFeeBeanOrRoomCard BIGINT,					-- 消耗房卡或游戏豆的数量
	@cbIsJoinGame TINYINT,						-- 是否参与游戏
	@cbMinPeople TINYINT,						-- 参与游戏的最小人数
	@cbMaxPeople TINYINT,						-- 参与游戏的最大人数

	-- 积分配置
	@lPersonalRoomTax  BIGINT,					-- 初始游分数
	@lMaxCellScore BIGINT,						-- 最大底分
	@wCanCreateCount int,						-- 可以创建的最大房间数目
	@wPlayTurnCount INT,						-- 房间能够进行游戏的最大局数

	-- 限制配置
	@wPlayTimeLimit	INT,						-- 房间能够进行游戏的最大时间
	@wTimeAfterBeginCount	INT,				-- 一局游戏开始后多长时间后解散桌子
	@wTimeOffLineCount	INT,					-- 玩家掉线多长时间后解散桌子
	@wTimeNotBeginGame	INT,					-- 房间创建多长时间后还未开始游戏解散桌子
	@wTimeNotBeginAfterCreateRoom	INT,		-- 房间创建后多长时间后还未开始游戏解散桌子
	@cbCreateRight	TINYINT,					-- 创建私人房间权限

	-- 输出信息
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 设置属性
SET NOCOUNT ON

-- 执行逻辑
BEGIN
	DECLARE @dwServerID INT
	SELECT  @dwServerID = ServerID FROM PersonalRoomInfo WHERE KindID = @wKindID
	IF @dwServerID IS NULL
	BEGIN
		-- 插入私人房间参数
		INSERT INTO PersonalRoomInfo (ServerID,  KindID, CardOrBean, FeeBeanOrRoomCard, IsJoinGame, MinPeople, MaxPeople, PersonalRoomTax, MaxCellScore, CanCreateCount, 
					PlayTurnCount, PlayTimeLimit, TimeAfterBeginCount, TimeOffLineCount,TimeNotBeginGame, TimeNotBeginAfterCreateRoom, CreateRight)
		VALUES (@wServerID,@wKindID,  @cbCardOrBean, @lFeeBeanOrRoomCard, @cbIsJoinGame, @cbMinPeople, @cbMaxPeople, @lPersonalRoomTax, @lMaxCellScore, @wCanCreateCount, @wPlayTurnCount, 
		@wPlayTimeLimit, @wTimeAfterBeginCount, @wTimeOffLineCount, @wTimeNotBeginGame, @wTimeNotBeginAfterCreateRoom, @cbCreateRight)
	END
	ELSE
	BEGIN
		--插入私人房间参数
		UPDATE PersonalRoomInfo SET CardOrBean = @cbCardOrBean,FeeBeanOrRoomCard = @lFeeBeanOrRoomCard, IsJoinGame = @cbIsJoinGame, MinPeople = @cbMinPeople, MaxPeople = @cbMaxPeople,PersonalRoomTax = @lPersonalRoomTax, MaxCellScore = @lMaxCellScore,
									 PlayTurnCount = @wPlayTurnCount, PlayTimeLimit = @wPlayTimeLimit, TimeAfterBeginCount = @wTimeAfterBeginCount, CanCreateCount = @wCanCreateCount,
									TimeOffLineCount = @wTimeOffLineCount,TimeNotBeginGame = @wTimeNotBeginGame, TimeNotBeginAfterCreateRoom = @wTimeNotBeginAfterCreateRoom, CreateRight = @cbCreateRight
		WHERE KindID = @wKindID
	END

END

RETURN 0

GO

----------------------------------------------------------------------------------------------------


-- 解散私人房
CREATE PROC GSP_GR_DissumePersonalRoom
	@RoomID nvarchar(6),						-- 房间 ID
	@lTaxCount varchar(MAX),
	@cbPersonalRoomInfo varbinary(MAX),
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 设置属性
SET NOCOUNT ON

-- 执行逻辑
BEGIN	
	DECLARE @tDissumDate datetime
	DECLARE @TaxRatio INT
	SET @TaxRatio = 0
	DECLARE @RoomTaxRatio INT
	DECLARE @ServerID INT
	DECLARE @TaxAgency	INT 
	SET @RoomTaxRatio = 0
	SET @ServerID = 0

	-- 获得时间,房间标识
	select @tDissumDate = DissumeDate, @ServerID = ServerID, @TaxAgency = TaxAgency from RYPlatformDB..StreamCreateTableFeeInfo where RoomID = @RoomID

	-- 获取对应房间的税收比例
	select @RoomTaxRatio = RevenueRatio from RYPlatformDB..GameRoomInfo where ServerID = @ServerID

	if @TaxAgency is null
	begin
		set @TaxAgency = 0
	end

	if @RoomTaxRatio is null or @RoomTaxRatio = 0
	begin
		set @TaxAgency = 1
	end

	declare @TaxRevenue int
	set @TaxRevenue = 0
	if @RoomTaxRatio is null or @RoomTaxRatio = 0
	begin
		set @RoomTaxRatio = @lTaxCount
	end
	else
	begin
		set @RoomTaxRatio =  @lTaxCount * @TaxAgency/@RoomTaxRatio
	end


	-- 写入创建记录
	UPDATE  RYPlatformDB..StreamCreateTableFeeInfo   SET  DissumeDate = GETDATE(),TaxCount = @lTaxCount, RoomScoreInfo = @cbPersonalRoomInfo  WHERE RoomID = @RoomID




	if @tDissumDate is null
	SET  @tDissumDate = GETDATE()

	--解锁
	DECLARE @temp TABLE
	(
	UserID INT
	);

	-- 将源表中的数据插入到表变量中
	INSERT INTO @temp(UserID)
	SELECT UserID FROM PersonalRoomScoreInfo WHERE RoomID = @RoomID
	ORDER BY UserID;

	-- 声明变量
	DECLARE
	@UserID AS INT,
	@firstname AS NVARCHAR(10),
	@lastname AS NVARCHAR(20);
     
	WHILE EXISTS(SELECT UserID FROM @temp)
	BEGIN
	-- 也可以使用top 1
	SET ROWCOUNT 1
	SELECT @UserID= UserID FROM @temp;
	DELETE FROM RYTreasureDBLink.RYTreasureDB.dbo.GameScoreLocker where UserID = @UserID;
	SET ROWCOUNT 0 
	DELETE FROM @temp WHERE UserID=@UserID;
	END

	select @tDissumDate AS DissumeDate
												
END

RETURN 0
GO

-----------------------------------------------



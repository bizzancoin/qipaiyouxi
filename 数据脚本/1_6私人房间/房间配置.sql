USE RYPlatformDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GS_WritePersonalFeeParameter]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GS_WritePersonalFeeParameter]

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GS_DeletePersonalFeeParameter]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GS_DeletePersonalFeeParameter]

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_MB_GetPersonalParameter]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_MB_GetPersonalParameter]

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_MB_GetPersonalFeeParameter]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_MB_GetPersonalFeeParameter]

---加载私人房间参数
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GS_LoadPersonalRoomParameter]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GS_LoadPersonalRoomParameter]

---加载私人房间参数
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GS_LoadPersonalRoomParameterByKindID]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].GSP_GS_LoadPersonalRoomParameterByKindID
GO

----获取单个玩家进入过的房间
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GS_GetPersonalRoomUserScore]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GS_GetPersonalRoomUserScore]
GO


----写入结束时间
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GS_CloseRoomWriteDissumeTime]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GS_CloseRoomWriteDissumeTime]
GO


SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------



CREATE PROC GSP_MB_GetPersonalParameter
	@wServerID INT,									-- 游戏 I D
	@strErrorDescribe NVARCHAR(127) OUTPUT			-- 输出信息
WITH ENCRYPTION AS

	DECLARE @lPersonalRoomTax  BIGINT						-- 初始游分数

	DECLARE @cbCardOrBean TINYINT					-- 使用房卡还是游戏豆
	DECLARE @lFeeBeanOrRoomCard BIGINT				-- 消耗房卡或游戏豆的数量
	DECLARE @cbIsJoinGame TINYINT					-- 是否参与游戏
	DECLARE @cbMinPeople TINYINT					-- 参与游戏的最小人数
	DECLARE @cbMaxPeople TINYINT					-- 参与游戏的最大人数

	-- 积分配置
	DECLARE @lMaxCellScore BIGINT					-- 最大底分
	DECLARE @wCanCreateCount int					-- 可以创建的最大房间数目
	DECLARE @wPlayTurnCount INT						-- 房间能够进行游戏的最大局数

	-- 限制配置
	DECLARE @wPlayTimeLimit	INT						-- 房间能够进行游戏的最大时间

BEGIN

	-- 加载房间
	SELECT @cbCardOrBean = CardOrBean, @lFeeBeanOrRoomCard = FeeBeanOrRoomCard, @cbIsJoinGame = IsJoinGame, @cbMinPeople = MinPeople,
		   @cbMaxPeople = MaxPeople,@lPersonalRoomTax = PersonalRoomTax, @lMaxCellScore = MaxCellScore, @wCanCreateCount = CanCreateCount, @wPlayTurnCount = PlayTurnCount,
		   @wPlayTimeLimit = PlayTimeLimit
	FROM PersonalRoomInfo WHERE @wServerID=ServerID

	SELECT @cbCardOrBean AS CardOrBean, @lFeeBeanOrRoomCard AS FeeBeanOrRoomCard, @cbIsJoinGame AS IsJoinGame, @cbMinPeople AS MinPeople,
		   @cbMaxPeople AS MaxPeople,@lPersonalRoomTax AS PersonalRoomTax, @lMaxCellScore AS MaxCellScore, @wCanCreateCount AS CanCreateCount, @wPlayTurnCount AS PlayTurnCount,
		   @wPlayTimeLimit AS PlayTimeLimit
END

RETURN 0
GO


------------------------------------------------------
---费用配置
CREATE PROC GSP_GS_WritePersonalFeeParameter
	@KindID	INT,				-- 
	@DrawCountLimit	INT,				-- 
	@DrawTimeLimit	INT,					-- 玩家掉线多长时间后解散桌子
	@TableFee	INT,					-- 房间创建多长时间后还未开始游戏解散桌子
	@IniScore	INT,		-- 房间创建后多长时间后还未开始游戏解散桌子
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

BEGIN
	INSERT INTO PersonalTableFee (KindID, DrawCountLimit,DrawTimeLimit, TableFee, IniScore ) 
	VALUES (@KindID, @DrawCountLimit,@DrawTimeLimit, @TableFee, @IniScore  ) 
END

return 0
GO

---费用配置
CREATE PROC GSP_GS_DeletePersonalFeeParameter
	@KindID	INT,				-- 
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

BEGIN
	
	DELETE  FROM PersonalTableFee WHERE  KindID = @KindID
	
END

return 0
GO


------------------------------------------------------
---费用配置
CREATE PROC GSP_MB_GetPersonalFeeParameter
	@dwKindID INT,								-- 游戏 I D
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

BEGIN

	DECLARE @DrawCountLimit	INT				-- 
	DECLARE @DrawTimeLimit	INT					-- 玩家掉线多长时间后解散桌子
	DECLARE @TableFee	INT					-- 房间创建多长时间后还未开始游戏解散桌子
	DECLARE @IniScore	INT		-- 房间创建后多长时间后还未开始游戏解散桌子

	DECLARE @cbIsJoinGame TINYINT						-- 是否参与游戏
	DECLARE @wTimeAfterBeginCount	INT				-- 一局游戏开始后多长时间后解散桌子
	DECLARE @wTimeOffLineCount	INT					-- 玩家掉线多长时间后解散桌子
	DECLARE @wTimeNotBeginGame	INT					-- 房间创建多长时间后还未开始游戏解散桌子
	DECLARE @wTimeNotBeginAfterCreateRoom	INT		-- 房间创建后多长时间后还未开始游戏解散桌子


	SELECT  DrawCountLimit, DrawTimeLimit, TableFee,IniScore FROM PersonalTableFee WHERE KindID=@dwKindID

	
END

return 0
GO



---------------------------------------------------------------
-- 加载配置
CREATE PROC GSP_GS_LoadPersonalRoomParameter
	@wKindID INT,								-- 房间标识
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

DECLARE @cbCardOrBean TINYINT						-- 使用房卡还是游戏豆
	DECLARE @lFeeBeanOrRoomCard BIGINT					-- 消耗房卡或游戏豆的数量
	DECLARE @cbIsJoinGame TINYINT						-- 是否参与游戏
	DECLARE @cbMinPeople TINYINT						-- 参与游戏的最小人数
	DECLARE @cbMaxPeople TINYINT						-- 参与游戏的最大人数

	-- 积分配置
	DECLARE @lPersonalRoomTax  BIGINT							-- 初始游分数
	DECLARE @lMaxCellScore BIGINT						-- 最大底分
	DECLARE @wCanCreateCount int						-- 可以创建的最大房间数目
	DECLARE @wPlayTurnCount INT						-- 房间能够进行游戏的最大局数
	DECLARE @cbCreateRight TINYINT						-- 创建私人房间权限

	-- 限制配置
	DECLARE @wPlayTimeLimit	INT						-- 房间能够进行游戏的最大时间
	DECLARE @wTimeAfterBeginCount	INT				-- 一局游戏开始后多长时间后解散桌子
	DECLARE @wTimeOffLineCount	INT					-- 玩家掉线多长时间后解散桌子
	DECLARE @wTimeNotBeginGame	INT					-- 房间创建多长时间后还未开始游戏解散桌子
	DECLARE @wTimeNotBeginAfterCreateRoom	INT		-- 房间创建后多长时间后还未开始游戏解散桌子

-- 执行逻辑
BEGIN

	SET @cbCardOrBean = 0
	SET @lFeeBeanOrRoomCard = 0
	SET @cbIsJoinGame = 0
	SET @cbMinPeople = 0
	SET @cbMaxPeople = 0
	SET @lPersonalRoomTax =1
	SET @lMaxCellScore = 0
	SET @lPersonalRoomTax = 0
	SET @lMaxCellScore = 0
	SET @wCanCreateCount = 0
	SET @wPlayTurnCount = 0
	SET @wPlayTimeLimit = 0
	SET @wTimeAfterBeginCount = 0
	SET @wTimeOffLineCount = 0
	SET @wTimeNotBeginGame = 0
	SET @wTimeNotBeginAfterCreateRoom = 0
	SET @cbCreateRight = 0

	----查询最近一次相同类型游戏修改配置
	--DECLARE @dwLastServerID INT
	--SET @dwLastServerID = 0
	--SELECT @dwLastServerID=KindID FROM GameRoomInfo WHERE KindID = @wServerID
	


	-- 加载房间
	SELECT @cbCardOrBean=CardOrBean, @lFeeBeanOrRoomCard=FeeBeanOrRoomCard,@cbIsJoinGame=IsJoinGame,@cbMinPeople=MinPeople, @cbMaxPeople=MaxPeople, @lPersonalRoomTax =PersonalRoomTax,
	@lMaxCellScore= MaxCellScore, @wCanCreateCount= CanCreateCount, @wPlayTurnCount=PlayTurnCount, @wPlayTimeLimit= PlayTimeLimit, @wTimeAfterBeginCount = TimeAfterBeginCount, 
	@wTimeOffLineCount = TimeOffLineCount, @wTimeNotBeginGame = TimeNotBeginGame, @wTimeNotBeginAfterCreateRoom = TimeNotBeginAfterCreateRoom, @cbCreateRight = CreateRight
	FROM PersonalRoomInfo WHERE KindID = @wKindID



	SELECT @cbCardOrBean AS CardOrBean, @lFeeBeanOrRoomCard AS FeeBeanOrRoomCard,@cbIsJoinGame AS IsJoinGame,@cbMinPeople AS MinPeople, @cbMaxPeople AS MaxPeople, @lPersonalRoomTax AS PersonalRoomTax,
	@lMaxCellScore AS MaxCellScore, @wCanCreateCount AS CanCreateCount, @wPlayTurnCount AS PlayTurnCount, @wPlayTimeLimit AS PlayTimeLimit, @wTimeAfterBeginCount AS TimeAfterBeginCount, 
	@wTimeOffLineCount AS TimeOffLineCount, @wTimeNotBeginGame AS TimeNotBeginGame, @wTimeNotBeginAfterCreateRoom AS TimeNotBeginAfterCreateRoom, @cbCreateRight AS CreateRight

END

RETURN 0

GO
----------------------------------------------------------------------------------------------------
-----------------------------------------------
--获取房间玩家积分

-- 请求私人房间信息
CREATE PROC GSP_GS_GetPersonalRoomUserScore
	@dwUserID INT,								-- 用户 I D
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 设置属性
SET NOCOUNT ON

-- 执行逻辑
BEGIN

	-- 加载房间
	SELECT * FROM PersonalRoomScoreInfo WHERE UserID = @dwUserID ORDER BY WriteTime DESC

END

RETURN 0

GO


----------------------------------------------------------------------------------------------------
-----------------------------------------------
--获取房间玩家积分

-- 请求私人房间信息
CREATE PROC GSP_GS_CloseRoomWriteDissumeTime
	@dwServerID INT,								-- 用户 I D
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 设置属性
SET NOCOUNT ON

-- 执行逻辑
BEGIN
	--删除此房间的所有锁表
	DELETE FROM RYTreasureDBLink.RYTreasureDB.dbo.GameScoreLocker WHERE ServerID = @dwServerID;

	-- 更新房间
	UPDATE StreamCreateTableFeeInfo SET DissumeDate = GetDATE() WHERE ServerID = @dwServerID AND datediff(dd,CreateDate,getdate()) = 0 AND DissumeDate IS NULL

END

RETURN 0

GO

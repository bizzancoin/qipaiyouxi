
----------------------------------------------------------------------------------------------------

USE RYGameMatchDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[WF_SplitStr]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION dbo.[WF_SplitStr]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GS_LoadGameMatchItem]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GS_LoadGameMatchItem]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GS_DeleteGameMatchItem]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GS_DeleteGameMatchItem]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GS_InsertGameMatchItem]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GS_InsertGameMatchItem]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GS_ModifyGameMatchItem]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GS_ModifyGameMatchItem]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GS_LoadMatchReward]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GS_LoadMatchReward]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------
-- 拆分字符串
CREATE FUNCTION [dbo].[WF_SplitStr]
(
	@strSource NVARCHAR(1024),		--源字符串
	@strSeparator CHAR(1)			--分隔符号
)
RETURNS @tbResult TABLE(id INT IDENTITY(1,1),rs NVARCHAR(1000))
WITH ENCRYPTION AS  
BEGIN 
   DECLARE @dwIndex INT ,@strResult NVARCHAR(1000);
   SET @strSource = RTRIM(LTRIM(@strSource)); -- 消空格
   SET @dwIndex = CHARINDEX(@strSeparator,@strSource);	-- 取得第一个分隔符的位置

   WHILE @dwIndex>0
   BEGIN 
      SET @strResult = LTRIM(RTRIM(LEFT(@strSource,@dwIndex-1)));
--      IF @strResult IS NULL OR @strResult = '' OR @strResult = @strSeparator
--      BEGIN 
--        SET @strSeparator = SUBSTRING(@strSource,@dwIndex+1,LEN(@strSource)-@dwIndex); --将要操作的字符串去除已切分部分
--        SET @dwIndex = CHARINDEX(@strSeparator,@strSource); --循环量增加
--		CONTINUE;
--      END 

      INSERT @tbResult VALUES(@strResult);
      SET @strSource = SUBSTRING(@strSource,@dwIndex+1,LEN(@strSource)-@dwIndex); --将要操作的字符串去除已切分部分
      SET @dwIndex=CHARINDEX(@strSeparator,@strSource); --循环量增加
   END 

   --处理最后一节
   IF  @strSource IS NOT NULL AND LTRIM(RTRIM(@strSource)) <> '' AND @strSource <> @strSeparator 
   BEGIN 
      INSERT @tbResult VALUES(@strSource)
   END 

   RETURN
END

GO
----------------------------------------------------------------------------------------------------

-- 加载比赛
CREATE  PROCEDURE dbo.GSP_GS_LoadGameMatchItem
	@wKindID   INT,								-- 类型标识
	@dwMatchID INT,								-- 比赛标识	
	@strServiceMachine NCHAR(32),				-- 服务机器
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 设置属性
SET NOCOUNT ON

-- 执行逻辑
BEGIN
	
	-- 加载比赛
	SELECT * FROM MatchPublic WHERE ((KindID=@wKindID AND MatchID=@dwMatchID) OR (@dwMatchID=0 AND KindID=@wKindID AND ServiceMachine=@strServiceMachine)) AND Nullity=0

END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

-- 删除比赛
CREATE  PROCEDURE dbo.GSP_GS_DeleteGameMatchItem	
	@dwMatchID INT								-- 比赛标识	
WITH ENCRYPTION AS

-- 设置属性
SET NOCOUNT ON

-- 执行逻辑
BEGIN

	-- 查询类型
	DECLARE @cbMatchType SMALLINT
	SELECT @cbMatchType=MatchType FROM MatchPublic WHERE MatchID=@dwMatchID

	-- 存在判断
	IF @cbMatchType IS NULL RETURN 1
	
	-- 删除配置
	DELETE MatchPublic WHERE MatchID=@dwMatchID

	-- 删除奖励	
	DELETE MatchReward WHERE MatchID=@dwMatchID				
	
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

-- 插入比赛
CREATE  PROCEDURE dbo.GSP_GS_InsertGameMatchItem	
	-- 基本信息
	@wKindID INT,								-- 类型标识		
	@strMatchName NVARCHAR(32),					-- 比赛名称
	@strMatchDate NVARCHAR(64),					-- 比赛时间	
	@cbMatchType TINYINT,						-- 比赛类型		
	
	-- 报名信息
	@cbFeeType TINYINT,							-- 费用类型
	@cbDeductArea TINYINT,						-- 扣费区域
	@lSignupFee BIGINT,							-- 比赛费用
	@cbSignupMode TINYINT,						-- 报名方式
	@cbJoinCondition TINYINT,					-- 参赛条件
	@cbMemberOrder TINYINT,						-- 会员等级	
	@lExperience INT,							-- 经验等级	
	@dwFromMatchID INT,							-- 比赛标识	
	@cbFilterType TINYINT,						-- 筛选方式
	@wMaxRankID SMALLINT,						-- 最大名次
	@MatchEndDate DATETIME,						-- 开始日期
	@MatchStartDate DATETIME,					-- 开始日期
	
	-- 排名信息
	@cbRankingMode TINYINT,						-- 排名方式
	@wCountInnings SMALLINT,					-- 统计局数
	@cbFilterGradesMode TINYINT,				-- 筛选方式

	-- 配桌信息
	@cbDistributeRule TINYINT,					-- 分配规则
	@wMinDistributeUser SMALLINT,				-- 分组人数
	@wDistributeTimeSpace SMALLINT,				-- 分组间隔
	@wMinPartakeGameUser SMALLINT,				-- 最小人数
	@wMaxPartakeGameUser SMALLINT,				-- 最大人数

	-- 比赛奖励
	@strRewardGold NVARCHAR(512),				-- 金币奖励
	@strRewardIngot NVARCHAR(512),				-- 元宝奖励
	@strRewardExperience NVARCHAR(512),			-- 经验奖励

	-- 扩展配置
	@strMatchRule NVARCHAR(1024),				-- 比赛规则	
	@strServiceMachine NCHAR(32),				-- 服务机器
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息	
WITH ENCRYPTION AS

-- 设置属性
SET NOCOUNT ON

-- 执行逻辑
BEGIN

	-- 插入配置
	INSERT INTO MatchPublic(KindID,MatchName,MatchType,SignupMode,FeeType,SignupFee,DeductArea,JoinCondition,MemberOrder,
		Experience,FromMatchID,FilterType,MaxRankID,MatchEndDate,MatchStartDate,RankingMode,CountInnings,FilterGradesMode,DistributeRule,MinDistributeUser,
		DistributeTimeSpace,MinPartakeGameUser,MaxPartakeGameUser,MatchRule,ServiceMachine,CollectDate)		
	VALUES(@wKindID,@strMatchName,@cbMatchType,@cbSignupMode,@cbFeeType,@lSignupFee,@cbDeductArea,@cbJoinCondition,@cbMemberOrder,
		@lExperience,@dwFromMatchID,@cbFilterType,@wMaxRankID,@MatchEndDate,@MatchStartDate,@cbRankingMode,@wCountInnings,@cbFilterGradesMode,@cbDistributeRule,@wMinDistributeUser,
		@wDistributeTimeSpace,@wMinPartakeGameUser,@wMaxPartakeGameUser,@strMatchRule,@strServiceMachine,GETDATE())

	-- 比赛标识
	DECLARE @dwMatchID INT
	SET @dwMatchID=SCOPE_IDENTITY()	
	
	-- 存在判断
	IF NOT EXISTS(SELECT * FROM MatchPublic WHERE MatchID=@dwMatchID) 
	BEGIN
		SET @strErrorDescribe=N'由于数据库异常，比赛创建失败，请稍后再试！'
		RETURN 1
	END
	
	-- 即时赛状态
	IF @cbMatchType=1
	BEGIN
		-- 修改状态
		UPDATE MatchPublic SET MatchStatus=0x02 WHERE MatchID=@dwMatchID		
	END
	
	-- 比赛信息
	INSERT INTO dbo.MatchInfo(MatchID,MatchName,MatchDate) VALUES (@dwMatchID,@strMatchName,@strMatchDate)

	-- 拆分奖励
	SELECT * INTO #tmpGold FROM dbo.WF_SplitStr(@strRewardGold,'|')	
	SELECT * INTO #tmpIngot FROM dbo.WF_SplitStr(@strRewardIngot,'|')	
	SELECT * INTO #tmpExperience FROM dbo.WF_SplitStr(@strRewardExperience,'|')		

	-- 变量定义
	DECLARE @Index INT
	DECLARE @RewardGold BIGINT
	DECLARE @RewardIngot BIGINT
	DECLARE @RewardExperience BIGINT

	-- 插入奖励
	SELECT @Index=COUNT(id) FROM #tmpGold
	WHILE @Index > 0
	BEGIN
		-- 查询数据
		SELECT @RewardGold=rs FROM #tmpGold WHERE id=@Index		
		SELECT @RewardIngot=rs FROM #tmpIngot WHERE id=@Index
		SELECT @RewardExperience=rs FROM #tmpExperience WHERE id=@Index					

		-- 插入数据
		INSERT INTO MatchReward(MatchID,MatchRank,RewardGold,RewardIngot,RewardExperience,RewardDescibe)
		VALUES(@dwMatchID,@Index,@RewardGold,@RewardIngot,@RewardExperience,'')

		SET @Index=@Index-1
	END

	-- 删临时表
	DROP TABLE #tmpGold,#tmpIngot,#tmpExperience

	-- 查询比赛
	EXEC GSP_GS_LoadGameMatchItem @wKindID,@dwMatchID,@strServiceMachine,N''				
	
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

-- 修改比赛
CREATE  PROCEDURE dbo.GSP_GS_ModifyGameMatchItem
	-- 基本信息
	@wKindID INT,								-- 类型标识
	@dwMatchID INT,								-- 比赛标识
	@strMatchName NVARCHAR(32),					-- 比赛名称
	@strMatchDate NVARCHAR(64),					-- 比赛时间
	@cbMatchType TINYINT,						-- 比赛类型
	
	-- 报名信息
	@cbFeeType TINYINT,							-- 费用类型
	@cbDeductArea TINYINT,						-- 扣费区域
	@lSignupFee BIGINT,							-- 比赛费用
	@cbSignupMode TINYINT,						-- 报名方式
	@cbJoinCondition TINYINT,					-- 参赛条件
	@cbMemberOrder TINYINT,						-- 会员等级	
	@lExperience INT,							-- 经验等级	
	@dwFromMatchID INT,							-- 比赛标识	
	@cbFilterType TINYINT,						-- 筛选方式
	@wMaxRankID SMALLINT,						-- 最大名次
	@MatchEndDate DATETIME,						-- 结束日期
	@MatchStartDate DATETIME,					-- 开始日期
	
	-- 排名信息
	@cbRankingMode TINYINT,						-- 排名方式
	@wCountInnings SMALLINT,					-- 统计局数
	@cbFilterGradesMode TINYINT,				-- 筛选方式

	-- 配桌信息
	@cbDistributeRule TINYINT,					-- 分配规则
	@wMinDistributeUser SMALLINT,				-- 分组人数
	@wDistributeTimeSpace SMALLINT,				-- 分组间隔
	@wMinPartakeGameUser SMALLINT,				-- 最小人数
	@wMaxPartakeGameUser SMALLINT,				-- 最大人数

	-- 比赛奖励
	@strRewardGold NVARCHAR(1024),				-- 金币奖励
	@strRewardIngot NVARCHAR(1024),				-- 元宝奖励
	@strRewardExperience NVARCHAR(512),			-- 经验奖励

	-- 比赛规则
	@strMatchRule NVARCHAR(1024),				-- 比赛规则	
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息	
WITH ENCRYPTION AS

-- 设置属性
SET NOCOUNT ON

-- 执行逻辑
BEGIN

	-- 更新配置
	UPDATE MatchPublic 	SET KindID=@wKindID,MatchName=@strMatchName,MatchType=@cbMatchType,SignupFee=@lSignupFee,
	SignupMode=@cbSignupMode,FeeType=@cbFeeType,DeductArea=@cbDeductArea,JoinCondition=@cbJoinCondition,MemberOrder=@cbMemberOrder,Experience=@lExperience,FromMatchID=@dwFromMatchID,
	FilterType=@cbFilterType,MaxRankID=@wMaxRankID,MatchEndDate=@MatchEndDate,MatchStartDate=@MatchStartDate,RankingMode=@cbRankingMode,CountInnings=@wCountInnings,FilterGradesMode=@cbFilterGradesMode,
	DistributeRule=@cbDistributeRule,MinDistributeUser=@wMinDistributeUser,DistributeTimeSpace=@wDistributeTimeSpace,MinPartakeGameUser=@wMinPartakeGameUser,MaxPartakeGameUser=@wMaxPartakeGameUser,MatchRule=@strMatchRule
	WHERE MatchID=@dwMatchID	
	
	-- 更新配置
	UPDATE MatchInfo SET MatchName=@strMatchName,MatchDate=@strMatchDate WHERE MatchID=@dwMatchID
	IF @@ROWCOUNT=0
	BEGIN
		-- 插入比赛	
		INSERT INTO dbo.MatchInfo(MatchID,MatchName,MatchDate) VALUES (@dwMatchID,@strMatchName,@strMatchDate)
	END

	-- 删除奖励
	DELETE MatchReward WHERE MatchID=@dwMatchID	

	-- 拆分奖励
	SELECT * INTO #tmpGold FROM dbo.WF_SplitStr(@strRewardGold,'|')	
	SELECT * INTO #tmpIngot FROM dbo.WF_SplitStr(@strRewardIngot,'|')	
	SELECT * INTO #tmpExperience FROM dbo.WF_SplitStr(@strRewardExperience,'|')		

	-- 变量定义
	DECLARE @Index INT
	DECLARE @RewardGold BIGINT
	DECLARE @RewardIngot BIGINT
	DECLARE @RewardExperience BIGINT

	-- 插入奖励
	SELECT @Index=COUNT(id) FROM #tmpGold
	WHILE @Index > 0
	BEGIN
		-- 查询数据
		SELECT @RewardGold=rs FROM #tmpGold WHERE id=@Index		
		SELECT @RewardIngot=rs FROM #tmpIngot WHERE id=@Index
		SELECT @RewardExperience=rs FROM #tmpExperience WHERE id=@Index					

		-- 插入数据
		INSERT INTO MatchReward(MatchID,MatchRank,RewardGold,RewardIngot,RewardExperience,RewardDescibe)
		VALUES(@dwMatchID,@Index,@RewardGold,@RewardIngot,@RewardExperience,'')

		SET @Index=@Index-1
	END

	-- 删临时表
	DROP TABLE #tmpGold,#tmpIngot,#tmpExperience	

	-- 查询比赛
	EXEC GSP_GS_LoadGameMatchItem @wKindID,@dwMatchID,N'',N''
			
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

-- 加载奖励
CREATE  PROCEDURE dbo.GSP_GS_LoadMatchReward
	@dwMatchID INT								-- 比赛标识	
WITH ENCRYPTION AS

-- 设置属性
SET NOCOUNT ON

-- 执行逻辑
BEGIN

	-- 加载奖励
	SELECT * FROM MatchReward WHERE MatchID=@dwMatchID 

END

RETURN 0

GO

----------------------------------------------------------------------------------------------------
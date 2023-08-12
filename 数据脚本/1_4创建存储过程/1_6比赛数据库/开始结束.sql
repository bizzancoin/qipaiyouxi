
----------------------------------------------------------------------------------------------------

USE RYGameMatchDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_MatchSignupStart]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_MatchSignupStart]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_MatchStart]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_MatchStart]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_MatchEliminate]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_MatchEliminate]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_MatchRecordGrades]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_MatchRecordGrades]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_MatchOver]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_MatchOver]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_MatchCancel]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_MatchCancel]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO


----------------------------------------------------------------------------------------------------
-- 报名开始
CREATE PROC GSP_GR_MatchSignupStart
	@wServerID		INT,		-- 房间标识		
	@dwMatchID		INT,		-- 比赛标识
	@lMatchNo		BIGINT,		-- 比赛场次
	@cbMatchType	TINYINT,	-- 比赛类型
	@cbSignupMode	TINYINT		-- 报名方式
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN 

	-- 定时赛制 
	IF @cbMatchType=0
	BEGIN
		-- 比赛玩家	
		IF (@cbSignupMode&0x02)<>0
		BEGIN
			-- 变量定义
			DECLARE @FromMatchID INT
			DECLARE @FilterType TINYINT
			DECLARE @MaxRankID SMALLINT
			DECLARE @MatchEndDate DATETIME
			DECLARE @MatchStartDate DATETIME
			
			-- 查询参数
			SELECT  @FromMatchID=FromMatchID, @FilterType=FilterType, @MaxRankID=MaxRankID, @MatchEndDate=MatchEndDate, @MatchStartDate=MatchStartDate FROM MatchPublic 
			WHERE MatchID=@dwMatchID
			
			-- 判断变量
			IF @FromMatchID IS NULL RETURN 1
			
			-- 查询类型
			DECLARE @FromMatchType TINYINT
			SELECT @FromMatchType=MatchType FROM MatchPublic WHERE MatchID=@FromMatchID
			
			-- 定时赛制
			IF @FromMatchType=0
			BEGIN			
				-- 按总排名
				IF @FilterType=1
				BEGIN
					-- 插入晋级信息
					INSERT INTO MatchPromoteInfo(UserID,MatchID,PromoteMatchID,ServerID,RankID,Score,RewardGold,RewardIngot,RewardExperience)  				
					SELECT UserID,@FromMatchID,@dwMatchID,ServerID,RankID,MatchScore,RewardGold,RewardIngot,RewardExperience FROM StreamMatchHistory
					WHERE MatchID=@FromMatchID AND RankID<=@MaxRankID				
				END				
			END 
			
			-- 即时赛制
			IF @FromMatchType=1
			BEGIN
				-- 按单轮排名
				IF @FilterType=0
				BEGIN				
					-- 插入晋级信息
					INSERT INTO MatchPromoteInfo(UserID,MatchID,PromoteMatchID,ServerID,RankID,Score,RewardGold,RewardIngot,RewardExperience)  				
					SELECT UserID,@FromMatchID,@dwMatchID,ServerID,RankID,MatchScore,RewardGold,RewardIngot,RewardExperience FROM StreamMatchHistory
					WHERE (ID IN (SELECT MAX(ID) FROM StreamMatchHistory 
					WHERE MatchID=@FromMatchID AND RankID<=@MaxRankID AND (MatchEndTime BETWEEN @MatchStartDate AND @MatchEndDate) GROUP BY UserID))
				END											
			END
			
			-- 删除复活信息
			DELETE MatchReviveInfo WHERE MatchID=@dwMatchID
			
			-- 删除比赛成绩
			DELETE MatchResults WHERE MatchID=@dwMatchID AND ServerID=@wServerID 
					
			-- 删除比赛分
			DELETE MatchScoreInfo WHERE MatchID=@dwMatchID AND MatchNo=@lMatchNo
			
		END
	END

	RETURN 0
END

RETURN 0
	
GO

----------------------------------------------------------------------------------------------------
-- 比赛开始
CREATE PROC GSP_GR_MatchStart
	@wServerID		INT,		-- 房间标识		
	@dwMatchID		INT,		-- 比赛标识
	@lMatchNo		BIGINT,		-- 比赛场次
	@cbMatchType	TINYINT		-- 比赛类型
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN 

	-- 定时赛制 
	IF @cbMatchType=0
	BEGIN
		-- 清除局数
		UPDATE 	MatchScoreInfo SET WinCount=0,LostCount=0,DrawCount=0,FleeCount=0 
		WHERE ServerID=@wServerID AND MatchID=@dwMatchID AND MatchNo=@lMatchNo
		
		-- 修改状态
		UPDATE MatchPublic SET MatchStatus=0x02 WHERE MatchID=@dwMatchID
	END

	RETURN 0
END

RETURN 0
	
GO

----------------------------------------------------------------------------------------------------

-- 比赛淘汰
CREATE PROC GSP_GR_MatchEliminate
	@dwUserID		INT,		-- 用户标识
	@wServerID		INT,		-- 房间标识	
	@dwMatchID		INT,		-- 比赛标识
	@lMatchNo		BIGINT,		-- 比赛场次
	@cbMatchType	TINYINT		-- 比赛类型			
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN
	-- 删除分数
	DELETE MatchScoreInfo WHERE UserID=@dwUserID AND ServerID=@wServerID AND MatchID=@dwMatchID AND MatchNo=@lMatchNo	
	
END

RETURN 0
GO

----------------------------------------------------------------------------------------------------

-- 记录成绩
CREATE PROC GSP_GR_MatchRecordGrades
	@dwUserID		INT,		-- 用户标识
	@wServerID		INT,		-- 房间标识	
	@dwMatchID		INT,		-- 比赛标识
	@lMatchNo		BIGINT,		-- 比赛场次			
	@lInitScore		INT			-- 初始成绩
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN
	
	-- 查询比赛
	DECLARE @RankingMode TINYINT
	DECLARE @CountInnings SMALLINT	
	SELECT @RankingMode=RankingMode,@CountInnings=CountInnings FROM MatchPublic WHERE MatchID=@dwMatchID	
	
	-- 调整变量
	IF @RankingMode IS NULL SET @RankingMode=0
	
	-- 排名模式
	IF @RankingMode=1
	BEGIN
		-- 插入成绩
		INSERT INTO MatchResults(UserID,MatchID,MatchNo,ServerID,Score,WinCount,LostCount,DrawCount,FleeCount)
		SELECT @dwUserID,@dwMatchID,@lMatchNo,@wServerID,Score,WinCount,LostCount,DrawCount,FleeCount FROM MatchScoreInfo
		WHERE UserID=@dwUserID AND ServerID=@wServerID AND MatchID=@dwMatchID AND MatchNo=@lMatchNo 
		
		-- 更新分数
		UPDATE MatchScoreInfo SET Score=@lInitScore,WinCount=0,LostCount=0,DrawCount=0,FleeCount=0
		WHERE UserID=@dwUserID AND ServerID=@wServerID AND MatchID=@dwMatchID AND MatchNo=@lMatchNo			
	END
		
END

RETURN 0
GO

----------------------------------------------------------------------------------------------------
-- 比赛结束
CREATE PROC GSP_GR_MatchOver
	@wServerID		INT,		-- 房间标识	
	@dwMatchID		INT,		-- 比赛标识
	@lMatchNo		BIGINT,		-- 比赛场次
	@cbMatchType	TINYINT,	-- 比赛类型
	@cbPlayCount	TINYINT,	-- 游戏局数
	@bMatchFinish   INT,		-- 完成标识
	@MatchStartTime DATETIME,	-- 开赛时间
	@MatchEndTime	DATETIME	-- 结束时间		
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN
	
	-- 定时赛制
	IF @cbMatchType = 0
	BEGIN
		-- 奖励名次			
		SELECT 	MatchRank,RewardGold,RewardIngot,RewardExperience INTO #TempMatchReward FROM MatchReward(NOLOCK) 
		WHERE MatchID=@dwMatchID

		DECLARE @RankCount SMALLINT
		SET @RankCount=@@Rowcount
		
		-- 比赛配置
		DECLARE @RankingMode TINYINT
		DECLARE @CountInnings SMALLINT
		DECLARE @FilterGradesMode TINYINT
		SELECT @RankingMode=RankingMode,@CountInnings=CountInnings,@FilterGradesMode=FilterGradesMode FROM MatchPublic WHERE MatchID=@dwMatchID
		
		-- 修改状态
		UPDATE MatchPublic SET MatchStatus=0x08 WHERE MatchID=@dwMatchID		

		-- 奖励处理
		IF @RankCount > 0
		BEGIN		
			-- 开始事务
			SET TRANSACTION ISOLATION LEVEL REPEATABLE READ	
			BEGIN TRAN

			-- 删除比赛分
			--DELETE MatchScoreInfo WHERE MatchID=@dwMatchID			
			--IF @@Rowcount > 0					
			BEGIN
						
				-- 总成绩排名
				IF @RankingMode=0
				BEGIN
					-- 查询晋级玩家	
					SELECT MatchRank=ROW_NUMBER() OVER (ORDER BY Score DESC,WinCount DESC,SignupTime ASC ),* INTO #RankUserList FROM MatchScoreInfo(NOLOCK) 	
					WHERE MatchID=@dwMatchID AND MatchNo=@lMatchNo AND (WinCount+LostCount+FleeCount)>=@cbPlayCount
					ORDER BY Score DESC,WinCount DESC,SignupTime ASC
					
					-- 合并记录
					SELECT a.*,ISNULL(b.RewardGold,0) AS RewardGold, ISNULL(b.RewardIngot,0) AS RewardIngot, ISNULL(b.RewardExperience,0) AS RewardExperience INTO #RankMatchReward
					FROM #RankUserList a LEFT JOIN #TempMatchReward b ON a.MatchRank=b.MatchRank 

					-- 插入记录
					INSERT INTO StreamMatchHistory(UserID,MatchID,MatchNo,MatchType,ServerID,RankID,MatchScore,UserRight,RewardGold,RewardIngot,RewardExperience,
					WinCount,LostCount,DrawCount,FleeCount,MatchStartTime,MatchEndTime,PlayTimeCount,OnlineTime,Machine,ClientIP)
					SELECT a.UserID,@dwMatchID,@lMatchNo,0,a.ServerID,a.MatchRank,a.Score,b.UserRight,a.RewardGold,a.RewardIngot,a.RewardExperience,
					a.WinCount,a.LostCount,a.DrawCount,a.FleeCount,@MatchStartTime,@MatchEndTime,
					a.PlayTimeCount,a.OnlineTime,b.LastLogonMachine,b.LastLogonIP 
					FROM #RankMatchReward a,GameScoreInfo b WHERE a.UserID=b.UserID	
					
					-- 抛出获奖名单			
					SELECT MatchRank AS RankID,UserID,@dwMatchID AS MatchID,ServerID,Score,RewardGold,RewardIngot,RewardExperience 
					FROM #RankMatchReward WHERE MatchRank<=@RankCount
					
					IF OBJECT_ID('tempdb..#RankUserList') IS NOT NULL DROP TABLE #RankUserList
					IF OBJECT_ID('tempdb..#MatchFeeRecord') IS NOT NULL DROP TABLE #MatchFeeRecord			
					IF OBJECT_ID('tempdb..#RankMatchReward') IS NOT NULL DROP TABLE #RankMatchReward					
				END
				
				-- 特定局数
				IF @RankingMode=1
				BEGIN
			
					-- 筛选用户
					SELECT UserID,
						  (
						   CASE @FilterGradesMode 
						   WHEN 0 THEN MAX(Score) 
						   WHEN 1 THEN AVG(Score) 
						   WHEN 2 THEN 
						     	  case WHEN COUNT(*)>2 THEN ((SUM(Score)-MAX(Score)-MIN(Score))/(COUNT(*)-2)) 
								  ELSE 0 END
						   ELSE MAX(Score) END
						   ) AS Score
					INTO #MatchUserResults FROM MatchResults WHERE MatchID=@dwMatchID AND MatchNo=@lMatchNo GROUP BY UserID 					

					-- 查询晋级玩家	
					SELECT MatchRank=ROW_NUMBER() OVER (ORDER BY a.Score DESC,b.SignupTime ASC),a.*,b.ServerID,b.PlayTimeCount,b.OnlineTime INTO #RankUserList1 
					FROM #MatchUserResults a,MatchScoreInfo b  WHERE a.UserID=b.UserID AND b.MatchID=@dwMatchID AND b.MatchNo=@lMatchNo ORDER BY a.Score DESC,b.SignupTime ASC
					
					-- 合并记录
					SELECT a.*,ISNULL(b.RewardGold,0) AS RewardGold, ISNULL(b.RewardIngot,0) AS RewardIngot, ISNULL(b.RewardExperience,0) AS RewardExperience INTO #RankMatchReward1
					FROM #RankUserList1 a LEFT JOIN #TempMatchReward b ON a.MatchRank=b.MatchRank 					
					
					-- 插入记录
					INSERT INTO StreamMatchHistory(UserID,MatchID,MatchNo,MatchType,ServerID,RankID,MatchScore,UserRight,RewardGold,RewardIngot,RewardExperience,
					WinCount,LostCount,DrawCount,FleeCount,MatchStartTime,MatchEndTime,PlayTimeCount,OnlineTime,Machine,ClientIP)
					SELECT a.UserID,@dwMatchID,@lMatchNo,0,@wServerID,a.MatchRank,a.Score,b.UserRight,a.RewardGold,a.RewardIngot,a.RewardExperience,
					0,0,0,0,@MatchStartTime,@MatchEndTime,a.PlayTimeCount,a.OnlineTime,b.LastLogonMachine,b.LastLogonIP 
					FROM #RankMatchReward1 a,GameScoreInfo b WHERE a.UserID=b.UserID
					
					-- 抛出获奖名单			
					SELECT MatchRank AS RankID,UserID,@dwMatchID AS MatchID,ServerID,MatchRank,Score,RewardGold,RewardIngot,RewardExperience
					FROM #RankMatchReward1 WHERE MatchRank<=@RankCount	
					
					-- 删除临时表
					IF OBJECT_ID('tempdb..#RankUserList1') IS NOT NULL DROP TABLE #RankUserList1					
					IF OBJECT_ID('tempdb..#MatchFeeRecord1') IS NOT NULL DROP TABLE #MatchFeeRecord1			
					IF OBJECT_ID('tempdb..#RankMatchReward1') IS NOT NULL DROP TABLE #RankMatchReward1						
					IF OBJECT_ID('tempdb..#MatchUserResults') IS NOT NULL DROP TABLE #MatchUserResults					
				END						 	
			END 						

			-- 结束事务
			COMMIT TRAN
			SET TRANSACTION ISOLATION LEVEL READ COMMITTED	

			-- 销毁临时表			
			IF OBJECT_ID('tempdb..#TempMatchReward') IS NOT NULL DROP TABLE #TempMatchReward																		
		END
		
		-- 删除比赛分
		DELETE MatchScoreInfo WHERE MatchID=@dwMatchID AND MatchNo=@lMatchNo	
		
		-- 禁用比赛
		IF @bMatchFinish=1
		BEGIN
			UPDATE MatchPublic SET Nullity=1 WHERE MatchID=@dwMatchID																																																																																															
		END
	END

	-- 即时赛制
	IF @cbMatchType = 1
	BEGIN
		-- 开始事务
		SET TRANSACTION ISOLATION LEVEL REPEATABLE READ	
		BEGIN TRAN	

		-- 奖励名次			
		SELECT MatchRank,RewardGold,RewardIngot,RewardExperience INTO #TempMatchReward1 FROM MatchReward(NOLOCK) 
		WHERE MatchID=@dwMatchID

		-- 查询获奖玩家	
		SELECT MatchRank=ROW_NUMBER() OVER (ORDER BY Score DESC,WinCount DESC,SignupTime ASC),* INTO #RankUserList2 FROM MatchScoreInfo(NOLOCK) 	
		WHERE ServerID=@wServerID AND MatchID=@dwMatchID AND MatchNo=@lMatchNo AND (WinCount+LostCount+FleeCount+DrawCount)>=@cbPlayCount 
		ORDER BY Score DESC,WinCount DESC,SignupTime ASC

		-- 删除比赛分
		DELETE MatchScoreInfo WHERE ServerID=@wServerID AND MatchID=@dwMatchID AND MatchNo=@lMatchNo

		-- 合并记录
		SELECT a.*,ISNULL(b.RewardGold,0) AS RewardGold, ISNULL(b.RewardIngot,0) AS RewardIngot, ISNULL(b.RewardExperience ,0) AS RewardExperience  INTO #RankMatchReward2
		FROM #RankUserList2 a LEFT JOIN #TempMatchReward1 b ON a.MatchRank=b.MatchRank	

		-- 插入记录
		INSERT INTO StreamMatchHistory(UserID,MatchID,MatchNo,MatchType,ServerID,RankID,MatchScore,UserRight,RewardGold,RewardIngot,RewardExperience, 
		WinCount,LostCount,DrawCount,FleeCount,MatchStartTime,MatchEndTime,PlayTimeCount,OnlineTime,Machine,ClientIP)
		SELECT a.UserID,@dwMatchID,@lMatchNo,1,@wServerID,a.MatchRank,a.Score,b.UserRight,a.RewardGold,a.RewardIngot,a.RewardExperience,
		a.WinCount,a.LostCount,a.DrawCount,a.FleeCount,@MatchStartTime,@MatchEndTime,
		a.PlayTimeCount,a.OnlineTime,b.LastLogonMachine,b.LastLogonIP 
		FROM #RankMatchReward2 a,GameScoreInfo b WHERE a.UserID=b.UserID

		-- 抛出获奖名单
		SELECT MatchRank AS RankID,UserID,Score,RewardGold,RewardIngot,RewardExperience FROM #RankMatchReward2		

		-- 结束事务
		COMMIT TRAN
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED		

		-- 销毁临时表
		IF OBJECT_ID('tempdb..#RankUserList2') IS NOT NULL DROP TABLE #RankUserList2 
		IF OBJECT_ID('tempdb..#TempMatchReward2') IS NOT NULL DROP TABLE #TempMatchReward2 
		IF OBJECT_ID('tempdb..#RankMatchReward2') IS NOT NULL DROP TABLE #RankMatchReward2	
	END
END

RETURN 0
GO


----------------------------------------------------------------------------------------------------
-- 比赛取消
CREATE PROC GSP_GR_MatchCancel
	@wServerID		INT,		-- 房间标识		
	@dwMatchID		INT,		-- 比赛标识
	@lMatchNo		BIGINT,		-- 比赛场次
	@lSafeCardFee	INT,		-- 保险费用	
	@bMatchFinish   INT			-- 完成标识
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN 

	-- 比赛配置
	DECLARE @FeeType SMALLINT
	DECLARE @MatchType TINYINT		
	SELECT @FeeType=FeeType,@MatchType=MatchType FROM MatchPublic WHERE MatchID=@dwMatchID
		
	-- 定时赛制 
	IF @MatchType=0
	BEGIN				
		-- 查询报名
		SELECT UserID,MatchFee INTO #MatchUserFeeInfo FROM StreamMatchFeeInfo WHERE ServerID=@wServerID AND MatchID=@dwMatchID AND MatchNo=@lMatchNo
		
		-- 删除比赛分
		DELETE MatchScoreInfo WHERE ServerID=@wServerID AND MatchID=@dwMatchID AND MatchNo=@lMatchNo 	
		IF @@ROWCOUNT>0
		BEGIN
			-- 返还金币
			IF @FeeType=0
			BEGIN
				-- 扣除金币
				UPDATE RYTreasureDB..GameScoreInfo SET Score=Score+(SELECT MatchFee FROM #MatchUserFeeInfo b WHERE RYTreasureDB..GameScoreInfo.UserID=b.UserID)
				WHERE UserID IN (SELECT UserID FROM #MatchUserFeeInfo)
			END
			
			-- 返还奖牌
			IF @FeeType=1
			BEGIN				
				-- 更新奖牌
				UPDATE RYAccountsDB..AccountsInfo SET UserMedal=UserMedal+(SELECT MatchFee FROM #MatchUserFeeInfo b WHERE RYAccountsDB..AccountsInfo.UserID=b.UserID)
				WHERE UserID IN (SELECT UserID FROM #MatchUserFeeInfo)
			END
			
			-- 退还保险卡费用			
			UPDATE RYTreasureDB..GameScoreInfo SET Score=Score+@lSafeCardFee WHERE UserID IN (SELECT UserID FROM MatchReviveInfo WHERE MatchID=@dwMatchID AND HoldSafeCard=1)
			
			-- 删除复活信息
			DELETE MatchReviveInfo WHERE MatchID=@dwMatchID
			
			-- 删除信息
			DELETE StreamMatchFeeInfo WHERE ServerID=@wServerID AND MatchID=@dwMatchID AND MatchNo=@lMatchNo												
		END
		
		-- 删除晋级
		DELETE MatchPromoteInfo WHERE PromoteMatchID=@dwMatchID
		
		-- 禁用比赛
		IF @bMatchFinish=1
		BEGIN
			UPDATE MatchPublic SET Nullity=1 WHERE MatchID=@dwMatchID
		END
	END

	RETURN 0
END

RETURN 0
	
GO

----------------------------------------------------------------------------------------------------
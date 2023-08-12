USE RYGameMatchDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_MatchReward]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_MatchReward]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- 比赛奖励
CREATE PROC GSP_GR_MatchReward
	@dwUserID INT,								-- 用户 I D	
	@lRewardGold BIGINT,						-- 金币奖励
	@lRewardIngot BIGINT,						-- 元宝奖牌
	@dwRewardExperience BIGINT,					-- 奖牌奖励
	@wKindID INT,								-- 游戏 I D
	@wServerID INT,								-- 房间 I D
	@strClientIP NVARCHAR(15)					-- 连接地址
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN
	
	-- 奖励金币
	IF @lRewardGold>0 OR @lRewardIngot>0 OR @dwRewardExperience>0
	BEGIN
		-- 查询金币
		DECLARE @CurrScore BIGINT
		DECLARE @CurrInsure BIGINT
		DECLARE @CurrMedal INT
		SELECT @CurrScore=Score,@CurrInsure=InsureScore FROM RYTreasureDB..GameScoreInfo WHERE UserID=@dwUserID
		SELECT @CurrMedal=UserMedal FROM RYAccountsDB..AccountsInfo WHERE UserID=@dwUserID
	
		-- 存在判断
		IF @CurrScore IS NULL OR @CurrInsure IS NULL 
		BEGIN
			-- 调整变量
			SELECT @CurrScore=0,@CurrInsure=0
			
			-- 插入记录
			INSERT RYTreasureDB..GameScoreInfo (UserID,Score,LastLogonIP,RegisterIP) 
			VALUES(@dwUserID,@lRewardGold,@strClientIP,@strClientIP)
		END
		

		-- 计算时间
		DECLARE @DateID INT
		SET @DateID=CAST(CAST(GETDATE() AS FLOAT) AS INT)
		
		-- 变量定义
		DECLARE @TypeID INT
		SET @TypeID=18
		
		-- 更新金币
		UPDATE RYTreasureDB..GameScoreInfo SET Score=Score+@lRewardGold WHERE UserID=@dwUserID
		
		-- 更新奖牌
		UPDATE RYAccountsDB..AccountsInfo SET UserMedal=UserMedal+@lRewardIngot, Experience=Experience+@dwRewardExperience WHERE UserID=@dwUserID
		
		IF @lRewardIngot > 0
		BEGIN
			-- 元宝记录
			INSERT INTO RYAccountsDBLink.RYAccountsDB.dbo.RecordMedalChange(UserID,SrcMedal,TradeMedal,TypeID,ClientIP,CollectDate)	
			VALUES (@dwUserID,@CurrMedal,@lRewardIngot,1,@strClientIP,GETDATE())
		END
		
		-- 流水账
		INSERT INTO RYTreasureDBLink.RYTreasureDB.dbo.RecordPresentInfo(UserID,PreScore,PreInsureScore,PresentScore,TypeID,IPAddress,CollectDate)
		VALUES (@dwUserID,@CurrScore,@CurrInsure,@lRewardGold,10,@strClientIP,GETDATE())
		
		-- 日统计
		UPDATE RYTreasureDBLink.RYTreasureDB.dbo.StreamPresentInfo SET DateID=@DateID, PresentCount=PresentCount+1,PresentScore=PresentScore+@lRewardGold WHERE UserID=@dwUserID AND TypeID=10
		IF @@ROWCOUNT=0
		BEGIN
			INSERT RYTreasureDBLink.RYTreasureDB.dbo.StreamPresentInfo(DateID,UserID,TypeID,PresentCount,PresentScore) VALUES(@DateID,@dwUserID,10,1,@lRewardGold)
		END	
		
	END
	
	-- 查询金币
	DECLARE @CurrGold BIGINT	
	SELECT @CurrGold=Score FROM RYTreasureDB..GameScoreInfo WHERE UserID=@dwUserID

	-- 调整数据
	IF @CurrGold IS NULL SET @CurrGold=0		

	-- 抛出数据
	SELECT @CurrGold AS Score
END

RETURN 0
GO
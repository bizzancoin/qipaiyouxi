
----------------------------------------------------------------------------------------------------

USE RYPlatformDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_LoadGrowLevelConfig]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_LoadGrowLevelConfig]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_QueryGrowLevel]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_QueryGrowLevel]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------
-- 等级配置
CREATE PROC GSP_GR_LoadGrowLevelConfig
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN
	-- 查询配置
	SELECT LevelID,Experience FROM GrowLevelConfig ORDER BY LevelID
	
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------
-- 查询等级
CREATE PROC GSP_GP_QueryGrowLevel
	@dwUserID INT,								-- 用户 I D
	@strPassword NCHAR(32),						-- 用户密码	
	@strClientIP NVARCHAR(15),					-- 连接地址
	@strMachineID NVARCHAR(32),					-- 机器标识
	@strUpgradeDescribe NVARCHAR(127) OUTPUT	-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 财富变量
DECLARE @Score BIGINT
DECLARE @Ingot BIGINT

-- 执行逻辑
BEGIN
	
	-- 变量定义
	DECLARE @Experience BIGINT
	DECLARE	@GrowlevelID INT	

	-- 查询用户
	SELECT @Experience=Experience,@GrowlevelID=GrowLevelID FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo 
	WHERE UserID=@dwUserID AND LogonPass=@strPassword

	-- 存在判断
	IF @Experience IS NULL OR @GrowlevelID IS NULL
	BEGIN
		return 1
	END

	-- 升级判断
	DECLARE @NowGrowLevelID INT
	SET @NowGrowLevelID = 1
	SELECT TOP 1 @NowGrowLevelID=LevelID FROM GrowLevelConfig
	WHERE @Experience>=Experience ORDER BY LevelID DESC

	-- 调整变量
	IF @NowGrowLevelID IS NULL
	BEGIN
		SET @NowGrowLevelID=@GrowlevelID														
	END

	-- 升级处理
	IF @NowGrowLevelID>@GrowlevelID
	BEGIN
		DECLARE @UpgradeLevelCount INT
		DECLARE	@lRewardGold BIGINT
		DECLARE	@lRewardIngot BIGINT
		
		DECLARE @CurrScore BIGINT
		DECLARE @CurrInsure BIGINT
		DECLARE @CurrMedal INT
		SELECT @CurrScore=Score,@CurrInsure=InsureScore FROM RYTreasureDBLink.RYTreasureDB.dbo.GameScoreInfo WHERE UserID=@dwUserID
		SELECT @CurrMedal=UserMedal FROM RYAccountsDB..AccountsInfo WHERE UserID=@dwUserID
		
		-- 升级增量
		SET @UpgradeLevelCount=@NowGrowLevelID-@GrowlevelID
		
		-- 查询奖励
		SELECT @lRewardGold=SUM(RewardGold),@lRewardIngot=SUM(RewardMedal) FROM GrowLevelConfig
		WHERE LevelID>@GrowlevelID AND LevelID<=@NowGrowLevelID

		-- 调整变量
		IF @lRewardGold IS NULL SET @lRewardGold=0				
		IF @lRewardIngot IS NULL SET @lRewardIngot=0

		-- 更新金币
		UPDATE RYTreasureDBLink.RYTreasureDB.dbo.GameScoreInfo SET Score=Score+@lRewardGold WHERE UserID=@dwUserID
		IF @@rowcount = 0
		BEGIN
			-- 插入资料
			INSERT INTO RYTreasureDBLink.RYTreasureDB.dbo.GameScoreInfo (UserID,Score,LastLogonIP, LastLogonMachine, RegisterIP, RegisterMachine)
			VALUES (@dwUserID, @lRewardGold, @strClientIP, @strMachineID, @strClientIP, @strMachineID)		
		END		

		-- 更新等级
		UPDATE RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo SET UserMedal=UserMedal+@lRewardIngot,GrowLevelID=@NowGrowLevelID WHERE UserID=@dwUserID

		IF @lRewardIngot > 0
		BEGIN
			-- 元宝记录
			INSERT INTO RYAccountsDBLink.RYAccountsDB.dbo.RecordMedalChange(UserID,SrcMedal,TradeMedal,TypeID,ClientIP,CollectDate)	
			VALUES (@dwUserID,@CurrMedal,@lRewardIngot,1,@strClientIP,GETDATE())
		END
		
		-- 流水账
		INSERT INTO RYTreasureDBLink.RYTreasureDB.dbo.RecordPresentInfo(UserID,PreScore,PreInsureScore,PresentScore,TypeID,IPAddress,CollectDate)
		VALUES (@dwUserID,@CurrScore,@CurrInsure,@lRewardGold,11,@strClientIP,GETDATE())
		
		-- 计算时间
		DECLARE @DateID INT
		SET @DateID=CAST(CAST(GETDATE() AS FLOAT) AS INT)
		-- 日统计
		UPDATE RYTreasureDBLink.RYTreasureDB.dbo.StreamPresentInfo SET DateID=@DateID, PresentCount=PresentCount+1,PresentScore=PresentScore+@lRewardGold WHERE UserID=@dwUserID AND TypeID=11
		IF @@ROWCOUNT=0
		BEGIN
			INSERT RYTreasureDBLink.RYTreasureDB.dbo.StreamPresentInfo(DateID,UserID,TypeID,PresentCount,PresentScore) VALUES(@DateID,@dwUserID,11,1,@lRewardGold)
		END	
		
		-- 升级提示
		SET @strUpgradeDescribe = N'恭喜您升为'+CAST(@NowGrowLevelID AS NVARCHAR)+N'级，系统奖励游戏币 '+CAST(@lRewardGold AS NVARCHAR)+N' ,元宝 '+CAST(@lRewardIngot AS NVARCHAR)

		-- 设置变量
		SET @GrowlevelID=@NowGrowLevelID		
	END
	ELSE
	BEGIN
		-- 更新等级
		UPDATE RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo SET GrowLevelID=@NowGrowLevelID WHERE UserID=@dwUserID	
		
		-- 设置变量
		SET @GrowlevelID=@NowGrowLevelID	
	END

	DECLARE @QuerylevelID INT
	SET @QuerylevelID=@GrowlevelID
	IF @GrowlevelID=0 SET @QuerylevelID=1

	-- 下一等级	
	DECLARE	@UpgradeRewardGold BIGINT
	DECLARE	@UpgradeRewardMedal BIGINT
	DECLARE @UpgradeExperience BIGINT	
	SELECT @UpgradeExperience=Experience,@UpgradeRewardGold=RewardGold,@UpgradeRewardMedal=RewardMedal FROM RYPlatformDBLink.RYPlatformDB.dbo.GrowLevelConfig
	WHERE LevelID=@GrowlevelID+1
	
	-- 调整变量
	IF @UpgradeExperience IS NULL SET @UpgradeExperience=0
	IF @UpgradeRewardGold IS NULL SET @UpgradeRewardGold=0
	IF @UpgradeRewardMedal IS NULL SET @UpgradeRewardMedal=0

	-- 查询游戏币
	SELECT @Score=Score FROM RYTreasureDBLink.RYTreasureDB.dbo.GameScoreInfo WHERE UserID=@dwUserID
	
	-- 查询元宝	
	SELECT @Ingot=UserMedal FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo WHERE UserID=@dwUserID

	-- 抛出数据
	SELECT @GrowlevelID AS CurrLevelID,@Experience AS Experience,@UpgradeExperience AS UpgradeExperience, @UpgradeRewardGold AS RewardGold,
		   @UpgradeRewardMedal AS RewardMedal,@Score AS Score,@Ingot AS Ingot
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------
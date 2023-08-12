
----------------------------------------------------------------------------------------------------

USE RYPlatformDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID =OBJECT_ID(N'[dbo].[GSP_GP_QueryUserBackpack]')and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_QueryUserBackpack]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_UseProp]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_UseProp]
GO

----------------------------------------------------------------------------------------------------

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

-- 查询背包
CREATE PROC GSP_GP_QueryUserBackpack
	@dwUserID INT,								-- 用户 I D
	@dwKind	INT									-- 道具类型
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN
-- 变量定义
	DECLARE @LogonPass AS NCHAR(32)
	-- 查询用户
	SELECT @LogonPass=LogonPass FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo WHERE UserID=@dwUserID
	
	IF @LogonPass is NULL
	BEGIN
		--N'个人信息查询失败！'
		RETURN 1
	END
	
	if @dwKind = 0
		select * from RYAccountsDBLink.RYAccountsDB.dbo.AccountsPackage as a, GameProperty as b where a.GoodsID=b.ID and a.UserID=@dwUserID and a.GoodsCount > 0
	else
		select * from RYAccountsDBLink.RYAccountsDB.dbo.AccountsPackage as a, GameProperty as b where a.GoodsID=b.ID and a.UserID=@dwUserID and a.GoodsCount > 0 and b.Kind=@dwKind
	RETURN 0
	END

RETURN 0

GO

---------------------------------------------------------------------------------------------------

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

CREATE PROC GSP_GP_UseProp
	@dwUserID INT,				-- 用户 I D
	@dwRecvUserID INT,			-- 接收方用户ID
	@dwPropID INT,				-- 道具ID
	@dwPropCount INT,			-- 道具数量
	@strClientIP NVARCHAR(15),	-- 连接地址
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN

	--定义变量
	DECLARE @useArea INT 
	DECLARE @ServiceArea INT 
	DECLARE @UseResultsGold INT 
	DECLARE @SendLoveLiness INT 
	DECLARE @RecvLoveLiness INT 
	DECLARE @UseResultsValidTime BIGINT 
	DECLARE @UseResultsValidTimeScoreMultiple SMALLINT 
	DECLARE @Kind INT 
	DECLARE @szPropName NVARCHAR(31)
	DECLARE @CurrMemberOrder TINYINT
	DECLARE @GoodsCount INT 
	DECLARE @BuffName NVARCHAR(32)
	DECLARE @UseTime DATETIME 
	DECLARE @ValidTime BIGINT
	DECLARE @CurrGetGold BIGINT
	DECLARE @OverTime DATETIME
	DECLARE @CurGoodsCount INT
	
	SET @useArea = 0
	SET @ServiceArea = 0
	SET @UseResultsGold = 0
	SET @SendLoveLiness = 0
	SET @RecvLoveLiness = 0
	SET @UseResultsValidTime = 0
	SET @UseResultsValidTimeScoreMultiple = 0
	SET @Kind = 0
	SET @CurrMemberOrder =0
	SET @GoodsCount = 0
	SET @UseTime = GETDATE()
	SET @ValidTime = 0
	SET @CurrGetGold=0
	
				
	-- 查询背包
	SELECT @GoodsCount = GoodsCount FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsPackage WHERE UserID=@dwUserID and GoodsID=@dwPropID
	IF @GoodsCount = 0 or @GoodsCount < @dwPropCount
	BEGIN
		SET @strErrorDescribe=N'道具数量不足'
		RETURN 1
	END

	-- 查询道具
	SELECT @useArea = UseArea, @ServiceArea = ServiceArea, @UseResultsGold = UseResultsGold, @szPropName = Name,
	@SendLoveLiness = SendLoveLiness, @RecvLoveLiness = RecvLoveLiness, @UseResultsValidTime = UseResultsValidTime,
	@Kind = Kind, @UseResultsValidTimeScoreMultiple=UseResultsValidTimeScoreMultiple
	FROM GameProperty  WHERE ID=@dwPropID
	IF @szPropName is null
	BEGIN
		SET @strErrorDescribe=N'道具不存在'
		RETURN 2
	END

	-- 礼物道具
	IF @Kind = 1
	BEGIN
		-- 查询玩家
		IF NOT EXISTS (SELECT UserID FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo WHERE @dwRecvUserID=UserID)
		BEGIN
			SET @strErrorDescribe=N'被赠送玩家不存在'
			RETURN 3
		END	
		
		-- 更新魅力
		IF @SendLoveLiness <> 0
			UPDATE RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo SET LoveLiness = LoveLiness+@SendLoveLiness WHERE UserID=@dwUserID
		
		IF @RecvLoveLiness <> 0
			UPDATE RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo SET LoveLiness = LoveLiness+@RecvLoveLiness WHERE UserID=@dwRecvUserID
	END
	
	-- 宝石道具
	IF @Kind = 2
	BEGIN
		SET @CurrGetGold = @UseResultsGold *@dwPropCount
		UPDATE RYTreasureDBLink.RYTreasureDB.dbo.GameScoreInfo SET Score = @CurrGetGold + Score WHERE UserID=@dwUserID
	END
	
	--卡片道具
	IF @Kind = 3 or @Kind=4 or  @Kind=5 
	BEGIN
		IF @Kind = 3
			SET @BuffName=N'双倍卡'
		ELSE IF @Kind = 4
			SET @BuffName=N'护身卡'
		ELSE IF @Kind = 5
			SET @BuffName=N'防踢卡'
			
		--插入Buff表
		SELECT @UseTime=UseTime, @ValidTime = UseResultsValidTime FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfoPoperty WHERE UserID=@dwUserID and KindID=@Kind
		IF @ValidTime = 0
		BEGIN
			SET @UseTime = GETDATE()
			SET @ValidTime = @UseResultsValidTime*@dwPropCount
			INSERT RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfoPoperty(UserID, KindID, UseTime, UseResultsValidTime, UseResultsValidTimeScoreMultiple, Name) 
			VALUES(@dwUserID, @Kind, GETDATE(), @UseResultsValidTime*@dwPropCount, @UseResultsValidTimeScoreMultiple, @BuffName)
		END
		ELSE
		BEGIN
			SET @OverTime = DATEADD(SECOND,@ValidTime,@UseTime)
			--过期检查
			IF @OverTime > GETDATE() --没有过期
			BEGIN
				SET @ValidTime = @ValidTime+@UseResultsValidTime*@dwPropCount
				UPDATE RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfoPoperty SET UseResultsValidTime=@ValidTime WHERE UserID=@dwUserID and KindID=@Kind
			END
			ELSE	--过期
			BEGIN
				SET @UseTime = GETDATE()
				SET @ValidTime = @UseResultsValidTime*@dwPropCount
				UPDATE RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfoPoperty SET UseTime=@UseTime, UseResultsValidTime=@ValidTime WHERE UserID=@dwUserID and KindID=@Kind
			END
		END
	END
	
	--会员道具
	IF @Kind = 6 
	BEGIN
		-- 会员资料
		DECLARE @MemberRight AS INT	
		DECLARE @MemberOverDate DATETIME
		DECLARE @MemberOrder TINYINT	
		DECLARE @MemberValidMonth INT
		DECLARE @MaxUserRight INT
		DECLARE @MaxMemberOrder TINYINT	 
		DECLARE @MemberSwitchDate DATETIME		
		
		-- 删除过期
		DELETE FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsMember WHERE UserID=@dwUserID  AND MemberOverDate<=GETDATE()
		
		-- 查询权限	
		SELECT @MemberRight=UserRight FROM RYAccountsDBLink.RYAccountsDB.dbo.MemberProperty
		
		-- 查询时间
		SET @MemberValidMonth = 1 * @dwPropCount 
		
		-- 查询等级
		SET @MemberOrder= @dwPropID % 100
		
		-- 会员记录
		UPDATE RYAccountsDBLink.RYAccountsDB.dbo.AccountsMember SET MemberOverDate=DATEADD(mm,@MemberValidMonth, MemberOverDate)
		WHERE UserID=@dwUserID AND MemberOrder=@MemberOrder
		IF @@ROWCOUNT=0
		BEGIN
		INSERT RYAccountsDBLink.RYAccountsDB.dbo.AccountsMember(UserID,MemberOrder,UserRight,MemberOverDate)
			VALUES (@dwUserID,@MemberOrder,@MemberRight,DATEADD(mm,@MemberValidMonth, GETDATE()))
		END
		
		-- 切换会员
		SELECT @MaxMemberOrder=MAX(MemberOrder),@MemberOverDate=MAX(MemberOverDate),@MemberSwitchDate=MIN(MemberOverDate)
		FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsMember WHERE UserID=@dwUserID
		
		-- 切换权限
		SELECT @MaxUserRight=UserRight FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsMember
		WHERE UserID=@dwUserID AND MemberOrder=@MaxMemberOrder	
		
		-- 更新会员
		UPDATE RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo
		SET MemberOrder=@MaxMemberOrder,UserRight=@MaxUserRight,MemberOverDate=@MemberOverDate,MemberSwitchDate=@MemberSwitchDate
		WHERE UserID=@dwUserID	
	
	END
	
	--负分清零
	IF @Kind=9  
	BEGIN
		DECLARE @UserGameScore INT 
		SET @UserGameScore = 0
		SELECT @UserGameScore=Score FROM RYGameScoreDBLink.RYGameScoreDB.dbo.GameScoreInfo WHERE UserID=@dwUserID
		IF @UserGameScore >= 0
		BEGIN
			SET @strErrorDescribe=N'您的积分不为负分，无法清除'
			RETURN 3
		END
		ELSE
			UPDATE RYGameScoreDBLink.RYGameScoreDB.dbo.GameScoreInfo SET Score=0 WHERE UserID=@dwUserID
	END
	
	--逃跑清零
	IF @Kind=10  
	BEGIN
		DECLARE @FleeCount INT 
		SET @FleeCount = 0
		SELECT @FleeCount=FleeCount FROM RYTreasureDBLink.RYTreasureDB.dbo.GameScoreInfo WHERE UserID=@dwUserID
		IF @FleeCount=0
		BEGIN
			SET @strErrorDescribe=N'您的逃跑率未大于0，无法清除'
			RETURN 4
		END
		ELSE
			UPDATE RYTreasureDBLink.RYTreasureDB.dbo.GameScoreInfo SET FleeCount=0 WHERE UserID=@dwUserID
	END
	
	
	--减少道具
	SET @CurGoodsCount= @GoodsCount-@dwPropCount
	IF @CurGoodsCount > 0
	BEGIN
		UPDATE RYAccountsDBLink.RYAccountsDB.dbo.AccountsPackage SET GoodsCount = @CurGoodsCount WHERE UserID=@dwUserID and GoodsID=@dwPropID
	END
	ELSE
	BEGIN
		DELETE RYAccountsDBLink.RYAccountsDB.dbo.AccountsPackage WHERE UserID=@dwUserID and GoodsID=@dwPropID
	END
		
	--道具记录
	insert RYRecordDBLink.RYRecordDB.dbo.RecordUseProperty(SourceUserID, TargetUserID,PropertyID, PropertyName,
	PropertyCount, LovelinessRcv, LovelinessSend,KindID, ServerID, ClientIP, UseDate)
	values(@dwUserID, @dwRecvUserID, @dwPropID, @szPropName, @dwPropCount, 
	@RecvLoveLiness, @SendLoveLiness, 0, 0, @strClientIP, GETDATE())
	
	-- 查询金币
	DECLARE @Score BIGINT
	SET @Score = 0
	SELECT @Score=Score FROM RYTreasureDBLink.RYTreasureDB.dbo.GameScoreInfo WHERE UserID = @dwUserID 	
	
	--当前会员
	SELECT @CurrMemberOrder=MemberOrder FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo WHERE UserID = @dwUserID
	
	SELECT @useArea AS UseArea, @ServiceArea AS ServiceArea, @CurGoodsCount AS CurGoodsCount, @Score AS Score,@CurrGetGold AS UseResultsGold,
	@SendLoveLiness AS SendLoveLiness, @RecvLoveLiness AS RecvLoveLiness,@UseTime AS UseTime, @ValidTime AS UseResultsValidTime, @Kind AS Kind, 
	@szPropName AS Name,@UseResultsValidTimeScoreMultiple AS UseResultsValidTimeScoreMultiple, @CurGoodsCount AS RemainderCount ,@CurrMemberOrder AS MemberOrder
	
	SET @strErrorDescribe=@szPropName + N'使用成功'
	RETURN 0

END

RETURN 0

GO

---------------------------------------------------------------------------------------------
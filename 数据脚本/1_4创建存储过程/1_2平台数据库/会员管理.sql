
----------------------------------------------------------------------------------------------------

USE RYPlatformDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_LoadMemberParameter]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_LoadMemberParameter]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_MemberGiftQuery]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_MemberGiftQuery]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_MemberQueryInfo]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_MemberQueryInfo]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_MemberDayPresent]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_MemberDayPresent]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_MemberDayGift]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_MemberDayGift]
GO



SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- 加载会员
CREATE PROC GSP_GP_LoadMemberParameter	
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN
	-- 加载会员
	SELECT * FROM RYAccountsDBLink.RYAccountsDB.dbo.MemberProperty

END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

-- 查询礼包
CREATE PROC GSP_GP_MemberGiftQuery	
	@dwUserID INT,								-- 用户 I D
	@strPassword NCHAR(32),						-- 用户密码
	@strClientIP NVARCHAR(15),					-- 连接地址
	@strMachineID NVARCHAR(32)					-- 机器标识
WITH ENCRYPTION AS


-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN

	-- 查询用户
	IF not exists(SELECT * FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo WHERE UserID=@dwUserID AND LogonPass=@strPassword)
	BEGIN
		return 1
	END

	-- 会员等级
    DECLARE @CurrMemberOrder SMALLINT
    SET   @CurrMemberOrder = 0
    SELECT @CurrMemberOrder=MemberOrder FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo WHERE UserID=@dwUserID
    
    --普通查看
    IF @CurrMemberOrder =0
		SET @CurrMemberOrder =1
 
	-- 查询礼包
    DECLARE @DayGiftID INT
    SET   @DayGiftID = 0
	SELECT @DayGiftID=DayGiftID FROM RYAccountsDBLink.RYAccountsDB.dbo.MemberProperty where @CurrMemberOrder =MemberOrder

	--礼包物品
	SELECT *  FROM GamePropertySub WHERE OwnerID = @DayGiftID
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

-- 查询会员
CREATE PROC GSP_GP_MemberQueryInfo
	@dwUserID INT,								-- 用户 I D
	@strPassword NCHAR(32),						-- 用户密码
	@strClientIP NVARCHAR(15),					-- 连接地址
	@strMachineID NVARCHAR(32)					-- 机器标识
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN

	-- 查询用户
	IF not exists(SELECT * FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo WHERE UserID=@dwUserID AND LogonPass=@strPassword)
	BEGIN
		return 1
	END
	
	-- 会员等级
    DECLARE @CurrMemberOrder SMALLINT
    SET   @CurrMemberOrder = 0
    SELECT @CurrMemberOrder=MemberOrder FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo WHERE UserID=@dwUserID
    
	DECLARE @Present INT
	SET @Present = 0	
	DECLARE @Gift INT
	SET @Gift = 0		   
    -- 会员判定
    IF @CurrMemberOrder >0
    BEGIN
		-- 时间查询
		DECLARE @TodayDateID INT
		SET @TodayDateID=CAST(CAST(GetDate() AS FLOAT) AS INT) 
		
		-- 送金定义
		DECLARE @TakeGold INT
		-- 送金记录
		SELECT @TakeGold=TakeGold FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsMemberDayPresent WHERE UserID=@dwUserID AND TakeDateID=@TodayDateID
		IF @TakeGold IS NULL 
		BEGIN
			SET @Present=1
		END
		ELSE
		BEGIN
			SET @Present=0
		END

		-- 礼包定义
		DECLARE @GiftID INT
		-- 礼包记录
		SELECT @GiftID=GiftID FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsMemberDayGift WHERE UserID=@dwUserID AND TakeDateID=@TodayDateID
		IF @GiftID IS NULL 
		BEGIN
			SET @Gift=1
		END
		ELSE
		BEGIN
			SET @Gift=0
		END   
		
		-- 检查送金礼包
		DECLARE @CurrPresentGold INT
		DECLARE @CurrPresentGiftID INT
		SELECT @CurrPresentGold =DayPresent,@CurrPresentGiftID= DayGiftID from RYAccountsDBLink.RYAccountsDB.dbo.MemberProperty WHERE @CurrMemberOrder = MemberOrder
		IF @CurrPresentGold = 0  SET @Present=0
		IF @CurrPresentGiftID = 0  
		BEGIN
		   SET @Gift=0
		END
		ELSE
		BEGIN
			DECLARE @CurrPresentGiftIDCount INT
			SET @CurrPresentGiftIDCount = 0
			--礼包物品
			SELECT @CurrPresentGiftIDCount = count(*)  FROM GamePropertySub WHERE OwnerID = @CurrPresentGiftID	
			IF @CurrPresentGiftIDCount = 0 	 SET @Gift=0
		END

    END

	-- 抛出数据
	SELECT @Present AS Present	,@Gift AS Gift
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

-- 会员送金
CREATE PROC GSP_GP_MemberDayPresent
	@dwUserID INT,								-- 用户 I D
	@strPassword NCHAR(32),						-- 用户密码
	@strClientIP NVARCHAR(15),					-- 连接地址
	@strMachineID NVARCHAR(32),					-- 机器标识
	@strNotifyContent NVARCHAR(127) OUTPUT        -- 提示内容
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN

	-- 查询用户
	IF not exists(SELECT * FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo WHERE UserID=@dwUserID AND LogonPass=@strPassword)
	BEGIN
		return 1
	END
	
	-- 时间查询
	DECLARE @TodayDateID INT
	SET @TodayDateID=CAST(CAST(GetDate() AS FLOAT) AS INT) 
	
	-- 送金定义
	DECLARE @Present INT
	SET @Present = 0	
	DECLARE @TakeGold INT
	
	-- 送金记录
	SELECT @TakeGold=TakeGold FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsMemberDayPresent WHERE UserID=@dwUserID AND TakeDateID=@TodayDateID
	IF @TakeGold IS NULL 
		BEGIN
			SET @Present=1
		END
	ELSE
		BEGIN
			SET @Present=0
		END

	-- 送金判断
    IF @Present = 0
    BEGIN
        SET @strNotifyContent = N'您今日已领取，领取失败！'
        return 2        
    END
    

    -- 会员等级
    DECLARE @CurrMemberOrder SMALLINT
    SET   @CurrMemberOrder = 0
    SELECT @CurrMemberOrder=MemberOrder FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo WHERE UserID=@dwUserID
    
    -- 会员判定
    IF @CurrMemberOrder =0
    BEGIN
        SET @strNotifyContent = N'现在还不是会员！'
        return 3        
    END
    
    --查询送金
    DECLARE @lRewardGold BIGINT
    SET @lRewardGold = 0
    SELECT @lRewardGold = DayPresent FROM RYAccountsDBLink.RYAccountsDB.dbo.MemberProperty where @CurrMemberOrder =MemberOrder

	-- 查询金币
	DECLARE @CurrScore BIGINT
	DECLARE @CurrInsure BIGINT
	SELECT @CurrScore=Score,@CurrInsure=InsureScore FROM RYTreasureDBLink.RYTreasureDB.dbo.GameScoreInfo  WHERE UserID=@dwUserID
	
    -- 领取金币    
    UPDATE  RYTreasureDBLink.RYTreasureDB.dbo.GameScoreInfo SET Score = Score + @lRewardGold WHERE UserID = @dwUserID
    
     -- 更新记录
    IF @Present=1
	BEGIN
		INSERT INTO RYAccountsDBLink.RYAccountsDB.dbo.AccountsMemberDayPresent(UserID,TakeDateID,TakeGold) VALUES(@dwUserID,@TodayDateID,@lRewardGold)        
	END 
    
    -- 流水账
	INSERT INTO RYTreasureDBLink.RYTreasureDB.dbo.RecordPresentInfo(UserID,PreScore,PreInsureScore,PresentScore,TypeID,IPAddress,CollectDate)
	VALUES (@dwUserID,@CurrScore,@CurrInsure,@lRewardGold,9,@strClientIP,GETDATE())	
	
	-- 日统计
	DECLARE @DateID INT
	SET @DateID=CAST(CAST(GETDATE() AS FLOAT) AS INT)
	UPDATE RYTreasureDBLink.RYTreasureDB.dbo.StreamPresentInfo SET DateID=@DateID, PresentCount=PresentCount+1,PresentScore=PresentScore+@lRewardGold WHERE UserID=@dwUserID AND TypeID=9
	IF @@ROWCOUNT=0
	BEGIN
		INSERT RYTreasureDBLink.RYTreasureDB.dbo.StreamPresentInfo(DateID,UserID,TypeID,PresentCount,PresentScore) VALUES(@DateID,@dwUserID,9,1,@lRewardGold)
	END	
	
    -- 查询金币
    DECLARE @Score BIGINT
    SELECT @Score=Score FROM RYTreasureDBLink.RYTreasureDB.dbo.GameScoreInfo WHERE UserID = @dwUserID     

	-- 输出提示
    SET @strNotifyContent = N'恭喜您，领取 '+CAST(@lRewardGold AS NVARCHAR)+N' 游戏币！'
	
	-- 抛出数据
	SELECT @Score AS Score
	
	RETURN 0
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

-- 会员礼包
CREATE PROC GSP_GP_MemberDayGift
	@dwUserID INT,								-- 用户 I D
	@strPassword NCHAR(32),						-- 用户密码
	@strClientIP NVARCHAR(15),					-- 连接地址
	@strMachineID NVARCHAR(32),					-- 机器标识
	@strNotifyContent NVARCHAR(127) OUTPUT        -- 提示内容
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN

	-- 查询用户
	IF not exists(SELECT * FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo WHERE UserID=@dwUserID AND LogonPass=@strPassword)
	BEGIN
		return 1
	END
	
	-- 时间查询
	DECLARE @TodayDateID INT
	SET @TodayDateID=CAST(CAST(GetDate() AS FLOAT) AS INT) 
	
	-- 礼包定义
	DECLARE @Gift INT
	SET @Gift = 0
	DECLARE @GiftID INT
	
	-- 礼包记录
	SELECT @GiftID=GiftID FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsMemberDayGift WHERE UserID=@dwUserID AND TakeDateID=@TodayDateID
	IF @GiftID IS NULL 
		BEGIN
			SET @Gift=1
		END
	ELSE
		BEGIN
			SET @Gift=0
		END

	-- 礼包判断
    IF @Gift = 0
    BEGIN
        SET @strNotifyContent = N'您今日已领取，领取失败！'
        return 2        
    END
    

    -- 会员等级
    DECLARE @CurrMemberOrder SMALLINT
    SET   @CurrMemberOrder = 0
    SELECT @CurrMemberOrder=MemberOrder FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo WHERE UserID=@dwUserID
    
    -- 会员判定
    IF @CurrMemberOrder =0
    BEGIN
        SET @strNotifyContent = N'现在还不是会员！'
        return 3        
    END
    
    --查询礼包
    DECLARE @DayGiftID BIGINT
    SET @DayGiftID = 0
    SELECT @DayGiftID = DayGiftID FROM RYAccountsDBLink.RYAccountsDB.dbo.MemberProperty where @CurrMemberOrder =MemberOrder

    -- 查询礼包
    DECLARE @PROPERTYID BIGINT
    DECLARE @MemberGiftName NVARCHAR(32)
    SELECT  @PROPERTYID = ID,@MemberGiftName= Name FROM GameProperty WHERE @DayGiftID = ID
    
    IF @PROPERTYID IS NULL
    BEGIN
        SET @strNotifyContent = N'没找到礼包！'
        return 4        
    END
    
    IF @PROPERTYID > 400 AND @PROPERTYID <500
    BEGIN
		--放入背包
		DECLARE @PropID INT
		DECLARE @PropCount INT
		DECLARE @ItemCount INT
		DECLARE auth_cur CURSOR FOR
		SELECT a.ID,[Count] FROM GamePropertySub AS a, GameProperty AS b WHERE a.ID=b.ID AND a.OwnerID = @PROPERTYID
		OPEN auth_cur
		FETCH NEXT FROM auth_cur INTO @PropID,@PropCount
		WHILE (@@fetch_status=0)
		BEGIN
			SELECT @ItemCount=COUNT(*) FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsPackage WHERE UserID=@dwUserID and GoodsID=@PropID
			IF @ItemCount = 0
			BEGIN
				INSERT RYAccountsDBLink.RYAccountsDB.dbo.AccountsPackage(UserID,GoodsID,GoodShowID,GoodsSortID,GoodsCount,PushTime)
				VALUES(@dwUserID,@PropID,0,0,@PropCount,GETDATE())
			END
			ELSE
			BEGIN
				UPDATE RYAccountsDBLink.RYAccountsDB.dbo.AccountsPackage SET GoodsCount=GoodsCount+@PropCount
				WHERE UserID=@dwUserID and GoodsID=@PropID
			END
			FETCH NEXT FROM auth_cur INTO @PropID,@PropCount
		END
		close auth_cur
		deallocate auth_cur
    END
    ELSE
    BEGIN
		UPDATE RYAccountsDBLink.RYAccountsDB.dbo.AccountsPackage SET GoodShowID=0, GoodsCount=GoodsCount+1, PushTime=GETDATE() WHERE UserID=@dwUserID AND GoodsID=@PROPERTYID
		IF @@ROWCOUNT =0
		BEGIN
			INSERT RYAccountsDBLink.RYAccountsDB.dbo.AccountsPackage(UserID,GoodsID,GoodShowID,GoodsCount,PushTime)
			VALUES(@dwUserID,@PROPERTYID,0,1,GETDATE())
		END
    END	
	     
     -- 更新记录
    IF @Gift=1
	BEGIN
		INSERT INTO RYAccountsDBLink.RYAccountsDB.dbo.AccountsMemberDayGift(UserID,TakeDateID,GiftID) VALUES(@dwUserID,@TodayDateID,@PROPERTYID)        
	END 
	
	-- 输出提示
    SET @strNotifyContent = N'恭喜您，领取 '+@MemberGiftName
	
	RETURN 0
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------

USE RYPlatformDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_LoadTaskList]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_LoadTaskList]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_QueryTaskInfo]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_QueryTaskInfo]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_TaskTake]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_TaskTake]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_TaskForward]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_TaskForward]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_TaskReward]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_TaskReward]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_TaskGiveUp]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_TaskGiveUp]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- 加载任务
CREATE PROC GSP_GR_LoadTaskList
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN

	-- 查询任务
	SELECT * FROM TaskInfo	

END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

-- 查询任务
CREATE PROC GSP_GR_QueryTaskInfo
	@wKindID INT,								-- 类型 I D
	@dwUserID INT,								-- 用户 I D
	@strPassword NCHAR(32),						-- 用户密码
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN
	
	-- 查询用户
	IF not exists(SELECT * FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo WHERE UserID=@dwUserID)
	BEGIN
		SET @strErrorDescribe = N'抱歉，你的用户信息不存在或者密码不正确！'
		return 1
	END

	-- 超时处理
	UPDATE RYAccountsDBLink.RYAccountsDB.dbo.AccountsTask SET TaskStatus=2 
	WHERE UserID=@dwUserID AND TaskStatus=0 AND TimeLimit<DateDiff(s,InputDate,GetDate())

	-- 查询任务
	SELECT TaskID,TaskStatus,Progress,(TimeLimit-DateDiff(ss,InputDate,GetDate())) AS ResidueTime FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsTask 
	WHERE UserID=@dwUserID AND DateDiff(d,InputDate,GetDate())=0 AND (((@wKindID=KindID) AND TaskStatus=0) OR @wKindID=0) 		
END

RETURN 0

GO
----------------------------------------------------------------------------------------------------

-- 领取任务
CREATE PROC GSP_GR_TaskTake
	@dwUserID INT,								-- 用户 I D
	@wTaskID  INT,								-- 任务 I D
	@strPassword NCHAR(32),						-- 用户密码
	@strClientIP NVARCHAR(15),					-- 连接地址
	@strMachineID NVARCHAR(32),					-- 机器标识
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN

	-- 查询用户
	DECLARE @MemberOrder INT
	SELECT @MemberOrder=MemberOrder FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo 
	WHERE UserID=@dwUserID AND LogonPass=@strPassword
	IF @MemberOrder IS NULL
	BEGIN
		SET @strErrorDescribe = N'抱歉，你的用户信息不存在或者密码不正确！'
		return 1
	END

	-- 重复领取
	IF exists(SELECT * FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsTask 
	WHERE UserID=@dwUserID AND TaskID=@wTaskID AND DateDiff(d,InputDate,GetDate())=0) 
	BEGIN
		SET @strErrorDescribe = N'抱歉，同一个任务每天只能领取一次！'
		RETURN 3		
	END

	-- 判断数目	
	DECLARE @TaskTakeMaxCount AS INT
	SELECT @TaskTakeMaxCount=StatusValue FROM RYAccountsDBLink.RYAccountsDB.dbo.SystemStatusInfo WHERE StatusName=N'TaskTakeCount'	

	-- 调整数目
	IF @TaskTakeMaxCount IS NULL SET @TaskTakeMaxCount=5

	-- 统计任务
	DECLARE @TaskTakeCount AS INT
	SELECT @TaskTakeCount=Count(*) FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsTask 
	WHERE UserID=@dwUserID AND DateDiff(d,InputDate,GetDate())=0 

	-- 任务已满
	IF @TaskTakeCount>=@TaskTakeMaxCount	
	BEGIN
		SET @strErrorDescribe = N'抱歉，您已领取的任务数目已达到系统设置的每天领取上限，请明天再来领取！'				
		RETURN 3
	END

	-- 任务对象
	DECLARE @KindID INT
	DECLARE @UserType INT
	DECLARE @TimeLimit INT
	DECLARE @TaskType INT
	DECLARE @TaskObject INT	
	SELECT @KindID=KindID,@UserType=UserType,@TimeLimit=TimeLimit,@TaskType=TaskType,@TaskObject=Innings
	FROM TaskInfo WHERE TaskID=@wTaskID
	IF @KindID IS NULL
	BEGIN
		SET @strErrorDescribe = N'抱歉，系统未找到您领取的任务信息！'
		RETURN 4			
	END

	-- 普通玩家
	IF @MemberOrder=0 AND (@UserType&0x01)=0
	BEGIN
		SET @strErrorDescribe = N'抱歉，该任务暂时不对普通玩家开放！'
		RETURN 5			
	END

	-- 会员玩家
	IF @MemberOrder>0 AND (@UserType&0x02)=0
	BEGIN
		SET @strErrorDescribe = N'抱歉，该任务暂时不对会员玩家开放！'
		RETURN 6			
	END	

	-- 插入任务
	INSERT INTO RYAccountsDBLink.RYAccountsDB.dbo.AccountsTask(UserID,TaskID,TaskType,TaskObject,KindID,TimeLimit) 
	VALUES(@dwUserID,@wTaskID,@TaskType,@TaskObject,@KindID,@TimeLimit)	

	-- 成功提示
	SET @strErrorDescribe = N'恭喜您，任务领取成功！'	
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

-- 任务推进
CREATE PROC GSP_GR_TaskForward
	@dwUserID INT,								-- 用户 I D
	@wKindID INT,								-- 游戏标识
	@wMatchID INT,								-- 比赛标识
	@lWinCount INT,								-- 赢局局数
	@lLostCount INT,							-- 输局局数
	@lDrawCount	INT								-- 和局局数
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN

	-- 查询任务	
	SELECT ID,TaskType,TaskObject,TimeLimit,TaskStatus,InputDate,(case 
									  when TaskType=0x01 then Progress+@lWinCount
									  when TaskType=0x02 then Progress+@lWinCount+@lLostCount+@lDrawCount
									  when TaskType=0x04 then @lWinCount
									  when TaskType=0x08 then Progress+@lWinCount
									  else Progress end) AS NewProgress
									  ,(case 
									  when TaskType=0x08 then @lLostCount+@lDrawCount
									  else 0 end) AS OtherProgress
	INTO #TempTaskInfo FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsTask 
	WHERE UserID=@dwUserID AND KindID=@wKindID AND TaskStatus=0 AND DateDiff(d,InputDate,GetDate())=0

	-- 更新状态（完成任务、首胜未胜、超时）
	UPDATE #TempTaskInfo SET TaskStatus=(case										 
										 when TaskType=0x04 AND NewProgress=0 then 2
										 
										 when TimeLimit<DateDiff(s,InputDate,GetDate()) then 2
										 when NewProgress>=TaskObject then 1
										 else 0 end)
	-- 更新物理表
	UPDATE RYAccountsDBLink.RYAccountsDB.dbo.AccountsTask SET a.Progress=b.NewProgress,a.TaskStatus=b.TaskStatus 
	FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsTask AS a,#TempTaskInfo AS b WHERE a.ID=b.ID

END

RETURN 0

GO

----------------------------------------------------------------------------------------------------
-- 领取奖励
CREATE PROC GSP_GR_TaskReward
	@dwUserID INT,								-- 用户 I D
	@wTaskID  INT,								-- 任务 I D
	@strPassword NCHAR(32),						-- 用户密码
	@strClientIP NVARCHAR(15),					-- 连接地址
	@strMachineID NVARCHAR(32),					-- 机器标识
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN

	-- 查询用户
	DECLARE @MemberOrder INT
	SELECT @MemberOrder=MemberOrder FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo 
	WHERE UserID=@dwUserID AND LogonPass=@strPassword
	IF @MemberOrder IS NULL
	BEGIN
		SET @strErrorDescribe = N'抱歉，你的用户信息不存在或者密码不正确！'
		return 1
	END

	-- 查询任务
	DECLARE @TaskInputDate DATETIME
	SELECT @TaskInputDate=InputDate FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsTask 
	WHERE UserID=@dwUserID AND TaskID=@wTaskID AND TaskStatus=1 AND DateDiff(d,InputDate,GetDate())=0
	IF @TaskInputDate IS NULL
	BEGIN
		SET @strErrorDescribe = N'请完成当前的任务再来领取奖励！'
		return 2		
	END		

	-- 查询奖励
	DECLARE @StandardAwardGold INT
	DECLARE @StandardAwardIngot INT
	DECLARE @MemberAwardGold INT
	DECLARE @MemberAwardIngot INT
	SELECT @StandardAwardGold=StandardAwardGold,@StandardAwardIngot=StandardAwardMedal,
	@MemberAwardGold=MemberAwardGold,@MemberAwardIngot=MemberAwardMedal	
	FROM TaskInfo WHERE TaskID=@wTaskID
	
    -- 会员等级
    DECLARE @CurrMemberOrder SMALLINT
    SET   @CurrMemberOrder = 0
    SELECT @CurrMemberOrder=MemberOrder FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo WHERE UserID=@dwUserID
    
    --会员奖励
    DECLARE @MemberRate INT
    SET @MemberRate = 0

    SELECT @MemberRate=TaskRate FROM RYAccountsDBLink.RYAccountsDB.dbo.MemberProperty where @CurrMemberOrder =MemberOrder
    SET @MemberAwardGold = (@StandardAwardGold * (100+ @MemberRate)/100)
    SET @MemberAwardIngot = (@StandardAwardIngot * (100+ @MemberRate)/100)

	-- 调整奖励
	IF @StandardAwardGold IS NULL SET @StandardAwardGold=0	
	IF @StandardAwardIngot IS NULL SET @StandardAwardIngot=0
	IF @MemberAwardGold IS NULL SET @MemberAwardGold=0
	IF @MemberAwardIngot IS NULL SET @MemberAwardIngot=0
	
	-- 查询金币
	DECLARE @CurrScore BIGINT
	DECLARE @CurrInsure BIGINT
	DECLARE @CurrMedal INT
	SELECT @CurrScore=Score,@CurrInsure=InsureScore FROM RYTreasureDBLink.RYTreasureDB.dbo.GameScoreInfo  WHERE UserID=@dwUserID
	SELECT @CurrMedal=UserMedal FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo WHERE UserID=@dwUserID
	
	-- 执行奖励
	DECLARE @lRewardGold INT
	DECLARE @lRewardIngot INT
	IF @MemberOrder=0
	BEGIN
		SELECT @lRewardGold=@StandardAwardGold,@lRewardIngot=@StandardAwardIngot
	END ELSE
	BEGIN
		SELECT @lRewardGold=@MemberAwardGold,@lRewardIngot=@MemberAwardIngot	
	END

	-- 更新元宝
	UPDATE RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo SET UserMedal=UserMedal+@lRewardIngot 
	WHERE UserID=@dwUserID	
		
	-- 更新金币
	UPDATE RYTreasureDBLink.RYTreasureDB.dbo.GameScoreInfo SET Score=Score+@lRewardGold 
	WHERE UserID=@dwUserID

	-- 查询分数
	DECLARE @UserScore BIGINT
	DECLARE @UserIngot BIGINT
	
	-- 查询金币
	SELECT @UserScore=Score FROM  RYTreasureDBLink.RYTreasureDB.dbo.GameScoreInfo 
	WHERE UserID=@dwUserID				

	-- 查询元宝
	SELECT @UserIngot=UserMedal FROM  RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo 
	WHERE UserID=@dwUserID
	
	-- 调整分数
	IF @UserScore IS NULL SET @UserScore=0		
	IF @UserIngot IS NULL SET @UserIngot=0

	-- 删除任务	
	UPDATE RYAccountsDBLink.RYAccountsDB.dbo.AccountsTask SET TaskStatus=3
	WHERE UserID=@dwUserID AND TaskID=@wTaskID AND DateDiff(d,InputDate,GetDate())=0
	
	-- 任务记录
	INSERT RYRecordDBLink.RYRecordDB.dbo.RecordTask(DateID,UserID,TaskID,AwardGold,AwardMedal,InputDate)
	VALUES (CAST(CAST(@TaskInputDate AS FLOAT) AS INT),@dwUserID,@wTaskID,@lRewardGold,@lRewardIngot,GetDate())

	-- 计算时间
	DECLARE @DateID INT
	SET @DateID=CAST(CAST(GETDATE() AS FLOAT) AS INT)
	
	IF @lRewardIngot > 0
	BEGIN
		-- 元宝记录
		INSERT INTO RYAccountsDBLink.RYAccountsDB.dbo.RecordMedalChange(UserID,SrcMedal,TradeMedal,TypeID,ClientIP,CollectDate)	
		VALUES (@dwUserID,@CurrMedal,@lRewardIngot,1,@strClientIP,GETDATE())
	END
	
	-- 流水账
	INSERT INTO RYTreasureDBLink.RYTreasureDB.dbo.RecordPresentInfo(UserID,PreScore,PreInsureScore,PresentScore,TypeID,IPAddress,CollectDate)
	VALUES (@dwUserID,@CurrScore,@CurrInsure,@lRewardGold,7,@strClientIP,GETDATE())
	
	-- 日统计
	UPDATE RYTreasureDBLink.RYTreasureDB.dbo.StreamPresentInfo SET DateID=@DateID, PresentCount=PresentCount+1,PresentScore=PresentScore+@lRewardGold WHERE UserID=@dwUserID AND TypeID=7
	IF @@ROWCOUNT=0
	BEGIN
		INSERT RYTreasureDBLink.RYTreasureDB.dbo.StreamPresentInfo(DateID,UserID,TypeID,PresentCount,PresentScore) VALUES(@DateID,@dwUserID,7,1,@lRewardGold)
	END	
		
	-- 成功提示
	SET @strErrorDescribe = N'恭喜您，奖励领取成功！'

	-- 抛出数据
	SELECT @UserScore AS Score,@UserIngot AS Ingot
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

-- 放弃任务
CREATE PROC GSP_GR_TaskGiveUp
	@dwUserID INT,								-- 用户 I D
	@wTaskID  INT,								-- 任务 I D
	@strPassword NCHAR(32),						-- 用户密码
	@strClientIP NVARCHAR(15),					-- 连接地址
	@strMachineID NVARCHAR(32),					-- 机器标识
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN

	-- 查询用户
	DECLARE @MemberOrder INT
	SELECT @MemberOrder=MemberOrder FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo 
	WHERE UserID=@dwUserID AND LogonPass=@strPassword
	IF @MemberOrder IS NULL
	BEGIN
		SET @strErrorDescribe = N'抱歉，你的用户信息不存在或者密码不正确！'
		return 1
	END

	-- 重复领取
	IF not exists(SELECT * FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsTask 
	WHERE UserID=@dwUserID AND TaskID=@wTaskID AND DateDiff(d,InputDate,GetDate())=0) 
	BEGIN
		SET @strErrorDescribe = N'抱歉，不能放弃没有的任务！'
		RETURN 3		
	END

	-- 放弃任务
	DECLARE @TaskTakeCount AS INT
	DELETE FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsTask 	WHERE UserID=@dwUserID AND TaskID=@wTaskID 

	-- 成功提示
	SET @strErrorDescribe = N'任务已经放弃！'	
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------

USE RYTreasureDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_LeaveGameServer]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_LeaveGameServer]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- 离开房间
CREATE PROC GSP_GR_LeaveGameServer

	-- 用户信息
	@dwUserID INT,								-- 用户 I D
	@dwOnLineTimeCount INT,						-- 在线时间

	-- 系统信息
	@dwInoutIndex INT,							-- 进出索引
	@dwLeaveReason INT,							-- 离开原因

	-- 记录成绩
	@lRecordScore BIGINT,						-- 用户分数
	@lRecordGrade BIGINT,						-- 用户成绩
	@lRecordInsure BIGINT,						-- 用户银行
	@lRecordRevenue BIGINT,						-- 游戏税收
	@lRecordWinCount INT,						-- 胜利盘数
	@lRecordLostCount INT,						-- 失败盘数
	@lRecordDrawCount INT,						-- 和局盘数
	@lRecordFleeCount INT,						-- 断线数目
	@lRecordUserMedal INT,						-- 用户奖牌
	@lRecordExperience INT,						-- 用户经验
	@lRecordLoveLiness INT,						-- 用户魅力
	@dwRecordPlayTimeCount INT,					-- 游戏时间

	-- 变更成绩
	@lVariationScore BIGINT,					-- 用户分数
	@lVariationGrade BIGINT,					-- 用户成绩
	@lVariationInsure BIGINT,					-- 用户银行
	@lVariationRevenue BIGINT,					-- 游戏税收
	@lVariationWinCount INT,					-- 胜利盘数
	@lVariationLostCount INT,					-- 失败盘数
	@lVariationDrawCount INT,					-- 和局盘数
	@lVariationFleeCount INT,					-- 断线数目
	@lVariationIntegralCount BIGINT,			-- 游戏积分		
	@lVariationUserMedal INT,					-- 用户奖牌
	@lVariationExperience INT,					-- 用户经验
	@lVariationLoveLiness INT,					-- 用户魅力
	@dwVariationPlayTimeCount INT,				-- 游戏时间

	-- 属性信息
	@wKindID INT,								-- 游戏 I D
	@wServerID INT,								-- 房间 I D
	@strClientIP NVARCHAR(15),					-- 连接地址
	@strMachineSerial NVARCHAR(32),				-- 机器标识
	@cbIsPersonalRoom TINYINT					-- 是否为私人房间	

WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN
	------------------------------------ 泡分开始 --------------------------------------------
	DECLARE @ServerID INT -- (-3:封顶配置,-2:积分房间公共配置,-1：金币房间公共配置)
	DECLARE @PresentMember NVARCHAR(50)
	DECLARE @MaxDatePresent INT
	DECLARE @MaxPresent	INT
	DECLARE @CellPlayPresnet INT
	DECLARE @CellPlayTime INT
	DECLARE @StartPlayTime INT
	DECLARE @CellOnlinePresent INT
	DECLARE @CellOnlineTime INT
	DECLARE @StartOnlineTime INT
	DECLARE @IsPlayPresent TINYINT
	DECLARE @IsOnlinePresent TINYINT
	DECLARE @PresentScore INT
	SET @PresentScore=0
	DECLARE @DateID	INT
	SET @DateID = CAST(CAST(GETDATE() AS FLOAT) AS INT)

	-- 泡点规则
	SELECT @ServerID=ServerID,@PresentMember=PresentMember,@CellPlayPresnet=CellPlayPresnet,@CellPlayTime=CellPlayTime,@StartPlayTime=StartPlayTime,
		@CellOnlinePresent=CellOnlinePresent,@CellOnlineTime=CellOnlineTime,@StartOnlineTime=StartOnlineTime,
		@IsPlayPresent=IsPlayPresent,@IsOnlinePresent=IsOnlinePresent
	FROM RYPlatformDBLink.RYPlatformDB.dbo.GlobalPlayPresent WHERE ServerID=@wServerID
	IF @ServerID IS NULL
	BEGIN
		SELECT @ServerID=ServerID,@PresentMember=PresentMember,@CellPlayPresnet=CellPlayPresnet,@CellPlayTime=CellPlayTime,@StartPlayTime=StartPlayTime,
		@CellOnlinePresent=CellOnlinePresent,@CellOnlineTime=CellOnlineTime,@StartOnlineTime=StartOnlineTime,
		@IsPlayPresent=IsPlayPresent,@IsOnlinePresent=IsOnlinePresent
		FROM RYPlatformDBLink.RYPlatformDB.dbo.GlobalPlayPresent WHERE ServerID=-1
		IF @ServerID IS NULL
		BEGIN
			SET @IsPlayPresent=0
			SET @IsOnlinePresent=0
		END
	END

	-- 封顶设置
	SELECT @MaxDatePresent=MaxDatePresent,@MaxPresent=MaxPresent
	FROM RYPlatformDBLink.RYPlatformDB.dbo.GlobalPlayPresent WHERE ServerID=-3
	IF @MaxDatePresent IS NULL
	BEGIN
		SET @MaxDatePresent=0
		SET @MaxPresent=0
	END

	-- 游戏时长泡分
	IF @IsPlayPresent=1
	BEGIN
		IF @dwRecordPlayTimeCount<>0 AND @CellPlayTime<>0
		BEGIN
			IF @dwRecordPlayTimeCount>=@StartPlayTime
			BEGIN
				SET @PresentScore=@PresentScore+(@dwRecordPlayTimeCount/@CellPlayTime)*@CellPlayPresnet
			END
		END		
	END
	
	-- 在线时长泡分
	IF @IsOnlinePresent=1
	BEGIN
		IF @dwOnLineTimeCount<>0 AND @CellOnlineTime<>0
		BEGIN
			IF @dwOnLineTimeCount>=@StartOnlineTime
			BEGIN
				SET @PresentScore=@PresentScore+(@dwOnLineTimeCount/@CellOnlineTime)*@CellOnlinePresent
			END
		END		
	END
	
	-- 封顶判断
	IF @MaxDatePresent>0
	BEGIN
		DECLARE @UserDatePresent INT
		SELECT @UserDatePresent=PresentScore FROM StreamPlayPresent WHERE DateID=@DateID AND UserID=@dwUserID
		IF @UserDatePresent IS NULL
		BEGIN
			SET @UserDatePresent=0
		END
		IF @UserDatePresent+@PresentScore>@MaxDatePresent
		BEGIN
			SET @PresentScore=@MaxDatePresent-@UserDatePresent
			IF @PresentScore<0
			BEGIN
				SET @PresentScore=0
			END
		END
	END
	IF @MaxPresent>0
	BEGIN
		DECLARE @UserPresent INT
		SELECT @UserPresent=SUM(PresentScore) FROM StreamPlayPresent WHERE UserID=@dwUserID
		IF @UserPresent IS NULL
		BEGIN
			SET @UserPresent=0
		END
		IF @UserPresent+@PresentScore>@MaxPresent 
		BEGIN
			SET @PresentScore=@MaxPresent-@UserPresent
			IF @PresentScore<0
			BEGIN
				SET @PresentScore=0
			END
		END
	END	

	-- 赠送对象判断
	DECLARE @MemberOrder TINYINT
    SELECT @MemberOrder=MemberOrder FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo WHERE UserID=@dwUserID
	IF CHARINDEX(LTRIM(STR(@MemberOrder)),@PresentMember)=0
	BEGIN
		SET @PresentScore=0
	END 

	-- 机器人不泡分
	IF @strClientIP=N'0.0.0.0'
	BEGIN
		SET @PresentScore=0
	END
	
	-- 赠送统计
	IF @PresentScore>0
	BEGIN		
		UPDATE StreamPlayPresent SET PresentCount=PresentCount+1,PresentScore=PresentScore+@PresentScore,
			PlayTimeCount=PlayTimeCount+@dwRecordPlayTimeCount,OnLineTimeCount=OnLineTimeCount+@dwOnLineTimeCount,
			LastDate=GETDATE()
		WHERE DateID=@DateID AND UserID=@dwUserID
		IF @@ROWCOUNT=0
		BEGIN
			INSERT StreamPlayPresent (DateID,UserID,PresentCount,PresentScore,PlayTimeCount,OnLineTimeCount)
			VALUES (@DateID,@dwUserID,1,@PresentScore,@dwRecordPlayTimeCount,@dwOnLineTimeCount)
		END
	END
	
	------------------------------------ 泡分结束 --------------------------------------------
	-- 房间参数
	UPDATE GameScoreAttribute SET  
	IntegralCount=IntegralCount+@lVariationIntegralCount,
	WinCount=WinCount+@lVariationWinCount, 
	LostCount=LostCount+@lVariationLostCount, 
	DrawCount=DrawCount+@lVariationDrawCount,
	FleeCount=FleeCount+@lVariationFleeCount 
	WHERE UserID=@dwUserID And ServerID=@wServerID And KindID = @wKindID 
	IF @@ROWCOUNT=0
	BEGIN
		INSERT INTO GameScoreAttribute (UserID,KindID,ServerID,IntegralCount,WinCount,LostCount,DrawCount,FleeCount) 
		VALUES (@dwUserID,@wKindID,@wServerID,@lVariationIntegralCount,@lVariationWinCount,@lVariationLostCount,@lVariationDrawCount,@lVariationFleeCount)
	END
	
	-- 开始事务
	SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
	BEGIN TRAN

	-- 用户积分
	UPDATE GameScoreInfo SET Score=Score+@lVariationScore+@PresentScore, InsureScore=InsureScore+@lVariationInsure, Revenue=Revenue+@lVariationRevenue,
		WinCount=WinCount+@lVariationWinCount, LostCount=LostCount+@lVariationLostCount, DrawCount=DrawCount+@lVariationDrawCount,
		FleeCount=FleeCount+@lVariationFleeCount, PlayTimeCount=PlayTimeCount+@dwVariationPlayTimeCount, OnLineTimeCount=OnLineTimeCount+@dwOnLineTimeCount
	WHERE UserID=@dwUserID

	-- 存在判断
	IF NOT EXISTS(SELECT * FROM StreamScoreInfo WHERE DateID=@DateID AND UserID=@dwUserID) 
	BEGIN
		-- 插入记录
		INSERT INTO StreamScoreInfo(DateID, UserID, WinCount, LostCount, Revenue, PlayTimeCount, OnlineTimeCount, FirstCollectDate, LastCollectDate)
		VALUES(@DateID, @dwUserID, @lVariationWinCount, @lVariationLostCount, @lVariationRevenue, @dwVariationPlayTimeCount, @dwOnLineTimeCount, GetDate(), GetDate())		
	END ELSE
	BEGIN
		-- 更新记录
		UPDATE StreamScoreInfo SET WinCount=WinCount+@lVariationWinCount, LostCount=LostCount+@lVariationLostCount, Revenue=Revenue+@lVariationRevenue,
			   PlayTimeCount=PlayTimeCount+@dwVariationPlayTimeCount, OnLineTimeCount=OnLineTimeCount+@dwOnLineTimeCount, LastCollectDate=GetDate()
		WHERE DateID=@DateID AND UserID=@dwUserID		
	END

	-- 锁定解除
	IF @dwLeaveReason<>0x03
	BEGIN
		DELETE GameScoreLocker WHERE UserID=@dwUserID AND ServerID=@wServerID
	END

	-- 机器人不记录税收
	IF @strClientIP=N'0.0.0.0'
	BEGIN
		SET @lRecordRevenue=0
	END

	-- 离开记录
	UPDATE RecordUserInout SET LeaveTime=GetDate(), LeaveReason=@dwLeaveReason, LeaveMachine=@strMachineSerial,LeaveClientIP=@strClientIP,
		Score=@lRecordScore, Grade=@lRecordGrade, Insure=@lRecordInsure, Revenue=@lRecordRevenue, WinCount=@lRecordWinCount, LostCount=@lRecordLostCount,
		DrawCount=@lRecordDrawCount, FleeCount=@lRecordFleeCount, UserMedal=@lRecordUserMedal, Experience=@lRecordExperience, LoveLiness=@lRecordLoveLiness,
		PlayTimeCount=@dwRecordPlayTimeCount, OnLineTimeCount=@dwOnLineTimeCount
	WHERE ID=@dwInoutIndex AND UserID=@dwUserID

	-- 结束事务
	COMMIT TRAN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED

	-- 全局信息
	UPDATE RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo SET Experience=Experience+@lVariationExperience, LoveLiness=LoveLiness+@lVariationLoveLiness,
		UserMedal=UserMedal+@lVariationUserMedal,PlayTimeCount=PlayTimeCount+@dwRecordPlayTimeCount,OnLineTimeCount=OnLineTimeCount+@dwOnLineTimeCount
	WHERE UserID=@dwUserID

END

RETURN 0

GO

----------------------------------------------------------------------------------------------------
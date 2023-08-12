
----------------------------------------------------------------------------------------------------

USE RYGameScoreDB
GO


----写私人房配置信息
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_WritePersonalGameScore]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_WritePersonalGameScore]
GO



SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO


----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
-- 游戏写分
CREATE PROC GSP_GR_WritePersonalGameScore

	-- 系统信息
	@dwUserID INT,								-- 用户 I D
	@szRoomID NVARCHAR(6),						-- 房间ID
	@dwDBQuestID INT,							-- 请求标识
	@dwInoutIndex INT,							-- 进出索引

	-- 变更成绩
	@lVariationScore BIGINT,					-- 用户分数
	@lVariationGrade BIGINT,					-- 用户成绩
	@lVariationInsure BIGINT,					-- 用户银行
	@lVariationRevenue BIGINT,					-- 游戏税收
	@lVariationWinCount INT,					-- 胜利盘数
	@lVariationLostCount INT,					-- 失败盘数
	@lVariationDrawCount INT,					-- 和局盘数
	@lVariationFleeCount INT,					-- 断线数目
	@lVariationUserMedal INT,					-- 用户奖牌
	@lVariationExperience INT,					-- 用户经验
	@lVariationLoveLiness INT,					-- 用户魅力
	@dwVariationPlayTimeCount INT,				-- 游戏时间

	-- 附加信息
	@cbTaskForward TINYINT,						-- 任务跟进

	-- 属性信息
	@wKindID INT,								-- 游戏 I D
	@wServerID INT,								-- 房间 I D
	@strClientIP NVARCHAR(15),					-- 连接地址
	@dwRoomHostID INT,							-- 房主 ID
	@dwPersonalTax INT							-- 私人房税收
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN
	
	-- 如果当前房间玩家不存在
	DECLARE @dwExistUserID INT
	SELECT @dwExistUserID = UserID FROM RYPlatformDBLink.RYPlatformDB.dbo.PersonalRoomScoreInfo WHERE RoomID = @szRoomID AND UserID = @dwUserID

	IF @dwExistUserID IS NULL
	BEGIN
		INSERT INTO RYPlatformDB..PersonalRoomScoreInfo(UserID, RoomID, Score, WinCount, LostCount, DrawCount, FleeCount, WriteTime) 
												VALUES (@dwUserID, @szRoomID, @lVariationScore,@lVariationWinCount, @lVariationLostCount, @lVariationDrawCount, @lVariationFleeCount, GETDATE()) 
	END
	ELSE
	BEGIN
		-- 用户积分
		UPDATE RYPlatformDBLink.RYPlatformDB.dbo.PersonalRoomScoreInfo SET Score=Score+@lVariationScore, WinCount=WinCount+@lVariationWinCount, LostCount=LostCount+@lVariationLostCount,
			DrawCount=DrawCount+@lVariationDrawCount, FleeCount=FleeCount+@lVariationFleeCount, WriteTime=GETDATE() 
		WHERE UserID=@dwUserID
	END

	--DECLARE @TaxCount INT
	--DECLARE @InsureScore BIGINT
	--DECLARE @SourceScore BIGINT
	--SELECT  @SourceScore = Score FROM GameScoreInfo WHERE UserID = @dwRoomHostID
	--SET @TaxCount = 0
	--IF @lVariationRevenue = 0
	--BEGIN
	--	IF @lVariationScore > 0
	--	BEGIN
	--		SET @TaxCount = @lVariationScore * @dwPersonalTax/1000
	--		UPDATE GameScoreInfo SET Score = Score + @TaxCount  WHERE UserID = @dwRoomHostID
	--	END
	--END
	--ELSE
	--BEGIN
	--	SET @TaxCount = @lVariationRevenue
	--	UPDATE GameScoreInfo SET Score = Score + @lVariationRevenue WHERE UserID = @dwRoomHostID
	--END

	-- 全局信息
	IF @lVariationExperience>0 OR @lVariationLoveLiness<>0 OR @lVariationUserMedal>0
	BEGIN
		UPDATE RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo SET Experience=Experience+@lVariationExperience, LoveLiness=LoveLiness+@lVariationLoveLiness,
			UserMedal=UserMedal+@lVariationUserMedal
		WHERE UserID=@dwUserID
	END

	-- 任务跟进
	IF @cbTaskForward=1
	BEGIN
		exec RYPlatformDBLink.RYPlatformDB.dbo.GSP_GR_TaskForward @dwUserID,@wKindID,0,@lVariationWinCount,@lVariationLostCount,@lVariationDrawCount	
	END

END

RETURN 0

GO








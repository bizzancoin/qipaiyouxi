USE RYTreasureDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_UserMatchFee]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_UserMatchFee]

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_UserMatchQuit]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_UserMatchQuit]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- 扣除费用
CREATE PROC GSP_GR_UserMatchFee
	@dwUserID INT,								-- 用户 I D
	@dwMatchFee INT,							-- 报名费用
	@wKindID INT,								-- 游戏 I D
	@wServerID INT,								-- 房间 I D
	@strClientIP NVARCHAR(15),					-- 连接地址
	@dwMatchID	INT,							-- 比赛 I D
	@dwMatchNO	INT,							-- 比赛场次
	@strMachineID NVARCHAR(32)	,				-- 机器标识
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 执行逻辑
BEGIN	
	DECLARE @UserRight INT 
	DECLARE @ReturnValue INT
	SET @ReturnValue=0
	SELECT @UserRight=UserRight FROM RYAccountsDB..AccountsInfo WHERE UserID=@dwUserID 
	SELECT @UserRight=@UserRight|UserRight FROM GameScoreInfo WHERE UserID=@dwUserID

	IF EXISTS(SELECT * FROM RYTreasureDB..GameScoreInfo WHERE UserID=@dwUserID)
	BEGIN
		DECLARE @Score BIGINT
		SELECT @Score=Score FROM RYTreasureDB..GameScoreInfo WHERE UserID=@dwUserID
		IF @Score < @dwMatchFee
		BEGIN
			SET @ReturnValue=1
		END
		ELSE
		BEGIN
			UPDATE RYTreasureDB..GameScoreInfo SET Score=Score-@dwMatchFee WHERE UserID=@dwUserID
			INSERT StreamMatchFeeInfo (UserID,ServerID,MatchID,MatchNo,Fee,CollectDate) 
								VALUES(@dwUserID,@wServerID,@dwMatchID,@dwMatchNO,@dwMatchFee,GETDATE())
			SET @ReturnValue=0
		END
	END	
	ELSE
		SET @ReturnValue=2

END

RETURN @ReturnValue
GO

----------------------------------------------------------------------------------------------------

-- 退还费用
CREATE PROC GSP_GR_UserMatchQuit
	@dwUserID INT,								-- 用户 I D
	@dwMatchFee INT,							-- 报名费用
	@wKindID INT,								-- 游戏 I D
	@wServerID INT,								-- 房间 I D
	@strClientIP NVARCHAR(15),					-- 连接地址
	@dwMatchID	INT,							-- 比赛 I D
	@dwMatchNO	INT,							-- 比赛场次
	@strMachineID NVARCHAR(32)	,				-- 机器标识
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 执行逻辑
BEGIN
		
	DECLARE @UserRight INT 
	DECLARE @ReturnValue INT
	SET @ReturnValue=0
	SELECT @UserRight=UserRight FROM RYAccountsDB..AccountsInfo WHERE UserID=@dwUserID 
	SELECT @UserRight=@UserRight|UserRight FROM GameScoreInfo WHERE UserID=@dwUserID

	IF  EXISTS(SELECT * FROM RYTreasureDB..GameScoreInfo WHERE UserID=@dwUserID)
	BEGIN
		DECLARE @Score BIGINT
		SELECT @Score=Score FROM RYTreasureDB..GameScoreInfo WHERE UserID=@dwUserID
		BEGIN
			IF EXISTS(SELECT * FROM StreamMatchFeeInfo 
					WHERE UserID=@dwUserID AND ServerID=@wServerID AND MatchID=@dwMatchID AND MatchNO=@dwMatchNO)
			BEGIN
				UPDATE RYTreasureDB..GameScoreInfo SET Score=Score+@dwMatchFee WHERE UserID=@dwUserID
				DELETE StreamMatchFeeInfo WHERE UserID=@dwUserID AND ServerID=@wServerID AND MatchID=@dwMatchID
			END					
			SET @ReturnValue=0
		END
	END	
	ELSE
		SET @ReturnValue=2

END

RETURN @ReturnValue
GO
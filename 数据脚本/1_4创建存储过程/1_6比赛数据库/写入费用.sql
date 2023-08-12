USE RYGameMatchDB
GO


IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_MatchQueryQualify]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_MatchQueryQualify]

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_MatchBuySafeCard]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_MatchBuySafeCard]

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_UserMatchFee]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_UserMatchFee]

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_UserMatchQuit]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_UserMatchQuit]

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_MatchQueryReviveInfo]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_MatchQueryReviveInfo]

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_MatchUserRevive]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_MatchUserRevive]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- 查询资格
CREATE PROC GSP_GR_MatchQueryQualify
	@dwUserID INT,								-- 用户 I D
	@dwMatchID	INT,							-- 比赛 I D
	@lMatchNo	BIGINT							-- 比赛场次
WITH ENCRYPTION AS

-- 设置属性
SET NOCOUNT ON

-- 执行逻辑
BEGIN	
	
	-- 查询玩家
	IF NOT EXISTS(SELECT * FROM MatchPromoteInfo(NOLOCK) WHERE UserID=@dwUserID AND MatchID=@dwMatchID)
	BEGIN
		RETURN 1	
	END	
	
END

RETURN 0
GO

----------------------------------------------------------------------------------------------------

-- 购买保险
CREATE PROC GSP_GR_MatchBuySafeCard
	@dwUserID INT,								-- 用户 I D
	@dwMatchID	INT,							-- 比赛 I D
	@lMatchNo	BIGINT,							-- 比赛场次
	@lSafeCardFee INT,							-- 保险费用		
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 设置属性
SET NOCOUNT ON

-- 执行逻辑
BEGIN	
	
	-- 查询玩家
	DECLARE @HoldSafeCard TINYINT
	SELECT @HoldSafeCard=HoldSafeCard FROM MatchReviveInfo(NOLOCK) WHERE UserID=@dwUserID AND MatchID=@dwMatchID AND MatchNo=@lMatchNo
	
	-- 调整变量
	IF @HoldSafeCard IS NULL 
	BEGIN
		SET @HoldSafeCard=0 
		
		-- 插入记录
		INSERT INTO MatchReviveInfo(UserID, MatchID, MatchNo, HoldSafeCard, ReviveFee, ReviveTimes, CollectDate) 
		VALUES (@dwUserID, @dwMatchID, @lMatchNo, @HoldSafeCard, 0, 0, GETDATE())
	END
	
	-- 已经购买
	IF @HoldSafeCard=1
	BEGIN
		SET @strErrorDescribe=N'本次比赛您已购买保险卡，不需要重复购买！'
		RETURN 1
	END	
	
	-- 查询金币
	DECLARE @Score BIGINT
	SELECT @Score=Score FROM RYTreasureDB..GameScoreInfo WHERE UserID=@dwUserID
	
	-- 判断余额
	IF @Score<@lSafeCardFee
	BEGIN
		SET @strErrorDescribe=N'抱歉，您身上金币余额不足，购买失败！'
		RETURN 2	
	END
	
	-- 扣除金币
	UPDATE RYTreasureDB..GameScoreInfo SET Score=Score-@lSafeCardFee WHERE UserID=@dwUserID
	
	-- 更新状态
	UPDATE MatchReviveInfo SET HoldSafeCard=1 WHERE UserID=@dwUserID AND MatchID=@dwMatchID AND MatchNo=@lMatchNo
	
	-- 查询金币
	DECLARE @CurrScore INT
	SELECT @CurrScore=Score FROM RYTreasureDB..GameScoreInfo WHERE UserID=@dwUserID
	
	-- 抛出数据
	SELECT @CurrScore AS Score
END

RETURN 0
GO


----------------------------------------------------------------------------------------------------

-- 玩家复活
CREATE PROC GSP_GR_MatchUserRevive
	@dwUserID INT,								-- 用户 I D
	@dwMatchID	INT,							-- 比赛 I D	
	@lMatchNo	BIGINT,							-- 比赛场次
	@wServerID	INT,							-- 房间 I D
	@InitScore  BIGINT,							-- 初始积分	
	@CullScore  BIGINT,							-- 淘汰积分	
	@lReviveFee INT,							-- 复活费用			
	@cbReviveTimes TINYINT,						-- 复活次数
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 设置属性
SET NOCOUNT ON

-- 执行逻辑
BEGIN	
	
	-- 查询分数
	DECLARE @MatchScore BIGINT
	SELECT @MatchScore=Score FROM MatchScoreInfo 
	WHERE UserID=@dwUserID AND ServerID=@wServerID AND MatchID=@dwMatchID AND MatchNo=@lMatchNo		
	
	-- 判断分数
	IF @MatchScore > @CullScore
	BEGIN
		SET @strErrorDescribe=N'您的分数未达到淘汰分数线，不需要复活！'	
		RETURN 1			
	END
	
	-- 查询玩家
	DECLARE @HoldSafeCard TINYINT
	DECLARE @UseSafeCard TINYINT
	DECLARE @ReviveTimes TINYINT
	SELECT @HoldSafeCard=HoldSafeCard, @UseSafeCard=UseSafeCard, @ReviveTimes=ReviveTimes FROM MatchReviveInfo(NOLOCK) 
	WHERE UserID=@dwUserID AND MatchID=@dwMatchID AND MatchNo=@lMatchNo
	
	-- 调整变量
	IF @HoldSafeCard IS NULL 
	BEGIN
		-- 设置变量				
		SET @ReviveTimes=0
		SET @UseSafeCard=0		
		SET @HoldSafeCard=0
		
		-- 插入记录
		INSERT INTO MatchReviveInfo(UserID, MatchID, MatchNo, HoldSafeCard, UseSafeCard, ReviveFee, ReviveTimes, CollectDate) 
		VALUES (@dwUserID, @dwMatchID, @lMatchNo, 0, 0, 0, 0, GETDATE())
	END
	
	-- 拥有保险卡且未使用
	IF @HoldSafeCard=1 AND @UseSafeCard=0
	BEGIN
		-- 更新状态
		UPDATE MatchReviveInfo SET UseSafeCard=1 WHERE UserID=@dwUserID AND MatchID=@dwMatchID AND MatchNo=@lMatchNo					
	END ELSE
	BEGIN
		-- 判断次数
		IF @ReviveTimes>=@cbReviveTimes
		BEGIN
			SET @strErrorDescribe=N'抱歉，本场比赛最多允许复活 ' +CONVERT(nvarchar(20),@cbReviveTimes)+N' 次，复活失败！'	
			RETURN 2					 
		END 
		
		-- 查询金币
		DECLARE @Score BIGINT
		SELECT @Score=Score FROM RYTreasureDB..GameScoreInfo WHERE UserID=@dwUserID
		
		-- 判断金币
		IF @Score<@lReviveFee
		BEGIN
			SET @strErrorDescribe=N'抱歉，您身上金币余额不足，复活失败！'
			RETURN 5
		END
	
		-- 扣除金币
		UPDATE RYTreasureDB..GameScoreInfo SET Score=Score-@lReviveFee WHERE UserID=@dwUserID
		
		-- 更新状态
		UPDATE MatchReviveInfo SET ReviveFee=ReviveFee+@lReviveFee,ReviveTimes=ReviveTimes+1 
		WHERE UserID=@dwUserID AND MatchID=@dwMatchID AND MatchNo=@lMatchNo		
	END
	
	-- 更新分数
	UPDATE MatchScoreInfo SET Score=@InitScore,WinCount=0,LostCount=0,DrawCount=0,FleeCount=0,PlayTimeCount=0,OnlineTime=0,MatchRight=0x10000000,SignupTime=GetDate()
	WHERE UserID=@dwUserID AND ServerID=@wServerID AND MatchID=@dwMatchID AND MatchNo=@lMatchNo	
	
	-- 查询金币
	DECLARE @CurrScore INT
	SELECT @CurrScore=Score FROM RYTreasureDB..GameScoreInfo WHERE UserID=@dwUserID
	
	-- 抛出数据
	SELECT @CurrScore AS Score
END

RETURN 0
GO


----------------------------------------------------------------------------------------------------

-- 查询复活
CREATE PROC GSP_GR_MatchQueryReviveInfo
	@dwUserID INT,								-- 用户 I D
	@dwMatchID	INT,							-- 比赛 I D
	@lMatchNo	BIGINT							-- 比赛场次	
WITH ENCRYPTION AS

-- 设置属性
SET NOCOUNT ON

-- 执行逻辑
BEGIN	
	
	-- 查询玩家
	DECLARE @UseSafeCard TINYINT
	DECLARE @HoldSafeCard TINYINT	
	DECLARE @ReviveTimes TINYINT
	SELECT @HoldSafeCard=HoldSafeCard, @UseSafeCard=UseSafeCard, @ReviveTimes=ReviveTimes FROM MatchReviveInfo(NOLOCK) 
	WHERE UserID=@dwUserID AND MatchID=@dwMatchID AND MatchNo=@lMatchNo
	
	-- 调整变量
	IF @HoldSafeCard IS NULL 
	BEGIN
		-- 设置变量		
		SET @ReviveTimes=0
		SET @UseSafeCard=0
		SET @HoldSafeCard=0
	END
	
	-- 变量定义
	DECLARE @SafeCardRevive TINYINT
	SET @SafeCardRevive=1
	
	-- 调整变量
	IF @HoldSafeCard=0 SET @SafeCardRevive=0
	IF @HoldSafeCard=1 AND @UseSafeCard=1 SET @SafeCardRevive=0
	
	-- 抛出数据
	SELECT @SafeCardRevive AS SafeCardRevive, @ReviveTimes AS ReviveTimes
END

RETURN 0
GO

----------------------------------------------------------------------------------------------------

-- 扣除费用
CREATE PROC GSP_GR_UserMatchFee
	@dwUserID INT,								-- 用户 I D	
	@InitScore BIGINT,							-- 初始积分
	@cbSignupMode TINYINT,						-- 报名方式	
	@wMaxSignupUser SMALLINT,					-- 最大人数
	@wKindID INT,								-- 游戏 I D
	@wServerID INT,								-- 房间 I D
	@strClientIP NVARCHAR(15),					-- 连接地址
	@dwMatchID	INT,							-- 比赛 I D
	@lMatchNo	BIGINT,							-- 比赛场次
	@strMachineID NVARCHAR(32),					-- 机器标识
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 设置属性
SET NOCOUNT ON

-- 执行逻辑
BEGIN	
	-- 比赛信息
	DECLARE @FeeType TINYINT
	DECLARE @SignupFee INT
	DECLARE @Experience INT	
	DECLARE @SignupMode TINYINT	
	DECLARE @MatchType TINYINT
	DECLARE @MemberOrder TINYINT
	DECLARE @FromMatchID INT		
	DECLARE @JoinCondition TINYINT
	
	-- 查询比赛	
	SELECT @FeeType=FeeType, @SignupFee=SignupFee, @MatchType=MatchType, @Experience=Experience, @JoinCondition=JoinCondition, 
	@SignupMode=SignupMode, @FromMatchID=FromMatchID, @MemberOrder=MemberOrder FROM MatchPublic(NOLOCK) WHERE MatchID=@dwMatchID

	-- 存在判断
	IF @MatchType IS NULL
	BEGIN
		SET @strErrorDescribe = N'抱歉,您报名的比赛不存在！'
		return 1		
	END
	
	-- 查询用户
	DECLARE @lExperience INT
	DECLARE @cbMemberOrder TINYINT
	SELECT @lExperience=Experience, @cbMemberOrder=MemberOrder FROM RYAccountsDB..AccountsInfo WHERE UserID=@dwUserID
	
	-- 存在判断
	IF @lExperience IS NULL
	BEGIN
		SET @strErrorDescribe = N'抱歉,您的用户信息不存在，请联系客服中心工作人员了解情况！'
		return 1	 
	END	
	
	-- 会员等级
	IF (@JoinCondition&0x01)<>0 AND @cbMemberOrder<@MemberOrder
	BEGIN
		SET @strErrorDescribe = N'抱歉，您的会员等级达不到报名条件，报名失败！'
		return 2				
	END
	
	-- 用户经验
	IF (@JoinCondition&0x02)<>0 AND @lExperience<@Experience
	BEGIN
		SET @strErrorDescribe = N'抱歉，您的经验值达不到报名条件，报名失败！'
		return 2				
	END
	
	-- 报名人数
	DECLARE @MaxSignupUser SMALLINT
	SELECT @MaxSignupUser=COUNT(*) FROM MatchScoreInfo WHERE MatchID=@dwMatchID AND MatchNo=@lMatchNo AND ServerID=@wServerID 
	
	-- 判断人数
	IF @wMaxSignupUser>0 AND @MaxSignupUser>=@wMaxSignupUser
	BEGIN
		SET @strErrorDescribe = N'抱歉，本场比赛已达到最大报名人数，报名失败！'
		return 3	
	END
	
	-- 用户信息
	DECLARE @IsAndroidUser TINYINT
	SET @IsAndroidUser=0
	
	-- 机器判断
	IF @strClientIP=N'0.0.0.0' SET @IsAndroidUser=1

	-- 扣除报名费
	IF (@SignupMode&@cbSignupMode)<>0 AND @cbSignupMode=1		
	BEGIN				
		-- 非机器玩家	
		IF @IsAndroidUser = 0	
		BEGIN	
			-- 扣除费用
			IF @SignupFee > 0
			BEGIN				
				-- 扣除金币
				IF @FeeType = 0
				BEGIN
					-- 查询金币
					DECLARE @Score BIGINT
					SELECT @Score=Score FROM RYTreasureDB..GameScoreInfo WHERE UserID=@dwUserID
					
					-- 调整金币
					IF @Score IS NULL SET @Score=0

					-- 金币不足
					IF @Score < @SignupFee		
					BEGIN
						SET @strErrorDescribe = N'抱歉,您身上的游戏币不足,系统无法为您成功报名！'
						return 4				
					END

					-- 更新金币
					UPDATE RYTreasureDB..GameScoreInfo SET Score=@Score-@SignupFee WHERE UserID=@dwUserID					
				END
				
				-- 扣除元宝
				IF @FeeType = 1
				BEGIN
					-- 查询奖牌
					DECLARE @UserIngot BIGINT
					SELECT @UserIngot=UserMedal FROM RYAccountsDB..AccountsInfo WHERE UserID=@dwUserID
					
					-- 调整奖牌
					IF @UserIngot IS NULL SET @UserIngot=0

					-- 金币不足
					IF @UserIngot < @SignupFee		
					BEGIN
						SET @strErrorDescribe = N'抱歉,您身上的元宝不足,系统无法为您报名！'
						return 4				
					END

					-- 更新奖牌
					UPDATE RYAccountsDB..AccountsInfo SET UserMedal=UserMedal-@SignupFee WHERE UserID=@dwUserID					
				END							
			END	

			-- 插入记录	
			INSERT StreamMatchFeeInfo (UserID,ServerID,MatchID,MatchNo,MatchType,SignupMode,MatchFee,CollectDate) 
			VALUES(@dwUserID,@wServerID,@dwMatchID,@lMatchNo,1,@cbSignupMode,@SignupFee,GETDATE())
		END		
		
	END
	
	-- 比赛玩家
	IF (@SignupMode&@cbSignupMode)<>0 AND @cbSignupMode=2
	BEGIN
		-- 比赛晋级玩家
		IF @MatchType=0 AND @FromMatchID<>0
		BEGIN
			-- 查询比赛
			DECLARE @szMatchName NVARCHAR(64)
			SELECT @szMatchName=MatchName FROM MatchPublic WHERE MatchID=@FromMatchID

			-- 校验报名条件
			IF @szMatchName IS NULL  RETURN 4
			
			-- 查询资格					
			IF NOT Exists(SELECT * FROM MatchPromoteInfo WHERE UserID=@dwUserID AND MatchID=@FromMatchID AND PromoteMatchID=@dwMatchID)
			BEGIN
			
				IF @SignupMode=@cbSignupMode
				BEGIN
					SET @strErrorDescribe = N'抱歉,本场比赛仅限[ '+@szMatchName+N' ]中晋级的玩家报名参加，您不具备报名的条件！'
				END									
				return 4				
			END					
			
			-- 非机器玩家	
			IF @IsAndroidUser=0		
			BEGIN			
				-- 插入记录	
				INSERT StreamMatchFeeInfo (UserID,ServerID,MatchID,MatchNo,MatchType,SignupMode,MatchFee,CollectDate) 
				VALUES(@dwUserID,@wServerID,@dwMatchID,@lMatchNo,2,@cbSignupMode,0,GETDATE())
			END
														   												
		END ELSE
		BEGIN
			SET @strErrorDescribe = N'抱歉,本场比赛不支持比赛玩家作为报名方式！'			
			return 4						
		END		
	END		
	
	-- 更新分数
	UPDATE MatchScoreInfo SET Score=@InitScore,WinCount=0,LostCount=0,DrawCount=0,FleeCount=0,PlayTimeCount=0,OnlineTime=0,MatchRight=0x10000000,SignupTime=GetDate()
	WHERE UserID=@dwUserID AND ServerID=@wServerID AND MatchID=@dwMatchID AND MatchNo=@lMatchNo				
	
	-- 插入分数
	IF @@ROWCOUNT=0
	BEGIN
		INSERT INTO MatchScoreInfo (UserID,ServerID,MatchID,MatchNo,Score,MatchRight) 
		VALUES (@dwUserID,@wServerID,@dwMatchID,@lMatchNo,@InitScore,0x10000000)				
	END			

	-- 查询金币
	DECLARE @CurrScore BIGINT
	SELECT @CurrScore=Score FROM RYTreasureDB..GameScoreInfo WHERE UserID=@dwUserID	
	
	-- 查询奖牌
	DECLARE @CurrUserIngot BIGINT
	SELECT @CurrUserIngot=UserMedal FROM RYAccountsDB..AccountsInfo WHERE UserID=@dwUserID
	
	-- 调整数据
	IF @CurrScore IS NULL SET @CurrScore=0
	IF @CurrUserIngot IS NULL SET @CurrUserIngot=0

	-- 抛出数据
	SELECT @cbSignupMode AS SignupMode,@CurrScore AS Score, @CurrUserIngot AS UserIngot
END

RETURN 0
GO

----------------------------------------------------------------------------------------------------

-- 退还费用
CREATE PROC GSP_GR_UserMatchQuit
	@dwUserID INT,								-- 用户 I D
	@wKindID INT,								-- 游戏 I D
	@wServerID INT,								-- 房间 I D
	@strClientIP NVARCHAR(15),					-- 连接地址
	@dwMatchID	INT,							-- 比赛 I D
	@lMatchNo	BIGINT,							-- 比赛场次
	@strMachineID NVARCHAR(32)	,				-- 机器标识
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 设置属性
SET NOCOUNT ON

-- 执行逻辑
BEGIN
	
	-- 机器信息
	IF Exists(SELECT * FROM RYAccountsDB..AccountsInfo WHERE UserID=@dwUserID AND IsAndroid = 1)
	BEGIN
		-- 删除比赛分
		DELETE MatchScoreInfo WHERE UserID=@dwUserID AND ServerID=@wServerID AND MatchID=@dwMatchID AND MatchNo=@lMatchNo
	END
	
	-- 比赛信息
	DECLARe @FeeType TINYINT
	DECLARE @SignupFee BIGINT		
	SELECT @FeeType=FeeType, @SignupFee=SignupFee FROM MatchPublic WHERE MatchID=@dwMatchID
	
	-- 查询模式
	DECLARE @SignupMode TINYINT	
	SELECT @SignupMode=SignupMode FROM StreamMatchFeeInfo WHERE UserID=@dwUserID AND ServerID=@wServerID AND MatchID=@dwMatchID AND MatchNo=@lMatchNo

	-- 存在判断	
	IF @SignupMode IS NULL
	BEGIN
		SET @strErrorDescribe = N'抱歉,您报名的比赛不存在！'
		return 1		
	END

	-- 存在判断
	IF NOT Exists(SELECT * FROM RYAccountsDB..AccountsInfo WHERE UserID=@dwUserID)
	BEGIN
		SET @strErrorDescribe = N'抱歉,您的用户信息不存在！'
		return 2		
	END

	-- 机器标识
	DECLARE @IsAndroidUser TINYINT	

	-- 机器判断
	SET @IsAndroidUser=0
	IF @strClientIP=N'0.0.0.0' SET @IsAndroidUser=1	

	-- 返还费用
	IF @IsAndroidUser=0
	BEGIN		
		-- 扣费模式 非免费
		IF @SignupMode=1 AND @SignupFee>0
		BEGIN		
			-- 金币支付
			IF @FeeType = 0
			BEGIN
				-- 查询金币
				DECLARE @Score BIGINT
				SELECT @Score=Score FROM RYTreasureDB..GameScoreInfo WHERE UserID=@dwUserID
				IF @Score IS NULL
				BEGIN
					SET @strErrorDescribe = N'没有找到您的金币信息,请您与我们的客服人员联系！'
					return 3						
				END

				-- 更新金币
				UPDATE RYTreasureDB..GameScoreInfo SET Score=@Score+@SignupFee WHERE UserID=@dwUserID				
			END
			
			-- 奖牌支付
			IF @FeeType = 1
			BEGIN
				-- 查询元宝
				DECLARE @UserIngot BIGINT
				SELECT @UserIngot=UserMedal FROM RYAccountsDB..AccountsInfo WHERE UserID=@dwUserID
				
				-- 调整元宝
				IF @UserIngot IS NULL
				BEGIN
					SET @strErrorDescribe = N'没有找到您的元宝信息,请您与我们的客服人员联系！'
					return 3				
				END

				-- 更新奖牌
				UPDATE RYAccountsDB..AccountsInfo SET UserMedal=UserMedal+@SignupFee WHERE UserID=@dwUserID		
			END	
		END					
	END

	-- 删除记录
	IF @IsAndroidUser=0 
	BEGIN
		DELETE StreamMatchFeeInfo WHERE UserID=@dwUserID AND ServerID=@wServerID AND MatchID=@dwMatchID AND MatchNo=@lMatchNo
	END

	-- 删除比赛分
	DELETE MatchScoreInfo WHERE UserID=@dwUserID AND ServerID=@wServerID AND MatchID=@dwMatchID AND MatchNo=@lMatchNo

	-- 查询金币
	DECLARE @CurrScore BIGINT
	SELECT @CurrScore=Score FROM RYTreasureDB..GameScoreInfo WHERE UserID=@dwUserID	
	
	-- 查询奖牌
	DECLARE @CurrUserIngot BIGINT
	SELECT @CurrUserIngot=UserMedal FROM RYAccountsDB..AccountsInfo WHERE UserID=@dwUserID
	
	-- 调整数据
	IF @CurrScore IS NULL SET @CurrScore=0
	IF @CurrUserIngot IS NULL SET @CurrUserIngot=0

	-- 抛出数据
	SELECT @SignupMode AS SignupMode, @CurrScore AS Score, @CurrUserIngot AS UserIngot
END

RETURN 0
GO
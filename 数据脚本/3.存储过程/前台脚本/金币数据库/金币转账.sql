----------------------------------------------------------------------
-- 版权：2011
-- 时间：2011-09-1
-- 用途：金币转账
----------------------------------------------------------------------

USE [RYTreasureDB]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].NET_PW_InsureTransfer') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].NET_PW_InsureTransfer
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--------------------------------------------------------------------------------
-- 存款
CREATE PROCEDURE NET_PW_InsureTransfer
	@dwSrcUserID		INT,						-- 源用户标识

	@dwDstUserID		INT,						-- 目标用户标识
	@strInsurePass		NVARCHAR(32),				-- 银行密码
	@dwSwapScore		BIGINT,						-- 转账金额

	@strClientIP		NVARCHAR(15),				-- 操作地址
	@strCollectNote		NVARCHAR(63),				-- 备注
	@strErrorDescribe	NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 汇款用户
DECLARE @SrcUserID			INT
DECLARE @SrcInsurePass		NCHAR(32)
DECLARE @SrcNullity			TINYINT
DECLARE @SrcStunDown		TINYINT
DECLARE @SrcMemberOverDate	DATETIME
DECLARE @SrcMemberOrder		INT

-- 收款用户
DECLARE @DstUserID			INT
DECLARE @DstNullity			TINYINT
DECLARE @DstStunDown		TINYINT
DECLARE @DstMemberOverDate	DATETIME
DECLARE @DstMemberOrder		INT

-- 汇款用户金币信息
DECLARE @SrcScore			BIGINT		-- 汇款人现金		
DECLARE @SrcInsureScore		BIGINT		-- 汇款人银行
DECLARE @SrcInsureBalance	BIGINT		-- 汇款人余额
DECLARE @AgentID			INT			-- 代理人标识	

-- 收款用户金币信息
DECLARE @DstScore			BIGINT		-- 收款人现金			
DECLARE @DstInsureScore		BIGINT		-- 收款人银行
DECLARE @DstInsureBalance	BIGINT		-- 收款人余额
DECLARE @UserRight			INT			-- 收款人权限
DECLARE @CalcUserRight		INT			-- 计算权限值

-- 税收
DECLARE @Revenue BIGINT
DECLARE @InsureRevenue BIGINT
DECLARE @MaxTax BIGINT

-- 返利配置
DECLARE @ConfigID INT
DECLARE @ReturnType TINYINT
DECLARE @ReturnPercent INT
DECLARE @ReturnDescribe NVARCHAR(32)
DECLARE @DatetimeNow DATETIME
DECLARE @TransferPower INT
DECLARE @TransferRebate INT

-- 执行逻辑
BEGIN
	DECLARE @EnjoinInsure INT
	-- 系统暂停
	SELECT @EnjoinInsure=StatusValue FROM RYAccountsDBLink.RYAccountsDB.dbo.SystemStatusInfo WHERE StatusName=N'EnjoinInsure'
	IF @EnjoinInsure IS NOT NULL AND @EnjoinInsure<>0
	BEGIN
		SELECT @strErrorDescribe=StatusString FROM RYAccountsDBLink.RYAccountsDB.dbo.SystemStatusInfo WHERE StatusName=N'EnjoinInsure'
		RETURN 1
	END
	
	-- 转账状态
	DECLARE @TransferStauts INT
	SELECT @TransferStauts=StatusValue FROM RYAccountsDBLink.RYAccountsDB.dbo.SystemStatusInfo WHERE StatusName=N'TransferStauts'
	IF @TransferStauts=1 AND @AgentID=0
	BEGIN
		SET @strErrorDescribe=N'抱歉的通知您！转账功能暂时被停用，开启时间请留言广告'
		RETURN 1
	END

	-- 判断是否自己转给自己
	IF @dwSrcUserID = @dwDstUserID
	BEGIN
		SET @strErrorDescribe=N'抱歉的通知您！同一帐号不允许进行赠送金币。'
		RETURN 1
	END
	
	--------------------------------------------------------------------------------
	/* 汇款人部分 */

	-- 查询用户	
	SELECT @SrcUserID=UserID,@SrcNullity=Nullity, @SrcStunDown=StunDown,@SrcInsurePass=InsurePass,
	@SrcMemberOrder=MemberOrder,@SrcMemberOverDate=MemberOverDate,@AgentID=AgentID 
	FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo WHERE UserID=@dwSrcUserID

	-- 验证用户
	IF @SrcUserID IS NULL
	BEGIN
		SET @strErrorDescribe=N'您的帐号不存在或者密码输入有误，请查证后再次尝试登录！'
		RETURN 101
	END

	-- 帐号封停
	IF @SrcNullity<>0
	BEGIN
		SET @strErrorDescribe=N'您的帐号暂时处于冻结状态，请联系客户服务中心了解详细情况！'
		RETURN 102
	END	

	-- 帐号关闭
	IF @SrcStunDown<>0
	BEGIN
		SET @strErrorDescribe=N'您的帐号使用了安全关闭功能，必须重新开通后才能继续使用！'
		RETURN 103
	END

	-- 银行密码
	IF @SrcInsurePass <> @strInsurePass 
	BEGIN
		SET @strErrorDescribe=N'您的保险柜密码输入有误，请查证后再次尝试！'	
		RETURN 104
	END	
	--------------------------------------------------------------------------------
	
	--------------------------------------------------------------------------------
	/* 收款人部分 */

	-- 查询用户	
	SELECT @DstUserID=UserID,@DstNullity=Nullity,@DstStunDown=StunDown,@UserRight=UserRight,@DstMemberOverDate =MemberOverDate,@DstMemberOrder=MemberOrder 
	FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo WHERE UserID=@dwDstUserID

	-- 验证用户
	IF @DstUserID IS NULL
	BEGIN
		SET @strErrorDescribe=N'抱歉！您要转账的目标帐号不存在！'
		RETURN 201
	END

	-- 帐号封停
	IF @DstNullity<>0
	BEGIN
		SET @strErrorDescribe=N'抱歉！您转账的目标帐号暂时处于冻结状态，无法进行金币赠送！'
		RETURN 202
	END	

	-- 帐号关闭
	IF @DstStunDown<>0
	BEGIN
		SET @strErrorDescribe=N'抱歉！您转账的目标帐号使用了安全关闭功能，无法进行金币赠送！'
		RETURN 203
	END

	-- 权限验证
	SET @DatetimeNow = GETDATE()
	SELECT @TransferPower = StatusValue FROM RYAccountsDBLink.RYAccountsDB.dbo.SystemStatusInfo WHERE StatusName='TransferPower'
	IF @TransferPower IS NULL OR @TransferPower = 1
	BEGIN
			IF @DstMemberOverDate IS NULL OR @DstMemberOverDate < @DatetimeNow
			BEGIN
				SET @CalcUserRight = (@UserRight & 67108864)
				IF @CalcUserRight != 67108864 
				BEGIN
					SET @strErrorDescribe=N'抱歉！您转账的目标帐号没有转账权限'
					RETURN 203
				END
			END
	END
	
	--------------------------------------------------------------------------------

	-- 房间锁定
	IF EXISTS (SELECT UserID FROM GameScoreLocker(NOLOCK) WHERE UserID=@dwSrcUserID)
	BEGIN
		SET @strErrorDescribe='您已经在金币游戏房间了，需要进行转账操作，请先退出金币游戏房间！'		
		RETURN 2
	END	
	
	-- 获取返利配置
	IF (@SrcMemberOverDate IS NULL OR @SrcMemberOverDate < @DatetimeNow) AND (@DstMemberOverDate IS NULL OR @DstMemberOverDate < @DatetimeNow)
	BEGIN
		SET @ConfigID = 1
	END
	ELSE IF (@SrcMemberOverDate IS NULL OR @SrcMemberOverDate < @DatetimeNow) AND @DstMemberOverDate >= @DatetimeNow
	BEGIN
		SET @ConfigID = 2
	END
	ELSE IF @SrcMemberOverDate >= @DatetimeNow AND (@DstMemberOverDate IS NULL OR @DstMemberOverDate < @DatetimeNow)
	BEGIN
		SET @ConfigID = 3
	END
	ELSE IF @SrcMemberOverDate >= @DatetimeNow AND @DstMemberOverDate >= @DatetimeNow
	BEGIN
		SET @ConfigID = 4
	END

	SELECT @ReturnType=ReturnType,@ReturnPercent=ReturnPercent,@ReturnDescribe=ConfigDescribe FROM TransferReturnConfig WHERE ConfigID = @ConfigID
	IF @ReturnType IS NULL
	BEGIN
		SET @ReturnType = 0
		SET @ReturnPercent = 0
		SET @ReturnDescribe = N'您尚未配置返利信息'
	END
	--------------------------------------------------------------------------------
	/* 汇款人部分 */

	-- 金币查询
	SELECT @SrcScore= Score, @SrcInsureScore=InsureScore
	FROM GameScoreInfo WHERE UserID=@dwSrcUserID
	
	-- 金币判断
	IF @SrcInsureScore IS NULL OR @SrcInsureScore<0
	BEGIN
		SET @strErrorDescribe=N'非常抱歉,您保险柜内余额不足!'
		RETURN 4
	END
	
	-- 转账条件
	DECLARE @TransferPrerequisite INT; SET @TransferPrerequisite = 0
	SELECT @TransferPrerequisite=ISNULL(StatusValue,0) FROM RYAccountsDBLink.RYAccountsDB.dbo.SystemStatusInfo WHERE StatusName=N'TransferPrerequisite'
	IF @dwSwapScore < @TransferPrerequisite
	BEGIN
		SET @strErrorDescribe=N'非常抱歉,转账金币数不能低于'+LTRIM(@TransferPrerequisite)
		RETURN 5
	END
	
	-- 银行保留
	DECLARE @TransferRetention INT	-- 至少保留
	DECLARE @SurplusScore BIGINT	-- 转后银行
	SELECT @TransferRetention=ISNULL(StatusValue,0) FROM RYAccountsDBLink.RYAccountsDB.dbo.SystemStatusInfo WHERE StatusName=N'TransferRetention'
	IF @TransferRetention<>0
	BEGIN
		SET @SurplusScore=@SrcInsureScore-@dwSwapScore
		IF @SurplusScore<@TransferRetention
		BEGIN
			SET @strErrorDescribe=N'非常抱歉,转账后您保险柜内的余额不能少于'+LTRIM(@TransferRetention)+'金币'
			RETURN 7
		END
	END
	
	-- 转账税收
	DECLARE @RevenueRate INT
	IF @SrcMemberOrder>0 AND @SrcMemberOverDate>@DatetimeNow
	BEGIN
		SELECT @RevenueRate=InsureRate FROM RYAccountsDBLink.RYAccountsDB.dbo.MemberProperty WHERE MemberOrder=@SrcMemberOrder
	END
	ELSE
	BEGIN
		SELECT @RevenueRate=StatusValue FROM RYAccountsDBLink.RYAccountsDB.dbo.SystemStatusInfo WHERE StatusName=N'RevenueRateTransfer'
	END		

	-- 税率调整
	IF @RevenueRate>300 SET @RevenueRate=300
	IF @RevenueRate IS NULL SET @RevenueRate=1	

	-- 金币判断
	IF @dwSwapScore > @SrcInsureScore
	BEGIN
		SET @strErrorDescribe=N'非常抱歉,您保险柜内余额不足!'
		RETURN 6
	END
	
	-- 税收计算
	SET @Revenue=@dwSwapScore*@RevenueRate/1000

	-- 税收封顶
	SELECT @MaxTax=StatusValue FROM RYAccountsDBLink.RYAccountsDB.dbo.SystemStatusInfo WHERE StatusName=N'TransferMaxTax'
	IF @MaxTax<>0
	BEGIN
		IF @Revenue > @MaxTax
			SET @Revenue=@MaxTax
	END

	SET @SrcInsureBalance = @SrcInsureScore - @dwSwapScore
	--------------------------------------------------------------------------------
	
	--------------------------------------------------------------------------------
	/* 收款人部分 */
	
	-- 金币查询
	SELECT @DstScore= Score, @DstInsureScore=InsureScore
	FROM GameScoreInfo WHERE UserID=@dwDstUserID

	-- 验证用户
	IF @DstScore IS NULL OR @DstInsureScore IS NULL
	BEGIN
		-- 初始用户
		SET @DstScore = 0
		SET @DstInsureScore = 0

		INSERT INTO GameScoreInfo(UserID,LastLogonIP,RegisterIP)
		VALUES(@dwDstUserID,@strClientIP,@strClientIP)
	END

	-- 余额计算
	SET @DstInsureBalance = @DstInsureScore + @dwSwapScore - @Revenue
	--------------------------------------------------------------------------------

	-- 转账记录
	INSERT INTO RecordInsure(
		SourceUserID,SourceGold,SourceBank,TargetUserID,TargetGold,TargetBank,SwapScore,Revenue,IsGamePlaza,TradeType,ClientIP,CollectNote)
	VALUES(@SrcUserID,@SrcScore,@SrcInsureScore,@DstUserID,@DstScore,@DstInsureScore,@dwSwapScore,@Revenue,1,3,@strClientIP,@strCollectNote)

	-- 返利记录
	SELECT @TransferRebate = StatusValue FROM RYAccountsDBLink.RYAccountsDB.dbo.SystemStatusInfo WHERE StatusName='TransferRebate'
	IF @TransferRebate = 0 
	BEGIN
		INSERT INTO TransferReturnDetailInfo(SourceUserID,TargetUserID,SwapScore,Revenue,ReturnType,ReturnPercent,ReturnDescribe) 
		VALUES(@SrcUserID,@DstUserID,@dwSwapScore,@Revenue,@ReturnType,@ReturnPercent,@ReturnDescribe)
	END

	-- 转账操作
	-- 收款用户
	UPDATE GameScoreInfo SET InsureScore=@DstInsureBalance
	WHERE UserID=@dwDstUserID

	-- 汇款用户	
	UPDATE GameScoreInfo SET InsureScore=@SrcInsureBalance,Revenue=Revenue+@Revenue
	WHERE UserID=@dwSrcUserID

	IF @Revenue=0
		SET @strErrorDescribe=N'成功将 '+LTRIM(@dwSwapScore)+' 转至对方账户'
	ELSE
		SET @strErrorDescribe=N'系统收取'+LTRIM(@Revenue)+'服务费，成功将 '+LTRIM(@dwSwapScore-@Revenue)+' 转至对方账户'
	
END

SET NOCOUNT OFF

RETURN 0
GO




----------------------------------------------------------------------------------------------------
-- 版权：2011
-- 时间：2012-02-23
-- 用途：房卡兑换
----------------------------------------------------------------------------------------------------

USE RYTreasureDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].NET_PW_ExchRoomCard') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].NET_PW_ExchRoomCard
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_NULLS ON
GO

----------------------------------------------------------------------------------------------------

CREATE PROCEDURE NET_PW_ExchRoomCard
	@dwUserID	INT,						-- 用户 I D
	@dwExchCount INT,						-- 兑换数量
	@strPassword NCHAR(32),					-- 银行密码
	@strClientIP NVARCHAR(15),				-- 操作地址
	@strErrorDescribe NVARCHAR(127) OUTPUT	-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 用户信息
DECLARE @UserID INT
DECLARE @Nullity BIT
DECLARE @StunDown BIT
DECLARE @InsurePass NCHAR(32)
DECLARE @UserGold BIGINT
DECLARE @UserRoomCard INT
DECLARE @RegisterIP NVARCHAR(15)

-- 兑换信息
DECLARE @Rate INT
DECLARE @Gold INT

-- 执行逻辑
BEGIN
	-- 查询用户
	SELECT @UserID=UserID, @Nullity=Nullity, @StunDown=StunDown,@InsurePass=InsurePass,@RegisterIP=RegisterIP FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo WHERE UserID=@dwUserID

	-- 查询用户
	IF @UserID IS NULL
	BEGIN
		SET @strErrorDescribe=N'您的帐号不存在或者密码输入有误，请查证后再次尝试登录！'
		RETURN 1
	END	
	
	-- 帐号禁止
	IF @Nullity<>0
	BEGIN
		SET @strErrorDescribe=N'您的帐号暂时处于冻结状态，请联系客户服务中心了解详细情况！'
		RETURN 2
	END	

	-- 帐号关闭
	IF @StunDown<>0
	BEGIN
		SET @strErrorDescribe=N'您的帐号使用了安全关闭功能，必须重新开通后才能继续使用！'
		RETURN 3
	END		

	-- 验证银行密码
	IF @InsurePass!=@strPassword
	BEGIN
		SET @strErrorDescribe=N'非常抱歉，您的银行密码输入错误！'
		RETURN 3
	END

	-- 获取兑换比例
	SELECT @Rate=StatusValue FROM RYAccountsDBLink.RYAccountsDB.dbo.SystemStatusInfo WHERE StatusName =N'AgentRoomCardExchRate'
	IF @Rate IS NULL
	BEGIN
		SET @strErrorDescribe=N'非常抱歉，房卡兑换比例暂未配置！'
		RETURN 4
	END

	-- 计算兑换游戏币
	SET @Gold = @Rate * @dwExchCount

	-- 开启事务
	BEGIN TRAN

	SELECT @UserRoomCard=RoomCard FROM UserRoomCard(ROWLOCK) WHERE UserID=@UserID
	IF @UserRoomCard IS NULL OR @UserRoomCard < @dwExchCount
	BEGIN
		SET @strErrorDescribe=N'非常抱歉,您的房卡余额不足，请先购买！'
		ROLLBACK TRAN
		RETURN 5
	END

	UPDATE UserRoomCard SET RoomCard = RoomCard - @dwExchCount WHERE UserID=@UserID
	IF @@ROWCOUNT <= 0
	BEGIN
		SET @strErrorDescribe=N'非常抱歉,兑换失败！'
		ROLLBACK TRAN
		RETURN 6
	END

	SELECT @UserGold=Score FROM GameScoreInfo WHERE UserID=@UserID
	IF @UserGold IS NULL
	BEGIN
		SET @UserGold = 0
		INSERT INTO GameScoreInfo (UserID, Score, RegisterIP, LastLogonIP) VALUES (@UserID, @Gold, @RegisterIP, @RegisterIP) 
	END
	ELSE
	BEGIN
		UPDATE GameScoreInfo SET Score = Score + @Gold WHERE UserID=@UserID
	END

	IF @@ROWCOUNT <= 0
	BEGIN
		SET @strErrorDescribe=N'非常抱歉,兑换失败！'
		ROLLBACK TRAN
		RETURN 6
	END

	COMMIT TRAN

	-- 写入操作记录
	INSERT INTO RYRecordDBLink.RYRecordDB.dbo.RecordRoomCard(SourceUserID,SBeforeCard,RoomCard,TypeID,Gold,SBeforeGold,ClientIP) VALUES(@UserID,@UserRoomCard,@dwExchCount,2,@Gold,@UserGold,@strClientIP)
	
	SET @strErrorDescribe=N'房卡兑换成功！' 
END

RETURN 0

GO
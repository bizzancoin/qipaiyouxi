----------------------------------------------------------------------------------------------------
-- 版权：2011
-- 时间：2012-02-23
-- 用途：房卡兑换
----------------------------------------------------------------------------------------------------

USE RYTreasureDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].NET_PW_PresentRoomCard') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].NET_PW_PresentRoomCard
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_NULLS ON
GO

----------------------------------------------------------------------------------------------------

CREATE PROCEDURE NET_PW_PresentRoomCard
	@dwUserID	INT,						-- 用户 I D
	@dwPresentCount INT,					-- 赠送数量
	@dwGameID INT,							-- 赠送ID
	@strPassword NCHAR(32),					-- 银行密码
	@strClientIP NVARCHAR(15),				-- 操作地址
	@strDescript NVARCHAR(80),				-- 备注说明
	@strErrorDescribe NVARCHAR(127) OUTPUT	-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 用户信息
DECLARE @UserID INT
DECLARE @Nullity BIT
DECLARE @StunDown BIT
DECLARE @InsurePass NCHAR(32)
DECLARE @UserRoomCard INT

DECLARE @TUserID INT
DECLARE @TUserRoomCard INT


-- 执行逻辑
BEGIN
	-- 查询用户
	SELECT @UserID=UserID, @Nullity=Nullity, @StunDown=StunDown,@InsurePass=InsurePass FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo WHERE UserID=@dwUserID
	SELECT @TUserID=UserID FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo WHERE GameID=@dwGameID

	-- 查询用户
	IF @UserID IS NULL
	BEGIN
		SET @strErrorDescribe=N'您的帐号不存在或者密码输入有误，请查证后再次尝试登录！'
		RETURN 1
	END	
	IF @TUserID IS NULL
	BEGIN
		SET @strErrorDescribe=N'您的赠送的目标账号不存在，请查证后再次输入！'
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

	-- 开启事务
	BEGIN TRAN

	SELECT @UserRoomCard=RoomCard FROM UserRoomCard(ROWLOCK) WHERE UserID=@UserID
	IF @UserRoomCard IS NULL OR @UserRoomCard < @dwPresentCount
	BEGIN
		SET @strErrorDescribe=N'非常抱歉,您的房卡余额不足，请先购买！'
		ROLLBACK TRAN
		RETURN 5
	END

	UPDATE UserRoomCard SET RoomCard = RoomCard - @dwPresentCount WHERE UserID=@UserID
	IF @@ROWCOUNT <= 0
	BEGIN
		SET @strErrorDescribe=N'非常抱歉,赠送失败！'
		ROLLBACK TRAN
		RETURN 6
	END

	SELECT @TUserRoomCard=RoomCard FROM UserRoomCard WHERE UserID = @TUserID
	IF @TUserRoomCard IS NULL
	BEGIN
		SET @TUserRoomCard = 0
		INSERT INTO UserRoomCard VALUES(@TUserID,@dwPresentCount)
	END
	ELSE
	BEGIN
		UPDATE UserRoomCard SET RoomCard = RoomCard + @dwPresentCount WHERE UserID = @TUserID
	END

	IF @@ROWCOUNT <= 0
	BEGIN
		SET @strErrorDescribe=N'非常抱歉,赠送失败！'
		ROLLBACK TRAN
		RETURN 6
	END

	COMMIT TRAN

	-- 写入操作记录
	INSERT INTO RYRecordDBLink.RYRecordDB.dbo.RecordRoomCard(SourceUserID,TargetUserID,SBeforeCard,TBeforeCard,RoomCard,TypeID,ClientIP,Remarks) VALUES(@UserID,@TUserID,@UserRoomCard,@TUserRoomCard,@dwPresentCount,1,@strClientIP,@strDescript)
	
	SET @strErrorDescribe=N'房卡赠送成功！' 
END

RETURN 0

GO
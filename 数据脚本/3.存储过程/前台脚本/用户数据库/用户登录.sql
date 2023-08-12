----------------------------------------------------------------------------------------------------
-- 版权：2011
-- 时间：2011-08-31
-- 用途：帐号登录
----------------------------------------------------------------------------------------------------

USE RYAccountsDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].NET_PW_EfficacyAccounts') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].NET_PW_EfficacyAccounts
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- 帐号登录
CREATE PROCEDURE NET_PW_EfficacyAccounts
	@strAccounts NVARCHAR(31),					-- 用户帐号
	@strPassword NCHAR(32),						-- 用户密码
	@strClientIP NVARCHAR(15),					-- 连接地址
	@strErrorDescribe	NVARCHAR(127) OUTPUT			-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 基本信息
DECLARE @UserID INT
DECLARE @FaceID INT
DECLARE @Accounts NVARCHAR(31)
DECLARE @Nickname NVARCHAR(31)
DECLARE @UnderWrite NVARCHAR(63)
DECLARE @AgentID INT

-- 扩展信息
DECLARE @GameID INT
DECLARE @CustomID			INT
DECLARE @Gender TINYINT
DECLARE @Experience INT
DECLARE @Loveliness INT
DECLARE @MemberOrder INT
DECLARE @MemberOverDate DATETIME
DECLARE @CustomFaceVer TINYINT
DECLARE @SpreaderID INT
DECLARE @PlayTimeCount INT

-- 辅助变量
DECLARE @EnjoinLogon AS INT

-- 执行逻辑
BEGIN
	-- 系统暂停
	SELECT @EnjoinLogon=StatusValue FROM SystemStatusInfo(NOLOCK) WHERE StatusName=N'EnjoinLogon'
	IF @EnjoinLogon IS NOT NULL AND @EnjoinLogon<>0
	BEGIN
		SELECT @strErrorDescribe=StatusString FROM SystemStatusInfo(NOLOCK) WHERE StatusName=N'EnjoinLogon'
		RETURN 1
	END

	-- 效验地址
	SELECT @EnjoinLogon=EnjoinLogon FROM ConfineAddress(NOLOCK) WHERE AddrString=@strClientIP AND (EnjoinOverDate>GETDATE() OR EnjoinOverDate IS NULL)
	IF @EnjoinLogon IS NOT NULL AND @EnjoinLogon<>0
	BEGIN
		SET @strErrorDescribe=N'抱歉地通知您，系统禁止了您所在的 IP 地址的登录功能，请联系客户服务中心了解详细情况！'
		RETURN 1
	END

	-- 查询用户
	DECLARE @Nullity BIT
	DECLARE @StunDown BIT
	DECLARE @LogonPass AS NCHAR(32)

	SELECT @UserID=UserID, @GameID=GameID, @Accounts=Accounts, @Nickname=Nickname, @UnderWrite=UnderWrite, @LogonPass=LogonPass, @FaceID=FaceID,@CustomID=CustomID,
		@Gender=Gender, @Nullity=Nullity, @StunDown=StunDown, @Experience=Experience, @MemberOrder=MemberOrder, @MemberOverDate=MemberOverDate, 
		@Loveliness=Loveliness,@CustomFaceVer=CustomFaceVer,@SpreaderID=SpreaderID,@PlayTimeCount=PlayTimeCount,@AgentID=AgentID 
	FROM AccountsInfo(NOLOCK) WHERE Accounts=@strAccounts

	-- 查询用户
	IF @UserID IS NULL
	BEGIN
		SET @strErrorDescribe=N'您的帐号不存在或者密码输入有误，请查证后再次尝试登录！'
		RETURN 2
	END	

	-- 帐号禁止
	IF @Nullity<>0
	BEGIN
		SET @strErrorDescribe=N'您的帐号暂时处于冻结状态，请联系客户服务中心了解详细情况！'
		RETURN 3
	END	

	-- 帐号关闭
	IF @StunDown<>0
	BEGIN
		SET @strErrorDescribe=N'您的帐号使用了安全关闭功能，必须重新开通后才能继续使用！'
		RETURN 4
	END	

	-- 密码判断
	IF @LogonPass<>@strPassword
	BEGIN
		SET @strErrorDescribe=N'您的帐号不存在或者密码输入有误，请查证后再次尝试登录！'
		RETURN 5
	END

	-- 推广员提成,代理商不参与
	IF @SpreaderID<>0 AND NOT EXISTS (SELECT AgentID FROM AccountsAgent WHERE UserID=@SpreaderID)
	BEGIN
		DECLARE @GrantTime	INT
		DECLARE @GrantScore	BIGINT
		DECLARE @Note NVARCHAR(512)
		SELECT @GrantTime=PlayTimeCount,@GrantScore=PlayTimeGrantScore FROM RYTreasureDBLink.RYTreasureDB.dbo.GlobalSpreadInfo
		IF @GrantTime IS NULL
		BEGIN
			SET @GrantTime = 108000 -- 30小时
			SET @GrantScore = 200000
		END		
		SET @Note = N'游戏时长达标一次性奖励'

		IF @GrantTime>0 AND @GrantScore>0 AND @PlayTimeCount>=@GrantTime  
		BEGIN
			-- 获取提成信息
			DECLARE @RecordID INT
			SELECT @RecordID=RecordID FROM RYTreasureDBLink.RYTreasureDB.dbo.RecordSpreadInfo
			WHERE UserID = @SpreaderID AND ChildrenID = @UserID AND TypeID = 2
			IF @RecordID IS NULL
			BEGIN
				INSERT INTO RYTreasureDBLink.RYTreasureDB.dbo.RecordSpreadInfo(
					UserID,Score,TypeID,ChildrenID,CollectNote)
				VALUES(@SpreaderID,@GrantScore,2,@UserID,@Note)	
			END		
		END
	END

	-- 会员等级
	IF GETDATE()>=@MemberOverDate 
	BEGIN 
		SET @MemberOrder=0

		-- 删除过期会员身份
		DELETE FROM AccountsMember WHERE UserID=@UserID
	END
	ELSE 
	BEGIN
		DECLARE @MemberCurDate DATETIME

		-- 当前会员时间
		SELECT @MemberCurDate=MIN(MemberOverDate) FROM AccountsMember WHERE UserID=@UserID

		-- 删除过期会员
		IF GETDATE()>=@MemberCurDate
		BEGIN
			-- 删除会员期限过期的所有会员身份
			DELETE FROM AccountsMember WHERE UserID=@UserID AND MemberOverDate<=GETDATE()

			-- 切换到下一级别会员身份
			SELECT @MemberOrder=MAX(MemberOrder) FROM AccountsMember WHERE UserID=@UserID
			IF @MemberOrder IS NOT NULL
			BEGIN
				UPDATE AccountsInfo SET MemberOrder=@MemberOrder WHERE UserID=@UserID
			END
			ELSE SET @MemberOrder=0
		END
	END

	-- 更新信息
	UPDATE AccountsInfo SET MemberOrder=@MemberOrder, WebLogonTimes=WebLogonTimes+1,LastLogonDate=GETDATE(),
		LastLogonIP=@strClientIP WHERE UserID=@UserID
	
	--UPDATE AccountsInfo SET MemberOrder=@MemberOrder, WebLogonTimes=WebLogonTimes+1,
	--	LastLogonIP=@strClientIP WHERE UserID=@UserID

	-- 记录日志
	DECLARE @DateID INT
	SET @DateID=CAST(CAST(GETDATE() AS FLOAT) AS INT)
	UPDATE SystemStreamInfo SET WebLogonSuccess=WebLogonSuccess+1 WHERE DateID=@DateID
	IF @@ROWCOUNT=0 INSERT SystemStreamInfo (DateID, WebLogonSuccess) VALUES (@DateID, 1)

	-- 输出变量
	SELECT @UserID AS UserID, @GameID AS GameID, @Accounts AS Accounts, @Nickname AS Nickname,@UnderWrite AS UnderWrite, @FaceID AS FaceID, @CustomID AS CustomID,
		@Gender AS Gender, @Experience AS Experience, @MemberOrder AS MemberOrder, @MemberOverDate AS MemberOverDate,
		@Loveliness AS Loveliness,@CustomFaceVer AS CustomFaceVer,@AgentID AS AgentID
END

RETURN 0
GO
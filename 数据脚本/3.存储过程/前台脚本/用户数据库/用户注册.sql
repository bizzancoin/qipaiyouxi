----------------------------------------------------------------------------------------------------
-- 版权：2011
-- 时间：2011-08-31
-- 用途：帐号注册
----------------------------------------------------------------------------------------------------

USE RYAccountsDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].NET_PW_RegisterAccounts') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].NET_PW_RegisterAccounts
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- 帐号注册
CREATE PROCEDURE NET_PW_RegisterAccounts
	@strAccounts NVARCHAR(31),					-- 用户帐号
	@strNickname NVARCHAR(31),					-- 用户昵称
	@strLogonPass NCHAR(32),					-- 用户密码
	@strInsurePass NCHAR(32),					-- 用户密码
	@strDynamicPass NCHAR(32),					-- 动态密码
	@dwFaceID INT,								-- 头像标识
	@dwGender TINYINT,							-- 用户性别
	@strSpreader NVARCHAR(31),					-- 推广员名
	@strCompellation NVARCHAR(16),				-- 真实姓名
	@strPassPortID NVARCHAR(18),				-- 身份证号
	@strClientIP NVARCHAR(15),					-- 连接地址
	@strErrorDescribe	NVARCHAR(127) OUTPUT	-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 基本信息
DECLARE @UserID INT
DECLARE @FaceID INT
DECLARE @Accounts NVARCHAR(31)
DECLARE @Nickname NVARCHAR(31)
DECLARE @UnderWrite NVARCHAR(63)

-- 扩展信息
DECLARE @GameID INT
DECLARE @SpreaderID INT
DECLARE @AgentID INT
DECLARE @Nullity TINYINT
DECLARE @Gender TINYINT
DECLARE @Experience INT
DECLARE @Loveliness INT
DECLARE @MemberOrder INT
DECLARE @MemberOverDate DATETIME
DECLARE @CustomFaceVer TINYINT
DECLARE @Compellation NVARCHAR(16)
DECLARE @PassPortID NVARCHAR(18)

-- 辅助变量
DECLARE @EnjoinLogon AS INT
DECLARE @EnjoinRegister AS INT

-- 执行逻辑
BEGIN
	-- 注册暂停
	SELECT @EnjoinRegister=StatusValue FROM SystemStatusInfo(NOLOCK) WHERE StatusName=N'EnjoinRegister'
	IF @EnjoinRegister IS NOT NULL AND @EnjoinRegister<>0
	BEGIN
		SELECT @strErrorDescribe=StatusString FROM SystemStatusInfo(NOLOCK) WHERE StatusName=N'EnjoinRegister'
		RETURN 1
	END

	-- 登录暂停
	SELECT @EnjoinLogon=StatusValue FROM SystemStatusInfo(NOLOCK) WHERE StatusName=N'EnjoinLogon'
	IF @EnjoinLogon IS NOT NULL AND @EnjoinLogon<>0
	BEGIN
		SELECT @strErrorDescribe=StatusString FROM SystemStatusInfo(NOLOCK) WHERE StatusName=N'EnjoinLogon'
		RETURN 2
	END

	-- 效验名字
	IF EXISTS (SELECT [String] FROM ConfineContent(NOLOCK) WHERE CHARINDEX(String,@strAccounts)>0 AND (EnjoinOverDate>GETDATE() OR EnjoinOverDate IS NULL))
	BEGIN
		SET @strErrorDescribe=N'抱歉地通知您，您所输入的帐号名含有限制字符串，请更换帐号名后再次申请帐号！'
		RETURN 1
	END

	-- 效验昵称
	IF EXISTS (SELECT [String] FROM ConfineContent(NOLOCK) WHERE CHARINDEX(String,@strNickname)>0 AND (EnjoinOverDate>GETDATE() OR EnjoinOverDate IS NULL))
	BEGIN
		SET @strErrorDescribe=N'抱歉地通知您，您所输入的昵称含有限制字符串，请更换昵称后再次申请帐号！'
		RETURN 1
	END
	
	-- 效验地址
	SELECT @EnjoinRegister=EnjoinRegister FROM ConfineAddress(NOLOCK) WHERE AddrString=@strClientIP AND (EnjoinOverDate>GETDATE() OR EnjoinOverDate IS NULL)
	IF @EnjoinRegister IS NOT NULL AND @EnjoinRegister<>0
	BEGIN
		SET @strErrorDescribe=N'抱歉地通知您，系统禁止了您所在的 IP 地址的注册功能，请联系客户服务中心了解详细情况！'
		RETURN 2
	END
	
	-- 查询用户
	IF EXISTS (SELECT UserID FROM AccountsInfo(NOLOCK) WHERE Accounts=@strAccounts)
	BEGIN
		SET @strErrorDescribe=N'此帐号名已被注册，请换另一帐号名字尝试再次注册！'
		RETURN 3
	END

	IF EXISTS (SELECT UserID FROM AccountsInfo(NOLOCK) WHERE NickName=@strNickname)
	BEGIN
		SET @strErrorDescribe=N'此昵称已被注册，请换另一昵称尝试再次注册！'
		RETURN 3
	END

	-- 查推广员
	IF @strSpreader<>''
	BEGIN
		-- 查推广员
		SELECT @SpreaderID=UserID,@AgentID=AgentID FROM AccountsInfo(NOLOCK) WHERE GameID=@strSpreader

		-- 结果处理
		IF @SpreaderID IS NULL
		BEGIN
			SET @strErrorDescribe=N'您所填写的推荐人不存在或者填写错误，请检查后再次注册！'
			RETURN 4
		END
	END
	ELSE
	BEGIN
		SET @SpreaderID=0
		SET @AgentID=0
	END
	 

	-- 注册用户
	INSERT AccountsInfo (Accounts,Nickname,RegAccounts,LogonPass,InsurePass,DynamicPass,SpreaderID,Gender,FaceID,WebLogonTimes,RegisterIP,LastLogonIP,Compellation,PassPortID,RegisterOrigin)
	VALUES (@strAccounts,@strNickname,@strAccounts,@strLogonPass,@strInsurePass,@strDynamicPass,@SpreaderID,@dwGender,@dwFaceID,1,@strClientIP,@strClientIP,@strCompellation,@strPassPortID,0x50)

	-- 错误判断
	IF @@ERROR<>0
	BEGIN
		SET @strErrorDescribe=N'帐号已存在，请换另一帐号名字尝试再次注册！'
		RETURN 5
	END
	
	-- 查询用户
	SELECT @UserID=UserID, @Accounts=Accounts, @Nickname=Nickname,@UnderWrite=UnderWrite, @Gender=Gender, @FaceID=FaceID, @Experience=Experience,
		@MemberOrder=MemberOrder, @MemberOverDate=MemberOverDate, @Loveliness=Loveliness,@CustomFaceVer=CustomFaceVer,
		@Compellation=Compellation,@PassPortID=PassPortID
	FROM AccountsInfo(NOLOCK) WHERE Accounts=@strAccounts

	-- 分配标识
	SELECT @GameID=GameID FROM GameIdentifier(NOLOCK) WHERE UserID=@UserID
	IF @GameID IS NULL 
	BEGIN
		SET @GameID=0
		SET @strErrorDescribe=N'用户注册成功，但未成功获取游戏 ID 号码，系统稍后将给您分配！'
	END
	ELSE UPDATE AccountsInfo SET GameID=@GameID WHERE UserID=@UserID

	-- 推广提成,代理商不参与
	IF @SpreaderID<>0 AND @AgentID=0
	BEGIN
		DECLARE @Score BIGINT
		DECLARE @Note NVARCHAR(512)
		SET @Note = N'注册'
		SELECT @Score = RegisterGrantScore FROM RYTreasureDBLink.RYTreasureDB.dbo.GlobalSpreadInfo
		IF @Score IS NULL
		BEGIN
			SET @Score=5000
		END
		INSERT INTO RYTreasureDBLink.RYTreasureDB.dbo.RecordSpreadInfo(
			UserID,Score,TypeID,ChildrenID,CollectNote)
		VALUES(@SpreaderID,@Score,1,@UserID,@Note)		
	END

	-- 记录日志
	DECLARE @DateID INT
	SET @DateID=CAST(CAST(GETDATE() AS FLOAT) AS INT)
	UPDATE SystemStreamInfo SET WebRegisterSuccess=WebRegisterSuccess+1 WHERE DateID=@DateID
	IF @@ROWCOUNT=0 INSERT SystemStreamInfo (DateID, WebRegisterSuccess) VALUES (@DateID, 1)

	----------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------
	-- 注册赠送

	-- 读取变量
	DECLARE @GrantScoreCount AS BIGINT
	DECLARE @GrantIPCount AS BIGINT
	IF @AgentID<>0
	BEGIN
		SELECT @GrantScoreCount=StatusValue FROM SystemStatusInfo(NOLOCK) WHERE StatusName=N'AgentGrantScoreCount'
	END
	ELSE
	BEGIN
		SELECT @GrantScoreCount=StatusValue FROM SystemStatusInfo(NOLOCK) WHERE StatusName=N'GrantScoreCount'
	END
	
	SELECT @GrantIPCount=StatusValue FROM SystemStatusInfo(NOLOCK) WHERE StatusName=N'GrantIPCount'

	-- 赠送限制
	IF @GrantScoreCount IS NOT NULL AND @GrantScoreCount>0 AND @GrantIPCount IS NOT NULL AND @GrantIPCount>0
	BEGIN
		-- 赠送次数
		DECLARE @GrantCount AS BIGINT
		SELECT @GrantCount=GrantCount FROM SystemGrantCount(NOLOCK) WHERE DateID=@DateID AND RegisterIP=@strClientIP
	
		-- 次数判断
		IF @GrantCount IS NOT NULL AND @GrantCount>=@GrantIPCount
		BEGIN
			SET @GrantScoreCount=0
		END
	END

	-- 赠送金币
	IF @GrantScoreCount IS NOT NULL AND @GrantScoreCount>0
	BEGIN
		-- 更新记录
		UPDATE SystemGrantCount SET GrantScore=GrantScore+@GrantScoreCount, GrantCount=GrantCount+1 WHERE DateID=@DateID AND RegisterIP=@strClientIP

		-- 插入记录
		IF @@ROWCOUNT=0
		BEGIN
			INSERT SystemGrantCount (DateID, RegisterIP, RegisterMachine, GrantScore, GrantCount) VALUES (@DateID, @strClientIP, '', @GrantScoreCount, 1)
		END

		-- 赠送金币
		INSERT RYTreasureDBLink.RYTreasureDB.dbo.GameScoreInfo (UserID, Score, RegisterIP, LastLogonIP) VALUES (@UserID, @GrantScoreCount, @strClientIP, @strClientIP) 

		-- 赠送统计
		DECLARE @TypeID INT
		IF @AgentID<>0
			SET @TypeID=13
		ELSE
			SET @TypeID=1
		
		-- 流水帐
		INSERT INTO RYTreasureDBLink.RYTreasureDB.dbo.RecordPresentInfo(UserID,PreScore,PreInsureScore,PresentScore,TypeID,IPAddress)
		VALUES(@UserID,0,0,@GrantScoreCount,@TypeID,@strClientIP)
		-- 日统计
		UPDATE RYTreasureDBLink.RYTreasureDB.dbo.StreamPresentInfo SET PresentCount=PresentCount+1,PresentScore=PresentScore+@GrantScoreCount,LastDate=GETDATE()
		WHERE DateID=@DateID AND UserID=@UserID AND TypeID=@TypeID 
		IF @@ROWCOUNT=0
		BEGIN
			INSERT INTO RYTreasureDBLink.RYTreasureDB.dbo.StreamPresentInfo(DateID,UserID,TypeID,PresentCount,PresentScore,FirstDate,LastDate)
			VALUES(@DateID,@UserID,@TypeID,1,@GrantScoreCount,GETDATE(),GETDATE())
		END		
	END

	----------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------

	----------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------
	-- 注册赠送房卡

	-- 读取变量
	DECLARE @GrantRoomCard AS BIGINT
	SELECT @Nullity=Nullity FROM AccountsAgent WHERE AgentID = @AgentID
	IF @AgentID<>0 AND @Nullity = 0
	BEGIN
		SELECT @GrantRoomCard=StatusValue FROM SystemStatusInfo(NOLOCK) WHERE StatusName=N'GrantAgentRoomCardCount'
	END
	ELSE
	BEGIN
		SELECT @GrantRoomCard=StatusValue FROM SystemStatusInfo(NOLOCK) WHERE StatusName=N'GrantRoomCardCount'
	END

	-- 赠送限制
	IF @GrantRoomCard IS NOT NULL AND @GrantRoomCard>0 AND @GrantIPCount IS NOT NULL AND @GrantIPCount>0
	BEGIN
		-- 赠送次数
		DECLARE @ExistGrantCount AS BIGINT
		SELECT @ExistGrantCount=GrantCount FROM SystemGrantRoomCardCount(NOLOCK) WHERE DateID=@DateID AND RegisterIP=@strClientIP
	
		-- 次数判断
		IF @ExistGrantCount IS NOT NULL AND @ExistGrantCount>=@GrantIPCount
		BEGIN
			SET @GrantRoomCard=0
		END
	END

	-- 赠送房卡
	IF @GrantRoomCard IS NOT NULL AND @GrantRoomCard>0
	BEGIN
		-- 更新记录
		UPDATE SystemGrantRoomCardCount SET GrantRoomCard=GrantRoomCard+@GrantRoomCard, GrantCount=GrantCount+1 WHERE DateID=@DateID AND RegisterIP=@strClientIP

		-- 插入记录
		IF @@ROWCOUNT=0
		BEGIN
			INSERT SystemGrantRoomCardCount (DateID, RegisterIP, RegisterMachine, GrantRoomCard, GrantCount) VALUES (@DateID, @strClientIP, '', @GrantRoomCard, 1)
		END

		-- 赠送金币
		INSERT RYTreasureDBLink.RYTreasureDB.dbo.UserRoomCard (UserID, RoomCard) VALUES (@UserID, @GrantRoomCard) 
		
	END
	----------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------

	-- 输出变量
	SELECT @UserID AS UserID, @GameID AS GameID, @Accounts AS Accounts, @Nickname AS Nickname,@UnderWrite AS UnderWrite, @FaceID AS FaceID, 
		@Gender AS Gender, @Experience AS Experience, @MemberOrder AS MemberOrder, @MemberOverDate AS MemberOverDate,
		@Loveliness AS Loveliness,@CustomFaceVer AS CustomFaceVer,
		@Compellation AS Compellation,@PassPortID AS PassPortID
End 

RETURN 0

GO
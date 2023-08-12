
----------------------------------------------------------------------------------------------------

USE RYAccountsDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_AccountBind]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_AccountBind]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_AccountBindExists]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_AccountBindExists]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- 帐号绑定
CREATE PROC GSP_GP_AccountBind
	@dwUserID INT,								-- 用户 I D
	@strPassword NCHAR(32),						-- 用户密码	
	@strClientIP NVARCHAR(15),					-- 连接地址
	@strMachineID NVARCHAR(32),					-- 机器标识
		
	@strBindAccounts NVARCHAR(31),				-- 绑定帐号	
	@strBindPassword NCHAR(32),					-- 绑定密码	
	@strBindSpreader NVARCHAR(31),				-- 绑定推广		

	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN
	-- 变量定义
	DECLARE @BindUserID INT
	
	DECLARE @UserID INT
	DECLARE @Nullity BIT
	DECLARE @PlatformID SMALLINT
	DECLARE @LogonPass AS NCHAR(32)

	-- 查询用户
	SELECT @UserID=UserID, @LogonPass=LogonPass, @Nullity=Nullity,@PlatformID=PlatformID FROM AccountsInfo(NOLOCK) WHERE UserID=@dwUserID

	-- 查询用户
	IF @UserID IS NULL
	BEGIN
		SET @strErrorDescribe=N'您的帐号不存在或者密码输入有误，请查证后再次尝试！'
		RETURN 1
	END	

	-- 帐号禁止
	IF @Nullity<>0
	BEGIN
		SET @strErrorDescribe=N'您的帐号暂时处于冻结状态，请联系客户服务中心了解详细情况！'
		RETURN 2
	END	
	
	-- 密码判断
	IF @LogonPass<>@strPassword
	BEGIN
		SET @strErrorDescribe=N'您的帐号不存在或者密码输入有误，请查证后再次尝试！'
		RETURN 3
	END
	
	-- 游客判断
	IF @PlatformID<>2
	BEGIN
		SET @strErrorDescribe=N'您的帐号不是游客，绑定帐号失败！'
		RETURN 4
	END
			
	-- 检查绑定
	IF EXISTS(SELECT * FROM AccountsVisitor WHERE VisitorMachine=@strMachineID )
	BEGIN
		SET @strErrorDescribe=N'此机器已经绑定帐号，不能重复绑定！'
		return 5
	END
	
	-- 查询用户
	IF EXISTS(SELECT * FROM AccountsVisitor WHERE BindAccounts=@strBindAccounts )
	BEGIN
		SET @strErrorDescribe=N'此帐号已经绑定，不能再次绑定！'
		return 6
	END
	
	-- 查询存在
	IF EXISTS(SELECT * FROM AccountsInfo WHERE Accounts=@strBindAccounts )
	BEGIN
		SET @strErrorDescribe=N'您的帐号已经注册，绑定帐号失败！'
		return 7
	END	
	
	-- 查推广员
	DECLARE @SpreaderID INT
	IF @strBindSpreader<>''
	BEGIN
		-- 查推广员
		SELECT @SpreaderID=UserID FROM AccountsInfo(NOLOCK) WHERE Accounts=@strBindSpreader
		
		-- 结果处理
		IF @SpreaderID IS NULL
		BEGIN
			SET @strErrorDescribe=N'您所填写的推荐人不存在或者填写错误，绑定帐号失败！'
			RETURN 8			
		END
	END
	ELSE SET @SpreaderID=0
		
	--注册帐号
	INSERT AccountsInfo (Accounts,NickName,RegAccounts,PlatformID,UserUin,LogonPass,InsurePass,SpreaderID,Gender,FaceID,
		GameLogonTimes,LastLogonIP,LastLogonMobile,LastLogonMachine,RegisterIP,RegisterMobile,RegisterMachine)
	VALUES (@strBindAccounts,@strBindAccounts,@strBindAccounts,0,N'',@strBindPassword,N'',@SpreaderID,0,0,
		1,@strClientIP,N'',@strMachineID,@strClientIP,N'',@strMachineID)	
	
	SELECT @BindUserID = UserID   FROM AccountsInfo WHERE Accounts=@strBindAccounts
	IF @BindUserID IS NULL
	BEGIN
		SET @strErrorDescribe=N'注册失败，请查证后再次尝试！'
		RETURN 8
	END	
	
	-- 积分归零
	INSERT RYTreasureDBLink.RYTreasureDB.dbo.GameScoreInfo (UserID, Score, RegisterIP, LastLogonIP,RegisterMachine) VALUES (@BindUserID, 0, @strClientIP, @strClientIP,@strMachineID) 

	INSERT RYTreasureDBLink.RYTreasureDB.dbo.UserCurrencyInfo (UserID, Currency) VALUES (@BindUserID, 0) 

	-- 记录绑定
	INSERT INTO AccountsVisitor([VisitorUserID],[VisitorMachine],[BindUserID],[BindAccounts],[BindType]) 
	VALUES (@dwUserID,@strMachineID,@BindUserID,@strBindAccounts,0)
	
	-- 合并数据
	DECLARE @Score BIGINT
	DECLARE @Insure BIGINT
	DECLARE @Beans decimal(18, 2)
	DECLARE @UserMedal INT
	
	-- 查询元宝
	SELECT @UserMedal = UserMedal FROM AccountsInfo WHERE UserID=@dwUserID
		
	-- 查询金币
	SELECT @Score=Score, @Insure=InsureScore FROM RYTreasureDBLink.RYTreasureDB.dbo.GameScoreInfo WHERE UserID=@dwUserID
	
	-- 查询游戏豆
	SELECT @Beans=Currency FROM RYTreasureDBLink.RYTreasureDB.dbo.UserCurrencyInfo WHERE UserID=@dwUserID		

	-- 数据调整
	IF @Score IS NULL SET @Score=0
	IF @Insure IS NULL SET @Insure=0
	IF @Beans IS NULL SET @Beans=0
	IF @UserMedal IS NULL SET @UserMedal=0
	
	-- 合并绑定
	UPDATE AccountsInfo SET UserMedal = UserMedal+ @UserMedal WHERE UserID = @BindUserID
	UPDATE RYTreasureDBLink.RYTreasureDB.dbo.GameScoreInfo SET Score =  Score + @Score, InsureScore=InsureScore+@Insure WHERE UserID = @BindUserID
	UPDATE RYTreasureDBLink.RYTreasureDB.dbo.UserCurrencyInfo SET Currency = Currency + @Beans WHERE UserID = @BindUserID
	
	-- 禁用游客
	UPDATE AccountsInfo SET Nullity = 1  WHERE UserID=@dwUserID

	-- 输出信息
	SET @strErrorDescribe=N'绑定新帐号成功！'
	
	RETURN 0

END

GO

----------------------------------------------------------------------------------------------------

-- 帐号绑定
CREATE PROC GSP_GP_AccountBindExists
	@dwUserID INT,								-- 用户 I D
	@strPassword NCHAR(32),						-- 用户密码	
	@strClientIP NVARCHAR(15),					-- 连接地址
	@strMachineID NVARCHAR(32),					-- 机器标识
		
	@strBindAccounts NVARCHAR(31),				-- 绑定帐号	
	@strBindPassword NCHAR(32),					-- 绑定密码		

	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN
	-- 变量定义
	DECLARE @BindUserID INT
	
	DECLARE @UserID INT
	DECLARE @Nullity BIT
	DECLARE @PlatformID SMALLINT
	DECLARE @LogonPass AS NCHAR(32)

	-- 查询用户
	SELECT @UserID=UserID, @LogonPass=LogonPass, @Nullity=Nullity,@PlatformID=PlatformID FROM AccountsInfo(NOLOCK) WHERE UserID=@dwUserID

	-- 查询用户
	IF @UserID IS NULL
	BEGIN
		SET @strErrorDescribe=N'您的帐号不存在或者密码输入有误，请查证后再次尝试！'
		RETURN 1
	END	

	-- 帐号禁止
	IF @Nullity<>0
	BEGIN
		SET @strErrorDescribe=N'您的帐号暂时处于冻结状态，请联系客户服务中心了解详细情况！'
		RETURN 2
	END	
	
	-- 密码判断
	IF @LogonPass<>@strPassword
	BEGIN
		SET @strErrorDescribe=N'您的帐号不存在或者密码输入有误，请查证后再次尝试！'
		RETURN 3
	END
	
	-- 游客判断
	IF @PlatformID<>2
	BEGIN
		SET @strErrorDescribe=N'您的帐号不是游客，绑定帐号失败！'
		RETURN 4
	END
			
	-- 检查绑定
	IF EXISTS(SELECT * FROM AccountsVisitor WHERE VisitorMachine=@strMachineID )
	BEGIN
		SET @strErrorDescribe=N'此机器已经绑定帐号，不能重复绑定！'
		return 5
	END
	
	-- 查询用户
	IF EXISTS(SELECT * FROM AccountsVisitor WHERE BindAccounts=@strBindAccounts )
	BEGIN
		SET @strErrorDescribe=N'此帐号已经绑定，不能再次绑定！'
		return 6
	END
	
	-- 查询存在
	IF NOT EXISTS(SELECT * FROM AccountsInfo WHERE Accounts=@strBindAccounts )
	BEGIN
		SET @strErrorDescribe=N'帐号不存在，绑定帐号失败！'
		return 7
	END	
	
	-- 查询密码
	IF NOT EXISTS(SELECT * FROM AccountsInfo WHERE Accounts=@strBindAccounts AND @strBindPassword=LogonPass )
	BEGIN
		SET @strErrorDescribe=N'帐号密码错误，绑定帐号失败！'
		return 7
	END	
	
	SELECT @BindUserID = UserID   FROM AccountsInfo WHERE Accounts=@strBindAccounts
	
	-- 记录绑定
	INSERT INTO AccountsVisitor([VisitorUserID],[VisitorMachine],[BindUserID],[BindAccounts],[BindType]) 
	VALUES (@dwUserID,@strMachineID,@BindUserID,@strBindAccounts,1)
	
	-- 合并数据
	DECLARE @Score BIGINT
	DECLARE @Insure BIGINT
	DECLARE @Beans decimal(18, 2)
	DECLARE @UserMedal INT
	
	-- 查询元宝
	SELECT @UserMedal = UserMedal FROM AccountsInfo WHERE UserID=@dwUserID
		
	-- 查询金币
	SELECT @Score=Score, @Insure=InsureScore FROM RYTreasureDBLink.RYTreasureDB.dbo.GameScoreInfo WHERE UserID=@dwUserID
	
	-- 查询游戏豆
	SELECT @Beans=Currency FROM RYTreasureDBLink.RYTreasureDB.dbo.UserCurrencyInfo WHERE UserID=@dwUserID		

	-- 数据调整
	IF @Score IS NULL SET @Score=0
	IF @Insure IS NULL SET @Insure=0
	IF @Beans IS NULL SET @Beans=0
	IF @UserMedal IS NULL SET @UserMedal=0
	
	-- 合并绑定
	UPDATE AccountsInfo SET UserMedal = UserMedal+ @UserMedal WHERE UserID = @BindUserID
	UPDATE RYTreasureDBLink.RYTreasureDB.dbo.GameScoreInfo SET Score =  Score + @Score, InsureScore=InsureScore+@Insure WHERE UserID = @BindUserID
	UPDATE RYTreasureDBLink.RYTreasureDB.dbo.UserCurrencyInfo SET Currency = Currency + @Beans WHERE UserID = @BindUserID
	
	-- 禁用游客
	UPDATE AccountsInfo SET Nullity = 1  WHERE UserID=@dwUserID

	-- 输出信息
	SET @strErrorDescribe=N'绑定新帐号成功！'
	
	RETURN 0

END

GO
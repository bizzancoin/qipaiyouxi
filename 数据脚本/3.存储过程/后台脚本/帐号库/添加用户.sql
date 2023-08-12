----------------------------------------------------------------------
-- 时间：2011-09-29
-- 用途：后台管理员添加用户信息
----------------------------------------------------------------------
USE RYAccountsDB
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[NET_PM_AddAccount]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[NET_PM_AddAccount]
GO

----------------------------------------------------------------------
CREATE PROC [NET_PM_AddAccount]
(
	@strAccounts		NVARCHAR(31),			--用户帐号
	@strNickName		NVARCHAR(31)=N'',		--用户昵称
	@strLogonPass		NCHAR(32),				--登录密码
	@strInsurePass		NCHAR(32),				--安全密码
	@strDynamicPass		NCHAR(32),				--动态密码
	@dwFaceID			SMALLINT ,				--头像
	@strUnderWrite		NVARCHAR(18)=N'',		--个性签名
	@strPassPortID		NVARCHAR(18)=N'',		--身份证号
	@strCompellation	NVARCHAR(16)=N'',		--真实名字	
	
	@dwExperience		INT	= 0,				--经验数值
	@dwPresent			INT	= 0,				--礼物数值
	@dwLoveLiness		INT	= 0,				--魅力值数	
	@dwUserRight		INT	= 0,				--用户权限
	@dwMasterRight		INT	= 0,				--管理权限
	@dwServiceRight		INT	= 0,				--服务权限
	@dwMasterOrder		TINYINT	= 0,			--管理等级
	
	@dwMemberOrder		TINYINT	= 0,			--会员等级
	@dtMemberOverDate	DATETIME='1980-01-01',	--过期日期
	@dtMemberSwitchDate DATETIME='1980-01-01',	--切换时间
	@dwGender			TINYINT = 1,			--用户性别
	@dwNullity			TINYINT = 0,			--禁止服务
	@dwStunDown			TINYINT = 0,			--关闭标志
	@dwMoorMachine		TINYINT = 0,			--固定机器	
	@strRegisterIP		NVARCHAR(15),			--注册地址
	@strRegisterMachine NVARCHAR(32)=N'',		--注册机器        
	@IsAndroid			TINYINT,
	                
	@strQQ				NVARCHAR(16)=N'',		--QQ 号码
	@strEMail			NVARCHAR(32)=N'',		--电子邮件
	@strSeatPhone		NVARCHAR(32)=N'',		--固定电话
	@strMobilePhone		NVARCHAR(16)=N'',		--手机号码
	@strDwellingPlace	NVARCHAR(128)=N'',		--详细住址
	@strPostalCode		NVARCHAR(8)=N'',		--邮政编码               
	@strUserNote		NVARCHAR(256)=N'',		--用户备注
	
	@strErrorDescribe NVARCHAR(127) OUTPUT		--输出信息
)
			
WITH ENCRYPTION AS

BEGIN
	-- 属性设置
	SET NOCOUNT ON

	DECLARE @dwUserID			INT,			-- 用户标识
			@GameID				INT,			-- 游戏ID
			@dtCurrentDate		DATETIME,
			@dwDefSpreaderScale DECIMAL(18,2)	--默认的抽水比例值0.10
	SET @dwDefSpreaderScale = 0.10
	SET @dtCurrentDate =  GETDATE()

	-- 执行逻辑
	BEGIN TRY

	--验证账号
	IF @strAccounts IS NULL OR @strAccounts = ''
	BEGIN
		SET @strErrorDescribe='帐号已存在，请重新输入！'
		RETURN -2;
	END
	IF EXISTS (SELECT * FROM AccountsInfo WHERE Accounts=@strAccounts OR RegAccounts=@strAccounts)
	BEGIN
		SET @strErrorDescribe='帐号已存在，请重新输入！'
		RETURN -3;	
	END
	IF EXISTS (SELECT [String] FROM ConfineContent(NOLOCK) WHERE (EnjoinOverDate IS NULL  OR EnjoinOverDate>=GETDATE()) AND CHARINDEX(String,@strAccounts)>0)
	BEGIN	
		SET @strErrorDescribe='您所输入的帐号名含有限制字符串!'	
		RETURN -5;
	END

	--验证昵称
	IF @strNickName IS NULL OR @strNickName = ''
		SET @strNickName = @strAccounts
	IF EXISTS (SELECT * FROM AccountsInfo WHERE NickName=@strNickName)
	BEGIN
		SET @strErrorDescribe='昵称已存在，请重新输入！'
		RETURN -4;
	END	
		
	-- 注册赠送金币	
	DECLARE @GrantScoreCount AS INT
	DECLARE @DateID INT
	SET @DateID=CAST(CAST(GETDATE() AS FLOAT) AS INT)
	SELECT @GrantScoreCount=StatusValue FROM SystemStatusInfo(NOLOCK) WHERE StatusName=N'GrantScoreCount'
	
	IF @GrantScoreCount IS NULL OR @GrantScoreCount = '' OR @GrantScoreCount <= 0
		SET @GrantScoreCount = 0;
	
	IF @strNickName IS NULL OR 	@strNickName = ''
		SET @strNickName = @strAccounts
	IF @strInsurePass IS NULL OR @strInsurePass = ''
		SET @strInsurePass = @strLogonPass
	BEGIN TRAN

		--用户信息
		INSERT AccountsInfo( Accounts,NickName,RegAccounts,UnderWrite,PassPortID,Compellation,LogonPass,InsurePass,DynamicPass,FaceID,
				Experience,Present,LoveLiness,UserRight,MasterRight,ServiceRight,MasterOrder,MemberOrder,MemberOverDate,MemberSwitchDate,Gender ,
				Nullity,StunDown,MoorMachine,LastLogonIP,RegisterIP,RegisterDate,RegisterMobile,RegisterMachine,IsAndroid)
		VALUES (@strAccounts,@strNickName,@strAccounts,@strUnderWrite,@strPassPortID,@strCompellation,@strLogonPass,@strInsurePass,@strDynamicPass,@dwFaceID,
				@dwExperience,@dwPresent,@dwLoveLiness,@dwUserRight,@dwMasterRight,@dwServiceRight,@dwMasterOrder,@dwMemberOrder,@dtMemberOverDate,@dtMemberSwitchDate,@dwGender,
				@dwNullity,@dwStunDown,@dwMoorMachine,@strRegisterIP,@strRegisterIP,@dtCurrentDate,@strMobilePhone,@strRegisterMachine,@IsAndroid)

		--用户标识
        SET @dwUserID  = @@IDENTITY
       
		--用户详细信息
		INSERT IndividualDatum(UserID,QQ,EMail,SeatPhone,MobilePhone,DwellingPlace,PostalCode,CollectDate,UserNote)
		VALUES (@dwUserID,@strQQ,@strEMail,@strSeatPhone,@strMobilePhone,@strDwellingPlace,@strPostalCode,@dtCurrentDate,@strUserNote)

		-- 用户财富信息
		INSERT RYTreasureDB.dbo.GameScoreInfo(UserID,Score,Revenue,InsureScore,UserRight,MasterRight,MasterOrder,LastLogonMachine,LastLogonIP,				         
		          RegisterIP,RegisterDate,RegisterMachine)
		VALUES (@dwUserID,@GrantScoreCount,0,0,@dwUserRight,@dwMasterRight,@dwMasterOrder,'',@strRegisterIP,@strRegisterIP,@dtCurrentDate,'')    

		-- 机器人配置
		IF @IsAndroid=1
		BEGIN
			 IF NOT EXISTS(SELECT UserID From AndroidLockInfo WHERE UserID=@dwUserID)
				INSERT INTO AndroidLockInfo(UserID,AndroidStatus,ServerID,BatchID,LockDateTime) VALUES(@dwUserID,0,0,0,GETDATE());
		END			
			
		-- 记录日志			
		UPDATE SystemStreamInfo SET WebRegisterSuccess=WebRegisterSuccess+1 WHERE DateID=@DateID
		IF @@ROWCOUNT=0 INSERT SystemStreamInfo (DateID, WebRegisterSuccess) VALUES (@DateID, 1)
		
		IF @GrantScoreCount > 0
		BEGIN 
			-- 更新赠送金币记录
			UPDATE SystemGrantCount SET GrantScore=GrantScore+@GrantScoreCount, GrantCount=GrantCount+1 WHERE DateID=@DateID AND RegisterIP=@strRegisterIP

			-- 插入记录
			IF @@ROWCOUNT=0		
				INSERT SystemGrantCount (DateID, RegisterIP, RegisterMachine, GrantScore, GrantCount) VALUES (@DateID, @strRegisterIP, '', @GrantScoreCount, 1)		
		END 
			
		-- 分配游戏ID
		SELECT @GameID=GameID FROM GameIdentifier(NOLOCK) WHERE UserID=@dwUserID
		IF @GameID IS NULL 
		BEGIN
			COMMIT TRAN
			SET @strErrorDescribe='用户添加成功，但未成功获取游戏 ID 号码，系统稍后将给您分配！'			
			RETURN 1;				
		END
		ELSE UPDATE AccountsInfo SET GameID=@GameID WHERE UserID=@dwUserID  
		     
		COMMIT TRAN		
		SET @strErrorDescribe='添加玩家成功'	
		RETURN 0;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
		BEGIN
			ROLLBACK TRAN
		END
		SET @strErrorDescribe='添加玩家失败,未知服务器错误'	
		RETURN -1;
	END CATCH
END
GO
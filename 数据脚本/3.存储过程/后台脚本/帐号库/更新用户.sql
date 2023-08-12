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

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[NET_PM_UpdateAccountInfo]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[NET_PM_UpdateAccountInfo]
GO

----------------------------------------------------------------------
CREATE PROC [NET_PM_UpdateAccountInfo]
(
	@dwUserID			INT,					--用户标识
	@strAccounts		NVARCHAR(31),			--用户帐号
	@strNickName		NVARCHAR(31)=N'',		--用户昵称
	@strLogonPass		NCHAR(32),				--登录密码
	@strInsurePass		NCHAR(32),				--安全密码
	@strUnderWrite		NVARCHAR(63)=N'',		--个性签名
	
	@dwExperience		INT	= 0,				--经验数值
	@dwPresent			INT	= 0,				--礼物数值
	@dwLoveLiness		INT	= 0,				--魅力值数
	@dwGender			TINYINT = 1,			--用户性别
	@dwFaceID			SMALLINT ,				--玩家头像	
	@dwCustomID			INT ,					--玩家自定义头像	
	
	@dwStunDown			TINYINT = 0,			--关闭标志
	@dwNullity			TINYINT = 0,			--禁止服务
	@dwMoorMachine		TINYINT = 0,			--固定机器 
	@dwIsAndroid		TINYINT,				--是否机器人
	@dwUserRight		INT	= 0,				--用户权限
	@dwMasterRight		INT	= 0,				--管理权限
	@dwMasterOrder		TINYINT	= 0,			--管理等级

	@dwMasterID			INT = 0,				--操作管理员
	@strClientIP		NVARCHAR(15),			--操作地址
	
	@strErrorDescribe NVARCHAR(127) OUTPUT		--输出信息
)
			
WITH ENCRYPTION AS

DECLARE @UserID INT
DECLARE @OldAccounts NVARCHAR(31)
DECLARE @OldNickName NVARCHAR(31)
DECLARE @OldLogonPass NVARCHAR(32)
DECLARE @OldInsurePass NVARCHAR(32)

BEGIN
	--属性设置
	SET NOCOUNT ON
	
	-- 查询用户信息
	SELECT @UserID=UserID,@OldAccounts=Accounts,@OldNickName=NickName,@OldLogonPass=logonPass,@OldInsurePass=InsurePass 
	FROM AccountsInfo WHERE UserID=@dwUserID

	-- 验证账号
	IF @OldAccounts<>@strAccounts
	BEGIN	
		IF EXISTS(SELECT UserID FROM AccountsInfo WHERE (Accounts=@strAccounts OR RegAccounts=@strAccounts) AND UserID!=@UserID)
		BEGIN
			SET @strErrorDescribe='帐号已存在，请重新输入！'
			RETURN -1;	
		END
		IF EXISTS(SELECT [String] FROM ConfineContent(NOLOCK) WHERE (EnjoinOverDate IS NULL  OR EnjoinOverDate>=GETDATE()) AND CHARINDEX(String,@strAccounts)>0)
		BEGIN	
			SET @strErrorDescribe='您所输入的帐号名含有限制字符串！'
			RETURN -2;
		END
	END

	-- 验证昵称
	IF @OldNickName<>@strNickName
	BEGIN
		IF EXISTS(SELECT UserID FROM AccountsInfo WHERE NickName=@strNickName)
		BEGIN
			SET @strErrorDescribe='昵称已存在，请重新输入！'
			RETURN -4;
		END	
	END
	
	-- 更新信息
	UPDATE AccountsInfo SET Accounts=@strAccounts,NickName=@strNickName,LogonPass=@strLogonPass,InsurePass=@strInsurePass,
		UnderWrite=@strUnderWrite,Experience=@dwExperience,Present=@dwPresent,LoveLiness=@dwLoveLiness,
		Gender=@dwGender,FaceID=@dwFaceID,CustomID=@dwCustomID,StunDown=@dwStunDown,Nullity=@dwNullity,MoorMachine=@dwMoorMachine,IsAndroid=@dwIsAndroid,
		UserRight=@dwUserRight,MasterOrder=@dwMasterOrder,MasterRight=@dwMasterRight 
	WHERE UserID=@UserID 

	-- 机器人配置
	IF @dwIsAndroid=1
	BEGIN
		IF NOT EXISTS(SELECT UserID From AndroidLockInfo WHERE UserID=@UserID)
			INSERT INTO AndroidLockInfo(UserID,AndroidStatus,ServerID,BatchID,LockDateTime) VALUES(@UserID,0,0,0,Getdate());	
	END
	ELSE
		DELETE AndroidLockInfo WHERE UserID=@UserID;
	
	-- 修改账号日志
	IF @OldAccounts<>@strAccounts
	BEGIN
		INSERT INTO RYRecordDBLink.RYRecordDB.DBO.RecordAccountsExpend(OperMasterID,UserID,ReAccounts,[Type],ClientIP,CollectDate)
		VALUES(@dwMasterID,@UserID,@OldAccounts,0,@strClientIP,GETDATE())
	END

	-- 修改昵称日志
	IF @OldNickName<>@strNickName
	BEGIN
		INSERT INTO RYRecordDBLink.RYRecordDB.DBO.RecordAccountsExpend(OperMasterID,UserID,ReAccounts,[Type],ClientIP,CollectDate)
		VALUES(@dwMasterID,@UserID,@OldNickName,1,@strClientIP,GETDATE())
	END

	-- 修改密码日志
	IF @OldLogonPass=@strLogonPass
	BEGIN
		SET @OldLogonPass=''
	END
	IF @OldInsurePass=@strInsurePass
	BEGIN
		SET @OldInsurePass=''
	END
	IF @OldLogonPass<>'' OR @OldInsurePass<>''
	BEGIN
		INSERT INTO RYRecordDBLink.RYRecordDB.DBO.RecordPasswdExpend(OperMasterID,UserID,ReLogonPasswd,ReInsurePasswd,ClientIP,CollectDate)
		VALUES(@dwMasterID,@UserID,@OldLogonPass,@OldInsurePass,@strClientIP,GETDATE())
	END
	SET @strErrorDescribe='修改用户信息成功！'
	RETURN 0;
END
GO
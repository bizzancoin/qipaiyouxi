----------------------------------------------------------------------------------------------------
-- 用途：添加自定义头像
----------------------------------------------------------------------------------------------------

USE RYAccountsDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].NET_PW_InsertCustomFace') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].NET_PW_InsertCustomFace
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- 添加自定义头像
CREATE PROCEDURE NET_PW_InsertCustomFace
	@dwUserID INT,								-- 用户 I D
	@imgCustomFace IMAGE,						-- 头像数据
	@strClientIP NVARCHAR(15),					-- 客户端IP
	@strMachineID NVARCHAR(32),					-- 机器码
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 账户信息
DECLARE @UserID INT
DECLARE @StunDown BIT
DECLARE @Nullity BIT
DECLARE @CustomID INT
DECLARE @FaceID INT

-- 执行逻辑
BEGIN
	-- 查询用户
	SELECT @UserID=UserID,@FaceID=FaceID,@Nullity=Nullity,@StunDown=StunDown FROM AccountsInfo(NOLOCK) WHERE UserID=@dwUserID

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

	-- 帐号关闭
	IF @StunDown<>0
	BEGIN
		SET @strErrorDescribe=N'您的帐号使用了安全关闭功能，必须重新开通后才能继续使用！'
		RETURN 3
	END	

	-- 保存头像
	INSERT INTO AccountsFace(UserID,CustomFace,InsertAddr,InsertMachine) VALUES(@dwUserID,@imgCustomFace,@strClientIP,@strMachineID)
	SELECT @CustomID=@@IDENTITY
	UPDATE AccountsInfo SET CustomID=@CustomID WHERE UserID=@dwUserID
	SET @strErrorDescribe=N'上传头像成功'
	
	SELECT @UserID AS UserID,@CustomID AS CustomID,@FaceID AS FaceID
END

RETURN 0
GO
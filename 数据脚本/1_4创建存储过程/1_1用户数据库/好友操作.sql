
----------------------------------------------------------------------------------------------------

USE RYAccountsDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_AddUserFriend]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_AddUserFriend]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_DeleteUserFriend]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_DeleteUserFriend]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------
-- 添加好友
CREATE PROC GSP_GP_AddUserFriend
	@dwUserID INT,								-- 用户 I D
	@dwDestUserID INT,							-- 用户 I D
	@cbGroupID SMALLINT,						-- 组别标识
	@cbDestGroupID SMALLINT,					-- 组别标识
	@cbLoadUserInfo TINYINT,					-- 加载标识
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN

	-- 存在判断
	IF Exists(SELECT * FROM AccountsRelation WHERE MainUserID=@dwUserID AND SubUserID=@dwDestUserID)
	BEGIN
		UPDATE AccountsRelation SET GroupID=@cbGroupID WHERE MainUserID=@dwUserID AND SubUserID=@dwDestUserID
	END
	ELSE BEGIN
		INSERT INTO AccountsRelation VALUES(@dwUserID,@dwDestUserID,@cbGroupID)		
	END

	-- 存在判断
	IF Exists(SELECT * FROM AccountsRelation WHERE MainUserID=@dwDestUserID AND SubUserID=@dwUserID)
	BEGIN
		UPDATE AccountsRelation SET GroupID=@cbDestGroupID WHERE MainUserID=@dwDestUserID AND SubUserID=@dwUserID
	END
	ELSE BEGIN
		INSERT INTO AccountsRelation VALUES(@dwDestUserID,@dwUserID,@cbGroupID)		
	END

	-- 加载用户信息
	IF @cbLoadUserInfo=1 
	BEGIN
		-- 查询信息
		SELECT a.UserID,a.NickName,a.FaceID,a.CustomID,a.Gender,a.MemberOrder,a.GrowLevelID AS GrowLevel,a.UnderWrite,a.Compellation,b.GroupID
		FROM AccountsInfo a,AccountsRelation b WHERE MainUserID=@dwUserID AND SubUserID=@dwDestUserID
	END
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------
-- 删除好友
CREATE PROC GSP_GP_DeleteUserFriend
	@dwUserID INT,								-- 用户 I D
	@dwDestUserID INT,							-- 用户 I D
	@cbGroupID SMALLINT,						-- 组别标识
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN
	
	-- 变量定义
	DECLARE @UserID INT
	DECLARE @Nullity BIT
	DECLARE @LogonPass AS NCHAR(32)

	-- 查询用户
	SELECT @UserID=UserID, @LogonPass=LogonPass, @Nullity=Nullity
	FROM AccountsInfo(NOLOCK) WHERE UserID=@dwUserID

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
	

	-- 移除好友
	DECLARE @cbMainGroupID SMALLINT
	SELECT @cbMainGroupID=GroupID FROM AccountsRelation WHERE MainUserID=@dwDestUserID AND SubUserID=@dwUserID
	DELETE AccountsRelation WHERE MainUserID=@dwUserID AND SubUserID=@dwDestUserID
	DELETE AccountsRelation WHERE MainUserID=@dwDestUserID AND SubUserID=@dwUserID

	SET @strErrorDescribe=N'移除成功！'


END

RETURN 0

GO

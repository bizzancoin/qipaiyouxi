
----------------------------------------------------------------------
-- 时间：2011-09-26
-- 用途：管理员登录
----------------------------------------------------------------------
USE RYPlatformManagerDB
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[NET_PM_UserLogon]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[NET_PM_UserLogon]
GO
-----------------------------------------------------------------------
CREATE PROC [NET_PM_UserLogon]
	@strUserName		NVARCHAR(31),					-- 管理员帐号
	@strPassword		NCHAR(32),						-- 登录密码
	@strClientIP		NVARCHAR(15),					-- 登录IP
	@strErrorDescribe	NVARCHAR(127) OUTPUT			-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN	

	-- 用户存在
	IF @strUserName IS NULL OR @strUserName=N'' OR @strPassword IS NULL OR @strPassword=N''
	BEGIN
		SET @strErrorDescribe = N'抱歉！您的管理帐号不存在或者密码输入有误，请查证后再次尝试登录。'
		RETURN 100
	END		
	IF NOT EXISTS (SELECT * FROM Base_Users WHERE UserName=@strUserName AND [Password]=@strPassword)
	BEGIN
		SET @strErrorDescribe = N'抱歉！您的管理帐号不存在或者密码输入有误，请查证后再次尝试登录。'
		RETURN 100
	END 
	
	DECLARE @IsBand INT 
	DECLARE @BandIP NVARCHAR(15)
	DECLARE @Nullity INT 
	
	SELECT @IsBand=IsBand,@BandIP=BandIP,@Nullity=Nullity FROM Base_Users WHERE UserName=@strUserName
	
	IF @IsBand = 0 AND @BandIP <> @strClientIP
	BEGIN
		SET @strErrorDescribe = N'抱歉！您的管理帐号已经绑定指定的IP地址登录！'
		RETURN 101
	END
	-- 帐号禁止
	IF @Nullity<>0
	BEGIN
		SET @strErrorDescribe = N'抱歉！您的帐号已被禁止使用，请联系管理员了解详细情况。'
		RETURN 102
	END
	-- 更新登录
	UPDATE Base_Users SET LoginTimes=LoginTimes+1,PreLogintime=LastLogintime,PreLoginIP=LastLoginIP, LastLoginTime=GETDATE(),LastLoginIP=@strClientIP
	WHERE UserName=@strUserName
	-- 记录日志
	INSERT dbo.SystemSecurity
	        ( OperatingTime ,
	          OperatingName ,
	          OperatingIP ,
	          OperatingAccounts
	        )
	VALUES  ( GETDATE() , -- OperatingTime - datetime
	          '登录' , -- OperatingName - nvarchar(50)
	          @strClientIP , -- OperatingIP - nvarchar(50)
	          @strUserName  -- OperatingAccounts - nvarchar(50)
	        )
	-- 输出
	SELECT a.* FROM Base_Users a INNER JOIN dbo.Base_Roles b ON a.RoleID=b.RoleID
	WHERE a.UserName=@strUserName	
	
END
RETURN 0
GO
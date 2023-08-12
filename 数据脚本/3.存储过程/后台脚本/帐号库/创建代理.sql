----------------------------------------------------------------------
-- 时间：2015-10-10
-- 用途：后台管理员添加代理用户
----------------------------------------------------------------------
USE RYAccountsDB
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[NET_PM_AddAgent]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[NET_PM_AddAgent]
GO

----------------------------------------------------------------------
CREATE PROC [NET_PM_AddAgent]
(
	@dwUserID			INT,					--用户标识
	@strCompellation	NVARCHAR(16),			--代理姓名
	@strDomain			NCHAR(50),				--代理域名
	@dwAgentType		INT,					--分成类型
	@dcAgentScale		DECIMAL(18,3),			--分成比例
	@dwPayBackScore		BIGINT ,				--日累计充值返现
	@dcPayBackScale		DECIMAL(18,3),			--返现比例
	@strMobilePhone		NVARCHAR(16),			--联系电话
	@strEMail			NVARCHAR(32),			--电子邮箱
	@strDwellingPlace	NVARCHAR(128),			--详细地址
	@dwNullity			TINYINT,				--冻结状态
	@strAgentNote		NVARCHAR(200),			--备注

	@strErrorDescribe NVARCHAR(127) OUTPUT		--输出信息
)

WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 用户信息
DECLARE @UserID INT
DECLARE @Nullity TINYINT

BEGIN
	-- 查询用户	
	SELECT @UserID=UserID,@Nullity=Nullity FROM AccountsInfo(NOLOCK) WHERE UserID=@dwUserID

	-- 用户存在
	IF @UserID IS NULL
	BEGIN
		SET @strErrorDescribe=N'您的帐号不存在，请查证后再次尝试！'
		RETURN 100
	END	

	-- 帐号禁止
	IF @Nullity<>0
	BEGIN
		SET @strErrorDescribe=N'您的帐号暂时处于冻结状态，请联系客服中心了解详细情况！'
		RETURN 101
	END	

	-- 查询代理重复信息
	IF EXISTS(SELECT AgentID FROM AccountsAgent WHERE UserID=@dwUserID)
	BEGIN
		SET @strErrorDescribe=N'代理已存在，不能重复添加！'
		RETURN 102
	END

	-- 查询代理域名重复信息
	IF EXISTS(SELECT AgentID FROM AccountsAgent WHERE Domain=@strDomain)
	BEGIN
		SET @strErrorDescribe=N'代理域名已存在，不能重复添加！'
		RETURN 103
	END

	-- 代理信息
	INSERT INTO AccountsAgent(UserID,Compellation,Domain,AgentType,AgentScale,PayBackScore,PayBackScale,MobilePhone,EMail,DwellingPlace,Nullity,AgentNote)
	VALUES(@dwUserID,@strCompellation,@strDomain,@dwAgentType,@dcAgentScale,@dwPayBackScore,@dcPayBackScale,@strMobilePhone,@strEMail,@strDwellingPlace,@dwNullity,@strAgentNote)

	-- 设置用户
	IF @@ERROR=0 
	BEGIN
		UPDATE AccountsInfo SET AgentID=SCOPE_IDENTITY() WHERE UserID = @dwUserID
		SET @strErrorDescribe=N'恭喜您！代理用户创建成功。'
		RETURN 0
	END
	ELSE
	BEGIN
		SET @strErrorDescribe=N'代理用户创建失败。'
		RETURN 112
	END
END

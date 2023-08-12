----------------------------------------------------------------------
-- 时间：2010-03-16
-- 用途：赠送靓号
----------------------------------------------------------------------
USE RYRecordDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[WSP_PM_GrantGameID]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[WSP_PM_GrantGameID]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO
----------------------------------------------------------------------


CREATE PROCEDURE WSP_PM_GrantGameID
	@MasterID INT,								-- 管理员标识
	@UserID INT,								-- 用户标识
	@ReGameID INT,								-- 赠送ID
	@ClientIP VARCHAR(15),						-- 赠送地址
	@Reason NVARCHAR(32)						-- 赠送原因
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 用户信息
DECLARE @CurGameID BIGINT
DECLARE @dwUserID INT

-- 保留ID信息
DECLARE @dwGameID INT
DECLARE @IDLevel INT

-- 返回参数
DECLARE @ReturnValue NVARCHAR(127)

-- 执行逻辑
BEGIN
	
	-- 获取用户游戏ID
	SELECT @CurGameID = GameID FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo
	WHERE UserID = @UserID

	-- 判断
	SELECT @dwGameID = GameID,@IDLevel = IDLevel FROM RYAccountsDBLink.RYAccountsDB.dbo.ReserveIdentifier
	WHERE GameID = @ReGameID
	IF @dwGameID IS NULL
	BEGIN
		SET @ReturnValue = N'赠送的靓号不存在！'
		SELECT @ReturnValue
		RETURN 1
	END

	SELECT @dwUserID = UserID FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo
	WHERE GameID = @ReGameID
	IF @dwUserID IS NOT NULL
	BEGIN
		SET @ReturnValue = N'赠送的靓号已被使用，请更换！'
		SELECT @ReturnValue
		RETURN 2
	END	

	-- 新增记录
	INSERT INTO RecordGrantGameID(MasterID,UserID,CurGameID,ReGameID,IDLevel,ClientIP,Reason)
	VALUES(@MasterID,@UserID,@CurGameID,@ReGameID,@IDLevel,@ClientIP,@Reason)

	-- 更新保留表
	UPDATE RYAccountsDBLink.RYAccountsDB.dbo.ReserveIdentifier SET Distribute = 1 
	WHERE GameID = @ReGameID

	-- 更新用户表
	UPDATE RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo SET GameID = @ReGameID
	WHERE UserID = @UserID

	SELECT @ReturnValue
END
RETURN 0
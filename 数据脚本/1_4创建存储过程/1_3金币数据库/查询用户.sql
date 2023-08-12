----------------------------------------------------------------------------------------------------

USE RYTreasureDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_QueryTransferUserInfo]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_QueryTransferUserInfo]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON
GO

----------------------------------------------------------------------------------------------------
-- 查询用户
CREATE PROC GSP_GR_QueryTransferUserInfo
	@cbByNickName INT,                          -- 昵称标志
	@strAccounts NVARCHAR(31),					-- 用户帐号
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 基本信息
DECLARE @Score BIGINT
DECLARE @Insure BIGINT
DECLARE @ServerID SMALLINT

-- 执行逻辑
BEGIN

	-- 目标用户
	DECLARE @TargetGameID INT
	DECLARE @Accounts NVARCHAR(31)	
	IF @cbByNickName=1
		SELECT @TargetGameID=GameID, @Accounts=NickName FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo WHERE NickName=@strAccounts
	ELSE
		SELECT @TargetGameID=GameID, @Accounts=NickName FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo WHERE GameID=@strAccounts

	-- 查询用户
	IF @TargetGameID IS NULL
	BEGIN
		SET @strErrorDescribe=N'您所要转账的用户“'+@strAccounts+'”不存在或者输入有误，请查证后再次尝试！'
		RETURN 5
	END

	-- 输出结果
	SELECT @TargetGameID AS GameID, @Accounts AS Accounts

END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

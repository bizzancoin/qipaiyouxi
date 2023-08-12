----------------------------------------------------------------------
-- 时间：2010-03-16
-- 用途：赠送经验
----------------------------------------------------------------------

USE RYTreasureDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[WSP_PM_GetRecordDrawScoreByDrawID]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[WSP_PM_GetRecordDrawScoreByDrawID]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO
----------------------------------------------------------------------
CREATE PROCEDURE WSP_PM_GetRecordDrawScoreByDrawID
		@dwDrawID		INT			-- 局ID
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 用户经验
DECLARE @CurExperience INT
	
-- 执行逻辑
BEGIN
	SELECT A.*,B.Accounts,B.Accounts,B.NickName,B.GameID,B.IsAndroid FROM RecordDrawScore AS A 
	Left JOIN RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo AS B
	ON A.UserID=B.UserID
	WHERE DrawID=@dwDrawID
END
RETURN 0

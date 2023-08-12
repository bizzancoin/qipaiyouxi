-- =============================================
-- 用途: 查询指定玩家的代理玩家（代理的分成类型为税收分成）。
-- =============================================
USE RYAccountsDB
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WF_GetAccountParent]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION dbo.WF_GetAccountParent
GO

----------------------------------------------------------------
CREATE FUNCTION [dbo].[WF_GetAccountParent] 
(
	@dwUserID INT = 0	--用户标识
)
RETURNS 
@tbAccountInfo TABLE 
(
	ParentID INT ,
	Scale DECIMAL(18,2)
)
WITH ENCRYPTION AS

BEGIN
	INSERT  INTO  @tbAccountInfo 
		SELECT  a.SpreaderID,b.AgentScale FROM AccountsInfo a INNER JOIN AccountsAgent b ON a.SpreaderID=b.UserID WHERE a.UserID = @dwUserID AND b.AgentType=2 AND b.Nullity=0
	
	RETURN 
END
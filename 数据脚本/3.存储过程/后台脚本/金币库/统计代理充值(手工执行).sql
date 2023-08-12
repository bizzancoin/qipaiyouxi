----------------------------------------------------------------------
-- 用途：用途：作为紧急处理。统计代理充值，只针对昨天的数据进行统计。
-- 描述：在断电或维护时，忘记开启作业执行，导致代理充值没有及时统计，则需要手工执行此存储过程。
--		 NOT IN语句中加上“UserID=a.UserID”条件是为了可以重复的执行此存储过程。
----------------------------------------------------------------------
USE RYTreasureDB
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].WSP_PM_StatAgentPayHand') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].WSP_PM_StatAgentPayHand
GO

----------------------------------------------------------------------
CREATE PROC WSP_PM_StatAgentPayHand
			
WITH ENCRYPTION AS

BEGIN
	-- 属性设置
	SET NOCOUNT ON;
	DECLARE @DateID INT
	SET @DateID = CAST(CAST(DateAdd(d,-1,GETDATE()) AS FLOAT) AS INT)
	
	INSERT RecordAgentInfo	
	SELECT	a.DateID,a.UserID,b.AgentScale,b.PayBackScale,2,a.PayScore,a.PayScore*b.PayBackScale,0,0,GETDATE(),'',''			
	FROM  StreamAgentPayInfo a CROSS APPLY
	(        
		SELECT PayBackScore,PayBackScale,AgentScale FROM RYAccountsDB.dbo.AccountsAgent WHERE UserID=a.UserID

	) AS b WHERE a.PayScore>=b.PayBackScore AND a.DateID<=@DateID AND a.DateID NOT IN (SELECT DateID FROM RecordAgentInfo WHERE DateID=a.DateID AND TypeID=2 AND UserID=a.UserID)
END
 
 
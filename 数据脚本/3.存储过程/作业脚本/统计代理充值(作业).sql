----------------------------------------------------------------------
-- 用途：统计代理充值，只针对昨天的数据进行统计。
-- 描述：作业执行
----------------------------------------------------------------------
USE RYTreasureDB
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].WSP_PM_StatAgentPay') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].WSP_PM_StatAgentPay
GO

----------------------------------------------------------------------
CREATE PROC WSP_PM_StatAgentPay
			
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

	) AS b WHERE a.PayScore>=b.PayBackScore AND a.DateID=@DateID AND a.DateID NOT IN (SELECT DateID FROM RecordAgentInfo WHERE DateID=a.DateID AND TypeID=2)
END
 
 
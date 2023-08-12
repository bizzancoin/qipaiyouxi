----------------------------------------------------------------------
-- 用途：统计玩家税收，只针对昨天的数据进行统计。
-- 描述：作业执行
----------------------------------------------------------------------
USE RYTreasureDB
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].WSP_PM_StatAccountRevenue') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].WSP_PM_StatAccountRevenue
GO

----------------------------------------------------------------------
CREATE PROC WSP_PM_StatAccountRevenue
			
WITH ENCRYPTION AS

BEGIN
	-- 属性设置
	SET NOCOUNT ON;
	DECLARE @DateID INT
	SET @DateID = CAST(CAST(DateAdd(d,-1,GETDATE()) AS FLOAT) AS INT)
	
	INSERT RecordUserRevenue
	SELECT	a.DateID,a.UserID,a.Revenue,ISNULL(b.ParentID,0),ISNULL(b.Scale,0),a.Revenue*ISNULL(b.Scale,0),			
			(CASE WHEN b.ParentID > 0 THEN (1-b.Scale) ELSE 1 END) AS CompanyScale,
			(CASE WHEN b.ParentID > 0 THEN (a.Revenue-a.Revenue*ISNULL(b.Scale,0)) ELSE a.Revenue END),GETDATE()
	FROM  StreamScoreInfo a CROSS APPLY
	(        
		SELECT * FROM RYAccountsDB.dbo.WF_GetAccountParent(a.userid)	

	) AS b WHERE a.Revenue>0 AND a.DateID=@DateID AND a.DateID NOT IN (SELECT DateID FROM RecordUserRevenue WHERE DateID=a.DateID )
END
 
 
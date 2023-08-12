----------------------------------------------------------------------
-- 版权：2011
-- 时间：2011-09-20
-- 用途：分页显示单个用户下所有被推荐人的推广信息
----------------------------------------------------------------------
USE RYTreasureDB
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].NET_PW_GetAllChildrenInfoByUserID') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].NET_PW_GetAllChildrenInfoByUserID
GO

----------------------------------------------------------------------
CREATE PROC NET_PW_GetAllChildrenInfoByUserID
	@dwUserID		INT,				--	用户标识
	@dwPageSize		INT=10 ,			--每页记录条数
	@dwPageIndex	INT=1 				--当前页码		
WITH ENCRYPTION AS

BEGIN
	-- 属性设置
	SET NOCOUNT ON;
	
	--定义变量
	DECLARE @dwStart INT,@dwEnd INT		
	DECLARE @Record INT;
	
	--计算页数	
	SET  @dwStart = (@dwPageIndex - 1)*@dwPageSize + 1;
	SET  @dwEnd = @dwPageSize * @dwPageIndex;
	
	SELECT @Record=COUNT(DISTINCT(ChildrenID)) FROM RecordSpreadInfo WHERE UserID = @dwUserID AND ChildrenID <> 0 
	SELECT @Record AS Records
	SELECT Score,ChildrenID,CollectDate FROM (
		SELECT ROW_NUMBER() OVER(ORDER BY ChildrenID DESC) AS TempID,SUM(Score) AS Score, ChildrenID, min(CollectDate) AS CollectDate
		FROM RecordSpreadInfo 
		WHERE UserID = @dwUserID AND ChildrenID <> 0 GROUP BY ChildrenID) AS TC
	WHERE TC.TempID BETWEEN @dwStart AND @dwEnd
	
END


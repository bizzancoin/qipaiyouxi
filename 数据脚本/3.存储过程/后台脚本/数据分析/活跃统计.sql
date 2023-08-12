----------------------------------------------------------------------
-- 时间：2011-10-11
-- 用途：活跃用户统计
----------------------------------------------------------------------
USE [RYTreasureDB]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[WSP_PM_StatActiveUserTotalByDay]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[WSP_PM_StatActiveUserTotalByDay]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[WSP_PM_StatActiveUserTotalByMonth]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[WSP_PM_StatActiveUserTotalByMonth]
GO

----------------------------------------------------------------------
CREATE PROC [WSP_PM_StatActiveUserTotalByDay]
(
	@StartDateID	INT,				-- 日统计起始时间
	@EndDateID		INT					-- 日统计结束时间
)
			
WITH ENCRYPTION AS

BEGIN
	-- 属性设置
	SET NOCOUNT ON

	-- 活跃人数
	DECLARE @DayActiveOnlineTime INT	-- 日活跃时长
	SET @DayActiveOnlineTime=60*60		-- 1小时
	
	SELECT COUNT(UserID) AS UserTotal,DateID FROM StreamScoreInfo
	WHERE OnlineTimeCount>@DayActiveOnlineTime AND DateID>=@StartDateID AND DateID<=@EndDateID
	GROUP BY DateID ORDER BY DateID ASC
	
END
GO

----------------------------------------------------------------------
CREATE PROC [WSP_PM_StatActiveUserTotalByMonth]

WITH ENCRYPTION AS

BEGIN
	-- 属性设置
	SET NOCOUNT ON

	-- 活跃人数
	DECLARE @MonthActiveOnlineTime INT		-- 月活跃时长
	SET @MonthActiveOnlineTime=40*60*60		-- 40小时		
	
	SELECT COUNT(UserID) AS UserTotal,UserID,CONVERT(VARCHAR(7),LastCollectDate,120) AS StatDate,Sum(CONVERT(BIGINT,OnlineTimeCount)) as TimeCount FROM StreamScoreInfo
	GROUP BY UserID,CONVERT(VARCHAR(7),LastCollectDate,120) HAVING Sum(CONVERT(BIGINT,OnlineTimeCount))>=@MonthActiveOnlineTime
	
END
GO




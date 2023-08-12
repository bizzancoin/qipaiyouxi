----------------------------------------------------------------------
-- 时间：2010-03-16
-- 用途：在线统计
----------------------------------------------------------------------

USE RYPlatformDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[WSP_PM_StatOnLineStream]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[WSP_PM_StatOnLineStream]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------

CREATE PROCEDURE WSP_PM_StatOnLineStream
	@year nvarchar(4),		-- 年
	@month nvarchar(2),		-- 月
	@day nvarchar(2)		-- 日
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN
	IF @month = '-1'-- 按年统计 
	BEGIN
		SELECT	CONVERT(varchar(7),InsertDateTime, 120) as InsertDateTime,
				MAX(OnLineCountSum) AS MaxCount,MIN(OnLineCountSum) AS MinCount,
				CONVERT(INT,ROUND(AVG(OnLineCountSum*1.0),0)) AS AvgCount
		FROM OnLineStreamInfo
		WHERE YEAR(InsertDateTime) = @year 
		GROUP BY CONVERT(varchar(7),InsertDateTime, 120) ORDER BY InsertDateTime ASC
	END
	ELSE IF @day = '-1'-- 按月统计
	BEGIN
		SELECT	CONVERT(varchar(10),InsertDateTime, 120) as InsertDateTime,
				MAX(OnLineCountSum) AS MaxCount,MIN(OnLineCountSum) AS MinCount,
				CONVERT(INT,ROUND(AVG(OnLineCountSum*1.0),0)) AS AvgCount
		FROM OnLineStreamInfo
		WHERE CONVERT(varchar(7),InsertDateTime, 120) = @year+'-'+@month
		GROUP BY CONVERT(varchar(10),InsertDateTime, 120) ORDER BY InsertDateTime ASC
	END
	ELSE -- 按日统计
		SELECT	DATEPART(hh,InsertDateTime) AS InsertDateTime,
				MAX(OnLineCountSum) AS MaxCount,MIN(OnLineCountSum) AS MinCount,
				CONVERT(INT,ROUND(AVG(OnLineCountSum*1.0),0)) AS AvgCount
		FROM OnLineStreamInfo
		WHERE CONVERT(varchar(10),InsertDateTime, 120) = @year+'-'+@month+'-'+@day
		GROUP BY DATEPART(hh,InsertDateTime) ORDER BY InsertDateTime ASC
END
RETURN 0

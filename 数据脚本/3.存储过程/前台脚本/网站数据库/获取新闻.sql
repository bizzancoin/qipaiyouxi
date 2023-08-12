----------------------------------------------------------------------
-- 版权：2011
-- 时间：2011-09-22
-- 用途：获取上一条或下一条新闻
----------------------------------------------------------------------
USE RYNativeWebDB
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].NET_PW_GetNewsInfoByID') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].NET_PW_GetNewsInfoByID
GO

----------------------------------------------------------------------
CREATE PROC NET_PW_GetNewsInfoByID
	@dwNewsID		INT,				--	新闻标识
	@dwMode		INT=1 			-- 上下的标识
WITH ENCRYPTION AS

BEGIN
	-- 属性设置
	SET NOCOUNT ON;
	
	--定义变量
	DECLARE @TempID INT

	SELECT @TempID = TempID FROM (
		SELECT ROW_NUMBER() OVER(ORDER By OnTopAll DESC,OnTop DESC,IssueDate DESC ,NewsID DESC) AS TempID, * 
		FROM News
		WHERE IsLock=1 AND IsDelete=0) AS TC
	WHERE NewsID = @dwNewsID
	
	IF @dwMode=1
	BEGIN
		SELECT NewsID, PopID, Subject, Subject1, OnTop, OnTopAll, IsElite, IsHot, IsLock, IsDelete, IsLinks, LinkUrl, Body, FormattedBody, HighLight, ClassID, UserID, IssueIP, LastModifyIP, IssueDate, LastModifyDate FROM (
			SELECT ROW_NUMBER() OVER(ORDER By OnTopAll DESC,OnTop DESC,IssueDate DESC ,NewsID DESC) AS TempID, * 
			FROM News
			WHERE IsLock=1 AND IsDelete=0) AS TC
		WHERE TC.TempID = @TempID - 1
	END
	ELSE IF @dwMode=2
	BEGIN
		SELECT NewsID, PopID, Subject, Subject1, OnTop, OnTopAll, IsElite, IsHot, IsLock, IsDelete, IsLinks, LinkUrl, Body, FormattedBody, HighLight, ClassID, UserID, IssueIP, LastModifyIP, IssueDate, LastModifyDate FROM (
			SELECT ROW_NUMBER() OVER(ORDER By OnTopAll DESC,OnTop DESC,IssueDate DESC ,NewsID DESC) AS TempID, * 
			FROM News
			WHERE IsLock=1 AND IsDelete=0) AS TC
		WHERE TC.TempID = @TempID + 1
	END
END


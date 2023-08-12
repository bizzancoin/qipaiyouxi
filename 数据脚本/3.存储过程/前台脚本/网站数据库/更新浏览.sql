----------------------------------------------------------------------------------------------------
-- 版权：2011
-- 时间：2011-09-06
-- 用途：更新浏览量
----------------------------------------------------------------------------------------------------
USE RYNativeWebDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].NET_PW_UpdateViewCount') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].NET_PW_UpdateViewCount
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------
-- 更新浏览量
CREATE PROCEDURE NET_PW_UpdateViewCount

	-- 验证信息
	@dwFeedbackID		NCHAR(32)					-- 反馈标识

WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN	
	
	UPDATE GameFeedbackInfo SET ViewCount = ViewCount+1 WHERE FeedbackID=@dwFeedbackID
	
END

SET NOCOUNT OFF

RETURN 0

GO
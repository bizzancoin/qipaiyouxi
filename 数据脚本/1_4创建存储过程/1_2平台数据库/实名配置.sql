
----------------------------------------------------------------------------------------------------

USE RYPlatformDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_LoadRealAuth]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_LoadRealAuth]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO
----------------------------------------------------------------------------------------------------
-- 加载奖励
CREATE PROC GSP_GP_LoadRealAuth
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN

	--查询奖励
	DECLARE @AuthRealAward AS BIGINT
	SELECT @AuthRealAward=StatusValue FROM RYAccountsDBLink.RYAccountsDB.dbo.SystemStatusInfo WHERE StatusName=N'AuthentPresent'
	
	DECLARE @AuthentDisable AS BIGINT
	SELECT @AuthentDisable=StatusValue FROM RYAccountsDBLink.RYAccountsDB.dbo.SystemStatusInfo WHERE StatusName=N'AuthentDisable'	
	-- 抛出数据
	SELECT @AuthRealAward AS AuthRealAward ,@AuthentDisable AS AuthentDisable
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------
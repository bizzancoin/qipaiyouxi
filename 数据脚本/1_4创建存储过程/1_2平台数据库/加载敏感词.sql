
----------------------------------------------------------------------------------------------------

USE RYPlatformDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_LoadSensitiveWords]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_LoadSensitiveWords]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

--读取系统消息
CREATE  PROCEDURE dbo.GSP_GR_LoadSensitiveWords 
WITH ENCRYPTION AS

--设置属性
SET NOCOUNT ON

SELECT ForbidWords AS SensitiveWords FROM SensitiveWords

RETURN 0

GO

----------------------------------------------------------------------------------------------------

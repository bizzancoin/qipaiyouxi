
----------------------------------------------------------------------------------------------------

USE RYTreasureDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_GameColumnItem]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_GameColumnItem]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

--º”‘ÿ√Ë ˆ
CREATE  PROCEDURE dbo.GSP_GR_GameColumnItem 
WITH ENCRYPTION AS

--…Ë÷√ Ù–‘
SET NOCOUNT ON

--≤È—Ø√Ë ˆ
SELECT * FROM GameColumnItem ORDER BY SortID

RETURN 0

GO

----------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------

USE RYPlatformDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GS_LoadDataBaseInfo]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GS_LoadDataBaseInfo]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- 连接信息
CREATE PROCEDURE GSP_GS_LoadDataBaseInfo
	@strDataBaseAddr NVARCHAR(15)				-- 列表索引
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 基本信息
DECLARE @DBPort INT
DECLARE @DBAddr NVARCHAR(15)
DECLARE @DBName NVARCHAR(32)

-- 连接信息
DECLARE @DBUser NVARCHAR(512)
DECLARE @DBPassword NVARCHAR(512)

-- 执行逻辑
BEGIN

	-- 查询信息
	SELECT @DBPort=DBPort, @DBAddr=DBAddr, @DBUser=DBUser, @DBPassword=DBPassword FROM DataBaseInfo(NOLOCK)
	WHERE DBAddr=@strDataBaseAddr
	
	-- 存在判断
	IF @@ROWCOUNT=0
	BEGIN
		SELECT N'数据库连接信息不存在，请检查 RYPlatformDB 数据库的 DataBaseInfo 表数据' AS [ErrorDescribe]
		RETURN 1
	END
	
	-- 输出变量
	SELECT @DBPort AS DBPort, @DBAddr AS DBAddr, @DBUser AS DBUser, @DBPassword AS DBPassword
	
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

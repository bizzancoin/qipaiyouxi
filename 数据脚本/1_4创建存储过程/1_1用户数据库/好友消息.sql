
----------------------------------------------------------------------------------------------------

USE RYAccountsDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_SaveOfflineMessage]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_SaveOfflineMessage]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_LoadOfflineMessage]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_LoadOfflineMessage]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- 存储消息
CREATE PROC GSP_GP_SaveOfflineMessage
	@dwUserID INT,								-- 用户 I D
	@wMessageType SMALLINT,						-- 消息类型
	@wDataSize INT,								-- 数据大小
	@szOfflineData varchar(2400),				-- 离线数据	
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN
	-- 插入数据
	INSERT OfflineMessage VALUES(@dwUserID,@wMessageType,@szOfflineData,@wDataSize)
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

-- 修改密码
CREATE PROC GSP_GP_LoadOfflineMessage
	@dwUserID INT,								-- 用户 I D
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN
	-- 查询数据
	SELECT MessageType,DataSize,OfflineData FROM OfflineMessage WHERE UserID=@dwUserID

	-- 删除数据
    DELETE OfflineMessage WHERE UserID=@dwUserID
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

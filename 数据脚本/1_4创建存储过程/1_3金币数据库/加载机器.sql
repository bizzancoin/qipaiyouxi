
----------------------------------------------------------------------------------------------------

USE RYTreasureDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'dbo.GSP_GR_LoadAndroidUser') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE dbo.GSP_GR_LoadAndroidUser
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'dbo.GSP_GR_UnLockAndroidUser') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE dbo.GSP_GR_UnLockAndroidUser
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- 加载机器
CREATE PROC GSP_GR_LoadAndroidUser
	@wServerID	SMALLINT,					-- 房间标识
	@dwBatchID	INT,						-- 批次标识
	@dwAndroidCount INT,						-- 机器数目
	@dwAndroidCountMember0 INT,					-- 普通会员	
	@dwAndroidCountMember1 INT,					-- 一级会员
	@dwAndroidCountMember2 INT,					-- 二级会员
	@dwAndroidCountMember3 INT,					-- 三级会员
	@dwAndroidCountMember4 INT,					-- 四级会员
	@dwAndroidCountMember5 INT					-- 五级会员
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN

	-- 变量定义	
	DECLARE	@return_value int

	EXEC @return_value = RYAccountsDBLink.RYAccountsDB.dbo.GSP_GR_LoadAndroidUser
		 @wServerID = @wServerID,
		 @dwBatchID = @dwBatchID,
		 @dwAndroidCount = @dwAndroidCount,
		 @dwAndroidCountMember0=@dwAndroidCountMember0,
		 @dwAndroidCountMember1=@dwAndroidCountMember1,
		 @dwAndroidCountMember2=@dwAndroidCountMember2,
		 @dwAndroidCountMember3=@dwAndroidCountMember3,
		 @dwAndroidCountMember4=@dwAndroidCountMember4,
		 @dwAndroidCountMember5=@dwAndroidCountMember5
		 

	RETURN @return_value
END

GO

----------------------------------------------------------------------------------------------------

-- 解锁机器
CREATE PROC GSP_GR_UnlockAndroidUser
	@wServerID	SMALLINT,					-- 房间标识	
	@wBatchID	SMALLINT					-- 批次标识	
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN

	-- 变量定义	
	DECLARE	@return_value int

	EXEC @return_value = RYAccountsDBLink.RYAccountsDB.dbo.GSP_GR_UnlockAndroidUser 
		 @wServerID=@wServerID,
		 @wBatchID=@wBatchID

	RETURN @return_value

END

GO
----------------------------------------------------------------------------------------------------
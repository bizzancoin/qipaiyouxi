
----------------------------------------------------------------------------------------------------

USE RYAccountsDB
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
	@wServerID	SMALLINT,						-- 房间标识
	@dwBatchID	INT,							-- 批次标识
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
	-- 参数校验
	IF @wServerID=0 OR @dwBatchID=0 OR @dwAndroidCount=0 
	BEGIN
		RETURN 1
	END

	-- 开始事务
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
	BEGIN TRAN

	-- 解锁机器
	UPDATE AndroidLockInfo SET AndroidStatus=0,ServerID=0,BatchID=0 
	WHERE DATEDIFF(hh,LockDateTime,GetDate())>=12	

	-- 查询机器
	SELECT UserID,LogonPass INTO #TempAndroids FROM AndroidLockInfo(NOLOCK)
	WHERE UserID IN (SELECT TOP (@dwAndroidCountMember0) UserID FROM AndroidLockInfo(NOLOCK) WHERE AndroidStatus=0 AND ServerID=0 AND MemberOrder=0 ORDER BY NEWID()) 
	

	-- 查询机器
	INSERT INTO #TempAndroids(UserID,LogonPass) SELECT UserID,LogonPass FROM AndroidLockInfo(NOLOCK)
	WHERE UserID IN (SELECT TOP (@dwAndroidCountMember1) UserID FROM AndroidLockInfo(NOLOCK) WHERE AndroidStatus=0 AND ServerID=0 AND MemberOrder=1 ORDER BY NEWID()) 
	

	-- 查询机器
	INSERT INTO #TempAndroids(UserID,LogonPass) SELECT UserID,LogonPass FROM AndroidLockInfo(NOLOCK)
	WHERE UserID IN (SELECT TOP (@dwAndroidCountMember2) UserID FROM AndroidLockInfo(NOLOCK) WHERE AndroidStatus=0 AND ServerID=0 AND MemberOrder=2 ORDER BY NEWID()) 
	
	
	-- 查询机器
	INSERT INTO #TempAndroids(UserID,LogonPass) SELECT UserID,LogonPass FROM AndroidLockInfo(NOLOCK)
	WHERE UserID IN (SELECT TOP (@dwAndroidCountMember3) UserID FROM AndroidLockInfo(NOLOCK) WHERE AndroidStatus=0 AND ServerID=0 AND MemberOrder=3 ORDER BY NEWID()) 
	
	
	-- 查询机器
	INSERT INTO #TempAndroids(UserID,LogonPass) SELECT UserID,LogonPass FROM AndroidLockInfo(NOLOCK)
	WHERE UserID IN (SELECT TOP (@dwAndroidCountMember4) UserID FROM AndroidLockInfo(NOLOCK) WHERE AndroidStatus=0 AND ServerID=0 AND MemberOrder=4 ORDER BY NEWID()) 
	

	-- 查询机器
	INSERT INTO #TempAndroids(UserID,LogonPass) SELECT UserID,LogonPass FROM AndroidLockInfo(NOLOCK)
	WHERE UserID IN (SELECT TOP (@dwAndroidCountMember5) UserID FROM AndroidLockInfo(NOLOCK) WHERE AndroidStatus=0 AND ServerID=0 AND MemberOrder=5 ORDER BY NEWID()) 
	
					
	-- 更新状态
	UPDATE AndroidLockInfo SET AndroidStatus=1,BatchID=@dwBatchID,ServerID=@wServerID,LockDateTime=GetDate() 
	FROM AndroidLockInfo a,#TempAndroids b WHERE a.UserID = b.UserID

	-- 结束事务
	COMMIT TRAN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED	

	-- 查询机器
	SELECT * FROM #TempAndroids

	-- 销毁临时表	
	IF OBJECT_ID('tempdb..#TempAndroids') IS NOT NULL DROP TABLE #TempAndroids
END

RETURN 0

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

	-- 更新状态
	IF @wBatchID<>0
	BEGIN
		UPDATE AndroidLockInfo SET AndroidStatus=0,ServerID=0,BatchID=0,LockDateTime=GetDate()  
		WHERE AndroidStatus<>0 AND BatchID=@wBatchID AND ServerID=@wServerID
	END
	ELSE
	BEGIN
		UPDATE AndroidLockInfo SET AndroidStatus=0,ServerID=0,BatchID=0,LockDateTime=GetDate()  
		WHERE AndroidStatus<>0 AND BatchID<>0 AND ServerID=@wServerID
	END

END

RETURN 0

----------------------------------------------------------------------------------------------------
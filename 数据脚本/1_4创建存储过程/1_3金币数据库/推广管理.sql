
----------------------------------------------------------------------------------------------------

USE RYTreasureDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_LoadSpreadInfo]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_LoadSpreadInfo]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- 推广奖励
CREATE PROC GSP_GR_LoadSpreadInfo
	@dwUserID		INT				--用户标识
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN
	
	-- 奖励信息
	DECLARE @SpreadCount INT
	DECLARE	@SpreadReward BIGINT
	
	-- 统计人数
	SELECT @SpreadCount=Count(*) FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo	
	WHERE SpreaderID=@dwUserID

	-- 统计奖励
	SELECT @SpreadReward=SUM(Score)	FROM RecordSpreadInfo WHERE UserID=@dwUserID AND Score>0

	-- 调整数据
	IF @SpreadCount IS NULL SET @SpreadCount=0
	IF @SpreadReward IS NULL SET @SpreadReward=0

	--抛出数据
	SELECT @SpreadCount AS SpreadCount,@SpreadReward AS SpreadReward
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

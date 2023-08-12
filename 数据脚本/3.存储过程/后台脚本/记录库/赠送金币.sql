----------------------------------------------------------------------
-- 时间：2010-03-16
-- 用途：赠送金币
----------------------------------------------------------------------

USE RYRecordDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[WSP_PM_GrantTreasure]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[WSP_PM_GrantTreasure]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO
----------------------------------------------------------------------

CREATE PROCEDURE WSP_PM_GrantTreasure
	@MasterID INT,				-- 管理员标识
	@ClientIP VARCHAR(15),		-- 赠送地址
	@UserID INT,				-- 用户标识
	@AddGold BIGINT,			-- 赠送金币
	@Reason NVARCHAR(32)		-- 赠送原因	
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 用户金币信息
DECLARE @CurGold BIGINT
DECLARE @CurScore BIGINT

-- 执行逻辑
BEGIN
	
	-- 获取用户金币信息
	SELECT @CurGold = InsureScore,@CurScore=Score FROM RYTreasureDBLink.RYTreasureDB.dbo.GameScoreInfo
	WHERE UserID = @UserID
	If @CurGold IS NULL
	BEGIN
		SET @CurGold = 0
		SET @CurScore=0
	END

	IF @CurGold+@AddGold<0
	BEGIN
		RETURN -1
	END 

	-- 新增记录信息
	INSERT INTO RecordGrantTreasure(MasterID,ClientIP,UserID,CurGold,AddGold,Reason)
	VALUES(@MasterID,@ClientIP,@UserID,@CurGold,@AddGold,@Reason)

	-- 赠送金币
	UPDATE RYTreasureDBLink.RYTreasureDB.dbo.GameScoreInfo SET InsureScore = InsureScore + @AddGold
	WHERE UserID = @UserID
	
	IF @@ROWCOUNT = 0
	BEGIN
		INSERT INTO RYTreasureDBLink.RYTreasureDB.dbo.GameScoreInfo(UserID,InsureScore,RegisterIP,LastLogonIP)
		VALUES(@UserID,@AddGold,@ClientIP,@ClientIP)
	END

	DECLARE @TypeID INT
	DECLARE @DateID INT
	SET @TypeID=15
	SET @DateID=CAST(CAST(GETDATE() AS FLOAT) AS INT)
	-- 流水帐
	INSERT INTO RYTreasureDBLink.RYTreasureDB.dbo.RecordPresentInfo(UserID,PreScore,PreInsureScore,PresentScore,TypeID,IPAddress)
	VALUES(@UserID,@CurScore,@CurGold,@AddGold,@TypeID,@ClientIP)
	-- 日统计
	UPDATE RYTreasureDBLink.RYTreasureDB.dbo.StreamPresentInfo SET PresentCount=PresentCount+1,PresentScore=PresentScore+@AddGold,LastDate=GETDATE()
	WHERE DateID=@DateID AND UserID=@UserID AND TypeID=@TypeID 
	IF @@ROWCOUNT=0
	BEGIN
		INSERT INTO RYTreasureDBLink.RYTreasureDB.dbo.StreamPresentInfo(DateID,UserID,TypeID,PresentCount,PresentScore,FirstDate,LastDate)
		VALUES(@DateID,@UserID,@TypeID,1,@AddGold,GETDATE(),GETDATE())
	END		
END
RETURN 0


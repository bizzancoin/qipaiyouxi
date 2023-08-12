USE RYPlatformDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_UseTrumpet]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_UseTrumpet]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO


CREATE PROC GSP_GP_UseTrumpet
	@dwUserID INT,				-- 用户 I D
	@strClientIP NVARCHAR(15),	-- 连接地址
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN
	
	DECLARE @PropName nvarchar(31)
	DECLARE @GoodsCount INT 
	DECLARE @PropCount  INT
	DECLARE @PropID	 INT	
	DECLARE @SendLoveLiness INT 
	DECLARE @RecvLoveLiness INT
	DECLARE @CurGoodsCount INT 
	
	SET @PropName = '大喇叭'
	SET @GoodsCount = 0	
	SET @PropCount = 1	
	SET @PropID = 306	
	SET @SendLoveLiness = 0	
	SET @RecvLoveLiness = 0	
	SET @CurGoodsCount = 0
			
	-- 查询背包
	SELECT @GoodsCount = GoodsCount FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsPackage WHERE UserID=@dwUserID and GoodsID=@PropID
	IF @GoodsCount = 0 
	BEGIN
		set @strErrorDescribe=N'背包没有该数量的道具， 无法使用'
		RETURN 1
	END
	
	--减少道具
	SET @CurGoodsCount= @GoodsCount-@PropCount
	if @CurGoodsCount > 0
		update RYAccountsDBLink.RYAccountsDB.dbo.AccountsPackage set GoodsCount = @CurGoodsCount where UserID=@dwUserID and GoodsID=@PropID
	else 
		delete RYAccountsDBLink.RYAccountsDB.dbo.AccountsPackage where UserID=@dwUserID and GoodsID=@PropID
	
		
	--道具记录
	insert RYRecordDBLink.RYRecordDB.dbo.RecordUseProperty(SourceUserID, TargetUserID, 
	PropertyID, PropertyName, PropertyCount, LovelinessRcv, LovelinessSend, 
	KindID, ServerID, ClientIP, UseDate)
	values(@dwUserID, 0, @PropID, @PropName, @PropCount, 
	@RecvLoveLiness, @SendLoveLiness, 0, 0, @strClientIP, GETDATE())
	
	SET @strErrorDescribe=N'大喇叭使用成功'
END

RETURN 0

GO

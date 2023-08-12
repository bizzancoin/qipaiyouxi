----------------------------------------------------------------------
-- 版本：2013
-- 时间：2013-04-22
-- 用途：每日整点结算转账返利(使用游标)
----------------------------------------------------------------------
USE [RYTreasureDB]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[NET_PJ_BalanceTransferReturn]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[NET_PJ_BalanceTransferReturn]
GO

----------------------------------------------------------------------
CREATE PROC [NET_PJ_BalanceTransferReturn]
			
WITH ENCRYPTION AS

-- 属性设置
DECLARE @ReturnType TINYINT
DECLARE @Revenue BIGINT
DECLARE @ReturnPercent INT
DECLARE @Percent DECIMAL(18,2)
DECLARE @ReturnValue INT
DECLARE @UserID INT

-- 执行逻辑
BEGIN
	DECLARE @RecordID INT
	DECLARE @Trans_Cursor CURSOR
	
	SET @Trans_Cursor = CURSOR FOR 
	SELECT RecordID FROM TransferReturnDetailInfo WHERE IsReturn = 0

	OPEN @Trans_Cursor

	FETCH NEXT FROM @Trans_Cursor INTO @RecordID

	WHILE @@FETCH_STATUS = 0
	BEGIN
		SELECT @UserID=SourceUserID,@Revenue=Revenue,@ReturnType=ReturnType,@ReturnPercent=ReturnPercent FROM TransferReturnDetailInfo WHERE RecordID = @RecordID
		SET @Percent = @ReturnPercent/100.00
		SET @ReturnValue = CAST((@Revenue * @Percent) AS INT)

		IF @ReturnValue >0
		BEGIN
			IF @ReturnType = 0
			BEGIN
				UPDATE RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo SET UserMedal = UserMedal + @ReturnValue WHERE UserID = @UserID
				UPDATE TransferReturnDetailInfo SET ReturnUserMedal = @ReturnValue,IsReturn = 1 WHERE RecordID = @RecordID
				IF EXISTS(SELECT UserID FROM TransferReturnStream WHERE UserID = @UserID)
				BEGIN
					UPDATE TransferReturnStream SET ReturnUserMedal = ReturnUserMedal + @ReturnValue WHERE UserID = @UserID
				END
				ELSE
				BEGIN
					INSERT INTO TransferReturnStream VALUES(@UserID,@ReturnValue,0,GETDATE())
				END
			END
			ELSE IF @ReturnType = 1
			BEGIN
				UPDATE RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo SET LoveLiness = LoveLiness + @ReturnValue WHERE UserID = @UserID
				UPDATE TransferReturnDetailInfo SET ReturnLoveLiness = @ReturnValue,IsReturn = 1 WHERE RecordID = @RecordID
				IF EXISTS(SELECT UserID FROM TransferReturnStream WHERE UserID = @UserID)
				BEGIN
					UPDATE TransferReturnStream SET ReturnLoveLiness = ReturnLoveLiness + @ReturnValue WHERE UserID = @UserID
				END
				ELSE
				BEGIN
					INSERT INTO TransferReturnStream VALUES(@UserID,0,@ReturnValue,GETDATE())
				END
			END
		END

		FETCH NEXT FROM @Trans_Cursor INTO @RecordID
	END

	CLOSE @Trans_Cursor
	DEALLOCATE @Trans_Cursor
END
GO

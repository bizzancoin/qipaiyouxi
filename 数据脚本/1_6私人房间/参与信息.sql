
----------------------------------------------------------------------------------------------------

USE RYPlatformDB
GO

----写私人房配置信息
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_WritePersonalRoomJoinInfo]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_WritePersonalRoomJoinInfo]
GO


SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------



----------------------------------------------------------------------------------------------------
-- 游戏写分
CREATE PROC GSP_GR_WritePersonalRoomJoinInfo

	-- 系统信息
	@dwUserID INT,								-- 用户 I D
	@dwTableID INT,								-- 用户 I D
	@szRoomID NVARCHAR(6)						-- 房间ID
	
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN
	
	-- 如果当前房间玩家不存在
	DECLARE @dwExistUserID INT
	SELECT @dwExistUserID = UserID FROM PersonalRoomScoreInfo WHERE RoomID = @szRoomID AND UserID = @dwUserID

	IF @dwExistUserID IS NULL
	BEGIN
		INSERT INTO PersonalRoomScoreInfo(UserID, RoomID, Score, WinCount, LostCount, DrawCount, FleeCount, WriteTime) 
												VALUES (@dwUserID, @szRoomID, 0,0, 0, 0, 0, GETDATE())  
	END

END

RETURN 0

GO
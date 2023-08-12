----------------------------------------------------------------------
-- 时间：2010-03-16
-- 用途：新增卡生成记录
----------------------------------------------------------------------

USE RYTreasureDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[WSP_PM_BuildStreamAdd]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[WSP_PM_BuildStreamAdd]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------

CREATE PROCEDURE WSP_PM_BuildStreamAdd
	@AdminName nvarchar(31),	-- 管理员用户名
	@CardTypeID int,			-- 实卡类别
	@CardPrice decimal(18,2),	-- 实卡价格
	@Currency bigint,			-- 实卡金币
	@Gold int,					-- 实卡游戏币
	@BuildCount int,			-- 生成数量
	@BuildAddr nvarchar(15),	-- 生成地址
	@NoteInfo nvarchar(128),	-- 备注信息
	@BuildCardPacket image		-- 实卡信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN
	INSERT INTO LivcardBuildStream(
		AdminName,CardTypeID,CardPrice,Currency,BuildCount,BuildAddr,NoteInfo,BuildCardPacket,Gold)
	VALUES(
		@AdminName,@CardTypeID,@CardPrice,@Currency,@BuildCount,@BuildAddr,@NoteInfo,@BuildCardPacket,@Gold)

	SELECT SCOPE_IDENTITY()
END
RETURN 0
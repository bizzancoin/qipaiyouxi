----------------------------------------------------------------------
-- 时间：2012-10-23
-- 用途：充值统计
----------------------------------------------------------------------
USE [RYAccountsDB]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[NET_PM_UsersNumberStat]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[NET_PM_UsersNumberStat]
GO

----------------------------------------------------------------------
CREATE PROC [NET_PM_UsersNumberStat]
			
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON
DECLARE @UserTotal INT						-- 总用户数
DECLARE @CurrentMonthRegUserCounts INT		-- 当月注册用户数
DECLARE @MaxUserRegCounts INT				-- 日注册最高值
DECLARE @UserAVGOnlineTime INT				-- 用户平均在线时长
DECLARE @ActiveUserCounts INT				-- 活跃用户数
DECLARE @LossUserCounts INT					-- 流失用户数
DECLARE @CurrentTime DATETIME				-- 当前时间

-- 执行逻辑
BEGIN
	SET @CurrentTime=GETDATE()
	
	-- 总用户数
	SELECT @UserTotal=COUNT(UserID) FROM AccountsInfo WHERE IsAndroid=0
	
	-- 当月注册用户数
	SELECT @CurrentMonthRegUserCounts=Sum(WebRegisterSuccess+GameRegisterSuccess) FROM SystemStreamInfo 
	WHERE CONVERT(char(7),CollectDate,120)=CONVERT(char(7),@CurrentTime,120)
	
	-- 日注册最高值
	SELECT @MaxUserRegCounts=MAX(WebRegisterSuccess+GameRegisterSuccess) FROM SystemStreamInfo
	
	-- 平均在线时长
	SELECT @UserAVGOnlineTime=AVG(CONVERT(BIGINT,OnLineTimeCount)) FROM AccountsInfo WHERE IsAndroid=0
	
	-- 活跃用户数
	SELECT @ActiveUserCounts=COUNT(UserID) FROM RYTreasureDBLink.RYTreasureDB.dbo.StreamScoreInfo 
	WHERE DateID= CAST(CAST(@CurrentTime AS FLOAT) AS INT) AND OnlineTimeCount>=60*60 
	AND UserID NOT IN(SELECT UserID FROM AccountsInfo WHERE IsAndroid=1)
	
	-- 流失用户数
	SELECT @LossUserCounts=Count(UserID) FROM AccountsInfo 
	WHERE LastLogonDate<DATEADD(mm,-1,Convert(varchar(10),@CurrentTime,120)) AND IsAndroid=0

	-- 赋默认值
	IF @MaxUserRegCounts IS NULL
		SET @MaxUserRegCounts=0
	IF @CurrentMonthRegUserCounts IS NULL
		SET @CurrentMonthRegUserCounts=0

	-- 返回数据
	SELECT @UserTotal AS UserTotal,@CurrentMonthRegUserCounts AS CurrentMonthRegUserCounts,@MaxUserRegCounts AS MaxUserRegCounts,
	@UserAVGOnlineTime AS UserAVGOnlineTime,@ActiveUserCounts AS ActiveUserCounts,@LossUserCounts AS LossUserCounts
END
GO
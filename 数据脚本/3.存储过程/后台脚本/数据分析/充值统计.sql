----------------------------------------------------------------------
-- 版本：2013
-- 时间：2013-04-22
-- 用途：充值统计
----------------------------------------------------------------------
USE [RYTreasureDB]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[NET_PM_AnalPayStat]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[NET_PM_AnalPayStat]

GO

----------------------------------------------------------------------
CREATE PROC [NET_PM_AnalPayStat]
			
WITH ENCRYPTION AS

BEGIN
	-- 属性设置
	SET NOCOUNT ON
	DECLARE @PayUserCounts INT			-- 充值总人数
	DECLARE @PayTwoUserCounts INT		-- 充值大于1次人数
	DECLARE @PayMaxAmount INT			-- 最大充值金额
	DECLARE @PayTotalAmount BIGINT		-- 充值总金额
	DECLARE @MaxShareID INT				-- 充值最多渠道
	DECLARE @CurrentDateMaxAmount INT	-- 今日充值最多金额 
	DECLARE @PayMaxDate VARCHAR(10)		-- 最多充值日期
	DECLARE @UserTotal VARCHAR(10)		-- 用户总数
	DECLARE @PayUserOutflowTotal INT	-- 充值用户流失数
	DECLARE @VIPPayUserTotal INT		-- 充值金额大于2000RMN玩家数

	-- 充值总人数
	SELECT @PayUserCounts=COUNT(*) FROM (SELECT DISTINCT UserID FROM ShareDetailInfo) AS A
	
	-- 二次充值玩家
	SELECT @PayTwoUserCounts=COUNT(Total) 
	FROM (SELECT COUNT(UserID) AS Total FROM ShareDetailInfo GROUP BY UserID) AS A WHERE Total>1
	
	-- 最大、总充值金额	
	SELECT @PayMaxAmount=MAX(PayAmount),@PayTotalAmount=SUM(PayAmount) FROM ShareDetailInfo
	
	-- 充值最多渠道
	SELECT TOP 1 @MaxShareID=ShareID FROM ShareDetailInfo GROUP BY ShareID ORDER BY Sum(PayAmount) DESC
	
	-- 今日充值最高额度
	SELECT @CurrentDateMaxAmount=Max(PayAmount) FROM ShareDetailInfo 
	WHERE ApplyDate>=CONVERT(VARCHAR(10),GETDATE(),120) AND ApplyDate<=CONVERT(VARCHAR(10),GETDATE()+1,120) 
	
	-- 最多充值日期
	SELECT TOP 1 @PayMaxDate=Convert(varchar(10),ApplyDate,120) FROM ShareDetailInfo 
	GROUP BY Convert(varchar(10),ApplyDate,120) ORDER BY SUM(PayAmount) DESC
	
	-- 用户总数
	SELECT @UserTotal=COUNT(UserID) FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo WHERE IsAndroid=0
	
	-- 充值用户流失数
	SELECT @PayUserOutflowTotal=Count(UserID) FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo 
	WHERE UserID IN(SELECT USERID FROM ShareDetailInfo) AND LastLogonDate<DATEADD(mm,-1,Convert(varchar(10),GetDate(),120)) AND IsAndroid=0
	
	-- 充值大户
	SELECT @VIPPayUserTotal=COUNT(UserID) FROM (SELECT UserID FROM ShareDetailInfo 
	GROUP BY UserID HAVING SUM(PayAmount)>=2000 ) AS A

	-- 返回数据
	SELECT @PayUserCounts AS PayUserCounts,@PayTwoUserCounts AS PayTwoUserCounts,ISNULL(@PayMaxAmount,0) AS PayMaxAmount,
	ISNULL(@PayTotalAmount,0) AS PayTotalAmount,ISNULL(@MaxShareID,0) AS MaxShareID,ISNULL(@CurrentDateMaxAmount,0) AS CurrentDateMaxAmount,
	ISNULL(@PayMaxDate,'') AS PayMaxDate,@UserTotal AS UserTotal,@PayUserOutflowTotal AS PayUserOutflowTotal,@VIPPayUserTotal AS VIPPayUserTotal
	
END
GO

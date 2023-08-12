----------------------------------------------------------------------
-- 用途：获取代理商分成详情
-- 描述：
----------------------------------------------------------------------
USE RYTreasureDB
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].WSP_PM_GetAgentFinance') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].WSP_PM_GetAgentFinance
GO

----------------------------------------------------------------------
CREATE PROC WSP_PM_GetAgentFinance
	@dwUserID		INT
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

BEGIN
	-- 获取税收分成
	DECLARE @AgentRevenue BIGINT
	SELECT @AgentRevenue=ISNULL(SUM(AgentRevenue),0) FROM RecordUserRevenue WHERE AgentUserID=@dwUserID

	-- 获取充值分成
	DECLARE @AgentPay BIGINT
	SELECT @AgentPay=ISNULL(SUM(Score),0) FROM RecordAgentInfo WHERE UserID=@dwUserID AND TypeID=1

	-- 获取充值返现分成
	DECLARE @AgentPayBack BIGINT
	SELECT @AgentPayBack=ISNULL(SUM(Score),0) FROM RecordAgentInfo WHERE UserID=@dwUserID AND TypeID=2
	
	-- 获取结算支出
	DECLARE @AgentOut BIGINT
	SELECT @AgentOut=ISNULL(-SUM(Score),0) FROM RecordAgentInfo WHERE UserID=@dwUserID AND TypeID=3

	SELECT @AgentRevenue AS AgentRevenue,@AgentPay AS AgentPay,@AgentPayBack AS AgentPayBack,@AgentOut AS AgentOut
	
END
 
 
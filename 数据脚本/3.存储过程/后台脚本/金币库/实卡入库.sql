USE RYTreasureDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[WSP_PM_LivcardAdd]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[WSP_PM_LivcardAdd]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------
-- 时间：2010-03-16
-- 用途：实卡入库
----------------------------------------------------------------------
CREATE PROCEDURE WSP_PM_LivcardAdd
	@SerialID nvarchar(3300),	-- 实卡卡号
	@Password nvarchar(3400),	-- 实卡密码
	@BuildID int,				-- 生成标识
	@CardTypeID int,			-- 实卡类型
	@CardPrice decimal(18,2),	-- 实卡价格	
	@Currency decimal(18,2),	-- 实卡金币
	@Gold int,					-- 实卡游戏币
	@UseRange int,				-- 使用范围
	@SalesPerson nvarchar(31),	-- 销售商
	@ValidDate datetime			-- 有效日期	
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN
	INSERT INTO LivcardAssociator(
		SerialID,[Password],BuildID,CardTypeID,CardPrice,Currency,UseRange,SalesPerson,ValidDate,Gold)
	SELECT A.rs AS SerialID,B.rs AS [Password],
		@BuildID,@CardTypeID,@CardPrice,@Currency,@UseRange,@SalesPerson,@ValidDate,@Gold 
	FROM WF_Split(@SerialID,',') AS A INNER JOIN WF_Split(@Password,',') AS B ON A.id=B.id
END
RETURN 0


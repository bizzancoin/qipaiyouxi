----------------------------------------------------------------------
-- 时间：2011-09-26
-- 用途：商品类型删除
----------------------------------------------------------------------
USE RYNativeWebDB
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[WSP_PM_DeleteAwardType]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[WSP_PM_DeleteAwardType]
GO
-----------------------------------------------------------------------
CREATE PROC [WSP_PM_DeleteAwardType]
	@TypeID INT,										-- 商品类型标识
	@strErrorDescribe NVARCHAR(127) OUTPUT			-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN	
	----判断删除的类型是否包含子类型
	IF EXISTS(SELECT * FROM AwardType WHERE ParentID=@TypeID)
	BEGIN
		SET @strErrorDescribe=N'该商品类型中存在子类型,无法删除';
		RETURN 1;
	END
	
	----判断删除的类型是否包含商品
	IF EXISTS(SELECT * FROM AwardInfo WHERE TypeID=@TypeID)
	BEGIN
		SET @strErrorDescribe=N'该商品类型中存在商品,无法删除';
		RETURN 1;
	END
	
	----执行删除操作
	DELETE FROM AwardType WHERE TypeID=@TypeID;
	RETURN 0;
END

GO


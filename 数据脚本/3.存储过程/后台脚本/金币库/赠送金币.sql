----------------------------------------------------------------------
-- 时间：2011-09-29
-- 用途：批量赠送金币
----------------------------------------------------------------------
USE RYTreasureDB
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[NET_PM_GrantTreasure]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[NET_PM_GrantTreasure]
GO

----------------------------------------------------------------------
CREATE PROC [NET_PM_GrantTreasure]
(	
	@strUserIDList	NVARCHAR(1000),	--用户标识的字符串
	@dwAddGold		DECIMAL(18,2),	--赠送金额
	@dwMasterID		INT,			--操作者标识
	@strReason 		NVARCHAR(32),	--赠送原因
	@strClientIP	VARCHAR(15)		--IP地址
)
			
WITH ENCRYPTION AS

BEGIN
	-- 属性设置
	SET NOCOUNT ON

	DECLARE @dwCounts		INT,			-- 赠送对象的数量	
			@dwTotalGold	DECIMAL(18,2),	-- 赠送的总金额
			@dtCurrentDate	DATETIME		-- 操作日期
	SET @dtCurrentDate =  GETDATE()
	
	
	-- 执行逻辑
	BEGIN TRY
	-- 验证
	IF @dwAddGold IS NULL OR @dwAddGold = 0
		RETURN -2;		-- 赠送金额不能为零
	SELECT @dwCounts=COUNT(*) FROM dbo.WF_Split(@strUserIDList,',')
	IF @dwCounts<=0 
		RETURN -3;		-- 未选中赠送对象
	SET @dwTotalGold = @dwCounts * @dwAddGold	
	
	BEGIN TRAN
			--插入赠送金币记录		
			INSERT RYRecordDB.dbo.RecordGrantTreasure(MasterID,ClientIP,CollectDate,UserID,CurGold,AddGold,Reason)
				SELECT @dwMasterID,@strClientIP,@dtCurrentDate,
						a.rs,ISNULL(b.InsureScore,0),@dwAddGold,@strReason
				FROM WF_Split(@strUserIDList,',') a LEFT JOIN GameScoreInfo b ON a.rs = b.UserID			 
			
			--更新玩家银行金币
			UPDATE GameScoreInfo SET InsureScore=(CASE WHEN InsureScore+@dwAddGold<0 THEN 0 WHEN InsureScore+@dwAddGold>=0 THEN InsureScore+@dwAddGold end) 
			WHERE UserID IN (SELECT rs FROM dbo.WF_Split(@strUserIDList,','))
			
			--没有金币记录的玩家银行金币更新
			INSERT INTO GameScoreInfo(UserID,InsureScore) 
			SELECT rs,@dwAddGold FROM dbo.WF_Split(@strUserIDList,',') WHERE rs NOT IN (SELECT UserID FROM dbo.GameScoreInfo)
			
		
	COMMIT TRAN			
		RETURN 0;--成功
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
		BEGIN
			ROLLBACK TRAN
		END
		RETURN -1;    --未知服务器错误
	END CATCH
END
GO


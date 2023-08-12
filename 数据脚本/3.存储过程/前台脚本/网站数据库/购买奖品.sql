----------------------------------------------------------------------------------------------------
-- 版权：2013
-- 时间：2013-07-31
-- 用途：问题反馈
----------------------------------------------------------------------------------------------------
USE RYNativeWebDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].WSP_PW_BuyAward') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].WSP_PW_BuyAward
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------
-- 购买商品
CREATE PROCEDURE WSP_PW_BuyAward
	@UserID	INT,					-- 用户标识
	@AwardID INT,					-- 奖品标识
	@AwardPrice INT,				-- 奖品价格
	@AwardCount INT,				-- 购买数量
	@TotalAmount INT,				-- 总金额
	@Compellation NVARCHAR(16),		-- 真实姓名
	@MobilePhone NVARCHAR(16),		-- 手机号码
	@QQ NVARCHAR(32),				-- QQ号码
	@Province INT,					-- 省份
	@City INT,						-- 城市
	@Area INT,						-- 地区
	@DwellingPlace NVARCHAR(128),	-- 详细地址
	@PostalCode	NVARCHAR(8),		-- 邮编号码
	@BuyIP NVARCHAR(15),			-- 购买IP                     
	@OrderID INT OUTPUT,			-- 订单号码	
	@strErrorDescribe NVARCHAR(127) OUTPUT	-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 账户信息
DECLARE @UserMedal INT

-- 执行逻辑
BEGIN
	-- 验证用户
	SELECT @UserMedal=UserMedal,@UserID=UserID FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo 
	WHERE UserID=@UserID
	IF @UserID IS NULL
	BEGIN
		SET @strErrorDescribe='用户不存在'
		RETURN 101
	END

	-- 验证奖牌
	IF @TotalAmount>@UserMedal
	BEGIN
		SET @strErrorDescribe='兑换失败，奖牌数不足'
		RETURN 101
	END
	
	-- 更新奖牌
	--BEGIN TRAN
	UPDATE RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo SET UserMedal=UserMedal-@TotalAmount
	WHERE UserID=@UserID
	
	-- 插入订单
	INSERT INTO AwardOrder(UserID,AwardID,AwardPrice,AwardCount,TotalAmount,Compellation,
		MobilePhone,QQ,Province,City,Area,DwellingPlace,PostalCode,BuyIP)
	VALUES(@UserID,@AwardID,@AwardPrice,@AwardCount,@TotalAmount,@Compellation,
		@MobilePhone,@QQ,@Province,@City,@Area,@DwellingPlace,@PostalCode,@BuyIP)

	SET @OrderID=@@IDENTITY 
	SELECT @OrderID AS OrderID
		
	--更新奖品
	UPDATE AwardInfo SET BuyCount=BuyCount+1,Inventory=Inventory-@AwardCount WHERE AwardID=@AwardID
	--COMMIT TRAN
	
	RETURN 0
END
RETURN 0
GO
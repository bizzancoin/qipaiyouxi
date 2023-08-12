----------------------------------------------------------------------------------------------------
-- 版权：2015
-- 时间：2015-01-20
-- 用途：分享赠送
----------------------------------------------------------------------------------------------------
USE RYTreasureDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].NET_PW_SharePresent') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].NET_PW_SharePresent
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------
-- 分享赠送
CREATE PROCEDURE NET_PW_SharePresent
	@dwUserID	INT,						-- 用户标识
	@strPassword NCHAR(32),					-- 用户密码
	@strMachineID NVARCHAR(32),				-- 机器码         
	@strClientIP NVARCHAR(15),				-- 连接地址                 
	@strErrorDescribe NVARCHAR(127) OUTPUT	-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 账户信息
DECLARE @UserID INT
DECLARE @Nullity TINYINT
DECLARE @LogonPass AS NCHAR(32)

-- 金币信息
DECLARE @Score BIGINT
DECLARE @InsureScore BIGINT

-- 执行逻辑
BEGIN
	-- 验证用户
	SELECT @UserID=UserID,@Nullity=Nullity,@LogonPass=LogonPass FROM RYAccountsDBLink.RYAccountsDB.dbo.AccountsInfo WHERE UserID=@dwUserID
	
	-- 用户存在
	IF @UserID IS NULL OR @LogonPass<>@strPassword
	BEGIN
		SET @strErrorDescribe=N'您的帐号不存在或者密码输入有误，请查证后再次尝试登录！'
		RETURN 100
	END	

	-- 帐号禁止
	IF @Nullity<>0
	BEGIN
		SET @strErrorDescribe=N'您的帐号暂时处于冻结状态，请联系客户服务中心了解详细情况！'
		RETURN 101
	END

	-- 查询金币
	SELECT @Score=Score,@InsureScore=InsureScore FROM GameScoreInfo WHERE UserID=@dwUserID
	IF @Score IS NULL
	BEGIN
		SET @Score=0
		SET @InsureScore=0
	END

	-- 分享赠送
	DECLARE @DateID INT
	DECLARE @PresentScore INT
	DECLARE @IsPresent bit
	SET @DateID=CAST(CAST(GETDATE() AS FLOAT) AS INT)
	SELECT @PresentScore = StatusValue FROM RYAccountsDBLink.RYAccountsDB.dbo.SystemStatusInfo WHERE StatusName='SharePresent'
	IF @PresentScore IS NULL
	BEGIN
		SET @PresentScore=1000
	END	
	SET @IsPresent=0

	IF @PresentScore>0
	BEGIN
		IF NOT EXISTS (SELECT MachineID FROM RecordSharePresent WHERE DateID=@DateID AND UserID=@dwUserID)
		BEGIN
			-- 设置标识
			SET @IsPresent=1

			-- 写入信息
			UPDATE GameScoreInfo SET Score=Score+@PresentScore WHERE UserID=@dwUserID
			IF @@ROWCOUNT=0
			BEGIN
				INSERT INTO GameScoreInfo(UserID,Score,LastLogonIP,RegisterIP) VALUES(@dwUserID,@PresentScore,@strClientIP,@strClientIP)
			END

			-- 写入记录
			INSERT INTO RecordSharePresent(DateID,UserID,MachineID,PresentScore) VALUES(@DateID,@dwUserID,@strMachineID,@PresentScore)

			SET @strErrorDescribe=N'恭喜您，今天首次分享成功，奖励金币'+LTRIM(STR(@PresentScore))
		END		
	END

	-- 赠送统计
	IF @IsPresent=1
	BEGIN
		DECLARE @TypeID INT
		SET @TypeID=12
		-- 流水帐
		INSERT INTO RecordPresentInfo(UserID,PreScore,PreInsureScore,PresentScore,TypeID,IPAddress)
		VALUES(@dwUserID,@Score,@InsureScore,@PresentScore,@TypeID,@strClientIP)
		-- 日统计
		UPDATE StreamPresentInfo SET PresentCount=PresentCount+1,PresentScore=PresentScore+@PresentScore,LastDate=GETDATE()
		WHERE DateID=@DateID AND UserID=@dwUserID AND TypeID=@TypeID 
		IF @@ROWCOUNT=0
		BEGIN
			INSERT INTO StreamPresentInfo(DateID,UserID,TypeID,PresentCount,PresentScore,FirstDate,LastDate)
			VALUES(@DateID,@dwUserID,@TypeID,1,@PresentScore,GETDATE(),GETDATE())
		END		
	END
END
RETURN 0
GO
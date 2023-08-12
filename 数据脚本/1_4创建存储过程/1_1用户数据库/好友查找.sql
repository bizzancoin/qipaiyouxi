
----------------------------------------------------------------------------------------------------

USE RYAccountsDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_SearchUser]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_SearchUser]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- 修改密码
CREATE PROC GSP_GP_SearchUser
	@dwGameID INT						-- 用户账号
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN
	-- 查询数据
	SELECT UserID,GameID,FaceID,CustomID,Gender,MemberOrder,NickName,GrowLevelID AS GrowLevel,ISNULL(UnderWrite,N'') AS UnderWrite FROM AccountsInfo WHERE GameID=@dwGameID			
END

RETURN 0

GO
----------------------------------------------------------------------------------------------------

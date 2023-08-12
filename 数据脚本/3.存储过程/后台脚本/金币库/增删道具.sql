

----------------------------------------------------------------------
-- 时间：2009-11-4 10:06:57
-- 工程：道具增删改
----------------------------------------------------------------------

USE RYTreasureDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[WSP_PM_GameProperty_OP]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[WSP_PM_GameProperty_OP]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[WSP_PM_GameProperty_OP]
(

    @ID  int = 0,	-- 数据库索引
    @Name  nvarchar(32) = '',	-- 提供站点
	@Cash decimal(18,2) = 0, --机器名
    @Gold  bigint = 0,	-- 数据库地址
    @Discount  smallint = 0,	-- 网通地址
    @IssueArea  smallint = 0,	-- 铁通地址
    @ServiceArea  smallint = 0,	-- 数据库端口
    @SendLoveLiness  bigint = 0,	-- 数据库用户
    @RecvLoveLiness  bigint = 0,	-- 数据库密码
    @RegulationsInfo  nvarchar(255) = '',	-- 机器标识
    @Nullity  tinyint  = 0,	-- 备注信息
    @DataTable_Action_  varchar(10) = ''		-- 操作方法 Insert:增加 Update:修改 Delete:删除
)
WITH ENCRYPTION AS
    -- 返回信息
	DECLARE @ReturnValue NVARCHAR(127)
    SET @ReturnValue = -1
    -- 新增
    IF (@DataTable_Action_='Insert')
    BEGIN
    
        --检测主键是否相同
        IF exists (select 1
            FROM  GameProperty
            WHERE ID=@ID )
        BEGIN
            SET @ReturnValue = N'ID重复，新增失败！'
			SELECT @ReturnValue
			RETURN 1
        END
    
        INSERT INTO GameProperty(
            ID , 
			[Name],
            Cash , 
            Gold , 
            Discount , 
            IssueArea , 
            ServiceArea , 
            SendLoveLiness , 
            RecvLoveLiness , 
            RegulationsInfo
        ) VALUES (
            @ID , 
			@Name,
            @Cash , 
            @Gold , 
            @Discount , 
            @IssueArea , 
            @ServiceArea , 
            @SendLoveLiness , 
            @RecvLoveLiness , 
            @RegulationsInfo
        )
    END

    -- 更新
    IF (@DataTable_Action_='Update')
    BEGIN
    
        --检测主键是否相同
        IF exists (select 1
            FROM  GameProperty
            WHERE  ID<>@ID)
        BEGIN
            SET @ReturnValue = N'道具ID不存在！'
			SELECT @ReturnValue
			RETURN 1
        END
    
        UPDATE GameProperty SET 
            ID=@ID ,
			[Name]=@Name, 
            Cash=@Cash , 
            Gold=@Gold , 
            Discount=@Discount , 
            IssueArea=@IssueArea , 
            ServiceArea=@ServiceArea , 
            SendLoveLiness=@SendLoveLiness , 
            RecvLoveLiness=@RecvLoveLiness , 
            RegulationsInfo=@RegulationsInfo
        WHERE (ID=@ID)

        IF @@ROWCOUNT =0
		BEGIN
			RETURN -3
		END
		ELSE
		BEGIN
			RETURN 1
		END
    END
    -- 删除
    IF (@DataTable_Action_='Delete')
    BEGIN
        DELETE DataBaseInfo	WHERE (ID=@ID)

        IF @@ROWCOUNT =0
		BEGIN
			RETURN -3
		END
		ELSE
		BEGIN
			RETURN 1
		END
    END

    SELECT @ReturnValue

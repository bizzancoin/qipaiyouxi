/*********************************************************************************
*      Function:  WEB_PageView2													 *
*      Description:                                                              *
*             Sql2005分页存储过程												 *
*      Finish DateTime:                                                          *
*             2009/1/3															 *
*	   Example:																	 *
*	          WEB_PageView @Tablename = 'Table1', @Returnfields = '*',           *
*			  @PageSize = 2, @PageIndex = 1, @Where = '',					     *
*			  @OrderBy=N'ORDER BY id desc'										 *           
*********************************************************************************/

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[WEB_PageView]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[WEB_PageView]
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_NULLS ON 
GO


CREATE PROCEDURE dbo.WEB_PageView
	@TableName		NVARCHAR(2000),			-- 表名
	@ReturnFields	NVARCHAR(1000) = '*',	-- 查询列数
	@PageSize		INT = 10,				-- 每页数目
	@PageIndex		INT = 1,				-- 当前页码
	@Where			NVARCHAR(1000) = '',	-- 查询条件
	@OrderBy		NVARCHAR(1000),			-- 排序字段
	@PageCount		INT OUTPUT,				-- 页码总数
	@RecordCount	INT OUTPUT	        	-- 记录总数
WITH ENCRYPTION AS

--设置属性
SET NOCOUNT ON

-- 变量定义
DECLARE @TotalRecord INT
DECLARE @TotalPage INT
DECLARE @CurrentPageSize INT
DECLARE @TotalRecordForPageIndex INT

BEGIN
	IF @Where IS NULL SET @Where=N''
	
	-- 记录总数
	DECLARE @countSql NVARCHAR(4000)  
	
	IF @RecordCount IS NULL
	BEGIN
		SET @countSql='SELECT @TotalRecord=Count(*) From '+@TableName+' '+@Where
		EXECUTE sp_executesql @countSql,N'@TotalRecord int out',@TotalRecord OUT
	END
	ELSE
	BEGIN
		SET @TotalRecord=@RecordCount
	END		
	
	SET @RecordCount=@TotalRecord
	SET @TotalPage=(@TotalRecord-1)/@PageSize+1	
	SET @CurrentPageSize=(@PageIndex-1)*@PageSize

	-- 返回总页数和总记录数
	SET @PageCount=@TotalPage
	SET @RecordCount=@TotalRecord
		
	-- 返回记录
	SET @TotalRecordForPageIndex=@PageIndex*@PageSize
	
	EXEC	('SELECT *
			FROM (SELECT TOP '+@TotalRecordForPageIndex+' '+@ReturnFields+', ROW_NUMBER() OVER ('+@OrderBy+') AS PageView_RowNo
			FROM '+@TableName+ ' ' + @Where +' ) AS TempPageViewTable
			WHERE TempPageViewTable.PageView_RowNo > 
			'+@CurrentPageSize)
	
END
RETURN 0
GO
			


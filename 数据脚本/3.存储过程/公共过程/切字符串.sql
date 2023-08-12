----------------------------------------------------------------------
-- 版权：2011
-- 时间：2011-06-17
-- 用途：切分字符串，将忽略连续分隔符和分隔符之间的空字符
-- 用法：SELECT * FROM [dbo].[WF_Split]('a,b,c,d',',');
--		返回表结构:
--		id		自增主键
--		rs		分隔符切分的每个段落
----------------------------------------------------------------------
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WF_Split]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION dbo.[WF_Split]
GO
----------------------------------------------------------------
CREATE FUNCTION [dbo].[WF_Split]
(
	@strSource NVARCHAR(4000),	--要操作的字符串
	@strSeparator CHAR(1)			--分隔符，单字节
)
RETURNS @tbResult TABLE(id INT IDENTITY(1,1),rs NVARCHAR(1000))
WITH ENCRYPTION AS  
BEGIN 
   DECLARE @dwIndex INT ,@strResult NVARCHAR(1000);
   SET @strSource = RTRIM(LTRIM(@strSource)); -- 消空格
   SET @dwIndex = CHARINDEX(@strSeparator,@strSource);	-- 取得第一个分隔符的位置

   WHILE @dwIndex>0
   BEGIN 
      SET @strResult = LTRIM(RTRIM(LEFT(@strSource,@dwIndex-1)));
      IF @strResult IS NULL OR @strResult = '' OR @strResult = @strSeparator
      BEGIN 
        SET @strSeparator = SUBSTRING(@strSource,@dwIndex+1,LEN(@strSource)-@dwIndex); --将要操作的字符串去除已切分部分
        SET @dwIndex = CHARINDEX(@strSeparator,@strSource); --循环量增加
		CONTINUE;
      END 

      INSERT @tbResult VALUES(@strResult);
      SET @strSource = SUBSTRING(@strSource,@dwIndex+1,LEN(@strSource)-@dwIndex); --将要操作的字符串去除已切分部分
      SET @dwIndex=CHARINDEX(@strSeparator,@strSource); --循环量增加
   END 
   --处理最后一节
   IF  @strSource IS NOT NULL AND LTRIM(RTRIM(@strSource)) <> '' AND @strSource <> @strSeparator 
   BEGIN 
      INSERT @tbResult VALUES(@strSource)
   END 

   RETURN;
END 




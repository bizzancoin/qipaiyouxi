
---执行本脚本前,请先备份数据库.自负后果

USE [RYAccountsDB]
GO

-- 关闭行数
SET NOCOUNT ON

--------------------------------------------------------------------------
-- 清空标识 
-- 注意：如果是重新生成的话,请去掉下面两句前的"--",如果是ID用完了,再次生成的话.请不要去掉

Truncate table GameIdentifier
Truncate table ReserveIdentifier 

--------------------------------------------------------------------------


-- 调试开关
DECLARE @Debug BIT

-- 基数定义
DECLARE @BeginBase	INT
DECLARE @EndBase	INT
DECLARE @BaseString	VARCHAR(10)
DECLARE @ReserveEnd	INT

-- 标识开始和结束
DECLARE @BeginGameID	INT
DECLARE @EndGameID		INT

-- 标识长度
DECLARE @MinIDLength		INT
DECLARE @MaxIDLength		INT

------------------------------------------------------------------------------
-- 变量初始化
SET @Debug=1

SET @BeginBase	=0
SET @EndBase	=9
SET @BaseString	='0123456789'

SET @ReserveEnd=100000
SET @BeginGameID=100000
SET @EndGameID	=999999

SET @MinIDLength=LEN(LTRIM(RTRIM(STR(@BeginGameID))))
SET @MaxIDLength=13

-- 变量初始化
------------------------------------------------------------------------------

-------------------------------------------------------------------------
-- 筛选规则 Begin
	DECLARE @tblFilterRules TABLE(Rules VARCHAR(64))
	DECLARE	@Tmp INT
	DECLARE @TmpRules VARCHAR(64)

	-------------------------------------------------------------------------
	-- AAAAA,BBBBB Begin
	SET @Tmp=0	
	SET @TmpRules=''
	WHILE (@BeginBase<@EndBase)
	BEGIN		
		SET @MinIDLength=LEN(LTRIM(RTRIM(STR(@BeginGameID))))

		WHILE (@MinIDLength<=@MaxIDLength)
		BEGIN
			SET @Tmp=0		
			WHILE (@Tmp<@MinIDLength)
			BEGIN
				SET @TmpRules=@TmpRules+'['+LTRIM(STR(@BeginBase+1))+']'
				
				SET @Tmp=@Tmp+1		
			END
			
			IF @TmpRules IS NOT NULL INSERT @tblFilterRules(Rules) VALUES(@TmpRules)			
			SET @MinIDLength=@MinIDLength+1
			SET @TmpRules=''
		END
		
		SET @BeginBase=@BeginBase+1			
	END

	-- 还原变量
	SET @Tmp=0	
	SET @TmpRules=''

	SET @BeginBase=0
	SET @MinIDLength=LEN(LTRIM(RTRIM(STR(@BeginGameID))))	 
	
	-- AAAAA,BBBBB END
	-------------------------------------------------------------------------
	INSERT @tblFilterRules (Rules)
			  SELECT '%000%'
	UNION ALL SELECT '%111%'
	UNION ALL SELECT '%222%'
	UNION ALL SELECT '%333%'
	UNION ALL SELECT '%444%'
	UNION ALL SELECT '%555%'
	UNION ALL SELECT '%666%'
	UNION ALL SELECT '%777%'
	UNION ALL SELECT '%888%'
	UNION ALL SELECT '%999%'
	-------------------------------------------------------------------------
	-- %AAA%,%BBB% Begin
	
	-- %AAA%,%BBB% End
	-------------------------------------------------------------------------

	-- 还原变量
	SET @Tmp=0	
	SET @TmpRules=''

	SET @BeginBase=0
	SET @MinIDLength=LEN(LTRIM(RTRIM(STR(@BeginGameID))))

	-------------------------------------------------------------------------
	-- %521%,%520% Begin
	INSERT @tblFilterRules (Rules)
	SELECT '%520%'
	UNION ALL SELECT '%521%'
	UNION ALL SELECT '%527%'

	-- %521%,%520% End
	-------------------------------------------------------------------------

	-------------------------------------------------------------------------
	-- %132%,%133% 电话号码 Begin
	INSERT @tblFilterRules (Rules)
			  SELECT '130[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
	UNION ALL SELECT '131[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
	UNION ALL SELECT '132[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
	UNION ALL SELECT '133[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
	UNION ALL SELECT '134[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
	UNION ALL SELECT '135[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
	UNION ALL SELECT '136[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
	UNION ALL SELECT '137[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
	UNION ALL SELECT '138[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
	UNION ALL SELECT '139[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'

	UNION ALL SELECT '150[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
	UNION ALL SELECT '151[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
	UNION ALL SELECT '152[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
	UNION ALL SELECT '153[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
	UNION ALL SELECT '154[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
	UNION ALL SELECT '155[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
	UNION ALL SELECT '156[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
	UNION ALL SELECT '157[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
	UNION ALL SELECT '158[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
	UNION ALL SELECT '159[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'

	UNION ALL SELECT '180[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
	UNION ALL SELECT '181[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
	UNION ALL SELECT '182[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
	UNION ALL SELECT '183[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
	UNION ALL SELECT '184[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
	UNION ALL SELECT '185[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'	
	UNION ALL SELECT '186[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
	UNION ALL SELECT '187[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
	UNION ALL SELECT '188[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
	UNION ALL SELECT '189[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'

	-- %132%,%133% 电话号码 End

	-- 195000 生日号码 Begin
	SET @BeginBase	=1949
	SET @EndBase	=2050
	SET @TmpRules	=''
	WHILE (@BeginBase<@EndBase)
	BEGIN		
		SET @TmpRules=@TmpRules+''+LTRIM(STR(@BeginBase))+'[0-1][0-9]'		
		
		-- 194901
		SET @TmpRules=@TmpRules
		INSERT @tblFilterRules (Rules)	VALUES ('%'+@TmpRules+'%')

		-- 19490101
		SET @TmpRules='%'+@TmpRules+'[0-3][0-9]%'
		INSERT @tblFilterRules (Rules)	VALUES (@TmpRules)

		SET @BeginBase=@BeginBase+1			
		SET @TmpRules=''
	END
	-- 195000 生日号码 End

	-- 吉祥号码 Begin
	INSERT @tblFilterRules (Rules)
			  SELECT '168%'	
	UNION ALL SELECT '668%'
	UNION ALL SELECT '666%'
	UNION ALL SELECT '888%'
	UNION ALL SELECT '518%'
	UNION ALL SELECT '588%'
	UNION ALL SELECT '886%'
	UNION ALL SELECT '881%'
	UNION ALL SELECT '%1234%'
	UNION ALL SELECT '%4321%'
	UNION ALL SELECT '%110%'
	UNION ALL SELECT '%120%'
	UNION ALL SELECT '%119%'
	UNION ALL SELECT '800%'
	UNION ALL SELECT '400%'
	UNION ALL SELECT '600%'
	UNION ALL SELECT '%806%'
	UNION ALL SELECT '%668%'
	UNION ALL SELECT '%888%'
	UNION ALL SELECT '%986%'
	UNION ALL SELECT '%998%'

	UNION ALL SELECT '[1-9]00188'
	UNION ALL SELECT '[1-9]22188'
	UNION ALL SELECT '[1-9]33188'

	UNION ALL SELECT '[1-9]00168'
	UNION ALL SELECT '[1-9]22168'
	UNION ALL SELECT '[1-9]33168'

	UNION ALL SELECT '[1-9]00186'
	UNION ALL SELECT '[1-9]22186'
	UNION ALL SELECT '[1-9]33186'

	UNION ALL SELECT '[1-9]00[1-9]00'
	UNION ALL SELECT '[1-9]11[1-9]11'	
	UNION ALL SELECT '[1-9]22[1-9]22'	
	UNION ALL SELECT '[1-9]33[1-9]33'	
	UNION ALL SELECT '[1-9]44[1-9]44'	
	UNION ALL SELECT '[1-9]55[1-9]55'	
	UNION ALL SELECT '[1-9]66[1-9]66'	
	UNION ALL SELECT '[1-9]77[1-9]77'	
	UNION ALL SELECT '[1-9]88[1-9]88'
	UNION ALL SELECT '[1-9]99[1-9]99'

	UNION ALL SELECT '[1-9]88[1-9]88'
	UNION ALL SELECT '[1-9]888[1-9]888'
	UNION ALL SELECT '[1-9]8888[1-9]8888'
	UNION ALL SELECT '[1-9]88888[1-9]88888'
	
	UNION ALL SELECT '[1-9]00[1-9]00'
	UNION ALL SELECT '[1-9]000[1-9]000'
	UNION ALL SELECT '[1-9]0000[1-9]0000'
	UNION ALL SELECT '[1-9]00000[1-9]00000'

	UNION ALL SELECT '%1314%'		-- 一生一世
	UNION ALL SELECT '%53770%'		-- 我想亲亲你
	UNION ALL SELECT '%53719%'		-- 我深情依旧
	UNION ALL SELECT '%25184%'		-- 爱我一辈子
	UNION ALL SELECT '%1392010%'	-- 一生就爱你一人
	UNION ALL SELECT '%220250%'		-- 爱爱你爱爱我
	UNION ALL SELECT '%584520%'		--  我发誓我爱你
	UNION ALL SELECT '%246437%'		-- 爱是如此神奇
	UNION ALL SELECT '%1314925%'	-- 一生一世就爱我
	UNION ALL SELECT '%594230%'		-- 我就是爱想你
	UNION ALL SELECT '360%'			-- 想念你
	UNION ALL SELECT '%2010000%'	--  爱你一万年
	UNION ALL SELECT '1372%'		-- 一厢情愿
	UNION ALL SELECT '259695%'		-- 爱我就了解我
	UNION ALL SELECT '74839%'		-- 其实不想走
	UNION ALL SELECT '20999%'		-- 爱你久久久
	UNION ALL SELECT '829475%'		-- 被爱就是幸福
	-- 吉祥号码 End
	
	-------------------------------------------------------------------------	 

	-- 调试信息
	--IF @Debug=1 SELECT * FROM @tblFilterRules
	
-- 筛选规则 End
-------------------------------------------------------------------------


-------------------------------------------------------------------------
-- ID生产 Begin

	DECLARE @Reserve BIT
	SET @Reserve=0
	WHILE (@BeginGameID<=@EndGameID)
	BEGIN
		SET @Reserve=0

		-- 保留标识
		IF @BeginGameID<=@ReserveEnd
		BEGIN
			SET @Reserve=1
			--print '保留：'+STR(@BeginGameID)+'  ' + @TTRules
			INSERT ReserveIdentifier(GameID) VALUES (@BeginGameID)
		END
		ELSE
		BEGIN
			-------------------------------------------------------------------------
			DECLARE @TTRules VARCHAR(64)

			DECLARE CUR_GameIDList CURSOR FOR 
			SELECT Rules FROM @tblFilterRules

			OPEN CUR_GameIDList

			FETCH NEXT FROM CUR_GameIDList INTO @TTRules

			WHILE @@FETCH_STATUS = 0
			BEGIN
				IF @BeginGameID LIKE @TTRules
				BEGIN
					SET @Reserve=1
					--print '保留：'+STR(@BeginGameID)+'  ' + @TTRules
					INSERT ReserveIdentifier(GameID) VALUES (@BeginGameID)
					BREAK
				END
				

				FETCH NEXT FROM CUR_GameIDList into @TTRules
			END

			CLOSE CUR_GameIDList
			DEALLOCATE CUR_GameIDList
			-------------------------------------------------------------------------
		END
	
		IF @Reserve=0
		BEGIN
			--print '发布：'+STR(@BeginGameID)
			INSERT [GameIdentifier] (GameID) VALUES(@BeginGameID)		
		END	

		SET @BeginGameID=@BeginGameID+1
	END


-- ID生产 End
-------------------------------------------------------------------------

-- 重新分配
UPDATE AccountsInfo
SET AccountsInfo.Gameid=GameIdentifier.Gameid
FROM GameIdentifier
WHERE AccountsInfo.userid=GameIdentifier.userid


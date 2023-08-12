@echo off
echo *************************************************************************
echo                              荣耀版一键安装
echo     执行荣耀版数据库一键安装脚本，自动备份"C:\数据库\荣耀平台"目录下的数据库，
echo 自动创建荣耀版初始数据库。请按任意键继续...
echo *************************************************************************
pause
echo.
echo 正在清理数据库
Rem 数据库重置
net stop mssqlserver
set Ymd=%DATE:~0,4%%DATE:~5,2%%DATE:~8,2%%TIME:~0,2%%TIME:~3,2%%TIME:~6,2% 
md C:\数据库\荣耀平台备份\%ymd%
XCOPY C:\数据库\荣耀平台\* C:\数据库\荣耀平台备份\%ymd% /s  /e
if exist C:\数据库\荣耀平台 (echo y|cacls C:\数据库\荣耀平台 /p everyone:f >nul 2>nul &&rd /s /q C:\数据库\荣耀平台) 
md C:\数据库\荣耀平台
net start mssqlserver
set rootPath=1_1创建数据库\
osql -E -i "%rootPath%数据库删除.sql"

echo.
echo 建立数据库
set rootPath=1_1创建数据库\
osql -E -i "%rootPath%1_1_用户库脚本.sql"
osql -E -i "%rootPath%1_2_平台库脚本.sql"
osql -E -i "%rootPath%1_3_金币库脚本.sql"
osql -E -i "%rootPath%1_4_记录库脚本.sql"
osql -E -i "%rootPath%1_5_积分库脚本.sql"
osql -E -i "%rootPath%1_6_比赛库脚本.sql"
osql -E -i "%rootPath%1_7_练习库脚本.sql"

osql -E -i "%rootPath%2_1_用户库脚本.sql"
osql -E -i "%rootPath%2_2_平台库脚本.sql"
osql -E -i "%rootPath%2_3_金币库脚本.sql"
osql -E -i "%rootPath%2_4_记录库脚本.sql"
osql -E -i "%rootPath%2_5_积分库脚本.sql"
osql -E -i "%rootPath%2_6_比赛库脚本.sql"
osql -E -i "%rootPath%2_7_练习库脚本.sql"

echo.
echo 建立链接服务器
set rootPath=1_2创建链接服务器\
osql -E -i "%rootPath%1_1用户链接.sql"
osql -E -i "%rootPath%1_2平台链接.sql"
osql -E -i "%rootPath%1_3金币链接.sql"
osql -E -i "%rootPath%1_4记录链接.sql"
osql -E -i "%rootPath%1_5积分链接.sql"
osql -E -i "%rootPath%1_6比赛链接.sql"
osql -E -i "%rootPath%1_7练习链接.sql"

echo.
echo 建立初始数据
set rootPath=1_3创建初始数据\1_1用户初始数据\
osql -E -i "%rootPath%系统配置.sql"
osql -E -i "%rootPath%会员配置.sql"

set rootPath=1_3创建初始数据\1_2平台初始数据\
osql -E -i "%rootPath%道具关系.sql"
osql -E -i "%rootPath%道具类型.sql"
osql -E -i "%rootPath%道具配置.sql"
osql -E -i "%rootPath%等级配置.sql"
osql -E -i "%rootPath%类型配置.sql"
osql -E -i "%rootPath%签到配置.sql"
osql -E -i "%rootPath%子道具配置.sql"

set rootPath=1_3创建初始数据\1_3金币初始数据\
osql -E -i "%rootPath%返利配置.sql"
osql -E -i "%rootPath%列表配置.sql"

set rootPath=1_3创建初始数据\1_5积分初始数据\
osql -E -i "%rootPath%列表配置.sql"

set rootPath=1_3创建初始数据\1_6比赛初始数据\
osql -E -i "%rootPath%列表配置.sql"

set rootPath=1_3创建初始数据\1_7练习初始数据\
osql -E -i "%rootPath%列表配置.sql"

echo.
echo 建立存储过程
set rootPath=1_4创建存储过程\1_1用户数据库\
osql -E  -i "%rootPath%绑定机器.sql"
osql -E  -i "%rootPath%标识登录.sql"
osql -E  -i "%rootPath%代理列表.sql"
osql -E  -i "%rootPath%好友操作.sql"
osql -E  -i "%rootPath%好友查找.sql"
osql -E  -i "%rootPath%好友登录.sql"
osql -E  -i "%rootPath%好友消息.sql"
osql -E  -i "%rootPath%机器管理.sql"
osql -E  -i "%rootPath%加载机器.sql"
osql -E  -i "%rootPath%设置权限.sql"
osql -E  -i "%rootPath%实名验证.sql"
osql -E  -i "%rootPath%校验权限.sql"
osql -E  -i "%rootPath%校验资料.sql"
osql -E  -i "%rootPath%修改密码.sql"
osql -E  -i "%rootPath%修改签名.sql"
osql -E  -i "%rootPath%用户资料.sql"
osql -E  -i "%rootPath%帐号绑定.sql"
osql -E  -i "%rootPath%帐号登录.sql"
osql -E  -i "%rootPath%注册帐号.sql"
osql -E  -i "%rootPath%自定头像.sql"

set rootPath=1_4创建存储过程\1_2平台数据库\
osql -E  -i "%rootPath%背包管理.sql"
osql -E  -i "%rootPath%道具管理.sql"
osql -E  -i "%rootPath%等级管理.sql"
osql -E  -i "%rootPath%低保管理.sql"
osql -E  -i "%rootPath%房间管理.sql"
osql -E  -i "%rootPath%会员管理.sql"
osql -E  -i "%rootPath%加载节点.sql"
osql -E  -i "%rootPath%加载类型.sql"
osql -E  -i "%rootPath%加载敏感词.sql"
osql -E  -i "%rootPath%加载页面.sql"
osql -E  -i "%rootPath%加载种类.sql"
osql -E  -i "%rootPath%喇叭使用.sql"
osql -E  -i "%rootPath%连接信息.sql"
osql -E  -i "%rootPath%模块管理.sql"
osql -E  -i "%rootPath%平台配置.sql"
osql -E  -i "%rootPath%签到管理.sql"
osql -E  -i "%rootPath%等级管理.sql"
osql -E  -i "%rootPath%任务管理.sql"
osql -E  -i "%rootPath%实名配置.sql"
osql -E  -i "%rootPath%在线信息.sql"

set rootPath=1_4创建存储过程\1_3金币数据库\
osql -E  -i "%rootPath%标识登录.sql"
osql -E  -i "%rootPath%查询用户.sql"
osql -E  -i "%rootPath%兑换管理.sql"
osql -E  -i "%rootPath%加载机器.sql"
osql -E  -i "%rootPath%机器配置.sql"
osql -E  -i "%rootPath%加载配置.sql"
osql -E  -i "%rootPath%加载消息.sql"
osql -E  -i "%rootPath%离开房间.sql"
osql -E  -i "%rootPath%列表描述.sql"
osql -E  -i "%rootPath%设置权限.sql"
osql -E  -i "%rootPath%推广管理.sql"
osql -E  -i "%rootPath%写入费用.sql"
osql -E  -i "%rootPath%银行服务.sql"
osql -E  -i "%rootPath%游戏记录.sql"
osql -E  -i "%rootPath%游戏数据.sql"
osql -E  -i "%rootPath%游戏写分.sql"

set rootPath=1_4创建存储过程\1_5积分数据库\
osql -E  -i "%rootPath%标识登录.sql"
osql -E  -i "%rootPath%加载配置.sql"
osql -E  -i "%rootPath%加载消息.sql"
osql -E  -i "%rootPath%离开房间.sql"
osql -E  -i "%rootPath%列表描述.sql"
osql -E  -i "%rootPath%设置权限.sql"
osql -E  -i "%rootPath%游戏记录.sql"
osql -E  -i "%rootPath%游戏写分.sql"

set rootPath=1_4创建存储过程\1_6比赛数据库\
osql -E  -i "%rootPath%比赛管理.sql"
osql -E  -i "%rootPath%标识登录.sql"
osql -E  -i "%rootPath%加载配置.sql"
osql -E  -i "%rootPath%加载消息.sql"
osql -E  -i "%rootPath%开始结束.sql"
osql -E  -i "%rootPath%离开房间.sql"
osql -E  -i "%rootPath%列表描述.sql"
osql -E  -i "%rootPath%设置权限.sql"
osql -E  -i "%rootPath%写入费用.sql"
osql -E  -i "%rootPath%写入奖励.sql"
osql -E  -i "%rootPath%游戏记录.sql"
osql -E  -i "%rootPath%游戏写分.sql"

set rootPath=1_4创建存储过程\1_7练习数据库\
osql -E  -i "%rootPath%标识登录.sql"
osql -E  -i "%rootPath%加载配置.sql"
osql -E  -i "%rootPath%加载消息.sql"
osql -E  -i "%rootPath%离开房间.sql"
osql -E  -i "%rootPath%列表描述.sql"
osql -E  -i "%rootPath%设置权限.sql"
osql -E  -i "%rootPath%游戏记录.sql"
osql -E  -i "%rootPath%游戏写分.sql"

set rootPath=1_6私人房间\
osql -E  -i "%rootPath%房间费用.sql"
osql -E  -i "%rootPath%房间管理.sql"
osql -E  -i "%rootPath%房间配置.sql"
osql -E  -i "%rootPath%房卡管理.sql"
osql -E  -i "%rootPath%房卡信息.sql"
osql -E  -i "%rootPath%参与信息.sql"
osql -E  -i "%rootPath%积分写分.sql"
osql -E  -i "%rootPath%金币写分.sql"

echo.
echo *************************************************************************
echo 荣耀版一键安装已经建立荣耀版数据库
echo 按任意键生成网站数据
echo *************************************************************************
pause



TITLE 网狐荣耀数据库 自动安装中...请注意：安装过程中请勿关闭

md C:\数据库\网站数据

set rootPath=1.数据库脚本\
osql -E -i "%rootPath%1.数据库删除.sql"
osql -E -i "%rootPath%1_1_网站库脚本.sql"
osql -E -i "%rootPath%1_2_后台库脚本.sql"
osql -E -i "%rootPath%2_1_网站库脚本.sql"
osql -E -i "%rootPath%2_2_后台库脚本.sql"

set rootPath=2.数据脚本\
osql -E -i "%rootPath%充值服务.sql"
osql -E -i "%rootPath%后台数据.sql"
osql -E -i "%rootPath%实卡类型.sql"
osql -E -i "%rootPath%推广数据.sql"
osql -E -i "%rootPath%泡点设置.sql"
osql -E -i "%rootPath%独立页面.sql"
osql -E -i "%rootPath%站点配置.sql"
osql -E -i "%rootPath%系统广告.sql"
osql -E -i "%rootPath%网站链接.sql"
osql -E -i "%rootPath%转盘数据.sql"
osql -E -i "%rootPath%会员属性.sql"
osql -E -i "%rootPath%充值数据.sql"
osql -E -i "%rootPath%返利配置.sql"

set rootPath=3.存储过程\作业脚本\
osql -E -i "%rootPath%每日统计(作业).sql"
osql -E -i "%rootPath%统计玩家税收(作业).sql"
osql -E -i "%rootPath%统计代理充值(作业).sql"

set rootPath=3.存储过程\公共过程\
osql -d RYAccountsDB -E  -n -i "%rootPath%分页过程.sql"
osql -d RYGameMatchDB -E  -n -i "%rootPath%分页过程.sql"
osql -d RYGameScoreDB -E  -n -i "%rootPath%分页过程.sql"
osql -d RYNativeWebDB -E  -n -i "%rootPath%分页过程.sql"
osql -d RYPlatformDB -E  -n -i "%rootPath%分页过程.sql"
osql -d RYPlatformManagerDB -E  -n -i "%rootPath%分页过程.sql"
osql -d RYRecordDB -E  -n -i "%rootPath%分页过程.sql"
osql -d RYTreasureDB -E  -n -i "%rootPath%分页过程.sql"

osql -d RYAccountsDB -E  -n -i "%rootPath%切字符串.sql"
osql -d RYGameMatchDB -E  -n -i "%rootPath%切字符串.sql"
osql -d RYGameScoreDB -E  -n -i "%rootPath%切字符串.sql"
osql -d RYNativeWebDB -E  -n -i "%rootPath%切字符串.sql"
osql -d RYPlatformDB -E  -n -i "%rootPath%切字符串.sql"
osql -d RYPlatformManagerDB -E  -n -i "%rootPath%切字符串.sql"
osql -d RYRecordDB -E  -n -i "%rootPath%切字符串.sql"
osql -d RYTreasureDB -E  -n -i "%rootPath%切字符串.sql"

set rootPath=3.存储过程\函数\
osql -E -i "%rootPath%查询指定玩家的代理玩家.sql"

set rootPath=3.存储过程\前台脚本\本地数据库\
osql -E -i "%rootPath%推荐游戏.sql"
osql -E -i "%rootPath%购买奖品.sql"

set rootPath=3.存储过程\前台脚本\比赛数据库\
osql -E -i "%rootPath%比赛排行.sql"

set rootPath=3.存储过程\前台脚本\用户数据库\
osql -E -i "%rootPath%修改密码.sql"
osql -E -i "%rootPath%修改资料.sql"
osql -E -i "%rootPath%固定机器.sql"
osql -E -i "%rootPath%奖牌兑换.sql"
osql -E -i "%rootPath%每日签到.sql"
osql -E -i "%rootPath%用户全局信息.sql"
osql -E -i "%rootPath%用户名检测.sql"
osql -E -i "%rootPath%用户注册.sql"
osql -E -i "%rootPath%用户登录.sql"
osql -E -i "%rootPath%获取用户信息.sql"
osql -E -i "%rootPath%账户保护.sql"
osql -E -i "%rootPath%重置密码.sql"
osql -E -i "%rootPath%魅力兑换.sql"
osql -E -i "%rootPath%自定头像.sql"

set rootPath=3.存储过程\前台脚本\积分数据库\
osql -E -i "%rootPath%负分清零.sql"
osql -E -i "%rootPath%逃率清零.sql"

set rootPath=3.存储过程\前台脚本\网站数据库\
osql -E -i "%rootPath%更新浏览.sql"
osql -E -i "%rootPath%比赛报名.sql"
osql -E -i "%rootPath%获取新闻.sql"
osql -E -i "%rootPath%购买奖品.sql"
osql -E -i "%rootPath%问题反馈.sql"

set rootPath=3.存储过程\前台脚本\金币数据库\
osql -E -i "%rootPath%代理结算.sql"
osql -E -i "%rootPath%在线充值.sql"
osql -E -i "%rootPath%在线订单.sql"
osql -E -i "%rootPath%实卡充值.sql"
osql -E -i "%rootPath%推广中心.sql"
osql -E -i "%rootPath%推广信息.sql"
osql -E -i "%rootPath%苹果充值.sql"
osql -E -i "%rootPath%金币取款.sql"
osql -E -i "%rootPath%金币存款.sql"
osql -E -i "%rootPath%金币转账.sql"
osql -E -i "%rootPath%手游充值.sql"
osql -E -i "%rootPath%分享赠送.sql"
osql -E -i "%rootPath%转盘抽奖.sql"

set rootPath=3.存储过程\后台脚本\帐号库\
osql -E -i "%rootPath%插入限制IP.sql"
osql -E -i "%rootPath%插入限制机器码.sql"
osql -E -i "%rootPath%更新用户.sql"
osql -E -i "%rootPath%注册IP统计.sql"
osql -E -i "%rootPath%注册机器码统计.sql"
osql -E -i "%rootPath%添加用户.sql"
osql -E -i "%rootPath%创建代理.sql"

set rootPath=3.存储过程\后台脚本\平台库\
osql -E -i "%rootPath%在线统计.sql"

set rootPath=3.存储过程\后台脚本\数据分析\
osql -E -i "%rootPath%充值统计.sql"
osql -E -i "%rootPath%其他统计.sql"
osql -E -i "%rootPath%活跃统计.sql"
osql -E -i "%rootPath%用户统计.sql"
osql -E -i "%rootPath%金币分布.sql"

set rootPath=3.存储过程\后台脚本\权限库\
osql -E -i "%rootPath%权限加载.sql"
osql -E -i "%rootPath%用户表操作.sql"
osql -E -i "%rootPath%管理员登录.sql"
osql -E -i "%rootPath%菜单加载.sql"

set rootPath=3.存储过程\后台脚本\比赛库\
osql -E -i "%rootPath%比赛排名.sql"

set rootPath=3.存储过程\后台脚本\积分库\
osql -E -i "%rootPath%清零积分.sql"
osql -E -i "%rootPath%清零逃率.sql"
osql -E -i "%rootPath%赠送积分.sql"

set rootPath=3.存储过程\后台脚本\网站库\
osql -E -i "%rootPath%删商品类.sql"

set rootPath=3.存储过程\后台脚本\记录库\
osql -E -i "%rootPath%赠送会员.sql"
osql -E -i "%rootPath%赠送经验.sql"
osql -E -i "%rootPath%赠送金币.sql"
osql -E -i "%rootPath%赠送靓号.sql"

set rootPath=3.存储过程\后台脚本\金币库\
osql -E -i "%rootPath%代理分成详情.sql"
osql -E -i "%rootPath%增删道具.sql"
osql -E -i "%rootPath%实卡入库.sql"
osql -E -i "%rootPath%实卡统计.sql"
osql -E -i "%rootPath%数据汇总.sql"
osql -E -i "%rootPath%新增实卡.sql"
osql -E -i "%rootPath%游戏记录.sql"
osql -E -i "%rootPath%统计记录.sql"
osql -E -i "%rootPath%赠送金币.sql"
osql -E -i "%rootPath%转账税收.sql"
osql -E -i "%rootPath%统计代理充值(手工执行).sql"
osql -E -i "%rootPath%统计玩家税收(手工执行).sql"

set rootPath=4.创建作业\
osql -E -i "%rootPath%创建作业.sql"
osql -E -i "%rootPath%代理充值统计.sql"
osql -E -i "%rootPath%税收统计.sql"

pause

COLOR 0A
CLS
@echo off
CLS
echo ------------------------------
echo.
echo. 数据库建立完成
echo.
echo ------------------------------



echo.
echo *************************************************************************
echo 所有虎踞已经建立完成
echo 无需生成游戏标识，请直接关闭
echo 需要生成游戏标识，请按任意键继续 
echo *************************************************************************
pause

CLS
echo.
@echo 建立游戏标识
set rootPath=1_5创建游戏标识\
osql -E  -i "%rootPath%标识生成.sql"
@echo 建立游戏标识
CLS
@echo off
echo *************************************************************************
echo.
echo 荣耀版一键安装脚本建立完成 
echo.
echo.
echo 版权所有： 深圳市网狐科技有限公司
echo *************************************************************************

pause


pause



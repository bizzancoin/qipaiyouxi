local cmd = {}

--[[
******
* 结构体描述
* {k = "key", t = "type", s = len, l = {}}
* k 表示字段名,对应C++结构体变量名
* t 表示字段类型,对应C++结构体变量类型
* s 针对string变量特有,描述长度
* l 针对数组特有,描述数组长度,以table形式,一维数组表示为{N},N表示数组长度,多维数组表示为{N,N},N表示数组长度
* d 针对table类型,即该字段为一个table类型
* ptr 针对数组,此时s必须为实际长度

** egg
* 取数据的时候,针对一维数组,假如有字段描述为 {k = "a", t = "byte", l = {3}}
* 则表示为 变量a为一个byte型数组,长度为3
* 取第一个值的方式为 a[1][1],第二个值a[1][2],依此类推

* 取数据的时候,针对二维数组,假如有字段描述为 {k = "a", t = "byte", l = {3,3}}
* 则表示为 变量a为一个byte型二维数组,长度都为3
* 则取第一个数组的第一个数据的方式为 a[1][1], 取第二个数组的第一个数据的方式为 a[2][1]
******
]]

--游戏版本
cmd.VERSION 					= appdf.VersionValue(6,7,0,1)
--游戏标识
cmd.KIND_ID						= 131
	
--游戏人数
cmd.GAME_PLAYER					= 100

--房间名长度
cmd.SERVER_LEN					= 32

--游戏记录长度
cmd.RECORD_LEN					= 3

--视图位置
cmd.MY_VIEWID					= 2

--区域索引 (lua的table默认下标为1，所以使用的过程中应当加1)
cmd.AREA_XIAN					= 0									--闲家索引
cmd.AREA_PING					= 1									--平家索引
cmd.AREA_ZHUANG					= 2									--庄家索引

cmd.AREA_MAX					= 3									--最大区域

--区域倍数multiple
cmd.MULTIPLE_XIAN				= 2									--闲家倍数
cmd.MULTIPLE_PING				= 9									--平家倍数
cmd.MULTIPLE_ZHUANG				= 2									--庄家倍数

--占座索引
cmd.SEAT_LEFT1_INDEX            = 0                                 --左一
cmd.SEAT_LEFT2_INDEX            = 1                                 --左二
cmd.SEAT_LEFT3_INDEX            = 2                                 --左三
cmd.SEAT_LEFT4_INDEX            = 3                                 --左四
cmd.SEAT_RIGHT1_INDEX           = 4                                 --右一
cmd.SEAT_RIGHT2_INDEX           = 5                                 --右二
cmd.SEAT_RIGHT3_INDEX           = 6                                 --右三
cmd.SEAT_RIGHT4_INDEX           = 7                                 --右四
cmd.MAX_OCCUPY_SEAT_COUNT       = 8                                 --最大占位个数
cmd.SEAT_INVALID_INDEX          = 9                                 --无效索引

--空闲状态
cmd.GAME_SCENE_FREE				= 0
--游戏开始
cmd.GAME_START 					= 1
--游戏进行
cmd.GAME_PLAY					= 100
--下注状态
cmd.GAME_JETTON					= 100
--游戏结束
cmd.GAME_END					= 101

--游戏倒计时
cmd.kGAMEFREE_COUNTDOWN			= 1
cmd.kGAMEPLAY_COUNTDOWN			= 2
cmd.kGAMEOVER_COUNTDOWN			= 3

---------------------------------------------------------------------------------------
--服务器命令结构

--游戏空闲
cmd.SUB_S_GAME_FREE				= 99
--游戏开始
cmd.SUB_S_GAME_START			= 100
--用户下注
cmd.SUB_S_PLACE_JETTON			= 101
--游戏结束
cmd.SUB_S_GAME_END				= 102
--申请庄家
cmd.SUB_S_APPLY_BANKER			= 103
--切换庄家
cmd.SUB_S_CHANGE_BANKER			= 104
--更新积分
cmd.SUB_S_CHANGE_USER_SCORE		= 105
--游戏记录
cmd.SUB_S_SEND_RECORD			= 106
--下注失败
cmd.SUB_S_PLACE_JETTON_FAIL		= 107
--取消申请
cmd.SUB_S_CANCEL_BANKER			= 108
--管理员命令
cmd.SUB_S_AMDIN_COMMAND			= 109
--更新库存
cmd.SUB_S_UPDATE_STORAGE		= 110
--发送下注(服务端消息)
cmd.SUB_S_SEND_USER_BET_INFO    = 111
--发送下注(服务端消息)
cmd.SUB_S_USER_SCORE_NOTIFY     = 112
--超级抢庄
cmd.SUB_S_SUPERROB_BANKER       = 113
--超级抢庄玩家离开
cmd.SUB_S_CURSUPERROB_LEAVE     = 114
--占位
cmd.SUB_S_OCCUPYSEAT            = 115
--占位失败
cmd.SUB_S_OCCUPYSEAT_FAIL       = 116
--更新占位
cmd.SUB_S_UPDATE_OCCUPYSEAT     = 117

--彩金
cmd.SUB_S_CAIJING_RECORD = 119

cmd.CMD_S_CaiJingRecord =
{
	{t="score",k="lCaiJing"},--彩金
    {t = "tchar", k = "szNickname", s = 32},
    {t = "tchar", k = "szTime", s = 32},
}
---------------------------------------------------------------------------------------

------
--超级抢庄配置

--超级抢庄
cmd.SUPERBANKER_VIPTYPE = 0;
cmd.SUPERBANKER_CONSUMETYPE = 1;

--会员
cmd.VIP1_INDEX = 1;
cmd.VIP2_INDEX = 2;
cmd.VIP3_INDEX = 3;
cmd.VIP4_INDEX = 4;
cmd.VIP5_INDEX = 5;
cmd.VIP_INVALID = 6;

--配置结构
cmd.SUPERBANKERCONFIG = 
{
    --抢庄类型
    {k = "superbankerType", t = "int"},
    --vip索引
    {k = "enVipIndex", t = "int"},
    --抢庄消耗
    {k = "lSuperBankerConsume", t = "score"}
}

--当前庄家类型
cmd.ORDINARY_BANKER = 0;    --普通玩家
cmd.SUPERROB_BANKER = 1;    --超级抢庄玩家
cmd.INVALID_SYSBANKER = 2;  --无效类型(系统庄家)
------

------
--占位配置
cmd.OCCUPYSEAT_VIPTYPE = 0          --会员占位
cmd.OCCUPYSEAT_CONSUMETYPE = 1      --消耗金币占位
cmd.OCCUPYSEAT_FREETYPE = 2         --免费占位

--占位配置结构
cmd.OCCUPYSEATCONFIG = 
{
    --占位类型
    {k = "occupyseatType", t = "int"},
    --vip索引
    {k = "enVipIndex", t = "int"},
    --占位消耗
    {k = "lOccupySeatConsume", t = "score"},
    --免费占位金币上限
    {k = "lOccupySeatFree", t = "score"},
    --强制站立条件
    {k = "lForceStandUpCondition", t = "score"}
}
------

--记录信息
cmd.tagServerGameRecord = 
{	
	cbKinWinner = 0,
	bPlayerTwoPair = false,
	bBankerTwoPair = false,
	cbPlayerCount = 0,
	cbBankerCount = 0
}

--超级抢庄
cmd.CMD_S_SuperRobBanker = 
{
    {k = "bSucceed", t = "bool"},
    {k = "wApplySuperRobUser", t = "word"},     --申请玩家
    {k = "wCurSuperRobBankerUser", t = "word"}  --当前玩家
}

--超级抢庄玩家离开
cmd.CMD_S_CurSuperRobLeave = 
{
    {k = "wCurSuperRobBankerUser", t = "word"}
}

--机器人配置
cmd.tagCustomAndroid = 
{
    --坐庄
    --是否做庄
    {k = "nEnableRobotBanker", t = "bool"},
    --坐庄次数
    {k = "lRobotBankerCountMin", t = "score"},
    --坐庄次数
    {k = "lRobotBankerCountMax", t = "score"},
    --列表人数
    {k = "lRobotListMinCount", t = "score"},
    --列表人数
    {k = "lRobotListMaxCount", t = "score"},
    --最多申请个数
    {k = "lRobotApplyBanker", t = "score"},
    --空盘重申
    {k = "lRobotWaitBanker", t = "score"},
    
    --下注
    --下注筹码个数
    {k = "lRobotMinBetTime", t = "score"},
    --下注筹码个数
    {k = "lRobotMaxBetTime", t = "score"},
    --下注筹码金额
    {k = "lRobotMinJetton", t = "score"},
    --下注筹码金额
    {k = "lRobotMaxJetton", t = "score"},
    --下注机器人数
    {k = "lRobotBetMinCount", t = "score"},
    --下注机器人数
    {k = "lRobotBetMaxCount", t = "score"},
    --区域限制
    {k = "lRobotAreaLimit", t = "score"},
    
    --存取款
    --金币下限
    {k = "lRobotScoreMin", t = "score"},
    --金币上限
    {k = "lRobotScoreMax", t = "score"},
    --取款最小值(非庄)
    {k = "lRobotBankGetMin", t = "score"},
    --取款最大值(非庄)
    {k = "lRobotBankGetMax", t = "score"},
    --取款最小值(坐庄)
    {k = "lRobotBankGetBankerMin", t = "score"},
    --取款最大值(坐庄)
    {k = "lRobotBankGetBankerMax", t = "score"},
    --存款百分比
    {k = "lRobotBankStoMul", t = "score"},
    
    --区域几率
    {k = "nAreaChance", t = "int", l = {cmd.AREA_MAX}},
}

--下注失败
cmd.CMD_S_PlaceBetFail =
{
	--下注玩家
	{k = "wPlaceUser", t = "word"},
	--下注区域
	{k = "cbBetArea", t = "byte"},
	--下注数额
	{k = "lPlaceScore", t = "score"}
}

--申请庄家
cmd.CMD_S_ApplyBanker = 
{
	--申请庄家
	{k = "wApplyUser", t = "word"}
}

--取消申请
cmd.CMD_S_CancelBanker =
{
	--取消玩家
	{k = "wCancelUser", t = "word"}
}

--切换庄家
cmd.CMD_S_ChangeBanker = 
{
	--当庄玩家
	{k = "wBankerUser", t = "word"},
	--庄家分数
	{k = "lBankerScore", t = "score"},
    --庄家类型
   -- {k = "typeCurrentBanker", t = "int"}
}

--游戏状态 free
cmd.CMD_S_StatusFree = 
{
    --彩金
    {t="score",k="lCaiJing"},
	--剩余时间
	{k = "cbTimeLeave", t = "byte"},
	--玩家自由金币
	{k = "lPlayFreeScore", t = "score"},
	--当前庄家
	{k = "wBankerUser", t = "word"},
	--庄家分数
	{k = "lBankerScore", t = "score"},
	--庄家赢分
	{k = "lBankerWinScore", t = "score"},
	--庄家局数
	{k = "wBankerTime", t = "word"},						
    
    --是否允许系统坐庄
    {k = "bEnableSysBanker", t = "bool"},
    --控制信息									
    {k = "lApplyBankerCondition", t = "score"},				--申请条件
    {k = "lAreaLimitScore", t = "score"},					--区域限制
    
    --房间信息 SERVER_LEN										
    {k = "szGameRoomName", t = "string", s = cmd.SERVER_LEN},					--房间名称
    {k = "bGenerEducate", t = "bool"},	                             --是否练习场					
    {k = "CustomAndroid", t = "table", d = cmd.tagCustomAndroid},  --机器人配置

    --抢庄配置
    {k = "superbankerConfig", t = "table", d = cmd.SUPERBANKERCONFIG}, 
    {k = "wCurSuperRobBankerUser", t = "word"},
    --庄家类型
    {k = "typeCurrentBanker", t = "int"},

    --占位配置
    {k = "occupyseatConfig", t = "table", d = cmd.OCCUPYSEATCONFIG},
    --占位椅子id MAX_OCCUPY_SEAT_COUNT
    {k = "wOccupySeatChairID", t = "word", l = {cmd.MAX_OCCUPY_SEAT_COUNT}},
}

--游戏状态 play/jetton
cmd.CMD_S_StatusPlay = 
{
    --彩金
    {t="score",k="lCaiJing"},

	--全局信息					
    {k = "cbTimeLeave", t = "byte"},					--剩余时间					
    {k = "cbGameStatus", t = "byte"},					--游戏状态
    
    --下注数 AREA_MAX						
    {k = "lAllBet", t = "score", l = {cmd.AREA_MAX}},	--总下注		
    {k = "lPlayBet", t = "score", l = {cmd.AREA_MAX}},	--玩家下注
    
    --玩家积分				
    {k = "lPlayBetScore", t = "score"},					--玩家最大下注	
    {k = "lPlayFreeSocre", t = "score"},				--玩家自由鹿豆
    
    --玩家输赢 AREA_MAX						
    {k = "lPlayScore", t = "score", l = {cmd.AREA_MAX}},--玩家输赢
    {k = "lPlayAllScore", t = "score"},       
    {k = "lRevenue", t = "score"},						--税收
    --玩家成绩
    
    --庄家信息					
    {k = "wBankerUser", t = "word"},					--当前庄家	
    {k = "lBankerScore", t = "score"},					--庄家分数		
    {k = "lBankerWinScore", t = "score"},				--庄家赢分		
    {k = "wBankerTime", t = "word"},					--庄家局数
    
    --是否系统坐庄					
    {k = "bEnableSysBanker", t = "bool"},				--系统做庄
    
    --控制信息			
    {k = "lApplyBankerCondition", t = "score"},			--申请条件		
    {k = "lAreaLimitScore", t = "score"},				--区域限制
    
    --扑克信息 2				
    {k = "cbCardCount", t = "byte", l = {2}},			--扑克数目
    {k = "cbTableCardArray", t = "byte", l = {3,3}},	--桌面扑克 2,3
    
    --房间信息 SERVER_LEN				
    {k = "szGameRoomName", t = "string", s = cmd.SERVER_LEN},	--房间名称
    {k = "bGenerEducate", t = "bool"},	                         --是否练习场
    {k = "CustomAndroid", t = "table", d = cmd.tagCustomAndroid}, --机器人配置

    {k = "superbankerConfig", t = "table", d = cmd.SUPERBANKERCONFIG},  --抢庄配置
    {k = "wCurSuperRobBankerUser", t = "word"},
    --庄家类型
    {k = "typeCurrentBanker", t = "int"},

    --占位配置
    {k = "occupyseatConfig", t = "table", d = cmd.OCCUPYSEATCONFIG},
    --占位椅子id MAX_OCCUPY_SEAT_COUNT
    {k = "wOccupySeatChairID", t = "word", l = {cmd.MAX_OCCUPY_SEAT_COUNT}},

    --占位玩家成绩
    {k = "lOccupySeatUserWinScore", t = "score", l = {cmd.MAX_OCCUPY_SEAT_COUNT}},
}

--游戏空闲
cmd.CMD_S_GameFree = 
{
    --彩金
    {t="score",k="lCaiJing"},

    {k = "cbTimeLeave", t = "byte"}
}

--游戏开始
cmd.CMD_S_GameStart = 
{
    --剩余时间
    {k = "cbTimeLeave", t = "byte"},
    
    --庄家位置
    {k = "wBankerUser", t = "word"},
    --庄家金币
    {k = "lBankerScore", t = "score"},
    
    --玩家最大下注
    {k = "lPlayBetScore", t = "score"},
    --玩家自由金币
    {k = "lPlayFreeSocre", t = "score"},
    
    --人数上限 (下注机器人)
    {k = "nChipRobotCount", t = "int"},
    --列表人数
    {k = "nListUserCount", t = "int"},
    --机器人列表人数
    {k = "nAndriodCount", t = "int"},
};

--用户下注
cmd.CMD_S_PlaceBet = 
{
    --用户位置
    {k = "wChairID", t = "word"},
    --筹码区域
    {k = "cbBetArea", t = "byte"},
    --加注数目
    {k = "lBetScore", t = "score"},
    --机器标识
    {k = "cbAndroidUser", t = "byte"},
    --机器标识
    {k = "cbAndroidUserT", t = "byte"},
};

--游戏结束
cmd.CMD_S_GameEnd = 
{
    --下局信息
    --剩余时间
    {k = "cbTimeLeave", t = "byte"},
    
    --扑克信息 2
    {k = "cbCardCount", t = "byte", l = {2}},			--扑克数目
    {k = "cbTableCardArray", t = "byte", l = {3,3}},	--桌面扑克 2,3
    
    --庄家信息
    --庄家成绩
    {k = "lBankerScore", t = "score"},
    --庄家成绩
    {k = "lBankerTotallScore", t = "score"},
    --做庄次数
    {k = "nBankerTime", t = "int"},
    
    --玩家成绩
    --玩家成绩 AREA_MAX
    {k = "lPlayScore", t = "score", l = {cmd.AREA_MAX}},
    --玩家成绩
    {k = "lPlayAllScore", t = "score"},
    
    --全局信息
    --游戏税收
    {k = "lRevenue", t = "score"},

    --占位玩家成绩
    {k = "lOccupySeatUserWinScore", t = "score", l = {cmd.MAX_OCCUPY_SEAT_COUNT}},
}

--占位
cmd.CMD_S_OccupySeat = 
{
    --申请占位玩家id
    {k = "wOccupySeatChairID", t = "word"},
    --占位索引
    {k = "cbOccupySeatIndex", t = "byte"},
    --占位椅子id
    {k = "tabWOccupySeatChairID", t = "word", l = {cmd.MAX_OCCUPY_SEAT_COUNT}},
}

--占位失败
cmd.CMD_S_OccupySeat_Fail = 
{
    --已申请占位玩家ID
    {k = "wAlreadyOccupySeatChairID", t = "word"},
    --已占位索引
    {k = "cbAlreadyOccupySeatIndex", t = "byte"},
    --占位椅子id
    {k = "tabWOccupySeatChairID", t = "word", l = {cmd.MAX_OCCUPY_SEAT_COUNT}},
}

--更新占位
cmd.CMD_S_UpdateOccupySeat = 
{
    --占位椅子id
    {k = "tabWOccupySeatChairID", t = "word", l = {cmd.MAX_OCCUPY_SEAT_COUNT}},
    --申请退出占位玩家
    {k = "wQuitOccupySeatChairID", t = "word"},
}

---------------------------------------------------------------------------------------
--客户端命令结构

--用户下注
cmd.SUB_C_PLACE_JETTON				= 1
--申请庄家
cmd.SUB_C_APPLY_BANKER				= 2
--取消申请
cmd.SUB_C_CANCEL_BANKER				= 3
--管理员命令
cmd.SUB_C_AMDIN_COMMAND				= 4
--更新库存
cmd.SUB_C_UPDATE_STORAGE			= 5
--超级抢庄
cmd.SUB_C_SUPERROB_BANKER           = 6
--占位
cmd.SUB_C_OCCUPYSEAT                = 7                                   
--退出占位
cmd.SUB_C_QUIT_OCCUPYSEAT           = 8  
--重复下注       
cmd.SUB_C_REPEAT_BET           = 9                                                            
---------------------------------------------------------------------------------------

--用户下注
cmd.CMD_C_PlaceBet = 
{
	--筹码区域
	{k = "cbBetArea", t = "byte"},
	--加注数目
	{k = "lBetScore", t = "score"}
}

--占位
cmd.CMD_C_OccupySeat = 
{
    --占位玩家
    {k = "wOccupySeatChairID", t = "word"},
    --占位索引
    {k = "cbOccupySeatIndex", t = "byte"},
}

cmd.RES_PATH 					=	"rhbattle/res/"
print("********************************************************load cmd");
return cmd
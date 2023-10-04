#ifndef CMD_OXSIXX_HEAD_FILE
#define CMD_OXSIXX_HEAD_FILE

#pragma pack(push)  
#pragma pack(1)

#define		CARD_CONFIG

//////////////////////////////////////////////////////////////////////////
//公共宏定义
#define KIND_ID							57									//游戏 I D
#define GAME_PLAYER						8									//游戏人数
#define GAME_NAME						TEXT("八人牛牛")					//游戏名字
#define MAX_CARDCOUNT					5									//最大数目
#define MAX_CONFIG						5									//最大配置个数
#define MAX_RECORD_COUNT				30									//房卡结算统计最大局数
#define MAX_CARD_TYPE					19									//最大牌型
#define MAX_SPECIAL_CARD_TYPE			9									//最大特殊牌型 依次四五花牛，顺子同花葫芦炸弹同花顺五小牛 有无大小王
#define MAX_BANKERMODE					6									//最大庄家模式 依次霸王庄，倍数抢庄，牛牛上庄，无牛下庄，自由抢庄，通比玩法
#define MAX_GAMEMODE					2									//最大游戏模式 依次经典模式，疯狂模式
#define MAX_BEBANKERCON					4									//最大上庄分数	默认无，100，150，200
#define MAX_USERBETTIMES				4									//最大闲家推注倍数	默认无，5，10，20
#define MAX_ADVANCECONFIG				5									//最大高级选项  依次发四等五， 需要密码， 开始禁止加入， 禁止搓牌，房卡断线代打

#define VERSION_SERVER					PROCESS_VERSION(7,0,1)				//程序版本
#define VERSION_CLIENT					PROCESS_VERSION(7,0,1)				//程序版本

//游戏状态
#define GS_TK_FREE						GAME_STATUS_FREE					//等待开始
#define GS_TK_CALL						GAME_STATUS_PLAY					//叫庄状态
#define GS_TK_SCORE						GAME_STATUS_PLAY+1					//下注状态
#define GS_TK_PLAYING					GAME_STATUS_PLAY+2					//游戏进行

//命令消息
#define IDM_ADMIN_UPDATE_STORAGE		WM_USER+1001
#define IDM_ADMIN_MODIFY_STORAGE		WM_USER+1011
#define IDM_REQUEST_QUERY_USER			WM_USER+1012
#define IDM_USER_DEBUG				WM_USER+1013
#define IDM_REQUEST_UPDATE_ROOMINFO		WM_USER+1014
#define IDM_CLEAR_CURRENT_QUERYUSER		WM_USER+1015

//操作记录
#define MAX_OPERATION_RECORD			20									//操作记录条数
#define RECORD_LENGTH					128									//每条记录字长

#define INVALID_LONGLONG				((LONGLONG)(0xFFFFFFFF))			//无效数值

//游戏记录
struct CMD_S_RECORD
{
	int									nCount;
	LONGLONG							lUserWinCount[GAME_PLAYER];						//玩家胜利次数
	LONGLONG							lUserLostCount[GAME_PLAYER];					//玩家失败次数
};

//-------------------------------------------
//游戏牌型
typedef enum
{
	CT_CLASSIC_ = 22,						//经典模式
	CT_ADDTIMES_ = 23,						//疯狂加倍
	CT_INVALID_ = 255,						//无效
}CARDTYPE_CONFIG;

//发牌模式
typedef enum
{
	ST_SENDFOUR_ = 32,						//发四等五
	ST_BETFIRST_ = 33,						//下注发牌
	ST_INVALID_ = 255,						//无效
}SENDCARDTYPE_CONFIG;

//扑克玩法
typedef enum
{
	GT_HAVEKING_ = 42,						//有大小王
	GT_NOKING_ = 43,						//无大小王
	GT_INVALID_ = 255,						//无效
}KING_CONFIG;

//庄家玩法
typedef enum
{
	BGT_DESPOT_ = 52,						//霸王庄
	BGT_ROB_ = 53,							//倍数抢庄
	BGT_NIUNIU_ = 54,						//牛牛上庄
	BGT_NONIUNIU_ = 55,						//无牛下庄

	BGT_FREEBANKER_ = 56,					//自由抢庄
	BGT_TONGBI_ = 57,						//通比玩法

	BGT_INVALID_ = 255,						//无效
}BANERGAMETYPE_CONFIG;

//下注配置
typedef enum
{
	BT_FREE_ = 62,							//自由配置额度
	BT_PENCENT_ = 63,						//百分比配置额度
	BT_INVALID_ = 255,						//无效
}BETTYPE_CONFIG;

//推注类型(只在积分房卡有效)
typedef enum
{
	BT_TUI_NONE_ = 72,						//无推注
	BT_TUI_DOUBLE_ = 73,					//翻倍推注(上局赢的总额的翻倍为本局推注的额度)
	BT_TUI_INVALID_ = 255,					//无效
}TUITYPE_CONFIG;

//-------------------------------------------

//////////////////////////////////////////////////////////////////////////
//服务器命令结构
#define SUB_S_GAME_START				100									//游戏开始
#define SUB_S_ADD_SCORE					101									//加注结果
#define SUB_S_PLAYER_EXIT				102									//用户强退
#define SUB_S_SEND_CARD					103									//发牌消息
#define SUB_S_GAME_END					104									//游戏结束
#define SUB_S_OPEN_CARD					105									//用户摊牌
#define SUB_S_CALL_BANKER				106									//用户叫庄
#define SUB_S_CALL_BANKERINFO			107									//用户叫庄信息
#define SUB_S_ADMIN_STORAGE_INFO		112									//刷新调试服务端
#define SUB_S_RECORD					113									//游戏记录
#define SUB_S_ROOMCARD_RECORD			114									//房卡记录

#define SUB_S_REQUEST_QUERY_RESULT		115									//查询用户结果
#define SUB_S_USER_DEBUG				116									//用户调试
#define SUB_S_USER_DEBUG_COMPLETE		117									//用户调试完成
#define SUB_S_OPERATION_RECORD		    118									//操作记录
#define SUB_S_REQUEST_UDPATE_ROOMINFO_RESULT 119
#define SUB_S_SEND_FOUR_CARD			120
#define SUB_S_ANDROID_BANKOPER			122									//AI存储款操作
#define SUB_S_ANDROID_READY				124									//AI准备

//////////////////////////////////////////////////////////////////////////////////////

//预留AI存款取款
struct tagCustomAndroid
{
	SCORE								lRobotScoreMin;	
	SCORE								lRobotScoreMax;
	SCORE	                            lRobotBankGet; 
	SCORE								lRobotBankGetBanker; 
	SCORE								lRobotBankStoMul; 
};

//调试类型
typedef enum{CONTINUE_WIN, CONTINUE_LOST, CONTINUE_CANCEL}DEBUG_TYPE;

//调试结果      调试成功 、调试失败 、调试取消成功 、调试取消无效
typedef enum{DEBUG_SUCCEED, DEBUG_FAIL, DEBUG_CANCEL_SUCCEED, DEBUG_CANCEL_INVALID}DEBUG_RESULT;

//用户行为
typedef enum{USER_SITDOWN = 11, USER_STANDUP, USER_OFFLINE, USER_RECONNECT}USERACTION;

//调试信息
typedef struct
{
	DEBUG_TYPE						debug_type;					  //调试类型
	BYTE								cbDebugCount;					  //调试局数
	bool							    bCancelDebug;					  //取消标识
}USERDEBUG;

//房间用户信息
typedef struct
{
	WORD								wChairID;							//椅子ID
	WORD								wTableID;							//桌子ID
	DWORD								dwGameID;							//GAMEID
	bool								bAndroid;							//AI标识
	TCHAR								szNickName[LEN_NICKNAME];			//用户昵称
	BYTE								cbUserStatus;						//用户状态
	BYTE								cbGameStatus;						//游戏状态
}ROOMUSERINFO;

//房间用户调试
typedef struct
{
	ROOMUSERINFO						roomUserInfo;						//房间用户信息
	USERDEBUG							userDebug;						//用户调试
}ROOMUSERDEBUG;

//////////////////////////////////////////////////////////////////////////////////////

//游戏状态
struct CMD_S_StatusFree
{
	LONGLONG							lCellScore;							//基础积分
	LONGLONG							lRoomStorageStart;					//房间起始库存
	LONGLONG							lRoomStorageCurrent;				//房间当前库存

	//历史积分
	LONGLONG							lTurnScore[GAME_PLAYER];			//积分信息
	LONGLONG							lCollectScore[GAME_PLAYER];			//积分信息
	tagCustomAndroid					CustomAndroid;						//AI配置

	bool								bIsAllowAvertDebug;					//反调试标志
	
	CARDTYPE_CONFIG						ctConfig;							//游戏牌型
	SENDCARDTYPE_CONFIG					stConfig;							//发牌模式
	BANERGAMETYPE_CONFIG				bgtConfig;							//庄家玩法
	BETTYPE_CONFIG						btConfig;							//下注配置
	KING_CONFIG							gtConfig;							//有无大小王

	WORD								wGamePlayerCountRule;				//2-6人为0，其他的人数多少值为多少
	BYTE								cbAdmitRevCard;						//允许搓牌 TRUE为允许

	BYTE								cbPlayMode;							//约战游戏模式
};

//叫庄状态
struct CMD_S_StatusCall
{
	LONGLONG							lCellScore;							//基础积分
	BYTE                                cbDynamicJoin;                      //动态加入 
	BYTE                                cbPlayStatus[GAME_PLAYER];          //用户状态

	LONGLONG							lRoomStorageStart;					//房间起始库存
	LONGLONG							lRoomStorageCurrent;				//房间当前库存

	//历史积分
	LONGLONG							lTurnScore[GAME_PLAYER];			//积分信息
	LONGLONG							lCollectScore[GAME_PLAYER];			//积分信息
	tagCustomAndroid					CustomAndroid;						//AI配置

	bool								bIsAllowAvertDebug;					//反调试标志
	
	BYTE								cbCallBankerStatus[GAME_PLAYER];	//叫庄状态
	BYTE								cbCallBankerTimes[GAME_PLAYER];		//叫庄倍数
	CARDTYPE_CONFIG						ctConfig;							//游戏牌型
	SENDCARDTYPE_CONFIG					stConfig;							//发牌模式
	BANERGAMETYPE_CONFIG				bgtConfig;							//庄家玩法 (自由抢庄默认都抢1倍)
	BETTYPE_CONFIG						btConfig;							//下注配置
	KING_CONFIG							gtConfig;							//有无大小王

	WORD								wGamePlayerCountRule;				//2-6人为0，其他的人数多少值为多少
	BYTE								cbAdmitRevCard;						//允许搓牌 TRUE为允许
	BYTE								cbMaxCallBankerTimes;				//最大抢庄倍数
	WORD								wBgtRobNewTurnChairID;				//倍数抢庄新开一局抢庄的玩家（无效为INVALID_CHAIR， 当有效时候只能这个玩家选择倍数，并且该玩家是庄家）

	BYTE								cbPlayMode;							//约战游戏模式
	BYTE								cbTimeRemain;						//重连剩余秒数
};

//下注状态
struct CMD_S_StatusScore
{
	LONGLONG							lCellScore;							//基础积分
	BYTE                                cbPlayStatus[GAME_PLAYER];          //用户状态
	BYTE                                cbDynamicJoin;                      //动态加入
	LONGLONG							lTurnMaxScore;						//最大下注
	LONGLONG							lTableScore[GAME_PLAYER];			//下注数目
	WORD								wBankerUser;						//庄家用户

	LONGLONG							lRoomStorageStart;					//房间起始库存
	LONGLONG							lRoomStorageCurrent;				//房间当前库存

	//历史积分
	LONGLONG							lTurnScore[GAME_PLAYER];			//积分信息
	LONGLONG							lCollectScore[GAME_PLAYER];			//积分信息
	tagCustomAndroid					CustomAndroid;						//AI配置

	bool								bIsAllowAvertDebug;					//反调试标志

	BYTE								cbCardData[GAME_PLAYER][MAX_CARDCOUNT];	//用户扑克
	BYTE								cbCallBankerTimes[GAME_PLAYER];		//叫庄倍数
	CARDTYPE_CONFIG						ctConfig;							//游戏牌型
	SENDCARDTYPE_CONFIG					stConfig;							//发牌模式
	BANERGAMETYPE_CONFIG				bgtConfig;							//庄家玩法
	BETTYPE_CONFIG						btConfig;							//下注配置
	KING_CONFIG							gtConfig;							//有无大小王

	LONG								lFreeConfig[MAX_CONFIG];			//自由配置额度(无效值0)
	LONG								lPercentConfig[MAX_CONFIG];			//百分比配置额度(无效值0)
	LONG								lPlayerBetBtEx[GAME_PLAYER];		//闲家额外的推注筹码

	WORD								wGamePlayerCountRule;				//2-6人为0，其他的人数多少值为多少
	BYTE								cbAdmitRevCard;						//允许搓牌 TRUE为允许

	BYTE								cbPlayMode;							//约战游戏模式
	BYTE								cbTimeRemain;						//重连剩余秒数
};

//游戏状态
struct CMD_S_StatusPlay
{
	LONGLONG							lCellScore;							//基础积分
	BYTE                                cbPlayStatus[GAME_PLAYER];          //用户状态
	BYTE                                cbDynamicJoin;                      //动态加入
	LONGLONG							lTurnMaxScore;						//最大下注
	LONGLONG							lTableScore[GAME_PLAYER];			//下注数目
	WORD								wBankerUser;						//庄家用户

	LONGLONG							lRoomStorageStart;					//房间起始库存
	LONGLONG							lRoomStorageCurrent;				//房间当前库存

	//扑克信息
	BYTE								cbHandCardData[GAME_PLAYER][MAX_CARDCOUNT];//桌面扑克
	bool								bOpenCard[GAME_PLAYER];				//开牌标识
	bool								bSpecialCard[GAME_PLAYER];			//特殊牌型标志 （四花牛，五花牛，顺子，同花，葫芦，炸弹，同花顺，五小牛）
	BYTE								cbOriginalCardType[GAME_PLAYER];	//玩家原始牌型（没有经过玩家组合的牌型）
	BYTE								cbCombineCardType[GAME_PLAYER];     //玩家组合牌型（经过玩家组合的牌型）

	//历史积分
	LONGLONG							lTurnScore[GAME_PLAYER];			//积分信息
	LONGLONG							lCollectScore[GAME_PLAYER];			//积分信息
	tagCustomAndroid					CustomAndroid;						//AI配置
	bool								bIsAllowAvertDebug;					//反调试标志
	
	BYTE								cbCallBankerTimes[GAME_PLAYER];		//叫庄倍数
	CARDTYPE_CONFIG						ctConfig;							//游戏牌型
	SENDCARDTYPE_CONFIG					stConfig;							//发牌模式
	BANERGAMETYPE_CONFIG				bgtConfig;							//庄家玩法
	BETTYPE_CONFIG						btConfig;							//下注配置
	KING_CONFIG							gtConfig;							//有无大小王

	LONG								lFreeConfig[MAX_CONFIG];			//自由配置额度(无效值0)
	LONG								lPercentConfig[MAX_CONFIG];			//百分比配置额度(无效值0)
	LONG								lPlayerBetBtEx[GAME_PLAYER];		//闲家额外的推注筹码

	WORD								wGamePlayerCountRule;				//2-6人为0，其他的人数多少值为多少
	BYTE								cbAdmitRevCard;						//允许搓牌 TRUE为允许

	BYTE								cbPlayMode;							//约战游戏模式
	BYTE								cbTimeRemain;						//重连剩余秒数

	bool								bDelayFreeDynamicJoin;
};

//用户叫庄信息
struct CMD_S_CallBankerInfo
{
	BYTE								cbCallBankerStatus[GAME_PLAYER];	//叫庄状态
	BYTE								cbCallBankerTimes[GAME_PLAYER];		//叫庄倍数(若用户不叫庄，赋值0)自由抢庄默认都抢1倍
};

//发4张牌
struct CMD_S_SendFourCard
{
	//发前面4张
	BYTE								cbCardData[GAME_PLAYER][MAX_CARDCOUNT];	//用户扑克
};

//游戏开始
struct CMD_S_GameStart
{
	WORD								wBankerUser;						//庄家用户
	BYTE								cbPlayerStatus[GAME_PLAYER];		//玩家状态
	LONGLONG							lTurnMaxScore;						//最大下注

	//(发牌模式如果为发四等五，则发四张牌， 否则全为0)
	BYTE								cbCardData[GAME_PLAYER][MAX_CARDCOUNT];	//用户扑克
	SENDCARDTYPE_CONFIG					stConfig;							//发牌模式
	BANERGAMETYPE_CONFIG				bgtConfig;							//庄家玩法
	BETTYPE_CONFIG						btConfig;							//下注配置
	KING_CONFIG							gtConfig;							//有无大小王

	LONG								lFreeConfig[MAX_CONFIG];			//自由配置额度(无效值0)
	LONG								lPercentConfig[MAX_CONFIG];			//百分比配置额度(无效值0)
	LONG								lPlayerBetBtEx[GAME_PLAYER];		//闲家额外的推注筹码
};

//用户下注
struct CMD_S_AddScore
{
	WORD								wAddScoreUser;						//加注用户
	LONGLONG							lAddScoreCount;						//加注数目
};

//游戏结束
struct CMD_S_GameEnd
{
	LONGLONG							lGameTax[GAME_PLAYER];				//游戏税收
	LONGLONG							lGameScore[GAME_PLAYER];			//游戏得分
	BYTE								cbHandCardData[GAME_PLAYER][MAX_CARDCOUNT];//桌面扑克
	BYTE								cbCardType[GAME_PLAYER];			//玩家牌型
	WORD								wCardTypeTimes[GAME_PLAYER];		//牌型倍数
	BYTE								cbDelayOverGame;
	BYTE								cbLastSingleCardData[GAME_PLAYER];	//原始最后一张牌
};

//发牌数据包
struct CMD_S_SendCard
{
	//(发全部5张牌，如果发牌模式是发四等五，则前面四张和CMD_S_GameStart消息一样) 通比玩法收到这消息要默认下底注
	BYTE								cbCardData[GAME_PLAYER][MAX_CARDCOUNT];	//用户扑克
	bool								bSpecialCard[GAME_PLAYER];				//特殊牌型标志 （四花牛，五花牛，顺子，同花，葫芦，炸弹，同花顺，五小牛）
	BYTE								cbOriginalCardType[GAME_PLAYER];		//玩家原始牌型（没有经过玩家组合的牌型）
};

//用户退出
struct CMD_S_PlayerExit
{
	WORD								wPlayerID;							//退出用户
};

//用户摊牌
struct CMD_S_Open_Card
{
	WORD								wOpenChairID;						//摊牌用户
	BYTE								bOpenCard;							//摊牌标志
};

struct CMD_S_RequestQueryResult
{
	ROOMUSERINFO						userinfo;							//用户信息
	bool								bFind;								//找到标识
};

//用户调试
struct CMD_S_UserDebug
{
	DWORD								dwGameID;							//GAMEID
	TCHAR								szNickName[LEN_NICKNAME];			//用户昵称
	DEBUG_RESULT						debugResult;						//调试结果
	DEBUG_TYPE						debugType;						//调试类型
	BYTE								cbDebugCount;						//调试局数
};

//用户调试
struct CMD_S_UserDebugComplete
{
	DWORD								dwGameID;							//GAMEID
	TCHAR								szNickName[LEN_NICKNAME];			//用户昵称
	DEBUG_TYPE						debugType;						//调试类型
	BYTE								cbRemainDebugCount;				//剩余调试局数
};

//调试服务端库存信息
struct CMD_S_ADMIN_STORAGE_INFO
{
	LONGLONG							lRoomStorageStart;						//房间起始库存
	LONGLONG							lRoomStorageCurrent;
	LONGLONG							lRoomStorageDeduct;
	LONGLONG							lMaxRoomStorage[2];
	WORD								wRoomStorageMul[2];
};

//操作记录
struct CMD_S_Operation_Record
{
	TCHAR								szRecord[MAX_OPERATION_RECORD][RECORD_LENGTH];					//记录最新操作的20条记录
};

//请求更新结果
struct CMD_S_RequestUpdateRoomInfo_Result
{
	LONGLONG							lRoomStorageCurrent;				//房间当前库存
	ROOMUSERINFO						currentqueryuserinfo;				//当前查询用户信息
	bool								bExistDebug;						//查询用户存在调试标识
	USERDEBUG							currentuserdebug;
};

//录像数据
struct Video_GameStart
{
	LONGLONG							lCellScore;							//基础积分
	WORD								wPlayerCount;						//真实在玩人数
	WORD								wGamePlayerCountRule;				//2-6人为0，其他的人数多少值为多少
	WORD								wBankerUser;						//庄家用户
	BYTE								cbPlayerStatus[GAME_PLAYER];		//玩家状态
	LONGLONG							lTurnMaxScore;						//最大下注

	//(发牌模式如果为发四等五，则发四张牌， 否则全为0)
	BYTE								cbCardData[GAME_PLAYER][MAX_CARDCOUNT];	//用户扑克
	CARDTYPE_CONFIG						ctConfig;							//游戏牌型
	SENDCARDTYPE_CONFIG					stConfig;							//发牌模式
	BANERGAMETYPE_CONFIG				bgtConfig;							//庄家玩法
	BETTYPE_CONFIG						btConfig;							//下注配置
	KING_CONFIG							gtConfig;							//有无大小王

	DWORD								lFreeConfig[MAX_CONFIG];			//自由配置额度(无效值0)
	DWORD								lPercentConfig[MAX_CONFIG];			//百分比配置额度(无效值0)
	TCHAR								szNickName[LEN_NICKNAME];			//用户昵称		
	WORD								wChairID;							//椅子ID
	LONGLONG							lScore;								//积分
};

//房卡记录
struct CMD_S_RoomCardRecord
{
	WORD							nCount;											//局数
	LONGLONG						lDetailScore[GAME_PLAYER][MAX_RECORD_COUNT];	//单局结算分
	BYTE                            cbPlayStatus[GAME_PLAYER];						//用户状态
};

////////用于回放
//用户叫庄
struct CMD_S_CallBanker
{
	WORD								wGamePlayerCountRule;				//2-6人为0，其他的人数多少值为多少
	CARDTYPE_CONFIG						ctConfig;							//游戏牌型
	SENDCARDTYPE_CONFIG					stConfig;							//发牌模式
	BANERGAMETYPE_CONFIG				bgtConfig;							//庄家玩法
	BYTE								cbMaxCallBankerTimes;				//最大抢庄倍数自由抢庄默认都抢1倍
	WORD								wBgtRobNewTurnChairID;				//倍数抢庄新开一局抢庄的玩家（无效为INVALID_CHAIR， 当有效时候只能这个玩家选择倍数，并且该玩家是庄家）
};

//////////////////////////////////////////////////////////////////////////
//客户端命令结构
#define SUB_C_CALL_BANKER				1									//用户叫庄
#define SUB_C_ADD_SCORE					2									//用户加注
#define SUB_C_OPEN_CARD					3									//用户摊牌
#define SUB_C_STORAGE					6									//更新库存
#define	SUB_C_STORAGEMAXMUL				7									//设置上限

#ifdef CARD_CONFIG
#define SUB_C_CARD_CONFIG				10									//配牌
#endif

#define SUB_C_REQUEST_RCRecord			12									//查询房卡记录

#define SUB_C_REQUEST_QUERY_USER		13									//请求查询用户
#define SUB_C_USER_DEBUG				14									//用户调试

//请求更新命令
#define SUB_C_REQUEST_UDPATE_ROOMINFO	15									//请求更新房间信息
#define SUB_C_CLEAR_CURRENT_QUERYUSER	16


//用户叫庄
struct CMD_C_CallBanker
{
	bool								bBanker;							//叫庄标志
	BYTE								cbBankerTimes;						//叫庄倍数(若用户不叫庄，赋值0)
};

//用户加注
struct CMD_C_AddScore
{
	LONGLONG							lScore;								//加注数目
};

//用户摊牌
struct CMD_C_OpenCard
{	
	//按照组合的牌，看前三张能否凑成10相关
	BYTE								cbCombineCardData[MAX_CARDCOUNT];	//玩家组合扑克
};

struct CMD_C_UpdateStorage
{
	LONGLONG							lRoomStorageCurrent;				//库存数值
	LONGLONG							lRoomStorageDeduct;					//库存数值
};

struct CMD_C_ModifyStorage
{
	LONGLONG							lMaxRoomStorage[2];					//库存上限
	WORD								wRoomStorageMul[2];					//赢分概率
};

#ifdef CARD_CONFIG
struct CMD_C_CardConfig
{
	BYTE								cbconfigCard[GAME_PLAYER][MAX_CARDCOUNT];	//配牌扑克
};
#endif

struct CMD_C_RequestQuery_User
{
	DWORD								dwGameID;								//查询用户GAMEID
	TCHAR								szNickName[LEN_NICKNAME];			    //查询用户昵称
};

//用户调试
struct CMD_C_UserDebug
{
	DWORD								dwGameID;							//GAMEID
	TCHAR								szNickName[LEN_NICKNAME];			//用户昵称
	USERDEBUG							userDebugInfo;					//
};

#pragma pack(pop)

#endif

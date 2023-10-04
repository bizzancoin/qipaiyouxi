#ifndef CMD_GAME_HEAD_FILE
#define CMD_GAME_HEAD_FILE

#pragma pack(push)  
#pragma pack(1)

//////////////////////////////////////////////////////////////////////////////////

//#define CARD_DISPATCHER_DEBUG
//服务定义

//游戏属性
#define KIND_ID						241										//游戏 I D
#define GAME_NAME					TEXT("21 点")							//游戏名字

//组件属性
#define GAME_PLAYER					6										//游戏人数
#define VERSION_SERVER				PROCESS_VERSION(7,0,1)					//程序版本
#define VERSION_CLIENT				PROCESS_VERSION(7,0,1)					//程序版本

//////////////////////////////////////////////////////////////////////////////////

//结束原因
#define GER_NO_PLAYER				0x10									//没有玩家
#define LEN_NICKNAME				32										//昵称长度

//状态定义
#define GAME_SCENE_FREE				GAME_STATUS_FREE						//等待开始
#define GAME_SCENE_ADD_SCORE		GAME_STATUS_PLAY						//闲家下注
#define GAME_SCENE_GET_CARD			(GAME_STATUS_PLAY+1)					//庄家操作

//操作记录
#define MAX_OPERATION_RECORD			20									//操作记录条数
#define RECORD_LENGTH					128									//每条记录字长

#define MAX_RECORD_COUNT				32									//房卡结算统计最大局数

//////////////////////////////////////////////////////////////////////////
//服务器命令结构

#define SUB_S_GAME_START				100									//游戏开始
#define SUB_S_GAME_END					101									//游戏结束
#define SUB_S_SEND_CARD					102									//发牌
#define SUB_S_SPLIT_CARD				103									//分牌
#define SUB_S_STOP_CARD					104									//停牌
#define SUB_S_DOUBLE_SCORE				105									//加倍
#define SUB_S_INSURE					106									//保险
#define SUB_S_ADD_SCORE					107									//下注
#define SUB_S_GET_CARD					108									//要牌
#define SUB_S_CHEAT_CARD				109									//发送明牌
#define SUB_S_RECORD					118									//游戏记录

struct CMD_S_RECORD
{
	int						nCount[GAME_PLAYER];
	SCORE					lDetailScore[GAME_PLAYER][MAX_RECORD_COUNT];	//单局结算分
	SCORE					lAllScore[GAME_PLAYER];							//总结算分
};

//游戏AI存款取款
struct tagCustomAndroid
{
	LONGLONG							lRobotScoreMin;	
	LONGLONG							lRobotScoreMax;
	LONGLONG	                        lRobotBankGet; 
	LONGLONG							lRobotBankGetBanker; 
	LONGLONG							lRobotBankStoMul; 
};

//调试类型
typedef enum{CONTINUE_WIN, CONTINUE_LOST, CONTINUE_CANCEL}DEBUG_TYPE;

//调试结果      调试成功 、调试失败 、调试取消成功 、调试取消无效
typedef enum{DEBUG_SUCCEED, DEBUG_FAIL, DEBUG_CANCEL_SUCCEED, DEBUG_CANCEL_INVALID}DEBUG_RESULT;

//用户行为
typedef enum{USER_SITDOWN, USER_STANDUP, USER_OFFLINE, USER_RECONNECT}USERACTION;



struct CMD_S_StatusFree
{
	//时间定义	
	BYTE								cbInitTimeAddScore;					//下注时间
	BYTE								cbInitTimeGetCard;					//操作时间

	BYTE								cbBankerMode;						//庄家模式
	SCORE								lBaseJeton;							//单元筹码
	WORD								wPlayerCount;						//游戏人数

	LONGLONG							lRoomStorageStart;					//房间起始库存
	LONGLONG							lRoomStorageCurrent;				//房间当前库存
	tagCustomAndroid					CustomAndroid;						//游戏AI配置
	BYTE								cbPlayMode;							//约战游戏模式
};

//游戏状态
struct CMD_S_StatusAddScore
{
	//时间定义	
	BYTE								cbInitTimeAddScore;					//下注时间
	BYTE								cbInitTimeGetCard;					//操作时间
	BYTE								cbTimeRemain;						//操作时间

	BYTE								cbBankerMode;						//庄家模式
	SCORE								lBaseJeton;							//单元筹码
	WORD								wPlayerCount;						//游戏人数

	BYTE								cbPlayStatus[GAME_PLAYER];			//玩家状态

	LONGLONG							lMaxScore;							//最大注数

	WORD								wBankerUser;						//庄家

	LONGLONG							lTableScore[GAME_PLAYER];			//桌面下注
	LONGLONG							lRoomStorageStart;					//房间起始库存
	LONGLONG							lRoomStorageCurrent;				//房间当前库存
	tagCustomAndroid					CustomAndroid;						//游戏AI配置
	BYTE								cbPlayMode;							//约战游戏模式

};

//游戏状态
struct CMD_S_StatusGetCard
{
	//时间定义	
	BYTE								cbInitTimeAddScore;					//下注时间
	BYTE								cbInitTimeGetCard;					//操作时间
	BYTE								cbTimeRemain;						//操作时间

	BYTE								cbBankerMode;						//庄家模式
	SCORE								lBaseJeton;							//单元筹码
	WORD								wPlayerCount;						//游戏人数

	BYTE								cbPlayStatus[GAME_PLAYER];			//玩家状态

	WORD								wBankerUser;						//庄家
	WORD								wCurrentUser;						//当前玩家

	SCORE								lTableScore[GAME_PLAYER];			//桌面下注

	//扑克信息
	BYTE								cbCardCount[GAME_PLAYER*2];			//扑克数目
	BYTE								cbHandCardData[GAME_PLAYER*2][11];	//桌面扑克

	//
	bool								bStopCard[GAME_PLAYER*2];			//玩家停牌
	bool								bDoubleCard[GAME_PLAYER*2];			//玩家加倍
	bool								bInsureCard[GAME_PLAYER*2];			//玩家下保险
	LONGLONG							lRoomStorageStart;					//房间起始库存
	LONGLONG							lRoomStorageCurrent;				//房间当前库存
	tagCustomAndroid					CustomAndroid;						//游戏AI配置
	BYTE								cbPlayMode;							//约战游戏模式

};

//录像数据
struct Video_GameStart
{
	TCHAR								szNickName[LEN_NICKNAME];			//用户昵称	
	SCORE								lUserScore;							//用户积分
	LONG								lGameCellScore;						//游戏底分
	WORD								wChairID;							//椅子ID

	SCORE								lMaxScore;							//最大下注
	WORD				 				wBankerUser;						//当前庄家

	//时间定义	
	BYTE								cbTimeAddScore;						//下注时间
	BYTE								cbTimeGetCard;						//操作时间

	BYTE								cbBankerMode;						//庄家模式
	SCORE								lBaseJeton;							//单元筹码
	WORD								wPlayerCount;						//玩家人数
};

//游戏开始
struct CMD_S_GameStart
{
	BYTE								cbPlayStatus[GAME_PLAYER];			//玩家状态
	//下注信息
	SCORE								lCellScore;							//单元下注
	SCORE								lMaxScore;							//最大下注
	//用户信息
	WORD				 				wBankerUser;						//当前庄家
};

//下注
struct CMD_S_AddScore
{
	WORD								wAddScoreUser;						//下注玩家

	LONGLONG							lAddScore;							//下注额
};

//要牌
struct CMD_S_GetCard
{
	WORD								wGetCardUser;						//要牌玩家
	BYTE								cbCardData;							//牌数据
	bool								bSysGet;							//是否系统要牌
};

//发牌
struct CMD_S_SendCard
{
	BYTE								cbHandCardData[GAME_PLAYER][2];		//发牌数据
	bool								bWin;								//是否赢牌
	WORD								wCurrentUser;						//当前玩家
};

//分牌
struct CMD_S_SplitCard
{
	WORD								wSplitUser;							//分牌玩家
	BYTE								bInsured;							//是否之前下了保险

	LONGLONG							lAddScore;							//加注额
	BYTE								cbCardData[2];						//牌数据
};

//停牌
struct CMD_S_StopCard					
{
	WORD								wStopCardUser;						//停牌玩家
	WORD								wCurrentUser;						//当前玩家
};

//加倍
struct CMD_S_DoubleScore
{
	WORD								wDoubleScoreUser;					//加倍玩家
	BYTE								cbCardData;							//牌数据
	LONGLONG							lAddScore;							//加注额
};

//保险
struct CMD_S_Insure
{
	WORD								wInsureUser;						//保险玩家
	double								dInsureScore;						//保险金
};

//游戏结束
struct CMD_S_GameEnd
{
	LONGLONG							lGameTax[GAME_PLAYER];				//游戏税收
	LONGLONG							lGameScore[GAME_PLAYER];			//游戏得分
	BYTE								cbCardData[GAME_PLAYER * 2][11];	//用户扑克
};



//////////////////////////////////////////////////////////////////////////
//客户端命令结构

#define SUB_C_ADD_SCORE					1									//用户加注
#define SUB_C_GET_CARD					2									//要牌
#define SUB_C_DOUBLE_SCORE				3									//加倍
#define SUB_C_INSURE					4									//保险
#define SUB_C_SPLIT_CARD				5									//分牌
#define SUB_C_STOP_CARD					6									//放弃跟注




//用户加注
struct CMD_C_AddScore
{
	LONGLONG							lScore;								//加注数目
};

struct CMD_C_RequestQuery_User
{
    DWORD								dwGameID;							//查询用户GAMEID
};


//调试相关结构

#define MAX_DEFAULT_CUSTOM_RULE		3											//最大默认配置

typedef enum
{
    PRIMARY = 0,				//初级配置
    MIDDLE = 1,					//中级配置
    SENIOR = 2,					//高级配置
    INVALID = INVALID_BYTE,
}EM_DEFAULT_CUSTOM_RULE;

typedef enum
{
    USER_CTRL,
    ROOM_CTRL,
    SYS_CTRL
}EM_CTRL_TYPE;

typedef enum
{
    PROGRESSINGEX = 0,
    CANCELEX,				//未执行过在队列中取消
    EXECUTE_CANCELEX,		//执行过取消
}EM_SYSCTRL_STATUS;

typedef enum
{
    QUEUE = 0,
    PROGRESSING,
    FINISH,
    CANCEL,				//未执行过在队列中取消
    EXECUTE_CANCEL,		//执行过取消
}EM_ROOMCTRL_STATUS;

//通用库存调试
typedef struct
{
    DWORD							dwCtrlIndex;						//索引(从1开始递增)
    DWORD							dwCtrlCount;						//执行次数
    SCORE							lSysCtrlSysStorage;					//当前系统库存(系统要赢的钱)
    SCORE							lSysCtrlPlayerStorage;				//当前玩家库存(玩家要赢的钱)
    SCORE							lSysCtrlParameterK;					//当前调节系数(百分比)
    SCORE							lSysResetParameterK;				//重置区间(百分比)
    SCORE							lSysCtrlSysWin;						//系统输赢总数
    SCORE							lSysCtrlPlayerWin;					//玩家输赢总数
    CTime							tmConfigTime;						//配置时间
    EM_SYSCTRL_STATUS				sysCtrlStatus;						//当前状态
}SYSCTRL;

//房间调试
typedef struct
{
    //房间调试部分
    DWORD							dwCtrlIndex;						//调试索引(从1开始递增)
    SCORE						    lRoomCtrlInitialSysStorage;			//超端房间调试系统库存(系统要赢的钱)
    SCORE						    lRoomCtrlInitialPlayerStorage;		//超端房间调试玩家库存(系统要赢的钱)
    SCORE						    lRoomCtrlSysStorage;				//超端房间调试系统库存(系统要赢的钱)
    SCORE						    lRoomCtrlPlayerStorage;				//超端房间调试玩家库存(系统要赢的钱)
    SCORE							lRoomCtrlParameterK;				//超端房间调试调节系数(百分比):
    SCORE							lRoomResetParameterK;				//重置区间(百分比)
    SCORE							lRoomCtrlSysWin;					//系统输赢总数
    SCORE							lRoomCtrlPlayerWin;					//玩家输赢总数
    CTime							tmConfigTime;						//配置时间
    EM_ROOMCTRL_STATUS				roomCtrlStatus;						//当前状态
}ROOMCTRL;

//房间调试选项
typedef struct
{
    //房间调试部分
    DWORD							dwCtrlIndex;						//调试索引(从1开始递增)
    SCORE						    lRoomCtrlInitialSysStorage;			//超端房间调试系统库存(系统要赢的钱)
    SCORE						    lRoomCtrlInitialPlayerStorage;		//超端房间调试玩家库存(系统要赢的钱)
    LONGLONG						lRoomCtrlParameterK;				//超端房间调试调节系数(百分比)
    LONGLONG						lRoomResetParameterK;				//重置区间(百分比)
    SCORE							lUserCtrlSysWin;					//系统输赢总数
    SCORE							lUserCtrlPlayerWin;					//玩家输赢总数

}ROOMCTRL_ITEM;


//用户调试
typedef struct
{
    //用户调试部分
    DWORD							dwCtrlIndex;						//调试索引(从1开始递增)
    DWORD							dwGameID;						    //玩家id
    SCORE						    lUserCtrlInitialSysStorage;			//超端房间调试系统库存(系统要赢的钱)
    SCORE						    lUserCtrlInitialPlayerStorage;		//超端房间调试玩家库存(系统要赢的钱)
    SCORE						    lUserCtrlSysStorage;				//超端房间调试系统库存(系统要赢的钱)
    SCORE						    lUserCtrlPlayerStorage;				//超端房间调试玩家库存(系统要赢的钱)
    SCORE							lUserCtrlParameterK;				//超端房间调试调节系数(百分比):
    SCORE							lUserResetParameterK;				//重置区间(百分比)
    SCORE							lUserCtrlSysWin;					//系统输赢总数
    SCORE							lUserCtrlPlayerWin;					//玩家输赢总数
    CTime							tmConfigTime;						//配置时间
    EM_ROOMCTRL_STATUS				roomCtrlStatus;						//当前状态
}USERCTRL;

//用户调试
typedef struct
{
    //用户调试部分
    DWORD							dwGameID;						    //玩家id
    SCORE						    lUserCtrlInitialSysStorage;			//超端调试系统库存(系统要赢的钱)
    SCORE						    lUserCtrlInitialPlayerStorage;		//超端调试玩家库存(系统要赢的钱)
    LONGLONG 						lUserCtrlParameterK;				//超端房间调试调节系数(百分比):
    LONGLONG 						lUserResetParameterK;				//重置区间(百分比):
    SCORE							lUserCtrlSysWin;					//系统输赢总数
    SCORE							lUserCtrlPlayerWin;					//玩家输赢总数
    EM_ROOMCTRL_STATUS				UserCtrlStatus;						//当前状态
}USERCTRL_ITEM;

//调试信息
typedef struct
{
    DEBUG_TYPE							debug_type;						  //调试类型
    BYTE								cbDebugCount;					  //调试局数
    BYTE								cbInitialCount;					  //调试局数
    bool							    bCancelDebug;					  //取消标识
}ZUANGDEBUG;

//桌子信息
typedef struct
{
    DWORD								dwGameID;							//玩家ID
    WORD								wTableID;							//桌子ID
    DWORD                               dwBankerGameID;                     //庄家gameid
    WORD                                wBankerChairID;                     //庄家chairID
    bool								bAndroid;							//游戏AI标识
    TCHAR								szNickName[LEN_NICKNAME];			//用户昵称
    int                                 nPlayerCount;                       //当前桌子人数

}ROOMUSERINFO;

//桌子信息
typedef struct
{
    WORD								wTableID;							//桌子ID
    DWORD                               dwBankerGameID;                     //庄家gameid
    WORD                                wBankerChairID;                     //庄家chairID
    int                                 nPlayerCount;                       //当前桌子人数

}DESKINFO;


//调试端相关
//调试端相关
#define SUB_S_AMDIN_COMMAND			    10									//系统调试
#define SUB_S_SEND_USER_BET_INFO	    11									//发送下注
#define SUB_S_REFRESH_RULE_RESULT	    21									//刷新配置结果
#define SUB_S_SET_RULE_RESULT		    22									//设置配置结果
#define SUB_S_REFRESH_SYSCTRL		    23									//更新系统调试列表
#define SUB_S_REFRESH_ROOMCTRL		    24									//更新房间调试列表
#define SUB_S_ALL_WINLOST_INFO		    26									//输赢信息统计
#define SUB_S_DEBUG_TEXT			    28									//调试提示信息
#define SUB_S_CUR_ROOMCTRL_INFO		    30									//当前房间调试信息
#define SUB_S_REQUEST_QUERY_RESULT		31								    //查询用户结果
#define SUB_S_OPERATION_RECORD		    32								    //操作记录
#define SUB_S_ZUANG_DEBUG				33								    //用户调试
#define SUB_S_USER_DEBUG_COMPLETE		34								    //用户调试完成
#define SUB_S_REFRESH_USERCTRL		    35									//更新用户调试列表
#define SUB_S_CUR_USERCTRL_INFO		    36									//当前用户调试信息
#define SUB_REFRESH_ROOM_CTRL           37                                  //刷新当前房间调试项
#define SUB_S_DELETE_USER_ITEM_INFO	    38									//删除玩家调试选项
#define SUB_S_ADD_USER_ITEM_INFO	    39									//添加玩家调试选项
#define SUB_S_REFRESH_USER_ITEM_INFO	40									//刷新玩家调试选项
#define SUB_S_ADD_ROOM_ITEM_INFO        41                                  //添加房间调试选项
#define SUB_S_DELETE_ROOM_ITEM_INFO     42                                  //删除房间调试选项
#define SUB_S_CLEAR_ROOM_CTRL           43                                  //清除已完成房间调试数据
#define SUB_S_CLEAR_INFO                44                                  //清除当前房间和玩家调试信息显示（删除无效数据界面重置）
#define SUB_S_REFRESH_DESKCTRL		    45									//更新ZHUOZI调试列表


#define SUB_C_REFRESH_RULE					11							//刷新配置
#define SUB_C_SET_RULE						12							//设置配置
#define SUB_C_ROOM_CTRL						13							//房间调试
#define SUB_C_REFRESH_CUR_ROOMCTRL_INFO		14							//刷新房间调试信息
#define SUB_C_REQUEST_QUERY_USER            15                          //查询用户信息
#define SUB_C_USER_DEBUG                    16                          //用户调试
#define SUB_C_ADVANCED_REFRESH_ALLCTRLLIST	17							//刷新所有调试记录
#define SUB_C_CLEAR_CURRENT_QUERYUSER	    18                          //清除当前用户信息
#define SUB_C_DELETE_USER_CTRL				19							//删除用户调试
#define SUB_C_REFRESH_CUR_USERCTRL_INFO		20							//刷新用户调试信息
#define SUB_C_SET_CHOU_PERCENT      		21							//设置抽水比例
#define SUB_C_CANCEL_ROOM_CTRL      		22							//删除当前房间调试
#define SUB_C_DELETE_ROOM_CTRL			    23					        //删除指定房间调试
#define SUB_C_DELETE_ALL_USER_CTRL			24					        //删除所有用户调试
#define SUB_C_DELETE_ALL_ROOM_CTRL			25					        //删除所有房间调试
#define SUB_C_DELETE_USER_CTRL_LOG			26					        //删除指定用户调试LOG
#define SUB_C_DELETE_ROOM_CTRL_LOG			27					        //删除指定房间调试LOG
#define SUB_C_DIAN_USER_DEBUG			    28					        //玩家点debug
#define SUB_C_CLRARE_DESK       			29					        //清除指定调试log
#define SUB_C_CLEARE_DESK_ALL			    30					        //清除所有桌子调试log

struct CMD_S_RequestQueryResult
{
    ROOMUSERINFO						userinfo;							//用户信息
    bool								bFind;								//找到标识
};


//请求更新结果
struct CMD_S_RequestUpdateRoomInfo_Result
{
    ROOMUSERINFO						currentQueryUserInfo;				//当前查询用户信息
    bool								bExistDebug;						//查询用户存在调试标识
    ZUANGDEBUG							currentUserDebug;
};


//刷新配置结果
struct CMD_S_RefreshRuleResult
{
    SCORE							lCurSysStorage;					//当前系统库存(系统要赢的钱)
    SCORE							lCurPlayerStorage;				//当前玩家库存(玩家要赢的钱)
    SCORE							lCurParameterK;					//当前调节系数(百分比):
    SCORE							lResetParameterK;				//强制重置区间(百分比):
    SCORE							lStorageResetCount;				//重置次数
    SCORE							lSysCtrlSysWin;					//系统输赢总数
    SCORE							lSysCtrlPlayerWin;				//玩家输赢总数
};

//设置配置结果
struct CMD_S_SetRuleResult
{
    SCORE							lConfigSysStorage;				//配置系统库存(系统要赢的钱)
    SCORE							lConfigPlayerStorage;			//配置玩家库存(玩家要赢的钱)
    SCORE							lConfigParameterK;				//配置调节系数(百分比):
    SCORE							lResetParameterK;				//强制重置区间(百分比):
};

//房间调试结果
struct CMD_S_RoomCtrlResult
{
    DWORD							dwCtrlIndex;						//调试索引
    SCORE						    lRoomCtrlSysStorage;				//超端房间调试系统库存(系统要赢的钱)
    SCORE						    lRoomCtrlPlayerStorage;				//超端房间调试玩家库存(系统要赢的钱)
    SCORE							lRoomCtrlParameterK;				//超端房间调试调节系数(百分比):
    SCORE							lRoomResetParameterK;				//强制重置区间(百分比):
    SCORE							lRoomCtrlSysWin;					//系统输赢总数
    SCORE							lRoomCtrlPlayerWin;					//玩家输赢总数
    CTime							tmConfigTime;						//配置时间
    EM_ROOMCTRL_STATUS				roomCtrlStatus;						//当前状态
};

//用户调试结果
struct CMD_S_UserCtrlResult
{
    DWORD							dwCtrlIndex;						//调试索引
    DWORD							dwGameID;						    //玩家ID
    SCORE						    lUserCtrlSysStorage;				//超端房间调试系统库存(系统要赢的钱)
    SCORE						    lUserCtrlPlayerStorage;				//超端房间调试玩家库存(系统要赢的钱)
    SCORE							lUserCtrlParameterK;				//超端房间调试调节系数(百分比):
    SCORE							lUserResetParameterK;				//重置区间(百分比):
    SCORE							lUserCtrlSysWin;					//系统输赢总数
    SCORE							lUserCtrlPlayerWin;					//玩家输赢总数
    CTime							tmConfigTime;						//配置时间
    EM_ROOMCTRL_STATUS				roomCtrlStatus;						//当前状态
};


//系统调试结果
struct CMD_S_SysCtrlResult
{
    DWORD							dwCtrlIndex;						//索引(从1开始递增)
    DWORD							dwResetCount;						//重置次数
    SCORE							lSysCtrlSysStorage;					//当前系统库存(系统要赢的钱)
    SCORE							lSysCtrlPlayerStorage;				//当前玩家库存(玩家要赢的钱)
    SCORE							lSysCtrlParameterK;					//当前调节系数(百分比):
    SCORE							lResetParameterK;					//当前调节系数(百分比):
    SCORE							lSysCtrlSysWin;						//系统输赢总数
    SCORE							lSysCtrlPlayerWin;					//玩家输赢总数
    CTime							tmResetTime;						//重设时间
    EM_SYSCTRL_STATUS				sysCtrlStatus;						//当前状态
};

//输赢信息统计
struct CMD_S_RefreshWinTotal
{
    SCORE							lSysWin;						    //输赢总数
    SCORE							lTotalServiceWin;					//服务比例总数
    SCORE							lTotalChouShui;						//抽水总数
    SCORE                           lTotalRoomCtrlWin;                  //房间调试总输赢
    SCORE							lChouPercent;					    //抽水比例
    bool                            bIsCleanRoomCtrl;

};

//取消当前玩家调试
struct CMD_S_DELETE_USER
{
    DWORD                               dUserDebugID;                       //调试ID
};

//取消当前房间调试
struct CMD_S_DELETE_ROOM
{
    DWORD                               dRoomDebugID;                       //调试ID
};

//调试提示
struct CMD_S_DebugText
{
    TCHAR							szMessageText[256];					//调试文本
};


//操作记录
struct CMD_S_Operation_Record
{
    TCHAR		szRecord[MAX_OPERATION_RECORD][RECORD_LENGTH];			//记录最新操作的20条记录
};

//当前房间调试信息
struct CMD_S_CurRoomCtrlInfo
{
    DWORD							dwCtrlIndex;						//调试索引
    SCORE						    lRoomCtrlSysStorage;				//超端房间调试系统库存(系统要赢的钱)
    SCORE						    lRoomCtrlPlayerStorage;				//超端房间调试玩家库存(系统要赢的钱)
    SCORE							lRoomCtrlParameterK;				//超端房间调试调节系数(百分比):
    SCORE							lRoomResetParameterK;				//强制重置区间(百分比):
    SCORE							lRoomCtrlSysWin;					//系统输赢总数
    SCORE							lRoomCtrlPlayerWin;					//玩家输赢总数
    BYTE                            cbCtrlType;                         //当前调试类型
};

//当前用户调试信息
struct CMD_S_CurUserCtrlInfo
{
    DWORD							dwCtrlIndex;						//调试索引
    DWORD							dwGameID;						    //用户id
    SCORE						    lUserCtrlSysStorage;				//超端房间调试系统库存(系统要赢的钱)
    SCORE						    lUserCtrlPlayerStorage;				//超端房间调试玩家库存(系统要赢的钱)
    SCORE							lUserCtrlParameterK;				//超端房间调试调节系数(百分比):
    SCORE							lResetParameterK;					//强制重置区间(百分比)
    SCORE							lUserCtrlSysWin;					//系统输赢总数
    SCORE							lUserCtrlPlayerWin;					//玩家输赢总数
};


//设置配置
struct CMD_C_SetRule
{
    SCORE							lConfigSysStorage;							//配置系统库存(系统要赢的钱)
    SCORE							lConfigPlayerStorage;						//配置玩家库存(玩家要赢的钱)
    SCORE							lConfigParameterK;							//配置调节系数(百分比)
    SCORE							lResetParameterK;							//强制重置区间(百分比)

};

//房间调试
struct CMD_C_RoomCtrl
{
    SCORE						    lRoomCtrlSysStorage;					    //超端房间调试系统库存(系统要赢的钱)
    SCORE						    lRoomCtrlPlayerStorage;					    //超端房间调试玩家库存(系统要赢的钱)
    SCORE							lRoomCtrlParameterK;					    //超端房间调试调节系数(百分比):
    SCORE							lResetParameterK;							//强制重置区间(百分比)

};

//用户调试
struct CMD_C_UserCtrl
{
    DWORD							dwUserID;							    //选择调试id
    SCORE						    lUserCtrlSysStorage;					//超端房间调试系统库存(系统要赢的钱)
    SCORE						    lUserCtrlPlayerStorage;					//超端房间调试玩家库存(系统要赢的钱)
    SCORE							lUserCtrlParameterK;					//超端房间调试调节系数(百分比):
    SCORE							lUserResetParameterK;					//强制重置区间(百分比):
};



//庄家调试
struct CMD_C_ZuangDebug
{
    DWORD								dwGameID;							//GAMEID
    WORD                                wTableID;
    ZUANGDEBUG							zuangDebugInfo;
};

//设置抽水比例
struct CMD_C_ChouPercent
{
    int                                 nChouShuiPercent;                   //抽水比例
};

//删除当前指定桌子调试的log
struct CMD_C_Delete_Desk_log
{
    DWORD                               dDeskDebugID;                       //调试ID
};

//取消当前房间调试
struct CMD_C_Cancel_RoomCtrl
{
    DWORD                               dRoomDebugID;                       //调试ID
};

//取消当前玩家调试
struct CMD_C_DELETE_USER
{
    DWORD                               dUserDebugID;                       //调试ID
};

//庄家调试
struct CMD_S_ZuangDebug
{
    bool                                bOk;
    BYTE								cbDebugCount;						//调试局数
};

//ZUANG调试
struct CMD_S_ZuangDebugComplete
{
    DWORD							    dwBankerID;							//调试类型
    DEBUG_TYPE							debugType;							//调试类型
    BYTE								cbRemainDebugCount;					//剩余调试局数
    BYTE								cbPlayers;					        //人数
    SCORE                               lTotalScore;                        //本轮调试输赢统计
};

//房间庄家调试
typedef struct
{
    DWORD							    dwCtrlIndex;						//调试索引
    DWORD                               dwGameID;                           //操作玩家
    DESKINFO						    deskInfo;						    //桌子信息
    ZUANGDEBUG							zuangDebug;						    //庄家调试
    EM_ROOMCTRL_STATUS				    CtrlStatus;						    //当前状态
    CTime							    tmResetTime;						//重设时间

}ROOMDESKDEBUG;


//桌子调试结果
struct CMD_S_DeskCtrlResult
{
    ROOMDESKDEBUG                       deskCtrl;
};


//////////////////////////////////////////////////////////////////////////
#pragma pack(pop)
#endif
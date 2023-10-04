#ifndef CMD_ATT_HEAD_FILE
#define CMD_ATT_HEAD_FILE

#pragma pack(push)  
#pragma pack(1)
#include "../游戏服务器/GameControlDefine.h"
//////////////////////////////////////////////////////////////////////////
//公共宏定义

#define KIND_ID						532									//游戏 I D
#define GAME_PLAYER					1									//游戏人数
#define GAME_NAME					TEXT("ATT连环炮")					//游戏名字
#define	MAX_CARD_COUNT				5									//最大扑克数目
#define FULL_COUNT					54									//全牌数目

//版本信息
#define VERSION_SERVER			    PROCESS_VERSION(7,0,1)				//程序版本
#define VERSION_CLIENT				PROCESS_VERSION(7,0,1)				//程序版本

//状态定义
#define	GS_GAME_FREE				GAME_STATUS_FREE
#define GS_GAME_PLAY				GAME_STATUS_FREE+1
#define	GS_GAME_LUCKYTIME			GAME_STATUS_FREE+2									

//牌型定义
#define	CT_5K						0                                    //五条
#define	CT_RS						1									 //同花大顺
#define	CT_SF						2									 //同花顺
#define	CT_4K						3									 //四条
#define	CT_FH						4									 //葫芦
#define	CT_FL						5									 //同花
#define	CT_ST						6									 //顺子
#define	CT_3K						7									 //三条
#define	CT_2P						8									 //两对
#define	CT_1P						9									 //一对
#define	CT_INVALID					11									 //无效牌型

#define MAX_CARD_CT					10									 //最大牌型总数
#define MAX_GUESS_COUNT				6									 //最大猜大小次数
#define LUCKYTIME_CARDDATA_COUNT	13									 //全副扑克数目

//操作记录
#define MAX_OPERATION_RECORD		20									 //操作记录条数
#define RECORD_LENGTH				200									 //每条记录字长

//命令消息
#define IDM_ADMIN_UPDATE_STORAGE_ROOM		WM_USER+1001
#define IDM_ADMIN_MODIFY_ROOMCONFIG			WM_USER+1011
#define IDM_REQUEST_QUERY_USER				WM_USER+1012
#define ROOMUSERDEBUG					    WM_USER+1013
#define IDM_REQUEST_UPDATE_ROOMUSERLIST		WM_USER+1015
#define IDM_REQUEST_UPDATE_ROOMSTORAGE		WM_USER+1016

#ifndef SCOREEX
#define SCOREEX SCORE
#endif
#ifndef SCOREEX_STRING
#define SCOREEX_STRING TEXT("%I64d")
#endif
//大于
inline bool D_GreaterThen(SCOREEX dVal1, SCOREEX dVal2)
{
	return dVal1 > dVal2;
}
//小于
inline bool D_LessThen(SCOREEX dVal1, SCOREEX dVal2)
{
	return dVal1 < dVal2;
}
//小于或等于
inline bool D_LessThenEquals(SCOREEX dVal1, SCOREEX dVal2)
{
	return dVal1 <= dVal2;
}
inline bool D_UnGreaterThen(SCOREEX dVal1, SCOREEX dVal2)
{
	return D_LessThenEquals(dVal1, dVal2);
}
//大于或等于
inline bool D_GreaterThenEquals(SCOREEX dVal1, SCOREEX dVal2)
{
	return dVal1 >= dVal2;
}
inline bool D_UnLessThen(SCOREEX dVal1, SCOREEX dVal2)
{
	return D_GreaterThenEquals(dVal1, dVal2);
}
//////////////////////////////////////////////////////////////////////////
//服务器命令结构

#define SUB_S_GAME_START			    100									//游戏开始
#define SUB_S_GAME_CONCLUDE			    101									//游戏结算
#define SUB_S_CURRENT_BET			    102									//压注
#define	SUB_S_GUESS					    103									//猜大小
#define SUB_S_SWITCH_CARD			    104									//转换扑克
#define	SUB_S_LUCKYTIME				    105									//luckytime
#define	SUB_S_CONTINUE_GUESS		    106									//续押
#define SUB_S_GAME_RECORD			    107									//查看记录
#define SUB_S_GAME_AUTO				    108									//自动游戏
#define SUB_S_GAME_GUSS_INDEX			109									//猜测大小牌index

////////////////////////////////////////////////////////////////////////////////////////////////////////

//调试类型（优先级，个人>房间）
typedef enum
{
    USER_CTRL,
    ROOM_CTRL,
    STORAGE_CTRL

}EM_CTRL_TYPE;

//配置结构
struct tagCustomRule
{
    int									    lExchangeRadio;				//兑换比例
    int                                     nDebugPercent;              //调节比例
    SCORE									lSysStorage;
    SCORE									lUserStorage;
    SCORE                                   lBet[10];
   
};


//BONUS结构
typedef struct
{
	LONG							lBonus5K;
	LONG							lBonusRS;
	LONG							lBonusSF;
	LONG							lBonus4K;
}BONUS;

typedef struct
{
	bool							bSwitchFlag[MAX_CARD_COUNT];				//转换标识
	BYTE							cbSwitchCount;								//转换张数
}SWITCH_CARD;

//压注倍率
typedef struct
{
	LONG							lHighRadio;
	LONG							lMidRadio;
	LONG							lLowRadio;
}BET_RADIO;

//压大小
typedef struct
{
	WORD							wLuckyCardIndex;					
	WORD							wGuessCount;						//猜大小局数
	bool							bBig;								//大小标识
}GUESSINFO;

//压大小记录
typedef struct
{
	bool							bIsAlreadyGuess;					//已经猜
	bool							bGuessRight;						//猜对
	bool							bValid;								//是否有效
}GUESSRECORD;

//记录
typedef struct
{
	SCORE							l5KBet;
	SCORE							lRSBet;
	SCORE							lSFBet;
	SCORE							l4KBet;
	SCORE							lFHBet;
	SCORE							lFLBet;
	SCORE							lSTBet;
	SCORE							l3KBet;
	SCORE							l2PBet;
	SCORE							l1PBet;
	SCORE							lInvalidBet;
	SCORE							lPlayTotal;
}RECORD_INFO;

//自动标识
typedef struct
{
	bool							bFirstReversalFinish;					//第一次翻牌完成标识
	bool							bAlreadySwitchCard;						//已激活转换牌
}AUTO_FLAG;


//用户行为
typedef enum { USER_SITDOWN, USER_STANDUP, USER_OFFLINE, USER_RECONNECT } EM_USER_ACTION;


//房间用户信息
typedef struct
{
	WORD							wChairID;							//椅子ID
	WORD							wTableID;							//桌子ID
	DWORD							dwGameID;							//GAMEID
	bool							bAndroid;							//机器人标识
	TCHAR							szNickName[LEN_NICKNAME];			//用户昵称
	BYTE							cbUserStatus;						//用户状态
	BYTE							cbGameStatus;						//游戏状态
	LONGLONG						lGameScore;							//游戏输赢分
}ROOMUSERINFO;


//空闲状态
struct CMD_S_StatusGameFree
{
	BONUS							bonus;								//奖池
	LONG							lExchangeRadio;						//兑换比例
	LONG							lbureauCount;						//游戏局数
	RECORD_INFO						recordInfo;							//记录信息
	WORD							wTableID;							//桌子ID
	TCHAR							szServerName[LEN_SERVER];			//房间名称
    SCORE                           lBetItem[10]; 
    LONG							lBet;								//压注
};

//游戏状态
struct CMD_S_StatusGamePlay
{
	BONUS							bonus;								//奖池
	LONG							lbureauCount;						//游戏局数
	LONG							lExchangeRadio;						//兑换比例
	LONG							lBet;								//压注
	bool							balreadySwitch;						//是否转换
	bool							bSwitchFlag[MAX_CARD_COUNT];		//转换标识
	bool							bAuto;
	BYTE							cbFirstCardData[MAX_CARD_COUNT];	//初始扑克列表
	BYTE							cbSecondCardData[MAX_CARD_COUNT];	//第二次扑克列表
	BYTE							cbSwitchCardData[MAX_CARD_COUNT];	//经过切换的扑克列表
	RECORD_INFO						recordInfo;							//记录信息
	WORD							wTableID;							//桌子ID
	TCHAR							szServerName[LEN_SERVER];			//房间名称
    SCORE                           lBetItem[10];
};

//LuckyTime状态
struct CMD_S_StatusLuckyTime
{
	BONUS							bonus;										//奖池
	LONG							lbureauCount;								//游戏局数
	LONG							lExchangeRadio;								//兑换比例
	LONG							lBet;										//压注
	bool							bLuckyTimePause;							//暂停标识
	GUESSRECORD						guessRecord[MAX_GUESS_COUNT];				//猜大小记录
	BYTE							cbGuessCardResultRecord[MAX_GUESS_COUNT];	//猜大小牌记录
	WORD							wCurrentGuessCount;							//猜大小局数
	BYTE							cbLuckyCardData[LUCKYTIME_CARDDATA_COUNT];  //LuckyCard
	BYTE							cbHandCardData[MAX_CARD_COUNT];				//手牌扑克
	RECORD_INFO						recordInfo;									//记录信息
	WORD							wTableID;									//桌子ID
	TCHAR							szServerName[LEN_SERVER];					//房间名称
    SCORE                           lBetItem[10];
};

////////////////////////////////////////////////////////////////////////////////////////////////////////

//游戏开始
struct CMD_S_GameStart
{
	BYTE							cbFirstCardArray[MAX_CARD_COUNT];	    //初始扑克列表
	BYTE							cbSecondCardArray[MAX_CARD_COUNT];	    //第二次扑克列表
};

//游戏结算
struct CMD_S_GameConclude
{
	//玩家成绩
	SCORE							lUserScore;							//玩家成绩
	LONG							lbureauCount;						//游戏局数
	BONUS							Bonus;								//奖池
	bool							bGuess;								//是否猜大小
	RECORD_INFO						recordInfo;							//记录信息
	LONG							lExchangeRadio;						//兑换比例
	LONG							llastBet;							//上次下注的筹码
	
};

//压大小
struct CMD_S_Guess
{	
	GUESSRECORD						guessRecord[MAX_GUESS_COUNT];				//猜大小记录
	BYTE							cbGuessCardResultRecord[MAX_GUESS_COUNT];	//猜大小牌记录
	WORD							wCurrentGuessCount;							//当前猜大小局数
};

//压注
struct CMD_S_CurrentBet
{
	LONG							lBet;				
};

//转换
struct CMD_S_SwitchCard
{
	SWITCH_CARD						switchCard;
    bool                            bGuss;
};

//luckytime
struct CMD_S_LuckyTime
{
	BYTE							cbLuckyCardData[LUCKYTIME_CARDDATA_COUNT];
    BYTE							cbGuessCardResultRecord[MAX_GUESS_COUNT];	//猜大小牌记录
};

//记录
struct CMD_S_GameRecord
{
	bool							bShowRecord;								
};

//自动游戏
struct CMD_S_GameAuto
{
	bool							bAuto;		

};

//查询用户结果
struct CMD_S_RequestQueryResult
{
	ROOMUSERINFO					userinfo;							//用户信息
	bool							bFind;								//找到标识
};



//更新玩家列表
struct CMD_S_UpdateRoomUserList
{
	DWORD							dwUserID;							//用户ID
	ROOMUSERINFO					roomUserInfo;
};


//客户端命令结构（20 到 27）
#define	SUB_C_LUCKYTIME				    20									//luckytime
#define SUB_C_CURRENT_BET			    21									//压注
#define SUB_C_SWITCH_CARD			    22									//转换扑克
#define SUB_C_GAME_END			        23									//游戏结束
#define SUB_C_GUESS					    24									//游戏结束
#define SUB_C_CONTINUE_GUESS		    25									//续押
#define SUB_C_GAME_RECORD			    26									//查看记录
#define SUB_C_GAME_AUTO				    27									//自动游戏
#define SUB_C_GAME_CLICK_GUSS			28									//点击猜大小


//猜大小
struct CMD_S_CLICK_Guess
{
    BYTE							cbIndex;						    //目标扑克
};



//猜大小
struct CMD_C_Guess
{
	GUESSINFO						guessInfo;							//猜测信息
	BYTE							cbKeyCardData;						//目标扑克
};

//压注
struct CMD_C_CurrentBet
{
	LONG							lBet;								
};

//记录
struct CMD_C_GameRecord
{
	bool							bShowRecord;								
};

//自动游戏
struct CMD_C_GameAuto
{
	bool							bAuto;			
};

//结算
struct CMD_C_GameEnd
{
	WORD							wChairID;
	LONG							lBet;	
	BYTE							cbHandCardData[MAX_CARD_COUNT];
};

//转换
struct CMD_C_SwitchCard
{
	SWITCH_CARD						switchCard;	
	bool							bSwitchCard;
	BYTE							cbSwitchCardData[MAX_CARD_COUNT];		//经过切换的扑克列表
};

struct CMD_C_RequestQuery_User
{
	DWORD							dwGameID;								//查询用户GAMEID
	TCHAR							szNickName[LEN_NICKNAME];			    //查询用户昵称
};


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
    SCORE							lSysCtrlSysStorage;					//当前系统库存(系统要赢的钱)
    SCORE							lSysCtrlPlayerStorage;				//当前玩家库存(玩家要赢的钱)
    SCORE							lSysCtrlParameterK;					//当前调节系数(百分比):
    SCORE							lSysCtrlDeadLineLimit;				//截止额度
    SCORE							lSysCtrlSysWin;						//系统输赢总数
    SCORE							lSysCtrlPlayerWin;					//玩家输赢总数
    CTime							tmResetTime;						//重设时间
    EM_SYSCTRL_STATUS				sysCtrlStatus;						//当前状态
}SYSCTRL;

//房间调试
typedef struct
{
    //房间调试部分
    DWORD							dwCtrlIndex;						//调试索引(从1开始递增)
    LONGLONG						lRoomCtrlInitialSysStorage;			//超端房间调试系统库存(系统要赢的钱)
    LONGLONG						lRoomCtrlInitialPlayerStorage;		//超端房间调试玩家库存(系统要赢的钱)
    LONGLONG						lRoomCtrlSysStorage;				//超端房间调试系统库存(系统要赢的钱)
    LONGLONG						lRoomCtrlPlayerStorage;				//超端房间调试玩家库存(系统要赢的钱)
    SCORE							lRoomCtrlParameterK;				//超端房间调试调节系数(百分比):
    BYTE							nRoomCtrlStorageDeadLine;			//库存截止
    SCORE							lRoomCtrlDeadLineLimit;				//截止额度
    SCORE							lRoomCtrlSysWin;					//系统输赢总数
    SCORE							lRoomCtrlPlayerWin;					//玩家输赢总数
    CTime							tmConfigTime;						//配置时间
    EM_ROOMCTRL_STATUS				roomCtrlStatus;						//当前状态
}ROOMCTRL;

//用户调试
typedef struct
{
    //用户调试部分
    DWORD							dwCtrlIndex;						//调试索引(从1开始递增)
    DWORD							dwGameID;						    //玩家id
    LONGLONG						lUserCtrlInitialSysStorage;			//超端房间调试系统库存(系统要赢的钱)
    LONGLONG						lUserCtrlInitialPlayerStorage;		//超端房间调试玩家库存(系统要赢的钱)
    LONGLONG						lUserCtrlSysStorage;				//超端房间调试系统库存(系统要赢的钱)
    LONGLONG						lUserCtrlPlayerStorage;				//超端房间调试玩家库存(系统要赢的钱)
    SCORE							lUserCtrlParameterK;				//超端房间调试调节系数(百分比):
    BYTE							nUserCtrlStorageDeadLine;			//库存截止
    SCORE							lUserCtrlDeadLineLimit;				//截止额度
    SCORE							lUserCtrlSysWin;					//系统输赢总数
    SCORE							lUserCtrlPlayerWin;					//玩家输赢总数
    CTime							tmConfigTime;						//配置时间
    EM_ROOMCTRL_STATUS				roomCtrlStatus;						//当前状态
}USERCTRL;

//控制端相关
#define SUB_S_AMDIN_COMMAND			    10									//系统调试
#define SUB_S_SEND_USER_BET_INFO	    11									//发送下注
#define SUB_S_REFRESH_RULE_RESULT	    21									//刷新配置结果
#define SUB_S_SET_RULE_RESULT		    22									//设置配置结果
#define SUB_S_REFRESH_SYSCTRL		    23									//更新系统调试列表
#define SUB_S_REFRESH_ROOMCTRL		    24									//更新房间调试列表
#define SUB_S_LIST_WINLOST_INFO		    26									//列表输赢信息
#define SUB_S_DEBUG_TEXT			    28									//调试提示信息
#define SUB_S_CUR_ROOMCTRL_INFO		    30									//当前房间调试信息
#define SUB_S_REQUEST_QUERY_RESULT		31								    //查询用户结果
#define SUB_S_OPERATION_RECORD		    32								    //操作记录
#define SUB_S_USER_DEBUG				33								    //用户调试
#define SUB_S_USER_DEBUG_COMPLETE		34								    //用户调试完成
#define SUB_S_REFRESH_USERCTRL		    35									//更新用户调试列表
#define SUB_S_CUR_USERCTRL_INFO		    36									//当前用户调试信息

//调试端相关
#define SUB_C_REFRESH_RULE					11							//刷新配置
#define SUB_C_SET_RULE						12							//设置配置
#define SUB_C_ROOM_CTRL						13							//房间调试
#define SUB_C_REFRESH_CUR_ROOMCTRL_INFO		14							//刷新房间调试信息
#define SUB_C_REQUEST_QUERY_USER            15                          //查询用户信息
#define SUB_C_USER_DEBUG                    16                          //用户调试
#define SUB_C_ADVANCED_REFRESH_ALLCTRLLIST	17							//刷新所有调试记录
#define SUB_C_CLEAR_CURRENT_QUERYUSER	    18                          //清除当前用户信息
#define SUB_C_USER_CTRL						19							//用户调试
#define SUB_C_REFRESH_CUR_USERCTRL_INFO		20							//刷新用户调试信息

//刷新配置结果
struct CMD_S_RefreshRuleResult
{
    SCORE							lCurSysStorage;					//当前系统库存(系统要赢的钱)
    SCORE							lCurPlayerStorage;				//当前玩家库存(玩家要赢的钱)
    SCORE							lCurParameterK;					//当前调节系数(百分比):
    SCORE							lConfigSysStorage;				//配置系统库存(系统要赢的钱)
    SCORE							lConfigPlayerStorage;			//配置玩家库存(玩家要赢的钱)
    SCORE							lConfigParameterK;				//配置调节系数(百分比):
    BOOL							nSysCtrlStorageDeadLine;		//库存截止
    SCORE							lStorageResetCount;				//重置次数
    SCORE							lSysCtrlDeadLineLimit;			//截止额度
    SCORE							lSysCtrlSysWin;					//系统输赢总数
    SCORE							lSysCtrlPlayerWin;				//玩家输赢总数
    int                             nCtrlType;                      //2系统控制，1房间控制，0玩家控制，用来刷新控制界面
};

//设置配置结果
struct CMD_S_SetRuleResult
{
    SCORE							lConfigSysStorage;				//配置系统库存(系统要赢的钱)
    SCORE							lConfigPlayerStorage;			//配置玩家库存(玩家要赢的钱)
    SCORE							lConfigParameterK;				//配置调节系数(百分比):
    BOOL							nSysCtrlStorageDeadLine;		//库存截止
};

//房间调试结果
struct CMD_S_RoomCtrlResult
{
    DWORD							dwCtrlIndex;						//调试索引
    LONGLONG						lRoomCtrlSysStorage;				//超端房间调试系统库存(系统要赢的钱)
    LONGLONG						lRoomCtrlPlayerStorage;				//超端房间调试玩家库存(系统要赢的钱)
    SCORE							lRoomCtrlParameterK;				//超端房间调试调节系数(百分比):
    BOOL							nRoomCtrlStorageDeadLine;			//库存截止
    SCORE							lRoomCtrlDeadLineLimit;				//截止额度
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
    LONGLONG						lUserCtrlSysStorage;				//超端房间调试系统库存(系统要赢的钱)
    LONGLONG						lUserCtrlPlayerStorage;				//超端房间调试玩家库存(系统要赢的钱)
    SCORE							lUserCtrlParameterK;				//超端房间调试调节系数(百分比):
    BOOL							nUserCtrlStorageDeadLine;			//库存截止
    SCORE							lUserCtrlDeadLineLimit;				//截止额度
    SCORE							lUserCtrlSysWin;					//系统输赢总数
    SCORE							lUserCtrlPlayerWin;					//玩家输赢总数
    CTime							tmConfigTime;						//配置时间
    EM_ROOMCTRL_STATUS				roomCtrlStatus;						//当前状态
};


//系统调试结果
struct CMD_S_SysCtrlResult
{
    DWORD							dwCtrlIndex;						//索引(从1开始递增)
    SCORE							lSysCtrlSysStorage;					//当前系统库存(系统要赢的钱)
    SCORE							lSysCtrlPlayerStorage;				//当前玩家库存(玩家要赢的钱)
    SCORE							lSysCtrlParameterK;					//当前调节系数(百分比):
    SCORE							lSysCtrlDeadLineLimit;				//截止额度
    SCORE							lSysCtrlSysWin;						//系统输赢总数
    SCORE							lSysCtrlPlayerWin;					//玩家输赢总数
    CTime							tmResetTime;						//重设时间
    EM_SYSCTRL_STATUS				sysCtrlStatus;						//当前状态
};

//列表输赢信息
struct CMD_S_ListWinLostInfo
{
    SCORE							lSysCtrlSysWin;						//系统输赢总数
    SCORE							lSysCtrlPlayerWin;					//玩家输赢总数
    SCORE							lRoomCtrlSysWin;					//系统输赢总数
    SCORE							lRoomCtrlPlayerWin;					//玩家输赢总数
    SCORE							lUserCtrlSysWin;					//系统输赢总数
    SCORE							lUserCtrlPlayerWin;					//玩家输赢总数
    SCORE                           lRevenueWin;                        //系统税收
    CTime							tmStartRecord;						//开始记录时间
};


//调试提示
struct CMD_S_DebugText
{
    TCHAR							szMessageText[256];					//调试文本
};


//操作记录
struct CMD_S_Operation_Record
{
    TCHAR		szRecord[MAX_OPERATION_RECORD][RECORD_LENGTH];				//记录最新操作的20条记录
};

//当前房间调试信息
struct CMD_S_CurRoomCtrlInfo
{
    DWORD							dwCtrlIndex;						//调试索引
    LONGLONG						lRoomCtrlSysStorage;				//超端房间调试系统库存(系统要赢的钱)
    LONGLONG						lRoomCtrlPlayerStorage;				//超端房间调试玩家库存(系统要赢的钱)
    SCORE							lRoomCtrlParameterK;				//超端房间调试调节系数(百分比):
    SCORE							lRoomCtrlDeadLineLimit;				//截止额度
    SCORE							lRoomCtrlSysWin;					//系统输赢总数
    SCORE							lRoomCtrlPlayerWin;					//玩家输赢总数
    BYTE                            cbCtrlType;                         //当前控制类型
};

//当前用户调试信息
struct CMD_S_CurUserCtrlInfo
{
    DWORD							dwCtrlIndex;						//调试索引
    DWORD							dwGameID;						    //用户id
    LONGLONG						lUserCtrlSysStorage;				//超端房间调试系统库存(系统要赢的钱)
    LONGLONG						lUserCtrlPlayerStorage;				//超端房间调试玩家库存(系统要赢的钱)
    SCORE							lUserCtrlParameterK;				//超端房间调试调节系数(百分比):
    SCORE							lUserCtrlDeadLineLimit;				//截止额度
    SCORE							lUserCtrlSysWin;					//系统输赢总数
    SCORE							lUserCtrlPlayerWin;					//玩家输赢总数
};


//设置配置
struct CMD_C_SetRule
{
    SCORE							lConfigSysStorage;							//配置系统库存(系统要赢的钱)
    SCORE							lConfigPlayerStorage;						//配置玩家库存(玩家要赢的钱)
    SCORE							lConfigParameterK;							//配置调节系数(百分比)
    BOOL							nSysCtrlStorageDeadLine;					//库存截止
};

//房间调试
struct CMD_C_RoomCtrl
{
    DWORD							dwSelCtrlIndex;							//选择调试索引
    LONGLONG						lRoomCtrlSysStorage;					//超端房间调试系统库存(系统要赢的钱)
    LONGLONG						lRoomCtrlPlayerStorage;					//超端房间调试玩家库存(系统要赢的钱)
    SCORE							lRoomCtrlParameterK;					//超端房间调试调节系数(百分比):
    bool							bCancelRoomCtrl;						//取消调试标识(true为取消，false为设置调试)
    BOOL							nRoomCtrlStorageDeadLine;				//库存截止
};

//用户调试
struct CMD_C_UserCtrl
{
    DWORD							dwSelCtrlIndex;							//选择调试索引
    DWORD							dwUserID;							    //选择调试id
    LONGLONG						lUserCtrlSysStorage;					//超端房间调试系统库存(系统要赢的钱)
    LONGLONG						lUserCtrlPlayerStorage;					//超端房间调试玩家库存(系统要赢的钱)
    SCORE							lUserCtrlParameterK;					//超端房间调试调节系数(百分比):
    bool							bCancelUserCtrl;						//取消调试标识(true为取消，false为设置调试)
    BOOL							nUserCtrlStorageDeadLine;				//库存截止
};


/////////////////////////////////////////////////////////////////////////

#pragma pack(pop)
#endif

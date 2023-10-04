#ifndef CMD_TUITONGZI_HEAD_FILE
#define CMD_TUITONGZI_HEAD_FILE

//////////////////////////////////////////////////////////////////////////
//公共宏定义
#pragma pack(push)
#pragma pack(1)

#define KIND_ID						320									//游戏 I D
#define GAME_PLAYER					100									//游戏人数
#define GAME_NAME					TEXT("百人二八杠")					//游戏名字

//版本信息
#define VERSION_SERVER			    PROCESS_VERSION(7,0,1)				//程序版本
#define VERSION_CLIENT				PROCESS_VERSION(7,0,1)				//程序版本
//状态定义
#define GAME_SCENE_FREE				GAME_STATUS_FREE					//等待开始
#define	GS_PLACE_JETTON				GAME_STATUS_PLAY					//下注状态
#define	GS_GAME_END					GAME_STATUS_PLAY+1					//结束状态
#define	GS_MOVECARD_END				GAME_STATUS_PLAY+2					//结束状态

//区域索引
#define ID_SHUN_MEN					1									//顺门
#define ID_TIAN_MEN					2									//天
#define ID_DI_MEN					3									//地门

#define AREA_MAX                    4                                   //最大索引

//玩家索引
#define BANKER_INDEX				0									//庄家索引
#define SHANG_MEN_INDEX				1									//上门索引
#define TIAN_MEN_INDEX				2									//天门索引
#define XIA_MEN_INDEX				3									//下门索引

#define AREA_COUNT					3									//区域数目
//赔率定义
#define RATE_TWO_PAIR				12									//对子赔率

#define SERVER_LEN					32									//房间长度

#define SEAT_COUNT					6									//占位数量

#define STORAGE_COUNT				5									//库存控制数量

#define MAX_SEAT_COUNT				6									//最大占位个数

#define USER_LIST_COUNT				20									//列表玩家相应数据条数

//机器人信息
struct tagRobotInfo
{
	int nChip[6];														//筹码定义
	int nAreaChance[AREA_COUNT];										//区域几率
	TCHAR szCfgFileName[MAX_PATH];										//配置文件
	int	nMaxTime;														//最大赔率

	tagRobotInfo()
	{
		int nTmpChip[6] = {1, 5, 10, 50, 100, 500};
		int nTmpAreaChance[AREA_COUNT] = {1, 1, 1};
		TCHAR szTmpCfgFileName[MAX_PATH] = _T("28GangBattleConfig.ini");

		nMaxTime = 1;
		memcpy(nChip, nTmpChip, sizeof(nChip));
		memcpy(nAreaChance, nTmpAreaChance, sizeof(nAreaChance));
		memcpy(szCfgFileName, szTmpCfgFileName, sizeof(szCfgFileName));
	}
};

//记录信息
struct tagServerGameRecord
{
	BYTE							bWinShangMen;						//顺门胜利
	BYTE							bWinTianMen;						//天门胜利
	BYTE							bWinXiaMen;							//地门胜利
};


#ifndef _UNICODE
#define myprintf	myprintf
#define mystrcpy	strcpy
#define mystrlen	strlen
#define myscanf		_snscanf
#define	myLPSTR		LPCSTR
#define myatoi      atoi
#define myatoi64    _atoi64
#else
#define myprintf	swprintf
#define mystrcpy	wcscpy
#define mystrlen	wcslen
#define myscanf		_snwscanf
#define	myLPSTR		LPWSTR
#define myatoi      _wtoi
#define myatoi64	_wtoi64
#endif


//////////////////////////////////////////////////////////////////////////
//服务器命令结构

#define SUB_S_GAME_FREE				99									//游戏空闲
#define SUB_S_GAME_START			100									//游戏开始
#define SUB_S_PLACE_JETTON			101									//用户下注
#define SUB_S_GAME_END				102									//游戏结束
#define SUB_S_APPLY_BANKER			103									//申请庄家
#define SUB_S_CHANGE_BANKER			104									//切换庄家
#define SUB_S_SEND_RECORD			106									//游戏记录
#define SUB_S_PLACE_JETTON_FAIL		107									//下注失败
#define SUB_S_CANCEL_BANKER			108									//取消申请

#define SUB_ANDROID_INIT			115									//机器人信息

#define SUB_S_ONLINE_PLAYER			2014								//在线用户

#define SUB_S_OTHER_JETTON			2021								//其它玩家下注
#define SUB_S_SEAT_JETTON			2022								//占位玩家下注

#define SUB_S_RESPONSE_CONTROL		2030								//超端信息响应

//超端控制信息请求
struct CMD_S_ControlInfo
{
	BYTE							cbJuControl;							//是否进行局控
	BYTE							cbJuControlTimes;						//局控次数
	BYTE							cbJuControlArea[AREA_MAX];				//本局控制哪一门胜利 0不控制，1控制赢，2控制输

	SCORE							lAreaJettonScore[AREA_MAX];				//区域总注
	SCORE							lUserJettonScore[GAME_PLAYER][AREA_MAX];//个人总注
	TCHAR							szNickName[GAME_PLAYER][32];			//玩家昵称
};

//机器人信息
struct CMD_S_AndroidInit
{
	//全局信息
	TCHAR							szRoomName[SERVER_LEN];				//配置房间
	TCHAR							szConfigName[MAX_PATH];				//配置房间
};

//失败结构
struct CMD_S_PlaceJettonFail
{
	WORD							wPlaceUser;							//下注玩家
	BYTE							lJettonArea;						//下注区域
	SCORE							lPlaceScore;						//当前下注
};

//申请庄家
struct CMD_S_ApplyBanker
{
	WORD							wApplyUser;							//申请玩家
};

//取消申请
struct CMD_S_CancelBanker
{
	WORD							wCancelUser;						//取消玩家
};

//切换庄家
struct CMD_S_ChangeBanker
{
	WORD							wBankerUser;						//当庄玩家
	SCORE							lBankerScore;						//庄家金币
};

//游戏状态
struct CMD_S_StatusFree
{
	//全局信息
	BYTE							cbTimeLeave;						//剩余时间

	//玩家信息
	SCORE							lUserMaxScore;						//玩家金币

	WORD							wSeatUser[MAX_SEAT_COUNT];	//6个椅子玩家的椅子号

	//庄家信息
	WORD							wBankerUser;						//当前庄家
	WORD							cbBankerTime;						//庄家局数
	SCORE							lBankerWinScore;					//庄家成绩
	SCORE							lBankerScore;						//庄家分数

	BYTE							cbTableHavaSendCardArray[4][10];	//桌面扑克
	BYTE							cbTableHavaSendCount[4];			//桌面扑克
	BYTE							cbLeftCardCount;					//扑克数目

	//控制信息
	SCORE							lApplyBankerCondition;				//申请条件
	SCORE							lAreaLimitScore;					//区域限制

	//房间信息
	TCHAR							szGameRoomName[SERVER_LEN];			//房间名称
};

//游戏状态
struct CMD_S_StatusPlay
{
	//全局下注
	SCORE							lAllJettonScore[AREA_MAX];			//全体总注

	//玩家下注
	SCORE							lUserJettonScore[AREA_MAX];			//个人总注

	WORD							wSeatUser[MAX_SEAT_COUNT];	//6个椅子玩家的椅子号
	SCORE							lSeatUserWinScore[MAX_SEAT_COUNT];	//坐下的玩家输赢
	SCORE							lSeatUserAreaScore[MAX_SEAT_COUNT][AREA_MAX];	//6个椅子玩家的区域下注信息

	BYTE							cbTableHavaSendCardArray[4][10];	//桌面扑克
	BYTE							cbTableHavaSendCount[4];			//桌面扑克
	BYTE							cbLeftCardCount;					//扑克数目

	//玩家积分
	SCORE							lUserMaxScore;						//最大下注							

	//控制信息
	SCORE							lApplyBankerCondition;				//申请条件
	SCORE							lAreaLimitScore;					//区域限制

	//扑克信息
	BYTE							cbTableCardArray[4][2];				//桌面扑克

	BYTE							cbCardType[4];						//扑克类型

	BYTE							cbBankerTong;						//庄家通赔通赢

	BYTE							cbWinArea[4];						//区域输赢

	//庄家信息
	WORD							wBankerUser;						//当前庄家
	WORD							cbBankerTime;						//庄家局数
	SCORE							lBankerWinScore;					//庄家赢分
	SCORE							lBankerScore;						//庄家分数

	//结束信息
	SCORE							lEndBankerScore;					//庄家成绩
	SCORE							lEndUserScore;						//玩家成绩
	SCORE							lEndUserReturnScore;				//返回积分
	SCORE							lEndRevenue;						//游戏税收

	//全局信息
	BYTE							cbTimeLeave;						//剩余时间
	BYTE							cbGameStatus;						//游戏状态
	//房间信息
	TCHAR							szGameRoomName[SERVER_LEN];			//房间名称
};

//游戏空闲
struct CMD_S_GameFree
{
	BYTE							cbTimeLeave;						//剩余时间
};

//游戏开始
struct CMD_S_GameStart
{
	WORD							wBankerUser;						//庄家位置
	SCORE							lBankerScore;						//庄家金币
	SCORE							lUserMaxScore;						//我的金币
	BYTE							cbTableHavaSendCardArray[4][10];	//桌面扑克
	BYTE							cbTableHavaSendCount[4];			//桌面扑克
	BYTE							cbLeftCardCount;					//扑克数目

	BYTE							cbTimeLeave;						//剩余时间	
	bool							bContiueCard;						//继续发牌

	WORD							wSeatUser[MAX_SEAT_COUNT];	//6个椅子玩家的椅子号
};

//用户下注
struct CMD_S_PlaceJetton
{
	WORD							wChairID;							//用户位置
	BYTE							cbJettonArea;						//筹码区域
	SCORE							lJettonScore;						//加注数目
	bool							bIsAndroid;							//是否机器人

	SCORE							lUserRestScore;						//用户剩余金币
};

//游戏结束
struct CMD_S_GameEnd
{
	//下局信息
	BYTE							cbTimeLeave;						//剩余时间

	BYTE							cbBankerTong;						//庄家通赔通赢

	//扑克信息
	BYTE							cbTableCardArray[4][2];				//桌面扑克
	BYTE							cbTableHavaSendCardArray[4][10];	//桌面扑克
	BYTE							cbTableHavaSendCount[4];			//桌面扑克
	BYTE							cbLeftCardCount;					//扑克数目

	BYTE							cbCardType[4];						//扑克类型

	BYTE							cbWinArea[4];						//区域输赢
 
	//庄家信息
	SCORE							lBankerScore;						//庄家成绩
	SCORE							lBankerTotallScore;					//庄家成绩
	SCORE							lBankerHaveScore;					//庄家拥有金币
	INT								nBankerTime;						//做庄次数

	//玩家成绩
	SCORE							lUserScore;							//玩家成绩
	SCORE							lUserReturnScore;					//返回积分

	//全局信息
	SCORE							lRevenue;							//游戏税收

	SCORE							lSeatScore[SEAT_COUNT];				//占位玩家成绩
};

//玩家列表
struct CMD_S_UserList
{
	WORD							wCount;								//数组数量
	bool							bEnd;								//是否结束
	BYTE							cbIndex[USER_LIST_COUNT];			//排名
	TCHAR							szUserNick[USER_LIST_COUNT][32];	//昵称
	SCORE							lBetScore[USER_LIST_COUNT];			//近20局下注金额
	BYTE							cbWinTimes[USER_LIST_COUNT];		//近20局赢了多少局
	SCORE							lUserScore[USER_LIST_COUNT];		//玩家金币
	BYTE							wFaceID[USER_LIST_COUNT];			//玩家头像
	WORD							wChairID[USER_LIST_COUNT];
};

//玩家列表单个数据
struct CMD_S_UserListInfo
{
	WORD							wWinNum;							//获胜次数
	SCORE							lAllBet;							//下注分数
	SCORE							lUserScore;							//用户积分
	TCHAR							szNickName[32];						//用户昵称
	BYTE							wFaceID;							//玩家头像
	WORD							wChairID;
};
//////////////////////////////////////////////////////////////////////////
//客户端命令结构

#define SUB_C_PLACE_JETTON			100									//用户下注
#define SUB_C_APPLY_BANKER			101									//申请庄家
#define SUB_C_CANCEL_BANKER			102									//取消申请
#define SUB_C_ONLINE_PLAYER			103									//在线用户

#define SUB_C_REQUEST_CONTROL		110									//控制信息请求
#define SUB_C_CONTROL				111									//本局控制输赢
#define SUB_C_CANCEL_CONTROL		112									//取消本局控制

//用户下注
struct CMD_C_PlaceJetton
{
	BYTE							cbJettonArea;						//筹码区域
	SCORE							lJettonScore;						//加注数目
};

//超端局控
struct CMD_C_ControlWinLost
{
	BYTE							cbControlTimes;						//控制次数
	BYTE							cbJuControlArea[AREA_MAX];			//本局控制哪门胜利 0不控制，1控制赢，2控制输
};
//////////////////////////////////////////////////////////////////////////
#pragma pack(pop)

#endif

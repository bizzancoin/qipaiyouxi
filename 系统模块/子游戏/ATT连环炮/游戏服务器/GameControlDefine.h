#ifndef __H_GAME_CONTROL_DEFINE_H__
#define __H_GAME_CONTROL_DEFINE_H__
#include <cstdint>

//////////////////////////////////////////////////////////////////////////////////
//调试控制端(复用请求和回复)
#define SUB_C_EVENT_UPDATE					11									//事件更新
#define SUB_S_EVENT_UPDATE					12									//事件更新
//////////////////////////////////////////////////////////////////////////////////

#ifndef SCOREEX
#define SCOREEX int64_t
#endif

////////////////////////////////////////////
//类型定义
#define MAX_EVENT_SEND_BUFFER		8192
#define MAX_LONGLONG		(0x7FFFFFFFFFFFFFFF)

//控制事件类型
enum ControlEventType
{
	EventMin = 0,
	EventSysCtrl,			//系统调试更新
	EventRoomCtrl,			//房间调试更新
	EventUserCtrl,			//玩家调试更新
	EventGameTax,			//游戏抽水更新
	EventGameReward,		//游戏彩金更新
	EventGameExtra,			//游戏杂项数据更新
	EventGameStatistics,	//游戏综合数据更新
	EventGameWeightConfig,	//权重配置
	EventMax,
};

//控制事件更新通知(包头)
struct ControlUpdateEvent
{
	ControlEventType		emEventType;
	int64_t					nDataLen;
	void*					pData;
};

//（优先级，系统=区域>房间>收放表）
enum ControlType
{
	MinCtrl = 0,
	SysCtrl,							//系统库存控制
	RoomCtrl,							//房间库存控制
	UserCtrl,							//玩家调试
	//
	GameTax,							//税收
	GameReward,							//彩金
	GameExtra,							//杂项
	GameWeight,							//权重
	MaxCtrl,
};
enum ControlStatus
{
	NullStatus = 0,
	CancelCtrl,
	WaitForCtrl,
	AlreadyInCtrl,
	DoneCtrl,
	RemoveCtrl,
};
struct BaseCtrlInfo
{
	int64_t							nId = 0;											//索引号
	int64_t							lUpdateTime = 0;									//更新时间
	ControlStatus					curStatus = WaitForCtrl;							//当前状态
};

//系统调试、房间调试配置
struct StorageInfo :public BaseCtrlInfo
{
	SCOREEX							lConfigSysStorage = 100000;							//配置系统库存(系统要赢的钱)
	SCOREEX							lConfigPlayerStorage = 80000;						//配置玩家库存(玩家要赢的钱)
	int64_t							lConfigParameterK = 30;								//配置调节系数(百分比)
	int64_t							lConfigResetSection = 10;							//强制重置区间(百分比)

	SCOREEX							lCurSysStorage = 100000;							//当前系统库存(系统要赢的钱)
	SCOREEX							lCurPlayerStorage = 80000;							//当前玩家库存(玩家要赢的钱)
	int64_t							lCurParameterK = 30;								//当前调节系数(百分比):
	int64_t							lCurResetSection = 10;								//强制重置区间(百分比)

	SCOREEX							lSysCtrlSysWin = 0;									//系统输赢总数
	SCOREEX							lSysCtrlPlayerWin = 0;								//玩家输赢总数
	int64_t							lWinRatio = 0;										//当前输赢概率
	int64_t							lResetTimes = 0;									//重置次数
	int64_t							lOperateUser = 0;									//操作人
};

//玩家调试配置
struct GameDebugInfo :public BaseCtrlInfo
{
	int32_t							nType = 0;												//调试类型
	int32_t							nMaxWorkCount = 0;										//最大执行次数
	int32_t							nCurWorkCount = 0;										//当前执行次数
	int32_t							nGameID = 0;											//调试玩家GameID

	SCOREEX							lConfigSysStorage = 100000;							//配置系统库存(系统要赢的钱)
	SCOREEX							lConfigPlayerStorage = 80000;						//配置玩家库存(玩家要赢的钱)
	int64_t							lConfigParameterK = 30;								//配置调节系数(百分比):
	int64_t							lConfigResetSection = 10;							//强制重置区间(百分比)

	SCOREEX							lCurSysStorage = 100000;							//当前系统库存(系统要赢的钱)
	SCOREEX							lCurPlayerStorage = 80000;							//当前玩家库存(玩家要赢的钱)
	int64_t							lCurParameterK = 30;								//当前调节系数(百分比)
	int64_t							lCurResetSection = 10;								//强制重置区间(百分比):

	SCOREEX							lSysCtrlSysWin = 0;									//系统输赢总数
	SCOREEX							lSysCtrlPlayerWin = 0;								//玩家输赢总数
	int64_t							lWinRatio = 0;										//当前输赢概率
	int64_t							lResetTimes = 0;									//重置次数
	int64_t							lOperateUser = 0;									//操作人
};

//权重配置
struct WeightConfig
{
#define WEIGHT_CONFIG_MAX_SZIE	14
	int64_t		lIndex;					//索引
	int64_t		lMinTimes;				//最小倍数
	int64_t		lMaxTimes;				//最大倍数
	int64_t		lWeight;				//配置权重(1~1000)
	int64_t		lRatio;					//开奖概率
	WeightConfig(int64_t minTimes = 0, int64_t maxTimes = 0, int64_t weight = 1, int64_t index = 0)
	{
		lMinTimes = minTimes;
		lMaxTimes = maxTimes;
		lWeight = weight;
		lIndex = index;
		lRatio = 0;
	}
};

//抽水数据
struct GameTaxInfo
{
	SCOREEX		lCurStorage;				//当前抽水总量
	int64_t		lTaxRatio;					//抽水比例
	GameTaxInfo()
	{
		lCurStorage = 0;
		lTaxRatio = 2;
	}
};
//彩金数据
struct GameRewardInfo
{
	SCOREEX		lConfigStorage;				//配置彩金库存
	SCOREEX		lCurStorage;				//当前彩金库存
	SCOREEX		lDispatchStorage;			//派彩起点
	SCOREEX		lVirtualStorage;			//虚拟彩金库存(客户端显示使用)
	SCOREEX		lUserBetDispatch;			//个人下注派彩限制
	int64_t		lDispatchRatio;				//派彩概率
	int64_t		lTaxRatio;					//抽水比例
	GameRewardInfo()
	{
		lConfigStorage = 0;
		lCurStorage = 0;
		lDispatchStorage = 0;
		lDispatchRatio = 50;
		lTaxRatio = 2;
		lVirtualStorage = 0;
		lUserBetDispatch = 0;
	}
};
//其它数据
struct GameExtraInfo
{
	int64_t		lFreeGameRatio;				//免费游戏概率
	int64_t		lExtraGameRatio;			//小游戏概率
	GameExtraInfo()
	{
		lFreeGameRatio = 0;
		lExtraGameRatio = 0;
	}
};

//子控统计数据
struct SubControlStatisticsInfo
{
	SCOREEX							lSysCtrlSysWin;									//系统输赢总数
	SCOREEX							lSysCtrlPlayerWin;								//玩家输赢总数
	int64_t							lStorageResetCount;								//库存重置次数
};
//杂项配置
struct GameConfig
{
	SCOREEX							lStorageMin;									//库存最小设置
	SCOREEX							lStorageMax;									//库存最大设置
};
//游戏统计数据
struct StatisticsInfo
{
	SCOREEX							lSysCtrlSysWin;									//系统输赢总数
	SCOREEX							lSysCtrlPlayerWin;								//玩家输赢总数
	SCOREEX							lTotalServiceTax;								//总税收
	int64_t							lStartTime;										//开始时间

	SubControlStatisticsInfo		stSystem;										//系统调试
	SubControlStatisticsInfo		stRoom;											//房间调试
	SubControlStatisticsInfo		stArea;											//玩家调试

	GameConfig						stGameConfig;									//游戏设置
};
#endif
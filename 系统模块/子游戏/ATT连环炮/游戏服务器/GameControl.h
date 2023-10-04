#pragma once

#include "GameControlDefine.h"

#include <list>
#include <map>
#include <chrono>
#include <cassert>
#include <functional>
#include <queue>

interface ITableFrame;
interface IServerUserItem;
/////////////////////////////////////////////////////////////////////////////////////////
//子调试基类

class CGameControl;
//类型控制
class BaseCrontol
{
public:
	CGameControl*					m_pGameControl;										//上层接口
	ControlType						m_ctrlType;											//控制类型
	SCOREEX							m_lSysCtrlSysWin;									//系统输赢总数
	SCOREEX							m_lSysCtrlPlayerWin;								//玩家输赢总数
	int64_t							m_lStorageResetCount;								//库存重置次数

public:
	BaseCrontol(ControlType type)
	{
		m_ctrlType = type;
		m_lSysCtrlSysWin = 0;
		m_lSysCtrlPlayerWin = 0;
		m_lStorageResetCount = 0;
	}
	virtual ~BaseCrontol(){};

public:
	//增加一个配置
	virtual void Add(BaseCtrlInfo* pInfo)
	{
		pInfo->curStatus = WaitForCtrl;
		pInfo->lUpdateTime = std::chrono::system_clock::to_time_t(std::chrono::system_clock::now());
	}
	//获得一个有效配置
	virtual BaseCtrlInfo* GetValid() = 0;
	//获得最后一个配置
	virtual BaseCtrlInfo* GetLast() = 0;
	//更新配置状态
	virtual void CancelControl(int64_t nChooseIndx, bool bRemove = false) = 0;
	//更新库存
	virtual void UpdateStorage(SCOREEX lChangeValue) = 0;
	//激活下一个配置
	virtual void ActiveNext() = 0;
	//执行完成
	virtual void Done() = 0;
	//发送更新事件
	virtual void SendUpdateEvent(void* pInfo) = 0;
	//删除已完成数据
	virtual bool RemoveDone() = 0;
};

/////////////////////////////////////////////////////////////////////////////////////////
//玩家调试

class CDebugCrontol :public BaseCrontol
{
public:
	std::list<GameDebugInfo>		m_ctrllist;

public:
	CDebugCrontol(ControlType type) :BaseCrontol(type){}
	~CDebugCrontol(){}

public:
	//增加一个配置
	virtual void Add(BaseCtrlInfo* pInfo);
	//获得一个有效配置
	virtual BaseCtrlInfo* GetValid();
	//获得最后一个配置
	virtual BaseCtrlInfo* GetLast();
	//更新配置状态
	virtual void CancelControl(int64_t nChooseIndx, bool bRemove = false);
	//更新库存
	virtual void UpdateStorage(SCOREEX lChangeValue);
	//激活下一个配置
	virtual void ActiveNext();
	//执行完成
	virtual void Done();
	//发送更新事件
	virtual void SendUpdateEvent(void* pInfo);
	//删除已完成数据
	virtual bool RemoveDone();

public:
	//
	BaseCtrlInfo* GetValid(int32_t nGameID);
	//
	void UpdateStorage(int32_t nGameID, SCOREEX lChangeValue);
};

/////////////////////////////////////////////////////////////////////////////////////////
//系统调试、房间调试

class CStorageCrontol :public BaseCrontol
{
public:
	std::list<StorageInfo>		m_ctrllist;

public:
	CStorageCrontol(ControlType type) :BaseCrontol(type){}
	~CStorageCrontol(){}

public:
	//增加一个配置
	virtual void Add(BaseCtrlInfo* pInfo);
	//获得一个有效配置
	virtual BaseCtrlInfo* GetValid();
	//获得最后一个配置
	virtual BaseCtrlInfo* GetLast();
	//更新配置状态
	virtual void CancelControl(int64_t nChooseIndx, bool bRemove = false);
	//更新库存
	virtual void UpdateStorage(SCOREEX lChangeValue);
	//激活下一个配置
	virtual void ActiveNext();
	//执行完成
	virtual void Done();
	//发送更新事件
	virtual void SendUpdateEvent(void* pInfo);
	//删除已完成数据
	virtual bool RemoveDone();
};

/////////////////////////////////////////////////////////////////////////////////////////
//权重配置

class CGameWeightControl
{
	std::vector<WeightConfig>				m_weightConfig;
	int64_t									m_lTotalWieght;

public:
	CGameControl*							m_pGameControl;										//上层接口

public:
	CGameWeightControl(){};
	virtual ~CGameWeightControl(){};

public:
	int32_t Size(){ return m_weightConfig.size(); }
	WeightConfig At(uint32_t idx)
	{
		if (idx >= m_weightConfig.size())
			return WeightConfig();

		return m_weightConfig[idx];
	}
	//不存在的话自动新增
	void Add(int64_t minTimes, int64_t maxTimes = 0, int64_t weight = 1)
	{
		for (auto& it : m_weightConfig)
		{
			if (it.lMinTimes == minTimes && it.lMaxTimes == maxTimes)
			{
				m_lTotalWieght += weight - it.lWeight;
				it.lWeight = weight;
				return;
			}
		}

		m_weightConfig.emplace_back(WeightConfig(minTimes, maxTimes, weight, m_weightConfig.size()));
		m_lTotalWieght += weight;
	}
	//
	void Update(uint32_t nPos, int64_t weight)
	{
		if (nPos >= m_weightConfig.size() || weight < 1)
		{
			assert(false);
			return;
		}

		m_lTotalWieght += weight - m_weightConfig[nPos].lWeight;
		m_weightConfig[nPos].lWeight = weight;
	}

public:
	int CalcRatio(int64_t lWeight)
	{
		return (int)((SCOREEX)lWeight / m_lTotalWieght * 1000);
	}
	int GetTargetTimeRatio(int64_t lMinTimes, int64_t lMaxTimes = 0)
	{
		for (auto& it : m_weightConfig)
		{
			if (it.lMinTimes <= lMinTimes && (it.lMaxTimes >= lMaxTimes || it.lMaxTimes < 0))
			{
				return CalcRatio(it.lWeight);
			}
		}

		return 0;
	}

	WeightConfig GetRandConfig()
	{
		if (m_lTotalWieght == 0) m_lTotalWieght = 1000;
		int nRandValue = rand() % m_lTotalWieght;
		int64_t nStart = 0;
		for (auto& it : m_weightConfig)
		{
			if (nRandValue >= nStart && nRandValue < nStart + it.lWeight)
			{
				return it;
			}

			nStart += it.lWeight;
		}

		assert(false);
		return WeightConfig();
	}
	void GetNextTimes(int64_t nStartTimes,int64_t& lCurMinTimes, int64_t& lCurMaxTimes)
	{
		for (auto& it : m_weightConfig)
		{
			if (it.lMinTimes > nStartTimes)
			{
				lCurMinTimes = it.lMinTimes;
				lCurMaxTimes = it.lMaxTimes;
				if (lCurMaxTimes < 0) lCurMaxTimes = MAX_LONGLONG;
				else if (lCurMaxTimes == 0) lCurMaxTimes = lCurMinTimes;
				if (lCurMinTimes == lCurMaxTimes)
				{
					if (it.lIndex == 0) lCurMinTimes = 0;
					else
					{
						lCurMinTimes = At(static_cast<int32_t>(it.lIndex - 1)).lMaxTimes;
						if (lCurMinTimes == 0)
							lCurMinTimes = At(static_cast<int32_t>(it.lIndex - 1)).lMinTimes;
					}
				}
				return;
			}
		}
		assert(false);
		return;
	}
	void GetRandTimes(int64_t& lCurMinTimes, int64_t& lCurMaxTimes)
	{
		WeightConfig randWeight = GetRandConfig();
		if (randWeight.lWeight > 0)
		{
			lCurMinTimes = randWeight.lMinTimes;
			lCurMaxTimes = randWeight.lMaxTimes;
			if (lCurMaxTimes < 0) lCurMaxTimes = MAX_LONGLONG;
			else if (lCurMaxTimes == 0) lCurMaxTimes = lCurMinTimes;
			if (lCurMinTimes == lCurMaxTimes)
			{
				if (randWeight.lIndex == 0) lCurMinTimes = 0;
				else
				{
					lCurMinTimes = At(static_cast<int32_t>(randWeight.lIndex - 1)).lMaxTimes;
					if (lCurMinTimes == 0)
						lCurMinTimes = At(static_cast<int32_t>(randWeight.lIndex - 1)).lMinTimes;
				}
			}
		}
		else
		{
			lCurMinTimes = 0;
			lCurMaxTimes = MAX_LONGLONG;
		}
	}

	void SendUpdateEvent();
};

/////////////////////////////////////////////////////////////////////////////////////////
//游戏控制管理类

//功能实现
class CGameControl
{
	friend class CStorageCrontol;
	friend class CDebugCrontol;
	friend class CGameWeightControl;

	std::map<ControlType, BaseCrontol*>					m_ctrlTypes;					//所有控制类型
	std::queue<ControlUpdateEvent>						m_eventUpdate;					//事件更新
	char												m_eventSendBuffer[MAX_EVENT_SEND_BUFFER];//事件发送缓冲区

public:
	GameTaxInfo						m_gameTax;											//游戏抽水
	GameRewardInfo					m_gameReward;										//彩金
	GameExtraInfo					m_gameExtraInfo;									//游戏杂项
	//		
	CGameWeightControl				m_gameWieght;										//倍数权重
	//
	StatisticsInfo					m_gameStatisticsInfo;								//统计数据

public:
	CGameControl();
	virtual ~CGameControl();

public:
	//获取当前生效控制
	BaseCrontol* GetCurValidControl(int32_t nGameID = -1);
	//获取系统当前某类型控制信息
	BaseCrontol* GetCurTypeCtrl(ControlType type);
	//获取玩家输赢概率
	int32_t GetUserWinLoseRatio(int32_t nGameID = -1);
	//获得当前玩家库存
	SCOREEX GetCurPlayerStorage(int32_t nGameID = -1);
	//获得当前库存
	void GetCurStorage(SCOREEX& dSysStorage,SCOREEX& dUserStorage,int32_t nGameID = -1);

public:
	//增加一个控制配置
	void AddControl(ControlType type, GameDebugInfo& info);
	void AddControl(ControlType type, StorageInfo& info);
	void AddControl(ControlType type, GameTaxInfo& info);
	void AddControl(ControlType type, GameRewardInfo& info);
	void AddControl(ControlType type, GameExtraInfo& info);
	void AddControl(ControlType type, WeightConfig* pInfo, int nSize);
	//取消某一个控制配置(<0表示取消队列头部配置),是否移除该项
	void CancelControl(ControlType type, int32_t index,bool bRemove = false);
	//根据玩家输赢，更新库存
	void UpdateControlStorage(SCOREEX lUserWinLose, int32_t nGameID = -1);
	//更新属性值
	void AddStorage(ControlEventType type,SCOREEX dValue);

	//
public:
	//连线游戏库存更新
	void LineGameUpdateStorage(SCOREEX dUserBet, SCOREEX dUserWinScore, int32_t nGameID);

protected:
	//发送更新事件
	void SendUpdateEvent(ControlEventType type, void* pInfo);

public:
	//事件
	void SendEvent(ControlUpdateEvent& event);
	//处理事件并通知到对端
	void RefreshEvent(ITableFrame* pTable, IServerUserItem *pIServerUserItem);
	//
	void RefreshAll(ITableFrame* pTable, IServerUserItem *pIServerUserItem);

	//工具接口
public:
	//计算胜率
	static int32_t CalcWinRatio(SCOREEX lCurSysStorage, SCOREEX lCurPlayerStorage, int64_t lCurParameteK);
	//计算税收(千分比)
	static SCOREEX CalcTax(int32_t nTaxRatio, SCOREEX dScore)
	{
		if (dScore <= 0 || nTaxRatio <= 0)
			return 0;
		//2位精度
		int64_t tax = static_cast<int64_t>(dScore*nTaxRatio / 1000*100);
		return static_cast<SCOREEX>(tax/100);
	};
	//获取list制定位置元素，未找到返回空
	template<typename T = GameDebugInfo>
	static T* ListGetParam(std::list<T>& input,int32_t pos)
	{
		if (input.size() <= static_cast<size_t>(pos))
		{
			return nullptr;
		}

		for (auto& it : input)
		{
			if (0 == pos)
			{
				return (T*)&it;
			}
			--pos;
		}

		return nullptr;
	};
};


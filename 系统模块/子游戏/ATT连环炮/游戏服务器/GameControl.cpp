#include "Stdafx.h"
#include "GameControl.h"

//////////////////////////////////////////////////////////////////////////
//区域控制
//增加一个配置
void CDebugCrontol::Add(BaseCtrlInfo* pInfo)
{
	BaseCrontol::Add(pInfo);
	pInfo->nId = 0;
	if (!m_ctrllist.empty()) pInfo->nId = m_ctrllist.back().nId + 1;

	bool bUpdate = false;
	GameDebugInfo* pDebug = static_cast<GameDebugInfo*>(pInfo);
	
	//有同GameID项
	for (auto& it : m_ctrllist)
	{
		if (it.nGameID == pDebug->nGameID)
		{
#if 1//覆盖
			it = *pDebug;
			it.lConfigParameterK = pDebug->lConfigParameterK;
			it.lConfigPlayerStorage = pDebug->lConfigPlayerStorage;
			it.lConfigSysStorage = pDebug->lConfigSysStorage;
			it.lConfigResetSection = pDebug->lConfigResetSection;

			it.curStatus = WaitForCtrl;
			pDebug = &it;
			bUpdate = true;
			break;
#else //取消
			CancelControl(it.nId);
			break;
#endif
		}
	}

	bool bActive = true;
	for (auto& it : m_ctrllist)
	{
		if (it.curStatus == AlreadyInCtrl)
		{
			bActive = false;
			break;
		}
	}
	if (bActive)
	{
		pDebug->curStatus = AlreadyInCtrl;
	}
	pDebug->lWinRatio = CGameControl::CalcWinRatio(pDebug->lCurSysStorage, pDebug->lCurPlayerStorage, pDebug->lCurParameterK);
	//更新通知
	m_pGameControl->SendUpdateEvent(EventUserCtrl, (void*)pDebug);

	if (!bUpdate)
		m_ctrllist.emplace_back(*pDebug);
};
//获得一个有效配置
BaseCtrlInfo* CDebugCrontol::GetValid()
{
	for (auto& it : m_ctrllist)
	{
		if (it.curStatus == AlreadyInCtrl || it.curStatus == WaitForCtrl)
			return static_cast<BaseCtrlInfo*>(&it);
	}

	return nullptr;
};
//获得最后一个配置
BaseCtrlInfo* CDebugCrontol::GetLast()
{
	if (m_ctrllist.empty())
		return nullptr;

	return (BaseCtrlInfo*)&m_ctrllist.back();
};
//更新配置状态
void CDebugCrontol::CancelControl(int64_t nChooseIndx, bool bRemove)
{
	auto it = m_ctrllist.begin();
	for (; it != m_ctrllist.end(); ++it)
	{
		if ( (nChooseIndx < 0 && (it->curStatus == AlreadyInCtrl || it->curStatus == WaitForCtrl)) ||
			//(it->nId == nChooseIndx || it->nGameID == nChooseIndx)
			it->nGameID == nChooseIndx
			)
		{
			break;
		}
	}
	if (it == m_ctrllist.end())
		return;

	it->curStatus = CancelCtrl;
	//未生效配置默认删除
	if (bRemove || (it->lSysCtrlSysWin == 0 && it->lSysCtrlPlayerWin == 0))
		it->curStatus = RemoveCtrl;
	//更新通知
	m_pGameControl->SendUpdateEvent(EventUserCtrl, (void*)&(*it));

	if (RemoveCtrl == it->curStatus)
	{
		m_ctrllist.erase(it);
	}
};
//更新库存
void CDebugCrontol::UpdateStorage(SCOREEX lChangeValue)
{
	GameDebugInfo* pCtrl = static_cast<GameDebugInfo*>(GetValid());
	if (pCtrl == nullptr)
		return;

	//>0 减少玩家库存，<0 增加系统库存
	if (lChangeValue > 0)
	{
		pCtrl->lCurPlayerStorage -= lChangeValue;
		pCtrl->lSysCtrlPlayerWin += lChangeValue;
		m_lSysCtrlPlayerWin += lChangeValue;
	}
	else if (lChangeValue < 0)
	{
		pCtrl->lCurSysStorage += lChangeValue;
		pCtrl->lSysCtrlSysWin -= lChangeValue;
		m_lSysCtrlSysWin -= lChangeValue;
	}
	pCtrl->lWinRatio = CGameControl::CalcWinRatio(pCtrl->lCurSysStorage, pCtrl->lCurPlayerStorage, pCtrl->lCurParameterK);

	++pCtrl->nCurWorkCount;
	if( (pCtrl->lCurSysStorage <=0 && pCtrl->lCurPlayerStorage <= 0) || 
		pCtrl->lCurSysStorage <= -pCtrl->lConfigSysStorage*pCtrl->lCurResetSection / 100)
		Done();
	else
	{
		//更新通知
		m_pGameControl->SendUpdateEvent(EventUserCtrl, (void*)pCtrl);
	}
};
//激活下一个配置
void CDebugCrontol::ActiveNext()
{
	GameDebugInfo* pCtrl = static_cast<GameDebugInfo*>(GetValid());
	if (pCtrl != nullptr)
	{
		pCtrl->curStatus = AlreadyInCtrl;
		//更新通知
		m_pGameControl->SendUpdateEvent(EventUserCtrl, (void*)pCtrl);
	}
	//通知界面清空当前数据
	else
	{
		GameDebugInfo tmp;
		ZeroMemory(&tmp, sizeof(tmp));
		//更新通知
		m_pGameControl->SendUpdateEvent(EventUserCtrl, (void*)&tmp);
	}
};
//执行完成
void CDebugCrontol::Done()
{
	GameDebugInfo* pCtrl = static_cast<GameDebugInfo*>(GetValid());
	if (pCtrl == nullptr)
		return;

	pCtrl->curStatus = DoneCtrl;
	//更新通知
	m_pGameControl->SendUpdateEvent(EventUserCtrl, (void*)pCtrl);

	//下一个任务自动开始
	ActiveNext();
};

BaseCtrlInfo* CDebugCrontol::GetValid(int32_t nGameID)
{
	for (auto& it : m_ctrllist)
	{
		if (it.nGameID == nGameID && (it.curStatus == AlreadyInCtrl || it.curStatus == WaitForCtrl))
			return static_cast<BaseCtrlInfo*>(&it);
	}
	return nullptr;
};
//
void CDebugCrontol::UpdateStorage(int32_t nGameID, SCOREEX lChangeValue)
{
	GameDebugInfo* pCtrl = static_cast<GameDebugInfo*>(GetValid(nGameID));
	ASSERT(pCtrl != nullptr);

	//>0 减少玩家库存，<0 增加系统库存
	if (lChangeValue > 0)
	{
		pCtrl->lCurPlayerStorage -= lChangeValue;
		pCtrl->lSysCtrlPlayerWin += lChangeValue;
		m_lSysCtrlPlayerWin += lChangeValue;
		m_pGameControl->m_gameStatisticsInfo.stArea.lSysCtrlPlayerWin = m_lSysCtrlPlayerWin;
	}
	else if (lChangeValue < 0)
	{
		pCtrl->lCurSysStorage += lChangeValue;
		pCtrl->lSysCtrlSysWin -= lChangeValue;
		m_lSysCtrlSysWin -= lChangeValue;
		m_pGameControl->m_gameStatisticsInfo.stArea.lSysCtrlSysWin = m_lSysCtrlSysWin;
	}

	++pCtrl->nCurWorkCount;
	pCtrl->lWinRatio = CGameControl::CalcWinRatio(pCtrl->lCurSysStorage, pCtrl->lCurPlayerStorage, pCtrl->lCurParameterK);

	if ((pCtrl->lCurSysStorage <= 0 && pCtrl->lCurPlayerStorage <= 0) ||
		pCtrl->lCurSysStorage <= -pCtrl->lConfigSysStorage*pCtrl->lCurResetSection/100)
	{
		pCtrl->curStatus = DoneCtrl;
		//更新通知
		m_pGameControl->SendUpdateEvent(EventUserCtrl, (void*)pCtrl);

		//下一个任务自动开始
		ActiveNext();
	}
	else
	{
		//更新通知
		m_pGameControl->SendUpdateEvent(EventUserCtrl, (void*)pCtrl);
	}
};

//发送更新事件
void CDebugCrontol::SendUpdateEvent(void* pInfo)
{
	ControlUpdateEvent stEvent;
	stEvent.emEventType = EventUserCtrl;
	stEvent.nDataLen = sizeof(GameDebugInfo);
	stEvent.pData = (void*)(new GameDebugInfo());
	if (stEvent.pData == nullptr)
		return;
	memcpy(stEvent.pData, pInfo,static_cast<size_t>(stEvent.nDataLen));
	m_pGameControl->SendEvent(stEvent);
};
//删除已完成数据
bool CDebugCrontol::RemoveDone()
{
	for (auto& it : m_ctrllist)
	{
		if (it.curStatus == CancelCtrl || it.curStatus == DoneCtrl)
		{
			CancelControl(it.nGameID, true);
			return true;
		}
	}

	return false;
};
/////////////////////////////////////////////////////////////////////////
//库存控制
//增加一个配置
void CStorageCrontol::Add(BaseCtrlInfo* pInfo)
{
	BaseCrontol::Add(pInfo);
	pInfo->nId = 0;
	if (!m_ctrllist.empty()) pInfo->nId = m_ctrllist.back().nId + 1;

	StorageInfo* pDebug = static_cast<StorageInfo*>(pInfo);

	bool bActive = true;
	for (auto& it : m_ctrllist)
	{
		if (it.curStatus == AlreadyInCtrl)
		{
			bActive = false;
			break;
		}
	}
	if (bActive)
	{
		pDebug->curStatus = AlreadyInCtrl;
	}

	++m_lStorageResetCount;
	//pDebug->lResetTimes = m_lStorageResetCount;
	pDebug->lWinRatio = CGameControl::CalcWinRatio(pDebug->lCurSysStorage, pDebug->lCurPlayerStorage, pDebug->lCurParameterK);

	//更新通知
	m_pGameControl->SendUpdateEvent(this->m_ctrlType == SysCtrl ? EventSysCtrl : EventRoomCtrl, (void*)pDebug);

	m_ctrllist.emplace_back(*pDebug);
};
//获得一个有效配置
BaseCtrlInfo* CStorageCrontol::GetValid()
{
	for (auto& it : m_ctrllist)
	{
		if (it.curStatus == AlreadyInCtrl || it.curStatus == WaitForCtrl)
			return static_cast<BaseCtrlInfo*>(&it);
	}

	return nullptr;
};
//获得最后一个配置
BaseCtrlInfo* CStorageCrontol::GetLast()
{
	if (m_ctrllist.empty())
		return nullptr;

	return (BaseCtrlInfo*)&m_ctrllist.back();
};
//更新配置状态
void CStorageCrontol::CancelControl(int64_t nChooseIndx, bool bRemove)
{
	auto it = m_ctrllist.begin();
	for (; it != m_ctrllist.end(); ++it)
	{
		if ((nChooseIndx < 0 && it->curStatus == AlreadyInCtrl) ||
			it->nId == nChooseIndx
			)
		{
			break;
		}
	}
	if (it == m_ctrllist.end())
		return;

	it->curStatus = CancelCtrl;
	if (bRemove || (it->lSysCtrlSysWin == 0 && it->lSysCtrlPlayerWin == 0))
		it->curStatus = RemoveCtrl;

	//更新通知
	m_pGameControl->SendUpdateEvent(this->m_ctrlType == SysCtrl ? EventSysCtrl : EventRoomCtrl, (void*)&(*it));

	//未生效配置默认删除
	if (it->curStatus == RemoveCtrl)
	{
		m_ctrllist.erase(it);
	}
};
//更新库存
void CStorageCrontol::UpdateStorage(SCOREEX lChangeValue)
{
	StorageInfo* pCtrl = static_cast<StorageInfo*>(GetValid());
	if (pCtrl == nullptr)
		return;

	//>0 减少玩家库存，<0 减少系统库存
	if (lChangeValue > 0)
	{
		pCtrl->lCurPlayerStorage -= lChangeValue;
		pCtrl->lSysCtrlPlayerWin += lChangeValue;
		m_lSysCtrlPlayerWin += lChangeValue;
		if (m_ctrlType == SysCtrl)	m_pGameControl->m_gameStatisticsInfo.stSystem.lSysCtrlPlayerWin = m_lSysCtrlPlayerWin;
		else m_pGameControl->m_gameStatisticsInfo.stRoom.lSysCtrlPlayerWin = m_lSysCtrlPlayerWin;
	}
	else if (lChangeValue < 0)
	{
		pCtrl->lCurSysStorage += lChangeValue;
		pCtrl->lSysCtrlSysWin -= lChangeValue;
		m_lSysCtrlSysWin -= lChangeValue;
		if (m_ctrlType == SysCtrl)	m_pGameControl->m_gameStatisticsInfo.stSystem.lSysCtrlSysWin = m_lSysCtrlSysWin;
		else m_pGameControl->m_gameStatisticsInfo.stRoom.lSysCtrlSysWin = m_lSysCtrlSysWin;
	}
	pCtrl->lWinRatio = CGameControl::CalcWinRatio(pCtrl->lCurSysStorage, pCtrl->lCurPlayerStorage, pCtrl->lCurParameterK);
	//系统、玩家库存为0时表示过程处理完成
	if ((pCtrl->lCurSysStorage <= 0 && pCtrl->lCurPlayerStorage <= 0) || 
		pCtrl->lCurSysStorage <= -pCtrl->lConfigSysStorage*pCtrl->lCurResetSection / 100)
	{
		Done();
	}
	else
	{
		//更新通知
		m_pGameControl->SendUpdateEvent(this->m_ctrlType == SysCtrl ? EventSysCtrl : EventRoomCtrl, (void*)pCtrl);
	}
};
//激活下一个配置
void CStorageCrontol::ActiveNext()
{
	StorageInfo* pCtrl = static_cast<StorageInfo*>(GetValid());
	if (pCtrl != nullptr)
	{
		pCtrl->curStatus = AlreadyInCtrl;
		//更新通知
		m_pGameControl->SendUpdateEvent(this->m_ctrlType == SysCtrl ? EventSysCtrl : EventRoomCtrl, (void*)pCtrl);
	}
	else if (m_ctrlType == SysCtrl)
	{
		StorageInfo* plast = (StorageInfo*)GetLast();
		if (plast != nullptr)
		{
			++m_lStorageResetCount;
			StorageInfo& newInfo = *plast;
			//重置
			newInfo.lCurResetSection = newInfo.lConfigResetSection;
			newInfo.lCurParameterK = newInfo.lConfigParameterK;
			newInfo.lCurSysStorage += newInfo.lConfigSysStorage;
			newInfo.lCurPlayerStorage += newInfo.lConfigPlayerStorage;
			newInfo.lUpdateTime = std::chrono::system_clock::to_time_t(std::chrono::system_clock::now());
			newInfo.lWinRatio = CGameControl::CalcWinRatio(newInfo.lCurSysStorage, newInfo.lCurPlayerStorage, newInfo.lCurParameterK);
			newInfo.lResetTimes += 1;
			newInfo.curStatus = AlreadyInCtrl;
			//m_ctrllist.emplace_back(newInfo);

			//更新通知
			m_pGameControl->SendUpdateEvent(this->m_ctrlType == SysCtrl ? EventSysCtrl : EventRoomCtrl, (void*)&newInfo);
		}
	}
	//通知界面清空当前数据
	else
	{
		StorageInfo tmp;
		ZeroMemory(&tmp, sizeof(tmp));
		//更新通知
		m_pGameControl->SendUpdateEvent(this->m_ctrlType == SysCtrl ? EventSysCtrl : EventRoomCtrl, (void*)&tmp);
	}
};
//执行完成
void CStorageCrontol::Done()
{
	StorageInfo* pCtrl = static_cast<StorageInfo*>(GetValid());
	if (pCtrl == nullptr)
		return;

	pCtrl->curStatus = DoneCtrl;

	//更新通知
	m_pGameControl->SendUpdateEvent(this->m_ctrlType == SysCtrl ? EventSysCtrl : EventRoomCtrl, (void*)pCtrl);

	//下一个任务自动开始
	ActiveNext();
};

//发送更新事件
void CStorageCrontol::SendUpdateEvent(void* pInfo)
{
	ControlUpdateEvent stEvent;
	stEvent.emEventType = this->m_ctrlType == SysCtrl ? EventSysCtrl : EventRoomCtrl;
	stEvent.nDataLen = sizeof(StorageInfo);
	stEvent.pData = (void*)(new StorageInfo());
	if (stEvent.pData == nullptr)
		return;
	memcpy(stEvent.pData, pInfo, static_cast<size_t>(stEvent.nDataLen));
	m_pGameControl->SendEvent(stEvent);
};
//删除已完成数据
bool CStorageCrontol::RemoveDone()
{
	for (auto& it : m_ctrllist)
	{
		if (it.curStatus == CancelCtrl || it.curStatus == DoneCtrl)
		{
			CancelControl(it.nId, true);
			return true;
		}
	}

	return false;
};
//////////////////////////////////////////////////////////////////////////
//权重配置
void CGameWeightControl::SendUpdateEvent()
{
	WeightConfig weightConfig[WEIGHT_CONFIG_MAX_SZIE];
	ZeroMemory(weightConfig, sizeof(weightConfig));

	int nCurIndex = 0;
	for (auto& it : m_weightConfig)
	{
		weightConfig[nCurIndex] = it;
		weightConfig[nCurIndex].lRatio = CalcRatio(it.lWeight);
		if (++nCurIndex == WEIGHT_CONFIG_MAX_SZIE)
			break;
	}
	assert(nCurIndex == WEIGHT_CONFIG_MAX_SZIE);
	m_pGameControl->SendUpdateEvent(EventGameWeightConfig, (void*)weightConfig);
}

//////////////////////////////////////////////////////////////////////////
//
CGameControl::CGameControl()
{
	m_ctrlTypes.clear();
	srand(static_cast<unsigned int>(time(0)));

	memset((void*)&m_gameStatisticsInfo, 0, sizeof(m_gameStatisticsInfo));
	m_gameStatisticsInfo.lStartTime = std::chrono::system_clock::to_time_t(std::chrono::system_clock::now());

	m_gameWieght.m_pGameControl = this;
}


CGameControl::~CGameControl()
{
	for (auto& it : m_ctrlTypes)
	{
		if (it.second != nullptr)
		{
			delete it.second;
			it.second = nullptr;
		}
	}

	m_ctrlTypes.clear();
}

//获取当前生效控制
BaseCrontol* CGameControl::GetCurValidControl(int32_t nGameID /*= -1*/)
{
	//优先级： 区域 >  房间 > 系统
	auto it = m_ctrlTypes.find(UserCtrl);
	if (nGameID > 0 && it != m_ctrlTypes.end())
	{
		CDebugCrontol* pUserCtrl = (CDebugCrontol*)it->second;
		if (pUserCtrl->GetValid(nGameID) != nullptr)
			return dynamic_cast<BaseCrontol*>(it->second);
	}

	it = m_ctrlTypes.find(RoomCtrl);
	if (it != m_ctrlTypes.end())
	{
		if (it->second->GetValid() != nullptr)
			return dynamic_cast<BaseCrontol*>(it->second);
	}

	it = m_ctrlTypes.find(SysCtrl);
	if (it != m_ctrlTypes.end())
	{
		if (it->second->GetValid() != nullptr)
			return dynamic_cast<BaseCrontol*>(it->second);
	}

	return nullptr;
}
//获取系统当前系统控制库存信息
BaseCrontol* CGameControl::GetCurTypeCtrl(ControlType type)
{
	auto it = m_ctrlTypes.find(type);
	if (it == m_ctrlTypes.end())
		return nullptr;
	
	return it->second;
};

//增加一个控制配置
void CGameControl::AddControl(ControlType type, GameDebugInfo& info)
{
	auto it = m_ctrlTypes.find(type);
	if (it == m_ctrlTypes.end())
	{
		m_ctrlTypes[type] = nullptr;
		m_ctrlTypes[type] = new CDebugCrontol(type);
		m_ctrlTypes[type]->m_pGameControl = this;
	}
	if (info.curStatus == CancelCtrl || info.curStatus == RemoveCtrl)
	{
		CancelControl(type, info.nGameID, info.curStatus == RemoveCtrl ? true : false);
		return;
	}
	assert(m_ctrlTypes[type] != nullptr);
	m_ctrlTypes[type]->Add((BaseCtrlInfo*)&info);
}
void CGameControl::AddControl(ControlType type, StorageInfo& info)
{
	auto it = m_ctrlTypes.find(type);
	if (it == m_ctrlTypes.end())
	{
		m_ctrlTypes[type] = nullptr;
		m_ctrlTypes[type] = new CStorageCrontol(type);
		m_ctrlTypes[type]->m_pGameControl = this;
	}
	if (info.curStatus == CancelCtrl)
	{
		CancelControl(type, static_cast<int32_t>(info.nId));
		return;
	}
	//玩家库存、系统库存，均同时只有一个生效
	else
	{
		m_ctrlTypes[type]->CancelControl(-1);
	}

	assert(m_ctrlTypes[type] != nullptr);
	m_ctrlTypes[type]->Add((BaseCtrlInfo*)&info);
}
void CGameControl::AddControl(ControlType type, GameTaxInfo& info)
{
	m_gameTax.lTaxRatio = info.lTaxRatio;
	SendUpdateEvent(EventGameTax, &m_gameTax);
};
void CGameControl::AddControl(ControlType type, GameRewardInfo& info)
{
	//m_gameReward.lCurStorage = m_gameReward.lConfigStorage = info.lConfigStorage;
	m_gameReward.lDispatchStorage = info.lDispatchStorage;
	m_gameReward.lDispatchRatio = info.lDispatchRatio;
	m_gameReward.lTaxRatio = info.lTaxRatio;
	m_gameReward.lVirtualStorage = info.lVirtualStorage;
	SendUpdateEvent(EventGameReward, &m_gameReward);
};
void CGameControl::AddControl(ControlType type, GameExtraInfo& info)
{
	m_gameExtraInfo.lFreeGameRatio = info.lFreeGameRatio;
	m_gameExtraInfo.lExtraGameRatio = info.lExtraGameRatio;
	SendUpdateEvent(EventGameExtra, &m_gameExtraInfo);
};
void CGameControl::AddControl(ControlType type, WeightConfig* pInfo, int nSize)
{
	for (int i = 0; i < nSize; ++i)
	{
		m_gameWieght.Update(static_cast<uint32_t>((pInfo + i)->lIndex), (pInfo + i)->lWeight);
	}
	m_gameWieght.SendUpdateEvent();
};
//取消某一个控制配置
void CGameControl::CancelControl(ControlType type, int32_t index, bool bRemove)
{
	auto it = m_ctrlTypes.find(type);
	if (it == m_ctrlTypes.end())
		return ;

	//表示删除所有非执行态
	if (index < 0 && bRemove)
	{
		while (it->second->RemoveDone());

		return;
	}
	else 
		it->second->CancelControl(index, bRemove);

	it->second->ActiveNext();
};

//根据玩家输赢，更新库存
void CGameControl::UpdateControlStorage(SCOREEX lUserWinLose, int32_t nGameID /*= -1*/)
{
	//更新子库存
	BaseCrontol* pCtrl = GetCurValidControl(nGameID);
	if (pCtrl != nullptr)
	{
		if (pCtrl->m_ctrlType != UserCtrl)
			pCtrl->UpdateStorage(lUserWinLose);
		else
		{
			CDebugCrontol* pDebug = (CDebugCrontol*)pCtrl;
			pDebug->UpdateStorage(nGameID,lUserWinLose);
		}
	}

	//更新总输赢 系统总输赢 = 各调试系统总输赢 + 下注抽水库存 + 彩金库存 
	m_gameStatisticsInfo.lSysCtrlPlayerWin += lUserWinLose;
	m_gameStatisticsInfo.lSysCtrlSysWin -= lUserWinLose;

	//更新通知
	StatisticsInfo tmp = m_gameStatisticsInfo;
	tmp.lSysCtrlSysWin += m_gameTax.lCurStorage + m_gameReward.lCurStorage;
	SendUpdateEvent(EventGameStatistics, (void*)&tmp);
	SendUpdateEvent(EventGameTax, (void*)&m_gameTax);
	SendUpdateEvent(EventGameReward, (void*)&m_gameReward);
	SendUpdateEvent(EventGameExtra, (void*)&m_gameExtraInfo);
};
//更新属性值
void CGameControl::AddStorage(ControlEventType type, SCOREEX dValue)
{
	switch (type)
	{
	case EventGameTax:
		m_gameTax.lCurStorage += dValue;
		SendUpdateEvent(type, (void*)&m_gameTax);
		break;
	case EventGameReward:
		m_gameReward.lCurStorage += dValue;
		SendUpdateEvent(type, (void*)&m_gameReward);
		break;
	case EventSysCtrl:
	case EventRoomCtrl:
	case EventUserCtrl:
	case EventGameExtra:
	case EventGameStatistics:
	case EventGameWeightConfig:
	default:
		return;
	}
};
//发送更新事件
void CGameControl::SendUpdateEvent(ControlEventType type, void* pInfo)
{
	ControlUpdateEvent stEvent;
	stEvent.emEventType = type;
	switch (type)
	{
	case EventGameTax:
		stEvent.nDataLen = sizeof(GameTaxInfo);
		break;
	case EventGameReward:
		stEvent.nDataLen = sizeof(GameRewardInfo);
		break;
	case EventGameExtra:
		stEvent.nDataLen = sizeof(GameExtraInfo);
		break;
	case EventGameStatistics:
		stEvent.nDataLen = sizeof(StatisticsInfo);
		break;
	case EventGameWeightConfig:
		stEvent.nDataLen = sizeof(WeightConfig)*WEIGHT_CONFIG_MAX_SZIE;
		break;
	case EventSysCtrl:
	case EventRoomCtrl:
		stEvent.nDataLen = sizeof(StorageInfo);
		break;
	case EventUserCtrl:
		stEvent.nDataLen = sizeof(GameDebugInfo);
		break;
	default:
		assert(false);
		return;
	}

	stEvent.pData = (void*)(new char[static_cast<uint32_t>(stEvent.nDataLen)]);
	if (stEvent.pData == nullptr)
	{
		assert(false);
		return;
	}

	memcpy(stEvent.pData, pInfo, static_cast<size_t>(stEvent.nDataLen));
	SendEvent(stEvent);
};

//事件
void CGameControl::SendEvent(ControlUpdateEvent& event)
{
	m_eventUpdate.push(event);
};
//处理事件并通知到对端
void CGameControl::RefreshEvent(ITableFrame* pTable, IServerUserItem *pIServerUserItem)
{
	assert(pTable != nullptr);
	if (pTable == nullptr)
		return;

	while (!m_eventUpdate.empty())
	{
		ControlUpdateEvent& stEvent = m_eventUpdate.front();
		//发送数据超长
		if (sizeof(ControlUpdateEvent)+stEvent.nDataLen > MAX_EVENT_SEND_BUFFER)
		{
			assert(false);
			m_eventUpdate.pop();
			continue;
		}
		//填充包头
		memcpy(m_eventSendBuffer, (void*)&stEvent, sizeof(ControlUpdateEvent));
		//填充数据部分
		memcpy(m_eventSendBuffer + sizeof(ControlUpdateEvent), stEvent.pData, static_cast<uint32_t>(stEvent.nDataLen));
		//发送
		pTable->SendRoomData(pIServerUserItem, SUB_S_EVENT_UPDATE, (void*)m_eventSendBuffer, static_cast<WORD>(sizeof(ControlUpdateEvent)+stEvent.nDataLen));

		//释放内存
		delete stEvent.pData;
		m_eventUpdate.pop();
	}
};

//
void CGameControl::RefreshAll(ITableFrame* pTable, IServerUserItem *pIServerUserItem)
{
	SendUpdateEvent(EventGameTax,(void*)&m_gameTax);
	SendUpdateEvent(EventGameReward, (void*)&m_gameReward);
	SendUpdateEvent(EventGameExtra, (void*)&m_gameExtraInfo);
	//
	StatisticsInfo tmp = m_gameStatisticsInfo;
	tmp.lSysCtrlSysWin += m_gameTax.lCurStorage + m_gameReward.lCurStorage;
	SendUpdateEvent(EventGameStatistics, (void*)&tmp);
	//列表数据
	for (auto& it : m_ctrlTypes)
	{
		switch (it.second->m_ctrlType)
		{
		case SysCtrl:
		case RoomCtrl:
		{
						 CStorageCrontol* pControl = (CStorageCrontol*)it.second;
						 for (auto& pItem : pControl->m_ctrllist)
						 {
							 SendUpdateEvent(pControl->m_ctrlType == SysCtrl ? EventSysCtrl : EventRoomCtrl, &pItem);
						 }
		}break;
		case UserCtrl:
		{
						 CStorageCrontol* pControl = (CStorageCrontol*)it.second;
						 for (auto& pItem : pControl->m_ctrllist)
						 {
							 SendUpdateEvent(EventUserCtrl, &pItem);
						 }
		}break;
		default:
			break;
		}
	}
	//权重配置
	m_gameWieght.SendUpdateEvent();

	//发送
	RefreshEvent(pTable, pIServerUserItem);
};

//获取玩家输赢概率
int32_t CGameControl::GetUserWinLoseRatio(int32_t nGameID /*= -1*/)
{
	int32_t nWinRatio = 0;

	BaseCrontol* pCurCtrl = GetCurValidControl(nGameID );
	if (pCurCtrl == nullptr)
	{
		//纯随机
		nWinRatio = rand()%100;
		return nWinRatio;
	}
	if (pCurCtrl->m_ctrlType == UserCtrl)
	{
		CDebugCrontol* pCtrl = (CDebugCrontol*)pCurCtrl;
		GameDebugInfo* pDebug = (GameDebugInfo*)pCtrl->GetValid(nGameID);
		//根据库存计算
		return CalcWinRatio(pDebug->lCurSysStorage, pDebug->lCurPlayerStorage, pDebug->lCurParameterK);
	}
	else
	{
		StorageInfo* pDebug = (StorageInfo*)pCurCtrl->GetValid();
		//根据库存计算
		return CalcWinRatio(pDebug->lCurSysStorage, pDebug->lCurPlayerStorage, pDebug->lCurParameterK);
	}
};

//计算胜率
int32_t CGameControl::CalcWinRatio(SCOREEX lCurSysStorage, SCOREEX lCurPlayerStorage, int64_t lCurParameteK)
{
	int32_t nWinRatio = 0;
	SCOREEX lDval = abs(lCurSysStorage - lCurPlayerStorage);
	SCOREEX lMax = max(lCurPlayerStorage, lCurSysStorage);
	int64_t lParameterK = lCurParameteK;

	bool bSysWin = lCurSysStorage > lCurPlayerStorage;
	if (lDval == lMax)
	{
		nWinRatio = lParameterK > 0 && lCurPlayerStorage == 0 ? 0 : 70;
	}
	else if (lDval <= lMax * lCurParameteK / 100)
	{
		nWinRatio = bSysWin ? 50 : 20;
	}
	else if (lDval > lMax * lParameterK / 100 && lDval <= 1.5 * lMax * lParameterK / 100)//1.5
	{
		nWinRatio = bSysWin ? 40 : 30;
	}
	else if (lDval > lMax * lParameterK / 100 && lDval <= 2 * lMax * lParameterK / 100)//2
	{
		nWinRatio = bSysWin ? 30 : 40;
	}
	else if (lDval > lMax * lParameterK / 100 && lDval <= 3 * lMax * lParameterK / 100)//3
	{
		nWinRatio = bSysWin ? 20 : 50;
	}
	else
	{
		nWinRatio = bSysWin ? 0 : 70;
	}

	return nWinRatio;
};

//获得当前玩家库存
SCOREEX CGameControl::GetCurPlayerStorage(int32_t nGameID)
{
	BaseCrontol* pCurCtrl = GetCurValidControl(nGameID);
	if (pCurCtrl == nullptr)
	{
		ASSERT(false);
		return 0;
	}

	if (pCurCtrl->m_ctrlType == UserCtrl)
	{
		GameDebugInfo* pInfo = (GameDebugInfo*)pCurCtrl->GetValid();
		return pInfo->lCurPlayerStorage;
	}

	StorageInfo* pInfo = (StorageInfo*)pCurCtrl->GetValid();
	return pInfo->lCurPlayerStorage;
};

//获得当前库存
void CGameControl::GetCurStorage(SCOREEX& dSysStorage, SCOREEX& dUserStorage, int32_t nGameID )
{
	BaseCrontol* pCurCtrl = GetCurValidControl(nGameID);
	if (pCurCtrl == nullptr)
	{
		ASSERT(false);
		return ;
	}

	if (pCurCtrl->m_ctrlType == UserCtrl)
	{
		GameDebugInfo* pInfo = (GameDebugInfo*)pCurCtrl->GetValid();
		dSysStorage = pInfo->lCurSysStorage;
		dUserStorage = pInfo->lCurPlayerStorage;
		return ;
	}

	StorageInfo* pInfo = (StorageInfo*)pCurCtrl->GetValid();
	dSysStorage = pInfo->lCurSysStorage;
	dUserStorage = pInfo->lCurPlayerStorage;
};

//连线游戏库存更新
void CGameControl::LineGameUpdateStorage(SCOREEX dUserBet, SCOREEX dUserWinScore,int32_t nGameID)
{
	//下注抽水
	SCOREEX dBetTxChange = (dUserBet*m_gameTax.lTaxRatio) / 100;
	m_gameTax.lCurStorage += dBetTxChange;
	//彩金抽水，按下注抽
	SCOREEX dRewardChange = (dUserBet*m_gameReward.lTaxRatio) / 100;
	m_gameReward.lCurStorage += dRewardChange;

	SCOREEX dStorageChange = 0;
	//玩家输，减系统库存
	if (dUserBet > dUserWinScore)
	{
		// = 系统赢钱 - 抽水 - 彩金抽水
		dStorageChange = -(dUserWinScore - dUserBet) - dBetTxChange - dRewardChange;
		dStorageChange > 0 ? dStorageChange = -dStorageChange : 0;
	}
	//玩家赢，减玩家库存
	else if (dUserBet < dUserWinScore)
	{
		// = 玩家赢钱 + 抽水 + 彩金抽水
		dStorageChange = (dUserWinScore - dUserBet) + dBetTxChange + dRewardChange;
		dStorageChange > 0 ? 0 : dStorageChange = -dStorageChange;
	}
	//玩家不输不赢，减系统库存
	else
	{
		dStorageChange = dBetTxChange + dRewardChange;
		dStorageChange > 0 ? dStorageChange = -dStorageChange : 0;
	}

	//dStorageChange > 0表示减玩家库存，<0表示减系统库存
	UpdateControlStorage(dStorageChange, nGameID);
};
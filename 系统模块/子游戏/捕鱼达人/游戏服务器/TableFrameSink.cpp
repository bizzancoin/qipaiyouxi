
#include "StdAfx.h"
#include "TableFrameSink.h"

#include <cmath>
#include <algorithm>

#include "game_config.h"

static GameConfig m_pGameConfig;
const DWORD m_dwGameLoopTimer = 1;
const DWORD m_dwGameSceneTimer = 2;
const DWORD m_dwGameAndroidTimer = 3;

const DWORD m_dwRepeatTimer = (DWORD)-1;


CTableFrameSink::CTableFrameSink()
{
	m_pITableFrame = NULL;
	m_pGameServiceAttrib = NULL;
	m_pGameServiceOption = NULL;
	m_dwLasttime = 0;
	m_dwLastSceneTime = 0;
	m_dwAndroidSceneTime = 0;
	m_dwLastWriteScoretime = 0;
	m_dwLastDeductStoragetime = 0;
	m_dwStarttime = 0;
	m_fSceneElapsed = 0;
	m_nSceneStatus = SCENE_NONE;
	ZeroMemory(m_lExchangeFishScore, sizeof(m_lExchangeFishScore));
	ZeroMemory(m_lFishScore, sizeof(m_lFishScore));
	ZeroMemory(m_fDistributeElapsed, sizeof(m_fDistributeElapsed));
	ZeroMemory(m_nCurrentBulletMulriple, sizeof(m_nCurrentBulletMulriple));
	ZeroMemory(m_fAndroidFireElapsed, sizeof(m_fAndroidFireElapsed));
	ZeroMemory(m_fFireOperateTime, sizeof(m_fFireOperateTime));
	ZeroMemory(m_nFireOperateType, sizeof(m_nFireOperateType));
	ZeroMemory(m_nLastLockFishId, sizeof(m_nLastLockFishId));

	ZeroMemory(m_dwEnterGameTime, sizeof(m_dwEnterGameTime));//cy add
	ZeroMemory(m_dwLastFireTime, sizeof(m_dwLastFireTime)); // lxf add

	ZeroMemory(m_fAndroidChangeBulletTime, sizeof(m_fAndroidChangeBulletTime));
	
	FillMemory(m_nAndroidTargetMulriple, sizeof(m_nAndroidTargetMulriple), 1);
	FillMemory(m_wReplaceCatch, sizeof(m_wReplaceCatch),INVALID_CHAIR);

	m_pFishManager.Initialize(m_kMaxFishInManager);
	m_pBulletManager.Initialize(m_kMaxBulletsInManager);

	m_nSceneKind = rand() % 2 + 1;

	for (WORD i = 0; i < GAME_PLAYER; i++)
	{
		//机器人开炮角度  0,1位置为6.28~3.14    2,3位置为 0~3.14
		m_fAndroidRandAngle[i] = rand() % (214) + 364;
		if (i == 2 || i == 3)
			m_fAndroidRandAngle[i] = rand() % (214) + 50;
		m_fAndroidRandAngle[i] = m_fAndroidRandAngle[i] / 100;
	}
}

CTableFrameSink::~CTableFrameSink()
{
	CMDDistributeFishVector::iterator it = m_pDistributeFishActive.begin();
	for (; it != m_pDistributeFishActive.end(); ++it) 
	{
		delete (*it);
	}
	for (it = m_pDistributeFishStorage.begin(); it != m_pDistributeFishStorage.end(); ++it) 
	{
		delete (*it);
	}

	//cy add end
	m_pFishManager.Cleanup();
	m_pBulletManager.Cleanup();
}

void* CTableFrameSink::QueryInterface(REFGUID guid, DWORD query_ver) 
{
	QUERYINTERFACE(ITableFrameSink, guid, query_ver);
	QUERYINTERFACE(ITableUserAction, guid, query_ver);
	QUERYINTERFACE_IUNKNOWNEX(ITableFrameSink, guid, query_ver);
	return NULL;
}

bool CTableFrameSink::Initialization(IUnknownEx* unknownex) 
{
	m_pITableFrame = QUERY_OBJECT_PTR_INTERFACE(unknownex, ITableFrame);
	if (!m_pITableFrame)
		return false;

	m_pITableFrame->SetStartMode(START_MODE_TIME_CONTROL);
	m_pGameServiceAttrib = m_pITableFrame->GetGameServiceAttrib();
	m_pGameServiceOption = m_pITableFrame->GetGameServiceOption();

	if (!m_pGameConfig.LoadGameConfig(m_pGameServiceOption->wServerID))
		return false;

	srand((unsigned)time(NULL));
	return true;
}

void CTableFrameSink::RepositionSink() 
{
	m_dwLasttime = 0;
	m_dwStarttime = 0;
	m_dwLastSceneTime = 0;
	m_dwAndroidSceneTime = 0;
	m_dwLastWriteScoretime = 0;
	m_dwLastDeductStoragetime = 0;
	ZeroMemory(m_fDistributeElapsed, sizeof(m_fDistributeElapsed));
	ZeroMemory(m_nCurrentBulletMulriple, sizeof(m_nCurrentBulletMulriple));
	ZeroMemory(m_fAndroidFireElapsed, sizeof(m_fAndroidFireElapsed));
	ZeroMemory(m_fFireOperateTime, sizeof(m_fFireOperateTime));
	ZeroMemory(m_nFireOperateType, sizeof(m_nFireOperateType));
	ZeroMemory(m_nLastLockFishId, sizeof(m_nLastLockFishId));

	FillMemory(m_nAndroidTargetMulriple, sizeof(m_nAndroidTargetMulriple), 1);

	m_fSceneElapsed = 0.0f;
	m_nSceneStatus = SCENE_NONE;
	m_pFishManager.DeleteAll();
	m_pBulletManager.DeleteAll();
	for (WORD i = 0; i < GAME_PLAYER; ++i) 
	{
		m_pAndroidTargetFish[i].clear();
	}
	std::copy(m_pDistributeFishActive.begin(), m_pDistributeFishActive.end(), std::back_inserter(m_pDistributeFishStorage));
	m_pDistributeFishActive.clear();
}

bool CTableFrameSink::OnEventGameStart() 
{
	return true;
}

bool CTableFrameSink::OnEventGameConclude(WORD chair_id, IServerUserItem* pIServerUserItem, BYTE reason) 
{
	if (reason == GER_DISMISS) 
	{
		for (WORD i = 0; i < GAME_PLAYER; ++i) 
		{
			IServerUserItem* user_item = m_pITableFrame->GetTableUserItem(i);
			if (user_item == NULL)
				continue;
			CalcScore(user_item, reason);
		}

		m_pITableFrame->KillGameTimer(m_dwGameLoopTimer);
		m_pITableFrame->KillGameTimer(m_dwGameSceneTimer);
		m_pITableFrame->KillGameTimer(m_dwGameAndroidTimer);
		
		m_pITableFrame->ConcludeGame(GAME_STATUS_FREE);
	}
	else if (chair_id < GAME_PLAYER && pIServerUserItem != NULL) 
	{
		CalcScore(pIServerUserItem, reason);
	}
	return true;
}

bool CTableFrameSink::OnEventSendGameScene(WORD chair_id, IServerUserItem* pIServerUserItem, BYTE game_status, bool send_secret) {
	switch (game_status) 
	{
		case GAME_STATUS_FREE:
		case GAME_STATUS_PLAY:
		{
			m_nAndroidTargetMulriple[chair_id] = 1;

			CMD_S_GameScene pGameScene;
			ZeroMemory(&pGameScene, sizeof(pGameScene));

			pGameScene.nSceneID = m_nSceneStatus;
			pGameScene.lBaseScore = m_pGameServiceOption->lCellScore;
			pGameScene.nStyleID = m_pGameServiceOption->wServerLevel > 3 ? 3 : m_pGameServiceOption->wServerLevel;

			WORD wPlayerCount = 0;
			for (WORD i = 0; i < GAME_PLAYER; i++)
			{
				IServerUserItem *pServerUser = m_pITableFrame->GetTableUserItem(i);
				if (pServerUser)
				{
					wPlayerCount++;
				}
			}

			pGameScene.wPlayerCount = wPlayerCount;
			pGameScene.wFishCount = m_pFishManager.count();
			pGameScene.wBulletCount = m_pBulletManager.count();
			pGameScene.dwServerTicket = GetTickCount();

			m_pITableFrame->SendGameScene(pIServerUserItem, &pGameScene, sizeof(pGameScene));

			//同步玩家
			WORD wBufferSize = 0;
			BYTE cbBuffer[SOCKET_TCP_BUFFER];
		
			for (WORD i = 0; i < GAME_PLAYER; i++)
			{
				IServerUserItem *pServerUser = m_pITableFrame->GetTableUserItem(i);
				if (pServerUser)
				{
					if ((wBufferSize + sizeof(CMD_S_PlayerInfo))>sizeof(cbBuffer))
					{
						m_pITableFrame->SendUserItemData(pIServerUserItem, SUB_S_PLAYER_SYNC, cbBuffer, wBufferSize);
						wBufferSize = 0;
					}
					
					CMD_S_PlayerInfo pPlayerInfo;
					ZeroMemory(&pPlayerInfo, sizeof(pPlayerInfo));
					pPlayerInfo.nPlayerID = pServerUser->GetGameID();
					pPlayerInfo.wChairID = i;
					pPlayerInfo.lPlayerScore = m_lFishScore[i];
					pPlayerInfo.dwPlayerMultiple = m_nCurrentBulletMulriple[i];
					pPlayerInfo.dwLockFishIndex = m_nLastLockFishId[i];

					CopyMemory(cbBuffer + wBufferSize, &pPlayerInfo, sizeof(CMD_S_PlayerInfo));
					wBufferSize += sizeof(CMD_S_PlayerInfo);
				}
			}

			if (wBufferSize>0)
				m_pITableFrame->SendUserItemData(pIServerUserItem, SUB_S_PLAYER_SYNC, cbBuffer, wBufferSize);
			else
				m_pITableFrame->SendUserItemData(pIServerUserItem, SUB_S_PLAYER_SYNC);

			//向玩家发送帮机器人发送捕中鱼的座位分配，   必须在还原子弹之前
			JudgeReplaceCatchInfo();

			SendSceneFish(pIServerUserItem);
			SendSceneBullets(pIServerUserItem);

			return true;
		}
	}
	return false;
}

//获取百人游戏是否下注状态而且玩家下注了  捕鱼用这个来判断桌子上机器人数是否最大人数，是就不让其它机器人上桌
bool CTableFrameSink::OnGetUserBetInfo(WORD wChairID, IServerUserItem * pIServerUserItem)
{
	if (wChairID == INVALID_CHAIR)
	{
		BYTE cbAndroidCount = 0;
		for (WORD i = 0; i < GAME_PLAYER; i++)
		{
			IServerUserItem* pServerUser = m_pITableFrame->GetTableUserItem(i);
			if (pServerUser && pServerUser->IsAndroidUser())
				cbAndroidCount++;
		}
		if (cbAndroidCount >= m_pGameConfig.nMaxAndroidCount)
			return true;
		else
			return false;
	}

	return false;
}

bool CTableFrameSink::OnTimerMessage(DWORD timer_id, WPARAM bind_param)
{
	switch (timer_id) 
	{
		case m_dwGameLoopTimer: 
		{
			DWORD dwNowWriteScore = GetTickCount();
			DWORD dwElaspedWriteScore = dwNowWriteScore - m_dwLastWriteScoretime;
			DWORD dwElaspedDeductStorage = dwNowWriteScore - m_dwLastDeductStoragetime;
			//10秒写一次分
			if (dwElaspedWriteScore > (10 * 1000))
			{
				m_dwLastWriteScoretime = dwNowWriteScore;

				for (WORD i = 0; i < GAME_PLAYER; ++i) 
				{
					IServerUserItem* user_item = m_pITableFrame->GetTableUserItem(i);
					if (user_item == NULL)
						continue;

					if (user_item->IsAndroidUser())
					{
						continue;
					}

					OnEventGameConclude(i, user_item, GER_NORMAL);
				}
			}
			//600秒衰减一次
			if (dwElaspedWriteScore > (600 * 1000))
			{
				m_dwLastDeductStoragetime = dwNowWriteScore;

				//库存衰减
				m_pITableFrame->CalculateStorageDeduct();
			}
		
			DWORD now = GetTickCount();
			DWORD elasped = now - m_dwLasttime;
			m_dwLasttime = now;
			OnGameLoop((float)elasped / 1000.0f);
			return true;
		}
		case m_dwGameSceneTimer:
		{
			DWORD now = GetTickCount();
			DWORD elasped = now - m_dwLastSceneTime;
			m_dwLastSceneTime = now;
			OnSceneLoop(elasped);
			return true;
		}
		case m_dwGameAndroidTimer:
		{
			DWORD now = GetTickCount();
			DWORD elasped = now - m_dwAndroidSceneTime;
			m_dwAndroidSceneTime = now;
			AndroidUpdate((float)elasped / 1000.0f);
			return true;
		}
		default:
			ASSERT(FALSE);
	}
	return false;
}

bool CTableFrameSink::OnGameMessage(WORD sub_cmdid, void* data, WORD data_size, IServerUserItem* pIServerUserItem)
{	
	switch (sub_cmdid) 
	{
		case SUB_C_USER_FIRE: 
		{
			ASSERT(data_size == sizeof(CMD_C_UserFire));
			if (data_size != sizeof(CMD_C_UserFire))
				return true;
			CMD_C_UserFire* user_fire = (CMD_C_UserFire*)(data);
			if (pIServerUserItem->GetUserStatus() == US_LOOKON)
				return true;

			return OnSubUserFire(pIServerUserItem, user_fire->dBulletAngle, user_fire->dwBulletIndex);
		}
		case SUB_C_EXCHANGE_BULLET:
		{
			ASSERT(data_size == sizeof(CMD_C_PlayerExchangeBullet));
			if (data_size != sizeof(CMD_C_PlayerExchangeBullet))
				return true;

			CMD_C_PlayerExchangeBullet* pPlayerExchangeBullet = (CMD_C_PlayerExchangeBullet*)(data);
			
			if (pPlayerExchangeBullet->nPlayerBulletMultiple < m_pGameConfig.min_bullet_multiple_ || pPlayerExchangeBullet->nPlayerBulletMultiple > m_pGameConfig.max_bullet_multiple_)
				return true;

			m_nCurrentBulletMulriple[pIServerUserItem->GetChairID()] = pPlayerExchangeBullet->nPlayerBulletMultiple;
			CMD_S_PlayerExchangeBullet UserExchangeBullet;
			ZeroMemory(&UserExchangeBullet, sizeof(UserExchangeBullet));
			UserExchangeBullet.nPlayerID = pIServerUserItem->GetGameID();
			UserExchangeBullet.nPlayerMultiple = pPlayerExchangeBullet->nPlayerBulletMultiple;
			
			m_pITableFrame->SendTableData(INVALID_CHAIR, SUB_S_EXCHANGE_BULLET, &UserExchangeBullet, sizeof(UserExchangeBullet));
			return true;
		}
		case SUB_C_CATCH_FISH:
		{
			ASSERT(data_size == sizeof(CMD_C_PlayerCatchFish));
			if (data_size != sizeof(CMD_C_PlayerCatchFish))
				return true;
			CMD_C_PlayerCatchFish* PlayerCatchFish = (CMD_C_PlayerCatchFish*)(data);
			if (pIServerUserItem->GetUserStatus() == US_LOOKON)
				return true;

			IServerUserItem* pCatchUser = m_pITableFrame->GetTableUserItem(PlayerCatchFish->wChairID);

			if (pCatchUser == NULL)
				return true;

			return OnSubUserCatchFish(pCatchUser, PlayerCatchFish->dwBulletIndex, PlayerCatchFish->dwFishIndex);
		}
		case SUB_C_TIMER_SYNC: 
		{
			return OnSubTimerSync(pIServerUserItem);
		}
		case SUB_C_LOCK_FISH:
		{
			ASSERT(data_size == sizeof(CMD_C_LockFish));
			if (data_size != sizeof(CMD_C_LockFish))
				return true;
			CMD_C_LockFish* pLockFish = (CMD_C_LockFish*)(data);

			m_nLastLockFishId[pIServerUserItem->GetChairID()] = pLockFish->dwLockFishIndex;

			CMD_S_LockFish LockFish;
			LockFish.nPlayerID = pIServerUserItem->GetGameID();
			LockFish.dwLockFishIndex = pLockFish->dwLockFishIndex;

			m_pITableFrame->SendTableData(INVALID_CHAIR, SUB_S_LOCK_FISH, &LockFish, sizeof(LockFish));
			return true;
		}
	}
	return false;
}

bool CTableFrameSink::OnFrameMessage(WORD sub_cmdid, void* data, WORD data_size, IServerUserItem* pIServerUserItem) 
{
	return false;
}

bool CTableFrameSink::OnActionUserSitDown(WORD chair_id, IServerUserItem* pIServerUserItem, bool lookon_user) 
{
	if (!lookon_user) 
	{
		m_dwEnterGameTime[chair_id] = (DWORD)time(NULL);//cy add
		m_lExchangeFishScore[chair_id] = pIServerUserItem->GetUserScore();
		m_lFishScore[chair_id] = pIServerUserItem->GetUserScore();
		m_dwLastFireTime[chair_id] = GetTickCount();

		m_nCurrentBulletMulriple[chair_id] = m_pGameConfig.min_bullet_multiple_;
		m_fAndroidFireElapsed[chair_id] = 0;

		if (m_pITableFrame->GetGameStatus() == GAME_STATUS_FREE) 
		{
			m_fSceneElapsed = 0.0f;
			m_nSceneStatus = SCENE_NONE;
			m_pITableFrame->StartGame();
			m_pITableFrame->SetGameStatus(GAME_STATUS_PLAY);

			m_dwStarttime = (DWORD)time(0);
			m_pITableFrame->SetGameTimer(m_dwGameLoopTimer, m_kGameLoopElasped, m_dwRepeatTimer, 0);
			m_pITableFrame->SetGameTimer(m_dwGameSceneTimer, m_kSceneElasped, m_dwRepeatTimer, 0);
			m_pITableFrame->SetGameTimer(m_dwGameAndroidTimer, m_kAndroidElasped, m_dwRepeatTimer, 0);
			m_dwLastSceneTime = GetTickCount();
			m_dwLasttime = GetTickCount();
			m_dwAndroidSceneTime = GetTickCount();
		}
	}

	m_fAndroidGameElapsed[chair_id] = 0;
	if (pIServerUserItem->IsAndroidUser())
	{
		m_fAndroidGameTime[chair_id] = (rand() % 130) + (rand() % 130) + 60;
	}

	return true;
}

bool CTableFrameSink::OnActionUserStandUp(WORD chair_id, IServerUserItem* pIServerUserItem, bool lookon_user) 
{
	if (lookon_user)
		return true;

	m_lExchangeFishScore[chair_id] = 0;
	m_lFishScore[chair_id] = 0;
	m_pAndroidTargetFish[chair_id].clear();
	m_fAndroidFireElapsed[chair_id] = 0;

	WORD user_count = 0;
	WORD player_count = 0;
	for (WORD i = 0; i < GAME_PLAYER; ++i) 
	{
		IServerUserItem* user_item = m_pITableFrame->GetTableUserItem(i);
		if (user_item) 
		{
			++user_count;
		}
	}

	if (!pIServerUserItem->IsAndroidUser())
	{
		if (m_wReplaceCatch[chair_id][0] != INVALID_CHAIR)
		{
			FillMemory(m_wReplaceCatch[chair_id], sizeof(m_wReplaceCatch[chair_id]), INVALID_CHAIR);
			JudgeReplaceCatchInfo();
		}
	}

	if (user_count == 0) 
	{
		//m_pITableFrame->KillGameTimer(m_dwGameLoopTimer);
		//m_pITableFrame->KillGameTimer(m_dwGameSceneTimer);
		//m_pITableFrame->KillGameTimer(m_dwGameAndroidTimer);
		//m_pITableFrame->ConcludeGame(GAME_STATUS_FREE);
	}

	return true;
}

bool CTableFrameSink::OnSubUserFire(IServerUserItem * pIServerUserItem, float fBulletAngle, DWORD dwBulletIndex)
{
	WORD chair_id = pIServerUserItem->GetChairID();

	int nBulletMultiple = m_nCurrentBulletMulriple[chair_id];
	SCORE lBulletScore = nBulletMultiple * m_pGameServiceOption->lCellScore;

	bool bCheckError = false;

	if (m_lFishScore[chair_id] < lBulletScore)
	{
		if (GetCheckFireError(lBulletScore, m_lFishScore[chair_id]))
		{
			m_lFishScore[chair_id] = lBulletScore;
		}
		else
		{
			if (pIServerUserItem->IsAndroidUser())
			{
				m_pITableFrame->PerformStandUpAction(pIServerUserItem);
				return true;
			}
			else
			{
				return true;
			}
		}
	}

	//没有真人玩家  机器人不开炮
	if (pIServerUserItem->IsAndroidUser())
	{
		BYTE cbRealUserCount = 0;
		for (WORD i = 0; i < GAME_PLAYER; i++)
		{
			IServerUserItem* pServerUser = m_pITableFrame->GetTableUserItem(i);
			if (pServerUser && !pServerUser->IsAndroidUser())
			{
				cbRealUserCount++;
			}
		}

		if (cbRealUserCount == 0)
			return true;

		//让机器人只能发30颗子弹
		BYTE cbBulletCount = 0;
		Bullet* bullet = NULL;

		for (DWORD i = 0; i < m_kMaxBulletsInManager; ++i)
		{
			bullet = m_pBulletManager.GetEntityByIndex(i);
			if (bullet == NULL || bullet->index() == kInvalidID)
			{
				continue;
			}
			if (bullet->chair_id() == pIServerUserItem->GetChairID())
			{
				cbBulletCount++;
			}
		}
		if (cbBulletCount >= 30)
			return true;
	}

	Bullet* bullet = m_pBulletManager.NewEntity(dwBulletIndex);

	m_dwLastFireTime[chair_id] = GetTickCount();
	m_lFishScore[chair_id] -= lBulletScore;

	if (pIServerUserItem && !pIServerUserItem->IsAndroidUser())
		m_pGameServiceOption->pRoomStorageOption.lStorageCurrent += lBulletScore;

	bullet->set_chair_id(chair_id);
	bullet->set_bullet_mulriple(nBulletMultiple);
	bullet->set_angle(fBulletAngle);
	bullet->set_lock_fish_id(m_nLastLockFishId[chair_id]);
	bullet->SetCreateTicket(GetTickCount());

	CMD_S_UserFire user_fire;
	ZeroMemory(&user_fire, sizeof(user_fire));
	user_fire.nPlayerID = pIServerUserItem->GetGameID();
	user_fire.wBulletIndex = dwBulletIndex;
	user_fire.nBulletMultiple = nBulletMultiple;
	user_fire.dBulletAngle = fBulletAngle;
	user_fire.lPlayerScore = m_lFishScore[chair_id];
	user_fire.dwCreateTicket = m_dwLastFireTime[chair_id];
	
	m_pITableFrame->SendTableData(INVALID_CHAIR, SUB_S_USER_FIRE, &user_fire, sizeof(user_fire));
	return true;
}

bool CTableFrameSink::OnSubUserCatchFish(IServerUserItem* pIServerUserItem, DWORD dwBulletIndex, DWORD dwFishIndex)
{
	Fish* pCatchFish = m_pFishManager.GetEntityByIndex(dwFishIndex);
	WORD wChairID = pIServerUserItem->GetChairID();
	Bullet* pCatchBullet = m_pBulletManager.GetEntityByIndex(dwBulletIndex);

	if (pCatchFish == NULL || pCatchBullet == NULL || pCatchFish->index() == kInvalidID || pCatchBullet->index() == kInvalidID)
	{
		if (pCatchBullet != NULL && pCatchBullet->index() != kInvalidID)
		{
			m_pBulletManager.DeleteEntity(pCatchBullet->id());
		}
		return true;
	}

	SCORE fish_score = pCatchFish->fish_mulriple() * pCatchBullet->bullet_mulriple() * m_pGameServiceOption->lCellScore;

	FishKind pFishKind = pCatchFish->fish_kind();
	//随机概率
	double probability = 0;
	probability = (double)((rand() % 1000 + 1)) / 1000;
	double fish_probability = m_pGameConfig.fish_config_[pFishKind].capture_probability;
	
	//库存控制
	{
		//库存控制
		tag_Jcby_Parameter Jcby_Parameter;
		ZeroMemory(&Jcby_Parameter, sizeof(Jcby_Parameter));

		Jcby_Parameter.wshutUser = pIServerUserItem->GetChairID();
		Jcby_Parameter.probability = probability;

		tag_Jcby_Result pJcby_Result;
		ZeroMemory(&pJcby_Result, sizeof(pJcby_Result));
		m_pITableFrame->GetControlResult(&Jcby_Parameter, sizeof(Jcby_Parameter), &pJcby_Result);

		if (pJcby_Result.probability > 0)
		{
			probability = pJcby_Result.probability;
		}
	}

	int nBulletMulriple = pCatchBullet->bullet_mulriple();

	m_pBulletManager.DeleteEntity(pCatchBullet->id());

	if (pIServerUserItem->IsAndroidUser())
		probability *= 2;

	if (probability > fish_probability)
	{
		return true;
	}

	//库存值
	if (pIServerUserItem && !pIServerUserItem->IsAndroidUser())
		m_pGameServiceOption->pRoomStorageOption.lStorageCurrent -= fish_score;

	CMD_S_PlayerCatchFish catch_fish;
	ZeroMemory(&catch_fish, sizeof(catch_fish));
	
	m_lFishScore[wChairID] += (fish_score);
	
	catch_fish.nPlayerID = pIServerUserItem->GetGameID();
	catch_fish.dwBulletIndex = dwBulletIndex;
	catch_fish.dwFishIndex = dwFishIndex;
	catch_fish.lFishScore = fish_score;
	catch_fish.lPlayerScore = m_lFishScore[wChairID];
	
	m_pITableFrame->SendTableData(INVALID_CHAIR, SUB_S_CATCH_CHAIN, &catch_fish, sizeof(catch_fish));

	//大厅跑马灯消息
	if (fish_score > 1000)
	{
		CMD_GR_GameRadioMessage GameRadioMessage;
		ZeroMemory(&GameRadioMessage, sizeof(GameRadioMessage));

		GameRadioMessage.cbCardType = 0;
		GameRadioMessage.wKindID = m_pGameServiceOption->wKindID;
		GameRadioMessage.lScore = fish_score;
		lstrcpyn(GameRadioMessage.szNickName, pIServerUserItem->GetNickName(), CountArray(GameRadioMessage.szNickName));
		m_pITableFrame->SendHallRadioMessage(&GameRadioMessage, sizeof(GameRadioMessage));
	}

	//金龙
	if (pFishKind == FISH_JINLONG)
	{
		Fish* fishTemp = NULL;
		for (int i = 0; i < m_kMaxFishInManager; i++)
		{
			fishTemp = m_pFishManager.GetEntityByIndex(i);

			if (fishTemp == pCatchFish)
				continue;

			if (fishTemp == NULL || fishTemp->index() == kInvalidID)
				continue;

			if (fishTemp->fish_kind() < FISH_JIANYU)
			{
				fish_score = fishTemp->fish_mulriple() * nBulletMulriple * m_pGameServiceOption->lCellScore;

				//库存值
				if (pIServerUserItem && !pIServerUserItem->IsAndroidUser())
					m_pGameServiceOption->pRoomStorageOption.lStorageCurrent -= fish_score;

				CMD_S_PlayerCatchFish catch_fish;
				ZeroMemory(&catch_fish, sizeof(catch_fish));

				m_lFishScore[wChairID] += (fish_score);

				catch_fish.nPlayerID = pIServerUserItem->GetGameID();
				catch_fish.dwBulletIndex = dwBulletIndex;
				catch_fish.dwFishIndex = fishTemp->index();
				catch_fish.lFishScore = fish_score;
				catch_fish.lPlayerScore = m_lFishScore[wChairID];

				m_pITableFrame->SendTableData(INVALID_CHAIR, SUB_S_CATCH_CHAIN, &catch_fish, sizeof(catch_fish));

				m_pFishManager.DeleteEntity(fishTemp->id());
			}
		}
	}

	//一网打尽
	if (pFishKind == FISH_YIWANG1 || pFishKind == FISH_YIWANG2 || pFishKind == FISH_YIWANG3 || pFishKind == FISH_YIWANG4 || pFishKind == FISH_YIWANG5)
	{
		Fish* fishTemp = NULL;
		for (int i = 0; i < m_kMaxFishInManager; i++)
		{
			fishTemp = m_pFishManager.GetEntityByIndex(i);

			if (fishTemp == pCatchFish)
				continue;

			if (fishTemp == NULL || fishTemp->index() == kInvalidID)
				continue;

			bool bYiWang = fishTemp->fish_kind() == FISH_YIWANG1 || fishTemp->fish_kind() == FISH_YIWANG2 || fishTemp->fish_kind() == FISH_YIWANG3 || fishTemp->fish_kind() == FISH_YIWANG4 || fishTemp->fish_kind() == FISH_YIWANG5;
			if (bYiWang)
			{
				fish_score = fishTemp->fish_mulriple() * nBulletMulriple * m_pGameServiceOption->lCellScore;

				//库存值
				if (pIServerUserItem && !pIServerUserItem->IsAndroidUser())
					m_pGameServiceOption->pRoomStorageOption.lStorageCurrent -= fish_score;


				CMD_S_PlayerCatchFish catch_fish;
				ZeroMemory(&catch_fish, sizeof(catch_fish));

				m_lFishScore[wChairID] += (fish_score);

				catch_fish.nPlayerID = pIServerUserItem->GetGameID();
				catch_fish.dwBulletIndex = dwBulletIndex;
				catch_fish.dwFishIndex = fishTemp->index();
				catch_fish.lFishScore = fish_score;
				catch_fish.lPlayerScore = m_lFishScore[wChairID];

				m_pITableFrame->SendTableData(INVALID_CHAIR, SUB_S_CATCH_CHAIN, &catch_fish, sizeof(catch_fish));

				m_pFishManager.DeleteEntity(fishTemp->id());
			}
		}
	}

	m_pFishManager.DeleteEntity(pCatchFish->id());
	
	return true;
}

bool CTableFrameSink::OnSubTimerSync(IServerUserItem* pIServerUserItem)
{
	CMD_S_SynTime timer_sync;
	timer_sync.dwServerTicket = GetTickCount();
	m_pITableFrame->SendTableData(pIServerUserItem->GetChairID(), SUB_S_TIMER_SYNC, &timer_sync, sizeof(timer_sync));
	return true;
}

void CTableFrameSink::OnGameLoop(float delta_time)
{
	DistributeFish(delta_time);
	GameUpdate(delta_time);
	SceneUpdate(delta_time);
}

void CTableFrameSink::OnSceneLoop(float delta_time)
{
	int nSceneStatus = m_nSceneStatus % 3;
	if (nSceneStatus != SCENE_RUNNING)
		return;

	BYTE tcp_buffer[IPC_PACKET] = { 0 };
	WORD send_size = 0;
	DWORD dwTimeSub = GetTickCount() - m_dwSceneLastTime;
	CMD_S_FishInfo* distribute_fish = (CMD_S_FishInfo*)(tcp_buffer);

	switch (m_nSceneKind)
	{
		case 1:
		{
			if (m_nSceneBatch >= m_nScene1FishTimes)
				break;

			if (dwTimeSub < m_nScene1TimeSub[m_nSceneBatch])
				break;

			m_dwSceneLastTime = GetTickCount();

			int nFishIndex = 0;

			for (int i = 0; i < m_nSceneBatch; i++)
				nFishIndex += m_nScene1TimesFishCount[i];

			int nFishCount = 0;

			for (int i = 0; i < m_nScene1TimesFishCount[m_nSceneBatch]; i++)
			{
				int nIndex = nFishIndex + i;
				if (nIndex >= m_nScene1AllFishCount)
					break;

				Fish* fish = m_pFishManager.NewEntity();
				if (fish == NULL)
					break;

				if (send_size + sizeof(CMD_S_FishInfo) > sizeof(tcp_buffer))
				{
					m_pITableFrame->SendTableData(INVALID_CHAIR, SUB_S_FISH, tcp_buffer, send_size);
					m_pITableFrame->SendLookonData(INVALID_CHAIR, SUB_S_FISH, tcp_buffer, send_size);
					send_size = 0;
					distribute_fish = reinterpret_cast<CMD_S_FishInfo*>(tcp_buffer);
				}

				FishKind fish_kind = (FishKind)m_nScene1FishID[nIndex];
	
				WORD wSteps = 1785;
				WORD wPathID = m_nScene1FishPathID[nIndex];

				distribute_fish->dwFishIndex = fish->index();
				distribute_fish->nFishKindID = m_nClientFishKind[fish_kind];
				distribute_fish->dwCreteTicket = GetTickCount();
				distribute_fish->wPathID = wPathID;
				distribute_fish->wPath_Index = m_nScene1PathIndex[nIndex];

				fish->set_fish_mulriple(m_pGameConfig.fish_config_[fish_kind].mulriple);
				fish->set_fish_kind(fish_kind);
				fish->set_path_id(wPathID);
				fish->SetSteps(wSteps);
				fish->SetCreateTicket(distribute_fish->dwCreteTicket);

				send_size += sizeof(CMD_S_FishInfo);
				++distribute_fish;
				nFishCount++;
			}

			if (send_size > 0)
			{
				m_pITableFrame->SendTableData(INVALID_CHAIR, SUB_S_FISH, tcp_buffer, send_size);
				m_pITableFrame->SendLookonData(INVALID_CHAIR, SUB_S_FISH, tcp_buffer, send_size);
			}

			m_nSceneBatch++;
			break;
		}
		case 2:
		{
			if (m_nSceneBatch >= m_nScene2FishTimes)
				break;

			if (dwTimeSub < m_nScene2TimeSub[m_nSceneBatch])
				break;

			m_dwSceneLastTime = GetTickCount();

			int nFishIndex = 0;

			for (int i = 0; i < m_nSceneBatch; i++)
				nFishIndex += m_nScene2TimesFishCount[i];

			for (int i = 0; i < m_nScene2TimesFishCount[m_nSceneBatch]; i++)
			{
				int nIndex = nFishIndex + i;
				if (nIndex >= m_nScene2AllFishCount)
					break;

				Fish* fish = m_pFishManager.NewEntity();
				if (fish == NULL)
					break;

				if (send_size + sizeof(CMD_S_FishInfo) > sizeof(tcp_buffer))
				{
					m_pITableFrame->SendTableData(INVALID_CHAIR, SUB_S_FISH, tcp_buffer, send_size);
					m_pITableFrame->SendLookonData(INVALID_CHAIR, SUB_S_FISH, tcp_buffer, send_size);
					send_size = 0;
					distribute_fish = reinterpret_cast<CMD_S_FishInfo*>(tcp_buffer);
				}

				FishKind fish_kind = (FishKind)m_nScene2FishID[nIndex];

				WORD wSteps = 1785;
				WORD wPathID = m_nScene2FishPathID[nIndex];

				distribute_fish->dwFishIndex = fish->index();
				distribute_fish->nFishKindID = m_nClientFishKind[fish_kind];
				distribute_fish->dwCreteTicket = GetTickCount();
				distribute_fish->wPathID = wPathID;
				distribute_fish->wPath_Index = m_nScene2PathIndex[nIndex];

				fish->set_fish_mulriple(m_pGameConfig.fish_config_[fish_kind].mulriple);
				fish->set_fish_kind(fish_kind);
				fish->set_path_id(wPathID);
				fish->SetSteps(wSteps);
				fish->SetCreateTicket(distribute_fish->dwCreteTicket);

				send_size += sizeof(CMD_S_FishInfo);
				++distribute_fish;
			}

			if (send_size > 0)
			{
				m_pITableFrame->SendTableData(INVALID_CHAIR, SUB_S_FISH, tcp_buffer, send_size);
				m_pITableFrame->SendLookonData(INVALID_CHAIR, SUB_S_FISH, tcp_buffer, send_size);
			}

			m_nSceneBatch++;

			break;
		}
	}
}

void CTableFrameSink::DistributeFish(float delta_time)
{
	int nSceneStatus = m_nSceneStatus % 3;
	if (nSceneStatus != SCENE_NONE)
		return;

	int nFishCount[FISH_KIND_COUNT] = { 0 };

	Fish* fishTemp = NULL;
	for (int i = 0; i < m_kMaxFishInManager; i++)
	{
		fishTemp = m_pFishManager.GetEntityByIndex(i);
		if (fishTemp && fishTemp->index() != kInvalidID)
			nFishCount[fishTemp->fish_kind()] ++;
	}

	int nZuheCount = nFishCount[FISH_50ZUHE] + nFishCount[FISH_60ZUHE] + nFishCount[FISH_70ZUHE] + nFishCount[FISH_80ZUHE];
	int nYiWangCount = nFishCount[FISH_YIWANG1] + nFishCount[FISH_YIWANG2] + nFishCount[FISH_YIWANG3] + nFishCount[FISH_YIWANG4] + nFishCount[FISH_YIWANG5];
	int nBigFishCount = nFishCount[FISH_ZHANGYU] + nFishCount[FISH_MEIRENYU];

	for (int i = 0; i < FISH_KIND_COUNT; ++i) 
	{
		if (nFishCount[i] >= m_pGameConfig.fish_config_[i].nMaxAliveCount)
			continue;

		if (i == FISH_ZHANGYU || i == FISH_MEIRENYU)
		{
			if (nBigFishCount > 0)
				continue;

			m_fDistributeElapsed[i] += delta_time;
			if (m_fDistributeElapsed[i] >= m_pGameConfig.fish_config_[i].distribute_interval && i == FISH_MEIRENYU)
			{
				m_fDistributeElapsed[i] = 0;

				int nBuildFish = rand() % 2 + FISH_MEIRENYU;

				BuildFish(static_cast<FishKind>(nBuildFish));

				nFishCount[nBuildFish] += m_pGameConfig.fish_config_[nBuildFish].distribute_count;
				nBigFishCount++;
				
			}
		}
		else if (i == FISH_50ZUHE || i == FISH_60ZUHE || i == FISH_70ZUHE || i == FISH_80ZUHE)
		{
			if (nZuheCount > 0)
				continue;

			m_fDistributeElapsed[i] += delta_time;
			if (m_fDistributeElapsed[i] >= m_pGameConfig.fish_config_[i].distribute_interval)
			{
				m_fDistributeElapsed[i] = 0;
				BuildFish(static_cast<FishKind>(i));
				nZuheCount++;
				nFishCount[i] += m_pGameConfig.fish_config_[i].distribute_count;
			}
		}
		else if (i == FISH_YIWANG1 || i == FISH_YIWANG2 || i == FISH_YIWANG3 || i == FISH_YIWANG4 || i == FISH_YIWANG5)
		{
			if (nYiWangCount > 0)
				continue;

			m_fDistributeElapsed[i] += delta_time;
			if (m_fDistributeElapsed[i] >= m_pGameConfig.fish_config_[i].distribute_interval && i == FISH_YIWANG1)
			{
				m_fDistributeElapsed[i] = 0;

				for (int j = FISH_YIWANG1; j <= FISH_YIWANG5; j++)
				{
					BuildFish(static_cast<FishKind>(j));

					nFishCount[j] += m_pGameConfig.fish_config_[j].distribute_count;
					nYiWangCount++;
				}
			}
		}
		else
		{
			m_fDistributeElapsed[i] += delta_time;
			if (m_fDistributeElapsed[i] >= m_pGameConfig.fish_config_[i].distribute_interval)
			{
				m_fDistributeElapsed[i] = 0;
				BuildFish(static_cast<FishKind>(i));

				nFishCount[i] += m_pGameConfig.fish_config_[i].distribute_count;
			}
		}
	}

	BYTE tcp_buffer[IPC_PACKET] = { 0 };
	WORD send_size = 0;
	CMD_S_FishInfo* distribute_fish = (CMD_S_FishInfo*)(tcp_buffer);
	for (CMDDistributeFishVector::iterator it = m_pDistributeFishActive.begin(); it != m_pDistributeFishActive.end(); ++it) 
	{
		if (send_size + sizeof(CMD_S_FishInfo) > sizeof(tcp_buffer)) 
		{
			m_pITableFrame->SendTableData(INVALID_CHAIR, SUB_S_FISH, tcp_buffer, send_size);
			m_pITableFrame->SendLookonData(INVALID_CHAIR, SUB_S_FISH, tcp_buffer, send_size);
			send_size = 0;
			distribute_fish = reinterpret_cast<CMD_S_FishInfo*>(tcp_buffer);
		}

		memcpy(distribute_fish, *it, sizeof(CMD_S_FishInfo));

		distribute_fish->nFishKindID = m_nClientFishKind[distribute_fish->nFishKindID];

		send_size += sizeof(CMD_S_FishInfo);
		++distribute_fish;
	}

	if (send_size > 0) {
		m_pITableFrame->SendTableData(INVALID_CHAIR, SUB_S_FISH, tcp_buffer, send_size);
		m_pITableFrame->SendLookonData(INVALID_CHAIR, SUB_S_FISH, tcp_buffer, send_size);
	}

	std::copy(m_pDistributeFishActive.begin(), m_pDistributeFishActive.end(), std::back_inserter(m_pDistributeFishStorage));
	m_pDistributeFishActive.clear();
}

void CTableFrameSink::BuildFish(FishKind fish_kind) 
{
	if (m_pFishManager.count() > 100 && fish_kind < FISH_LANCHUISHA)
		return;

	GameConfig::FishConfig& fish_config = m_pGameConfig.fish_config_[fish_kind];
	CMD_S_FishInfo* distribute_fish = NULL;
	for (int j = 0; j < fish_config.distribute_count; ++j) 
	{
		Fish* fish = m_pFishManager.NewEntity();
		ASSERT(fish);
		if (fish == NULL)
			break;
		if (!m_pDistributeFishStorage.empty()) 
		{
			distribute_fish = m_pDistributeFishStorage.back();
			m_pDistributeFishStorage.pop_back();
		}
		else 
		{
			distribute_fish = new CMD_S_FishInfo();
		}

		WORD wSteps = 0;
		WORD wPathID = GetRandPathID(fish_kind,wSteps);

		distribute_fish->dwFishIndex = fish->index();
		distribute_fish->nFishKindID = fish_kind;
		distribute_fish->dwCreteTicket = GetTickCount();
		distribute_fish->wPathID = wPathID;
		distribute_fish->wPath_Index = 0;

		fish->set_fish_mulriple(fish_config.mulriple);
		fish->set_fish_kind(fish_kind);
		fish->set_path_id(wPathID);
		fish->SetSteps(wSteps);
		fish->SetCreateTicket(distribute_fish->dwCreteTicket);

		m_pDistributeFishActive.push_back(distribute_fish);
	}
}

void CTableFrameSink::FishDestroy(Entity* entity)
{
	m_pFishManager.DeleteEntity(entity->id());
}

void CTableFrameSink::BulletDestroy(Entity* entity)
{

}

void CTableFrameSink::GameUpdate(float delta_time)
{
	Bullet* bullet = NULL;
	Fish* fish = NULL;
	bool bullet_hit = false;
	SCORE except_score = 0;
	EntityIDs remove_bullets_;

	for (DWORD i = 0; i < m_kMaxBulletsInManager; ++i)
	{
		bullet_hit = false;
		except_score = 0;
		bullet = m_pBulletManager.GetEntityByIndex(i);
		if (bullet == NULL || bullet->index() == kInvalidID)
		{
			continue;
		}

		if (!bullet->bullet_mulriple())
		{
			remove_bullets_.push_back(bullet->id());
			continue;
		}

		DWORD wSubTime = GetTickCount() - bullet->GetCreateTicket();
		wSubTime = wSubTime / 1000;
		if (wSubTime > 10)
		{
			remove_bullets_.push_back(bullet->id());
			continue;
		}

		IServerUserItem* user_item = m_pITableFrame->GetTableUserItem(bullet->chair_id());
		if (user_item == NULL) 
		{
			remove_bullets_.push_back(bullet->id());
			continue;
		}
	}

	for (int k = 0; k < (int)remove_bullets_.size(); ++k) 
	{
		m_pBulletManager.DeleteEntity(remove_bullets_[k]);
	}

	Fish *Fish = NULL;
	for (DWORD i = 0; i < m_kMaxFishInManager; ++i)
	{
		Fish = m_pFishManager.GetEntityByIndex(i);
		if (Fish != NULL && Fish->index() != kInvalidID)
		{
			DOUBLE dwNowSub = (GetTickCount() - Fish->GetCreateTicket()) / 1000;
			DOUBLE dwMaxAliveTime = Fish->GetSteps() / 30;
			if (Fish->fish_kind() == FISH_ZHANGYU || Fish->fish_kind() == FISH_MEIRENYU)
				dwMaxAliveTime = dwMaxAliveTime + 20;
			if (dwNowSub >= dwMaxAliveTime)
			{
				m_pFishManager.DeleteEntity(Fish->id());
			}
		}
	}

	//60秒没开炮就要踢出去
	for (WORD i = 0; i < GAME_PLAYER; i++)
	{
		IServerUserItem* pServerUser = m_pITableFrame->GetTableUserItem(i);
		if (pServerUser)
		{
			DWORD wSubTime = GetTickCount() - m_dwLastFireTime[i];
			wSubTime = wSubTime / 1000;
			if (wSubTime >= 60)
			{
				m_pITableFrame->PerformStandUpAction(pServerUser);
			}
		}
	}

	remove_bullets_.clear();
}

void CTableFrameSink::SceneUpdate(float delta_time)
{
	int nSceneStatus = m_nSceneStatus % 3;
	if (nSceneStatus == SCENE_NONE)
	{
		m_fSceneElapsed += delta_time;
		if (m_fSceneElapsed >= m_pGameConfig.nSceneUpdateTimes) 
		{
			m_nSceneStatus++;
			if (m_nSceneStatus == 1000000)
				m_nSceneStatus = SCENE_WAIT_TIDE;

			m_fSceneElapsed = 0.0f;
			CMD_S_CHANGE_SCENE switch_scene;
			switch_scene.nSceneID = m_nSceneStatus;
			m_pITableFrame->SendTableData(INVALID_CHAIR, SUB_S_SWITCH_SCENE, &switch_scene, sizeof(switch_scene));
			m_pITableFrame->SendLookonData(INVALID_CHAIR, SUB_S_SWITCH_SCENE, &switch_scene, sizeof(switch_scene));
		}
	}
	else if (nSceneStatus == SCENE_WAIT_TIDE)
	{
		m_fSceneElapsed += delta_time;
		if (m_fSceneElapsed >= m_kTideActionDuration)
		{
			m_fSceneElapsed = 0.0f;
			m_nSceneStatus++;
			if (m_nSceneStatus == 1000001)
				m_nSceneStatus = SCENE_RUNNING;

			m_dwSceneLastTime = GetTickCount();
			m_nSceneBatch = 0;

			//除了大章鱼和美人鱼，其它的鱼清除
			Fish* fishTemp = NULL;
			for (int i = 0; i < m_kMaxFishInManager; i++)
			{
				fishTemp = m_pFishManager.GetEntityByIndex(i);

				if (fishTemp == NULL || fishTemp->index() == kInvalidID)
					continue;

				if (fishTemp->fish_kind() != FISH_ZHANGYU && fishTemp->fish_kind() != FISH_MEIRENYU)
					m_pFishManager.DeleteEntity(fishTemp->id());
			}

			for (WORD i = 0; i < GAME_PLAYER; ++i) 
			{
				m_pAndroidTargetFish[i].clear();
			}
			std::copy(m_pDistributeFishActive.begin(), m_pDistributeFishActive.end(), std::back_inserter(m_pDistributeFishStorage));
			m_pDistributeFishActive.clear();

			CMD_S_CHANGE_SCENE switch_scene;
			switch_scene.nSceneID = m_nSceneStatus;
			m_pITableFrame->SendTableData(INVALID_CHAIR, SUB_S_SWITCH_SCENE, &switch_scene, sizeof(switch_scene));
			m_pITableFrame->SendLookonData(INVALID_CHAIR, SUB_S_SWITCH_SCENE, &switch_scene, sizeof(switch_scene));
		}
	}
	else if (nSceneStatus == SCENE_RUNNING)
	{
		m_fSceneElapsed += delta_time;
		if (m_fSceneElapsed >= 65.0f) 
		{
			m_fSceneElapsed = 0.0f;
			m_nSceneStatus++;
			if (m_nSceneStatus == 999999)
				m_nSceneStatus = SCENE_NONE;

			m_nSceneKind = rand() % 2 + 1;

			CMD_S_CHANGE_SCENE switch_scene;
			switch_scene.nSceneID = m_nSceneStatus;
			m_pITableFrame->SendTableData(INVALID_CHAIR, SUB_S_SWITCH_SCENE, &switch_scene, sizeof(switch_scene));
			m_pITableFrame->SendLookonData(INVALID_CHAIR, SUB_S_SWITCH_SCENE, &switch_scene, sizeof(switch_scene));
		}
	}
}

void CTableFrameSink::AndroidUpdate(float delta_time) 
{
	IServerUserItem* user_item = NULL;
	for (WORD i = 0; i < GAME_PLAYER; ++i) 
	{
		user_item = m_pITableFrame->GetTableUserItem(i);
		if (user_item == NULL)
			continue;
		if (!user_item->IsAndroidUser())
			continue;

		// 兑换分数
		if (m_lFishScore[i] < m_nCurrentBulletMulriple[i])
		{
			BYTE cbBulletCount = 0;

			for (int m = 0; m < 100; m++)
			{
				DWORD dwIndex = i * 100 + m;
				Bullet* pBullet = m_pBulletManager.GetEntityByIndex(dwIndex);
				if (pBullet != NULL && pBullet->index() != kInvalidID)
				{
					cbBulletCount++;
				}
			}

			if (cbBulletCount == 0)
				m_pITableFrame->PerformStandUpAction(user_item);
			continue;
		}

		//机器人游戏时间到了
		m_fAndroidGameElapsed[i] += delta_time;
		if (m_fAndroidGameElapsed[i] >= m_fAndroidGameTime[i])
		{
			BYTE cbBulletCount = 0;

			for (int m = 0; m < 100; m++)
			{
				DWORD dwIndex = i * 100 + m;
				Bullet* pBullet = m_pBulletManager.GetEntityByIndex(dwIndex);
				if (pBullet != NULL && pBullet->index() != kInvalidID)
				{
					cbBulletCount++;
				}
			}

			if (cbBulletCount == 0)
				m_pITableFrame->PerformStandUpAction(user_item);
			continue;
		}

		m_fFireOperateTime[i] += delta_time;

		//每30~80秒随机换一下机器人的炮倍数
		float fSwitchTime = 30.0 + (rand() % 25) + (rand() % 25);

		if (m_fFireOperateTime[i] >= fSwitchTime)
		{
			if (m_fFireOperateTime[i] >= fSwitchTime)
			{
				m_fFireOperateTime[i] -= fSwitchTime;
			}

			int nRandBulletMulTiple = rand() % (m_pGameConfig.max_bullet_multiple_ - m_pGameConfig.min_bullet_multiple_ + 1) + m_pGameConfig.min_bullet_multiple_;
			m_nAndroidTargetMulriple[i] = nRandBulletMulTiple;

			m_fAndroidChangeBulletTime[i] = 0;

			//换子弹的时候帮机器人取消一下锁定 避免出现锁定了但是不开炮的情况
			m_nLastLockFishId[i] = 0;
			CMD_S_LockFish LockFish;
			LockFish.nPlayerID = user_item->GetGameID();
			LockFish.dwLockFishIndex = 0;
			m_pITableFrame->SendTableData(INVALID_CHAIR, SUB_S_LOCK_FISH, &LockFish, sizeof(LockFish));
		}

		if (m_nCurrentBulletMulriple[i] != m_nAndroidTargetMulriple[i])
		{
			if (m_nCurrentBulletMulriple[i] > m_nAndroidTargetMulriple[i])
				m_nCurrentBulletMulriple[i] --;
			else
				m_nCurrentBulletMulriple[i] ++;
			CMD_S_PlayerExchangeBullet UserExchangeBullet;
			ZeroMemory(&UserExchangeBullet, sizeof(UserExchangeBullet));
			UserExchangeBullet.nPlayerID = user_item->GetGameID();
			UserExchangeBullet.nPlayerMultiple = m_nCurrentBulletMulriple[i];

			m_pITableFrame->SendTableData(INVALID_CHAIR, SUB_S_EXCHANGE_BULLET, &UserExchangeBullet, sizeof(UserExchangeBullet));
			continue;
		}

		m_fAndroidChangeBulletTime[i] += delta_time;
		if (m_fAndroidChangeBulletTime[i] < 2.0f)
			continue;

		float fStopTime = 2.0 + (rand() % 3) + (rand() % 3);

		m_fAndroidFireElapsed[i] += delta_time;
		if (m_fAndroidFireElapsed[i] >= fStopTime)
		{
			if (m_fAndroidFireElapsed[i] >= fStopTime)
				m_fAndroidFireElapsed[i] -= fStopTime;

			//机器人开炮角度  0,1位置为6.28~3.14    2,3位置为 0~3.14
			m_fAndroidRandAngle[i] = rand() % (214) + 364;
			if (i == 2 || i == 3)
				m_fAndroidRandAngle[i] = rand() % (214) + 50;
			m_fAndroidRandAngle[i] = m_fAndroidRandAngle[i] / 100;
		}

		// 开炮
		if (m_nSceneStatus != SCENE_WAIT_TIDE)
		{
			Fish* fish = NULL;

			Fish* lockFish = NULL;

			//上次锁定的鱼
			if (m_nLastLockFishId[i] != 0)
			{
				lockFish = m_pFishManager.GetEntityByID(m_nLastLockFishId[i]);

				DWORD LockSubTime = GetTickCount() - lockFish->GetCreateTicket();
				LockSubTime = LockSubTime / 1000;
				if (LockSubTime > 20)
					lockFish = NULL;
			}

			//在找一只锁定
			if (lockFish == NULL || lockFish->index() == kInvalidID)
			{
				int tempId[m_kMaxFishInManager] = { 0 };
				int nLockFishCount = 0;
				int nasdCount = 0;
				for (int j = 0; j < m_kMaxFishInManager; j++)
				{
					fish = m_pFishManager.GetEntityByIndex(j);
					if ((NULL != fish) && (fish->index() != kInvalidID))
					{
						nasdCount++;
						DWORD wSubTime = GetTickCount() - fish->GetCreateTicket();
						wSubTime = wSubTime / 1000;
						if (wSubTime < 15)
						{
							tempId[nLockFishCount] = j;
							nLockFishCount++;
						}
					}
				}

				if (nLockFishCount > 0)
				{
					int randId = (rand() % (nLockFishCount == 0 ? 1 : nLockFishCount));
					m_nLastLockFishId[i] = tempId[randId];

					CMD_S_LockFish LockFish;
					LockFish.nPlayerID = user_item->GetGameID();
					LockFish.dwLockFishIndex = m_nLastLockFishId[i];
					m_pITableFrame->SendTableData(INVALID_CHAIR, SUB_S_LOCK_FISH, &LockFish, sizeof(LockFish));

					lockFish = m_pFishManager.GetEntityByIndex(m_nLastLockFishId[i]);
				}
			}

			if (NULL != lockFish)
			{
				float angle = m_fAndroidRandAngle[i];


				DWORD dwIndex = 0;
				bool bGetBullet = false;
				for (int m = 0; m < 100; m++)
				{
					dwIndex = i * 100 + m;
					Bullet* pBullet = m_pBulletManager.GetEntityByIndex(dwIndex);
					if (pBullet == NULL || pBullet->index() == kInvalidID)
					{
						bGetBullet = true;
						break;
					}
				}

				if (bGetBullet)
					OnSubUserFire(user_item, angle, dwIndex);
			}
			
		}
	}
}

void CTableFrameSink::SendSceneFish(IServerUserItem* pIServerUserItem)
{
	//同步鱼
	WORD wBufferSize = 0;
	BYTE cbBuffer[SOCKET_TCP_BUFFER];

	Fish* fish = NULL;

	for (WORD i = 0; i < m_kMaxFishInManager; i++)
	{
		fish = m_pFishManager.GetEntityByIndex(i);
		if (fish != NULL && fish->index() != kInvalidID)
		{
			if ((wBufferSize + sizeof(CMD_S_FishInfo))>sizeof(cbBuffer))
			{
				m_pITableFrame->SendUserItemData(pIServerUserItem, SUB_S_FISH_SYNC, cbBuffer, wBufferSize);
				wBufferSize = 0;
			}

			CMD_S_FishInfo pFishInfo;
			ZeroMemory(&pFishInfo, sizeof(pFishInfo));
			pFishInfo.dwFishIndex = i;
			pFishInfo.nFishKindID = m_nClientFishKind[fish->fish_kind()];
			pFishInfo.wPathID = fish->path_id();
			pFishInfo.wPath_Index = 1;
			pFishInfo.dwCreteTicket = fish->GetCreateTicket();

			CopyMemory(cbBuffer + wBufferSize, &pFishInfo, sizeof(CMD_S_FishInfo));
			wBufferSize += sizeof(CMD_S_FishInfo);
		}
	}

	if (wBufferSize>0)
		m_pITableFrame->SendUserItemData(pIServerUserItem, SUB_S_FISH_SYNC, cbBuffer, wBufferSize);
	else
		m_pITableFrame->SendUserItemData(pIServerUserItem, SUB_S_FISH_SYNC);
}

void CTableFrameSink::SendSceneBullets(IServerUserItem* pIServerUserItem)
{
	//同步鱼
	WORD wBufferSize = 0;
	BYTE cbBuffer[SOCKET_TCP_BUFFER];

	Bullet* bullet = NULL;

	for (WORD i = 0; i < m_kMaxBulletsInManager; i++)
	{
		bullet = m_pBulletManager.GetEntityByIndex(i);
		
		if (bullet != NULL && bullet->index() != kInvalidID)
		{
			if ((wBufferSize + sizeof(CMD_S_BulletInfo))>sizeof(cbBuffer))
			{
				m_pITableFrame->SendUserItemData(pIServerUserItem, SUB_S_BULLET_SYNC, cbBuffer, wBufferSize);
				wBufferSize = 0;
			}

			CMD_S_BulletInfo pBulletInfo;
			ZeroMemory(&pBulletInfo, sizeof(pBulletInfo));
			
			pBulletInfo.dwBulletIndex = i;

			WORD wUserChair = bullet->chair_id();
			IServerUserItem *pBulletUser = m_pITableFrame->GetTableUserItem(wUserChair);
			if (pBulletUser)
				pBulletInfo.nPlayerID = pBulletUser->GetGameID();

			pBulletInfo.dBulletAngle = bullet->angle();
			pBulletInfo.dwBulletTicket = bullet->GetCreateTicket();

			CopyMemory(cbBuffer + wBufferSize, &pBulletInfo, sizeof(CMD_S_BulletInfo));
			wBufferSize += sizeof(CMD_S_BulletInfo);
		}
	}

	if (wBufferSize>0)
		m_pITableFrame->SendUserItemData(pIServerUserItem, SUB_S_BULLET_SYNC, cbBuffer, wBufferSize);
	else
		m_pITableFrame->SendUserItemData(pIServerUserItem, SUB_S_BULLET_SYNC);
}

void CTableFrameSink::CalcScore(IServerUserItem* pIServerUserItem, BYTE reason)
{
	if (pIServerUserItem == NULL) return;

	WORD chair_id = pIServerUserItem->GetChairID();
	//cy add 掉线补分
	if (!pIServerUserItem->IsAndroidUser() && US_OFFLINE == pIServerUserItem->GetUserStatus())
	{
		for (DWORD i = 0; i < m_kMaxBulletsInManager; ++i)
		{
			Bullet* bullet = m_pBulletManager.GetEntityByIndex(i);
			if (!bullet || bullet->index() == kInvalidID)
				continue;
			if (bullet->chair_id() == chair_id)
			{
				m_lFishScore[chair_id] += bullet->bullet_mulriple();
			}
		}
	}
	//cy add end
	tagScoreInfo score_info;
	memset(&score_info, 0, sizeof(score_info));
	score_info.cbType = SCORE_TYPE_SERVICE;
	//防止负分
	SCORE lScoreTemp = 0l;
	lScoreTemp = m_lFishScore[chair_id] - m_lExchangeFishScore[chair_id];
	if (lScoreTemp<0 && labs(lScoreTemp)>pIServerUserItem->GetUserScore())
		lScoreTemp = -pIServerUserItem->GetUserScore();
	score_info.lScore = lScoreTemp;

	if (score_info.lScore == 0) return;//没有成绩不写分

	DWORD dwPlayTimeCount = 0;
	//每隔10秒结算，需要留下炮筒上分
	SCORE fish_score = m_lFishScore[chair_id];
	SCORE exchange_score = m_lFishScore[chair_id];

	//解散时，才相当于一局
	if (reason == GER_DISMISS)
	{
		score_info.cbType = SCORE_TYPE_WIN;
		dwPlayTimeCount = (DWORD)time(NULL) - m_dwEnterGameTime[chair_id];

		fish_score = 0;
		exchange_score = 0;
	}
	m_pITableFrame->WriteUserScore(chair_id, score_info, INVALID_DWORD, dwPlayTimeCount);

	m_lFishScore[chair_id] = fish_score;
	m_lExchangeFishScore[chair_id] = exchange_score;
}

WORD CTableFrameSink::GetRandPathID(FishKind fish_kind,WORD &wStep)
{
	if (fish_kind >= 0 && fish_kind <= 5)
	{
		int nRandIndex = rand() % m_nPathCount1;
		wStep = m_nStepCount1[nRandIndex];
		return m_nPathID1[nRandIndex];
	}
	else if (fish_kind == 6)
	{
		int nRandIndex = rand() % m_nPathCount3;
		wStep = m_nStepCount3[nRandIndex];
		return m_nPathID3[nRandIndex];
	}
	else if (fish_kind == 7)
	{
		int nRandIndex = rand() % m_nPathCount5;
		wStep = m_nStepCount5[nRandIndex];
		return m_nPathID5[nRandIndex];
	}
	else if (fish_kind == 8)
	{
		int nRandIndex = rand() % m_nPathCount4;
		wStep = m_nStepCount4[nRandIndex];
		return m_nPathID4[nRandIndex];
	}
	else if (fish_kind == 9)
	{
		int nRandIndex = rand() % m_nPathCount6;
		wStep = m_nStepCount6[nRandIndex];
		return m_nPathID6[nRandIndex];
	}
	else if (fish_kind >= 10 && fish_kind <= 12)
	{
		int nRandIndex = rand() % m_nPathCount7;
		wStep = m_nStepCount7[nRandIndex];
		return m_nPathID7[nRandIndex];
	}
	else if (fish_kind == 13)
	{
		int nRandIndex = rand() % m_nPathCount17;
		wStep = m_nStepCount17[nRandIndex];
		return m_nPathID17[nRandIndex];
	}
	else if (fish_kind == 14)
	{
		int nRandIndex = rand() % m_nPathCount18;
		wStep = m_nStepCount18[nRandIndex];
		return m_nPathID18[nRandIndex];
	}
	else if (fish_kind == 15)
	{
		int nRandIndex = rand() % m_nPathCount8;
		wStep = m_nStepCount8[nRandIndex];
		return m_nPathID8[nRandIndex];
	}
	else if (fish_kind == 16)
	{
		int nRandIndex = rand() % m_nPathCount19;
		wStep = m_nStepCount19[nRandIndex];
		return m_nPathID19[nRandIndex];
	}
	else if (fish_kind >= 17 && fish_kind <= 18)
	{
		int nRandIndex = rand() % m_nPathCount9;
		wStep = m_nStepCount9[nRandIndex];
		return m_nPathID9[nRandIndex];
	}
	else if (fish_kind == 19)
	{
		int nRandIndex = rand() % m_nPathCount100;
		wStep = m_nStepCount100[nRandIndex];
		return m_nPathID100[nRandIndex];
	}
	else if (fish_kind == 20)
	{
		int nRandIndex = rand() % m_nPathCount101;
		wStep = m_nStepCount101[nRandIndex];
		return m_nPathID101[nRandIndex];
	}
	else if (fish_kind == 21)
	{
		int nRandIndex = rand() % m_nPathCount12;
		wStep = m_nStepCount12[nRandIndex];
		return m_nPathID12[nRandIndex];
	}
	else if (fish_kind == 22)
	{
		int nRandIndex = rand() % m_nPathCount102;
		wStep = m_nStepCount102[nRandIndex];
		return m_nPathID102[nRandIndex];
	}
	else if (fish_kind == 23)
	{
		int nRandIndex = rand() % m_nPathCount11;
		wStep = m_nStepCount11[nRandIndex];
		return m_nPathID11[nRandIndex];
	}
	else if (fish_kind == 24)
	{
		int nRandIndex = rand() % m_nPathCount103;
		wStep = m_nStepCount103[nRandIndex];
		return m_nPathID103[nRandIndex];
	}
	else if (fish_kind == 25)
	{
		int nRandIndex = rand() % m_nPathCount10;
		wStep = m_nStepCount10[nRandIndex];
		return m_nPathID10[nRandIndex];
	}
	else if (fish_kind == 26)
	{
		int nRandIndex = rand() % m_nPathCount13;
		wStep = m_nStepCount13[nRandIndex];
		return m_nPathID13[nRandIndex];
	}
	else if (fish_kind == 27)
	{
		int nRandIndex = rand() % m_nPathCount14;
		wStep = m_nStepCount14[nRandIndex];
		return m_nPathID14[nRandIndex];
	}
	else if (fish_kind == 28)
	{
		int nRandIndex = rand() % m_nPathCount20;
		wStep = m_nStepCount20[nRandIndex];
		return m_nPathID20[nRandIndex];
	}
	else if (fish_kind == 29)
	{
		int nRandIndex = rand() % m_nPathCount16;
		wStep = m_nStepCount16[nRandIndex];
		return m_nPathID16[nRandIndex];
	}
	else if (fish_kind == 30)
	{
		int nRandIndex = rand() % m_nPathCount15;
		wStep = m_nStepCount15[nRandIndex];
		return m_nPathID15[nRandIndex];
	}
	else if (fish_kind == 31)
	{
		int nRandIndex = rand() % m_nPathCount3;
		wStep = m_nStepCount3[nRandIndex];
		return m_nPathID3[nRandIndex];
	}
	else if (fish_kind == 32)
	{
		int nRandIndex = rand() % m_nPathCount4;
		wStep = m_nStepCount4[nRandIndex];
		return m_nPathID4[nRandIndex];
	}
	else if (fish_kind == 33)
	{
		int nRandIndex = rand() % m_nPathCount6;
		wStep = m_nStepCount6[nRandIndex];
		return m_nPathID6[nRandIndex];
	}
	else if (fish_kind >= 34 && fish_kind <= 35)
	{
		int nRandIndex = rand() % m_nPathCount7;
		wStep = m_nStepCount7[nRandIndex];
		return m_nPathID7[nRandIndex];
	}
}

int CTableFrameSink::GetStyleID()
{
	WORD wLevel = m_pGameServiceOption->wServerLevel;
	if (wLevel == 1)
		return 1;
	else if (wLevel == 2)
		return 4;
	else if (wLevel == 3)
		return 6;
	else if (wLevel == 4)
		return 5;
	else
		return 1;
}

bool CTableFrameSink::GetCheckFireError(SCORE lBulletScore, SCORE lFishScore)
{
	SCORE lSubScore = lBulletScore - lFishScore;
	if (lSubScore > 0 && lSubScore < 0.01)
	{
		return true;
	}

	return false;
}


void CTableFrameSink::JudgeReplaceCatchInfo()
{
	WORD wNeedReplaceChair[GAME_PLAYER];
	FillMemory(wNeedReplaceChair, sizeof(wNeedReplaceChair), INVALID_CHAIR);
	BYTE cbNeeReplaceCount = 0;

	WORD wRealPlayerChair[GAME_PLAYER];
	FillMemory(wRealPlayerChair, sizeof(wRealPlayerChair), INVALID_CHAIR);
	BYTE cbRealPlayerCount = 0;

	for (WORD i = 0; i < GAME_PLAYER; i++)
	{
		IServerUserItem *pServerUser = m_pITableFrame->GetTableUserItem(i);
		if (pServerUser)
		{
			if (pServerUser->IsAndroidUser())
			{
				wNeedReplaceChair[cbNeeReplaceCount++] = i;
			}
			else
			{
				wRealPlayerChair[cbRealPlayerCount++] = i;
			}
		}
	}

	FillMemory(m_wReplaceCatch, sizeof(m_wReplaceCatch), INVALID_CHAIR);

	for (WORD i = 0; i < cbRealPlayerCount; i++)
	{
		CMD_S_Replace_Catch Replace_Catch;
		ZeroMemory(&Replace_Catch, sizeof(Replace_Catch));

		BYTE cbPerCount = 1;
		if (cbRealPlayerCount == 1)
			cbPerCount = cbNeeReplaceCount;

		for (int j = 0; j < cbPerCount; j++)
		{
			if (cbNeeReplaceCount == 0)
				break;
			if (wNeedReplaceChair[j] == INVALID_CHAIR)
				break;

			IServerUserItem* pServerUser = m_pITableFrame->GetTableUserItem(wNeedReplaceChair[j]);
			if (pServerUser == NULL)
				continue;

			Replace_Catch.wMaxReplaceGameID[j] = pServerUser->GetGameID();

			cbNeeReplaceCount--;
			m_wReplaceCatch[wRealPlayerChair[i]][j] = wNeedReplaceChair[j];
		}

		m_pITableFrame->SendTableData(wRealPlayerChair[i], SUB_S_REPLACE_CATCH, &Replace_Catch, sizeof(Replace_Catch));
	}
}
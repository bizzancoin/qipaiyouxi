#include "Stdafx.h"
#include "AndroidUserItemSink.h"
#include "math.h"

//////////////////////////////////////////////////////////////////////////

//时间标识
#define IDI_BANK_OPERATE			3									//银行定时
#define IDI_PLACE_JETTON1			103									//下注定时
#define IDI_PLACE_JETTON2			104									//下注定时
#define IDI_PLACE_JETTON3			105									//下注定时
#define IDI_PLACE_JETTON4			106									//下注定时
#define IDI_PLACE_JETTON5			107									//下注定时
#define IDI_CHECK_BANKER			108									//检查上庄
#define IDI_REQUEST_BANKER			101									//申请定时
#define IDI_GIVEUP_BANKER			102									//下庄定时
#define IDI_PLACE_JETTON			110									//下注定义 (预留110-160)

//////////////////////////////////////////////////////////////////////////

int CAndroidUserItemSink::m_stlApplyBanker = 0L;
int CAndroidUserItemSink::m_stnApplyCount = 0L;

//构造函数
CAndroidUserItemSink::CAndroidUserItemSink()
{
	//游戏变量
	m_lMaxChipBanker = 0;
	m_lMaxChipUser = 0;
	m_lAndroidBet = 0;
	m_lBankerScore = 0;
	m_wCurrentBanker = 0;
	m_nChipTime = 0;
	m_nChipTimeCount = 0;
	m_cbTimeLeave = 0;
	ZeroMemory(m_lAreaChip, sizeof(m_lAreaChip));
	ZeroMemory(m_nChipLimit, sizeof(m_nChipLimit));
	ZeroMemory(m_lAllBet, sizeof(m_lAllBet));

	//上庄变量
	m_bMeApplyBanker = false;
	m_nWaitBanker=0;
	m_nBankerCount=0;
	m_nListUserCount= 0;
	
	// 读取变量初始化
	m_lRobotBetLimit[1] = 10000000;
	m_lRobotBetLimit[0] = 100;
	if (m_lRobotBetLimit[1] > 10000000)					m_lRobotBetLimit[1] = 10000000;
	if (m_lRobotBetLimit[0] < 100)						m_lRobotBetLimit[0] = 100;
	if (m_lRobotBetLimit[1] < m_lRobotBetLimit[0])	m_lRobotBetLimit[1] = m_lRobotBetLimit[0];

	//次数限制
	m_nRobotBetTimeLimit[0] = 4;
	m_nRobotBetTimeLimit[1] = 8;

	if (m_nRobotBetTimeLimit[0] < 0)							m_nRobotBetTimeLimit[0] = 0;
	if (m_nRobotBetTimeLimit[1] < m_nRobotBetTimeLimit[0])		m_nRobotBetTimeLimit[1] = m_nRobotBetTimeLimit[0];

	//是否坐庄
	m_bRobotBanker = 0;

	//坐庄次数
	m_nRobotBankerCount = 3;
	m_nMinBankerTimes=2;
	m_nMaxBankerTimes=5;

	//空盘重申
	m_nRobotWaitBanker = 3;

	//上庄数量
	m_nRobotListMaxCount = 5;
	m_nRobotListMinCount = 2;

	//降低限制
	m_bReduceBetLimit = 0;

	//区域概率
	m_RobotInfo.nAreaChance[0] = 3;
	m_RobotInfo.nAreaChance[1] = 1;
	m_RobotInfo.nAreaChance[2] = 3;
	m_RobotInfo.nAreaChance[3] = 1;
	m_RobotInfo.nAreaChance[4] = 1;
	m_RobotInfo.nAreaChance[5] = 1;
	m_RobotInfo.nAreaChance[6] = 1;
	m_RobotInfo.nAreaChance[7] = 2;

	srand((unsigned)time(NULL));  

	return;
}

//析构函数
CAndroidUserItemSink::~CAndroidUserItemSink()
{
}

//接口查询
void * CAndroidUserItemSink::QueryInterface(REFGUID Guid, DWORD dwQueryVer)
{
	QUERYINTERFACE(IAndroidUserItemSink,Guid,dwQueryVer);
	QUERYINTERFACE_IUNKNOWNEX(IAndroidUserItemSink,Guid,dwQueryVer);
	return NULL;
}

//初始接口
bool CAndroidUserItemSink::Initialization(IUnknownEx * pIUnknownEx)
{
	//查询接口
	m_pIAndroidUserItem=QUERY_OBJECT_PTR_INTERFACE(pIUnknownEx,IAndroidUserItem);
	if (m_pIAndroidUserItem==NULL) return false;

	return true;
}

//重置接口
bool CAndroidUserItemSink::RepositionSink()
{
	//游戏变量
	m_lMaxChipBanker = 0;
	m_lMaxChipUser = 0;
	m_lAndroidBet = 0;
	m_lBankerScore = 0;
	m_wCurrentBanker = 0;
	m_nChipTime = 0;
	m_nChipTimeCount = 0;
	m_cbTimeLeave = 0;
	ZeroMemory(m_lAreaChip, sizeof(m_lAreaChip));
	ZeroMemory(m_nChipLimit, sizeof(m_nChipLimit));
	ZeroMemory(m_lAllBet,sizeof(m_lAllBet));

	//上庄变量
	m_bMeApplyBanker = false;
	m_nWaitBanker=0;
	m_nBankerCount=0;

	return true;
}

//时间消息
bool CAndroidUserItemSink::OnEventTimer(UINT nTimerID)
{
	switch (nTimerID)
	{
	case IDI_BANK_OPERATE:		//银行操作
		{
			m_pIAndroidUserItem->KillGameTimer(nTimerID);

			//变量定义
			IServerUserItem *pUserItem = m_pIAndroidUserItem->GetMeUserItem();
			LONGLONG lRobotScore = pUserItem->GetUserScore();			
			{

				//判断存取
				if (lRobotScore > m_lRobotScoreRange[1])
				{
					LONGLONG lSaveScore=0L;

					lSaveScore = LONGLONG(lRobotScore*m_nRobotBankStorageMul/100);
					if (lSaveScore > lRobotScore)  lSaveScore = lRobotScore;

					if (lSaveScore > 0 && m_wCurrentBanker != m_pIAndroidUserItem->GetChairID())
						m_pIAndroidUserItem->PerformSaveScore(lSaveScore);

				}
				else if (lRobotScore < m_lRobotScoreRange[0])
				{
					SCORE lDiffScore = (m_lRobotBankGetScoreMax-m_lRobotBankGetScoreMin)/100;
					SCORE lScore = m_lRobotBankGetScoreMin + (m_pIAndroidUserItem->GetUserID()%10)*(rand()%10)*lDiffScore + 
						(rand()%10+1)*(rand()%(lDiffScore/10));
					if (lScore > 0)
						m_pIAndroidUserItem->PerformTakeScore(lScore);								
				}
			}
			return false;
		}
	default:
		{
			if (nTimerID >= IDI_PLACE_JETTON && nTimerID <= IDI_PLACE_JETTON+MAX_CHIP_TIME)
			{
				//对冲下注
				int	nAreaChance[AREA_MAX] = {0};	//区域几率
				LONGLONG nMaxBet[AREA_MAX] = {0};	//区域最大下注
				CopyMemory( nAreaChance, m_RobotInfo.nAreaChance, sizeof(nAreaChance));

				//判断最大下注
				for( int i = 0 ; i < AREA_MAX; ++i )
				{
					nMaxBet[i] = GetMaxPlayerScore(i);
					if( nMaxBet[i] < 100 )
					{
						nAreaChance[i] = 0;
					}
				}

				//随机区域
				int nACTotal = 0;
				int nRandNum = 0;
				int nChipArea = 0;
				for (int i = 0; i < AREA_MAX; i++)
					nACTotal += nAreaChance[i];
				static int nStFluc = 1;				//随机辅助
				if (nACTotal > 0)	
				{
					nRandNum = (rand()+nStFluc*3) % nACTotal;
					for (int i = 0; i < AREA_MAX; i++)
					{
						nRandNum -= nAreaChance[i];
						if (nRandNum <= 0)
						{
							nChipArea = i;
							break;
						}
					}
					nStFluc = nStFluc + 2 + rand()%3;

					//随机下注
					LONGLONG lBetScore = 0;

					if( nMaxBet[nChipArea] < m_lRobotBetLimit[0] )
					{
						for( int i = CountArray(m_RobotInfo.nChip) - 1; i >= 0 ; i-- )
						{
							if( nMaxBet[nChipArea] >= m_RobotInfo.nChip[i] )
							{
								lBetScore = m_RobotInfo.nChip[i];
								break;
							}
						}
					}
					else if( nMaxBet[nChipArea] == m_lRobotBetLimit[0] )
					{
						lBetScore = nMaxBet[nChipArea];
					}
					else
					{
						int nCurChip[2] = {0 , CountArray(m_RobotInfo.nChip) - 1};
						for( int i = 0 ; i < CountArray(m_RobotInfo.nChip); ++i )
						{
							if( m_lRobotBetLimit[0] == m_RobotInfo.nChip[i] )
								nCurChip[0] = i;
							if( m_lRobotBetLimit[1] == m_RobotInfo.nChip[i] )
								nCurChip[1] = i;
						}
						if( nCurChip[1] == nCurChip[0] )
							lBetScore = m_RobotInfo.nChip[nCurChip[0]];
						else
							lBetScore = m_RobotInfo.nChip[ (rand()%(nCurChip[1] - nCurChip[0]+1)) + nCurChip[0]];
					}

					if( lBetScore > 0 )
					{
						//变量定义
						CMD_C_PlaceBet PlaceBet = {};

						//构造变量
						PlaceBet.cbBetArea = nChipArea;	
						PlaceBet.lBetScore = lBetScore;

						//发送消息
						m_pIAndroidUserItem->SendSocketData(SUB_C_PLACE_JETTON, &PlaceBet, sizeof(PlaceBet));

						
					}
				}
			}

			m_pIAndroidUserItem->KillGameTimer(nTimerID);
			return false;
		}
	}
	return false;
}

//游戏消息
bool CAndroidUserItemSink::OnEventGameMessage(WORD wSubCmdID, void * pBuffer, WORD wDataSize)
{
	switch (wSubCmdID)
	{
	case SUB_S_GAME_FREE:			//游戏空闲 
		{
			return OnSubGameFree(pBuffer, wDataSize);
		}
	case SUB_S_GAME_START:			//游戏开始
		{
			return OnSubGameStart(pBuffer, wDataSize);
		}
	case SUB_S_PLACE_JETTON:		//用户加注
		{
			return OnSubPlaceBet(pBuffer, wDataSize);
		}
	case SUB_S_APPLY_BANKER:		//申请做庄 
		{
			return OnSubUserApplyBanker(pBuffer,wDataSize);
		}
	case SUB_S_CANCEL_BANKER:		//取消做庄 
		{
			return OnSubUserCancelBanker(pBuffer,wDataSize);
		}
	case SUB_S_CHANGE_BANKER:		//切换庄家 
		{
			return OnSubChangeBanker(pBuffer,wDataSize);
		}
	case SUB_S_GAME_END:			//游戏结束 
		{
			return OnSubGameEnd(pBuffer, wDataSize);
		}
	case SUB_S_SEND_RECORD:			//游戏记录 (忽略)
		{
			return true;
		}
	case SUB_S_PLACE_JETTON_FAIL:	//下注失败 (忽略)
		{
			return true;
		}
	case SUB_S_SUPERROB_BANKER:
		{
			return true;
		}
	case SUB_S_CURSUPERROB_LEAVE:
		{
			return true;
		}
	case SUB_S_UPDATE_STORAGE:
		{
			return true;
		}
	case SUB_S_OCCUPYSEAT:
		{
			return true;
		}
	case SUB_S_OCCUPYSEAT_FAIL:
		{
			return true;
		}
	case SUB_S_UPDATE_OCCUPYSEAT:
		{
			return true;
		}
	}

	//错误断言
	ASSERT(FALSE);

	return true;
}

//游戏消息
bool CAndroidUserItemSink::OnEventFrameMessage(WORD wSubCmdID, void * pData, WORD wDataSize)
{
	return true;
}

//场景消息
bool CAndroidUserItemSink::OnEventSceneMessage(BYTE cbGameStatus, bool bLookonOther, void * pData, WORD wDataSize)
{
	switch (cbGameStatus)
	{
	case GAME_SCENE_FREE:			//空闲状态
		{
			//效验数据
			ASSERT(wDataSize==sizeof(CMD_S_StatusFree));
			if (wDataSize!=sizeof(CMD_S_StatusFree)) return false;

			//消息处理
			CMD_S_StatusFree * pStatusFree=(CMD_S_StatusFree *)pData;

			m_lUserLimitScore = pStatusFree->lPlayFreeSocre;
			m_lAreaLimitScore = pStatusFree->lAreaLimitScore;
			m_lBankerCondition = pStatusFree->lApplyBankerCondition;

			memcpy(m_szRoomName, pStatusFree->szGameRoomName, sizeof(m_szRoomName));

			ReadConfigInformation(&pStatusFree->CustomAndroid);

			return true;
		}
	case GAME_SCENE_BET:		//游戏状态
	case GAME_SCENE_END:		//结束状态
		{
			//效验数据
			ASSERT(wDataSize==sizeof(CMD_S_StatusPlay));
			if (wDataSize!=sizeof(CMD_S_StatusPlay)) return false;

			//消息处理
			CMD_S_StatusPlay * pStatusPlay=(CMD_S_StatusPlay *)pData;

			//庄家信息
			m_wCurrentBanker = pStatusPlay->wBankerUser;

			m_lUserLimitScore = pStatusPlay->lPlayBetScore;
			m_lAreaLimitScore = pStatusPlay->lAreaLimitScore;
			m_lBankerCondition = pStatusPlay->lApplyBankerCondition;

			memcpy(m_szRoomName, pStatusPlay->szGameRoomName, sizeof(m_szRoomName));

			ReadConfigInformation(&pStatusPlay->CustomAndroid);

			return true;
		}
	}

	return true;
}

//用户进入
void CAndroidUserItemSink::OnEventUserEnter(IAndroidUserItem * pIAndroidUserItem, bool bLookonUser)
{
	return;
}

//用户离开
void CAndroidUserItemSink::OnEventUserLeave(IAndroidUserItem * pIAndroidUserItem, bool bLookonUser)
{
	return;
}

//用户积分
void CAndroidUserItemSink::OnEventUserScore(IAndroidUserItem * pIAndroidUserItem, bool bLookonUser)
{
	return;
}

//用户状态
void CAndroidUserItemSink::OnEventUserStatus(IAndroidUserItem * pIAndroidUserItem, bool bLookonUser)
{
	return;
}



//游戏空闲
bool CAndroidUserItemSink::OnSubGameFree(const void * pBuffer, WORD wDataSize)
{
	//消息处理
	CMD_S_GameFree* pGameFree=(CMD_S_GameFree *)pBuffer;

	m_cbTimeLeave = pGameFree->cbTimeLeave;

	//银行操作
	if (pGameFree->cbTimeLeave > 2)
		m_pIAndroidUserItem->SetGameTimer(IDI_BANK_OPERATE, (rand() % (pGameFree->cbTimeLeave-1)) + 1);

	return true;
}

//游戏开始
bool CAndroidUserItemSink::OnSubGameStart(const void * pBuffer, WORD wDataSize)
{	
	//效验数据
	ASSERT(wDataSize==sizeof(CMD_S_GameStart));
	if (wDataSize!=sizeof(CMD_S_GameStart)) return false;

	//消息处理
	CMD_S_GameStart * pGameStart=(CMD_S_GameStart *)pBuffer;

	//自己当庄或无下注机器人
	if (pGameStart->wBankerUser == m_pIAndroidUserItem->GetChairID() || pGameStart->nChipRobotCount <= 0)
		return true;

	//设置变量
	m_lAndroidBet = 0;
	m_nListUserCount = pGameStart->nListUserCount;
	m_lMaxChipBanker = pGameStart->lBankerScore/m_RobotInfo.nMaxTime;

	CString strO = m_pIAndroidUserItem->GetMeUserItem()->GetNickName();
	m_lMaxChipUser = pGameStart->lPlayBetScore/m_RobotInfo.nMaxTime;
	m_wCurrentBanker = pGameStart->wBankerUser;
	m_lBankerScore = pGameStart->lBankerScore;
	m_nChipTimeCount = 0;
	ZeroMemory(m_nChipLimit, sizeof(m_nChipLimit));
	ZeroMemory(m_lAllBet,sizeof(m_lAllBet));

	if(pGameStart->nAndriodCount > 0)
		m_stlApplyBanker=pGameStart->nAndriodCount;
	else
		m_stlApplyBanker=0;

	for (int i = 0; i < AREA_MAX; i++)
		m_lAreaChip[i] = m_lAreaLimitScore;

	ASSERT(m_lMaxChipUser >= 0);

	//计算下注次数
	int nElapse = 0;												
	WORD wMyID = m_pIAndroidUserItem->GetChairID();

	if (m_nRobotBetTimeLimit[0] == m_nRobotBetTimeLimit[1])
		m_nChipTime = m_nRobotBetTimeLimit[0];
	else
		m_nChipTime = (rand()+wMyID)%(m_nRobotBetTimeLimit[1]-m_nRobotBetTimeLimit[0]+1) + m_nRobotBetTimeLimit[0];
	ASSERT(m_nChipTime>=0);		
	if (m_nChipTime <= 0)	return false;								//的确,2个都带等于
	if (m_nChipTime > MAX_CHIP_TIME)	m_nChipTime = MAX_CHIP_TIME;	//限定MAX_CHIP次下注

	//计算范围
	//if (!CalcBetRange(__min(m_lMaxChipBanker, m_lMaxChipUser), m_lRobotBetLimit, m_nChipTime, m_nChipLimit))
	//	return true;

	//设置时间
	int nTimeGrid = int(pGameStart->cbTimeLeave-2)*800/m_nChipTime;		//时间格,前2秒不下注,所以-2,800表示机器人下注时间范围千分比
	for (int i = 0; i < m_nChipTime; i++)
	{
		int nRandRage = int( nTimeGrid * i / (1500*sqrt((double)m_nChipTime)) ) + 1;		//波动范围
		nElapse = 2 + (nTimeGrid*i)/1000 + ( (rand()+wMyID)%(nRandRage*2) - (nRandRage-1) );
		ASSERT(nElapse>=2&&nElapse<=pGameStart->cbTimeLeave);
		if (nElapse < 2 || nElapse > pGameStart->cbTimeLeave)	continue;
		
		m_pIAndroidUserItem->SetGameTimer(IDI_PLACE_JETTON+i+1, nElapse);
	}

	return true;
}

//用户加注
bool CAndroidUserItemSink::OnSubPlaceBet(const void * pBuffer, WORD wDataSize)
{
	//效验数据
	ASSERT(wDataSize==sizeof(CMD_S_PlaceBet));
	if (wDataSize!=sizeof(CMD_S_PlaceBet)) return false;

	//消息处理
	CMD_S_PlaceBet * pPlaceBet=(CMD_S_PlaceBet *)pBuffer;

	//添加筹码
	if( pPlaceBet->wChairID == m_pIAndroidUserItem->GetChairID())
		m_lAndroidBet += pPlaceBet->lBetScore;

	m_lAllBet[pPlaceBet->cbBetArea] += pPlaceBet->lBetScore;

	//设置变量
	m_lMaxChipBanker -= pPlaceBet->lBetScore;

	//对冲计算
	m_lAreaChip[pPlaceBet->cbBetArea] -= pPlaceBet->lBetScore;

	//if (pPlaceBet->wChairID == m_pIAndroidUserItem->GetChairID())
	//	m_lMaxChipUser -= pPlaceBet->lBetScore;

	ASSERT(m_lMaxChipUser >= 0);

	return true;
}

//下注失败
bool CAndroidUserItemSink::OnSubPlaceBetFail(const void * pBuffer, WORD wDataSize)
{
	return true;
}

//游戏结束
bool CAndroidUserItemSink::OnSubGameEnd(const void * pBuffer, WORD wDataSize)
{
	//效验数据
	ASSERT(wDataSize==sizeof(CMD_S_GameEnd));
	if (wDataSize!=sizeof(CMD_S_GameEnd)) return false;

	//消息处理
	CMD_S_GameEnd * pGameEnd=(CMD_S_GameEnd *)pBuffer;

	m_stnApplyCount = 0;

	return true;
}

//申请做庄
bool CAndroidUserItemSink::OnSubUserApplyBanker(const void * pBuffer, WORD wDataSize)
{
	//效验数据
	ASSERT(wDataSize==sizeof(CMD_S_ApplyBanker));
	if (wDataSize!=sizeof(CMD_S_ApplyBanker)) return false;

	//消息处理
	CMD_S_ApplyBanker * pApplyBanker=(CMD_S_ApplyBanker *)pBuffer;

	//自己判断
	if (m_pIAndroidUserItem->GetChairID()==pApplyBanker->wApplyUser) 
		m_bMeApplyBanker = true;

	return true;
}

//取消做庄
bool CAndroidUserItemSink::OnSubUserCancelBanker(const void * pBuffer, WORD wDataSize)
{
	//效验数据
	ASSERT(wDataSize==sizeof(CMD_S_CancelBanker));
	if (wDataSize!=sizeof(CMD_S_CancelBanker)) return false;

	//消息处理
	CMD_S_CancelBanker * pCancelBanker=(CMD_S_CancelBanker *)pBuffer;

	//自己判断
	if ( m_pIAndroidUserItem->GetMeUserItem()->GetChairID() == pCancelBanker->wCancelUser ) 
		m_bMeApplyBanker = false;

	return true;
}

//切换庄家
bool CAndroidUserItemSink::OnSubChangeBanker(const void * pBuffer, WORD wDataSize)
{
	//效验数据
	ASSERT(wDataSize==sizeof(CMD_S_ChangeBanker));
	if (wDataSize!=sizeof(CMD_S_ChangeBanker)) return false;

	//消息处理
	CMD_S_ChangeBanker * pChangeBanker = (CMD_S_ChangeBanker *)pBuffer;

	if ( m_wCurrentBanker == m_pIAndroidUserItem->GetChairID() && m_wCurrentBanker != pChangeBanker->wBankerUser )
	{
		//m_stlApplyBanker--;
		m_nWaitBanker = 0;
		m_bMeApplyBanker = false;
	}
	m_wCurrentBanker = pChangeBanker->wBankerUser;

	return true;
}

//读取配置
void CAndroidUserItemSink::ReadConfigInformation(tagCustomAndroid *pCustomAndroid)
{
	//次数限制
	m_nRobotBetTimeLimit[0] = pCustomAndroid->lRobotMinBetTime;
	m_nRobotBetTimeLimit[1] = pCustomAndroid->lRobotMaxBetTime;
	if (m_nRobotBetTimeLimit[0] < 0) m_nRobotBetTimeLimit[0] = 0;
	if (m_nRobotBetTimeLimit[1] < m_nRobotBetTimeLimit[0]) m_nRobotBetTimeLimit[1] = m_nRobotBetTimeLimit[0];

	//筹码限制
	m_lRobotBetLimit[0] = pCustomAndroid->lRobotMinJetton;
	m_lRobotBetLimit[1] = pCustomAndroid->lRobotMaxJetton;
	if (m_lRobotBetLimit[1] > 10000000)					m_lRobotBetLimit[1] = 10000000;
	if (m_lRobotBetLimit[0] < 1000)						m_lRobotBetLimit[0] = 1000;
	if (m_lRobotBetLimit[1] < m_lRobotBetLimit[0])	m_lRobotBetLimit[1] = m_lRobotBetLimit[0];

	//是否坐庄
	m_bRobotBanker = pCustomAndroid->nEnableRobotBanker;

	//坐庄次数
	LONGLONG lRobotBankerCountMin = pCustomAndroid->lRobotBankerCountMin;
	LONGLONG lRobotBankerCountMax = pCustomAndroid->lRobotBankerCountMax;
	m_nRobotBankerCount = rand()%(lRobotBankerCountMax-lRobotBankerCountMin+1) + lRobotBankerCountMin;
	
	//列表人数
	m_nRobotListMinCount = pCustomAndroid->lRobotListMinCount;
	m_nRobotListMaxCount = pCustomAndroid->lRobotListMaxCount;
	
	//最多个数
	m_nRobotApplyBanker = pCustomAndroid->lRobotApplyBanker;

	//空盘重申
	m_nRobotWaitBanker = pCustomAndroid->lRobotWaitBanker;

	//分数限制
	m_lRobotScoreRange[0] = pCustomAndroid->lRobotScoreMin;
	m_lRobotScoreRange[1] = pCustomAndroid->lRobotScoreMax;
	if (m_lRobotScoreRange[1] < m_lRobotScoreRange[0])	m_lRobotScoreRange[1] = m_lRobotScoreRange[0];

	//提款数额
	m_lRobotBankGetScoreMin = pCustomAndroid->lRobotBankGetMin;
	m_lRobotBankGetScoreMax = pCustomAndroid->lRobotBankGetMax;

	//提款数额 (庄家)
	m_lRobotBankGetScoreBankerMin = pCustomAndroid->lRobotBankGetBankerMin;
	m_lRobotBankGetScoreBankerMax = pCustomAndroid->lRobotBankGetBankerMax;

	//存款倍数
	m_nRobotBankStorageMul = pCustomAndroid->lRobotBankStoMul;
	if (m_nRobotBankStorageMul<0 || m_nRobotBankStorageMul>100) m_nRobotBankStorageMul = 20;
	
	//区域几率
	CopyMemory(m_RobotInfo.nAreaChance,pCustomAndroid->nAreaChance,sizeof(m_RobotInfo.nAreaChance));
	return;

}

//计算范围	(返回值表示是否可以通过下降下限达到下注)
bool CAndroidUserItemSink::CalcBetRange(LONGLONG lMaxScore, LONGLONG lChipLmt[], int & nChipTime, int lJetLmt[])
{
	//定义变量
	bool bHaveSetMinChip = false;

	//不够一注
	if (lMaxScore < m_RobotInfo.nChip[0])	return false;

	//配置范围
	for (int i = 0; i < CountArray(m_RobotInfo.nChip); i++)
	{
		if (!bHaveSetMinChip && m_RobotInfo.nChip[i] >= lChipLmt[0])
		{ 
			lJetLmt[0] = i;
			bHaveSetMinChip = true;
		}
		if (m_RobotInfo.nChip[i] <= lChipLmt[1])
			lJetLmt[1] = i;
	}
	if (lJetLmt[0] > lJetLmt[1])	lJetLmt[0] = lJetLmt[1];

	//是否降低下限
	if (m_bReduceBetLimit)
	{
		if (nChipTime * m_RobotInfo.nChip[lJetLmt[0]] > lMaxScore)
		{
			//是否降低下注次数
			if (nChipTime * m_RobotInfo.nChip[0] > lMaxScore)
			{
				nChipTime = int(lMaxScore/m_RobotInfo.nChip[0]);
				lJetLmt[0] = 0;
				lJetLmt[1] = 0;
			}
			else
			{
				//降低到合适下限
				while (nChipTime * m_RobotInfo.nChip[lJetLmt[0]] > lMaxScore)
				{
					lJetLmt[0]--;
					ASSERT(lJetLmt[0]>=0);
				}
			}
		}
	}

	return true;
}


//最大下注
LONGLONG CAndroidUserItemSink::GetMaxPlayerScore( BYTE cbBetArea )
{	
	if( cbBetArea >= AREA_MAX )
		return 0L;

	//已下注额
	LONGLONG lNowBet = m_lAndroidBet;

	//最大下注
	LONGLONG lMaxBet = 0L;

	ASSERT(m_lMaxChipUser >= 0);

	//最大下注
	lMaxBet = min( m_lMaxChipUser - lNowBet, m_lAreaLimitScore - m_lAndroidBet);

	lMaxBet = min( m_lMaxChipUser - lNowBet, m_lAreaLimitScore - m_lAllBet[cbBetArea]);

	//lMaxBet = min( lMaxBet, lBankerScore / (cbMultiple[cbBetArea] - 1));

	//非零限制
	lMaxBet = max(lMaxBet, 0);

	return lMaxBet;
}
//////////////////////////////////////////////////////////////////////////

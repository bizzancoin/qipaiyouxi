#include "Stdafx.h"
#include "AndroidUserItemSink.h"

//////////////////////////////////////////////////////////////////////////

//辅助时间
#define TIME_LESS						2									//最少时间

//游戏时间
#define TIME_USER_CALL_BANKER			2									//叫庄时间
#define TIME_USER_START_GAME			3									//开始时间
#define TIME_USER_ADD_SCORE				3									//下注时间
#define TIME_USER_OPEN_CARD				12									//摊牌时间

#define TIME_CHECK_BANKER				30									//检查银行

//游戏时间
#define IDI_START_GAME					(100)									//开始定时器
#define IDI_USER_ADD_SCORE				(102)									//下注定时器
#define IDI_GET_CARD					(103)									//要牌定时器
#define IDI_STOP_CARD					(104)									//停牌定时器
#define IDI_SPLIT_CARD					(105)									//分牌定时器
#define IDI_DOUBLE_CARD					(106)									//加倍定时器


#define IDI_CHECK_BANKER_OPERATE        (110)									//检查定时器

//////////////////////////////////////////////////////////////////////////

//构造函数
CAndroidUserItemSink::CAndroidUserItemSink()
{
	m_lTurnMaxScore = 0;
	m_lCellScore = 0;
	m_wBankerUser = INVALID_CHAIR;
	ZeroMemory(m_HandCardData,sizeof(m_HandCardData));
	ZeroMemory( m_bStopCard,sizeof(m_bStopCard) );
	ZeroMemory( m_bInsureCard,sizeof(m_bInsureCard) );
	ZeroMemory( m_bDoubleCard,sizeof(m_bDoubleCard) );
	ZeroMemory( m_cbCardCount,sizeof(m_cbCardCount) );

	m_nRobotBankStorageMul=0;
	m_lRobotBankGetScore=0;
	m_lRobotBankGetScoreBanker=0;
	ZeroMemory(m_lRobotScoreRange,sizeof(m_lRobotScoreRange));
	m_bWin=false;
	
	//接口变量
	m_pIAndroidUserItem=NULL;
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
	m_lTurnMaxScore = 0;
	ZeroMemory(m_HandCardData,sizeof(m_HandCardData));
	ZeroMemory( m_bStopCard,sizeof(m_bStopCard) );
	ZeroMemory( m_bInsureCard,sizeof(m_bInsureCard) );
	ZeroMemory( m_bDoubleCard,sizeof(m_bDoubleCard) );
	ZeroMemory( m_cbCardCount,sizeof(m_cbCardCount) );
	m_wBankerUser = INVALID_CHAIR;

	//检查银行
	//UINT nElapse=TIME_CHECK_BANKER+rand()%100;
	//m_pIAndroidUserItem->SetGameTimer(IDI_CHECK_BANKER_OPERATE,nElapse);

	return true;
}

//时间消息
bool CAndroidUserItemSink::OnEventTimer(UINT nTimerID)
{
	try
	{
		switch (nTimerID)
		{		
		case IDI_CHECK_BANKER_OPERATE://检查银行
			{

// 				IServerUserItem *pUserItem = m_pIAndroidUserItem->GetMeUserItem();
// 				if (NULL == pUserItem) return true;
// 				if(pUserItem->GetUserStatus()<US_SIT)
// 				{
// 					//ReadConfigInformation();
// 					//BankOperate(1);
// 				}
// 				//检查银行
// 				UINT nElapse=TIME_CHECK_BANKER+rand()%100;
// 				m_pIAndroidUserItem->SetGameTimer(IDI_CHECK_BANKER_OPERATE,nElapse);

				return true;
			}
		case IDI_START_GAME:		//开始定时器
			{
				//发送准备
				m_pIAndroidUserItem->KillGameTimer(IDI_START_GAME);

				m_pIAndroidUserItem->SendUserReady(NULL,0);

				return true;
			}		
		case IDI_USER_ADD_SCORE:	//加注定时
			{
				m_pIAndroidUserItem->KillGameTimer(IDI_USER_ADD_SCORE);
				//发送消息
				CMD_C_AddScore AddScore;
				//随机概率
				AddScore.lScore = ((rand() % 4) + 1)*m_lCellScore;
				if (AddScore.lScore <= 0)
				{
					AddScore.lScore = m_lCellScore;
				}
				
				m_pIAndroidUserItem->SendSocketData(SUB_C_ADD_SCORE, &AddScore, sizeof(CMD_C_AddScore));

				return true;	
			}
		case IDI_STOP_CARD:			//停牌定时
			{
				m_pIAndroidUserItem->KillGameTimer(IDI_STOP_CARD);
				m_pIAndroidUserItem->SendSocketData(SUB_C_STOP_CARD, NULL, 0);
				return true;	
			}
		case IDI_DOUBLE_CARD:		//加倍定时
			{
				m_pIAndroidUserItem->KillGameTimer(IDI_DOUBLE_CARD);
				m_pIAndroidUserItem->SendSocketData(SUB_C_DOUBLE_SCORE, NULL, 0);
				return true;
			}
		case IDI_SPLIT_CARD:		//分牌定时
			{
				m_pIAndroidUserItem->KillGameTimer(IDI_SPLIT_CARD);
				m_pIAndroidUserItem->SendSocketData(SUB_C_SPLIT_CARD, NULL, 0);
				return true;
			}
		case IDI_GET_CARD:			//要牌定时
			{
				m_pIAndroidUserItem->KillGameTimer(IDI_GET_CARD);
				m_pIAndroidUserItem->SendSocketData(SUB_C_GET_CARD, NULL, 0);

// 				CStringA lyt;
// 				lyt.Format("lytlog::机器人 定时 要牌 OnEventTimer()  wChairID = %d m_wBankerUser = %d", m_pIAndroidUserItem->GetChairID(), m_wBankerUser);
// 				OutputDebugStringA(lyt); 
				return true;
			}

		}
	}
	catch (...)
	{
		CString cs;
		cs.Format(TEXT("异常ID=%d"),nTimerID);
		CTraceService::TraceString(cs,TraceLevel_Debug);
	}	
	
	return false;
}

//游戏消息
bool CAndroidUserItemSink::OnEventGameMessage(WORD wSubCmdID, void * pData, WORD wDataSize)
{
	switch (wSubCmdID)
	{	
	case SUB_S_GAME_START:	//游戏开始
		{			
			//消息处理
			return OnSubGameStart(pData,wDataSize);
		}
	case SUB_S_ADD_SCORE:	//加注
		{
			return OnSubAddScore( pData,wDataSize );
		}
	case SUB_S_SEND_CARD:	//发牌消息
		{
			//消息处理
			return OnSubSendCard(pData, wDataSize);
		}
	case SUB_S_STOP_CARD:	//停牌
		{			
			//消息处理
			return OnSubStopCard(pData,wDataSize);
		}
	case SUB_S_DOUBLE_SCORE://加倍
		{			
			//消息处理
			return OnSubDoubleCard(pData,wDataSize);
		}
	case SUB_S_SPLIT_CARD:	//分牌
		{			
			//消息处理
			return OnSubSplitCard(pData,wDataSize);
		}
	case SUB_S_INSURE:		//保险
		{
			//消息处理
			return OnSubInsureCard(pData,wDataSize);
		}
	case SUB_S_GET_CARD:	//要牌
		{			
			//消息处理
			return OnSubGetCard(pData,wDataSize);
		}	
	case SUB_S_GAME_END:	//游戏结束
		{
			//消息处理
			return OnSubGameEnd(pData,wDataSize);
		}
	case SUB_S_CHEAT_CARD:
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
	case GAME_STATUS_FREE:		//空闲状态
		{
			CString strGameLog;
			strGameLog.Format(TEXT("  AI 空闲状态()  000  \n"));
			m_pIAndroidUserItem->SendLogData(strGameLog);
			//效验数据
			if (wDataSize!=sizeof(CMD_S_StatusFree)) return false;

			//消息处理
			CMD_S_StatusFree * pStatusFree=(CMD_S_StatusFree *)pData;

			//读取配置
			ReadConfigInformation(&(pStatusFree->CustomAndroid));
			BankOperate(2);

			//开始时间
			UINT nElapse = rand() % TIME_LESS + TIME_LESS;
			m_pIAndroidUserItem->SetGameTimer(IDI_START_GAME,nElapse);

			strGameLog.Format(TEXT("  AI 空闲状态()  111  \n"));
			m_pIAndroidUserItem->SendLogData(strGameLog);

			return true;
		}
	case GAME_SCENE_ADD_SCORE:	//游戏状态
		{
			CString strGameLog;
			strGameLog.Format(TEXT("  AI 下注状态()  000  \n"));
			m_pIAndroidUserItem->SendLogData(strGameLog);
			//效验数据
			if (wDataSize!=sizeof(CMD_S_StatusAddScore)) return false;
			CMD_S_StatusAddScore * pStatusScore=(CMD_S_StatusAddScore *)pData;

			//读取配置
			ReadConfigInformation(&(pStatusScore->CustomAndroid));

			BankOperate(2);	

			//设置变量
			m_lTurnMaxScore=pStatusScore->lMaxScore;
			WORD wMeChairId = m_pIAndroidUserItem->GetChairID();

			//设置筹码
			if (pStatusScore->lMaxScore>0L && pStatusScore->lTableScore[wMeChairId]==0L)
			{
				//下注时间
				UINT nElapse = rand() % TIME_LESS + TIME_LESS;
				m_pIAndroidUserItem->SetGameTimer(IDI_USER_ADD_SCORE,nElapse);
			}

			strGameLog.Format(TEXT("  AI 下注状态()  111  \n"));
			m_pIAndroidUserItem->SendLogData(strGameLog);

			return true;
		}
	case GAME_SCENE_GET_CARD:
		{
			CString strGameLog;
			strGameLog.Format(TEXT("  AI 游戏状态()  000  \n"));
			m_pIAndroidUserItem->SendLogData(strGameLog);
			//效验数据
			if (wDataSize!=sizeof(CMD_S_StatusGetCard)) return false;
			CMD_S_StatusGetCard * pStatusGetCard=(CMD_S_StatusGetCard *)pData;

			//读取配置
			ReadConfigInformation(&(pStatusGetCard->CustomAndroid));

			BankOperate(2);	

			WORD wMeChairId = m_pIAndroidUserItem->GetChairID();
			if (pStatusGetCard->wCurrentUser != NULL && wMeChairId == pStatusGetCard->wCurrentUser)
				
			{
				//设置定时器
// 				UINT nElapse = rand() % TIME_LESS + TIME_LESS;
// 				m_pIAndroidUserItem->SetGameTimer(IDI_GET_CARD, nElapse);

				if (pStatusGetCard->bStopCard[wMeChairId * 2] == false)
				{
// 					BYTE cbCardType = 0;
// 					cbCardType = m_GameLogic.GetCardType(m_HandCardData[0], m_cbCardCount[0], false);
// 					BYTE cbLastCardValue = 0;
// 					for (int i = 1; i < m_cbCardCount[0]; i++)
// 					{
// 						cbLastCardValue += m_GameLogic.GetCardLogicValue(m_HandCardData[0][i]);
// 					}
// 					//分析操作
// 					AnalyseCardOperate(cbCardType, cbLastCardValue);

					//设置定时器
					UINT nElapse = rand() % TIME_LESS + TIME_LESS;
					m_pIAndroidUserItem->SetGameTimer(IDI_STOP_CARD, nElapse);
				}
			}

			strGameLog.Format(TEXT("  AI 游戏状态()  111  \n"));
			m_pIAndroidUserItem->SendLogData(strGameLog);

			return true;
		}	
	}

	ASSERT(FALSE);

	return false;
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

//用户段位
void CAndroidUserItemSink::OnEventUserSegment(IAndroidUserItem * pIAndroidUserItem, bool bLookonUser)
{
	return;
}

//要牌
bool CAndroidUserItemSink::OnSubGetCard( const void *pBuffer, WORD wDataSize )
{
	CString strGameLog;
	strGameLog.Format(TEXT("  AI OnSubGetCard()  000  \n"));
	m_pIAndroidUserItem->SendLogData(strGameLog);
	//效验数据
	if (wDataSize!=sizeof(CMD_S_GetCard)) return false;
	CMD_S_GetCard * pGetCard=(CMD_S_GetCard *)pBuffer;	

	WORD wMeChairId = m_pIAndroidUserItem->GetChairID();
	if( wMeChairId == pGetCard->wGetCardUser )
	{
		WORD wIndex = m_bStopCard[wMeChairId*2]?1:0;
		m_HandCardData[wIndex][m_cbCardCount[wIndex]++] = pGetCard->cbCardData;		
		
		bool bSplitCard = m_cbCardCount[1] > 0 ? true : false;

		BYTE cbCardType = m_GameLogic.GetCardType( m_HandCardData[wIndex],m_cbCardCount[wIndex],bSplitCard);		

		BYTE cbLastCardValue = 0;
		for (int i = 1; i < m_cbCardCount[wIndex]; i++)
		{
			cbLastCardValue += m_GameLogic.GetCardLogicValue(m_HandCardData[wIndex][i]);
		}
		//庄家17点以下必须要牌
		if (wMeChairId == m_wBankerUser && cbCardType <= 17 && CT_BAOPAI != cbCardType)
		{
			//下注时间
			UINT nElapse = rand() % TIME_LESS + TIME_LESS;
			m_pIAndroidUserItem->SetGameTimer(IDI_GET_CARD, nElapse);

// 			CStringA lyt;
// 			lyt.Format("lytlog::机器人OnSubGetCard() wMeChairId = %d m_wBankerUser = %d cbCardType = %d ", wMeChairId, m_wBankerUser, cbCardType);
// 			OutputDebugStringA(lyt);
		}
		else
		{
			//分析操作
			AnalyseCardOperate(cbCardType, cbLastCardValue);
		}
	}

	strGameLog.Format(TEXT("  AI OnSubGetCard()  111  \n"));
	m_pIAndroidUserItem->SendLogData(strGameLog);

	return true;
}

//游戏开始
bool CAndroidUserItemSink::OnSubGameStart(const void * pBuffer, WORD wDataSize)
{
	CString strGameLog;
	strGameLog.Format(TEXT("  AI OnSubGameStart()  000  \n"));
	m_pIAndroidUserItem->SendLogData(strGameLog);
	//效验数据
	if (wDataSize!=sizeof(CMD_S_GameStart)) return false;
	CMD_S_GameStart * pGameStart=(CMD_S_GameStart *)pBuffer;

	if (NULL == m_pIAndroidUserItem) return true;
	//删除定时器	
	m_pIAndroidUserItem->KillGameTimer(IDI_START_GAME);
	m_pIAndroidUserItem->KillGameTimer(IDI_USER_ADD_SCORE);
	m_pIAndroidUserItem->KillGameTimer(IDI_STOP_CARD);
	m_pIAndroidUserItem->KillGameTimer(IDI_GET_CARD);
	m_pIAndroidUserItem->KillGameTimer(IDI_SPLIT_CARD);
	m_pIAndroidUserItem->KillGameTimer(IDI_DOUBLE_CARD);

	//设置变量
	m_lTurnMaxScore=pGameStart->lMaxScore;
	m_lCellScore = pGameStart->lCellScore;
	m_wBankerUser = pGameStart->wBankerUser;

	//设置筹码
	if (m_wBankerUser != m_pIAndroidUserItem->GetChairID())
	{
		//下注时间
		UINT nElapse = rand() % TIME_LESS + TIME_LESS;
		m_pIAndroidUserItem->SetGameTimer(IDI_USER_ADD_SCORE,nElapse);
	}

	strGameLog.Format(TEXT("  AI OnSubGameStart()  111  \n"));
	m_pIAndroidUserItem->SendLogData(strGameLog);

	return true;
}

//用户下注
bool CAndroidUserItemSink::OnSubAddScore(const void * pBuffer, WORD wDataSize)
{
	//效验数据
	if (wDataSize!=sizeof(CMD_S_AddScore)) return false;
	CMD_S_AddScore * pAddScore=(CMD_S_AddScore *)pBuffer;

	return true;
}

//发牌消息
bool CAndroidUserItemSink::OnSubSendCard(const void * pBuffer, WORD wDataSize)
{
	CString strGameLog;
	strGameLog.Format(TEXT("  AI OnSubSendCard()  000  \n"));
	m_pIAndroidUserItem->SendLogData(strGameLog);

	//效验数据
	if (wDataSize!=sizeof(CMD_S_SendCard)) return false;
	CMD_S_SendCard * pSendCard=(CMD_S_SendCard *)pBuffer;

	//设置变量
	WORD wMeChairId = m_pIAndroidUserItem->GetChairID();
	m_cbCardCount[0] = 2;
	CopyMemory( m_HandCardData[0],pSendCard->cbHandCardData[wMeChairId],sizeof(BYTE)*2 );
	m_bWin = pSendCard->bWin;

	if (m_wBankerUser != wMeChairId && pSendCard->wCurrentUser == wMeChairId)
	{
// 		if (m_GameLogic.GetCardValue(m_HandCardData[0][1]) == m_GameLogic.GetCardValue(m_HandCardData[0][0]))
// 		{
// 			//下注时间
// 			UINT nElapse=rand()%(4)+TIME_LESS;
// 			m_pIAndroidUserItem->SetGameTimer(IDI_SPLIT_CARD,nElapse);
// 		}
// 		else
		{
			BYTE cbCardType = 0;
			cbCardType = m_GameLogic.GetCardType( m_HandCardData[0],m_cbCardCount[0],false );
			BYTE cbLastCardValue = 0;
			for (int i = 1; i < m_cbCardCount[0]; i++)
			{
				cbLastCardValue += m_GameLogic.GetCardLogicValue(m_HandCardData[0][i]);
			}
			//分析操作
			AnalyseCardOperate(cbCardType, cbLastCardValue);
		}
	}

	strGameLog.Format(TEXT("  AI OnSubSendCard()  111  \n"));
	m_pIAndroidUserItem->SendLogData(strGameLog);

	return true;
}

//停牌消息
bool CAndroidUserItemSink::OnSubStopCard(const void * pBuffer, WORD wDataSize)
{
	CString strGameLog;
	strGameLog.Format(TEXT("  AI OnSubStopCard()  000  \n"));
	m_pIAndroidUserItem->SendLogData(strGameLog);

	//效验
	if( wDataSize != sizeof(CMD_S_StopCard) ) return false;
	CMD_S_StopCard *pStopCard = (CMD_S_StopCard *)pBuffer;

	if (pStopCard->wStopCardUser >= GAME_PLAYER) return true;
	
	//设置停牌变量
	WORD wOperIndex = pStopCard->wStopCardUser*2;
	if( m_bStopCard[wOperIndex] )
		m_bStopCard[++wOperIndex] = TRUE;
	else m_bStopCard[wOperIndex] = TRUE;

	WORD wMeChairId = m_pIAndroidUserItem->GetChairID();
// 	if (pStopCard->wStopCardUser == wMeChairId )
// 	{
// 		if (wOperIndex%2 == 0 && m_cbCardCount[1] > 0 )
// 		{
// 			BYTE cbCardType = m_GameLogic.GetCardType( m_HandCardData[1],m_cbCardCount[1],true);		
// 
// 			BYTE cbLastCardValue = 0;
// 			for (int i = 1; i < m_cbCardCount[1]; i++)
// 			{
// 				cbLastCardValue += m_GameLogic.GetCardLogicValue(m_HandCardData[1][i]);
// 			}
// 			//分析操作
// 			AnalyseCardOperate(cbCardType, cbLastCardValue);
// 		}		
// 	}

	//是否轮到庄家操作
	if (pStopCard->wCurrentUser == wMeChairId && pStopCard->wStopCardUser != m_wBankerUser)
	{		
		BYTE cbCardType = 0;
		cbCardType = m_GameLogic.GetCardType( m_HandCardData[0],m_cbCardCount[0],false );

		BYTE cbLastCardValue = 0;
		for (int i = 1; i < m_cbCardCount[0]; i++)
		{
			cbLastCardValue += m_GameLogic.GetCardLogicValue(m_HandCardData[0][i]);
		}
		//分析操作
		AnalyseCardOperate(cbCardType, cbLastCardValue);				
	}

	strGameLog.Format(TEXT("  AI OnSubStopCard()  111  \n"));
	m_pIAndroidUserItem->SendLogData(strGameLog);

	return true;
}

//加倍消息
bool CAndroidUserItemSink::OnSubDoubleCard(const void * pBuffer, WORD wDataSize)
{
	CString strGameLog;
	strGameLog.Format(TEXT("  AI OnSubDoubleCard()  000  \n"));
	m_pIAndroidUserItem->SendLogData(strGameLog);

	//效验
	if( wDataSize != sizeof(CMD_S_DoubleScore) ) return false;
	CMD_S_DoubleScore *pDoubleScore = (CMD_S_DoubleScore *)pBuffer;

	//若是自己加倍
	WORD wMeChairId = m_pIAndroidUserItem->GetChairID();
	if( wMeChairId == pDoubleScore->wDoubleScoreUser )
	{
		WORD wIndex = m_bStopCard[wMeChairId*2]?1:0;
		m_HandCardData[wIndex][m_cbCardCount[wIndex]++] = pDoubleScore->cbCardData;
	}
	//设置加倍
	if( wMeChairId == pDoubleScore->wDoubleScoreUser )
	{
		if( !m_bDoubleCard[0] ) m_bDoubleCard[0] = TRUE;
		else m_bDoubleCard[1] = TRUE;
	}

	strGameLog.Format(TEXT("  AI OnSubDoubleCard()  111  \n"));
	m_pIAndroidUserItem->SendLogData(strGameLog);

	return true;
}

//游戏结束
bool CAndroidUserItemSink::OnSubGameEnd(const void * pBuffer, WORD wDataSize)
{

	CString strGameLog;
	strGameLog.Format(TEXT("  AI OnSubGameEnd()  000  \n"));
	m_pIAndroidUserItem->SendLogData(strGameLog);

	//效验参数
	if (wDataSize!=sizeof(CMD_S_GameEnd)) return false;
	CMD_S_GameEnd * pGameEnd=(CMD_S_GameEnd *)pBuffer;

	//删除定时器	
	m_pIAndroidUserItem->KillGameTimer(IDI_START_GAME);
	m_pIAndroidUserItem->KillGameTimer(IDI_USER_ADD_SCORE);
	m_pIAndroidUserItem->KillGameTimer(IDI_STOP_CARD);
	m_pIAndroidUserItem->KillGameTimer(IDI_GET_CARD);
	m_pIAndroidUserItem->KillGameTimer(IDI_SPLIT_CARD);
	m_pIAndroidUserItem->KillGameTimer(IDI_DOUBLE_CARD);	
	
	//开始时间
	//if(m_pIAndroidUserItem->GetChairID() != INVALID_CHAIR)
	{
		UINT nElapse = rand() % TIME_LESS + TIME_LESS * 2;
		m_pIAndroidUserItem->SetGameTimer(IDI_START_GAME,nElapse);
	}

	//清理变量
	m_lTurnMaxScore = 0;	
	ZeroMemory(m_HandCardData,sizeof(m_HandCardData));
	ZeroMemory( m_bStopCard,sizeof(m_bStopCard) );
	ZeroMemory( m_bInsureCard,sizeof(m_bInsureCard) );
	ZeroMemory( m_bDoubleCard,sizeof(m_bDoubleCard) );
	ZeroMemory( m_cbCardCount,sizeof(m_cbCardCount) );

	strGameLog.Format(TEXT("  AI OnSubGameEnd()  111  \n"));
	m_pIAndroidUserItem->SendLogData(strGameLog);

	return true;
}

//分牌消息
bool CAndroidUserItemSink::OnSubSplitCard(const void * pBuffer, WORD wDataSize)
{
	CString strGameLog;
	strGameLog.Format(TEXT("  AI OnSubSplitCard()  000  \n"));
	m_pIAndroidUserItem->SendLogData(strGameLog);

	//效验
	if( wDataSize != sizeof(CMD_S_SplitCard) ) return false;
	CMD_S_SplitCard *pSplitCard = (CMD_S_SplitCard *)pBuffer;

	//若是自己分牌
	WORD wMeChairId = m_pIAndroidUserItem->GetChairID();
	if( pSplitCard->wSplitUser == wMeChairId )
	{		
		m_HandCardData[1][1] = m_HandCardData[0][1];
		m_HandCardData[0][0] = pSplitCard->cbCardData[0];
		m_HandCardData[1][0] = pSplitCard->cbCardData[1];
		m_cbCardCount[0] = m_cbCardCount[1] = 2;			

		BYTE cbCardType = m_GameLogic.GetCardType( m_HandCardData[0],m_cbCardCount[0],false);		

		//分析操作
		AnalyseCardOperate(cbCardType, m_GameLogic.GetCardLogicValue(m_HandCardData[0][1]));
	}

	strGameLog.Format(TEXT("  AI OnSubSplitCard()  111  \n"));
	m_pIAndroidUserItem->SendLogData(strGameLog);

	return true;
}

//分析操作
bool CAndroidUserItemSink::AnalyseCardOperate(BYTE cbCardType, BYTE cbLastVaule)
{
	CString strGameLog;
	strGameLog.Format(TEXT("  AI AnalyseCardOperate()  000  \n"));
	m_pIAndroidUserItem->SendLogData(strGameLog);

	//删除定时器	
	m_pIAndroidUserItem->KillGameTimer(IDI_USER_ADD_SCORE);
	m_pIAndroidUserItem->KillGameTimer(IDI_STOP_CARD);
	m_pIAndroidUserItem->KillGameTimer(IDI_GET_CARD);
	m_pIAndroidUserItem->KillGameTimer(IDI_SPLIT_CARD);
	m_pIAndroidUserItem->KillGameTimer(IDI_DOUBLE_CARD);

	if (cbCardType == CT_BAOPAI || cbCardType >= CT_BJ - 1)
	{
		//下注时间
		UINT nElapse = rand() % TIME_LESS + TIME_LESS;
		m_pIAndroidUserItem->SetGameTimer(IDI_STOP_CARD, nElapse);
		return true;
	}
	else
	{
// 		if (m_bWin)
// 		{
// 			if (cbLastVaule < 11)
// 			{
// 				//下注时间
// 				UINT nElapse=rand()%(4)+TIME_LESS;
// 				m_pIAndroidUserItem->SetGameTimer(IDI_GET_CARD,nElapse);
// 				return true;
// 			}
// 			else
// 			{
// 				//下注时间
// 				UINT nElapse=rand()%(4)+TIME_LESS;
// 				m_pIAndroidUserItem->SetGameTimer(IDI_STOP_CARD,nElapse);
// 				return true;
// 			}
// 		}
// 		else
		{
			if (cbCardType < 15)
			{
				//下注时间
				UINT nElapse = rand() % TIME_LESS + TIME_LESS;
				m_pIAndroidUserItem->SetGameTimer(IDI_GET_CARD,nElapse);
				return true;
			}
			else if(cbCardType > 16)
			{				
				//下注时间
				UINT nElapse = rand() % TIME_LESS + TIME_LESS;
				m_pIAndroidUserItem->SetGameTimer(IDI_STOP_CARD, nElapse);
				return true;
			}
			else
			{
				int nRand = rand()%2;
				if (nRand == 0)
				{
					//下注时间
					UINT nElapse = rand() % TIME_LESS+TIME_LESS;
					m_pIAndroidUserItem->SetGameTimer(IDI_STOP_CARD, nElapse);
					return true;
				}
				else
				{
					//下注时间
					UINT nElapse = rand() % TIME_LESS+TIME_LESS;
					m_pIAndroidUserItem->SetGameTimer(IDI_GET_CARD,nElapse);
					return true;
				}
			}
		}
	}
}

//保险消息
bool CAndroidUserItemSink::OnSubInsureCard(const void * pBuffer, WORD wDataSize)
{
	CString strGameLog;
	strGameLog.Format(TEXT("  AI OnSubInsureCard()  000  \n"));
	m_pIAndroidUserItem->SendLogData(strGameLog);

	//效验
	if( wDataSize != sizeof(CMD_S_Insure) ) return false;
	CMD_S_Insure *pInsureCard = (CMD_S_Insure *)pBuffer;

	//设置保险
	WORD wMeChairId = m_pIAndroidUserItem->GetChairID();
	if( wMeChairId == pInsureCard->wInsureUser )
	{
		if( !m_bStopCard[wMeChairId*2] ) m_bInsureCard[0] = TRUE;
		else m_bInsureCard[1] = TRUE;
	}

	strGameLog.Format(TEXT("  AI OnSubInsureCard()  111  \n"));
	m_pIAndroidUserItem->SendLogData(strGameLog);

	return true;
}

//银行操作
void CAndroidUserItemSink::BankOperate(BYTE cbType)
{
	CString strGameLog;
	strGameLog.Format(TEXT("  AI BankOperate()  000  \n"));
	m_pIAndroidUserItem->SendLogData(strGameLog);

	IServerUserItem *pUserItem = m_pIAndroidUserItem->GetMeUserItem();
	if(pUserItem->GetUserStatus()>=US_SIT)
	{
		if(cbType==1)
		{
			CString strInfo;
			strInfo.Format(TEXT("大厅：状态不对，不执行存取款"));
			CTraceService::TraceString(strInfo,TraceLevel_Normal);
			return;			
		}
	}
	
	//变量定义
	LONGLONG lRobotScore = pUserItem->GetUserScore();

	//CString strInfo;
	//strInfo.Format(TEXT("配置信息：取款条件(%I64d)，存款条件(%I64d),游戏AI分数(%I64d)"),m_lRobotScoreRange[0],m_lRobotScoreRange[1],lRobotScore);
	//if(cbType==1) 
	//NcaTextOut(strInfo);

	{
		CString strInfo;
		strInfo.Format(TEXT("[%s] 分数(%I64d)"),pUserItem->GetNickName(),lRobotScore);

		if (lRobotScore > m_lRobotScoreRange[1])
		{
			CString strInfo1;
			strInfo1.Format(TEXT("满足存款条件(%I64d)"),m_lRobotScoreRange[1]);
			strInfo+=strInfo1;
			//CTraceService::TraceString(strInfo,TraceLevel_Normal);
		}
		else if (lRobotScore < m_lRobotScoreRange[0])
		{
			CString strInfo1;
			strInfo1.Format(TEXT("满足取款条件(%I64d)"),m_lRobotScoreRange[0]);
			strInfo+=strInfo1;
			//CTraceService::TraceString(strInfo,TraceLevel_Normal);
		}

		//判断存取
		if (lRobotScore > m_lRobotScoreRange[1])
		{			
			LONGLONG lSaveScore=0L;

			lSaveScore = LONGLONG(lRobotScore*m_nRobotBankStorageMul/100);
			if (lSaveScore > lRobotScore)  lSaveScore = lRobotScore;

			if (lSaveScore > 0)
				m_pIAndroidUserItem->PerformSaveScore(lSaveScore);

			LONGLONG lRobotNewScore = pUserItem->GetUserScore();

			CString strInfo;
			strInfo.Format(TEXT("[%s] 执行存款：存款前金币(%I64d)，存款后金币(%I64d)"),pUserItem->GetNickName(),lRobotScore,lRobotNewScore);

			//CTraceService::TraceString(strInfo,TraceLevel_Normal);

		}
		else if (lRobotScore < m_lRobotScoreRange[0])
		{

			CString strInfo;
			//strInfo.Format(TEXT("配置信息：取款最小值(%I64d)，取款最大值(%I64d)"),m_lRobotBankGetScore,m_lRobotBankGetScoreBanker);

			//if(cbType==1) 
			//	NcaTextOut(strInfo);
			
			SCORE lScore=rand()%m_lRobotBankGetScoreBanker+m_lRobotBankGetScore;
			if (lScore > 0)
				m_pIAndroidUserItem->PerformTakeScore(lScore);

			LONGLONG lRobotNewScore = pUserItem->GetUserScore();

			//CString strInfo;
			strInfo.Format(TEXT("[%s] 执行取款：取款前金币(%I64d)，取款后金币(%I64d)"),pUserItem->GetNickName(),lRobotScore,lRobotNewScore);

			//CTraceService::TraceString(strInfo,TraceLevel_Normal);
					
		}
	}

	strGameLog.Format(TEXT("  AI BankOperate()  111  \n"));
	m_pIAndroidUserItem->SendLogData(strGameLog);
}

//读取配置
void CAndroidUserItemSink::ReadConfigInformation(tagCustomAndroid *pCustomAndroid)
{
	CString strGameLog;
	strGameLog.Format(TEXT("  AI ReadConfigInformation()  000  \n"));
	m_pIAndroidUserItem->SendLogData(strGameLog);

	m_lRobotScoreRange[0] = pCustomAndroid->lRobotScoreMin;
	m_lRobotScoreRange[1] = pCustomAndroid->lRobotScoreMax;

	if (m_lRobotScoreRange[1] < m_lRobotScoreRange[0])	
		m_lRobotScoreRange[1] = m_lRobotScoreRange[0];

	m_lRobotBankGetScore = pCustomAndroid->lRobotBankGet;
	m_lRobotBankGetScoreBanker = pCustomAndroid->lRobotBankGetBanker;
	m_nRobotBankStorageMul = (int)pCustomAndroid->lRobotBankStoMul;

	if (m_nRobotBankStorageMul<0||m_nRobotBankStorageMul>100) 
		m_nRobotBankStorageMul =20;

	strGameLog.Format(TEXT("  AI ReadConfigInformation()  111  \n"));
	m_pIAndroidUserItem->SendLogData(strGameLog);
}


//组件创建函数
DECLARE_CREATE_MODULE(AndroidUserItemSink);

//////////////////////////////////////////////////////////////////////////

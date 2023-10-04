#include "Stdafx.h"
#include "AndroidUserItemSink.h"
#include "math.h"
#include <locale>

//////////////////////////////////////////////////////////////////////////

//辅助时间
#define TIME_LESS						2									//最少时间

//游戏时间
#define TIME_USER_CALL_BANKER			3									//叫庄时间
#define TIME_USER_START_GAME			3									//开始时间
#define TIME_USER_ADD_SCORE				3									//下注时间
#define TIME_USER_OPEN_CARD				3									//摊牌时间

//游戏时间
#define IDI_START_GAME					(100)									//开始定时器
#define IDI_CALL_BANKER					(101)									//叫庄定时器
#define IDI_USER_ADD_SCORE				(102)									//下注定时器
#define IDI_OPEN_CARD					(103)									//开牌定时器
#define IDI_DELAY_TIME					(105)									//延时定时器

//////////////////////////////////////////////////////////////////////////

//构造函数
CAndroidUserItemSink::CAndroidUserItemSink()
{
	m_lTurnMaxScore = 0;
	ZeroMemory(m_cbHandCardData, sizeof(m_cbHandCardData));

	m_nRobotBankStorageMul = 0;
	m_lRobotBankGetScore = 0;
	m_lRobotBankGetScoreBanker = 0;
	ZeroMemory(m_lRobotScoreRange, sizeof(m_lRobotScoreRange));

	m_cbDynamicJoin = FALSE;

	m_bgtConfig = BGT_DESPOT_;
	m_btConfig = BT_FREE_;

	m_lFreeConfig[0] = 200;
	m_lFreeConfig[1] = 500;
	m_lFreeConfig[2] = 800;
	m_lFreeConfig[3] = 1100;
	m_lFreeConfig[4] = 1500;

	ZeroMemory(m_lPercentConfig, sizeof(m_lPercentConfig));
	m_wBgtRobNewTurnChairID = INVALID_CHAIR;
	m_lCellScore = 0;

	//接口变量
	m_pIAndroidUserItem = NULL;
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
	QUERYINTERFACE(IAndroidUserItemSink, Guid, dwQueryVer);
	QUERYINTERFACE_IUNKNOWNEX(IAndroidUserItemSink, Guid, dwQueryVer);
	return NULL;
}

//初始接口
bool CAndroidUserItemSink::Initialization(IUnknownEx * pIUnknownEx)
{
	//查询接口
	m_pIAndroidUserItem = QUERY_OBJECT_PTR_INTERFACE(pIUnknownEx, IAndroidUserItem);
	if (m_pIAndroidUserItem == NULL)
	{
		return false;
	}

	return true;
}

//重置接口
bool CAndroidUserItemSink::RepositionSink()
{
	m_lTurnMaxScore = 0;
	ZeroMemory(m_cbHandCardData, sizeof(m_cbHandCardData));
	m_wBgtRobNewTurnChairID = INVALID_CHAIR;
	m_lCellScore = 0;

	return true;
}

//时间消息
bool CAndroidUserItemSink::OnEventTimer(UINT nTimerID)
{
	try
	{
		switch (nTimerID)
		{
		case IDI_DELAY_TIME:
		{
			//开始时间
			UINT nElapse = rand() % TIME_LESS;
			m_pIAndroidUserItem->SetGameTimer(IDI_START_GAME, nElapse);

			return true;
		}

		case IDI_START_GAME:		//开始定时器
		{
			//发送准备
			m_pIAndroidUserItem->SendUserReady(NULL, 0);

			return true;
		}
		case IDI_CALL_BANKER:		//叫庄定时
		{
			//设置变量
			CMD_C_CallBanker CallBanker;
			ZeroMemory(&CallBanker, sizeof(CallBanker));

			CallBanker.bBanker = (m_wBgtRobNewTurnChairID != INVALID_CHAIR ? true : rand() % 100 > 50);
			if (CallBanker.bBanker == false)
			{
				CallBanker.cbBankerTimes = 0;
			}
			else
			{
				//自由抢庄抢1倍
				CallBanker.cbBankerTimes = (m_bgtConfig == BGT_FREEBANKER_ ? 1 : rand() % 5 + 1);
			}

			//发送信息
			m_pIAndroidUserItem->SendSocketData(SUB_C_CALL_BANKER, &CallBanker, sizeof(CallBanker));

			return true;
		}
		case IDI_USER_ADD_SCORE:	//加注定时
		{
			CMD_C_AddScore AddScore;
			ZeroMemory(&AddScore, sizeof(AddScore));

			ASSERT(m_lTurnMaxScore > 0L);

			LONGLONG lAddScore = 0LL;

			if (m_btConfig == BT_FREE_)
			{
				//改成4个配置项，且发过来的是倍数
				lAddScore = m_lFreeConfig[rand() % (MAX_CONFIG - 1)] * m_lCellScore;

				if (lAddScore == 0 || lAddScore > m_lTurnMaxScore)
				{
					lAddScore = m_lTurnMaxScore;
				}
			}
			else if (m_btConfig == BT_PENCENT_)
			{
				lAddScore = m_lPercentConfig[rand() % MAX_CONFIG] * m_lTurnMaxScore / 100;

				if (lAddScore == 0)
				{
					lAddScore = m_lTurnMaxScore;
				}
			}

			AddScore.lScore = lAddScore;

			//发送消息
			m_pIAndroidUserItem->SendSocketData(SUB_C_ADD_SCORE, &AddScore, sizeof(AddScore));

			return true;
		}
		case IDI_OPEN_CARD:			//开牌定时
		{
			//发送消息
			CMD_C_OpenCard OpenCard;
			ZeroMemory(&OpenCard, sizeof(OpenCard));

			//获取最大牌型
			m_GameLogic.GetOxCard(m_cbHandCardData, MAX_CARDCOUNT);
			CopyMemory(OpenCard.cbCombineCardData, m_cbHandCardData, sizeof(m_cbHandCardData));
			m_pIAndroidUserItem->SendSocketData(SUB_C_OPEN_CARD, &OpenCard, sizeof(OpenCard));

			return true;
		}
		}
	}
	catch (...)
	{
		CString cs;
		cs.Format(TEXT("异常ID=%d"), nTimerID);
		CTraceService::TraceString(cs, TraceLevel_Debug);
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
		return OnSubGameStart(pData, wDataSize);
	}
	case SUB_S_ADD_SCORE:	//用户下注
	{
		//消息处理
		return OnSubAddScore(pData, wDataSize);
	}
	case SUB_S_PLAYER_EXIT:	//用户强退
	{
		//消息处理
		return OnSubPlayerExit(pData, wDataSize);
	}
	case SUB_S_SEND_CARD:	//发牌消息
	{
		//消息处理
		return OnSubSendCard(pData, wDataSize);
	}
	case SUB_S_GAME_END:	//游戏结束
	{
		//消息处理
		return OnSubGameEnd(pData, wDataSize);
	}
	case SUB_S_OPEN_CARD:	//用户摊牌
	{
		//消息处理
		return OnSubOpenCard(pData, wDataSize);
	}
	case SUB_S_CALL_BANKER:	//用户叫庄
	{
		//消息处理
		return OnSubCallBanker(pData, wDataSize);
	}
	case SUB_S_CALL_BANKERINFO:	//用户叫庄信息
	{
		//消息处理
		return OnSubCallBankerInfo(pData, wDataSize);
	}
	case SUB_S_ADMIN_STORAGE_INFO:
	case SUB_S_RECORD:
	{
		return true;
	}
	case SUB_S_ANDROID_BANKOPER:
	{
		BankOperate(2);
		return true;
	}
	case SUB_S_ANDROID_READY:
	{
		if (m_pIAndroidUserItem->GetMeUserItem()->GetUserStatus() < US_READY)
		{
			//开始时间
			UINT nElapse = TIME_LESS + (rand() % TIME_USER_START_GAME);
			m_pIAndroidUserItem->SetGameTimer(IDI_START_GAME, nElapse);
		}

		return true;
	}
	default:
		return true;
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
	case GS_TK_FREE:		//空闲状态
	{
		//效验数据
		if (wDataSize != sizeof(CMD_S_StatusFree))
		{
			return false;
		}

		//消息处理
		CMD_S_StatusFree * pStatusFree = (CMD_S_StatusFree *)pData;


		ReadConfigInformation(&(pStatusFree->CustomAndroid));

		BankOperate(2);

		m_bgtConfig = pStatusFree->bgtConfig;
		m_btConfig = pStatusFree->btConfig;
		m_lCellScore = pStatusFree->lCellScore;

		//开始时间
		UINT nElapse = rand() % TIME_LESS + (rand() % TIME_USER_START_GAME);
		m_pIAndroidUserItem->SetGameTimer(IDI_START_GAME, nElapse);

		return true;
	}
	case GS_TK_CALL:	// 叫庄状态
	{
		//效验数据
		if (wDataSize != sizeof(CMD_S_StatusCall))
		{
			return false;
		}

		CMD_S_StatusCall * pStatusCall = (CMD_S_StatusCall *)pData;

		m_cbDynamicJoin = pStatusCall->cbDynamicJoin;

		ReadConfigInformation(&(pStatusCall->CustomAndroid));

		BankOperate(2);

		m_bgtConfig = pStatusCall->bgtConfig;
		m_btConfig = pStatusCall->btConfig;
		m_lCellScore = pStatusCall->lCellScore;

		ASSERT(m_bgtConfig == BGT_ROB_);

		if (m_cbDynamicJoin == FALSE && pStatusCall->cbCallBankerStatus[m_pIAndroidUserItem->GetChairID()] == FALSE)
		{
			//叫庄时间
			UINT nElapse = TIME_LESS + (rand() % TIME_USER_CALL_BANKER);
			m_pIAndroidUserItem->SetGameTimer(IDI_CALL_BANKER, nElapse);
		}

		return true;
	}
	case GS_TK_SCORE:	//下注状态
	{
		//效验数据
		if (wDataSize != sizeof(CMD_S_StatusScore))
		{
			return false;
		}

		CMD_S_StatusScore * pStatusScore = (CMD_S_StatusScore *)pData;

		m_cbDynamicJoin = pStatusScore->cbDynamicJoin;

		ReadConfigInformation(&(pStatusScore->CustomAndroid));

		BankOperate(2);

		m_bgtConfig = pStatusScore->bgtConfig;
		m_btConfig = pStatusScore->btConfig;
		m_lCellScore = pStatusScore->lCellScore;

		CopyMemory(m_lFreeConfig, pStatusScore->lFreeConfig, sizeof(m_lFreeConfig));
		CopyMemory(m_lPercentConfig, pStatusScore->lPercentConfig, sizeof(m_lPercentConfig));

		//设置变量
		m_lTurnMaxScore = pStatusScore->lTurnMaxScore;
		WORD wMeChairId = m_pIAndroidUserItem->GetChairID();

		//设置筹码
		if (pStatusScore->lTurnMaxScore > 0L && pStatusScore->lTableScore[wMeChairId] == 0L && m_cbDynamicJoin == FALSE
			&& wMeChairId != pStatusScore->wBankerUser)
		{
			//下注时间
			UINT nElapse = TIME_LESS + (rand() % TIME_USER_ADD_SCORE);
			m_pIAndroidUserItem->SetGameTimer(IDI_USER_ADD_SCORE, nElapse);
		}

		return true;
	}
	case GS_TK_PLAYING:	//游戏状态
	{
		//效验数据
		if (wDataSize != sizeof(CMD_S_StatusPlay))
		{
			return false;
		}

		CMD_S_StatusPlay * pStatusPlay = (CMD_S_StatusPlay *)pData;

		m_cbDynamicJoin = pStatusPlay->cbDynamicJoin;

		ReadConfigInformation(&(pStatusPlay->CustomAndroid));

		BankOperate(2);

		m_bgtConfig = pStatusPlay->bgtConfig;
		m_btConfig = pStatusPlay->btConfig;
		m_lCellScore = pStatusPlay->lCellScore;

		CopyMemory(m_lFreeConfig, pStatusPlay->lFreeConfig, sizeof(m_lFreeConfig));
		CopyMemory(m_lPercentConfig, pStatusPlay->lPercentConfig, sizeof(m_lPercentConfig));

		//设置变量
		m_lTurnMaxScore = pStatusPlay->lTurnMaxScore;
		WORD wMeChiarID = m_pIAndroidUserItem->GetChairID();

		CopyMemory(m_cbHandCardData, pStatusPlay->cbHandCardData[wMeChiarID], MAX_CARDCOUNT);

		//控件处理
		if (pStatusPlay->bOpenCard[wMeChiarID] == false && m_cbDynamicJoin == FALSE)
		{
			//开牌时间
			UINT nElapse = TIME_LESS + 2 + (rand() % TIME_USER_OPEN_CARD);
			m_pIAndroidUserItem->SetGameTimer(IDI_OPEN_CARD, nElapse);
		}

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

//游戏开始
bool CAndroidUserItemSink::OnSubGameStart(const void * pBuffer, WORD wDataSize)
{
	//效验数据
	if (wDataSize != sizeof(CMD_S_GameStart))
	{
		return false;
	}

	CMD_S_GameStart * pGameStart = (CMD_S_GameStart *)pBuffer;

	//设置变量
	m_lTurnMaxScore = pGameStart->lTurnMaxScore;

	CopyMemory(m_cbHandCardData, pGameStart->cbCardData[m_pIAndroidUserItem->GetChairID()], sizeof(m_cbHandCardData));

	m_bgtConfig = pGameStart->bgtConfig;
	m_btConfig = pGameStart->btConfig;

	CopyMemory(m_lFreeConfig, pGameStart->lFreeConfig, sizeof(m_lFreeConfig));
	CopyMemory(m_lPercentConfig, pGameStart->lPercentConfig, sizeof(m_lPercentConfig));

	//设置筹码
	if (pGameStart->lTurnMaxScore > 0 && m_cbDynamicJoin == FALSE && m_pIAndroidUserItem->GetChairID() != pGameStart->wBankerUser)
	{
		//下注时间
		UINT nElapse = TIME_LESS + (rand() % TIME_USER_ADD_SCORE);
		m_pIAndroidUserItem->SetGameTimer(IDI_USER_ADD_SCORE, nElapse);
	}

	return true;
}

//用户下注
bool CAndroidUserItemSink::OnSubAddScore(const void * pBuffer, WORD wDataSize)
{
	//AI不处理用户下注
	return true;
}

//用户强退
bool CAndroidUserItemSink::OnSubPlayerExit(const void * pBuffer, WORD wDataSize)
{
	//AI不处理用户强退
	return true;
}

//发牌消息
bool CAndroidUserItemSink::OnSubSendCard(const void * pBuffer, WORD wDataSize)
{
	//效验数据
	if (wDataSize != sizeof(CMD_S_SendCard))
	{
		return false;
	}

	CMD_S_SendCard * pSendCard = (CMD_S_SendCard *)pBuffer;

	//设置数据
	WORD wMeChiarID = m_pIAndroidUserItem->GetChairID();
	CopyMemory(m_cbHandCardData, pSendCard->cbCardData[wMeChiarID], sizeof(m_cbHandCardData));

	//开牌时间
	if (m_cbDynamicJoin == FALSE)
	{
		UINT nElapse = TIME_LESS + 2 + (rand() % TIME_USER_OPEN_CARD);
		m_pIAndroidUserItem->SetGameTimer(IDI_OPEN_CARD, nElapse);
	}

	return true;
}

//游戏结束
bool CAndroidUserItemSink::OnSubGameEnd(const void * pBuffer, WORD wDataSize)
{
	//效验参数
	if (wDataSize != sizeof(CMD_S_GameEnd))
	{
		return false;
	}

	CMD_S_GameEnd * pGameEnd = (CMD_S_GameEnd *)pBuffer;

	//删除定时器
	m_pIAndroidUserItem->KillGameTimer(IDI_CALL_BANKER);
	m_pIAndroidUserItem->KillGameTimer(IDI_USER_ADD_SCORE);
	m_pIAndroidUserItem->KillGameTimer(IDI_OPEN_CARD);

	BankOperate(2);

	UINT nElapse = rand() % TIME_LESS + (rand() % TIME_USER_START_GAME) + 7;
	m_pIAndroidUserItem->SetGameTimer(IDI_START_GAME, nElapse);

	//清理变量
	m_lTurnMaxScore = 0;
	ZeroMemory(m_cbHandCardData, sizeof(m_cbHandCardData));

	m_cbDynamicJoin = FALSE;

	return true;
}

//用户摊牌
bool CAndroidUserItemSink::OnSubOpenCard(const void * pBuffer, WORD wDataSize)
{
	//效验数据
	if (wDataSize != sizeof(CMD_S_Open_Card))
	{
		return false;
	}

	CMD_S_Open_Card * pOpenCard = (CMD_S_Open_Card *)pBuffer;

	return true;
}

//用户叫庄
bool CAndroidUserItemSink::OnSubCallBanker(const void * pBuffer, WORD wDataSize)
{
	//效验数据
	if (wDataSize != sizeof(CMD_S_CallBanker))
	{
		return false;
	}

	CMD_S_CallBanker * pCallBanker = (CMD_S_CallBanker *)pBuffer;
	m_wBgtRobNewTurnChairID = pCallBanker->wBgtRobNewTurnChairID;

	if (m_cbDynamicJoin == FALSE)
	{
		if ((pCallBanker->wBgtRobNewTurnChairID == INVALID_CHAIR) || (pCallBanker->wBgtRobNewTurnChairID != INVALID_CHAIR && pCallBanker->wBgtRobNewTurnChairID == m_pIAndroidUserItem->GetChairID()))
		{
			//叫庄时间
			UINT nElapse = TIME_LESS + (rand() % TIME_USER_CALL_BANKER);
			m_pIAndroidUserItem->SetGameTimer(IDI_CALL_BANKER, nElapse);
		}
	}

	return true;
}

//用户叫庄信息
bool CAndroidUserItemSink::OnSubCallBankerInfo(const void * pBuffer, WORD wDataSize)
{
	//AI不处理用户叫庄信息
	return true;
}

//银行操作
void CAndroidUserItemSink::BankOperate(BYTE cbType)
{
	//变量定义
	LONGLONG lRobotScore = m_pIAndroidUserItem->GetMeUserItem()->GetUserScore();

	//判断存取
	if (lRobotScore > m_lRobotScoreRange[1])
	{
		LONGLONG lSaveScore = 0L;

		lSaveScore = LONGLONG(lRobotScore*m_nRobotBankStorageMul / 100);
		if (lSaveScore > lRobotScore)
		{
			lSaveScore = lRobotScore;
		}

		if (lSaveScore > 0)
		{
			m_pIAndroidUserItem->PerformSaveScore(lSaveScore);
		}
			
		LONGLONG lRobotNewScore = m_pIAndroidUserItem->GetMeUserItem()->GetUserScore();

		CString strdebug;
		strdebug.Format(TEXT("AIUSERID = 【%d】, 开始存款，此时身上的金币【%I64d】\n"), m_pIAndroidUserItem->GetUserID(), m_pIAndroidUserItem->GetMeUserItem()->GetUserScore());
		WriteInfo(strdebug);

		CString strInfo;
		strInfo.Format(TEXT("[%s] 执行存款：存款前金币(%I64d)，存款后金币(%I64d)"), m_pIAndroidUserItem->GetMeUserItem()->GetNickName(), lRobotScore, lRobotNewScore);

		WriteInfo(strInfo);
	}
	else if (lRobotScore < m_lRobotScoreRange[0])
	{
		CString strInfo;
		LONGLONG lRobotNewScore = m_pIAndroidUserItem->GetMeUserItem()->GetUserScore();

		SCORE lScore = (lRobotNewScore < 0 ? ((-lRobotNewScore) + rand() % m_lRobotBankGetScoreBanker + m_lRobotBankGetScore) : (rand() % m_lRobotBankGetScoreBanker + m_lRobotBankGetScore));

		if (lScore > 0)
		{
			m_pIAndroidUserItem->PerformTakeScore(lScore);
		}
			
		CString strdebug;
		strdebug.Format(TEXT("AIUSERID = 【%d】, 开始取款，此时身上的金币【%I64d】\n"), m_pIAndroidUserItem->GetUserID(), m_pIAndroidUserItem->GetMeUserItem()->GetUserScore());
		WriteInfo(strdebug);

		strInfo.Format(TEXT("[%s] 执行取款：取款前金币(%I64d)，取款后金币(%I64d)"), m_pIAndroidUserItem->GetMeUserItem()->GetNickName(), lRobotScore, lRobotNewScore);

		WriteInfo(strInfo);
	}
}

//写日志文件
void CAndroidUserItemSink::WriteInfo(LPCTSTR pszString)
{
	//韩湘 2020/01/05 屏蔽机器人日志
#ifndef DEBUG
	return;
#endif // !DEBUG

	//设置语言区域
	char* old_locale = _strdup(setlocale(LC_CTYPE, NULL));
	setlocale(LC_CTYPE, "chs");

	CStdioFile myFile;
	CString strFileName = TEXT("新六人牛牛AI存取款记录.txt");
	BOOL bOpen = myFile.Open(strFileName, CFile::modeReadWrite | CFile::modeCreate | CFile::modeNoTruncate);
	if (bOpen)
	{
		myFile.SeekToEnd();
		myFile.WriteString(pszString);
		myFile.Flush();
		myFile.Close();
	}

	//还原区域设定
	setlocale(LC_CTYPE, old_locale);
	free(old_locale);
}

//读取配置
void CAndroidUserItemSink::ReadConfigInformation(tagCustomAndroid *pCustomAndroid)
{
	m_lRobotScoreRange[0] = pCustomAndroid->lRobotScoreMin;
	m_lRobotScoreRange[1] = pCustomAndroid->lRobotScoreMax;

	if (m_lRobotScoreRange[1] < m_lRobotScoreRange[0])
	{
		m_lRobotScoreRange[1] = m_lRobotScoreRange[0];
	}
		
	m_lRobotBankGetScore = pCustomAndroid->lRobotBankGet;
	m_lRobotBankGetScoreBanker = pCustomAndroid->lRobotBankGetBanker;
	m_nRobotBankStorageMul = pCustomAndroid->lRobotBankStoMul;

	if (m_nRobotBankStorageMul<0 || m_nRobotBankStorageMul>100)
	{
		m_nRobotBankStorageMul = 20;
	}
}


//组件创建函数
DECLARE_CREATE_MODULE(AndroidUserItemSink);

//////////////////////////////////////////////////////////////////////////

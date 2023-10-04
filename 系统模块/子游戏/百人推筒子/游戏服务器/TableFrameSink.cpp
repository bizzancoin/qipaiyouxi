#include "StdAfx.h"
#include "TableFrameSink.h"

//////////////////////////////////////////////////////////////////////////

//常量定义
#define SEND_COUNT					600									//发送次数

//索引定义
#define INDEX_PLAYER				0									//闲家索引
#define INDEX_BANKER				1									//庄家索引

//下注时间
#define IDI_FREE					1									//空闲时间
#ifdef _DEBUG
#define TIME_FREE					6									//空闲时间
#else
#define TIME_FREE					10									//空闲时间
#endif

//下注时间
#define IDI_PLACE_JETTON			2									//下注时间

#ifdef _DEBUG
#define TIME_PLACE_JETTON			5									//下注时间
#else
#define TIME_PLACE_JETTON			15									//下注时间
#endif

//结束时间
#define IDI_GAME_END				3									//结束时间

#ifdef _DEBUG
#define TIME_GAME_END				20									//结束时间
#else
#define TIME_GAME_END				20									//结束时间
#endif

//////////////////////////////////////////////////////////////////////////

//静态变量
const WORD			CTableFrameSink::m_wPlayerCount=GAME_PLAYER;				//游戏人数

//////////////////////////////////////////////////////////////////////////

//构造函数
CTableFrameSink::CTableFrameSink()
{
	//总下注数
	ZeroMemory(m_lAllJettonScore,sizeof(m_lAllJettonScore));
	
	//个人下注
	ZeroMemory(m_lUserJettonScore,sizeof(m_lUserJettonScore));


	//玩家成绩	
	ZeroMemory(m_lUserWinScore,sizeof(m_lUserWinScore));
	ZeroMemory(m_lUserReturnScore,sizeof(m_lUserReturnScore));
	ZeroMemory(m_lUserRevenue,sizeof(m_lUserRevenue));

	//扑克信息
	ZeroMemory(m_cbCardCount,sizeof(m_cbCardCount));
	ZeroMemory(m_cbTableCardArray,sizeof(m_cbTableCardArray));

	ZeroMemory(m_cbTableHavaSendCardArray,sizeof(m_cbTableHavaSendCardArray));
	ZeroMemory(m_cbTableHavaSendCount,sizeof(m_cbTableHavaSendCount));

	ZeroMemory(m_bUserListWin, sizeof(m_bUserListWin));
	ZeroMemory(m_lUserListScore, sizeof(m_lUserListScore));
	ZeroMemory(m_cbUserPlayCount, sizeof(m_cbUserPlayCount));

	//状态变量
	m_dwJettonTime=0L;

	m_cbJuControl = FALSE;
	m_cbJuControlTimes = 0;
	ZeroMemory(m_cbJuControlArea, sizeof(m_cbJuControlArea));

	//庄家信息
	m_ApplyUserArray.RemoveAll();
	m_wCurrentBanker=INVALID_CHAIR;
	m_wBankerTime=0;
	m_lBankerWinScore=0L;		
	m_lBankerCurGameScore=0L;
	m_cbLeftCardCount=0;

	m_lSysBankerScore = 10000000;

	//记录变量
	ZeroMemory(m_GameRecordArrary,sizeof(m_GameRecordArrary));
	m_nRecordFirst=0;
	m_nRecordLast=0;

	//机器人控制
	ZeroMemory(m_lRobotAreaScore, sizeof(m_lRobotAreaScore));

	return;
}

//析构函数
CTableFrameSink::~CTableFrameSink(void)
{

}

//释放对象
VOID  CTableFrameSink::Release()
{
	delete this;
}

//接口查询
void *  CTableFrameSink::QueryInterface(REFGUID Guid, DWORD dwQueryVer)
{
	QUERYINTERFACE(ITableFrameSink,Guid,dwQueryVer);
	QUERYINTERFACE(ITableUserAction,Guid,dwQueryVer);	
	QUERYINTERFACE_IUNKNOWNEX(ITableFrameSink,Guid,dwQueryVer);
	return NULL;
}

//初始化
bool  CTableFrameSink::Initialization(IUnknownEx * pIUnknownEx)
{
	//查询接口
	ASSERT(pIUnknownEx!=NULL);
	m_pITableFrame=QUERY_OBJECT_PTR_INTERFACE(pIUnknownEx,ITableFrame);
	if (m_pITableFrame==NULL) return false;

	m_pITableFrame->SetStartMode(START_MODE_ALL_READY);

	//游戏配置
	m_pGameServiceAttrib=m_pITableFrame->GetGameServiceAttrib();
	m_pGameServiceOption=m_pITableFrame->GetGameServiceOption();

	//设置文件名
	TCHAR szPath[MAX_PATH] = TEXT("");
	GetCurrentDirectory(sizeof(szPath), szPath);
	myprintf(m_szConfigFileName, sizeof(m_szConfigFileName), TEXT("%s\\BaiRenConfig\\TongziConfig-%d-%d.ini"), szPath, m_pGameServiceOption->wServerID, m_pITableFrame->GetTableID());

	ReadConfigInformation(true);


	return true;
}

//复位桌子
VOID  CTableFrameSink::RepositionSink()
{
	//总下注数
	ZeroMemory(m_lAllJettonScore,sizeof(m_lAllJettonScore));
	
	//个人下注
	ZeroMemory(m_lUserJettonScore,sizeof(m_lUserJettonScore));

	//玩家成绩	
	ZeroMemory(m_lUserWinScore,sizeof(m_lUserWinScore));
	ZeroMemory(m_lUserReturnScore,sizeof(m_lUserReturnScore));
	ZeroMemory(m_lUserRevenue,sizeof(m_lUserRevenue));

	//机器人控制
	ZeroMemory(m_lRobotAreaScore, sizeof(m_lRobotAreaScore));

	ZeroMemory(m_cbTableCardArray, sizeof(m_cbTableCardArray));

	return;
}

//游戏开始
bool  CTableFrameSink::OnEventGameStart()
{
	//如果剩下牌不足了  重新洗所有牌
	if (m_cbLeftCardCount < 8)
	{
		m_GameLogic.RandCardList(m_cbTableCard, CountArray(m_cbTableCard));
		m_cbLeftCardCount = CountArray(m_cbTableCard);

		ZeroMemory(m_cbTableHavaSendCardArray, sizeof(m_cbTableHavaSendCardArray));
		ZeroMemory(m_cbTableHavaSendCount, sizeof(m_cbTableHavaSendCount));
	}

	//变量定义
	CMD_S_GameStart GameStart;
	ZeroMemory(&GameStart,sizeof(GameStart));

	//获取庄家
	IServerUserItem *pIBankerServerUserItem=NULL;
	if (INVALID_CHAIR!=m_wCurrentBanker) 
	{
		pIBankerServerUserItem=m_pITableFrame->GetTableUserItem(m_wCurrentBanker);
		m_lBankerScore=pIBankerServerUserItem->GetUserScore();
	}

	//设置变量
	GameStart.cbTimeLeave=m_nPlaceJettonTime;
	GameStart.wBankerUser=m_wCurrentBanker;
	if (pIBankerServerUserItem!=NULL) 
		GameStart.lBankerScore=m_lBankerScore;
	else
		GameStart.lBankerScore = m_lSysBankerScore;

	GameStart.bContiueCard=true;

	//m_wBankerTime

	GameStart.cbLeftCardCount=m_cbLeftCardCount+8;

	for (int i = 0;i<4;i++)
	{	
		CopyMemory(GameStart.cbTableHavaSendCardArray[i],m_cbTableHavaSendCardArray[i],CountArray(m_cbTableHavaSendCardArray[i]));
	}

	CopyMemory(GameStart.cbTableHavaSendCount,m_cbTableHavaSendCount,CountArray(m_cbTableHavaSendCount));

    
	//下注机器人数量
	int nChipRobotCount = 0;
	for (int i = 0; i < GAME_PLAYER; i++)
	{
		IServerUserItem *pIServerUserItem=m_pITableFrame->GetTableUserItem(i);
		if (pIServerUserItem != NULL && pIServerUserItem->IsAndroidUser())
			nChipRobotCount++;
	}

	//机器人控制
	ZeroMemory(m_lRobotAreaScore, sizeof(m_lRobotAreaScore));

	FillMemory(GameStart.wSeatUser, sizeof(GameStart.wSeatUser), INVALID_CHAIR);

	OnGetUserListGameID(GameStart.wSeatUser);
	
	//旁观玩家
	m_pITableFrame->SendLookonData(INVALID_CHAIR,SUB_S_GAME_START,&GameStart,sizeof(GameStart));	

	//游戏玩家
	for (WORD wChairID=0; wChairID<GAME_PLAYER; ++wChairID)
	{
		IServerUserItem *pIServerUserItem=m_pITableFrame->GetTableUserItem(wChairID);
		if (pIServerUserItem==NULL) continue;

		//设置积分
		GameStart.lUserMaxScore=min(pIServerUserItem->GetUserScore(),m_lUserLimitScore);

		m_pITableFrame->SendTableData(wChairID,SUB_S_GAME_START,&GameStart,sizeof(GameStart));	
	}

	return true;
}

//游戏结束
bool  CTableFrameSink::OnEventGameConclude(WORD wChairID, IServerUserItem * pIServerUserItem, BYTE cbReason)
{
	switch (cbReason)
	{
	case GER_NORMAL:		//常规结束	
		{

			tag_TongZi_Parameter TongZi_Parameter;
			ZeroMemory(&TongZi_Parameter, sizeof(TongZi_Parameter));

			TongZi_Parameter.wBankerUser = m_wCurrentBanker;
			TongZi_Parameter.cbJuControl = m_cbJuControl;
			CopyMemory(TongZi_Parameter.cbJuControlArea, m_cbJuControlArea, sizeof(TongZi_Parameter.cbJuControlArea));
			CopyMemory(TongZi_Parameter.lPlayBet, m_lUserJettonScore, sizeof(TongZi_Parameter.lPlayBet));
			TongZi_Parameter.cbLeftCardCount = m_cbLeftCardCount;
			CopyMemory(TongZi_Parameter.cbTableCard, m_cbTableCard, sizeof(TongZi_Parameter.cbTableCard));

			tag_TongZi_Result pTongZi_Result;
			ZeroMemory(&pTongZi_Result, sizeof(pTongZi_Result));
			m_pITableFrame->GetControlResult(&TongZi_Parameter, sizeof(TongZi_Parameter), &pTongZi_Result);

			if (pTongZi_Result.cbTableCardArray[0][0] != 0)
			{
				CopyMemory(m_cbTableCardArray, pTongZi_Result.cbTableCardArray, sizeof(m_cbTableCardArray));
				m_cbCardCount[0] = 2;
				m_cbCardCount[1] = 2;
				m_cbCardCount[2] = 2;
				m_cbCardCount[3] = 2;
			}
			else
				CopyMemory(&m_cbTableCardArray[0][0], m_cbTableCard, sizeof(m_cbTableCardArray));

			if (m_cbJuControlTimes > 0)
				m_cbJuControlTimes--;
			if (m_cbJuControlTimes == 0)
			{
				m_cbJuControl = FALSE;
				ZeroMemory(m_cbJuControlArea, sizeof(m_cbJuControlArea));
			}

			//整理牌组
			{
				BYTE cbCardBuffer[8] = {0};
				CopyMemory(cbCardBuffer, m_cbTableCardArray, sizeof(cbCardBuffer));
				m_GameLogic.RemoveCard(cbCardBuffer,8,m_cbTableCard,m_cbLeftCardCount);
				m_cbLeftCardCount -= 8;
			}

			m_cbTableCardArray[0][0] = 0x04;
			m_cbTableCardArray[0][1] = 0x06;

			//计算分数
			SCORE lBankerWinScore = CalculateScore();

			//递增次数
			m_wBankerTime++;

			//结束消息
			CMD_S_GameEnd GameEnd;
			ZeroMemory(&GameEnd,sizeof(GameEnd));

			//列表玩家信息
			for (WORD i = 0; i < GAME_PLAYER; i++)
			{
				IServerUserItem *pServerUser = m_pITableFrame->GetTableUserItem(i);
				if (!pServerUser) continue;

				if (m_lUserWinScore[i] > 0)
				{
					m_bUserListWin[i][m_cbUserPlayCount[i]] = true;
				}

				SCORE lAddScore = 0;
				for (BYTE j = 1; j < AREA_MAX + 1; j++)
				{
					lAddScore += m_lUserJettonScore[i][j];
				}
				m_lUserListScore[i][m_cbUserPlayCount[i]] = lAddScore;
				m_cbUserPlayCount[i] ++;

				if (m_cbUserPlayCount[i] == USER_LIST_COUNT)
					m_cbUserPlayCount[i] = 0;
			}

			bool static bWinShangMen, bWinTianMen, bWinXiaMen;
			DeduceWinner(bWinShangMen, bWinTianMen, bWinXiaMen);

			if (bWinShangMen && bWinTianMen && bWinXiaMen)
				GameEnd.cbBankerTong = 2;
			else if (!bWinShangMen && !bWinTianMen && !bWinXiaMen)
				GameEnd.cbBankerTong = 1;

			GameEnd.cbWinArea[1] = bWinShangMen ? TRUE : FALSE;
			GameEnd.cbWinArea[2] = bWinTianMen ? TRUE : FALSE;
			GameEnd.cbWinArea[3] = bWinXiaMen ? TRUE : FALSE;

			//庄家信息
			GameEnd.nBankerTime = m_wBankerTime;
			GameEnd.lBankerTotallScore=m_lBankerWinScore;
			GameEnd.lBankerScore=lBankerWinScore;

			if (m_wCurrentBanker == INVALID_CHAIR)
			{
				m_lSysBankerScore += lBankerWinScore;
				GameEnd.lBankerHaveScore = m_lSysBankerScore;
			}

			//扑克信息
			CopyMemory(GameEnd.cbTableCardArray,m_cbTableCardArray,sizeof(m_cbTableCardArray));

			GameEnd.cbLeftCardCount=m_cbLeftCardCount;
			for (int i = 0;i<4;i++)
			{
				CopyMemory(&m_cbTableHavaSendCardArray[i][m_cbTableHavaSendCount[i]],GameEnd.cbTableCardArray[i],2);		
				m_cbTableHavaSendCount[i]+=2;
				CopyMemory(GameEnd.cbTableHavaSendCardArray[i],m_cbTableHavaSendCardArray[i],sizeof(m_cbTableHavaSendCardArray[i]));
			}
			
			CopyMemory(GameEnd.cbTableHavaSendCount,m_cbTableHavaSendCount,sizeof(m_cbTableHavaSendCount));

			for (int i = 0; i < 4; i++)
			{
				GameEnd.cbCardType[i] = m_GameLogic.GetCardType(m_cbTableCardArray[i],2);
			}

			//占位玩家成绩
			WORD wSeatUser[MAX_SEAT_COUNT];
			FillMemory(wSeatUser, sizeof(wSeatUser), INVALID_CHAIR);
			OnGetUserListGameID(wSeatUser);

			for (WORD i = 0; i < MAX_SEAT_COUNT; i++)
			{
				if (wSeatUser[i] != INVALID_CHAIR)
				{
					GameEnd.lSeatScore[i] = m_lUserWinScore[wSeatUser[i]];
				}
			}

			//发送积分
			GameEnd.cbTimeLeave=m_nGameEndTime;	

			for ( WORD wUserIndex = 0; wUserIndex < GAME_PLAYER; ++wUserIndex )
			{
				IServerUserItem *pIServerUserItem = m_pITableFrame->GetTableUserItem(wUserIndex);
				if ( pIServerUserItem == NULL ) continue;

				//设置成绩
				GameEnd.lUserScore=m_lUserWinScore[wUserIndex];

				//返还积分
				GameEnd.lUserReturnScore=m_lUserReturnScore[wUserIndex];

				//设置税收
				if (m_lUserRevenue[wUserIndex]>0) GameEnd.lRevenue=m_lUserRevenue[wUserIndex];
				else if (m_wCurrentBanker!=INVALID_CHAIR) GameEnd.lRevenue=m_lUserRevenue[m_wCurrentBanker];
				else GameEnd.lRevenue=0;

				//发送消息					
				m_pITableFrame->SendTableData(wUserIndex,SUB_S_GAME_END,&GameEnd,sizeof(GameEnd));
				m_pITableFrame->SendLookonData(wUserIndex,SUB_S_GAME_END,&GameEnd,sizeof(GameEnd));

				if (!pIServerUserItem->IsAndroidUser())
				{
					m_pGameServiceOption->pRoomStorageOption.lStorageCurrent -= GameEnd.lUserScore;
				}
			}

			//修改积分
			tagScoreInfo ScoreInfoArray[GAME_PLAYER];
			ZeroMemory(ScoreInfoArray, sizeof(ScoreInfoArray));

			//写入积分
			for (WORD wUserChairID = 0; wUserChairID < GAME_PLAYER; ++wUserChairID)
			{
				IServerUserItem *pIServerUserItem = m_pITableFrame->GetTableUserItem(wUserChairID);
				if (pIServerUserItem == NULL) continue;

				//胜利类型
				//enScoreKind ScoreKind=(m_lUserWinScore[wUserChairID]>0L)?enScoreKind_Win:enScoreKind_Lost;

				ScoreInfoArray[wUserChairID].lScore = m_lUserWinScore[wUserChairID];
				ScoreInfoArray[wUserChairID].cbType = (m_lUserWinScore[wUserChairID]>0L) ? SCORE_TYPE_WIN : SCORE_TYPE_LOSE;;
				ScoreInfoArray[wUserChairID].lRevenue = m_lUserRevenue[wUserChairID];
				//写入积分
				//if (m_lUserWinScore[wUserChairID]!=0L) m_pITableFrame->WriteUserScore(wUserChairID,m_lUserWinScore[wUserChairID], m_lUserRevenue[wUserChairID], ScoreKind);

			}

			m_pITableFrame->WriteTableScore(ScoreInfoArray, CountArray(ScoreInfoArray));

			return true;
		}
	case GER_USER_LEAVE:		//用户离开
	case GER_NETWORK_ERROR:
		{
			return true;
		}
	}

	return false;
}

//发送场景
bool  CTableFrameSink::OnEventSendGameScene(WORD wChiarID, IServerUserItem * pIServerUserItem, BYTE cbGameStatus, bool bSendSecret)
{
	switch (cbGameStatus)
	{
	case GAME_STATUS_FREE:			//空闲状态
		{
			//发送记录
			SendGameRecord(pIServerUserItem);

			//构造数据
			CMD_S_StatusFree StatusFree;
			ZeroMemory(&StatusFree,sizeof(StatusFree));			

			FillMemory(StatusFree.wSeatUser, sizeof(StatusFree.wSeatUser), INVALID_CHAIR);

			//控制信息
			StatusFree.lApplyBankerCondition = m_lApplyBankerCondition;
			StatusFree.lAreaLimitScore = m_lAreaLimitScore;

			//扑克信息
			StatusFree.cbLeftCardCount=m_cbLeftCardCount;
			for (int i = 0;i<4;i++)
			{	
				CopyMemory(StatusFree.cbTableHavaSendCardArray[i],m_cbTableHavaSendCardArray[i],CountArray(m_cbTableHavaSendCardArray[i]));
			}

			CopyMemory(StatusFree.cbTableHavaSendCount,m_cbTableHavaSendCount,CountArray(m_cbTableHavaSendCount));

			//庄家信息
			StatusFree.wBankerUser=m_wCurrentBanker;	
			StatusFree.cbBankerTime=m_wBankerTime;
			StatusFree.lBankerWinScore=m_lBankerWinScore;
			if (m_wCurrentBanker!=INVALID_CHAIR)
			{
				IServerUserItem *pIServerUserItem=m_pITableFrame->GetTableUserItem(m_wCurrentBanker);
				StatusFree.lBankerScore=pIServerUserItem->GetUserScore();
			}
			else
				StatusFree.lBankerScore = m_lSysBankerScore;

			//玩家信息
			if (pIServerUserItem->GetUserStatus()!=US_LOOKON)
			{
				StatusFree.lUserMaxScore=min(pIServerUserItem->GetUserScore(),m_lUserLimitScore); 
			}

			//房间名称
			CopyMemory(StatusFree.szGameRoomName, m_pGameServiceOption->szServerName, sizeof(StatusFree.szGameRoomName));

			//全局信息
			DWORD dwPassTime=(DWORD)time(NULL)-m_dwJettonTime;
			StatusFree.cbTimeLeave=(BYTE)(m_nFreeTime-(__min(dwPassTime,m_nFreeTime)));

			OnGetUserListGameID(StatusFree.wSeatUser);

			//发送场景
			bool bSuccess = m_pITableFrame->SendGameScene(pIServerUserItem,&StatusFree,sizeof(StatusFree));
						
			//发送申请者
			SendApplyUser(pIServerUserItem);

			//发送机器人信息
			if (pIServerUserItem && pIServerUserItem->IsAndroidUser())
			{
				CMD_S_AndroidInit AndroidInit;
				ZeroMemory(&AndroidInit, sizeof(AndroidInit));
				memcpy(AndroidInit.szRoomName, TEXT("百人二八杠"), sizeof(AndroidInit.szRoomName));
				memcpy(AndroidInit.szConfigName, m_szConfigFileName, sizeof(AndroidInit.szConfigName));
				m_pITableFrame->SendTableData(pIServerUserItem->GetChairID(), SUB_ANDROID_INIT, &AndroidInit, sizeof(AndroidInit));
			}

			return bSuccess;
		}
	case GS_PLACE_JETTON:		//游戏状态
	case GS_GAME_END:			//结束状态
		{
			//发送记录
			SendGameRecord(pIServerUserItem);		

			//构造数据
			CMD_S_StatusPlay StatusPlay={0};

			FillMemory(StatusPlay.wSeatUser, sizeof(StatusPlay.wSeatUser), INVALID_CHAIR);

			//全局下注
			CopyMemory(StatusPlay.lAllJettonScore,m_lAllJettonScore,sizeof(StatusPlay.lAllJettonScore));

			//玩家下注
			if (pIServerUserItem->GetUserStatus()!=US_LOOKON)
			{
				for (int nAreaIndex=1; nAreaIndex<=AREA_COUNT; ++nAreaIndex)
					StatusPlay.lUserJettonScore[nAreaIndex] = m_lUserJettonScore[wChiarID][nAreaIndex];

				//最大下注
				StatusPlay.lUserMaxScore=min(pIServerUserItem->GetUserScore(),m_lUserLimitScore);
			}

			//控制信息
			StatusPlay.lApplyBankerCondition=m_lApplyBankerCondition;		
			StatusPlay.lAreaLimitScore=m_lAreaLimitScore;		

			//庄家信息
			StatusPlay.wBankerUser=m_wCurrentBanker;			
			StatusPlay.cbBankerTime=m_wBankerTime;
			StatusPlay.lBankerWinScore=m_lBankerWinScore;	


			StatusPlay.cbLeftCardCount=m_cbLeftCardCount;
			for (int i = 0;i<4;i++)
			{
				CopyMemory(StatusPlay.cbTableHavaSendCardArray[i],m_cbTableHavaSendCardArray[i],CountArray(m_cbTableHavaSendCardArray[i]));
			}

			CopyMemory(StatusPlay.cbTableHavaSendCount,m_cbTableHavaSendCount,CountArray(m_cbTableHavaSendCount));


			if (m_wCurrentBanker!=INVALID_CHAIR)
			{
				IServerUserItem *pIServerUserItem=m_pITableFrame->GetTableUserItem(m_wCurrentBanker);
				StatusPlay.lBankerScore=pIServerUserItem->GetUserScore();
			}
			else
				StatusPlay.lBankerScore = m_lSysBankerScore;

			//房间名称
			CopyMemory(StatusPlay.szGameRoomName, m_pGameServiceOption->szServerName, sizeof(StatusPlay.szGameRoomName));

			//全局信息
			DWORD dwPassTime=(DWORD)time(NULL)-m_dwJettonTime;
			StatusPlay.cbTimeLeave = (BYTE)(m_nGameEndTime - (__min(dwPassTime, m_nGameEndTime)));
			if (cbGameStatus == GS_PLACE_JETTON)
				StatusPlay.cbTimeLeave = (BYTE)(m_nPlaceJettonTime - (__min(dwPassTime, m_nPlaceJettonTime)));
			StatusPlay.cbGameStatus=m_pITableFrame->GetGameStatus();			

			//结束判断
			if (cbGameStatus==GS_GAME_END)
			{
				//设置成绩
				StatusPlay.lEndUserScore=m_lUserWinScore[wChiarID];

				bool static bWinShangMen, bWinTianMen, bWinXiaMen;
				DeduceWinner(bWinShangMen, bWinTianMen, bWinXiaMen);

				if (bWinShangMen && bWinTianMen && bWinXiaMen)
					StatusPlay.cbBankerTong = 2;
				else if (!bWinShangMen && !bWinTianMen && !bWinXiaMen)
					StatusPlay.cbBankerTong = 1;

				StatusPlay.cbWinArea[1] = bWinShangMen ? TRUE : FALSE;
				StatusPlay.cbWinArea[2] = bWinTianMen ? TRUE : FALSE;
				StatusPlay.cbWinArea[3] = bWinXiaMen ? TRUE : FALSE;

				//返还积分
				StatusPlay.lEndUserReturnScore=m_lUserReturnScore[wChiarID];

				//设置税收
				if (m_lUserRevenue[wChiarID]>0) StatusPlay.lEndRevenue=m_lUserRevenue[wChiarID];
				else if (m_wCurrentBanker!=INVALID_CHAIR) StatusPlay.lEndRevenue=m_lUserRevenue[m_wCurrentBanker];
				else StatusPlay.lEndRevenue=0;

				//庄家成绩
				StatusPlay.lEndBankerScore=m_lBankerCurGameScore;

				//占位玩家成绩
				WORD wSeatUser[MAX_SEAT_COUNT];
				FillMemory(wSeatUser, sizeof(wSeatUser), INVALID_CHAIR);
				OnGetUserListGameID(wSeatUser);

				for (WORD i = 0; i < MAX_SEAT_COUNT; i++)
				{
					if (wSeatUser[i] != INVALID_CHAIR)
					{
						StatusPlay.lSeatUserWinScore[i] = m_lUserWinScore[wSeatUser[i]];
					}
				}

				//扑克信息
				CopyMemory(StatusPlay.cbTableCardArray,m_cbTableCardArray,sizeof(m_cbTableCardArray));

				for (int i = 0; i < 4; i++)
				{
					StatusPlay.cbCardType[i] = m_GameLogic.GetCardType(m_cbTableCardArray[i],2);
				}
			}

			//发送申请者
			SendApplyUser( pIServerUserItem );

			OnGetUserListGameID(StatusPlay.wSeatUser);
				
			for (WORD i = 0; i < MAX_SEAT_COUNT; i++)
			{
				if (StatusPlay.wSeatUser[i] != INVALID_CHAIR)
				{
					WORD wSeatChair = StatusPlay.wSeatUser[i];
					CopyMemory(StatusPlay.lSeatUserAreaScore[i], m_lUserJettonScore[wSeatChair], sizeof(StatusPlay.lSeatUserAreaScore[i]));
				}
			}

			//发送场景
			bool bSuccess = m_pITableFrame->SendGameScene(pIServerUserItem, &StatusPlay, sizeof(StatusPlay));

			//发送机器人信息
			if (pIServerUserItem && pIServerUserItem->IsAndroidUser())
			{
				CMD_S_AndroidInit AndroidInit;
				ZeroMemory(&AndroidInit, sizeof(AndroidInit));
				memcpy(AndroidInit.szRoomName, TEXT("百人二八杠"), sizeof(AndroidInit.szRoomName));
				memcpy(AndroidInit.szConfigName, m_szConfigFileName, sizeof(AndroidInit.szConfigName));
				m_pITableFrame->SendTableData(pIServerUserItem->GetChairID(), SUB_ANDROID_INIT, &AndroidInit, sizeof(AndroidInit));
			}
			
			return bSuccess;
		}
	}

	return false;
}

//百人游戏获取游戏记录
void CTableFrameSink::OnGetGameRecord(VOID *GameRecord)
{
	CMD_GF_TongRoomStatus *pRoomStatus = (CMD_GF_TongRoomStatus *)GameRecord;

	pRoomStatus->tagGameInfo.wTableID = m_pITableFrame->GetTableID() + 1;
	pRoomStatus->tagGameInfo.cbGameStatus = m_pITableFrame->GetGameStatus();

	pRoomStatus->tagTimeInfo.cbFreeTime = m_nFreeTime;
	pRoomStatus->tagTimeInfo.cbBetTime = m_nPlaceJettonTime;
	pRoomStatus->tagTimeInfo.cbEndTime = m_nGameEndTime;
	pRoomStatus->tagTimeInfo.cbPassTime = (DWORD)time(NULL) - m_dwJettonTime;

	//客户端只显示48条
	int nIndex = m_nRecordFirst;

	pRoomStatus->cbRecordCount = m_nRecordLast - m_nRecordFirst;
	if (pRoomStatus->cbRecordCount > 20 || m_nRecordLast < m_nRecordFirst)
	{
		pRoomStatus->cbRecordCount = 20;
	}

	int nArrayIndex = 0;

	int nEndIndex = (m_nRecordLast + 1) % MAX_SCORE_HISTORY;

	do
	{
		if (nArrayIndex >= 20)
			break;
		pRoomStatus->GameRecordArrary[nArrayIndex].cbAreaWin[0] = m_GameRecordArrary[nIndex].bWinShangMen;
		pRoomStatus->GameRecordArrary[nArrayIndex].cbAreaWin[1] = m_GameRecordArrary[nIndex].bWinTianMen;
		pRoomStatus->GameRecordArrary[nArrayIndex].cbAreaWin[2] = m_GameRecordArrary[nIndex].bWinXiaMen;

		nArrayIndex++;
		nIndex = (nIndex + 1) % MAX_SCORE_HISTORY;
	} while (nIndex != nEndIndex);
}

//获取百人游戏是否下注状态而且玩家下注了
bool CTableFrameSink::OnGetUserBetInfo(WORD wChairID, IServerUserItem * pIServerUserItem)
{
	if (m_pITableFrame->GetGameStatus() == GAME_SCENE_FREE)
		return false;

	for (WORD wAreaIndex = 1; wAreaIndex < AREA_MAX + 1; ++wAreaIndex)
	{
		if (m_lUserJettonScore[wChairID][wAreaIndex] != 0)
		{
			return true;
		}
	}

	if (wChairID == m_wCurrentBanker)
		return true;

	return false;
}

//定时器事件
bool  CTableFrameSink::OnTimerMessage(DWORD wTimerID, WPARAM wBindParam)
{
	switch (wTimerID)
	{
	case IDI_FREE:		//空闲时间
		{
			if (m_wCurrentBanker==INVALID_CHAIR)
			{
				TrySelectBanker();
			}

			m_pITableFrame->StartGame();

			//设置时间
			m_pITableFrame->SetGameTimer(IDI_PLACE_JETTON,m_nPlaceJettonTime*1000,1,0L);

			//设置状态
			m_pITableFrame->SetGameStatus(GS_PLACE_JETTON);

			//库存衰减
			m_pITableFrame->CalculateStorageDeduct();

			return true;
		}
	case IDI_PLACE_JETTON:		//下注时间
		{
			//状态判断(防止强退重复设置)
			if (m_pITableFrame->GetGameStatus()!=GS_GAME_END)
			{
				//设置状态
				m_pITableFrame->SetGameStatus(GS_GAME_END);			

				//结束游戏
				OnEventGameConclude(INVALID_CHAIR,NULL,GER_NORMAL);

				//设置时间
				m_pITableFrame->SetGameTimer(IDI_GAME_END,m_nGameEndTime*1000,1,0L);			
			}

			return true;
		}
	case IDI_GAME_END:			//结束游戏
		{			
			//写入积分
			for ( WORD wUserChairID = 0; wUserChairID < GAME_PLAYER; ++wUserChairID )
			{
				IServerUserItem *pIServerUserItem = m_pITableFrame->GetTableUserItem(wUserChairID);
				if ( pIServerUserItem == NULL ) continue;

				//坐庄判断
				SCORE lUserScore = pIServerUserItem->GetUserScore();
				if (wUserChairID!=m_wCurrentBanker && lUserScore<m_lApplyBankerCondition)
				{
					for (WORD i=0; i<m_ApplyUserArray.GetCount(); ++i)
					{
						if (wUserChairID!=m_ApplyUserArray[i]) continue;

						//删除玩家
						m_ApplyUserArray.RemoveAt(i);

						//发送消息
						CMD_S_CancelBanker CancelBanker;
						ZeroMemory(&CancelBanker,sizeof(CancelBanker));

						CancelBanker.wCancelUser = pIServerUserItem->GetChairID();
						
						//发送消息
						m_pITableFrame->SendTableData(INVALID_CHAIR, SUB_S_CANCEL_BANKER, &CancelBanker, sizeof(CancelBanker));
						m_pITableFrame->SendLookonData(INVALID_CHAIR, SUB_S_CANCEL_BANKER, &CancelBanker, sizeof(CancelBanker));

						break;
					}
				}
			}

			//结束游戏
			m_pITableFrame->ConcludeGame(GAME_STATUS_FREE);

			//切换庄家
			ChangeBanker(false);

			TrySelectBanker();

			//设置时间
			m_dwJettonTime=(DWORD)time(NULL);
			m_pITableFrame->SetGameTimer(IDI_FREE,m_nFreeTime*1000,1,0L);

			//发送消息
			CMD_S_GameFree GameFree;
			ZeroMemory(&GameFree,sizeof(GameFree));
			GameFree.cbTimeLeave=m_nFreeTime;
			m_pITableFrame->SendTableData(INVALID_CHAIR,SUB_S_GAME_FREE,&GameFree,sizeof(GameFree));
			m_pITableFrame->SendLookonData(INVALID_CHAIR,SUB_S_GAME_FREE,&GameFree,sizeof(GameFree));

			return true;
		}
	}

	return false;
}

//选择庄家
void CTableFrameSink::TrySelectBanker()
{
	if (m_wCurrentBanker==INVALID_CHAIR&&m_ApplyUserArray.GetCount()>0)
	{		
		m_wCurrentBanker = m_ApplyUserArray[0];

		//切换判断
		{
			//设置变量
			m_wBankerTime = 0;
			m_lBankerWinScore=0;

			//发送消息
			CMD_S_ChangeBanker ChangeBanker;
			ZeroMemory(&ChangeBanker,sizeof(ChangeBanker));
			ChangeBanker.wBankerUser=m_wCurrentBanker;
			if (m_wCurrentBanker!=INVALID_CHAIR)
			{
				IServerUserItem *pIServerUserItem=m_pITableFrame->GetTableUserItem(m_wCurrentBanker);
				ChangeBanker.lBankerScore=pIServerUserItem->GetUserScore();
			}
			m_pITableFrame->SendTableData(INVALID_CHAIR,SUB_S_CHANGE_BANKER,&ChangeBanker,sizeof(ChangeBanker));
			m_pITableFrame->SendLookonData(INVALID_CHAIR,SUB_S_CHANGE_BANKER,&ChangeBanker,sizeof(ChangeBanker));
		}
	}
}

//游戏消息处理
bool  CTableFrameSink::OnGameMessage(WORD wSubCmdID, VOID * pDataBuffer, WORD wDataSize, IServerUserItem * pIServerUserItem)
{
	switch (wSubCmdID)
	{
	case SUB_C_PLACE_JETTON:		//用户加注
		{
			//效验数据
			ASSERT(wDataSize==sizeof(CMD_C_PlaceJetton));
			if (wDataSize!=sizeof(CMD_C_PlaceJetton)) return true;

			//用户效验
			tagUserInfo * pUserData=pIServerUserItem->GetUserInfo();
			if (pUserData->cbUserStatus!=US_PLAYING) return true;

			//消息处理
			CMD_C_PlaceJetton * pPlaceJetton=(CMD_C_PlaceJetton *)pDataBuffer;
			return OnUserPlaceJetton(pUserData->wChairID,pPlaceJetton->cbJettonArea,pPlaceJetton->lJettonScore);
		}
	case SUB_C_APPLY_BANKER:		//申请做庄
		{
			//用户效验
			tagUserInfo * pUserData=pIServerUserItem->GetUserInfo();
			if (pUserData->cbUserStatus==US_LOOKON) return true;

			return OnUserApplyBanker(pIServerUserItem);	
		}
	case SUB_C_CANCEL_BANKER:		//取消做庄
		{
			//用户效验
			tagUserInfo * pUserData=pIServerUserItem->GetUserInfo();
			if (pUserData->cbUserStatus==US_LOOKON) return true;

			return OnUserCancelBanker(pIServerUserItem);	
		}
	case SUB_C_ONLINE_PLAYER:		//获取用户列表
		{
			return OnUserRequestUserList(pIServerUserItem->GetChairID());
		}
	case SUB_C_REQUEST_CONTROL:		//控制信息请求
		{
			//权限判断
			if (CUserRight::IsGameCheatUser(pIServerUserItem->GetUserRight()) == false)
				return true;

			CMD_S_ControlInfo ControlInfo;
			ZeroMemory(&ControlInfo, sizeof(ControlInfo));

			ControlInfo.cbJuControl = m_cbJuControl;
			ControlInfo.cbJuControlTimes = m_cbJuControlTimes;

			CopyMemory(ControlInfo.cbJuControlArea, m_cbJuControlArea, sizeof(ControlInfo.cbJuControlArea));
			LONGLONG lUserBetAllScore[GAME_PLAYER] = { 0 };
			BYTE cbIndex = 0;
			for (WORD i = 0; i < GAME_PLAYER; i++)
			{
				IServerUserItem *pServerUser = m_pITableFrame->GetTableUserItem(i);
				if (pServerUser && !pServerUser->IsAndroidUser())
				{
					CopyMemory(ControlInfo.lUserJettonScore[cbIndex], m_lUserJettonScore[i], sizeof(ControlInfo.lUserJettonScore[cbIndex]));
					lstrcpyn(ControlInfo.szNickName[cbIndex], pServerUser->GetNickName(), sizeof(ControlInfo.szNickName[cbIndex]));

					for (BYTE j = 0; j < AREA_MAX; j++)
					{
						lUserBetAllScore[cbIndex] += m_lUserJettonScore[i][j];
						ControlInfo.lAreaJettonScore[j] += m_lUserJettonScore[i][j];
					}

					cbIndex++;
				}
			}

			for (WORD i = 0; i < GAME_PLAYER; i++)
			{
				for (WORD j = i + 1; j < GAME_PLAYER; j++)
				{
					if (lUserBetAllScore[i] < lUserBetAllScore[j])
					{
						LONGLONG lTempScore = lUserBetAllScore[i];
						lUserBetAllScore[i] = lUserBetAllScore[j];
						lUserBetAllScore[j] = lTempScore;

						LONGLONG lAreaTempScore[AREA_MAX] = { 0 };
						CopyMemory(lAreaTempScore, ControlInfo.lUserJettonScore[i], sizeof(lAreaTempScore));
						CopyMemory(ControlInfo.lUserJettonScore[i], ControlInfo.lUserJettonScore[j], sizeof(lAreaTempScore));
						CopyMemory(ControlInfo.lUserJettonScore[j], lAreaTempScore, sizeof(lAreaTempScore));

						TCHAR szTempNick[32] = { 0 };
						CopyMemory(szTempNick, ControlInfo.szNickName[i], sizeof(szTempNick));
						CopyMemory(ControlInfo.szNickName[i], ControlInfo.szNickName[j], sizeof(szTempNick));
						CopyMemory(ControlInfo.szNickName[j], szTempNick, sizeof(szTempNick));
					}
				}
			}

			m_pITableFrame->SendTableData(pIServerUserItem->GetChairID(), SUB_S_RESPONSE_CONTROL, &ControlInfo, sizeof(ControlInfo));

			return true;
		}
	case SUB_C_CONTROL:				//本局控制输赢
		{
			//权限判断
			if (CUserRight::IsGameCheatUser(pIServerUserItem->GetUserRight()) == false)
				return true;

			CMD_C_ControlWinLost *pControlWinLost = (CMD_C_ControlWinLost *)pDataBuffer;

			CopyMemory(m_cbJuControlArea, pControlWinLost->cbJuControlArea, sizeof(m_cbJuControlArea));

			m_cbJuControl = TRUE;
			m_cbJuControlTimes = pControlWinLost->cbControlTimes;

			if (m_cbJuControlTimes < 0 || m_cbJuControlTimes > 5)
			{
				m_cbJuControl = FALSE;
				m_cbJuControlTimes = 0;
				ZeroMemory(m_cbJuControlArea, sizeof(m_cbJuControlArea));
			}

			return true;
		}
	case SUB_C_CANCEL_CONTROL:		//取消本局控制
		{
			//权限判断
			if (CUserRight::IsGameCheatUser(pIServerUserItem->GetUserRight()) == false)
				return true;

			m_cbJuControl = FALSE;
			m_cbJuControlTimes = 0;
			ZeroMemory(m_cbJuControlArea, sizeof(m_cbJuControlArea));

			return true;
		}
	}

	return true;
}

//框架消息处理
bool  CTableFrameSink::OnFrameMessage(WORD wSubCmdID, VOID * pDataBuffer, WORD wDataSize, IServerUserItem * pIServerUserItem)
{
	return false;
}

//用户坐下
bool  CTableFrameSink::OnActionUserSitDown(WORD wChairID, IServerUserItem * pIServerUserItem, bool bLookonUser)
{
	//设置时间
	if ((bLookonUser==false)&&(m_dwJettonTime==0L))
	{
		m_dwJettonTime=(DWORD)time(NULL);
		m_pITableFrame->SetGameTimer(IDI_FREE,m_nFreeTime*1000,1,NULL);
		m_pITableFrame->SetGameStatus(GAME_STATUS_FREE);
	}

	//发送机器人信息
	if (pIServerUserItem && pIServerUserItem->IsAndroidUser())
	{
		CMD_S_AndroidInit AndroidInit;
		ZeroMemory(&AndroidInit, sizeof(AndroidInit));
		memcpy(AndroidInit.szRoomName, TEXT("百人二八杠"), sizeof(AndroidInit.szRoomName));
		memcpy(AndroidInit.szConfigName, m_szConfigFileName, sizeof(AndroidInit.szConfigName));
		m_pITableFrame->SendTableData(pIServerUserItem->GetChairID(), SUB_ANDROID_INIT, &AndroidInit, sizeof(AndroidInit));
	}

	return true;
}

//用户起来
bool  CTableFrameSink::OnActionUserStandUp(WORD wChairID, IServerUserItem * pIServerUserItem, bool bLookonUser)
{

	ZeroMemory(m_bUserListWin[wChairID], sizeof(m_bUserListWin[wChairID]));
	ZeroMemory(m_lUserListScore[wChairID], sizeof(m_lUserListScore[wChairID]));
	m_cbUserPlayCount[wChairID] = 0;

	//记录成绩
	if (bLookonUser==false)
	{
		//切换庄家
		if (wChairID==m_wCurrentBanker)
		{
			ChangeBanker(true);
		}
				
		//取消申请
		for (WORD i=0; i<m_ApplyUserArray.GetCount(); ++i)
		{
			if (wChairID!=m_ApplyUserArray[i]) continue;

			//删除玩家
			m_ApplyUserArray.RemoveAt(i);

			//构造变量
			CMD_S_CancelBanker CancelBanker;
			ZeroMemory(&CancelBanker,sizeof(CancelBanker));

			CancelBanker.wCancelUser = pIServerUserItem->GetChairID();

			//发送消息
			m_pITableFrame->SendTableData(INVALID_CHAIR, SUB_S_CANCEL_BANKER, &CancelBanker, sizeof(CancelBanker));
			m_pITableFrame->SendLookonData(INVALID_CHAIR, SUB_S_CANCEL_BANKER, &CancelBanker, sizeof(CancelBanker));

			break;
		}

		return true;
	}

	return true;
}

//加注事件
bool CTableFrameSink::OnUserPlaceJetton(WORD wChairID, BYTE cbJettonArea, SCORE lJettonScore)
{
	//效验参数
	ASSERT((cbJettonArea <= ID_DI_MEN && cbJettonArea >= ID_SHUN_MEN) && (lJettonScore>0L));
	if ((cbJettonArea>ID_DI_MEN) || (lJettonScore <= 0L) || cbJettonArea<ID_SHUN_MEN) 
		return true;

	//效验状态
	if (m_pITableFrame->GetGameStatus()!=GS_PLACE_JETTON)
	{
		CMD_S_PlaceJettonFail PlaceJettonFail;
		ZeroMemory(&PlaceJettonFail,sizeof(PlaceJettonFail));
		PlaceJettonFail.lJettonArea=cbJettonArea;
		PlaceJettonFail.lPlaceScore=lJettonScore;
		PlaceJettonFail.wPlaceUser=wChairID;

		//发送消息
		m_pITableFrame->SendTableData(wChairID,SUB_S_PLACE_JETTON_FAIL,&PlaceJettonFail,sizeof(PlaceJettonFail));
		return true;
	}

	//庄家判断
	if (m_wCurrentBanker==wChairID) return true;

	//变量定义
	IServerUserItem * pIServerUserItem=m_pITableFrame->GetTableUserItem(wChairID);
	SCORE lJettonCount = 0L;
	for (int nAreaIndex = 1; nAreaIndex <= AREA_COUNT; ++nAreaIndex) 
		lJettonCount += m_lUserJettonScore[wChairID][nAreaIndex];

	//玩家积分
	SCORE lUserScore = pIServerUserItem->GetUserScore();

	//合法校验
	if (lUserScore < lJettonCount + lJettonScore) return true;
	if (m_lUserLimitScore < lJettonCount + lJettonScore) return true;

	//成功标识
	bool bPlaceJettonSuccess=true;

	//合法验证
	if (GetUserMaxJetton(wChairID) >= lJettonScore)
	{
		
		//机器人验证
		if(pIServerUserItem->IsAndroidUser())
		{
			//long lTemp = lJettonScore;
			//MyDebug(_T(" [机器人%d ,最大:%d,请求: %I64d]\r\n"),pIServerUserItem->GetUserID(),GetUserMaxJetton(wChairID),lJettonScore);
			
			//区域限制
			if (m_lRobotAreaScore[cbJettonArea] + lJettonScore > m_lAreaLimitScore)//m_lRobotAreaLimit
				return true;

			//限制机器人只能下注多少
			if (m_wCurrentBanker != INVALID_CHAIR && bPlaceJettonSuccess)
			{
				IServerUserItem *pUser = m_pITableFrame->GetTableUserItem(m_wCurrentBanker);
				if (pUser)
				{
					SCORE lBankerScore = pUser->GetUserScore();
					SCORE lRobotAllJetton = 0;
					for (int nAreaIndex = 1; nAreaIndex <= AREA_COUNT; ++nAreaIndex)
					{
						lRobotAllJetton += m_lRobotAreaScore[nAreaIndex];
					}

					if (lRobotAllJetton > ((lBankerScore * 30) / 100))
					{
						bPlaceJettonSuccess = false;
					}
				}
			}

			//统计分数
			if (bPlaceJettonSuccess)
				m_lRobotAreaScore[cbJettonArea] += lJettonScore;
		}

		
		
		if (bPlaceJettonSuccess)
		{
			//保存下注
			m_lAllJettonScore[cbJettonArea] += lJettonScore;
			m_lUserJettonScore[wChairID][cbJettonArea] += lJettonScore;
		}
	}
	else
	{
		bPlaceJettonSuccess=false;
	}

	if (bPlaceJettonSuccess)
	{
		//变量定义
		CMD_S_PlaceJetton PlaceJetton;
		ZeroMemory(&PlaceJetton,sizeof(PlaceJetton));

		//构造变量
		PlaceJetton.wChairID=wChairID;
		PlaceJetton.cbJettonArea=cbJettonArea;
		PlaceJetton.lJettonScore=lJettonScore;
		PlaceJetton.bIsAndroid=pIServerUserItem->IsAndroidUser();

		PlaceJetton.lUserRestScore = lUserScore - lJettonCount;

		//发送消息
		m_pITableFrame->SendTableData(INVALID_CHAIR,SUB_S_PLACE_JETTON,&PlaceJetton,sizeof(PlaceJetton));
		m_pITableFrame->SendLookonData(INVALID_CHAIR,SUB_S_PLACE_JETTON,&PlaceJetton,sizeof(PlaceJetton));
	}
	else
	{
		CMD_S_PlaceJettonFail PlaceJettonFail;
		ZeroMemory(&PlaceJettonFail,sizeof(PlaceJettonFail));
		PlaceJettonFail.lJettonArea=cbJettonArea;
		PlaceJettonFail.lPlaceScore=lJettonScore;
		PlaceJettonFail.wPlaceUser=wChairID;

		//发送消息
		m_pITableFrame->SendTableData(wChairID,SUB_S_PLACE_JETTON_FAIL,&PlaceJettonFail,sizeof(PlaceJettonFail));
	}

	return true;
}

//申请庄家
bool CTableFrameSink::OnUserApplyBanker(IServerUserItem *pIApplyServerUserItem)
{
	//合法判断
	SCORE lUserScore = pIApplyServerUserItem->GetUserScore();
	if (lUserScore<m_lApplyBankerCondition)
	{
		return true;
	}

	//存在判断
	WORD wApplyUserChairID=pIApplyServerUserItem->GetChairID();
	for (INT_PTR nUserIdx=0; nUserIdx<m_ApplyUserArray.GetCount(); ++nUserIdx)
	{
		WORD wChairID=m_ApplyUserArray[nUserIdx];
		if (wChairID==wApplyUserChairID)
		{
			return true;
		}
	}

	//保存信息 
	m_ApplyUserArray.Add(wApplyUserChairID);

	//构造变量
	CMD_S_ApplyBanker ApplyBanker;
	ZeroMemory(&ApplyBanker,sizeof(ApplyBanker));

	//设置变量
	ApplyBanker.wApplyUser=wApplyUserChairID;

	//发送消息
	m_pITableFrame->SendTableData(INVALID_CHAIR, SUB_S_APPLY_BANKER, &ApplyBanker, sizeof(ApplyBanker));
	m_pITableFrame->SendLookonData(INVALID_CHAIR, SUB_S_APPLY_BANKER, &ApplyBanker, sizeof(ApplyBanker));

	//切换判断
	if (m_pITableFrame->GetGameStatus()==GAME_STATUS_FREE && m_ApplyUserArray.GetCount()==1)
	{
		ChangeBanker(false);
//#ifdef _DEBUG
//
//		WORD wChairID=m_ApplyUserArray[0];
//		m_wCurrentBanker = wChairID;
//		//发送消息
//		CMD_S_ChangeBanker ChangeBanker;
//		ZeroMemory(&ChangeBanker,sizeof(ChangeBanker));
//		ChangeBanker.wBankerUser=m_wCurrentBanker;
//		if (m_wCurrentBanker!=INVALID_CHAIR)
//		{
//			IServerUserItem *pIServerUserItem=m_pITableFrame->GetTableUserItem(m_wCurrentBanker);
//			ChangeBanker.lBankerScore=pIServerUserItem->GetUserScore();
//		}
//		m_pITableFrame->SendTableData(INVALID_CHAIR,SUB_S_CHANGE_BANKER,&ChangeBanker,sizeof(ChangeBanker));
//		m_pITableFrame->SendLookonData(INVALID_CHAIR,SUB_S_CHANGE_BANKER,&ChangeBanker,sizeof(ChangeBanker));
//
//#endif
	}

	return true;
}

//取消申请
bool CTableFrameSink::OnUserCancelBanker(IServerUserItem *pICancelServerUserItem)
{
	//当前庄家
	if (pICancelServerUserItem->GetChairID()==m_wCurrentBanker && m_pITableFrame->GetGameStatus()!=GAME_STATUS_FREE)
	{
		return true;
	}

	//存在判断
	for (WORD i=0; i<m_ApplyUserArray.GetCount(); ++i)
	{
		//获取玩家
		WORD wChairID=m_ApplyUserArray[i];
		IServerUserItem *pIServerUserItem=m_pITableFrame->GetTableUserItem(wChairID);

		//条件过滤
		if (pIServerUserItem==NULL) continue;
		if (pIServerUserItem->GetUserID()!=pICancelServerUserItem->GetUserID()) continue;


		//删除玩家
		m_ApplyUserArray.RemoveAt(i);

		if (m_wCurrentBanker!=wChairID)
		{
			//构造变量
			CMD_S_CancelBanker CancelBanker;
			ZeroMemory(&CancelBanker,sizeof(CancelBanker));

			CancelBanker.wCancelUser = pIServerUserItem->GetChairID(); 

			//发送消息
			m_pITableFrame->SendTableData(INVALID_CHAIR, SUB_S_CANCEL_BANKER, &CancelBanker, sizeof(CancelBanker));
			m_pITableFrame->SendLookonData(INVALID_CHAIR, SUB_S_CANCEL_BANKER, &CancelBanker, sizeof(CancelBanker));
		}
		else if (m_wCurrentBanker==wChairID)
		{
			//切换庄家 
			m_wCurrentBanker=INVALID_CHAIR;
			ChangeBanker(true);
		}
	
		return true;
	}

	return true;
}

//请求用户列表
bool CTableFrameSink::OnUserRequestUserList(WORD wChairID)
{
	CMD_S_UserListInfo UserListInfo[GAME_PLAYER];
	ZeroMemory(UserListInfo, sizeof(UserListInfo));

	BYTE cbListUserCount = 0;

	for (WORD i = 0; i < GAME_PLAYER; i++)
	{
		IServerUserItem *pServerUser = m_pITableFrame->GetTableUserItem(i);
		if (!pServerUser) continue;

		SCORE lAddScore = 0;
		BYTE cbWinCount = 0;

		for (BYTE j = 0; j < USER_LIST_COUNT; j++)
		{
			if (m_bUserListWin[i][j])
				cbWinCount++;
			lAddScore += m_lUserListScore[i][j];
		}

		UserListInfo[cbListUserCount].wWinNum = cbWinCount;
		UserListInfo[cbListUserCount].lAllBet = lAddScore;
		UserListInfo[cbListUserCount].lUserScore = pServerUser->GetUserScore();
		lstrcpyn(UserListInfo[cbListUserCount].szNickName, pServerUser->GetNickName(), CountArray(UserListInfo[cbListUserCount].szNickName));
		UserListInfo[cbListUserCount].wFaceID = pServerUser->GetUserInfo()->wFaceID;
		cbListUserCount++;
	}

	//找出一个获胜局数最多的放第一个
	for (WORD i = 1; i < cbListUserCount; i++)
	{
		bool bExchange = false;
		if (UserListInfo[i].wWinNum > UserListInfo[0].wWinNum)
			bExchange = true;
		else if (UserListInfo[i].wWinNum == UserListInfo[0].wWinNum)
		{
			if (UserListInfo[i].lAllBet > UserListInfo[0].lAllBet)
				bExchange = true;
		}

		if (bExchange)
		{
			CMD_S_UserListInfo UserTempInfo;
			ZeroMemory(&UserTempInfo, sizeof(UserTempInfo));

			CopyMemory(&UserTempInfo, &UserListInfo[i], sizeof(UserTempInfo));
			CopyMemory(&UserListInfo[i], &UserListInfo[0], sizeof(UserTempInfo));
			CopyMemory(&UserListInfo[0], &UserTempInfo, sizeof(UserTempInfo));
		}
	}

	//剩下的按下注量排列
	for (WORD i = 1; i < cbListUserCount; i++)
	{
		for (WORD j = i + 1; j < cbListUserCount; j++)
		{
			if (UserListInfo[j].lAllBet > UserListInfo[i].lAllBet)
			{
				CMD_S_UserListInfo UserTempInfo;
				ZeroMemory(&UserTempInfo, sizeof(UserTempInfo));

				CopyMemory(&UserTempInfo, &UserListInfo[i], sizeof(UserTempInfo));
				CopyMemory(&UserListInfo[i], &UserListInfo[j], sizeof(UserTempInfo));
				CopyMemory(&UserListInfo[j], &UserTempInfo, sizeof(UserTempInfo));
			}
		}
	}

	//然后开始发送了。。。
	BYTE cbMaxTimes = cbListUserCount / 20;
	if (cbListUserCount % 20 != 0)
		cbMaxTimes += 1;

	for (int i = 0; i < cbMaxTimes; i++)
	{
		BYTE cbRestCount = 20;
		if (i == (cbMaxTimes - 1))
			cbRestCount = cbListUserCount % 20;

		CMD_S_UserList UpdateUserList;
		ZeroMemory(&UpdateUserList, sizeof(UpdateUserList));
		UpdateUserList.wCount = cbRestCount;
		if (i != (cbMaxTimes - 1))
			UpdateUserList.bEnd = false;
		else
			UpdateUserList.bEnd = true;

		for (int j = 0; j < cbRestCount; j++)
		{
			UpdateUserList.cbIndex[j] = i * 20 + j;
		}

		for (int j = 0; j < cbRestCount; j++)
			UpdateUserList.cbWinTimes[j] = UserListInfo[i * 20 + j].wWinNum;
		for (int j = 0; j < cbRestCount; j++)
			UpdateUserList.lBetScore[j] = UserListInfo[i * 20 + j].lAllBet;
		for (int j = 0; j < cbRestCount; j++)
			UpdateUserList.lUserScore[j] = UserListInfo[i * 20 + j].lUserScore;


		for (int j = 0; j < cbRestCount; j++)
			lstrcpyn(UpdateUserList.szUserNick[j], UserListInfo[i * 20 + j].szNickName, CountArray(UpdateUserList.szUserNick[j]));

		for (int j = 0; j < cbRestCount; j++)
			UpdateUserList.wFaceID[j] = UserListInfo[i * 20 + j].wFaceID;

		m_pITableFrame->SendTableData(wChairID, SUB_S_ONLINE_PLAYER, &UpdateUserList, sizeof(UpdateUserList));
		m_pITableFrame->SendLookonData(wChairID, SUB_S_ONLINE_PLAYER, &UpdateUserList, sizeof(UpdateUserList));
	}

	return true;
}

//获取前6个用户列表的椅子号
bool CTableFrameSink::OnGetUserListGameID(WORD wSeatUser[MAX_SEAT_COUNT])
{
	CMD_S_UserListInfo UserListInfo[GAME_PLAYER];
	ZeroMemory(UserListInfo, sizeof(UserListInfo));

	BYTE cbListUserCount = 0;

	for (WORD i = 0; i < GAME_PLAYER; i++)
	{
		IServerUserItem *pServerUser = m_pITableFrame->GetTableUserItem(i);
		if (!pServerUser) continue;

		SCORE lAddScore = 0;
		BYTE cbWinCount = 0;

		for (BYTE j = 0; j < USER_LIST_COUNT; j++)
		{
			if (m_bUserListWin[i][j])
				cbWinCount++;
			lAddScore += m_lUserListScore[i][j];
		}

		UserListInfo[cbListUserCount].wWinNum = cbWinCount;
		UserListInfo[cbListUserCount].lAllBet = lAddScore;
		UserListInfo[cbListUserCount].lUserScore = pServerUser->GetUserScore();
		UserListInfo[cbListUserCount].wChairID = pServerUser->GetChairID();
		lstrcpyn(UserListInfo[cbListUserCount].szNickName, pServerUser->GetNickName(), CountArray(UserListInfo[cbListUserCount].szNickName));
		cbListUserCount++;
	}

	//找出一个获胜局数最多的放第一个
	for (WORD i = 1; i < cbListUserCount; i++)
	{
		bool bExchange = false;
		if (UserListInfo[i].wWinNum > UserListInfo[0].wWinNum)
			bExchange = true;
		else if (UserListInfo[i].wWinNum == UserListInfo[0].wWinNum)
		{
			if (UserListInfo[i].lAllBet > UserListInfo[0].lAllBet)
				bExchange = true;
		}

		if (bExchange)
		{
			CMD_S_UserListInfo UserTempInfo;
			ZeroMemory(&UserTempInfo, sizeof(UserTempInfo));

			CopyMemory(&UserTempInfo, &UserListInfo[i], sizeof(UserTempInfo));
			CopyMemory(&UserListInfo[i], &UserListInfo[0], sizeof(UserTempInfo));
			CopyMemory(&UserListInfo[0], &UserTempInfo, sizeof(UserTempInfo));
		}
	}

	//剩下的按下注量排列
	for (WORD i = 1; i < cbListUserCount; i++)
	{
		for (WORD j = i + 1; j < cbListUserCount; j++)
		{
			if (UserListInfo[j].lAllBet > UserListInfo[i].lAllBet)
			{
				CMD_S_UserListInfo UserTempInfo;
				ZeroMemory(&UserTempInfo, sizeof(UserTempInfo));

				CopyMemory(&UserTempInfo, &UserListInfo[i], sizeof(UserTempInfo));
				CopyMemory(&UserListInfo[i], &UserListInfo[j], sizeof(UserTempInfo));
				CopyMemory(&UserListInfo[j], &UserTempInfo, sizeof(UserTempInfo));
			}
		}
	}

	for (int i = 0; i < MAX_SEAT_COUNT; i++)
	{
		if (cbListUserCount > i)
			wSeatUser[i] = UserListInfo[i].wChairID;
	}

	return true;
}

//更换庄家
bool CTableFrameSink::ChangeBanker(bool bCancelCurrentBanker)
{
	//做庄次数
	WORD wBankerTime = m_nBankerTimeLimit;
	SCORE lBigScore = 0;

	bool bChangeBanker =false;

	//取消当前
	if (bCancelCurrentBanker)
	{
		for (WORD i=0; i<m_ApplyUserArray.GetCount(); ++i)
		{
			//获取玩家
			WORD wChairID=m_ApplyUserArray[i];

			//条件过滤
			if (wChairID!=m_wCurrentBanker) continue;

			//删除玩家
			m_ApplyUserArray.RemoveAt(i);

			break;
		}

		//设置庄家
		m_wCurrentBanker=INVALID_CHAIR;

		m_wBankerTime = 0;
		m_lBankerWinScore=0;
		bChangeBanker=true;
	}

	//轮庄判断
	if (m_wCurrentBanker!=INVALID_CHAIR)
	{
		//获取庄家
		IServerUserItem *pIServerUserItem=m_pITableFrame->GetTableUserItem(m_wCurrentBanker);

		if(pIServerUserItem!= NULL)
		{
			SCORE lBankerScore = pIServerUserItem->GetUserScore();

			//次数判断
			if (wBankerTime<=m_wBankerTime || lBankerScore<m_lApplyBankerCondition)
			{
				//撤销玩家
				for (WORD i=0; i<m_ApplyUserArray.GetCount(); ++i)
				{
					//获取玩家
					WORD wChairID=m_ApplyUserArray[i];

					//条件过滤
					if (wChairID!=m_wCurrentBanker) continue;

					//删除玩家
					m_ApplyUserArray.RemoveAt(i);

					break;
				}

				//设置庄家
				m_wCurrentBanker=INVALID_CHAIR;
	
				bChangeBanker=true;
			}

		}
		else
		{
			for (WORD i=0; i<m_ApplyUserArray.GetCount(); ++i)
			{
				//获取玩家
				WORD wChairID=m_ApplyUserArray[i];

				//条件过滤
				if (wChairID!=m_wCurrentBanker) continue;

				//删除玩家
				m_ApplyUserArray.RemoveAt(i);

				break;
			}
			//设置庄家
			m_wCurrentBanker=INVALID_CHAIR;
		}
		
	}

	if (bChangeBanker)
	{
		//设置变量
		m_wBankerTime = 0;
		m_lBankerWinScore=0;

		//发送消息
		CMD_S_ChangeBanker ChangeBanker;
		ZeroMemory(&ChangeBanker,sizeof(ChangeBanker));
		ChangeBanker.wBankerUser=m_wCurrentBanker;
		if (m_wCurrentBanker!=INVALID_CHAIR)
		{
			IServerUserItem *pIServerUserItem=m_pITableFrame->GetTableUserItem(m_wCurrentBanker);
			ChangeBanker.lBankerScore=pIServerUserItem->GetUserScore();
		}
		else
		{
			m_lSysBankerScore = 10000000;
			ChangeBanker.lBankerScore = m_lSysBankerScore;
		}
		m_pITableFrame->SendTableData(INVALID_CHAIR,SUB_S_CHANGE_BANKER,&ChangeBanker,sizeof(ChangeBanker));
		m_pITableFrame->SendLookonData(INVALID_CHAIR,SUB_S_CHANGE_BANKER,&ChangeBanker,sizeof(ChangeBanker));

	}
	

	return true;
}



//发送庄家
void CTableFrameSink::SendApplyUser( IServerUserItem *pRcvServerUserItem )
{
	for (INT_PTR nUserIdx=0; nUserIdx<m_ApplyUserArray.GetCount(); ++nUserIdx)
	{
		WORD wChairID=m_ApplyUserArray[nUserIdx];

		//获取玩家
		IServerUserItem *pServerUserItem=m_pITableFrame->GetTableUserItem(wChairID);
		if (!pServerUserItem) continue;

		//庄家判断
		if (pServerUserItem->GetChairID()==m_wCurrentBanker) continue;

		//构造变量
		CMD_S_ApplyBanker ApplyBanker;
		ApplyBanker.wApplyUser=wChairID;

		//发送消息
		m_pITableFrame->SendUserItemData(pRcvServerUserItem, SUB_S_APPLY_BANKER, &ApplyBanker, sizeof(ApplyBanker));
	}
}

//用户断线
bool  CTableFrameSink::OnActionUserOffLine(WORD wChairID, IServerUserItem * pIServerUserItem) 
{
	//切换庄家
//	if (wChairID==m_wCurrentBanker) ChangeBanker(true);

	//取消申请
	for (WORD i=0; i<m_ApplyUserArray.GetCount(); ++i)
	{
		if (wChairID!=m_ApplyUserArray[i]) continue;

		//删除玩家
		m_ApplyUserArray.RemoveAt(i);

		//构造变量
		CMD_S_CancelBanker CancelBanker;
		ZeroMemory(&CancelBanker,sizeof(CancelBanker));

		CancelBanker.wCancelUser = pIServerUserItem->GetChairID(); 

		//发送消息
		m_pITableFrame->SendTableData(INVALID_CHAIR, SUB_S_CANCEL_BANKER, &CancelBanker, sizeof(CancelBanker));
		m_pITableFrame->SendLookonData(INVALID_CHAIR, SUB_S_CANCEL_BANKER, &CancelBanker, sizeof(CancelBanker));

		break;
	}

	return true;
}

//最大下注
SCORE CTableFrameSink::GetUserMaxJetton(WORD wChairID)
{
	//获取玩家
	IServerUserItem *pIMeServerUserItem=m_pITableFrame->GetTableUserItem(wChairID);
	if (NULL==pIMeServerUserItem) return 0L;

	//已下注额
	SCORE lNowJetton = 0;
	ASSERT(AREA_COUNT<=CountArray(m_lUserJettonScore));
	
	//庄家金币
	SCORE lBankerScore = 10000000;
	if (m_wCurrentBanker!=INVALID_CHAIR)
	{
		lBankerScore=m_lBankerScore;
	}

	for (int nAreaIndex=1; nAreaIndex<=AREA_COUNT; ++nAreaIndex) 
	{
		lBankerScore-=m_lAllJettonScore[nAreaIndex];
		lNowJetton += m_lUserJettonScore[wChairID][nAreaIndex];
	}

	//个人限制
	SCORE lMeMaxScore = min((pIMeServerUserItem->GetUserScore() - lNowJetton), m_lUserLimitScore);

	//区域限制
	lMeMaxScore=min(lMeMaxScore,m_lAreaLimitScore);

	//庄家限制
	lMeMaxScore=min(lMeMaxScore,lBankerScore);
	
	lMeMaxScore = max(lMeMaxScore, 0);

	return lMeMaxScore;
}

//计算得分
SCORE CTableFrameSink::CalculateScore()
{
	//变量定义
	float static cbRevenue=m_pGameServiceOption->wRevenueRatio;

	//推断玩家
	bool static bWinShangMen, bWinTianMen, bWinXiaMen;
	DeduceWinner(bWinShangMen, bWinTianMen, bWinXiaMen);

	//游戏记录
	tagServerGameRecord &GameRecord = m_GameRecordArrary[m_nRecordLast];
	GameRecord.bWinShangMen=bWinShangMen;
	GameRecord.bWinTianMen=bWinTianMen;
	GameRecord.bWinXiaMen=bWinXiaMen;

	//移动下标
	m_nRecordLast = (m_nRecordLast+1) % MAX_SCORE_HISTORY;
	if ( m_nRecordLast == m_nRecordFirst ) m_nRecordFirst = (m_nRecordFirst+1) % MAX_SCORE_HISTORY;
	
	//庄家总量
	SCORE lBankerWinScore = 0;

	//玩家成绩
	ZeroMemory(m_lUserWinScore, sizeof(m_lUserWinScore));
	ZeroMemory(m_lUserReturnScore, sizeof(m_lUserReturnScore));
	ZeroMemory(m_lUserRevenue, sizeof(m_lUserRevenue));
	SCORE lUserLostScore[GAME_PLAYER];
	ZeroMemory(lUserLostScore, sizeof(lUserLostScore));


	//胜利标识
	bool static bWinFlag[AREA_MAX];
	bWinFlag[0]=false;
	bWinFlag[ID_SHUN_MEN] = bWinShangMen;
	bWinFlag[ID_TIAN_MEN] = (true == bWinShangMen && true == bWinTianMen) ? true : false;
	bWinFlag[ID_DI_MEN] = (true == bWinShangMen && true == bWinXiaMen) ? true : false;

	//计算积分
	for (WORD wChairID=0; wChairID<GAME_PLAYER; wChairID++)
	{
		//庄家判断
		if (m_wCurrentBanker==wChairID) continue;

		//获取用户
		IServerUserItem * pIServerUserItem=m_pITableFrame->GetTableUserItem(wChairID);
		if (pIServerUserItem==NULL) continue;

		for (WORD wAreaIndex = ID_SHUN_MEN; wAreaIndex <= ID_DI_MEN; ++wAreaIndex)
		{
			if (true==bWinFlag[wAreaIndex]) 
			{
				m_lUserWinScore[wChairID] += m_lUserJettonScore[wChairID][wAreaIndex];
				lBankerWinScore -= m_lUserJettonScore[wChairID][wAreaIndex];
			}
			else
			{
				lUserLostScore[wChairID] -= m_lUserJettonScore[wChairID][wAreaIndex];
				lBankerWinScore += m_lUserJettonScore[wChairID][wAreaIndex];
			}
		}

		//计算税收
		if (0 < m_lUserWinScore[wChairID])
		{
			float fRevenuePer=float(cbRevenue/1000);
			m_lUserRevenue[wChairID] = SCORE(m_lUserWinScore[wChairID] * fRevenuePer + 0.5);
			m_lUserWinScore[wChairID] -= m_lUserRevenue[wChairID];
		}
	  //	总的分数
		m_lUserWinScore[wChairID] += lUserLostScore[wChairID];
	}

	//庄家成绩
	if (m_wCurrentBanker!=INVALID_CHAIR)
	{
		m_lUserWinScore[m_wCurrentBanker] = lBankerWinScore;

		//计算税收
		if (0 < m_lUserWinScore[m_wCurrentBanker])
		{
			float fRevenuePer=float(cbRevenue/1000);
			if(cbRevenue<=0)
			{
				fRevenuePer = 0;
			}
			m_lUserRevenue[m_wCurrentBanker] = SCORE(m_lUserWinScore[m_wCurrentBanker] * fRevenuePer + 0.5);
			m_lUserWinScore[m_wCurrentBanker] -= m_lUserRevenue[m_wCurrentBanker];
			lBankerWinScore = m_lUserWinScore[m_wCurrentBanker];
		}		
	}


	//累计积分
	m_lBankerWinScore += lBankerWinScore;

	//当前积分
	m_lBankerCurGameScore=lBankerWinScore;	
	
	

	return lBankerWinScore;
}

//计算系统输赢分
SCORE CTableFrameSink::CalculateSystemScore()
{
	SCORE lSystemScore = 0;

	IServerUserItem *pIServerUserItem = m_pITableFrame->GetTableUserItem(m_wCurrentBanker);
	//玩家坐庄
	if (pIServerUserItem != NULL && !pIServerUserItem->IsAndroidUser())
	{
		for (WORD wUserIndex = 0; wUserIndex < GAME_PLAYER; ++wUserIndex)
		{
			IServerUserItem *pIServerUserItem = m_pITableFrame->GetTableUserItem(wUserIndex);
			if (pIServerUserItem == NULL) continue;

			if (pIServerUserItem->IsAndroidUser())
				lSystemScore += m_lUserWinScore[wUserIndex];
		}
	}
	else
	{
		for (WORD wUserIndex = 0; wUserIndex < GAME_PLAYER; ++wUserIndex)
		{
			IServerUserItem *pIServerUserItem = m_pITableFrame->GetTableUserItem(wUserIndex);
			if (pIServerUserItem == NULL) continue;

			if (!pIServerUserItem->IsAndroidUser())
				lSystemScore -= m_lUserWinScore[wUserIndex];
		}
	}

	return lSystemScore;
}

//是否控制
BYTE CTableFrameSink::AnalyseControl()
{
	//机器人数
	WORD wAiCount = 0;
	WORD wPlayerCount = 0;
	for (WORD i = 0; i < m_wPlayerCount; i++)
	{
		//获取用户
		IServerUserItem * pIServerUserItem = m_pITableFrame->GetTableUserItem(i);
		if (pIServerUserItem != NULL)
		{
			if (pIServerUserItem->IsAndroidUser())
			{
				wAiCount++;
			}
			wPlayerCount++;
		}
	}

	//全部机器
	if (wPlayerCount == wAiCount || wAiCount == 0)
	{
		return 0;
	}

	SCORE				llRiseScore[STORAGE_COUNT] = { 0 };	//库存起始值
	SCORE				llEndScore[STORAGE_COUNT] = { 0 };	//库存结束值
	INT						nProbability[STORAGE_COUNT] = { 0 };	//控制概率

	TCHAR outBuff[64] = { 0 };
	for (int i = 0; i < STORAGE_COUNT; i++)
	{
		memset(outBuff, 0, sizeof(outBuff));
		_sntprintf_s(outBuff, sizeof(outBuff), _T("%s"), m_pGameServiceOption->pRoomStorageOption.szStorageControl[i]);

		long long llValue[3] = { 0 };
		this->GetValueFromCombStr(llValue, CountArray(llValue), outBuff, _tcslen(outBuff));
		llRiseScore[i] = llValue[0];
		llEndScore[i] = llValue[1];
		nProbability[i] = llValue[2];
	}

	SCORE lStorageCurrent = m_pGameServiceOption->pRoomStorageOption.lStorageCurrent;
	SCORE lStorageMax = m_pGameServiceOption->pRoomStorageOption.lStorageMax;
	int lStorageMul = m_pGameServiceOption->pRoomStorageOption.lStorageMul;

	//控制判断
	int a = 0;			//控制档位
	for (; a < STORAGE_COUNT; a++)
	{
		if (llRiseScore[a] < lStorageCurrent && llEndScore[a] >= lStorageCurrent)
			break;
	}

	//进入库存控制
	if ((a < STORAGE_COUNT && nProbability[a] > 100) || lStorageCurrent < 0)
	{
		if ((rand() % 100) < (nProbability[a] - 100) || lStorageCurrent < 0)
		{
			return 1;
		}
	}

	// 送分判断
	bool bStorageSend = a < STORAGE_COUNT && nProbability[a] <= 100 && nProbability[a] > 0 && (rand() % 100) < nProbability[a];
	if ((lStorageCurrent > 0 && lStorageCurrent > lStorageMax && rand() % 100 < lStorageMul) || bStorageSend)
	{
		return 2;
	}

	return 0;
}

void CTableFrameSink::DeduceWinner(bool &bWinShangMen, bool &bWinTianMen, bool &bWinXiaMen)
{
	//大小比较
	bWinShangMen=m_GameLogic.CompareCard(m_cbTableCardArray[BANKER_INDEX],2,m_cbTableCardArray[SHANG_MEN_INDEX],2)==1?true:false;
	bWinTianMen=m_GameLogic.CompareCard(m_cbTableCardArray[BANKER_INDEX],2,m_cbTableCardArray[TIAN_MEN_INDEX],2)==1?true:false;
	bWinXiaMen=m_GameLogic.CompareCard(m_cbTableCardArray[BANKER_INDEX],2,m_cbTableCardArray[XIA_MEN_INDEX],2)==1?true:false;
}

//发送记录
void CTableFrameSink::SendGameRecord(IServerUserItem *pIServerUserItem)
{
	WORD wBufferSize=0;
	BYTE cbBuffer[SOCKET_TCP_BUFFER];
	int nIndex = m_nRecordFirst;
	while ( nIndex != m_nRecordLast )
	{
		if ((wBufferSize+sizeof(tagServerGameRecord))>sizeof(cbBuffer))
		{
			m_pITableFrame->SendUserItemData(pIServerUserItem,SUB_S_SEND_RECORD,cbBuffer,wBufferSize);
			wBufferSize=0;
		}
		CopyMemory(cbBuffer+wBufferSize,&m_GameRecordArrary[nIndex],sizeof(tagServerGameRecord));
		wBufferSize+=sizeof(tagServerGameRecord);

		nIndex = (nIndex+1) % MAX_SCORE_HISTORY;
	}
	if (wBufferSize>0) m_pITableFrame->SendUserItemData(pIServerUserItem,SUB_S_SEND_RECORD,cbBuffer,wBufferSize);
}

//读取配置
void CTableFrameSink::ReadConfigInformation(bool bReadFresh,bool bReadBaseConfig)
{
	//变量定义
	TCHAR OutBuf[255] = {};

	//上庄条件
	ZeroMemory(OutBuf, sizeof(OutBuf));
	GetPrivateProfileString(TEXT("百人二八杠"), TEXT("ApplyBankerCondition"), _T("5000"), OutBuf, 255, m_szConfigFileName);
	myscanf(OutBuf, mystrlen(OutBuf), _T("%lf"), &m_lApplyBankerCondition);

	//做庄次数
	m_nBankerTimeLimit = GetPrivateProfileInt(TEXT("百人二八杠"), TEXT("BankerTimes"), 10, m_szConfigFileName);
	
	//下注限制
	ZeroMemory(OutBuf, sizeof(OutBuf));
	GetPrivateProfileString(TEXT("百人二八杠"), TEXT("AreaLimitScore"), _T("1000000"), OutBuf, 255, m_szConfigFileName);
	myscanf(OutBuf, mystrlen(OutBuf), _T("%lf"), &m_lAreaLimitScore);

	ZeroMemory(OutBuf, sizeof(OutBuf));
	GetPrivateProfileString(TEXT("百人二八杠"), TEXT("UserLimitScore"), _T("1000000"), OutBuf, 255, m_szConfigFileName);
	myscanf(OutBuf, mystrlen(OutBuf), _T("%lf"), &m_lUserLimitScore);

	//时间配置
	m_nFreeTime = GetPrivateProfileInt(TEXT("百人二八杠"), TEXT("FreeTime"), 10, m_szConfigFileName);
	m_nPlaceJettonTime = GetPrivateProfileInt(TEXT("百人二八杠"), TEXT("BetTime"), 15, m_szConfigFileName);
	m_nGameEndTime = GetPrivateProfileInt(TEXT("百人二八杠"), TEXT("EndTime"), 15, m_szConfigFileName);
	if (m_nFreeTime <= 5		|| m_nFreeTime > 99)			m_nFreeTime = 5;
	if (m_nPlaceJettonTime <= 10 || m_nPlaceJettonTime > 99)		m_nPlaceJettonTime = 10;
	if (m_nGameEndTime <= 10 || m_nGameEndTime > 99)			m_nGameEndTime = 10;
}

//查询服务费
bool  CTableFrameSink::QueryBuckleServiceCharge(WORD wChairID)
{
	for (BYTE i=0;i<GAME_PLAYER;i++)
	{
		IServerUserItem *pUserItem=m_pITableFrame->GetTableUserItem(i);
		if(pUserItem==NULL) continue;
		if(wChairID==i)
		{
			//返回下注
			for (int nAreaIndex=0; nAreaIndex<AREA_COUNT; ++nAreaIndex) 
			{

				if (m_lUserJettonScore[wChairID][nAreaIndex] != 0)
				{
					return true;
				}
			}
			break;
		}
	}
	return false;
}
//查询限额
SCORE CTableFrameSink::QueryConsumeQuota(IServerUserItem * pIServerUserItem)
{
	SCORE consumeQuota=0L;
	SCORE lMinTableScore=m_pGameServiceOption->lMinTableScore;
	if(m_pITableFrame->GetGameStatus()==GAME_STATUS_FREE)
	{
		consumeQuota=pIServerUserItem->GetUserScore()-lMinTableScore;

	}
	return consumeQuota;
}

void CTableFrameSink::GetValueFromCombStr(LONGLONG llData[], int nDataLen, LPCTSTR sTr, int nStrLen)
{
	int nIndex = 0;							// 索引
	TCHAR szStr[500] = TEXT("");

	int nCount = 0;							// 获取到的数据
	for (int i = 0; i<nStrLen; i++)
	{
		if (sTr[i] != '|')
		{
			szStr[nIndex] = sTr[i];
			nIndex++;
			if (i == (int)(_tcslen(sTr) - 1))
			{
				llData[nCount] = _ttoi64(szStr);
				nCount++;
				nIndex = 0;
				memset(szStr, NULL, sizeof(szStr));
			}
			continue;
		}

		if (nCount >= nDataLen)
			return;

		llData[nCount] = _ttoi64(szStr);
		nCount++;
		nIndex = 0;
		memset(szStr, NULL, sizeof(szStr));
	}
}
//////////////////////////////////////////////////////////////////////////

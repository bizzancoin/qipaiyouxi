#include "StdAfx.h"
#include "TableFrameSink.h"
#include "DlgCustomRule.h"
#include <conio.h>
#include <locale>

//////////////////////////////////////////////////////////////////////////

//房间玩家信息
CMap<DWORD, DWORD, ROOMUSERINFO, ROOMUSERINFO> g_MapRoomUserInfo;	//玩家USERID映射玩家信息
//房间用户调试
CList<ROOMUSERDEBUG, ROOMUSERDEBUG &> g_ListRoomUserDebug;		//房间用户调试链表
//操作调试记录
CList<CString, CString &> g_ListOperationRecord;						//操作调试记录

ROOMUSERINFO	g_CurrentQueryUserInfo;								//当前查询用户信息

//全局变量
LONGLONG						g_lRoomStorageStart = 0LL;								//房间起始库存
LONGLONG						g_lRoomStorageCurrent = 0LL;							//总输赢分
LONGLONG						g_lStorageDeductRoom = 0LL;								//回扣变量
LONGLONG						g_lStorageMax1Room = 0LL;								//库存封顶
LONGLONG						g_lStorageMul1Room = 0LL;								//系统输钱比例
LONGLONG						g_lStorageMax2Room = 0LL;								//库存封顶
LONGLONG						g_lStorageMul2Room = 0LL;								//系统输钱比例
//////////////////////////////////////////////////////////////////////////

#define	IDI_SO_OPERATE							2							//代打定时器
#define	IDI_TIME_ELAPSE							12							//流逝定时器
#define	IDI_DELAY_GAMEFREE						13							//延迟空闲定时器

//前端所有的操作时间都缩短为10秒
#define	TIME_SO_OPERATE							12000						//代打定时器
#define	TIME_DELAY_GAMEFREE						6000						//延迟空闲定时器

#define	IDI_OFFLINE_TRUSTEE_0					3
#define	IDI_OFFLINE_TRUSTEE_1					4
#define	IDI_OFFLINE_TRUSTEE_2					5
#define	IDI_OFFLINE_TRUSTEE_3					6
#define	IDI_OFFLINE_TRUSTEE_4					7
#define	IDI_OFFLINE_TRUSTEE_5					8
#define	IDI_OFFLINE_TRUSTEE_6					9
#define	IDI_OFFLINE_TRUSTEE_7					10

//////////////////////////////////////////////////////////////////////////

//构造函数
CTableFrameSink::CTableFrameSink()
{
    //游戏变量
    m_wPlayerCount = GAME_PLAYER;

    m_lExitScore = 0;

    m_cbTimeRemain = TIME_SO_OPERATE / 1000;
    m_wBankerUser = INVALID_CHAIR;
    m_wFirstEnterUser = INVALID_CHAIR;
    m_listEnterUser.RemoveAll();
    m_listCardTypeOrder.RemoveAll();
    m_bReNewTurn = true;

    //用户状态
    ZeroMemory(m_cbDynamicJoin, sizeof(m_cbDynamicJoin));
    ZeroMemory(m_lTableScore, sizeof(m_lTableScore));
    ZeroMemory(m_cbPlayStatus, sizeof(m_cbPlayStatus));
    ZeroMemory(m_cbCallBankerStatus, sizeof(m_cbCallBankerStatus));
    ZeroMemory(m_cbCallBankerTimes, sizeof(m_cbCallBankerTimes));
    ZeroMemory(m_cbPrevCallBankerTimes, sizeof(m_cbPrevCallBankerTimes));

    ZeroMemory(m_bOpenCard, sizeof(m_bOpenCard));

    //扑克变量
    ZeroMemory(m_cbOriginalCardData, sizeof(m_cbOriginalCardData));
    ZeroMemory(m_cbHandCardData, sizeof(m_cbHandCardData));
    ZeroMemory(m_bSpecialCard, sizeof(m_bSpecialCard));
    ZeroMemory(m_cbOriginalCardType, sizeof(m_cbOriginalCardType));
    ZeroMemory(m_cbCombineCardType, sizeof(m_cbCombineCardType));

    //下注信息
    ZeroMemory(m_lTurnMaxScore, sizeof(m_lTurnMaxScore));

    ZeroMemory(m_bBuckleServiceCharge, sizeof(m_bBuckleServiceCharge));

    //组件变量
    m_pITableFrame = NULL;
    m_pGameServiceOption = NULL;

    m_ctConfig = CT_ADDTIMES_;
    m_stConfig = ST_SENDFOUR_;
    m_gtConfig = GT_HAVEKING_;
    m_bgtConfig = BGT_ROB_;
    m_btConfig = BT_FREE_;
    m_tyConfig = BT_TUI_INVALID_;

    m_lFreeConfig[0] = 200;
    m_lFreeConfig[1] = 500;
    m_lFreeConfig[2] = 800;
    m_lFreeConfig[3] = 1100;
    m_lFreeConfig[4] = 1500;

    ZeroMemory(m_lPercentConfig, sizeof(m_lPercentConfig));

    m_lMaxCardTimes = 0;

    ZeroMemory(&m_stRecord, sizeof(m_stRecord));
    for(WORD i = 0; i < GAME_PLAYER; i++)
    {
        m_listWinScoreRecord[i].RemoveAll();
    }

    m_cbTrusteeDelayTime = 3;

#ifdef CARD_CONFIG
    ZeroMemory(m_cbconfigCard, sizeof(m_cbconfigCard));
#endif

    //清空链表
    g_ListRoomUserDebug.RemoveAll();
    g_ListOperationRecord.RemoveAll();
    ZeroMemory(&g_CurrentQueryUserInfo, sizeof(g_CurrentQueryUserInfo));

    //服务调试
    m_hInst = NULL;
    m_pServerDebug = NULL;
    m_hInst = LoadLibrary(TEXT("OxEightServerDebug.dll"));
    if(m_hInst)
    {
        typedef void *(*CREATE)();
        CREATE ServerDebug = (CREATE)GetProcAddress(m_hInst, "CreateServerDebug");
        if(ServerDebug)
        {
            m_pServerDebug = static_cast<IServerDebug *>(ServerDebug());
        }
    }

    //游戏视频
    m_hVideoInst = NULL;
    m_pGameVideo = NULL;
    m_hVideoInst = LoadLibrary(TEXT("OxEightGameVideo.dll"));
    if(m_hVideoInst)
    {
        typedef void *(*CREATE)();
        CREATE GameVideo = (CREATE)GetProcAddress(m_hVideoInst, "CreateGameVideo");
        if(GameVideo)
        {
            m_pGameVideo = static_cast<IGameVideo *>(GameVideo());
        }
    }

    ZeroMemory(&m_RoomCardRecord, sizeof(m_RoomCardRecord));

    //////////////////////////优化内容
    m_lBeBankerCondition = INVALID_DWORD;
    m_lPlayerBetTimes = INVALID_DWORD;
    m_cbAdmitRevCard = TRUE;
    m_cbMaxCallBankerTimes = 5;
    for(WORD i = 0; i < MAX_SPECIAL_CARD_TYPE; i++)
    {
        m_cbEnableCardType[i] = TRUE;
    }
    m_cbClassicTypeConfig = 0;

    m_lBgtDespotWinScore = 0L;
    m_wBgtRobNewTurnChairID = INVALID_CHAIR;
	m_cbRCOfflineTrustee = TRUE;

    ZeroMemory(m_bLastTurnBeBanker, sizeof(m_bLastTurnBeBanker));
    ZeroMemory(m_lLastTurnWinScore, sizeof(m_lLastTurnWinScore));
    ZeroMemory(m_bLastTurnBetBtEx, sizeof(m_bLastTurnBetBtEx));
    ZeroMemory(m_lPlayerBetBtEx, sizeof(m_lPlayerBetBtEx));

	ZeroMemory(&m_GameEndEx, sizeof(m_GameEndEx));

    srand(time(NULL));

    return;
}

//析构函数
CTableFrameSink::~CTableFrameSink(void)
{
    if(m_pServerDebug)
    {
        delete m_pServerDebug;
        m_pServerDebug = NULL;
    }

    if(m_hInst)
    {
        FreeLibrary(m_hInst);
        m_hInst = NULL;
    }

    if(m_pGameVideo)
    {
        delete m_pGameVideo;
        m_pGameVideo = NULL;
    }

    if(m_hVideoInst)
    {
        FreeLibrary(m_hVideoInst);
        m_hVideoInst = NULL;
    }
}

//接口查询--检测相关信息版本
void *CTableFrameSink::QueryInterface(const IID &Guid, DWORD dwQueryVer)
{
    QUERYINTERFACE(ITableFrameSink, Guid, dwQueryVer);
    QUERYINTERFACE(ITableUserAction, Guid, dwQueryVer);
    QUERYINTERFACE_IUNKNOWNEX(ITableFrameSink, Guid, dwQueryVer);
    return NULL;
}

//初始化
bool CTableFrameSink::Initialization(IUnknownEx *pIUnknownEx)
{
    //查询接口
    ASSERT(pIUnknownEx != NULL);
    m_pITableFrame = QUERY_OBJECT_PTR_INTERFACE(pIUnknownEx, ITableFrame);
    if(m_pITableFrame == NULL) { return false; }

    m_pITableFrame->SetStartMode(START_MODE_ALL_READY);

    //游戏配置
    m_pGameServiceAttrib = m_pITableFrame->GetGameServiceAttrib();
    m_pGameServiceOption = m_pITableFrame->GetGameServiceOption();

    //读取配置
    ReadConfigInformation();



    return true;
}

//复位桌子
void CTableFrameSink::RepositionSink()
{
    //游戏变量
    m_lExitScore = 0;
    m_cbTimeRemain = TIME_SO_OPERATE / 1000;

    //用户状态
    ZeroMemory(m_cbDynamicJoin, sizeof(m_cbDynamicJoin));
    ZeroMemory(m_lTableScore, sizeof(m_lTableScore));
    ZeroMemory(m_bBuckleServiceCharge, sizeof(m_bBuckleServiceCharge));
    ZeroMemory(m_cbPlayStatus, sizeof(m_cbPlayStatus));
    ZeroMemory(m_cbCallBankerStatus, sizeof(m_cbCallBankerStatus));
    ZeroMemory(m_cbCallBankerTimes, sizeof(m_cbCallBankerTimes));

    ZeroMemory(m_bOpenCard, sizeof(m_bOpenCard));

    //扑克变量
    ZeroMemory(m_cbOriginalCardData, sizeof(m_cbOriginalCardData));
    ZeroMemory(m_cbHandCardData, sizeof(m_cbHandCardData));
    ZeroMemory(m_bSpecialCard, sizeof(m_bSpecialCard));
    ZeroMemory(m_cbOriginalCardType, sizeof(m_cbOriginalCardType));
    ZeroMemory(m_cbCombineCardType, sizeof(m_cbCombineCardType));

    //下注信息
    ZeroMemory(m_lTurnMaxScore, sizeof(m_lTurnMaxScore));
    m_wBgtRobNewTurnChairID = INVALID_CHAIR;

    //重置推注变量
    ZeroMemory(m_lPlayerBetBtEx, sizeof(m_lPlayerBetBtEx));

	ZeroMemory(&m_GameEndEx, sizeof(m_GameEndEx));

    return;
}

//用户断线
bool CTableFrameSink::OnActionUserOffLine(WORD wChairID, IServerUserItem *pIServerUserItem)
{
    //更新房间用户信息
    UpdateRoomUserInfo(pIServerUserItem, USER_OFFLINE);

    //设置托管定时器
    //金币场和金币房卡默认托管，积分房卡房卡创建界面可以勾选托管
	if (((m_pGameServiceOption->wServerType & GAME_GENRE_PERSONAL) != 0 && m_cbRCOfflineTrustee == TRUE)
      || (m_pGameServiceOption->wServerType & GAME_GENRE_PERSONAL) == 0)
    {
        pIServerUserItem->SetTrusteeUser(true);
        switch(m_pITableFrame->GetGameStatus())
        {
        case GS_TK_CALL:
        {
            if(m_cbCallBankerStatus[wChairID] == FALSE)
            {
                if(wChairID == m_wBgtRobNewTurnChairID && m_wBgtRobNewTurnChairID != INVALID_CHAIR)
                {
                    OnUserCallBanker(wChairID, true, 1);
                }
                else
                {
                    OnUserCallBanker(wChairID, false, m_cbPrevCallBankerTimes[wChairID]);
                }
            }
            break;
        }
        case GS_TK_SCORE:
        {
            if(m_lTableScore[wChairID] > 0 || wChairID == m_wBankerUser)
            {
                break;
            }
            if(m_lTurnMaxScore[wChairID] > 0)
            {
                if(m_btConfig == BT_FREE_)
                {
                    OnUserAddScore(wChairID, m_lFreeConfig[0] * m_pITableFrame->GetCellScore());
                }
                else if(m_btConfig == BT_PENCENT_)
                {
                    OnUserAddScore(wChairID, m_lTurnMaxScore[wChairID] * m_lPercentConfig[0] / 100);
                }
            }
            else
            {
                OnUserAddScore(wChairID, 1);
            }
            break;
        }
        case GS_TK_PLAYING:
        {
            if(m_bOpenCard[wChairID] == false)
            {
                //获取牛牛牌型
                BYTE cbTempHandCardData[MAX_CARDCOUNT];
                ZeroMemory(cbTempHandCardData, sizeof(cbTempHandCardData));
                CopyMemory(cbTempHandCardData, m_cbHandCardData[wChairID], sizeof(m_cbHandCardData[wChairID]));

                m_GameLogic.GetOxCard(cbTempHandCardData, MAX_CARDCOUNT);
                OnUserOpenCard(wChairID, cbTempHandCardData);
            }
            break;
        }
        default:
            break;
        }
    }

    return true;
}

//用户坐下
bool CTableFrameSink::OnActionUserSitDown(WORD wChairID, IServerUserItem *pIServerUserItem, bool bLookonUser)
{
    //历史积分
    if(bLookonUser == false) { m_HistoryScore.OnEventUserEnter(pIServerUserItem->GetChairID()); }

    if(m_pITableFrame->GetGameStatus() != GS_TK_FREE)
    {
        m_cbDynamicJoin[pIServerUserItem->GetChairID()] = TRUE;
    }

    //更新房间用户信息
    UpdateRoomUserInfo(pIServerUserItem, USER_SITDOWN);

    //更新同桌用户调试
    UpdateUserDebug(pIServerUserItem);

    //霸王庄 首进玩家
    if(m_wFirstEnterUser == INVALID_CHAIR && m_bgtConfig == BGT_DESPOT_)
    {
        m_wFirstEnterUser = wChairID;
    }

    m_listEnterUser.AddTail(wChairID);

    return true;
}

//用户起立
bool CTableFrameSink::OnActionUserStandUp(WORD wChairID, IServerUserItem *pIServerUserItem, bool bLookonUser)
{
    //历史积分
    if(bLookonUser == false)
    {
        m_HistoryScore.OnEventUserLeave(pIServerUserItem->GetChairID());
        m_cbDynamicJoin[pIServerUserItem->GetChairID()] = FALSE;
    }

    //更新房间用户信息
    UpdateRoomUserInfo(pIServerUserItem, USER_STANDUP);

    //非房卡房间
    if((m_pGameServiceOption->wServerType & GAME_GENRE_PERSONAL) == 0)
    {
        if(m_bgtConfig == BGT_NIUNIU_ || m_bgtConfig == BGT_NONIUNIU_)
        {
            if(wChairID == m_wBankerUser)
            {
                m_wBankerUser = INVALID_CHAIR;
            }
        }
    }

    POSITION ptListHead = m_listEnterUser.GetHeadPosition();
    POSITION ptTemp;

    //删除离开玩家
    while(ptListHead)
    {
        ptTemp = ptListHead;
        if(m_listEnterUser.GetNext(ptListHead) == wChairID)
        {
            m_listEnterUser.RemoveAt(ptTemp);
            break;
        }
    }

    ptListHead = m_listCardTypeOrder.GetHeadPosition();

    //删除离开玩家
    while(ptListHead)
    {
        ptTemp = ptListHead;
        if(m_listCardTypeOrder.GetNext(ptListHead) == wChairID)
        {
            m_listCardTypeOrder.RemoveAt(ptTemp);
            break;
        }
    }

    //房卡模式
    if((m_pGameServiceOption->wServerType & GAME_GENRE_PERSONAL) != 0)
    {
        //当前约战解散清理记录
        if(m_pITableFrame->IsPersonalRoomDisumme())
        {
            ZeroMemory(&m_stRecord, sizeof(m_stRecord));
            ZeroMemory(&m_RoomCardRecord, sizeof(m_RoomCardRecord));

            m_wFirstEnterUser = INVALID_CHAIR;

            if(!m_listEnterUser.IsEmpty())
            {
                m_listEnterUser.RemoveAll();
            }

            m_wBankerUser = INVALID_CHAIR;
            m_lBgtDespotWinScore = 0L;

            //重置推注变量
            ZeroMemory(m_bLastTurnBeBanker, sizeof(m_bLastTurnBeBanker));
            ZeroMemory(m_lLastTurnWinScore, sizeof(m_lLastTurnWinScore));
            ZeroMemory(m_bLastTurnBetBtEx, sizeof(m_bLastTurnBetBtEx));
            ZeroMemory(m_lPlayerBetBtEx, sizeof(m_lPlayerBetBtEx));
        }
    }
    //非房卡房间
    else
    {
        BYTE bUserCount = 0;
        for(WORD i = 0; i < m_wPlayerCount; i++)
        {
            if(i == wChairID)
            {
                continue;
            }

            if(m_pITableFrame->GetTableUserItem(i))
            {
                bUserCount++;
            }
        }

        if(bUserCount == 0 && !m_listEnterUser.IsEmpty())
        {
            m_listEnterUser.RemoveAll();
        }
    }

    if(m_bgtConfig == BGT_NIUNIU_)
    {
        m_bReNewTurn = m_listCardTypeOrder.IsEmpty();

        if(!m_listCardTypeOrder.IsEmpty())
        {
            m_wBankerUser = m_listCardTypeOrder.GetHead();
        }
    }
    else
    {
        m_bReNewTurn = true;
    }

    //金币房卡
    if((m_pITableFrame->GetDataBaseMode() == 1) && ((m_pGameServiceOption->wServerType & GAME_GENRE_PERSONAL) != 0))
    {
        m_listWinScoreRecord[wChairID].RemoveAll();
    }

    m_bLastTurnBeBanker[wChairID] = false;
    m_lLastTurnWinScore[wChairID] = 0;
    m_bLastTurnBetBtEx[wChairID] = false;
    m_lPlayerBetBtEx[wChairID] = 0;

    return true;
}

//用户同意
bool CTableFrameSink::OnActionUserOnReady(WORD wChairID, IServerUserItem *pIServerUserItem, VOID *pData, WORD wDataSize)
{
    //私人房设置游戏模式
    if(((m_pGameServiceOption->wServerType) & GAME_GENRE_PERSONAL) != 0)
    {
        //cbGameRule[1] 为  2345678分别对应桌子最大人数
		if (m_pITableFrame->GetStartMode() != START_MODE_ALL_READY)
		{
			m_pITableFrame->SetStartMode(START_MODE_ALL_READY);
		}
    }

	for (WORD i = 0; i < m_wPlayerCount; i++)
	{
		//获取用户
		IServerUserItem *pIServerUserItem = m_pITableFrame->GetTableUserItem(i);
		if (pIServerUserItem == NULL)
		{
			continue;
		}

		if (!pIServerUserItem->IsClientReady() || !pIServerUserItem->IsAndroidUser())
		{
			continue;
		}

		m_pITableFrame->SendTableData(i, SUB_S_ANDROID_READY);
	}

    return true;
}

//游戏开始
bool CTableFrameSink::OnEventGameStart()
{
    //重置推注变量
    ZeroMemory(m_lPlayerBetBtEx, sizeof(m_lPlayerBetBtEx));

    //库存
    if(g_lRoomStorageCurrent > 0 && NeedDeductStorage())
    {
        g_lRoomStorageCurrent = g_lRoomStorageCurrent - g_lRoomStorageCurrent * g_lStorageDeductRoom / 1000;
    }

    //写日志
    CString strInfo;
    strInfo.Format(TEXT("TABLEID = %d, 当前库存：%I64d"), m_pITableFrame->GetTableID(), g_lRoomStorageCurrent);
    CString strFileName = TEXT("库存日志");

    tagLogUserInfo LogUserInfo;
    ZeroMemory(&LogUserInfo, sizeof(LogUserInfo));
	CopyMemory(LogUserInfo.szDescName, strFileName, sizeof(LogUserInfo.szDescName));
    CopyMemory(LogUserInfo.szLogContent, strInfo, sizeof(LogUserInfo.szLogContent));
    //m_pITableFrame->SendGameLogData(LogUserInfo);

    if(m_pGameVideo)
    {
        m_pGameVideo->StartVideo(m_pITableFrame, m_wPlayerCount);
    }

    //牌型最大倍数
    tagCustomRule *pCustomRule = (tagCustomRule *)m_pITableFrame->GetCustomRule();
    m_lMaxCardTimes = INVALID_BYTE;

    if(pCustomRule->ctConfig == CT_CLASSIC_)
    {
        m_lMaxCardTimes = pCustomRule->cbCardTypeTimesClassic[0];
        for(WORD i = 0; i < MAX_CARD_TYPE; i++)
        {
            if(pCustomRule->cbCardTypeTimesClassic[i] > m_lMaxCardTimes)
            {
                m_lMaxCardTimes = pCustomRule->cbCardTypeTimesClassic[i];
            }
        }
    }
    else if(pCustomRule->ctConfig == CT_ADDTIMES_)
    {
        m_lMaxCardTimes = pCustomRule->cbCardTypeTimesAddTimes[0];
        for(WORD i = 0; i < MAX_CARD_TYPE; i++)
        {
            if(pCustomRule->cbCardTypeTimesAddTimes[i] > m_lMaxCardTimes)
            {
                m_lMaxCardTimes = pCustomRule->cbCardTypeTimesAddTimes[i];
            }
        }
    }
    ASSERT(m_lMaxCardTimes != INVALID_BYTE);

    //设置牌型倍数

    if(m_cbClassicTypeConfig == INVALID_BYTE)
    {
        m_GameLogic.SetCardTypeTimes(pCustomRule->cbCardTypeTimesAddTimes);
    }
    else if(m_cbClassicTypeConfig == 0)
    {
        //牌型倍数
        m_GameLogic.SetCardTypeTimes(pCustomRule->cbCardTypeTimesClassic);
    }
    else if(m_cbClassicTypeConfig == 1)
    {
        //牌型倍数
        m_GameLogic.SetCardTypeTimes(pCustomRule->cbCardTypeTimesClassic);
    }

    //设置牌型激活
    m_GameLogic.SetEnableCardType(m_cbEnableCardType);

    //用户状态
    for(WORD i = 0; i < m_wPlayerCount; i++)
    {
        //获取用户
        IServerUserItem *pIServerUserItem = m_pITableFrame->GetTableUserItem(i);
        if(pIServerUserItem == NULL)
        {
            m_cbPlayStatus[i] = FALSE;
        }
        else
        {
            m_cbPlayStatus[i] = TRUE;

            //更新房间用户信息
            UpdateRoomUserInfo(pIServerUserItem, USER_SITDOWN);
        }
    }

    CopyMemory(m_RoomCardRecord.cbPlayStatus, m_cbPlayStatus, sizeof(m_RoomCardRecord.cbPlayStatus));

    //随机扑克
    BYTE bTempArray[GAME_PLAYER * MAX_CARDCOUNT];
    m_GameLogic.RandCardList(bTempArray, sizeof(bTempArray), (m_gtConfig == GT_HAVEKING_ ? true : false));

    for(WORD i = 0; i < m_wPlayerCount; i++)
    {
        IServerUserItem *pIServerUser = m_pITableFrame->GetTableUserItem(i);
        if(pIServerUser == NULL)
        {
            continue;
        }

        //派发扑克
        CopyMemory(m_cbHandCardData[i], &bTempArray[i * MAX_CARDCOUNT], MAX_CARDCOUNT);
    }

#ifdef CARD_CONFIG
    //if (m_cbconfigCard[0][0] != 0 && m_cbconfigCard[0][1] != 0 && m_cbconfigCard[0][2] != 0)
    //{
    //	CopyMemory(m_cbHandCardData, m_cbconfigCard, sizeof(m_cbHandCardData));
    //}

    //m_cbHandCardData[0][0] = 0x32;
    //m_cbHandCardData[0][1] = 0x35;
    //m_cbHandCardData[0][2] = 0x34;
    //m_cbHandCardData[0][3] = 0x37;
    //m_cbHandCardData[0][4] = 0x4E;

    //m_cbHandCardData[1][0] = 0x4E;
    //m_cbHandCardData[1][1] = 0x3B;
    //m_cbHandCardData[1][2] = 0x4F;
    //m_cbHandCardData[1][3] = 0x0C;
    //m_cbHandCardData[1][4] = 0x1B;
#endif

    //临时扑克
    BYTE cbTempHandCardData[GAME_PLAYER][MAX_CARDCOUNT];
    ZeroMemory(cbTempHandCardData, sizeof(cbTempHandCardData));
    CopyMemory(cbTempHandCardData, m_cbHandCardData, sizeof(m_cbHandCardData));

    //原始扑克
    //CopyMemory(m_cbOriginalCardData, m_cbHandCardData, sizeof(m_cbHandCardData));

    for(WORD i = 0; i < m_wPlayerCount; i++)
    {
        IServerUserItem *pIServerUser = m_pITableFrame->GetTableUserItem(i);
        if(pIServerUser == NULL)
        {
            continue;
        }

        m_bSpecialCard[i] = (m_GameLogic.GetCardType(cbTempHandCardData[i], MAX_CARDCOUNT, m_ctConfig) > CT_CLASSIC_OX_VALUENIUNIU ? true : false);

        //特殊牌型
        if(m_bSpecialCard[i])
        {
            m_cbOriginalCardType[i] = m_GameLogic.GetCardType(cbTempHandCardData[i], MAX_CARDCOUNT, m_ctConfig);
        }
        else
        {
            //获取牛牛牌型
            m_GameLogic.GetOxCard(cbTempHandCardData[i], MAX_CARDCOUNT);

            m_cbOriginalCardType[i] = m_GameLogic.GetCardType(cbTempHandCardData[i], MAX_CARDCOUNT, m_ctConfig);
        }
    }

    //获取坐庄模式
    ASSERT(m_bgtConfig != BGT_INVALID_);

    bool bRoomServerType = ((m_pGameServiceOption->wServerType) & GAME_GENRE_PERSONAL) != 0;

    //庄家配置
    switch(m_bgtConfig)
    {
    //霸王庄
    case BGT_DESPOT_:
    {
        //初始默认庄家
        InitialBanker();

        //霸王庄模式下 m_lBeBankerCondition为INVALID_DWORD表明设置无，其他模式下没有该选项也为INVALID_DWORD

        break;
    }
    //倍数抢庄
    case BGT_ROB_:
    {
        //房卡模式新开一局
        //if(bRoomServerType && m_bReNewTurn == true)
        //{
        //    //房主强制为庄，若房主不参与游戏，则第一个进去此游戏的玩家强制为庄
        //    //获取房主
        //    WORD wRoomOwenrChairID = INVALID_CHAIR;
        //    DWORD dwRoomOwenrUserID = INVALID_DWORD;
        //    for(WORD i = 0; i < m_wPlayerCount; i++)
        //    {
        //        //获取用户
        //        IServerUserItem *pIServerUserItem = m_pITableFrame->GetTableUserItem(i);
        //        if(!pIServerUserItem)
        //        {
        //            continue;
        //        }

        //        m_cbCallBankerStatus[i] = TRUE;
        //        m_cbCallBankerTimes[i] = 0;

        //        if(pIServerUserItem->GetUserID() == m_pITableFrame->GetTableOwner() && IsRoomCardType())
        //        {
        //            dwRoomOwenrUserID = pIServerUserItem->GetUserID();
        //            wRoomOwenrChairID = pIServerUserItem->GetChairID();
        //            //break;
        //        }
        //    }

        //    //房主参与游戏
        //    if(dwRoomOwenrUserID != INVALID_DWORD && wRoomOwenrChairID != INVALID_CHAIR)
        //    {
        //        m_wBankerUser = wRoomOwenrChairID;
        //    }
        //    //房主不参与游戏和非房卡房间
        //    else
        //    {
        //        ASSERT(m_listEnterUser.IsEmpty() == false);
        //        m_wBankerUser = m_listEnterUser.GetHead();
        //    }

        //    ASSERT(m_wBankerUser != INVALID_CHAIR);

        //    m_wBgtRobNewTurnChairID = m_wBankerUser;
        //    m_cbCallBankerStatus[m_wBankerUser] = FALSE;

        //    //初始默认庄家
        //    //InitialBanker();

        //    //非房卡场设置定时器
        //    if(!IsRoomCardType())
        //    {
        //        m_pITableFrame->KillGameTimer(IDI_SO_OPERATE);
        //        m_pITableFrame->SetGameTimer(IDI_SO_OPERATE, TIME_SO_OPERATE, 1, 0);
        //    }

        //    //设置离线代打定时器
        //    for(WORD i = 0; i < m_wPlayerCount; i++)
        //    {
        //        if(m_cbPlayStatus[i] == TRUE && m_pITableFrame->GetTableUserItem(i)->IsTrusteeUser())
        //        {
        //            m_pITableFrame->SetGameTimer(IDI_OFFLINE_TRUSTEE_0 + i, m_cbTrusteeDelayTime * 1000, 1, 0);
        //        }
        //    }

        //    //设置状态
        //    m_pITableFrame->SetGameStatus(GS_TK_CALL);
        //    EnableTimeElapse(true);

        //    CMD_S_CallBanker CallBanker;
        //    ZeroMemory(&CallBanker, sizeof(CallBanker));
        //    CallBanker.ctConfig = m_ctConfig;
        //    CallBanker.stConfig = m_stConfig;
        //    CallBanker.bgtConfig = m_bgtConfig;

        //    BYTE *pGameRule = m_pITableFrame->GetGameRule();
        //    CallBanker.wGamePlayerCountRule = pGameRule[1];
        //    CallBanker.cbMaxCallBankerTimes = m_cbMaxCallBankerTimes;
        //    CallBanker.wBgtRobNewTurnChairID = m_wBgtRobNewTurnChairID;

        //    //更新房间用户信息
        //    for(WORD i = 0; i < m_wPlayerCount; i++)
        //    {
        //        //获取用户
        //        IServerUserItem *pIServerUserItem = m_pITableFrame->GetTableUserItem(i);
        //        if(pIServerUserItem != NULL)
        //        {
        //            UpdateRoomUserInfo(pIServerUserItem, USER_SITDOWN);
        //        }
        //    }

        //    //发送数据
        //    for(WORD i = 0; i < m_wPlayerCount; i++)
        //    {
        //        if(m_cbPlayStatus[i] != TRUE)
        //        {
        //            continue;
        //        }
        //        m_pITableFrame->SendTableData(i, SUB_S_CALL_BANKER, &CallBanker, sizeof(CallBanker));
        //    }
        //    m_pITableFrame->SendLookonData(INVALID_CHAIR, SUB_S_CALL_BANKER, &CallBanker, sizeof(CallBanker));

        //    if(m_pGameVideo)
        //    {
        //        m_pGameVideo->AddVideoData(SUB_S_CALL_BANKER, &CallBanker);
        //    }
        //}
        ////房卡模式不是新开一局 或者非房卡模式
        //else if((bRoomServerType && !m_bReNewTurn) || !bRoomServerType)
        {
            m_wBgtRobNewTurnChairID = INVALID_CHAIR;

            //非房卡场设置定时器
            if(!IsRoomCardType())
            {
                m_pITableFrame->KillGameTimer(IDI_SO_OPERATE);
                m_pITableFrame->SetGameTimer(IDI_SO_OPERATE, TIME_SO_OPERATE, 1, 0);
            }

            //设置离线代打定时器
            for(WORD i = 0; i < m_wPlayerCount; i++)
            {
                if(m_cbPlayStatus[i] == TRUE && m_pITableFrame->GetTableUserItem(i)->IsTrusteeUser())
                {
                    m_pITableFrame->SetGameTimer(IDI_OFFLINE_TRUSTEE_0 + i, m_cbTrusteeDelayTime * 1000, 1, 0);
                }
            }

            //设置状态
            m_pITableFrame->SetGameStatus(GS_TK_CALL);
            EnableTimeElapse(true);

            CMD_S_CallBanker CallBanker;
            ZeroMemory(&CallBanker, sizeof(CallBanker));
            CallBanker.ctConfig = m_ctConfig;
            CallBanker.stConfig = m_stConfig;
            CallBanker.bgtConfig = m_bgtConfig;

            BYTE *pGameRule = m_pITableFrame->GetGameRule();
            CallBanker.wGamePlayerCountRule = pGameRule[1];
            CallBanker.cbMaxCallBankerTimes = m_cbMaxCallBankerTimes;
            CallBanker.wBgtRobNewTurnChairID = m_wBgtRobNewTurnChairID;

            //更新房间用户信息
            for(WORD i = 0; i < m_wPlayerCount; i++)
            {
                //获取用户
                IServerUserItem *pIServerUserItem = m_pITableFrame->GetTableUserItem(i);
                if(pIServerUserItem != NULL)
                {
                    UpdateRoomUserInfo(pIServerUserItem, USER_SITDOWN);
                }
            }

            //发送数据
            for(WORD i = 0; i < m_wPlayerCount; i++)
            {
                if(m_cbPlayStatus[i] != TRUE)
                {
                    continue;
                }
                m_pITableFrame->SendTableData(i, SUB_S_CALL_BANKER, &CallBanker, sizeof(CallBanker));
            }
            m_pITableFrame->SendLookonData(INVALID_CHAIR, SUB_S_CALL_BANKER, &CallBanker, sizeof(CallBanker));

            if(m_pGameVideo)
            {
                m_pGameVideo->AddVideoData(SUB_S_CALL_BANKER, &CallBanker);
            }

            //发四等五
            if(m_stConfig == ST_SENDFOUR_)
            {
                //设置变量
                CMD_S_SendFourCard SendFourCard;
                ZeroMemory(&SendFourCard, sizeof(SendFourCard));

                for(WORD i = 0; i < m_wPlayerCount; i++)
                {
                    if(m_cbPlayStatus[i] == FALSE && m_cbDynamicJoin[i] == FALSE)
                    {
                        continue;
                    }

                    //派发扑克(开始只发四张牌)
                    CopyMemory(SendFourCard.cbCardData[i], m_cbHandCardData[i], sizeof(BYTE) * 4);
                }

                m_pITableFrame->SendTableData(INVALID_CHAIR, SUB_S_SEND_FOUR_CARD, &SendFourCard, sizeof(SendFourCard));
            }
        }

        break;
    }
    //牛牛上庄
    //无牛下庄
    case BGT_NIUNIU_:
    case BGT_NONIUNIU_:
    {
        //新开一局
        if(m_bReNewTurn == true)
        {
            //初始默认庄家
            InitialBanker();
        }
        else
        {
            ASSERT(m_wBankerUser != INVALID_CHAIR);

            m_bBuckleServiceCharge[m_wBankerUser] = true;

            //非房卡场设置定时器
            if(!IsRoomCardType())
            {
                m_pITableFrame->KillGameTimer(IDI_SO_OPERATE);
                m_pITableFrame->SetGameTimer(IDI_SO_OPERATE, TIME_SO_OPERATE, 1, 0);
            }

            //设置离线代打定时器
            for(WORD i = 0; i < m_wPlayerCount; i++)
            {
                if(m_cbPlayStatus[i] == TRUE && m_pITableFrame->GetTableUserItem(i)->IsTrusteeUser())
                {
                    m_pITableFrame->SetGameTimer(IDI_OFFLINE_TRUSTEE_0 + i, m_cbTrusteeDelayTime * 1000, 1, 0);
                }
            }

            //设置状态
            m_pITableFrame->SetGameStatus(GS_TK_SCORE);
            EnableTimeElapse(true);

            //更新房间用户信息
            for(WORD i = 0; i < m_wPlayerCount; i++)
            {
                //获取用户
                IServerUserItem *pIServerUserItem = m_pITableFrame->GetTableUserItem(i);
                if(pIServerUserItem != NULL)
                {
                    UpdateRoomUserInfo(pIServerUserItem, USER_SITDOWN);
                }
            }

            //获取最大下注
            for(WORD i = 0; i < m_wPlayerCount; i++)
            {
                if(m_cbPlayStatus[i] != TRUE || i == m_wBankerUser)
                {
                    continue;
                }

                //下注变量
                m_lTurnMaxScore[i] = GetUserMaxTurnScore(i);
            }

            for(WORD i = 0; i < m_wPlayerCount; i++)
            {
                if(i == m_wBankerUser || m_cbPlayStatus[i] == FALSE)
                {
                    continue;
                }

                if(m_bLastTurnBetBtEx[i] == true)
                {
                    m_bLastTurnBetBtEx[i] = false;
                }
            }

            m_lPlayerBetBtEx[m_wBankerUser] = 0;

            //设置变量
            CMD_S_GameStart GameStart;
            ZeroMemory(&GameStart, sizeof(GameStart));
            GameStart.wBankerUser = m_wBankerUser;
            CopyMemory(GameStart.cbPlayerStatus, m_cbPlayStatus, sizeof(m_cbPlayStatus));

            //发四等五
            if(m_stConfig == ST_SENDFOUR_)
            {
                for(WORD i = 0; i < m_wPlayerCount; i++)
                {
                    if(m_cbPlayStatus[i] == FALSE && m_cbDynamicJoin[i] == FALSE)
                    {
                        continue;
                    }

                    //派发扑克(开始只发四张牌)
                    CopyMemory(GameStart.cbCardData[i], m_cbHandCardData[i], sizeof(BYTE) * 4);
                }
            }

            GameStart.stConfig = m_stConfig;
            GameStart.bgtConfig = m_bgtConfig;
            GameStart.btConfig = m_btConfig;
            GameStart.gtConfig = m_gtConfig;

            CopyMemory(GameStart.lFreeConfig, m_lFreeConfig, sizeof(GameStart.lFreeConfig));
            CopyMemory(GameStart.lPercentConfig, m_lPercentConfig, sizeof(GameStart.lPercentConfig));
            CopyMemory(GameStart.lPlayerBetBtEx, m_lPlayerBetBtEx, sizeof(GameStart.lPlayerBetBtEx));

            bool bFirstRecord = true;

            WORD wRealPlayerCount = 0;
            for(WORD i = 0; i < m_wPlayerCount; i++)
            {
                IServerUserItem *pServerUserItem = m_pITableFrame->GetTableUserItem(i);
                if(m_cbPlayStatus[i] == FALSE && m_cbDynamicJoin[i] == FALSE)
                {
                    continue;
                }

                if(!pServerUserItem)
                {
                    continue;
                }

                wRealPlayerCount++;
            }

            BYTE *pGameRule = m_pITableFrame->GetGameRule();

            //最大下注
            for(WORD i = 0; i < m_wPlayerCount; i++)
            {
                IServerUserItem *pServerUserItem = m_pITableFrame->GetTableUserItem(i);
                if(m_cbPlayStatus[i] == FALSE && m_cbDynamicJoin[i] == FALSE)
                {
                    continue;
                }
                GameStart.lTurnMaxScore = m_lTurnMaxScore[i];
                m_pITableFrame->SendTableData(i, SUB_S_GAME_START, &GameStart, sizeof(GameStart));

                if(m_pGameVideo)
                {
                    Video_GameStart video;
                    ZeroMemory(&video, sizeof(video));
                    video.lCellScore = m_pITableFrame->GetCellScore();
                    video.wPlayerCount = wRealPlayerCount;
                    video.wGamePlayerCountRule = pGameRule[1];
                    video.wBankerUser = GameStart.wBankerUser;
                    CopyMemory(video.cbPlayerStatus, GameStart.cbPlayerStatus, sizeof(video.cbPlayerStatus));
                    video.lTurnMaxScore = GameStart.lTurnMaxScore;
                    CopyMemory(video.cbCardData, GameStart.cbCardData, sizeof(video.cbCardData));
                    video.ctConfig = m_ctConfig;
                    video.stConfig = GameStart.stConfig;
                    video.bgtConfig = GameStart.bgtConfig;
                    video.btConfig = GameStart.btConfig;
                    video.gtConfig = GameStart.gtConfig;

                    CopyMemory(video.lFreeConfig, GameStart.lFreeConfig, sizeof(video.lFreeConfig));
                    CopyMemory(video.lPercentConfig, GameStart.lPercentConfig, sizeof(video.lPercentConfig));
                    CopyMemory(video.szNickName, pServerUserItem->GetNickName(), sizeof(video.szNickName));
                    video.wChairID = i;
                    video.lScore = pServerUserItem->GetUserScore();

                    m_pGameVideo->AddVideoData(SUB_S_GAME_START, &video, bFirstRecord);

                    if(bFirstRecord == true)
                    {
                        bFirstRecord = false;
                    }
                }
            }
            m_pITableFrame->SendLookonData(INVALID_CHAIR, SUB_S_GAME_START, &GameStart, sizeof(GameStart));
        }

        break;
    }
    //自由抢庄
    case BGT_FREEBANKER_:
    {
        //非房卡场设置定时器
        if(!IsRoomCardType())
        {
            m_pITableFrame->KillGameTimer(IDI_SO_OPERATE);
            m_pITableFrame->SetGameTimer(IDI_SO_OPERATE, TIME_SO_OPERATE, 1, 0);
        }

        //设置离线代打定时器
        for(WORD i = 0; i < m_wPlayerCount; i++)
        {
            if(m_cbPlayStatus[i] == TRUE && m_pITableFrame->GetTableUserItem(i)->IsTrusteeUser())
            {
                m_pITableFrame->SetGameTimer(IDI_OFFLINE_TRUSTEE_0 + i, m_cbTrusteeDelayTime * 1000, 1, 0);
            }
        }

        //设置状态
        m_pITableFrame->SetGameStatus(GS_TK_CALL);
        EnableTimeElapse(true);

        CMD_S_CallBanker CallBanker;
        ZeroMemory(&CallBanker, sizeof(CallBanker));
        CallBanker.ctConfig = m_ctConfig;
        CallBanker.stConfig = m_stConfig;
        CallBanker.bgtConfig = m_bgtConfig;

        BYTE *pGameRule = m_pITableFrame->GetGameRule();
        CallBanker.wGamePlayerCountRule = pGameRule[1];
        CallBanker.cbMaxCallBankerTimes = m_cbMaxCallBankerTimes;
        CallBanker.wBgtRobNewTurnChairID = m_wBgtRobNewTurnChairID;

        //更新房间用户信息
        for(WORD i = 0; i < m_wPlayerCount; i++)
        {
            //获取用户
            IServerUserItem *pIServerUserItem = m_pITableFrame->GetTableUserItem(i);
            if(pIServerUserItem != NULL)
            {
                UpdateRoomUserInfo(pIServerUserItem, USER_SITDOWN);
            }
        }

        //发送数据
        for(WORD i = 0; i < m_wPlayerCount; i++)
        {
            if(m_cbPlayStatus[i] != TRUE)
            {
                continue;
            }
            m_pITableFrame->SendTableData(i, SUB_S_CALL_BANKER, &CallBanker, sizeof(CallBanker));
        }
        m_pITableFrame->SendLookonData(INVALID_CHAIR, SUB_S_CALL_BANKER, &CallBanker, sizeof(CallBanker));

        if(m_pGameVideo)
        {
            m_pGameVideo->AddVideoData(SUB_S_CALL_BANKER, &CallBanker);
        }

        break;
    }
    //通比玩法
    case BGT_TONGBI_:
    {
        bool bFirstRecord = true;

        WORD wRealPlayerCount = 0;
        for(WORD i = 0; i < m_wPlayerCount; i++)
        {
            IServerUserItem *pServerUserItem = m_pITableFrame->GetTableUserItem(i);
            if(m_cbPlayStatus[i] == FALSE && m_cbDynamicJoin[i] == FALSE)
            {
                continue;
            }

            if(!pServerUserItem)
            {
                continue;
            }

            wRealPlayerCount++;
        }

        BYTE *pGameRule = m_pITableFrame->GetGameRule();

        for(WORD i = 0; i < m_wPlayerCount; i++)
        {
            IServerUserItem *pServerUserItem = m_pITableFrame->GetTableUserItem(i);
            if(m_cbPlayStatus[i] == FALSE && m_cbDynamicJoin[i] == FALSE)
            {
                continue;
            }

            if(m_pGameVideo)
            {
                Video_GameStart video;
                ZeroMemory(&video, sizeof(video));
                video.lCellScore = m_pITableFrame->GetCellScore();
                video.wPlayerCount = wRealPlayerCount;
                video.wGamePlayerCountRule = pGameRule[1];
                video.wBankerUser = INVALID_CHAIR;// 通比玩家没有庄家
                CopyMemory(video.cbPlayerStatus, m_cbPlayStatus, sizeof(video.cbPlayerStatus));
                video.lTurnMaxScore = 0;
                CopyMemory(video.cbCardData, m_cbHandCardData[i], sizeof(video.cbCardData));
                video.ctConfig = m_ctConfig;
                video.stConfig = m_stConfig;
                video.bgtConfig = m_bgtConfig;
                video.btConfig = m_btConfig;
                video.gtConfig = m_gtConfig;

                CopyMemory(video.lFreeConfig, m_lFreeConfig, sizeof(video.lFreeConfig));
                CopyMemory(video.lPercentConfig, m_lPercentConfig, sizeof(video.lPercentConfig));
                CopyMemory(video.szNickName, pServerUserItem->GetNickName(), sizeof(video.szNickName));
                video.wChairID = i;
                video.lScore = pServerUserItem->GetUserScore();

                m_pGameVideo->AddVideoData(SUB_S_GAME_START, &video, bFirstRecord);

                if(bFirstRecord == true)
                {
                    bFirstRecord = false;
                }
            }
        }

        m_wBankerUser = INVALID_CHAIR;

        //非房卡场设置定时器
        if(!IsRoomCardType())
        {
            m_pITableFrame->KillGameTimer(IDI_SO_OPERATE);
            m_pITableFrame->SetGameTimer(IDI_SO_OPERATE, TIME_SO_OPERATE, 1, 0);
        }

        //设置离线代打定时器
        for(WORD i = 0; i < m_wPlayerCount; i++)
        {
            if(m_cbPlayStatus[i] == TRUE && m_pITableFrame->GetTableUserItem(i)->IsTrusteeUser())
            {
                m_pITableFrame->SetGameTimer(IDI_OFFLINE_TRUSTEE_0 + i, m_cbTrusteeDelayTime * 1000, 1, 0);
            }
        }

        //设置状态
        m_pITableFrame->SetGameStatus(GS_TK_PLAYING);
        EnableTimeElapse(true);

        //更新房间用户信息
        for(WORD i = 0; i < m_wPlayerCount; i++)
        {
            //获取用户
            IServerUserItem *pIServerUserItem = m_pITableFrame->GetTableUserItem(i);
            if(pIServerUserItem != NULL)
            {
                UpdateRoomUserInfo(pIServerUserItem, USER_SITDOWN);
            }

            if(m_cbPlayStatus[i] == TRUE)
            {
                //下注金币(通比玩家下底注)
                m_lTableScore[i] = m_pITableFrame->GetCellScore();
                m_bBuckleServiceCharge[i] = true;
            }
        }

        //构造数据
        CMD_S_SendCard SendCard;
        ZeroMemory(SendCard.cbCardData, sizeof(SendCard.cbCardData));

        //通比玩法不分析
        //分析牌数据，下注发牌和发四等五区分处理
        //AnalyseCard(m_stConfig);

        //变量定义
        ROOMUSERDEBUG roomuserdebug;
        ZeroMemory(&roomuserdebug, sizeof(roomuserdebug));
        POSITION posKeyList;

        //调试 (下注发牌和发四等五区分调试)
        if(m_pServerDebug != NULL && AnalyseRoomUserDebug(roomuserdebug, posKeyList))
        {
            //校验数据
            ASSERT(roomuserdebug.roomUserInfo.wChairID != INVALID_CHAIR && roomuserdebug.userDebug.cbDebugCount != 0
                   && roomuserdebug.userDebug.debug_type != CONTINUE_CANCEL);

            if(m_pServerDebug->DebugResult(m_cbHandCardData, roomuserdebug, m_stConfig, m_ctConfig, m_gtConfig))
            {
                //获取元素
                ROOMUSERDEBUG &tmproomuserdebug = g_ListRoomUserDebug.GetAt(posKeyList);

                //校验数据
                ASSERT(roomuserdebug.userDebug.cbDebugCount == tmproomuserdebug.userDebug.cbDebugCount);

                //调试局数
                tmproomuserdebug.userDebug.cbDebugCount--;

                CMD_S_UserDebugComplete UserDebugComplete;
                ZeroMemory(&UserDebugComplete, sizeof(UserDebugComplete));
                UserDebugComplete.dwGameID = roomuserdebug.roomUserInfo.dwGameID;
                CopyMemory(UserDebugComplete.szNickName, roomuserdebug.roomUserInfo.szNickName, sizeof(UserDebugComplete.szNickName));
                UserDebugComplete.debugType = roomuserdebug.userDebug.debug_type;
                UserDebugComplete.cbRemainDebugCount = tmproomuserdebug.userDebug.cbDebugCount;

                for(WORD i = 0; i < m_wPlayerCount; i++)
                {
                    IServerUserItem *pIServerUserItem = m_pITableFrame->GetTableUserItem(i);
                    if(!pIServerUserItem)
                    {
                        continue;
                    }
                    if(pIServerUserItem->IsAndroidUser() == true || CUserRight::IsGameDebugUser(pIServerUserItem->GetUserRight()) == false)
                    {
                        continue;
                    }

                    //发送数据
                    m_pITableFrame->SendTableData(i, SUB_S_USER_DEBUG_COMPLETE, &UserDebugComplete, sizeof(UserDebugComplete));
                    m_pITableFrame->SendLookonData(i, SUB_S_USER_DEBUG_COMPLETE, &UserDebugComplete, sizeof(UserDebugComplete));

                }
            }
        }

        //临时扑克,因为分析和调试扑克，重算原始牌型
        BYTE cbTempHandCardData[GAME_PLAYER][MAX_CARDCOUNT];
        ZeroMemory(cbTempHandCardData, sizeof(cbTempHandCardData));
        CopyMemory(cbTempHandCardData, m_cbHandCardData, sizeof(m_cbHandCardData));

        for(WORD i = 0; i < m_wPlayerCount; i++)
        {
            IServerUserItem *pIServerUser = m_pITableFrame->GetTableUserItem(i);
            if(pIServerUser == NULL)
            {
                continue;
            }

            m_bSpecialCard[i] = (m_GameLogic.GetCardType(cbTempHandCardData[i], MAX_CARDCOUNT, m_ctConfig) > CT_CLASSIC_OX_VALUENIUNIU ? true : false);

            //特殊牌型
            if(m_bSpecialCard[i])
            {
                m_cbOriginalCardType[i] = m_GameLogic.GetCardType(cbTempHandCardData[i], MAX_CARDCOUNT, m_ctConfig);
            }
            else
            {
                //获取牛牛牌型
                m_GameLogic.GetOxCard(cbTempHandCardData[i], MAX_CARDCOUNT);

                m_cbOriginalCardType[i] = m_GameLogic.GetCardType(cbTempHandCardData[i], MAX_CARDCOUNT, m_ctConfig);
            }
        }

        CopyMemory(SendCard.cbCardData, m_cbHandCardData, sizeof(SendCard.cbCardData));
        CopyMemory(SendCard.bSpecialCard, m_bSpecialCard, sizeof(SendCard.bSpecialCard));
        CopyMemory(SendCard.cbOriginalCardType, m_cbOriginalCardType, sizeof(SendCard.cbOriginalCardType));

        //发送数据
        for(WORD i = 0; i < m_wPlayerCount; i++)
        {
            if(m_cbPlayStatus[i] == FALSE && m_cbDynamicJoin[i] == FALSE)
            {
                continue;
            }

            m_pITableFrame->SendTableData(i, SUB_S_SEND_CARD, &SendCard, sizeof(SendCard));
        }
        m_pITableFrame->SendLookonData(INVALID_CHAIR, SUB_S_SEND_CARD, &SendCard, sizeof(SendCard));

        if(m_pGameVideo)
        {
            m_pGameVideo->AddVideoData(SUB_S_SEND_CARD, &SendCard);
        }

        break;
    }
    default:
        break;
    }

    //用户状态
    for(WORD i = 0; i < m_wPlayerCount; i++)
    {
        //获取用户
        IServerUserItem *pIServerUserItem = m_pITableFrame->GetTableUserItem(i);
        if(pIServerUserItem != NULL)
        {
            //写日志
            CString strOperationRecord;
            strOperationRecord.Format(TEXT("TABLEID = %d 用户USERID = %d, userstatus = %d，游戏正式开始"), m_pITableFrame->GetTableID(), pIServerUserItem->GetUserID(), pIServerUserItem->GetUserStatus());
			CString strFileName = TEXT("流程日志");

            tagLogUserInfo LogUserInfo;
            ZeroMemory(&LogUserInfo, sizeof(LogUserInfo));
			CopyMemory(LogUserInfo.szDescName, strFileName, sizeof(LogUserInfo.szDescName));
            CopyMemory(LogUserInfo.szLogContent, strOperationRecord, sizeof(LogUserInfo.szLogContent));
            //m_pITableFrame->SendGameLogData(LogUserInfo);
        }
    }

    return true;
}

//游戏结束
bool CTableFrameSink::OnEventGameConclude(WORD wChairID, IServerUserItem *pIServerUserItem, BYTE cbReason)
{
    switch(cbReason)
    {
    case GER_DISMISS:		//游戏解散
    {
        //构造数据
        CMD_S_GameEnd GameEnd = { 0 };

        //发送信息
        m_pITableFrame->SendTableData(INVALID_CHAIR, SUB_S_GAME_END, &GameEnd, sizeof(GameEnd));
        m_pITableFrame->SendLookonData(INVALID_CHAIR, SUB_S_GAME_END, &GameEnd, sizeof(GameEnd));

        //结束游戏
        EnableTimeElapse(false);
        m_pITableFrame->ConcludeGame(GS_TK_FREE);

        if(!IsRoomCardType())
        {
            //删除时间
            m_pITableFrame->KillGameTimer(IDI_SO_OPERATE);

            //删除离线代打定时器
            for(WORD i = 0; i < m_wPlayerCount; i++)
            {
                m_pITableFrame->KillGameTimer(IDI_OFFLINE_TRUSTEE_0 + i);
            }
        }

        m_wBankerUser = INVALID_CHAIR;
        m_wFirstEnterUser = INVALID_CHAIR;

        //房卡模式
        if((m_pGameServiceOption->wServerType & GAME_GENRE_PERSONAL) != 0)
        {
            //解散清理记录
            if(m_pITableFrame->IsPersonalRoomDisumme())
            {
                ZeroMemory(&m_stRecord, sizeof(m_stRecord));
                m_lBgtDespotWinScore = 0L;
            }
        }

        //更新房间用户信息
        for(WORD i = 0; i < m_wPlayerCount; i++)
        {
            //获取用户
            IServerUserItem *pIServerUserItem = m_pITableFrame->GetTableUserItem(i);

            if(!pIServerUserItem)
            {
                continue;
            }

            UpdateRoomUserInfo(pIServerUserItem, USER_STANDUP);
        }

        m_bReNewTurn = true;

        return true;
    }
    case GER_NORMAL:		//常规结束
    {
        //定义变量
        CMD_S_GameEnd GameEnd;
        ZeroMemory(&GameEnd, sizeof(GameEnd));

        //保存扑克
        BYTE cbUserCardData[GAME_PLAYER][MAX_CARDCOUNT];
        CopyMemory(cbUserCardData, m_cbHandCardData, sizeof(cbUserCardData));

        //赋值最后一张牌
        for(WORD i = 0; i < m_wPlayerCount; i++)
        {
            GameEnd.cbLastSingleCardData[i] = m_cbOriginalCardData[i][4];
        }

        WORD wWinTimes[GAME_PLAYER];

        //非通比玩法
        if(m_bgtConfig != BGT_TONGBI_)
        {
            WORD wWinCount[GAME_PLAYER];
            ZeroMemory(wWinCount, sizeof(wWinCount));
            ZeroMemory(wWinTimes, sizeof(wWinTimes));

            //倍数抢庄 结算需要乘以cbMaxCallBankerTimes
            BYTE cbMaxCallBankerTimes = 1;
            if(m_bgtConfig == BGT_ROB_)
            {
                for(WORD i = 0; i < m_wPlayerCount; i++)
                {
                    if(m_cbPlayStatus[i] == TRUE && m_cbCallBankerStatus[i] == TRUE && m_cbCallBankerTimes[i] > cbMaxCallBankerTimes)
                    {
                        cbMaxCallBankerTimes = m_cbCallBankerTimes[i];
                    }
                }
            }

            //庄家倍数
            wWinTimes[m_wBankerUser] = m_GameLogic.GetTimes(cbUserCardData[m_wBankerUser], MAX_CARDCOUNT, m_ctConfig, m_cbCombineCardType[m_wBankerUser]);

            //对比玩家
            for(WORD i = 0; i < m_wPlayerCount; i++)
            {
                if(i == m_wBankerUser || m_cbPlayStatus[i] == FALSE) { continue; }

                //对比扑克
                if(m_GameLogic.CompareCard(cbUserCardData[i], cbUserCardData[m_wBankerUser], MAX_CARDCOUNT, m_ctConfig, m_cbCombineCardType[i], m_cbCombineCardType[m_wBankerUser]))
                {
                    wWinCount[i]++;
                    //获取倍数
                    wWinTimes[i] = m_GameLogic.GetTimes(cbUserCardData[i], MAX_CARDCOUNT, m_ctConfig, m_cbCombineCardType[i]);
                }
                else
                {
                    wWinCount[m_wBankerUser]++;
                }
            }

            //临时下注数目
            LONGLONG lTempTableScore[GAME_PLAYER];
            ZeroMemory(lTempTableScore, sizeof(lTempTableScore));
            CopyMemory(lTempTableScore, m_lTableScore, sizeof(lTempTableScore));

            //统计得分
			for (WORD i = 0; i<m_wPlayerCount; i++)
			{
				if (i == m_wBankerUser || m_cbPlayStatus[i] == FALSE)continue;

				if (wWinCount[i]>0)	//闲家胜利
				{
					LONGLONG lXianWinScore = m_lTableScore[i] * wWinTimes[i] * cbMaxCallBankerTimes;
					LONGLONG lCarryScore = m_pITableFrame->GetTableUserItem(i)->GetUserScore();

					//玩家单局最大赢分以身上携带分值为上限
					lXianWinScore = min(lXianWinScore, lCarryScore);

					GameEnd.lGameScore[i] = lXianWinScore;
					GameEnd.lGameScore[m_wBankerUser] -= lXianWinScore;
					m_lTableScore[i] = 0;
				}
				else					//庄家胜利
				{
					//玩家身上有多少分就赔付多少分。
					LONGLONG lXianLostScore = m_lTableScore[i] * wWinTimes[m_wBankerUser] * cbMaxCallBankerTimes;
					LONGLONG lCarryScore = m_pITableFrame->GetTableUserItem(i)->GetUserScore();

					lXianLostScore = -min(lXianLostScore, lCarryScore);

					GameEnd.lGameScore[i] = lXianLostScore;
					GameEnd.lGameScore[m_wBankerUser] += (-1)*GameEnd.lGameScore[i];
					m_lTableScore[i] = 0;
				}
			}

            //闲家强退分数
            GameEnd.lGameScore[m_wBankerUser] += m_lExitScore;

            //离开用户
            for(WORD i = 0; i < m_wPlayerCount; i++)
            {
                if(m_lTableScore[i] > 0) { GameEnd.lGameScore[i] = -m_lTableScore[i]; }
            }

            //调整结算得分(庄家携带分不够赔的情况)
            ASSERT(m_wBankerUser != INVALID_CHAIR);

            LONGLONG lAllPlayerWinScore = 0;
            for(WORD i = 0; i < m_wPlayerCount; i++)
            {
                if(i == m_wBankerUser || m_cbPlayStatus[i] == FALSE)
                {
                    continue;
                }

                lAllPlayerWinScore += GameEnd.lGameScore[i];
            }

			//庄家不够赔
			ASSERT(lAllPlayerWinScore == -GameEnd.lGameScore[m_wBankerUser]);
			if (lAllPlayerWinScore > 0 && (m_pITableFrame->GetTableUserItem(m_wBankerUser)->GetUserScore() + GameEnd.lGameScore[m_wBankerUser]) < 0)
			{
				LONGLONG lBankerRemainScore = m_pITableFrame->GetTableUserItem(m_wBankerUser)->GetUserScore();
				for (WORD i = 0; i<m_wPlayerCount; i++)
				{
					if (i == m_wBankerUser || m_cbPlayStatus[i] == FALSE || GameEnd.lGameScore[i] >= 0)
					{
						continue;
					}

					lBankerRemainScore += (-GameEnd.lGameScore[i]);
				}

				LONGLONG lUserNeedScore = 0;
				for (WORD i = 0; i<m_wPlayerCount; i++)
				{
					if (i == m_wBankerUser || m_cbPlayStatus[i] == FALSE || GameEnd.lGameScore[i] <= 0)
					{
						continue;
					}

					lUserNeedScore += GameEnd.lGameScore[i];
				}

				LONGLONG lTotalMidVal = 0;
				for (WORD i = 0; i<m_wPlayerCount; i++)
				{
					if (i == m_wBankerUser || m_cbPlayStatus[i] == FALSE || GameEnd.lGameScore[i] <= 0)
					{
						continue;
					}

					GameEnd.lGameScore[i] = (double)(((double)lBankerRemainScore) / ((double)(lUserNeedScore))) * GameEnd.lGameScore[i];

					//玩家赢分改成：玩家单局最大赢分以身上携带分值为上限。
					LONGLONG lUserCarryScore = m_pITableFrame->GetTableUserItem(i)->GetUserScore();
					if (GameEnd.lGameScore[i] > lUserCarryScore)
					{
						GameEnd.lGameScore[i] = lUserCarryScore;
						LONGLONG lMidVal = GameEnd.lGameScore[i] - lUserCarryScore;
						lTotalMidVal += lMidVal;
					}
				}

				GameEnd.lGameScore[m_wBankerUser] = -m_pITableFrame->GetTableUserItem(m_wBankerUser)->GetUserScore() + lTotalMidVal;
			}

			//庄家赢分改成：庄家单局最大赢分以身上携带分值为上限。
			if (lAllPlayerWinScore < 0 && (-lAllPlayerWinScore) > m_pITableFrame->GetTableUserItem(m_wBankerUser)->GetUserScore())
			{
				LONGLONG lUserNeedScore = 0;
				LONGLONG lBankerCarryScore = m_pITableFrame->GetTableUserItem(m_wBankerUser)->GetUserScore();
				for (WORD i = 0; i<m_wPlayerCount; i++)
				{
					if (i == m_wBankerUser || m_cbPlayStatus[i] == FALSE || GameEnd.lGameScore[i] >= 0)
					{
						continue;
					}

					lUserNeedScore += GameEnd.lGameScore[i];
				}

				//计算闲家赢分 
				LONGLONG lUserWinScore = 0;
				for (WORD i = 0; i < m_wPlayerCount; i++)
				{
					if (i == m_wBankerUser || m_cbPlayStatus[i] == FALSE || GameEnd.lGameScore[i] <= 0)
					{
						continue;
					}

					//闲家赢的总分
					lUserWinScore += GameEnd.lGameScore[i];
				}

				//把闲家赢分转嫁到庄家携带的金币
				lBankerCarryScore += lUserWinScore;

				//调整闲家按照比例赔付
				for (WORD i = 0; i < m_wPlayerCount; i++)
				{
					if (i == m_wBankerUser || m_cbPlayStatus[i] == FALSE || GameEnd.lGameScore[i] >= 0)
					{
						continue;
					}

					GameEnd.lGameScore[i] = -((double)((double)GameEnd.lGameScore[i] / (double)lUserNeedScore)) * lBankerCarryScore;
				}

				GameEnd.lGameScore[m_wBankerUser] = 0;
				for (WORD i = 0; i < m_wPlayerCount; i++)
				{
					if (i == m_wBankerUser || m_cbPlayStatus[i] == FALSE)
					{
						continue;
					}

					GameEnd.lGameScore[m_wBankerUser] += (-GameEnd.lGameScore[i]);
				}
			}

            for(WORD i = 0; i < m_wPlayerCount; i++)
            {
                if(m_cbPlayStatus[i] == FALSE)
                {
                    continue;
                }

                m_lLastTurnWinScore[i] = GameEnd.lGameScore[i];
                m_bLastTurnBeBanker[i] = (i == m_wBankerUser ? true : false);

                //获取用户
                IServerUserItem *pIKeyServerUserItem = m_pITableFrame->GetTableUserItem(i);

                //写日志
                CString strUser;
                strUser.Format(TEXT("TABLEID = %d, CHAIRID = %d USERID = %d， 庄家标志 %d, 得分 %I64d ,房主USERID = %d, m_bgtConfig = %d"), m_pITableFrame->GetTableID(), i, pIKeyServerUserItem->GetUserID(), m_bLastTurnBeBanker[i], m_lLastTurnWinScore[i], m_pITableFrame->GetTableOwner(), m_bgtConfig);
				CString strFileName = TEXT("流程日志");

                tagLogUserInfo LogUserInfo;
                ZeroMemory(&LogUserInfo, sizeof(LogUserInfo));
                CopyMemory(LogUserInfo.szDescName, strFileName, sizeof(LogUserInfo.szDescName));
                CopyMemory(LogUserInfo.szLogContent, strUser, sizeof(LogUserInfo.szLogContent));
                //m_pITableFrame->SendGameLogData(LogUserInfo);

				strUser += TEXT("\n");
				WriteInfo(TEXT("八人牛调试日志.log"), strUser);
            }
        }
        else
        {
            ASSERT(m_wBankerUser == INVALID_CHAIR);

            //大家一起比牌，最大的牌型通吃。
            //胜利玩家
            WORD wWinner = INVALID_CHAIR;

            for(WORD i = 0; i < m_wPlayerCount; i++)
            {
                if(m_cbPlayStatus[i] == FALSE) { continue; }

                if(wWinner == INVALID_CHAIR)
                {
                    wWinner = i;
                }

                //对比扑克
                if(m_GameLogic.CompareCard(cbUserCardData[i], cbUserCardData[wWinner], MAX_CARDCOUNT, m_ctConfig, m_cbCombineCardType[i], m_cbCombineCardType[wWinner]))
                {
                    wWinner = i;
                }
            }

            WORD wWinTimes = m_GameLogic.GetTimes(cbUserCardData[wWinner], MAX_CARDCOUNT, m_ctConfig, m_cbCombineCardType[wWinner]);

            //统计得分
            for(WORD i = 0; i < m_wPlayerCount; i++)
            {
                if(i == wWinner || m_cbPlayStatus[i] == FALSE)
                {
                    continue;
                }

                GameEnd.lGameScore[i] = -min(m_pITableFrame->GetTableUserItem(i)->GetUserScore(), m_lTableScore[i] * wWinTimes);
                m_lTableScore[i] = 0;

                GameEnd.lGameScore[wWinner] += (-GameEnd.lGameScore[i]);
            }

            GameEnd.lGameScore[wWinner] += m_lExitScore;
            m_lTableScore[wWinner] = 0;

            //离开用户
            for(WORD i = 0; i < m_wPlayerCount; i++)
            {
                if(m_lTableScore[i] > 0) { GameEnd.lGameScore[i] = -m_lTableScore[i]; }
            }
        }

        //修改积分
        tagScoreInfo ScoreInfoArray[GAME_PLAYER];
        ZeroMemory(ScoreInfoArray, sizeof(ScoreInfoArray));

        //积分税收
        for(WORD i = 0; i < m_wPlayerCount; i++)
        {
            if(m_cbPlayStatus[i] == FALSE) { continue; }

            if(((m_pGameServiceOption->wServerType & GAME_GENRE_PERSONAL) == 0) ||
                    ((m_pGameServiceOption->wServerType & GAME_GENRE_PERSONAL) != 0 && m_pITableFrame->GetDataBaseMode() == 1))
            {
                if(GameEnd.lGameScore[i] > 0L)
                {
                    GameEnd.lGameTax[i] = m_pITableFrame->CalculateRevenue(i, GameEnd.lGameScore[i]);
                    if(GameEnd.lGameTax[i] > 0)
                    {
                        GameEnd.lGameScore[i] -= GameEnd.lGameTax[i];
                    }
                }
            }

            //历史积分
            m_HistoryScore.OnEventUserScore(i, GameEnd.lGameScore[i]);

            //保存积分
            ScoreInfoArray[i].lScore = GameEnd.lGameScore[i];
            ScoreInfoArray[i].lRevenue = GameEnd.lGameTax[i];
            ScoreInfoArray[i].cbType = (GameEnd.lGameScore[i] > 0L) ? SCORE_TYPE_WIN : SCORE_TYPE_LOSE;

            //约战记录
            if(m_stRecord.nCount < MAX_RECORD_COUNT)
            {
                if(GameEnd.lGameScore[i] > 0)
                {
                    m_stRecord.lUserWinCount[i]++;
                }
                else
                {
                    m_stRecord.lUserLostCount[i]++;
                }
            }

            //房卡模式
            //积分房卡
            if((m_pITableFrame->GetDataBaseMode() == 0) && !m_pITableFrame->IsPersonalRoomDisumme() && ((m_pGameServiceOption->wServerType & GAME_GENRE_PERSONAL) != 0) && (m_RoomCardRecord.nCount < MAX_RECORD_COUNT))
            {
                m_RoomCardRecord.lDetailScore[i][m_RoomCardRecord.nCount] = ScoreInfoArray[i].lScore;
            }
            //金币房卡
            else if((m_pITableFrame->GetDataBaseMode() == 1) && ((m_pGameServiceOption->wServerType & GAME_GENRE_PERSONAL) != 0))
            {
                m_listWinScoreRecord[i].AddHead(ScoreInfoArray[i].lScore);
            }
        }

        m_stRecord.nCount++;

        //房卡模式
        if((m_pITableFrame->GetDataBaseMode() == 0) && (m_pGameServiceOption->wServerType & GAME_GENRE_PERSONAL) != 0 && (m_RoomCardRecord.nCount < MAX_RECORD_COUNT))
        {
            m_RoomCardRecord.nCount++;
        }

        //房卡模式
        if((m_pGameServiceOption->wServerType & GAME_GENRE_PERSONAL) != 0)
        {
            m_pITableFrame->SendTableData(INVALID_CHAIR, SUB_S_RECORD, &m_stRecord, sizeof(m_stRecord));

            CMD_S_RoomCardRecord RoomCardRecord;
            ZeroMemory(&RoomCardRecord, sizeof(RoomCardRecord));

            CopyMemory(&RoomCardRecord, &m_RoomCardRecord, sizeof(m_RoomCardRecord));

            m_pITableFrame->SendTableData(INVALID_CHAIR, SUB_S_ROOMCARD_RECORD, &RoomCardRecord, sizeof(RoomCardRecord));
            m_pITableFrame->SendLookonData(INVALID_CHAIR, SUB_S_ROOMCARD_RECORD, &RoomCardRecord, sizeof(RoomCardRecord));
        }

        for(WORD i = 0; i < m_wPlayerCount; i++)
        {
            if(m_cbPlayStatus[i] == FALSE || m_bSpecialCard[i] == false)
            {
                continue;
            }

            m_GameLogic.GetSpecialSortCard(m_cbCombineCardType[i], m_cbHandCardData[i], MAX_CARDCOUNT, m_ctConfig);
        }

        CopyMemory(GameEnd.cbHandCardData, m_cbHandCardData, sizeof(m_cbHandCardData));

        //获取玩家牌型
        for(WORD i = 0; i < m_wPlayerCount; i++)
        {
            if(m_cbPlayStatus[i] == FALSE)
            {
                continue;
            }

            GameEnd.cbCardType[i] = m_cbCombineCardType[i];
        }

        //拷贝牌型倍数
        CopyMemory(GameEnd.wCardTypeTimes, wWinTimes, sizeof(wWinTimes));

        //发送信息
        for(WORD i = 0; i < m_wPlayerCount; i++)
        {
            if(m_cbPlayStatus[i] == FALSE && m_cbDynamicJoin[i] == FALSE) { continue; }
            m_pITableFrame->SendTableData(i, SUB_S_GAME_END, &GameEnd, sizeof(GameEnd));
        }

        m_pITableFrame->SendLookonData(INVALID_CHAIR, SUB_S_GAME_END, &GameEnd, sizeof(GameEnd));

		CopyMemory(&m_GameEndEx, &GameEnd, sizeof(GameEnd));
		m_GameEndEx.dwTickCountGameEnd = (DWORD)time(NULL);

        if(m_pGameVideo)
        {
            m_pGameVideo->AddVideoData(SUB_S_GAME_END, &GameEnd);
        }

        if(m_pGameVideo)
        {
            m_pGameVideo->StopAndSaveVideo(m_pGameServiceOption->wServerID, m_pITableFrame->GetTableID());
        }

        TryWriteTableScore(ScoreInfoArray);

		//发送信息
		for (WORD i = 0; i<m_wPlayerCount; i++)
		{
			//获取用户
			IServerUserItem * pIServerUserItem = m_pITableFrame->GetTableUserItem(i);
			if (pIServerUserItem == NULL)
			{
				continue;
			}

			if (m_cbPlayStatus[i] == FALSE&&m_cbDynamicJoin[i] == FALSE)
			{
				continue;
			}

			if (!pIServerUserItem->IsAndroidUser())
			{
				continue;
			}

			if (!pIServerUserItem->IsClientReady())
			{
				continue;
			}

			m_pITableFrame->SendTableData(i, SUB_S_ANDROID_BANKOPER);
		}

        //库存统计
        for(WORD i = 0; i < m_wPlayerCount; i++)
        {
            //获取用户
            IServerUserItem *pIServerUserIte = m_pITableFrame->GetTableUserItem(i);
            if(pIServerUserIte == NULL) { continue; }

            //库存累计
            if(!pIServerUserIte->IsAndroidUser())
            {
                g_lRoomStorageCurrent -= GameEnd.lGameScore[i];
            }

        }

        //牛牛当庄 场上有牛牛以及牛牛以上的牌型，由最大的牌型玩家当庄, 如果没有还是原来的当庄
        if(m_bgtConfig == BGT_NIUNIU_)
        {
            //牌型最大玩家
            WORD wMaxPlayerUser = INVALID_CHAIR;

            for(WORD i = 0; i < m_wPlayerCount; i++)
            {
                //获取用户
                IServerUserItem *pIServerUserItem = m_pITableFrame->GetTableUserItem(i);
                if(pIServerUserItem == NULL)
                {
                    continue;
                }

                if(wMaxPlayerUser == INVALID_CHAIR)
                {
                    wMaxPlayerUser = i;
                }

                //获取较大者
                if(m_GameLogic.CompareCard(cbUserCardData[i], m_cbHandCardData[wMaxPlayerUser], MAX_CARDCOUNT, m_ctConfig, m_cbCombineCardType[i], m_cbCombineCardType[wMaxPlayerUser]) == true)
                {
                    wMaxPlayerUser = i;
                }
            }

            BYTE cbMaxCardType = ((m_cbCombineCardType[wMaxPlayerUser] == INVALID_BYTE) ? (m_GameLogic.GetCardType(m_cbHandCardData[wMaxPlayerUser], MAX_CARDCOUNT, m_ctConfig)) : m_cbCombineCardType[wMaxPlayerUser]);

            //如果牌型比牛牛少原来的玩家当庄
            if(cbMaxCardType >= CT_ADDTIMES_OX_VALUENIUNIU)
            {
                //牌型最大玩家当庄
                m_wBankerUser = wMaxPlayerUser;
            }

            //按照牌型排序大小
            //保存扑克
            m_listCardTypeOrder.RemoveAll();
            BYTE cbTempCardData[GAME_PLAYER][MAX_CARDCOUNT];
            CopyMemory(cbTempCardData, m_cbHandCardData, sizeof(cbTempCardData));

            BYTE cbTempCombineCardType[GAME_PLAYER];
            CopyMemory(cbTempCombineCardType, m_cbCombineCardType, sizeof(cbTempCombineCardType));

            for(WORD i = 0; i < m_wPlayerCount; i++)
            {
                //获取用户
                IServerUserItem *pIServerUserItemI = m_pITableFrame->GetTableUserItem(i);
                if(pIServerUserItemI == NULL)
                {
                    continue;
                }

                for(WORD j = 0; j < m_wPlayerCount - i - 1; j++)
                {
                    //获取用户
                    IServerUserItem *pIServerUserItemJ = m_pITableFrame->GetTableUserItem(j);
                    if(pIServerUserItemJ == NULL)
                    {
                        continue;
                    }

                    //获取较大者
                    if(m_GameLogic.CompareCard(cbTempCardData[i], cbTempCardData[j], MAX_CARDCOUNT, m_ctConfig, cbTempCombineCardType[i], cbTempCombineCardType[j]) == false)
                    {
                        BYTE cbTempData[MAX_CARDCOUNT];
                        CopyMemory(cbTempData, cbTempCardData[j], sizeof(cbTempData));
                        CopyMemory(cbTempCardData[j], cbTempCardData[i], sizeof(cbTempCardData[j]));
                        CopyMemory(cbTempCardData[i], cbTempData, sizeof(cbTempCardData[i]));

                        BYTE cbTempType = cbTempCombineCardType[j];
                        cbTempCombineCardType[j] = cbTempCombineCardType[i];
                        cbTempCombineCardType[i] = cbTempType;
                    }
                }
            }

            for(WORD i = 0; i < GAME_PLAYER; i++)
            {
                if(cbTempCardData[i][0] == 0)
                {
                    continue;
                }

                WORD wKeyChairID = SearchKeyCardChairID(cbTempCardData[i]);
                ASSERT(wKeyChairID != INVALID_CHAIR);

                m_listCardTypeOrder.AddTail(wKeyChairID);
            }
        }
        //无牛下庄
        else if(m_bgtConfig == BGT_NONIUNIU_)
        {
            //庄家无牛轮到下一位上庄
            ASSERT(m_wBankerUser != INVALID_CHAIR);
            BYTE cbBankerCardType = ((m_cbCombineCardType[m_wBankerUser] == INVALID_BYTE) ? (m_GameLogic.GetCardType(m_cbHandCardData[m_wBankerUser], MAX_CARDCOUNT, m_ctConfig)) : m_cbCombineCardType[m_wBankerUser]);
            if(cbBankerCardType == CT_CLASSIC_OX_VALUE0
                    || cbBankerCardType == CT_ADDTIMES_OX_VALUE0)
            {
                //始叫用户
                while(true)
                {
                    m_wBankerUser = (m_wBankerUser + 1) % m_wPlayerCount;
                    if(m_pITableFrame->GetTableUserItem(m_wBankerUser) != NULL && m_cbPlayStatus[m_wBankerUser] == TRUE)
                    {
                        break;
                    }
                }
            }
        }

        //发送库存
		CMD_S_ADMIN_STORAGE_INFO StorageInfo;
		ZeroMemory(&StorageInfo, sizeof(StorageInfo));
		StorageInfo.lRoomStorageStart = g_lRoomStorageStart;
		StorageInfo.lRoomStorageCurrent = g_lRoomStorageCurrent;
		StorageInfo.lRoomStorageDeduct = g_lStorageDeductRoom;
		StorageInfo.lMaxRoomStorage[0] = g_lStorageMax1Room;
		StorageInfo.lMaxRoomStorage[1] = g_lStorageMax2Room;
		StorageInfo.wRoomStorageMul[0] = (WORD)g_lStorageMul1Room;
		StorageInfo.wRoomStorageMul[1] = (WORD)g_lStorageMul2Room;
		m_pITableFrame->SendRoomData(NULL, SUB_S_ADMIN_STORAGE_INFO, &StorageInfo, sizeof(StorageInfo));

        //房卡模式
        if((m_pGameServiceOption->wServerType & GAME_GENRE_PERSONAL) != 0)
        {
            //解散清理记录
            if(m_pITableFrame->IsPersonalRoomDisumme())
            {
                ZeroMemory(&m_stRecord, sizeof(m_stRecord));
                ZeroMemory(&m_RoomCardRecord, sizeof(m_RoomCardRecord));
                m_lBgtDespotWinScore = 0L;
            }
        }

        //私人房霸王庄庄家统计输赢
        BOOL bEndLoop = FALSE;
        if(m_bgtConfig == BGT_DESPOT_ && m_lBeBankerCondition != INVALID_DWORD)
        {
            m_lBgtDespotWinScore += GameEnd.lGameScore[m_wBankerUser];

            if((-m_lBgtDespotWinScore) > m_lBeBankerCondition)
            {
                bEndLoop = TRUE;
            }
        }

        EnableTimeElapse(false);
		m_pITableFrame->SetGameTimer(IDI_DELAY_GAMEFREE, TIME_DELAY_GAMEFREE, 1, (WPARAM)(&bEndLoop));
		//m_pITableFrame->ConcludeGame(GS_TK_FREE, bEndLoop);

        if(!IsRoomCardType())
        {
            //删除时间
            m_pITableFrame->KillGameTimer(IDI_SO_OPERATE);

            //删除离线代打定时器
            for(WORD i = 0; i < m_wPlayerCount; i++)
            {
                m_pITableFrame->KillGameTimer(IDI_OFFLINE_TRUSTEE_0 + i);
            }
        }

        //更新房间用户信息
        for(WORD i = 0; i < m_wPlayerCount; i++)
        {
            //获取用户
            IServerUserItem *pIServerUserItem = m_pITableFrame->GetTableUserItem(i);

            if(!pIServerUserItem)
            {
                continue;
            }

            UpdateRoomUserInfo(pIServerUserItem, USER_SITDOWN);
        }

        m_bReNewTurn = false;

        //修复漏洞
        //先拿 1号椅子创建房间，创建通比玩法，然后完了之后解散，这个时候再创建一个牛牛上庄或者无牛下庄，如果刚好那是拿1号椅子创建，m_wBankerUser就为无效服务端崩溃
        if(((m_pGameServiceOption->wServerType & GAME_GENRE_PERSONAL) != 0) && m_pITableFrame->IsPersonalRoomDisumme())
        {
            m_bReNewTurn = true;
            m_wBankerUser = INVALID_CHAIR;
        }

        return true;
    }
    case GER_USER_LEAVE:		//用户强退
    case GER_NETWORK_ERROR:
    {
        //旗舰平台没有强退
        //效验参数
        ASSERT(pIServerUserItem != NULL);
        ASSERT(wChairID < m_wPlayerCount && (m_cbPlayStatus[wChairID] == TRUE || m_cbDynamicJoin[wChairID] == FALSE));

        if(m_cbPlayStatus[wChairID] == FALSE) { return true; }
        //设置状态
        m_cbPlayStatus[wChairID] = FALSE;
        m_cbDynamicJoin[wChairID] = FALSE;

        //定义变量
        CMD_S_PlayerExit PlayerExit;
        PlayerExit.wPlayerID = wChairID;

        //发送信息
        for(WORD i = 0; i < m_wPlayerCount; i++)
        {
            if(i == wChairID || (m_cbPlayStatus[i] == FALSE && m_cbDynamicJoin[i] == FALSE)) { continue; }
            m_pITableFrame->SendTableData(i, SUB_S_PLAYER_EXIT, &PlayerExit, sizeof(PlayerExit));
        }
        m_pITableFrame->SendLookonData(INVALID_CHAIR, SUB_S_PLAYER_EXIT, &PlayerExit, sizeof(PlayerExit));

        ////////////////////////////////////
        if(m_bgtConfig == BGT_TONGBI_)
        {
            //逃跑那个玩家直接扣底住，然后直接写分，如果剩下超过2个以上的玩家继续比牌，  那逃跑玩家的底住加到那个赢的玩家身上，  如果逃跑后只剩一个玩家，就结束
            m_lExitScore += m_lTableScore[wChairID];

            tagScoreInfo ScoreInfo;
            ZeroMemory(&ScoreInfo, sizeof(ScoreInfo));
            ScoreInfo.lScore = -m_lTableScore[wChairID];
            ScoreInfo.cbType = SCORE_TYPE_FLEE;

            m_pITableFrame->WriteUserScore(wChairID, ScoreInfo);

            m_lTableScore[wChairID] = 0;

            //获取用户
            IServerUserItem *pIServerUserIte = m_pITableFrame->GetTableUserItem(wChairID);

            //库存累计
            if((pIServerUserIte != NULL) && (!pIServerUserIte->IsAndroidUser()))
            {
                g_lRoomStorageCurrent -= ScoreInfo.lScore;
            }

            //玩家人数
            WORD wUserCount = 0;
            for(WORD i = 0; i < m_wPlayerCount; i++)
            {
                if(m_cbPlayStatus[i] == TRUE)
                {
                    wUserCount++;
                }
            }

            //结束游戏
            if(wUserCount == 1)
            {
                //定义变量
                CMD_S_GameEnd GameEnd;
                ZeroMemory(&GameEnd, sizeof(GameEnd));
                CopyMemory(GameEnd.cbHandCardData, m_cbHandCardData, sizeof(m_cbHandCardData));

                //赋值最后一张牌
                for(WORD i = 0; i < m_wPlayerCount; i++)
                {
                    GameEnd.cbLastSingleCardData[i] = m_cbOriginalCardData[i][4];
                }

                //获取玩家牌型
                for(WORD i = 0; i < m_wPlayerCount; i++)
                {
                    if(m_cbPlayStatus[i] == FALSE && i != wChairID)
                    {
                        continue;
                    }

                    if(i == wChairID)
                    {
                        GameEnd.cbCardType[i] = (m_cbCombineCardType[i] == 0 ? m_cbOriginalCardType[i] : m_cbCombineCardType[i]);
                        continue;
                    }

                    GameEnd.lGameScore[i] = m_pITableFrame->GetCellScore();
                    if(((m_pGameServiceOption->wServerType & GAME_GENRE_PERSONAL) == 0) ||
                            ((m_pGameServiceOption->wServerType & GAME_GENRE_PERSONAL) != 0 && m_pITableFrame->GetDataBaseMode() == 1))
                    {
                        GameEnd.lGameTax[i] = m_pITableFrame->CalculateRevenue(i, GameEnd.lGameScore[i]);
                    }
                    GameEnd.lGameScore[i] = GameEnd.lGameScore[i] - GameEnd.lGameTax[i];
                    GameEnd.cbCardType[i] = (m_cbCombineCardType[i] == 0 ? m_cbOriginalCardType[i] : m_cbCombineCardType[i]);
                }

                //发送信息
                m_pITableFrame->SendTableData(INVALID_CHAIR, SUB_S_GAME_END, &GameEnd, sizeof(GameEnd));
                m_pITableFrame->SendLookonData(INVALID_CHAIR, SUB_S_GAME_END, &GameEnd, sizeof(GameEnd));

                if(m_pGameVideo)
                {
                    m_pGameVideo->AddVideoData(SUB_S_GAME_END, &GameEnd);
                    m_pGameVideo->StopAndSaveVideo(m_pGameServiceOption->wServerID, m_pITableFrame->GetTableID());
                }

                for(WORD i = 0; i < m_wPlayerCount; i++)
                {
                    if(m_cbPlayStatus[i] == FALSE)
                    {
                        continue;
                    }

                    //修改积分
                    tagScoreInfo ScoreInfo;
                    ZeroMemory(&ScoreInfo, sizeof(ScoreInfo));
                    ScoreInfo.lScore = GameEnd.lGameScore[i];
                    ScoreInfo.lRevenue = GameEnd.lGameTax[i];
                    ScoreInfo.cbType = (GameEnd.lGameScore[i] > 0 ? SCORE_TYPE_WIN : SCORE_TYPE_LOSE);

                    m_pITableFrame->WriteUserScore(i, ScoreInfo);

                    //获取用户
                    IServerUserItem *pIServerUserIte = m_pITableFrame->GetTableUserItem(i);

                    //库存累计
                    if((pIServerUserIte != NULL) && (!pIServerUserIte->IsAndroidUser()))
                    {
                        g_lRoomStorageCurrent -= GameEnd.lGameScore[i];
                    }
                }

                //结束游戏
                m_pITableFrame->ConcludeGame(GS_TK_FREE);

                if(!IsRoomCardType())
                {
                    //删除时间
                    m_pITableFrame->KillGameTimer(IDI_SO_OPERATE);

                    //删除离线代打定时器
                    for(WORD i = 0; i < m_wPlayerCount; i++)
                    {
                        m_pITableFrame->KillGameTimer(IDI_OFFLINE_TRUSTEE_0 + i);
                    }
                }

                UpdateRoomUserInfo(pIServerUserItem, USER_STANDUP);

                //更新房间用户信息
                for(WORD i = 0; i < m_wPlayerCount; i++)
                {
                    if(i == wChairID)
                    {
                        continue;
                    }

                    //获取用户
                    IServerUserItem *pIServerUserItem = m_pITableFrame->GetTableUserItem(i);

                    if(!pIServerUserItem)
                    {
                        continue;
                    }

                    UpdateRoomUserInfo(pIServerUserItem, USER_SITDOWN);
                }

                m_bReNewTurn = false;

                return true;
            }

            OnUserOpenCard(wChairID, m_cbHandCardData[wChairID]);
        }

        ////////////////////////////////////
        WORD wWinTimes[GAME_PLAYER];
        ZeroMemory(wWinTimes, sizeof(wWinTimes));

        //倍数抢庄 结算需要乘以cbMaxCallBankerTimes
        BYTE cbMaxCallBankerTimes = 1;
        if(m_bgtConfig == BGT_ROB_)
        {
            for(WORD i = 0; i < m_wPlayerCount; i++)
            {
                if(m_cbPlayStatus[i] == TRUE && m_cbCallBankerStatus[i] == TRUE && m_cbCallBankerTimes[i] > cbMaxCallBankerTimes)
                {
                    cbMaxCallBankerTimes = m_cbCallBankerTimes[i];
                }
            }
        }

        //游戏进行 （下注后）
        if(m_pITableFrame->GetGameStatus() == GS_TK_PLAYING)
        {
            if(wChairID == m_wBankerUser)	//庄家强退
            {
                //定义变量
                CMD_S_GameEnd GameEnd;
                ZeroMemory(&GameEnd, sizeof(GameEnd));
                ZeroMemory(wWinTimes, sizeof(wWinTimes));
                CopyMemory(GameEnd.cbHandCardData, m_cbHandCardData, sizeof(m_cbHandCardData));

                BYTE cbUserCardData[GAME_PLAYER][MAX_CARDCOUNT];
                CopyMemory(cbUserCardData, m_cbHandCardData, sizeof(cbUserCardData));

                //赋值最后一张牌
                for(WORD i = 0; i < m_wPlayerCount; i++)
                {
                    GameEnd.cbLastSingleCardData[i] = m_cbOriginalCardData[i][4];
                }

                //得分倍数
                for(WORD i = 0; i < m_wPlayerCount; i++)
                {
                    if(i == m_wBankerUser || m_cbPlayStatus[i] == FALSE) { continue; }
                    wWinTimes[i] = (m_pITableFrame->GetGameStatus() != GS_TK_PLAYING) ? (1) : (m_GameLogic.GetTimes(cbUserCardData[i], MAX_CARDCOUNT, m_ctConfig, INVALID_BYTE));
                }

                //统计得分 已下或没下
                for(WORD i = 0; i < m_wPlayerCount; i++)
                {
                    if(i == m_wBankerUser || m_cbPlayStatus[i] == FALSE) { continue; }
                    GameEnd.lGameScore[i] = m_lTableScore[i] * wWinTimes[i] * cbMaxCallBankerTimes;
                    GameEnd.lGameScore[m_wBankerUser] -= GameEnd.lGameScore[i];
                    m_lTableScore[i] = 0;
                }

                //修改积分
                tagScoreInfo ScoreInfoArray[GAME_PLAYER];
                ZeroMemory(&ScoreInfoArray, sizeof(ScoreInfoArray));

                //积分税收
                for(WORD i = 0; i < m_wPlayerCount; i++)
                {
                    if(m_cbPlayStatus[i] == FALSE && i != m_wBankerUser) { continue; }

                    if(((m_pGameServiceOption->wServerType & GAME_GENRE_PERSONAL) == 0) ||
                            ((m_pGameServiceOption->wServerType & GAME_GENRE_PERSONAL) != 0 && m_pITableFrame->GetDataBaseMode() == 1))
                    {
                        if(GameEnd.lGameScore[i] > 0L)
                        {
                            GameEnd.lGameTax[i] = m_pITableFrame->CalculateRevenue(i, GameEnd.lGameScore[i]);
                            if(GameEnd.lGameTax[i] > 0)
                            {
                                GameEnd.lGameScore[i] -= GameEnd.lGameTax[i];
                            }
                        }
                    }

                    //保存积分
                    ScoreInfoArray[i].lRevenue = GameEnd.lGameTax[i];
                    ScoreInfoArray[i].lScore = GameEnd.lGameScore[i];

                    if(i == m_wBankerUser)
                    {
                        ScoreInfoArray[i].cbType = SCORE_TYPE_FLEE;
                    }
                    else if(m_cbPlayStatus[i] == TRUE)
                    {
                        ScoreInfoArray[i].cbType = (GameEnd.lGameScore[i] > 0L) ? SCORE_TYPE_WIN : SCORE_TYPE_LOSE;
                    }

                    m_pITableFrame->WriteUserScore(i, ScoreInfoArray[i]);
                }

                //获取玩家牌型
                for(WORD i = 0; i < m_wPlayerCount; i++)
                {
                    if(m_cbPlayStatus[i] == FALSE)
                    {
                        continue;
                    }

                    GameEnd.cbCardType[i] = (m_cbCombineCardType[i] == 0 ? m_cbOriginalCardType[i] : m_cbCombineCardType[i]);
                }

                //拷贝牌型倍数
                CopyMemory(GameEnd.wCardTypeTimes, wWinTimes, sizeof(wWinTimes));

                //发送信息
                for(WORD i = 0; i < m_wPlayerCount; i++)
                {
                    if(i == m_wBankerUser || (m_cbPlayStatus[i] == FALSE && m_cbDynamicJoin[i] == FALSE)) { continue; }
                    m_pITableFrame->SendTableData(i, SUB_S_GAME_END, &GameEnd, sizeof(GameEnd));
                }
                m_pITableFrame->SendLookonData(INVALID_CHAIR, SUB_S_GAME_END, &GameEnd, sizeof(GameEnd));

                if(m_pGameVideo)
                {
                    m_pGameVideo->AddVideoData(SUB_S_GAME_END, &GameEnd);
                }

                if(m_pGameVideo)
                {
                    m_pGameVideo->StopAndSaveVideo(m_pGameServiceOption->wServerID, m_pITableFrame->GetTableID());
                }

                //TryWriteTableScore(ScoreInfoArray);

                //写入库存
                for(WORD i = 0; i < m_wPlayerCount; i++)
                {
                    if(m_cbPlayStatus[i] == FALSE && i != m_wBankerUser) { continue; }

                    //获取用户
                    IServerUserItem *pIServerUserIte = m_pITableFrame->GetTableUserItem(i);

                    //库存累计
                    if((pIServerUserIte != NULL) && (!pIServerUserIte->IsAndroidUser()))
                    {
                        g_lRoomStorageCurrent -= GameEnd.lGameScore[i];
                    }

                }
                //结束游戏
                m_pITableFrame->ConcludeGame(GS_TK_FREE);

                if(!IsRoomCardType())
                {
                    //删除时间
                    m_pITableFrame->KillGameTimer(IDI_SO_OPERATE);

                    //删除离线代打定时器
                    for(WORD i = 0; i < m_wPlayerCount; i++)
                    {
                        m_pITableFrame->KillGameTimer(IDI_OFFLINE_TRUSTEE_0 + i);
                    }
                }

                UpdateRoomUserInfo(pIServerUserItem, USER_STANDUP);

                //更新房间用户信息
                for(WORD i = 0; i < m_wPlayerCount; i++)
                {
                    if(i == wChairID)
                    {
                        continue;
                    }

                    //获取用户
                    IServerUserItem *pIServerUserItem = m_pITableFrame->GetTableUserItem(i);

                    if(!pIServerUserItem)
                    {
                        continue;
                    }

                    UpdateRoomUserInfo(pIServerUserItem, USER_SITDOWN);
                }

                m_bReNewTurn = false;

                return true;
            }
            else						//闲家强退
            {
                //已经下注
                if(m_lTableScore[wChairID] > 0L)
                {
                    ZeroMemory(wWinTimes, sizeof(wWinTimes));

                    //用户扑克
                    BYTE cbUserCardData[MAX_CARDCOUNT];
                    CopyMemory(cbUserCardData, m_cbHandCardData[m_wBankerUser], MAX_CARDCOUNT);

                    //用户倍数
                    wWinTimes[m_wBankerUser] = (m_pITableFrame->GetGameStatus() == GS_TK_SCORE) ? (1) : (m_GameLogic.GetTimes(cbUserCardData, MAX_CARDCOUNT, m_ctConfig, INVALID_BYTE));

                    //修改积分
                    LONGLONG lScore = -m_lTableScore[wChairID] * wWinTimes[m_wBankerUser] * cbMaxCallBankerTimes;
                    m_lExitScore += (-1 * lScore);
                    m_lTableScore[wChairID] = (-1 * lScore);

                    tagScoreInfo ScoreInfo;
                    ZeroMemory(&ScoreInfo, sizeof(ScoreInfo));
                    ScoreInfo.lScore = lScore;
                    ScoreInfo.cbType = SCORE_TYPE_FLEE;

                    m_pITableFrame->WriteUserScore(wChairID, ScoreInfo);

                    //获取用户
                    IServerUserItem *pIServerUserIte = m_pITableFrame->GetTableUserItem(wChairID);

                    //库存累计
                    if((pIServerUserIte != NULL) && (!pIServerUserIte->IsAndroidUser()))
                    {
                        g_lRoomStorageCurrent -= lScore;
                    }
                }

                //玩家人数
                WORD wUserCount = 0;
                for(WORD i = 0; i < m_wPlayerCount; i++)if(m_cbPlayStatus[i] == TRUE) { wUserCount++; }

                //结束游戏
                if(wUserCount == 1)
                {
                    //定义变量
                    CMD_S_GameEnd GameEnd;
                    ZeroMemory(&GameEnd, sizeof(GameEnd));
                    CopyMemory(GameEnd.cbHandCardData, m_cbHandCardData, sizeof(m_cbHandCardData));
                    ASSERT(m_lExitScore >= 0L);

                    //赋值最后一张牌
                    for(WORD i = 0; i < m_wPlayerCount; i++)
                    {
                        GameEnd.cbLastSingleCardData[i] = m_cbOriginalCardData[i][4];

                    }
                    //统计得分
                    GameEnd.lGameScore[m_wBankerUser] += m_lExitScore;
                    if(((m_pGameServiceOption->wServerType & GAME_GENRE_PERSONAL) == 0) ||
                            ((m_pGameServiceOption->wServerType & GAME_GENRE_PERSONAL) != 0 && m_pITableFrame->GetDataBaseMode() == 1))
                    {
                        GameEnd.lGameTax[m_wBankerUser] = m_pITableFrame->CalculateRevenue(m_wBankerUser, GameEnd.lGameScore[m_wBankerUser]);
                    }
                    GameEnd.lGameScore[m_wBankerUser] -= GameEnd.lGameTax[m_wBankerUser];

                    //获取玩家牌型
                    for(WORD i = 0; i < m_wPlayerCount; i++)
                    {
                        if(m_cbPlayStatus[i] == FALSE)
                        {
                            continue;
                        }

                        GameEnd.cbCardType[i] = (m_cbCombineCardType[i] == 0 ? m_cbOriginalCardType[i] : m_cbCombineCardType[i]);
                    }

                    //拷贝牌型倍数
                    CopyMemory(GameEnd.wCardTypeTimes, wWinTimes, sizeof(wWinTimes));

                    //发送信息
                    m_pITableFrame->SendTableData(INVALID_CHAIR, SUB_S_GAME_END, &GameEnd, sizeof(GameEnd));
                    m_pITableFrame->SendLookonData(INVALID_CHAIR, SUB_S_GAME_END, &GameEnd, sizeof(GameEnd));

                    if(m_pGameVideo)
                    {
                        m_pGameVideo->AddVideoData(SUB_S_GAME_END, &GameEnd);
                        m_pGameVideo->StopAndSaveVideo(m_pGameServiceOption->wServerID, m_pITableFrame->GetTableID());
                    }

                    WORD Zero = 0;
                    for(; Zero < m_wPlayerCount; Zero++)if(m_lTableScore[Zero] != 0) { break; }
                    if(Zero != m_wPlayerCount)
                    {
                        //修改积分
                        tagScoreInfo ScoreInfo;
                        ZeroMemory(&ScoreInfo, sizeof(ScoreInfo));
                        ScoreInfo.lScore = GameEnd.lGameScore[m_wBankerUser];
                        ScoreInfo.lRevenue = GameEnd.lGameTax[m_wBankerUser];
                        ScoreInfo.cbType = SCORE_TYPE_WIN;

                        m_pITableFrame->WriteUserScore(m_wBankerUser, ScoreInfo);

                        //获取用户
                        IServerUserItem *pIServerUserIte = m_pITableFrame->GetTableUserItem(wChairID);

                        //库存累计
                        if((pIServerUserIte != NULL) && (!pIServerUserIte->IsAndroidUser()))
                        {
                            g_lRoomStorageCurrent -= GameEnd.lGameScore[m_wBankerUser];
                        }

                    }

                    //结束游戏
                    m_pITableFrame->ConcludeGame(GS_TK_FREE);

                    if(!IsRoomCardType())
                    {
                        //删除时间
                        m_pITableFrame->KillGameTimer(IDI_SO_OPERATE);

                        //删除离线代打定时器
                        for(WORD i = 0; i < m_wPlayerCount; i++)
                        {
                            m_pITableFrame->KillGameTimer(IDI_OFFLINE_TRUSTEE_0 + i);
                        }
                    }

                    UpdateRoomUserInfo(pIServerUserItem, USER_STANDUP);

                    //更新房间用户信息
                    for(WORD i = 0; i < m_wPlayerCount; i++)
                    {
                        if(i == wChairID)
                        {
                            continue;
                        }

                        //获取用户
                        IServerUserItem *pIServerUserItem = m_pITableFrame->GetTableUserItem(i);

                        if(!pIServerUserItem)
                        {
                            continue;
                        }

                        UpdateRoomUserInfo(pIServerUserItem, USER_SITDOWN);
                    }

                    m_bReNewTurn = false;

                    return true;
                }

                OnUserOpenCard(wChairID, m_cbHandCardData[wChairID]);
            }
        }
        //下注逃跑
        else if(m_pITableFrame->GetGameStatus() == GS_TK_SCORE)
        {
            //剩余玩家人数
            WORD wUserCount = 0;
            for(WORD i = 0; i < m_wPlayerCount; i++)
            {
                if(m_cbPlayStatus[i] == TRUE)
                {
                    wUserCount++;
                }
            }

            //发四等五 (已发4张牌) 按照最小筹码进行赔付
            if(m_stConfig == ST_SENDFOUR_)
            {
                //获取最小筹码
                LONGLONG lMinJetton = 0L;

                //自由配置额度
                if(m_btConfig == BT_FREE_)
                {
                    lMinJetton = m_lFreeConfig[0];
                }
                //百分比配置额度
                else if(m_btConfig == BT_PENCENT_)
                {
                    //最小下注玩家
                    WORD wMinJettonChairID = INVALID_CHAIR;
                    for(WORD i = 0; i < m_wPlayerCount; i++)
                    {
                        //获取用户
                        IServerUserItem *pIServerUserItem = m_pITableFrame->GetTableUserItem(i);
                        if(pIServerUserItem == NULL || m_cbPlayStatus[i] == FALSE)
                        {
                            continue;
                        }

                        if(wMinJettonChairID == INVALID_CHAIR) { wMinJettonChairID = i; }

                        //获取较大者
                        if(m_lTurnMaxScore[i] < m_lTurnMaxScore[wMinJettonChairID])
                        {
                            wMinJettonChairID = i;
                        }
                    }

                    ASSERT(wMinJettonChairID != INVALID_CHAIR);

                    lMinJetton = m_lTurnMaxScore[wMinJettonChairID] * m_lPercentConfig[0] / 100;
                }

                CMD_S_GameEnd GameEnd;
                ZeroMemory(&GameEnd, sizeof(GameEnd));
                CopyMemory(GameEnd.cbHandCardData, m_cbHandCardData, sizeof(m_cbHandCardData));

                //赋值最后一张牌
                for(WORD i = 0; i < m_wPlayerCount; i++)
                {
                    GameEnd.cbLastSingleCardData[i] = m_cbOriginalCardData[i][4];
                }

                tagScoreInfo ScoreInfoArray[GAME_PLAYER];
                ZeroMemory(&ScoreInfoArray, sizeof(ScoreInfoArray));

                //庄家逃跑结束游戏
                if(wChairID == m_wBankerUser)
                {
                    //发四等五	庄家逃跑，不显示牌型
                    for(WORD i = 0; i < m_wPlayerCount; i++)
                    {
                        GameEnd.cbCardType[i] = INVALID_BYTE;
                        //if(m_cbPlayStatus[i]==FALSE)
                        //{
                        //	continue;
                        //}

                        //GameEnd.cbCardType[i] = (m_cbCombineCardType[i] == 0 ? m_cbOriginalCardType[i] : m_cbCombineCardType[i]);
                    }

                    LONGLONG lBankerScore = 0L;
                    for(WORD i = 0; i < m_wPlayerCount; i++)
                    {
                        //获取用户
                        IServerUserItem *pIServerUserItem = m_pITableFrame->GetTableUserItem(i);
                        if(pIServerUserItem == NULL || m_cbPlayStatus[i] == FALSE || i == m_wBankerUser)
                        {
                            continue;
                        }

                        //统计得分
                        GameEnd.lGameScore[i] += lMinJetton;
                        if(((m_pGameServiceOption->wServerType & GAME_GENRE_PERSONAL) == 0) ||
                                ((m_pGameServiceOption->wServerType & GAME_GENRE_PERSONAL) != 0 && m_pITableFrame->GetDataBaseMode() == 1))
                        {
                            GameEnd.lGameTax[i] = m_pITableFrame->CalculateRevenue(i, GameEnd.lGameScore[i]);
                        }
                        GameEnd.lGameScore[i] -= GameEnd.lGameTax[i];

                        //写分
                        ScoreInfoArray[i].lScore = GameEnd.lGameScore[i];
                        ScoreInfoArray[i].lRevenue = GameEnd.lGameTax[i];
                        ScoreInfoArray[i].cbType = SCORE_TYPE_WIN;

                        lBankerScore -= lMinJetton;
                    }

                    GameEnd.lGameScore[m_wBankerUser] = lBankerScore;
                    ScoreInfoArray[m_wBankerUser].lScore = GameEnd.lGameScore[m_wBankerUser];
                    ScoreInfoArray[m_wBankerUser].cbType = SCORE_TYPE_FLEE;

                    //发送信息
                    m_pITableFrame->SendTableData(INVALID_CHAIR, SUB_S_GAME_END, &GameEnd, sizeof(GameEnd));
                    m_pITableFrame->SendLookonData(INVALID_CHAIR, SUB_S_GAME_END, &GameEnd, sizeof(GameEnd));

                    if(m_pGameVideo)
                    {
                        m_pGameVideo->AddVideoData(SUB_S_GAME_END, &GameEnd);
                        m_pGameVideo->StopAndSaveVideo(m_pGameServiceOption->wServerID, m_pITableFrame->GetTableID());
                    }

                    //写分
                    //TryWriteTableScore(ScoreInfoArray);

                    for(WORD i = 0; i < m_wPlayerCount; i++)
                    {
                        //获取用户
                        IServerUserItem *pIServerUserItem = m_pITableFrame->GetTableUserItem(i);
                        if(pIServerUserItem == NULL)
                        {
                            continue;
                        }

                        m_pITableFrame->WriteUserScore(i, ScoreInfoArray[i]);
                    }

                    //结束游戏
                    m_pITableFrame->ConcludeGame(GS_TK_FREE);

                    if(!IsRoomCardType())
                    {
                        //删除时间
                        m_pITableFrame->KillGameTimer(IDI_SO_OPERATE);

                        //删除离线代打定时器
                        for(WORD i = 0; i < m_wPlayerCount; i++)
                        {
                            m_pITableFrame->KillGameTimer(IDI_OFFLINE_TRUSTEE_0 + i);
                        }
                    }

                    UpdateRoomUserInfo(pIServerUserItem, USER_STANDUP);

                    //更新房间用户信息
                    for(WORD i = 0; i < m_wPlayerCount; i++)
                    {
                        if(i == wChairID)
                        {
                            continue;
                        }

                        //获取用户
                        IServerUserItem *pIServerUserItem = m_pITableFrame->GetTableUserItem(i);

                        if(!pIServerUserItem)
                        {
                            continue;
                        }

                        UpdateRoomUserInfo(pIServerUserItem, USER_SITDOWN);
                    }

                    m_bReNewTurn = false;

                    return true;
                }
                //闲家逃跑，只剩下一个玩家
                else if(wChairID != m_wBankerUser && wUserCount == 1)
                {
                    //统计得分
                    GameEnd.lGameScore[wChairID] -= lMinJetton;
                    GameEnd.lGameScore[m_wBankerUser] += lMinJetton;
                    if(((m_pGameServiceOption->wServerType & GAME_GENRE_PERSONAL) == 0) ||
                            ((m_pGameServiceOption->wServerType & GAME_GENRE_PERSONAL) != 0 && m_pITableFrame->GetDataBaseMode() == 1))
                    {
                        GameEnd.lGameTax[m_wBankerUser] = m_pITableFrame->CalculateRevenue(m_wBankerUser, GameEnd.lGameScore[m_wBankerUser]);
                    }
                    GameEnd.lGameScore[m_wBankerUser] -= GameEnd.lGameTax[m_wBankerUser];

                    //写分
                    ScoreInfoArray[wChairID].lScore = GameEnd.lGameScore[wChairID];
                    ScoreInfoArray[wChairID].cbType = SCORE_TYPE_FLEE;
                    ScoreInfoArray[m_wBankerUser].lScore = GameEnd.lGameScore[m_wBankerUser];
                    ScoreInfoArray[m_wBankerUser].cbType = SCORE_TYPE_WIN;
                    ScoreInfoArray[m_wBankerUser].lRevenue = GameEnd.lGameTax[m_wBankerUser];

                    //发送信息
                    m_pITableFrame->SendTableData(INVALID_CHAIR, SUB_S_GAME_END, &GameEnd, sizeof(GameEnd));
                    m_pITableFrame->SendLookonData(INVALID_CHAIR, SUB_S_GAME_END, &GameEnd, sizeof(GameEnd));

                    if(m_pGameVideo)
                    {
                        m_pGameVideo->AddVideoData(SUB_S_GAME_END, &GameEnd);
                        m_pGameVideo->StopAndSaveVideo(m_pGameServiceOption->wServerID, m_pITableFrame->GetTableID());
                    }

                    //写分
                    //TryWriteTableScore(ScoreInfoArray);

                    for(WORD i = 0; i < m_wPlayerCount; i++)
                    {
                        //获取用户
                        IServerUserItem *pIServerUserItem = m_pITableFrame->GetTableUserItem(i);
                        if(pIServerUserItem == NULL)
                        {
                            continue;
                        }

                        m_pITableFrame->WriteUserScore(i, ScoreInfoArray[i]);
                    }

                    //结束游戏
                    m_pITableFrame->ConcludeGame(GS_TK_FREE);

                    if(!IsRoomCardType())
                    {
                        //删除时间
                        m_pITableFrame->KillGameTimer(IDI_SO_OPERATE);

                        //删除离线代打定时器
                        for(WORD i = 0; i < m_wPlayerCount; i++)
                        {
                            m_pITableFrame->KillGameTimer(IDI_OFFLINE_TRUSTEE_0 + i);
                        }
                    }

                    UpdateRoomUserInfo(pIServerUserItem, USER_STANDUP);

                    //更新房间用户信息
                    for(WORD i = 0; i < m_wPlayerCount; i++)
                    {
                        if(i == wChairID)
                        {
                            continue;
                        }

                        //获取用户
                        IServerUserItem *pIServerUserItem = m_pITableFrame->GetTableUserItem(i);

                        if(!pIServerUserItem)
                        {
                            continue;
                        }

                        UpdateRoomUserInfo(pIServerUserItem, USER_SITDOWN);
                    }

                    m_bReNewTurn = false;

                    return true;
                }
                //闲家逃跑，剩下2个以上玩家 继续游戏
                else
                {
                    m_lExitScore += lMinJetton;
                    m_lTableScore[wChairID] = 0;

                    tagScoreInfo ScoreInfoArray[GAME_PLAYER];
                    ZeroMemory(ScoreInfoArray, sizeof(ScoreInfoArray));
                    ScoreInfoArray[wChairID].lScore -= lMinJetton;
                    ScoreInfoArray[wChairID].cbType = SCORE_TYPE_FLEE;

                    //TryWriteTableScore(ScoreInfoArray);
                    m_pITableFrame->WriteUserScore(wChairID, ScoreInfoArray[wChairID]);

                    OnUserAddScore(wChairID, 0);
                }
            }
            //下注发牌 (未发牌不需要赔付)
            else if(m_stConfig == ST_BETFIRST_)
            {
                //庄家逃跑结束游戏 或只剩下一个玩家
                if(wChairID == m_wBankerUser || wUserCount == 1)
                {
                    CMD_S_GameEnd GameEnd;
                    ZeroMemory(&GameEnd, sizeof(GameEnd));

                    //发送信息
                    m_pITableFrame->SendTableData(INVALID_CHAIR, SUB_S_GAME_END, &GameEnd, sizeof(GameEnd));
                    m_pITableFrame->SendLookonData(INVALID_CHAIR, SUB_S_GAME_END, &GameEnd, sizeof(GameEnd));

                    if(m_pGameVideo)
                    {
                        m_pGameVideo->AddVideoData(SUB_S_GAME_END, &GameEnd);
                        m_pGameVideo->StopAndSaveVideo(m_pGameServiceOption->wServerID, m_pITableFrame->GetTableID());
                    }

                    //结束游戏
                    m_pITableFrame->ConcludeGame(GS_TK_FREE);

                    if(!IsRoomCardType())
                    {
                        //删除时间
                        m_pITableFrame->KillGameTimer(IDI_SO_OPERATE);

                        //删除离线代打定时器
                        for(WORD i = 0; i < m_wPlayerCount; i++)
                        {
                            m_pITableFrame->KillGameTimer(IDI_OFFLINE_TRUSTEE_0 + i);
                        }
                    }

                    UpdateRoomUserInfo(pIServerUserItem, USER_STANDUP);

                    //更新房间用户信息
                    for(WORD i = 0; i < m_wPlayerCount; i++)
                    {
                        if(i == wChairID)
                        {
                            continue;
                        }

                        //获取用户
                        IServerUserItem *pIServerUserItem = m_pITableFrame->GetTableUserItem(i);

                        if(!pIServerUserItem)
                        {
                            continue;
                        }

                        UpdateRoomUserInfo(pIServerUserItem, USER_SITDOWN);
                    }

                    m_bReNewTurn = false;

                    return true;
                }
                //闲家逃跑 且游戏人数大于1  继续游戏
                else
                {
                    ASSERT(wUserCount >= 2);

                    OnUserAddScore(wChairID, 0);
                    m_lTableScore[wChairID] = 0L;
                }
            }
        }
        //叫庄状态逃跑
        else
        {
            //玩家人数
            WORD wUserCount = 0;
            for(WORD i = 0; i < m_wPlayerCount; i++)if(m_cbPlayStatus[i] == TRUE) { wUserCount++; }

            //结束游戏
            if(wUserCount == 1)
            {
                //定义变量
                CMD_S_GameEnd GameEnd;
                ZeroMemory(&GameEnd, sizeof(GameEnd));

                //发送信息
                for(WORD i = 0; i < m_wPlayerCount; i++)
                {
                    if(m_cbPlayStatus[i] == FALSE && m_cbDynamicJoin[i] == FALSE) { continue; }
                    m_pITableFrame->SendTableData(i, SUB_S_GAME_END, &GameEnd, sizeof(GameEnd));
                }
                m_pITableFrame->SendLookonData(INVALID_CHAIR, SUB_S_GAME_END, &GameEnd, sizeof(GameEnd));

                if(m_pGameVideo)
                {
                    m_pGameVideo->AddVideoData(SUB_S_GAME_END, &GameEnd);
                }

                if(m_pGameVideo)
                {
                    m_pGameVideo->StopAndSaveVideo(m_pGameServiceOption->wServerID, m_pITableFrame->GetTableID());
                }

                //结束游戏
                m_pITableFrame->ConcludeGame(GS_TK_FREE);

                if(!IsRoomCardType())
                {
                    //删除时间
                    m_pITableFrame->KillGameTimer(IDI_SO_OPERATE);

                    //删除离线代打定时器
                    for(WORD i = 0; i < m_wPlayerCount; i++)
                    {
                        m_pITableFrame->KillGameTimer(IDI_OFFLINE_TRUSTEE_0 + i);
                    }
                }

                UpdateRoomUserInfo(pIServerUserItem, USER_STANDUP);

                //更新房间用户信息
                for(WORD i = 0; i < m_wPlayerCount; i++)
                {
                    if(i == wChairID)
                    {
                        continue;
                    }

                    //获取用户
                    IServerUserItem *pIServerUserItem = m_pITableFrame->GetTableUserItem(i);

                    if(!pIServerUserItem)
                    {
                        continue;
                    }

                    UpdateRoomUserInfo(pIServerUserItem, USER_SITDOWN);
                }

                m_bReNewTurn = false;

                return true;
            }
            else
            {
                OnUserCallBanker(wChairID, false, 0);
            }
        }

        return true;
    }
    }

    return false;
}

//发送场景
bool CTableFrameSink::OnEventSendGameScene(WORD wChairID, IServerUserItem *pIServerUserItem, BYTE cbGameStatus, bool bSendSecret)
{
    switch(cbGameStatus)
    {
    case GAME_STATUS_FREE:		//空闲状态
    {
        //私人房间
        if((m_pGameServiceOption->wServerType & GAME_GENRE_PERSONAL) != 0)
        {
            //cbGameRule[1] 为  2 、3 、4, 5, 6 0分别对应 2人 、 3人 、 4人 、5, 6 2-6人 这几种配置
            BYTE *pGameRule = m_pITableFrame->GetGameRule();
            if(pGameRule[1] != 0)
            {
                m_wPlayerCount = pGameRule[1];

                //设置人数
                m_pITableFrame->SetTableChairCount(m_wPlayerCount);
            }
            else
            {
                m_wPlayerCount = GAME_PLAYER;

                //设置人数
                m_pITableFrame->SetTableChairCount(GAME_PLAYER);
            }

            ASSERT(pGameRule[3] == 22 || pGameRule[3] == 23);
            if(pGameRule[3] == 22 || pGameRule[3] == 23)
            {
                //默认经典模式
                m_ctConfig = (CARDTYPE_CONFIG)(pGameRule[3]);
            }

            ASSERT(pGameRule[4] == 32 || pGameRule[4] == 33);
            if(pGameRule[4] == 32 || pGameRule[4] == 33)
            {
                //默认发四等五
                m_stConfig = (SENDCARDTYPE_CONFIG)(pGameRule[4]);
            }

            //ASSERT (pGameRule[5] == 42 || pGameRule[5] == 43);
            //m_gtConfig = (KING_CONFIG)(pGameRule[5]);

            ASSERT(pGameRule[6] == 52 || pGameRule[6] == 53 || pGameRule[6] == 54 || pGameRule[6] == 55 || pGameRule[6] == 56 || pGameRule[6] == 57);
            if(pGameRule[6] == 52 || pGameRule[6] == 53 || pGameRule[6] == 54 || pGameRule[6] == 55 || pGameRule[6] == 56 || pGameRule[6] == 57)
            {
                //默认霸王庄
                m_bgtConfig = (BANERGAMETYPE_CONFIG)(pGameRule[6]);
            }

            //下注配置只能在后台配置
            //优化内容配置
            LONG *plConfig = new LONG;
            ZeroMemory(plConfig, sizeof(LONG));

            CopyMemory(plConfig, &(pGameRule[7]), sizeof(LONG));
            m_lBeBankerCondition = *plConfig;

            CopyMemory(plConfig, &(pGameRule[7 + sizeof(LONG)]), sizeof(LONG));
            m_lPlayerBetTimes = *plConfig;

            m_cbAdmitRevCard = pGameRule[15];
            m_cbMaxCallBankerTimes = pGameRule[16];

            for(WORD i = 0; i < MAX_SPECIAL_CARD_TYPE - 1; i++)
            {
                m_cbEnableCardType[i] = pGameRule[17 + i];
            }

            //默认有大小王
            m_gtConfig = (pGameRule[25] == TRUE ? GT_HAVEKING_ : GT_NOKING_);

            m_cbClassicTypeConfig = pGameRule[26];
            if(m_ctConfig == CT_ADDTIMES_)
            {
                m_cbClassicTypeConfig = INVALID_BYTE;
            }

            //积分房卡
            if(IsRoomCardType())
            {
				//推注类型
                m_tyConfig = (pGameRule[27] == TRUE ? BT_TUI_DOUBLE_ : BT_TUI_NONE_);

				//房卡断线代打标识，金币房卡默认m_cbRCOfflineTrustee为TRUE
				m_cbRCOfflineTrustee = pGameRule[28];
            }
			else
			{
				m_cbRCOfflineTrustee = TRUE;
			}
        }

        //构造数据
        CMD_S_StatusFree StatusFree;
        ZeroMemory(&StatusFree, sizeof(StatusFree));

        //CString cs;
        //cs.Format(TEXT("CellScore = %d"), m_pITableFrame->GetCellScore());
        //CTraceService::TraceString(cs,TraceLevel_Exception);

        //设置变量
        StatusFree.lCellScore = m_pITableFrame->GetCellScore();
        StatusFree.lRoomStorageStart = g_lRoomStorageStart;
        StatusFree.lRoomStorageCurrent = g_lRoomStorageCurrent;

        StatusFree.ctConfig = m_ctConfig;
        StatusFree.stConfig = m_stConfig;
        StatusFree.bgtConfig = m_bgtConfig;
        StatusFree.btConfig = m_btConfig;
        StatusFree.gtConfig = m_gtConfig;

        //历史积分
        for(WORD i = 0; i < m_wPlayerCount; i++)
        {
            tagHistoryScore *pHistoryScore = m_HistoryScore.GetHistoryScore(i);
            StatusFree.lTurnScore[i] = pHistoryScore->lTurnScore;
            StatusFree.lCollectScore[i] = pHistoryScore->lCollectScore;
        }

        //获取自定义配置
        tagCustomRule *pCustomRule = (tagCustomRule *)m_pGameServiceOption->cbCustomRule;
        ASSERT(pCustomRule);
        tagCustomAndroid CustomAndroid;
        ZeroMemory(&CustomAndroid, sizeof(CustomAndroid));
        CustomAndroid.lRobotBankGet = pCustomRule->lRobotBankGet;
        CustomAndroid.lRobotBankGetBanker = pCustomRule->lRobotBankGetBanker;
        CustomAndroid.lRobotBankStoMul = pCustomRule->lRobotBankStoMul;
        CustomAndroid.lRobotScoreMax = pCustomRule->lRobotScoreMax;
        CustomAndroid.lRobotScoreMin = pCustomRule->lRobotScoreMin;
        CopyMemory(&StatusFree.CustomAndroid, &CustomAndroid, sizeof(CustomAndroid));
        BYTE *pGameRule = m_pITableFrame->GetGameRule();
        StatusFree.wGamePlayerCountRule = pGameRule[1];
        StatusFree.cbAdmitRevCard = m_cbAdmitRevCard;
        StatusFree.cbPlayMode = m_pITableFrame->GetDataBaseMode();

        //防调试
        if(CServerRule::IsAllowAvertDebugMode(m_pGameServiceOption->dwServerRule))
        {
            StatusFree.bIsAllowAvertDebug = true;
        }

        //权限判断
        if(CUserRight::IsGameDebugUser(pIServerUserItem->GetUserRight()) && !pIServerUserItem->IsAndroidUser())
        {
            CMD_S_ADMIN_STORAGE_INFO StorageInfo;
            ZeroMemory(&StorageInfo, sizeof(StorageInfo));
            StorageInfo.lRoomStorageStart = g_lRoomStorageStart;
            StorageInfo.lRoomStorageCurrent = g_lRoomStorageCurrent;
            StorageInfo.lRoomStorageDeduct = g_lStorageDeductRoom;
            StorageInfo.lMaxRoomStorage[0] = g_lStorageMax1Room;
            StorageInfo.lMaxRoomStorage[1] = g_lStorageMax2Room;
            StorageInfo.wRoomStorageMul[0] = (WORD)g_lStorageMul1Room;
            StorageInfo.wRoomStorageMul[1] = (WORD)g_lStorageMul2Room;

            m_pITableFrame->SendRoomData(NULL, SUB_S_ADMIN_STORAGE_INFO, &StorageInfo, sizeof(StorageInfo));
        }

        //房卡模式
        if((m_pGameServiceOption->wServerType & GAME_GENRE_PERSONAL) != 0)
        {
            m_pITableFrame->SendTableData(INVALID_CHAIR, SUB_S_RECORD, &m_stRecord, sizeof(m_stRecord));

            CMD_S_RoomCardRecord RoomCardRecord;
            ZeroMemory(&RoomCardRecord, sizeof(RoomCardRecord));

            CopyMemory(&RoomCardRecord, &m_RoomCardRecord, sizeof(m_RoomCardRecord));

            m_pITableFrame->SendTableData(INVALID_CHAIR, SUB_S_ROOMCARD_RECORD, &RoomCardRecord, sizeof(RoomCardRecord));
            m_pITableFrame->SendLookonData(INVALID_CHAIR, SUB_S_ROOMCARD_RECORD, &RoomCardRecord, sizeof(RoomCardRecord));
        }

		//金币场和金币房卡可以托管，积分房卡也托管
		//断线回来取消代打
		//if(((m_pGameServiceOption->wServerType & GAME_GENRE_PERSONAL) != 0 && m_pITableFrame->GetDataBaseMode() == 1)
		//        || (m_pGameServiceOption->wServerType & GAME_GENRE_PERSONAL) == 0)
		{
			//重连取消托管标志
			pIServerUserItem->SetTrusteeUser(false);
			m_pITableFrame->KillGameTimer(IDI_OFFLINE_TRUSTEE_0 + wChairID);
		}

        //发送场景
        return m_pITableFrame->SendGameScene(pIServerUserItem, &StatusFree, sizeof(StatusFree));
    }
    case GS_TK_CALL:	//叫庄状态
    {
        //构造数据
        CMD_S_StatusCall StatusCall;
        ZeroMemory(&StatusCall, sizeof(StatusCall));

        //历史积分
        for(WORD i = 0; i < m_wPlayerCount; i++)
        {
            tagHistoryScore *pHistoryScore = m_HistoryScore.GetHistoryScore(i);
            StatusCall.lTurnScore[i] = pHistoryScore->lTurnScore;
            StatusCall.lCollectScore[i] = pHistoryScore->lCollectScore;
        }

        //设置变量
        StatusCall.lCellScore = m_pITableFrame->GetCellScore();
        StatusCall.cbDynamicJoin = m_cbDynamicJoin[wChairID];
        CopyMemory(StatusCall.cbPlayStatus, m_cbPlayStatus, sizeof(StatusCall.cbPlayStatus));
        StatusCall.lRoomStorageStart = g_lRoomStorageStart;
        StatusCall.lRoomStorageCurrent = g_lRoomStorageCurrent;

        StatusCall.ctConfig = m_ctConfig;
        StatusCall.stConfig = m_stConfig;
        StatusCall.bgtConfig = m_bgtConfig;
        StatusCall.btConfig = m_btConfig;
        StatusCall.gtConfig = m_gtConfig;

        //获取自定义配置
        tagCustomRule *pCustomRule = (tagCustomRule *)m_pGameServiceOption->cbCustomRule;
        ASSERT(pCustomRule);
        tagCustomAndroid CustomAndroid;
        ZeroMemory(&CustomAndroid, sizeof(CustomAndroid));
        CustomAndroid.lRobotBankGet = pCustomRule->lRobotBankGet;
        CustomAndroid.lRobotBankGetBanker = pCustomRule->lRobotBankGetBanker;
        CustomAndroid.lRobotBankStoMul = pCustomRule->lRobotBankStoMul;
        CustomAndroid.lRobotScoreMax = pCustomRule->lRobotScoreMax;
        CustomAndroid.lRobotScoreMin = pCustomRule->lRobotScoreMin;
        CopyMemory(&StatusCall.CustomAndroid, &CustomAndroid, sizeof(CustomAndroid));
        BYTE *pGameRule = m_pITableFrame->GetGameRule();
        StatusCall.wGamePlayerCountRule = pGameRule[1];
        StatusCall.cbAdmitRevCard = m_cbAdmitRevCard;
        StatusCall.cbMaxCallBankerTimes = m_cbMaxCallBankerTimes;
        StatusCall.wBgtRobNewTurnChairID = m_wBgtRobNewTurnChairID;
        StatusCall.cbPlayMode = m_pITableFrame->GetDataBaseMode();

        //防调试
        if(CServerRule::IsAllowAvertDebugMode(m_pGameServiceOption->dwServerRule))
        {
            StatusCall.bIsAllowAvertDebug = true;
        }

        CopyMemory(StatusCall.cbCallBankerStatus, m_cbCallBankerStatus, sizeof(StatusCall.cbCallBankerStatus));
        CopyMemory(StatusCall.cbCallBankerTimes, m_cbCallBankerTimes, sizeof(StatusCall.cbCallBankerTimes));

        //更新房间用户信息
        UpdateRoomUserInfo(pIServerUserItem, USER_RECONNECT);

        //权限判断
        if(CUserRight::IsGameDebugUser(pIServerUserItem->GetUserRight()) && !pIServerUserItem->IsAndroidUser())
        {
            CMD_S_ADMIN_STORAGE_INFO StorageInfo;
            ZeroMemory(&StorageInfo, sizeof(StorageInfo));
            StorageInfo.lRoomStorageStart = g_lRoomStorageStart;
            StorageInfo.lRoomStorageCurrent = g_lRoomStorageCurrent;
            StorageInfo.lRoomStorageDeduct = g_lStorageDeductRoom;
            StorageInfo.lMaxRoomStorage[0] = g_lStorageMax1Room;
            StorageInfo.lMaxRoomStorage[1] = g_lStorageMax2Room;
            StorageInfo.wRoomStorageMul[0] = (WORD)g_lStorageMul1Room;
            StorageInfo.wRoomStorageMul[1] = (WORD)g_lStorageMul2Room;
            m_pITableFrame->SendRoomData(NULL, SUB_S_ADMIN_STORAGE_INFO, &StorageInfo, sizeof(StorageInfo));
        }

        //发送场景
        bool bResult = m_pITableFrame->SendGameScene(pIServerUserItem, &StatusCall, sizeof(StatusCall));

        //房卡模式
        if((m_pGameServiceOption->wServerType & GAME_GENRE_PERSONAL) != 0)
        {
            m_pITableFrame->SendTableData(INVALID_CHAIR, SUB_S_RECORD, &m_stRecord, sizeof(m_stRecord));

            CMD_S_RoomCardRecord RoomCardRecord;
            ZeroMemory(&RoomCardRecord, sizeof(RoomCardRecord));

            CopyMemory(&RoomCardRecord, &m_RoomCardRecord, sizeof(m_RoomCardRecord));

            m_pITableFrame->SendTableData(INVALID_CHAIR, SUB_S_ROOMCARD_RECORD, &RoomCardRecord, sizeof(RoomCardRecord));
            m_pITableFrame->SendLookonData(INVALID_CHAIR, SUB_S_ROOMCARD_RECORD, &RoomCardRecord, sizeof(RoomCardRecord));
        }

        //发四等五
        if(m_stConfig == ST_SENDFOUR_ && m_bgtConfig == BGT_ROB_)
        {
            //设置变量
            CMD_S_SendFourCard SendFourCard;
            ZeroMemory(&SendFourCard, sizeof(SendFourCard));

            for(WORD i = 0; i < m_wPlayerCount; i++)
            {
                if(m_cbPlayStatus[i] == FALSE && m_cbDynamicJoin[i] == FALSE)
                {
                    continue;
                }

                //派发扑克(开始只发四张牌)
                CopyMemory(SendFourCard.cbCardData[i], m_cbHandCardData[i], sizeof(BYTE) * 4);
            }

            m_pITableFrame->SendTableData(wChairID, SUB_S_SEND_FOUR_CARD, &SendFourCard, sizeof(SendFourCard));
        }

        //金币场和金币房卡可以托管，积分房卡也托管
		//断线回来取消代打
        //if(((m_pGameServiceOption->wServerType & GAME_GENRE_PERSONAL) != 0 && m_pITableFrame->GetDataBaseMode() == 1)
        //        || (m_pGameServiceOption->wServerType & GAME_GENRE_PERSONAL) == 0)
        {
            //重连取消托管标志
            pIServerUserItem->SetTrusteeUser(false);
            m_pITableFrame->KillGameTimer(IDI_OFFLINE_TRUSTEE_0 + wChairID);
        }

        return bResult;
    }
    case GS_TK_SCORE:	//下注状态
    {
        //构造数据
        CMD_S_StatusScore StatusScore;
        memset(&StatusScore, 0, sizeof(StatusScore));

        //历史积分
        for(WORD i = 0; i < m_wPlayerCount; i++)
        {
            tagHistoryScore *pHistoryScore = m_HistoryScore.GetHistoryScore(i);
            StatusScore.lTurnScore[i] = pHistoryScore->lTurnScore;
            StatusScore.lCollectScore[i] = pHistoryScore->lCollectScore;
        }

        //加注信息
        StatusScore.lCellScore = m_pITableFrame->GetCellScore();
        StatusScore.lTurnMaxScore = m_lTurnMaxScore[wChairID];
        StatusScore.wBankerUser = m_wBankerUser;
        StatusScore.cbDynamicJoin = m_cbDynamicJoin[wChairID];
        CopyMemory(StatusScore.cbPlayStatus, m_cbPlayStatus, sizeof(StatusScore.cbPlayStatus));
        StatusScore.lRoomStorageStart = g_lRoomStorageStart;
        StatusScore.lRoomStorageCurrent = g_lRoomStorageCurrent;

        //发四等五
        if(m_stConfig == ST_SENDFOUR_)
        {
            for(WORD i = 0; i < m_wPlayerCount; i++)
            {
                if(m_cbPlayStatus[i] == FALSE && m_cbDynamicJoin[i] == FALSE)
                {
                    continue;
                }

                //派发扑克(开始只发四张牌)
                CopyMemory(StatusScore.cbCardData[i], m_cbHandCardData[i], sizeof(BYTE) * 4);
            }
        }

        StatusScore.ctConfig = m_ctConfig;
        StatusScore.stConfig = m_stConfig;
        StatusScore.bgtConfig = m_bgtConfig;
        StatusScore.btConfig = m_btConfig;
        StatusScore.gtConfig = m_gtConfig;

        CopyMemory(StatusScore.lFreeConfig, m_lFreeConfig, sizeof(StatusScore.lFreeConfig));
        CopyMemory(StatusScore.lPercentConfig, m_lPercentConfig, sizeof(StatusScore.lPercentConfig));
        CopyMemory(StatusScore.lPlayerBetBtEx, m_lPlayerBetBtEx, sizeof(StatusScore.lPlayerBetBtEx));

        //设置积分
        for(WORD i = 0; i < m_wPlayerCount; i++)
        {
            if(m_cbPlayStatus[i] == FALSE) { continue; }
            StatusScore.lTableScore[i] = m_lTableScore[i];
        }

        //获取自定义配置
        tagCustomRule *pCustomRule = (tagCustomRule *)m_pGameServiceOption->cbCustomRule;
        ASSERT(pCustomRule);
        tagCustomAndroid CustomAndroid;
        ZeroMemory(&CustomAndroid, sizeof(CustomAndroid));
        CustomAndroid.lRobotBankGet = pCustomRule->lRobotBankGet;
        CustomAndroid.lRobotBankGetBanker = pCustomRule->lRobotBankGetBanker;
        CustomAndroid.lRobotBankStoMul = pCustomRule->lRobotBankStoMul;
        CustomAndroid.lRobotScoreMax = pCustomRule->lRobotScoreMax;
        CustomAndroid.lRobotScoreMin = pCustomRule->lRobotScoreMin;
        CopyMemory(&StatusScore.CustomAndroid, &CustomAndroid, sizeof(CustomAndroid));
        BYTE *pGameRule = m_pITableFrame->GetGameRule();
        StatusScore.wGamePlayerCountRule = pGameRule[1];
        StatusScore.cbAdmitRevCard = m_cbAdmitRevCard;
        StatusScore.cbPlayMode = m_pITableFrame->GetDataBaseMode();

        //防调试
        if(CServerRule::IsAllowAvertDebugMode(m_pGameServiceOption->dwServerRule))
        {
            StatusScore.bIsAllowAvertDebug = true;
        }

		CopyMemory(StatusScore.cbCallBankerTimes, m_cbCallBankerTimes, sizeof(StatusScore.cbCallBankerTimes));

        //更新房间用户信息
        UpdateRoomUserInfo(pIServerUserItem, USER_RECONNECT);

        //权限判断
        if(CUserRight::IsGameDebugUser(pIServerUserItem->GetUserRight()) && !pIServerUserItem->IsAndroidUser())
        {
            CMD_S_ADMIN_STORAGE_INFO StorageInfo;
            ZeroMemory(&StorageInfo, sizeof(StorageInfo));
            StorageInfo.lRoomStorageStart = g_lRoomStorageStart;
            StorageInfo.lRoomStorageCurrent = g_lRoomStorageCurrent;
            StorageInfo.lRoomStorageDeduct = g_lStorageDeductRoom;
            StorageInfo.lMaxRoomStorage[0] = g_lStorageMax1Room;
            StorageInfo.lMaxRoomStorage[1] = g_lStorageMax2Room;
            StorageInfo.wRoomStorageMul[0] = (WORD)g_lStorageMul1Room;
            StorageInfo.wRoomStorageMul[1] = (WORD)g_lStorageMul2Room;
            m_pITableFrame->SendRoomData(NULL, SUB_S_ADMIN_STORAGE_INFO, &StorageInfo, sizeof(StorageInfo));
        }

        //房卡模式
        if((m_pGameServiceOption->wServerType & GAME_GENRE_PERSONAL) != 0)
        {
            m_pITableFrame->SendTableData(INVALID_CHAIR, SUB_S_RECORD, &m_stRecord, sizeof(m_stRecord));

            CMD_S_RoomCardRecord RoomCardRecord;
            ZeroMemory(&RoomCardRecord, sizeof(RoomCardRecord));

            CopyMemory(&RoomCardRecord, &m_RoomCardRecord, sizeof(m_RoomCardRecord));

            m_pITableFrame->SendTableData(INVALID_CHAIR, SUB_S_ROOMCARD_RECORD, &RoomCardRecord, sizeof(RoomCardRecord));
            m_pITableFrame->SendLookonData(INVALID_CHAIR, SUB_S_ROOMCARD_RECORD, &RoomCardRecord, sizeof(RoomCardRecord));
        }

		//金币场和金币房卡可以托管，积分房卡也托管
		//断线回来取消代打
		//if(((m_pGameServiceOption->wServerType & GAME_GENRE_PERSONAL) != 0 && m_pITableFrame->GetDataBaseMode() == 1)
		//        || (m_pGameServiceOption->wServerType & GAME_GENRE_PERSONAL) == 0)
        {
            //重连取消托管标志
            pIServerUserItem->SetTrusteeUser(false);
            m_pITableFrame->KillGameTimer(IDI_OFFLINE_TRUSTEE_0 + wChairID);
        }

        //发送场景
        return m_pITableFrame->SendGameScene(pIServerUserItem, &StatusScore, sizeof(StatusScore));
    }
    case GS_TK_PLAYING:	//游戏状态
    {
        //构造数据
        CMD_S_StatusPlay StatusPlay;
        memset(&StatusPlay, 0, sizeof(StatusPlay));

        //历史积分
        for(WORD i = 0; i < m_wPlayerCount; i++)
        {
            tagHistoryScore *pHistoryScore = m_HistoryScore.GetHistoryScore(i);
            StatusPlay.lTurnScore[i] = pHistoryScore->lTurnScore;
            StatusPlay.lCollectScore[i] = pHistoryScore->lCollectScore;
        }

        //设置信息
        StatusPlay.lCellScore = m_pITableFrame->GetCellScore();
        StatusPlay.lTurnMaxScore = m_lTurnMaxScore[wChairID];
        StatusPlay.wBankerUser = m_wBankerUser;
        StatusPlay.cbDynamicJoin = m_cbDynamicJoin[wChairID];
        CopyMemory(StatusPlay.bOpenCard, m_bOpenCard, sizeof(StatusPlay.bOpenCard));
        CopyMemory(StatusPlay.bSpecialCard, m_bSpecialCard, sizeof(StatusPlay.bSpecialCard));
        CopyMemory(StatusPlay.cbOriginalCardType, m_cbOriginalCardType, sizeof(StatusPlay.cbOriginalCardType));
        CopyMemory(StatusPlay.cbCombineCardType, m_cbCombineCardType, sizeof(StatusPlay.cbCombineCardType));

        CopyMemory(StatusPlay.cbPlayStatus, m_cbPlayStatus, sizeof(StatusPlay.cbPlayStatus));
        StatusPlay.lRoomStorageStart = g_lRoomStorageStart;
        StatusPlay.lRoomStorageCurrent = g_lRoomStorageCurrent;

        StatusPlay.ctConfig = m_ctConfig;
        StatusPlay.stConfig = m_stConfig;
        StatusPlay.bgtConfig = m_bgtConfig;
        StatusPlay.btConfig = m_btConfig;
        StatusPlay.gtConfig = m_gtConfig;

        CopyMemory(StatusPlay.lFreeConfig, m_lFreeConfig, sizeof(StatusPlay.lFreeConfig));
        CopyMemory(StatusPlay.lPercentConfig, m_lPercentConfig, sizeof(StatusPlay.lPercentConfig));
        CopyMemory(StatusPlay.lPlayerBetBtEx, m_lPlayerBetBtEx, sizeof(StatusPlay.lPlayerBetBtEx));

        //获取自定义配置
        tagCustomRule *pCustomRule = (tagCustomRule *)m_pGameServiceOption->cbCustomRule;
        ASSERT(pCustomRule);
        tagCustomAndroid CustomAndroid;
        ZeroMemory(&CustomAndroid, sizeof(CustomAndroid));
        CustomAndroid.lRobotBankGet = pCustomRule->lRobotBankGet;
        CustomAndroid.lRobotBankGetBanker = pCustomRule->lRobotBankGetBanker;
        CustomAndroid.lRobotBankStoMul = pCustomRule->lRobotBankStoMul;
        CustomAndroid.lRobotScoreMax = pCustomRule->lRobotScoreMax;
        CustomAndroid.lRobotScoreMin = pCustomRule->lRobotScoreMin;
        CopyMemory(&StatusPlay.CustomAndroid, &CustomAndroid, sizeof(CustomAndroid));
        BYTE *pGameRule = m_pITableFrame->GetGameRule();
        StatusPlay.wGamePlayerCountRule = pGameRule[1];
        StatusPlay.cbAdmitRevCard = m_cbAdmitRevCard;
        StatusPlay.cbPlayMode = m_pITableFrame->GetDataBaseMode();

        //防调试
        if(CServerRule::IsAllowAvertDebugMode(m_pGameServiceOption->dwServerRule))
        {
            StatusPlay.bIsAllowAvertDebug = true;
        }

        //设置扑克
        for(WORD i = 0; i < m_wPlayerCount; i++)
        {
            if(m_cbPlayStatus[i] == FALSE) { continue; }
            WORD j = i;
            StatusPlay.lTableScore[j] = m_lTableScore[j];
            CopyMemory(StatusPlay.cbHandCardData[j], m_cbHandCardData[j], MAX_CARDCOUNT);
        }

		CopyMemory(StatusPlay.cbCallBankerTimes, m_cbCallBankerTimes, sizeof(StatusPlay.cbCallBankerTimes));

        //更新房间用户信息
        UpdateRoomUserInfo(pIServerUserItem, USER_RECONNECT);

        //权限判断
        if(CUserRight::IsGameDebugUser(pIServerUserItem->GetUserRight()) && !pIServerUserItem->IsAndroidUser())
        {
            CMD_S_ADMIN_STORAGE_INFO StorageInfo;
            ZeroMemory(&StorageInfo, sizeof(StorageInfo));
            StorageInfo.lRoomStorageStart = g_lRoomStorageStart;
            StorageInfo.lRoomStorageCurrent = g_lRoomStorageCurrent;
            StorageInfo.lRoomStorageDeduct = g_lStorageDeductRoom;
            StorageInfo.lMaxRoomStorage[0] = g_lStorageMax1Room;
            StorageInfo.lMaxRoomStorage[1] = g_lStorageMax2Room;
            StorageInfo.wRoomStorageMul[0] = (WORD)g_lStorageMul1Room;
            StorageInfo.wRoomStorageMul[1] = (WORD)g_lStorageMul2Room;
            m_pITableFrame->SendRoomData(NULL, SUB_S_ADMIN_STORAGE_INFO, &StorageInfo, sizeof(StorageInfo));
        }

        //房卡模式
        if((m_pGameServiceOption->wServerType & GAME_GENRE_PERSONAL) != 0)
        {
            m_pITableFrame->SendTableData(INVALID_CHAIR, SUB_S_RECORD, &m_stRecord, sizeof(m_stRecord));

            CMD_S_RoomCardRecord RoomCardRecord;
            ZeroMemory(&RoomCardRecord, sizeof(RoomCardRecord));

            CopyMemory(&RoomCardRecord, &m_RoomCardRecord, sizeof(m_RoomCardRecord));

            m_pITableFrame->SendTableData(INVALID_CHAIR, SUB_S_ROOMCARD_RECORD, &RoomCardRecord, sizeof(RoomCardRecord));
            m_pITableFrame->SendLookonData(INVALID_CHAIR, SUB_S_ROOMCARD_RECORD, &RoomCardRecord, sizeof(RoomCardRecord));
        }

		//金币场和金币房卡可以托管，积分房卡也托管
		//断线回来取消代打
		//if(((m_pGameServiceOption->wServerType & GAME_GENRE_PERSONAL) != 0 && m_pITableFrame->GetDataBaseMode() == 1)
		//        || (m_pGameServiceOption->wServerType & GAME_GENRE_PERSONAL) == 0)
        {
            //重连取消托管标志
            pIServerUserItem->SetTrusteeUser(false);
            m_pITableFrame->KillGameTimer(IDI_OFFLINE_TRUSTEE_0 + wChairID);
        }

		//当前tm
		DWORD dwCurTickCount = (DWORD)time(NULL);
		DWORD dwDTmVal = dwCurTickCount - m_GameEndEx.dwTickCountGameEnd;

		if (dwDTmVal >= 1 && dwDTmVal <= TIME_DELAY_GAMEFREE / 1000 && !pIServerUserItem->IsAndroidUser())
		{
			StatusPlay.bDelayFreeDynamicJoin = true;
		}

		CopyMemory(StatusPlay.lTurnScore, m_GameEndEx.GameEnd.lGameScore, sizeof(StatusPlay.lTurnScore));

        //发送场景
        return m_pITableFrame->SendGameScene(pIServerUserItem, &StatusPlay, sizeof(StatusPlay));
    }
    }
    //效验错误
    ASSERT(FALSE);

    return false;
}

//定时器事件
bool CTableFrameSink::OnTimerMessage(DWORD dwTimerID, WPARAM wBindParam)
{
    switch(dwTimerID)
    {
	case IDI_DELAY_GAMEFREE:
	{
		//删除时间
		m_pITableFrame->KillGameTimer(IDI_DELAY_GAMEFREE);

		BOOL bEndLoop = *((BOOL*)wBindParam);
		m_pITableFrame->ConcludeGame(GS_TK_FREE, bEndLoop);

		return true;
	}
    case IDI_SO_OPERATE:
    {
        //删除时间
        m_pITableFrame->KillGameTimer(IDI_SO_OPERATE);

        //游戏状态
        switch(m_pITableFrame->GetGameStatus())
        {
        case GS_TK_CALL:			//用户叫庄
        {
            for(WORD i = 0; i < m_wPlayerCount; i++)
            {
                if(m_cbPlayStatus[i] != TRUE)
                {
                    continue;
                }
                if(m_cbCallBankerStatus[i] == TRUE)
                {
                    continue;
                }

                if(i == m_wBgtRobNewTurnChairID && m_wBgtRobNewTurnChairID != INVALID_CHAIR)
                {
                    OnUserCallBanker(i, true, 1);
                }
                else
                {
                    OnUserCallBanker(i, false, m_cbPrevCallBankerTimes[i]);
                }
            }

            break;
        }
        case GS_TK_SCORE:			//下注操作
        {
            for(WORD i = 0; i < m_wPlayerCount; i++)
            {
                if(m_lTableScore[i] > 0L || m_cbPlayStatus[i] == FALSE || i == m_wBankerUser)
                {
                    continue;
                }

                if(m_lTurnMaxScore[i] > 0)
                {
                    if(m_btConfig == BT_FREE_)
                    {
                        OnUserAddScore(i, m_lFreeConfig[0] * m_pITableFrame->GetCellScore());
                    }
                    else if(m_btConfig == BT_PENCENT_)
                    {
                        OnUserAddScore(i, m_lTurnMaxScore[i] * m_lPercentConfig[0] / 100);
                    }
                }
                else
                {
                    OnUserAddScore(i, 1);
                }
            }

            break;
        }
        case GS_TK_PLAYING:			//用户开牌
        {
            for(WORD i = 0; i < m_wPlayerCount; i++)
            {
                if(m_bOpenCard[i] == true || m_cbPlayStatus[i] == FALSE)
                {
                    continue;
                }

                //获取牛牛牌型
                BYTE cbTempHandCardData[MAX_CARDCOUNT];
                ZeroMemory(cbTempHandCardData, sizeof(cbTempHandCardData));
                CopyMemory(cbTempHandCardData, m_cbHandCardData[i], sizeof(m_cbHandCardData[i]));

                m_GameLogic.GetOxCard(cbTempHandCardData, MAX_CARDCOUNT);

                OnUserOpenCard(i, cbTempHandCardData);
            }

            break;
        }
        default:
        {
            break;
        }
        }

        if(m_pITableFrame->GetGameStatus() != GS_TK_FREE)
        {
            m_pITableFrame->SetGameTimer(IDI_SO_OPERATE, TIME_SO_OPERATE, 1, 0);
        }
        return true;
    }
    case IDI_OFFLINE_TRUSTEE_0:
    case IDI_OFFLINE_TRUSTEE_1:
    case IDI_OFFLINE_TRUSTEE_2:
    case IDI_OFFLINE_TRUSTEE_3:
    case IDI_OFFLINE_TRUSTEE_4:
    case IDI_OFFLINE_TRUSTEE_5:
    case IDI_OFFLINE_TRUSTEE_6:
    case IDI_OFFLINE_TRUSTEE_7:
    {
        m_pITableFrame->KillGameTimer(dwTimerID);
        WORD wOfflineTrustee = dwTimerID - IDI_OFFLINE_TRUSTEE_0;

        if(m_pITableFrame->GetTableUserItem(wOfflineTrustee) && m_pITableFrame->GetTableUserItem(wOfflineTrustee)->IsTrusteeUser())
        {
            //游戏状态
            switch(m_pITableFrame->GetGameStatus())
            {
            case GS_TK_CALL:			//用户叫庄
            {
                if(m_cbPlayStatus[wOfflineTrustee] != TRUE)
                {
                    break;
                }
                if(m_cbCallBankerStatus[wOfflineTrustee] == TRUE)
                {
                    break;
                }

                if(wOfflineTrustee == m_wBgtRobNewTurnChairID && m_wBgtRobNewTurnChairID != INVALID_CHAIR)
                {
                    OnUserCallBanker(wOfflineTrustee, true, 1);
                }
                else
                {
                    OnUserCallBanker(wOfflineTrustee, false, 0);
                }

                break;
            }
            case GS_TK_SCORE:			//下注操作
            {
                if(m_lTableScore[wOfflineTrustee] > 0L || m_cbPlayStatus[wOfflineTrustee] == FALSE || wOfflineTrustee == m_wBankerUser)
                {
                    break;
                }

                if(m_lTurnMaxScore[wOfflineTrustee] > 0)
                {
                    if(m_btConfig == BT_FREE_)
                    {
                        OnUserAddScore(wOfflineTrustee, m_lFreeConfig[0] * m_pITableFrame->GetCellScore());
                    }
                    else if(m_btConfig == BT_PENCENT_)
                    {
                        OnUserAddScore(wOfflineTrustee, m_lTurnMaxScore[wOfflineTrustee] * m_lPercentConfig[0] / 100);
                    }
                }
                else
                {
                    OnUserAddScore(wOfflineTrustee, 1);
                }

                break;
            }
            case GS_TK_PLAYING:			//用户开牌
            {
                if(m_bOpenCard[wOfflineTrustee] == true || m_cbPlayStatus[wOfflineTrustee] == FALSE)
                {
                    break;
                }

                //获取牛牛牌型
                BYTE cbTempHandCardData[MAX_CARDCOUNT];
                ZeroMemory(cbTempHandCardData, sizeof(cbTempHandCardData));
                CopyMemory(cbTempHandCardData, m_cbHandCardData[wOfflineTrustee], sizeof(m_cbHandCardData[wOfflineTrustee]));

                m_GameLogic.GetOxCard(cbTempHandCardData, MAX_CARDCOUNT);

                OnUserOpenCard(wOfflineTrustee, cbTempHandCardData);

                break;
            }
            default:
            {
                break;
            }
            }
        }

        return true;
    }
    case IDI_TIME_ELAPSE:
    {
        if(m_cbTimeRemain > 0)
        {
            m_cbTimeRemain--;
        }

        return true;
    }
    }
    return false;
}

//游戏消息处理
bool CTableFrameSink::OnGameMessage(WORD wSubCmdID, void *pDataBuffer, WORD wDataSize, IServerUserItem *pIServerUserItem)
{
    bool bResult = false;
    switch(wSubCmdID)
    {
    case SUB_C_CALL_BANKER:			//用户叫庄
    {
        //效验数据
        ASSERT(wDataSize == sizeof(CMD_C_CallBanker));
        if(wDataSize != sizeof(CMD_C_CallBanker)) { return false; }

        //变量定义
        CMD_C_CallBanker *pCallBanker = (CMD_C_CallBanker *)pDataBuffer;

        //用户效验
        tagUserInfo *pUserData = pIServerUserItem->GetUserInfo();
        //if (pUserData->cbUserStatus!=US_PLAYING) return true;

        //状态判断
        ASSERT(m_cbPlayStatus[pUserData->wChairID] == TRUE);
        if(m_cbPlayStatus[pUserData->wChairID] != TRUE)
        {
            //写日志
			CString strFileName = TEXT("调试日志");

            tagLogUserInfo LogUserInfo;
            ZeroMemory(&LogUserInfo, sizeof(LogUserInfo));
            CopyMemory(LogUserInfo.szDescName, strFileName, sizeof(LogUserInfo.szDescName));
            CopyMemory(LogUserInfo.szLogContent, TEXT("m_cbPlayStatus = FALSE"), sizeof(LogUserInfo.szLogContent));
            //m_pITableFrame->SendGameLogData(LogUserInfo);

            return false;
        }

        //消息处理
        bResult = OnUserCallBanker(pUserData->wChairID, pCallBanker->bBanker, pCallBanker->cbBankerTimes);
        break;
    }
    case SUB_C_ADD_SCORE:			//用户加注
    {
        //效验数据
        ASSERT(wDataSize == sizeof(CMD_C_AddScore));
        if(wDataSize != sizeof(CMD_C_AddScore))
        {
            return false;
        }

        //变量定义
        CMD_C_AddScore *pAddScore = (CMD_C_AddScore *)pDataBuffer;

        //用户效验
        tagUserInfo *pUserData = pIServerUserItem->GetUserInfo();
        //if (pUserData->cbUserStatus!=US_PLAYING) return true;

        //状态判断
        ASSERT(m_cbPlayStatus[pUserData->wChairID] == TRUE);
        if(m_cbPlayStatus[pUserData->wChairID] != TRUE)
        {
            //写日志
			CString strFileName = TEXT("调试日志");

            tagLogUserInfo LogUserInfo;
            ZeroMemory(&LogUserInfo, sizeof(LogUserInfo));
            CopyMemory(LogUserInfo.szDescName, strFileName, sizeof(LogUserInfo.szDescName));
            CopyMemory(LogUserInfo.szLogContent, TEXT("m_cbPlayStatus = FALSE"), sizeof(LogUserInfo.szLogContent));
            //m_pITableFrame->SendGameLogData(LogUserInfo);

            return false;
        }

        //消息处理
        bResult = OnUserAddScore(pUserData->wChairID, pAddScore->lScore);
        break;
    }
    case SUB_C_OPEN_CARD:			//用户摊牌
    {
        ASSERT(wDataSize == sizeof(CMD_C_OpenCard));
        if(wDataSize != sizeof(CMD_C_OpenCard)) { return false; }

        CMD_C_OpenCard *pOpenCard = (CMD_C_OpenCard *)pDataBuffer;

        //用户效验
        tagUserInfo *pUserData = pIServerUserItem->GetUserInfo();
        //if (pUserData->cbUserStatus!=US_PLAYING) return true;

        //状态判断
        ASSERT(m_cbPlayStatus[pUserData->wChairID] != FALSE);
        if(m_cbPlayStatus[pUserData->wChairID] == FALSE)
        {
            //写日志
			CString strFileName = TEXT("调试日志");

            tagLogUserInfo LogUserInfo;
            ZeroMemory(&LogUserInfo, sizeof(LogUserInfo));
            CopyMemory(LogUserInfo.szDescName, strFileName, sizeof(LogUserInfo.szDescName));
            CopyMemory(LogUserInfo.szLogContent, TEXT("m_cbPlayStatus = FALSE"), sizeof(LogUserInfo.szLogContent));
            //m_pITableFrame->SendGameLogData(LogUserInfo);

            return false;
        }

        //消息处理
        bResult = OnUserOpenCard(pUserData->wChairID, pOpenCard->cbCombineCardData);
        break;
    }
    case SUB_C_REQUEST_RCRecord:
    {
        //ASSERT((m_pGameServiceOption->wServerType & GAME_GENRE_PERSONAL) != 0);
        if(!((m_pGameServiceOption->wServerType & GAME_GENRE_PERSONAL) != 0))
        {
            return true;
        }

        if(m_pITableFrame->IsPersonalRoomDisumme())
        {
            return true;
        }

        ASSERT(pIServerUserItem->IsMobileUser());
        if(!pIServerUserItem->IsMobileUser())
        {
            return false;
        }

        CMD_S_RoomCardRecord RoomCardRecord;
        ZeroMemory(&RoomCardRecord, sizeof(RoomCardRecord));

        //积分房卡
        if((m_pITableFrame->GetDataBaseMode() == 0) && (((m_pGameServiceOption->wServerType) & GAME_GENRE_PERSONAL) != 0))
        {
            CopyMemory(&RoomCardRecord, &m_RoomCardRecord, sizeof(m_RoomCardRecord));
        }
        else
        {
            WORD wChairID = pIServerUserItem->GetChairID();
            POSITION pos = m_listWinScoreRecord[wChairID].GetHeadPosition();

            WORD wIndex = 0;
            while(pos)
            {
                RoomCardRecord.lDetailScore[wChairID][wIndex++] = m_listWinScoreRecord[wChairID].GetNext(pos);

                if(wIndex >= MAX_RECORD_COUNT)
                {
                    break;
                }
            }

            RoomCardRecord.nCount = wIndex;
        }

        m_pITableFrame->SendTableData(pIServerUserItem->GetChairID(), SUB_S_ROOMCARD_RECORD, &RoomCardRecord, sizeof(RoomCardRecord));
        m_pITableFrame->SendLookonData(pIServerUserItem->GetChairID(), SUB_S_ROOMCARD_RECORD, &RoomCardRecord, sizeof(RoomCardRecord));

        return true;
    }
#ifdef CARD_CONFIG
    case SUB_C_CARD_CONFIG:
    {
        //效验数据
        ASSERT(wDataSize == sizeof(CMD_C_CardConfig));
        if(wDataSize != sizeof(CMD_C_CardConfig))
        {
            return true;
        }

        //消息处理
        CMD_C_CardConfig *pCardConfig = (CMD_C_CardConfig *)pDataBuffer;

        CopyMemory(m_cbconfigCard, pCardConfig->cbconfigCard, sizeof(m_cbconfigCard));

        return true;
    }
#endif
    }

    BYTE cbGameStatus = m_pITableFrame->GetGameStatus();

    return true;
}

//框架消息处理
bool CTableFrameSink::OnFrameMessage(WORD wSubCmdID, void *pDataBuffer, WORD wDataSize, IServerUserItem *pIServerUserItem)
{
    // 消息处理
    if(wSubCmdID >= SUB_GF_FRAME_MESSAG_GAME_MIN && wSubCmdID <= SUB_GF_FRAME_MESSAG_GAME_MAX)
    {
        switch(wSubCmdID - SUB_GF_FRAME_MESSAG_GAME_MIN)
        {
        case SUB_C_STORAGE:
        {
            ASSERT(wDataSize == sizeof(CMD_C_UpdateStorage));
            if(wDataSize != sizeof(CMD_C_UpdateStorage)) { return false; }

            //权限判断
            if(CUserRight::IsGameDebugUser(pIServerUserItem->GetUserRight()) == false)
            {
                return false;
            }

            CMD_C_UpdateStorage *pUpdateStorage = (CMD_C_UpdateStorage *)pDataBuffer;
            g_lRoomStorageCurrent = pUpdateStorage->lRoomStorageCurrent;
            g_lStorageDeductRoom = pUpdateStorage->lRoomStorageDeduct;

            //20条操作记录
            if(g_ListOperationRecord.GetSize() == MAX_OPERATION_RECORD)
            {
                g_ListOperationRecord.RemoveHead();
            }

            //写日志
            CString strOperationRecord;
            strOperationRecord.Format(TEXT("调试账户[%s],修改当前库存为 %I64d,衰减值为 %I64d"), pIServerUserItem->GetNickName(),
                                      g_lRoomStorageCurrent, g_lStorageDeductRoom);

            g_ListOperationRecord.AddTail(strOperationRecord);

			CString strFileName = TEXT("调试日志");

            tagLogUserInfo LogUserInfo;
            ZeroMemory(&LogUserInfo, sizeof(LogUserInfo));
            CopyMemory(LogUserInfo.szDescName, strFileName, sizeof(LogUserInfo.szDescName));
            CopyMemory(LogUserInfo.szLogContent, strOperationRecord, sizeof(LogUserInfo.szLogContent));
            //m_pITableFrame->SendGameLogData(LogUserInfo);

            //变量定义
            CMD_S_Operation_Record OperationRecord;
            ZeroMemory(&OperationRecord, sizeof(OperationRecord));
            POSITION posListRecord = g_ListOperationRecord.GetHeadPosition();
            WORD wIndex = 0;//数组下标
            while(posListRecord)
            {
                CString strRecord = g_ListOperationRecord.GetNext(posListRecord);

                CopyMemory(OperationRecord.szRecord[wIndex], strRecord, sizeof(OperationRecord.szRecord[wIndex]));
                wIndex++;
            }

            ASSERT(wIndex <= MAX_OPERATION_RECORD);

            //发送数据
            m_pITableFrame->SendRoomData(pIServerUserItem, SUB_S_OPERATION_RECORD, &OperationRecord, sizeof(OperationRecord));

            return true;
        }
        case SUB_C_STORAGEMAXMUL:
        {
            ASSERT(wDataSize == sizeof(CMD_C_ModifyStorage));
            if(wDataSize != sizeof(CMD_C_ModifyStorage)) { return false; }

            //权限判断
            if(CUserRight::IsGameDebugUser(pIServerUserItem->GetUserRight()) == false)
            {
                return false;
            }

            CMD_C_ModifyStorage *pModifyStorage = (CMD_C_ModifyStorage *)pDataBuffer;
            g_lStorageMax1Room = pModifyStorage->lMaxRoomStorage[0];
            g_lStorageMax2Room = pModifyStorage->lMaxRoomStorage[1];
            g_lStorageMul1Room = (SCORE)(pModifyStorage->wRoomStorageMul[0]);
            g_lStorageMul2Room = (SCORE)(pModifyStorage->wRoomStorageMul[1]);

            //20条操作记录
            if(g_ListOperationRecord.GetSize() == MAX_OPERATION_RECORD)
            {
                g_ListOperationRecord.RemoveHead();
            }

            //写入日志
            CString strOperationRecord;
            strOperationRecord.Format(TEXT("调试账户[%s], 修改库存上限值1为 %I64d,赢分概率1为 %I64d,上限值2为 %I64d,赢分概率2为 %I64d"), pIServerUserItem->GetNickName(), g_lStorageMax1Room, g_lStorageMul1Room, g_lStorageMax2Room, g_lStorageMul2Room);

            g_ListOperationRecord.AddTail(strOperationRecord);

			CString strFileName = TEXT("调试日志");

            tagLogUserInfo LogUserInfo;
            ZeroMemory(&LogUserInfo, sizeof(LogUserInfo));
            CopyMemory(LogUserInfo.szDescName, strFileName, sizeof(LogUserInfo.szDescName));
            CopyMemory(LogUserInfo.szLogContent, strOperationRecord, sizeof(LogUserInfo.szLogContent));
            //m_pITableFrame->SendGameLogData(LogUserInfo);

            //变量定义
            CMD_S_Operation_Record OperationRecord;
            ZeroMemory(&OperationRecord, sizeof(OperationRecord));
            POSITION posListRecord = g_ListOperationRecord.GetHeadPosition();
            WORD wIndex = 0;//数组下标
            while(posListRecord)
            {
                CString strRecord = g_ListOperationRecord.GetNext(posListRecord);

                CopyMemory(OperationRecord.szRecord[wIndex], strRecord, sizeof(OperationRecord.szRecord[wIndex]));
                wIndex++;
            }

            ASSERT(wIndex <= MAX_OPERATION_RECORD);

            //发送数据
            m_pITableFrame->SendRoomData(pIServerUserItem, SUB_S_OPERATION_RECORD, &OperationRecord, sizeof(OperationRecord));

            return true;
        }
        case SUB_C_REQUEST_QUERY_USER:
        {
            ASSERT(wDataSize == sizeof(CMD_C_RequestQuery_User));
            if(wDataSize != sizeof(CMD_C_RequestQuery_User))
            {
                return false;
            }

            //权限判断
            if(CUserRight::IsGameDebugUser(pIServerUserItem->GetUserRight()) == false || pIServerUserItem->IsAndroidUser())
            {
                return false;
            }

            CMD_C_RequestQuery_User *pQuery_User = (CMD_C_RequestQuery_User *)pDataBuffer;

            //遍历映射
            POSITION ptHead = g_MapRoomUserInfo.GetStartPosition();
            DWORD dwUserID = 0;
            ROOMUSERINFO userinfo;
            ZeroMemory(&userinfo, sizeof(userinfo));

            CMD_S_RequestQueryResult QueryResult;
            ZeroMemory(&QueryResult, sizeof(QueryResult));

            while(ptHead)
            {
                g_MapRoomUserInfo.GetNextAssoc(ptHead, dwUserID, userinfo);
                if(pQuery_User->dwGameID == userinfo.dwGameID || _tcscmp(pQuery_User->szNickName, userinfo.szNickName) == 0)
                {
                    //拷贝用户信息数据
                    QueryResult.bFind = true;
                    CopyMemory(&(QueryResult.userinfo), &userinfo, sizeof(userinfo));

                    ZeroMemory(&g_CurrentQueryUserInfo, sizeof(g_CurrentQueryUserInfo));
                    CopyMemory(&(g_CurrentQueryUserInfo), &userinfo, sizeof(userinfo));
                }
            }

            //发送数据
            m_pITableFrame->SendRoomData(pIServerUserItem, SUB_S_REQUEST_QUERY_RESULT, &QueryResult, sizeof(QueryResult));

            return true;
        }
        case SUB_C_USER_DEBUG:
        {
            ASSERT(wDataSize == sizeof(CMD_C_UserDebug));
            if(wDataSize != sizeof(CMD_C_UserDebug))
            {
                return false;
            }

            //权限判断
            if(CUserRight::IsGameDebugUser(pIServerUserItem->GetUserRight()) == false || pIServerUserItem->IsAndroidUser() == true)
            {
                return false;
            }

            CMD_C_UserDebug *pUserDebug = (CMD_C_UserDebug *)pDataBuffer;

            //遍历映射
            POSITION ptMapHead = g_MapRoomUserInfo.GetStartPosition();
            DWORD dwUserID = 0;
            ROOMUSERINFO userinfo;
            ZeroMemory(&userinfo, sizeof(userinfo));

            //20条操作记录
            if(g_ListOperationRecord.GetSize() == MAX_OPERATION_RECORD)
            {
                g_ListOperationRecord.RemoveHead();
            }

            //变量定义
            CMD_S_UserDebug serverUserDebug;
            ZeroMemory(&serverUserDebug, sizeof(serverUserDebug));

            TCHAR szNickName[LEN_NICKNAME];
            ZeroMemory(szNickName, sizeof(szNickName));

            //激活调试
            if(pUserDebug->userDebugInfo.bCancelDebug == false)
            {
                ASSERT(pUserDebug->userDebugInfo.debug_type == CONTINUE_WIN || pUserDebug->userDebugInfo.debug_type == CONTINUE_LOST);

                while(ptMapHead)
                {
                    g_MapRoomUserInfo.GetNextAssoc(ptMapHead, dwUserID, userinfo);

                    if(_tcscmp(pUserDebug->szNickName, szNickName) == 0 && _tcscmp(userinfo.szNickName, szNickName) == 0)
                    {
                        continue;
                    }

                    if(pUserDebug->dwGameID == userinfo.dwGameID || _tcscmp(pUserDebug->szNickName, userinfo.szNickName) == 0)
                    {
                        //激活调试标识
                        bool bEnableDebug = false;
                        IsSatisfyDebug(userinfo, bEnableDebug);

                        //满足调试
                        if(bEnableDebug)
                        {
                            ROOMUSERDEBUG roomuserdebug;
                            ZeroMemory(&roomuserdebug, sizeof(roomuserdebug));
                            CopyMemory(&(roomuserdebug.roomUserInfo), &userinfo, sizeof(userinfo));
                            CopyMemory(&(roomuserdebug.userDebug), &(pUserDebug->userDebugInfo), sizeof(roomuserdebug.userDebug));


                            //遍历链表，除重
                            TravelDebugList(roomuserdebug);

                            //压入链表（不压入同GAMEID和NICKNAME)
                            g_ListRoomUserDebug.AddHead(roomuserdebug);

                            //复制数据
                            serverUserDebug.dwGameID = userinfo.dwGameID;
                            CopyMemory(serverUserDebug.szNickName, userinfo.szNickName, sizeof(userinfo.szNickName));
                            serverUserDebug.debugResult = DEBUG_SUCCEED;
                            serverUserDebug.debugType = pUserDebug->userDebugInfo.debug_type;
                            serverUserDebug.cbDebugCount = pUserDebug->userDebugInfo.cbDebugCount;

                            //操作记录
                            //写入日志
                            CString strOperationRecord;
                            CString strDebugType;
                            GetDebugTypeString(serverUserDebug.debugType, strDebugType);
                            strOperationRecord.Format(TEXT("调试账户[%s], 调试玩家%s,%s,调试局数%d"),
                                                      pIServerUserItem->GetNickName(), serverUserDebug.szNickName, strDebugType, serverUserDebug.cbDebugCount);

                            g_ListOperationRecord.AddTail(strOperationRecord);

							CString strFileName = TEXT("调试日志");

                            tagLogUserInfo LogUserInfo;
                            ZeroMemory(&LogUserInfo, sizeof(LogUserInfo));
                            CopyMemory(LogUserInfo.szDescName, strFileName, sizeof(LogUserInfo.szDescName));
                            CopyMemory(LogUserInfo.szLogContent, strOperationRecord, sizeof(LogUserInfo.szLogContent));
                            //m_pITableFrame->SendGameLogData(LogUserInfo);
                        }
                        else	//不满足
                        {
                            //复制数据
                            serverUserDebug.dwGameID = userinfo.dwGameID;
                            CopyMemory(serverUserDebug.szNickName, userinfo.szNickName, sizeof(userinfo.szNickName));
                            serverUserDebug.debugResult = DEBUG_FAIL;
                            serverUserDebug.debugType = pUserDebug->userDebugInfo.debug_type;
                            serverUserDebug.cbDebugCount = 0;

                            //操作记录
                            //写入日志
                            CString strOperationRecord;
                            CString strDebugType;
                            GetDebugTypeString(serverUserDebug.debugType, strDebugType);
                            strOperationRecord.Format(TEXT("调试账户[%s], 调试玩家%s,%s,失败！"),
                                                      pIServerUserItem->GetNickName(), serverUserDebug.szNickName, strDebugType);

                            g_ListOperationRecord.AddTail(strOperationRecord);

							CString strFileName = TEXT("调试日志");

                            tagLogUserInfo LogUserInfo;
                            ZeroMemory(&LogUserInfo, sizeof(LogUserInfo));
                            CopyMemory(LogUserInfo.szDescName, strFileName, sizeof(LogUserInfo.szDescName));
                            CopyMemory(LogUserInfo.szLogContent, strOperationRecord, sizeof(LogUserInfo.szLogContent));
                            //m_pITableFrame->SendGameLogData(LogUserInfo);
                        }

                        //发送数据
                        m_pITableFrame->SendRoomData(pIServerUserItem, SUB_S_USER_DEBUG, &serverUserDebug, sizeof(serverUserDebug));

                        CMD_S_Operation_Record OperationRecord;
                        ZeroMemory(&OperationRecord, sizeof(OperationRecord));
                        POSITION posListRecord = g_ListOperationRecord.GetHeadPosition();
                        WORD wIndex = 0;//数组下标
                        while(posListRecord)
                        {
                            CString strRecord = g_ListOperationRecord.GetNext(posListRecord);

                            CopyMemory(OperationRecord.szRecord[wIndex], strRecord, sizeof(OperationRecord.szRecord[wIndex]));
                            wIndex++;
                        }

                        ASSERT(wIndex <= MAX_OPERATION_RECORD);

                        //发送数据
                        m_pITableFrame->SendRoomData(pIServerUserItem, SUB_S_OPERATION_RECORD, &OperationRecord, sizeof(OperationRecord));
                        return true;
                    }
                }

                ASSERT(FALSE);
                return false;
            }
            else	//取消调试
            {
                ASSERT(pUserDebug->userDebugInfo.debug_type == CONTINUE_CANCEL);

                POSITION ptListHead = g_ListRoomUserDebug.GetHeadPosition();
                POSITION ptTemp;
                ROOMUSERDEBUG roomuserdebug;
                ZeroMemory(&roomuserdebug, sizeof(roomuserdebug));

                //遍历链表
                while(ptListHead)
                {
                    ptTemp = ptListHead;
                    roomuserdebug = g_ListRoomUserDebug.GetNext(ptListHead);
                    if(pUserDebug->dwGameID == roomuserdebug.roomUserInfo.dwGameID || _tcscmp(pUserDebug->szNickName, roomuserdebug.roomUserInfo.szNickName) == 0)
                    {
                        //复制数据
                        serverUserDebug.dwGameID = roomuserdebug.roomUserInfo.dwGameID;
                        CopyMemory(serverUserDebug.szNickName, roomuserdebug.roomUserInfo.szNickName, sizeof(roomuserdebug.roomUserInfo.szNickName));
                        serverUserDebug.debugResult = DEBUG_CANCEL_SUCCEED;
                        serverUserDebug.debugType = pUserDebug->userDebugInfo.debug_type;
                        serverUserDebug.cbDebugCount = 0;

                        //移除元素
                        g_ListRoomUserDebug.RemoveAt(ptTemp);

                        //发送数据
                        m_pITableFrame->SendRoomData(pIServerUserItem, SUB_S_USER_DEBUG, &serverUserDebug, sizeof(serverUserDebug));

                        //操作记录
                        //写入日志
                        CString strOperationRecord;
                        CTime time = CTime::GetCurrentTime();
                        strOperationRecord.Format(TEXT("调试账户[%s], 取消对玩家%s的调试！"),
                                                  pIServerUserItem->GetNickName(), serverUserDebug.szNickName);

                        g_ListOperationRecord.AddTail(strOperationRecord);

						CString strFileName = TEXT("调试日志");

                        tagLogUserInfo LogUserInfo;
                        ZeroMemory(&LogUserInfo, sizeof(LogUserInfo));
                        CopyMemory(LogUserInfo.szDescName, strFileName, sizeof(LogUserInfo.szDescName));
                        CopyMemory(LogUserInfo.szLogContent, strOperationRecord, sizeof(LogUserInfo.szLogContent));
                        //m_pITableFrame->SendGameLogData(LogUserInfo);

                        CMD_S_Operation_Record OperationRecord;
                        ZeroMemory(&OperationRecord, sizeof(OperationRecord));
                        POSITION posListRecord = g_ListOperationRecord.GetHeadPosition();
                        WORD wIndex = 0;//数组下标
                        while(posListRecord)
                        {
                            CString strRecord = g_ListOperationRecord.GetNext(posListRecord);

                            CopyMemory(OperationRecord.szRecord[wIndex], strRecord, sizeof(OperationRecord.szRecord[wIndex]));
                            wIndex++;
                        }

                        ASSERT(wIndex <= MAX_OPERATION_RECORD);

                        //发送数据
                        m_pITableFrame->SendRoomData(pIServerUserItem, SUB_S_OPERATION_RECORD, &OperationRecord, sizeof(OperationRecord));

                        return true;
                    }
                }

                //复制数据
                serverUserDebug.dwGameID = pUserDebug->dwGameID;
                CopyMemory(serverUserDebug.szNickName, pUserDebug->szNickName, sizeof(serverUserDebug.szNickName));
                serverUserDebug.debugResult = DEBUG_CANCEL_INVALID;
                serverUserDebug.debugType = pUserDebug->userDebugInfo.debug_type;
                serverUserDebug.cbDebugCount = 0;

                //发送数据
                m_pITableFrame->SendRoomData(pIServerUserItem, SUB_S_USER_DEBUG, &serverUserDebug, sizeof(serverUserDebug));

                //操作记录
                //写入日志
                CString strOperationRecord;
                strOperationRecord.Format(TEXT("调试账户[%s], 取消对玩家%s的调试，操作无效！"),
                                          pIServerUserItem->GetNickName(), serverUserDebug.szNickName);

                g_ListOperationRecord.AddTail(strOperationRecord);

				CString strFileName = TEXT("调试日志");

                tagLogUserInfo LogUserInfo;
                ZeroMemory(&LogUserInfo, sizeof(LogUserInfo));
                CopyMemory(LogUserInfo.szDescName, strFileName, sizeof(LogUserInfo.szDescName));
                CopyMemory(LogUserInfo.szLogContent, strOperationRecord, sizeof(LogUserInfo.szLogContent));
                //m_pITableFrame->SendGameLogData(LogUserInfo);

                CMD_S_Operation_Record OperationRecord;
                ZeroMemory(&OperationRecord, sizeof(OperationRecord));
                POSITION posListRecord = g_ListOperationRecord.GetHeadPosition();
                WORD wIndex = 0;//数组下标
                while(posListRecord)
                {
                    CString strRecord = g_ListOperationRecord.GetNext(posListRecord);

                    CopyMemory(OperationRecord.szRecord[wIndex], strRecord, sizeof(OperationRecord.szRecord[wIndex]));
                    wIndex++;
                }

                ASSERT(wIndex <= MAX_OPERATION_RECORD);

                //发送数据
                m_pITableFrame->SendRoomData(pIServerUserItem, SUB_S_OPERATION_RECORD, &OperationRecord, sizeof(OperationRecord));

            }

            return true;
        }
        case SUB_C_REQUEST_UDPATE_ROOMINFO:
        {
            //权限判断
            if(CUserRight::IsGameDebugUser(pIServerUserItem->GetUserRight()) == false || pIServerUserItem->IsAndroidUser() == true)
            {
                return false;
            }

            CMD_S_RequestUpdateRoomInfo_Result RoomInfo_Result;
            ZeroMemory(&RoomInfo_Result, sizeof(RoomInfo_Result));

            RoomInfo_Result.lRoomStorageCurrent = g_lRoomStorageCurrent;


            DWORD dwKeyGameID = g_CurrentQueryUserInfo.dwGameID;
            TCHAR szKeyNickName[LEN_NICKNAME];
            ZeroMemory(szKeyNickName, sizeof(szKeyNickName));
            CopyMemory(szKeyNickName, g_CurrentQueryUserInfo.szNickName, sizeof(szKeyNickName));

            //遍历映射
            POSITION ptHead = g_MapRoomUserInfo.GetStartPosition();
            DWORD dwUserID = 0;
            ROOMUSERINFO userinfo;
            ZeroMemory(&userinfo, sizeof(userinfo));

            while(ptHead)
            {
                g_MapRoomUserInfo.GetNextAssoc(ptHead, dwUserID, userinfo);
                if(dwKeyGameID == userinfo.dwGameID && _tcscmp(szKeyNickName, userinfo.szNickName) == 0)
                {
                    //拷贝用户信息数据
                    CopyMemory(&(RoomInfo_Result.currentqueryuserinfo), &userinfo, sizeof(userinfo));

                    ZeroMemory(&g_CurrentQueryUserInfo, sizeof(g_CurrentQueryUserInfo));
                    CopyMemory(&(g_CurrentQueryUserInfo), &userinfo, sizeof(userinfo));
                }
            }


            //
            //变量定义
            POSITION ptListHead = g_ListRoomUserDebug.GetHeadPosition();
            POSITION ptTemp;
            ROOMUSERDEBUG roomuserdebug;
            ZeroMemory(&roomuserdebug, sizeof(roomuserdebug));

            //遍历链表
            while(ptListHead)
            {
                ptTemp = ptListHead;
                roomuserdebug = g_ListRoomUserDebug.GetNext(ptListHead);

                //寻找玩家
                if((dwKeyGameID == roomuserdebug.roomUserInfo.dwGameID) &&
                        _tcscmp(szKeyNickName, roomuserdebug.roomUserInfo.szNickName) == 0)
                {
                    RoomInfo_Result.bExistDebug = true;
                    CopyMemory(&(RoomInfo_Result.currentuserdebug), &(roomuserdebug.userDebug), sizeof(roomuserdebug.userDebug));
                    break;
                }
            }

            //发送数据
            m_pITableFrame->SendRoomData(pIServerUserItem, SUB_S_REQUEST_UDPATE_ROOMINFO_RESULT, &RoomInfo_Result, sizeof(RoomInfo_Result));

            CMD_S_ADMIN_STORAGE_INFO StorageInfo;
            ZeroMemory(&StorageInfo, sizeof(StorageInfo));
            StorageInfo.lRoomStorageStart = g_lRoomStorageStart;
            StorageInfo.lRoomStorageCurrent = g_lRoomStorageCurrent;
            StorageInfo.lRoomStorageDeduct = g_lStorageDeductRoom;
            StorageInfo.lMaxRoomStorage[0] = g_lStorageMax1Room;
            StorageInfo.lMaxRoomStorage[1] = g_lStorageMax2Room;
            StorageInfo.wRoomStorageMul[0] = (WORD)g_lStorageMul1Room;
            StorageInfo.wRoomStorageMul[1] = (WORD)g_lStorageMul2Room;
            m_pITableFrame->SendRoomData(NULL, SUB_S_ADMIN_STORAGE_INFO, &StorageInfo, sizeof(StorageInfo));

            return true;
        }
        case SUB_C_CLEAR_CURRENT_QUERYUSER:
        {
            //权限判断
            if(CUserRight::IsGameDebugUser(pIServerUserItem->GetUserRight()) == false || pIServerUserItem->IsAndroidUser() == true)
            {
                return false;
            }

            ZeroMemory(&g_CurrentQueryUserInfo, sizeof(g_CurrentQueryUserInfo));

            return true;
        }
        }
    }
    return false;
}

//叫庄事件
bool CTableFrameSink::OnUserCallBanker(WORD wChairID, bool bBanker, BYTE cbBankerTimes)
{
    //状态效验
    BYTE cbGameStatus = m_pITableFrame->GetGameStatus();
    ASSERT(cbGameStatus == GS_TK_CALL);
    if(cbGameStatus != GS_TK_CALL) { return true; }

    //设置变量
    m_cbCallBankerStatus[wChairID] = TRUE;
    m_cbCallBankerTimes[wChairID] = cbBankerTimes;

    //设置变量
    CMD_S_CallBankerInfo CallBanker;
    ZeroMemory(&CallBanker, sizeof(CallBanker));

    CopyMemory(CallBanker.cbCallBankerStatus, m_cbCallBankerStatus, sizeof(m_cbCallBankerStatus));
    CopyMemory(CallBanker.cbCallBankerTimes, m_cbCallBankerTimes, sizeof(m_cbCallBankerTimes));

    //发送数据
    for(WORD i = 0; i < m_wPlayerCount; i++)
    {
        if(m_cbPlayStatus[i] == FALSE && m_cbDynamicJoin[i] == FALSE) { continue; }
        m_pITableFrame->SendTableData(i, SUB_S_CALL_BANKERINFO, &CallBanker, sizeof(CallBanker));
    }
    m_pITableFrame->SendLookonData(INVALID_CHAIR, SUB_S_CALL_BANKERINFO, &CallBanker, sizeof(CallBanker));

    if(m_pGameVideo)
    {
        m_pGameVideo->AddVideoData(SUB_S_CALL_BANKERINFO, &CallBanker);
    }

    //叫庄人数
    WORD wCallUserCount = 0;
    for(WORD i = 0; i < m_wPlayerCount; i++)
    {
        if(m_cbPlayStatus[i] == TRUE && m_cbCallBankerStatus[i] == TRUE) { wCallUserCount++; }
        else if(m_cbPlayStatus[i] != TRUE) { wCallUserCount++; }
    }

    //全部人叫完庄，下注开始
    if(wCallUserCount == m_wPlayerCount)
    {
        CopyMemory(m_cbPrevCallBankerTimes, m_cbCallBankerTimes, sizeof(m_cbPrevCallBankerTimes));

        //
        if(m_wBgtRobNewTurnChairID == INVALID_CHAIR)
        {
            //叫庄最大倍数
            BYTE cbMaxBankerTimes = cbBankerTimes;
            for(WORD i = 0; i < m_wPlayerCount; i++)
            {
                if(m_cbPlayStatus[i] == TRUE && m_cbCallBankerStatus[i] == TRUE && m_cbCallBankerTimes[i] > cbMaxBankerTimes)
                {
                    cbMaxBankerTimes = m_cbCallBankerTimes[i];
                }
            }

            //叫庄最大倍数的人数和CHAIRID
            BYTE cbMaxBankerCount = 0;
            WORD *pwMaxBankerTimesChairID = new WORD[m_wPlayerCount];
            for(WORD i = 0; i < m_wPlayerCount; i++)
            {
                if(m_cbPlayStatus[i] == TRUE && m_cbCallBankerStatus[i] == TRUE && m_cbCallBankerTimes[i] == cbMaxBankerTimes)
                {
                    pwMaxBankerTimesChairID[cbMaxBankerCount++] = i;
                }
            }

            ASSERT(cbMaxBankerCount <= m_wPlayerCount);
            m_wBankerUser = pwMaxBankerTimesChairID[rand() % cbMaxBankerCount];
            delete[] pwMaxBankerTimesChairID;
        }
        else
        {
            m_wBankerUser = m_wBgtRobNewTurnChairID;
        }

        m_bBuckleServiceCharge[m_wBankerUser] = true;

        bool bTrusteeUser = false;
        for(WORD i = 0; i < m_wPlayerCount; i++)
        {
            if(m_cbPlayStatus[i] == TRUE && m_pITableFrame->GetTableUserItem(i)->IsTrusteeUser())
            {
                bTrusteeUser = true;
            }
        }

        //非房卡场设置定时器
        if(!IsRoomCardType()/* || bTrusteeUser*/)
        {
            m_pITableFrame->KillGameTimer(IDI_SO_OPERATE);
            m_pITableFrame->SetGameTimer(IDI_SO_OPERATE, TIME_SO_OPERATE, 1, 0);
        }

        //设置离线代打定时器
        for(WORD i = 0; i < m_wPlayerCount; i++)
        {
            if(m_cbPlayStatus[i] == TRUE && m_pITableFrame->GetTableUserItem(i)->IsTrusteeUser())
            {
                m_pITableFrame->SetGameTimer(IDI_OFFLINE_TRUSTEE_0 + i, m_cbTrusteeDelayTime * 1000, 1, 0);
            }
        }

        //设置状态
        m_pITableFrame->SetGameStatus(GS_TK_SCORE);
        EnableTimeElapse(true);

        //更新房间用户信息
        for(WORD i = 0; i < m_wPlayerCount; i++)
        {
            //获取用户
            IServerUserItem *pIServerUserItem = m_pITableFrame->GetTableUserItem(i);
            if(pIServerUserItem != NULL)
            {
                UpdateRoomUserInfo(pIServerUserItem, USER_SITDOWN);
            }
        }

        //获取最大下注
        for(WORD i = 0; i < m_wPlayerCount; i++)
        {
            if(m_cbPlayStatus[i] != TRUE || i == m_wBankerUser)
            {
                continue;
            }

            //下注变量
            m_lTurnMaxScore[i] = GetUserMaxTurnScore(i);
        }

        for(WORD i = 0; i < m_wPlayerCount; i++)
        {
            if(i == m_wBankerUser || m_cbPlayStatus[i] == FALSE)
            {
                continue;
            }

            if(m_bLastTurnBetBtEx[i] == true)
            {
                m_bLastTurnBetBtEx[i] = false;
            }
        }

        m_lPlayerBetBtEx[m_wBankerUser] = 0;

        //设置变量
        CMD_S_GameStart GameStart;
        ZeroMemory(&GameStart, sizeof(GameStart));
        GameStart.wBankerUser = m_wBankerUser;
        CopyMemory(GameStart.cbPlayerStatus, m_cbPlayStatus, sizeof(m_cbPlayStatus));

        //发四等五
        if(m_stConfig == ST_SENDFOUR_)
        {
            for(WORD i = 0; i < m_wPlayerCount; i++)
            {
                if(m_cbPlayStatus[i] == FALSE && m_cbDynamicJoin[i] == FALSE)
                {
                    continue;
                }

                //派发扑克(开始只发四张牌)
                CopyMemory(GameStart.cbCardData[i], m_cbHandCardData[i], sizeof(BYTE) * 4);
            }
        }

        GameStart.stConfig = m_stConfig;
        GameStart.bgtConfig = m_bgtConfig;
        GameStart.btConfig = m_btConfig;
        GameStart.gtConfig = m_gtConfig;

        CopyMemory(GameStart.lFreeConfig, m_lFreeConfig, sizeof(GameStart.lFreeConfig));
        CopyMemory(GameStart.lPercentConfig, m_lPercentConfig, sizeof(GameStart.lPercentConfig));
        CopyMemory(GameStart.lPlayerBetBtEx, m_lPlayerBetBtEx, sizeof(GameStart.lPlayerBetBtEx));

        bool bFirstRecord = true;

        WORD wRealPlayerCount = 0;
        for(WORD i = 0; i < m_wPlayerCount; i++)
        {
            IServerUserItem *pServerUserItem = m_pITableFrame->GetTableUserItem(i);
            if(m_cbPlayStatus[i] == FALSE && m_cbDynamicJoin[i] == FALSE)
            {
                continue;
            }

            if(!pServerUserItem)
            {
                continue;
            }

            wRealPlayerCount++;
        }

        BYTE *pGameRule = m_pITableFrame->GetGameRule();

        //最大下注
        for(WORD i = 0; i < m_wPlayerCount; i++)
        {
            IServerUserItem *pServerUserItem = m_pITableFrame->GetTableUserItem(i);
            if(m_cbPlayStatus[i] == FALSE && m_cbDynamicJoin[i] == FALSE)
            {
                continue;
            }
            GameStart.lTurnMaxScore = m_lTurnMaxScore[i];
            m_pITableFrame->SendTableData(i, SUB_S_GAME_START, &GameStart, sizeof(GameStart));

            if(m_pGameVideo)
            {
                Video_GameStart video;
                ZeroMemory(&video, sizeof(video));
                video.lCellScore = m_pITableFrame->GetCellScore();
                video.wPlayerCount = wRealPlayerCount;
                video.wGamePlayerCountRule = pGameRule[1];
                video.wBankerUser = GameStart.wBankerUser;
                CopyMemory(video.cbPlayerStatus, GameStart.cbPlayerStatus, sizeof(video.cbPlayerStatus));
                video.lTurnMaxScore = GameStart.lTurnMaxScore;
                CopyMemory(video.cbCardData, GameStart.cbCardData, sizeof(video.cbCardData));
                video.ctConfig = m_ctConfig;
                video.stConfig = GameStart.stConfig;
                video.bgtConfig = GameStart.bgtConfig;
                video.btConfig = GameStart.btConfig;
                video.gtConfig = GameStart.gtConfig;

                CopyMemory(video.lFreeConfig, GameStart.lFreeConfig, sizeof(video.lFreeConfig));
                CopyMemory(video.lPercentConfig, GameStart.lPercentConfig, sizeof(video.lPercentConfig));
                CopyMemory(video.szNickName, pServerUserItem->GetNickName(), sizeof(video.szNickName));
                video.wChairID = i;
                video.lScore = pServerUserItem->GetUserScore();

                m_pGameVideo->AddVideoData(SUB_S_GAME_START, &video, bFirstRecord);

                if(bFirstRecord == true)
                {
                    bFirstRecord = false;
                }
            }
        }
        m_pITableFrame->SendLookonData(INVALID_CHAIR, SUB_S_GAME_START, &GameStart, sizeof(GameStart));
    }

    return true;
}

//加注事件
bool CTableFrameSink::OnUserAddScore(WORD wChairID, LONGLONG lScore)
{
    //状态效验
    BYTE cbGameStatus = m_pITableFrame->GetGameStatus();
    ASSERT(cbGameStatus == GS_TK_SCORE);
    if(cbGameStatus != GS_TK_SCORE)
    {
        //写日志
		CString strFileName = TEXT("调试日志");

        tagLogUserInfo LogUserInfo;
        ZeroMemory(&LogUserInfo, sizeof(LogUserInfo));
        CopyMemory(LogUserInfo.szDescName, strFileName, sizeof(LogUserInfo.szDescName));
        CopyMemory(LogUserInfo.szLogContent, TEXT("cbGameStatus = FALSE"), sizeof(LogUserInfo.szLogContent));
        //m_pITableFrame->SendGameLogData(LogUserInfo);

        return true;
    }

    //庄家校验
    if(wChairID == m_wBankerUser)
    {
        //写日志
		CString strFileName = TEXT("调试日志");

        tagLogUserInfo LogUserInfo;
        ZeroMemory(&LogUserInfo, sizeof(LogUserInfo));
        CopyMemory(LogUserInfo.szDescName, strFileName, sizeof(LogUserInfo.szDescName));
        CopyMemory(LogUserInfo.szLogContent, TEXT("wChairID == m_wBankerUser = FALSE"), sizeof(LogUserInfo.szLogContent));
        //m_pITableFrame->SendGameLogData(LogUserInfo);

        return false;
    }

    //金币效验
    if(m_cbPlayStatus[wChairID] == TRUE)
    {
		//下注筹码校验
		bool bValidBet = false;
		for (WORD i = 0; i<MAX_CONFIG - 1; i++)
		{
			if (lScore == m_lFreeConfig[i] * m_pITableFrame->GetCellScore())
			{
				bValidBet = true;
				break;
			}
		}

		if (lScore == m_lPlayerBetBtEx[wChairID])
		{
			bValidBet = true;
		}

		//无效下注筹码
		if (!bValidBet)
		{
			//写日志
			CString strFileName = TEXT("调试日志");

			tagLogUserInfo LogUserInfo;
			ZeroMemory(&LogUserInfo, sizeof(LogUserInfo));
			CopyMemory(LogUserInfo.szDescName, strFileName, sizeof(LogUserInfo.szDescName));
			CopyMemory(LogUserInfo.szLogContent, TEXT("INValidBet"), sizeof(LogUserInfo.szLogContent));
			//m_pITableFrame->SendGameLogData(LogUserInfo);

			WriteInfo(TEXT("八人牛调试日志.log"), TEXT("invalid_bet\n"));

			return false;
		}

        ASSERT(lScore > 0);
        if(lScore <= 0)
        {
            //写日志
			CString strFileName = TEXT("调试日志");

            tagLogUserInfo LogUserInfo;
            ZeroMemory(&LogUserInfo, sizeof(LogUserInfo));
            CopyMemory(LogUserInfo.szDescName, strFileName, sizeof(LogUserInfo.szDescName));
            CopyMemory(LogUserInfo.szLogContent, TEXT("lScore < 0"), sizeof(LogUserInfo.szLogContent));
            //m_pITableFrame->SendGameLogData(LogUserInfo);

            return false;
        }

        if(lScore > m_lTurnMaxScore[wChairID])
        {
            lScore = m_lTurnMaxScore[wChairID];
        }
    }
    else //没下注玩家强退
    {
        ASSERT(lScore == 0);
        if(lScore != 0)
        {
            //写日志
			CString strFileName = TEXT("调试日志");

            tagLogUserInfo LogUserInfo;
            ZeroMemory(&LogUserInfo, sizeof(LogUserInfo));
            CopyMemory(LogUserInfo.szDescName, strFileName, sizeof(LogUserInfo.szDescName));
            CopyMemory(LogUserInfo.szLogContent, TEXT("lScore!=0"), sizeof(LogUserInfo.szLogContent));
            //m_pITableFrame->SendGameLogData(LogUserInfo);

            return false;
        }
    }

    if(lScore > 0L)
    {
        //下注金币
        m_lTableScore[wChairID] = lScore;
        m_bBuckleServiceCharge[wChairID] = true;
        //构造数据
        CMD_S_AddScore AddScore;
        AddScore.wAddScoreUser = wChairID;
        AddScore.lAddScoreCount = m_lTableScore[wChairID];

        //发送数据
        for(WORD i = 0; i < m_wPlayerCount; i++)
        {
            if(m_cbPlayStatus[i] == FALSE && m_cbDynamicJoin[i] == FALSE) { continue; }
            m_pITableFrame->SendTableData(i, SUB_S_ADD_SCORE, &AddScore, sizeof(AddScore));
        }
        m_pITableFrame->SendLookonData(INVALID_CHAIR, SUB_S_ADD_SCORE, &AddScore, sizeof(AddScore));

        if(m_pGameVideo)
        {
            m_pGameVideo->AddVideoData(SUB_S_ADD_SCORE, &AddScore);
        }
    }

    if(lScore == m_lPlayerBetBtEx[wChairID])
    {
        m_bLastTurnBetBtEx[wChairID] = true;
    }

    //下注人数
    BYTE bUserCount = 0;
    for(WORD i = 0; i < m_wPlayerCount; i++)
    {
        if(m_lTableScore[i] > 0L && m_cbPlayStatus[i] == TRUE)
        {
            bUserCount++;
        }
        else if(m_cbPlayStatus[i] == FALSE || i == m_wBankerUser)
        {
            bUserCount++;
        }
    }

    //闲家全到
    if(bUserCount == m_wPlayerCount)
    {
        bool bTrusteeUser = false;
        for(WORD i = 0; i < m_wPlayerCount; i++)
        {
            if(m_cbPlayStatus[i] == TRUE && m_pITableFrame->GetTableUserItem(i)->IsTrusteeUser())
            {
                bTrusteeUser = true;
            }
        }

        //非房卡场设置定时器
        if(!IsRoomCardType()/* || bTrusteeUser*/)
        {
            m_pITableFrame->KillGameTimer(IDI_SO_OPERATE);
            m_pITableFrame->SetGameTimer(IDI_SO_OPERATE, TIME_SO_OPERATE, 1, 0);
        }

        //设置离线代打定时器
        for(WORD i = 0; i < m_wPlayerCount; i++)
        {
            if(m_cbPlayStatus[i] == TRUE && m_pITableFrame->GetTableUserItem(i)->IsTrusteeUser())
            {
                m_pITableFrame->SetGameTimer(IDI_OFFLINE_TRUSTEE_0 + i, m_cbTrusteeDelayTime * 1000, 1, 0);
            }
        }

        //设置状态
        m_pITableFrame->SetGameStatus(GS_TK_PLAYING);
        EnableTimeElapse(true);

        //更新房间用户信息
        for(WORD i = 0; i < m_wPlayerCount; i++)
        {
            //获取用户
            IServerUserItem *pIServerUserItem = m_pITableFrame->GetTableUserItem(i);
            if(pIServerUserItem != NULL)
            {
                UpdateRoomUserInfo(pIServerUserItem, USER_SITDOWN);
            }
        }

        //构造数据
        CMD_S_SendCard SendCard;
        ZeroMemory(SendCard.cbCardData, sizeof(SendCard.cbCardData));

        //分析牌数据，下注发牌和发四等五区分处理
        UINT nCirCount = 0;
        while(true)
        {
            if(nCirCount > 50000)
            {
                break;
            }

            nCirCount++;
            bool AnalyseCardValid = true;

            AnalyseCard(m_stConfig);

            for(WORD i = 0; i < m_wPlayerCount; i++)
            {
                if(m_cbPlayStatus[i] == TRUE && m_cbHandCardData[i][0] == 0 && m_cbHandCardData[i][1] == 0 && m_cbHandCardData[i][2] == 0)
                {
                    AnalyseCardValid = false;
                    break;
                }
            }

            //当牌数据无效，可能都是【0】【0】【0】【0】【0】
            if(AnalyseCardValid == false)
            {
                //随机扑克
                BYTE bTempArray[GAME_PLAYER * MAX_CARDCOUNT];
                m_GameLogic.RandCardList(bTempArray, sizeof(bTempArray), (m_gtConfig == GT_HAVEKING_ ? true : false));

                for(WORD i = 0; i < m_wPlayerCount; i++)
                {
                    if(m_cbPlayStatus[i] == TRUE)
                    {
                        //派发扑克
                        CopyMemory(m_cbHandCardData[i], &bTempArray[i * MAX_CARDCOUNT], MAX_CARDCOUNT);
                    }
                }
            }
            else
            {
                break;
            }
        }

        //变量定义
        ROOMUSERDEBUG roomuserdebug;
        ZeroMemory(&roomuserdebug, sizeof(roomuserdebug));
        POSITION posKeyList;

        //调试 (下注发牌和发四等五区分调试)
        if(m_pServerDebug != NULL && AnalyseRoomUserDebug(roomuserdebug, posKeyList))
        {
            //校验数据
            ASSERT(roomuserdebug.roomUserInfo.wChairID != INVALID_CHAIR && roomuserdebug.userDebug.cbDebugCount != 0
                   && roomuserdebug.userDebug.debug_type != CONTINUE_CANCEL);

            if(m_pServerDebug->DebugResult(m_cbHandCardData, roomuserdebug, m_stConfig, m_ctConfig, m_gtConfig))
            {
                //获取元素
                ROOMUSERDEBUG &tmproomuserdebug = g_ListRoomUserDebug.GetAt(posKeyList);

                //校验数据
                ASSERT(roomuserdebug.userDebug.cbDebugCount == tmproomuserdebug.userDebug.cbDebugCount);

                //调试局数
                tmproomuserdebug.userDebug.cbDebugCount--;

                CMD_S_UserDebugComplete UserDebugComplete;
                ZeroMemory(&UserDebugComplete, sizeof(UserDebugComplete));
                UserDebugComplete.dwGameID = roomuserdebug.roomUserInfo.dwGameID;
                CopyMemory(UserDebugComplete.szNickName, roomuserdebug.roomUserInfo.szNickName, sizeof(UserDebugComplete.szNickName));
                UserDebugComplete.debugType = roomuserdebug.userDebug.debug_type;
                UserDebugComplete.cbRemainDebugCount = tmproomuserdebug.userDebug.cbDebugCount;

				//发送数据
				m_pITableFrame->SendRoomData(NULL, SUB_S_USER_DEBUG_COMPLETE, &UserDebugComplete, sizeof(UserDebugComplete));
            }
        }

        //临时扑克,因为分析和调试扑克，重算原始牌型
        BYTE cbTempHandCardData[GAME_PLAYER][MAX_CARDCOUNT];
        ZeroMemory(cbTempHandCardData, sizeof(cbTempHandCardData));
        CopyMemory(cbTempHandCardData, m_cbHandCardData, sizeof(m_cbHandCardData));

		//原始扑克
		CopyMemory(m_cbOriginalCardData, m_cbHandCardData, sizeof(m_cbHandCardData));

        for(WORD i = 0; i < m_wPlayerCount; i++)
        {
            IServerUserItem *pIServerUser = m_pITableFrame->GetTableUserItem(i);
            if(pIServerUser == NULL)
            {
                continue;
            }

            m_bSpecialCard[i] = (m_GameLogic.GetCardType(cbTempHandCardData[i], MAX_CARDCOUNT, m_ctConfig) > CT_CLASSIC_OX_VALUENIUNIU ? true : false);

            //特殊牌型
            if(m_bSpecialCard[i])
            {
                m_cbOriginalCardType[i] = m_GameLogic.GetCardType(cbTempHandCardData[i], MAX_CARDCOUNT, m_ctConfig);
            }
            else
            {
                //获取牛牛牌型
                m_GameLogic.GetOxCard(cbTempHandCardData[i], MAX_CARDCOUNT);

                m_cbOriginalCardType[i] = m_GameLogic.GetCardType(cbTempHandCardData[i], MAX_CARDCOUNT, m_ctConfig);
            }
        }

        CopyMemory(SendCard.cbCardData, m_cbHandCardData, sizeof(SendCard.cbCardData));
        CopyMemory(SendCard.bSpecialCard, m_bSpecialCard, sizeof(SendCard.bSpecialCard));
        CopyMemory(SendCard.cbOriginalCardType, m_cbOriginalCardType, sizeof(SendCard.cbOriginalCardType));

        //发送数据
        for(WORD i = 0; i < m_wPlayerCount; i++)
        {
            if(m_cbPlayStatus[i] == FALSE && m_cbDynamicJoin[i] == FALSE)
            {
                continue;
            }

            m_pITableFrame->SendTableData(i, SUB_S_SEND_CARD, &SendCard, sizeof(SendCard));
        }
        m_pITableFrame->SendLookonData(INVALID_CHAIR, SUB_S_SEND_CARD, &SendCard, sizeof(SendCard));

        if(m_pGameVideo)
        {
            m_pGameVideo->AddVideoData(SUB_S_SEND_CARD, &SendCard);
        }

        CString strUserCard;
        for(WORD i = 0; i < m_wPlayerCount; i++)
        {
            if(m_cbPlayStatus[i] == FALSE)
            {
                continue;
            }

            IServerUserItem *pIServer = m_pITableFrame->GetTableUserItem(i);
            if(!pIServer)
            {
                continue;
            }

            //写日志
            CString strUserCard;
            strUserCard.Format(TEXT("-USERID[%d],牌数据分别为[%d][%d][%d][%d][%d],牌型为[%d]"), pIServer->GetUserID(),
                               m_cbHandCardData[i][0], m_cbHandCardData[i][1], m_cbHandCardData[i][2], m_cbHandCardData[i][3], m_cbHandCardData[i][4], m_cbOriginalCardType[i]);
			CString strFileName = TEXT("调试日志");

            tagLogUserInfo LogUserInfo;
            ZeroMemory(&LogUserInfo, sizeof(LogUserInfo));
            CopyMemory(LogUserInfo.szDescName, strFileName, sizeof(LogUserInfo.szDescName));
            CopyMemory(LogUserInfo.szLogContent, strUserCard, sizeof(LogUserInfo.szLogContent));
            //m_pITableFrame->SendGameLogData(LogUserInfo);
        }
    }

    return true;
}

//摊牌事件
bool CTableFrameSink::OnUserOpenCard(WORD wChairID, BYTE cbCombineCardData[MAX_CARDCOUNT])
{
    //状态效验
    BYTE cbGameStatus = m_pITableFrame->GetGameStatus();
    ASSERT(cbGameStatus == GS_TK_PLAYING);
    if(cbGameStatus != GS_TK_PLAYING) { return true; }
    if(m_bOpenCard[wChairID] != false) { return true; }

    //摊牌标志
    m_bOpenCard[wChairID] = true;

    //八人牛牛客户端不组合牌，直接摊牌
    BYTE cbTempHandCardData[MAX_CARDCOUNT];
    ZeroMemory(cbTempHandCardData, sizeof(cbTempHandCardData));
    CopyMemory(cbTempHandCardData, m_cbHandCardData[wChairID], sizeof(cbTempHandCardData));

    bool bSpecialCard = (m_GameLogic.GetCardType(cbTempHandCardData, MAX_CARDCOUNT, m_ctConfig) > CT_CLASSIC_OX_VALUENIUNIU ? true : false);
    if(!bSpecialCard)
    {
        //获取牛牛牌型
        m_GameLogic.GetOxCard(cbTempHandCardData, MAX_CARDCOUNT);

        CopyMemory(cbCombineCardData, cbTempHandCardData, sizeof(cbTempHandCardData));
    }

    //玩家重新组合牌标志
    //bool bUserCombine = false;
    //for (WORD i=0; i<MAX_CARDCOUNT; i++)
    //{
    //	if (m_cbHandCardData[wChairID][i] != cbCombineCardData[i])
    //	{
    //		bUserCombine = true;
    //		break;
    //	}
    //}
    //
    ////没有重组过牌
    //if (!bUserCombine)
    //{
    //	m_cbCombineCardType[wChairID] = m_cbOriginalCardType[wChairID];
    //}
    //else
    {
        //特殊牌型 赋值初始牌型
        if(m_bSpecialCard[wChairID])
        {
            m_cbCombineCardType[wChairID] = m_cbOriginalCardType[wChairID];
        }
        else
        {
            //前面三张王牌张数
            BYTE cbFirstKingCount = m_GameLogic.GetKingCount(cbCombineCardData, 3);
            BYTE cbSecondKingCount = m_GameLogic.GetKingCount(&cbCombineCardData[3], 2);

            if(cbFirstKingCount == 0)
            {
                //前面三张逻辑值
                BYTE cbFirstNNLogicValue = 0;
                for(WORD i = 0; i < 3; i++)
                {
                    cbFirstNNLogicValue += m_GameLogic.GetNNCardLogicValue(cbCombineCardData[i]);
                }

                if(cbFirstNNLogicValue % 10 != 0)
                {
                    m_cbCombineCardType[wChairID] = CT_CLASSIC_OX_VALUE0;
                }
                else
                {
                    if(cbSecondKingCount != 0)
                    {
                        m_cbCombineCardType[wChairID] = CT_CLASSIC_OX_VALUENIUNIU;
                    }
                    else
                    {
                        BYTE cbSecondNNLogicValue = 0;
                        for(WORD i = 3; i < 5; i++)
                        {
                            cbSecondNNLogicValue += m_GameLogic.GetNNCardLogicValue(cbCombineCardData[i]);
                        }

                        m_cbCombineCardType[wChairID] = ((cbSecondNNLogicValue % 10 == 0) ? CT_CLASSIC_OX_VALUENIUNIU : (cbSecondNNLogicValue % 10));
                    }
                }
            }
            else
            {
                if(cbSecondKingCount != 0)
                {
                    m_cbCombineCardType[wChairID] = CT_CLASSIC_OX_VALUENIUNIU;
                }
                else
                {
                    BYTE cbSecondNNLogicValue = 0;
                    for(WORD i = 3; i < 5; i++)
                    {
                        cbSecondNNLogicValue += m_GameLogic.GetNNCardLogicValue(cbCombineCardData[i]);
                    }

                    m_cbCombineCardType[wChairID] = ((cbSecondNNLogicValue % 10 == 0) ? CT_CLASSIC_OX_VALUENIUNIU : (cbSecondNNLogicValue % 10));
                }
            }

            //重置组合过的扑克
            CopyMemory(m_cbHandCardData[wChairID], cbCombineCardData, sizeof(m_cbHandCardData[wChairID]));
        }
    }

    //摊牌人数
    BYTE bUserCount = 0;
    for(WORD i = 0; i < m_wPlayerCount; i++)
    {
        if(m_bOpenCard[i] == true && m_cbPlayStatus[i] == TRUE) { bUserCount++; }
        else if(m_cbPlayStatus[i] == FALSE) { bUserCount++; }
    }

    //构造变量
    CMD_S_Open_Card OpenCard;
    ZeroMemory(&OpenCard, sizeof(OpenCard));

    //设置变量
    OpenCard.bOpenCard = true;
    OpenCard.wOpenChairID = wChairID;

    //发送数据
    for(WORD i = 0; i < m_wPlayerCount; i++)
    {
        if(m_cbPlayStatus[i] == FALSE && m_cbDynamicJoin[i] == FALSE) { continue; }
        m_pITableFrame->SendTableData(i, SUB_S_OPEN_CARD, &OpenCard, sizeof(OpenCard));
    }
    m_pITableFrame->SendLookonData(INVALID_CHAIR, SUB_S_OPEN_CARD, &OpenCard, sizeof(OpenCard));

    if(m_pGameVideo)
    {
        m_pGameVideo->AddVideoData(SUB_S_OPEN_CARD, &OpenCard);
    }

    //结束游戏
    if(bUserCount == m_wPlayerCount)
    {
        return OnEventGameConclude(INVALID_CHAIR, NULL, GER_NORMAL);
    }

    return true;
}

//扑克分析
void CTableFrameSink::AnalyseCard(SENDCARDTYPE_CONFIG stConfig)
{
    //AI数
    bool bIsAiBanker = false;
    WORD wAiCount = 0;
    WORD wPlayerCount = 0;
    for(WORD i = 0; i < m_wPlayerCount; i++)
    {
        //获取用户
        IServerUserItem *pIServerUserItem = m_pITableFrame->GetTableUserItem(i);
        if(pIServerUserItem != NULL && m_cbPlayStatus[i] == TRUE)
        {
            if(pIServerUserItem->IsAndroidUser())
            {
                wAiCount++;
                if(i == m_wBankerUser)
                {
                    bIsAiBanker = true;
                }
            }

            wPlayerCount++;
        }
    }

    //全部机器
    if(wPlayerCount == wAiCount || wAiCount == 0)
    {
        return;
    }

    //扑克变量
    BYTE cbUserCardData[GAME_PLAYER][MAX_CARDCOUNT];
    CopyMemory(cbUserCardData, m_cbHandCardData, sizeof(m_cbHandCardData));

    //获取最大牌型
    for(WORD i = 0; i < m_wPlayerCount; i++)
    {
        if(m_cbPlayStatus[i] == TRUE)
        {
            m_GameLogic.GetOxCard(cbUserCardData[i], MAX_CARDCOUNT);
        }
    }

    //变量定义
    LONGLONG lAndroidScore = 0;

    //倍数变量
    BYTE cbCardTimes[GAME_PLAYER];
    ZeroMemory(cbCardTimes, sizeof(cbCardTimes));

    //查找倍数
    for(WORD i = 0; i < m_wPlayerCount; i++)
    {
        if(m_cbPlayStatus[i] == TRUE)
        {
            cbCardTimes[i] = m_GameLogic.GetTimes(cbUserCardData[i], MAX_CARDCOUNT, m_ctConfig);
        }
    }

    //倍数抢庄 结算需要乘以cbMaxCallBankerTimes
    BYTE cbMaxCallBankerTimes = 1;
    if(m_bgtConfig == BGT_ROB_)
    {
        for(WORD i = 0; i < m_wPlayerCount; i++)
        {
            if(m_cbPlayStatus[i] == TRUE && m_cbCallBankerStatus[i] == TRUE && m_cbCallBankerTimes[i] > cbMaxCallBankerTimes)
            {
                cbMaxCallBankerTimes = m_cbCallBankerTimes[i];
            }
        }
    }

    //机器庄家
    if(bIsAiBanker)
    {
        //对比扑克
        for(WORD i = 0; i < m_wPlayerCount; i++)
        {
            //用户过滤
            if((i == m_wBankerUser) || (m_cbPlayStatus[i] == FALSE)) { continue; }

            //获取用户
            IServerUserItem *pIServerUserItem = m_pITableFrame->GetTableUserItem(i);

            //机器过滤
            if((pIServerUserItem != NULL) && (pIServerUserItem->IsAndroidUser())) { continue; }

            //对比扑克
            if(m_GameLogic.CompareCard(cbUserCardData[i], cbUserCardData[m_wBankerUser], MAX_CARDCOUNT, m_ctConfig) == true)
            {
                lAndroidScore -= cbCardTimes[i] * m_lTableScore[i] * cbMaxCallBankerTimes;
            }
            else
            {
                lAndroidScore += cbCardTimes[m_wBankerUser] * m_lTableScore[i] * cbMaxCallBankerTimes;
            }
        }
    }
    else//用户庄家
    {
        //对比扑克
        for(WORD i = 0; i < m_wPlayerCount; i++)
        {
            //获取用户
            IServerUserItem *pIServerUserItem = m_pITableFrame->GetTableUserItem(i);

            //用户过滤
            if((i == m_wBankerUser) || (pIServerUserItem == NULL) || !(pIServerUserItem->IsAndroidUser())) { continue; }

            //对比扑克
            if(m_GameLogic.CompareCard(cbUserCardData[i], cbUserCardData[m_wBankerUser], MAX_CARDCOUNT, m_ctConfig) == true)
            {
                lAndroidScore += cbCardTimes[i] * m_lTableScore[i] * cbMaxCallBankerTimes;
            }
            else
            {
                lAndroidScore -= cbCardTimes[m_wBankerUser] * m_lTableScore[i] * cbMaxCallBankerTimes;
            }
        }
    }

    LONGLONG lGameEndStorage = g_lRoomStorageCurrent + lAndroidScore;

	BYTE cbRandVal = rand() % 100;

    //下注发牌
    if(stConfig == ST_BETFIRST_)
    {
        //变量定义
        WORD wMaxUser = INVALID_CHAIR;
        WORD wMinAndroid = INVALID_CHAIR;
        WORD wMaxAndroid = INVALID_CHAIR;

        //查找特殊玩家
        for(WORD i = 0; i < m_wPlayerCount; i++)
        {
            //获取用户
            IServerUserItem *pIServerUserItem = m_pITableFrame->GetTableUserItem(i);
            if(pIServerUserItem == NULL) { continue; }

            //真人玩家
            if(pIServerUserItem->IsAndroidUser() == false)
            {
                //初始设置
                if(wMaxUser == INVALID_CHAIR) { wMaxUser = i; }

                //获取较大者
                if(m_GameLogic.CompareCard(cbUserCardData[i], cbUserCardData[wMaxUser], MAX_CARDCOUNT, m_ctConfig) == true)
                {
                    wMaxUser = i;
                }
            }

            //机器玩家
            if(pIServerUserItem->IsAndroidUser() == true)
            {
                //初始设置
                if(wMinAndroid == INVALID_CHAIR) { wMinAndroid = i; }
                if(wMaxAndroid == INVALID_CHAIR) { wMaxAndroid = i; }

                //获取较小者
                if(m_GameLogic.CompareCard(cbUserCardData[i], cbUserCardData[wMinAndroid], MAX_CARDCOUNT, m_ctConfig) == false)
                {
                    wMinAndroid = i;
                }

                //获取较大者
                if(m_GameLogic.CompareCard(cbUserCardData[i], cbUserCardData[wMaxAndroid], MAX_CARDCOUNT, m_ctConfig) == true)
                {
                    wMaxAndroid = i;
                }
            }
        }

		if (g_lRoomStorageCurrent + lAndroidScore<0 || (lGameEndStorage < (g_lRoomStorageCurrent * (double)(1 - (double)10 / (double)100))))
		{
			//最大玩家（包括真人和AI）
			WORD wWinUser = wMaxUser;
			//最小玩家（包括真人和AI）
			WORD wLostUser = wMaxUser;

			//查找最大玩家
			for (WORD i = 0; i<m_wPlayerCount; i++)
			{

				//用户过滤
				if (m_cbPlayStatus[i] == FALSE) continue;

				//获取较大者
				if (m_GameLogic.CompareCard(cbUserCardData[i], cbUserCardData[wWinUser], MAX_CARDCOUNT, m_ctConfig) == true)
				{
					wWinUser = i;
				}
			}

			//查找最小玩家
			for (WORD i = 0; i<m_wPlayerCount; i++)
			{

				//用户过滤
				if (m_cbPlayStatus[i] == FALSE) continue;

				//获取较大者
				if (m_GameLogic.CompareCard(cbUserCardData[i], cbUserCardData[wLostUser], MAX_CARDCOUNT, m_ctConfig) == false)
				{
					wLostUser = i;
				}
			}

			//AI当庄
			if (bIsAiBanker)
			{
				//交换数据
				BYTE cbTempData[MAX_CARDCOUNT];
				CopyMemory(cbTempData, m_cbHandCardData[m_wBankerUser], MAX_CARDCOUNT);
				CopyMemory(m_cbHandCardData[m_wBankerUser], m_cbHandCardData[wWinUser], MAX_CARDCOUNT);
				CopyMemory(m_cbHandCardData[wWinUser], cbTempData, MAX_CARDCOUNT);
			}
			else
			{
				//最小的牌给真人玩家
				BYTE cbTempData[MAX_CARDCOUNT];
				CopyMemory(cbTempData, m_cbHandCardData[m_wBankerUser], MAX_CARDCOUNT);
				CopyMemory(m_cbHandCardData[m_wBankerUser], m_cbHandCardData[wLostUser], MAX_CARDCOUNT);
				CopyMemory(m_cbHandCardData[wLostUser], cbTempData, MAX_CARDCOUNT);
			}
		}
		else
		{
			//满足上限2
			if (g_lRoomStorageCurrent>0 && g_lRoomStorageCurrent > g_lStorageMax2Room && g_lRoomStorageCurrent + lAndroidScore > 0 && cbRandVal < g_lStorageMul2Room)
			{
				if (m_GameLogic.CompareCard(cbUserCardData[wMaxAndroid], cbUserCardData[wMaxUser], MAX_CARDCOUNT, m_ctConfig) == true)
				{
					//交换数据
					BYTE cbTempData[MAX_CARDCOUNT];
					CopyMemory(cbTempData, m_cbHandCardData[wMaxUser], MAX_CARDCOUNT);
					CopyMemory(m_cbHandCardData[wMaxUser], m_cbHandCardData[wMaxAndroid], MAX_CARDCOUNT);
					CopyMemory(m_cbHandCardData[wMaxAndroid], cbTempData, MAX_CARDCOUNT);

					//库存不够换回来
					if (JudgeStock() == false)
					{
						CopyMemory(cbTempData, m_cbHandCardData[wMaxUser], MAX_CARDCOUNT);
						CopyMemory(m_cbHandCardData[wMaxUser], m_cbHandCardData[wMaxAndroid], MAX_CARDCOUNT);
						CopyMemory(m_cbHandCardData[wMaxAndroid], cbTempData, MAX_CARDCOUNT);
					}
				}
				else
				{
					if (JudgeStock() == false)
					{
						BYTE cbTempData[MAX_CARDCOUNT];
						ZeroMemory(cbTempData, sizeof(cbTempData));
						CopyMemory(cbTempData, m_cbHandCardData[wMaxUser], MAX_CARDCOUNT);
						CopyMemory(m_cbHandCardData[wMaxUser], m_cbHandCardData[wMaxAndroid], MAX_CARDCOUNT);
						CopyMemory(m_cbHandCardData[wMaxAndroid], cbTempData, MAX_CARDCOUNT);
					}
				}
			}
			//满足上限1
			else if (g_lRoomStorageCurrent>0 && g_lRoomStorageCurrent > g_lStorageMax1Room && g_lRoomStorageCurrent + lAndroidScore > 0 && cbRandVal < g_lStorageMul1Room)
			{
				if (m_GameLogic.CompareCard(cbUserCardData[wMaxAndroid], cbUserCardData[wMaxUser], MAX_CARDCOUNT, m_ctConfig) == true)
				{
					//交换数据
					BYTE cbTempData[MAX_CARDCOUNT];
					CopyMemory(cbTempData, m_cbHandCardData[wMaxUser], MAX_CARDCOUNT);
					CopyMemory(m_cbHandCardData[wMaxUser], m_cbHandCardData[wMaxAndroid], MAX_CARDCOUNT);
					CopyMemory(m_cbHandCardData[wMaxAndroid], cbTempData, MAX_CARDCOUNT);

					//库存不够换回来
					if (JudgeStock() == false)
					{
						CopyMemory(cbTempData, m_cbHandCardData[wMaxUser], MAX_CARDCOUNT);
						CopyMemory(m_cbHandCardData[wMaxUser], m_cbHandCardData[wMaxAndroid], MAX_CARDCOUNT);
						CopyMemory(m_cbHandCardData[wMaxAndroid], cbTempData, MAX_CARDCOUNT);
					}
				}
				else
				{
					if (JudgeStock() == false)
					{
						BYTE cbTempData[MAX_CARDCOUNT];
						ZeroMemory(cbTempData, sizeof(cbTempData));
						CopyMemory(cbTempData, m_cbHandCardData[wMaxUser], MAX_CARDCOUNT);
						CopyMemory(m_cbHandCardData[wMaxUser], m_cbHandCardData[wMaxAndroid], MAX_CARDCOUNT);
						CopyMemory(m_cbHandCardData[wMaxAndroid], cbTempData, MAX_CARDCOUNT);
					}
				}
			}
			//不满足上限1.2,玩家赢分概率百分之50
			else if (cbRandVal < 50)
			{
				if (m_GameLogic.CompareCard(cbUserCardData[wMaxAndroid], cbUserCardData[wMaxUser], MAX_CARDCOUNT, m_ctConfig) == true)
				{
					//交换数据
					BYTE cbTempData[MAX_CARDCOUNT];
					CopyMemory(cbTempData, m_cbHandCardData[wMaxUser], MAX_CARDCOUNT);
					CopyMemory(m_cbHandCardData[wMaxUser], m_cbHandCardData[wMaxAndroid], MAX_CARDCOUNT);
					CopyMemory(m_cbHandCardData[wMaxAndroid], cbTempData, MAX_CARDCOUNT);

					//库存不够换回来
					if (JudgeStock() == false)
					{
						CopyMemory(cbTempData, m_cbHandCardData[wMaxUser], MAX_CARDCOUNT);
						CopyMemory(m_cbHandCardData[wMaxUser], m_cbHandCardData[wMaxAndroid], MAX_CARDCOUNT);
						CopyMemory(m_cbHandCardData[wMaxAndroid], cbTempData, MAX_CARDCOUNT);
					}
				}
				else
				{
					if (JudgeStock() == false)
					{
						BYTE cbTempData[MAX_CARDCOUNT];
						ZeroMemory(cbTempData, sizeof(cbTempData));
						CopyMemory(cbTempData, m_cbHandCardData[wMaxUser], MAX_CARDCOUNT);
						CopyMemory(m_cbHandCardData[wMaxUser], m_cbHandCardData[wMaxAndroid], MAX_CARDCOUNT);
						CopyMemory(m_cbHandCardData[wMaxAndroid], cbTempData, MAX_CARDCOUNT);
					}
				}
			}
			else
			{
				//最大玩家（包括真人和AI）
				WORD wWinUser = wMaxUser;
				//最小玩家（包括真人和AI）
				WORD wLostUser = wMaxUser;

				//查找最大玩家
				for (WORD i = 0; i<m_wPlayerCount; i++)
				{

					//用户过滤
					if (m_cbPlayStatus[i] == FALSE) continue;

					//获取较大者
					if (m_GameLogic.CompareCard(cbUserCardData[i], cbUserCardData[wWinUser], MAX_CARDCOUNT, m_ctConfig) == true)
					{
						wWinUser = i;
					}
				}

				//查找最小玩家
				for (WORD i = 0; i<m_wPlayerCount; i++)
				{

					//用户过滤
					if (m_cbPlayStatus[i] == FALSE) continue;

					//获取较大者
					if (m_GameLogic.CompareCard(cbUserCardData[i], cbUserCardData[wLostUser], MAX_CARDCOUNT, m_ctConfig) == false)
					{
						wLostUser = i;
					}
				}

				//AI当庄
				if (bIsAiBanker)
				{
					//交换数据
					BYTE cbTempData[MAX_CARDCOUNT];
					CopyMemory(cbTempData, m_cbHandCardData[m_wBankerUser], MAX_CARDCOUNT);
					CopyMemory(m_cbHandCardData[m_wBankerUser], m_cbHandCardData[wWinUser], MAX_CARDCOUNT);
					CopyMemory(m_cbHandCardData[wWinUser], cbTempData, MAX_CARDCOUNT);
				}
				else
				{
					//最小的牌给真人玩家
					BYTE cbTempData[MAX_CARDCOUNT];
					CopyMemory(cbTempData, m_cbHandCardData[m_wBankerUser], MAX_CARDCOUNT);
					CopyMemory(m_cbHandCardData[m_wBankerUser], m_cbHandCardData[wLostUser], MAX_CARDCOUNT);
					CopyMemory(m_cbHandCardData[wLostUser], cbTempData, MAX_CARDCOUNT);
				}
			}
		}
    }
    else if(stConfig == ST_SENDFOUR_)
    {
        //扑克链表
        CList<BYTE, BYTE &> cardlist;
        cardlist.RemoveAll();

        //含大小王
        if(m_gtConfig == GT_HAVEKING_)
        {
            for(WORD i = 0; i < 54; i++)
            {
                cardlist.AddTail(m_GameLogic.m_cbCardListDataHaveKing[i]);
            }
        }
        else if(m_gtConfig == GT_NOKING_)
        {
            for(WORD i = 0; i < 52; i++)
            {
                cardlist.AddTail(m_GameLogic.m_cbCardListDataNoKing[i]);
            }
        }

        //删除扑克 （删除前面4张，构造后面一张）
        for(WORD i = 0; i < GAME_PLAYER; i++)
        {
            for(WORD j = 0; j < MAX_CARDCOUNT - 1; j++)
            {
                if(m_cbHandCardData[i][j] != 0)
                {
                    POSITION ptListHead = cardlist.GetHeadPosition();
                    POSITION ptTemp;
                    BYTE cbCardData = INVALID_BYTE;

                    //遍历链表
                    while(ptListHead)
                    {
                        ptTemp = ptListHead;
                        if(cardlist.GetNext(ptListHead) == m_cbHandCardData[i][j])
                        {
                            cardlist.RemoveAt(ptTemp);
                            break;
                        }
                    }
                }
            }
        }

		//库存判断
		if (g_lRoomStorageCurrent + lAndroidScore<0 || (lGameEndStorage < (g_lRoomStorageCurrent * (double)(1 - (double)10 / (double)100))))
		{
			//这局机器人赢

			//机器人坐庄, 剩下真人中，抽取可以已知最大的牌型A ， 机器人庄家构造比A大
			if (m_wBankerUser != INVALID_CHAIR && m_pITableFrame->GetTableUserItem(m_wBankerUser)->IsAndroidUser())
			{
				BYTE cbMaxCardTypeSendFour = m_GameLogic.GetMaxCardTypeSendFourRealPlayer(cardlist, m_cbHandCardData, m_ctConfig, m_pITableFrame, m_cbPlayStatus, m_cbDynamicJoin, m_wPlayerCount);
				cbMaxCardTypeSendFour = (cbMaxCardTypeSendFour >= CT_CLASSIC_OX_VALUE9 ? CT_CLASSIC_OX_VALUE9 : cbMaxCardTypeSendFour);

				BYTE cbKeyCardData = m_GameLogic.ConstructCardType(cardlist, m_cbHandCardData[m_wBankerUser], cbMaxCardTypeSendFour + 1, m_gtConfig);
				if (cbKeyCardData != INVALID_BYTE)
				{
					m_cbHandCardData[m_wBankerUser][4] = cbKeyCardData;
				}
			}
			//真人坐庄 ,为了保证机器人赢，所有机器人构造比真人庄家大的牌 (机器人5张牌都可以换 )
			else if (m_wBankerUser != INVALID_CHAIR && !m_pITableFrame->GetTableUserItem(m_wBankerUser)->IsAndroidUser())
			{
				BYTE cbMaxCardTypeSingle = m_GameLogic.GetMaxCardTypeSingle(cardlist, m_cbHandCardData[m_wBankerUser], m_ctConfig);
				cbMaxCardTypeSingle = (cbMaxCardTypeSingle >= CT_CLASSIC_OX_VALUE9 ? CT_CLASSIC_OX_VALUE9 : cbMaxCardTypeSingle);

				for (WORD i = 0; i<m_wPlayerCount; i++)
				{
					//获取用户
					IServerUserItem *pIServerUserItem = m_pITableFrame->GetTableUserItem(i);
					if (pIServerUserItem != NULL && m_cbPlayStatus[i] == TRUE && m_cbDynamicJoin[i] == FALSE)
					{
						//AI
						if (pIServerUserItem->IsAndroidUser() == true)
						{
							BYTE cbKeyCardData = m_GameLogic.ConstructCardType(cardlist, m_cbHandCardData[i], cbMaxCardTypeSingle + 1, m_gtConfig);
							if (cbKeyCardData != INVALID_BYTE)
							{
								m_cbHandCardData[i][4] = cbKeyCardData;
							}
						}
					}
				}
			}

			//牛五为基准点，AI从牛六往上开始构造， 普通玩家从牛五往下开始构造
			//for (WORD i = 0; i<m_wPlayerCount; i++)
			//{
			//	//获取用户
			//	IServerUserItem *pIServerUserItem = m_pITableFrame->GetTableUserItem(i);
			//	if (pIServerUserItem != NULL && m_cbPlayStatus[i] == TRUE && m_cbDynamicJoin[i] == FALSE)
			//	{
			//		//AI
			//		if (pIServerUserItem->IsAndroidUser() == true)
			//		{
			//			//AI从牛六往上开始构造
			//			for (int wCardTypeIndex = CT_CLASSIC_OX_VALUE6; wCardTypeIndex <= CT_CLASSIC_OX_VALUENIUNIU; wCardTypeIndex++)
			//			{
			//				BYTE cbKeyCardData = m_GameLogic.ConstructCardType(cardlist, m_cbHandCardData[i], wCardTypeIndex, m_gtConfig);
			//				if (cbKeyCardData == INVALID_BYTE)
			//				{
			//					continue;
			//				}
			//				else
			//				{
			//					m_cbHandCardData[i][4] = cbKeyCardData;
			//					break;
			//				}
			//			}
			//		}
			//		else if (pIServerUserItem->IsAndroidUser() == false)
			//		{
			//			//普通玩家从牛五往下开始构造
			//			for (int wCardTypeIndex = CT_CLASSIC_OX_VALUE5; wCardTypeIndex >= CT_CLASSIC_OX_VALUE0; wCardTypeIndex--)
			//			{
			//				BYTE cbKeyCardData = m_GameLogic.ConstructCardType(cardlist, m_cbHandCardData[i], wCardTypeIndex, m_gtConfig);
			//				if (cbKeyCardData == INVALID_BYTE)
			//				{
			//					continue;
			//				}
			//				else
			//				{
			//					m_cbHandCardData[i][4] = cbKeyCardData;
			//					break;
			//				}
			//			}
			//		}
			//	}
			//}
		}
		else
		{
			if (g_lRoomStorageCurrent>0 /*&& lAndroidScore>0*/ && g_lRoomStorageCurrent > g_lStorageMax2Room && g_lRoomStorageCurrent + lAndroidScore > 0 && cbRandVal < g_lStorageMul2Room)
			{
				//这局真人赢

				//机器人坐庄, 为了保证真人赢，所有真人构造比机器人庄家大的牌 
				if (m_wBankerUser != INVALID_CHAIR && m_pITableFrame->GetTableUserItem(m_wBankerUser)->IsAndroidUser())
				{
					BYTE cbMaxCardTypeSingle = m_GameLogic.GetMaxCardTypeSingle(cardlist, m_cbHandCardData[m_wBankerUser], m_ctConfig);
					cbMaxCardTypeSingle = (cbMaxCardTypeSingle >= CT_CLASSIC_OX_VALUE9 ? CT_CLASSIC_OX_VALUE9 : cbMaxCardTypeSingle);

					for (WORD i = 0; i<m_wPlayerCount; i++)
					{
						//获取用户
						IServerUserItem *pIServerUserItem = m_pITableFrame->GetTableUserItem(i);
						if (pIServerUserItem != NULL && m_cbPlayStatus[i] == TRUE && m_cbDynamicJoin[i] == FALSE)
						{
							//真人
							if (pIServerUserItem->IsAndroidUser() == false)
							{
								BYTE cbKeyCardData = m_GameLogic.ConstructCardType(cardlist, m_cbHandCardData[i], cbMaxCardTypeSingle + 1, m_gtConfig);
								if (cbKeyCardData != INVALID_BYTE)
								{
									m_cbHandCardData[i][4] = cbKeyCardData;
								}
							}
						}
					}					
				}
				//真人坐庄 ,剩下机器人中，抽取可以已知最大的牌型A ， 真人庄家构造比A大
				else if (m_wBankerUser != INVALID_CHAIR && !m_pITableFrame->GetTableUserItem(m_wBankerUser)->IsAndroidUser())
				{
					BYTE cbMaxCardTypeSendFour = m_GameLogic.GetMaxCardTypeSendFourRealPlayer(cardlist, m_cbHandCardData, m_ctConfig, m_pITableFrame, m_cbPlayStatus, m_cbDynamicJoin, m_wPlayerCount);
					cbMaxCardTypeSendFour = (cbMaxCardTypeSendFour >= CT_CLASSIC_OX_VALUE9 ? CT_CLASSIC_OX_VALUE9 : cbMaxCardTypeSendFour);

					BYTE cbKeyCardData = m_GameLogic.ConstructCardType(cardlist, m_cbHandCardData[m_wBankerUser], cbMaxCardTypeSendFour + 1, m_gtConfig);
					if (cbKeyCardData != INVALID_BYTE)
					{
						m_cbHandCardData[m_wBankerUser][4] = cbKeyCardData;
					}
				}

				//牛五为基准点，AI从牛五往下开始构造 普通玩家从牛六往上开始构造
				//for (WORD i = 0; i<m_wPlayerCount; i++)
				//{
				//	//获取用户
				//	IServerUserItem *pIServerUserItem = m_pITableFrame->GetTableUserItem(i);
				//	if (pIServerUserItem != NULL && m_cbPlayStatus[i] == TRUE && m_cbDynamicJoin[i] == FALSE)
				//	{
				//		//AI
				//		if (pIServerUserItem->IsAndroidUser() == true)
				//		{
				//			//AI从牛五往下开始构造
				//			for (int wCardTypeIndex = CT_CLASSIC_OX_VALUE5; wCardTypeIndex >= CT_CLASSIC_OX_VALUE0; wCardTypeIndex--)
				//			{
				//				BYTE cbKeyCardData = m_GameLogic.ConstructCardType(cardlist, m_cbHandCardData[i], wCardTypeIndex, m_gtConfig);
				//				if (cbKeyCardData == INVALID_BYTE)
				//				{
				//					continue;
				//				}
				//				else
				//				{
				//					m_cbHandCardData[i][4] = cbKeyCardData;
				//					break;
				//				}
				//			}
				//		}
				//		else if (pIServerUserItem->IsAndroidUser() == false)
				//		{
				//			//普通玩家从牛六往上开始构造
				//			for (int wCardTypeIndex = CT_CLASSIC_OX_VALUE6; wCardTypeIndex <= CT_CLASSIC_OX_VALUENIUNIU; wCardTypeIndex++)
				//			{
				//				BYTE cbKeyCardData = m_GameLogic.ConstructCardType(cardlist, m_cbHandCardData[i], wCardTypeIndex, m_gtConfig);
				//				if (cbKeyCardData == INVALID_BYTE)
				//				{
				//					continue;
				//				}
				//				else
				//				{
				//					m_cbHandCardData[i][4] = cbKeyCardData;
				//					break;
				//				}
				//			}
				//		}
				//	}
				//}
			}
			else if (g_lRoomStorageCurrent>0 /*&& lAndroidScore>0*/ && g_lRoomStorageCurrent > g_lStorageMax1Room && g_lRoomStorageCurrent + lAndroidScore > 0 && cbRandVal < g_lStorageMul1Room)
			{
				//这局真人赢

				//机器人坐庄, 为了保证真人赢，所有真人构造比机器人庄家大的牌 
				if (m_wBankerUser != INVALID_CHAIR && m_pITableFrame->GetTableUserItem(m_wBankerUser)->IsAndroidUser())
				{
					BYTE cbMaxCardTypeSingle = m_GameLogic.GetMaxCardTypeSingle(cardlist, m_cbHandCardData[m_wBankerUser], m_ctConfig);
					cbMaxCardTypeSingle = (cbMaxCardTypeSingle >= CT_CLASSIC_OX_VALUE9 ? CT_CLASSIC_OX_VALUE9 : cbMaxCardTypeSingle);

					for (WORD i = 0; i<m_wPlayerCount; i++)
					{
						//获取用户
						IServerUserItem *pIServerUserItem = m_pITableFrame->GetTableUserItem(i);
						if (pIServerUserItem != NULL && m_cbPlayStatus[i] == TRUE && m_cbDynamicJoin[i] == FALSE)
						{
							//真人
							if (pIServerUserItem->IsAndroidUser() == false)
							{
								BYTE cbKeyCardData = m_GameLogic.ConstructCardType(cardlist, m_cbHandCardData[i], cbMaxCardTypeSingle + 1, m_gtConfig);
								if (cbKeyCardData != INVALID_BYTE)
								{
									m_cbHandCardData[i][4] = cbKeyCardData;
								}
							}
						}
					}
				}
				//真人坐庄 ,剩下机器人中，抽取可以已知最大的牌型A ， 真人庄家构造比A大
				else if (m_wBankerUser != INVALID_CHAIR && !m_pITableFrame->GetTableUserItem(m_wBankerUser)->IsAndroidUser())
				{
					BYTE cbMaxCardTypeSendFour = m_GameLogic.GetMaxCardTypeSendFourRealPlayer(cardlist, m_cbHandCardData, m_ctConfig, m_pITableFrame, m_cbPlayStatus, m_cbDynamicJoin, m_wPlayerCount);
					cbMaxCardTypeSendFour = (cbMaxCardTypeSendFour >= CT_CLASSIC_OX_VALUE9 ? CT_CLASSIC_OX_VALUE9 : cbMaxCardTypeSendFour);

					BYTE cbKeyCardData = m_GameLogic.ConstructCardType(cardlist, m_cbHandCardData[m_wBankerUser], cbMaxCardTypeSendFour + 1, m_gtConfig);
					if (cbKeyCardData != INVALID_BYTE)
					{
						m_cbHandCardData[m_wBankerUser][4] = cbKeyCardData;
					}
				}

				//牛五为基准点，AI从牛五往下开始构造 普通玩家从牛六往上开始构造
				//for (WORD i = 0; i<m_wPlayerCount; i++)
				//{
				//	//获取用户
				//	IServerUserItem *pIServerUserItem = m_pITableFrame->GetTableUserItem(i);
				//	if (pIServerUserItem != NULL && m_cbPlayStatus[i] == TRUE && m_cbDynamicJoin[i] == FALSE)
				//	{
				//		//AI
				//		if (pIServerUserItem->IsAndroidUser() == true)
				//		{
				//			//AI从牛五往下开始构造
				//			for (int wCardTypeIndex = CT_CLASSIC_OX_VALUE5; wCardTypeIndex >= CT_CLASSIC_OX_VALUE0; wCardTypeIndex--)
				//			{
				//				BYTE cbKeyCardData = m_GameLogic.ConstructCardType(cardlist, m_cbHandCardData[i], wCardTypeIndex, m_gtConfig);
				//				if (cbKeyCardData == INVALID_BYTE)
				//				{
				//					continue;
				//				}
				//				else
				//				{
				//					m_cbHandCardData[i][4] = cbKeyCardData;
				//					break;
				//				}
				//			}
				//		}
				//		else if (pIServerUserItem->IsAndroidUser() == false)
				//		{
				//			//普通玩家从牛六往上开始构造
				//			for (int wCardTypeIndex = CT_CLASSIC_OX_VALUE6; wCardTypeIndex <= CT_CLASSIC_OX_VALUENIUNIU; wCardTypeIndex++)
				//			{
				//				BYTE cbKeyCardData = m_GameLogic.ConstructCardType(cardlist, m_cbHandCardData[i], wCardTypeIndex, m_gtConfig);
				//				if (cbKeyCardData == INVALID_BYTE)
				//				{
				//					continue;
				//				}
				//				else
				//				{
				//					m_cbHandCardData[i][4] = cbKeyCardData;
				//					break;
				//				}
				//			}
				//		}
				//	}
				//}
			}
			//不满足上限1.2,玩家赢分概率百分之50
			else if (cbRandVal < 50)
			{
				//这局真人赢

				//机器人坐庄, 为了保证真人赢，所有真人构造比机器人庄家大的牌 
				if (m_wBankerUser != INVALID_CHAIR && m_pITableFrame->GetTableUserItem(m_wBankerUser)->IsAndroidUser())
				{
					BYTE cbMaxCardTypeSingle = m_GameLogic.GetMaxCardTypeSingle(cardlist, m_cbHandCardData[m_wBankerUser], m_ctConfig);
					cbMaxCardTypeSingle = (cbMaxCardTypeSingle >= CT_CLASSIC_OX_VALUE9 ? CT_CLASSIC_OX_VALUE9 : cbMaxCardTypeSingle);

					for (WORD i = 0; i<m_wPlayerCount; i++)
					{
						//获取用户
						IServerUserItem *pIServerUserItem = m_pITableFrame->GetTableUserItem(i);
						if (pIServerUserItem != NULL && m_cbPlayStatus[i] == TRUE && m_cbDynamicJoin[i] == FALSE)
						{
							//真人
							if (pIServerUserItem->IsAndroidUser() == false)
							{
								BYTE cbKeyCardData = m_GameLogic.ConstructCardType(cardlist, m_cbHandCardData[i], cbMaxCardTypeSingle + 1, m_gtConfig);
								if (cbKeyCardData != INVALID_BYTE)
								{
									m_cbHandCardData[i][4] = cbKeyCardData;
								}
							}
						}
					}
				}
				//真人坐庄 ,剩下机器人中，抽取可以已知最大的牌型A ， 真人庄家构造比A大
				else if (m_wBankerUser != INVALID_CHAIR && !m_pITableFrame->GetTableUserItem(m_wBankerUser)->IsAndroidUser())
				{
					BYTE cbMaxCardTypeSendFour = m_GameLogic.GetMaxCardTypeSendFourRealPlayer(cardlist, m_cbHandCardData, m_ctConfig, m_pITableFrame, m_cbPlayStatus, m_cbDynamicJoin, m_wPlayerCount);
					cbMaxCardTypeSendFour = (cbMaxCardTypeSendFour >= CT_CLASSIC_OX_VALUE9 ? CT_CLASSIC_OX_VALUE9 : cbMaxCardTypeSendFour);

					BYTE cbKeyCardData = m_GameLogic.ConstructCardType(cardlist, m_cbHandCardData[m_wBankerUser], cbMaxCardTypeSendFour + 1, m_gtConfig);
					if (cbKeyCardData != INVALID_BYTE)
					{
						m_cbHandCardData[m_wBankerUser][4] = cbKeyCardData;
					}
				}

				//牛五为基准点，AI从牛五往下开始构造 普通玩家从牛六往上开始构造
				//for (WORD i = 0; i<m_wPlayerCount; i++)
				//{
				//	//获取用户
				//	IServerUserItem *pIServerUserItem = m_pITableFrame->GetTableUserItem(i);
				//	if (pIServerUserItem != NULL && m_cbPlayStatus[i] == TRUE && m_cbDynamicJoin[i] == FALSE)
				//	{
				//		//AI
				//		if (pIServerUserItem->IsAndroidUser() == true)
				//		{
				//			//AI从牛五往下开始构造
				//			for (int wCardTypeIndex = CT_CLASSIC_OX_VALUE5; wCardTypeIndex >= CT_CLASSIC_OX_VALUE0; wCardTypeIndex--)
				//			{
				//				BYTE cbKeyCardData = m_GameLogic.ConstructCardType(cardlist, m_cbHandCardData[i], wCardTypeIndex, m_gtConfig);
				//				if (cbKeyCardData == INVALID_BYTE)
				//				{
				//					continue;
				//				}
				//				else
				//				{
				//					m_cbHandCardData[i][4] = cbKeyCardData;
				//					break;
				//				}
				//			}
				//		}
				//		else if (pIServerUserItem->IsAndroidUser() == false)
				//		{
				//			//普通玩家从牛六往上开始构造
				//			for (int wCardTypeIndex = CT_CLASSIC_OX_VALUE6; wCardTypeIndex <= CT_CLASSIC_OX_VALUENIUNIU; wCardTypeIndex++)
				//			{
				//				BYTE cbKeyCardData = m_GameLogic.ConstructCardType(cardlist, m_cbHandCardData[i], wCardTypeIndex, m_gtConfig);
				//				if (cbKeyCardData == INVALID_BYTE)
				//				{
				//					continue;
				//				}
				//				else
				//				{
				//					m_cbHandCardData[i][4] = cbKeyCardData;
				//					break;
				//				}
				//			}
				//		}
				//	}
				//}
			}
			else
			{
				//这局机器人赢

				//机器人坐庄, 剩下真人中，抽取可以已知最大的牌型A ， 机器人庄家构造比A大
				if (m_wBankerUser != INVALID_CHAIR && m_pITableFrame->GetTableUserItem(m_wBankerUser)->IsAndroidUser())
				{
					BYTE cbMaxCardTypeSendFour = m_GameLogic.GetMaxCardTypeSendFourRealPlayer(cardlist, m_cbHandCardData, m_ctConfig, m_pITableFrame, m_cbPlayStatus, m_cbDynamicJoin, m_wPlayerCount);
					cbMaxCardTypeSendFour = (cbMaxCardTypeSendFour >= CT_CLASSIC_OX_VALUE9 ? CT_CLASSIC_OX_VALUE9 : cbMaxCardTypeSendFour);

					BYTE cbKeyCardData = m_GameLogic.ConstructCardType(cardlist, m_cbHandCardData[m_wBankerUser], cbMaxCardTypeSendFour + 1, m_gtConfig);
					if (cbKeyCardData != INVALID_BYTE)
					{
						m_cbHandCardData[m_wBankerUser][4] = cbKeyCardData;
					}
				}
				//真人坐庄 ,为了保证机器人赢，所有机器人构造比真人庄家大的牌 (机器人5张牌都可以换 )
				else if (m_wBankerUser != INVALID_CHAIR && !m_pITableFrame->GetTableUserItem(m_wBankerUser)->IsAndroidUser())
				{
					BYTE cbMaxCardTypeSingle = m_GameLogic.GetMaxCardTypeSingle(cardlist, m_cbHandCardData[m_wBankerUser], m_ctConfig);
					cbMaxCardTypeSingle = (cbMaxCardTypeSingle >= CT_CLASSIC_OX_VALUE9 ? CT_CLASSIC_OX_VALUE9 : cbMaxCardTypeSingle);

					for (WORD i = 0; i<m_wPlayerCount; i++)
					{
						//获取用户
						IServerUserItem *pIServerUserItem = m_pITableFrame->GetTableUserItem(i);
						if (pIServerUserItem != NULL && m_cbPlayStatus[i] == TRUE && m_cbDynamicJoin[i] == FALSE)
						{
							//AI
							if (pIServerUserItem->IsAndroidUser() == true)
							{
								BYTE cbKeyCardData = m_GameLogic.ConstructCardType(cardlist, m_cbHandCardData[i], cbMaxCardTypeSingle + 1, m_gtConfig);
								if (cbKeyCardData != INVALID_BYTE)
								{
									m_cbHandCardData[i][4] = cbKeyCardData;
								}
							}
						}
					}
				}

				////牛五为基准点，AI从牛六往上开始构造， 普通玩家从牛五往下开始构造
				//for (WORD i = 0; i<m_wPlayerCount; i++)
				//{
				//	//获取用户
				//	IServerUserItem *pIServerUserItem = m_pITableFrame->GetTableUserItem(i);
				//	if (pIServerUserItem != NULL && m_cbPlayStatus[i] == TRUE && m_cbDynamicJoin[i] == FALSE)
				//	{
				//		//AI
				//		if (pIServerUserItem->IsAndroidUser() == true)
				//		{
				//			//AI从牛六往上开始构造
				//			for (int wCardTypeIndex = CT_CLASSIC_OX_VALUE6; wCardTypeIndex <= CT_CLASSIC_OX_VALUENIUNIU; wCardTypeIndex++)
				//			{
				//				BYTE cbKeyCardData = m_GameLogic.ConstructCardType(cardlist, m_cbHandCardData[i], wCardTypeIndex, m_gtConfig);
				//				if (cbKeyCardData == INVALID_BYTE)
				//				{
				//					continue;
				//				}
				//				else
				//				{
				//					m_cbHandCardData[i][4] = cbKeyCardData;
				//					break;
				//				}
				//			}
				//		}
				//		else if (pIServerUserItem->IsAndroidUser() == false)
				//		{
				//			//普通玩家从牛五往下开始构造
				//			for (int wCardTypeIndex = CT_CLASSIC_OX_VALUE5; wCardTypeIndex >= CT_CLASSIC_OX_VALUE0; wCardTypeIndex--)
				//			{
				//				BYTE cbKeyCardData = m_GameLogic.ConstructCardType(cardlist, m_cbHandCardData[i], wCardTypeIndex, m_gtConfig);
				//				if (cbKeyCardData == INVALID_BYTE)
				//				{
				//					continue;
				//				}
				//				else
				//				{
				//					m_cbHandCardData[i][4] = cbKeyCardData;
				//					break;
				//				}
				//			}
				//		}
				//	}
				//}
			}
		}
    }

    return;
}

//判断库存
bool CTableFrameSink::JudgeStock()
{
    //AI当庄标识
    bool bIsAiBanker = false;
    for(WORD i = 0; i < m_wPlayerCount; i++)
    {
        //获取用户
        IServerUserItem *pIServerUserItem = m_pITableFrame->GetTableUserItem(i);
        if(pIServerUserItem != NULL && pIServerUserItem->IsAndroidUser() && m_cbPlayStatus[i] == TRUE && i == m_wBankerUser)
        {
            bIsAiBanker = true;
        }
    }

    //扑克变量
    BYTE cbUserCardData[GAME_PLAYER][MAX_CARDCOUNT];
    CopyMemory(cbUserCardData, m_cbHandCardData, sizeof(m_cbHandCardData));

    //获取最大牌型
    for(WORD i = 0; i < m_wPlayerCount; i++)
    {
        if(m_cbPlayStatus[i] == TRUE)
        {
            m_GameLogic.GetOxCard(cbUserCardData[i], MAX_CARDCOUNT);
        }
    }

    //变量定义
    LONGLONG lAndroidScore = 0;

    //倍数变量
    BYTE cbCardTimes[GAME_PLAYER];
    ZeroMemory(cbCardTimes, sizeof(cbCardTimes));

    //查找倍数
    for(WORD i = 0; i < m_wPlayerCount; i++)
    {
        if(m_cbPlayStatus[i] == TRUE)
        {
            cbCardTimes[i] = m_GameLogic.GetTimes(cbUserCardData[i], MAX_CARDCOUNT, m_ctConfig);
        }
    }

    //倍数抢庄 结算需要乘以cbMaxCallBankerTimes
    BYTE cbMaxCallBankerTimes = 1;
    if(m_bgtConfig == BGT_ROB_)
    {
        for(WORD i = 0; i < m_wPlayerCount; i++)
        {
            if(m_cbPlayStatus[i] == TRUE && m_cbCallBankerStatus[i] == TRUE && m_cbCallBankerTimes[i] > cbMaxCallBankerTimes)
            {
                cbMaxCallBankerTimes = m_cbCallBankerTimes[i];
            }
        }
    }

    //机器庄家
    if(bIsAiBanker)
    {
        //对比扑克
        for(WORD i = 0; i < m_wPlayerCount; i++)
        {
            //用户过滤
            if((i == m_wBankerUser) || (m_cbPlayStatus[i] == FALSE)) { continue; }

            //获取用户
            IServerUserItem *pIServerUserItem = m_pITableFrame->GetTableUserItem(i);

            //机器过滤
            if((pIServerUserItem != NULL) && (pIServerUserItem->IsAndroidUser())) { continue; }

            //对比扑克
            if(m_GameLogic.CompareCard(cbUserCardData[i], cbUserCardData[m_wBankerUser], MAX_CARDCOUNT, m_ctConfig) == true)
            {
                lAndroidScore -= cbCardTimes[i] * m_lTableScore[i] * cbMaxCallBankerTimes;
            }
            else
            {
                lAndroidScore += cbCardTimes[m_wBankerUser] * m_lTableScore[i] * cbMaxCallBankerTimes;
            }
        }
    }
    else//用户庄家
    {
        //对比扑克
        for(WORD i = 0; i < m_wPlayerCount; i++)
        {
            //获取用户
            IServerUserItem *pIServerUserItem = m_pITableFrame->GetTableUserItem(i);

            //用户过滤
            if((i == m_wBankerUser) || (pIServerUserItem == NULL) || !(pIServerUserItem->IsAndroidUser())) { continue; }

            //对比扑克
            if(m_GameLogic.CompareCard(cbUserCardData[i], cbUserCardData[m_wBankerUser], MAX_CARDCOUNT, m_ctConfig) == true)
            {
                lAndroidScore += cbCardTimes[i] * m_lTableScore[i] * cbMaxCallBankerTimes;
            }
            else
            {
                lAndroidScore -= cbCardTimes[m_wBankerUser] * m_lTableScore[i] * cbMaxCallBankerTimes;
            }
        }
    }

    LONGLONG lGameEndStorage = g_lRoomStorageCurrent + lAndroidScore;

    return lGameEndStorage > 0 && (lGameEndStorage >= (g_lRoomStorageCurrent * (double)(1 - (double)5 / (double)100)));
}

//查询是否扣服务费
bool CTableFrameSink::QueryBuckleServiceCharge(WORD wChairID)
{
    for(BYTE i = 0; i < m_wPlayerCount; i++)
    {
        IServerUserItem *pUserItem = m_pITableFrame->GetTableUserItem(i);
        if(pUserItem == NULL) { continue; }

        if(m_bBuckleServiceCharge[i] && i == wChairID)
        {
            return true;
        }

    }
    return false;
}


bool CTableFrameSink::TryWriteTableScore(tagScoreInfo ScoreInfoArray[])
{
    //修改积分
    tagScoreInfo ScoreInfo[GAME_PLAYER];
    ZeroMemory(&ScoreInfo, sizeof(ScoreInfo));
    memcpy(&ScoreInfo, ScoreInfoArray, sizeof(ScoreInfo));
    //记录异常
    LONGLONG beforeScore[GAME_PLAYER];
    ZeroMemory(beforeScore, sizeof(beforeScore));
    for(WORD i = 0; i < m_wPlayerCount; i++)
    {
        IServerUserItem *pItem = m_pITableFrame->GetTableUserItem(i);
        if(pItem != NULL && m_cbPlayStatus[i] == TRUE)
        {
            beforeScore[i] = pItem->GetUserScore();
            m_pITableFrame->WriteUserScore(i, ScoreInfo[i]);
        }
    }

    LONGLONG afterScore[GAME_PLAYER];
    ZeroMemory(afterScore, sizeof(afterScore));
    for(WORD i = 0; i < m_wPlayerCount; i++)
    {
        IServerUserItem *pItem = m_pITableFrame->GetTableUserItem(i);
        if(pItem != NULL)
        {
            afterScore[i] = pItem->GetUserScore();

            if(afterScore[i] < 0)
            {
                //异常写入日志
                CString strInfo;
                strInfo.Format(TEXT("USERID[%d] 出现负分, 写分前分数：%I64d, 写入积分 %I64d，税收 %I64d, 写分后分数：%I64d"), pItem->GetUserID(), beforeScore[i], ScoreInfoArray[i].lScore, ScoreInfoArray[i].lRevenue, afterScore[i]);
				CString strFileName = TEXT("调试日志");

                tagLogUserInfo LogUserInfo;
                ZeroMemory(&LogUserInfo, sizeof(LogUserInfo));
                CopyMemory(LogUserInfo.szDescName, strFileName, sizeof(LogUserInfo.szDescName));
                CopyMemory(LogUserInfo.szLogContent, strInfo, sizeof(LogUserInfo.szLogContent));
                //m_pITableFrame->SendGameLogData(LogUserInfo);
            }

        }
    }
    return true;
}

//最大下分
SCORE CTableFrameSink::GetUserMaxTurnScore(WORD wChairID)
{
    SCORE lMaxTurnScore = 0L;
    if(wChairID == m_wBankerUser) { return 0; }
    //庄家积分
    IServerUserItem *pIBankerItem = m_pITableFrame->GetTableUserItem(m_wBankerUser);
    LONGLONG lBankerScore = 0L;
    if(pIBankerItem != NULL)
    {
        lBankerScore = pIBankerItem->GetUserScore();
    }

    //玩家人数
    WORD wUserCount = 0;
    for(WORD i = 0; i < m_wPlayerCount; i++)
        if(m_cbPlayStatus[i] == TRUE) { wUserCount++; }

    //获取用户
    IServerUserItem *pIServerUserItem = m_pITableFrame->GetTableUserItem(wChairID);

    BYTE cbMaxCallBankerTimes = 1;
    if(m_bgtConfig == BGT_ROB_)
    {
        for(WORD i = 0; i < m_wPlayerCount; i++)
        {
            if(m_cbPlayStatus[i] == TRUE && m_cbCallBankerStatus[i] == TRUE && m_cbCallBankerTimes[i] > cbMaxCallBankerTimes)
            {
                cbMaxCallBankerTimes = m_cbCallBankerTimes[i];
            }
        }
    }

    //推注功能只在积分房卡中，金币房卡和金币场不支持
    //前端积分房卡创建界面可以选择:无推注和翻倍推注
    //这一局可以推注的 条件 1. 这局是闲家 2. 上一局赢钱且闲家 3.上一把没有推注
    //某闲家可推注额度: 上局赢的总额的翻倍为本局推注的额度（大厅服务分配积分无限大，不用考虑不够赔的情况）
    //不可以连续推注
    //推注筹码是5的倍数且限制推注最高100

    //积分房卡
	if (IsRoomCardType() && m_tyConfig == BT_TUI_DOUBLE_ && m_bgtConfig != BGT_TONGBI_)
    {
        for(WORD i = 0; i < m_wPlayerCount; i++)
        {
            if(i == m_wBankerUser || m_cbPlayStatus[i] == FALSE)
            {
                continue;
            }

            if(m_bLastTurnBeBanker[i] == false && m_lLastTurnWinScore[i] > 0 && !m_bLastTurnBetBtEx[i])
            {
                m_lPlayerBetBtEx[i] = m_lLastTurnWinScore[i] * 2 / m_pITableFrame->GetCellScore();

                //推注是5的倍数
                int nDiv = m_lPlayerBetBtEx[i] / 5;
                if(nDiv > 0)
                {
                    m_lPlayerBetBtEx[i] = nDiv * 5;
                }
                else
                {
                    m_lPlayerBetBtEx[i] = 0;
                }

                m_lPlayerBetBtEx[i] = (m_lPlayerBetBtEx[i] > 100 ? 100 : m_lPlayerBetBtEx[i]);
            }
        }
    }
    else
    {
        //重置推注变量
        ZeroMemory(m_bLastTurnBeBanker, sizeof(m_bLastTurnBeBanker));
        ZeroMemory(m_lLastTurnWinScore, sizeof(m_lLastTurnWinScore));
        ZeroMemory(m_bLastTurnBetBtEx, sizeof(m_bLastTurnBetBtEx));
        ZeroMemory(m_lPlayerBetBtEx, sizeof(m_lPlayerBetBtEx));
    }

    //计算自由下注模式
    //房卡和普通金币场最大下注，前端判断某个下注筹码是否禁用
    if(pIServerUserItem != NULL && m_btConfig == BT_FREE_)
    {
        //获取积分
        LONGLONG lScore = pIServerUserItem->GetUserScore();
        lMaxTurnScore = lScore /*/ m_lMaxCardTimes / cbMaxCallBankerTimes / wUserCount*/;

        if(m_lPlayerBetBtEx[wChairID] != 0)
        {
            lMaxTurnScore = max(lMaxTurnScore, m_lPlayerBetBtEx[wChairID]);
        }

		//最小可以下第一个筹码
		lMaxTurnScore = max(lMaxTurnScore, m_lFreeConfig[0] * m_pITableFrame->GetCellScore());

        return lMaxTurnScore;
    }

    return lMaxTurnScore;
}

//查询限额
SCORE CTableFrameSink::QueryConsumeQuota(IServerUserItem *pIServerUserItem)
{
    return 0L;
}

//是否衰减(一桌同时存在真人和机器人才衰减)
bool CTableFrameSink::NeedDeductStorage()
{
	BYTE cbRealPlayerCount = 0;
	BYTE cbAICount = 0;

    for(int i = 0; i < m_wPlayerCount; ++i)
    {
        IServerUserItem *pIServerUserItem = m_pITableFrame->GetTableUserItem(i);
        if(pIServerUserItem == NULL) 
		{ 
			continue; 
		}

        if(pIServerUserItem->IsAndroidUser())
        {
			cbAICount++;
        }
		else
		{
			cbRealPlayerCount++;
		}
    }

	return (cbRealPlayerCount > 0 && cbAICount > 0);
}

//读取配置
void CTableFrameSink::ReadConfigInformation()
{
    //获取自定义配置
    tagCustomRule *pCustomRule = (tagCustomRule *)m_pGameServiceOption->cbCustomRule;
    ASSERT(pCustomRule);

    g_lRoomStorageStart = pCustomRule->lRoomStorageStart;
    g_lRoomStorageCurrent = pCustomRule->lRoomStorageStart;
    g_lStorageDeductRoom = pCustomRule->lRoomStorageDeduct;
    g_lStorageMax1Room = pCustomRule->lRoomStorageMax1;
    g_lStorageMul1Room = pCustomRule->lRoomStorageMul1;
    g_lStorageMax2Room = pCustomRule->lRoomStorageMax2;
    g_lStorageMul2Room = pCustomRule->lRoomStorageMul2;

    if(g_lStorageDeductRoom < 0 || g_lStorageDeductRoom > 1000)
    {
        g_lStorageDeductRoom = 0;
    }
    if(g_lStorageDeductRoom > 1000)
    {
        g_lStorageDeductRoom = 1000;
    }
    if(g_lStorageMul1Room < 0 || g_lStorageMul1Room > 100)
    {
        g_lStorageMul1Room = 50;
    }
    if(g_lStorageMul2Room < 0 || g_lStorageMul2Room > 100)
    {
        g_lStorageMul2Room = 80;
    }

    m_ctConfig = pCustomRule->ctConfig;
    m_stConfig = pCustomRule->stConfig;
    m_gtConfig = pCustomRule->gtConfig;
    m_bgtConfig = pCustomRule->bgtConfig;
    m_btConfig = pCustomRule->btConfig;

    CopyMemory(m_lFreeConfig, pCustomRule->lFreeConfig, sizeof(m_lFreeConfig));
    CopyMemory(m_lPercentConfig, pCustomRule->lPercentConfig, sizeof(m_lPercentConfig));

    if(m_ctConfig == CT_ADDTIMES_)
    {
        //五小牛牌型激活标注
        m_cbEnableCardType[7] = pCustomRule->cbCardTypeTimesAddTimes[18] == 0 ? FALSE : TRUE;

        m_cbClassicTypeConfig = INVALID_BYTE;
    }
    else if(m_ctConfig == CT_CLASSIC_)
    {
        //五小牛牌型激活标注
        m_cbEnableCardType[7] = pCustomRule->cbCardTypeTimesClassic[18] == 0 ? FALSE : TRUE;

        if(pCustomRule->cbCardTypeTimesClassic[7] == 1 && pCustomRule->cbCardTypeTimesClassic[8] == 2
                && pCustomRule->cbCardTypeTimesClassic[9] == 2 && pCustomRule->cbCardTypeTimesClassic[10] == 3)
        {
            m_cbClassicTypeConfig = 1;
        }
        else if(pCustomRule->cbCardTypeTimesClassic[7] == 2 && pCustomRule->cbCardTypeTimesClassic[8] == 2
                && pCustomRule->cbCardTypeTimesClassic[9] == 3 && pCustomRule->cbCardTypeTimesClassic[10] == 4)
        {
            m_cbClassicTypeConfig = 0;
        }
    }

    m_cbTrusteeDelayTime = pCustomRule->cbTrusteeDelayTime;

    return;
}

//更新房间用户信息
void CTableFrameSink::UpdateRoomUserInfo(IServerUserItem *pIServerUserItem, USERACTION userAction)
{
    //变量定义
    ROOMUSERINFO roomUserInfo;
    ZeroMemory(&roomUserInfo, sizeof(roomUserInfo));

    roomUserInfo.dwGameID = pIServerUserItem->GetGameID();
    CopyMemory(&(roomUserInfo.szNickName), pIServerUserItem->GetNickName(), sizeof(roomUserInfo.szNickName));
    roomUserInfo.cbUserStatus = pIServerUserItem->GetUserStatus();
    roomUserInfo.cbGameStatus = m_pITableFrame->GetGameStatus();

    roomUserInfo.bAndroid = pIServerUserItem->IsAndroidUser();

    //用户坐下和重连
    if(userAction == USER_SITDOWN || userAction == USER_RECONNECT)
    {
        roomUserInfo.wChairID = pIServerUserItem->GetChairID();
        roomUserInfo.wTableID = pIServerUserItem->GetTableID() + 1;
    }
    else if(userAction == USER_STANDUP || userAction == USER_OFFLINE)
    {
        roomUserInfo.wChairID = INVALID_CHAIR;
        roomUserInfo.wTableID = INVALID_TABLE;
    }

    g_MapRoomUserInfo.SetAt(pIServerUserItem->GetUserID(), roomUserInfo);

    //遍历映射，删除离开房间的玩家，
    POSITION ptHead = g_MapRoomUserInfo.GetStartPosition();
    DWORD dwUserID = 0;
    ROOMUSERINFO userinfo;
    ZeroMemory(&userinfo, sizeof(userinfo));
    TCHAR szNickName[LEN_NICKNAME];
    ZeroMemory(szNickName, sizeof(szNickName));
    DWORD *pdwRemoveKey = new DWORD[g_MapRoomUserInfo.GetSize()];
    ZeroMemory(pdwRemoveKey, sizeof(DWORD)* g_MapRoomUserInfo.GetSize());
    WORD wRemoveKeyIndex = 0;

    while(ptHead)
    {
        g_MapRoomUserInfo.GetNextAssoc(ptHead, dwUserID, userinfo);

        if(userinfo.dwGameID == 0 && (_tcscmp(szNickName, userinfo.szNickName) == 0) && userinfo.cbUserStatus == 0)
        {
            pdwRemoveKey[wRemoveKeyIndex++] = dwUserID;
        }

    }

    for(WORD i = 0; i < wRemoveKeyIndex; i++)
    {
        g_MapRoomUserInfo.RemoveKey(pdwRemoveKey[i]);
    }

    delete[] pdwRemoveKey;
}

//更新同桌用户调试
void CTableFrameSink::UpdateUserDebug(IServerUserItem *pIServerUserItem)
{
    //变量定义
    POSITION ptListHead;
    POSITION ptTemp;
    ROOMUSERDEBUG roomuserdebug;

    //初始化
    ptListHead = g_ListRoomUserDebug.GetHeadPosition();
    ZeroMemory(&roomuserdebug, sizeof(roomuserdebug));

    //遍历链表
    while(ptListHead)
    {
        ptTemp = ptListHead;
        roomuserdebug = g_ListRoomUserDebug.GetNext(ptListHead);

        //寻找已存在调试玩家
        if((pIServerUserItem->GetGameID() == roomuserdebug.roomUserInfo.dwGameID) &&
                _tcscmp(pIServerUserItem->GetNickName(), roomuserdebug.roomUserInfo.szNickName) == 0)
        {
            //获取元素
            ROOMUSERDEBUG &tmproomuserdebug = g_ListRoomUserDebug.GetAt(ptTemp);

            //重设参数
            tmproomuserdebug.roomUserInfo.wChairID = pIServerUserItem->GetChairID();
            tmproomuserdebug.roomUserInfo.wTableID = m_pITableFrame->GetTableID() + 1;

            return;
        }
    }
}

//除重用户调试
void CTableFrameSink::TravelDebugList(ROOMUSERDEBUG keyroomuserdebug)
{
    //变量定义
    POSITION ptListHead;
    POSITION ptTemp;
    ROOMUSERDEBUG roomuserdebug;

    //初始化
    ptListHead = g_ListRoomUserDebug.GetHeadPosition();
    ZeroMemory(&roomuserdebug, sizeof(roomuserdebug));

    //遍历链表
    while(ptListHead)
    {
        ptTemp = ptListHead;
        roomuserdebug = g_ListRoomUserDebug.GetNext(ptListHead);

        //寻找已存在调试玩家在用一张桌子切换椅子
        if((keyroomuserdebug.roomUserInfo.dwGameID == roomuserdebug.roomUserInfo.dwGameID) &&
                _tcscmp(keyroomuserdebug.roomUserInfo.szNickName, roomuserdebug.roomUserInfo.szNickName) == 0)
        {
            g_ListRoomUserDebug.RemoveAt(ptTemp);
        }
    }
}

//是否满足调试条件
void CTableFrameSink::IsSatisfyDebug(ROOMUSERINFO &userInfo, bool &bEnableDebug)
{
    if(userInfo.wChairID == INVALID_CHAIR || userInfo.wTableID == INVALID_TABLE)
    {
        bEnableDebug = FALSE;
        return;
    }

    if(userInfo.cbUserStatus == US_SIT || userInfo.cbUserStatus == US_READY || userInfo.cbUserStatus == US_PLAYING)
    {
        bEnableDebug = TRUE;
        return;
    }
    else
    {
        bEnableDebug = FALSE;
        return;
    }
}

//分析房间用户调试
bool CTableFrameSink::AnalyseRoomUserDebug(ROOMUSERDEBUG &Keyroomuserdebug, POSITION &ptList)
{
    //变量定义
    POSITION ptListHead;
    POSITION ptTemp;
    ROOMUSERDEBUG roomuserdebug;

    //遍历链表
    for(WORD i = 0; i < m_wPlayerCount; i++)
    {
        IServerUserItem *pIServerUserItem = m_pITableFrame->GetTableUserItem(i);
        if(!pIServerUserItem)
        {
            continue;
        }

        //初始化
        ptListHead = g_ListRoomUserDebug.GetHeadPosition();
        ZeroMemory(&roomuserdebug, sizeof(roomuserdebug));

        //遍历链表
        while(ptListHead)
        {
            ptTemp = ptListHead;
            roomuserdebug = g_ListRoomUserDebug.GetNext(ptListHead);

            //寻找玩家
            if((pIServerUserItem->GetGameID() == roomuserdebug.roomUserInfo.dwGameID) &&
                    _tcscmp(pIServerUserItem->GetNickName(), roomuserdebug.roomUserInfo.szNickName) == 0)
            {
                //清空调试局数为0的元素
                if(roomuserdebug.userDebug.cbDebugCount == 0)
                {
                    g_ListRoomUserDebug.RemoveAt(ptTemp);
                    break;
                }

                if(roomuserdebug.userDebug.debug_type == CONTINUE_CANCEL)
                {
                    g_ListRoomUserDebug.RemoveAt(ptTemp);
                    break;
                }

                //拷贝数据
                CopyMemory(&Keyroomuserdebug, &roomuserdebug, sizeof(roomuserdebug));
                ptList = ptTemp;

                return true;
            }

        }

    }

    return false;
}

void CTableFrameSink::GetDebugTypeString(DEBUG_TYPE &debugType, CString &debugTypestr)
{
    switch(debugType)
    {
    case CONTINUE_WIN:
    {
        debugTypestr = TEXT("调试类型为连赢");
        break;
    }
    case CONTINUE_LOST:
    {
        debugTypestr = TEXT("调试类型为连输");
        break;
    }
    case CONTINUE_CANCEL:
    {
        debugTypestr = TEXT("调试类型为取消调试");
        break;
    }
    }
}

//判断房卡房间
bool CTableFrameSink::IsRoomCardType()
{
    //金币场和金币房卡可以托管，积分房卡不托管
    return (((m_pGameServiceOption->wServerType) & GAME_GENRE_PERSONAL) != 0 && m_pITableFrame->GetDataBaseMode() == 0);
}

//初始默认庄家
void CTableFrameSink::InitialBanker()
{
    //房主强制为庄，若房主不参与游戏，则第一个进去此游戏的玩家强制为庄
    //获取房主
    WORD wRoomOwenrChairID = INVALID_CHAIR;
    DWORD dwRoomOwenrUserID = INVALID_DWORD;
    for(WORD i = 0; i < m_wPlayerCount; i++)
    {
        //获取用户
        IServerUserItem *pIServerUserItem = m_pITableFrame->GetTableUserItem(i);
        if(!pIServerUserItem)
        {
            continue;
        }

        m_cbCallBankerStatus[i] = TRUE;

        if(pIServerUserItem->GetUserID() == m_pITableFrame->GetTableOwner() && IsRoomCardType())
        {
            dwRoomOwenrUserID = pIServerUserItem->GetUserID();
            wRoomOwenrChairID = pIServerUserItem->GetChairID();
            //break;
        }
    }

    //房主参与游戏
    if(dwRoomOwenrUserID != INVALID_DWORD && wRoomOwenrChairID != INVALID_CHAIR)
    {
        m_wBankerUser = wRoomOwenrChairID;
    }
    //房主不参与游戏和非房卡房间
    else
    {
        ASSERT(m_listEnterUser.IsEmpty() == false);
        m_wBankerUser = m_listEnterUser.GetHead();
    }

    ASSERT(m_wBankerUser != INVALID_CHAIR);

    m_bBuckleServiceCharge[m_wBankerUser] = true;

    bool bTrusteeUser = false;
    for(WORD i = 0; i < m_wPlayerCount; i++)
    {
        if(m_cbPlayStatus[i] == TRUE && m_pITableFrame->GetTableUserItem(i)->IsTrusteeUser())
        {
            bTrusteeUser = true;
        }
    }

    //非房卡场设置定时器
    if(!IsRoomCardType()/* || bTrusteeUser*/)
    {
        m_pITableFrame->KillGameTimer(IDI_SO_OPERATE);
        m_pITableFrame->SetGameTimer(IDI_SO_OPERATE, TIME_SO_OPERATE, 1, 0);
    }

    //设置离线代打定时器
    for(WORD i = 0; i < m_wPlayerCount; i++)
    {
        if(m_cbPlayStatus[i] == TRUE && m_pITableFrame->GetTableUserItem(i)->IsTrusteeUser())
        {
            m_pITableFrame->SetGameTimer(IDI_OFFLINE_TRUSTEE_0 + i, m_cbTrusteeDelayTime * 1000, 1, 0);
        }
    }

    //设置状态
    m_pITableFrame->SetGameStatus(GS_TK_SCORE);
    EnableTimeElapse(true);

    //更新房间用户信息
    for(WORD i = 0; i < m_wPlayerCount; i++)
    {
        //获取用户
        IServerUserItem *pIServerUserItem = m_pITableFrame->GetTableUserItem(i);
        if(pIServerUserItem != NULL)
        {
            UpdateRoomUserInfo(pIServerUserItem, USER_SITDOWN);
        }
    }

    //获取最大下注
    for(WORD i = 0; i < m_wPlayerCount; i++)
    {
        if(m_cbPlayStatus[i] != TRUE || i == m_wBankerUser)
        {
            continue;
        }

        //下注变量
        m_lTurnMaxScore[i] = GetUserMaxTurnScore(i);
    }

    for(WORD i = 0; i < m_wPlayerCount; i++)
    {
        if(i == m_wBankerUser || m_cbPlayStatus[i] == FALSE)
        {
            continue;
        }

        if(m_bLastTurnBetBtEx[i] == true)
        {
            m_bLastTurnBetBtEx[i] = false;
        }
    }

    m_lPlayerBetBtEx[m_wBankerUser] = 0;

    //设置变量
    CMD_S_GameStart GameStart;
    ZeroMemory(&GameStart, sizeof(GameStart));
    GameStart.wBankerUser = m_wBankerUser;
    CopyMemory(GameStart.cbPlayerStatus, m_cbPlayStatus, sizeof(m_cbPlayStatus));

    //发四等五
    if(m_stConfig == ST_SENDFOUR_)
    {
        for(WORD i = 0; i < m_wPlayerCount; i++)
        {
            if(m_cbPlayStatus[i] == FALSE && m_cbDynamicJoin[i] == FALSE)
            {
                continue;
            }

            //派发扑克(开始只发四张牌)
            CopyMemory(GameStart.cbCardData[i], m_cbHandCardData[i], sizeof(BYTE) * 4);
        }
    }

    GameStart.stConfig = m_stConfig;
    GameStart.bgtConfig = m_bgtConfig;
    GameStart.btConfig = m_btConfig;
    GameStart.gtConfig = m_gtConfig;

    CopyMemory(GameStart.lFreeConfig, m_lFreeConfig, sizeof(GameStart.lFreeConfig));
    CopyMemory(GameStart.lPercentConfig, m_lPercentConfig, sizeof(GameStart.lPercentConfig));
    CopyMemory(GameStart.lPlayerBetBtEx, m_lPlayerBetBtEx, sizeof(GameStart.lPlayerBetBtEx));

    bool bFirstRecord = true;

    WORD wRealPlayerCount = 0;
    for(WORD i = 0; i < m_wPlayerCount; i++)
    {
        IServerUserItem *pServerUserItem = m_pITableFrame->GetTableUserItem(i);
        if(m_cbPlayStatus[i] == FALSE && m_cbDynamicJoin[i] == FALSE)
        {
            continue;
        }

        if(!pServerUserItem)
        {
            continue;
        }

        wRealPlayerCount++;
    }

    BYTE *pGameRule = m_pITableFrame->GetGameRule();

    //最大下注
    for(WORD i = 0; i < m_wPlayerCount; i++)
    {
        IServerUserItem *pServerUserItem = m_pITableFrame->GetTableUserItem(i);
        if(m_cbPlayStatus[i] == FALSE && m_cbDynamicJoin[i] == FALSE)
        {
            continue;
        }
        GameStart.lTurnMaxScore = m_lTurnMaxScore[i];
        m_pITableFrame->SendTableData(i, SUB_S_GAME_START, &GameStart, sizeof(GameStart));

        if(m_pGameVideo)
        {
            Video_GameStart video;
            ZeroMemory(&video, sizeof(video));
            video.lCellScore = m_pITableFrame->GetCellScore();
            video.wPlayerCount = wRealPlayerCount;
            video.wGamePlayerCountRule = pGameRule[1];
            video.wBankerUser = GameStart.wBankerUser;
            CopyMemory(video.cbPlayerStatus, GameStart.cbPlayerStatus, sizeof(video.cbPlayerStatus));
            video.lTurnMaxScore = GameStart.lTurnMaxScore;
            CopyMemory(video.cbCardData, GameStart.cbCardData, sizeof(video.cbCardData));
            video.ctConfig = m_ctConfig;
            video.stConfig = GameStart.stConfig;
            video.bgtConfig = GameStart.bgtConfig;
            video.btConfig = GameStart.btConfig;
            video.gtConfig = GameStart.gtConfig;

            CopyMemory(video.lFreeConfig, GameStart.lFreeConfig, sizeof(video.lFreeConfig));
            CopyMemory(video.lPercentConfig, GameStart.lPercentConfig, sizeof(video.lPercentConfig));
            CopyMemory(video.szNickName, pServerUserItem->GetNickName(), sizeof(video.szNickName));
            video.wChairID = i;
            video.lScore = pServerUserItem->GetUserScore();

            m_pGameVideo->AddVideoData(SUB_S_GAME_START, &video, bFirstRecord);

            if(bFirstRecord == true)
            {
                bFirstRecord = false;
            }
        }
    }
    m_pITableFrame->SendLookonData(INVALID_CHAIR, SUB_S_GAME_START, &GameStart, sizeof(GameStart));
}

//搜索特定扑克玩家
WORD CTableFrameSink::SearchKeyCardChairID(BYTE cbKeyCardData[MAX_CARDCOUNT])
{
    WORD wKeyChairID = INVALID_CHAIR;

    for(WORD i = 0; i < m_wPlayerCount; i++)
    {
        //获取用户
        IServerUserItem *pIServerUserItem = m_pITableFrame->GetTableUserItem(i);
        if(pIServerUserItem == NULL)
        {
            continue;
        }

        if(cbKeyCardData[0] == m_cbHandCardData[i][0] && cbKeyCardData[1] == m_cbHandCardData[i][1]
                && cbKeyCardData[2] == m_cbHandCardData[i][2] && cbKeyCardData[3] == m_cbHandCardData[i][3]
                && cbKeyCardData[4] == m_cbHandCardData[i][4])
        {
            wKeyChairID = i;
            break;
        }
    }

    return wKeyChairID;
}

//流逝时间
void CTableFrameSink::EnableTimeElapse(bool bEnable)
{
    if(bEnable)
    {
        m_pITableFrame->KillGameTimer(IDI_TIME_ELAPSE);
        m_cbTimeRemain = TIME_SO_OPERATE / 1000;
        m_pITableFrame->SetGameTimer(IDI_TIME_ELAPSE, 1000, -1, 0);
    }
    else
    {
        m_pITableFrame->KillGameTimer(IDI_TIME_ELAPSE);
        m_cbTimeRemain = TIME_SO_OPERATE / 1000;
    }
}

//测试写信息
void CTableFrameSink::WriteInfo(LPCTSTR pszFileName, LPCTSTR pszString)
{
	//设置语言区域
	char *old_locale = _strdup(setlocale(LC_CTYPE, NULL));
	setlocale(LC_CTYPE, "chs");

	CStdioFile myFile;
	CString strFileName;
	strFileName.Format(TEXT("%s"), pszFileName);
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

//////////////////////////////////////////////////////////////////////////

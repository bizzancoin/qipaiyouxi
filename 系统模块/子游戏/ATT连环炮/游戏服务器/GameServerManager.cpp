#include "StdAfx.h"
#include "Resource.h"
#include "Tableframesink.h"
#include "GameServerManager.h"

//////////////////////////////////////////////////////////////////////////

//全局变量
static CGameServiceManager g_GameServiceManager;
//构造函数
CGameServiceManager::CGameServiceManager(void)
{
	//设置属性
	m_GameServiceAttrib.wKindID = KIND_ID;
	m_GameServiceAttrib.wChairCount = GAME_PLAYER;
	m_GameServiceAttrib.wSupporType = (GAME_GENRE_GOLD);

	//功能标志
	m_GameServiceAttrib.cbDynamicJoin = FALSE;
	m_GameServiceAttrib.cbAndroidUser = FALSE;
	m_GameServiceAttrib.cbOffLineTrustee = FALSE;

	//服务属性
	m_GameServiceAttrib.dwServerVersion = VERSION_SERVER;
	m_GameServiceAttrib.dwClientVersion = VERSION_CLIENT;
	lstrcpyn(m_GameServiceAttrib.szGameName, GAME_NAME, CountArray(m_GameServiceAttrib.szGameName));
	lstrcpyn(m_GameServiceAttrib.szDataBaseName, szTreasureDB, CountArray(m_GameServiceAttrib.szDataBaseName));
	lstrcpyn(m_GameServiceAttrib.szClientEXEName, TEXT("ATT.exe"), CountArray(m_GameServiceAttrib.szClientEXEName));
	lstrcpyn(m_GameServiceAttrib.szServerDLLName, TEXT("ATTServer.DLL"), CountArray(m_GameServiceAttrib.szServerDLLName));
	
	m_pDlgCustomRule = NULL;
	return;
}

//析构函数
CGameServiceManager::~CGameServiceManager(void)
{
	SafeDelete(m_pDlgCustomRule);
}

//接口查询
VOID * CGameServiceManager::QueryInterface(const IID &Guid, DWORD dwQueryVer)
{
	QUERYINTERFACE(IGameServiceManager, Guid, dwQueryVer);
	QUERYINTERFACE(IGameServiceCustomRule, Guid, dwQueryVer);
	QUERYINTERFACE_IUNKNOWNEX(IGameServiceManager, Guid, dwQueryVer);
	return NULL;
}

//创建游戏桌
VOID * CGameServiceManager::CreateTableFrameSink(REFGUID Guid, DWORD dwQueryVer)
{
	//建立对象
	CTableFrameSink *pTableFrameSink = NULL;
	try
	{
		pTableFrameSink = new CTableFrameSink();
		if (pTableFrameSink == NULL) 
		{
			throw TEXT("创建失败");
		}

		void *pObject = pTableFrameSink->QueryInterface(Guid, dwQueryVer);
		if (pObject == NULL) 
		{
			throw TEXT("接口查询失败");
		}

		return pObject;
	}
	catch (...) {}

	//清理对象
	SafeDelete(pTableFrameSink);

	return NULL;
}

//获取属性
bool CGameServiceManager::GetServiceAttrib(tagGameServiceAttrib &GameServiceAttrib)
{
	GameServiceAttrib = m_GameServiceAttrib;

	return true;
}

//参数修改
bool CGameServiceManager::RectifyParameter(tagGameServiceOption &GameServiceOption)
{
	//效验参数
	ASSERT(&GameServiceOption != NULL);
	if (&GameServiceOption == NULL) 
	{
		return false;
	}

	//单元积分
	GameServiceOption.lCellScore = __max(1L, GameServiceOption.lCellScore);

	//积分下限
	if (GameServiceOption.wServerType&(GAME_GENRE_GOLD|SCORE_GENRE_POSITIVE))
	{
        GameServiceOption.lMinTableScore = __max(GameServiceOption.lCellScore, GameServiceOption.lMinTableScore);
	}

	//积分上限
	if (GameServiceOption.lRestrictScore != 0L)
	{
		GameServiceOption.lRestrictScore = __max(GameServiceOption.lRestrictScore, GameServiceOption.lMinTableScore);
	}

	return true;
}

//创建机器
VOID * CGameServiceManager::CreateAndroidUserItemSink(REFGUID Guid, DWORD dwQueryVer)
{
	return NULL;
}

//创建数据
VOID * CGameServiceManager::CreateGameDataBaseEngineSink(REFGUID Guid, DWORD dwQueryVer)
{
	return NULL;
}

//获取配置
bool CGameServiceManager::SaveCustomRule(LPBYTE pcbCustomRule, WORD wCustonSize)
{
	//效验状态
	ASSERT(m_pDlgCustomRule != NULL);
	if (m_pDlgCustomRule == NULL) 
	{
		return false;
	}

	//变量定义
	ASSERT(wCustonSize >= sizeof(tagCustomRule));
	tagCustomRule *pCustomRule = (tagCustomRule *)pcbCustomRule;

	//获取配置
	if (m_pDlgCustomRule->GetCustomRule(*pCustomRule) == false)
	{
		return false;
	}	

	return true;
}
	
//默认配置
bool CGameServiceManager::DefaultCustomRule(LPBYTE pcbCustomRule, WORD wCustonSize)
{
	//变量定义
	ASSERT(wCustonSize >= sizeof(tagCustomRule));
	tagCustomRule *pCustomRule = (tagCustomRule *)pcbCustomRule;

	//设置变量
	pCustomRule->lExchangeRadio = 10;
	pCustomRule->lSysStorage = 100000;
	pCustomRule->lUserStorage = 90000;
	pCustomRule->nDebugPercent = 20;
    pCustomRule->lBet[0] = 1;
    pCustomRule->lBet[1] = 2;
    pCustomRule->lBet[2] = 3;
    pCustomRule->lBet[3] = 4;
    pCustomRule->lBet[4] = 5;
    pCustomRule->lBet[5] = 6;
    pCustomRule->lBet[6] = 7;
    pCustomRule->lBet[7] = 8;
    pCustomRule->lBet[8] = 9;
    pCustomRule->lBet[9] = 10;
	return true;
}

//创建窗口
HWND CGameServiceManager::CreateCustomRule(CWnd * pParentWnd, CRect rcCreate, LPBYTE pcbCustomRule, WORD wCustonSize)
{
	//创建窗口
	if (m_pDlgCustomRule == NULL)
	{
		m_pDlgCustomRule = new CDlgCustomRule;
	}

	//创建窗口
	if (m_pDlgCustomRule->m_hWnd == NULL)
	{
		//设置资源
		AfxSetResourceHandle(GetModuleHandle(m_GameServiceAttrib.szServerDLLName));

		//创建窗口
		m_pDlgCustomRule->Create(IDD_CUSTOM_RULE, pParentWnd);

		//还原资源
		AfxSetResourceHandle(GetModuleHandle(NULL));
	}

	//设置变量
	ASSERT(wCustonSize >= sizeof(tagCustomRule));
	m_pDlgCustomRule->SetCustomRule(*((tagCustomRule *)pcbCustomRule));

	//显示窗口
	m_pDlgCustomRule->SetWindowPos(NULL, rcCreate.left, rcCreate.top, rcCreate.Width(), rcCreate.Height(), SWP_NOZORDER|SWP_SHOWWINDOW);

	return m_pDlgCustomRule->GetSafeHwnd();
}


//////////////////////////////////////////////////////////////////////////

//建立对象函数
extern "C" __declspec(dllexport) VOID * CreateGameServiceManager(REFGUID Guid, DWORD dwInterfaceVer)
{
	return g_GameServiceManager.QueryInterface(Guid, dwInterfaceVer);
}

//////////////////////////////////////////////////////////////////////////

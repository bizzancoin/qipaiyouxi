#include "StdAfx.h"
#include "Resource.h"
#include "Tableframesink.h"
#include "GameServerManager.h"

//////////////////////////////////////////////////////////////////////////
//机器定义
#ifndef _DEBUG
#define ANDROID_SERVICE_DLL_NAME	TEXT("OxEightAndroid.dll")	//组件名字
#else
#define ANDROID_SERVICE_DLL_NAME	TEXT("OxEightAndroid.dll")	//组件名字
#endif

//////////////////////////////////////////////////////////////////////////

//构造函数
CGameServiceManager::CGameServiceManager(void)
{
	//设置属性
	m_GameServiceAttrib.wKindID = KIND_ID;
	m_GameServiceAttrib.wChairCount = GAME_PLAYER;
	m_GameServiceAttrib.wSupporType = (GAME_GENRE_GOLD | GAME_GENRE_SCORE | GAME_GENRE_MATCH | GAME_GENRE_EDUCATE | GAME_GENRE_PERSONAL);

	//功能标志
	m_GameServiceAttrib.cbDynamicJoin = TRUE;
	m_GameServiceAttrib.cbAndroidUser = TRUE;
	m_GameServiceAttrib.cbOffLineTrustee = FALSE;

	//服务属性
	m_GameServiceAttrib.dwServerVersion = VERSION_SERVER;
	m_GameServiceAttrib.dwClientVersion = VERSION_CLIENT;
	lstrcpyn(m_GameServiceAttrib.szGameName, GAME_NAME, CountArray(m_GameServiceAttrib.szGameName));
	lstrcpyn(m_GameServiceAttrib.szDataBaseName, szTreasureDB, CountArray(m_GameServiceAttrib.szDataBaseName));
	lstrcpyn(m_GameServiceAttrib.szClientEXEName, TEXT("OxEight.exe"), CountArray(m_GameServiceAttrib.szClientEXEName));
	lstrcpyn(m_GameServiceAttrib.szServerDLLName, TEXT("OxEightServer.dll"), CountArray(m_GameServiceAttrib.szServerDLLName));

	m_pDlgCustomRule = NULL;

	return;
}

//析构函数
CGameServiceManager::~CGameServiceManager(void)
{
	//删除对象
	SafeDelete(m_pDlgCustomRule);
}

//接口查询
VOID * CGameServiceManager::QueryInterface(const IID & Guid, DWORD dwQueryVer)
{
	QUERYINTERFACE(IGameServiceManager, Guid, dwQueryVer);
	QUERYINTERFACE(IGameServiceCustomRule, Guid, dwQueryVer);
	QUERYINTERFACE(IGameServicePersonalRule, Guid, dwQueryVer);
	QUERYINTERFACE_IUNKNOWNEX(IGameServiceManager, Guid, dwQueryVer);
	return NULL;
}

//创建游戏桌
VOID * CGameServiceManager::CreateTableFrameSink(REFGUID Guid, DWORD dwQueryVer)
{
	//建立对象
	CTableFrameSink * pTableFrameSink = NULL;
	try
	{
		pTableFrameSink = new CTableFrameSink();
		if (pTableFrameSink == NULL) throw TEXT("创建失败");
		void * pObject = pTableFrameSink->QueryInterface(Guid, dwQueryVer);
		if (pObject == NULL) throw TEXT("接口查询失败");
		return pObject;
	}
	catch (...) {}

	//清理对象
	SafeDelete(pTableFrameSink);

	return NULL;
}

//获取属性
bool CGameServiceManager::GetServiceAttrib(tagGameServiceAttrib & GameServiceAttrib)
{
	GameServiceAttrib = m_GameServiceAttrib;
	return true;
}

//参数修改
bool CGameServiceManager::RectifyParameter(tagGameServiceOption & GameServiceOption)
{
	//效验参数
	ASSERT(&GameServiceOption != NULL);
	if (&GameServiceOption == NULL) return false;

	//单元积分
	GameServiceOption.lCellScore = __max(1L, GameServiceOption.lCellScore);

	//获取规则
	tagCustomRule * pCustomRule = (tagCustomRule*)(&(GameServiceOption.cbCustomRule));

	//最大牌型倍数
	BYTE cbMaxCardTypeTimes = INVALID_BYTE;

	if (pCustomRule->ctConfig == CT_CLASSIC_)
	{
		cbMaxCardTypeTimes = pCustomRule->cbCardTypeTimesClassic[0];
		for (WORD i = 0; i < MAX_CARD_TYPE; i++)
		{
			if (pCustomRule->cbCardTypeTimesClassic[i] > cbMaxCardTypeTimes)
			{
				cbMaxCardTypeTimes = pCustomRule->cbCardTypeTimesClassic[i];
			}
		}
	}
	else if (pCustomRule->ctConfig == CT_ADDTIMES_)
	{
		cbMaxCardTypeTimes = pCustomRule->cbCardTypeTimesAddTimes[0];
		for (WORD i = 0; i < MAX_CARD_TYPE; i++)
		{
			if (pCustomRule->cbCardTypeTimesAddTimes[i] > cbMaxCardTypeTimes)
			{
				cbMaxCardTypeTimes = pCustomRule->cbCardTypeTimesAddTimes[i];
			}
		}
	}
	ASSERT(cbMaxCardTypeTimes != INVALID_BYTE);

	//最小下注倍数
	LONG cbMinBetTimes = pCustomRule->lFreeConfig[0];

	if (pCustomRule->bgtConfig == BGT_ROB_)
	{
		//底分 x 最小下注倍数 x 最大抢庄倍数 x 最大牌型倍数 x (GAME_PLAYER - 1) 
		BYTE cbMaxCallBankerTimes = 5;
		SCORE lMinTableScore = GameServiceOption.lCellScore * cbMinBetTimes/* * cbMaxCallBankerTimes * cbMaxCardTypeTimes * (GAME_PLAYER - 1)*/;
		GameServiceOption.lMinTableScore = max(GameServiceOption.lMinTableScore, lMinTableScore);
	}
	else
	{
		//底分 x 最小下注倍数 x 最大牌型倍数 x (GAME_PLAYER - 1) 
		SCORE lMinTableScore = GameServiceOption.lCellScore * cbMinBetTimes/* * cbMaxCardTypeTimes * (GAME_PLAYER - 1)*/;
		GameServiceOption.lMinTableScore = max(GameServiceOption.lMinTableScore, lMinTableScore);
	}

	//金币房卡默认支持断线代打，不勾选
	if (((GameServiceOption.wServerType) & GAME_GENRE_PERSONAL) != 0 && lstrcmp(GameServiceOption.szDataBaseName, TEXT("WHQJTreasureDB")) == 0)
	{
		//获取约战规则
		tagOxSixXSpecial * pPersonalRule = (tagOxSixXSpecial *)(GameServiceOption.cbPersonalRule);
		pPersonalRule->cbAdvancedConfig[4] = FALSE;
	}

	return true;
}

//获取配置
bool CGameServiceManager::SaveCustomRule(LPBYTE pcbCustomRule, WORD wCustonSize)
{
	//效验状态
	ASSERT(m_pDlgCustomRule != NULL);
	if (m_pDlgCustomRule == NULL) return false;

	//变量定义
	ASSERT(wCustonSize >= sizeof(tagCustomRule));
	tagCustomRule * pCustomRule = (tagCustomRule *)pcbCustomRule;

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
	tagCustomRule * pCustomRule = (tagCustomRule *)pcbCustomRule;

	//设置变量
	pCustomRule->lRoomStorageStart = 100000;
	pCustomRule->lRoomStorageDeduct = 0;
	pCustomRule->lRoomStorageMax1 = 1000000;
	pCustomRule->lRoomStorageMul1 = 50;
	pCustomRule->lRoomStorageMax2 = 5000000;
	pCustomRule->lRoomStorageMul2 = 80;

	//AI存款取款
	pCustomRule->lRobotScoreMin = 100000;
	pCustomRule->lRobotScoreMax = 1000000;
	pCustomRule->lRobotBankGet = 1000000;
	pCustomRule->lRobotBankGetBanker = 10000000;
	pCustomRule->lRobotBankStoMul = 10;

	pCustomRule->ctConfig = CT_ADDTIMES_;
	pCustomRule->stConfig = ST_SENDFOUR_;
	pCustomRule->gtConfig = GT_HAVEKING_;
	pCustomRule->bgtConfig = BGT_ROB_;
	pCustomRule->btConfig = BT_FREE_;

	pCustomRule->lFreeConfig[0] = 2;
	pCustomRule->lFreeConfig[1] = 5;
	pCustomRule->lFreeConfig[2] = 8;
	pCustomRule->lFreeConfig[3] = 11;

	ZeroMemory(pCustomRule->lPercentConfig, sizeof(pCustomRule->lPercentConfig));

	//经典牌型倍数
	for (WORD i = 0; i < 7; i++)
	{
		pCustomRule->cbCardTypeTimesClassic[i] = 1;
	}
	pCustomRule->cbCardTypeTimesClassic[7] = 2;
	pCustomRule->cbCardTypeTimesClassic[8] = 2;
	pCustomRule->cbCardTypeTimesClassic[9] = 3;
	pCustomRule->cbCardTypeTimesClassic[10] = 4;
	pCustomRule->cbCardTypeTimesClassic[11] = 4;
	for (WORD i = 12; i < MAX_CARD_TYPE - 1; i++)
	{
		pCustomRule->cbCardTypeTimesClassic[i] = 5;
	}
	pCustomRule->cbCardTypeTimesClassic[18] = 8;

	//加倍牌型倍数
	pCustomRule->cbCardTypeTimesAddTimes[0] = 1;
	for (BYTE i = 1; i < MAX_CARD_TYPE; i++)
	{
		pCustomRule->cbCardTypeTimesAddTimes[i] = i;
	}

	pCustomRule->cbTrusteeDelayTime = 3;

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
	m_pDlgCustomRule->SetWindowPos(NULL, rcCreate.left, rcCreate.top, rcCreate.Width(), rcCreate.Height(), SWP_NOZORDER | SWP_SHOWWINDOW);

	return m_pDlgCustomRule->GetSafeHwnd();
}

//获取配置
bool CGameServiceManager::SavePersonalRule(LPBYTE pcbPersonalRule, WORD wPersonalSize)
{
	//效验状态
	ASSERT(m_pDlgPersonalRule != NULL);
	if (m_pDlgPersonalRule == NULL) return false;

	//变量定义
	ASSERT(wPersonalSize >= sizeof(tagOxSixXSpecial));
	tagOxSixXSpecial * pPersonalRule = (tagOxSixXSpecial *)pcbPersonalRule;

	//获取配置
	if (m_pDlgPersonalRule->GetPersonalRule(*pPersonalRule) == false)
	{
		return false;
	}

	return true;
}

//默认配置
bool CGameServiceManager::DefaultPersonalRule(LPBYTE pcbPersonalRule, WORD wPersonalSize)
{
	//变量定义
	ASSERT(wPersonalSize >= sizeof(tagOxSixXSpecial));
	tagOxSixXSpecial * pPersonalRule = (tagOxSixXSpecial *)pcbPersonalRule;

	//设置变量
	for (WORD i = 0; i < MAX_BANKERMODE; i++)
	{
		pPersonalRule->cbBankerModeEnable[i] = TRUE;
	}

	//霸王庄禁用
	pPersonalRule->cbBankerModeEnable[0] = FALSE;

	for (WORD i = 0; i < MAX_GAMEMODE; i++)
	{
		pPersonalRule->cbGameModeEnable[i] = TRUE;
	}

	for (WORD i = 0; i < MAX_ADVANCECONFIG; i++)
	{
		pPersonalRule->cbAdvancedConfig[i] = TRUE;
	}

	for (WORD i = 0; i < MAX_SPECIAL_CARD_TYPE; i++)
	{
		pPersonalRule->cbSpeCardType[i] = TRUE;
	}

	pPersonalRule->cbBeBankerCon[0] = 100;
	pPersonalRule->cbBeBankerCon[1] = 120;
	pPersonalRule->cbBeBankerCon[2] = 150;
	pPersonalRule->cbBeBankerCon[3] = 200;

	pPersonalRule->cbUserbetTimes[0] = 5;
	pPersonalRule->cbUserbetTimes[1] = 8;
	pPersonalRule->cbUserbetTimes[2] = 10;
	pPersonalRule->cbUserbetTimes[3] = 20;

	return true;
}

//创建窗口
HWND CGameServiceManager::CreatePersonalRule(CWnd * pParentWnd, CRect rcCreate, LPBYTE pcbPersonalRule, WORD wPersonalSize)
{
	//创建窗口
	if (m_pDlgPersonalRule == NULL)
	{
		m_pDlgPersonalRule = new CDlgPersonalRule;
	}

	//创建窗口
	if (m_pDlgPersonalRule->m_hWnd == NULL)
	{
		//设置资源
		AfxSetResourceHandle(GetModuleHandle(m_GameServiceAttrib.szServerDLLName));

		//创建窗口
		m_pDlgPersonalRule->Create(IDD_PERSONAL_RULE, pParentWnd);

		//还原资源
		AfxSetResourceHandle(GetModuleHandle(NULL));
	}

	//设置变量
	ASSERT(wPersonalSize >= sizeof(tagOxSixXSpecial));
	m_pDlgPersonalRule->SetPersonalRule(*((tagOxSixXSpecial *)pcbPersonalRule));

	//显示窗口
	m_pDlgPersonalRule->SetWindowPos(NULL, rcCreate.left, rcCreate.top, rcCreate.Width(), rcCreate.Height(), SWP_NOZORDER | SWP_SHOWWINDOW);

	return m_pDlgPersonalRule->GetSafeHwnd();
}

//创建机器
VOID * CGameServiceManager::CreateAndroidUserItemSink(REFGUID Guid, DWORD dwQueryVer)
{
	try
	{
		//加载模块
		if (m_hDllInstance == NULL)
		{
			m_hDllInstance = AfxLoadLibrary(ANDROID_SERVICE_DLL_NAME);
			if (m_hDllInstance == NULL) throw TEXT("AI服务模块不存在");
		}

		//寻找函数
		ModuleCreateProc * CreateProc = (ModuleCreateProc *)GetProcAddress(m_hDllInstance, "CreateAndroidUserItemSink");
		if (CreateProc == NULL) throw TEXT("AI服务模块组件不合法");

		//创建组件
		return CreateProc(Guid, dwQueryVer);
	}
	catch (...) {}

	return NULL;
}

//创建数据
VOID * CGameServiceManager::CreateGameDataBaseEngineSink(REFGUID Guid, DWORD dwQueryVer)
{
	return NULL;
}

//////////////////////////////////////////////////////////////////////////

//建立对象函数
extern "C" __declspec(dllexport) VOID * CreateGameServiceManager(REFGUID Guid, DWORD dwInterfaceVer)
{
	static CGameServiceManager GameServiceManager;
	return GameServiceManager.QueryInterface(Guid, dwInterfaceVer);
}

// CoinDozerConfigDlg.cpp : 实现文件
//

#include "stdafx.h"
#include "Resource.h"
#include "ClientConfigDlg.h"
#include <math.h>

//////////////////////////////////////////////////////////////////////////////////

// 调试对话框
IMPLEMENT_DYNAMIC(CClientConfigDlg, CDialog)
BEGIN_MESSAGE_MAP(CClientConfigDlg, CDialog)
	ON_BN_CLICKED(IDC_BUTTON_WEIGHT, OnShowWeight)
    ON_NOTIFY(TCN_SELCHANGE, IDC_TAB_CUSTOM, OnTcnSelchangeTabOptisons)
    ON_WM_DESTROY()
END_MESSAGE_MAP()

//////////////////////////////////////////////////////////////////////////////////

// 构造函数
CClientConfigDlg::CClientConfigDlg(CWnd *pParent /*=NULL*/) : CDialog(IDD_DIALOG_MAIN, pParent)
{
    // 设置变量
    m_pParentWnd = NULL;
    m_pIClientDebugCallback = NULL;
	m_pDialogWeight = nullptr;
}

// 析构函数
CClientConfigDlg::~CClientConfigDlg()
{
}

// 窗口销毁
void CClientConfigDlg::OnDestroy()
{
    // 销毁窗口
    for(int nIndex = 0; nIndex < MAX_CUSTOM; ++nIndex)
    {
        m_DialogCustom[nIndex]->DestroyWindow();
        delete m_DialogCustom[nIndex];
    }
	if (m_pDialogWeight)
	{
		m_pDialogWeight->DestroyWindow();
		delete m_pDialogWeight;
	}
    CDialog::OnDestroy();
}

// 控件绑定
VOID CClientConfigDlg::DoDataExchange(CDataExchange *pDX)
{
    __super::DoDataExchange(pDX);
}

// 释放接口
void CClientConfigDlg::Release()
{
    delete this;
}

// 创建函数
bool CClientConfigDlg::Create(CWnd *pParentWnd, IClientDebugCallback *pIClientDebugCallback)
{
    // 设置变量
    m_pParentWnd = pParentWnd;
    m_pIClientDebugCallback = pIClientDebugCallback;

    // 创建窗口
    __super::Create(IDD_DIALOG_MAIN, pParentWnd);

    // 获取分页
    CTabCtrl *pTabCtrl = (CTabCtrl *)GetDlgItem(IDC_TAB_CUSTOM);

    // 设置选项
    pTabCtrl->InsertItem(0, _T("配置调试"));
	pTabCtrl->InsertItem(1, _T("游戏调试"));
	pTabCtrl->InsertItem(2, _T("日志记录"));
	//pTabCtrl->InsertItem(3, _T("权重配置"));
    pTabCtrl->SetCurSel(0);

    // 获取分页
    CRect RectWindow;
	CWnd *pWindowShow = GetDlgItem(IDC_STATIC_SHOW);
    pWindowShow->ShowWindow(SW_HIDE);
    pWindowShow->GetWindowRect(RectWindow);
    ScreenToClient(RectWindow);

    // 创建窗口
	m_DialogCustom[CUSTOM_CONFIG] = new CDialogConfig(RectWindow.Height(), this);
	m_DialogCustom[CUSTOM_CONFIG]->Create(IDD_CUSTOM_CONFIG, this);

	m_DialogCustom[CUSTOM_DEBUG] = new CDialogDebug(RectWindow.Height(), this);
	m_DialogCustom[CUSTOM_DEBUG]->Create(IDD_CUSTOM_DEBUG, this);

	m_DialogCustom[CUSTOM_LOG] = new CDialogLog(RectWindow.Height(), this);
	m_DialogCustom[CUSTOM_LOG]->Create(IDD_CUSTOM_LOG, this);

	//m_DialogCustom[CUSTOM_WEIGHT] = new CDialogWeight(RectWindow.Height(), this);
	//m_DialogCustom[CUSTOM_WEIGHT]->Create(IDD_CUSTOM_WEIGHT, this);
	m_pDialogWeight = new CDialogWeight(RectWindow.Height(), this);
	m_pDialogWeight->Create(IDD_CUSTOM_WEIGHT, this);
	{
		CRect RectCustom;
		CSize SizeCustom;
		m_pDialogWeight->GetClientRect(RectCustom);
		SizeCustom.SetSize(min(RectWindow.Width(), RectCustom.Width()), min(RectWindow.Height(), RectCustom.Height()));
		m_pDialogWeight->SetWindowPos(NULL, RectWindow.left + RectWindow.Width() / 2 - SizeCustom.cx / 2, RectWindow.top, SizeCustom.cx, SizeCustom.cy, SWP_NOZORDER);
		//m_pDialogWeight->ShowWindow((nIndex == 0) ? SW_SHOW : SW_HIDE);
	}

    // 窗口位置
    for(int nIndex = 0; nIndex < MAX_CUSTOM; ++nIndex)
    {
        CRect RectCustom;
        CSize SizeCustom;
        m_DialogCustom[nIndex]->GetClientRect(RectCustom);
        SizeCustom.SetSize(min(RectWindow.Width(), RectCustom.Width()), min(RectWindow.Height(), RectCustom.Height()));

		m_DialogCustom[nIndex]->SetWindowPos(NULL, RectWindow.left + RectWindow.Width() / 2 - SizeCustom.cx / 2, RectWindow.top, SizeCustom.cx, SizeCustom.cy, SWP_NOZORDER);
        m_DialogCustom[nIndex]->ShowWindow((nIndex == 0) ? SW_SHOW : SW_HIDE);
    }

    // 关闭窗口
    __super::ShowWindow(SW_HIDE);

    return true;

}

// 显示窗口
bool CClientConfigDlg::ShowWindow(bool bShow)
{
    // 显示窗口
    __super::ShowWindow(bShow ? SW_SHOW : SW_HIDE);

    // 显示窗口
    if(bShow && m_pParentWnd)
    {
        // 获取父窗口
        CRect RectParent;
        m_pParentWnd->GetWindowRect(RectParent);

        // 获取当前窗口
        CRect RectWindow;
        GetWindowRect(RectWindow);

        // 移动位置
        SetWindowPos(NULL, RectParent.left + RectParent.Width() / 2 - RectWindow.Width() / 2, RectParent.top + RectParent.Height() / 2 - RectWindow.Height() / 2, 0, 0, SWP_NOSIZE);
    }

    return true;
}

// 消息函数
bool CClientConfigDlg::OnDebugMessage(WORD nMessageID, WORD wTableID, void *pData, WORD nSize)
{
    // 无效接口
    if(m_pIClientDebugCallback == NULL)
    {
        return false;
    }
	if (m_pDialogWeight)
		m_pDialogWeight->OnDebugMessage(nMessageID, wTableID, pData, nSize);

    // 判断窗口
    for(int nIndex = 0; nIndex < MAX_CUSTOM; ++nIndex)
    {
        if(m_DialogCustom[nIndex]->OnDebugMessage(nMessageID, wTableID, pData, nSize))
        {
            return true;
        }
    }

    return true;
}

// 调试信息
bool CClientConfigDlg::SendDebugMessage(UINT nMessageID, void *pData, UINT nSize)
{
    if(m_pIClientDebugCallback != NULL)
    {
        // 发送消息
        m_pIClientDebugCallback->OnDebugInfo(nMessageID, 0, pData, nSize);
    }
    return true;
}

// 调试信息
bool CClientConfigDlg::SendDebugMessage(UINT nMessageID, WORD wTableID, void *pData, UINT nSize)
{
	if (m_pIClientDebugCallback != NULL)
	{
		// 发送消息
		m_pIClientDebugCallback->OnDebugInfo(nMessageID, wTableID, pData, nSize);
	}
	return true;
}

// 变换选项
void CClientConfigDlg::OnTcnSelchangeTabOptisons(NMHDR *pNMHDR, LRESULT *pResult)
{
    // 获取分页
    CTabCtrl *pTabCtrl = (CTabCtrl *)GetDlgItem(IDC_TAB_CUSTOM);

    // 获取选择项目
    int nCurSel = pTabCtrl->GetCurSel();
    if(nCurSel >= 0 && nCurSel < MAX_CUSTOM)
    {
        // 判断窗口
        for(int nIndex = 0; nIndex < MAX_CUSTOM; ++nIndex)
        {
            m_DialogCustom[nIndex]->ShowWindow((nIndex == nCurSel) ? SW_SHOW : SW_HIDE);
        }
    }

    *pResult = 0;
}
void CClientConfigDlg::OnShowWeight()
{
	CTabCtrl *pTabCtrl = (CTabCtrl *)GetDlgItem(IDC_TAB_CUSTOM);
	if (m_pDialogWeight != nullptr)
	{
		if (!m_pDialogWeight->IsWindowVisible())
		{
			pTabCtrl->ShowWindow(SW_HIDE);
			// 判断窗口
			for (int nIndex = 0; nIndex < MAX_CUSTOM; ++nIndex)
			{
				m_DialogCustom[nIndex]->ShowWindow(SW_HIDE);
			}
			m_pDialogWeight->ShowWindow(SW_SHOW);
			return;
		}

		m_pDialogWeight->ShowWindow(SW_HIDE);
		pTabCtrl->ShowWindow(SW_SHOW);
		// 获取选择项目
		int nCurSel = pTabCtrl->GetCurSel();
		if (nCurSel >= 0 && nCurSel < MAX_CUSTOM)
		{
			// 判断窗口
			for (int nIndex = 0; nIndex < MAX_CUSTOM; ++nIndex)
			{
				m_DialogCustom[nIndex]->ShowWindow((nIndex == nCurSel) ? SW_SHOW : SW_HIDE);
			}
		}
		return;
	}
};
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
IMPLEMENT_DYNAMIC(CDialogConfig, CDialogDexter)
BEGIN_MESSAGE_MAP(CDialogConfig, CDialogDexter)
	ON_BN_CLICKED(IDC_BUTTON_STORAGE_SET, OnSetSystemStorage)
	ON_BN_CLICKED(IDC_BUTTON_REWARD_SET, OnSetGameReward)
	//ON_BN_CLICKED(IDC_BUTTON_TAX_SET, OnSetGameTax)
	ON_BN_CLICKED(IDC_BUTTON_CONFIG_GAME_EXTRA, OnSetGameExtra)
	ON_WM_CTLCOLOR()
END_MESSAGE_MAP()
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 调试对话框

// 构造函数
CDialogConfig::CDialogConfig(int nShowMax/* = 0*/, CClientConfigDlg *pParent /*=NULL*/) : CDialogDexter(IDD_CUSTOM_CONFIG, nShowMax, pParent)
{
	m_pParentDlg = pParent;
	for (int i = MinCtrl; i < MaxCtrl; i += 1)
		m_bFirstInit[i] = true;
}

// 析构函数
CDialogConfig::~CDialogConfig()
{
}

// 控件绑定
void CDialogConfig::DoDataExchange(CDataExchange *pDX)
{
	CDialogDexter::DoDataExchange(pDX);
}

bool CDialogConfig::OnDebugMessage(WORD nMessageID, WORD wTableID, void *pData, WORD nSize)
{
	switch (nMessageID)
	{
	case SUB_S_EVENT_UPDATE:
		return OnDebugEvent(pData, nSize);
	default:
		return false;
	}

	return true;
}

// 初始化窗口
BOOL CDialogConfig::OnInitDialog()
{
	// 初始化窗口
	__super::OnInitDialog();

	InitUI();
	return TRUE;
}
void CDialogConfig::InitUI()
{
	static CFont fontA,fontB;
	fontA.CreateFont(18, 10, 0, 0, FW_MEDIUM, FALSE, FALSE, 0, ANSI_CHARSET, OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS,
		DEFAULT_QUALITY,
		DEFAULT_PITCH,
		_T("宋体"));
	fontB.CreateFont(15, 7, 0, 0, FW_MEDIUM, FALSE, FALSE, 0, ANSI_CHARSET, OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS,
		DEFAULT_QUALITY,
		DEFAULT_PITCH,
		_T("宋体"));

	//调整控件字体大小
	GetDlgItem(IDC_STATIC_TONGJI)->SetFont(&fontA);
	GetDlgItem(IDC_STATIC_TOTAL_WINLOSE)->SetFont(&fontA);
	GetDlgItem(IDC_STATIC_REVENUE)->SetFont(&fontA);
	GetDlgItem(IDC_STATIC_TOTAL_TAX)->SetFont(&fontA);
	//
	GetDlgItem(IDC_STATIC_SYS)->SetFont(&fontB);
	GetDlgItem(IDC_STATIC_T2)->SetFont(&fontB);
	GetDlgItem(IDC_STATIC_T)->SetFont(&fontB);
	//
	GetDlgItem(IDC_STATIC_SET)->SetFont(&fontB);
	GetDlgItem(IDC_STATIC_CHOU)->SetFont(&fontB);


	//获取所有数据
	m_pParentWnd->SendDebugMessage(SUB_C_EVENT_UPDATE);
}

//
bool CDialogConfig::OnDebugEvent(void *pData, WORD nSize)
{
	if (nSize <= sizeof(ControlUpdateEvent))
		return false;

	ControlUpdateEvent* pEvent = (ControlUpdateEvent*)pData;
	if (nSize != pEvent->nDataLen + sizeof(ControlUpdateEvent))
		return false;

	switch (pEvent->emEventType)
	{
	case EventSysCtrl:		//系统调试更新
	{
									if (pEvent->nDataLen != sizeof(StorageInfo))
										return true;
									StorageInfo* pInfo = (StorageInfo*)(pEvent+1);
									RefreshCurSystemStorage(pInfo);

	}break;
	case EventGameTax:			//游戏抽水更新
	{
									if (pEvent->nDataLen != sizeof(GameTaxInfo))
									return true;
									GameTaxInfo* pInfo = (GameTaxInfo*)(pEvent+1);
									RefreshCurGameTax(pInfo);

	}break;
	case EventGameReward:		//游戏彩金更新
	{
									if (pEvent->nDataLen != sizeof(GameRewardInfo))
										return true;
									GameRewardInfo* pInfo = (GameRewardInfo*)(pEvent+1);
									RefreshCurGameReward(pInfo);

	}break;
	case EventGameExtra:			//游戏杂项数据更新
	{
									if (pEvent->nDataLen != sizeof(GameExtraInfo))
										return true;
									GameExtraInfo* pInfo = (GameExtraInfo*)(pEvent + 1);
									RefreshCurGameExtra(pInfo);

	}break;
	case EventGameStatistics:	//游戏综合数据更新
	{
									if (pEvent->nDataLen != sizeof(StatisticsInfo))
										return true;
									StatisticsInfo* pInfo = (StatisticsInfo*)(pEvent+1);
									RefreshCurGameStatistics(pInfo);

	}break;
	case EventRoomCtrl:			//房间调试更新
	case EventUserCtrl:			//玩家调试更新
	default:
		return false;;
	}

	//让所有界面尝试处理消息，多界面可能共享同一数据
	return false;
};
//
void CDialogConfig::RefreshCurSystemStorage(StorageInfo* pInfo)
{
	StorageInfo info = *pInfo;

	if (m_bFirstInit[SysCtrl] && pInfo->curStatus == AlreadyInCtrl)
	{
		SetDlgItemValue(IDC_EDIT_CONFIG_STORAGE_SYSTEM, (LONGLONG)info.lConfigSysStorage);
		SetDlgItemValue(IDC_EDIT_CONFIG_STORAGE_PLAYER, (LONGLONG)info.lConfigPlayerStorage);
		SetDlgItemValue(IDC_EDIT_CONFIG_STORAGE_PARATERMK, info.lConfigParameterK);
		SetDlgItemValue(IDC_EDIT_CONFIG_STORAGE_FORCE_REST_SECTION, info.lConfigResetSection);
		m_bFirstInit[SysCtrl] = false;
	}
	if (pInfo->curStatus != AlreadyInCtrl)
		ZeroMemory(&info, sizeof(info));
	SetDlgItemValue(IDC_STATIC_CUR_STORAGE_SYATEM, info.lCurSysStorage);
	SetDlgItemValue(IDC_STATIC_CUR_STORAGE_PLAYER, info.lCurPlayerStorage);
	SetDlgItemValue(IDC_STATIC_CUR_STORAGE_PARAMTERMK, info.lCurParameterK);
	SetDlgItemValue(IDC_STATIC_CUR_STORAGE_RESET_TIMES, info.lResetTimes);
	//SetDlgItemValue(IDC_STATIC_CUR_STORAGE_SYATEM_WINLOSE, info.lSysCtrlSysWin - info.lSysCtrlPlayerWin);
	CString str;
	str.Format(L"%d%%", info.lWinRatio);
	SetDlgItemText(IDC_STATIC_CUR_STORAGE_WIN_RATIO, str);
};
void CDialogConfig::RefreshCurGameReward(GameRewardInfo* pInfo)
{
	SetDlgItemValue(IDC_STATIC_CUR_REWARD_STROAGE, pInfo->lCurStorage);
	SetDlgItemValue(IDC_STATIC_CUR_REWARD_RATIO, pInfo->lTaxRatio);
	if (m_bFirstInit[GameReward])
	{
		SetDlgItemValue(IDC_EDIT_CONFIG_REWARD_RATIO, pInfo->lTaxRatio);
		SetDlgItemValue(IDC_EDIT_CONFIG_REWARD_DISPATCH_START, (LONGLONG)pInfo->lDispatchStorage);
		SetDlgItemValue(IDC_EDIT_CONFIG_REWARD_DISPATCH_RATIO, pInfo->lDispatchRatio);
		SetDlgItemValue(IDC_EDIT_CONFIG_REWARD_VIRTUAL_STORAGE, (LONGLONG)pInfo->lVirtualStorage);
		m_bFirstInit[GameReward] = false;
	}
};
void CDialogConfig::RefreshCurGameTax(GameTaxInfo* pInfo)
{
	SetDlgItemValue(IDC_STATIC_CUR_TAX_TOTAL, pInfo->lCurStorage);
	SetDlgItemValue(IDC_STATIC_CUR_TAX_RATIO, pInfo->lTaxRatio);
	if (m_bFirstInit[GameTax])
	{
		SetDlgItemValue(IDC_EDIT_CONFIG_TAX_RATIO, pInfo->lTaxRatio);
		m_bFirstInit[GameTax] = false;
	}
};
void CDialogConfig::RefreshCurGameExtra(GameExtraInfo* pInfo)
{
	if (m_bFirstInit[GameExtra])
	{
		SetDlgItemValue(IDC_EDIT_CONFIG_FREE_GAME_RATIO, pInfo->lFreeGameRatio);
		SetDlgItemValue(IDC_EDIT_CONFIG_EXTRA_GAME_RATIO, pInfo->lExtraGameRatio);
		m_bFirstInit[GameExtra] = false;
	}
};
void CDialogConfig::RefreshCurGameStatistics(StatisticsInfo* pInfo)
{
	//系统总输赢 = 各调试系统总输赢 + 下注抽水库存 + 彩金库存 
	SetDlgItemValue(IDC_STATIC_TOTAL_WINLOSE, pInfo->lSysCtrlSysWin);
	SetDlgItemValue(IDC_STATIC_TOTAL_TAX, pInfo->lTotalServiceTax);
	//调试系统总输赢 = 系统赢(系统库存变化)  - 玩家赢(玩家库存变化)
	SetDlgItemValue(IDC_STATIC_CUR_STORAGE_SYATEM_WINLOSE, pInfo->stSystem.lSysCtrlSysWin - pInfo->stSystem.lSysCtrlPlayerWin);
	m_pParentDlg->m_gameConfig = pInfo->stGameConfig;
	SetDlgItemValue(IDC_EDIT_STORGAE_SET_MIN_VALUE, (LONGLONG)m_pParentDlg->m_gameConfig.lStorageMin);
};
//
void CDialogConfig::OnSetSystemStorage()
{
	StorageInfo info;
	ZeroMemory(&info, sizeof(info));

	//填充数据
	info.lConfigParameterK = GetDlgItemLongLong(IDC_EDIT_CONFIG_STORAGE_PARATERMK);
	if (info.lConfigParameterK <= 0 || info.lConfigParameterK > 100)
	{
		AfxMessageBox(L"调节系数有效输入范围：1~100");
		return;
	}
	info.lConfigSysStorage = GetDlgItemLongLong(IDC_EDIT_CONFIG_STORAGE_SYSTEM);
	if (info.lConfigSysStorage <= 0)
	{
		AfxMessageBox(L"系统库存有效输入范围：>0");
		return;
	}
	info.lConfigPlayerStorage = GetDlgItemLongLong(IDC_EDIT_CONFIG_STORAGE_PLAYER);
	if (info.lConfigPlayerStorage <= 0)
	{
		AfxMessageBox(L"玩家库存有效输入范围：>0");
		return;
	}
	info.lConfigResetSection = GetDlgItemLongLong(IDC_EDIT_CONFIG_STORAGE_FORCE_REST_SECTION);
	if (info.lConfigResetSection <= 0 || info.lConfigResetSection > 100)
	{
		AfxMessageBox(L"强制重置区间有效输入范围：1~100");
		return;
	}
	if (m_pParentDlg->m_gameConfig.lStorageMin > 0 && m_pParentDlg->m_gameConfig.lStorageMin > info.lConfigPlayerStorage)
	{
		CString str;
		str.Format(L"玩家库存设置错误，最小:%I64d", (LONGLONG)m_pParentDlg->m_gameConfig.lStorageMin);
		AfxMessageBox(str);
		SetDlgItemValue(IDC_EDIT_CONFIG_STORAGE_PLAYER, (LONGLONG)m_pParentDlg->m_gameConfig.lStorageMin);
		return;
	}

	info.lCurSysStorage = info.lConfigSysStorage;
	info.lCurPlayerStorage = info.lConfigPlayerStorage;
	info.lCurParameterK = info.lConfigParameterK;
	info.lCurResetSection = info.lConfigResetSection;
	SendEvent(EventSysCtrl, sizeof(StorageInfo), (void*)&info);

};
void CDialogConfig::OnSetGameReward()
{
	
	//填充数据
	/*
	GameRewardInfo info;
	ZeroMemory(&info, sizeof(info));
	info.lDispatchRatio = GetDlgItemLongLong(IDC_EDIT_CONFIG_REWARD_DISPATCH_RATIO);
	if (info.lDispatchRatio < 0 || info.lDispatchRatio > 100)
	{
		AfxMessageBox(L"派彩概率有效输入范围：0~100");
		return;
	}
	info.lTaxRatio = GetDlgItemLongLong(IDC_EDIT_CONFIG_REWARD_RATIO);
	if (info.lTaxRatio < 0 || info.lTaxRatio > 100)
	{
		AfxMessageBox(L"彩金抽取比例有效输入范围：0~100");
		return;
	}
	info.lDispatchStorage = GetDlgItemLongLong(IDC_EDIT_CONFIG_REWARD_DISPATCH_START);
	if (info.lDispatchStorage < 0)
	{
		AfxMessageBox(L"派彩起点有效输入范围：>0");
		return;
	}
	info.lVirtualStorage = GetDlgItemLongLong(IDC_EDIT_CONFIG_REWARD_VIRTUAL_STORAGE);
	if (info.lVirtualStorage < 0)
	{
		AfxMessageBox(L"虚拟彩金派彩有效输入范围：>0");
		return;
	}
	SendEvent(EventGameReward, sizeof(GameRewardInfo), (void*)&info);
	*/
	//
	GameTaxInfo taxinfo;
	ZeroMemory(&taxinfo, sizeof(taxinfo));
	//填充数据
	taxinfo.lTaxRatio = GetDlgItemLongLong(IDC_EDIT_CONFIG_TAX_RATIO);
	if (taxinfo.lTaxRatio < 0 || taxinfo.lTaxRatio > 100)
	{
		AfxMessageBox(L"抽水比例有效输入范围：0~100");
		return;
	}

	SendEvent(EventGameTax, sizeof(GameTaxInfo), (void*)&taxinfo);
};
void CDialogConfig::OnSetGameTax()
{
	GameTaxInfo info;
	ZeroMemory(&info, sizeof(info));
	//填充数据
	info.lTaxRatio = GetDlgItemLongLong(IDC_EDIT_CONFIG_TAX_RATIO);
	if (info.lTaxRatio < 0 || info.lTaxRatio > 100)
	{
		AfxMessageBox(L"抽水比例有效输入范围：0~100");
		return;
	}

	SendEvent(EventGameTax, sizeof(GameTaxInfo), (void*)&info);
};
void CDialogConfig::OnSetGameExtra()
{
	//
	GameExtraInfo extraInfo;
	ZeroMemory(&extraInfo, sizeof(extraInfo));
	//填充数据
	extraInfo.lFreeGameRatio = GetDlgItemLongLong(IDC_EDIT_CONFIG_FREE_GAME_RATIO);
	if (extraInfo.lFreeGameRatio < 0 || extraInfo.lFreeGameRatio > 100)
	{
		AfxMessageBox(L"免费游戏概率有效输入范围：0~100");
		return;
	}
	extraInfo.lExtraGameRatio = GetDlgItemLongLong(IDC_EDIT_CONFIG_EXTRA_GAME_RATIO);
	if (extraInfo.lExtraGameRatio < 0 || extraInfo.lExtraGameRatio > 100)
	{
		AfxMessageBox(L"小游戏概率有效输入范围：0~100");
		return;
	}
	SendEvent(EventGameExtra, sizeof(GameExtraInfo), (void*)&extraInfo);
}
HBRUSH CDialogConfig::OnCtlColor(CDC* pDC, CWnd* pWnd, UINT nCtlColor)
{
	HBRUSH hbr = __super::OnCtlColor(pDC, pWnd, nCtlColor);

	return hbr;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
IMPLEMENT_DYNAMIC(CDialogDebug, CDialogDexter)
BEGIN_MESSAGE_MAP(CDialogDebug, CDialogDexter)
	ON_BN_CLICKED(IDC_BUTTON_ROOM_SET, OnSetRoomStorage)
	ON_BN_CLICKED(IDC_BUTTON_ROOM_CANCEL, OnCancelRoomTask)
	ON_BN_CLICKED(IDC_BUTTON_PLAYER_SET, OnSetPlayerStorage)
	ON_BN_CLICKED(IDC_BUTTON_PLAYER_CANCEL, OnCancelPlayerTask)
	ON_WM_CTLCOLOR()
END_MESSAGE_MAP()

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 调试对话框

// 构造函数
CDialogDebug::CDialogDebug(int nShowMax/* = 0*/, CClientConfigDlg *pParent /*=NULL*/) : CDialogDexter(IDD_CUSTOM_DEBUG, nShowMax, pParent)
{
	m_pParentDlg = pParent;
	for (int i = MinCtrl; i < MaxCtrl; i += 1)
		m_bFirstInit[i] = true;
}

// 析构函数
CDialogDebug::~CDialogDebug()
{
}

// 控件绑定
void CDialogDebug::DoDataExchange(CDataExchange *pDX)
{
	CDialogDexter::DoDataExchange(pDX);
}

// 消息函数
bool CDialogDebug::OnDebugMessage(WORD nMessageID, WORD wTableID, void *pData, WORD nSize)
{
	switch (nMessageID)
	{
	case SUB_S_EVENT_UPDATE:
		return OnDebugEvent(pData, nSize);
	default:
		return false;

	}
	return true;
}

// 初始化窗口
BOOL CDialogDebug::OnInitDialog()
{
	// 初始化窗口
	__super::OnInitDialog();

	InitUI();
	return TRUE;
}

HBRUSH CDialogDebug::OnCtlColor(CDC* pDC, CWnd* pWnd, UINT nCtlColor)
{
	HBRUSH hbr = __super::OnCtlColor(pDC, pWnd, nCtlColor);

	switch (pWnd->GetDlgCtrlID())
	{
	/*case IDC_STATIC_LOG_TOTAL_PLAYER_WINLOSE:
	{
		pDC->SetTextColor(RGB(255, 0, 0));
	}break;*/
	default:
		break;
	}

	return hbr;
}

//
void CDialogDebug::InitUI()
{
	static CFont fontB;
	fontB.CreateFont(15, 7, 0, 0, FW_MEDIUM, FALSE, FALSE, 0, ANSI_CHARSET, OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS,
		DEFAULT_QUALITY,
		DEFAULT_PITCH,
		_T("宋体"));

	//调整控件字体大小
	//
	GetDlgItem(IDC_STATIC_ROOM)->SetFont(&fontB);
	GetDlgItem(IDC_STATIC_USER)->SetFont(&fontB);
	GetDlgItem(IDC_STATIC_ROOM_T)->SetFont(&fontB);
	GetDlgItem(IDC_STATIC_USER_T)->SetFont(&fontB);

	//房间调试列表
	{
		CListCtrl *pList = (CListCtrl *)GetDlgItem(IDC_LIST_ROOM_WORKING_TASK);
		pList->SetExtendedStyle(pList->GetExtendedStyle() | LVS_EX_FULLROWSELECT | LVS_EX_GRIDLINES);
		int nColumnCount = 0;
		pList->InsertColumn(nColumnCount++, TEXT("调试ID"), LVCFMT_CENTER, 60);
		pList->InsertColumn(nColumnCount++, TEXT("系统库存"), LVCFMT_CENTER, 70);
		pList->InsertColumn(nColumnCount++, TEXT("玩家库存"), LVCFMT_CENTER, 70);
		pList->InsertColumn(nColumnCount++, TEXT("调节系数"), LVCFMT_CENTER, 80);
		pList->InsertColumn(nColumnCount++, TEXT("库存统计"), LVCFMT_CENTER, 70);
	};
	//玩家调试列表
	{
		CListCtrl *pList = (CListCtrl *)GetDlgItem(IDC_LIST_PLAYER_WORKING_TASK);
		pList->SetExtendedStyle(pList->GetExtendedStyle() | LVS_EX_FULLROWSELECT | LVS_EX_GRIDLINES);
		int nColumnCount = 0;
		pList->InsertColumn(nColumnCount++, TEXT("调试ID"), LVCFMT_CENTER, 60);
		pList->InsertColumn(nColumnCount++, TEXT("系统库存"), LVCFMT_CENTER, 70);
		pList->InsertColumn(nColumnCount++, TEXT("玩家库存"), LVCFMT_CENTER, 70);
		pList->InsertColumn(nColumnCount++, TEXT("调节系数"), LVCFMT_CENTER, 80);
		pList->InsertColumn(nColumnCount++, TEXT("库存统计"), LVCFMT_CENTER, 70);
		pList->InsertColumn(nColumnCount++, TEXT("当前状态"), LVCFMT_CENTER, 70);
	};
};
//
bool CDialogDebug::OnDebugEvent(void *pData, WORD nSize)
{
	if (nSize < sizeof(ControlUpdateEvent))
		return false;

	ControlUpdateEvent* pEvent = (ControlUpdateEvent*)pData;
	if (nSize != pEvent->nDataLen + sizeof(ControlUpdateEvent))
		return false;

	switch (pEvent->emEventType)
	{
	case EventRoomCtrl:		//房间调试更新
	{
								if (pEvent->nDataLen != sizeof(StorageInfo))
									return true;
								StorageInfo* pInfo = (StorageInfo*)(pEvent+1);
								RefreshCurRoomStorage(pInfo);
								RefreshRoomTaskList(pInfo);

	}break;
	case EventUserCtrl:			//玩家调试更新
	{
									if (pEvent->nDataLen != sizeof(GameDebugInfo))
										return true;
									GameDebugInfo* pInfo = (GameDebugInfo*)(pEvent+1);
									RefreshCurPlayerStorage(pInfo);
									RefreshPlayerTaskList(pInfo);

	}break;
	case EventGameStatistics:	//游戏综合数据更新
	{
									if (pEvent->nDataLen != sizeof(StatisticsInfo))
										return true;
									StatisticsInfo* pInfo = (StatisticsInfo*)(pEvent + 1);
									RefreshCurGameStatistics(pInfo);

	}break;
	default:
		return false;;
	}

	//让所有界面尝试处理消息，多界面可能共享同一数据
	return false;
};
void CDialogDebug::RefreshCurGameStatistics(StatisticsInfo* pInfo)
{
	//调试系统总输赢 = 系统赢(系统库存变化)  - 玩家赢(玩家库存变化)
	SetDlgItemValue(IDC_STATIC_CUR_ROOM_TOTAL_WINLOSE, pInfo->stRoom.lSysCtrlSysWin - pInfo->stRoom.lSysCtrlPlayerWin);
	SetDlgItemValue(IDC_STATIC_CUR_PLAYER_TOTAL_WINLOSE, pInfo->stArea.lSysCtrlSysWin - pInfo->stArea.lSysCtrlPlayerWin);
	//
	SetDlgItemValue(IDC_EDIT_STORAGE_SET_MIN_VALUE2, (LONGLONG)m_pParentDlg->m_gameConfig.lStorageMin);
	SetDlgItemValue(IDC_EDIT_STORAGE_SET_MIN_VALUE3, (LONGLONG)m_pParentDlg->m_gameConfig.lStorageMin);
};
void CDialogDebug::RefreshCurRoomStorage(StorageInfo* pInfo)
{
	StorageInfo info = *pInfo;

	if (m_bFirstInit[RoomCtrl])
	{
		SetDlgItemValue(IDC_EDIT_CONFIG_ROOM_SYSTEM, (LONGLONG)info.lConfigSysStorage);
		SetDlgItemValue(IDC_EDIT_CONFIG_ROOM_PLAYER, (LONGLONG)info.lConfigPlayerStorage);
		SetDlgItemValue(IDC_EDIT_CONFIG_ROOM_PARAMTERMK, info.lConfigParameterK);
		SetDlgItemValue(IDC_EDIT_CONFIG_ROOM_FROCE_RESET_SECTION, info.lConfigResetSection);
		m_bFirstInit[RoomCtrl] = false;
	}

	SetDlgItemValue(IDC_STATIC_CUR_ROOM_STORAGE_INDEX, info.nId);
	SetDlgItemValue(IDC_STATIC_CUR_ROOM_SYSTEM_STORAGE, info.lCurSysStorage);
	SetDlgItemValue(IDC_STATIC_CUR_ROOM_PLAYER_STORAGE, info.lCurPlayerStorage);
	SetDlgItemValue(IDC_STATIC_CUR_ROOM_PARAMTERMK, info.lCurParameterK);
	//SetDlgItemValue(IDC_STATIC_CUR_ROOM_TOTAL_WINLOSE, info.lSysCtrlSysWin - info.lSysCtrlPlayerWin);
	CString str;
	str.Format(L"%d%%", info.lWinRatio);
	SetDlgItemText(IDC_STATIC_CUR_ROOM_WIN_RATIO, str);
};
void CDialogDebug::RefreshRoomTaskList(StorageInfo* pInfo)
{
	CListCtrl* pList = (CListCtrl*)GetDlgItem(IDC_LIST_ROOM_WORKING_TASK);
	//只显示执行态或待执行态任务
	int nColumn = GetListTargetColumn(pList, pInfo->nId, 0);
	
	if (pInfo->curStatus != AlreadyInCtrl && pInfo->curStatus != WaitForCtrl)
	{
		if (pInfo->curStatus == NullStatus)	return;
		//删除条目
		if (nColumn >= 0)
		{
			pList->DeleteItem(nColumn);
			return;
		}
		return;
	}

	//新增条目
	if (nColumn < 0)
	{
		nColumn = pList->GetItemCount();

		CString str;
		str.Format(L"%d", pInfo->nId);
		pList->InsertItem(nColumn, str);
	}
	
	int nCurSetIndex = 1;
	SetListItemValue(pList,nColumn, nCurSetIndex++, pInfo->lCurSysStorage);
	SetListItemValue(pList, nColumn, nCurSetIndex++, pInfo->lCurPlayerStorage);
	SetListItemValue(pList, nColumn, nCurSetIndex++, pInfo->lCurParameterK);
	SetListItemValue(pList, nColumn, nCurSetIndex++, pInfo->lSysCtrlSysWin - pInfo->lSysCtrlPlayerWin);
};
void CDialogDebug::RefreshCurPlayerStorage(GameDebugInfo* pInfo)
{
	GameDebugInfo info = *pInfo;

	if (m_bFirstInit[UserCtrl])
	{
		SetDlgItemValue(IDC_EDIT_CONFIG_PLAYER_SYSTEMSTORAGE, (LONGLONG)info.lConfigSysStorage);
		SetDlgItemValue(IDC_EDIT_CONFIG_PLAYER_PLAYERSTORAGE, (LONGLONG)info.lConfigPlayerStorage);
		SetDlgItemValue(IDC_EDIT_CONFIG_PLAYER_PARAMTERMK, info.lConfigParameterK);
		SetDlgItemValue(IDC_EDIT_CONFIG_PLAYER_FORCERESETSECTION, info.lConfigResetSection);
		SetDlgItemValue(IDC_EDIT_CONFIG_PLAYER_DEBUGID, (LONGLONG)info.nGameID);
		m_bFirstInit[UserCtrl] = false;
	}
	
	SetDlgItemValue(IDC_STATIC_CUR_PLAYER_DEBUGID, (LONGLONG)info.nGameID);
	SetDlgItemValue(IDC_STATIC_CUR_PLAYER_SYSTEM_STORAGE, info.lCurSysStorage);
	SetDlgItemValue(IDC_STATIC_CUR_PLAYER_PLAYER_STORAGE, info.lCurPlayerStorage);
	SetDlgItemValue(IDC_STATIC_CUR_PLAYER_PARAMTERMK, info.lCurParameterK);
	//SetDlgItemValue(IDC_STATIC_CUR_PLAYER_TOTAL_WINLOSE, info.lSysCtrlSysWin - info.lSysCtrlPlayerWin);
	CString str;
	str.Format(L"%d%%", info.lWinRatio);
	SetDlgItemText(IDC_STATIC_CUR_PLAYER_WIN_RATIO, str);
};
void CDialogDebug::RefreshPlayerTaskList(GameDebugInfo* pInfo)
{
	CListCtrl* pList = (CListCtrl*)GetDlgItem(IDC_LIST_PLAYER_WORKING_TASK);
	//只显示执行态或待执行态任务
	int nColumn = GetListTargetColumn(pList, pInfo->nGameID, 0);

	if (pInfo->curStatus != AlreadyInCtrl && pInfo->curStatus != WaitForCtrl)
	{
		if (pInfo->curStatus == NullStatus)	return;
		//删除条目
		if (nColumn >= 0) 		
		{
			pList->DeleteItem(nColumn);
			return;
		}

		return;
	}

	//新增条目
	if (nColumn < 0)
	{
		nColumn = pList->GetItemCount();

		CString str;
		str.Format(L"%d", pInfo->nGameID);
		pList->InsertItem(nColumn, str);
	}

	int nCurSetIndex = 1;
	SetListItemValue(pList, nColumn, nCurSetIndex++, pInfo->lCurSysStorage);
	SetListItemValue(pList, nColumn, nCurSetIndex++, pInfo->lCurPlayerStorage);
	SetListItemValue(pList, nColumn, nCurSetIndex++, pInfo->lCurParameterK);
	SetListItemValue(pList, nColumn, nCurSetIndex++, pInfo->lSysCtrlSysWin - pInfo->lSysCtrlPlayerWin);
	SetListItemValue(pList, nColumn, nCurSetIndex++, pInfo->curStatus == AlreadyInCtrl ? L"进行中" : L"队列中");
};
//
void CDialogDebug::OnSetRoomStorage()
{
	StorageInfo info;
	ZeroMemory(&info, sizeof(info));
	info.lConfigSysStorage = GetDlgItemLongLong(IDC_EDIT_CONFIG_ROOM_SYSTEM);
	if (info.lConfigSysStorage < 0)
	{
		AfxMessageBox(L"系统库存有效输入范围：>0");
		return;
	}
	info.lConfigPlayerStorage = GetDlgItemLongLong(IDC_EDIT_CONFIG_ROOM_PLAYER);
	if (info.lConfigPlayerStorage < 0)
	{
		AfxMessageBox(L"玩家库存有效输入范围：>0");
		return;
	}
	info.lConfigParameterK = GetDlgItemLongLong(IDC_EDIT_CONFIG_ROOM_PARAMTERMK);
	if (info.lConfigParameterK <= 0 || info.lConfigParameterK > 100)
	{
		AfxMessageBox(L"调节系数有效输入范围：1~100");
		return;
	}
	info.lConfigResetSection = GetDlgItemLongLong(IDC_EDIT_CONFIG_ROOM_FROCE_RESET_SECTION);
	if (info.lConfigResetSection <= 0 || info.lConfigResetSection > 100)
	{
		AfxMessageBox(L"强制重置区间有效输入范围：1~100");
		return;
	}
	if (m_pParentDlg->m_gameConfig.lStorageMin > 0 && m_pParentDlg->m_gameConfig.lStorageMin > info.lConfigPlayerStorage)
	{
		CString str;
		str.Format(L"玩家库存设置错误，最小:%I64d", (LONGLONG)m_pParentDlg->m_gameConfig.lStorageMin);
		AfxMessageBox(str);
		SetDlgItemValue(IDC_EDIT_CONFIG_ROOM_PLAYER, (LONGLONG)m_pParentDlg->m_gameConfig.lStorageMin);
		return;
	}

	info.lCurSysStorage = info.lConfigSysStorage;
	info.lCurPlayerStorage = info.lConfigPlayerStorage;
	info.lCurParameterK = info.lConfigParameterK;
	info.lCurResetSection = info.lConfigResetSection;
	SendEvent(EventRoomCtrl, sizeof(StorageInfo), (void*)&info);
};
void CDialogDebug::OnCancelRoomTask()
{
	CListCtrl* pList = (CListCtrl*)GetDlgItem(IDC_LIST_ROOM_WORKING_TASK);
	POSITION pos = pList->GetFirstSelectedItemPosition();
	if (!pos)
	{
		AfxMessageBox(L"请选择一条记录!");
		return;
	}
	int nItem = pList->GetNextSelectedItem(pos);

	StorageInfo info;
	ZeroMemory(&info, sizeof(info));
	info.curStatus = CancelCtrl;
	info.nId = _ttoi64(pList->GetItemText(nItem, 0));
	SendEvent(EventRoomCtrl, sizeof(StorageInfo), (void*)&info);
};
void CDialogDebug::OnSetPlayerStorage()
{
	GameDebugInfo info;
	ZeroMemory(&info, sizeof(info));
	info.lConfigSysStorage = GetDlgItemLongLong(IDC_EDIT_CONFIG_PLAYER_SYSTEMSTORAGE);
	if (info.lConfigSysStorage < 0)
	{
		AfxMessageBox(L"系统库存有效输入范围：>0");
		return;
	}
	info.lConfigPlayerStorage = GetDlgItemLongLong(IDC_EDIT_CONFIG_PLAYER_PLAYERSTORAGE);
	if (info.lConfigPlayerStorage < 0)
	{
		AfxMessageBox(L"玩家库存有效输入范围：>0");
		return;
	}
	info.lConfigParameterK = GetDlgItemLongLong(IDC_EDIT_CONFIG_PLAYER_PARAMTERMK);
	if (info.lConfigParameterK <= 0 || info.lConfigParameterK > 100)
	{
		AfxMessageBox(L"调节系数有效输入范围：1~100");
		return;
	}
	info.lConfigResetSection = GetDlgItemLongLong(IDC_EDIT_CONFIG_PLAYER_FORCERESETSECTION);
	if (info.lConfigResetSection <= 0 || info.lConfigResetSection > 100)
	{
		AfxMessageBox(L"强制重置区间有效输入范围：1~100");
		return;
	}
	info.nGameID = GetDlgItemLongLong(IDC_EDIT_CONFIG_PLAYER_DEBUGID);
	if (info.nGameID < 0)
	{
		AfxMessageBox(L"调试ID有效输入范围：>0");
		return;
	}
	if (m_pParentDlg->m_gameConfig.lStorageMin > 0 && m_pParentDlg->m_gameConfig.lStorageMin > info.lConfigPlayerStorage)
	{
		CString str;
		str.Format(L"玩家库存设置错误，最小:%I64d", (LONGLONG)m_pParentDlg->m_gameConfig.lStorageMin);
		AfxMessageBox(str);
		SetDlgItemValue(IDC_EDIT_CONFIG_PLAYER_PLAYERSTORAGE, (LONGLONG)m_pParentDlg->m_gameConfig.lStorageMin);
		return;
	}

	info.lCurSysStorage = info.lConfigSysStorage;
	info.lCurPlayerStorage = info.lConfigPlayerStorage;
	info.lCurParameterK = info.lConfigParameterK;
	info.lCurResetSection = info.lConfigResetSection;
	SendEvent(EventUserCtrl, sizeof(GameDebugInfo), (void*)&info);
};
void CDialogDebug::OnCancelPlayerTask()
{
	CListCtrl* pList = (CListCtrl*)GetDlgItem(IDC_LIST_PLAYER_WORKING_TASK);
	POSITION pos = pList->GetFirstSelectedItemPosition();
	if (!pos)
	{
		AfxMessageBox(L"请选择一条记录!");
		return;
	}
	int nItem = pList->GetNextSelectedItem(pos);

	GameDebugInfo info;
	ZeroMemory(&info, sizeof(info));
	info.curStatus = CancelCtrl;
	info.nGameID = _ttoi64(pList->GetItemText(nItem, 0));
	SendEvent(EventUserCtrl, sizeof(GameDebugInfo), (void*)&info);
};
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
IMPLEMENT_DYNAMIC(CDialogLog, CDialogDexter)
BEGIN_MESSAGE_MAP(CDialogLog, CDialogDexter)
	//ON_BN_CLICKED(IDC_BTN_ROOM_DELETE, OnCancelRoomTask)
	//ON_BN_CLICKED(IDC_BTN_ROOM_DELETE_ALL, OnCancelRoomTaskAll)
	//ON_BN_CLICKED(IDC_BTN_PLAYER_DELETE, OnCancelPlayerTask)
	//ON_BN_CLICKED(IDC_BTN_PLAYER_DELETE_ALL, OnCancelPlayerTaskAll)
	ON_WM_CTLCOLOR()
END_MESSAGE_MAP()

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//日志界面

// 构造函数
CDialogLog::CDialogLog(int nShowMax/* = 0*/, CClientConfigDlg *pParent /*=NULL*/) : CDialogDexter(IDD_CUSTOM_LOG, nShowMax, pParent)
{
}

// 析构函数
CDialogLog::~CDialogLog()
{
}

// 控件绑定
void CDialogLog::DoDataExchange(CDataExchange *pDX)
{
	CDialogDexter::DoDataExchange(pDX);
}

// 消息函数
bool CDialogLog::OnDebugMessage(WORD nMessageID, WORD wTableID, void *pData, WORD nSize)
{
	switch (nMessageID)
	{
	case SUB_S_EVENT_UPDATE:
		return OnDebugEvent(pData, nSize);
	default:
		return false;

	}
	return true;
}

// 初始化窗口
BOOL CDialogLog::OnInitDialog()
{
	// 初始化窗口
	__super::OnInitDialog();

	InitUI();
	return TRUE;
}

HBRUSH CDialogLog::OnCtlColor(CDC* pDC, CWnd* pWnd, UINT nCtlColor)
{
	HBRUSH hbr = __super::OnCtlColor(pDC, pWnd, nCtlColor);

	switch (pWnd->GetDlgCtrlID())
	{
		/*case IDC_STATIC_LOG_TOTAL_PLAYER_WINLOSE:
		{
		pDC->SetTextColor(RGB(255, 0, 0));
		}break;*/
	default:
		break;
	}

	return hbr;
}

//
void CDialogLog::InitUI()
{
	static CFont fontB;
	fontB.CreateFont(15, 7, 0, 0, FW_MEDIUM, FALSE, FALSE, 0, ANSI_CHARSET, OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS,
		DEFAULT_QUALITY,
		DEFAULT_PITCH,
		_T("宋体"));

	//调整控件字体大小
	//
	GetDlgItem(IDC_STATIC_SYS)->SetFont(&fontB);
	GetDlgItem(IDC_STATIC_ROOM)->SetFont(&fontB);
	GetDlgItem(IDC_STATIC_USER)->SetFont(&fontB);

	//系统调试列表
	{
		CListCtrl *pList = (CListCtrl *)GetDlgItem(IDC_LIST_SYSTEM_ALL_TASK);
		pList->SetExtendedStyle(pList->GetExtendedStyle() | LVS_EX_FULLROWSELECT | LVS_EX_GRIDLINES);
		int nColumnCount = 0;
		pList->InsertColumn(nColumnCount++, TEXT("重置次数"), LVCFMT_CENTER, 60);
		pList->InsertColumn(nColumnCount++, TEXT("系统库存"), LVCFMT_CENTER, 70);
		pList->InsertColumn(nColumnCount++, TEXT("玩家库存"), LVCFMT_CENTER, 70);
		pList->InsertColumn(nColumnCount++, TEXT("调节系数%"), LVCFMT_CENTER, 80);
		pList->InsertColumn(nColumnCount++, TEXT("库存统计"), LVCFMT_CENTER, 70);
		pList->InsertColumn(nColumnCount++, TEXT("时间"), LVCFMT_CENTER, 130);
	};
	//房间调试列表
	{
		CListCtrl *pList = (CListCtrl *)GetDlgItem(IDC_LIST_ROOM_ALL_TASK);
		pList->SetExtendedStyle(pList->GetExtendedStyle() | LVS_EX_FULLROWSELECT | LVS_EX_GRIDLINES);
		int nColumnCount = 0;
		pList->InsertColumn(nColumnCount++, TEXT("调试ID"), LVCFMT_CENTER, 60);
		pList->InsertColumn(nColumnCount++, TEXT("系统库存"), LVCFMT_CENTER, 70);
		pList->InsertColumn(nColumnCount++, TEXT("玩家库存"), LVCFMT_CENTER, 70);
		pList->InsertColumn(nColumnCount++, TEXT("调节系数%"), LVCFMT_CENTER, 80);
		pList->InsertColumn(nColumnCount++, TEXT("房间调试统计"), LVCFMT_CENTER, 100);
		pList->InsertColumn(nColumnCount++, TEXT("操作人"), LVCFMT_CENTER, 70);
		pList->InsertColumn(nColumnCount++, TEXT("时间"), LVCFMT_CENTER, 130);
		pList->InsertColumn(nColumnCount++, TEXT("当前状态"), LVCFMT_CENTER, 70);
	};
	//玩家调试列表
	{
		CListCtrl *pList = (CListCtrl *)GetDlgItem(IDC_LIST_PLAYER_ALL_TASK);
		pList->SetExtendedStyle(pList->GetExtendedStyle() | LVS_EX_FULLROWSELECT | LVS_EX_GRIDLINES);
		int nColumnCount = 0;
		pList->InsertColumn(nColumnCount++, TEXT("调试ID"), LVCFMT_CENTER, 60);
		pList->InsertColumn(nColumnCount++, TEXT("系统库存"), LVCFMT_CENTER, 70);
		pList->InsertColumn(nColumnCount++, TEXT("玩家库存"), LVCFMT_CENTER, 70);
		pList->InsertColumn(nColumnCount++, TEXT("调节系数%"), LVCFMT_CENTER, 80);
		pList->InsertColumn(nColumnCount++, TEXT("玩家调试统计"), LVCFMT_CENTER, 100);
		pList->InsertColumn(nColumnCount++, TEXT("操作人"), LVCFMT_CENTER, 70);
		pList->InsertColumn(nColumnCount++, TEXT("时间"), LVCFMT_CENTER, 130);
		pList->InsertColumn(nColumnCount++, TEXT("当前状态"), LVCFMT_CENTER, 70);
	};
};
//
bool CDialogLog::OnDebugEvent(void *pData, WORD nSize)
{
	if (nSize < sizeof(ControlUpdateEvent))
		return false;

	ControlUpdateEvent* pEvent = (ControlUpdateEvent*)pData;
	if (nSize != pEvent->nDataLen + sizeof(ControlUpdateEvent))
		return false;

	switch (pEvent->emEventType)
	{
	case EventSysCtrl:		//系统调试更新
	{
								if (pEvent->nDataLen != sizeof(StorageInfo))
									return true;
								StorageInfo* pInfo = (StorageInfo*)(pEvent+1);
								RefreshSystemTaskList(pInfo);

	}break;
	case EventRoomCtrl:		//房间调试更新
	{
								if (pEvent->nDataLen != sizeof(StorageInfo))
									return true;
								StorageInfo* pInfo = (StorageInfo*)(pEvent+1);
								RefreshRoomTaskList(pInfo);

	}break;
	case EventUserCtrl:			//玩家调试更新
	{
								if (pEvent->nDataLen != sizeof(GameDebugInfo))
									return true;
								GameDebugInfo* pInfo = (GameDebugInfo*)(pEvent+1);
								RefreshPlayerTaskList(pInfo);

	}break;
	default:
		return false;;
	}

	//让所有界面尝试处理消息，多界面可能共享同一数据
	return false;
};
void CDialogLog::RefreshSystemTaskList(StorageInfo* pInfo)
{
	CListCtrl* pList = (CListCtrl*)GetDlgItem(IDC_LIST_SYSTEM_ALL_TASK);
	//列表位置即为记录索引...

	//首条显示当前执行条目,其它条目整体下移
	if (pList->GetItemCount() == 0)
	{
		CString str;
		str.Format(L"%d", pInfo->lResetTimes);
		pList->InsertItem(0, str);
	}

	//只显示执行态或待执行态任务
	int nColumn = -1;
	if (pList->GetItemCount() > pInfo->nId + 1)
		nColumn = pInfo->nId + 1;
	if (pInfo->curStatus == AlreadyInCtrl || pInfo->curStatus == DoneCtrl)
		nColumn = 0;

	if (pInfo->curStatus != AlreadyInCtrl && pInfo->curStatus != WaitForCtrl)
	{
		if (pInfo->curStatus == NullStatus)	return;
		//删除条目
		if (pInfo->curStatus == RemoveCtrl) 
		{
			if (nColumn >= 0)
				pList->DeleteItem(nColumn);
			else if (pList->GetItemCount() == 0)
				pList->DeleteItem(0);
			return;
		}
	}

	//新增条目
	if (nColumn < 0)
	{
		nColumn = pList->GetItemCount();

		CString str;
		str.Format(L"%d", pInfo->lResetTimes);
		pList->InsertItem(nColumn, str);
	}

	int nCurSetIndex = 0;
	SetListItemValue(pList, nColumn, nCurSetIndex++, pInfo->lResetTimes);
	SetListItemValue(pList, nColumn, nCurSetIndex++, pInfo->lCurSysStorage);
	SetListItemValue(pList, nColumn, nCurSetIndex++, pInfo->lCurPlayerStorage);
	SetListItemValue(pList, nColumn, nCurSetIndex++, pInfo->lCurParameterK);
	SetListItemValue(pList, nColumn, nCurSetIndex++, pInfo->lSysCtrlSysWin - pInfo->lSysCtrlPlayerWin);
	CString str;
	CTime time(pInfo->lUpdateTime);
	str.Format(TEXT("%d-%02d-%02d %02d:%02d:%02d"), time.GetYear(), time.GetMonth(), time.GetDay(), time.GetHour(), time.GetMinute(), time.GetSecond());
	SetListItemValue(pList, nColumn, nCurSetIndex++, str);
};
void CDialogLog::RefreshRoomTaskList(StorageInfo* pInfo)
{
	CListCtrl* pList = (CListCtrl*)GetDlgItem(IDC_LIST_ROOM_ALL_TASK);
	//只显示执行态或待执行态任务
	int nColumn = GetListTargetColumn(pList, pInfo->nId, 0);

	if (pInfo->curStatus != CancelCtrl && pInfo->curStatus != DoneCtrl)
	{
		if (pInfo->curStatus == NullStatus)	return;
		//删除条目
		if (nColumn >= 0 && pInfo->curStatus == RemoveCtrl)
		{
			pList->DeleteItem(nColumn);
			return;
		}

		return;
	}

	//新增条目
	if (nColumn < 0)
	{
		nColumn = pList->GetItemCount();

		CString str;
		str.Format(L"%d", pInfo->nId);
		pList->InsertItem(nColumn, str);
	}

	int nCurSetIndex = 1;
	SetListItemValue(pList, nColumn, nCurSetIndex++, pInfo->lCurSysStorage);
	SetListItemValue(pList, nColumn, nCurSetIndex++, pInfo->lCurPlayerStorage);
	SetListItemValue(pList, nColumn, nCurSetIndex++, pInfo->lCurParameterK);
	SetListItemValue(pList, nColumn, nCurSetIndex++, pInfo->lSysCtrlSysWin - pInfo->lSysCtrlPlayerWin);
	SetListItemValue(pList, nColumn, nCurSetIndex++, pInfo->lOperateUser);

	CString str;
	CTime time(pInfo->lUpdateTime);
	str.Format(TEXT("%d-%02d-%02d %02d:%02d:%02d"), time.GetYear(), time.GetMonth(), time.GetDay(), time.GetHour(), time.GetMinute(), time.GetSecond());
	SetListItemValue(pList, nColumn, nCurSetIndex++, str);

	switch (pInfo->curStatus)
	{
	case CancelCtrl:str = L"已取消"; break;
	case WaitForCtrl:str = L"队列中"; break;
	case AlreadyInCtrl:str = L"进行中"; break;
	case DoneCtrl:str = L"已完成"; break;
	default:
		break;
	}
	SetListItemValue(pList, nColumn, nCurSetIndex++, str);
	
};
void CDialogLog::RefreshPlayerTaskList(GameDebugInfo* pInfo)
{
	CListCtrl* pList = (CListCtrl*)GetDlgItem(IDC_LIST_PLAYER_ALL_TASK);
	
	int nColumn = GetListTargetColumn(pList, pInfo->nGameID, 0);

	if (pInfo->curStatus != CancelCtrl && pInfo->curStatus != DoneCtrl)
	{
		if (pInfo->curStatus == NullStatus)	return;
		//删除条目
		if (nColumn >= 0 && pInfo->curStatus == RemoveCtrl)
		{
			pList->DeleteItem(nColumn);
			return;
		}

		return;
	}

	//新增条目
	if (nColumn < 0)
	{
		nColumn = pList->GetItemCount();

		CString str;
		str.Format(L"%d", pInfo->nGameID);
		pList->InsertItem(nColumn, str);
	}

	int nCurSetIndex = 1;
	SetListItemValue(pList, nColumn, nCurSetIndex++, pInfo->lCurSysStorage);
	SetListItemValue(pList, nColumn, nCurSetIndex++, pInfo->lCurPlayerStorage);
	SetListItemValue(pList, nColumn, nCurSetIndex++, pInfo->lCurParameterK);
	SetListItemValue(pList, nColumn, nCurSetIndex++, pInfo->lSysCtrlSysWin - pInfo->lSysCtrlPlayerWin);
	SetListItemValue(pList, nColumn, nCurSetIndex++, pInfo->lOperateUser);

	CString str;
	CTime time(pInfo->lUpdateTime);
	str.Format(TEXT("%d-%02d-%02d %02d:%02d:%02d"), time.GetYear(), time.GetMonth(), time.GetDay(), time.GetHour(), time.GetMinute(), time.GetSecond());
	SetListItemValue(pList, nColumn, nCurSetIndex++, str);

	switch (pInfo->curStatus)
	{
	case CancelCtrl:str = L"已取消"; break;
	//case WaitForCtrl:str = L"队列中"; break;
	case WaitForCtrl:
	case AlreadyInCtrl:str = L"进行中"; break;
	case DoneCtrl:str = L"已完成"; break;
	default:
		break;
	}
	SetListItemValue(pList, nColumn, nCurSetIndex++, str);
};
void CDialogLog::OnCancelRoomTask()
{
	CListCtrl* pList = (CListCtrl*)GetDlgItem(IDC_LIST_ROOM_ALL_TASK);
	POSITION pos = pList->GetFirstSelectedItemPosition();
	if (!pos)
	{
		AfxMessageBox(L"请选择一条记录!");
		return;
	}
	int nItem = pList->GetNextSelectedItem(pos);

	StorageInfo info;
	ZeroMemory(&info, sizeof(info));
	info.curStatus = RemoveCtrl;
	info.nId = _ttoi64(pList->GetItemText(nItem, 0));
	SendEvent(EventRoomCtrl, sizeof(StorageInfo), (void*)&info);
};
void CDialogLog::OnCancelRoomTaskAll()
{
	StorageInfo info;
	ZeroMemory(&info, sizeof(info));
	info.curStatus = RemoveCtrl;
	info.nId = -1;
	SendEvent(EventRoomCtrl, sizeof(StorageInfo), (void*)&info);
};
void CDialogLog::OnCancelPlayerTask()
{
	CListCtrl* pList = (CListCtrl*)GetDlgItem(IDC_LIST_PLAYER_ALL_TASK);
	POSITION pos = pList->GetFirstSelectedItemPosition();
	if (!pos)
	{
		AfxMessageBox(L"请选择一条记录!");
		return;
	}
	int nItem = pList->GetNextSelectedItem(pos);

	GameDebugInfo info;
	ZeroMemory(&info, sizeof(info));
	info.curStatus = RemoveCtrl;
	info.nGameID = _ttoi64(pList->GetItemText(nItem, 0));
	SendEvent(EventUserCtrl, sizeof(GameDebugInfo), (void*)&info);
};
void CDialogLog::OnCancelPlayerTaskAll()
{
	GameDebugInfo info;
	ZeroMemory(&info, sizeof(info));
	info.curStatus = RemoveCtrl;
	info.nGameID = -1;
	SendEvent(EventUserCtrl, sizeof(GameDebugInfo), (void*)&info);
};
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

IMPLEMENT_DYNAMIC(CDialogWeight, CDialogDexter)
BEGIN_MESSAGE_MAP(CDialogWeight, CDialogDexter)
	ON_BN_CLICKED(IDC_BUTTON_CONFIG_WEIGHT, OnWieightConfigSet)
	ON_WM_CLOSE()
	ON_WM_CTLCOLOR()
END_MESSAGE_MAP()
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//权重界面

// 构造函数
CDialogWeight::CDialogWeight(int nShowMax/* = 0*/, CClientConfigDlg *pParent /*=NULL*/) : CDialogDexter(IDD_CUSTOM_WEIGHT, nShowMax, pParent)
{
	m_bInit = false;
}

// 析构函数
CDialogWeight::~CDialogWeight()
{
}

// 控件绑定
void CDialogWeight::DoDataExchange(CDataExchange *pDX)
{
	CDialogDexter::DoDataExchange(pDX);
}

bool CDialogWeight::OnDebugMessage(WORD nMessageID, WORD wTableID, void *pData, WORD nSize)
{
	switch (nMessageID)
	{
	case SUB_S_EVENT_UPDATE:
		return OnDebugEvent(pData, nSize);
	default:
		return false;
	}

	return true;
}

// 初始化窗口
BOOL CDialogWeight::OnInitDialog()
{
	// 初始化窗口
	__super::OnInitDialog();

	InitUI();
	return TRUE;
}
HBRUSH CDialogWeight::OnCtlColor(CDC* pDC, CWnd* pWnd, UINT nCtlColor)
{
	HBRUSH hbr = __super::OnCtlColor(pDC, pWnd, nCtlColor);

	return hbr;
}
afx_msg void CDialogWeight::OnClose()
{
	((CClientConfigDlg*)m_pParentWnd)->OnWieightDestory();
	__super::OnClose();
};

void CDialogWeight::InitUI()
{
	//发送更新请求
	//m_pParentWnd->SendDebugMessage(SUB_C_S_UPDATE_WIGHT_CONFIG);
}
//
bool CDialogWeight::OnDebugEvent(void *pData, WORD nSize)
{
	if (nSize <= sizeof(ControlUpdateEvent))
		return false;

	ControlUpdateEvent* pEvent = (ControlUpdateEvent*)pData;
	if (nSize != pEvent->nDataLen + sizeof(ControlUpdateEvent))
		return false;

	switch (pEvent->emEventType)
	{
	case EventGameWeightConfig:		//权重配置
	{
								if (pEvent->nDataLen%sizeof(WeightConfig) != 0 )
									return true;
								WeightConfig* pInfo = (WeightConfig*)(pEvent+1);
								RefreshWeightConfig(pInfo, pEvent->nDataLen/sizeof(WeightConfig));

	}break;
	default:
		return false;;
	}

	//让所有界面尝试处理消息，多界面可能共享同一数据
	return false;
};

void CDialogWeight::RefreshWeightConfig(WeightConfig* pInfo, int nSize)
{
	for (int i = 0; i < nSize; ++i)
	{
		WeightConfig& cfg = *(pInfo+i);
		ASSERT(cfg.lIndex < WEIGHT_CONFIG_MAX_SZIE);
		if (cfg.lIndex >= WEIGHT_CONFIG_MAX_SZIE)
			continue;

		//倍数描述
		if (!m_bInit)
		{
			CString str;
			if (cfg.lMaxTimes < 0)	str.Format(TEXT("中%I64d倍以上权重"), cfg.lMinTimes);
			else if (cfg.lMaxTimes > 0)	str.Format(TEXT("中%I64d倍~%I64d倍权重"), cfg.lMinTimes, cfg.lMaxTimes);
			else if (cfg.lMaxTimes == 0)	str.Format(TEXT("中%I64d倍权重"), cfg.lMinTimes);
			SetDlgItemText(IDC_STATIC_TYPE + cfg.lIndex * 3, str);
		}

		SetDlgItemValue(IDC_STATIC_TYPE + cfg.lIndex * 3 + 1, cfg.lWeight);
		SetDlgItemValue(IDC_STATIC_TYPE + cfg.lIndex * 3 + 2, cfg.lRatio);
	}
};
void CDialogWeight::OnWieightConfigSet()
{
	WeightConfig info[WEIGHT_CONFIG_MAX_SZIE];
	ZeroMemory(info, sizeof(info));

	for (int i = 0; i < WEIGHT_CONFIG_MAX_SZIE; ++i)
	{
		WeightConfig& cfg = info[i];
		LONGLONG lWeight = GetDlgItemLongLong(IDC_STATIC_TYPE + i * 3 + 1);
		if (lWeight < 1 || lWeight > 1000)
		{
			CString str;
			GetDlgItemText(IDC_STATIC_TYPE + i * 3, str);
			str.AppendFormat(TEXT("  -- 无效权重配置！"));
			AfxMessageBox(str, MB_ICONSTOP);
			return;
		}
		cfg.lIndex = i;
		cfg.lWeight = lWeight;
	}

	SendEvent(EventGameWeightConfig, sizeof(info), (void*)info);
};

// 创建函数
bool CDialogWeight::Create(CWnd *pParentWnd)
{
	// 创建窗口
	__super::Create(IDD_CUSTOM_WEIGHT, pParentWnd);

	// 关闭窗口
	__super::ShowWindow(SW_HIDE);
	return true;
};
// 显示窗口
bool CDialogWeight::ShowWindow(bool bShow)
{
	return __super::ShowWindow(bShow ? SW_SHOW : SW_HIDE);
};
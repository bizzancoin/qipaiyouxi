// CoinDozerConfigDlg.cpp : 实现文件
//

#include "stdafx.h"
#include "Resource.h"
#include "ClientConfigDlg.h"
#include <math.h>

//////////////////////////////////////////////////////////////////////////////////


BYTE g_cbExecuteTimesArray[MAX_EXECUTE_TIMES] = { 1, 3, 5, 10, 15 };

// 调试对话框
IMPLEMENT_DYNAMIC(CClientConfigDlg, CDialog)
BEGIN_MESSAGE_MAP(CClientConfigDlg, CDialog)
	ON_WM_DESTROY()
    ON_NOTIFY(TCN_SELCHANGE, IDC_TAB_CUSTOM, OnTcnSelchangeTabOptisons)
  
END_MESSAGE_MAP()

//////////////////////////////////////////////////////////////////////////////////

// 构造函数
CClientConfigDlg::CClientConfigDlg(CWnd *pParent /*=NULL*/) : CDialog(IDD_DIALOG_MAIN, pParent)
{
    // 设置变量
    m_pParentWnd = NULL;
    m_pIClientDebugCallback = NULL;
    m_DialogSetting = NULL;
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

    delete m_DialogSetting;

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
    pTabCtrl->InsertItem(0, _T("基本设置"));
    pTabCtrl->InsertItem(1, _T("调试设置"));
	pTabCtrl->InsertItem(2, _T("日志记录"));
    pTabCtrl->SetCurSel(0);

    // 获取分页
    CRect RectWindow;
    CWnd *pWindowShow = GetDlgItem(IDC_STATIC_SHOW);
    pWindowShow->ShowWindow(SW_HIDE);
    pWindowShow->GetWindowRect(RectWindow);
    ScreenToClient(RectWindow);

    // 创建窗口
    m_DialogCustom[CUSTOM_GENERAL] = new CDialogGeneral(RectWindow.Height(), this);
    m_DialogCustom[CUSTOM_GENERAL]->Create(IDD_CUSTOM_GENERAL, this);

    m_DialogCustom[CUSTOM_CONTROL] = new CDialogControl(RectWindow.Height(), this);
    m_DialogCustom[CUSTOM_CONTROL]->Create(IDD_CUSTOM_CONTROL, this);

	m_DialogCustom[CUSTOM_ADVANCED] = new CDialogAdvanced(RectWindow.Height(), this);
	m_DialogCustom[CUSTOM_ADVANCED]->Create(IDD_CUSTOM_ADVANCED, this);

  

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

    if(m_DialogSetting != NULL)
    {
        m_DialogSetting->OnDebugMessage(nMessageID, wTableID, pData, nSize);
          
    }

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

		if (nCurSel == CUSTOM_ADVANCED)
		{
			SendDebugMessage(SUB_C_ADVANCED_REFRESH_ALLCTRLLIST);
		}
      
    }

    *pResult = 0;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// 调试对话框
BEGIN_MESSAGE_MAP(CDialogGeneral, CDialogDexter)
	ON_BN_CLICKED(IDC_BUTTON_SETRULE, OnBnClickedButtonSetRule)
	ON_NOTIFY(LVN_ITEMCHANGED, IDC_LIST_ROOM, OnLvnItemchangedListRoom)
	
	ON_EN_CHANGE(IDC_EDIT_ROOMCTRL_SYSSTORAGE, OnEnChangeEditRoomctrlSysstorage)
	ON_EN_CHANGE(IDC_EDIT_ROOMCTRL_PLAYERSTORAGE, OnEnChangeEditRoomctrlPlayerstorage)
	ON_EN_CHANGE(IDC_EDIT_ROOMCTRL_PARAMETER_K, OnEnChangeEditRoomctrlParameterK)
	
	ON_WM_CTLCOLOR()
  

ON_BN_CLICKED(IDC_BUTTON_CHOU, &CDialogGeneral::OnBnClickedButtonChou)
ON_BN_CLICKED(IDC_BTN_SET_ROOMCTRL, &CDialogGeneral::OnBnClickedBtnSetRoomctrl)
ON_BN_CLICKED(IDC_BUTTON_CANCELL_ROOM, &CDialogGeneral::OnBnClickedButtonCancellRoom)
END_MESSAGE_MAP()

// 构造函数
CDialogGeneral::CDialogGeneral(int nShowMax/* = 0*/, CClientConfigDlg *pParent /*=NULL*/) : CDialogDexter(IDD_CUSTOM_GENERAL, nShowMax, pParent)
{
    
}

// 析构函数
CDialogGeneral::~CDialogGeneral()
{
}

// 控件绑定
void CDialogGeneral::DoDataExchange(CDataExchange *pDX)
{
	CDialogDexter::DoDataExchange(pDX);
}

void CDialogGeneral::DDX_DOUBLE(CDataExchange* pDX, int nIDC, DOUBLE &value)
{
    CString cc;
    if(pDX->m_bSaveAndValidate)
    {
        GetDlgItemText(nIDC, cc);
        cc.Format(_T("%I64d"), _wtof(cc));
        value = _wtof(cc);
    }
    else
    {
        cc.Format(_T("%I64d"), value);
        SetDlgItemText(nIDC, cc);
    }
}

bool CDialogGeneral::OnDebugMessage(WORD nMessageID, WORD wTableID, void *pBuffer, WORD wDataSize)
{
	switch (nMessageID)
	{
        case SUB_S_ALL_WINLOST_INFO:
        {
            ASSERT(wDataSize == sizeof(CMD_S_RefreshWinTotal));
            if(wDataSize != sizeof(CMD_S_RefreshWinTotal))
            {
                return false;
            }
            CMD_S_RefreshWinTotal *p_SysWin = (CMD_S_RefreshWinTotal *)pBuffer;

            CString str;
            str.Format(L"%I64d",p_SysWin->lSysWin);
            SetDlgItemText(IDC_EDIT_SYS_WINTOTAL,str );
            str.Format(L"%I64d", p_SysWin->lTotalServiceWin);
            SetDlgItemText( IDC_SERVICE_SYS_WINTOTAL, str);
            str.Format(L"%I64d", p_SysWin->lTotalChouShui);
            SetDlgItemText(IDC_EDIT_ANCHOU_TOTAL,str);
            str.Format(L"%I64d", p_SysWin->lTotalRoomCtrlWin);
            SetDlgItemText(IDC_EDIT_ROOM_TOTAL, str);
            
            SetDlgItemInt(IDC_EDIT_ANCHOU_PERCENT_CUR, p_SysWin->lChouPercent);

            if(p_SysWin->bIsCleanRoomCtrl)
            {
               /* SetDlgItemText(IDC_STATIC_ROOMCTRL_ID, L"");
                SetDlgItemText(IDC_STATIC_ROOMCTRL_SYSSTORAGE, L"");
                SetDlgItemText(IDC_STATIC_ROOMCTRL_PLAYERSTORAGE, L"");
                SetDlgItemText(IDC_STATIC_ROOMCTRL_PARAMETER_K, L"");
                SetDlgItemText(IDC_EDIT_RESET_PERCENT_ROOM, L"");
                SetDlgItemText(IDC_STATIC_ROOM_CTRLDESC, L"");

                CListCtrl *pListCtrlRoom = (CListCtrl *)GetDlgItem(IDC_LIST_ROOM_ITEM);
                pListCtrlRoom->DeleteAllItems();*/
            }
           

            return true;
        }
  
	case SUB_S_REFRESH_RULE_RESULT:
	    {
		    ASSERT(wDataSize == sizeof(CMD_S_RefreshRuleResult));
		    if (wDataSize != sizeof(CMD_S_RefreshRuleResult))
		    {
			    return false;
		    }

		    CMD_S_RefreshRuleResult *pRefreshRuleResult = (CMD_S_RefreshRuleResult *)pBuffer;

            CString str;
            str.Format(L"%I64d", pRefreshRuleResult->lCurSysStorage);
            SetDlgItemText(IDC_STATIC_CUR_SYSSTORAGE,str);
		  
            str.Format(L"%I64d", pRefreshRuleResult->lCurPlayerStorage);
            SetDlgItemText(IDC_STATIC_CUR_PLAYERSTORAGE, str);

            str.Format(L"%I64d", pRefreshRuleResult->lSysCtrlSysWin - pRefreshRuleResult->lSysCtrlPlayerWin);
            SetDlgItemText(IDC_STATIC_SYSCTRL_SYSWIN, str);

            SetDlgItemInt(IDC_STATIC_CUR_PARAMETER_K, pRefreshRuleResult->lCurParameterK);
            SetDlgItemInt(IDC_STATIC_SYS_RESET_PERCENT, pRefreshRuleResult->lResetParameterK);
            SetDlgItemInt(IDC_STATIC_SYSCTRL_RESETCOUNT, pRefreshRuleResult->lStorageResetCount); 

		    UpdateSysCtrlDesc();

		    return true;
	    }
	case SUB_S_SET_RULE_RESULT:
	    {
		    ASSERT(wDataSize == sizeof(CMD_S_SetRuleResult));
		    if (wDataSize != sizeof(CMD_S_SetRuleResult))
		    {
			    return false;
		    }

		    CMD_S_SetRuleResult *pSetRuleResult = (CMD_S_SetRuleResult *)pBuffer;

            CString str;
            str.Format(L"%I64d", pSetRuleResult->lConfigSysStorage);
            SetDlgItemText(IDC_STATIC_CUR_SYSSTORAGE, str);

            str.Format(L"%I64d", pSetRuleResult->lConfigPlayerStorage);
            SetDlgItemText(IDC_STATIC_CUR_PLAYERSTORAGE, str);

            SetDlgItemInt(IDC_STATIC_CUR_PARAMETER_K, pSetRuleResult->lConfigParameterK);
            SetDlgItemInt(IDC_STATIC_SYS_RESET_PERCENT, pSetRuleResult->lResetParameterK);
            SetDlgItemInt(IDC_STATIC_SYSCTRL_RESETCOUNT,0);

            UpdateSysCtrlDesc();

		    return true;
	    }

    case SUB_S_CUR_ROOMCTRL_INFO:
        {
            //校验大小
            ASSERT(sizeof(CMD_S_CurRoomCtrlInfo) == wDataSize);
            if(sizeof(CMD_S_CurRoomCtrlInfo) != wDataSize)
            {
                return false;
            }

            // 定义信息
            CMD_S_CurRoomCtrlInfo *pCurRoomCtrlInfo = (CMD_S_CurRoomCtrlInfo *)pBuffer;

            SetDlgItemInt(IDC_STATIC_ROOMCTRL_ID, pCurRoomCtrlInfo->dwCtrlIndex);

            CString str;

            str.Format(L"%I64d", pCurRoomCtrlInfo->lRoomCtrlSysStorage);
            SetDlgItemText(IDC_STATIC_ROOMCTRL_SYSSTORAGE, str);

            str.Format(L"%I64d", pCurRoomCtrlInfo->lRoomCtrlPlayerStorage);
            SetDlgItemText(IDC_STATIC_ROOMCTRL_PLAYERSTORAGE, str);

            SetDlgItemInt(IDC_STATIC_ROOMCTRL_PARAMETER_K, pCurRoomCtrlInfo->lRoomCtrlParameterK);
            SetDlgItemInt(IDC_EDIT_RESET_PERCENT_ROOM, pCurRoomCtrlInfo->lRoomResetParameterK);

            str.Format(L"%I64d", pCurRoomCtrlInfo->lRoomCtrlSysWin - pCurRoomCtrlInfo->lRoomCtrlPlayerWin);
            SetDlgItemText(IDC_STATIC_ROOMCTRL_SYSWIN2, str);

            UpdateRoomCtrlDesc(pCurRoomCtrlInfo->lRoomCtrlSysStorage, pCurRoomCtrlInfo->lRoomCtrlPlayerStorage, pCurRoomCtrlInfo->lRoomCtrlParameterK);

            return true;
        }
    case SUB_S_ADD_ROOM_ITEM_INFO:
        {
            ASSERT(wDataSize % sizeof(ROOMCTRL_ITEM) == 0);
            if(wDataSize % sizeof(ROOMCTRL_ITEM) != 0)
            {
                return false;
            }
            //定义信息
            ROOMCTRL_ITEM *pData = (ROOMCTRL_ITEM *)pBuffer;

            CListCtrl *pListCtrlRoom = (CListCtrl *)GetDlgItem(IDC_LIST_ROOM_ITEM);

            pListCtrlRoom->DeleteAllItems();

          
            CString strCtrlIndex;
            strCtrlIndex.Format(TEXT("%d"), pData->dwCtrlIndex);
            pListCtrlRoom->InsertItem(0, strCtrlIndex);
            CString strCtrlVal;
            strCtrlVal.Format(TEXT("%I64d"), pData->lRoomCtrlInitialSysStorage);
            pListCtrlRoom->SetItemText(0, 1, strCtrlVal);

            strCtrlVal.Format(TEXT("%I64d"), pData->lRoomCtrlInitialPlayerStorage);
            pListCtrlRoom->SetItemText(0, 2, strCtrlVal);

            strCtrlVal.Format(TEXT("%I64d"), pData->lRoomCtrlParameterK);
            pListCtrlRoom->SetItemText(0, 3, strCtrlVal);

            strCtrlVal.Format(TEXT("%I64d"), pData->lRoomResetParameterK);
            pListCtrlRoom->SetItemText(0, 4, strCtrlVal);

            strCtrlVal.Format(TEXT("%I64d"), pData->lUserCtrlSysWin - pData->lUserCtrlPlayerWin);
            pListCtrlRoom->SetItemText(0, 5, strCtrlVal);

            if(pData->lUserCtrlSysWin == pData->lUserCtrlPlayerWin)
            {
                pListCtrlRoom->SetItemText(0, 6, TEXT("等待执行"));
            }
            else
            {
                pListCtrlRoom->SetItemText(0, 6, TEXT("进行中"));
            }
           
            
            return true;

        }
    case SUB_REFRESH_ROOM_CTRL:
        {
            ASSERT(wDataSize % sizeof(ROOMCTRL_ITEM) == 0);
            if(wDataSize % sizeof(ROOMCTRL_ITEM) != 0)
            {
                return false;
            }

            CListCtrl *pListCtrlRoom = (CListCtrl *)GetDlgItem(IDC_LIST_ROOM_ITEM);

            //定义信息
            ROOMCTRL_ITEM *pRoomCtrlResult = (ROOMCTRL_ITEM *)pBuffer;

            CString strCtrlIndex;
            strCtrlIndex.Format(TEXT("%d"), pRoomCtrlResult->dwCtrlIndex);

            CString strCtrlVal;
            strCtrlVal.Format(TEXT("%I64d"), pRoomCtrlResult->lRoomCtrlInitialSysStorage);
            pListCtrlRoom->SetItemText(0, 1, strCtrlVal);

            strCtrlVal.Format(TEXT("%I64d"), pRoomCtrlResult->lRoomCtrlInitialPlayerStorage);
            pListCtrlRoom->SetItemText(0, 2, strCtrlVal);

            strCtrlVal.Format(TEXT("%I64d"), pRoomCtrlResult->lUserCtrlSysWin - pRoomCtrlResult->lUserCtrlPlayerWin);
            pListCtrlRoom->SetItemText(0, 5, strCtrlVal);

          
            pListCtrlRoom->SetItemText(0, 6, TEXT("进行中"));
           
          
            return true;
        }

	case  SUB_S_DEBUG_TEXT:
	    {
		    //校验大小
		    ASSERT(sizeof(CMD_S_DebugText) == wDataSize);
		    if (sizeof(CMD_S_DebugText) != wDataSize)
		    {
			    return false;
		    }

		    // 定义信息
		    CMD_S_DebugText *pDebugText = (CMD_S_DebugText *)pBuffer;

		    return true;
	    }
    case SUB_S_CLEAR_ROOM_CTRL:
        {
             SetDlgItemText(IDC_STATIC_ROOMCTRL_ID, L"");
            SetDlgItemText(IDC_STATIC_ROOMCTRL_SYSSTORAGE, L"");
            SetDlgItemText(IDC_STATIC_ROOMCTRL_PLAYERSTORAGE, L"");
            SetDlgItemText(IDC_STATIC_ROOMCTRL_PARAMETER_K, L"");
            SetDlgItemText(IDC_EDIT_RESET_PERCENT_ROOM, L"");
            SetDlgItemText(IDC_STATIC_ROOM_CTRLDESC, L"");

            CListCtrl *pListCtrlRoom = (CListCtrl *)GetDlgItem(IDC_LIST_ROOM_ITEM);
            pListCtrlRoom->DeleteAllItems();
        }
	    default:
		break;
	}

	return false;
}

// 初始化窗口
BOOL CDialogGeneral::OnInitDialog()
{
	// 初始化窗口
	__super::OnInitDialog();

	//限制输入
	((CEdit *)GetDlgItem(IDC_EDIT_CONFIG_SYSSTORAGE))->LimitText(9);
	((CEdit *)GetDlgItem(IDC_EDIT_CONFIG_PLAYERSTORAGE))->LimitText(9);
	((CEdit *)GetDlgItem(IDC_EDIT_CONFIG_PARAMETER_K))->LimitText(3);

    //房间调试选项
    CListCtrl *pListRoomCtrl = (CListCtrl *)GetDlgItem(IDC_LIST_ROOM_ITEM);
    pListRoomCtrl->SetExtendedStyle(pListRoomCtrl->GetExtendedStyle() | LVS_EX_FULLROWSELECT | LVS_EX_GRIDLINES);

    int  nColumnCount = 0;
    pListRoomCtrl->InsertColumn(nColumnCount++, TEXT("调试ID"), LVCFMT_CENTER, 50);
    pListRoomCtrl->InsertColumn(nColumnCount++, TEXT("系统库存"), LVCFMT_CENTER, 80);
    pListRoomCtrl->InsertColumn(nColumnCount++, TEXT("玩家库存"), LVCFMT_CENTER, 80);
    pListRoomCtrl->InsertColumn(nColumnCount++, TEXT("调节系数"), LVCFMT_CENTER, 60);
    pListRoomCtrl->InsertColumn(nColumnCount++, TEXT("重置区间"), LVCFMT_CENTER, 60);
    pListRoomCtrl->InsertColumn(nColumnCount++, TEXT("系统输赢"), LVCFMT_CENTER, 80);
    pListRoomCtrl->InsertColumn(nColumnCount++, TEXT("当前状态"), LVCFMT_CENTER, 60);
    
	//刷新
	SendDebugMessage(SUB_C_REFRESH_RULE);

    m_FontFrame.CreateFont(18, 10, 0, 0, FW_MEDIUM, FALSE, FALSE, 0, ANSI_CHARSET, OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS,
                           DEFAULT_QUALITY,
                           DEFAULT_PITCH,
                           _T("宋体"));

    m_Font.CreateFont(15, 7, 0, 0, FW_MEDIUM, FALSE, FALSE, 0, ANSI_CHARSET, OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS,
                      DEFAULT_QUALITY,
                      DEFAULT_PITCH,
                      _T("宋体"));


    GetDlgItem(IDC_STATIC_SYS)->SetFont(&m_Font);
    GetDlgItem(IDC_STATIC_ROOM_T3)->SetFont(&m_Font);
    GetDlgItem(IDC_STATIC_SET)->SetFont(&m_Font);


    GetDlgItem(IDC_STATIC_TONGJI)->SetFont(&m_FontFrame);
    GetDlgItem(IDC_STATIC_REVENUE)->SetFont(&m_FontFrame);
    GetDlgItem(IDC_EDIT_SYS_WINTOTAL)->SetFont(&m_FontFrame);
    GetDlgItem(IDC_SERVICE_SYS_WINTOTAL)->SetFont(&m_FontFrame);

   
	return TRUE;
}

bool CDialogGeneral::IsValidNum(CString strEdit)
{
    SCORE lScoreValue = _wtof(strEdit);
    CString strCmp;
    strCmp.Format(L"%I64d", lScoreValue);

    if(strCmp == strEdit)
    {
        return true;
    }

    SCORE lScoreVal = _ttoi64(strEdit);
    strCmp.Format(TEXT("%I64d"), lScoreVal);

    return strCmp == strEdit;
}

void CDialogGeneral::OnBnClickedButtonSetRule()
{
	UpdateData(TRUE);
   
    CString strRoomCtrlParameterK;
    GetDlgItemText(IDC_EDIT_CONFIG_PARAMETER_K, strRoomCtrlParameterK);
    strRoomCtrlParameterK.TrimLeft();
    strRoomCtrlParameterK.TrimRight();

    if(!IsValidNum(strRoomCtrlParameterK) || strRoomCtrlParameterK == TEXT("0") || strRoomCtrlParameterK.IsEmpty())
    {
        MessageBox(TEXT("调节系数填写无效！"), TEXT("温馨提示"));
        return;
    }

    LPTSTR lpszRoomCtrlParameterK = new TCHAR[strRoomCtrlParameterK.GetLength() + 1];
    _tcscpy_s(lpszRoomCtrlParameterK, strRoomCtrlParameterK.GetLength() + 1, strRoomCtrlParameterK);
    SCORE lRoomCtrlParameterK = _ttoi64(lpszRoomCtrlParameterK);

    //校验
    if(!(lRoomCtrlParameterK > 0 && lRoomCtrlParameterK <= 100))
    {
        AfxMessageBox(TEXT("调节系数范围0~100，请重新设置！"), MB_ICONSTOP);
      
        return;
    }
    if(GetDlgItemInt(IDC_EDIT_RESET_PERCENT) < 0 || GetDlgItemInt(IDC_EDIT_RESET_PERCENT) > 99)
    {
        AfxMessageBox(TEXT("强制重置区间范围0~99，请重新设置！"), MB_ICONSTOP);

        return;
    }


    CMD_C_SetRule SetRule;
    ZeroMemory(&SetRule, sizeof(SetRule));

    SetRule.lConfigSysStorage = GetDlgItemInt(IDC_EDIT_CONFIG_SYSSTORAGE);
    SetRule.lConfigPlayerStorage = GetDlgItemInt(IDC_EDIT_CONFIG_PLAYERSTORAGE);
    SetRule.lConfigParameterK = GetDlgItemInt(IDC_EDIT_CONFIG_PARAMETER_K);
    SetRule.lResetParameterK = GetDlgItemInt(IDC_EDIT_RESET_PERCENT);
   

    SendDebugMessage(SUB_C_SET_RULE, &SetRule, sizeof(SetRule));

	return;
}

void CDialogGeneral::OnLvnItemchangedListRoom(NMHDR *pNMHDR, LRESULT *pResult)
{
	LPNMLISTVIEW pNMLV = reinterpret_cast<LPNMLISTVIEW>(pNMHDR);

	if ((pNMLV->uChanged == LVIF_STATE) && (pNMLV->uNewState & LVIS_SELECTED))
	{
		//处理内容
		int nItem = pNMLV->iItem;
		if (nItem >= 0)
		{
			CListCtrl *pListCtrlRoom = (CListCtrl *)GetDlgItem(IDC_LIST_ROOM);

			SetDlgItemText(IDC_EDIT_ROOMCTRL_SYSSTORAGE, pListCtrlRoom->GetItemText(nItem, 1));
			SetDlgItemText(IDC_EDIT_ROOMCTRL_PLAYERSTORAGE, pListCtrlRoom->GetItemText(nItem, 2));
			SetDlgItemText(IDC_EDIT_ROOMCTRL_PARAMETER_K, pListCtrlRoom->GetItemText(nItem, 3));

		}
	}

	*pResult = 0;
}

void CDialogGeneral::UpdateSysCtrlDesc()
{
	CString strCurSysStorage;
	GetDlgItemText(IDC_STATIC_CUR_SYSSTORAGE, strCurSysStorage);
	strCurSysStorage.TrimLeft();
	strCurSysStorage.TrimRight();

	CString strCurPlayerStorage;
	GetDlgItemText(IDC_STATIC_CUR_PLAYERSTORAGE, strCurPlayerStorage);
	strCurPlayerStorage.TrimLeft();
	strCurPlayerStorage.TrimRight();

	CString strCurParameterK;
	GetDlgItemText(IDC_STATIC_CUR_PARAMETER_K, strCurParameterK);
	strCurParameterK.TrimLeft();
	strCurParameterK.TrimRight();



	SCORE lCurSysStorage = _ttoi64(strCurSysStorage);
	SCORE lCurPlayerStorage = _ttoi64(strCurPlayerStorage);
	SCORE nCurParameterK = _ttoi64(strCurParameterK);

	//小于0当成0算概率
	lCurSysStorage = (lCurSysStorage < 0 ? 0 : lCurSysStorage);
	lCurPlayerStorage = (lCurPlayerStorage < 0 ? 0 : lCurPlayerStorage);

	WORD wUserWinChance = INVALID_WORD;
	WORD wSysWinChance = INVALID_WORD;

	SCORE lDVal = abs(lCurSysStorage - lCurPlayerStorage);
	SCORE lMaxCtrlStorage = max(lCurSysStorage, lCurPlayerStorage);
	bool bSysWin = lCurSysStorage > lCurPlayerStorage;

	if (lMaxCtrlStorage == lDVal)
	{
		wUserWinChance = (lCurSysStorage > 0 && lCurPlayerStorage == 0) ? 0 : 70;
		
	}
	else
	{
        //区间概率判断
        if(lDVal <= lMaxCtrlStorage * nCurParameterK / 100)
        {
            wUserWinChance = bSysWin ? 50 : 50;
        }
        else if(lDVal > lMaxCtrlStorage * nCurParameterK / 100 && lDVal <= 1.5 * lMaxCtrlStorage * nCurParameterK / 100)
        {
            wUserWinChance = bSysWin ? 45 : 55;
        }
        else if(lDVal > 1.5 * lMaxCtrlStorage * nCurParameterK / 100 && lDVal <= 2 * lMaxCtrlStorage * nCurParameterK / 100)
        {
            wUserWinChance = bSysWin ? 40 : 60;
        }
        else if(lDVal > 2 * lMaxCtrlStorage * nCurParameterK / 100 && lDVal <= 3 * lMaxCtrlStorage * nCurParameterK / 100)
        {
            wUserWinChance = bSysWin ? 35 : 65;
        }
        else if(lDVal > 3 * lMaxCtrlStorage * nCurParameterK / 100)
        {
            wUserWinChance = bSysWin ? 0 : 70;
        }
	}

	CString strSysCtrlDesc;
	strSysCtrlDesc.Format(TEXT("%d%%"), wUserWinChance);
    SetDlgItemText(IDC_STATIC_SYS_ZHONG_PERCENT, strSysCtrlDesc);
}

void CDialogGeneral::OnEnChangeEditRoomctrlSysstorage()
{
	//UpdateRoomCtrlDesc();
}

void CDialogGeneral::OnEnChangeEditRoomctrlPlayerstorage()
{
	//UpdateRoomCtrlDesc();
}

void CDialogGeneral::OnEnChangeEditRoomctrlParameterK()
{
	//UpdateRoomCtrlDesc();
}

void CDialogGeneral::UpdateRoomCtrlDesc(SCORE lCurSysStorage, SCORE lCurPlayerStorage, int nCurParameterK)
{
	//小于0当成0算概率
	lCurSysStorage = (lCurSysStorage < 0 ? 0 : lCurSysStorage);
	lCurPlayerStorage = (lCurPlayerStorage < 0 ? 0 : lCurPlayerStorage);

	WORD wUserWinChance = INVALID_WORD;
	WORD wSysWinChance = INVALID_WORD;

	SCORE lDVal = abs(lCurSysStorage - lCurPlayerStorage);
	SCORE lMaxCtrlStorage = max(lCurSysStorage, lCurPlayerStorage);
	bool bSysWin = lCurSysStorage > lCurPlayerStorage;

	if (lMaxCtrlStorage == lDVal)
	{
		wUserWinChance = (lCurSysStorage > 0 && lCurPlayerStorage == 0) ? 0 : 70;
		
	}
	else
	{
        //区间概率判断
        if(lDVal <= lMaxCtrlStorage * nCurParameterK / 100)
        {
            wUserWinChance = bSysWin ? 50 : 50;
        }
        else if(lDVal > lMaxCtrlStorage * nCurParameterK / 100 && lDVal <= 1.5 * lMaxCtrlStorage * nCurParameterK / 100)
        {
            wUserWinChance = bSysWin ? 45 : 55;
        }
        else if(lDVal > 1.5 * lMaxCtrlStorage * nCurParameterK / 100 && lDVal <= 2 * lMaxCtrlStorage * nCurParameterK / 100)
        {
            wUserWinChance = bSysWin ? 40 : 60;
        }
        else if(lDVal > 2 * lMaxCtrlStorage * nCurParameterK / 100 && lDVal <= 3 * lMaxCtrlStorage * nCurParameterK / 100)
        {
            wUserWinChance = bSysWin ? 35 : 65;
        }
        else if(lDVal > 3 * lMaxCtrlStorage * nCurParameterK / 100)
        {
            wUserWinChance = bSysWin ? 0 : 70;
        }
	}

	CString strRoomCtrlDesc;
	strRoomCtrlDesc.Format(TEXT("%d"), wUserWinChance);
	SetDlgItemText(IDC_STATIC_ROOM_CTRLDESC, strRoomCtrlDesc);
}


void CDialogGeneral::UpdateUserCtrlDesc(SCORE lCurSysStorage, SCORE lCurPlayerStorage, int nCurParameterK)
{
    //小于0当成0算概率
    lCurSysStorage = (lCurSysStorage < 0 ? 0 : lCurSysStorage);
    lCurPlayerStorage = (lCurPlayerStorage < 0 ? 0 : lCurPlayerStorage);

    WORD wUserWinChance = INVALID_WORD;
    WORD wSysWinChance = INVALID_WORD;

    SCORE lDVal = abs(lCurSysStorage - lCurPlayerStorage);
    SCORE lMaxCtrlStorage = max(lCurSysStorage, lCurPlayerStorage);
    bool bSysWin = lCurSysStorage > lCurPlayerStorage;

    if(lMaxCtrlStorage == lDVal)
    {
        wUserWinChance = (lCurSysStorage > 0 && lCurPlayerStorage == 0) ? 0 : 70;
       
    }
    else
    {
        //区间概率判断
        if(lDVal <= lMaxCtrlStorage * nCurParameterK / 100)
        {
            wUserWinChance = bSysWin ? 50 : 50;
        }
        else if(lDVal > lMaxCtrlStorage * nCurParameterK / 100 && lDVal <= 1.5 * lMaxCtrlStorage * nCurParameterK / 100)
        {
            wUserWinChance = bSysWin ? 45 : 55;
        }
        else if(lDVal > 1.5 * lMaxCtrlStorage * nCurParameterK / 100 && lDVal <= 2 * lMaxCtrlStorage * nCurParameterK / 100)
        {
            wUserWinChance = bSysWin ? 40 : 60;
        }
        else if(lDVal > 2 * lMaxCtrlStorage * nCurParameterK / 100 && lDVal <= 3 * lMaxCtrlStorage * nCurParameterK / 100)
        {
            wUserWinChance = bSysWin ? 35 : 65;
        }
        else if(lDVal > 3 * lMaxCtrlStorage * nCurParameterK / 100)
        {
            wUserWinChance = bSysWin ? 0 : 70;
        }
    }

    CString strRoomCtrlDesc;
    strRoomCtrlDesc.Format(TEXT("%d%%"), wUserWinChance);
    SetDlgItemText(IDC_STATIC_USER_CTRLDESC, strRoomCtrlDesc);
}


//////////////////////////////////////////////////////////////////////////////////////////////////////

HBRUSH CDialogGeneral::OnCtlColor(CDC* pDC, CWnd* pWnd, UINT nCtlColor)
{
	HBRUSH hbr = __super::OnCtlColor(pDC, pWnd, nCtlColor);

	return hbr;
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// 调试对话框
BEGIN_MESSAGE_MAP(CDialogControl, CDialogDexter)
   
    ON_BN_CLICKED(IDC_BTN_CANCEL_USER, &CDialogControl::OnBnClickedBtnCancelUser)

ON_BN_CLICKED(IDC_BTN_SET_USERCTRL, &CDialogControl::OnBnClickedBtnSetUserctrl)
ON_BN_CLICKED(IDC_BTN_DEBUG_EXC, &CDialogControl::OnBnClickedBtnDebugExc)
ON_BN_CLICKED(IDC_BTN_DEBUG_CANCELL, &CDialogControl::OnBnClickedBtnDebugCancell)
ON_BN_CLICKED(IDC_BTN_QUARY, &CDialogControl::OnBnClickedBtnQuary)

END_MESSAGE_MAP()

// 构造函数
CDialogControl::CDialogControl(int nShowMax/* = 0*/, CClientConfigDlg *pParent /*=NULL*/) : CDialogDexter(IDD_CUSTOM_CONTROL, nShowMax, pParent)
{
    m_tableID = INVALID_WORD;
}

// 析构函数
CDialogControl::~CDialogControl()
{
}

// 控件绑定
void CDialogControl::DoDataExchange(CDataExchange *pDX)
{
    CDialogDexter::DoDataExchange(pDX);

}

bool CDialogControl::OnDebugMessage(WORD nMessageID, WORD wTableID, void *pBuffer, WORD wDataSize)
{
    switch(nMessageID)
    {
        case SUB_S_USER_DEBUG_COMPLETE:
        {
            //校验大小
            ASSERT(sizeof(CMD_S_ZuangDebugComplete) == wDataSize);
            if(sizeof(CMD_S_ZuangDebugComplete) != wDataSize)
            {
                return false;
            }

            // 定义信息
            CMD_S_ZuangDebugComplete *pCurUserCtrlInfo = (CMD_S_ZuangDebugComplete *)pBuffer;

            SetDlgItemInt(IDC_STATIC_USERCTRL_ID2, pCurUserCtrlInfo->dwBankerID); 
            SetDlgItemInt(IDC_STATIC_USERCTRL_SYSSTORAGE2, pCurUserCtrlInfo->cbRemainDebugCount);
            SetDlgItemInt(IDC_STATIC_USER_CTRLDESC2,(int) pCurUserCtrlInfo->lTotalScore);
            SetDlgItemInt(IDC_STATIC_USERCTRL_PLAYERSTORAGE2, pCurUserCtrlInfo->cbPlayers);
           

            break;
        }
        case SUB_S_ZUANG_DEBUG:
        {
            //校验大小
            ASSERT(sizeof(CMD_S_ZuangDebug) == wDataSize);
            if(sizeof(CMD_S_ZuangDebug) != wDataSize)
            {
                return false;
            }

            // 定义信息
            CMD_S_ZuangDebug *pCurUserCtrlInfo = (CMD_S_ZuangDebug *)pBuffer;

            if(pCurUserCtrlInfo->bOk)
            {
                SetDlgItemInt(IDC_STATIC_USERCTRL_SYSSTORAGE3, pCurUserCtrlInfo->cbDebugCount);
                SetDlgItemInt(IDC_STATIC_USERCTRL_SYSSTORAGE2, pCurUserCtrlInfo->cbDebugCount);
                SetDlgItemInt(IDC_STATIC_USER_CTRLDESC2, 0);
                
                if(pCurUserCtrlInfo->cbDebugCount == 0)
                {
                   // MessageBox(TEXT("取消调试成功！"), TEXT("温馨提示"));
                }
                else
                {
                   // MessageBox(TEXT("设置调试成功！"), TEXT("温馨提示"));
                }
            }
            else
            {
                MessageBox(TEXT("当前桌子不满足调试！"), TEXT("温馨提示"));
            }

            break;
        }
        case SUB_S_CLEAR_INFO:
        {

            SetDlgItemInt(IDC_STATIC_USERCTRL_ID, 0);
            SetDlgItemInt(IDC_STATIC_USERCTRL_SYSSTORAGE, 0);
            SetDlgItemInt(IDC_STATIC_USERCTRL_PLAYERSTORAGE, 0);
            SetDlgItemInt(IDC_STATIC_USER_CTRLDESC, 0);
            SetDlgItemInt(IDC_STATIC_USERCTRL_PARAMETER_K, 0);

            return true;
        }
        case SUB_S_CUR_USERCTRL_INFO:
        {
            //校验大小
            ASSERT(sizeof(CMD_S_CurUserCtrlInfo) == wDataSize);
            if(sizeof(CMD_S_CurUserCtrlInfo) != wDataSize)
            {
                return false;
            }

            // 定义信息
            CMD_S_CurUserCtrlInfo *pCurUserCtrlInfo = (CMD_S_CurUserCtrlInfo *)pBuffer;

            SetDlgItemInt(IDC_STATIC_USERCTRL_ID, pCurUserCtrlInfo->dwGameID);

            CString str;

            str.Format(L"%I64d",pCurUserCtrlInfo->lUserCtrlSysStorage);
            SetDlgItemText(IDC_STATIC_USERCTRL_SYSSTORAGE,str);

            str.Format(L"%I64d", pCurUserCtrlInfo->lUserCtrlPlayerStorage);
            SetDlgItemText(IDC_STATIC_USERCTRL_PLAYERSTORAGE, str);

            SetDlgItemInt(IDC_STATIC_USERCTRL_PARAMETER_K, pCurUserCtrlInfo->lUserCtrlParameterK);
            SetDlgItemInt(IDC_EDIT_RESET_PERCENT_USER, pCurUserCtrlInfo->lResetParameterK);

            str.Format(L"%I64d", pCurUserCtrlInfo->lUserCtrlSysWin - pCurUserCtrlInfo->lUserCtrlPlayerWin);
            SetDlgItemText(IDC_STATIC_USERCTRL_SYSWIN, str);

            UpdateUserCtrlDesc(pCurUserCtrlInfo->lUserCtrlSysStorage, pCurUserCtrlInfo->lUserCtrlPlayerStorage, pCurUserCtrlInfo->lUserCtrlParameterK);

            return true;
        }
        case SUB_S_DELETE_USER_ITEM_INFO:
        {
            ASSERT(wDataSize % sizeof(CMD_S_DELETE_USER) == 0);
            if(wDataSize % sizeof(CMD_S_DELETE_USER) != 0)
            {
                return false;
            }

            CListCtrl *pListCtrlUser = (CListCtrl *)GetDlgItem(IDC_LIST_USER);

            
            //定义信息
            CMD_S_DELETE_USER *pDelete = (CMD_S_DELETE_USER *)pBuffer;

            int nItemIndex = -1;
            for(WORD wIndex = 0; wIndex<pListCtrlUser->GetItemCount(); wIndex++)
            {
                if(_ttoi64(pListCtrlUser->GetItemText(wIndex, 0)) == pDelete->dUserDebugID)//如果找到对应的调试数据
                {
                    nItemIndex = wIndex;
                    pListCtrlUser->DeleteItem(wIndex);
                    break;
                }
            }
            
            return true;
        }
        case SUB_S_ADD_USER_ITEM_INFO:
        {
            ASSERT(wDataSize % sizeof(USERCTRL_ITEM) == 0);
            if(wDataSize % sizeof(USERCTRL_ITEM) != 0)
            {
                return false;
            }
            //定义信息
            USERCTRL_ITEM *pData = (USERCTRL_ITEM *)pBuffer;

            CListCtrl *pListCtrl = (CListCtrl *)GetDlgItem(IDC_LIST_USER);

            int nItem = pListCtrl->GetItemCount();
            for(int i = 0; i < nItem; i++)
            {
                if(_ttoi64(pListCtrl->GetItemText(i, 0)) == pData->dwGameID)
                {
                    pListCtrl->DeleteItem(i);
                    break;
                }
            }
            nItem = pListCtrl->GetItemCount();
            CString strCtrlIndex;
            strCtrlIndex.Format(TEXT("%d"), pData->dwGameID);

            pListCtrl->InsertItem(nItem, strCtrlIndex);

            CString strCtrlVal;
            strCtrlVal.Format(TEXT("%I64d"), pData->lUserCtrlInitialSysStorage);
            pListCtrl->SetItemText(nItem, 1, strCtrlVal);

            strCtrlVal.Format(TEXT("%I64d"), pData->lUserCtrlInitialPlayerStorage);
            pListCtrl->SetItemText(nItem, 2, strCtrlVal);

            strCtrlVal.Format(TEXT("%I64d"), pData->lUserCtrlParameterK);
            pListCtrl->SetItemText(nItem, 3, strCtrlVal);

            strCtrlVal.Format(TEXT("%I64d"), pData->lUserResetParameterK);
            pListCtrl->SetItemText(nItem, 4, strCtrlVal);

            strCtrlVal.Format(TEXT("%I64d"), pData->lUserCtrlSysWin - pData->lUserCtrlPlayerWin);
            pListCtrl->SetItemText(nItem, 5, strCtrlVal);

            if(pData->UserCtrlStatus == QUEUE)
            {
                pListCtrl->SetItemText(nItem, 6, L"等待执行");
            }
            else
            {
                pListCtrl->SetItemText(nItem, 6, L"执行中");
            }


            return true;

        }
        case SUB_S_REFRESH_USER_ITEM_INFO:
        {
            ASSERT(wDataSize % sizeof(USERCTRL_ITEM) == 0);
            if(wDataSize % sizeof(USERCTRL_ITEM) != 0)
            {
                return false;
            }
            USERCTRL_ITEM *pData = (USERCTRL_ITEM *)pBuffer;

            CListCtrl *pListCtrl = (CListCtrl *)GetDlgItem(IDC_LIST_USER);

            int nItem = pListCtrl->GetItemCount();
            for(int i = 0; i < nItem; i++)
            {
                if(_ttoi64(pListCtrl->GetItemText(i, 0)) == pData->dwGameID)
                {
                    CString strCtrlVal;
                    strCtrlVal.Format(TEXT("%I64d"), pData->lUserCtrlInitialSysStorage);
                    pListCtrl->SetItemText(i, 1, strCtrlVal);

                    strCtrlVal.Format(TEXT("%I64d"), pData->lUserCtrlInitialPlayerStorage);
                    pListCtrl->SetItemText(i, 2, strCtrlVal);

                    strCtrlVal.Format(TEXT("%I64d"), pData->lUserCtrlParameterK);
                    pListCtrl->SetItemText(i, 3, strCtrlVal);

                    strCtrlVal.Format(TEXT("%I64d"), pData->lUserResetParameterK);
                    pListCtrl->SetItemText(i, 4, strCtrlVal);

                    strCtrlVal.Format(TEXT("%I64d"), pData->lUserCtrlSysWin - pData->lUserCtrlPlayerWin);
                    pListCtrl->SetItemText(i, 5, strCtrlVal);

                    pListCtrl->SetItemText(i, 6, L"执行中");
                    break;
                }
            }
            return true;
        }
        case SUB_S_REQUEST_QUERY_RESULT:
        {
            ASSERT(wDataSize % sizeof(CMD_S_RequestQueryResult) == 0);
            if(wDataSize % sizeof(CMD_S_RequestQueryResult) != 0)
            {
                return false;
            }
            CMD_S_RequestQueryResult *s_result = (CMD_S_RequestQueryResult *)pBuffer;
            if(!s_result->bFind)
            {
                GetDlgItem(IDC_BTN_DEBUG_EXC)->EnableWindow(FALSE);
                GetDlgItem(IDC_BTN_DEBUG_CANCELL)->EnableWindow(FALSE);
                SetDlgItemInt(IDC_STATIC_USERCTRL_PLAYERSTORAGE2, 0);
                SetDlgItemInt(IDC_STATIC_USERCTRL_SYSSTORAGE3, 0);
                SetDlgItemInt(IDC_STATIC_USERCTRL_SYSSTORAGE2, 0);
             
                SetDlgItemText(IDC_STATIC_USERCTRL_ID3, L"未入桌");
                SetDlgItemText(IDC_STATIC_USERCTRL_ID2, L"未调试");
                break;
            }
            else
            {
                SetDlgItemInt(IDC_STATIC_USERCTRL_ID2,s_result->userinfo.dwBankerGameID);
                SetDlgItemInt(IDC_STATIC_USERCTRL_PLAYERSTORAGE2, s_result->userinfo.nPlayerCount);
                m_tableID = s_result->userinfo.wTableID;
                GetDlgItem(IDC_BTN_DEBUG_EXC)->EnableWindow(TRUE);
                GetDlgItem(IDC_BTN_DEBUG_CANCELL)->EnableWindow(TRUE);
                SetDlgItemInt(IDC_STATIC_USERCTRL_ID3, m_tableID);
                break;
            }
            
        }
      
        default:
            break;
    }

    return false;
}

void CDialogControl::OnBnClickedBtnSetUserctrl()
{
    // TODO:  在此添加控件通知处理程序代码
    CString strUserCtrlSysStorage;
    GetDlgItemText(IDC_EDIT_USERCTRL_SYSSTORAGE, strUserCtrlSysStorage);
    strUserCtrlSysStorage.TrimLeft();
    strUserCtrlSysStorage.TrimRight();

    if(!IsValidNum(strUserCtrlSysStorage) || strUserCtrlSysStorage == TEXT("0") || strUserCtrlSysStorage.IsEmpty())
    {
        MessageBox(TEXT("系统库存填写无效！"), TEXT("温馨提示"));
        return;
    }

    CString strID;
    GetDlgItemText(IDC_EDIT_USERID, strID);
    strID.TrimLeft();
    strID.TrimRight();

    if(!IsValidNum(strID) || strID == TEXT("0") || strID.IsEmpty())
    {
        MessageBox(TEXT("调试ID填写错误！"), TEXT("温馨提示"));
        return;
    }
    SCORE luserID = _ttoi64(strID);

    LPTSTR lpszUserCtrlSysStorage = new TCHAR[strUserCtrlSysStorage.GetLength() + 1];
    _tcscpy_s(lpszUserCtrlSysStorage, strUserCtrlSysStorage.GetLength() + 1, strUserCtrlSysStorage);
    SCORE lUserCtrlSysStorage = _ttoi64(lpszUserCtrlSysStorage);

    CString strUserCtrlPlayerStorage;
    GetDlgItemText(IDC_EDIT_USERCTRL_PLAYERSTORAGE, strUserCtrlPlayerStorage);
    strUserCtrlPlayerStorage.TrimLeft();
    strUserCtrlPlayerStorage.TrimRight();

    if(!IsValidNum(strUserCtrlPlayerStorage) || strUserCtrlPlayerStorage == TEXT("0") || strUserCtrlPlayerStorage.IsEmpty())
    {
        MessageBox(TEXT("玩家库存填写无效！"), TEXT("温馨提示"));
        return;
    }

    LPTSTR lpszUserCtrlPlayerStorage = new TCHAR[strUserCtrlPlayerStorage.GetLength() + 1];
    _tcscpy_s(lpszUserCtrlPlayerStorage, strUserCtrlPlayerStorage.GetLength() + 1, strUserCtrlPlayerStorage);
    SCORE lUserCtrlPlayerStorage = _ttoi64(lpszUserCtrlPlayerStorage);

    CString strUserCtrlParameterK;
    GetDlgItemText(IDC_EDIT_USERCTRL_PARAMETER_K, strUserCtrlParameterK);
    strUserCtrlParameterK.TrimLeft();
    strUserCtrlParameterK.TrimRight();

    if(!IsValidNum(strUserCtrlParameterK) || strUserCtrlParameterK == TEXT("0") || strUserCtrlParameterK.IsEmpty())
    {
        MessageBox(TEXT("调节系数填写无效！"), TEXT("温馨提示"));
        return;
    }

    LPTSTR lpszUserCtrlParameterK = new TCHAR[strUserCtrlParameterK.GetLength() + 1];
    _tcscpy_s(lpszUserCtrlParameterK, strUserCtrlParameterK.GetLength() + 1, strUserCtrlParameterK);
    SCORE nUserCtrlParameterK = _ttoi64(lpszUserCtrlParameterK);

    //校验
    if(!(nUserCtrlParameterK > 0 && nUserCtrlParameterK <= 100))
    {
        AfxMessageBox(TEXT("调节系数范围0~100，请重新设置！"), MB_ICONSTOP);
        return;
    }
    if(GetDlgItemInt(IDC_EDIT2) > GetDlgItemInt(IDC_EDIT_USERCTRL_PLAYERSTORAGE))
    {
        MessageBox(TEXT(" 玩家库存需要大于等于提示设置最小值"), TEXT("温馨提示"));

        SetDlgItemInt(IDC_EDIT_USERCTRL_PLAYERSTORAGE, GetDlgItemInt(IDC_EDIT2));

        return;
    }
    //新建
    CMD_C_UserCtrl UserCtrl;
    ZeroMemory(&UserCtrl, sizeof(UserCtrl));
    UserCtrl.dwUserID = luserID;
    UserCtrl.lUserCtrlSysStorage = lUserCtrlSysStorage;
    UserCtrl.lUserCtrlPlayerStorage = lUserCtrlPlayerStorage;
    UserCtrl.lUserResetParameterK = GetDlgItemInt(IDC_EDIT_RESET_PERCENT_USER);
    UserCtrl.lUserCtrlParameterK = nUserCtrlParameterK;

    // 发送消息
    SendDebugMessage(SUB_C_USER_DEBUG, &UserCtrl, sizeof(UserCtrl));

    delete[] lpszUserCtrlSysStorage;
    delete[] lpszUserCtrlPlayerStorage;
    delete[] lpszUserCtrlParameterK;
}

// 初始化窗口
BOOL CDialogControl::OnInitDialog()
{
    // 初始化窗口
    __super::OnInitDialog();

  
    int  nColumnCount = 0;
  
    //玩家调试调试选项
    CListCtrl *pListUserCtrl = (CListCtrl *)GetDlgItem(IDC_LIST_USER);
    pListUserCtrl->SetExtendedStyle(pListUserCtrl->GetExtendedStyle() | LVS_EX_FULLROWSELECT | LVS_EX_GRIDLINES);

    nColumnCount = 0;
    pListUserCtrl->InsertColumn(nColumnCount++, TEXT("玩家ID"), LVCFMT_CENTER, 100);
    pListUserCtrl->InsertColumn(nColumnCount++, TEXT("系统库存"), LVCFMT_CENTER, 130);
    pListUserCtrl->InsertColumn(nColumnCount++, TEXT("玩家库存"), LVCFMT_CENTER, 130);
    pListUserCtrl->InsertColumn(nColumnCount++, TEXT("调节系数"), LVCFMT_CENTER, 120);
    pListUserCtrl->InsertColumn(nColumnCount++, TEXT("重置区间"), LVCFMT_CENTER, 120);
    pListUserCtrl->InsertColumn(nColumnCount++, TEXT("库存统计"), LVCFMT_CENTER, 130);
    pListUserCtrl->InsertColumn(nColumnCount++, TEXT("当前状态"), LVCFMT_CENTER, 115);

    int nTimes[5] = {1,2,3,4,5};
    //调试局数
    for(WORD i = 0; i < 5; i++)
    {
        CString strCtrlTimes;
        strCtrlTimes.Format(TEXT("%d"), nTimes[i]);

        ((CComboBox *)GetDlgItem(IDC_COMBO_TIMES))->AddString(strCtrlTimes);
    }
    ((CComboBox *)GetDlgItem(IDC_COMBO_TIMES))->SetCurSel(0);

    SendDebugMessage(SUB_C_REFRESH_CUR_ROOMCTRL_INFO);
    SendDebugMessage(SUB_C_REFRESH_CUR_USERCTRL_INFO);

    m_FontTitle.CreateFont(15, 7, 0, 0, FW_MEDIUM, FALSE, FALSE, 0, ANSI_CHARSET, OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS,
                           DEFAULT_QUALITY,
                           DEFAULT_PITCH,
                           _T("宋体"));

  
    GetDlgItem(IDC_STATIC_USER)->SetFont(&m_FontTitle);
    ((CButton *)GetDlgItem(IDC_RADIO_WIN))->SetCheck(1);

    GetDlgItem(IDC_BTN_DEBUG_EXC)->EnableWindow(FALSE);
    GetDlgItem(IDC_BTN_DEBUG_CANCELL)->EnableWindow(FALSE);

    return TRUE;
}





//////////////////////////////////////////////////////////////////////////////////////////////////////




BEGIN_MESSAGE_MAP(CDialogAdvanced, CDialogDexter)
	ON_BN_CLICKED(IDC_BTN_CANCEL_ROOMCTRL, OnBnClickedBtnCancelRoomCtrl)
	ON_WM_CTLCOLOR()
ON_BN_CLICKED(IDC_BTN_CANCEL_USERCTRL, &CDialogAdvanced::OnBnClickedBtnCancelUserctrl)
ON_BN_CLICKED(IDC_BTN_CANCEL_ROOMCTRL2, &CDialogAdvanced::OnBnClickedBtnCancelRoomctrl2)
ON_BN_CLICKED(IDC_BTN_CANCEL_USERCTRL2, &CDialogAdvanced::OnBnClickedBtnCancelUserctrl2)

ON_BN_CLICKED(IDC_BTN_CLEAR_DESK, &CDialogAdvanced::OnBnClickedBtnClearDesk)
ON_BN_CLICKED(IDC_BTN_CLEAR_DESKALL, &CDialogAdvanced::OnBnClickedBtnClearDeskall)
END_MESSAGE_MAP()

// 构造函数
CDialogAdvanced::CDialogAdvanced(int nShowMax/* = 0*/, CClientConfigDlg *pParent /*=NULL*/) : CDialogDexter(IDD_CUSTOM_ADVANCED, nShowMax, pParent)
{
}

// 析构函数
CDialogAdvanced::~CDialogAdvanced()
{
}

// 控件绑定
void CDialogAdvanced::DoDataExchange(CDataExchange *pDX)
{
	CDialogDexter::DoDataExchange(pDX);
}

// 消息函数
bool CDialogAdvanced::OnDebugMessage(WORD nMessageID, WORD wTableID, void *pData, WORD nSize)
{
	switch (nMessageID)
	{
	case SUB_S_REFRESH_ROOMCTRL:
	{
		ASSERT(nSize % sizeof(CMD_S_RoomCtrlResult) == 0);
		if (nSize % sizeof(CMD_S_RoomCtrlResult) != 0)
		{
			return false;
		}

		CListCtrl *pListCtrlRoom = (CListCtrl *)GetDlgItem(IDC_LIST_ROOM);

		//定义信息
		CMD_S_RoomCtrlResult *pRoomCtrlResult = (CMD_S_RoomCtrlResult *)pData;

		int nItemIndex = -1;
		for (WORD wIndex = 0; wIndex<pListCtrlRoom->GetItemCount(); wIndex++)
		{
			if (_ttoi64(pListCtrlRoom->GetItemText(wIndex, 0)) == pRoomCtrlResult->dwCtrlIndex )
			{
				nItemIndex = wIndex;
				break;
			}
		}

        for(WORD wIndex = 0; wIndex<pListCtrlRoom->GetItemCount(); wIndex++)
        {
            if(_ttoi64(pListCtrlRoom->GetItemText(wIndex, 0)) == pRoomCtrlResult->dwCtrlIndex && ((pListCtrlRoom->GetItemText(wIndex, 6) == L"进行中") && pRoomCtrlResult->roomCtrlStatus != PROGRESSING))
            {
                pListCtrlRoom->SetItemText(wIndex, 6, TEXT("已完成"));
                CString strCtrlVal;
                strCtrlVal.Format(TEXT("%I64d"), pRoomCtrlResult->lRoomCtrlSysWin - pRoomCtrlResult->lRoomCtrlPlayerWin);
                pListCtrlRoom->SetItemText(wIndex, 4, strCtrlVal);
                break;
            }
            if(_ttoi64(pListCtrlRoom->GetItemText(wIndex, 0)) == pRoomCtrlResult->dwCtrlIndex && ((pListCtrlRoom->GetItemText(wIndex, 6) == L"进行中") && pRoomCtrlResult->roomCtrlStatus == PROGRESSING))
            {
                CString strCtrlVal;
                strCtrlVal.Format(TEXT("%I64d"), pRoomCtrlResult->lRoomCtrlSysStorage);
                pListCtrlRoom->SetItemText(wIndex, 1, strCtrlVal);

                strCtrlVal.Format(TEXT("%I64d"), pRoomCtrlResult->lRoomCtrlPlayerStorage);
                pListCtrlRoom->SetItemText(wIndex, 2, strCtrlVal);

                strCtrlVal.Format(TEXT("%I64d"), pRoomCtrlResult->lRoomCtrlSysWin - pRoomCtrlResult->lRoomCtrlPlayerWin);
                pListCtrlRoom->SetItemText(wIndex, 4, strCtrlVal);
                break;
            }
        }
        

		if (nItemIndex == -1)
		{
			CString strCtrlIndex;
			strCtrlIndex.Format(TEXT("%d"), pRoomCtrlResult->dwCtrlIndex);

			int nItem = pListCtrlRoom->GetItemCount();
			nItemIndex = pListCtrlRoom->InsertItem(nItem, strCtrlIndex);

			CString strCtrlVal;
			strCtrlVal.Format(TEXT("%I64d"), pRoomCtrlResult->lRoomCtrlSysStorage);
			pListCtrlRoom->SetItemText(nItem, 1, strCtrlVal);

			strCtrlVal.Format(TEXT("%I64d"), pRoomCtrlResult->lRoomCtrlPlayerStorage);
			pListCtrlRoom->SetItemText(nItem, 2, strCtrlVal);

            strCtrlVal.Format(TEXT("%I64d"), pRoomCtrlResult->lRoomCtrlParameterK);
			pListCtrlRoom->SetItemText(nItem, 3, strCtrlVal);

            strCtrlVal.Format(TEXT("%I64d"), pRoomCtrlResult->lRoomCtrlSysWin-pRoomCtrlResult->lRoomCtrlPlayerWin);
            pListCtrlRoom->SetItemText(nItem, 4, strCtrlVal);

			strCtrlVal.Format(TEXT("%d/%d-%d:%d"), pRoomCtrlResult->tmConfigTime.GetMonth(), pRoomCtrlResult->tmConfigTime.GetDay(), pRoomCtrlResult->tmConfigTime.GetHour(), pRoomCtrlResult->tmConfigTime.GetMinute());
			pListCtrlRoom->SetItemText(nItem, 5, strCtrlVal);

			if (pRoomCtrlResult->roomCtrlStatus == QUEUE)
			{
					pListCtrlRoom->SetItemText(nItem, 6, TEXT("队列中"));
			}
			else if (pRoomCtrlResult->roomCtrlStatus == PROGRESSING)
			{
				pListCtrlRoom->SetItemText(nItem, 6, TEXT("进行中"));
			}
			else if (pRoomCtrlResult->roomCtrlStatus == FINISH)
			{
				pListCtrlRoom->SetItemText(nItem, 6, TEXT("已完成"));
			}
			else if (pRoomCtrlResult->roomCtrlStatus == CANCEL)
			{
				pListCtrlRoom->SetItemText(nItem, 6, TEXT("已取消"));
			}
			else if (pRoomCtrlResult->roomCtrlStatus == EXECUTE_CANCEL)
			{
				pListCtrlRoom->SetItemText(nItem, 6, TEXT("已执行"));
			}

			if (pRoomCtrlResult->roomCtrlStatus == PROGRESSING)
			{
				pListCtrlRoom->SetItemState(nItem, LVNI_FOCUSED | LVIS_SELECTED, LVNI_FOCUSED | LVIS_SELECTED);
			}
		}

		return true;
	}
    case SUB_S_REFRESH_USERCTRL:
    {
        ASSERT(nSize % sizeof(CMD_S_UserCtrlResult) == 0);
        if(nSize % sizeof(CMD_S_UserCtrlResult) != 0)
        {
            return false;
        }

        CListCtrl *pListCtrlUser = (CListCtrl *)GetDlgItem(IDC_LIST_USERSTORAGE);

        if(nSize == 0)
        {

        }
        else
        {
            //定义信息
            CMD_S_UserCtrlResult *pUserCtrlResult = (CMD_S_UserCtrlResult *)pData;

            int nItemIndex = -1;
           
            for(WORD wIndex = 0; wIndex<pListCtrlUser->GetItemCount(); wIndex++)
            {
                if(_ttoi64(pListCtrlUser->GetItemText(wIndex, 0)) == pUserCtrlResult->dwCtrlIndex && (pUserCtrlResult->roomCtrlStatus == FINISH || pUserCtrlResult->roomCtrlStatus == EXECUTE_CANCEL))//如果找到对应的调试数据
                {
                    nItemIndex = wIndex;
                    UpdateList(wIndex, *pListCtrlUser, *pUserCtrlResult);
                }
            }

            if(nItemIndex == -1)
            {
                CString strCtrlIndex;
                strCtrlIndex.Format(TEXT("%d"), pUserCtrlResult->dwCtrlIndex);

                int nItem = pListCtrlUser->GetItemCount();

                pListCtrlUser->InsertItem(nItem, strCtrlIndex);
                UpdateList(nItem, *pListCtrlUser, *pUserCtrlResult);

            }
        }

        return true;
    }
	case SUB_S_REFRESH_SYSCTRL:
	{
		ASSERT(nSize % sizeof(CMD_S_SysCtrlResult) == 0);
		if (nSize % sizeof(CMD_S_SysCtrlResult) != 0)
		{
			return false;
		}

		CListCtrl *pListSysStorage = (CListCtrl *)GetDlgItem(IDC_LIST_SYSSTORAGE);

		if (nSize == 0)
		{
			pListSysStorage->DeleteAllItems();
		}
		else
		{
			//定义信息
			CMD_S_SysCtrlResult *pSysCtrlResult = (CMD_S_SysCtrlResult *)pData;

			int nItemIndex = -1;
			for (WORD wIndex = 0; wIndex<pListSysStorage->GetItemCount(); wIndex++)
			{
				if (_ttoi64(pListSysStorage->GetItemText(wIndex, 0)) == pSysCtrlResult->dwCtrlIndex)
				{
					nItemIndex = wIndex;
                    CString strCtrlVal;

                    strCtrlVal.Format(TEXT("%d"), pSysCtrlResult->dwResetCount);
                    pListSysStorage->SetItemText(wIndex, 1, strCtrlVal);

                    strCtrlVal.Format(TEXT("%I64d"), pSysCtrlResult->lSysCtrlSysStorage);
                    pListSysStorage->SetItemText(wIndex, 2, strCtrlVal);

                    strCtrlVal.Format(TEXT("%I64d"), pSysCtrlResult->lSysCtrlPlayerStorage);
                    pListSysStorage->SetItemText(wIndex, 3, strCtrlVal);

                    strCtrlVal.Format(TEXT("%I64d"), pSysCtrlResult->lSysCtrlSysWin - pSysCtrlResult->lSysCtrlPlayerWin);
                    pListSysStorage->SetItemText(wIndex, 5, strCtrlVal);
					break;
				}
			}

			if (nItemIndex == -1)
			{
				CString strCtrlIndex;
				strCtrlIndex.Format(TEXT("%d"), pSysCtrlResult->dwCtrlIndex);

				int nItem = pListSysStorage->GetItemCount();
				nItemIndex = pListSysStorage->InsertItem(nItem, strCtrlIndex);

				CString strCtrlVal;

                strCtrlVal.Format(TEXT("%d"), pSysCtrlResult->dwResetCount);
                pListSysStorage->SetItemText(nItem, 1, strCtrlVal);

				strCtrlVal.Format(TEXT("%I64d"), pSysCtrlResult->lSysCtrlSysStorage);
				pListSysStorage->SetItemText(nItem, 2, strCtrlVal);

				strCtrlVal.Format(TEXT("%I64d"), pSysCtrlResult->lSysCtrlPlayerStorage);
				pListSysStorage->SetItemText(nItem, 3, strCtrlVal);

                strCtrlVal.Format(TEXT("%I64d"), pSysCtrlResult->lSysCtrlParameterK);
				pListSysStorage->SetItemText(nItem, 4, strCtrlVal);

                strCtrlVal.Format(TEXT("%I64d"), pSysCtrlResult->lSysCtrlSysWin-pSysCtrlResult->lSysCtrlPlayerWin);
                pListSysStorage->SetItemText(nItem, 5, strCtrlVal);

				strCtrlVal.Format(TEXT("%d/%d-%d:%d"), pSysCtrlResult->tmResetTime.GetMonth(), pSysCtrlResult->tmResetTime.GetDay(), pSysCtrlResult->tmResetTime.GetHour(), pSysCtrlResult->tmResetTime.GetMinute());
				pListSysStorage->SetItemText(nItem, 6, strCtrlVal);

				if (pSysCtrlResult->sysCtrlStatus == PROGRESSINGEX)
				{
					pListSysStorage->SetItemState(nItem, LVNI_FOCUSED | LVIS_SELECTED, LVNI_FOCUSED | LVIS_SELECTED);
				}
			}
		}

		return true;
	}
    case SUB_S_REFRESH_DESKCTRL:
    {
        ASSERT(nSize % sizeof(CMD_S_DeskCtrlResult) == 0);
        if(nSize % sizeof(CMD_S_DeskCtrlResult) != 0)
        {
            return false;
        }

        CListCtrl *pListDesk = (CListCtrl *)GetDlgItem(IDC_LIST_DESK);

        if(nSize == 0)
        {
            pListDesk->DeleteAllItems();
        }
        else
        {
            //定义信息
            CMD_S_DeskCtrlResult *pDesk = (CMD_S_DeskCtrlResult *)pData;

            int nItemIndex = -1;
            for(WORD wIndex = 0; wIndex < pListDesk->GetItemCount(); wIndex++)
            {
                if(_ttoi64(pListDesk->GetItemText(wIndex, 0)) == pDesk->deskCtrl.dwCtrlIndex)
                {
                    nItemIndex = wIndex;
                    CString strCtrlVal;

                    if(pDesk->deskCtrl.CtrlStatus == QUEUE)
                    {
                        pListDesk->SetItemText(wIndex, 5, TEXT("等待执行"));
                    }
                    else if(pDesk->deskCtrl.CtrlStatus == PROGRESSING)
                    {
                        pListDesk->SetItemText(wIndex, 5, TEXT("进行中"));
                    }
                    else if(pDesk->deskCtrl.CtrlStatus == FINISH)
                    {
                        pListDesk->SetItemText(wIndex, 5, TEXT("已完成"));
                    }
                    else if(pDesk->deskCtrl.CtrlStatus == CANCEL)
                    {
                        pListDesk->SetItemText(wIndex, 5, TEXT("已取消"));
                    }
                    else if(pDesk->deskCtrl.CtrlStatus == EXECUTE_CANCEL)
                    {
                        pListDesk->SetItemText(wIndex, 5, TEXT("已执行"));
                    }
                    break;
                }
            }

            if(nItemIndex == -1)
            {
                CString strCtrlIndex;
                strCtrlIndex.Format(TEXT("%d"), pDesk->deskCtrl.dwCtrlIndex);

                int nItem = pListDesk->GetItemCount();
                nItemIndex = pListDesk->InsertItem(nItem, strCtrlIndex);

                if(pDesk->deskCtrl.zuangDebug.debug_type == CONTINUE_WIN)
                {
                    pListDesk->SetItemText(nItem, 1, TEXT("庄家赢"));
                }
                else
                {
                    pListDesk->SetItemText(nItem, 1, TEXT("庄家输"));
                }

                CString strCtrlVal;

                strCtrlVal.Format(TEXT("%d"), pDesk->deskCtrl.zuangDebug.cbDebugCount);
                pListDesk->SetItemText(nItem, 2, strCtrlVal);

                strCtrlVal.Format(TEXT("%d"), pDesk->deskCtrl.deskInfo.wTableID);
                pListDesk->SetItemText(nItem, 3, strCtrlVal);

                strCtrlVal.Format(TEXT("%d"), pDesk->deskCtrl.dwGameID);
                pListDesk->SetItemText(nItem, 4, strCtrlVal);

                if(pDesk->deskCtrl.CtrlStatus == QUEUE)
                {
                    pListDesk->SetItemText(nItem, 5, TEXT("等待执行"));
                }
                else if(pDesk->deskCtrl.CtrlStatus == PROGRESSING)
                {
                    pListDesk->SetItemText(nItem, 5, TEXT("进行中"));
                }
                else if(pDesk->deskCtrl.CtrlStatus == FINISH)
                {
                    pListDesk->SetItemText(nItem, 5, TEXT("已完成"));
                }
                else if(pDesk->deskCtrl.CtrlStatus == CANCEL)
                {
                    pListDesk->SetItemText(nItem, 5, TEXT("已取消"));
                }
                else if(pDesk->deskCtrl.CtrlStatus == EXECUTE_CANCEL)
                {
                    pListDesk->SetItemText(nItem, 5, TEXT("已执行"));
                }

                strCtrlVal.Format(TEXT("%d/%d-%d:%d"), pDesk->deskCtrl.tmResetTime.GetMonth(), pDesk->deskCtrl.tmResetTime.GetDay(), pDesk->deskCtrl.tmResetTime.GetHour(), pDesk->deskCtrl.tmResetTime.GetMinute());
                pListDesk->SetItemText(nItem, 6, strCtrlVal);

                if(pDesk->deskCtrl.CtrlStatus == PROGRESSINGEX)
                {
                    pListDesk->SetItemState(nItem, LVNI_FOCUSED | LVIS_SELECTED, LVNI_FOCUSED | LVIS_SELECTED);
                }
            }
        }
      
        return true;
    }
	

	default:
		break;
	}

	return false;
}

void CDialogAdvanced::UpdateList(int nItem, CListCtrl &pListCtrlUser, CMD_S_UserCtrlResult &pUserCtrlResult)
{
    CString strCtrlVal;
    strCtrlVal.Format(TEXT("%d"), pUserCtrlResult.dwGameID);
    pListCtrlUser.SetItemText(nItem, 1, strCtrlVal);


    strCtrlVal.Format(TEXT("%I64d"), pUserCtrlResult.lUserCtrlSysStorage);
    pListCtrlUser.SetItemText(nItem, 2, strCtrlVal);

    strCtrlVal.Format(TEXT("%I64d"), pUserCtrlResult.lUserCtrlPlayerStorage);
    pListCtrlUser.SetItemText(nItem, 3, strCtrlVal);

    strCtrlVal.Format(TEXT("%I64d"), pUserCtrlResult.lUserCtrlParameterK);
    pListCtrlUser.SetItemText(nItem, 4, strCtrlVal);

    strCtrlVal.Format(TEXT("%I64d"), pUserCtrlResult.lUserCtrlSysWin-pUserCtrlResult.lUserCtrlPlayerWin);
    pListCtrlUser.SetItemText(nItem, 5, strCtrlVal);

    strCtrlVal.Format(TEXT("%d/%d-%d:%d"), pUserCtrlResult.tmConfigTime.GetMonth(), pUserCtrlResult.tmConfigTime.GetDay(), pUserCtrlResult.tmConfigTime.GetHour(), pUserCtrlResult.tmConfigTime.GetMinute());
    pListCtrlUser.SetItemText(nItem, 6, strCtrlVal);

    if(pUserCtrlResult.roomCtrlStatus == QUEUE)
    {
        pListCtrlUser.SetItemText(nItem, 7, TEXT("等待执行"));
    }
    else if(pUserCtrlResult.roomCtrlStatus == PROGRESSING)
    {
        pListCtrlUser.SetItemText(nItem, 7, TEXT("进行中"));
    }
    else if(pUserCtrlResult.roomCtrlStatus == FINISH)
    {
        pListCtrlUser.SetItemText(nItem, 7, TEXT("已完成"));
    }
    else if(pUserCtrlResult.roomCtrlStatus == CANCEL)
    {
        pListCtrlUser.SetItemText(nItem, 7, TEXT("已取消"));
    }
    else if(pUserCtrlResult.roomCtrlStatus == EXECUTE_CANCEL)
    {
        pListCtrlUser.SetItemText(nItem, 7, TEXT("已执行"));
    }
}

// 初始化窗口
BOOL CDialogAdvanced::OnInitDialog()
{
	// 初始化窗口
	__super::OnInitDialog();

	INT nColumnCount = 0;

	//库存配置
	CListCtrl *pListSysStorage = (CListCtrl *)GetDlgItem(IDC_LIST_SYSSTORAGE);
	pListSysStorage->SetExtendedStyle(pListSysStorage->GetExtendedStyle() | LVS_EX_FULLROWSELECT | LVS_EX_GRIDLINES);

	nColumnCount = 0;
    pListSysStorage->InsertColumn(nColumnCount++, TEXT("调试ID"), LVCFMT_CENTER, 50);
	pListSysStorage->InsertColumn(nColumnCount++, TEXT("重置次数"), LVCFMT_CENTER, 60);
	pListSysStorage->InsertColumn(nColumnCount++, TEXT("系统库存"), LVCFMT_CENTER, 70);
	pListSysStorage->InsertColumn(nColumnCount++, TEXT("玩家库存"), LVCFMT_CENTER, 70);
	pListSysStorage->InsertColumn(nColumnCount++, TEXT("调节系数"), LVCFMT_CENTER, 60);
    pListSysStorage->InsertColumn(nColumnCount++, TEXT("系统输赢"), LVCFMT_CENTER, 70);
	
	pListSysStorage->InsertColumn(nColumnCount++, TEXT("时间"), LVCFMT_CENTER, 70);

    //桌子提示
    CListCtrl *pListDeskCtrl = (CListCtrl *)GetDlgItem(IDC_LIST_DESK);
    pListDeskCtrl->SetExtendedStyle(pListSysStorage->GetExtendedStyle() | LVS_EX_FULLROWSELECT | LVS_EX_GRIDLINES);

    nColumnCount = 0;
    pListDeskCtrl->InsertColumn(nColumnCount++, TEXT("调试ID"), LVCFMT_CENTER, 50);
    pListDeskCtrl->InsertColumn(nColumnCount++, TEXT("调试输赢"), LVCFMT_CENTER, 60);
    pListDeskCtrl->InsertColumn(nColumnCount++, TEXT("调试局数"), LVCFMT_CENTER, 70);
    pListDeskCtrl->InsertColumn(nColumnCount++, TEXT("桌号"), LVCFMT_CENTER, 70);
    pListDeskCtrl->InsertColumn(nColumnCount++, TEXT("操作人"), LVCFMT_CENTER, 60);
    pListDeskCtrl->InsertColumn(nColumnCount++, TEXT("时间"), LVCFMT_CENTER, 70);
    pListDeskCtrl->InsertColumn(nColumnCount++, TEXT("当前状态"), LVCFMT_CENTER, 70);

   

	//房间调试
	CListCtrl *pListRoomCtrl = (CListCtrl *)GetDlgItem(IDC_LIST_ROOM);
	pListRoomCtrl->SetExtendedStyle(pListRoomCtrl->GetExtendedStyle() | LVS_EX_FULLROWSELECT | LVS_EX_GRIDLINES);

	nColumnCount = 0;
	pListRoomCtrl->InsertColumn(nColumnCount++, TEXT("调试ID"), LVCFMT_CENTER, 50);
	pListRoomCtrl->InsertColumn(nColumnCount++, TEXT("系统库存"), LVCFMT_CENTER, 70);
	pListRoomCtrl->InsertColumn(nColumnCount++, TEXT("玩家库存"), LVCFMT_CENTER, 70);
	pListRoomCtrl->InsertColumn(nColumnCount++, TEXT("调节系数"), LVCFMT_CENTER, 70);
    pListRoomCtrl->InsertColumn(nColumnCount++, TEXT("系统输赢"), LVCFMT_CENTER, 70);
	
	pListRoomCtrl->InsertColumn(nColumnCount++, TEXT("时间"), LVCFMT_CENTER, 100);
	pListRoomCtrl->InsertColumn(nColumnCount++, TEXT("当前状态"), LVCFMT_CENTER, 72);


    //房间调试
    CListCtrl *pListUserCtrl = (CListCtrl *)GetDlgItem(IDC_LIST_USERSTORAGE);
    pListUserCtrl->SetExtendedStyle(pListUserCtrl->GetExtendedStyle() | LVS_EX_FULLROWSELECT | LVS_EX_GRIDLINES);

    nColumnCount = 0;
    pListUserCtrl->InsertColumn(nColumnCount++, TEXT("调试ID"), LVCFMT_CENTER, 100);
    pListUserCtrl->InsertColumn(nColumnCount++, TEXT("GAME_ID"), LVCFMT_CENTER, 100);
    pListUserCtrl->InsertColumn(nColumnCount++, TEXT("系统库存"), LVCFMT_CENTER, 120);
    pListUserCtrl->InsertColumn(nColumnCount++, TEXT("玩家库存"), LVCFMT_CENTER, 120);
    pListUserCtrl->InsertColumn(nColumnCount++, TEXT("调节系数"), LVCFMT_CENTER, 100);
    pListUserCtrl->InsertColumn(nColumnCount++, TEXT("系统输赢"), LVCFMT_CENTER, 100);
  
    pListUserCtrl->InsertColumn(nColumnCount++, TEXT("时间"), LVCFMT_CENTER, 150);
    pListUserCtrl->InsertColumn(nColumnCount++, TEXT("当前状态"), LVCFMT_CENTER, 110);


    m_FontTitle.CreateFont(15, 7, 0, 0, FW_MEDIUM, FALSE, FALSE, 0, ANSI_CHARSET, OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS,
                           DEFAULT_QUALITY,
                           DEFAULT_PITCH,
                           _T("宋体"));

    GetDlgItem(IDC_STATIC_SYS)->SetFont(&m_FontTitle);
    GetDlgItem(IDC_STATIC_ROOM)->SetFont(&m_FontTitle);
    GetDlgItem(IDC_STATIC_USER)->SetFont(&m_FontTitle);

	return TRUE;
}

void CDialogAdvanced::OnBnClickedBtnCancelRoomCtrl()
{
	CListCtrl *pListCtrlRoom = (CListCtrl *)GetDlgItem(IDC_LIST_ROOM);
	POSITION pos = pListCtrlRoom->GetFirstSelectedItemPosition();

	if (!pos)
	{
		AfxMessageBox(TEXT("请选中某行！"), MB_ICONSTOP);

		return;
	}

	int nItem = pListCtrlRoom->GetNextSelectedItem(pos);

    if(pListCtrlRoom->GetItemText(nItem, 6) == L"进行中")
    {
        AfxMessageBox(TEXT("日志项中不能删除正在执行中的调试项！"), MB_ICONSTOP);
        return;
    }

    CMD_C_Cancel_RoomCtrl RoomCtrl;
	ZeroMemory(&RoomCtrl, sizeof(RoomCtrl));

	RoomCtrl.dRoomDebugID = _ttoi64(pListCtrlRoom->GetItemText(nItem, 0));

  
	// 发送消息
    SendDebugMessage(SUB_C_DELETE_ROOM_CTRL_LOG, &RoomCtrl, sizeof(RoomCtrl));

    pListCtrlRoom->DeleteItem(nItem);

	
}


void CDialogAdvanced::OnBnClickedBtnCancelUserctrl()
{
    CListCtrl *pListCtrlUser = (CListCtrl *)GetDlgItem(IDC_LIST_USERSTORAGE);
   
    pListCtrlUser->DeleteAllItems();

   
    // 发送消息
    SendDebugMessage(SUB_C_DELETE_ALL_USER_CTRL);
    
}



void CDialogControl::OnBnClickedBtnCancelUser()
{
    // TODO:  在此添加控件通知处理程序代码
    CListCtrl *pListCtrlUser = (CListCtrl *)GetDlgItem(IDC_LIST_USER);
    POSITION pos = pListCtrlUser->GetFirstSelectedItemPosition();

    if(!pos)
    {
        AfxMessageBox(TEXT("请选中某行！"), MB_ICONSTOP);

        return;
    }

    int nItem = pListCtrlUser->GetNextSelectedItem(pos);


    CMD_C_DELETE_USER UserCtrl;
    ZeroMemory(&UserCtrl, sizeof(UserCtrl));

    UserCtrl.dUserDebugID = _ttoi64(pListCtrlUser->GetItemText(nItem, 0));

    // 发送消息
    SendDebugMessage(SUB_C_DELETE_USER_CTRL, &UserCtrl, sizeof(UserCtrl));

    pListCtrlUser->DeleteItem(nItem);
}


bool CDialogControl::IsValidNum(CString strEdit)
{
    SCORE lScoreValue = _wtof(strEdit);
    CString strCmp;
    strCmp.Format(L"%I64d", lScoreValue);

    if(strCmp == strEdit)
    {
        return true;
    }

    SCORE lScoreVal = _ttoi64(strEdit);
    strCmp.Format(TEXT("%I64d"), lScoreVal);

    return strCmp == strEdit;
}

void CDialogControl::UpdateRoomCtrlDesc(SCORE lCurSysStorage, SCORE lCurPlayerStorage, int nCurParameterK)
{
    //小于0当成0算概率
    lCurSysStorage = (lCurSysStorage < 0 ? 0 : lCurSysStorage);
    lCurPlayerStorage = (lCurPlayerStorage < 0 ? 0 : lCurPlayerStorage);

    WORD wUserWinChance = INVALID_WORD;
    WORD wSysWinChance = INVALID_WORD;

    SCORE lDVal = abs(lCurSysStorage - lCurPlayerStorage);
    SCORE lMaxCtrlStorage = max(lCurSysStorage, lCurPlayerStorage);
    bool bSysWin = lCurSysStorage > lCurPlayerStorage;

    if(lMaxCtrlStorage == lDVal)
    {
        wUserWinChance = (lCurSysStorage > 0 && lCurPlayerStorage == 0) ? 0 : 70;
    }
       
    else
    {
        //区间概率判断
        if(lDVal <= lMaxCtrlStorage * nCurParameterK / 100)
        {
            wUserWinChance = bSysWin ? 50 : 50;
        }
        else if(lDVal > lMaxCtrlStorage * nCurParameterK / 100 && lDVal <= 1.5 * lMaxCtrlStorage * nCurParameterK / 100)
        {
            wUserWinChance = bSysWin ? 45 : 55;
        }
        else if(lDVal > 1.5 * lMaxCtrlStorage * nCurParameterK / 100 && lDVal <= 2 * lMaxCtrlStorage * nCurParameterK / 100)
        {
            wUserWinChance = bSysWin ? 40 : 60;
        }
        else if(lDVal > 2 * lMaxCtrlStorage * nCurParameterK / 100 && lDVal <= 3 * lMaxCtrlStorage * nCurParameterK / 100)
        {
            wUserWinChance = bSysWin ? 35 : 65;
        }
        else if(lDVal > 3 * lMaxCtrlStorage * nCurParameterK / 100)
        {
            wUserWinChance = bSysWin ? 0 : 70;
        }
    }

    CString strRoomCtrlDesc;
    strRoomCtrlDesc.Format(TEXT("%d%%"), wUserWinChance);
    SetDlgItemText(IDC_STATIC_ROOM_CTRLDESC, strRoomCtrlDesc);
}

void CDialogControl::UpdateUserCtrlDesc(SCORE lCurSysStorage, SCORE lCurPlayerStorage, int nCurParameterK)
{
    //小于0当成0算概率
    lCurSysStorage = (lCurSysStorage < 0 ? 0 : lCurSysStorage);
    lCurPlayerStorage = (lCurPlayerStorage < 0 ? 0 : lCurPlayerStorage);

    WORD wUserWinChance = INVALID_WORD;
    WORD wSysWinChance = INVALID_WORD;

    SCORE lDVal = abs(lCurSysStorage - lCurPlayerStorage);
    SCORE lMaxCtrlStorage = max(lCurSysStorage, lCurPlayerStorage);
    bool bSysWin = lCurSysStorage > lCurPlayerStorage;

    if(lMaxCtrlStorage == lDVal)
    {
        wUserWinChance = (lCurSysStorage > 0 && lCurPlayerStorage == 0) ? 0 : 70;
       
    }
    else
    {
        //区间概率判断
        if(lDVal <= lMaxCtrlStorage * nCurParameterK / 100)
        {
            wUserWinChance = bSysWin ? 50 : 50;
        }
        else if(lDVal > lMaxCtrlStorage * nCurParameterK / 100 && lDVal <= 1.5 * lMaxCtrlStorage * nCurParameterK / 100)
        {
            wUserWinChance = bSysWin ? 45 : 55;
        }
        else if(lDVal > 1.5 * lMaxCtrlStorage * nCurParameterK / 100 && lDVal <= 2 * lMaxCtrlStorage * nCurParameterK / 100)
        {
            wUserWinChance = bSysWin ? 40 : 60;
        }
        else if(lDVal > 2 * lMaxCtrlStorage * nCurParameterK / 100 && lDVal <= 3 * lMaxCtrlStorage * nCurParameterK / 100)
        {
            wUserWinChance = bSysWin ? 35 : 65;
        }
        else if(lDVal > 3 * lMaxCtrlStorage * nCurParameterK / 100)
        {
            wUserWinChance = bSysWin ? 0 : 70;
        }
    }

    CString strRoomCtrlDesc;
    strRoomCtrlDesc.Format(TEXT("%d%%"), wUserWinChance);
    SetDlgItemText(IDC_STATIC_USER_CTRLDESC, strRoomCtrlDesc);
}

void CDialogAdvanced::OnBnClickedBtnCancelRoomctrl2()
{
    CListCtrl *pListCtrlRoom = (CListCtrl *)GetDlgItem(IDC_LIST_ROOM);

    pListCtrlRoom->DeleteAllItems();
    
   
    SendDebugMessage(SUB_C_DELETE_ALL_ROOM_CTRL);
   
}


void CDialogAdvanced::OnBnClickedBtnCancelUserctrl2()
{
    // TODO:  在此添加控件通知处理程序代码
    CListCtrl *pListCtrlUser = (CListCtrl *)GetDlgItem(IDC_LIST_USERSTORAGE);
    POSITION pos = pListCtrlUser->GetFirstSelectedItemPosition();

    if(!pos)
    {
        AfxMessageBox(TEXT("请选中某行！"), MB_ICONSTOP);

        return;
    }

    int nItem = pListCtrlUser->GetNextSelectedItem(pos);

    if(pListCtrlUser->GetItemText(nItem, 7) == L"进行中")
    {
        AfxMessageBox(TEXT("日志项中不能删除正在执行中的调试项！"), MB_ICONSTOP);
        return;
    }

    CMD_C_DELETE_USER UserCtrl;
    ZeroMemory(&UserCtrl, sizeof(UserCtrl));

    UserCtrl.dUserDebugID = _ttoi64(pListCtrlUser->GetItemText(nItem, 0));

    // 发送消息
    SendDebugMessage(SUB_C_DELETE_USER_CTRL_LOG, &UserCtrl, sizeof(UserCtrl));

    pListCtrlUser->DeleteItem(nItem);
}


void CDialogGeneral::OnBnClickedButtonChou()
{
    // TODO:  在此添加控件通知处理程序代码
    CMD_C_ChouPercent s_ChouPercent;

    s_ChouPercent.nChouShuiPercent = GetDlgItemInt(IDC_EDIT_ANCHOU_PERCENT);

    if(s_ChouPercent.nChouShuiPercent < 0 || s_ChouPercent.nChouShuiPercent>99)
    {
        AfxMessageBox(TEXT("抽水范围为0~99 ！"), MB_ICONSTOP);
        return;
    }
    SetDlgItemInt(IDC_EDIT_ANCHOU_PERCENT_CUR, s_ChouPercent.nChouShuiPercent);

    // 发送消息
    SendDebugMessage(SUB_C_SET_CHOU_PERCENT, &s_ChouPercent, sizeof(s_ChouPercent));

}


void CDialogGeneral::OnBnClickedBtnSetRoomctrl()
{
    // TODO:  在此添加控件通知处理程序代码
    CMD_C_RoomCtrl s_SetRoomCtrl;
    ZeroMemory(&s_SetRoomCtrl, sizeof(CMD_C_RoomCtrl));

    s_SetRoomCtrl.lResetParameterK = GetDlgItemInt(IDC_EDIT_RESET_PERCENT_ROOM2);
    if(s_SetRoomCtrl.lResetParameterK < 0 || s_SetRoomCtrl.lResetParameterK>99)
    {
        AfxMessageBox(TEXT("强制重置区间范围为0~99 ！"), MB_ICONSTOP);
        return;
    }
    s_SetRoomCtrl.lRoomCtrlParameterK = GetDlgItemInt(IDC_EDIT_ROOMCTRL_PARAMETER_K);
    if(s_SetRoomCtrl.lRoomCtrlParameterK < 0 || s_SetRoomCtrl.lRoomCtrlParameterK>99)
    {
        AfxMessageBox(TEXT("调节系数范围为0~99 ！"), MB_ICONSTOP);
        return;
    }
    s_SetRoomCtrl.lRoomCtrlPlayerStorage = GetDlgItemInt(IDC_EDIT_ROOMCTRL_PLAYERSTORAGE);
    s_SetRoomCtrl.lRoomCtrlSysStorage = GetDlgItemInt(IDC_EDIT_ROOMCTRL_SYSSTORAGE);
    if(s_SetRoomCtrl.lRoomCtrlPlayerStorage == 0 || s_SetRoomCtrl.lRoomCtrlSysStorage == 0)
    {
        AfxMessageBox(TEXT("库存配置不能为0 ！"), MB_ICONSTOP);
        return;
    }

    // 发送消息
    SendDebugMessage(SUB_C_ROOM_CTRL, &s_SetRoomCtrl, sizeof(s_SetRoomCtrl));
}


void CDialogGeneral::OnBnClickedButtonCancellRoom()
{
    // TODO:  在此添加控件通知处理程序代码
    CMD_C_Cancel_RoomCtrl  s_CancelRoomCtrl;

    CListCtrl *pListCtrlRoom = (CListCtrl *)GetDlgItem(IDC_LIST_ROOM_ITEM);
    POSITION pos = pListCtrlRoom->GetFirstSelectedItemPosition();

    if(!pos)
    {
        AfxMessageBox(TEXT("请选中某行！"), MB_ICONSTOP);

        return;
    }

    int nItem = pListCtrlRoom->GetNextSelectedItem(pos);

    s_CancelRoomCtrl.dRoomDebugID = _ttoi64(pListCtrlRoom->GetItemText(nItem, 0));

    // 发送消息
    SendDebugMessage(SUB_C_DELETE_ROOM_CTRL, &s_CancelRoomCtrl, sizeof(s_CancelRoomCtrl));

    pListCtrlRoom->DeleteAllItems();
}


void CDialogControl::OnBnClickedBtnDebugExc()
{
    // TODO:  在此添加控件通知处理程序代码
    CMD_C_ZuangDebug s_zuangCtrl;
    ZeroMemory(&s_zuangCtrl, sizeof(s_zuangCtrl));
  
    if(((CButton *)GetDlgItem(IDC_RADIO_WIN))->GetCheck())
    {
        s_zuangCtrl.zuangDebugInfo.debug_type = CONTINUE_WIN;
    }
    else
    {
        s_zuangCtrl.zuangDebugInfo.debug_type = CONTINUE_LOST;
    }
    s_zuangCtrl.zuangDebugInfo.cbDebugCount = (INT)((CComboBox *)GetDlgItem(IDC_COMBO_TIMES))->GetCurSel()+1;
   
    s_zuangCtrl.wTableID = m_tableID;
    if(m_tableID!=INVALID_WORD)
    SendDebugMessage(SUB_C_DIAN_USER_DEBUG, m_tableID-1, &s_zuangCtrl, sizeof(s_zuangCtrl));


}


void CDialogControl::OnBnClickedBtnDebugCancell()
{
    // TODO:  在此添加控件通知处理程序代码
    CMD_C_ZuangDebug s_zuangCtrl;
    ZeroMemory(&s_zuangCtrl, sizeof(s_zuangCtrl));

    s_zuangCtrl.zuangDebugInfo.bCancelDebug = TRUE;
    s_zuangCtrl.wTableID = m_tableID;
    if(m_tableID != INVALID_WORD)
        SendDebugMessage(SUB_C_DIAN_USER_DEBUG, m_tableID-1, &s_zuangCtrl, sizeof(s_zuangCtrl));
}


void CDialogControl::OnBnClickedBtnQuary()
{
    // TODO:  在此添加控件通知处理程序代码
    CMD_C_RequestQuery_User s_Quary;
    s_Quary.dwGameID = GetDlgItemInt(IDC_EDIT_USERID_DEBUG);
    if(s_Quary.dwGameID == 0)AfxMessageBox(TEXT("请输入玩家ID！"), MB_ICONWARNING);

    SendDebugMessage(SUB_C_REQUEST_QUERY_USER, &s_Quary, sizeof(s_Quary));
    
}



void CDialogAdvanced::OnBnClickedBtnClearDesk()
{
    CListCtrl *pListCtrlRoom = (CListCtrl *)GetDlgItem(IDC_LIST_DESK);
    POSITION pos = pListCtrlRoom->GetFirstSelectedItemPosition();

    if(!pos)
    {
        AfxMessageBox(TEXT("请选中某行！"), MB_ICONSTOP);

        return;
    }

    int nItem = pListCtrlRoom->GetNextSelectedItem(pos);

    if(pListCtrlRoom->GetItemText(nItem, 5) == L"进行中")
    {
        AfxMessageBox(TEXT("日志项中不能删除正在执行中的调试项！"), MB_ICONSTOP);
        return;
    }

    CMD_C_Delete_Desk_log DeskCtrl;
    ZeroMemory(&DeskCtrl, sizeof(DeskCtrl));

    DeskCtrl.dDeskDebugID = _ttoi64(pListCtrlRoom->GetItemText(nItem, 0));


    // 发送消息
    SendDebugMessage(SUB_C_CLRARE_DESK, &DeskCtrl, sizeof(DeskCtrl));

    pListCtrlRoom->DeleteItem(nItem);
}


void CDialogAdvanced::OnBnClickedBtnClearDeskall()
{
    CListCtrl *pListCtrlRoom = (CListCtrl *)GetDlgItem(IDC_LIST_DESK);

    pListCtrlRoom->DeleteAllItems();


    SendDebugMessage(SUB_C_CLEARE_DESK_ALL);
}

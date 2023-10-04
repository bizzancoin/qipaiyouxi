#include "stdafx.h"
#include "Resource.h"
#include "ClientDebugItemSink.h"
#include ".\clientdebugitemsink.h"

#define TIME_ROOMINFO							500	    //500毫秒刷新一次
#define IDI_REQUEST_UPDATE_ROOMINFO				111		//请求定时器

IMPLEMENT_DYNAMIC(CClientDebugItemSinkDlg, IClientDebugDlg)

BEGIN_MESSAGE_MAP(CClientDebugItemSinkDlg, IClientDebugDlg)
    ON_BN_CLICKED(IDC_BUTTON_UPDATE_STORAGE, OnUpdateStorage)
    ON_BN_CLICKED(IDC_BUTTON_MODIFY_STORAGE, OnModifyStorage)
    ON_BN_CLICKED(IDC_BT_CONTINUE_WIN, OnContinueDebugWin)
    ON_BN_CLICKED(IDC_BT_CONTINUE_LOST, OnContinueDebugLost)
    ON_BN_CLICKED(IDC_BT_CONTINUE_CANCEL, OnContinueDebugCancel)
    ON_BN_CLICKED(IDC_BTN_USER_BET_QUERY, OnBnClickedBtnUserBetQuery)
    ON_EN_SETFOCUS(IDC_EDIT_USER_ID, OnEnSetfocusEditUserId)
    ON_BN_CLICKED(IDC_RADIO_GAMEID, OnQueryUserGameID)
    ON_BN_CLICKED(IDC_RADIO_NICKNAME, OnQueryUserNickName)
    ON_WM_CTLCOLOR()
    ON_WM_TIMER()
END_MESSAGE_MAP()

CClientDebugItemSinkDlg::CClientDebugItemSinkDlg(CWnd *pParent /*=NULL*/)
    : IClientDebugDlg(CClientDebugItemSinkDlg::IDD, pParent)
{
    ZeroMemory(m_lMaxRoomStorage, sizeof(m_lMaxRoomStorage));
    ZeroMemory(m_wRoomStorageMul, sizeof(m_wRoomStorageMul));
    m_lRoomStorageCurrent = 0;
    m_lRoomStorageDeduct = 0;

    m_dwQueryUserGameID = INVALID_WORD;
    ZeroMemory(m_szQueryUserNickName, sizeof(m_szQueryUserNickName));
    m_QueryType = QUERY_INVALID;

    m_pParentWnd = NULL;
    m_pIClientDebugCallback = NULL;
}

CClientDebugItemSinkDlg::~CClientDebugItemSinkDlg()
{
}

void CClientDebugItemSinkDlg::DoDataExchange(CDataExchange *pDX)
{
    IClientDebugDlg::DoDataExchange(pDX);
    DDX_Control(pDX, IDC_BUTTON_UPDATE_STORAGE, m_btUpdateStorage);
    DDX_Control(pDX, IDC_BUTTON_MODIFY_STORAGE, m_btModifyStorage);
    DDX_Control(pDX, IDC_BT_CONTINUE_WIN, m_btContinueWin);
    DDX_Control(pDX, IDC_BT_CONTINUE_LOST, m_btContinueLost);
    DDX_Control(pDX, IDC_BT_CONTINUE_CANCEL, m_btContinueCancel);
    DDX_Control(pDX, IDC_BTN_USER_BET_QUERY, m_btQueryUser);
    DDX_Control(pDX, IDC_EDIT_ROOMCURRENT_STORAGE, m_editCurrentStorage);
    DDX_Control(pDX, IDC_EDIT_ROOMSTORAGE_DEDUCT, m_editStorageDeduct);
    DDX_Control(pDX, IDC_EDIT_ROOMSTORAGE_MAX1, m_editStorageMax1);
    DDX_Control(pDX, IDC_EDIT_ROOMSTORAGE_MUL1, m_editStorageMul1);
    DDX_Control(pDX, IDC_EDIT_ROOMSTORAGE_MAX2, m_editStorageMax2);
    DDX_Control(pDX, IDC_EDIT_ROOMSTORAGE_MUL2, m_editStorageMul2);
    DDX_Control(pDX, IDC_EDIT_USER_ID, m_editUserID);
    DDX_Control(pDX, IDC_EDIT_DEBUG_COUNT, m_editDebugCount);
    DDX_Control(pDX, IDC_RICHEDIT_USERDESCRIPTION, m_richEditUserDescription);
    DDX_Control(pDX, IDC_RICHEDIT_USERDEBUG, m_richEditUserDebug);
    DDX_Control(pDX, IDC_RICHEDIT_OPERATION_RECORD, m_richEditOperationRecord);
}

//初始化
BOOL CClientDebugItemSinkDlg::OnInitDialog()
{
    CSkinDialog::OnInitDialog();
    SetWindowText(TEXT("调试管理器"));

    SetDlgItemText(IDC_BUTTON_UPDATE_STORAGE, TEXT("更新库存"));
    SetDlgItemText(IDC_BUTTON_MODIFY_STORAGE, TEXT("修改上限"));

    //限制范围
    m_editStorageDeduct.LimitText(3);
    m_editStorageMul1.LimitText(2);
    m_editStorageMul2.LimitText(2);
    m_editCurrentStorage.LimitText(13);
    m_editStorageMax1.LimitText(13);
    m_editStorageMax2.LimitText(13);
    m_editDebugCount.LimitText(1);

    SetDlgItemText(IDC_EDIT_USER_ID, TEXT("请输入玩家ID或昵称"));
    GetDlgItem(IDC_EDIT_USER_ID)->EnableWindow(FALSE);
    GetDlgItem(IDC_BTN_USER_BET_QUERY)->EnableWindow(TRUE);
    GetDlgItem(IDC_EDIT_DEBUG_COUNT)->EnableWindow(FALSE);
    GetDlgItem(IDC_BT_CONTINUE_WIN)->EnableWindow(FALSE);
    GetDlgItem(IDC_BT_CONTINUE_LOST)->EnableWindow(FALSE);
    GetDlgItem(IDC_BT_CONTINUE_CANCEL)->EnableWindow(FALSE);

    m_richEditUserDescription.EnableWindow(FALSE);
    m_richEditUserDebug.EnableWindow(FALSE);
    m_richEditOperationRecord.EnableWindow(FALSE);

    SendDebugMessage(SUB_C_REQUEST_UDPATE_ROOMINFO, 0, 0);

    return TRUE;
}

// 释放接口
void CClientDebugItemSinkDlg::Release()
{
    delete this;
}

// 创建函数
bool CClientDebugItemSinkDlg::Create(CWnd *pParentWnd, IClientDebugCallback *pIClientDebugCallback)
{
    // 设置变量
    m_pParentWnd = pParentWnd;
    m_pIClientDebugCallback = pIClientDebugCallback;

    // 创建窗口
    __super::Create(IDD_CLIENT_DEBUG, GetDesktopWindow());

    return true;

}

// 显示窗口
bool CClientDebugItemSinkDlg::ShowWindow(bool bShow)
{
    // 显示窗口
    IClientDebugDlg::ShowWindow(bShow ? SW_SHOW : SW_HIDE);
    if(bShow)
    {
        SetUpdateIDI();
    }

    return true;
}

// 消息函数
bool CClientDebugItemSinkDlg::OnDebugMessage(WORD nMessageID, WORD wTableID, void *pBuffer, WORD wDataSize)
{
    // 无效接口
    if(m_pIClientDebugCallback == NULL)
    {
        return false;
    }

    switch(nMessageID)
    {
    case SUB_S_ADMIN_STORAGE_INFO:	//特殊客户端信息
    {
        ASSERT(wDataSize == sizeof(CMD_S_ADMIN_STORAGE_INFO));
        if(wDataSize != sizeof(CMD_S_ADMIN_STORAGE_INFO))
        {
            return false;
        }

        CMD_S_ADMIN_STORAGE_INFO *pStorage = (CMD_S_ADMIN_STORAGE_INFO *)pBuffer;
        SetStorageInfo(pStorage);
        return true;
    }
    case SUB_S_REQUEST_QUERY_RESULT:
    {
        ASSERT(wDataSize == sizeof(CMD_S_RequestQueryResult));
        if(wDataSize != sizeof(CMD_S_RequestQueryResult))
        {
            return false;
        }

        CMD_S_RequestQueryResult *pQueryResult = (CMD_S_RequestQueryResult *)pBuffer;
        RequestQueryResult(pQueryResult);

        return true;
    }
    case SUB_S_USER_DEBUG:
    {
        ASSERT(wDataSize == sizeof(CMD_S_UserDebug));
        if(wDataSize != sizeof(CMD_S_UserDebug))
        {
            return false;
        }

        CMD_S_UserDebug *pUserDebug = (CMD_S_UserDebug *)pBuffer;
        RoomUserDebugResult(pUserDebug);

        return true;
    }
    case SUB_S_USER_DEBUG_COMPLETE:
    {
        ASSERT(wDataSize == sizeof(CMD_S_UserDebugComplete));
        if(wDataSize != sizeof(CMD_S_UserDebugComplete))
        {
            return false;
        }

        CMD_S_UserDebugComplete *pUserDebugComplete = (CMD_S_UserDebugComplete *)pBuffer;
        UserDebugComplete(pUserDebugComplete);

        return true;
    }
    case SUB_S_OPERATION_RECORD:
    {
        ASSERT(wDataSize == sizeof(CMD_S_Operation_Record));
        if(wDataSize != sizeof(CMD_S_Operation_Record))
        {
            return false;
        }

        CMD_S_Operation_Record *pOperation_Record = (CMD_S_Operation_Record *)pBuffer;
        UpdateOperationRecord(pOperation_Record);

        return true;
    }
    case SUB_S_REQUEST_UDPATE_ROOMINFO_RESULT:
    {
        ASSERT(wDataSize == sizeof(CMD_S_RequestUpdateRoomInfo_Result));
        if(wDataSize != sizeof(CMD_S_RequestUpdateRoomInfo_Result))
        {
            return false;
        }

        CMD_S_RequestUpdateRoomInfo_Result *pRoomInfo_Result = (CMD_S_RequestUpdateRoomInfo_Result *)pBuffer;
        UpdateRoomInfoResult(pRoomInfo_Result);

        return true;
    }
    }
    return true;
}

//设置起始库存
void CClientDebugItemSinkDlg::SetRoomStorage(LONGLONG lRoomStartStorage, LONGLONG lRoomCurrentStorage)
{
    CString strBuf;
    strBuf.Format(SCORE_STRING, lRoomStartStorage);
    GetDlgItem(IDC_STATIC_ROOMSTART_STORAGE)->SetWindowText(strBuf);

    strBuf.Format(SCORE_STRING, lRoomCurrentStorage);
    GetDlgItem(IDC_STATIC_ROOMCURRENT_STORAGE)->SetWindowText(strBuf);

    //strBuf.Format(SCORE_STRING, lRoomCurrentStorage);
    //GetDlgItem(IDC_EDIT_ROOMCURRENT_STORAGE)->SetWindowText(strBuf);
}

void CClientDebugItemSinkDlg::SetStorageInfo(CMD_S_ADMIN_STORAGE_INFO *pStorageInfo)
{
    CString strBuf;
    //房间起始库存
    strBuf.Format(SCORE_STRING, pStorageInfo->lRoomStorageStart);
    GetDlgItem(IDC_STATIC_ROOMSTART_STORAGE)->SetWindowText(strBuf);
    //当前库存
    strBuf.Format(SCORE_STRING, pStorageInfo->lRoomStorageCurrent);
    GetDlgItem(IDC_STATIC_ROOMCURRENT_STORAGE)->SetWindowText(strBuf);
    //当前库存
    //strBuf.Format(SCORE_STRING, pStorageInfo->lRoomStorageCurrent);
    //GetDlgItem(IDC_EDIT_ROOMCURRENT_STORAGE)->SetWindowText(strBuf);
    //当前衰减
    strBuf.Format(SCORE_STRING, pStorageInfo->lRoomStorageDeduct);
    GetDlgItem(IDC_EDIT_ROOMSTORAGE_DEDUCT)->SetWindowText(strBuf);
    //库存上限1
    strBuf.Format(SCORE_STRING, pStorageInfo->lMaxRoomStorage[0]);
    GetDlgItem(IDC_EDIT_ROOMSTORAGE_MAX1)->SetWindowText(strBuf);
    //吐分概率
    strBuf.Format(TEXT("%d"), pStorageInfo->wRoomStorageMul[0]);
    GetDlgItem(IDC_EDIT_ROOMSTORAGE_MUL1)->SetWindowText(strBuf);
    //库存上限2
    strBuf.Format(SCORE_STRING, pStorageInfo->lMaxRoomStorage[1]);
    GetDlgItem(IDC_EDIT_ROOMSTORAGE_MAX2)->SetWindowText(strBuf);
    //吐分概率
    strBuf.Format(TEXT("%d"), pStorageInfo->wRoomStorageMul[1]);
    GetDlgItem(IDC_EDIT_ROOMSTORAGE_MUL2)->SetWindowText(strBuf);


    //保存数值
    m_lRoomStorageCurrent = pStorageInfo->lRoomStorageCurrent;
    m_lRoomStorageDeduct = pStorageInfo->lRoomStorageDeduct;
    CopyMemory(m_lMaxRoomStorage, pStorageInfo->lMaxRoomStorage, sizeof(m_lMaxRoomStorage));
    CopyMemory(m_wRoomStorageMul, pStorageInfo->wRoomStorageMul, sizeof(m_wRoomStorageMul));
}

HBRUSH CClientDebugItemSinkDlg::OnCtlColor(CDC *pDC, CWnd *pWnd, UINT nCtlColor)
{
    HBRUSH hbr = IClientDebugDlg::OnCtlColor(pDC, pWnd, nCtlColor);

    if(pWnd->GetDlgCtrlID() == IDC_STATIC_STORAGEINFO || pWnd->GetDlgCtrlID() == IDC_STATIC_ROOMSTART_STORAGE
            || pWnd->GetDlgCtrlID() == IDC_STATIC_ROOMCURRENT_STORAGE)
    {
        pDC->SetTextColor(RGB(255, 10, 10));
    }
    return hbr;
}

//修改库存上限
void CClientDebugItemSinkDlg::OnModifyStorage()
{
    CMD_C_ModifyStorage modifyStorage;
    ZeroMemory(&modifyStorage, sizeof(modifyStorage));

    CString strlMaxStorage0;
    CString strlMaxStorage1;
    GetDlgItemText(IDC_EDIT_ROOMSTORAGE_MAX1, strlMaxStorage0);
    GetDlgItemText(IDC_EDIT_ROOMSTORAGE_MAX2, strlMaxStorage1);

    CString strMul0;
    CString strMul1;
    GetDlgItemText(IDC_EDIT_ROOMSTORAGE_MUL1, strMul0);
    GetDlgItemText(IDC_EDIT_ROOMSTORAGE_MUL2, strMul1);

    //校验是否为空值
    if(strlMaxStorage0 == TEXT("") || strlMaxStorage1 == TEXT("")
            || strMul0 == TEXT("") || strMul1 == TEXT(""))
    {
        GetDlgItem(IDC_STATIC_STORAGEINFO)->SetWindowText(TEXT("您输入空值，请重新设置！"));
        //还原原来值
        CString strBuf;
        strBuf.Format(TEXT("%d"), m_lMaxRoomStorage[0]);
        GetDlgItem(IDC_EDIT_ROOMSTORAGE_MAX1)->SetWindowText(strBuf);
        //吐分概率
        strBuf.Format(TEXT("%d"), m_wRoomStorageMul[0]);
        GetDlgItem(IDC_EDIT_ROOMSTORAGE_MUL1)->SetWindowText(strBuf);
        //库存上限2
        strBuf.Format(TEXT("%I64d"), m_lMaxRoomStorage[1]);
        GetDlgItem(IDC_EDIT_ROOMSTORAGE_MAX2)->SetWindowText(strBuf);
        //吐分概率
        strBuf.Format(TEXT("%d"), m_wRoomStorageMul[1]);
        GetDlgItem(IDC_EDIT_ROOMSTORAGE_MUL2)->SetWindowText(strBuf);
        return;
    }

    strlMaxStorage0.TrimLeft();
    strlMaxStorage0.TrimRight();
    strlMaxStorage1.TrimLeft();
    strlMaxStorage1.TrimRight();
    LPTSTR lpsz1 = new TCHAR[strlMaxStorage0.GetLength() + 1];
    _tcscpy_s(lpsz1, strlMaxStorage0.GetLength() + 1, strlMaxStorage0);
    modifyStorage.lMaxRoomStorage[0] = _ttoi64(lpsz1);
    delete lpsz1;

    LPTSTR lpsz2 = new TCHAR[strlMaxStorage1.GetLength() + 1];
    _tcscpy_s(lpsz2, strlMaxStorage1.GetLength() + 1, strlMaxStorage1);
    modifyStorage.lMaxRoomStorage[1] = _ttoi64(lpsz2);
    delete lpsz2;

    modifyStorage.wRoomStorageMul[0] = GetDlgItemInt(IDC_EDIT_ROOMSTORAGE_MUL1);
    modifyStorage.wRoomStorageMul[1] = GetDlgItemInt(IDC_EDIT_ROOMSTORAGE_MUL2);

    //校验合法性
    if(modifyStorage.wRoomStorageMul[0] < 0 || modifyStorage.wRoomStorageMul[0] > 100 ||
            modifyStorage.wRoomStorageMul[1] < 0 || modifyStorage.wRoomStorageMul[1] > 100)
    {
        GetDlgItem(IDC_STATIC_STORAGEINFO)->SetWindowText(TEXT("赢分概率范围0-100"));
        return;
    }
    if(modifyStorage.lMaxRoomStorage[0] <= 0 || modifyStorage.lMaxRoomStorage[0] >= modifyStorage.lMaxRoomStorage[1])
    {
        GetDlgItem(IDC_STATIC_STORAGEINFO)->SetWindowText(TEXT("库存上限应该大于0且上限值2应该大于上限值1，请重新设置！"));
        return;
    }
    else if(modifyStorage.wRoomStorageMul[0] <= 0 || modifyStorage.wRoomStorageMul[0] >= modifyStorage.wRoomStorageMul[1])
    {
        GetDlgItem(IDC_STATIC_STORAGEINFO)->SetWindowText(TEXT("赢分概率应该大于0且赢分概率值2应该大于赢分概率值1"));
        return;
    }
    else
    {
        SendDebugMessage(SUB_C_STORAGEMAXMUL, &modifyStorage, sizeof(modifyStorage));

        GetDlgItem(IDC_STATIC_STORAGEINFO)->SetWindowText(TEXT("修改成功"));

        CopyMemory(m_wRoomStorageMul, modifyStorage.wRoomStorageMul, sizeof(m_wRoomStorageMul));
        CopyMemory(m_lMaxRoomStorage, modifyStorage.lMaxRoomStorage, sizeof(m_lMaxRoomStorage));
    }
}

//更新库存
void CClientDebugItemSinkDlg::OnUpdateStorage()
{
    CString str;
    CMD_C_UpdateStorage UpdateStorage;
    ZeroMemory(&UpdateStorage, sizeof(UpdateStorage));

    CString strStorageCurrent;
    GetDlgItemText(IDC_EDIT_ROOMCURRENT_STORAGE, strStorageCurrent);
    CString strStorageDudect;
    GetDlgItemText(IDC_EDIT_ROOMSTORAGE_DEDUCT, strStorageDudect);

    //校验是否为空值
    if(strStorageCurrent == TEXT("") || strStorageDudect == TEXT(""))
    {
        GetDlgItem(IDC_STATIC_STORAGEINFO)->SetWindowText(TEXT("您输入空值，请重新设置！"));
        CString strBuf;
        //当前库存
        strBuf.Format(TEXT("%I64d"), m_lRoomStorageCurrent);
        GetDlgItem(IDC_EDIT_ROOMCURRENT_STORAGE)->SetWindowText(strBuf);
        //当前衰减
        strBuf.Format(TEXT("%I64d"), m_lRoomStorageDeduct);
        GetDlgItem(IDC_EDIT_ROOMSTORAGE_DEDUCT)->SetWindowText(strBuf);

        return;
    }
    strStorageCurrent.TrimLeft();
    strStorageCurrent.TrimRight();
    LPTSTR lpsz = new TCHAR[strStorageCurrent.GetLength() + 1];
    _tcscpy_s(lpsz, strStorageCurrent.GetLength() + 1, strStorageCurrent);
    UpdateStorage.lRoomStorageCurrent = _ttoi64(lpsz);
    UpdateStorage.lRoomStorageDeduct = (SCORE)GetDlgItemInt(IDC_EDIT_ROOMSTORAGE_DEDUCT);
    delete lpsz;
    //校验合法性
    if(!(UpdateStorage.lRoomStorageDeduct >= 0 && UpdateStorage.lRoomStorageDeduct < 1000))
    {
        GetDlgItem(IDC_STATIC_STORAGEINFO)->SetWindowText(TEXT("库存衰减范围0-1000"));
        return;
    }
    SendDebugMessage(SUB_C_STORAGE, &UpdateStorage, sizeof(UpdateStorage));

    str = TEXT("库存已更新！");
    m_lRoomStorageCurrent = UpdateStorage.lRoomStorageCurrent;
    m_lRoomStorageDeduct = UpdateStorage.lRoomStorageDeduct;
    GetDlgItem(IDC_STATIC_STORAGEINFO)->SetWindowText(str);
    GetDlgItem(IDC_EDIT_ROOMCURRENT_STORAGE)->SetWindowText(TEXT(""));
}

BOOL CClientDebugItemSinkDlg::PreTranslateMessage(MSG *pMsg)
{
    if(pMsg->message == WM_KEYDOWN)
    {
        if(pMsg->wParam == VK_ESCAPE)
        {
            return true;
        }
    }
    return false;
}

void CClientDebugItemSinkDlg::OnCancel()
{
    ShowWindow(SW_HIDE);
}

void CClientDebugItemSinkDlg::OnEnSetfocusEditUserId()
{
    SetDlgItemText(IDC_EDIT_USER_ID, TEXT(""));
    m_richEditUserDescription.CleanScreen();
    m_richEditUserDebug.CleanScreen();
    SetDlgItemText(IDC_EDIT_DEBUG_COUNT, TEXT(""));
    GetDlgItem(IDC_EDIT_DEBUG_COUNT)->EnableWindow(FALSE);
    GetDlgItem(IDC_BT_CONTINUE_WIN)->EnableWindow(FALSE);
    GetDlgItem(IDC_BT_CONTINUE_LOST)->EnableWindow(FALSE);
    GetDlgItem(IDC_BT_CONTINUE_CANCEL)->EnableWindow(FALSE);

    m_dwQueryUserGameID = INVALID_WORD;
    ZeroMemory(m_szQueryUserNickName, sizeof(m_szQueryUserNickName));

    //SendDebugMessage(SUB_C_CLEAR_CURRENT_QUERYUSER, 0, 0);
}

void CClientDebugItemSinkDlg::OnQueryUserGameID()
{
    //SendDebugMessage(SUB_C_CLEAR_CURRENT_QUERYUSER, 0, 0);

    SetDlgItemText(IDC_EDIT_USER_ID, TEXT(""));
    m_richEditUserDescription.CleanScreen();
    m_richEditUserDebug.CleanScreen();
    SetDlgItemText(IDC_EDIT_DEBUG_COUNT, TEXT(""));
    GetDlgItem(IDC_EDIT_DEBUG_COUNT)->EnableWindow(FALSE);
    GetDlgItem(IDC_BT_CONTINUE_WIN)->EnableWindow(FALSE);
    GetDlgItem(IDC_BT_CONTINUE_LOST)->EnableWindow(FALSE);
    GetDlgItem(IDC_BT_CONTINUE_CANCEL)->EnableWindow(FALSE);

    m_QueryType = QUERY_USER_GAMEID;

    GetDlgItem(IDC_EDIT_USER_ID)->EnableWindow(TRUE);
    SetDlgItemText(IDC_EDIT_USER_ID, TEXT(""));

    //重设编辑框属性,加上ES_NUMBER风格
    DWORD dwStyle = m_editUserID.GetStyle();
    dwStyle |= ES_NUMBER;
    SetWindowLong(m_editUserID.m_hWnd, GWL_STYLE, dwStyle);
}

void CClientDebugItemSinkDlg::OnQueryUserNickName()
{
    //SendDebugMessage(SUB_C_CLEAR_CURRENT_QUERYUSER, 0, 0);

    SetDlgItemText(IDC_EDIT_USER_ID, TEXT(""));
    m_richEditUserDescription.CleanScreen();
    m_richEditUserDebug.CleanScreen();
    SetDlgItemText(IDC_EDIT_DEBUG_COUNT, TEXT(""));
    GetDlgItem(IDC_EDIT_DEBUG_COUNT)->EnableWindow(FALSE);
    GetDlgItem(IDC_BT_CONTINUE_WIN)->EnableWindow(FALSE);
    GetDlgItem(IDC_BT_CONTINUE_LOST)->EnableWindow(FALSE);
    GetDlgItem(IDC_BT_CONTINUE_CANCEL)->EnableWindow(FALSE);

    m_QueryType = QUERY_USER_NICKNAME;

    GetDlgItem(IDC_EDIT_USER_ID)->EnableWindow(TRUE);
    SetDlgItemText(IDC_EDIT_USER_ID, TEXT(""));

    //重设编辑框属性,删除ES_NUMBER风格
    DWORD dwStyle = m_editUserID.GetStyle();
    dwStyle &= ~ES_NUMBER;
    SetWindowLong(m_editUserID.m_hWnd, GWL_STYLE, dwStyle);
}

void CClientDebugItemSinkDlg::OnTimer(UINT_PTR nIDEvent)
{
    // 	switch(nIDEvent)
    // 	{
    // 	case IDI_REQUEST_UPDATE_ROOMINFO:
    // 		{
    // 			SendDebugMessage(SUB_C_REQUEST_UPDATE_ROOMINFO, 0, 0);
    // 			return;
    // 		}
    // 	}
    __super::OnTimer(nIDEvent);
}

void CClientDebugItemSinkDlg::OnContinueDebugWin()
{
    //读取调试局数
    CString strCount = TEXT("");
    GetDlgItemText(IDC_EDIT_DEBUG_COUNT, strCount);
    WORD wDebugCount = StrToInt(strCount);
    if(wDebugCount <= 0 || wDebugCount > 5)
    {
        CInformation information;
        information.ShowMessageBox(TEXT("温馨提示"), TEXT("调试局数范围为1到5"), MB_OK, 5);
        return;
    }

    ASSERT(!((m_dwQueryUserGameID == INVALID_WORD) && (m_szQueryUserNickName[0] == 0)));

    CMD_C_UserDebug UserDebug;
    ZeroMemory(&UserDebug, sizeof(UserDebug));
    UserDebug.dwGameID = m_dwQueryUserGameID;
    CopyMemory(UserDebug.szNickName, m_szQueryUserNickName, sizeof(m_szQueryUserNickName));
    UserDebug.userDebugInfo.bCancelDebug = false;
    UserDebug.userDebugInfo.cbDebugCount = wDebugCount;
    UserDebug.userDebugInfo.debug_type = CONTINUE_WIN;

    SendDebugMessage(SUB_C_USER_DEBUG, &UserDebug, sizeof(UserDebug));
}

void CClientDebugItemSinkDlg::OnContinueDebugLost()
{
    //读取调试局数
    CString strCount = TEXT("");
    GetDlgItemText(IDC_EDIT_DEBUG_COUNT, strCount);
    WORD wDebugCount = StrToInt(strCount);
    if(wDebugCount <= 0 || wDebugCount > 5)
    {
        CInformation information;
        information.ShowMessageBox(TEXT("温馨提示"), TEXT("调试局数范围为1到5"), MB_OK, 5);
        return;
    }

    ASSERT(!((m_dwQueryUserGameID == INVALID_WORD) && (m_szQueryUserNickName[0] == 0)));

    CMD_C_UserDebug UserDebug;
    ZeroMemory(&UserDebug, sizeof(UserDebug));
    UserDebug.dwGameID = m_dwQueryUserGameID;
    CopyMemory(UserDebug.szNickName, m_szQueryUserNickName, sizeof(m_szQueryUserNickName));
    UserDebug.userDebugInfo.bCancelDebug = false;
    UserDebug.userDebugInfo.cbDebugCount = wDebugCount;
    UserDebug.userDebugInfo.debug_type = CONTINUE_LOST;

    SendDebugMessage(SUB_C_USER_DEBUG, &UserDebug, sizeof(UserDebug));
}

void CClientDebugItemSinkDlg::OnContinueDebugCancel()
{
    ASSERT(!((m_dwQueryUserGameID == INVALID_WORD) && (m_szQueryUserNickName[0] == 0)));

    CMD_C_UserDebug UserDebug;
    ZeroMemory(&UserDebug, sizeof(UserDebug));
    UserDebug.dwGameID = m_dwQueryUserGameID;
    CopyMemory(UserDebug.szNickName, m_szQueryUserNickName, sizeof(m_szQueryUserNickName));
    UserDebug.userDebugInfo.bCancelDebug = true;
    UserDebug.userDebugInfo.debug_type = CONTINUE_CANCEL;

    SendDebugMessage(SUB_C_USER_DEBUG, &UserDebug, sizeof(UserDebug));

    GetDlgItem(IDC_EDIT_DEBUG_COUNT)->SetWindowText(TEXT(""));
}

void CClientDebugItemSinkDlg::OnBnClickedBtnUserBetQuery()
{
    m_richEditUserDebug.CleanScreen();

    if(m_QueryType == QUERY_INVALID)
    {
        m_richEditUserDebug.InsertString(TEXT("请正确选择查询的类型然后再重新输入！"), RGB(255, 10, 10));

        return;
    }

    //读取用户ID
    CString strUser = TEXT("");
    GetDlgItemText(IDC_EDIT_USER_ID, strUser);

    if(strUser == TEXT(""))
    {
        CInformation information;
        information.ShowMessageBox(TEXT("温馨提示"), TEXT("请正确输入玩家ID或昵称"), MB_OK, 5);
        return;
    }

    //去掉空格
    CString szStr = strUser;
    szStr.TrimLeft();
    szStr.TrimRight();

    CMD_C_RequestQuery_User	QueryUser;
    ZeroMemory(&QueryUser, sizeof(QueryUser));

    ASSERT(m_QueryType != QUERY_INVALID);

    //查询GAMEID
    if(m_QueryType == QUERY_USER_GAMEID)
    {
        QueryUser.dwGameID = StrToInt(szStr);
        m_dwQueryUserGameID = StrToInt(szStr);
    }
    else if(m_QueryType == QUERY_USER_NICKNAME)
    {
        CopyMemory(QueryUser.szNickName, szStr, sizeof(QueryUser.szNickName));
        CopyMemory(m_szQueryUserNickName, szStr, sizeof(m_szQueryUserNickName));
    }

    SendDebugMessage(SUB_C_REQUEST_QUERY_USER, &QueryUser, sizeof(QueryUser));
}

//查询用户结果
void CClientDebugItemSinkDlg::RequestQueryResult(CMD_S_RequestQueryResult *pQueryResult)
{
    //清空屏幕
    m_richEditUserDescription.CleanScreen();
    m_richEditUserDebug.CleanScreen();
    GetDlgItem(IDC_EDIT_DEBUG_COUNT)->EnableWindow(FALSE);
    GetDlgItem(IDC_BT_CONTINUE_WIN)->EnableWindow(FALSE);
    GetDlgItem(IDC_BT_CONTINUE_LOST)->EnableWindow(FALSE);
    GetDlgItem(IDC_BT_CONTINUE_CANCEL)->EnableWindow(FALSE);

    if(pQueryResult->bFind == false)
    {
        m_richEditUserDescription.InsertString(TEXT("查询不到该玩家的信息，可能该玩家尚未进去该游戏房间或者未进入任何一张桌子！"), RGB(255, 10, 10));
        return;
    }
    else  //查询到目标玩家
    {
        CString strUserInfo;
        CString strUserStatus;
        CString strGameStatus;
        CString strSatisfyDebug;
        CString strAndroid = (pQueryResult->userinfo.bAndroid == true ? TEXT("为AI") : TEXT("为真人玩家"));
        bool bEnableDebug = false;
        GetGameStatusString(pQueryResult, strGameStatus);
        GetUserStatusString(pQueryResult, strUserStatus);
        GetSatisfyDebugString(pQueryResult, strSatisfyDebug, bEnableDebug);

        if(pQueryResult->userinfo.wChairID != INVALID_CHAIR && pQueryResult->userinfo.wTableID != INVALID_TABLE)
        {
            strUserInfo.Format(TEXT("查询玩家【%s】 %s,正在第%d号桌子，第%d号椅子进行游戏，用户状态为%s,游戏状态为%s,%s ! "), pQueryResult->userinfo.szNickName,
                               strAndroid, pQueryResult->userinfo.wTableID, pQueryResult->userinfo.wChairID, strUserStatus, strGameStatus, strSatisfyDebug);

            m_richEditUserDescription.InsertString(strUserInfo, RGB(255, 10, 10));

            if(bEnableDebug)
            {
                GetDlgItem(IDC_EDIT_DEBUG_COUNT)->EnableWindow(TRUE);
                GetDlgItem(IDC_BT_CONTINUE_WIN)->EnableWindow(TRUE);
                GetDlgItem(IDC_BT_CONTINUE_LOST)->EnableWindow(TRUE);
                GetDlgItem(IDC_BT_CONTINUE_CANCEL)->EnableWindow(TRUE);
            }
        }
        else
        {
            strUserInfo.Format(TEXT("查询玩家【%s】 %s 不在任何桌子，不满足调试条件！"), pQueryResult->userinfo.szNickName, strAndroid);

            m_richEditUserDescription.InsertString(strUserInfo, RGB(255, 10, 10));
            return;
        }
    }
}

//获取用户状态
void CClientDebugItemSinkDlg::GetUserStatusString(CMD_S_RequestQueryResult *pQueryResult, CString &userStatus)
{
    ASSERT(pQueryResult->bFind);

    switch(pQueryResult->userinfo.cbUserStatus)
    {
    case US_NULL:
    {
        userStatus = TEXT("没有");
        return;
    }
    case US_FREE:
    {
        userStatus = TEXT("站立");
        return;
    }
    case US_SIT:
    {
        userStatus = TEXT("坐下");
        return;
    }
    case US_READY:
    {
        userStatus = TEXT("同意");
        return;
    }
    case US_LOOKON:
    {
        userStatus = TEXT("旁观");
        return;
    }
    case US_PLAYING:
    {
        userStatus = TEXT("游戏");
        return;
    }
    case US_OFFLINE:
    {
        userStatus = TEXT("断线");
        return;
    }
    ASSERT(FALSE);
    }
}

//获取用户状态
void CClientDebugItemSinkDlg::GetGameStatusString(CMD_S_RequestQueryResult *pQueryResult, CString &gameStatus)
{
    ASSERT(pQueryResult->bFind);

    switch(pQueryResult->userinfo.cbGameStatus)
    {
    case GS_TK_FREE:
    {
        gameStatus = TEXT("空闲");
        return;
    }
    case GS_TK_CALL:
    {
        gameStatus = TEXT("叫庄");
        return;
    }
    case GS_TK_SCORE:
    {
        gameStatus = TEXT("下注");
        return;
    }
    case GS_TK_PLAYING:
    {
        gameStatus = TEXT("游戏进行");
        return;
    }
    ASSERT(FALSE);
    }
}

//获取是否满足调试
void CClientDebugItemSinkDlg::GetSatisfyDebugString(CMD_S_RequestQueryResult *pQueryResult, CString &satisfyDebug, bool &bEnableDebug)
{
    ASSERT(pQueryResult->bFind);

    if(pQueryResult->userinfo.wChairID == INVALID_CHAIR || pQueryResult->userinfo.wTableID == INVALID_TABLE)
    {
        satisfyDebug = TEXT("不满足调试");
        bEnableDebug = FALSE;
        return;
    }

    if(pQueryResult->userinfo.cbUserStatus == US_SIT || pQueryResult->userinfo.cbUserStatus == US_READY || pQueryResult->userinfo.cbUserStatus == US_PLAYING)
    {
        if(pQueryResult->userinfo.cbGameStatus == GS_TK_FREE || pQueryResult->userinfo.cbGameStatus == GS_TK_CALL || pQueryResult->userinfo.cbGameStatus == GS_TK_SCORE)
        {
            satisfyDebug = TEXT("满足调试,该局开始调试");
            bEnableDebug = TRUE;
            return;
        }
        else
        {
            satisfyDebug = TEXT("满足调试，下局开始调试");
            bEnableDebug = TRUE;
            return;
        }
    }
    else
    {
        satisfyDebug = TEXT("不满足调试");
        bEnableDebug = FALSE;
        return;
    }
}

//房间用户调试结果
void CClientDebugItemSinkDlg::RoomUserDebugResult(CMD_S_UserDebug *pUserDebug)
{
    m_richEditUserDebug.CleanScreen();

    //调试结果
    CString strDebugInfo;
    CString strDebugType;

    switch(pUserDebug->debugResult)
    {
    case DEBUG_SUCCEED:
    {
        GetDebugTypeString(pUserDebug->debugType, strDebugType);

        if(pUserDebug->debugType == CONTINUE_WIN || pUserDebug->debugType == CONTINUE_LOST)
        {
            strDebugInfo.Format(TEXT("玩家【%s】调试成功，%s, 调试局数 %d 局 ！"), pUserDebug->szNickName, strDebugType, pUserDebug->cbDebugCount);
        }

        m_richEditUserDebug.InsertString(strDebugInfo, RGB(255, 10, 10));
        break;
    }
    case DEBUG_FAIL:
    {
        if(pUserDebug->debugType == CONTINUE_WIN || pUserDebug->debugType == CONTINUE_LOST)
        {
            strDebugInfo.Format(TEXT("玩家【%s】调试失败，该玩家状态或者游戏状态不满足调试的条件 ！"), pUserDebug->szNickName);
        }

        m_richEditUserDebug.InsertString(strDebugInfo, RGB(255, 10, 10));
        break;
    }
    case DEBUG_CANCEL_SUCCEED:
    {
        strDebugInfo.Format(TEXT("玩家【%s】取消调试成功 ！"), pUserDebug->szNickName);

        m_richEditUserDebug.InsertString(strDebugInfo, RGB(255, 10, 10));
        break;
    }
    case DEBUG_CANCEL_INVALID:
    {
        strDebugInfo.Format(TEXT("玩家【%s】取消调试失败，该玩家不存在调试或者调试已完成 ！"), pUserDebug->szNickName);

        m_richEditUserDebug.InsertString(strDebugInfo, RGB(255, 10, 10));
        break;
    }
    ASSERT(FALSE);
    }

}

//用户调试完成
void CClientDebugItemSinkDlg::UserDebugComplete(CMD_S_UserDebugComplete *pUserDebugComplete)
{
    m_richEditUserDebug.CleanScreen();

    ASSERT(pUserDebugComplete->debugType != CONTINUE_CANCEL);

    //调试结果
    CString strDebugInfo;
    CString strDebugType;

    switch(pUserDebugComplete->debugType)
    {
    case CONTINUE_WIN:
    {
        GetDebugTypeString(pUserDebugComplete->debugType, strDebugType);

        strDebugInfo.Format(TEXT("玩家【%s】%s, 剩余调试局数为 %d 局 ！"), pUserDebugComplete->szNickName, strDebugType, pUserDebugComplete->cbRemainDebugCount);

        m_richEditUserDebug.InsertString(strDebugInfo, RGB(255, 10, 10));
        break;
    }
    case CONTINUE_LOST:
    {
        GetDebugTypeString(pUserDebugComplete->debugType, strDebugType);

        strDebugInfo.Format(TEXT("玩家【%s】%s, 剩余调试局数为 %d 局 ！"), pUserDebugComplete->szNickName, strDebugType, pUserDebugComplete->cbRemainDebugCount);

        m_richEditUserDebug.InsertString(strDebugInfo, RGB(255, 10, 10));
        break;
    }
    }
}

//操作记录
void CClientDebugItemSinkDlg::UpdateOperationRecord(CMD_S_Operation_Record *pOperation_Record)
{
    m_richEditOperationRecord.CleanScreen();

    m_richEditOperationRecord.EnableWindow(TRUE);
    //变量定义
    TCHAR szRecord[MAX_OPERATION_RECORD][RECORD_LENGTH];
    ZeroMemory(szRecord, sizeof(szRecord));
    CopyMemory(szRecord, pOperation_Record->szRecord, sizeof(szRecord));
    WORD wRecordCount = 1;
    CString strCount;

    for(WORD i = 0; i < MAX_OPERATION_RECORD; i++)
    {
        for(WORD j = 0; j < RECORD_LENGTH; j++)
        {
            if(szRecord[i][j] == 0)
            {
                break;
            }

            if(szRecord[i][j] != 0)
            {
                strCount.Format(TEXT("第【%d】条-%s"), wRecordCount, szRecord[i]);

                m_richEditOperationRecord.InsertString(strCount, RGB(255, 10, 10));
                m_richEditOperationRecord.InsertString(TEXT("\n"), RGB(255, 10, 10));

                wRecordCount++;
                break;
            }
        }
    }
}

//设置更新定时器
void CClientDebugItemSinkDlg::SetUpdateIDI()
{
    //设置更新定时器
    //SetTimer(IDI_REQUEST_UPDATE_ROOMINFO, TIME_ROOMINFO, NULL);
}

//更新房间信息
void CClientDebugItemSinkDlg::UpdateRoomInfoResult(CMD_S_RequestUpdateRoomInfo_Result *RoomInfo_Result)
{
    CString strBuf;
    strBuf.Format(SCORE_STRING, RoomInfo_Result->lRoomStorageCurrent);
    GetDlgItem(IDC_STATIC_ROOMCURRENT_STORAGE)->SetWindowText(strBuf);

    if(m_dwQueryUserGameID == INVALID_WORD && m_szQueryUserNickName[0] == 0)
    {
        SendDebugMessage(SUB_C_CLEAR_CURRENT_QUERYUSER, 0, 0);

        return;
    }

    if(RoomInfo_Result->currentqueryuserinfo.dwGameID == 0 &&
            RoomInfo_Result->currentqueryuserinfo.wChairID == 0 &&
            RoomInfo_Result->currentqueryuserinfo.wTableID == 0)
    {
        return;
    }

    GetDlgItem(IDC_BT_CONTINUE_WIN)->EnableWindow(FALSE);
    GetDlgItem(IDC_BT_CONTINUE_LOST)->EnableWindow(FALSE);
    GetDlgItem(IDC_BT_CONTINUE_CANCEL)->EnableWindow(FALSE);

    CMD_S_RequestQueryResult QueryResult;
    ZeroMemory(&QueryResult, sizeof(QueryResult));
    QueryResult.bFind = true;
    CopyMemory(&(QueryResult.userinfo), &(RoomInfo_Result->currentqueryuserinfo), sizeof(QueryResult.userinfo));

    static CString strDuplicate = TEXT("");
    CString strUserInfo;
    CString strUserStatus;
    CString strGameStatus;
    CString strSatisfyDebug;
    CString strAndroid = (QueryResult.userinfo.bAndroid == true ? TEXT("为AI") : TEXT("为真人玩家"));
    bool bEnableDebug = false;
    GetGameStatusString(&QueryResult, strGameStatus);
    GetUserStatusString(&QueryResult, strUserStatus);
    GetSatisfyDebugString(&QueryResult, strSatisfyDebug, bEnableDebug);

    if(QueryResult.userinfo.wChairID != INVALID_CHAIR && QueryResult.userinfo.wTableID != INVALID_TABLE)
    {
        strUserInfo.Format(TEXT("查询玩家【%s】 %s,正在第%d号桌子，第%d号椅子进行游戏，用户状态为%s,游戏状态为%s,%s ! "), QueryResult.userinfo.szNickName,
                           strAndroid, QueryResult.userinfo.wTableID, QueryResult.userinfo.wChairID, strUserStatus, strGameStatus, strSatisfyDebug);

        if(strDuplicate != strUserInfo)
        {
            m_richEditUserDescription.CleanScreen();
            m_richEditUserDescription.InsertString(strUserInfo, RGB(255, 10, 10));
            strDuplicate = strUserInfo;
        }

        if(bEnableDebug)
        {
            GetDlgItem(IDC_EDIT_DEBUG_COUNT)->EnableWindow(TRUE);
            GetDlgItem(IDC_BT_CONTINUE_WIN)->EnableWindow(TRUE);
            GetDlgItem(IDC_BT_CONTINUE_LOST)->EnableWindow(TRUE);
            GetDlgItem(IDC_BT_CONTINUE_CANCEL)->EnableWindow(TRUE);
        }
    }
    else
    {
        strUserInfo.Format(TEXT("查询玩家【%s】 %s 不在任何桌子，不满足调试条件！"), QueryResult.userinfo.szNickName, strAndroid);

        if(strDuplicate != strUserInfo)
        {
            m_richEditUserDescription.CleanScreen();
            m_richEditUserDescription.InsertString(strUserInfo, RGB(255, 10, 10));
            strDuplicate = strUserInfo;
        }

    }

    //存在调试
    if(RoomInfo_Result->bExistDebug == true)
    {
        m_richEditUserDebug.CleanScreen();

        ASSERT(RoomInfo_Result->currentuserdebug.debug_type != CONTINUE_CANCEL);

        //调试结果
        CString strDebugInfo;
        CString strDebugType;

        switch(RoomInfo_Result->currentuserdebug.debug_type)
        {
        case CONTINUE_WIN:
        {
            GetDebugTypeString(RoomInfo_Result->currentuserdebug.debug_type, strDebugType);

            strDebugInfo.Format(TEXT("玩家【%s】%s, 剩余调试局数为 %d 局 ！"), QueryResult.userinfo.szNickName, strDebugType, RoomInfo_Result->currentuserdebug.cbDebugCount);

            m_richEditUserDebug.InsertString(strDebugInfo, RGB(255, 10, 10));
            break;
        }
        case CONTINUE_LOST:
        {
            GetDebugTypeString(RoomInfo_Result->currentuserdebug.debug_type, strDebugType);

            strDebugInfo.Format(TEXT("玩家【%s】%s, 剩余调试局数为 %d 局 ！"), QueryResult.userinfo.szNickName, strDebugType, RoomInfo_Result->currentuserdebug.cbDebugCount);

            m_richEditUserDebug.InsertString(strDebugInfo, RGB(255, 10, 10));
            break;
        }
        ASSERT(FALSE);
        }
    }
}

//获取调试类型
void CClientDebugItemSinkDlg::GetDebugTypeString(DEBUG_TYPE &debugType, CString &debugTypestr)
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

// 调试信息
bool CClientDebugItemSinkDlg::SendDebugMessage(UINT nMessageID, void *pData, UINT nSize)
{
    if(m_pIClientDebugCallback != NULL)
    {
        // 获取信息
        CString StrTableID;
        //GetDlgItem(IDC_EDIT_TABLE_ID)->GetWindowText(StrTableID);

        // 判断有效值
        if(StrTableID.IsEmpty())
        {
            StrTableID = TEXT("0");
            //// 提示信息
            //::MessageBox( GetSafeHwnd(), _T("指定桌子接收消息,请输入有效参数。"), _T("提示"), MB_OK );

            //return false;
        }
        // 发送消息
        m_pIClientDebugCallback->OnDebugInfo(nMessageID, _ttoi(StrTableID), pData, nSize);
    }
    return true;
}




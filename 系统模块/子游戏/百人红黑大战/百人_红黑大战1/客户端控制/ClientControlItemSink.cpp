// ClientControlItemSink.cpp : 实现文件
//

#include "stdafx.h"
#include "Resource.h"
#include "ClientControlItemSink.h"
#include ".\clientcontrolitemsink.h"


// CClientControlItemSinkDlg 对话框

IMPLEMENT_DYNAMIC(CClientControlItemSinkDlg, IClientControlDlg)

BEGIN_MESSAGE_MAP(CClientControlItemSinkDlg, IClientControlDlg)
	ON_BN_CLICKED(IDC_BT_RESET,OnReSet)
	ON_BN_CLICKED(IDC_BT_EXCUTE,OnExcute)
	ON_BN_CLICKED(IDC_BT_CURSET,OnRefresh)
	ON_BN_CLICKED(IDC_BTN_UPDATE_STORAGE, OnBnClickedBtnUpdateStorage)
	ON_BN_CLICKED(IDC_BTN_USER_BET_QUERY, OnBnClickedBtnUserBetQuery)
	ON_BN_CLICKED(IDC_BTN_USER_BET_ALL, OnBnClickedBtnUserBetAll)
	ON_EN_SETFOCUS(IDC_EDIT_USER_ID, OnEnSetfocusEditUserId)	
	ON_WM_CTLCOLOR()
END_MESSAGE_MAP()

// CClientControlItemSinkDlg 消息处理程序
CClientControlItemSinkDlg::CClientControlItemSinkDlg(CWnd* pParent /*=NULL*/)
	: IClientControlDlg(CClientControlItemSinkDlg::IDD, pParent)
{
	m_cbWinArea=0;				//赢牌区域
	m_cbExcuteTimes=0;			//执行次数
	m_lStorageStart = 0;
	m_lStorageDeduct = 0;
	m_lStorageCurrent = 0;
	m_lStorageMax1 = 0;
	m_lStorageMul1 = 0;
	m_lStorageMax2 = 0;
	m_lStorageMul2 = 0;

	m_UserBetArray.RemoveAll();

	m_lQueryGameID = -1;
}

CClientControlItemSinkDlg::~CClientControlItemSinkDlg()
{
}

void CClientControlItemSinkDlg::DoDataExchange(CDataExchange* pDX)
{
	IClientControlDlg::DoDataExchange(pDX);

	DDX_Text(pDX,IDC_EDIT_STORAGE_START,m_lStorageStart);
	DDX_Text(pDX,IDC_EDIT_STORAGE_DEDUCT,m_lStorageDeduct);
	DDX_Text(pDX,IDC_EDIT_STORAGE_CURRENT,m_lStorageCurrent);
	DDX_Text(pDX,IDC_EDIT_STORAGE_MAX1,m_lStorageMax1);
	DDX_Text(pDX,IDC_EDIT_STORAGE_MUL1,m_lStorageMul1);
	DDX_Text(pDX,IDC_EDIT_STORAGE_MAX2,m_lStorageMax2);
	DDX_Text(pDX,IDC_EDIT_STORAGE_MUL2,m_lStorageMul2);

	/*DDV_MinMaxLongLong(pDX,m_lStorageStart, 0, LLONG_MAX);
	DDV_MinMaxLongLong(pDX,m_lStorageDeduct, 0, 1000);
	DDV_MinMaxLongLong(pDX,m_lStorageCurrent, 0, LLONG_MAX);
	DDV_MinMaxLongLong(pDX,m_lStorageMax1, 0, LLONG_MAX);
	DDV_MinMaxLongLong(pDX,m_lStorageMul1, 0, 100);
	DDV_MinMaxLongLong(pDX,m_lStorageMax2, 0, LLONG_MAX);
	DDV_MinMaxLongLong(pDX,m_lStorageMul2, 0, 100);*/

	DDX_Control(pDX, IDC_LIST_USER_BET, m_listUserBet);
	DDX_Control(pDX, IDC_LIST_USER_BET_ALL, m_listUserBetAll);
}

//初始化
BOOL CClientControlItemSinkDlg::OnInitDialog()
{
	IClientControlDlg::OnInitDialog();

	//区域控制		
	((CComboBox*)GetDlgItem(IDC_COMBO_TIMES))->AddString(TEXT("1"));	
	((CComboBox*)GetDlgItem(IDC_COMBO_TIMES))->AddString(TEXT("2"));	
	((CComboBox*)GetDlgItem(IDC_COMBO_TIMES))->AddString(TEXT("3"));	
	((CComboBox*)GetDlgItem(IDC_COMBO_TIMES))->AddString(TEXT("4"));	
	((CComboBox*)GetDlgItem(IDC_COMBO_TIMES))->AddString(TEXT("5"));	
	
	((CComboBox*)GetDlgItem(IDC_COMBO_TIMES))->SetCurSel(0);

	GetDlgItem(IDC_STATIC_CONTROL_INFO)->SetWindowText(TEXT(""));
	GetDlgItem(IDC_STATIC_STORAGE_INFO)->SetWindowText(TEXT(""));

	//玩家下注
	m_listUserBet.SetExtendedStyle(m_listUserBet.GetExtendedStyle()|LVS_EX_FULLROWSELECT|LVS_EX_GRIDLINES);
	m_listUserBet.GetHeaderCtrl()->EnableWindow(false);
	INT nColumnCount=0;
	m_listUserBet.InsertColumn(nColumnCount++,TEXT(""),LVCFMT_CENTER,0);
	m_listUserBet.InsertColumn(nColumnCount++,TEXT("序号"),LVCFMT_CENTER,40);
	m_listUserBet.InsertColumn(nColumnCount++,TEXT("玩家昵称"),LVCFMT_CENTER,75);
	m_listUserBet.InsertColumn(nColumnCount++,TEXT("玩家ID"),LVCFMT_CENTER,50);
	m_listUserBet.InsertColumn(nColumnCount++,TEXT("带入金币"),LVCFMT_CENTER,90);
	m_listUserBet.InsertColumn(nColumnCount++,TEXT("总输赢"),LVCFMT_CENTER,90);
	m_listUserBet.InsertColumn(nColumnCount++,TEXT("闲"),LVCFMT_CENTER,75);
	m_listUserBet.InsertColumn(nColumnCount++,TEXT("平"),LVCFMT_CENTER,75);
	m_listUserBet.InsertColumn(nColumnCount++,TEXT("庄"),LVCFMT_CENTER,75);
	m_listUserBet.InsertColumn(nColumnCount++,TEXT("闲对子"),LVCFMT_CENTER,75);
	m_listUserBet.InsertColumn(nColumnCount++,TEXT("庄对子"),LVCFMT_CENTER,75);
	m_listUserBet.InsertColumn(nColumnCount++,TEXT("闲天王"),LVCFMT_CENTER,75);
	m_listUserBet.InsertColumn(nColumnCount++,TEXT("庄天王"),LVCFMT_CENTER,75);
	m_listUserBet.InsertColumn(nColumnCount++,TEXT("同点平"),LVCFMT_CENTER,75);

	m_listUserBetAll.SetExtendedStyle(m_listUserBetAll.GetExtendedStyle()|LVS_EX_GRIDLINES);
	nColumnCount=0;
	m_listUserBetAll.InsertColumn(nColumnCount++,TEXT(""),LVCFMT_CENTER,0);
	m_listUserBetAll.InsertColumn(nColumnCount++,TEXT(""),LVCFMT_CENTER,165);
	m_listUserBetAll.InsertColumn(nColumnCount++,TEXT(""),LVCFMT_CENTER,180);
	m_listUserBetAll.InsertColumn(nColumnCount++,TEXT(""),LVCFMT_CENTER,75);
	m_listUserBetAll.InsertColumn(nColumnCount++,TEXT(""),LVCFMT_CENTER,75);
	m_listUserBetAll.InsertColumn(nColumnCount++,TEXT(""),LVCFMT_CENTER,75);
	m_listUserBetAll.InsertColumn(nColumnCount++,TEXT(""),LVCFMT_CENTER,75);
	m_listUserBetAll.InsertColumn(nColumnCount++,TEXT(""),LVCFMT_CENTER,75);
	m_listUserBetAll.InsertColumn(nColumnCount++,TEXT(""),LVCFMT_CENTER,75);
	m_listUserBetAll.InsertColumn(nColumnCount++,TEXT(""),LVCFMT_CENTER,75);
	m_listUserBetAll.InsertColumn(nColumnCount++,TEXT(""),LVCFMT_CENTER,75);
	m_listUserBetAll.InsertItem(0, TEXT(""));
	m_listUserBetAll.SetItemText(0, 1, TEXT("真实玩家下注统计"));
	for(BYTE cbSubItem=3; cbSubItem <=10; cbSubItem++)
	{
		m_listUserBetAll.SetItemText(0, cbSubItem, TEXT("0"));
	}

	SetDlgItemText(IDC_EDIT_USER_ID, TEXT("请输入玩家ID"));
	
	GetDlgItem(IDC_BTN_USER_BET_QUERY)->EnableWindow(true);
	GetDlgItem(IDC_BTN_USER_BET_ALL)->EnableWindow(false);

	return TRUE;
}

void CClientControlItemSinkDlg::OnReSet()
{
	CMD_C_AdminReq adminReq;
	adminReq.cbReqType=RQ_RESET_CONTROL;
	CGameFrameEngine::GetInstance()->SendMessage(IDM_ADMIN_COMMDN,(WPARAM)&adminReq,0);
}

void CClientControlItemSinkDlg::OnRefresh()
{
	CMD_C_AdminReq adminReq;
	adminReq.cbReqType=RQ_PRINT_SYN;
	CGameFrameEngine::GetInstance()->SendMessage(IDM_ADMIN_COMMDN,(WPARAM)&adminReq,0);
}


void CClientControlItemSinkDlg::OnExcute()
{
	CMD_C_AdminReq adminReq;
	BYTE cbIndex=0;
	int nCheckID = 0;
	for(cbIndex=0;cbIndex<8;cbIndex++)
	{
		if(((CButton*)GetDlgItem(IDC_RADIO_LT+cbIndex))->GetCheck())
		{
			nCheckID=cbIndex+1;
		}
	}

	int nSelect=(INT)((CComboBox*)GetDlgItem(IDC_COMBO_TIMES))->GetCurSel();

	if(nCheckID>0&&nSelect>=0)
	{
		adminReq.cbReqType=RQ_SET_WIN_AREA;
		adminReq.cbExtendData[0]=(BYTE)nCheckID;
		adminReq.cbExtendData[1]=(BYTE)nSelect+1;
		m_cbWinArea=adminReq.cbExtendData[0];
		m_cbExcuteTimes=adminReq.cbExtendData[1];

		CGameFrameEngine::GetInstance()->SendMessage(IDM_ADMIN_COMMDN,(WPARAM)&adminReq,0);
	}
	else
	{
		AfxMessageBox(TEXT("请选择受控次数以及受控区域!"));
	}
	// TODO: 在此添加控件通知处理程序代码
}

//更新库存
bool __cdecl CClientControlItemSinkDlg::UpdateStorage(const void * pBuffer)
{

	const CMD_S_UpdateStorage*pResult=(CMD_S_UpdateStorage*)pBuffer;
	
	//更新库存
	m_lStorageStart = pResult->lStorageStart;
	m_lStorageDeduct = pResult->lStorageDeduct;
	m_lStorageCurrent = pResult->lStorageCurrent;
	m_lStorageMax1 = pResult->lStorageMax1;
	m_lStorageMul1 = pResult->lStorageMul1;
	m_lStorageMax2 = pResult->lStorageMax2;
	m_lStorageMul2 = pResult->lStorageMul2;
	
	//拷贝变量值到控件显示
	UpdateData(FALSE);

	//设置标题消息
	if(RQ_SET_STORAGE == pResult->cbReqType)
	{
		//SetWindowText(TEXT("库存修改成功！"));
		GetDlgItem(IDC_STATIC_STORAGE_INFO)->SetWindowText(TEXT("库存修改成功！"));
	}
	else if(RQ_REFRESH_STORAGE == pResult->cbReqType)
	{
		//SetWindowText(TEXT("库存已更新！"));
		GetDlgItem(IDC_STATIC_STORAGE_INFO)->SetWindowText(TEXT("库存已更新！"));
	}

	return true;
}

//更新下注
void __cdecl CClientControlItemSinkDlg::UpdateUserBet(bool bReSet)
{
	//清空列表
	m_listUserBet.DeleteAllItems();
	
	////test+
	//for(INT i=0; i<15; i++)
	//{
	//	//插入数据
	//	m_listUserBet.InsertItem(i, TEXT("s"));
	//}
	////test-

	if(bReSet)
	{
		m_lQueryGameID = -1;
		
		SetDlgItemText(IDC_EDIT_USER_ID, TEXT("请输入玩家ID"));
		GetDlgItem(IDC_EDIT_STORAGE_START)->SetFocus();

		for(BYTE cbSubItem=3; cbSubItem <=10; cbSubItem++)
		{
			m_listUserBetAll.SetItemText(0, cbSubItem, TEXT("0"));
		}
		
		GetDlgItem(IDC_BTN_USER_BET_QUERY)->EnableWindow(true);
		GetDlgItem(IDC_BTN_USER_BET_ALL)->EnableWindow(false);

		return;
	}

	if(0 == m_UserBetArray.GetCount()) return;

	LONGLONG lAllBetScore[AREA_MAX];
	ZeroMemory(lAllBetScore, sizeof(lAllBetScore));

	INT nItemIndex = 0;
	for(INT i=0; i<m_UserBetArray.GetCount(); i++)
	{
		//校验用户ID
		if(-1 != m_lQueryGameID && m_UserBetArray[i].dwUserGameID != m_lQueryGameID) continue;
		
		//插入数据
		m_listUserBet.InsertItem(nItemIndex, TEXT(""));

		CString strInfo;
		strInfo.Format(TEXT("%d"), nItemIndex+1);
		m_listUserBet.SetItemText(nItemIndex, 1, strInfo);

		m_listUserBet.SetItemText(nItemIndex, 2, m_UserBetArray[i].szNickName);
		
		strInfo.Format(TEXT("%u"), m_UserBetArray[i].dwUserGameID);
		m_listUserBet.SetItemText(nItemIndex, 3, strInfo);

		strInfo.Format(TEXT("%I64d"), m_UserBetArray[i].lUserStartScore);
		m_listUserBet.SetItemText(nItemIndex, 4, strInfo);

		strInfo.Format(TEXT("%I64d"), m_UserBetArray[i].lUserWinLost);
		m_listUserBet.SetItemText(nItemIndex, 5, strInfo);
		
		INT nSubItem = -1;
		for(BYTE j=0; j<AREA_MAX; j++)
		{
			switch(j)
			{
			case AREA_XIAN:
				{
					nSubItem = 6;
					break;
				}
			case AREA_PING:
				{
					nSubItem = 7;
					break;
				}
			case AREA_ZHUANG:
				{
					nSubItem = 8;
					break;
				}
			case AREA_XIAN_DUI:
				{
					nSubItem = 9;
					break;
				}
			case AREA_ZHUANG_DUI:
				{
					nSubItem = 10;
					break;
				}
			case AREA_XIAN_TIAN:
				{
					nSubItem = 11;
					break;
				}
			case AREA_ZHUANG_TIAN:
				{
					nSubItem = 12;
					break;
				}
			case AREA_TONG_DUI:
				{
					nSubItem = 13;
					break;
				}
			}
			
			strInfo.Format(TEXT("%I64d"), m_UserBetArray[i].lUserBet[j]);
			m_listUserBet.SetItemText(nItemIndex, nSubItem, strInfo);

			lAllBetScore[j] += m_UserBetArray[i].lUserBet[j];
		}

		nItemIndex++;
	}
	
	INT nSubItemAll = -1;
	for(BYTE k=0; k<AREA_MAX; k++)
	{
		switch(k)
		{
		case AREA_XIAN:
			{
				nSubItemAll = 3;
				break;
			}
		case AREA_PING:
			{
				nSubItemAll = 4;
				break;
			}
		case AREA_ZHUANG:
			{
				nSubItemAll = 5;
				break;
			}
		case AREA_XIAN_DUI:
			{
				nSubItemAll = 6;
				break;
			}
		case AREA_ZHUANG_DUI:
			{
				nSubItemAll = 7;
				break;
			}
		case AREA_XIAN_TIAN:
			{
				nSubItemAll = 8;
				break;
			}
		case AREA_ZHUANG_TIAN:
			{
				nSubItemAll = 9;
				break;
			}
		case AREA_TONG_DUI:
			{
				nSubItemAll = 10;
				break;
			}
		}
		CString strInfoAll;
		strInfoAll.Format(TEXT("%I64d"), lAllBetScore[k]);
		m_listUserBetAll.SetItemText(0, nSubItemAll, strInfoAll);
	}

	return;
}

//更新控件
void __cdecl CClientControlItemSinkDlg::UpdateControl()
{

	RequestUpdateStorage();
	OnRefresh();

}

bool CClientControlItemSinkDlg::ReqResult(const void * pBuffer)
{

	const CMD_S_CommandResult*pResult=(CMD_S_CommandResult*)pBuffer;
	CString str;
	switch(pResult->cbAckType)
	{

	case ACK_SET_WIN_AREA:
		{
			if(pResult->cbResult==CR_ACCEPT)
			{  
				switch(m_cbWinArea)
				{
				case 0:str.Format(TEXT("无受控区域"));break;
				case 1:str.Format(TEXT("执行控制,胜利区域:闲对子,执行次数:%d"),m_cbExcuteTimes);break;
				case 2:str.Format(TEXT("执行控制,胜利区域:  闲  ,执行次数:%d"),m_cbExcuteTimes);break;
				case 3:str.Format(TEXT("执行控制,胜利区域:闲天王,执行次数:%d"),m_cbExcuteTimes);break;
				case 4:str.Format(TEXT("执行控制,胜利区域:  平  ,执行次数:%d"),m_cbExcuteTimes);break;
				case 5:str.Format(TEXT("执行控制,胜利区域:同点平,执行次数:%d"),m_cbExcuteTimes);break;
				case 6:str.Format(TEXT("执行控制,胜利区域:庄对子,执行次数:%d"),m_cbExcuteTimes);break;
				case 7:str.Format(TEXT("执行控制,胜利区域:  庄  ,执行次数:%d"),m_cbExcuteTimes);break;
				case 8:str.Format(TEXT("执行控制,胜利区域:庄天王,执行次数:%d"),m_cbExcuteTimes);break;
				default:break;
				}
			}
			else
			{
				str.Format(TEXT("执行控制失败!"));
				m_cbExcuteTimes=0;
				m_cbWinArea=0;
			}
			break;
		}
	case ACK_RESET_CONTROL:
		{
			if(pResult->cbResult==CR_ACCEPT)
			{  
				str=TEXT("取消控制!");
				for(int nIndex=0;nIndex<8;nIndex++)
					((CButton*)GetDlgItem(IDC_RADIO_LT+nIndex))->SetCheck(0);
				if(m_cbExcuteTimes>0)
					((CComboBox*)GetDlgItem(IDC_COMBO_TIMES))->SetCurSel(-1);
				m_cbWinArea=0;
				m_cbExcuteTimes=0;
			}
			break;
		}
	case ACK_PRINT_SYN:
		{
			if(pResult->cbResult==CR_ACCEPT)
			{  
				str=TEXT("当前设置已同步!");
				for(int nIndex=0;nIndex<8;nIndex++)
					((CButton*)GetDlgItem(IDC_RADIO_LT+nIndex))->SetCheck(0);

				m_cbWinArea=pResult->cbExtendData[0];
				m_cbExcuteTimes=pResult->cbExtendData[1];
				if(m_cbWinArea>0&&m_cbWinArea<=8)
					((CButton*)GetDlgItem(IDC_RADIO_LT+m_cbWinArea-1))->SetCheck(1);
				if(m_cbExcuteTimes>0&&m_cbExcuteTimes<=5)
					((CComboBox*)GetDlgItem(IDC_COMBO_TIMES))->SetCurSel(m_cbExcuteTimes-1);
			}
			else
			{
				str.Format(TEXT("当前设置同步失败!"));
			}
			break;
		}

	default: break;
	}

	//SetWindowText(str);
	GetDlgItem(IDC_STATIC_CONTROL_INFO)->SetWindowText(str);

	return true;
}


//更新库存
void CClientControlItemSinkDlg::OnBnClickedBtnUpdateStorage()
{
	//读取库存变量
	UpdateData(TRUE); //从控件读取数据到变量
	
	if (m_lStorageDeduct < 0|| m_lStorageDeduct > 1000)
	{
		AfxMessageBox(TEXT("[库存衰减值]输入范围为0-1000"));
			return;
	}
	if (m_lStorageCurrent < 0|| m_lStorageCurrent > LLONG_MAX)
	{
		CString str;
		str.Format(TEXT("[当前库存值]输入范围为0-%I64d"),LLONG_MAX);
		AfxMessageBox(str);
			return;
	}
	if (m_lStorageMax1 < 0|| m_lStorageMax1 > LLONG_MAX)
	{
		CString str;
		str.Format(TEXT("[库存上限1]输入范围为0-%I64d"),LLONG_MAX);
		AfxMessageBox(str);
		return;
	}
	if (m_lStorageMul1 < 0|| m_lStorageMul1 > 100)
	{
		AfxMessageBox(TEXT("[玩家赢分概率1]输入范围为0-100"));
			return;
	}
	if (m_lStorageMax2 < 0|| m_lStorageMax2 > LLONG_MAX)
	{
		CString str;
		str.Format(TEXT("[库存上限2]输入范围为0-%I64d"),LLONG_MAX);
		AfxMessageBox(str);
		return;
	}
	if (m_lStorageMul2 < 0|| m_lStorageMul2 > 100)
	{
		AfxMessageBox(TEXT("[玩家赢分概率2]输入范围为0-100"));
			return;
	}

	CMD_C_UpdateStorage adminReq;
	ZeroMemory(&adminReq,sizeof(adminReq));
	adminReq.cbReqType=RQ_SET_STORAGE;

	adminReq.lStorageDeduct = m_lStorageDeduct;
	adminReq.lStorageCurrent = m_lStorageCurrent;
	adminReq.lStorageMax1 = m_lStorageMax1;
	adminReq.lStorageMul1 = m_lStorageMul1;
	adminReq.lStorageMax2 = m_lStorageMax2;
	adminReq.lStorageMul2 = m_lStorageMul2;
	
	CGameFrameEngine * pGameFrameEngine=CGameFrameEngine::GetInstance();
	if (pGameFrameEngine!=NULL) pGameFrameEngine->SendMessage(IDM_UPDATE_STORAGE,(WPARAM)&adminReq,0);
}

void CClientControlItemSinkDlg::RequestUpdateStorage()
{
	CMD_C_UpdateStorage adminReq;
	ZeroMemory(&adminReq,sizeof(adminReq));
	adminReq.cbReqType=RQ_REFRESH_STORAGE;

	CGameFrameEngine * pGameFrameEngine=CGameFrameEngine::GetInstance();
	if (pGameFrameEngine!=NULL) pGameFrameEngine->SendMessage(IDM_UPDATE_STORAGE,(WPARAM)&adminReq,0);

}

void CClientControlItemSinkDlg::OnBnClickedBtnUserBetQuery()
{
	//读取用户ID
	CString strUserID = TEXT("");
	GetDlgItemText(IDC_EDIT_USER_ID,strUserID);

	//去掉空格
	strUserID.TrimLeft();
	strUserID.TrimRight();

	m_lQueryGameID = StrToInt(strUserID);
	
	GetDlgItem(IDC_BTN_USER_BET_ALL)->EnableWindow(true);

	//更新控件
	UpdateUserBet(false);
}

void CClientControlItemSinkDlg::OnBnClickedBtnUserBetAll()
{
	//显示全部
	m_lQueryGameID = -1;
	
	SetDlgItemText(IDC_EDIT_USER_ID, TEXT("请输入玩家ID"));
	
	GetDlgItem(IDC_BTN_USER_BET_QUERY)->EnableWindow(true);
	GetDlgItem(IDC_BTN_USER_BET_ALL)->EnableWindow(false);

	//更新控件
	UpdateUserBet(false);

	return;
}

void CClientControlItemSinkDlg::OnEnSetfocusEditUserId()
{
	SetDlgItemText(IDC_EDIT_USER_ID, TEXT(""));
	return;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////
HBRUSH CClientControlItemSinkDlg::OnCtlColor(CDC* pDC, CWnd* pWnd, UINT nCtlColor)
{
	HBRUSH hbr = IClientControlDlg::OnCtlColor(pDC, pWnd, nCtlColor);

	if( pWnd->GetDlgCtrlID() == IDC_STATIC_CONTROL_INFO || pWnd->GetDlgCtrlID() == IDC_STATIC_STORAGE_INFO)
    {
        pDC->SetTextColor(RGB(255,0,0)); //字体颜色
        //pDC->SetBkColor(RGB(0, 0, 255)); //字体背景色
    }

	return hbr;
}

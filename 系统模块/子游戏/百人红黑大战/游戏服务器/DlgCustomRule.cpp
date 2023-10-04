#include "Stdafx.h"
#include "Resource.h"
#include "DlgCustomRule.h"
#include ".\dlgcustomrule.h"

//////////////////////////////////////////////////////////////////////////

BEGIN_MESSAGE_MAP(CDlgCustomRule, CDialog)
	ON_NOTIFY(TCN_SELCHANGE, IDC_TAB_CUSTOM, OnTcnSelchangeTab)
END_MESSAGE_MAP()

//////////////////////////////////////////////////////////////////////////

//构造函数
CDlgCustomRule::CDlgCustomRule() : CDialog(IDD_CUSTOM_RULE)
{
}

//析构函数
CDlgCustomRule::~CDlgCustomRule()
{
}

//控件绑定
VOID CDlgCustomRule::DoDataExchange(CDataExchange* pDX)
{
	__super::DoDataExchange(pDX);
}

//初始化函数
BOOL CDlgCustomRule::OnInitDialog()
{
	__super::OnInitDialog();
	
	((CTabCtrl *)GetDlgItem(IDC_TAB_CUSTOM))->InsertItem(0,TEXT("通用功能"));
	((CTabCtrl *)GetDlgItem(IDC_TAB_CUSTOM))->InsertItem(1,TEXT("机器人"));
	
	m_DlgCustomGeneral.Create(IDD_CUSTOM_GENERAL,GetDlgItem(IDC_TAB_CUSTOM)); 
	m_DlgCustomAndroid.Create(IDD_CUSTOM_ANDROID,GetDlgItem(IDC_TAB_CUSTOM)); 
	
	CRect rcTabClient;
	GetDlgItem(IDC_TAB_CUSTOM)->GetClientRect(rcTabClient);
	rcTabClient.top+=20;
	rcTabClient.bottom-=4; 
	rcTabClient.left+=4; 
	rcTabClient.right-=4; 
	m_DlgCustomGeneral.MoveWindow(rcTabClient);
	m_DlgCustomAndroid.MoveWindow(rcTabClient);
	
	m_DlgCustomGeneral.ShowWindow(TRUE);
	m_DlgCustomAndroid.ShowWindow(FALSE);
	((CTabCtrl *)GetDlgItem(IDC_TAB_CUSTOM))->SetCurSel(0);
	
	return TRUE;
}

//确定函数
VOID CDlgCustomRule::OnOK() 
{ 
	//投递消息
	GetParent()->PostMessage(WM_COMMAND,MAKELONG(IDOK,0),0);

	return;
}

//取消消息
VOID CDlgCustomRule::OnCancel() 
{ 
	//投递消息
	GetParent()->PostMessage(WM_COMMAND,MAKELONG(IDCANCEL,0),0);

	return;
}

//更新数据
BOOL CDlgCustomRule::UpdateConfigData(BOOL bSaveAndValidate)
{
	if(bSaveAndValidate)	//从控件读取数据到变量
	{
		m_DlgCustomGeneral.UpdateData(TRUE);
		m_DlgCustomAndroid.UpdateData(TRUE);
		
		CopyMemory(&m_CustomConfig.CustomGeneral, &m_DlgCustomGeneral.m_CustomGeneral, sizeof(tagCustomGeneral));
		CopyMemory(&m_CustomConfig.CustomAndroid, &m_DlgCustomAndroid.m_CustomAndroid, sizeof(tagCustomAndroid));

	}
	else					//拷贝变量值到控件显示
	{
		CopyMemory(&m_DlgCustomGeneral.m_CustomGeneral, &m_CustomConfig.CustomGeneral, sizeof(tagCustomGeneral));
		CopyMemory(&m_DlgCustomAndroid.m_CustomAndroid, &m_CustomConfig.CustomAndroid, sizeof(tagCustomAndroid));

		m_DlgCustomGeneral.UpdateData(FALSE);
		m_DlgCustomAndroid.UpdateData(FALSE);
	}

	return TRUE;
}

//设置配置
bool CDlgCustomRule::SetCustomRule(LPBYTE pcbCustomRule, WORD wCustomSize)
{
	//设置变量
	m_wCustomSize=wCustomSize;
	m_pcbCustomRule=pcbCustomRule;

	//配置变量
	ASSERT(m_pcbCustomRule);
	if( !m_pcbCustomRule ) return false;
	tagCustomConfig *pCustomConfig = (tagCustomConfig *)m_pcbCustomRule;
		memcpy(&m_CustomConfig, pCustomConfig, sizeof(tagCustomConfig));

	//更新界面
	if( m_hWnd )
		UpdateConfigData(FALSE);  //拷贝变量值到控件显示

	//超级抢庄配置
	if (m_CustomConfig.CustomGeneral.superbankerConfig.superbankerType == SUPERBANKER_VIPTYPE)
	{
		((CButton*)(m_DlgCustomGeneral.GetDlgItem(IDC_RADIO_SUPERBANKER_VIP)))->SetCheck(1);
		((CButton*)(m_DlgCustomGeneral.GetDlgItem(IDC_RADIO_SUPERBANKER_CONSUME)))->SetCheck(0);
	
		((CComboBox*)(m_DlgCustomGeneral.GetDlgItem(IDC_COMBO_SUPERBANKER_VIP)))->SetCurSel(GetCurSel(m_CustomConfig.CustomGeneral.superbankerConfig.enVipIndex));
		((CEdit*)(m_DlgCustomGeneral.GetDlgItem(IDC_EDIT_SUPERBANKERCONSUME)))->SetWindowText(TEXT(""));
		((CEdit*)(m_DlgCustomGeneral.GetDlgItem(IDC_EDIT_SUPERBANKERCONSUME)))->EnableWindow(false);
	}
	else if (m_CustomConfig.CustomGeneral.superbankerConfig.superbankerType == SUPERBANKER_CONSUMETYPE)
	{
		((CButton*)(m_DlgCustomGeneral.GetDlgItem(IDC_RADIO_SUPERBANKER_VIP)))->SetCheck(0);
		((CButton*)(m_DlgCustomGeneral.GetDlgItem(IDC_RADIO_SUPERBANKER_CONSUME)))->SetCheck(1);

		((CComboBox*)(m_DlgCustomGeneral.GetDlgItem(IDC_COMBO_SUPERBANKER_VIP)))->EnableWindow(false);
		((CComboBox*)(m_DlgCustomGeneral.GetDlgItem(IDC_COMBO_SUPERBANKER_VIP)))->SetWindowText(TEXT(""));

		((CEdit*)(m_DlgCustomGeneral.GetDlgItem(IDC_EDIT_SUPERBANKERCONSUME)))->EnableWindow(true);

		CString strConsume;
		strConsume.Format(SCORE_STRING, m_CustomConfig.CustomGeneral.superbankerConfig.lSuperBankerConsume);
		((CEdit*)(m_DlgCustomGeneral.GetDlgItem(IDC_EDIT_SUPERBANKERCONSUME)))->SetWindowText(strConsume);
	}

	//占位配置
	if (m_CustomConfig.CustomGeneral.occupyseatConfig.occupyseatType == OCCUPYSEAT_VIPTYPE)
	{
		((CButton*)(m_DlgCustomGeneral.GetDlgItem(IDC_RADIO_OCCUPYSEAT_VIP)))->SetCheck(1);
		((CButton*)(m_DlgCustomGeneral.GetDlgItem(IDC_RADIO_OCCUPYSEAT_CONSUME)))->SetCheck(0);
		((CButton*)(m_DlgCustomGeneral.GetDlgItem(IDC_RADIO_OCCUPYSEAT_FREE)))->SetCheck(0);

		((CComboBox*)(m_DlgCustomGeneral.GetDlgItem(IDC_COMBO_OCCUPYSEAT_VIP)))->SetCurSel(GetCurSel(m_CustomConfig.CustomGeneral.occupyseatConfig.enVipIndex));
		((CEdit*)(m_DlgCustomGeneral.GetDlgItem(IDC_EDIT_OCCUPYSEATCONSUME)))->SetWindowText(TEXT(""));
		((CEdit*)(m_DlgCustomGeneral.GetDlgItem(IDC_EDIT_OCCUPYSEATCONSUME)))->EnableWindow(false);

		((CEdit*)(m_DlgCustomGeneral.GetDlgItem(IDC_EDIT_OCCUPYSEATFREE)))->SetWindowText(TEXT(""));
		((CEdit*)(m_DlgCustomGeneral.GetDlgItem(IDC_EDIT_OCCUPYSEATFREE)))->EnableWindow(false);
	}
	else if (m_CustomConfig.CustomGeneral.occupyseatConfig.occupyseatType == OCCUPYSEAT_CONSUMETYPE)
	{
		((CButton*)(m_DlgCustomGeneral.GetDlgItem(IDC_RADIO_OCCUPYSEAT_VIP)))->SetCheck(0);
		((CButton*)(m_DlgCustomGeneral.GetDlgItem(IDC_RADIO_OCCUPYSEAT_CONSUME)))->SetCheck(1);
		((CButton*)(m_DlgCustomGeneral.GetDlgItem(IDC_RADIO_OCCUPYSEAT_FREE)))->SetCheck(0);

		((CComboBox*)(m_DlgCustomGeneral.GetDlgItem(IDC_COMBO_OCCUPYSEAT_VIP)))->EnableWindow(false);
		((CComboBox*)(m_DlgCustomGeneral.GetDlgItem(IDC_COMBO_OCCUPYSEAT_VIP)))->SetWindowText(TEXT(""));

		((CEdit*)(m_DlgCustomGeneral.GetDlgItem(IDC_EDIT_OCCUPYSEATCONSUME)))->EnableWindow(true);

		CString strConsume;
		strConsume.Format(SCORE_STRING, m_CustomConfig.CustomGeneral.occupyseatConfig.lOccupySeatConsume);
		((CEdit*)(m_DlgCustomGeneral.GetDlgItem(IDC_EDIT_OCCUPYSEATCONSUME)))->SetWindowText(strConsume);

		((CEdit*)(m_DlgCustomGeneral.GetDlgItem(IDC_EDIT_OCCUPYSEATFREE)))->SetWindowText(TEXT(""));
		((CEdit*)(m_DlgCustomGeneral.GetDlgItem(IDC_EDIT_OCCUPYSEATFREE)))->EnableWindow(false);
	}
	else if (m_CustomConfig.CustomGeneral.occupyseatConfig.occupyseatType == OCCUPYSEAT_FREETYPE)
	{
		((CButton*)(m_DlgCustomGeneral.GetDlgItem(IDC_RADIO_OCCUPYSEAT_VIP)))->SetCheck(0);
		((CButton*)(m_DlgCustomGeneral.GetDlgItem(IDC_RADIO_OCCUPYSEAT_CONSUME)))->SetCheck(0);
		((CButton*)(m_DlgCustomGeneral.GetDlgItem(IDC_RADIO_OCCUPYSEAT_FREE)))->SetCheck(1);

		((CComboBox*)(m_DlgCustomGeneral.GetDlgItem(IDC_COMBO_OCCUPYSEAT_VIP)))->EnableWindow(false);
		((CComboBox*)(m_DlgCustomGeneral.GetDlgItem(IDC_COMBO_OCCUPYSEAT_VIP)))->SetWindowText(TEXT(""));
		((CEdit*)(m_DlgCustomGeneral.GetDlgItem(IDC_EDIT_OCCUPYSEATCONSUME)))->SetWindowText(TEXT(""));
		((CEdit*)(m_DlgCustomGeneral.GetDlgItem(IDC_EDIT_OCCUPYSEATCONSUME)))->EnableWindow(false);

		((CEdit*)(m_DlgCustomGeneral.GetDlgItem(IDC_EDIT_OCCUPYSEATFREE)))->EnableWindow(true);

		CString strConsume;
		strConsume.Format(SCORE_STRING, m_CustomConfig.CustomGeneral.occupyseatConfig.lOccupySeatFree);
		((CEdit*)(m_DlgCustomGeneral.GetDlgItem(IDC_EDIT_OCCUPYSEATFREE)))->SetWindowText(strConsume);
	}

	CString strForceStandUpCondition;
	strForceStandUpCondition.Format(SCORE_STRING, m_CustomConfig.CustomGeneral.occupyseatConfig.lForceStandUpCondition);
	((CEdit*)(m_DlgCustomGeneral.GetDlgItem(IDC_EDIT_FORCESTANDUP)))->SetWindowText(strForceStandUpCondition);

	if (m_CustomConfig.CustomAndroid.nEnableRobotBanker == true)
	{
		((CButton*)(m_DlgCustomAndroid.GetDlgItem(IDC_CHECK_ANDROID_1)))->SetCheck(1);
	}
	else if (m_CustomConfig.CustomAndroid.nEnableRobotBanker == false)
	{
		((CButton*)(m_DlgCustomAndroid.GetDlgItem(IDC_CHECK_ANDROID_1)))->SetCheck(0);
	}
	
	return true;
}

//保存数据
bool CDlgCustomRule::SaveCustomRule(LPBYTE pcbCustomRule, WORD wCustomSize)
{
	//更新界面
	if( m_hWnd )
	{
		//检测输入值非空
		bool bDataOK = true;
		INT nID = IDC_EDIT_GENERAL_1;
		while(nID <= IDC_EDIT_GENERAL_19)
		{
			TCHAR szData[256] = {0};
			m_DlgCustomGeneral.GetDlgItemText(nID, szData, sizeof(szData));

			if(0 == szData[0])
			{
				if( IDOK  == AfxMessageBox(TEXT("请输入一个合法数据！")))
				{
					return false;
				}
			}

			nID ++;
		}
		nID = IDC_EDIT_ANDROID_1;
		while(nID <= IDC_EDIT_ANDROID_20)
		{
			TCHAR szData[256] = {0};
			m_DlgCustomAndroid.GetDlgItemText(nID, szData, sizeof(szData));

			if(0 == szData[0])
			{
				if( IDOK  == AfxMessageBox(TEXT("请输入一个合法数据！")))
				{
					return false;
				}
			}

			nID ++;
		}	

		UpdateConfigData(TRUE); //从控件读取数据到变量
	}
	
	if (m_DlgCustomGeneral.m_CustomGeneral.lFreeTime<5||m_DlgCustomGeneral.m_CustomGeneral.lFreeTime>99)
	{
           AfxMessageBox(L"[空闲时间]输入范围为5-99");
			    return false;
	}
	if (m_DlgCustomGeneral.m_CustomGeneral.lBetTime<10||
		m_DlgCustomGeneral.m_CustomGeneral.lBetTime>99)
	{
       AfxMessageBox(L"[下注时间]输入范围为10-99");
		    return false;
	}
	if (m_DlgCustomGeneral.m_CustomGeneral.lEndTime<20||m_DlgCustomGeneral.m_CustomGeneral.lEndTime>99)
	{
		AfxMessageBox(L"[结束时间]输入范围为20-99");
	 return false;
	}
	if (m_DlgCustomGeneral.m_CustomGeneral.StorageDeduct<0||m_DlgCustomGeneral.m_CustomGeneral.StorageDeduct>1000)
	{
		AfxMessageBox(L"[库存衰减值]输入范围为0-1000");
		return false;
	}
	if (m_DlgCustomGeneral.m_CustomGeneral.StorageMul1<0||m_DlgCustomGeneral.m_CustomGeneral.StorageMul1>100)
	{
		AfxMessageBox(L"[玩家赢分概率1]输入范围为0-100");
		return false;
	}
	if (m_DlgCustomGeneral.m_CustomGeneral.StorageMul2<0||m_DlgCustomGeneral.m_CustomGeneral.StorageMul2>100)
	{
		AfxMessageBox(L"[玩家赢分概率2]输入范围为0-100");
		return false;
	}

	if (m_DlgCustomAndroid.m_CustomAndroid.lRobotBankStoMul<0||m_DlgCustomAndroid.m_CustomAndroid.lRobotBankStoMul>100)
	{
		AfxMessageBox(L"[存款百分比]输入范围为0-100");
		return false;
	}

	if(!CheckDataMinMax(m_DlgCustomGeneral.m_CustomGeneral.lApplyBankerCondition)) return false;
	if(!CheckDataMinMax(m_DlgCustomGeneral.m_CustomGeneral.lBankerTime)) return false;
	if(!CheckDataMinMax(m_DlgCustomGeneral.m_CustomGeneral.lBankerTimeAdd)) return false;
	if(!CheckDataMinMax(m_DlgCustomGeneral.m_CustomGeneral.lBankerScoreMAX)) return false;
	if(!CheckDataMinMax(m_DlgCustomGeneral.m_CustomGeneral.lBankerTimeExtra)) return false;
	if(!CheckDataMinMax(m_DlgCustomGeneral.m_CustomGeneral.StorageStart)) return false;
	if(!CheckDataMinMax(m_DlgCustomGeneral.m_CustomGeneral.StorageMax1)) return false;
	if(!CheckDataMinMax(m_DlgCustomGeneral.m_CustomGeneral.StorageMax2)) return false;
	if(!CheckDataMinMax(m_DlgCustomGeneral.m_CustomGeneral.lAreaLimitScore)) return false;
	if(!CheckDataMinMax(m_DlgCustomGeneral.m_CustomGeneral.lUserLimitScore)) return false;
	if(!CheckDataMinMax(m_DlgCustomAndroid.m_CustomAndroid.lRobotBankerCountMin)) return false;
	if(!CheckDataMinMax(m_DlgCustomAndroid.m_CustomAndroid.lRobotBankerCountMax)) return false;
	if(!CheckDataMinMax(m_DlgCustomAndroid.m_CustomAndroid.lRobotListMinCount)) return false;
	if(!CheckDataMinMax(m_DlgCustomAndroid.m_CustomAndroid.lRobotListMaxCount)) return false;
	if(!CheckDataMinMax(m_DlgCustomAndroid.m_CustomAndroid.lRobotApplyBanker)) return false;
	if(!CheckDataMinMax(m_DlgCustomAndroid.m_CustomAndroid.lRobotWaitBanker)) return false;
	if(!CheckDataMinMax(m_DlgCustomAndroid.m_CustomAndroid.lRobotMinBetTime)) return false;
	if(!CheckDataMinMax(m_DlgCustomAndroid.m_CustomAndroid.lRobotMaxBetTime)) return false;
	if(!CheckDataMinMax(m_DlgCustomAndroid.m_CustomAndroid.lRobotMinJetton)) return false;
	if(!CheckDataMinMax(m_DlgCustomAndroid.m_CustomAndroid.lRobotMaxJetton)) return false;
	if(!CheckDataMinMax(m_DlgCustomAndroid.m_CustomAndroid.lRobotBetMinCount)) return false;
	if(!CheckDataMinMax(m_DlgCustomAndroid.m_CustomAndroid.lRobotBetMaxCount)) return false;
	if(!CheckDataMinMax(m_DlgCustomAndroid.m_CustomAndroid.lRobotAreaLimit)) return false;
	if(!CheckDataMinMax(m_DlgCustomAndroid.m_CustomAndroid.lRobotScoreMin)) return false;
	if(!CheckDataMinMax(m_DlgCustomAndroid.m_CustomAndroid.lRobotScoreMax)) return false;
	if(!CheckDataMinMax(m_DlgCustomAndroid.m_CustomAndroid.lRobotBankGetMin)) return false;
	if(!CheckDataMinMax(m_DlgCustomAndroid.m_CustomAndroid.lRobotBankGetMax)) return false;
	if(!CheckDataMinMax(m_DlgCustomAndroid.m_CustomAndroid.lRobotBankGetBankerMin)) return false;
	if(!CheckDataMinMax(m_DlgCustomAndroid.m_CustomAndroid.lRobotBankGetBankerMax)) return false;
	
	//超级抢庄配置
	if (((CButton*)(m_DlgCustomGeneral.GetDlgItem(IDC_RADIO_SUPERBANKER_VIP)))->GetCheck() == 1)
	{
		ASSERT (((CButton*)(m_DlgCustomGeneral.GetDlgItem(IDC_RADIO_SUPERBANKER_CONSUME)))->GetCheck() == 0);

		m_CustomConfig.CustomGeneral.superbankerConfig.superbankerType = SUPERBANKER_VIPTYPE;
		m_CustomConfig.CustomGeneral.superbankerConfig.lSuperBankerConsume = 0;

		m_CustomConfig.CustomGeneral.superbankerConfig.enVipIndex = GetVipIndex(((CComboBox*)(m_DlgCustomGeneral.GetDlgItem(IDC_COMBO_SUPERBANKER_VIP)))->GetCurSel());
	}	
	else if (((CButton*)(m_DlgCustomGeneral.GetDlgItem(IDC_RADIO_SUPERBANKER_CONSUME)))->GetCheck() == 1)
	{
		ASSERT (((CButton*)(m_DlgCustomGeneral.GetDlgItem(IDC_RADIO_SUPERBANKER_VIP)))->GetCheck() == 0);

		m_CustomConfig.CustomGeneral.superbankerConfig.superbankerType = SUPERBANKER_CONSUMETYPE;
		m_CustomConfig.CustomGeneral.superbankerConfig.lSuperBankerConsume = m_DlgCustomGeneral.GetDlgItemInt(IDC_EDIT_SUPERBANKERCONSUME);
		m_CustomConfig.CustomGeneral.superbankerConfig.enVipIndex = VIP_INVALID;
	}

	//占位配置
	if (((CButton*)(m_DlgCustomGeneral.GetDlgItem(IDC_RADIO_OCCUPYSEAT_VIP)))->GetCheck() == 1)
	{
		ASSERT (((CButton*)(m_DlgCustomGeneral.GetDlgItem(IDC_RADIO_OCCUPYSEAT_CONSUME)))->GetCheck() == 0);
		ASSERT (((CButton*)(m_DlgCustomGeneral.GetDlgItem(IDC_RADIO_OCCUPYSEAT_FREE)))->GetCheck() == 0);

		m_CustomConfig.CustomGeneral.occupyseatConfig.occupyseatType = OCCUPYSEAT_VIPTYPE;
		m_CustomConfig.CustomGeneral.occupyseatConfig.lOccupySeatConsume = 0;

		m_CustomConfig.CustomGeneral.occupyseatConfig.enVipIndex = GetVipIndex(((CComboBox*)(m_DlgCustomGeneral.GetDlgItem(IDC_COMBO_OCCUPYSEAT_VIP)))->GetCurSel());

		m_CustomConfig.CustomGeneral.occupyseatConfig.lOccupySeatFree = 0;
	}	
	else if (((CButton*)(m_DlgCustomGeneral.GetDlgItem(IDC_RADIO_OCCUPYSEAT_CONSUME)))->GetCheck() == 1)
	{
		ASSERT (((CButton*)(m_DlgCustomGeneral.GetDlgItem(IDC_RADIO_OCCUPYSEAT_VIP)))->GetCheck() == 0);
		ASSERT (((CButton*)(m_DlgCustomGeneral.GetDlgItem(IDC_RADIO_OCCUPYSEAT_FREE)))->GetCheck() == 0);

		m_CustomConfig.CustomGeneral.occupyseatConfig.occupyseatType = OCCUPYSEAT_CONSUMETYPE;
		m_CustomConfig.CustomGeneral.occupyseatConfig.lOccupySeatConsume = m_DlgCustomGeneral.GetDlgItemInt(IDC_EDIT_OCCUPYSEATCONSUME);
		m_CustomConfig.CustomGeneral.occupyseatConfig.enVipIndex = VIP_INVALID;
		m_CustomConfig.CustomGeneral.occupyseatConfig.lOccupySeatFree = 0;
	}
	else if (((CButton*)(m_DlgCustomGeneral.GetDlgItem(IDC_RADIO_OCCUPYSEAT_FREE)))->GetCheck() == 1)
	{
		ASSERT (((CButton*)(m_DlgCustomGeneral.GetDlgItem(IDC_RADIO_OCCUPYSEAT_VIP)))->GetCheck() == 0);
		ASSERT (((CButton*)(m_DlgCustomGeneral.GetDlgItem(IDC_RADIO_OCCUPYSEAT_CONSUME)))->GetCheck() == 0);

		m_CustomConfig.CustomGeneral.occupyseatConfig.occupyseatType = OCCUPYSEAT_FREETYPE;
		m_CustomConfig.CustomGeneral.occupyseatConfig.lOccupySeatConsume = 0;
		m_CustomConfig.CustomGeneral.occupyseatConfig.enVipIndex = VIP_INVALID;
		m_CustomConfig.CustomGeneral.occupyseatConfig.lOccupySeatFree =  m_DlgCustomGeneral.GetDlgItemInt(IDC_EDIT_OCCUPYSEATFREE);
	}
	
	m_CustomConfig.CustomGeneral.occupyseatConfig.lForceStandUpCondition = m_DlgCustomGeneral.GetDlgItemInt(IDC_EDIT_FORCESTANDUP);

	if (m_CustomConfig.CustomGeneral.occupyseatConfig.lForceStandUpCondition <= 0)
	{
		AfxMessageBox(L"[强制站起条件]必须大于0");
		return false;
	}

	if (((CButton*)(m_DlgCustomGeneral.GetDlgItem(IDC_RADIO_OCCUPYSEAT_FREE)))->GetCheck() == 1)
	{
		SCORE lOccupySeatFree =  m_DlgCustomGeneral.GetDlgItemInt(IDC_EDIT_OCCUPYSEATFREE);
		if (!(m_CustomConfig.CustomGeneral.occupyseatConfig.lForceStandUpCondition < lOccupySeatFree))
		{
			AfxMessageBox(L"[强制站起条件]必须小于玩家金币上限");
			return false;
		}
	}

	if (((CButton*)(m_DlgCustomAndroid.GetDlgItem(IDC_CHECK_ANDROID_1)))->GetCheck() == 1)
	{
		m_CustomConfig.CustomAndroid.nEnableRobotBanker = true;
	}
	else if (((CButton*)(m_DlgCustomAndroid.GetDlgItem(IDC_CHECK_ANDROID_1)))->GetCheck() == 0)
	{
		m_CustomConfig.CustomAndroid.nEnableRobotBanker = false;
	}

	//设置变量
	m_wCustomSize=wCustomSize;
	m_pcbCustomRule=pcbCustomRule;

	//配置变量
	ASSERT(m_pcbCustomRule);
	if( !m_pcbCustomRule ) return true;
	tagCustomConfig *pCustomConfig = (tagCustomConfig *)m_pcbCustomRule;
	memcpy(pCustomConfig, &m_CustomConfig, sizeof(tagCustomConfig));

	return true;
}

//保存数据
bool CDlgCustomRule::DefaultCustomRule(LPBYTE pcbCustomRule, WORD wCustomSize)
{
	//设置变量
	m_wCustomSize=wCustomSize;
	m_pcbCustomRule=pcbCustomRule;

	//配置变量
	ASSERT(m_pcbCustomRule);
	if( !m_pcbCustomRule ) return true;
	tagCustomConfig *pCustomConfig = (tagCustomConfig *)m_pcbCustomRule;

	m_CustomConfig.DefaultCustomRule();
	memcpy(pCustomConfig, &m_CustomConfig, sizeof(tagCustomConfig));

	//更新界面
	if( m_hWnd )
		UpdateConfigData(FALSE); // 拷贝变量值到控件显示

	return true;
}

//隐藏机器人配置
bool CDlgCustomRule::HideAndroidModule(bool bHide)
{
	if(bHide)
	{
		((CTabCtrl *)GetDlgItem(IDC_TAB_CUSTOM))->DeleteItem(1);
		m_DlgCustomAndroid.ShowWindow(false);
		((CTabCtrl *)GetDlgItem(IDC_TAB_CUSTOM))->SetCurSel(0);
	}

	return true;
}

VIPINDEX CDlgCustomRule::GetVipIndex(WORD wSelIndex)
{
	ASSERT (wSelIndex >= 0 && wSelIndex <= 4);

	switch(wSelIndex)
	{
	case 0:
		{
			return VIP1_INDEX;
		}
	case 1:
		{
			return VIP2_INDEX;
		}
	case 2:
		{
			return VIP3_INDEX;
		}
	case 3:
		{
			return VIP4_INDEX;
		}
	case 4:
		{
			return VIP5_INDEX;
		}
	default:
		return VIP_INVALID;
	}

	return VIP_INVALID;
}

int CDlgCustomRule::GetCurSel(VIPINDEX vipIndex)
{
	switch(vipIndex)
	{
	case VIP1_INDEX:
		{
			return 0;
		}
	case VIP2_INDEX:
		{
			return 1;
		}
	case VIP3_INDEX:
		{
			return 2;
		}
	case VIP4_INDEX:
		{
			return 3;
		}
	case VIP5_INDEX:
		{
			return 4;
		}
	default:
		return -1;
	}

	return -1;
}

void CDlgCustomRule::OnTcnSelchangeTab(NMHDR *pNMHDR, LRESULT *pResult)
{   
	INT CurSel =((CTabCtrl *)GetDlgItem(IDC_TAB_CUSTOM))->GetCurSel();

    switch(CurSel)
    {
    case 0:
        m_DlgCustomGeneral.ShowWindow(true);
        m_DlgCustomAndroid.ShowWindow(false);
        break;
    case 1:
        m_DlgCustomGeneral.ShowWindow(false);
        m_DlgCustomAndroid.ShowWindow(true);
        break;
    }
    *pResult = 0;

	return;
}

//////////////////////////////////////////////////////////////////////////////////

BEGIN_MESSAGE_MAP(CDlgCustomGeneral, CDialog)
	ON_WM_VSCROLL()
	ON_WM_SIZE()
	ON_BN_CLICKED(IDC_RADIO_SUPERBANKER_VIP, OnClickSuperBankerVIPConfig)
	ON_BN_CLICKED(IDC_RADIO_SUPERBANKER_CONSUME, OnClickSuperBankerConsumeConfig)

	ON_BN_CLICKED(IDC_RADIO_OCCUPYSEAT_VIP, OnClickOccupySeatVIPConfig)
	ON_BN_CLICKED(IDC_RADIO_OCCUPYSEAT_CONSUME, OnClickOccupySeatConsumeConfig)
	ON_BN_CLICKED(IDC_RADIO_OCCUPYSEAT_FREE, OnClickOccupySeatFreeConfig)
END_MESSAGE_MAP()

//////////////////////////////////////////////////////////////////////////

//构造函数
CDlgCustomGeneral::CDlgCustomGeneral() : CDialog(IDD_CUSTOM_GENERAL)
{
	m_iyoldpos = 0;
}

//析构函数
CDlgCustomGeneral::~CDlgCustomGeneral()
{
}

//控件绑定
VOID CDlgCustomGeneral::DoDataExchange(CDataExchange* pDX)
{
	__super::DoDataExchange(pDX);
		
	DDX_Text(pDX,IDC_EDIT_GENERAL_1,m_CustomGeneral.lApplyBankerCondition);
	DDX_Text(pDX,IDC_EDIT_GENERAL_2,m_CustomGeneral.lBankerTime);
	DDX_Text(pDX,IDC_EDIT_GENERAL_3,m_CustomGeneral.lBankerTimeAdd);
	DDX_Text(pDX,IDC_EDIT_GENERAL_4,m_CustomGeneral.lBankerScoreMAX);
	DDX_Text(pDX,IDC_EDIT_GENERAL_5,m_CustomGeneral.lBankerTimeExtra);
	DDX_Text(pDX,IDC_EDIT_GENERAL_6,m_CustomGeneral.lFreeTime);
	DDX_Text(pDX,IDC_EDIT_GENERAL_7,m_CustomGeneral.lBetTime);
	DDX_Text(pDX,IDC_EDIT_GENERAL_8,m_CustomGeneral.lEndTime);
	DDX_Text(pDX,IDC_EDIT_GENERAL_9,m_CustomGeneral.lAreaLimitScore);
	DDX_Text(pDX,IDC_EDIT_GENERAL_10,m_CustomGeneral.lUserLimitScore);

	DDX_Text(pDX,IDC_EDIT_GENERAL_11,m_CustomGeneral.szMessageItem1,64);
	DDX_Text(pDX,IDC_EDIT_GENERAL_12,m_CustomGeneral.szMessageItem2,64);
	DDX_Text(pDX,IDC_EDIT_GENERAL_13,m_CustomGeneral.szMessageItem3,64);

	DDX_Text(pDX,IDC_EDIT_GENERAL_14,m_CustomGeneral.StorageStart);
	DDX_Text(pDX,IDC_EDIT_GENERAL_15,m_CustomGeneral.StorageDeduct);
	DDX_Text(pDX,IDC_EDIT_GENERAL_16,m_CustomGeneral.StorageMax1);
	DDX_Text(pDX,IDC_EDIT_GENERAL_17,m_CustomGeneral.StorageMul1);
	DDX_Text(pDX,IDC_EDIT_GENERAL_18,m_CustomGeneral.StorageMax2);
	DDX_Text(pDX,IDC_EDIT_GENERAL_19,m_CustomGeneral.StorageMul2);

	DDX_Check(pDX,IDC_CHECK_GENERAL_1,m_CustomGeneral.nEnableSysBanker);
}

//初始化函数
BOOL CDlgCustomGeneral::OnInitDialog()
{
	__super::OnInitDialog();

	((CButton*)(GetDlgItem(IDC_RADIO_SUPERBANKER_VIP)))->SetCheck(1);
	((CEdit*)(GetDlgItem(IDC_EDIT_SUPERBANKERCONSUME)))->LimitText(10);
	((CEdit*)(GetDlgItem(IDC_EDIT_SUPERBANKERCONSUME)))->EnableWindow(false);
	((CComboBox*)GetDlgItem(IDC_COMBO_SUPERBANKER_VIP))->AddString(TEXT("VIP1"));
	((CComboBox*)GetDlgItem(IDC_COMBO_SUPERBANKER_VIP))->AddString(TEXT("VIP2"));
	((CComboBox*)GetDlgItem(IDC_COMBO_SUPERBANKER_VIP))->AddString(TEXT("VIP3"));
	((CComboBox*)GetDlgItem(IDC_COMBO_SUPERBANKER_VIP))->AddString(TEXT("VIP4"));
	((CComboBox*)GetDlgItem(IDC_COMBO_SUPERBANKER_VIP))->AddString(TEXT("VIP5"));
	((CComboBox*)GetDlgItem(IDC_COMBO_SUPERBANKER_VIP))->SetCurSel(0);

	((CButton*)(GetDlgItem(IDC_RADIO_OCCUPYSEAT_VIP)))->SetCheck(1);
	((CEdit*)(GetDlgItem(IDC_EDIT_OCCUPYSEATCONSUME)))->LimitText(10);
	((CEdit*)(GetDlgItem(IDC_EDIT_OCCUPYSEATCONSUME)))->EnableWindow(false);
	((CComboBox*)GetDlgItem(IDC_COMBO_OCCUPYSEAT_VIP))->AddString(TEXT("VIP1"));
	((CComboBox*)GetDlgItem(IDC_COMBO_OCCUPYSEAT_VIP))->AddString(TEXT("VIP2"));
	((CComboBox*)GetDlgItem(IDC_COMBO_OCCUPYSEAT_VIP))->AddString(TEXT("VIP3"));
	((CComboBox*)GetDlgItem(IDC_COMBO_OCCUPYSEAT_VIP))->AddString(TEXT("VIP4"));
	((CComboBox*)GetDlgItem(IDC_COMBO_OCCUPYSEAT_VIP))->AddString(TEXT("VIP5"));
	((CComboBox*)GetDlgItem(IDC_COMBO_OCCUPYSEAT_VIP))->SetCurSel(0);

	((CEdit*)(GetDlgItem(IDC_EDIT_OCCUPYSEATFREE)))->LimitText(10);
	((CEdit*)(GetDlgItem(IDC_EDIT_OCCUPYSEATFREE)))->EnableWindow(false);
	
	((CEdit*)(GetDlgItem(IDC_EDIT_FORCESTANDUP)))->LimitText(10);

	return TRUE;
}

void CDlgCustomGeneral::OnVScroll(UINT nSBCode, UINT nPos, CScrollBar* pScrollBar)
{
	static int oldpos = 0;  
	int minpos = 0;  
	int maxpos = 0;  
	GetScrollRange(SB_VERT, &minpos, &maxpos);   
	maxpos = GetScrollLimit(SB_VERT); 
	int curpos = GetScrollPos(SB_VERT);  
	switch (nSBCode)  
	{  
	case SB_LEFT:      
		curpos = minpos;  
		break;  

	case SB_RIGHT:     
		curpos = maxpos;  
		break;  

	case SB_ENDSCROLL:   
		break;  

	case SB_LINELEFT:       
		if (curpos > minpos)  
			curpos--;  
		break;  

	case SB_LINERIGHT:    
		if (curpos < maxpos)  
			curpos++;  
		break;  

	case SB_PAGELEFT:      
		{  

			SCROLLINFO   info;  
			GetScrollInfo(SB_VERT, &info, SIF_ALL);  

			if (curpos > minpos)  
				curpos = max(minpos, curpos - (int) info.nPage);  
		}  
		break;  

	case SB_PAGERIGHT:        
		{    
			SCROLLINFO   info;  
			GetScrollInfo(SB_VERT, &info, SIF_ALL);  

			if (curpos < maxpos)  
				curpos = min(maxpos, curpos + (int) info.nPage);  
		}  
		break;  

	case SB_THUMBPOSITION:  
		curpos = nPos;     
		break;  

	case SB_THUMBTRACK:   
		curpos = nPos;     
		break;  
	}  

	SetScrollPos(SB_VERT, curpos);  
	ScrollWindow(0,oldpos-curpos);  

	oldpos = curpos;  
	UpdateWindow(); 
	CDialog::OnVScroll(nSBCode, nPos, pScrollBar);
}

void CDlgCustomGeneral::OnSize(UINT nType, int cx, int cy)
{
	CDialog::OnSize(nType, cx, cy);
	//设置滚动条范围  
	SCROLLINFO si;  
	si.cbSize = sizeof(si);  
	si.fMask = SIF_RANGE | SIF_PAGE;  
	si.nMin = 0;  
	si.nMax = 596;  
	si.nPage = cy;  
	SetScrollInfo(SB_VERT,&si,TRUE);  

	int icurypos = GetScrollPos(SB_VERT);  

	if (icurypos < m_iyoldpos)  
	{  
		ScrollWindow(0,m_iyoldpos-icurypos);  
	}     
	m_iyoldpos = icurypos;  

	Invalidate(TRUE); 
}

void CDlgCustomGeneral::OnClickSuperBankerVIPConfig()
{
	((CEdit*)(GetDlgItem(IDC_EDIT_SUPERBANKERCONSUME)))->EnableWindow(false);
	((CComboBox*)(GetDlgItem(IDC_COMBO_SUPERBANKER_VIP)))->EnableWindow(true);

	((CEdit*)(GetDlgItem(IDC_EDIT_SUPERBANKERCONSUME)))->SetWindowText(TEXT(""));
}

void CDlgCustomGeneral::OnClickSuperBankerConsumeConfig()
{
	((CEdit*)(GetDlgItem(IDC_EDIT_SUPERBANKERCONSUME)))->EnableWindow(true);
	((CComboBox*)(GetDlgItem(IDC_COMBO_SUPERBANKER_VIP)))->EnableWindow(false);

	((CComboBox*)(GetDlgItem(IDC_COMBO_SUPERBANKER_VIP)))->SetWindowText(TEXT(""));
}

void CDlgCustomGeneral::OnClickOccupySeatVIPConfig()
{
	((CEdit*)(GetDlgItem(IDC_EDIT_OCCUPYSEATCONSUME)))->EnableWindow(false);
	((CComboBox*)(GetDlgItem(IDC_COMBO_OCCUPYSEAT_VIP)))->EnableWindow(true);

	((CEdit*)(GetDlgItem(IDC_EDIT_OCCUPYSEATCONSUME)))->SetWindowText(TEXT(""));

	((CEdit*)(GetDlgItem(IDC_EDIT_OCCUPYSEATFREE)))->EnableWindow(false);
	((CEdit*)(GetDlgItem(IDC_EDIT_OCCUPYSEATFREE)))->SetWindowText(TEXT(""));
}

void CDlgCustomGeneral::OnClickOccupySeatConsumeConfig()
{
	((CEdit*)(GetDlgItem(IDC_EDIT_OCCUPYSEATCONSUME)))->EnableWindow(true);
	((CComboBox*)(GetDlgItem(IDC_COMBO_OCCUPYSEAT_VIP)))->EnableWindow(false);

	((CComboBox*)(GetDlgItem(IDC_COMBO_OCCUPYSEAT_VIP)))->SetWindowText(TEXT(""));
	
	((CEdit*)(GetDlgItem(IDC_EDIT_OCCUPYSEATFREE)))->EnableWindow(false);
	((CEdit*)(GetDlgItem(IDC_EDIT_OCCUPYSEATFREE)))->SetWindowText(TEXT(""));
}

void CDlgCustomGeneral::OnClickOccupySeatFreeConfig()
{
	((CComboBox*)(GetDlgItem(IDC_COMBO_OCCUPYSEAT_VIP)))->EnableWindow(false);
	((CComboBox*)(GetDlgItem(IDC_COMBO_OCCUPYSEAT_VIP)))->SetWindowText(TEXT(""));
	((CEdit*)(GetDlgItem(IDC_EDIT_OCCUPYSEATCONSUME)))->EnableWindow(false);
	((CEdit*)(GetDlgItem(IDC_EDIT_OCCUPYSEATCONSUME)))->SetWindowText(TEXT(""));
	((CEdit*)(GetDlgItem(IDC_EDIT_OCCUPYSEATFREE)))->EnableWindow(true);
}

//////////////////////////////////////////////////////////////////////////////////

BEGIN_MESSAGE_MAP(CDlgCustomAndroid, CDialog)
	ON_WM_VSCROLL()
	ON_WM_SIZE()
	ON_BN_CLICKED(IDC_CHECK_ANDROID_1, OnBNClickEnableRobotBanker)

END_MESSAGE_MAP()

//////////////////////////////////////////////////////////////////////////

//构造函数
CDlgCustomAndroid::CDlgCustomAndroid() : CDialog(IDD_CUSTOM_ANDROID)
{
	m_iyoldpos = 0;
}

//析构函数
CDlgCustomAndroid::~CDlgCustomAndroid()
{
}

//控件绑定
VOID CDlgCustomAndroid::DoDataExchange(CDataExchange* pDX)
{
	__super::DoDataExchange(pDX);
	
	DDX_Text(pDX,IDC_EDIT_ANDROID_1,m_CustomAndroid.lRobotBankerCountMin);
	DDX_Text(pDX,IDC_EDIT_ANDROID_2,m_CustomAndroid.lRobotBankerCountMax);
	DDX_Text(pDX,IDC_EDIT_ANDROID_3,m_CustomAndroid.lRobotListMinCount);
	DDX_Text(pDX,IDC_EDIT_ANDROID_4,m_CustomAndroid.lRobotListMaxCount);
	DDX_Text(pDX,IDC_EDIT_ANDROID_5,m_CustomAndroid.lRobotApplyBanker);
	DDX_Text(pDX,IDC_EDIT_ANDROID_6,m_CustomAndroid.lRobotWaitBanker);

	DDX_Text(pDX,IDC_EDIT_ANDROID_7,m_CustomAndroid.lRobotMinBetTime);
	DDX_Text(pDX,IDC_EDIT_ANDROID_8,m_CustomAndroid.lRobotMaxBetTime);
	DDX_Text(pDX,IDC_EDIT_ANDROID_9,m_CustomAndroid.lRobotMinJetton);
	DDX_Text(pDX,IDC_EDIT_ANDROID_10,m_CustomAndroid.lRobotMaxJetton);
	DDX_Text(pDX,IDC_EDIT_ANDROID_11,m_CustomAndroid.lRobotBetMinCount);
	DDX_Text(pDX,IDC_EDIT_ANDROID_12,m_CustomAndroid.lRobotBetMaxCount);
	DDX_Text(pDX,IDC_EDIT_ANDROID_13,m_CustomAndroid.lRobotAreaLimit);

	DDX_Text(pDX,IDC_EDIT_ANDROID_14,m_CustomAndroid.lRobotScoreMin);
	DDX_Text(pDX,IDC_EDIT_ANDROID_15,m_CustomAndroid.lRobotScoreMax);
	DDX_Text(pDX,IDC_EDIT_ANDROID_16,m_CustomAndroid.lRobotBankGetMin);
	DDX_Text(pDX,IDC_EDIT_ANDROID_17,m_CustomAndroid.lRobotBankGetMax);
	DDX_Text(pDX,IDC_EDIT_ANDROID_18,m_CustomAndroid.lRobotBankGetBankerMin);
	DDX_Text(pDX,IDC_EDIT_ANDROID_19,m_CustomAndroid.lRobotBankGetBankerMax);
	DDX_Text(pDX,IDC_EDIT_ANDROID_20,m_CustomAndroid.lRobotBankStoMul);
	
	DDX_Text(pDX,IDC_EDIT_ANDROID_21,m_CustomAndroid.nAreaChance[0]);
	DDX_Text(pDX,IDC_EDIT_ANDROID_22,m_CustomAndroid.nAreaChance[1]);
	DDX_Text(pDX,IDC_EDIT_ANDROID_23,m_CustomAndroid.nAreaChance[2]);
	DDX_Text(pDX,IDC_EDIT_ANDROID_24,m_CustomAndroid.nAreaChance[3]);
	DDX_Text(pDX,IDC_EDIT_ANDROID_25,m_CustomAndroid.nAreaChance[4]);
	DDX_Text(pDX,IDC_EDIT_ANDROID_26,m_CustomAndroid.nAreaChance[5]);
	DDX_Text(pDX,IDC_EDIT_ANDROID_27,m_CustomAndroid.nAreaChance[6]);
	DDX_Text(pDX,IDC_EDIT_ANDROID_28,m_CustomAndroid.nAreaChance[7]);
	
	//DDX_Check(pDX,IDC_CHECK_ANDROID_1,m_CustomAndroid.nEnableRobotBanker);
}

//初始化函数
BOOL CDlgCustomAndroid::OnInitDialog()
{
	__super::OnInitDialog();
	
	return TRUE;
}

bool CDlgCustomRule::CheckDataMinMax(LONGLONG valueMax)
{
	if (valueMax<0||valueMax>LLONG_MAX)
	{
		CString str;
		str.Format(L"输入范围为0-%I64d",LLONG_MAX);
		AfxMessageBox(str);
		return false;
	}
  return true;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////
void CDlgCustomAndroid::OnVScroll(UINT nSBCode, UINT nPos, CScrollBar* pScrollBar)
{
	// TODO: 在此添加消息处理程序代码和/或调用默认值
	static int oldpos = 0;  
	int minpos = 0;  
	int maxpos = 0;  
	GetScrollRange(SB_VERT, &minpos, &maxpos);   
	maxpos = GetScrollLimit(SB_VERT); 
	int curpos = GetScrollPos(SB_VERT);  
	switch (nSBCode)  
	{  
	case SB_LEFT:      
		curpos = minpos;  
		break;  

	case SB_RIGHT:     
		curpos = maxpos;  
		break;  

	case SB_ENDSCROLL:   
		break;  

	case SB_LINELEFT:       
		if (curpos > minpos)  
			curpos--;  
		break;  

	case SB_LINERIGHT:    
		if (curpos < maxpos)  
			curpos++;  
		break;  

	case SB_PAGELEFT:      
		{  
 
			SCROLLINFO   info;  
			GetScrollInfo(SB_VERT, &info, SIF_ALL);  

			if (curpos > minpos)  
				curpos = max(minpos, curpos - (int) info.nPage);  
		}  
		break;  

	case SB_PAGERIGHT:        
		{    
			SCROLLINFO   info;  
			GetScrollInfo(SB_VERT, &info, SIF_ALL);  

			if (curpos < maxpos)  
				curpos = min(maxpos, curpos + (int) info.nPage);  
		}  
		break;  

	case SB_THUMBPOSITION:  
		curpos = nPos;     
		break;  

	case SB_THUMBTRACK:   
		curpos = nPos;     
		break;  
	}  

	SetScrollPos(SB_VERT, curpos);  
	ScrollWindow(0,oldpos-curpos);  

	oldpos = curpos;  
	UpdateWindow(); 
	CDialog::OnVScroll(nSBCode, nPos, pScrollBar);
}

void CDlgCustomAndroid::OnSize(UINT nType, int cx, int cy)
{
	CDialog::OnSize(nType, cx, cy);
	//设置滚动条范围  
	SCROLLINFO si;  
	si.cbSize = sizeof(si);  
	si.fMask = SIF_RANGE | SIF_PAGE;  
	si.nMin = 0;  
	si.nMax = 596;  
	si.nPage = cy;  
	SetScrollInfo(SB_VERT,&si,TRUE);  

	int icurypos = GetScrollPos(SB_VERT);  

	if (icurypos < m_iyoldpos)  
	{  
		ScrollWindow(0,m_iyoldpos-icurypos);  
	}     
	m_iyoldpos = icurypos;  

	Invalidate(TRUE); 
	// TODO: 在此处添加消息处理程序代码
}

void CDlgCustomAndroid::OnBNClickEnableRobotBanker()
{
	if (((CButton*)GetDlgItem(IDC_CHECK_ANDROID_1))->GetCheck() == 1)
	{
		m_CustomAndroid.nEnableRobotBanker = true;
	}
	else
	{
		m_CustomAndroid.nEnableRobotBanker = false;
	}
}

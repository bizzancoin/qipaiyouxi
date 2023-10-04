// DlgCustomRule.cpp : 实现文件
//

#include "stdafx.h"
#include "Resource.h"
#include "DlgCustomRule.h"


// CDlgCustomRule 对话框

BEGIN_MESSAGE_MAP(CDlgCustomRule, CDialog)
END_MESSAGE_MAP()

CDlgCustomRule::CDlgCustomRule() : CDialog(IDD_CUSTOM_RULE)
{
	//设置变量
	ZeroMemory(&m_CustomRule, sizeof(m_CustomRule));

    m_CustomRule.lSysStorage = 100000;
    m_CustomRule.lUserStorage = 90000;
    m_CustomRule.nDebugPercent = 20;
	m_CustomRule.lExchangeRadio = 10;
    m_CustomRule.lBet[0] = 1;
    m_CustomRule.lBet[1] = 2;
    m_CustomRule.lBet[2] = 3;
    m_CustomRule.lBet[3] = 4;
    m_CustomRule.lBet[4] = 5;
    m_CustomRule.lBet[5] = 6;
    m_CustomRule.lBet[6] = 7;
    m_CustomRule.lBet[7] = 8;
    m_CustomRule.lBet[8] = 9;
    m_CustomRule.lBet[9] = 10;
}

CDlgCustomRule::~CDlgCustomRule()
{
}

//配置函数
BOOL CDlgCustomRule::OnInitDialog()
{
	__super::OnInitDialog();

	//设置控件范围
	((CEdit *)GetDlgItem(IDC_EDIT_EXCHANGE_RADIO))->LimitText(8);
    ((CEdit *)GetDlgItem(IDC_EDIT_STORAGE_SYS))->LimitText(9);
    ((CEdit *)GetDlgItem(IDC_EDIT_STORAGE_USER))->LimitText(9);
	((CEdit *)GetDlgItem(IDC_EDIT_DEBUG_PERCENT))->LimitText(2);

	//更新参数
	FillDataToDebug();

	return FALSE;
}

//确定函数
VOID CDlgCustomRule::OnOK() 
{ 
	//投递消息
	GetParent()->PostMessage(WM_COMMAND, MAKELONG(IDOK, 0), 0);

	return;
}

//取消消息
VOID CDlgCustomRule::OnCancel() 
{ 
	//投递消息
	GetParent()->PostMessage(WM_COMMAND, MAKELONG(IDCANCEL, 0), 0);

	return;
}

//更新控件
bool CDlgCustomRule::FillDataToDebug()
{
	//设置数据
	SetDlgItemInt(IDC_EDIT_EXCHANGE_RADIO, m_CustomRule.lExchangeRadio);
    SetDlgItemInt(IDC_EDIT_STORAGE_SYS, m_CustomRule.lSysStorage);
    SetDlgItemInt(IDC_EDIT_STORAGE_USER, m_CustomRule.lUserStorage);
    SetDlgItemInt(IDC_EDIT_DEBUG_PERCENT, m_CustomRule.nDebugPercent);

    SetDlgItemInt(IDC_EDIT_1, m_CustomRule.lBet[0]);
    SetDlgItemInt(IDC_EDIT_2, m_CustomRule.lBet[1]);
    SetDlgItemInt(IDC_EDIT_3, m_CustomRule.lBet[2]);
    SetDlgItemInt(IDC_EDIT_4, m_CustomRule.lBet[3]);
    SetDlgItemInt(IDC_EDIT_5, m_CustomRule.lBet[4]);
    SetDlgItemInt(IDC_EDIT_6, m_CustomRule.lBet[5]);
    SetDlgItemInt(IDC_EDIT_7, m_CustomRule.lBet[6]);
    SetDlgItemInt(IDC_EDIT_8, m_CustomRule.lBet[7]);
    SetDlgItemInt(IDC_EDIT_9, m_CustomRule.lBet[8]);
    SetDlgItemInt(IDC_EDIT_10, m_CustomRule.lBet[9]);
   

	return true;
}

//更新数据
bool CDlgCustomRule::FillDebugToData()
{
	//设置数据
	m_CustomRule.lExchangeRadio = (LONG)GetDlgItemInt(IDC_EDIT_EXCHANGE_RADIO);
    m_CustomRule.lSysStorage = (SCORE)GetDlgItemInt(IDC_EDIT_STORAGE_SYS);
    m_CustomRule.lUserStorage = (SCORE)GetDlgItemInt(IDC_EDIT_STORAGE_USER);
    m_CustomRule.nDebugPercent = (SCORE)GetDlgItemInt(IDC_EDIT_DEBUG_PERCENT);
    m_CustomRule.lBet[0] = (SCORE)GetDlgItemInt(IDC_EDIT_1);
    m_CustomRule.lBet[1] = (SCORE)GetDlgItemInt(IDC_EDIT_2);
    m_CustomRule.lBet[2] = (SCORE)GetDlgItemInt(IDC_EDIT_3);
    m_CustomRule.lBet[3] = (SCORE)GetDlgItemInt(IDC_EDIT_4);
    m_CustomRule.lBet[4] = (SCORE)GetDlgItemInt(IDC_EDIT_5);
    m_CustomRule.lBet[5] = (SCORE)GetDlgItemInt(IDC_EDIT_6);
    m_CustomRule.lBet[6] = (SCORE)GetDlgItemInt(IDC_EDIT_7);
    m_CustomRule.lBet[7] = (SCORE)GetDlgItemInt(IDC_EDIT_8);
    m_CustomRule.lBet[8] = (SCORE)GetDlgItemInt(IDC_EDIT_9);
    m_CustomRule.lBet[9] = (SCORE)GetDlgItemInt(IDC_EDIT_10);
  

	//数据校验
	if (m_CustomRule.lExchangeRadio < 10 )
	{
		AfxMessageBox(TEXT("筹码兑换比例至少为10"), MB_ICONSTOP);
		return false;
	}

	if (m_CustomRule.lExchangeRadio % 10 != 0)
	{
		AfxMessageBox(TEXT("筹码兑换比例应为10的倍数"), MB_ICONSTOP);
		return false;
	}

    if(m_CustomRule.nDebugPercent <= 0 || m_CustomRule.nDebugPercent >99)
	{
		AfxMessageBox(TEXT("调节比例输入范围 1 到 99，请重新设置！"), MB_ICONSTOP);
		return false;
	}

  /*  if(m_CustomRule.lSysStorage - m_CustomRule.lUserStorage >0)
    {
        if((m_CustomRule.lSysStorage - m_CustomRule.lUserStorage) > m_CustomRule.lSysStorage * m_CustomRule.nDebugPercent / 100)
        {
            AfxMessageBox(TEXT("系统库存和玩家库存差值需要为在调控比例范围内，请重新设置！"), MB_ICONSTOP);
            return false;
        }
    }
    else
    {
        if((m_CustomRule.lUserStorage - m_CustomRule.lSysStorage) > m_CustomRule.lUserStorage * m_CustomRule.nDebugPercent / 100)
        {
            AfxMessageBox(TEXT("系统库存和玩家库存差值需要为在调控比例范围内，请重新设置！"), MB_ICONSTOP);
            return false;
        }  
    }*/

	return true;
}

//读取配置
bool CDlgCustomRule::GetCustomRule(tagCustomRule & CustomRule)
{
	//读取参数
	if (FillDebugToData() == true)
	{
		CustomRule = m_CustomRule;
		return true;
	}

	return false;
}

//设置配置
bool CDlgCustomRule::SetCustomRule(tagCustomRule & CustomRule)
{
	//设置变量
	m_CustomRule = CustomRule;

	//更新参数
	if (m_hWnd != NULL) 
	{
		FillDataToDebug();
	}

	return true;
}


///////////////////////////////////////////////////////////////////////////////////////////////////////

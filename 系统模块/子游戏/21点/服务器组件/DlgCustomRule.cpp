#include "Stdafx.h"
#include "Resource.h"
#include "DlgCustomRule.h"

//////////////////////////////////////////////////////////////////////////////////

BEGIN_MESSAGE_MAP(CDlgCustomRule, CDialog)
END_MESSAGE_MAP()

//////////////////////////////////////////////////////////////////////////////////

//构造函数
CDlgCustomRule::CDlgCustomRule() : CDialog(IDD_CUSTOM_RULE)
{
	//设置变量
	ZeroMemory(&m_CustomRule,sizeof(m_CustomRule));

	m_CustomRule.lConfigSysStorage = 100000;
	m_CustomRule.lConfigPlayerStorage = 90000;
	m_CustomRule.lAnchouPercent = 2;
	m_CustomRule.lConfigParameterK = 10;
	m_CustomRule.lResetParameterK = 10;
	
	//游戏AI存款取款
	m_CustomRule.lRobotScoreMin = 100000;
	m_CustomRule.lRobotScoreMax = 1000000;
	m_CustomRule.lRobotBankGet = 1000000;
	m_CustomRule.lRobotBankGetBanker = 10000000;
	m_CustomRule.lRobotBankStoMul = 10;

	//时间定义	
	m_CustomRule.cbTimeAddScore = 10;				
	m_CustomRule.cbTimeGetCard = 10;			

	m_CustomRule.cbBankerMode = 1;			
	m_CustomRule.cbTimeTrusteeDelay = 5;
	return;
}

//析构函数
CDlgCustomRule::~CDlgCustomRule()
{
}

//配置函数
BOOL CDlgCustomRule::OnInitDialog()
{
	__super::OnInitDialog();
	
	//设置控件
    ((CEdit *)GetDlgItem(IDC_EDIT_SYS_STORAGE))->LimitText(9);
    ((CEdit *)GetDlgItem(IDC_EDIT_USER_STORAGE))->LimitText(9);
    ((CEdit *)GetDlgItem(IDC_EDIT_DEBUG_PERCENT))->LimitText(2);
    ((CEdit *)GetDlgItem(IDC_EDIT_ANCHOU_PERCENT))->LimitText(2);
    ((CEdit *)GetDlgItem(IDC_EDIT_RESET_PERCENT))->LimitText(2);

	((CEdit *)GetDlgItem(IDC_ROBOT_SCOREMIN))->LimitText(9);
	((CEdit *)GetDlgItem(IDC_ROBOT_BANKERGETBANKER))->LimitText(9);
	((CEdit *)GetDlgItem(IDC_ROBOT_SCOREMAX))->LimitText(9);
	((CEdit *)GetDlgItem(IDC_ROBOT_BANKGET))->LimitText(9);
	((CEdit *)GetDlgItem(IDC_ROBOT_STOMUL))->LimitText(2);

	((CEdit *)GetDlgItem(IDC_TIME_ADD_SCORE))->LimitText(2);
	((CEdit *)GetDlgItem(IDC_TIME_GET_CARD))->LimitText(2);

	//更新参数
	FillDataToDebug();

	return FALSE;
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

//更新控件
bool CDlgCustomRule::FillDataToDebug()
{
	//设置数据
    SetDlgItemInt(IDC_EDIT_SYS_STORAGE, (UINT)m_CustomRule.lConfigSysStorage);
    SetDlgItemInt(IDC_EDIT_USER_STORAGE, (UINT)m_CustomRule.lConfigPlayerStorage);
    SetDlgItemInt(IDC_EDIT_DEBUG_PERCENT, (UINT)m_CustomRule.lConfigParameterK);
    SetDlgItemInt(IDC_EDIT_ANCHOU_PERCENT, (UINT)m_CustomRule.lAnchouPercent);
    SetDlgItemInt(IDC_EDIT_RESET_PERCENT, (UINT)m_CustomRule.lResetParameterK);
	
	//游戏AI调试
	SetDlgItemInt(IDC_ROBOT_SCOREMIN, (UINT)m_CustomRule.lRobotScoreMin);
	SetDlgItemInt(IDC_ROBOT_SCOREMAX, (UINT)m_CustomRule.lRobotScoreMax);
	SetDlgItemInt(IDC_ROBOT_BANKERGETBANKER, (UINT)m_CustomRule.lRobotBankGetBanker);
	SetDlgItemInt(IDC_ROBOT_BANKGET, (UINT)m_CustomRule.lRobotBankGet);
	SetDlgItemInt(IDC_ROBOT_STOMUL, (UINT)m_CustomRule.lRobotBankStoMul);

	SetDlgItemInt(IDC_TIME_ADD_SCORE, m_CustomRule.cbTimeAddScore);
	SetDlgItemInt(IDC_TIME_GET_CARD, m_CustomRule.cbTimeGetCard);

	SetDlgItemInt(IDC_TIME_TRUSTEEDELAY, m_CustomRule.cbTimeTrusteeDelay);

	if (1 == m_CustomRule.cbBankerMode)
	{
		((CButton*)GetDlgItem(IDC_BANKER_BAWANG))->SetCheck(1);
		((CButton*)GetDlgItem(IDC_BANKER_BJ))->SetCheck(0);

	}
	else
	{
		((CButton*)GetDlgItem(IDC_BANKER_BAWANG))->SetCheck(0);
		((CButton*)GetDlgItem(IDC_BANKER_BJ))->SetCheck(1);
	}

	//SetDlgItemInt(IDC_EDIT_JETTON, (UINT)m_CustomRule.lBaseJeton);

	return true;
}

//更新数据
bool CDlgCustomRule::FillDebugToData()
{
	//设置数据
    m_CustomRule.lConfigSysStorage = (SCORE)GetDlgItemInt(IDC_EDIT_SYS_STORAGE);
    m_CustomRule.lConfigPlayerStorage = (SCORE)GetDlgItemInt(IDC_EDIT_USER_STORAGE);
    m_CustomRule.lConfigParameterK = (SCORE)GetDlgItemInt(IDC_EDIT_DEBUG_PERCENT);
    m_CustomRule.lAnchouPercent = (SCORE)GetDlgItemInt(IDC_EDIT_ANCHOU_PERCENT);
    m_CustomRule.lResetParameterK = (SCORE)GetDlgItemInt(IDC_EDIT_RESET_PERCENT);
	

	//游戏AI调试
	m_CustomRule.lRobotScoreMin = (SCORE)GetDlgItemInt(IDC_ROBOT_SCOREMIN);
	m_CustomRule.lRobotScoreMax = (SCORE)GetDlgItemInt(IDC_ROBOT_SCOREMAX);
	m_CustomRule.lRobotBankGetBanker = (SCORE)GetDlgItemInt(IDC_ROBOT_BANKERGETBANKER);
	m_CustomRule.lRobotBankGet = (SCORE)GetDlgItemInt(IDC_ROBOT_BANKGET);
	m_CustomRule.lRobotBankStoMul = (SCORE)GetDlgItemInt(IDC_ROBOT_STOMUL);

	m_CustomRule.cbTimeAddScore = (BYTE)GetDlgItemInt(IDC_TIME_ADD_SCORE);
	m_CustomRule.cbTimeGetCard = (BYTE)GetDlgItemInt(IDC_TIME_GET_CARD);
	m_CustomRule.cbTimeTrusteeDelay = (BYTE)GetDlgItemInt(IDC_TIME_TRUSTEEDELAY);

	//庄家模式
	if (((CButton *)GetDlgItem(IDC_BANKER_BAWANG))->GetCheck())
	{
		m_CustomRule.cbBankerMode = 1;
	}
	

	if ((m_CustomRule.lRobotScoreMin > m_CustomRule.lRobotScoreMax))
	{
		AfxMessageBox(TEXT("游戏AI分数最小值应小于最大值，请重新设置！"),MB_ICONSTOP);
		return false;
	}

	//下注时间
	if ((m_CustomRule.cbTimeAddScore<5) || (m_CustomRule.cbTimeAddScore>60))
	{
		AfxMessageBox(TEXT("下注时间设置范围错误，请重新设置！"), MB_ICONSTOP);
		return false;
	}
	//开牌时间
	if ((m_CustomRule.cbTimeGetCard<5) || (m_CustomRule.cbTimeGetCard>60))
	{
		AfxMessageBox(TEXT("开牌时间设置范围错误，请重新设置！"), MB_ICONSTOP);
		return false;
	}
	//托管延迟时间
	if ((m_CustomRule.cbTimeTrusteeDelay<3) || (m_CustomRule.cbTimeTrusteeDelay>6))
	{
		AfxMessageBox(TEXT("托管延迟时间设置范围错误，请重新设置！"), MB_ICONSTOP);
		return false;
	}

	return true;
}

//读取配置
bool CDlgCustomRule::GetCustomRule(tagCustomRule & CustomRule)
{
	//读取参数
	if (FillDebugToData()==true)
	{
		CustomRule=m_CustomRule;
		return true;
	}

	return false;
}

//设置配置
bool CDlgCustomRule::SetCustomRule(tagCustomRule & CustomRule)
{
	//设置变量
	m_CustomRule=CustomRule;

	//更新参数
	if (m_hWnd!=NULL) FillDataToDebug();

	return true;
}

//////////////////////////////////////////////////////////////////////////////////

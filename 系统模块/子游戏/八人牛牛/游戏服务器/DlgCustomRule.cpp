#include "Stdafx.h"
#include "Resource.h"
#include "DlgCustomRule.h"

//////////////////////////////////////////////////////////////////////////////////

BEGIN_MESSAGE_MAP(CDlgCustomRule, CDialog)
	ON_WM_VSCROLL()
	ON_WM_SIZE()
	ON_BN_CLICKED(IDC_RADIO_CT_CLASSIC, OnClickClassic)
	ON_BN_CLICKED(IDC_RADIO_CT_ADDTIMES, OnClickAddTimes)

	ON_BN_CLICKED(IDC_RADIO_BT_FREE, OnClickBTFree)
	ON_BN_CLICKED(IDC_RADIO_BT_PERCENT, OnClickBTPercent)

	ON_BN_CLICKED(IDC_RADIO_CTTIMES_CONFIG_0, OnClickCTTimesConfig0)
	ON_BN_CLICKED(IDC_RADIO_CTTIMES_CONFIG_1, OnClickCTTimesConfig1)

END_MESSAGE_MAP()

//////////////////////////////////////////////////////////////////////////////////

//构造函数
CDlgCustomRule::CDlgCustomRule() : CDialog(IDD_CUSTOM_RULE)
{
	//设置变量
	ZeroMemory(&m_CustomRule, sizeof(m_CustomRule));

	m_CustomRule.lRoomStorageStart = 100000;
	m_CustomRule.lRoomStorageDeduct = 0;
	m_CustomRule.lRoomStorageMax1 = 1000000;
	m_CustomRule.lRoomStorageMul1 = 50;
	m_CustomRule.lRoomStorageMax2 = 5000000;
	m_CustomRule.lRoomStorageMul2 = 80;

	//AI存款取款
	m_CustomRule.lRobotScoreMin = 100000;
	m_CustomRule.lRobotScoreMax = 1000000;
	m_CustomRule.lRobotBankGet = 1000000;
	m_CustomRule.lRobotBankGetBanker = 10000000;
	m_CustomRule.lRobotBankStoMul = 10;


	m_CustomRule.ctConfig = CT_ADDTIMES_;
	m_CustomRule.stConfig = ST_SENDFOUR_;
	m_CustomRule.gtConfig = GT_HAVEKING_;
	m_CustomRule.bgtConfig = BGT_ROB_;
	m_CustomRule.btConfig = BT_FREE_;

	m_CustomRule.lFreeConfig[0] = 2;
	m_CustomRule.lFreeConfig[1] = 5;
	m_CustomRule.lFreeConfig[2] = 8;
	m_CustomRule.lFreeConfig[3] = 11;
	//m_CustomRule.lFreeConfig[4] = 15;

	ZeroMemory(m_CustomRule.lPercentConfig, sizeof(m_CustomRule.lPercentConfig));

	//经典牌型倍数
	for (WORD i = 0; i < 7; i++)
	{
		m_CustomRule.cbCardTypeTimesClassic[i] = 1;
	}
	m_CustomRule.cbCardTypeTimesClassic[7] = 2;
	m_CustomRule.cbCardTypeTimesClassic[8] = 2;
	m_CustomRule.cbCardTypeTimesClassic[9] = 3;
	m_CustomRule.cbCardTypeTimesClassic[10] = 4;
	m_CustomRule.cbCardTypeTimesClassic[11] = 4;
	for (WORD i = 12; i < MAX_CARD_TYPE - 1; i++)
	{
		m_CustomRule.cbCardTypeTimesClassic[i] = 5;
	}
	m_CustomRule.cbCardTypeTimesClassic[18] = 8;

	//加倍牌型倍数
	m_CustomRule.cbCardTypeTimesAddTimes[0] = 1;
	for (BYTE i = 1; i < MAX_CARD_TYPE; i++)
	{
		m_CustomRule.cbCardTypeTimesAddTimes[i] = i;
	}

	m_CustomRule.cbTrusteeDelayTime = 3;
	m_iyoldpos = 0;

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
	((CEdit *)GetDlgItem(IDC_EDIT_ROOMSTORAGE_START))->LimitText(9);
	((CEdit *)GetDlgItem(IDC_EDIT_ROOMSTORAGE_DEDUCT))->LimitText(3);
	((CEdit *)GetDlgItem(IDC_EDIT_ROOMSTORAGE_MAX1))->LimitText(9);
	((CEdit *)GetDlgItem(IDC_EDIT_ROOMSTORAGE_MUL1))->LimitText(2);
	((CEdit *)GetDlgItem(IDC_EDIT_ROOMSTORAGE_MAX2))->LimitText(9);
	((CEdit *)GetDlgItem(IDC_EDIT_ROOMSTORAGE_MUL2))->LimitText(2);

	((CEdit *)GetDlgItem(IDC_ROBOT_SCOREMIN))->LimitText(9);
	((CEdit *)GetDlgItem(IDC_ROBOT_BANKERGETBANKER))->LimitText(9);
	((CEdit *)GetDlgItem(IDC_ROBOT_SCOREMAX))->LimitText(9);
	((CEdit *)GetDlgItem(IDC_ROBOT_BANKGET))->LimitText(9);
	((CEdit *)GetDlgItem(IDC_ROBOT_STOMUL))->LimitText(2);

	for (WORD i = 0; i<MAX_CONFIG; i++)
	{
		((CEdit *)GetDlgItem(IDC_EDIT_BT_FREE_0 + i))->LimitText(9);
	}

	for (WORD i = 0; i<MAX_CONFIG; i++)
	{
		((CEdit *)GetDlgItem(IDC_EDIT_BT_PERCENT_0 + i))->LimitText(3);
	}

	for (WORD i = 0; i<MAX_CARD_TYPE; i++)
	{
		((CEdit *)GetDlgItem(IDC_EDIT_CARDTYPETIMES_0 + i))->LimitText(2);
	}

	((CEdit *)GetDlgItem(IDC_EDIT_TRUSTEEDELAY_TIME))->LimitText(1);

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
	SetDlgItemInt(IDC_EDIT_ROOMSTORAGE_START, m_CustomRule.lRoomStorageStart);
	SetDlgItemInt(IDC_EDIT_ROOMSTORAGE_DEDUCT, m_CustomRule.lRoomStorageDeduct);
	SetDlgItemInt(IDC_EDIT_ROOMSTORAGE_MAX1, m_CustomRule.lRoomStorageMax1);
	SetDlgItemInt(IDC_EDIT_ROOMSTORAGE_MUL1, m_CustomRule.lRoomStorageMul1);
	SetDlgItemInt(IDC_EDIT_ROOMSTORAGE_MAX2, m_CustomRule.lRoomStorageMax2);
	SetDlgItemInt(IDC_EDIT_ROOMSTORAGE_MUL2, m_CustomRule.lRoomStorageMul2);

	//AI调试
	SetDlgItemInt(IDC_ROBOT_SCOREMIN, m_CustomRule.lRobotScoreMin);
	SetDlgItemInt(IDC_ROBOT_SCOREMAX, m_CustomRule.lRobotScoreMax);
	SetDlgItemInt(IDC_ROBOT_BANKERGETBANKER, m_CustomRule.lRobotBankGetBanker);
	SetDlgItemInt(IDC_ROBOT_BANKGET, m_CustomRule.lRobotBankGet);
	SetDlgItemInt(IDC_ROBOT_STOMUL, m_CustomRule.lRobotBankStoMul);

	SetDlgItemInt(IDC_EDIT_TRUSTEEDELAY_TIME, m_CustomRule.cbTrusteeDelayTime);

	//游戏牌型
	if (m_CustomRule.ctConfig == CT_CLASSIC_)
	{
		((CButton *)GetDlgItem(IDC_RADIO_CT_CLASSIC))->SetCheck(TRUE);
		((CButton *)GetDlgItem(IDC_RADIO_CT_ADDTIMES))->SetCheck(FALSE);

		for (WORD i = 0; i < MAX_CARD_TYPE; i++)
		{
			SetDlgItemInt(IDC_EDIT_CARDTYPETIMES_0 + i, (UINT)(m_CustomRule.cbCardTypeTimesClassic[i]));
		}

		//牛7到牛牛禁用
		for (WORD i = IDC_EDIT_CARDTYPETIMES_7; i < IDC_EDIT_CARDTYPETIMES_11; i++)
		{
			((CEdit *)GetDlgItem(i))->EnableWindow(FALSE);
		}

		//经典模式选项
		if (m_CustomRule.cbCardTypeTimesClassic[7] == 1 && m_CustomRule.cbCardTypeTimesClassic[8] == 2 && m_CustomRule.cbCardTypeTimesClassic[9] == 2 &&
			m_CustomRule.cbCardTypeTimesClassic[10] == 3)
		{
			((CButton *)GetDlgItem(IDC_RADIO_CTTIMES_CONFIG_0))->SetCheck(FALSE);
			((CButton *)GetDlgItem(IDC_RADIO_CTTIMES_CONFIG_1))->SetCheck(TRUE);

			((CButton *)GetDlgItem(IDC_RADIO_CTTIMES_CONFIG_0))->EnableWindow(TRUE);
			((CButton *)GetDlgItem(IDC_RADIO_CTTIMES_CONFIG_1))->EnableWindow(TRUE);
		}
		else if (m_CustomRule.cbCardTypeTimesClassic[7] == 2 && m_CustomRule.cbCardTypeTimesClassic[8] == 2 && m_CustomRule.cbCardTypeTimesClassic[9] == 3 &&
			m_CustomRule.cbCardTypeTimesClassic[10] == 4)
		{
			((CButton *)GetDlgItem(IDC_RADIO_CTTIMES_CONFIG_0))->SetCheck(TRUE);
			((CButton *)GetDlgItem(IDC_RADIO_CTTIMES_CONFIG_1))->SetCheck(FALSE);

			((CButton *)GetDlgItem(IDC_RADIO_CTTIMES_CONFIG_0))->EnableWindow(TRUE);
			((CButton *)GetDlgItem(IDC_RADIO_CTTIMES_CONFIG_1))->EnableWindow(TRUE);
		}
		else
		{
			ASSERT(FALSE);
		}
	}
	else if (m_CustomRule.ctConfig == CT_ADDTIMES_)
	{
		((CButton *)GetDlgItem(IDC_RADIO_CT_CLASSIC))->SetCheck(FALSE);
		((CButton *)GetDlgItem(IDC_RADIO_CT_ADDTIMES))->SetCheck(TRUE);

		for (WORD i = 0; i < MAX_CARD_TYPE; i++)
		{
			SetDlgItemInt(IDC_EDIT_CARDTYPETIMES_0 + i, (UINT)(m_CustomRule.cbCardTypeTimesAddTimes[i]));
		}

		//牛7到牛牛激活
		for (WORD i = IDC_EDIT_CARDTYPETIMES_7; i < IDC_EDIT_CARDTYPETIMES_11; i++)
		{
			((CEdit *)GetDlgItem(i))->EnableWindow(TRUE);
		}

		//默认经典模式选项禁用
		((CButton *)GetDlgItem(IDC_RADIO_CTTIMES_CONFIG_0))->SetCheck(FALSE);
		((CButton *)GetDlgItem(IDC_RADIO_CTTIMES_CONFIG_0))->EnableWindow(FALSE);
		((CButton *)GetDlgItem(IDC_RADIO_CTTIMES_CONFIG_1))->SetCheck(FALSE);
		((CButton *)GetDlgItem(IDC_RADIO_CTTIMES_CONFIG_1))->EnableWindow(FALSE);
	}

	//发牌模式
	if (m_CustomRule.stConfig == ST_SENDFOUR_)
	{
		((CButton *)GetDlgItem(IDC_RADIO_ST_SENDFOUR))->SetCheck(TRUE);
		((CButton *)GetDlgItem(IDC_RADIO_ST_BETFIRST))->SetCheck(FALSE);
	}
	else if (m_CustomRule.stConfig == ST_BETFIRST_)
	{
		((CButton *)GetDlgItem(IDC_RADIO_ST_SENDFOUR))->SetCheck(FALSE);
		((CButton *)GetDlgItem(IDC_RADIO_ST_BETFIRST))->SetCheck(TRUE);
	}

	//扑克玩法
	if (m_CustomRule.gtConfig == GT_HAVEKING_)
	{
		((CButton *)GetDlgItem(IDC_RADIO_HAVEKING))->SetCheck(TRUE);
		((CButton *)GetDlgItem(IDC_RADIO_NOKING))->SetCheck(FALSE);
	}
	else if (m_CustomRule.gtConfig == GT_NOKING_)
	{
		((CButton *)GetDlgItem(IDC_RADIO_HAVEKING))->SetCheck(FALSE);
		((CButton *)GetDlgItem(IDC_RADIO_NOKING))->SetCheck(TRUE);
	}

	//庄家玩法
	if (m_CustomRule.bgtConfig == BGT_DESPOT_)
	{
		((CButton *)GetDlgItem(IDC_RADIO_DESPOT_BANKER))->SetCheck(TRUE);
		((CButton *)GetDlgItem(IDC_RADIO_ROB_BANKER))->SetCheck(FALSE);
		((CButton *)GetDlgItem(IDC_RADIO_NIUNIU_BANKER))->SetCheck(FALSE);
		((CButton *)GetDlgItem(IDC_RADIO_NONIUNIU))->SetCheck(FALSE);
		((CButton *)GetDlgItem(IDC_RADIO_FREEBANKER))->SetCheck(FALSE);
		((CButton *)GetDlgItem(IDC_RADIO_TONGBI))->SetCheck(FALSE);
	}
	else if (m_CustomRule.bgtConfig == BGT_ROB_)
	{
		((CButton *)GetDlgItem(IDC_RADIO_DESPOT_BANKER))->SetCheck(FALSE);
		((CButton *)GetDlgItem(IDC_RADIO_ROB_BANKER))->SetCheck(TRUE);
		((CButton *)GetDlgItem(IDC_RADIO_NIUNIU_BANKER))->SetCheck(FALSE);
		((CButton *)GetDlgItem(IDC_RADIO_NONIUNIU))->SetCheck(FALSE);
		((CButton *)GetDlgItem(IDC_RADIO_FREEBANKER))->SetCheck(FALSE);
		((CButton *)GetDlgItem(IDC_RADIO_TONGBI))->SetCheck(FALSE);
	}
	else if (m_CustomRule.bgtConfig == BGT_NIUNIU_)
	{
		((CButton *)GetDlgItem(IDC_RADIO_DESPOT_BANKER))->SetCheck(FALSE);
		((CButton *)GetDlgItem(IDC_RADIO_ROB_BANKER))->SetCheck(FALSE);
		((CButton *)GetDlgItem(IDC_RADIO_NIUNIU_BANKER))->SetCheck(TRUE);
		((CButton *)GetDlgItem(IDC_RADIO_NONIUNIU))->SetCheck(FALSE);
		((CButton *)GetDlgItem(IDC_RADIO_FREEBANKER))->SetCheck(FALSE);
		((CButton *)GetDlgItem(IDC_RADIO_TONGBI))->SetCheck(FALSE);
	}
	else if (m_CustomRule.bgtConfig == BGT_NONIUNIU_)
	{
		((CButton *)GetDlgItem(IDC_RADIO_DESPOT_BANKER))->SetCheck(FALSE);
		((CButton *)GetDlgItem(IDC_RADIO_ROB_BANKER))->SetCheck(FALSE);
		((CButton *)GetDlgItem(IDC_RADIO_NIUNIU_BANKER))->SetCheck(FALSE);
		((CButton *)GetDlgItem(IDC_RADIO_NONIUNIU))->SetCheck(TRUE);
		((CButton *)GetDlgItem(IDC_RADIO_FREEBANKER))->SetCheck(FALSE);
		((CButton *)GetDlgItem(IDC_RADIO_TONGBI))->SetCheck(FALSE);
	}
	else if (m_CustomRule.bgtConfig == BGT_FREEBANKER_)
	{
		((CButton *)GetDlgItem(IDC_RADIO_DESPOT_BANKER))->SetCheck(FALSE);
		((CButton *)GetDlgItem(IDC_RADIO_ROB_BANKER))->SetCheck(FALSE);
		((CButton *)GetDlgItem(IDC_RADIO_NIUNIU_BANKER))->SetCheck(FALSE);
		((CButton *)GetDlgItem(IDC_RADIO_NONIUNIU))->SetCheck(FALSE);
		((CButton *)GetDlgItem(IDC_RADIO_FREEBANKER))->SetCheck(TRUE);
		((CButton *)GetDlgItem(IDC_RADIO_TONGBI))->SetCheck(FALSE);
	}
	else if (m_CustomRule.bgtConfig == BGT_TONGBI_)
	{
		((CButton *)GetDlgItem(IDC_RADIO_DESPOT_BANKER))->SetCheck(FALSE);
		((CButton *)GetDlgItem(IDC_RADIO_ROB_BANKER))->SetCheck(FALSE);
		((CButton *)GetDlgItem(IDC_RADIO_NIUNIU_BANKER))->SetCheck(FALSE);
		((CButton *)GetDlgItem(IDC_RADIO_NONIUNIU))->SetCheck(FALSE);
		((CButton *)GetDlgItem(IDC_RADIO_FREEBANKER))->SetCheck(FALSE);
		((CButton *)GetDlgItem(IDC_RADIO_TONGBI))->SetCheck(TRUE);
	}

	//下注配置
	if (m_CustomRule.btConfig == BT_FREE_)
	{
		((CButton *)GetDlgItem(IDC_RADIO_BT_FREE))->SetCheck(TRUE);
		((CButton *)GetDlgItem(IDC_RADIO_BT_PERCENT))->SetCheck(FALSE);

		for (WORD i = 0; i<MAX_CONFIG; i++)
		{
			((CEdit *)GetDlgItem(IDC_EDIT_BT_PERCENT_0 + i))->SetWindowText(TEXT(""));
			((CEdit *)GetDlgItem(IDC_EDIT_BT_PERCENT_0 + i))->EnableWindow(FALSE);


			SetDlgItemInt(IDC_EDIT_BT_FREE_0 + i, m_CustomRule.lFreeConfig[i]);
			((CEdit *)GetDlgItem(IDC_EDIT_BT_FREE_0 + i))->EnableWindow(TRUE);
		}
	}
	else if (m_CustomRule.btConfig == BT_PENCENT_)
	{
		((CButton *)GetDlgItem(IDC_RADIO_BT_FREE))->SetCheck(FALSE);
		((CButton *)GetDlgItem(IDC_RADIO_BT_PERCENT))->SetCheck(TRUE);

		for (WORD i = 0; i<MAX_CONFIG; i++)
		{
			((CEdit *)GetDlgItem(IDC_EDIT_BT_FREE_0 + i))->SetWindowText(TEXT(""));
			((CEdit *)GetDlgItem(IDC_EDIT_BT_FREE_0 + i))->EnableWindow(FALSE);

			SetDlgItemInt(IDC_EDIT_BT_PERCENT_0 + i, m_CustomRule.lPercentConfig[i]);
			((CEdit *)GetDlgItem(IDC_EDIT_BT_PERCENT_0 + i))->EnableWindow(TRUE);
		}
	}

	return true;
}

//更新数据
bool CDlgCustomRule::FillDebugToData()
{
	//设置数据
	m_CustomRule.lRoomStorageStart = (SCORE)GetDlgItemInt(IDC_EDIT_ROOMSTORAGE_START);
	m_CustomRule.lRoomStorageDeduct = (SCORE)GetDlgItemInt(IDC_EDIT_ROOMSTORAGE_DEDUCT);
	m_CustomRule.lRoomStorageMax1 = (SCORE)GetDlgItemInt(IDC_EDIT_ROOMSTORAGE_MAX1);
	m_CustomRule.lRoomStorageMul1 = (SCORE)GetDlgItemInt(IDC_EDIT_ROOMSTORAGE_MUL1);
	m_CustomRule.lRoomStorageMax2 = (SCORE)GetDlgItemInt(IDC_EDIT_ROOMSTORAGE_MAX2);
	m_CustomRule.lRoomStorageMul2 = (SCORE)GetDlgItemInt(IDC_EDIT_ROOMSTORAGE_MUL2);

	//AI调试
	m_CustomRule.lRobotScoreMin = (SCORE)GetDlgItemInt(IDC_ROBOT_SCOREMIN);
	m_CustomRule.lRobotScoreMax = (SCORE)GetDlgItemInt(IDC_ROBOT_SCOREMAX);
	m_CustomRule.lRobotBankGetBanker = (SCORE)GetDlgItemInt(IDC_ROBOT_BANKERGETBANKER);
	m_CustomRule.lRobotBankGet = (SCORE)GetDlgItemInt(IDC_ROBOT_BANKGET);
	m_CustomRule.lRobotBankStoMul = (SCORE)GetDlgItemInt(IDC_ROBOT_STOMUL);

	m_CustomRule.cbTrusteeDelayTime = (BYTE)GetDlgItemInt(IDC_EDIT_TRUSTEEDELAY_TIME);

	//游戏规则
	//游戏牌型
	if (((CButton *)GetDlgItem(IDC_RADIO_CT_CLASSIC))->GetCheck() == TRUE && ((CButton *)GetDlgItem(IDC_RADIO_CT_ADDTIMES))->GetCheck() == FALSE)
	{
		m_CustomRule.ctConfig = CT_CLASSIC_;
		ASSERT(((CButton *)GetDlgItem(IDC_RADIO_CTTIMES_CONFIG_0))->GetCheck() == TRUE ||
			((CButton *)GetDlgItem(IDC_RADIO_CTTIMES_CONFIG_1))->GetCheck() == TRUE);

		for (WORD i = 0; i < MAX_CARD_TYPE; i++)
		{
			m_CustomRule.cbCardTypeTimesClassic[i] = (BYTE)GetDlgItemInt(IDC_EDIT_CARDTYPETIMES_0 + i);

			if (m_CustomRule.cbCardTypeTimesClassic[i] <= 0)
			{
				AfxMessageBox(TEXT("牌型倍数需正常填写！"), MB_ICONSTOP);
				return false;
			}
		}
	}
	else if (((CButton *)GetDlgItem(IDC_RADIO_CT_CLASSIC))->GetCheck() == FALSE && ((CButton *)GetDlgItem(IDC_RADIO_CT_ADDTIMES))->GetCheck() == TRUE)
	{
		m_CustomRule.ctConfig = CT_ADDTIMES_;
		ASSERT(((CButton *)GetDlgItem(IDC_RADIO_CTTIMES_CONFIG_0))->GetCheck() == FALSE &&
			((CButton *)GetDlgItem(IDC_RADIO_CTTIMES_CONFIG_1))->GetCheck() == FALSE);
		for (WORD i = 0; i < MAX_CARD_TYPE; i++)
		{
			m_CustomRule.cbCardTypeTimesAddTimes[i] = (BYTE)GetDlgItemInt(IDC_EDIT_CARDTYPETIMES_0 + i);

			if (m_CustomRule.cbCardTypeTimesAddTimes[i] <= 0)
			{
				AfxMessageBox(TEXT("牌型倍数需正常填写！"), MB_ICONSTOP);
				return false;
			}
		}
	}

	//发牌模式
	if (((CButton *)GetDlgItem(IDC_RADIO_ST_SENDFOUR))->GetCheck() == TRUE && ((CButton *)GetDlgItem(IDC_RADIO_ST_BETFIRST))->GetCheck() == FALSE)
	{
		m_CustomRule.stConfig = ST_SENDFOUR_;
	}
	else if (((CButton *)GetDlgItem(IDC_RADIO_ST_SENDFOUR))->GetCheck() == FALSE && ((CButton *)GetDlgItem(IDC_RADIO_ST_BETFIRST))->GetCheck() == TRUE)
	{
		m_CustomRule.stConfig = ST_BETFIRST_;
	}

	//扑克玩法
	if (((CButton *)GetDlgItem(IDC_RADIO_HAVEKING))->GetCheck() == TRUE && ((CButton *)GetDlgItem(IDC_RADIO_NOKING))->GetCheck() == FALSE)
	{
		m_CustomRule.gtConfig = GT_HAVEKING_;
	}
	else if (((CButton *)GetDlgItem(IDC_RADIO_HAVEKING))->GetCheck() == FALSE && ((CButton *)GetDlgItem(IDC_RADIO_NOKING))->GetCheck() == TRUE)
	{
		m_CustomRule.gtConfig = GT_NOKING_;
	}

	//庄家玩法
	if (((CButton *)GetDlgItem(IDC_RADIO_DESPOT_BANKER))->GetCheck() == TRUE && ((CButton *)GetDlgItem(IDC_RADIO_ROB_BANKER))->GetCheck() == FALSE
		&& ((CButton *)GetDlgItem(IDC_RADIO_NIUNIU_BANKER))->GetCheck() == FALSE && ((CButton *)GetDlgItem(IDC_RADIO_NONIUNIU))->GetCheck() == FALSE
		&& ((CButton *)GetDlgItem(IDC_RADIO_FREEBANKER))->GetCheck() == FALSE && ((CButton *)GetDlgItem(IDC_RADIO_TONGBI))->GetCheck() == FALSE)
	{
		m_CustomRule.bgtConfig = BGT_DESPOT_;
	}
	else if (((CButton *)GetDlgItem(IDC_RADIO_DESPOT_BANKER))->GetCheck() == FALSE && ((CButton *)GetDlgItem(IDC_RADIO_ROB_BANKER))->GetCheck() == TRUE
		&& ((CButton *)GetDlgItem(IDC_RADIO_NIUNIU_BANKER))->GetCheck() == FALSE && ((CButton *)GetDlgItem(IDC_RADIO_NONIUNIU))->GetCheck() == FALSE
		&& ((CButton *)GetDlgItem(IDC_RADIO_FREEBANKER))->GetCheck() == FALSE && ((CButton *)GetDlgItem(IDC_RADIO_TONGBI))->GetCheck() == FALSE)
	{
		m_CustomRule.bgtConfig = BGT_ROB_;
	}
	else if (((CButton *)GetDlgItem(IDC_RADIO_DESPOT_BANKER))->GetCheck() == FALSE && ((CButton *)GetDlgItem(IDC_RADIO_ROB_BANKER))->GetCheck() == FALSE
		&& ((CButton *)GetDlgItem(IDC_RADIO_NIUNIU_BANKER))->GetCheck() == TRUE && ((CButton *)GetDlgItem(IDC_RADIO_NONIUNIU))->GetCheck() == FALSE
		&& ((CButton *)GetDlgItem(IDC_RADIO_FREEBANKER))->GetCheck() == FALSE && ((CButton *)GetDlgItem(IDC_RADIO_TONGBI))->GetCheck() == FALSE)
	{
		m_CustomRule.bgtConfig = BGT_NIUNIU_;
	}
	else if (((CButton *)GetDlgItem(IDC_RADIO_DESPOT_BANKER))->GetCheck() == FALSE && ((CButton *)GetDlgItem(IDC_RADIO_ROB_BANKER))->GetCheck() == FALSE
		&& ((CButton *)GetDlgItem(IDC_RADIO_NIUNIU_BANKER))->GetCheck() == FALSE && ((CButton *)GetDlgItem(IDC_RADIO_NONIUNIU))->GetCheck() == TRUE
		&& ((CButton *)GetDlgItem(IDC_RADIO_FREEBANKER))->GetCheck() == FALSE && ((CButton *)GetDlgItem(IDC_RADIO_TONGBI))->GetCheck() == FALSE)
	{
		m_CustomRule.bgtConfig = BGT_NONIUNIU_;
	}
	else if (((CButton *)GetDlgItem(IDC_RADIO_DESPOT_BANKER))->GetCheck() == FALSE && ((CButton *)GetDlgItem(IDC_RADIO_ROB_BANKER))->GetCheck() == FALSE
		&& ((CButton *)GetDlgItem(IDC_RADIO_NIUNIU_BANKER))->GetCheck() == FALSE && ((CButton *)GetDlgItem(IDC_RADIO_NONIUNIU))->GetCheck() == FALSE
		&& ((CButton *)GetDlgItem(IDC_RADIO_FREEBANKER))->GetCheck() == TRUE && ((CButton *)GetDlgItem(IDC_RADIO_TONGBI))->GetCheck() == FALSE)
	{
		m_CustomRule.bgtConfig = BGT_FREEBANKER_;
	}
	else if (((CButton *)GetDlgItem(IDC_RADIO_DESPOT_BANKER))->GetCheck() == FALSE && ((CButton *)GetDlgItem(IDC_RADIO_ROB_BANKER))->GetCheck() == FALSE
		&& ((CButton *)GetDlgItem(IDC_RADIO_NIUNIU_BANKER))->GetCheck() == FALSE && ((CButton *)GetDlgItem(IDC_RADIO_NONIUNIU))->GetCheck() == FALSE
		&& ((CButton *)GetDlgItem(IDC_RADIO_FREEBANKER))->GetCheck() == FALSE && ((CButton *)GetDlgItem(IDC_RADIO_TONGBI))->GetCheck() == TRUE)
	{
		m_CustomRule.bgtConfig = BGT_TONGBI_;
	}

	//下注配置
	if (((CButton *)GetDlgItem(IDC_RADIO_BT_FREE))->GetCheck() == TRUE && ((CButton *)GetDlgItem(IDC_RADIO_BT_PERCENT))->GetCheck() == FALSE)
	{
		m_CustomRule.btConfig = BT_FREE_;

		for (WORD i = 0; i<MAX_CONFIG; i++)
		{
			m_CustomRule.lFreeConfig[i] = (LONG)GetDlgItemInt(IDC_EDIT_BT_FREE_0 + i);
		}

		//校验前两个
		if (m_CustomRule.lFreeConfig[0] == 0 || m_CustomRule.lFreeConfig[1] == 0)
		{
			AfxMessageBox(TEXT("自由配置额度前两个不应为0，请重新设置！"), MB_ICONSTOP);
			return false;
		}

		//校验是否递增和重复
		for (WORD i = 0; i<MAX_CONFIG - 1; i++)
		{
			if (m_CustomRule.lFreeConfig[i + 1] <= m_CustomRule.lFreeConfig[i])
			{
				//是否后面都是0
				bool bContinueZero = true;

				for (WORD j = i + 1; j<MAX_CONFIG; j++)
				{
					if (m_CustomRule.lFreeConfig[j] != 0)
					{
						bContinueZero = false;
						break;
					}
				}

				if (!bContinueZero)
				{
					AfxMessageBox(TEXT("自由配置额度应该递增且唯一，请重新设置！"), MB_ICONSTOP);
					return false;
				}

			}
		}
	}
	else if (((CButton *)GetDlgItem(IDC_RADIO_BT_FREE))->GetCheck() == FALSE && ((CButton *)GetDlgItem(IDC_RADIO_BT_PERCENT))->GetCheck() == TRUE)
	{
		m_CustomRule.btConfig = BT_PENCENT_;

		for (WORD i = 0; i<MAX_CONFIG; i++)
		{
			m_CustomRule.lPercentConfig[i] = (LONG)GetDlgItemInt(IDC_EDIT_BT_PERCENT_0 + i);
		}

		//校验前两个
		if (m_CustomRule.lPercentConfig[0] == 0 || m_CustomRule.lPercentConfig[1] == 0)
		{
			AfxMessageBox(TEXT("百分比配置额度前两个不应为0，请重新设置！"), MB_ICONSTOP);
			return false;
		}

		//校验是否递增和重复
		for (WORD i = 0; i<MAX_CONFIG - 1; i++)
		{
			if (m_CustomRule.lPercentConfig[i + 1] <= m_CustomRule.lPercentConfig[i])
			{
				//是否后面都是0
				bool bContinueZero = true;

				for (WORD j = i + 1; j<MAX_CONFIG; j++)
				{
					if (m_CustomRule.lPercentConfig[j] != 0)
					{
						bContinueZero = false;
						break;
					}
				}

				if (!bContinueZero)
				{
					AfxMessageBox(TEXT("百分比配置额度应该递增且唯一，请重新设置！"), MB_ICONSTOP);
					return false;
				}

			}
		}

		for (WORD i = 0; i<MAX_CONFIG; i++)
		{
			if (m_CustomRule.lPercentConfig[i] > 100)
			{
				AfxMessageBox(TEXT("百分比配置额度不应该大于100，请重新设置！"), MB_ICONSTOP);
				return false;
			}
		}
	}

	//数据校验
	if ((m_CustomRule.lRoomStorageMax1 > m_CustomRule.lRoomStorageMax2))
	{
		AfxMessageBox(TEXT("库存封顶值1应小于库存封顶值2，请重新设置！"), MB_ICONSTOP);
		return false;
	}

	if ((m_CustomRule.lRoomStorageMul1 > m_CustomRule.lRoomStorageMul2))
	{
		AfxMessageBox(TEXT("赢分概率1应小于赢分概率2，请重新设置！"), MB_ICONSTOP);
		return false;
	}

	if ((m_CustomRule.lRobotScoreMin > m_CustomRule.lRobotScoreMax))
	{
		AfxMessageBox(TEXT("AI分数最小值应小于最大值，请重新设置！"), MB_ICONSTOP);
		return false;
	}

	if (!(m_CustomRule.cbTrusteeDelayTime >= 3 && m_CustomRule.cbTrusteeDelayTime <= 6))
	{
		AfxMessageBox(TEXT("断线托管延时有效时间3-6秒，请重新设置！"), MB_ICONSTOP);
		return false;
	}

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
	if (m_hWnd != NULL) FillDataToDebug();

	return true;
}

void CDlgCustomRule::OnClickClassic()
{
	//过滤无效操作
	if (m_CustomRule.ctConfig == CT_CLASSIC_)
	{
		return;
	}

	//点击经典保存上次加倍模式的最后设置
	for (WORD i = 0; i < MAX_CARD_TYPE; i++)
	{
		m_CustomRule.cbCardTypeTimesAddTimes[i] = (BYTE)GetDlgItemInt(IDC_EDIT_CARDTYPETIMES_0 + i);

		if (m_CustomRule.cbCardTypeTimesAddTimes[i] <= 0)
		{
			//填写无效默认保存1
			m_CustomRule.cbCardTypeTimesAddTimes[i] = 1;
		}
	}

	for (WORD i = 0; i < MAX_CARD_TYPE; i++)
	{
		SetDlgItemInt(IDC_EDIT_CARDTYPETIMES_0 + i, (UINT)(m_CustomRule.cbCardTypeTimesClassic[i]));
	}

	//牛7到牛牛禁用
	for (WORD i = IDC_EDIT_CARDTYPETIMES_7; i < IDC_EDIT_CARDTYPETIMES_11; i++)
	{
		((CEdit *)GetDlgItem(i))->EnableWindow(FALSE);
	}

	//经典模式选项
	if (m_CustomRule.cbCardTypeTimesClassic[7] == 1 && m_CustomRule.cbCardTypeTimesClassic[8] == 2 && m_CustomRule.cbCardTypeTimesClassic[9] == 2 &&
		m_CustomRule.cbCardTypeTimesClassic[10] == 3)
	{
		((CButton *)GetDlgItem(IDC_RADIO_CTTIMES_CONFIG_0))->SetCheck(FALSE);
		((CButton *)GetDlgItem(IDC_RADIO_CTTIMES_CONFIG_1))->SetCheck(TRUE);

		((CButton *)GetDlgItem(IDC_RADIO_CTTIMES_CONFIG_0))->EnableWindow(TRUE);
		((CButton *)GetDlgItem(IDC_RADIO_CTTIMES_CONFIG_1))->EnableWindow(TRUE);
	}
	else if (m_CustomRule.cbCardTypeTimesClassic[7] == 2 && m_CustomRule.cbCardTypeTimesClassic[8] == 2 && m_CustomRule.cbCardTypeTimesClassic[9] == 3 &&
		m_CustomRule.cbCardTypeTimesClassic[10] == 4)
	{
		((CButton *)GetDlgItem(IDC_RADIO_CTTIMES_CONFIG_0))->SetCheck(TRUE);
		((CButton *)GetDlgItem(IDC_RADIO_CTTIMES_CONFIG_1))->SetCheck(FALSE);

		((CButton *)GetDlgItem(IDC_RADIO_CTTIMES_CONFIG_0))->EnableWindow(TRUE);
		((CButton *)GetDlgItem(IDC_RADIO_CTTIMES_CONFIG_1))->EnableWindow(TRUE);
	}

	m_CustomRule.ctConfig = CT_CLASSIC_;
}

void CDlgCustomRule::OnClickAddTimes()
{
	//过滤无效操作
	if (m_CustomRule.ctConfig == CT_ADDTIMES_)
	{
		return;
	}

	//点击加倍保存上次经典模式的最后设置
	for (WORD i = 0; i < MAX_CARD_TYPE; i++)
	{
		m_CustomRule.cbCardTypeTimesClassic[i] = (BYTE)GetDlgItemInt(IDC_EDIT_CARDTYPETIMES_0 + i);

		if (m_CustomRule.cbCardTypeTimesClassic[i] <= 0)
		{
			//填写无效默认保存1
			m_CustomRule.cbCardTypeTimesClassic[i] = 1;
		}
	}

	for (BYTE i = 0; i < MAX_CARD_TYPE; i++)
	{
		SetDlgItemInt(IDC_EDIT_CARDTYPETIMES_0 + i, (UINT)(m_CustomRule.cbCardTypeTimesAddTimes[i]));
	}

	//牛7到牛牛激活
	for (BYTE i = IDC_EDIT_CARDTYPETIMES_7; i < IDC_EDIT_CARDTYPETIMES_11; i++)
	{
		((CEdit *)GetDlgItem(i))->EnableWindow(TRUE);
	}

	//默认经典模式选项
	((CButton *)GetDlgItem(IDC_RADIO_CTTIMES_CONFIG_0))->EnableWindow(FALSE);
	((CButton *)GetDlgItem(IDC_RADIO_CTTIMES_CONFIG_0))->SetCheck(FALSE);
	((CButton *)GetDlgItem(IDC_RADIO_CTTIMES_CONFIG_1))->EnableWindow(FALSE);
	((CButton *)GetDlgItem(IDC_RADIO_CTTIMES_CONFIG_1))->SetCheck(FALSE);

	m_CustomRule.ctConfig = CT_ADDTIMES_;
}

void CDlgCustomRule::OnClickBTFree()
{
	if (m_CustomRule.lFreeConfig[0] == 0)
	{
		m_CustomRule.lFreeConfig[0] = 2;
		m_CustomRule.lFreeConfig[1] = 5;
		m_CustomRule.lFreeConfig[2] = 8;
		m_CustomRule.lFreeConfig[3] = 11;
		//m_CustomRule.lFreeConfig[4] = 15;
	}

	ZeroMemory(m_CustomRule.lPercentConfig, sizeof(m_CustomRule.lPercentConfig));

	for (WORD i = 0; i<MAX_CONFIG; i++)
	{
		((CEdit *)GetDlgItem(IDC_EDIT_BT_PERCENT_0 + i))->SetWindowText(TEXT(""));
		((CEdit *)GetDlgItem(IDC_EDIT_BT_PERCENT_0 + i))->EnableWindow(FALSE);

		((CEdit *)GetDlgItem(IDC_EDIT_BT_FREE_0 + i))->EnableWindow(TRUE);
		SetDlgItemInt(IDC_EDIT_BT_FREE_0 + i, m_CustomRule.lFreeConfig[i]);
	}
}

void CDlgCustomRule::OnClickBTPercent()
{
	if (m_CustomRule.lPercentConfig[0] == 0)
	{
		m_CustomRule.lPercentConfig[0] = 20;
		m_CustomRule.lPercentConfig[1] = 30;
		m_CustomRule.lPercentConfig[2] = 50;
		m_CustomRule.lPercentConfig[3] = 80;
		//m_CustomRule.lPercentConfig[4] = 100;
	}

	ZeroMemory(m_CustomRule.lFreeConfig, sizeof(m_CustomRule.lFreeConfig));


	for (WORD i = 0; i<MAX_CONFIG; i++)
	{
		((CEdit *)GetDlgItem(IDC_EDIT_BT_FREE_0 + i))->SetWindowText(TEXT(""));
		((CEdit *)GetDlgItem(IDC_EDIT_BT_FREE_0 + i))->EnableWindow(FALSE);

		((CEdit *)GetDlgItem(IDC_EDIT_BT_PERCENT_0 + i))->EnableWindow(TRUE);
		SetDlgItemInt(IDC_EDIT_BT_PERCENT_0 + i, m_CustomRule.lPercentConfig[i]);
	}
}

void CDlgCustomRule::OnClickCTTimesConfig0()
{
	ASSERT(m_CustomRule.ctConfig == CT_CLASSIC_);

	SetDlgItemInt(IDC_EDIT_CARDTYPETIMES_7, (UINT)(2));
	SetDlgItemInt(IDC_EDIT_CARDTYPETIMES_8, (UINT)(2));
	SetDlgItemInt(IDC_EDIT_CARDTYPETIMES_9, (UINT)(3));
	SetDlgItemInt(IDC_EDIT_CARDTYPETIMES_10, (UINT)(4));

	m_CustomRule.cbCardTypeTimesClassic[7] = 2;
	m_CustomRule.cbCardTypeTimesClassic[8] = 2;
	m_CustomRule.cbCardTypeTimesClassic[9] = 3;
	m_CustomRule.cbCardTypeTimesClassic[10] = 4;
}

void CDlgCustomRule::OnClickCTTimesConfig1()
{
	ASSERT(m_CustomRule.ctConfig == CT_CLASSIC_);

	SetDlgItemInt(IDC_EDIT_CARDTYPETIMES_7, (UINT)(1));
	SetDlgItemInt(IDC_EDIT_CARDTYPETIMES_8, (UINT)(2));
	SetDlgItemInt(IDC_EDIT_CARDTYPETIMES_9, (UINT)(2));
	SetDlgItemInt(IDC_EDIT_CARDTYPETIMES_10, (UINT)(3));

	m_CustomRule.cbCardTypeTimesClassic[7] = 1;
	m_CustomRule.cbCardTypeTimesClassic[8] = 2;
	m_CustomRule.cbCardTypeTimesClassic[9] = 2;
	m_CustomRule.cbCardTypeTimesClassic[10] = 3;
}

void CDlgCustomRule::OnVScroll(UINT nSBCode, UINT nPos, CScrollBar* pScrollBar)
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
							curpos = max(minpos, curpos - (int)info.nPage);
	}
		break;

	case SB_PAGERIGHT:
	{
						 SCROLLINFO   info;
						 GetScrollInfo(SB_VERT, &info, SIF_ALL);

						 if (curpos < maxpos)
							 curpos = min(maxpos, curpos + (int)info.nPage);
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
	ScrollWindow(0, oldpos - curpos);

	oldpos = curpos;
	UpdateWindow();
	CDialog::OnVScroll(nSBCode, nPos, pScrollBar);
}

void CDlgCustomRule::OnSize(UINT nType, int cx, int cy)
{
	CDialog::OnSize(nType, cx, cy);
	//设置滚动条范围  
	SCROLLINFO si;
	si.cbSize = sizeof(si);
	si.fMask = SIF_RANGE | SIF_PAGE;
	si.nMin = 0;
	si.nMax = 896;
	si.nPage = cy;
	SetScrollInfo(SB_VERT, &si, TRUE);

	int icurypos = GetScrollPos(SB_VERT);

	if (icurypos < m_iyoldpos)
	{
		ScrollWindow(0, m_iyoldpos - icurypos);
	}
	m_iyoldpos = icurypos;

	Invalidate(TRUE);
}

//////////////////////////////////////////////////////////////////////////////////

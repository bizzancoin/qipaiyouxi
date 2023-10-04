#include "Stdafx.h"
#include "Resource.h"
#include "DlgPersonalRule.h"

//////////////////////////////////////////////////////////////////////////////////

BEGIN_MESSAGE_MAP(CDlgPersonalRule, CDialog)
	ON_WM_VSCROLL()
	ON_WM_SIZE()
END_MESSAGE_MAP()

//////////////////////////////////////////////////////////////////////////////////
const int g_nCellScore[CELLSCORE_COUNT] = { 100, 200, 500, 1000, 2000 };

//构造函数
CDlgPersonalRule::CDlgPersonalRule() : CDialog(IDD_PERSONAL_RULE)
{
	//设置变量
	ZeroMemory(&m_OxSixXSpecialRule, sizeof(m_OxSixXSpecialRule));

	m_iyoldpos = 0;

	for (WORD i = 0; i < MAX_BANKERMODE; i++)
	{
		m_OxSixXSpecialRule.cbBankerModeEnable[i] = TRUE;
	}

	//霸王庄禁用
	m_OxSixXSpecialRule.cbBankerModeEnable[0] = FALSE;

	for (WORD i = 0; i < MAX_GAMEMODE; i++)
	{
		m_OxSixXSpecialRule.cbGameModeEnable[i] = TRUE;
	}

	for (WORD i = 0; i < MAX_ADVANCECONFIG; i++)
	{
		m_OxSixXSpecialRule.cbAdvancedConfig[i] = TRUE;
	}

	for (WORD i = 0; i < MAX_SPECIAL_CARD_TYPE; i++)
	{
		m_OxSixXSpecialRule.cbSpeCardType[i] = TRUE;
	}

	m_OxSixXSpecialRule.cbBeBankerCon[0] = 100;
	m_OxSixXSpecialRule.cbBeBankerCon[1] = 120;
	m_OxSixXSpecialRule.cbBeBankerCon[2] = 150;
	m_OxSixXSpecialRule.cbBeBankerCon[3] = 200;

	m_OxSixXSpecialRule.cbUserbetTimes[0] = 5;
	m_OxSixXSpecialRule.cbUserbetTimes[1] = 8;
	m_OxSixXSpecialRule.cbUserbetTimes[2] = 10;
	m_OxSixXSpecialRule.cbUserbetTimes[3] = 20;

	return;
}

//析构函数
CDlgPersonalRule::~CDlgPersonalRule()
{
}

//配置函数
BOOL CDlgPersonalRule::OnInitDialog()
{
	__super::OnInitDialog();

	//设置控件

	//更新参数
	FillDataToDebug();

	return FALSE;
}

//确定函数
VOID CDlgPersonalRule::OnOK()
{
	//投递消息
	GetParent()->PostMessage(WM_COMMAND, MAKELONG(IDOK, 0), 0);

	return;
}

//取消消息
VOID CDlgPersonalRule::OnCancel()
{
	//投递消息
	GetParent()->PostMessage(WM_COMMAND, MAKELONG(IDCANCEL, 0), 0);

	return;
}

//更新控件
bool CDlgPersonalRule::FillDataToDebug()
{
	//设置房间参数数据
	int i = 0;
	for (i = IDC_TIME_START_GAME5; i < IDC_TIME_START_GAME5 + 20; i += 4)
	{
		SetDlgItemInt(i, m_OxSixXSpecialRule.comPersonalRule.personalRule[(i - IDC_TIME_START_GAME5) / 4].nTurnCount);
		SetDlgItemInt(i + 1, m_OxSixXSpecialRule.comPersonalRule.personalRule[(i - IDC_TIME_START_GAME5) / 4].nPlayerCount);
		SetDlgItemInt(i + 2, m_OxSixXSpecialRule.comPersonalRule.personalRule[(i - IDC_TIME_START_GAME5) / 4].nFee);
		SetDlgItemInt(i + 3, m_OxSixXSpecialRule.comPersonalRule.personalRule[(i - IDC_TIME_START_GAME5) / 4].nIniScore);
	}

	//设置房间底分
	for (i = IDC_EDIT1; i < IDC_EDIT1 + CELLSCORE_COUNT; i++)
	{
		SetDlgItemInt(i, m_OxSixXSpecialRule.comPersonalRule.nCellScore[i - IDC_EDIT1]);
	}

	for (WORD i = 0; i < MAX_BANKERMODE; i++)
	{
		((CButton *)GetDlgItem(IDC_CHECK_BGT_DESPOT_ + i))->SetCheck(m_OxSixXSpecialRule.cbBankerModeEnable[i]);
	}

	for (WORD i = 0; i < MAX_GAMEMODE; i++)
	{
		((CButton *)GetDlgItem(IDC_CHECK_CT_CLASSIC_ + i))->SetCheck(m_OxSixXSpecialRule.cbGameModeEnable[i]);
	}

	for (WORD i = 0; i < MAX_ADVANCECONFIG; i++)
	{
		((CButton *)GetDlgItem(IDC_CHECK_SENDFOUR + i))->SetCheck(m_OxSixXSpecialRule.cbAdvancedConfig[i]);
	}

	for (WORD i = 0; i < MAX_SPECIAL_CARD_TYPE; i++)
	{
		((CButton *)GetDlgItem(IDC_CHECK_FOURFLOWER + i))->SetCheck(m_OxSixXSpecialRule.cbSpeCardType[i]);
	}

	for (WORD i = 0; i < MAX_BEBANKERCON; i++)
	{
		SetDlgItemInt(IDC_EDIT_BEBANKER_CON0 + i, (UINT)(m_OxSixXSpecialRule.cbBeBankerCon[i]));
	}

	for (WORD i = 0; i < MAX_USERBETTIMES; i++)
	{
		SetDlgItemInt(IDC_EDIT_USERBETTIMES_0 + i, (UINT)(m_OxSixXSpecialRule.cbUserbetTimes[i]));
	}

	return true;
}

//更新数据
bool CDlgPersonalRule::FillDebugToData()
{
	//更新数据
	m_OxSixXSpecialRule.comPersonalRule.cbSpecialRule = 1;
	int i = 0;
	for (i = IDC_TIME_START_GAME5; i < IDC_TIME_START_GAME5 + 20; i += 4)
	{
		m_OxSixXSpecialRule.comPersonalRule.personalRule[(i - IDC_TIME_START_GAME5) / 4].nTurnCount = GetDlgItemInt(i);
		m_OxSixXSpecialRule.comPersonalRule.personalRule[(i - IDC_TIME_START_GAME5) / 4].nPlayerCount = GetDlgItemInt(i + 1);
		m_OxSixXSpecialRule.comPersonalRule.personalRule[(i - IDC_TIME_START_GAME5) / 4].nFee = GetDlgItemInt(i + 2);
		m_OxSixXSpecialRule.comPersonalRule.personalRule[(i - IDC_TIME_START_GAME5) / 4].nIniScore = GetDlgItemInt(i + 3);
	}

	//获取房间底分
	for (i = IDC_EDIT1; i < IDC_EDIT1 + CELLSCORE_COUNT; i++)
	{
		m_OxSixXSpecialRule.comPersonalRule.nCellScore[i - IDC_EDIT1] = GetDlgItemInt(i);
	}

	for (WORD i = 0; i < MAX_BANKERMODE; i++)
	{
		m_OxSixXSpecialRule.cbBankerModeEnable[i] = ((CButton *)GetDlgItem(IDC_CHECK_BGT_DESPOT_ + i))->GetCheck();
	}

	for (WORD i = 0; i < MAX_GAMEMODE; i++)
	{
		m_OxSixXSpecialRule.cbGameModeEnable[i] = ((CButton *)GetDlgItem(IDC_CHECK_CT_CLASSIC_ + i))->GetCheck();
	}

	for (WORD i = 0; i < MAX_ADVANCECONFIG; i++)
	{
		m_OxSixXSpecialRule.cbAdvancedConfig[i] = ((CButton *)GetDlgItem(IDC_CHECK_SENDFOUR + i))->GetCheck();
	}

	for (WORD i = 0; i < MAX_SPECIAL_CARD_TYPE; i++)
	{
		m_OxSixXSpecialRule.cbSpeCardType[i] = ((CButton *)GetDlgItem(IDC_CHECK_FOURFLOWER + i))->GetCheck();
	}

	for (WORD i = 0; i < MAX_BEBANKERCON; i++)
	{
		CString str;
		GetDlgItemText(IDC_EDIT_BEBANKER_CON0 + i, str);
		if (str == TEXT(""))
		{
			SetDlgItemInt(IDC_EDIT_BEBANKER_CON0 + i, (UINT)(0xFFFFFFFF));
		}

		m_OxSixXSpecialRule.cbBeBankerCon[i] = (DWORD)GetDlgItemInt(IDC_EDIT_BEBANKER_CON0 + i);
	}

	for (WORD i = 0; i < MAX_USERBETTIMES; i++)
	{
		CString str;
		GetDlgItemText(IDC_EDIT_USERBETTIMES_0 + i, str);
		if (str == TEXT(""))
		{
			SetDlgItemInt(IDC_EDIT_USERBETTIMES_0 + i, (UINT)(0xFFFFFFFF));
		}

		m_OxSixXSpecialRule.cbUserbetTimes[i] = (DWORD)GetDlgItemInt(IDC_EDIT_USERBETTIMES_0 + i);
	}

	return true;
}

//读取配置
bool CDlgPersonalRule::GetPersonalRule(tagOxSixXSpecial & OxSixXSpecialRule)
{
	//读取参数
	if (FillDebugToData() == true)
	{
		OxSixXSpecialRule = m_OxSixXSpecialRule;
		return true;
	}

	return false;
}

//设置配置
bool CDlgPersonalRule::SetPersonalRule(tagOxSixXSpecial & OxSixXSpecialRule)
{
	//设置变量
	m_OxSixXSpecialRule = OxSixXSpecialRule;

	if (m_OxSixXSpecialRule.comPersonalRule.personalRule[0].nTurnCount == 0 ||
		m_OxSixXSpecialRule.comPersonalRule.personalRule[0].nFee == 0)
	{
		m_OxSixXSpecialRule.comPersonalRule.personalRule[0].nTurnCount = 5;
		m_OxSixXSpecialRule.comPersonalRule.personalRule[0].nFee = 1;
		m_OxSixXSpecialRule.comPersonalRule.personalRule[0].nIniScore = 1000;
	}

	if (m_OxSixXSpecialRule.comPersonalRule.nCellScore[0] == 0)
	{
		m_OxSixXSpecialRule.comPersonalRule.nCellScore[0] = 10;
		m_OxSixXSpecialRule.comPersonalRule.nCellScore[1] = 20;
		m_OxSixXSpecialRule.comPersonalRule.nCellScore[2] = 30;
		m_OxSixXSpecialRule.comPersonalRule.nCellScore[3] = 40;
		m_OxSixXSpecialRule.comPersonalRule.nCellScore[4] = 50;
	}

	//更新参数
	if (m_hWnd != NULL) FillDataToDebug();

	return true;
}

void CDlgPersonalRule::OnVScroll(UINT nSBCode, UINT nPos, CScrollBar* pScrollBar)
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

void CDlgPersonalRule::OnSize(UINT nType, int cx, int cy)
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

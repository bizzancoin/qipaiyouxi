#include "Stdafx.h"
#include "GameOption.h"

//////////////////////////////////////////////////////////////////////////

BEGIN_MESSAGE_MAP(CGameOption, CSkinDialog)

	ON_WM_CTLCOLOR()

END_MESSAGE_MAP()

//////////////////////////////////////////////////////////////////////////

//构造函数
CGameOption::CGameOption() : CSkinDialog(IDD_OPTION)
{
	m_bEnableSound=true;
	m_bEnableBGSound=true;
	return;
}

//析构函数
CGameOption::~CGameOption()
{
}

//控件绑定
void CGameOption::DoDataExchange(CDataExchange * pDX)
{
	__super::DoDataExchange(pDX);
	DDX_Control(pDX, IDOK, m_btOK);
	DDX_Control(pDX, IDCANCEL, m_btCancel);
}

//初始化函数
BOOL CGameOption::OnInitDialog()
{
	__super::OnInitDialog();

	//设置标题
	SetWindowText(TEXT("游戏配置"));
	//设置控件
	if (m_bEnableSound==true) ((CButton *)GetDlgItem(IDC_ENABLE_SOUND))->SetCheck(BST_CHECKED);

	if (m_bEnableBGSound==true) ((CButton *)GetDlgItem(IDC_ENABLE_BG_SOUND))->SetCheck(BST_CHECKED);

	m_brush.CreateSolidBrush(RGB(136,77,32));
	return TRUE;
}

//确定消息
void CGameOption::OnOK()
{
	//获取变量
	m_bEnableSound=(((CButton *)GetDlgItem(IDC_ENABLE_SOUND))->GetCheck()==BST_CHECKED);
	m_bEnableBGSound=(((CButton *)GetDlgItem(IDC_ENABLE_BG_SOUND))->GetCheck()==BST_CHECKED);

	__super::OnOK();
}

HBRUSH CGameOption::OnCtlColor(CDC* pDC, CWnd* pWnd, UINT nCtlColor)
{
	HBRUSH hbr = __super::OnCtlColor(pDC, pWnd, nCtlColor);

	//INT ControlID[3] = {IDC_ENABLE_SOUND,IDC_ENABLE_BG_SOUND,IDC_STATIC_GROUP};
	//for(int i = 0; i < 3; ++i)
	//{
	//	if(pWnd->GetSafeHwnd() == GetDlgItem(ControlID[i])->GetSafeHwnd())
	//	{
	//		pDC->SetBkMode(TRANSPARENT);
	//		//	pDC->SetTextColor(RGB(193,167,108));
	//		return m_brush; 
	//	}
	//}
	//if(pWnd->GetSafeHwnd() == GetDlgItem(IDC_ENABLE_SOUND)->GetSafeHwnd())
	//{
	//	pDC->SetBkMode(TRANSPARENT);
	////	pDC->SetTextColor(RGB(193,167,108));
	//	return m_brush; 
	//}
	//if(pWnd->GetSafeHwnd() == GetDlgItem(IDC_STATIC_GROUP)->GetSafeHwnd())
	//{
	//	pDC->SetBkMode(TRANSPARENT);
	//	//	pDC->SetTextColor(RGB(193,167,108));
	//	return m_brush; 
	//}
	return hbr;
}
//////////////////////////////////////////////////////////////////////////

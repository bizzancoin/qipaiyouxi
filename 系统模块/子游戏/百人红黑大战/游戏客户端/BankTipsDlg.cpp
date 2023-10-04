// BankTipsDlg.cpp : 实现文件
//

#include "stdafx.h"
#include "BankTipsDlg.h"


// CBankTipsDlg 对话框

IMPLEMENT_DYNAMIC(CBankTipsDlg, CSkinDialog)
CBankTipsDlg::CBankTipsDlg(CWnd* pParent /*=NULL*/)
	: CSkinDialog(CBankTipsDlg::IDD, pParent)
{
}

CBankTipsDlg::~CBankTipsDlg()
{
	m_StartLoc.SetPoint(0,0);
}

void CBankTipsDlg::DoDataExchange(CDataExchange* pDX)
{
	CSkinDialog::DoDataExchange(pDX);
	DDX_Control(pDX, IDOK, m_btOK);
	DDX_Control(pDX, IDCANCEL, m_btCancel);
}


BEGIN_MESSAGE_MAP(CBankTipsDlg, CSkinDialog)
END_MESSAGE_MAP()


//初始化函数
BOOL CBankTipsDlg::OnInitDialog()
{
	__super::OnInitDialog();

	m_bRestore=true;

	//设置标题
	SetWindowText(TEXT("选择类型"));
	//设置控件
	((CButton *)GetDlgItem(IDC_RADIO2))->SetCheck(BST_CHECKED);

	CRect clientRect;
	GetClientRect(clientRect);
	
	MoveWindow(m_StartLoc.x,m_StartLoc.y,clientRect.Width(),clientRect.Height());

	return TRUE;
}

//确定消息
void CBankTipsDlg::OnOK()
{
	//获取变量
	m_bRestore=(((CButton *)GetDlgItem(IDC_RADIO1))->GetCheck()==BST_CHECKED);
	
	__super::OnOK();
}

void CBankTipsDlg::SetStartLoc(CPoint startPoint)
{

	m_StartLoc=startPoint;
}


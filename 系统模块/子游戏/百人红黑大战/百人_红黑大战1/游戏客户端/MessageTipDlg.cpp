// MessageTipDlg.cpp : 实现文件
//

#include "stdafx.h"
#include "MessageTipDlg.h"


// CMessageTipDlg 对话框


IMPLEMENT_DYNAMIC(CMessageTipDlg, CSkinDialog)
CMessageTipDlg::CMessageTipDlg(CWnd* pParent /*=NULL*/)
	: CSkinDialog(CMessageTipDlg::IDD, pParent)
{
}

CMessageTipDlg::~CMessageTipDlg()
{
}

void CMessageTipDlg::DoDataExchange(CDataExchange* pDX)
{
	__super::DoDataExchange(pDX);
	DDX_Control(pDX, IDOK, m_btOK);
	DDX_Control(pDX, IDCANCEL, m_btCancel);
}


BEGIN_MESSAGE_MAP(CMessageTipDlg, CSkinDialog)

END_MESSAGE_MAP()



//初始化函数
BOOL CMessageTipDlg::OnInitDialog()
{
	__super::OnInitDialog();

	//设置标题
	SetWindowText(TEXT("提示"));
	
	m_brush.CreateSolidBrush(RGB(136,77,32));

	return TRUE;
}

//确定消息
void CMessageTipDlg::OnOK()
{
		
	__super::OnOK();
}

// CMessageTipDlg 消息处理程序

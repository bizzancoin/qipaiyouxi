#pragma once
#include "Stdafx.h"
#include "Resource.h"

// CMessageTipDlg 对话框

class CMessageTipDlg : public CSkinDialog
{
	DECLARE_DYNAMIC(CMessageTipDlg)

public:
	CMessageTipDlg(CWnd* pParent = NULL);   // 标准构造函数
	virtual ~CMessageTipDlg();

	//控件变量
public:
	CSkinButton						m_btOK;								//确定按钮
	CSkinButton						m_btCancel;							//取消按钮
	CBrush							m_brush;

// 对话框数据
	enum { IDD = IDD_MESSAGEDLG };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV 支持
	//初始化函数
	virtual BOOL OnInitDialog();
	//确定消息
	virtual void OnOK();

	//消息函数
public:

	DECLARE_MESSAGE_MAP()
};

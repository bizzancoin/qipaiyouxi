#pragma once

#include "Stdafx.h"
#include "Resource.h"

// CBankTipsDlg 对话框

class CBankTipsDlg : public CSkinDialog
{
	DECLARE_DYNAMIC(CBankTipsDlg)

public:
	CBankTipsDlg(CWnd* pParent = NULL);   // 标准构造函数
	virtual ~CBankTipsDlg();

	//控件变量
public:
	CSkinButton						m_btOK;								//确定按钮
	CSkinButton						m_btCancel;							//取消按钮
	bool                            m_bRestore;							//是否存款	
	CPoint                          m_StartLoc;							//开始位置
	void							SetStartLoc(CPoint startPoint);

// 对话框数据
	enum { IDD = IDD_BANKTIPS_DLG };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV 支持
	//初始化函数
	virtual BOOL OnInitDialog();
	//确定消息
	virtual void OnOK();

	DECLARE_MESSAGE_MAP()
};

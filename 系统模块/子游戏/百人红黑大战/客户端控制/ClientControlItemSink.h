#pragma once
#include "Stdafx.h"
#include "../游戏客户端/ClientControl.h"


// CClientControlItemSinkDlg 对话框

class AFX_EXT_CLASS CClientControlItemSinkDlg : public IClientControlDlg
{
	DECLARE_DYNAMIC(CClientControlItemSinkDlg)

//库存控制
protected:
	LONGLONG						m_lStorageStart;				//起始库存
	LONGLONG						m_lStorageDeduct;				//库存衰减
	LONGLONG						m_lStorageCurrent;				//当前库存
	LONGLONG						m_lStorageMax1;					//库存上限1
	LONGLONG						m_lStorageMul1;					//系统输分概率1
	LONGLONG						m_lStorageMax2;					//库存上限2
	LONGLONG						m_lStorageMul2;					//系统输分概率2

	//区域控制
protected:
	BYTE m_cbWinArea;				//赢牌区域
	BYTE m_cbExcuteTimes;			//执行次数
	
	//玩家下注
protected:
	CListCtrl						m_listUserBet;					//列表控件
	CListCtrl						m_listUserBetAll;				//列表控件
	LONGLONG						m_lQueryGameID;					//查询ID

public:
	CClientControlItemSinkDlg(CWnd* pParent = NULL);   // 标准构造函数
	virtual ~CClientControlItemSinkDlg();

// 对话框数据
	enum { IDD = IDD_DIALOG_ADMIN };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV 支持

	DECLARE_MESSAGE_MAP()

public:
	//申请结果
	virtual bool __cdecl ReqResult(const void * pBuffer);
	//更新库存
	virtual bool __cdecl UpdateStorage(const void * pBuffer);
	//更新下注
	virtual void __cdecl UpdateUserBet(bool bReSet);
	//更新控件
	virtual void __cdecl UpdateControl();

	virtual BOOL OnInitDialog();
	afx_msg void  OnReSet();
	afx_msg void  OnRefresh();
	afx_msg void  OnExcute();

public:
	afx_msg void OnBnClickedBtnUpdateStorage();
	void RequestUpdateStorage();
	afx_msg void OnBnClickedBtnUserBetQuery();
	afx_msg void OnBnClickedBtnUserBetAll();
	afx_msg void OnEnSetfocusEditUserId();
	afx_msg void OnBnClickedRadioRb();
	afx_msg HBRUSH OnCtlColor(CDC* pDC, CWnd* pWnd, UINT nCtlColor);
};

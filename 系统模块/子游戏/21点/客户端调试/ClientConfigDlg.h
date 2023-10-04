#ifndef GAME_DLG_CUSTOM_RULE_HEAD_FILE
#define GAME_DLG_CUSTOM_RULE_HEAD_FILE

#pragma once
#include "Stdafx.h"
#include "resource.h"
#include "DialogDexter.h"
#include "..\消息定义\CMD_Game.h"

#pragma warning(disable : 4244)
#pragma warning(disable : 4800)

#define CUSTOM_GENERAL			0
#define CUSTOM_CONTROL			1
#define CUSTOM_ADVANCED			2

#define MAX_CUSTOM				3
#define MAX_EXECUTE_TIMES		15

// 调试对话框
class CClientConfigDlg : public CDialog, public IClientDebug
{
    // 对话框数据
    enum { IDD = IDD_DIALOG_MAIN };

    // 类变量
public:
    CWnd 									*m_pParentWnd;					// 父窗口
    IClientDebugCallback 					*m_pIClientDebugCallback;		// 回调接口

    // 组件信息
public:
    CDialogDexter 							*m_DialogCustom[MAX_CUSTOM];
    CDialogDexter                           *m_DialogSetting;

    // 类函数
public:
    // 构造函数
    CClientConfigDlg(CWnd *pParent = NULL);
    // 析构函数
    virtual ~CClientConfigDlg();
    // 窗口销毁
    void OnDestroy();

    // 窗口函数
public:
    // 控件绑定
    virtual void DoDataExchange(CDataExchange *pDX);
    // 调试信息
    bool SendDebugMessage(UINT nMessageID, void *pData = NULL, UINT nSize = 0);
	// 调试信息
	bool SendDebugMessage(UINT nMessageID, WORD wTableID, void *pData = NULL, UINT nSize = 0);

    // 继承函数
public:
    // 释放接口
    virtual void Release();
    // 创建函数
    virtual bool Create(CWnd *pParentWnd, IClientDebugCallback *pIClientDebugCallback);
    // 显示窗口
    virtual bool ShowWindow(bool bShow);
    // 消息函数
    virtual bool OnDebugMessage(WORD nMessageID, WORD wTableID, void *pData, WORD nSize);

    DECLARE_DYNAMIC(CClientConfigDlg)
    DECLARE_MESSAGE_MAP()
   
    // 变换选项
    afx_msg void OnTcnSelchangeTabOptisons(NMHDR *pNMHDR, LRESULT *pResult);
};

//////////////////////////////////////////////////////////////////////////////////
// 调试对话框
class CDialogGeneral : public CDialogDexter
{
	// 资源ID
public:
	enum { IDD = IDD_CUSTOM_GENERAL };

	//配置变量
protected:

    CFont                           m_FontFrame;
    CFont                           m_Font;
  
	// 类函数
public:
	// 构造函数
	CDialogGeneral(int nShowMax = 0, CClientConfigDlg *pParent = NULL);
	// 析构函数
	virtual ~CDialogGeneral();

	// 窗口函数
protected:
	//初始化窗口
	virtual BOOL OnInitDialog();
	// 控件绑定
	virtual void DoDataExchange(CDataExchange *pDX);
    void DDX_DOUBLE(CDataExchange* pDX, int nIDC, DOUBLE &value);
	virtual bool OnDebugMessage(WORD nMessageID, WORD wTableID, void *pBuffer, WORD wDataSize);

public:
	//判断有效数字
	bool IsValidNum(CString strEdit);


	// 继承函数
public:
	DECLARE_MESSAGE_MAP()

	afx_msg void OnBnClickedButtonSetRule();
	afx_msg void OnLvnItemchangedListRoom(NMHDR *pNMHDR, LRESULT *pResult);
	

	void UpdateSysCtrlDesc();
	afx_msg void OnEnChangeEditRoomctrlSysstorage();
	afx_msg void OnEnChangeEditRoomctrlPlayerstorage();
	afx_msg void OnEnChangeEditRoomctrlParameterK();
	void UpdateRoomCtrlDesc(SCORE lCurSysStorage, SCORE lCurPlayerStorage, int nCurParameterK);
    void UpdateUserCtrlDesc(SCORE lCurSysStorage, SCORE lCurPlayerStorage, int nCurParameterK);
    
   
	afx_msg HBRUSH OnCtlColor(CDC *pDC, CWnd *pWnd, UINT nCtlColor);

    afx_msg void OnBnClickedBtnUserBetQuery();
    afx_msg void OnBnClickedBtContinueWin();
    afx_msg void OnBnClickedBtContinueLost();
    afx_msg void OnBnClickedBtContinueCancel();
   
    afx_msg void OnBnClickedButtonChou();
    afx_msg void OnBnClickedBtnSetRoomctrl();
    afx_msg void OnBnClickedButtonCancellRoom();
};


// 调试对话框
class CDialogControl : public CDialogDexter
{
    // 资源ID
public:
    enum { IDD = IDD_CUSTOM_CONTROL };

    //变量
public:
    CFont      m_FontTitle;
    WORD       m_tableID;
    // 类函数
public:
    // 构造函数
    CDialogControl(int nShowMax = 0, CClientConfigDlg *pParent = NULL);
    // 析构函数
    virtual ~CDialogControl();

    // 窗口函数
protected:
    //初始化窗口
    virtual BOOL OnInitDialog();
    // 控件绑定
    virtual void DoDataExchange(CDataExchange *pDX);

    virtual bool OnDebugMessage(WORD nMessageID, WORD wTableID, void *pBuffer, WORD wDataSize);
    //判断有效数字
    bool IsValidNum(CString strEdit);

    void UpdateRoomCtrlDesc(SCORE lCurSysStorage, SCORE lCurPlayerStorage, int nCurParameterK);
    void UpdateUserCtrlDesc(SCORE lCurSysStorage, SCORE lCurPlayerStorage, int nCurParameterK);
    // 继承函数
public:
    DECLARE_MESSAGE_MAP()

    afx_msg void OnBnClickedBtnCancelUser();
   
    afx_msg void OnBnClickedBtnSetUserctrl();
    afx_msg void OnBnClickedBtnDebugExc();
    afx_msg void OnBnClickedBtnDebugCancell();
    afx_msg void OnBnClickedBtnQuary();
   
};

class CDialogAdvanced : public CDialogDexter
{
	// 资源ID
public:
	enum { IDD = IDD_CUSTOM_ADVANCED };

	// 类变量
public:
    CFont      m_FontTitle;
	// 类函数
public:
	// 构造函数
	CDialogAdvanced(int nShowMax = 0, CClientConfigDlg *pParent = NULL);
	// 析构函数
	virtual ~CDialogAdvanced();

	// 窗口函数
protected:
	//初始化窗口
	virtual BOOL OnInitDialog();
	// 控件绑定
	virtual void DoDataExchange(CDataExchange *pDX);
	// 消息函数
	virtual bool OnDebugMessage(WORD nMessageID, WORD wTableID, void *pData, WORD nSize);
    void UpdateList(int nItem, CListCtrl &pListCtrlUser, CMD_S_UserCtrlResult &pUserCtrlResult);
	
	// 继承函数
public:
	DECLARE_MESSAGE_MAP()

	afx_msg void OnBnClickedBtnCancelRoomCtrl();

    afx_msg void OnBnClickedBtnCancelUserctrl();
    afx_msg void OnBnClickedBtnCancelRoomctrl2();
    afx_msg void OnBnClickedBtnCancelUserctrl2();
    afx_msg void OnBnClickedBtnClearDesk();
    afx_msg void OnBnClickedBtnClearDeskall();
};

#endif
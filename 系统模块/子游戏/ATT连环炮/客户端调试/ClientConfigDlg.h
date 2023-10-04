#ifndef GAME_DLG_CUSTOM_RULE_HEAD_FILE
#define GAME_DLG_CUSTOM_RULE_HEAD_FILE

#pragma once
#include "Stdafx.h"
#include "resource.h"
#include "DialogDexter.h"
#include "..\消息定义\CMD_Game.h"
#include <cstdint>
#include <vector>

#pragma warning(disable : 4244)
#pragma warning(disable : 4800)

enum
{
	CUSTOM_CONFIG=0,
	CUSTOM_DEBUG,
	CUSTOM_LOG,
	//CUSTOM_WEIGHT,
	MAX_CUSTOM,
};

// 调试对话框
class CClientConfigDlg : public CDialog, public IClientDebug
{
    // 对话框数据
    enum { IDD = IDD_DIALOG_MAIN };

    // 类变量
public:
    CWnd 									*m_pParentWnd;					// 父窗口
    IClientDebugCallback 					*m_pIClientDebugCallback;		// 回调接口
public:
	GameConfig								m_gameConfig;

    // 组件信息
public:
    CDialogDexter 							*m_DialogCustom[MAX_CUSTOM];
	CDialogDexter							*m_pDialogWeight;

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

public:
	//
	void OnWieightDestory(){ OnShowWeight(); }

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
	//
	afx_msg void OnShowWeight();
};


//////////////////////////////////////////////////////////////////////////////////
// 调试对话框
class CDialogConfig : public CDialogDexter
{
	CClientConfigDlg*	m_pParentDlg;

	// 资源ID
public:
	enum { IDD = IDD_CUSTOM_CONFIG };

	// 类函数
public:
	// 构造函数
	CDialogConfig(int nShowMax = 0, CClientConfigDlg *pParent = NULL);
	// 析构函数
	virtual ~CDialogConfig();

	//
public:
	//
	void InitUI();
	//
	bool OnDebugEvent(void *pData, WORD nSize);

	//界面刷新
protected:
	bool m_bFirstInit[MaxCtrl];
	//
	void RefreshCurSystemStorage(StorageInfo* pInfo);
	void RefreshCurGameReward(GameRewardInfo* pInfo);
	void RefreshCurGameTax(GameTaxInfo* pInfo);
	void RefreshCurGameExtra(GameExtraInfo* pInfo);
	void RefreshCurGameStatistics(StatisticsInfo* pInfo);
	//
	afx_msg void OnSetSystemStorage();
	afx_msg void OnSetGameReward();
	afx_msg void OnSetGameTax();
	afx_msg void OnSetGameExtra();

	// 窗口函数
protected:
	//初始化窗口
	virtual BOOL OnInitDialog();
	// 控件绑定
	virtual void DoDataExchange(CDataExchange *pDX);

	virtual bool OnDebugMessage(WORD nMessageID, WORD wTableID, void *pData, WORD nSize);

	// 继承函数
public:
	DECLARE_DYNAMIC(CDialogConfig)
	DECLARE_MESSAGE_MAP()

public:
	afx_msg HBRUSH OnCtlColor(CDC* pDC, CWnd* pWnd, UINT nCtlColor);
	
};

class CDialogDebug : public CDialogDexter
{
	CClientConfigDlg*	m_pParentDlg;

	// 资源ID
public:
	enum { IDD = IDD_CUSTOM_DEBUG };

	// 类变量
public:

	// 类函数
public:
	// 构造函数
	CDialogDebug(int nShowMax = 0, CClientConfigDlg *pParent = NULL);
	// 析构函数
	virtual ~CDialogDebug();

	//
public:
	//
	void InitUI();
	//
	bool OnDebugEvent(void *pData, WORD nSize);

	//界面刷新
protected:
	bool m_bFirstInit[MaxCtrl];
	//
	void RefreshCurRoomStorage(StorageInfo* pInfo);
	void RefreshRoomTaskList(StorageInfo* pInfo);
	void RefreshCurPlayerStorage(GameDebugInfo* pInfo);
	void RefreshPlayerTaskList(GameDebugInfo* pInfo);
	void RefreshCurGameStatistics(StatisticsInfo* pInfo);
	//
	afx_msg void OnSetRoomStorage();
	afx_msg void OnCancelRoomTask();
	afx_msg void OnSetPlayerStorage();
	afx_msg void OnCancelPlayerTask();

	// 窗口函数
protected:
	//初始化窗口
	virtual BOOL OnInitDialog();
	// 控件绑定
	virtual void DoDataExchange(CDataExchange *pDX);
	// 消息函数
	virtual bool OnDebugMessage(WORD nMessageID, WORD wTableID, void *pData, WORD nSize);

	// 继承函数
public:
	DECLARE_DYNAMIC(CDialogDebug)
	DECLARE_MESSAGE_MAP()

public:
	afx_msg HBRUSH OnCtlColor(CDC* pDC, CWnd* pWnd, UINT nCtlColor);
};


class CDialogLog : public CDialogDexter
{

	// 资源ID
public:
	enum { IDD = IDD_CUSTOM_LOG };

	// 类变量
public:

	// 类函数
public:
	// 构造函数
	CDialogLog(int nShowMax = 0, CClientConfigDlg *pParent = NULL);
	// 析构函数
	virtual ~CDialogLog();

	//
public:
	//
	void InitUI();
	//
	bool OnDebugEvent(void *pData, WORD nSize);

	//界面刷新
public:
	void RefreshSystemTaskList(StorageInfo* pInfo);
	void RefreshRoomTaskList(StorageInfo* pInfo);
	void RefreshPlayerTaskList(GameDebugInfo* pInfo);
	//
	afx_msg void OnCancelRoomTask();
	afx_msg void OnCancelRoomTaskAll();
	afx_msg void OnCancelPlayerTask();
	afx_msg void OnCancelPlayerTaskAll();

	// 窗口函数
protected:
	//初始化窗口
	virtual BOOL OnInitDialog();
	// 控件绑定
	virtual void DoDataExchange(CDataExchange *pDX);
	// 消息函数
	virtual bool OnDebugMessage(WORD nMessageID, WORD wTableID, void *pData, WORD nSize);

	// 继承函数
public:
	DECLARE_DYNAMIC(CDialogLog)
	DECLARE_MESSAGE_MAP()

public:
	afx_msg HBRUSH OnCtlColor(CDC* pDC, CWnd* pWnd, UINT nCtlColor);
};

class CDialogWeight : public CDialogDexter
{
	// 资源ID
public:
	enum { IDD = IDD_CUSTOM_WEIGHT };

	// 类变量
public:

	// 类函数
public:
	// 构造函数
	CDialogWeight(int nShowMax = 0, CClientConfigDlg *pParent = NULL);
	// 析构函数
	virtual ~CDialogWeight();

	//
public:
	bool				m_bInit;
	//
	void RefreshConfig(void *pData, WORD nSize);
	//
	bool OnDebugEvent(void *pData, WORD nSize);

	//
public:
	//
	void InitUI();

	//界面刷新
public:
	//
	void RefreshWeightConfig(WeightConfig* pInfo,int nSize);
	afx_msg void OnWieightConfigSet();

	// 窗口函数
protected:
	//初始化窗口
	virtual BOOL OnInitDialog();
	// 控件绑定
	virtual void DoDataExchange(CDataExchange *pDX);
	// 消息函数
	virtual bool OnDebugMessage(WORD nMessageID, WORD wTableID, void *pData, WORD nSize);

public:
	// 创建函数
	bool Create(CWnd *pParentWnd);
	// 显示窗口
	bool ShowWindow(bool bShow);

	// 继承函数
public:
	DECLARE_DYNAMIC(CDialogWeight)
	DECLARE_MESSAGE_MAP()

public:
	afx_msg HBRUSH OnCtlColor(CDC* pDC, CWnd* pWnd, UINT nCtlColor);
	afx_msg void OnClose();
	afx_msg void OnBtnConfirm();
};

#endif
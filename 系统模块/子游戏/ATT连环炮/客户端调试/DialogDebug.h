#pragma once
#include "Resource.h"
#include "afxwin.h"

#define CUSTOM_SPECIAL			0
#define CUSTOM_GENERAL			1
#define CUSTOM_GIFT				2
#define CUSTOM_DELIVERY			3
#define MAX_CUSTOM				4

class CDialogDexter;
// 调试对话框
class CDialogDebug : public CDialog, public IClientDebug
{
    // 资源ID
public:
    enum { IDD = IDD_DIALOG_MAIN };

    // 类变量
public:
    CWnd 									*m_pParentWnd;					// 父窗口
    IClientDebugCallback 					*m_pIClientDebugCallback;		// 回调接口

    // 组件信息
public:
    CDialogDexter 							*m_DialogCustom[MAX_CUSTOM];


    // 类函数
public:
    // 构造函数
    CDialogDebug(CWnd *pParent = NULL);
    // 析构函数
    virtual ~CDialogDebug();

    // 窗口函数
public:
    // 控件绑定
    virtual void DoDataExchange(CDataExchange *pDX);
    // 调试信息
    bool SendDebugMessage(uint nMessageID, void *pData = NULL, uint nSize = 0);

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

    DECLARE_DYNAMIC(CDialogDebug)
    DECLARE_MESSAGE_MAP()

    // 变换选项
    afx_msg void OnTcnSelchangeTabOptisons(NMHDR *pNMHDR, LRESULT *pResult);
    afx_msg void OnBnClickedButtonDefault();
    afx_msg void OnBnClickedButtonRefreshRule();
    afx_msg void OnBnClickedButtonModifyRule();
};

// 窗口类
class CDialogDexter : public CDialog
{
public:
    CDialogDebug				*m_pParentWnd;						// 消息窗口

    // 滑动变量
public:
    bool						m_bShowScroll;						// 显示滚动
    int							m_nShowMax;							// 最大显示
    int							m_nScrollMax;						// 最大位置
    int							m_nScrollPos;						// 滑动位置

    // 类函数
public:
    // 构造函数
    CDialogDexter(UINT nIDTemplate, int nShowMax, CDialogDebug *pParentWnd = NULL);
    // 析构函数
    ~CDialogDexter();

    // 实现函数
public:
    //初始化窗口
    virtual BOOL OnInitDialog();
    // 滑动消息
    afx_msg void OnVScroll(UINT nSBCode, UINT nPos, CScrollBar *pScrollBar);
    // 鼠标滑轮
    afx_msg BOOL OnMouseWheel(UINT nFlags, short zDelta, CPoint pt);
    // 窗口变化
    afx_msg void OnSize(UINT nType, int cx, int cy);
    // 消息函数
    virtual bool OnDebugMessage(WORD nMessageID, WORD wTableID, void *pData, WORD nSize) = NULL;
    // 调试信息
    virtual bool SendDebugMessage(uint nMessageID, void *pData = NULL, uint nSize = 0);

    DECLARE_MESSAGE_MAP()
};

// 调试对话框
class CDialogSpecial : public CDialogDexter
{
    // 资源ID
public:
    enum { IDD = IDD_CUSTOM_SPECIAL };

    // 类变量
public:

    // 组件信息
public:
    CEdit										m_EditTable;					// 桌子
    CComboBox									m_ComboGiftType;				// 修改类型

    // 类函数
public:
    // 构造函数
    CDialogSpecial(int nShowMax = 0, CDialogDebug *pParent = NULL);
    // 析构函数
    virtual ~CDialogSpecial();

    // 窗口函数
protected:
    //初始化窗口
    virtual BOOL OnInitDialog();
    // 控件绑定
    virtual void DoDataExchange(CDataExchange *pDX);
    //礼物索引
    int GetKindRewardIndex(CString strKindRewardName);

    // 继承函数
public:
    // 消息函数
    virtual bool OnDebugMessage(WORD nMessageID, WORD wTableID, void *pData, WORD nSize);

    DECLARE_DYNAMIC(CDialogSpecial)
    DECLARE_MESSAGE_MAP()

    afx_msg void OnBnClickedBtnRefreshStock();
    afx_msg void OnBnClickedBtnModifyStock();
    afx_msg void OnBnClickedBtnGlod();
    afx_msg void OnBnClickedBtnGift();
    afx_msg void OnCbnSelchangeComboGiftType();
    afx_msg void OnBnClickedBtnQueryId();
    afx_msg void OnBnClickedBtnShard();
    afx_msg void OnBnClickedBtnGiftOpenClose();
};

// 调试对话框
class CDialogGeneral : public CDialogDexter
{
    // 资源ID
public:
    enum { IDD = IDD_CUSTOM_GENERAL };

    // 类变量
public:

    // 类函数
public:
    // 构造函数
    CDialogGeneral(int nShowMax = 0, CDialogDebug *pParent = NULL);
    // 析构函数
    virtual ~CDialogGeneral();

    // 窗口函数
protected:
    //初始化窗口
    virtual BOOL OnInitDialog();
    // 控件绑定
    virtual void DoDataExchange(CDataExchange *pDX);

    // 继承函数
public:
    // 消息函数
    virtual bool OnDebugMessage(WORD nMessageID, WORD wTableID, void *pData, WORD nSize);

    DECLARE_DYNAMIC(CDialogGeneral)
    DECLARE_MESSAGE_MAP()
};


// 调试对话框
class CDialogGift : public CDialogDexter
{
    // 资源ID
public:
    enum { IDD = IDD_CUSTOM_GIFT };

    // 类变量
public:

    // 类函数
public:
    // 构造函数
    CDialogGift(int nShowMax = 0, CDialogDebug *pParent = NULL);
    // 析构函数
    virtual ~CDialogGift();

    // 窗口函数
protected:
    //初始化窗口
    virtual BOOL OnInitDialog();
    // 控件绑定
    virtual void DoDataExchange(CDataExchange *pDX);

    // 继承函数
public:
    // 消息函数
    virtual bool OnDebugMessage(WORD nMessageID, WORD wTableID, void *pData, WORD nSize);

    DECLARE_DYNAMIC(CDialogGift)
    DECLARE_MESSAGE_MAP()

};

// 调试对话框
class CDialogDelivery : public CDialogDexter
{
    // 资源ID
public:
    enum { IDD = IDD_CUSTOM_GIFT };

    // 类变量
public:

    // 类函数
public:
    // 构造函数
    CDialogDelivery(int nShowMax = 0, CDialogDebug *pParent = NULL);
    // 析构函数
    virtual ~CDialogDelivery();

    // 窗口函数
protected:
    //初始化窗口
    virtual BOOL OnInitDialog();
    // 控件绑定
    virtual void DoDataExchange(CDataExchange *pDX);

    // 继承函数
public:
    // 消息函数
    virtual bool OnDebugMessage(WORD nMessageID, WORD wTableID, void *pData, WORD nSize);

    DECLARE_DYNAMIC(CDialogDelivery)
    DECLARE_MESSAGE_MAP()

};


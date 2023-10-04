#pragma once
#include "Stdafx.h"
#include "ClientDebug.h"
#include "DialogDexter.h"

#define CUSTOM_GENERAL			0
#define CUSTOM_ADVANCED			1
#define MAX_CUSTOM				2

// 调试对话框
class CClientDebugItemSinkDlg : public CDialog, public IClientDebug
{
	// 对话框数据
	enum { IDD = IDD_DIALOG_MAIN };

	// 类变量
public:
	//系统调试
	DWORD									m_dwSysDebugIndex;						// 系统调试索引
	CTime									m_tStartDebugTime;						// 服务器启动时间
	bool									m_bSystemStorageEnd;					// 系统库存截止	
	CTime									m_tResetSystemStorage;					// 库存重置时间
	SCOREEX									m_dInitSystemStorage;					// 初始系统库存
	SCOREEX									m_dSystemStorage;						// 系统库存
	SCOREEX									m_dInitUserStorage;						// 初始玩家库存
	SCOREEX									m_dUserStorage;							// 玩家库存
	int										m_nInitParameterK;						// 初始参数K(百分比)
	int										m_nUpdateStorageCount;					// 库存重置次数
	SCOREEX									m_lEndStorageScore;						// 系统系统库存截止
	SCOREEX									m_dTotalSystemStorage;					// 系统系统输赢总数
	SCOREEX									m_dTotalUserStorage;					// 系统玩家输赢总数


	//房间调试
	DWORD									m_dwRoomDebugIndex;						// 房间调试索引
	SCOREEX									m_dRoomInitSystemStorage;				// 房间初始系统库存
	SCOREEX									m_dRoomInitUserStorage;					// 房间初始玩家库存
	int										m_nRoomParameterK;						// 房间初始参数K(百分比)
	SCOREEX									m_dRoomEndStorageScore;					// 房间系统库存截止
	SCOREEX									m_dRoomTotalSystemStorage;				// 房间系统输赢总数
	SCOREEX									m_dRoomTotalUserStorage;				// 房间玩家输赢总数

	//个人调试
	DWORD									m_dwUserDebugCount;						// 玩家调试数量

	DWORD									m_dwUserDebugIndex;						// 玩家调试索引
	DWORD									m_dwGameID;								// 调试玩家ID
	SCOREEX									m_dUserInitSystemStorage;				// 玩家初始系统库存
	SCOREEX									m_dUserInitUserStorage;					// 玩家初始玩家库存
	int										m_nUserParameterK;						// 玩家初始参数K(百分比)
	SCOREEX									m_dUserEndStorageScore;					// 玩家系统库存截止
	SCOREEX									m_dUserTotalSystemStorage;				// 玩家系统输赢总数
	SCOREEX									m_dUserTotalUserStorage;				// 玩家玩家输赢总数

	bool									m_bInit;								// 初始化	
	SCOREEX									m_dStorageCurrent;						// 实时输赢
	CListHistoryRoomUserInfo				m_listHistoryUserDebugInfo;				// 玩家调试记录
	CListHistoryRoomDebugInfo				m_listHistoryRoomDebugInfo;				// 房间调试记录
	CListHistoryRoomDebugInfo				m_listHistorySysDebugInfo;				// 系统调试记录

	CWnd 									*m_pParentWnd;							// 父窗口
	IClientDebugCallback 					*m_pIClientDebugCallback;				// 回调接口

	// 组件信息
public:
	CDialogDexter 							*m_DialogCustom[MAX_CUSTOM];

	// 类函数
public:
	// 构造函数
	CClientDebugItemSinkDlg(CWnd *pParent = NULL);
	// 析构函数
	virtual ~CClientDebugItemSinkDlg();
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

	DECLARE_DYNAMIC(CClientDebugItemSinkDlg)
	DECLARE_MESSAGE_MAP()

	// 变换选项
	afx_msg void OnTcnSelchangeTabOptisons(NMHDR *pNMHDR, LRESULT *pResult);

	//更新玩家调试
	virtual void DeleteUserDebugInfo(DWORD dwDebugIndex);
	//更新玩家调试
	void UpdateUserDebugInfo(tagHistoryRoomUserInfo *pHistoryRoomUserInfo);
	//更新玩家调试
	void UpdateUserDebugInfo(DWORD dwDebugIndex, SCOREEX dSystemStorage, SCOREEX dUserStorage, int nDebugStatus, LONGLONG lUpdateTime);

	//更新房间调试
	virtual void DeleteRoomDebugInfo(DWORD dwDebugIndex);
	//更新房间调试
	void UpdateRoomDebugInfo(tagHistoryRoomDebugInfo *pHistoryRoomDebugInfo);
	//更新房间调试
	void UpdateRoomDebugInfo(DWORD dwDebugIndex, SCOREEX dSystemStorage, SCOREEX dUserStorage, int nDebugStatus, LONGLONG lUpdateTime);

	//更新系统调试
	void UpdateSysDebugInfo(tagHistoryRoomDebugInfo *pHistoryRoomDebugInfo);
	//更新系统调试
	void UpdateSysDebugInfo(DWORD dwDebugIndex, SCOREEX dSystemStorage, SCOREEX dUserStorage, int nDebugStatus, LONGLONG lUpdateTime);

	//更新其它信息
	virtual void UpdateOtherInfo();

public:
	//取得玩家调试
	POSITION GetUserDebugInfo(DWORD dwDebugIndex, tagHistoryRoomUserInfo &HistoryRoomUserInfo);
	//取得房间调试
	POSITION GetRoomDebugInfo(DWORD dwDebugIndex, tagHistoryRoomDebugInfo &HistoryRoomDebugInfo);
	//取得系统调试
	POSITION GetSysDebugInfo(DWORD dwDebugIndex, tagHistoryRoomDebugInfo &HistoryRoomDebugInfo);
};


class AFX_EXT_CLASS CDialogGeneral : public CDialogDexter
{
	DECLARE_DYNAMIC(CDialogGeneral)

public:
	CDialogGeneral(CClientDebugItemSinkDlg *pParent = NULL);
	virtual ~CDialogGeneral();

	enum { IDD = IDD_CUSTOM_GENERAL };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV 支持

	DECLARE_MESSAGE_MAP()

	// 继承函数
public:
	// 消息函数
	virtual bool OnDebugMessage(WORD nMessageID, WORD wTableID, void *pData, WORD nSize);

public:
	//初始化对话框
	virtual BOOL OnInitDialog();
	//消息预处理
	virtual BOOL PreTranslateMessage(MSG *pMsg);

//映射函数
public:
	afx_msg HBRUSH OnCtlColor(CDC *pDC, CWnd *pWnd, UINT nCtlColor);
	afx_msg void OnTimer(UINT_PTR nIDEvent);

	//更新玩家调试
	virtual void DeleteUserDebugInfo(DWORD dwDebugIndex);
	//更新玩家调试
	virtual void UpdateUserDebugInfo(tagHistoryRoomUserInfo *pHistoryRoomUserInfo);
	//更新玩家调试
	virtual void UpdateUserDebugInfo(DWORD dwDebugIndex, SCOREEX dSystemStorage, SCOREEX dUserStorage, int nDebugStatus, LONGLONG lUpdateTime);

	//更新房间调试
	virtual void DeleteRoomDebugInfo(DWORD dwDebugIndex);
	//更新房间调试
	virtual void UpdateRoomDebugInfo(tagHistoryRoomDebugInfo *pHistoryRoomDebugInfo);
	//更新房间调试
	virtual void UpdateRoomDebugInfo(DWORD dwDebugIndex, SCOREEX dSystemStorage, SCOREEX dUserStorage, int nDebugStatus, LONGLONG lUpdateTime);

	//更新系统调试
	virtual void UpdateSysDebugInfo(tagHistoryRoomDebugInfo *pHistoryRoomDebugInfo);
	//更新系统调试
	virtual void UpdateSysDebugInfo(DWORD dwDebugIndex, SCOREEX dSystemStorage, SCOREEX dUserStorage, int nDebugStatus, LONGLONG lUpdateTime);

	//更新其它信息
	virtual void UpdateOtherInfo();


protected:
	WORD					m_wTableID;								//当前桌子ID
	TCHAR					m_szServerName[LEN_SERVER];				//当前房间名称
	CMap<DWORD, DWORD, tagRoomUserInfo, tagRoomUserInfo>	m_RoomUserInfoMap;			//房间用户信息映射
public:
	//刷新库存
	afx_msg void OnBnClickedButtonRefreshrule();
	//系统库存变化
	afx_msg void OnEnChangeEditSystemStorage();
	//玩家库存变化
	afx_msg void OnEnChangeEditUserStorage();
	//调节系数变化
	afx_msg void OnEnChangeEditParameterK();
	//设置当前库存
	afx_msg void OnBnClickedButtonCurStorage();
	//设置当前库存
	afx_msg void OnBnClickedButtonCurStorageTwo();


	//系统库存变化
	afx_msg void OnEnChangeEditRoomSystemStorage();
	//玩家库存变化
	afx_msg void OnEnChangeEditRoomUserStorage();
	//调节系数变化
	afx_msg void OnEnChangeEditRoomParameterK();
	//设置库存
	afx_msg void OnBnClickedBtnSetRoomStorage();
	//设置库存
	afx_msg void OnBnClickedBtnSetRoomStorageTwo();
	//取消房间库存
	afx_msg void OnBnClickedBtnCancelRoomStorage();
	//单击房间列表
	afx_msg void OnLvnItemchangedListRoom(NMHDR *pNMHDR, LRESULT *pResult);

	//系统库存变化
	afx_msg void OnEnChangeEditUserSystemStorage();
	//玩家库存变化
	afx_msg void OnEnChangeEditUserUserStorage();
	//调节系数变化
	afx_msg void OnEnChangeEditUserParameterK();
	//设置玩家库存
	afx_msg void OnBnClickedBtnSetUserStorage();
	//设置玩家库存
	afx_msg void OnBnClickedBtnSetUserStorageTwo();
	//取消玩家库存
	afx_msg void OnBnClickedBtnCancelUserStorage();
	//单击玩家列表
	afx_msg void OnLvnItemchangedListUser(NMHDR *pNMHDR, LRESULT *pResult);
	afx_msg void OnBnClickedButtonCurCaiJing();
};

class CDialogAdvanced : public CDialogDexter
{
	// 资源ID
public:
	enum { IDD = IDD_CUSTOM_ADVANCED };

	// 类变量
public:

	// 类函数
public:
	// 构造函数
	CDialogAdvanced(CClientDebugItemSinkDlg *pParent = NULL);
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

	//更新玩家调试
	virtual void DeleteUserDebugInfo(DWORD dwDebugIndex);
	//更新玩家调试
	virtual void UpdateUserDebugInfo(tagHistoryRoomUserInfo *pHistoryRoomUserInfo);
	//更新玩家调试
	virtual void UpdateUserDebugInfo(DWORD dwDebugIndex, SCOREEX dSystemStorage, SCOREEX dUserStorage, int nDebugStatus, LONGLONG lUpdateTime);

	//更新房间调试
	virtual void DeleteRoomDebugInfo(DWORD dwDebugIndex);
	//更新房间调试
	virtual void UpdateRoomDebugInfo(tagHistoryRoomDebugInfo *pHistoryRoomDebugInfo);
	//更新房间调试
	virtual void UpdateRoomDebugInfo(DWORD dwDebugIndex, SCOREEX dSystemStorage, SCOREEX dUserStorage, int nDebugStatus, LONGLONG lUpdateTime);

	//更新系统调试
	virtual void UpdateSysDebugInfo(tagHistoryRoomDebugInfo *pHistoryRoomDebugInfo);
	//更新系统调试
	virtual void UpdateSysDebugInfo(DWORD dwDebugIndex, SCOREEX dSystemStorage, SCOREEX dUserStorage, int nDebugStatus, LONGLONG lUpdateTime);

	//更新其它信息
	virtual void UpdateOtherInfo();

	//更新系统总收益
	void UpdateAllDebugInfo();

	// 继承函数
public:
	DECLARE_DYNAMIC(CDialogAdvanced)
	DECLARE_MESSAGE_MAP()
	afx_msg void OnBnClickedButtonRoomCancel();
	afx_msg void OnBnClickedButtonUserCancel();
};
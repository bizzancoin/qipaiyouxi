#pragma once
#include "StringMessage.h"
//屏幕限制
#define LESS_SCREEN_CY				740									//最小高度
#define LESS_SCREEN_CX				1024								//最小宽度

class CGameFrameWindow : public CFrameWnd, public IGameFrameWnd, public IUserEventSink
{
	//组件接口
protected:
	IClientKernel *					m_pIClientKernel;					//内核接口
	IGameFrameView *				m_pIGameFrameView;					//视图接口
	IGameFrameService *				m_pIGameFrameService;				//框架服务


	//功能控件
public:
	CGameFrameControl				m_GameFrameControl;					//控制框架
//	CStringMessage					m_StringMessage;					//消息控制
private:
	CSize							m_CurWindowSize;

public:
	CGameFrameWindow(void);
	~CGameFrameWindow(void);

	//基础接口
public:
	//释放对象
	virtual VOID Release() { delete this; }
	//接口查询
	virtual VOID * QueryInterface(REFGUID Guid, DWORD dwQueryVer);

	//重载函数
protected:
	//消息解释
	virtual BOOL PreTranslateMessage(MSG * pMsg);
	//命令函数
	virtual BOOL OnCommand(WPARAM wParam, LPARAM lParam);

	//界面控制
protected:
	//调整控件
	VOID RectifyControl(INT nWidth, INT nHeight);
	//重设大小
	void ReSetDlgSize(int cx,int cy);

	//窗口控制
public:
	//游戏规则
	virtual bool ShowGameRule();
	//最大窗口
	virtual bool MaxSizeWindow();
	//还原窗口
	virtual bool RestoreWindow();

	//控制接口
public:
	//声音控制
	virtual bool AllowGameSound(bool bAllowSound);
	//旁观控制
	virtual bool AllowGameLookon(DWORD dwUserID, bool bAllowLookon);
	//控制接口
	virtual bool OnGameOptionChange();

	//用户事件
public:
	//用户进入
	virtual VOID OnEventUserEnter(IClientUserItem * pIClientUserItem, bool bLookonUser);
	//用户离开
	virtual VOID OnEventUserLeave(IClientUserItem * pIClientUserItem, bool bLookonUser);
	//用户积分
	virtual VOID OnEventUserScore(IClientUserItem * pIClientUserItem, bool bLookonUser);
	//用户状态
	virtual VOID OnEventUserStatus(IClientUserItem * pIClientUserItem, bool bLookonUser);
	//用户头像
	virtual VOID OnEventCustomFace(IClientUserItem * pIClientUserItem, bool bLookonUser);
	//用户属性
	virtual VOID OnEventUserAttrib(IClientUserItem * pIClientUserItem, bool bLookonUser);


	//消息函数
protected:
	//绘画背景
	BOOL OnEraseBkgnd(CDC * pDC);
	//位置消息
	VOID OnSize(UINT nType, INT cx, INT cy);
	//创建消息
	INT OnCreate(LPCREATESTRUCT lpCreateStruct);
	//鼠标消息
	VOID OnLButtonDown(UINT nFlags, CPoint Point);
	//鼠标消息
	VOID OnLButtonDblClk(UINT nFlags, CPoint Point);
	//改变消息
	VOID OnSettingChange(UINT uFlags, LPCTSTR lpszSection);
	
	afx_msg UINT OnNcHitTest(CPoint point);

	//自定消息
protected:
	//标题消息
	LRESULT	OnSetTextMesage(WPARAM wParam, LPARAM lParam);

	DECLARE_MESSAGE_MAP()
};

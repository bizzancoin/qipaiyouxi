#include "StdAfx.h"
#include "Resource.h"
#include ".\gameframewindow.h"
#include "gameclientview.h"

//////////////////////////////////////////////////////////////////////////////////

//控制按钮
#define IDC_MIN						226									//最小按钮
#define IDC_MAX						229									//最大按钮
#define IDC_SKIN					102									//界面按钮
#define IDC_CLOSE					227									//关闭按钮

#define IDC_RESTORE					230								    //恢复按钮

//控件标识
#define IDC_SKIN_SPLITTER			200									//拆分控件
#define IDC_GAME_CLIENT_VIEW		201									//视图标识

//屏幕位置
#define BORAD_SIZE					6									//边框大小
#define CAPTION_SIZE				32									//标题大小

//控件大小
#define SPLITTER_CX					0									//拆分宽度
#define CAPTION_SIZE				32									//标题大小




//////////////////////////////////////////////////////////////////////////////////


BEGIN_MESSAGE_MAP(CGameFrameWindow, CFrameWnd)
	//系统消息
	ON_WM_SIZE()
	ON_WM_CREATE()
	ON_WM_ERASEBKGND()
	ON_WM_LBUTTONDOWN()
	ON_WM_LBUTTONDBLCLK()
	ON_WM_SETTINGCHANGE()
	ON_WM_NCHITTEST()

	//自定消息
	ON_MESSAGE(WM_SETTEXT,OnSetTextMesage)
END_MESSAGE_MAP()


CGameFrameWindow::CGameFrameWindow(void)
{
	//组件接口
	m_pIClientKernel=NULL;
	m_pIGameFrameView=NULL;
	m_pIGameFrameService=NULL;

	//注册组件
	CGlobalUnits * pGlobalUnits=CGlobalUnits::GetInstance();
	pGlobalUnits->RegisterGlobalModule(MODULE_GAME_FRAME_WND,QUERY_ME_INTERFACE(IUnknownEx));
	
	//int   cx   =   GetSystemMetrics(   SM_CXSCREEN   );   
	//int   cy   =   GetSystemMetrics(   SM_CYSCREEN   );
	//m_CurWindowSize.SetSize(cx,cy);
	m_CurWindowSize.SetSize(LESS_SCREEN_CX,LESS_SCREEN_CY);
}

CGameFrameWindow::~CGameFrameWindow(void)
{
}

//接口查询
VOID * CGameFrameWindow::QueryInterface(REFGUID Guid, DWORD dwQueryVer)
{
	QUERYINTERFACE(IUserEventSink,Guid,dwQueryVer);
	QUERYINTERFACE(IGameFrameWnd,Guid,dwQueryVer);
	QUERYINTERFACE_IUNKNOWNEX(IGameFrameWnd,Guid,dwQueryVer);
	return NULL;
}

//消息解释
BOOL CGameFrameWindow::PreTranslateMessage(MSG * pMsg)
{
	return __super::PreTranslateMessage(pMsg);
}

//命令函数
BOOL CGameFrameWindow::OnCommand(WPARAM wParam, LPARAM lParam)
{
	//变量定义
	UINT nCommandID=LOWORD(wParam);

	//功能按钮
	switch (nCommandID)
	{
	case IDC_MIN:				//最小按钮
		{			
			if (IsIconic())	
				ShowWindow(SW_RESTORE);
			else
				ShowWindow(SW_MINIMIZE);
			
			return TRUE;
		}
	case IDC_CLOSE:				//关闭按钮
		{
			PostMessage(WM_CLOSE,0,0);
			return TRUE;
		}
	case IDC_MAX:				//最大化按钮
		{
			int   cx   =   GetSystemMetrics(   SM_CXSCREEN   );   
			int   cy   =   GetSystemMetrics(   SM_CYSCREEN   );
			
			// 获取任务栏高度 
			CRect rcTaskbar; 
			SystemParametersInfo(SPI_GETWORKAREA, 0, &rcTaskbar, 0); 		
			int nTaskbarHeight = GetSystemMetrics(SM_CYSCREEN) - rcTaskbar.Height(); 

			ReSetDlgSize(cx,cy - nTaskbarHeight);		
			return TRUE;
		}
	case IDC_RESTORE:				//恢复按钮
		{
			ReSetDlgSize(LESS_SCREEN_CX,LESS_SCREEN_CY);		
			return TRUE;
		}

	}

	return __super::OnCommand(wParam,lParam);
}

//调整控件
VOID CGameFrameWindow::RectifyControl(INT nWidth, INT nHeight)
{
	//状态判断
	if ((nWidth==0)||(nHeight==0)) return;

	//移动准备
	HDWP hDwp=BeginDeferWindowPos(32);
	UINT uFlags=SWP_NOACTIVATE|SWP_NOCOPYBITS|SWP_NOZORDER;


	//查询游戏
	CGlobalUnits * pGlobalUnits=CGlobalUnits::GetInstance();
	IGameFrameView * pIGameFrameView=(IGameFrameView *)pGlobalUnits->QueryGlobalModule(MODULE_GAME_FRAME_VIEW,IID_IGameFrameView,VER_IGameFrameView);

	//游戏视图
	if (pIGameFrameView!=NULL)
	{
		CRect rcArce;
		CSize SizeRestrict=m_CurWindowSize;
		SystemParametersInfo(SPI_GETWORKAREA,0,&rcArce,SPIF_SENDCHANGE);
		//SizeRestrict.cx=__min(rcArce.Width(),SizeRestrict.cx);
		//SizeRestrict.cy=__min(rcArce.Height(),SizeRestrict.cy);
		DeferWindowPos(hDwp, pIGameFrameView->GetGameViewHwnd(), NULL, 0, 0, SizeRestrict.cx, SizeRestrict.cy, uFlags);
	}

	DeferWindowPos(hDwp, m_GameFrameControl, NULL, 0, 0, 0, 0, uFlags);

	//移动结束
	EndDeferWindowPos(hDwp);

	return;
}

//用户进入
VOID CGameFrameWindow::OnEventUserEnter(IClientUserItem * pIClientUserItem, bool bLookonUser)
{
	//变量定义
	ASSERT(CGlobalUnits::GetInstance()!=NULL);
	CGlobalUnits * pGlobalUnits=CGlobalUnits::GetInstance();

	//提示信息
	if (pGlobalUnits->m_bNotifyUserInOut==true)//&&(GetServiceStatus()==ServiceStatus_Service))
	{
		//CDialogChat::m_ChatMessage.InsertUserEnter(pIClientUserItem->GetNickName());
	}

	return;
}

//用户离开
VOID CGameFrameWindow::OnEventUserLeave(IClientUserItem * pIClientUserItem, bool bLookonUser)
{
	return;
}

//用户积分
VOID CGameFrameWindow::OnEventUserScore(IClientUserItem * pIClientUserItem, bool bLookonUser)
{

	return;
}

//用户状态
VOID CGameFrameWindow::OnEventUserStatus(IClientUserItem * pIClientUserItem, bool bLookonUser)
{
	return;
}

//用户头像
VOID CGameFrameWindow::OnEventCustomFace(IClientUserItem * pIClientUserItem, bool bLookonUser)
{
	return;

}

//用户属性
VOID CGameFrameWindow::OnEventUserAttrib(IClientUserItem * pIClientUserItem, bool bLookonUser)
{

}

//绘画背景
BOOL CGameFrameWindow::OnEraseBkgnd(CDC * pDC)
{
	return TRUE;
}

//位置消息
VOID CGameFrameWindow::OnSize(UINT nType, INT cx, INT cy) 
{
	__super::OnSize(nType, cx, cy);

	//调整控件
	RectifyControl(cx,cy);

	return;
}


//建立消息
INT CGameFrameWindow::OnCreate(LPCREATESTRUCT lpCreateStruct)
{
	if (__super::OnCreate(lpCreateStruct)==-1) return -1;

	//设置窗口
	ModifyStyle(WS_CAPTION,0,0);
	ModifyStyleEx(WS_BORDER|WS_EX_CLIENTEDGE|WS_EX_WINDOWEDGE,0,0);

	//变量定义
	ASSERT(CGlobalUnits::GetInstance()!=NULL);
	CGlobalUnits * pGlobalUnits=CGlobalUnits::GetInstance();

	//查询接口
	m_pIClientKernel=(IClientKernel *)pGlobalUnits->QueryGlobalModule(MODULE_CLIENT_KERNEL,IID_IClientKernel,VER_IClientKernel);
	m_pIGameFrameView=(IGameFrameView *)pGlobalUnits->QueryGlobalModule(MODULE_GAME_FRAME_VIEW,IID_IGameFrameView,VER_IGameFrameView);
	m_pIGameFrameService=(IGameFrameService *)pGlobalUnits->QueryGlobalModule(MODULE_GAME_FRAME_SERVICE,IID_IGameFrameService,VER_IGameFrameService);

	//用户接口
	IUserEventSink * pIUserEventSink=QUERY_ME_INTERFACE(IUserEventSink);
	if (pIUserEventSink!=NULL) m_pIClientKernel->SetUserEventSink(pIUserEventSink);

	//控制窗口
	AfxSetResourceHandle(GetModuleHandle(GAME_FRAME_DLL_NAME));
	m_GameFrameControl.Create(8011,this);
	AfxSetResourceHandle(GetModuleHandle(NULL));

	//聊天接口
//	m_pIClientKernel->SetStringMessage(QUERY_OBJECT_INTERFACE(m_StringMessage,IUnknownEx));
	
	//窗口位置
	CRect rcArce;
	SystemParametersInfo(SPI_GETWORKAREA,0,&rcArce,SPIF_SENDCHANGE);

	//读取位置
	CSize SizeRestrict=m_CurWindowSize;
	//正常位置
	CRect rcNormalSize;			

	//位置调整
	//SizeRestrict.cx=__min(rcArce.Width(),SizeRestrict.cx);
	//SizeRestrict.cy=__min(rcArce.Height(),SizeRestrict.cy);

	//移动窗口
	rcNormalSize.top=(rcArce.Height()-SizeRestrict.cy)/2;
	rcNormalSize.left=(rcArce.Width()-SizeRestrict.cx)/2;
	rcNormalSize.right=rcNormalSize.left+SizeRestrict.cx;
	rcNormalSize.bottom=rcNormalSize.top+SizeRestrict.cy;
	SetWindowPos(NULL,rcNormalSize.left,rcNormalSize.top,rcNormalSize.Width(),rcNormalSize.Height(),SWP_NOZORDER);

	//创建视图
	ASSERT(m_pIGameFrameView!=NULL);
	if (m_pIGameFrameView!=NULL) m_pIGameFrameView->CreateGameViewWnd(this,IDC_GAME_CLIENT_VIEW);

	return 0L;
}

//鼠标消息
VOID CGameFrameWindow::OnLButtonDown(UINT nFlags, CPoint Point)
{
		
	__super::OnLButtonDown(nFlags,Point);

	//AfxMessageBox(TEXT("CGameFrameWindow::OnLButtonDown"));
	if(Point.y <=30)
		PostMessage(WM_NCLBUTTONDOWN,HTCAPTION,MAKELPARAM(Point.x,Point.y)); 

	return;
}

//鼠标消息
VOID CGameFrameWindow::OnLButtonDblClk(UINT nFlags, CPoint Point)
{
	return __super::OnLButtonDblClk(nFlags,Point);
}

//设置改变
VOID CGameFrameWindow::OnSettingChange(UINT uFlags, LPCTSTR lpszSection)
{
	// 获取任务栏高度 
	CRect rcTaskbar; 
	SystemParametersInfo(SPI_GETWORKAREA, 0, &rcTaskbar, 0); 		
	int nTaskbarHeight = GetSystemMetrics(SM_CYSCREEN) - rcTaskbar.Height(); 
	int cx = GetSystemMetrics( SM_CXSCREEN );   
	int cy = GetSystemMetrics( SM_CYSCREEN );
	CRect rcClient;
	GetClientRect(&rcClient);
	// 全屏模式
	if(rcClient.Width() == cx ) 
	{
		if(cy - nTaskbarHeight < LESS_SCREEN_CY)
		{
			ReSetDlgSize(cx,LESS_SCREEN_CY);
			return;
		}

		ReSetDlgSize(cx,cy - nTaskbarHeight);
		InvalidateRect(rcClient,TRUE);
		UpdateWindow();
	}
	
	__super::OnSettingChange(uFlags,lpszSection);
	return;
}

//标题消息
LRESULT	CGameFrameWindow::OnSetTextMesage(WPARAM wParam, LPARAM lParam)
{
	//默认调用
	LRESULT lResult=DefWindowProc(WM_SETTEXT,wParam,lParam);
	
	((CGameClientView*)m_pIGameFrameView)->SendMessage(WM_SET_CAPTION,wParam,lParam);
	//更新标题
	Invalidate(TRUE);

	return lResult;
}

//游戏规则
bool CGameFrameWindow::ShowGameRule()
{
	return true;
}

//最大窗口
bool CGameFrameWindow::MaxSizeWindow()
{	
	return true;
}
//还原窗口
bool CGameFrameWindow::RestoreWindow()
{
	return true;
}

//声音控制
bool CGameFrameWindow::AllowGameSound(bool bAllowSound)
{
	return true;
}

//旁观控制
bool CGameFrameWindow::AllowGameLookon(DWORD dwUserID, bool bAllowLookon)
{
	return true;
}

//控制接口
bool CGameFrameWindow::OnGameOptionChange()
{
	return true;
}
//重设大小
void CGameFrameWindow::ReSetDlgSize(int cx,int cy)
{
	m_CurWindowSize.SetSize(cx,cy);
	//窗口位置
	CRect rcArce;
	SystemParametersInfo(SPI_GETWORKAREA,0,&rcArce,SPIF_SENDCHANGE);

	//读取位置
	CSize SizeRestrict=m_CurWindowSize;
	//正常位置
	CRect rcNormalSize;			

	//位置调整
	//SizeRestrict.cx=__min(rcArce.Width(),SizeRestrict.cx);
	//SizeRestrict.cy=__min(rcArce.Height(),SizeRestrict.cy);

	//移动窗口
	rcNormalSize.top=(rcArce.Height()-SizeRestrict.cy)/2;
	rcNormalSize.left=(rcArce.Width()-SizeRestrict.cx)/2;
	rcNormalSize.right=rcNormalSize.left+SizeRestrict.cx;
	rcNormalSize.bottom=rcNormalSize.top+SizeRestrict.cy;


	m_CurWindowSize.SetSize(rcNormalSize.Width(),rcNormalSize.Height());


	SetWindowPos(NULL,rcNormalSize.left,rcNormalSize.top,rcNormalSize.Width(),rcNormalSize.Height(),SWP_NOZORDER);
}

UINT CGameFrameWindow::OnNcHitTest(CPoint point)
{
	CFrameWnd::OnNcHitTest(point);   
	return HTCAPTION;

}

//////////////////////////////////////////////////////////////////////////////////
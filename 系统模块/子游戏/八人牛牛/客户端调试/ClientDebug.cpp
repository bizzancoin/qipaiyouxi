// ClientDebug.cpp : 定义 DLL 的初始化例程。
//

#include "stdafx.h"
#include <afxdllx.h>
#include "ClientDebugItemSink.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#endif

static AFX_EXTENSION_MODULE ClientDebugDLL = { NULL, NULL };

extern "C" int APIENTRY DllMain(HINSTANCE hInstance, DWORD dwReason, LPVOID lpReserved)
{
	// 如果使用 lpReserved，请将此移除
	UNREFERENCED_PARAMETER(lpReserved);

	if (dwReason == DLL_PROCESS_ATTACH)
	{
		TRACE0("ClientDebug.DLL 正在初始化！\n");
		if (!AfxInitExtensionModule(ClientDebugDLL, hInstance))return 0;
		new CDynLinkLibrary(ClientDebugDLL);

	}
	else if (dwReason == DLL_PROCESS_DETACH)
	{
		TRACE0("ClientDebug.DLL 正在终止！\n");
		// 在调用析构函数之前终止该库
		AfxTermExtensionModule(ClientDebugDLL);
	}
	return 1;   // 确定
}

//建立对象函数
extern "C" __declspec(dllexport) void * __cdecl CreateClientDebug(CWnd *pParentWnd )
{
	//建立对象
	CClientDebugItemSinkDlg * pServerDebug = NULL;
	try
	{
		pServerDebug = new CClientDebugItemSinkDlg(/*pParentWnd*/);
		if (pServerDebug == NULL) 
			throw TEXT("创建失败");
		
		return static_cast< IClientDebug * >(pServerDebug);
	}
	catch (...) {}

	//清理对象
	SafeDelete(pServerDebug);
	return NULL;
}
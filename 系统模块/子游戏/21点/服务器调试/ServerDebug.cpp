// ServerDebug.cpp : 定义 DLL 的初始化例程。
//

#include "stdafx.h"
#include <afxdllx.h>
#include "ServerDebugItemSink.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#endif

static AFX_EXTENSION_MODULE ServerDebugDLL = { NULL, NULL };

extern "C" int APIENTRY DllMain(HINSTANCE hInstance, DWORD dwReason, LPVOID lpReserved)
{
	// 如果使用 lpReserved，请将此移除
	UNREFERENCED_PARAMETER(lpReserved);

	if (dwReason == DLL_PROCESS_ATTACH)
	{
		TRACE0("ServerDebug.DLL 正在初始化！\n");
		if (!AfxInitExtensionModule(ServerDebugDLL, hInstance)) return 0;
		new CDynLinkLibrary(ServerDebugDLL);

	}
	else if (dwReason == DLL_PROCESS_DETACH)
	{
		TRACE0("ServerDebug.DLL 正在终止！\n");
		AfxTermExtensionModule(ServerDebugDLL);
	}
	return 1;   // 确定
}

//建立对象函数
extern "C" __declspec(dllexport) void * __cdecl CreateServerDebug()
{
	//建立对象
	CServerDebugItemSink * pServerDebug = NULL;
	try
	{
		pServerDebug = new CServerDebugItemSink();
		if (pServerDebug == NULL) 
			throw TEXT("创建失败");

		return pServerDebug;
	}
	catch (...) {}

	//清理对象
	SafeDelete(pServerDebug);
	return NULL;
}
// ServerDebug.cpp : 定义 DLL 的初始化例程。
//

#include "stdafx.h"
#include <afxdllx.h>
#include "GameVideoItemSink.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#endif

static AFX_EXTENSION_MODULE LandGameVideoDLL = { NULL, NULL };

extern "C" int APIENTRY DllMain(HINSTANCE hInstance, DWORD dwReason, LPVOID lpReserved)
{
	// 如果使用 lpReserved，请将此移除
	UNREFERENCED_PARAMETER(lpReserved);

	if (dwReason == DLL_PROCESS_ATTACH)
	{
		TRACE0("LandGameVideo.DLL 正在初始化！\n");
		if (!AfxInitExtensionModule(LandGameVideoDLL, hInstance)) return 0;
		new CDynLinkLibrary(LandGameVideoDLL);

	}
	else if (dwReason == DLL_PROCESS_DETACH)
	{
		TRACE0("LandGameVideo.DLL 正在终止！\n");
		AfxTermExtensionModule(LandGameVideoDLL);
	}
	return 1;   // 确定
}

//建立对象函数
extern "C" __declspec(dllexport) void * __cdecl CreateGameVideo()
{
	//建立对象
	CGameVideoItemSink * pGameVideo = NULL;
	try
	{
		pGameVideo = new CGameVideoItemSink();
		if (pGameVideo == NULL) 
			throw TEXT("创建失败");

		return pGameVideo;
	}
	catch (...) {}

	//清理对象
	SafeDelete(pGameVideo);
	return NULL;
}
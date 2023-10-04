// ClientControl.cpp : 定义 DLL 的初始化例程。
//

#include "stdafx.h"
#include <afxdllx.h>
#include "ClientControlItemSink.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#endif

static AFX_EXTENSION_MODULE ClientControlDLL = { NULL, NULL };

extern "C" int APIENTRY DllMain(HINSTANCE hInstance, DWORD dwReason, LPVOID lpReserved)
{
	// 如果使用 lpReserved，请将此移除
	UNREFERENCED_PARAMETER(lpReserved);

	if (dwReason == DLL_PROCESS_ATTACH)
	{
		TRACE0("ClientControl.DLL 正在初始化！\n");
		if (!AfxInitExtensionModule(ClientControlDLL, hInstance))return 0;
		new CDynLinkLibrary(ClientControlDLL);

	}
	else if (dwReason == DLL_PROCESS_DETACH)
	{
		TRACE0("ClientControl.DLL 正在终止！\n");
		// 在调用析构函数之前终止该库
		AfxTermExtensionModule(ClientControlDLL);
	}
	return 1;   // 确定
}

//建立对象函数
extern "C" __declspec(dllexport) void * __cdecl CreateClientControl(CWnd *pParentWnd )
{
	//建立对象
	CClientControlItemSinkDlg * pServerControl = NULL;
	try
	{
		pServerControl = new CClientControlItemSinkDlg(pParentWnd);
		if (pServerControl == NULL) 
			throw TEXT("创建失败");

		pServerControl->Create(IDD_DIALOG_ADMIN,pParentWnd);
		return pServerControl;
	}
	catch (...) {}

	//清理对象
	SafeDelete(pServerControl);
	return NULL;
}
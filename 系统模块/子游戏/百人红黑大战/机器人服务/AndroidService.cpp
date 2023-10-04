#include "Stdafx.h"
#include "AfxDLLx.h"

//////////////////////////////////////////////////////////////////////////

//静态变量
static AFX_EXTENSION_MODULE AndroidServiceDLL={NULL,NULL};

//////////////////////////////////////////////////////////////////////////

//DLL 主函数
extern "C" INT APIENTRY DllMain(HINSTANCE hInstance, DWORD dwReason, LPVOID lpReserved)
{
	UNREFERENCED_PARAMETER(lpReserved);

	if (dwReason==DLL_PROCESS_ATTACH)
	{
		if (!AfxInitExtensionModule(AndroidServiceDLL, hInstance)) return 0;
		new CDynLinkLibrary(AndroidServiceDLL);
	}
	else if (dwReason==DLL_PROCESS_DETACH)
	{
		AfxTermExtensionModule(AndroidServiceDLL);
	}

	return 1;
}

//////////////////////////////////////////////////////////////////////////

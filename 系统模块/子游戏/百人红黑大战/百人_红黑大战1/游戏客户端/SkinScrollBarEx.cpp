#include "StdAfx.h"
#include "Resource.h"
#include "SkinScrollBarEx.h"

//////////////////////////////////////////////////////////////////////////////////

//构造函数
CSkinScrollBarEx::CSkinScrollBarEx()
{
	m_ImageScroll.LoadFromResource(AfxGetInstanceHandle(),IDB_SKIN_SCROLL);
}

//析构函数
CSkinScrollBarEx::~CSkinScrollBarEx()
{
}

//配置滚动
VOID CSkinScrollBarEx::InitScroolBar(CWnd * pWnd)
{
	//设置滚动
	SkinSB_Init(pWnd->GetSafeHwnd(),m_ImageScroll);

	return;
}

//////////////////////////////////////////////////////////////////////////////////

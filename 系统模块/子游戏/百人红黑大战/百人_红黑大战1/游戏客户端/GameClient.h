#pragma once

#include "Stdafx.h"
#include "Resource.h"

//////////////////////////////////////////////////////////////////////////

//应用程序类
class CGameClientApp : public CGameFrameApp
{
	//函数定义
public:
	//构造函数
	CGameClientApp();
	//析构函数
	virtual ~CGameClientApp();

	//继承函数
public:
	//创建框架
	virtual CGameFrameWnd * GetGameFrameWnd();
	//创建引擎
	virtual CGameFrameEngine * GetGameFrameEngine(DWORD dwSDKVersion);

};

//////////////////////////////////////////////////////////////////////////

//程序对象
extern CGameClientApp theApp;

//////////////////////////////////////////////////////////////////////////

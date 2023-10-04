#ifndef SKIN_BUTTONEX_HEAD_FILE
#define SKIN_BUTTONEX_HEAD_FILE

#pragma once

//////////////////////////////////////////////////////////////////////////////////

//按钮类
class CSkinButtonEx : public CSkinButton
{
	//函数定义
public:
	//构造函数
	CSkinButtonEx();
	//析构函数
	virtual ~CSkinButtonEx();

	//重载函数
protected:
	//绑定函数
	virtual VOID PreSubclassWindow();
	//绘画函数
	virtual VOID DrawItem(LPDRAWITEMSTRUCT lpDrawItemStruct);
	//绘画文字
	VOID DrawButtonText(CDC * pDC, UINT uItemState);
};

//////////////////////////////////////////////////////////////////////////////////

#endif
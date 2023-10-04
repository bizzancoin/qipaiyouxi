#ifndef CARD_CONTROL_HEAD_FILE
#define CARD_CONTROL_HEAD_FILE

#pragma once

#include "Stdafx.h"

//////////////////////////////////////////////////////////////////////////
//宏定义

//常量定义
#define INVALID_ITEM				0xFFFF								//无效子项

//属性定义
#define MAX_CARD_COUNT				3									//扑克数目
#define SPACE_CARD_DATA				255									//间距扑克

//数值掩码
#define	CARD_MASK_COLOR				0xF0								//花色掩码
#define	CARD_MASK_VALUE				0x0F								//数值掩码

//间距定义
#define DEF_X_DISTANCE				25									//默认间距
#define DEF_Y_DISTANCE				17									//默认间距
#define DEF_SHOOT_DISTANCE			20									//默认间距


//////////////////////////////////////////////////////////////////////////
//枚举定义

//X 排列方式
enum enXCollocateMode 
{ 
	enXLeft,						//左对齐
	enXCenter,						//中对齐
	enXRight,						//右对齐
};

//Y 排列方式
enum enYCollocateMode 
{ 
	enYTop,							//上对齐
	enYCenter,						//中对齐
	enYBottom,						//下对齐
};

//////////////////////////////////////////////////////////////////////////

//扑克结构
struct tagCardItem
{
	bool							bShoot;								//弹起标志
	BYTE							cbCardData;							//扑克数据
};

//////////////////////////////////////////////////////////////////////////

//扑克控件
class CCardControl
{
	//状态变量
protected:
	bool							m_bDisplayItem;						//显示标志
	bool							m_bShowCardControl;					//显示扑克

	//扑克数据
protected:
	WORD							m_wCardCount;						//扑克数目
	tagCardItem						m_CardItemArray[MAX_CARD_COUNT];	//扑克数据

	//位置变量
protected:
	CPoint							m_BenchmarkPos;						//基准位置

	//资源变量
protected:
	CSize							m_CardSize;							//扑克大小
	CPngImage						m_ImageCard;						//图片资源

	//函数定义
public:
	//构造函数
	CCardControl();
	//析构函数
	virtual ~CCardControl();

	//创建函数
public:
	//创建函数
	void Create(CWnd* pWnd);

	//扑克控制
public:
	//设置扑克
	bool SetCardData(WORD wCardCount);
	//设置扑克
	bool SetCardData(const BYTE cbCardData[], WORD wCardCount);

	//获取扑克
public:
	//扑克资源
	CPngImage* GetCardImage() { return &m_ImageCard; }
	//扑克数目
	WORD GetCardCount() { return m_wCardCount; }
	//获取扑克
	WORD GetCardData(BYTE cbCardData[], WORD wBufferCount);
	//获取扑克
	WORD GetShootCard(BYTE cbCardData[], WORD wBufferCount);
	//获取扑克
	WORD GetCardData(tagCardItem CardItemArray[], WORD wBufferCount);

	//状态控制
public:
	//设置显示
	VOID SetDisplayFlag(bool bDisplayItem) { m_bDisplayItem = bDisplayItem; }
	//显示扑克
	void ShowCardControl(bool bShow){ m_bShowCardControl = bShow;}

	//控件控制
public:
	//基准位置
	VOID SetBenchmarkPos(INT nXPos, INT nYPos);
	//获取位置
	CPoint GetBenchmarkPos();

	//事件控制
public:
	//绘画扑克
	VOID DrawCardControl(CDC * pDC);
	//绘画扑克
	VOID DrawCard(CDC * pDC, BYTE cbCardData, int nPosX, int nPosY);
};

//////////////////////////////////////////////////////////////////////////

#endif
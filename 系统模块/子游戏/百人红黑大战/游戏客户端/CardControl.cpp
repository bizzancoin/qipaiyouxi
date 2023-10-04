#include "StdAfx.h"
#include "GameClient.h"
#include "CardControl.h"

//////////////////////////////////////////////////////////////////////////

//构造函数
CCardControl::CCardControl()
{
	//状态变量
	m_bDisplayItem = false;
	m_bShowCardControl = true;

	//扑克数据
	m_wCardCount=0;
	ZeroMemory(m_CardItemArray,sizeof(m_CardItemArray));

	//位置变量
	m_BenchmarkPos.SetPoint(0,0);

	return;
}

//析构函数
CCardControl::~CCardControl()
{
}

//创建函数
void CCardControl::Create(CWnd* pWnd)
{
	//加载资源
	HINSTANCE hResInstance=AfxGetInstanceHandle();
	m_ImageCard.LoadImage( hResInstance, TEXT("GAME_CARD"));

	//获取大小
	m_CardSize.SetSize(m_ImageCard.GetWidth()/13,m_ImageCard.GetHeight()/5);
}

//设置扑克
bool CCardControl::SetCardData(WORD wCardCount)
{
	//效验参数
	ASSERT(wCardCount<=CountArray(m_CardItemArray));
	if (wCardCount>CountArray(m_CardItemArray)) return false;

	//设置变量
	m_wCardCount=wCardCount;
	ZeroMemory(m_CardItemArray,sizeof(m_CardItemArray));

	return true;
}


//设置扑克
bool CCardControl::SetCardData(const BYTE cbCardData[], WORD wCardCount)
{
	//效验参数
	ASSERT(wCardCount<=CountArray(m_CardItemArray));
	if (wCardCount>CountArray(m_CardItemArray)) return false;

	//扑克数目
	m_wCardCount=wCardCount;

	//设置扑克
	for (WORD i=0;i<wCardCount;i++)
	{
		m_CardItemArray[i].bShoot=false;
		m_CardItemArray[i].cbCardData=cbCardData[i];
	}

	return true;
}


//获取扑克
WORD CCardControl::GetCardData(BYTE cbCardData[], WORD wBufferCount)
{
	//效验参数
	ASSERT(wBufferCount>=m_wCardCount);
	if (wBufferCount<m_wCardCount) return 0;

	//拷贝扑克
	for (WORD i=0;i<m_wCardCount;i++) cbCardData[i]=m_CardItemArray[i].cbCardData;

	return m_wCardCount;
}

//获取扑克
WORD CCardControl::GetCardData(tagCardItem CardItemArray[], WORD wBufferCount)
{
	//效验参数
	ASSERT(wBufferCount>=m_wCardCount);
	if (wBufferCount<m_wCardCount) return 0;

	//拷贝扑克
	CopyMemory(CardItemArray,m_CardItemArray,sizeof(tagCardItem)*m_wCardCount);

	return m_wCardCount;
}

//基准位置
VOID CCardControl::SetBenchmarkPos(INT nXPos, INT nYPos)
{
	//设置变量
	m_BenchmarkPos.x = nXPos;
	m_BenchmarkPos.y = nYPos;
	return;
}


//绘画扑克
VOID CCardControl::DrawCardControl(CDC * pDC)
{
	//显示判断
	if (m_bShowCardControl==false) return;

	//绘画扑克
	for (WORD i = 0 ; i < m_wCardCount; i++)
	{
		//获取扑克
		bool bShoot = m_CardItemArray[i].bShoot;
		BYTE cbCardData = m_CardItemArray[i].cbCardData;

		//间隙过滤
		if (cbCardData == SPACE_CARD_DATA) continue;

		//屏幕位置
		INT nXDrawPos = 0; 
		INT nYDrawPos = 0;

		//绘画扑克
		nXDrawPos = m_BenchmarkPos.x - m_CardSize.cx/2 - ((m_wCardCount - 1)*DEF_X_DISTANCE/2) + DEF_X_DISTANCE * i ;
		nYDrawPos = m_BenchmarkPos.y - m_CardSize.cy/2;
		DrawCard(pDC, cbCardData, nXDrawPos, nYDrawPos);

	}
	return;
}

//绘画扑克
VOID CCardControl::DrawCard( CDC * pDC, BYTE cbCardData, int nPosX, int nPosY )
{
	CSize szCardSize(m_ImageCard.GetWidth()/13,m_ImageCard.GetHeight()/5);
	INT nXImagePos = 0;
	INT nYImagePos = 0;

	//图片位置
	if ((m_bDisplayItem==true)&&(cbCardData!=0))
	{
		if ((cbCardData==0x4E)||(cbCardData==0x4F))
		{
			nXImagePos = ((cbCardData&CARD_MASK_VALUE)%14)*szCardSize.cx;
			nYImagePos = ((cbCardData&CARD_MASK_COLOR)>>4)*szCardSize.cy;
		}
		else
		{
			nXImagePos = ((cbCardData&CARD_MASK_VALUE)-1)*szCardSize.cx;
			nYImagePos = ((cbCardData&CARD_MASK_COLOR)>>4)*szCardSize.cy;
		}
	}
	else
	{
		nXImagePos = szCardSize.cx*2;
		nYImagePos = szCardSize.cy*4;
	}

	m_ImageCard.DrawImage(pDC, nPosX, nPosY,szCardSize.cx,szCardSize.cy, nXImagePos, nYImagePos);
}

//获取位置
CPoint CCardControl::GetBenchmarkPos()
{
	return m_BenchmarkPos;
}

//////////////////////////////////////////////////////////////////////////


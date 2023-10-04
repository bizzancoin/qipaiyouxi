// DlgViewChart.cpp : implementation file
//

#include "stdafx.h"
#include "DlgViewChart.h"
#include ".\dlgviewchart.h"

BEGIN_MESSAGE_MAP(CDlgViewChart, CDialog)
	ON_WM_PAINT()
	ON_WM_LBUTTONDOWN()
	ON_WM_ERASEBKGND()
END_MESSAGE_MAP()

IMPLEMENT_DYNAMIC(CDlgViewChart, CDialog)
CDlgViewChart::CDlgViewChart():CDialog(IDD_VIEW_CHART, NULL)
{
	HINSTANCE hInstance=AfxGetInstanceHandle();
	m_ImageBack.LoadFromResource(hInstance,IDB_CHART_BACK);

	//设置图片
	m_PngPlayerFlag.LoadImage(hInstance,TEXT("CHART_XIAN"));
	m_PngPlayerEXFlag.LoadImage(hInstance,TEXT("CHART_XIAN_EX"));
	m_PngBankerFlag.LoadImage(hInstance,TEXT("CHART_ZHUANG"));
	m_PngBankerEXFlag.LoadImage(hInstance,TEXT("CHART_ZHUANG_EX"));
	m_PngTieFlag.LoadImage(hInstance,TEXT("CHART_PING"));
	m_PngTieEXFlag.LoadImage(hInstance,TEXT("CHART_PING_EX"));
	m_PngTwopairFlag.LoadImage(hInstance,TEXT("TWO_PAIR_FLAG"));

	//初始变量
	ZeroMemory(m_TraceGameRecordArray,sizeof(m_TraceGameRecordArray));
	ZeroMemory(m_GameRecordArray,sizeof(m_GameRecordArray));
	m_TraceGameRecordCount=0;
	m_GameRecordCount=0;
	m_nRecordFirst= 0;	
	m_nRecordLast= 0;
	m_nRecordCol = 0;
	ZeroMemory(m_bFillTrace,sizeof(m_bFillTrace));
}

CDlgViewChart::~CDlgViewChart()
{
}

void CDlgViewChart::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	DDX_Control(pDX,IDOK,m_btClose);
}

BOOL CDlgViewChart::OnInitDialog()
{
	CDialog::OnInitDialog();

	m_btClose.SetButtonImage(IDB_BT_CHART_CLOSE,AfxGetInstanceHandle(),false,false);

	CRgn ImageRgn;
	m_ImageBack.CreateImageRegion(ImageRgn,RGB(255,0,255));
	SetWindowRgn(ImageRgn, FALSE);
	ImageRgn.DeleteObject();


	MoveWindow(0,0,m_ImageBack.GetWidth(),m_ImageBack.GetHeight());
	CRect rcButton;
	m_btClose.GetWindowRect(rcButton);
	m_btClose.MoveWindow(m_ImageBack.GetWidth()/2 - rcButton.Width()/2, m_ImageBack.GetHeight() - rcButton.Height() - 5, rcButton.Width(), rcButton.Height());

	return TRUE;
}

void CDlgViewChart::OnPaint()
{
	CPaintDC dc(this); 

	m_ImageBack.BitBlt(dc.GetSafeHdc(),0,0);

	DrawPrecent(&dc);
	DrawChart(&dc);
}

void CDlgViewChart::OnLButtonDown(UINT nFlags, CPoint point)
{
	CDialog::OnLButtonDown(nFlags, point);

	//消息模拟
	PostMessage(WM_NCLBUTTONDOWN,HTCAPTION,MAKELPARAM(point.x,point.y));
}

//绘画表格
void CDlgViewChart::DrawChart(CDC *pDC)
{
	//位置变量
	int nPosX = 10;
	int nPosY = 156;
	int nGridWidth=31;
	int nGridHeight=31;
	int nIndex = m_nRecordFirst;
	//绘画结果
	int nVerCount=0, nHorCount=0;
	int nDrawCount = (m_nRecordLast-m_nRecordFirst +MAX_SCORE_HISTORY)%MAX_SCORE_HISTORY;
	nIndex = (m_nRecordLast-__min(80,nDrawCount) +MAX_SCORE_HISTORY)%MAX_SCORE_HISTORY;
	while (nIndex != m_nRecordLast && ( m_nRecordLast != m_nRecordFirst ) )
	{
		tagClientGameRecord &ClientGameRecord = m_GameRecordArray[nIndex];

		if (ClientGameRecord.cbPlayerCount > ClientGameRecord.cbBankerCount)
		{
			m_PngPlayerFlag.DrawImage(pDC,nPosX+nHorCount*nGridWidth,nPosY+nVerCount*nGridHeight);
		}
		else if (ClientGameRecord.cbPlayerCount < ClientGameRecord.cbBankerCount)
		{
			m_PngBankerFlag.DrawImage(pDC,nPosX+nHorCount*nGridWidth,nPosY+nVerCount*nGridHeight);
		}
		else
		{
			m_PngTieFlag.DrawImage(pDC,nPosX+nHorCount*nGridWidth,nPosY+nVerCount*nGridHeight);
		}

		INT nWidth = m_PngTwopairFlag.GetWidth()/2;
		INT nHeight = m_PngTwopairFlag.GetHeight();
		if (ClientGameRecord.bBankerTwoPair) m_PngTwopairFlag.DrawImage(pDC,nPosX+nHorCount*nGridWidth+2,nPosY+nVerCount*nGridHeight+2,nWidth,nHeight,0,0);
		if (ClientGameRecord.bPlayerTwoPair) m_PngTwopairFlag.DrawImage(pDC,nPosX+(nHorCount+1)*nGridWidth-3-nWidth,nPosY+(nVerCount+1)*nGridHeight-3-nHeight,nWidth,nHeight,nWidth,0);

		//递增数目
		nVerCount++;		
		if (nVerCount == 6)
		{
			nVerCount = 0;
			nHorCount++;
		}

		nIndex = (nIndex+1) % MAX_SCORE_HISTORY;
	}

	//绘画路径
	nPosX = 10;
	nPosY = 60;
	nGridWidth = 15;
	nGridHeight = 15;
	nVerCount = 0, nHorCount = 0;
	BYTE cbPreWinSide = 0, cbCurWinSide = 0;
	BYTE cbOffSetCol = __max(m_nRecordCol - 28,0);
	ZeroMemory(m_bFillTrace,sizeof(m_bFillTrace));
	nIndex = m_nRecordFirst;
	while (nIndex != m_nRecordLast && ( m_nRecordLast != m_nRecordFirst ) )
	{
		//break;
		tagClientGameRecord &ClientGameRecord = m_TraceGameRecordArray[nIndex];

		if (ClientGameRecord.cbPlayerCount > ClientGameRecord.cbBankerCount) cbCurWinSide = AREA_XIAN + 1;
		else if (ClientGameRecord.cbPlayerCount < ClientGameRecord.cbBankerCount) cbCurWinSide = AREA_ZHUANG + 1;
		else cbCurWinSide = AREA_PING + 1;

		//递增数目
		if ( cbPreWinSide != 0 && ( cbPreWinSide == cbCurWinSide || cbCurWinSide == AREA_PING + 1 ))
		{
			nVerCount++;
			if (m_bFillTrace[nVerCount][nHorCount]==true || nVerCount==6)
			{
				nVerCount--;
				nHorCount++;
			}
		}
		else
		{
			nVerCount=0;

			//第一次
			if ( cbPreWinSide != 0 )
			{
				for (int i=0; i<MAX_SCORE_HISTORY; ++i)
				{
					if (m_bFillTrace[0][i]==false)
					{
						nHorCount=i;
						break;
					}
				}				
			}

			cbPreWinSide=cbCurWinSide;
		}

		//设置标识
		m_bFillTrace[nVerCount][nHorCount]=true;

		////清零判断
		//if (nHorCount==100)
		//{
		//	m_TraceGameRecordCount=0;
		//	ZeroMemory(m_bFillTrace,sizeof(m_bFillTrace));
		//	//InvalidateRect(NULL);
		//	break;
		//}
		if(nHorCount - cbOffSetCol < 0 || nHorCount - cbOffSetCol > 28)
		{
			nIndex = (nIndex+1) % MAX_SCORE_HISTORY;
			continue;
		}
		
		if ( cbCurWinSide == AREA_ZHUANG + 1 )
		{
			m_PngBankerEXFlag.DrawImage(pDC, nPosX + (nHorCount - cbOffSetCol) * nGridWidth, nPosY + nVerCount * nGridHeight + 1);
		}
		else if ( cbCurWinSide == AREA_XIAN + 1 )
		{
			m_PngPlayerEXFlag.DrawImage(pDC, nPosX + (nHorCount - cbOffSetCol) * nGridWidth, nPosY + nVerCount * nGridHeight);
		}
		else
		{
			m_PngTieEXFlag.DrawImage(pDC, nPosX + (nHorCount - cbOffSetCol) * nGridWidth, nPosY + nVerCount * nGridHeight);
		}
		nIndex = (nIndex+1) % MAX_SCORE_HISTORY;
	}
}

//绘画表格
void CDlgViewChart::DrawPrecent(CDC *pDC)
{
	//创建资源
	CFont InfoFont;
	InfoFont.CreateFont(-16,0,0,0,400,0,0,0,134,3,2,ANTIALIASED_QUALITY,2,TEXT("宋体"));

	//设置 DC
	pDC->SetBkMode(TRANSPARENT);
	pDC->SetTextAlign(TA_CENTER|TA_TOP);
	CFont * pOldFont=pDC->SelectObject(&InfoFont);

	//获取大小
	CRect rcClient;
	GetClientRect(rcClient);

	//数目统计
	int nBankerCount=0, nPlayerCount=0, nTieCount=0, nBankerTwoPairCount=0, nPlayerTwoPairCount=0, nBankerKingCount=0, nPlayerKingCount=0;
	int nIndex = m_nRecordFirst;
	while (nIndex != m_nRecordLast && ( m_nRecordLast != m_nRecordFirst ) )
	{
		tagClientGameRecord &ClientGameRecord=m_GameRecordArray[nIndex];

		if (ClientGameRecord.cbBankerCount > ClientGameRecord.cbPlayerCount)
		{
			nBankerCount++;
		}
		else if (ClientGameRecord.cbBankerCount < ClientGameRecord.cbPlayerCount)
		{
			nPlayerCount++;
		}
		else
		{
			nTieCount++;
		}
		
		//对子判断
		if (ClientGameRecord.bBankerTwoPair) nBankerTwoPairCount++;
		if (ClientGameRecord.bPlayerTwoPair) nPlayerTwoPairCount++;

		if (ClientGameRecord.cbBankerCount < ClientGameRecord.cbPlayerCount && ClientGameRecord.cbPlayerCount >=8) 
			nPlayerKingCount++;
		else if (ClientGameRecord.cbPlayerCount < ClientGameRecord.cbBankerCount && ClientGameRecord.cbBankerCount >=8) 
			nBankerKingCount++;

		nIndex = (nIndex+1) % MAX_SCORE_HISTORY;
	}

	CString strCount;
	float fTatolCount=float(nBankerCount+nPlayerCount+nTieCount);
	if (fTatolCount<=0) fTatolCount=1.0;

	int nSpace = 45 ,nPosX = 0,nPosY = 37;

	//闲家
	nPosX = 55;
	strCount.Format(TEXT("%d"),nPlayerCount);
	DrawTextString(pDC,strCount,RGB(95,166,227),RGB(39,27,1),nPosX,12);
	strCount.Format(TEXT("%.2f%%"),100*nPlayerCount/fTatolCount);
	DrawTextString(pDC,strCount,RGB(95,166,227),RGB(39,27,1),nPosX+nSpace,12);

	//平家
	nPosX = 202;
	strCount.Format(TEXT("%d"),nTieCount);
	DrawTextString(pDC,strCount,RGB(75,171,69),RGB(39,27,1),nPosX,12);
	strCount.Format(TEXT("%.2f%%"),100*nTieCount/fTatolCount);
	DrawTextString(pDC,strCount,RGB(75,171,69),RGB(39,27,1),nPosX+nSpace,12);

	//庄家
	nPosX = 349;
	strCount.Format(TEXT("%d"),nBankerCount);
	DrawTextString(pDC,strCount,RGB(212,95,27),RGB(39,27,1),nPosX,12);
	strCount.Format(TEXT("%.2f%%"),100*nBankerCount/fTatolCount);
	DrawTextString(pDC,strCount,RGB(212,95,27),RGB(39,27,1),nPosX+nSpace,12);	

	//闲对子
	nPosX = 74;
	strCount.Format(TEXT("%d"),nPlayerTwoPairCount);
	DrawTextString(pDC,strCount,RGB(95,166,227),RGB(39,27,1),nPosX,nPosY);

	//庄对子
	nPosX = 180;
	strCount.Format(TEXT("%d"),nBankerTwoPairCount);
	DrawTextString(pDC,strCount,RGB(212,95,27),RGB(39,27,1),nPosX,nPosY);

	//闲天王
	nPosX = 290;
	strCount.Format(TEXT("%d"),nPlayerKingCount);
	DrawTextString(pDC,strCount,RGB(95,166,227),RGB(39,27,1),nPosX,nPosY);

	//庄天王
	nPosX = 400;
	strCount.Format(TEXT("%d"),nBankerKingCount);
	DrawTextString(pDC,strCount,RGB(212,95,27),RGB(39,27,1),nPosX,nPosY);

	//清理资源
	pDC->SelectObject(pOldFont);
	InfoFont.DeleteObject();
}

//艺术字体
void CDlgViewChart::DrawTextString(CDC * pDC, LPCTSTR pszString, COLORREF crText, COLORREF crFrame, int nXPos, int nYPos)
{
	//变量定义
	int nStringLength=lstrlen(pszString);
	int nXExcursion[8]={1,1,1,0,-1,-1,-1,0};
	int nYExcursion[8]={-1,0,1,1,1,0,-1,-1};

	//保存设置
	COLORREF rcTextColor=pDC->GetTextColor();

	//绘画边框
	pDC->SetTextColor(crFrame);
	for (int i=0;i<CountArray(nXExcursion);i++)
	{
		pDC->TextOut(nXPos+nXExcursion[i],nYPos+nYExcursion[i],pszString,nStringLength);
	}

	//绘画字体
	pDC->SetTextColor(crText);
	pDC->TextOut(nXPos,nYPos,pszString,nStringLength);

	//还原设置
	pDC->SetTextColor(rcTextColor);

	return;
}

//设置结果
void CDlgViewChart::SetGameRecord(const tagClientGameRecord &ClientGameRecord)
{
	//保存结果
	m_TraceGameRecordArray[m_nRecordLast]=ClientGameRecord;
	m_GameRecordArray[m_nRecordLast]=ClientGameRecord;

	//清空判断
	m_TraceGameRecordCount++;
	m_GameRecordCount++;
	if (m_TraceGameRecordCount>=100) m_TraceGameRecordCount=0;
	if (m_GameRecordCount>=80) m_GameRecordCount=0;
	
	//移动下标
	m_nRecordLast = (m_nRecordLast+1) % MAX_SCORE_HISTORY;
	if ( m_nRecordLast == m_nRecordFirst )
	{
		m_nRecordFirst = (m_nRecordFirst+1) % MAX_SCORE_HISTORY;
		//if ( m_nScoreHead < m_nRecordFirst ) m_nScoreHead = m_nRecordFirst;
	}

	//更新界面
	if (IsWindowVisible()) InvalidateRect(NULL);
}
BOOL CDlgViewChart::OnEraseBkgnd(CDC* pDC)
{
	DrawPrecent(pDC);
	DrawChart(pDC);

	return TRUE;
}

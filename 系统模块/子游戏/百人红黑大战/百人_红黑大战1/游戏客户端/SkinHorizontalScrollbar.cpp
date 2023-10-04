// SkinHorizontalScrollbar.cpp : implementation file
//

#include "stdafx.h"

#include "SkinHorizontalScrollbar.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CSkinHorizontalScrollbar

CSkinHorizontalScrollbar::CSkinHorizontalScrollbar()
{
	nThumbLeft = NWIDTH;
	dbThumbRemainder = 0.00f;

	bMouseDown = false;
	bMouseDownArrowLeft = false;
	bMouseDownArrowRight = false;
	bDragging = false;
	pList = NULL;
	
}

CSkinHorizontalScrollbar::~CSkinHorizontalScrollbar()
{
}


BEGIN_MESSAGE_MAP(CSkinHorizontalScrollbar, CStatic)
	//{{AFX_MSG_MAP(CSkinHorizontalScrollbar)
	ON_WM_PAINT()
	ON_WM_LBUTTONDOWN()
	ON_WM_LBUTTONUP()
	ON_WM_MOUSEMOVE()
	ON_WM_TIMER()
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CSkinHorizontalScrollbar message handlers

void CSkinHorizontalScrollbar::OnPaint() 
{
	CPaintDC dc(this); // device context for painting
	
	Draw();
}

void CSkinHorizontalScrollbar::OnLButtonDown(UINT nFlags, CPoint point) 
{
	SetCapture();
	CRect clientRect;
	GetClientRect(&clientRect);
	
	int nWidth = clientRect.Width()-NWIDTH;

	CRect rectLeftArrow(0,0,NWIDTH,NHEIGHT);
	CRect rectRightArrow(nWidth,0,nWidth+NWIDTH,NHEIGHT);
	CRect rectThumb(nThumbLeft,0,nThumbLeft+GetScrollBarLength(),NHEIGHT);
	
	if(rectThumb.PtInRect(point))
	{
		bMouseDown = true;
	}


	if(rectRightArrow.PtInRect(point))
	{
		bMouseDownArrowRight = true;
		SetTimer(2,250,NULL);
	}

	if(rectLeftArrow.PtInRect(point))
	{
		bMouseDownArrowLeft = true;
		SetTimer(2,250,NULL);
	}

	CStatic::OnLButtonDown(nFlags, point);
}

void CSkinHorizontalScrollbar::OnLButtonUp(UINT nFlags, CPoint point) 
{
	UpdateThumbPosition();
	KillTimer(1);
	ReleaseCapture();
	

	bool bInChannel = true;
	
	CRect clientRect;
	GetClientRect(&clientRect);
	
	int nWidth = clientRect.Width()-NWIDTH;

	CRect rectLeftArrow(0,0,nWidth,NHEIGHT);
	CRect rectThumb(nThumbLeft,0,GetScrollBarLength(),NHEIGHT);

	if(rectLeftArrow.PtInRect(point))
	{
		ScrollLeft();	
		bInChannel = false;
	}

	CRect rectRightArrow(nWidth,0,nWidth+nWidth,NHEIGHT);

	
	if(rectRightArrow.PtInRect(point))
	{
		ScrollRight();	
		bInChannel = false;
	}

	if(rectThumb.PtInRect(point))
	{
		bInChannel = false;
	}

	if(bInChannel == true)
	{
		if(point.x > nThumbLeft)
		{
			PageRight();
		}
		else
		{
			PageLeft();
		}
	}

	//reset all variables
	bMouseDown = false;
	bDragging = false;
	bMouseDownArrowLeft = false;
	bMouseDownArrowRight = false;
	CStatic::OnLButtonUp(nFlags, point);
}

void CSkinHorizontalScrollbar::OnMouseMove(UINT nFlags, CPoint point) 
{
	CRect clientRect;
	GetClientRect(&clientRect);

	if(bMouseDown)
		bDragging = true;

	if(bDragging)
	{	
		int nPreviousThumbLeft = nThumbLeft;
		nThumbLeft = point.x-GetScrollBarLength()/2; //-13 so mouse is in middle of thumb

		
		double nMax = pList->GetScrollLimit(SB_HORZ);
		int nPos = pList->GetScrollPos(SB_HORZ);

		double nWidth = clientRect.Width()-NHEIGHT*3;
		double nVar = nMax;
		dbThumbInterval = nWidth/nVar;

		//figure out how many times to scroll total from top
		//then minus the current position from it
		int nScrollTimes = (int)((nThumbLeft-NHEIGHT)/dbThumbInterval)-nPos;
		
		CSize size;
		size.cx = nScrollTimes;
		size.cy = 0;
		pList->Scroll(size);

		pList->Invalidate(TRUE);
		
		LimitThumbPosition();
		
		Draw();
	}

	CStatic::OnMouseMove(nFlags, point);
}

void CSkinHorizontalScrollbar::OnTimer(UINT nIDEvent) 
{
	if(nIDEvent == 1)
	{
		if(bMouseDownArrowRight)
		{
			ScrollRight();
		}
		
		if(bMouseDownArrowLeft)
		{
			ScrollLeft();
		}
	}
	else if(nIDEvent == 2)
	{
		if(bMouseDownArrowRight)
		{
			KillTimer(2);
			SetTimer(1, 50, NULL);
		}
		
		if(bMouseDownArrowLeft)
		{
			KillTimer(2);
			SetTimer(1, 50, NULL);
		}
	}
	CStatic::OnTimer(nIDEvent);
}

void CSkinHorizontalScrollbar::ScrollLeft()
{
	pList->SendMessage(WM_HSCROLL, MAKELONG(SB_LINELEFT,0),NULL);
	UpdateThumbPosition();
}

void CSkinHorizontalScrollbar::ScrollRight()
{
	pList->SendMessage(WM_HSCROLL, MAKELONG(SB_LINERIGHT,0),NULL);
	UpdateThumbPosition();
}

void CSkinHorizontalScrollbar::UpdateThumbPosition()
{
	CRect clientRect;
	GetClientRect(&clientRect);

	double nPos = pList->GetScrollPos(SB_HORZ);
	double nMax = pList->GetScrollLimit(SB_HORZ);
	double nWidth = clientRect.Width()-NHEIGHT*3; 
	double nVar = nMax;

	dbThumbInterval = nWidth/nVar;

	double nNewdbValue = dbThumbInterval * (nPos);
	int nNewValue = (int)nNewdbValue;
	double nExtra = nNewdbValue - nNewValue;
	dbThumbRemainder = nExtra;
	
	nThumbLeft = NHEIGHT+nNewValue;

	LimitThumbPosition();
	
	Draw();
}

void CSkinHorizontalScrollbar::PageRight()
{
	pList->SendMessage(WM_HSCROLL, MAKELONG(SB_PAGEDOWN,0),NULL);
	UpdateThumbPosition();
}

void CSkinHorizontalScrollbar::PageLeft()
{
	pList->SendMessage(WM_HSCROLL, MAKELONG(SB_PAGEUP,0),NULL);
	UpdateThumbPosition();
}

void CSkinHorizontalScrollbar::Draw()
{
	CClientDC dc(this);
	CRect clientRect;
	GetClientRect(&clientRect);
	CMemDC memDC(&dc, &clientRect);
	memDC.FillSolidRect(&clientRect,  RGB(76,85,118));

	CDC bitmapDC;
	bitmapDC.CreateCompatibleDC(&dc);

	CBitmap bitmap;
	bitmap.LoadBitmap(IDB_SCROLL_BAR);
	CBitmap* pOldBitmap = bitmapDC.SelectObject(&bitmap);

	//LEFTARROW
	int indexX=0;
	int indexY=3*NHEIGHT+3*3;
	memDC.BitBlt(clientRect.left,clientRect.top,NWIDTH,NHEIGHT,&bitmapDC,0,indexY,SRCCOPY);


	//span
	indexX=5*NWIDTH+5*3;
	int nWidth = clientRect.Width() - NWIDTH;

	for(int i=0; i<nWidth; i++)
	{
		memDC.BitBlt((clientRect.left+NWIDTH)+(i*1),clientRect.top,1,NHEIGHT,&bitmapDC,indexX,indexY,SRCCOPY);
	}

	
	//RIGHTARROW
	indexX=NWIDTH+3;
	memDC.BitBlt(nWidth,clientRect.top,nWidth,NHEIGHT,&bitmapDC,indexX,indexY,SRCCOPY);
	

	int nThumbLength=GetScrollBarLength();
	

	//THUMB
	indexX=2*NWIDTH+3*2;
	//memDC.BitBlt(clientRect.left+nThumbLeft,clientRect.top,NWIDTH,NHEIGHT,&bitmapDC,indexX,indexY,SRCCOPY);

	int start=clientRect.left+nThumbLeft;
	if (start+nThumbLength>clientRect.Width()-NWIDTH)
	{
		start=clientRect.Width()-NWIDTH-nThumbLength;
	}
	memDC.StretchBlt(start,clientRect.top,nThumbLength,NHEIGHT,&bitmapDC,indexX+2,indexY,1,NHEIGHT,SRCCOPY);

	bitmapDC.SelectObject(pOldBitmap);
	bitmap.DeleteObject();
	pOldBitmap = NULL;
}

void CSkinHorizontalScrollbar::LimitThumbPosition()
{
	CRect clientRect;
	GetClientRect(&clientRect);

	if(nThumbLeft+GetScrollBarLength() > (clientRect.Width()-NWIDTH))
	{
		nThumbLeft = clientRect.Width()-NWIDTH-GetScrollBarLength();
	}

	if(nThumbLeft < (clientRect.left+NWIDTH))
	{
		nThumbLeft = clientRect.left+NWIDTH;
	}
}

int CSkinHorizontalScrollbar::GetScrollBarLength()
{
	SCROLLINFO si;
	si.cbSize = sizeof(SCROLLINFO);
	si.fMask = SIF_POS | SIF_RANGE;

	CRect clientRect;
	GetClientRect(&clientRect);

	int nThumbLength=NWIDTH;
	if (pList!=NULL)
	{
		pList->GetScrollInfo(SB_HORZ,&si);
		nThumbLength = si.nPage*(clientRect.Width() - NWIDTH*2)/(si.nPage+si.nMax-si.nMin);
	}
	return nThumbLength;

}

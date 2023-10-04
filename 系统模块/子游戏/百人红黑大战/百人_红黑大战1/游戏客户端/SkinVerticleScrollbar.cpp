// SkinVerticleScrollbar.cpp : implementation file
//

#include "stdafx.h"
#include "SkinVerticleScrollbar.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CSkinVerticleScrollbar

CSkinVerticleScrollbar::CSkinVerticleScrollbar()
{
	bMouseDown = false;
	bMouseDownArrowUp = false;
	bMouseDownArrowDown = false;
	bDragging = false;

	nThumbTop = NHEIGHT-1;
	dbThumbInterval = 0.000000;
	pList = NULL;
	pEdit = NULL;

}

CSkinVerticleScrollbar::~CSkinVerticleScrollbar()
{
}


BEGIN_MESSAGE_MAP(CSkinVerticleScrollbar, CStatic)
	//{{AFX_MSG_MAP(CSkinVerticleScrollbar)
	ON_WM_ERASEBKGND()
	ON_WM_LBUTTONDOWN()
	ON_WM_LBUTTONUP()
	ON_WM_MOUSEMOVE()
	ON_WM_PAINT()
	ON_WM_TIMER()
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CSkinVerticleScrollbar message handlers

BOOL CSkinVerticleScrollbar::OnEraseBkgnd(CDC* pDC) 
{
	return CStatic::OnEraseBkgnd(pDC);
}

void CSkinVerticleScrollbar::OnLButtonDown(UINT nFlags, CPoint point) 
{
	SetCapture();
	CRect clientRect;
	GetClientRect(&clientRect);

	int nHeight = clientRect.Height() ;
	

	CRect rectUpArrow(0,0,NWIDTH,NHEIGHT);
	CRect rectDownArrow(0,nHeight-NHEIGHT,NWIDTH,nHeight);
	CRect rectThumb(0,nThumbTop,NWIDTH,nThumbTop+NHEIGHT);

	if(rectThumb.PtInRect(point))
	{
		bMouseDown = true;
	}

	if(rectDownArrow.PtInRect(point))
	{
		bMouseDownArrowDown = true;
		SetTimer(2,250,NULL);
	}

	if(rectUpArrow.PtInRect(point))
	{
		bMouseDownArrowUp = true;
		SetTimer(2,250,NULL);
	}
	
	CStatic::OnLButtonDown(nFlags, point);
}

void CSkinVerticleScrollbar::OnLButtonUp(UINT nFlags, CPoint point) 
{
	UpdateThumbPosition();
	KillTimer(1);
	ReleaseCapture();
	
	bool bInChannel = true;

	CRect clientRect;
	GetClientRect(&clientRect);
	int nHeight = clientRect.Height() ;
	
	CRect rectUpArrow(0,0,NWIDTH,NHEIGHT);
	CRect rectDownArrow(0,nHeight-NHEIGHT,NWIDTH,nHeight);
	CRect rectThumb(0,nThumbTop,NWIDTH,nThumbTop+NHEIGHT);


	if(rectUpArrow.PtInRect(point) && bMouseDownArrowUp)
	{
		ScrollUp();	
		bInChannel = false;
	}

	if(rectDownArrow.PtInRect(point) && bMouseDownArrowDown)
	{
		ScrollDown();
		bInChannel = false;
	}

	if(rectThumb.PtInRect(point))
	{
		bInChannel = false;
	}

	if(bInChannel == true)
	{
		if(point.y > nThumbTop)
		{
			PageDown();
		}
		else
		{
			PageUp();
		}
	}

	bMouseDown = false;
	bDragging = false;
	bMouseDownArrowUp = false;
	bMouseDownArrowDown = false;
	
	CStatic::OnLButtonUp(nFlags, point);
}

void CSkinVerticleScrollbar::OnMouseMove(UINT nFlags, CPoint point) 
{
	CRect clientRect;
	GetClientRect(&clientRect);

	
	if (pList==NULL&&pEdit==NULL)
	{
		return;
	}
	if(bMouseDown)
	{
		
		int nPreviousThumbTop = nThumbTop;
		nThumbTop = point.y-NHEIGHT/2; //-13 so mouse is in middle of thumb
		
		double nMax;
		int nPos ;

		if (pList!=NULL)
		{
			 nMax = pList->GetScrollLimit(SB_VERT);
			 nPos = pList->GetScrollPos(SB_VERT);
		}
		else
		{
			nMax = pEdit->GetScrollLimit(SB_VERT);
			nPos = pEdit->GetScrollPos(SB_VERT);
		}

		double nHeight = clientRect.Height()-NHEIGHT*3;
		double nVar = nMax;
		dbThumbInterval = nHeight/nVar;
		
		int nScrollTimes = (int)((nThumbTop-(NHEIGHT-1))/dbThumbInterval)-nPos;
		
		CSize size;
		size.cx = 0;
		size.cy = nScrollTimes*12; //12 is the height of each row at current font
								  					  
		if (pList!=NULL)
		{
			//pList->Scroll(size);
		}
		else
		{
			//pEdit->Scroll(size);
			
		}
		LimitThumbPosition();

		Draw();
		
	}
	CStatic::OnMouseMove(nFlags, point);
}

void CSkinVerticleScrollbar::OnPaint() 
{
	CPaintDC dc(this); 
	
	Draw();
}

void CSkinVerticleScrollbar::OnTimer(UINT nIDEvent) 
{
	if(nIDEvent == 1)
	{
		if(bMouseDownArrowDown)
		{
			ScrollDown();
		}
		
		if(bMouseDownArrowUp)
		{
			ScrollUp();
		}
	}
	else if(nIDEvent == 2)
	{
		if(bMouseDownArrowDown)
		{
			KillTimer(2);
			SetTimer(1, 50, NULL);
		}
		
		if(bMouseDownArrowUp)
		{
			KillTimer(2);
			SetTimer(1, 50, NULL);
		}
	}
	CStatic::OnTimer(nIDEvent);
}

void CSkinVerticleScrollbar::PageDown()
{
	
	if (pList!=NULL)
	{
		pList->SendMessage(WM_VSCROLL, MAKELONG(SB_PAGEDOWN,0),NULL);
	}
	else
	{
		pEdit->SendMessage(WM_VSCROLL, MAKELONG(SB_PAGEDOWN,0),NULL);
	}
	
	UpdateThumbPosition();
}

void CSkinVerticleScrollbar::PageUp()
{
	if (pList!=NULL)
	{
		pList->SendMessage(WM_VSCROLL, MAKELONG(SB_PAGEUP,0),NULL);
	}
	else
	{
		pEdit->SendMessage(WM_VSCROLL, MAKELONG(SB_PAGEUP,0),NULL);
	}
	
	UpdateThumbPosition();
}

void CSkinVerticleScrollbar::ScrollUp()
{	
	if (pList!=NULL)
	{
		pList->SendMessage(WM_VSCROLL, MAKELONG(SB_LINEUP,0),NULL);
	}
	else
	{
		pEdit->SendMessage(WM_VSCROLL, MAKELONG(SB_LINEUP,0),NULL);
	}
	
	UpdateThumbPosition();
}

void CSkinVerticleScrollbar::ScrollDown()
{	

	if (pList!=NULL)
	{
		pList->SendMessage(WM_VSCROLL, MAKELONG(SB_LINEDOWN,0),NULL);
	}
	else
	{
		pEdit->SendMessage(WM_VSCROLL, MAKELONG(SB_LINEDOWN,0),NULL);
	}
	
	UpdateThumbPosition();
}

void CSkinVerticleScrollbar::UpdateThumbPosition()
{
	CRect clientRect;
	GetClientRect(&clientRect);

	double nPos ;
	double nMax ;


	if (pList!=NULL)
	{
		 nPos = pList->GetScrollPos(SB_VERT);
		 nMax = pList->GetScrollLimit(SB_VERT);
	}
	else
	{
		 nPos = pEdit->GetScrollPos(SB_VERT);
		 nMax = pEdit->GetScrollLimit(SB_VERT);
	}

	double nHeight = (clientRect.Height()-NHEIGHT*3);
	double nVar = nMax;

	dbThumbInterval = nHeight/nVar;

	double nNewdbValue = (dbThumbInterval * nPos);
	int nNewValue = (int)nNewdbValue;


	nThumbTop = NHEIGHT-1+nNewValue;

	LimitThumbPosition();

	Draw();
}


void CSkinVerticleScrollbar::Draw()
{

	CClientDC dc(this);
	CRect clientRect;
	GetClientRect(&clientRect);
	CMemDC memDC(&dc, &clientRect);
	memDC.FillSolidRect(&clientRect,  RGB(54,47,36));
	CDC bitmapDC;
	bitmapDC.CreateCompatibleDC(&dc);

	CBitmap bitmap;
		
	bitmap.LoadBitmap(IDB_SCROLL_BAR);

	CBitmap* pOldBitmap = bitmapDC.SelectObject(&bitmap);
	
	int indexX=0;
	int indexY=0;

	//span
	int nHeight = clientRect.Height();

	indexX=5*NWIDTH+5*3;
	for(int i=0; i<nHeight; i++)
	{
		memDC.BitBlt(clientRect.left,(clientRect.top)+(i),NWIDTH,1,&bitmapDC,indexX,indexY,SRCCOPY);
	}


	indexX=0;
	indexY=0;

	//uparrow
	memDC.BitBlt(clientRect.left,clientRect.top,NWIDTH,NHEIGHT,&bitmapDC,indexX,indexY,SRCCOPY);

	
	//downarrow
	indexX=NWIDTH+3;
	memDC.BitBlt(clientRect.left,nHeight-NHEIGHT,NWIDTH,NHEIGHT,&bitmapDC,indexX,indexY,SRCCOPY);
	
	int nThumbLength=GetScrollBarLength();
	//thumb
	indexX=2*NWIDTH+2*3;

	int start=clientRect.top+nThumbTop+1;
	if (start+nThumbLength>clientRect.Height()-NHEIGHT)
	{
		start=clientRect.Height()-NHEIGHT-nThumbLength;
	}
	memDC.StretchBlt(clientRect.left,start,NWIDTH,nThumbLength,&bitmapDC,indexX,indexY,NWIDTH,NHEIGHT,SRCCOPY);


	//memDC.BitBlt(clientRect.left,clientRect.top+nThumbTop,NWIDTH,NHEIGHT,&bitmapDC,indexX,indexY,SRCCOPY);
	bitmapDC.SelectObject(pOldBitmap);
	bitmap.DeleteObject();
	pOldBitmap = NULL;


}

void CSkinVerticleScrollbar::LimitThumbPosition()
{
	CRect clientRect;
	GetClientRect(&clientRect);

	if(nThumbTop+GetScrollBarLength() > (clientRect.Height()-NHEIGHT))
	{
		nThumbTop = clientRect.Height()-NHEIGHT-GetScrollBarLength()-1;
	}

	if(nThumbTop < (clientRect.top+NHEIGHT))
	{
		nThumbTop = clientRect.top+NHEIGHT-1;
	}

}

int CSkinVerticleScrollbar::GetScrollBarLength()
{
	SCROLLINFO si;
	si.cbSize = sizeof(SCROLLINFO);
	si.fMask = SIF_POS | SIF_RANGE;

	CRect clientRect;
	GetClientRect(&clientRect);

	int nThumbLength=NWIDTH;
	if (pList!=NULL)
	{
		//pList->GetScrollInfo(SB_VERT,&si);
		//nThumbLength = si.nPage*(clientRect.Height() - NHEIGHT*2)/(si.nPage+si.nMax-si.nMin);
	}

	if (pEdit!=NULL)
	{
		//pEdit->GetScrollInfo(SB_VERT,&si);
		//nThumbLength = si.nPage*(clientRect.Height() - NHEIGHT*2)/(si.nPage+si.nMax-si.nMin);
	}

	return nThumbLength;

}


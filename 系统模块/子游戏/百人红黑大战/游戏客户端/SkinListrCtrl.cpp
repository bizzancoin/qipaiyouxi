#include "Stdafx.h"
#include "SkinListCtrl.h"
#include ".\skinlistctrl.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

//////////////////////////////////////////////////////////////////////////
#define COLOR_TEXT					RGB(255,214,101)

BEGIN_MESSAGE_MAP(CSkinHeaderCtrlEx, CHeaderCtrl)
	//{{AFX_MSG_MAP(CSkinHeaderCtrlEx)
	ON_WM_PAINT()
	ON_WM_ERASEBKGND()
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

BEGIN_MESSAGE_MAP(CSkinListCtrlEx, CListCtrl)
	//{{AFX_MSG_MAP(CSkinListCtrlEx)
	ON_WM_CREATE()
	ON_WM_ERASEBKGND()
	//}}AFX_MSG_MAP
	ON_NOTIFY_REFLECT(LVN_COLUMNCLICK, OnColumnclick)
	ON_WM_MEASUREITEM_REFLECT()
END_MESSAGE_MAP()


//控件消息
BOOL CSkinHeaderCtrlEx::OnChildNotify(UINT uMessage, WPARAM wParam, LPARAM lParam, LRESULT * pLResult)
{
	//变量定义
	NMHEADER * pNMHearder=(NMHEADER*)lParam;

	//拖动消息
	if ((pNMHearder->hdr.code==HDN_BEGINTRACKA)||(pNMHearder->hdr.code==HDN_BEGINTRACKW))
	{
		//禁止拖动
		/*if (pNMHearder->iItem<(INT)m_uLockCount)
		{
			*pLResult=TRUE;
			return TRUE;
		}*/
	}

	return __super::OnChildNotify(uMessage,wParam,lParam,pLResult);
}

//重画函数
void CSkinHeaderCtrlEx::OnPaint() 
{
	CPaintDC dc(this);


	//建立缓冲图
	CRect ClientRect;
	GetClientRect(&ClientRect);
	CBitmap BufferBmp;
	BufferBmp.CreateCompatibleBitmap(&dc,ClientRect.Width(),ClientRect.Height());
	CDC BufferDC;
	BufferDC.CreateCompatibleDC(&dc);
	BufferDC.SelectObject(&BufferBmp);
	BufferDC.SetBkMode(TRANSPARENT);
	BufferDC.SelectObject(&font);
	BufferDC.SetTextColor(COLOR_TEXT);

	//绘画背景

	BITMAP map;
	CDC dcCompatibale; 
	dcCompatibale.CreateCompatibleDC(&BufferDC); 

	CBitmap * pOldBitmap=dcCompatibale.SelectObject(CBitmap::FromHandle(m_bmpTitle)); 
	m_bmpTitle.GetBitmap(&map);   

	BufferDC.StretchBlt(ClientRect.left,ClientRect.top,ClientRect.Width(),ClientRect.Height(),&dcCompatibale,
		0,0,map.bmWidth,map.bmHeight,SRCCOPY);

	//绘画列
	HDITEM HDItem;
	CRect rcItemRect;
	TCHAR szBuffer[30];

	for (int i=0;i<GetItemCount();i++)
	{
		//获取信息
		HDItem.pszText=szBuffer;
		HDItem.mask=HDI_TEXT|HDI_FORMAT;
		HDItem.cchTextMax=sizeof(szBuffer)/sizeof(szBuffer[0])-1;
		GetItemRect(i,&rcItemRect);
		GetItem(i,&HDItem);

		//绘画背景
		BufferDC.StretchBlt(rcItemRect.left,rcItemRect.top,rcItemRect.Width(),rcItemRect.Height(),&dcCompatibale,
			0,0,map.bmWidth,map.bmHeight,SRCCOPY);
		BufferDC.Draw3dRect(&rcItemRect,DFC_BUTTON,DFCS_BUTTONPUSH);
		rcItemRect.DeflateRect(6,2,6,2);

		//绘画标题头
		UINT uFormat=DT_SINGLELINE|DT_CENTER|DT_END_ELLIPSIS;
		if (HDItem.fmt&HDF_CENTER) uFormat|=DT_CENTER;
		else if (HDItem.fmt&HDF_LEFT) uFormat|=DT_LEFT;
		else if (HDItem.fmt&HDF_RIGHT) uFormat|=DT_RIGHT;

		BufferDC.DrawText(HDItem.pszText,lstrlen(HDItem.pszText),&rcItemRect,uFormat);

	}

	dcCompatibale.SelectObject(pOldBitmap);
	dcCompatibale.DeleteDC();
	//绘画界面

	dc.BitBlt(0,0,ClientRect.Width(),ClientRect.Height(),&BufferDC,0,0,SRCCOPY);
	//BufferDC.DeleteDC();
	//BufferBmp.DeleteObject();

	return;
}

//背景函数
BOOL CSkinHeaderCtrlEx::OnEraseBkgnd(CDC * pDC) 
{
	return TRUE;
}
CSkinHeaderCtrlEx::CSkinHeaderCtrlEx()
{

	//font.CreateFont(5,0,0,0,400,0,0,0,134,3,2,1,2,TEXT("宋体"));

	font.CreateFont(
		13,                        // nHeight
		0,                         // nWidth
		0,                         // nEscapement
		0,                         // nOrientation
		FW_NORMAL,                 // nWeight
		FALSE,                     // bItalic
		FALSE,                     // bUnderline
		0,                         // cStrikeOut
		ANSI_CHARSET,              // nCharSet
		OUT_DEFAULT_PRECIS,        // nOutPrecision
		CLIP_DEFAULT_PRECIS,       // nClipPrecision
		DEFAULT_QUALITY,           // nQuality
		DEFAULT_PITCH | FF_SWISS,  // nPitchAndFamily
		TEXT("宋体"));

	m_bmpTitle.LoadBitmap(IDB_LIST_TITLE);//IDB_LIST_TITLE

}
//////////////////////////////////////////////////////////////////////////


CSkinListCtrlEx::CSkinListCtrlEx()
{
	//设置变量
	m_bAscendSort=false;
}

CSkinListCtrlEx::~CSkinListCtrlEx()
{
	
}
// CSkinListCtrlEx message handlers

void CSkinListCtrlEx::DrawItem(LPDRAWITEMSTRUCT lpDrawItemStruct) 
{
	//变量定义
	CRect rcItem=lpDrawItemStruct->rcItem;
	CDC * pDC=CDC::FromHandle(lpDrawItemStruct->hDC);

	//获取属性
	INT nItemID=lpDrawItemStruct->itemID;
	INT nColumnCount=m_ListHeader.GetItemCount();

	//定制颜色
	COLORREF rcTextColor=RGB(255,255,255);
	COLORREF rcBackColor=RGB(38,29,25);
	GetItemColor(lpDrawItemStruct,rcTextColor,rcBackColor);

	//绘画区域
	CRect rcClipBox;
	pDC->GetClipBox(&rcClipBox);

	//设置环境
	pDC->SetBkColor(rcBackColor);
	pDC->SetTextColor(rcTextColor);

	//绘画子项
	for (INT i=0;i<nColumnCount;i++)
	{
		//获取位置
		CRect rcSubItem;
		GetSubItemRect(nItemID,i,LVIR_BOUNDS,rcSubItem);

		//绘画判断
		if (rcSubItem.left>rcClipBox.right) break;
		if (rcSubItem.right<rcClipBox.left) continue;

		//绘画背景
		pDC->FillSolidRect(&rcSubItem,rcBackColor);

		//绘画数据
		DrawCustomItem(pDC,lpDrawItemStruct,rcSubItem,i);
	}

	//绘画焦点
	if (lpDrawItemStruct->itemState&ODS_FOCUS)
	{
		pDC->DrawFocusRect(&rcItem);
	}

	return;
}

//绘画数据
VOID CSkinListCtrlEx::DrawCustomItem(CDC * pDC, LPDRAWITEMSTRUCT lpDrawItemStruct, CRect&rcSubItem, INT nColumnIndex)
{
	//变量定义
	INT nItemID=lpDrawItemStruct->itemID;
	WORD wImageIndex = HIWORD(lpDrawItemStruct->itemData);

	if(0 == nColumnIndex)
	{
		INT nStatusWidth = USER_STATUS_CX;
		INT nStatusHeight=m_ImageUserStatus.GetHeight();
		m_ImageUserStatus.TransDrawImage(pDC, rcSubItem.left,rcSubItem.top, nStatusWidth,nStatusHeight,
			wImageIndex*nStatusWidth,0,nStatusWidth,nStatusHeight, RGB(255,0,255));
	}
	else
	{
		//获取文字
		TCHAR szString[256]=TEXT("");
		GetItemText(lpDrawItemStruct->itemID,nColumnIndex,szString,CountArray(szString));

		//绘画文字
		rcSubItem.left+=5;
		pDC->DrawText(szString,lstrlen(szString),&rcSubItem,DT_VCENTER|DT_SINGLELINE|DT_END_ELLIPSIS);
	}

	return;
}

//控件绑定
void CSkinListCtrlEx::PreSubclassWindow() 
{
	__super::PreSubclassWindow();
	
	SetExtendedStyle(GetExtendedStyle()|LVS_EX_FULLROWSELECT|LVS_EX_SUBITEMIMAGES);
	
	//加载状态图片
	if (m_ImageUserStatus.IsNull())
	{
		m_ImageUserStatus.LoadFromResource(AfxGetInstanceHandle(),IDB_USER_STATUS_IMAGE);
	}
}

//建立消息
int CSkinListCtrlEx::OnCreate(LPCREATESTRUCT lpCreateStruct) 
{
	if (CListCtrl::OnCreate(lpCreateStruct)==-1) return -1;
	
	m_ListHeader.SubclassWindow(GetHeaderCtrl()->GetSafeHwnd());
	
	//设置滚动
	m_SkinScrollBar.InitScroolBar(this);
	
	//设置行高
	SetItemHeight(18);
	
	return 0;
}

//背景函数
BOOL CSkinListCtrlEx::OnEraseBkgnd(CDC * pDC) 
{
	if (m_ListHeader.GetSafeHwnd())
	{
		CRect ClientRect,ListHeaderRect;
		GetClientRect(&ClientRect);
		m_ListHeader.GetWindowRect(&ListHeaderRect);
		ClientRect.top=ListHeaderRect.Height();
		pDC->FillSolidRect(&ClientRect,GetBkColor());
	}

	return TRUE;
	
	return CListCtrl::OnEraseBkgnd(pDC);
}

//插入列表
void CSkinListCtrlEx::InserUser(sUserInfo & UserInfo)
{
	
	if (FindUser(UserInfo.strUserName))
	{
		UpdateUser(UserInfo);
		return;
	}
	
	//变量定义
	WORD wListIndex=0;
	WORD wColumnCount=1;
	TCHAR szBuffer[128]=TEXT("");
	//游戏玩家
	INT nItemIndex=InsertItem(GetItemCount(),TEXT(""));
	
	//玩家姓名
	myprintf(szBuffer,CountArray(szBuffer),TEXT("%s"),UserInfo.strUserName);
	SetItem(nItemIndex,wColumnCount++,LVIF_TEXT,szBuffer,0,0,0,0);

	//玩家金币
	myprintf(szBuffer,CountArray(szBuffer),TEXT("%I64d"),UserInfo.lUserScore);
	SetItem(nItemIndex,wColumnCount++,LVIF_TEXT,szBuffer,0,0,0,0);
	
	//总输赢成绩
	myprintf(szBuffer,CountArray(szBuffer),TEXT("%I64d"),UserInfo.lWinScore);
	SetItem(nItemIndex,wColumnCount++,LVIF_TEXT,szBuffer,0,0,0,0);	
	
	//图片 机器人标识
	DWORD dwItemData = MAKELONG(UserInfo.wAndrod, UserInfo.wImageIndex);
	SetItemData(nItemIndex, dwItemData);
	
	return;
}

//查找玩家
bool CSkinListCtrlEx::FindUser(CString lpszUserName)
{
	for(int i=0;i<GetItemCount();i++)
	{
		CString strName=GetItemText(i,1);

		if(strName==lpszUserName) return true;
	}

	return false;
}


//删除用户
void CSkinListCtrlEx::DeleteUser(sUserInfo & UserInfo)
{
	//构造变量
	LVFINDINFO lvFindInfo;
	ZeroMemory( &lvFindInfo, sizeof( lvFindInfo ) );
	lvFindInfo.flags = LVFI_STRING;
	lvFindInfo.psz = (LPCTSTR)UserInfo.strUserName;

	//查找子项
	int nItem = -1;

	for(int i=0;i<GetItemCount();i++)
	{
		CString strName=GetItemText(i,1);

		if(strName==UserInfo.strUserName) 
		{
			nItem=i;
			break;
		}
	}

	//删除子项
	if ( nItem != -1 ) DeleteItem( nItem );
}

//更新列表
void CSkinListCtrlEx::UpdateUser( sUserInfo & UserInfo )
{
	//构造变量
	LVFINDINFO lvFindInfo;
	ZeroMemory( &lvFindInfo, sizeof( lvFindInfo ) );
	lvFindInfo.flags = LVFI_STRING;
	lvFindInfo.psz = (LPCTSTR)UserInfo.strUserName;

	//查找子项
	int nItem = -1;


	for(int i=0;i<GetItemCount();i++)
	{
		CString strName=GetItemText(i,1);

		if(strName==UserInfo.strUserName) 
		{
			nItem=i;
			break;
		}
	}

	//删除子项
	if ( nItem != -1 ) 
	{
		TCHAR szBuffer[128]=TEXT("");

		//玩家金币
		myprintf(szBuffer,CountArray(szBuffer),TEXT("%I64d"),UserInfo.lUserScore);
		SetItem(nItem,2,LVIF_TEXT,szBuffer,0,0,0,0);

		//总输赢
		myprintf(szBuffer,CountArray(szBuffer),TEXT("%I64d"),UserInfo.lWinScore);
		SetItem(nItem,3,LVIF_TEXT,szBuffer,0,0,0,0);

		Invalidate(FALSE);
	}
}

//清空列表
void CSkinListCtrlEx::ClearAll()
{
	DeleteAllItems();
}

void CSkinListCtrlEx::ReSetLoc( int cx, int cy)
{
	CRect windowRect,clientRect;
	GetWindowRect(&windowRect);

	GetClientRect(&clientRect);

	//窗口位置
	CRect rcArce;
	SystemParametersInfo(SPI_GETWORKAREA,0,&rcArce,SPIF_SENDCHANGE);

	//读取位置
	CSize SizeRestrict(cx,cy);
	//正常位置
	CRect rcNormalSize;			

	//位置调整
	SizeRestrict.cx=__min(rcArce.Width(),SizeRestrict.cx);
	SizeRestrict.cy=__min(rcArce.Height(),SizeRestrict.cy);

	//移动窗口
	rcNormalSize.top=(rcArce.Height()-SizeRestrict.cy)/2;
	rcNormalSize.left=(rcArce.Width()-SizeRestrict.cx)/2;
	rcNormalSize.right=rcNormalSize.left+SizeRestrict.cx;
	rcNormalSize.bottom=rcNormalSize.top+SizeRestrict.cy;

}

//获取颜色
VOID CSkinListCtrlEx::GetItemColor(LPDRAWITEMSTRUCT lpDrawItemStruct, COLORREF&crColorText, COLORREF&crColorBack)
{
	//定制变量
	WORD wAndroid = LOWORD(lpDrawItemStruct->itemData);

	//颜色定制
	if (lpDrawItemStruct->itemState&ODS_SELECTED)
	{
		//选择颜色
		crColorText=RGB(255,234,2);
		crColorBack=RGB(85,72,53);
	}
	else if(1 == wAndroid)
	{
		//机器颜色
		crColorText=RGB(255,255,255);
		crColorBack=RGB(255,0,0);
	}
	else
	{
		//默认颜色
		crColorText=RGB(255,255,255);
		crColorBack=RGB(38,29,25);
	}

	return;
}

//排列函数
INT CALLBACK CSkinListCtrlEx::SortFunction(LPARAM lParam1, LPARAM lParam2, LPARAM lParamList)
{
	//变量定义
	tagSortInfo * pSortInfo=(tagSortInfo *)lParamList;
	CSkinListCtrlEx * pSkinListCtrl=pSortInfo->pSkinListCtrl;

	WORD columnClicked= pSortInfo->wColumnIndex;
	//数据排序
	return pSkinListCtrl->SortItemData(lParam1,lParam2,pSortInfo->wColumnIndex,pSortInfo->bAscendSort);

}

//点击消息
VOID CSkinListCtrlEx::OnColumnclick(NMHDR * pNMHDR, LRESULT * pResult)
{
	//变量定义
	NM_LISTVIEW * pNMListView=(NM_LISTVIEW *)pNMHDR;

	//变量定义
	tagSortInfo SortInfo;
	ZeroMemory(&SortInfo,sizeof(SortInfo));

	//设置变量
	SortInfo.pSkinListCtrl=this;
	SortInfo.bAscendSort=m_bAscendSort;
	SortInfo.wColumnIndex=pNMListView->iSubItem;

	//设置变量
	m_bAscendSort=!m_bAscendSort;

	int len=this->GetItemCount();
	for(int i=0;i<len;i++)
	{
		this->SetItemData(i,(DWORD_PTR)i);
	}
	//排列列表
	SortItems(SortFunction,(LPARAM)&SortInfo);

	return;
}

//排列数据
INT CSkinListCtrlEx::SortItemData(LPARAM lParam1, LPARAM lParam2, WORD wColumnIndex, bool bAscendSort)
{
	//获取数据
	TCHAR szBuffer1[256]=TEXT("");
	TCHAR szBuffer2[256]=TEXT("");
	GetItemText((INT)lParam1,wColumnIndex,szBuffer1,CountArray(szBuffer1));
	GetItemText((INT)lParam2,wColumnIndex,szBuffer2,CountArray(szBuffer2));

	if(wColumnIndex==2||wColumnIndex==3)
	{
		int nData1=_wtoi(szBuffer1);
		int nData2=_wtoi(szBuffer2);

		INT nResult=0;
		if(nData1>nData2)
		{
			nResult=1;
		}
		if(nData1<nData2)
		{
			nResult=-1;
		}
		return (bAscendSort==true)?nResult:-nResult;
	}


	//对比数据
	INT nResult=lstrcmp(szBuffer1,szBuffer2);
	return (bAscendSort==true)?nResult:-nResult;
}

void CSkinListCtrlEx::MeasureItem(LPMEASUREITEMSTRUCT lpMeasureItemStruct)
{
   lpMeasureItemStruct->itemHeight = 20;
}

//设置行高
void CSkinListCtrlEx::SetItemHeight(UINT nHeight)
{
	CRect rcWin;
	GetWindowRect(&rcWin);
	WINDOWPOS wp;
	wp.hwnd = m_hWnd;
	wp.cx = rcWin.Width();
	wp.cy = rcWin.Height();
	wp.flags = SWP_NOACTIVATE | SWP_NOMOVE | SWP_NOOWNERZORDER | SWP_NOZORDER;
	SendMessage(WM_WINDOWPOSCHANGED, 0, (LPARAM)&wp);
}


////////////////////////////////////////////////////////////////////////////////////////////////////////

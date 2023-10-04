#include "StdAfx.h"
#include "Resource.h"
#include "SkinButtonEx.h"

//构造函数
CSkinButtonEx::CSkinButtonEx(void)
{
}

//析构函数
CSkinButtonEx::~CSkinButtonEx(void)
{
}

//绑定函数
VOID CSkinButtonEx::PreSubclassWindow()
{
	return ;
}

//绘画函数
VOID CSkinButtonEx::DrawItem(LPDRAWITEMSTRUCT lpDrawItemStruct)
{
	//获取位置
	CRect rcClient;
	GetClientRect(&rcClient);

	//变量定义
	CDC CdcMdc;
	HDC hDC=lpDrawItemStruct->hDC;
	CDC * pDC=CDC::FromHandle(lpDrawItemStruct->hDC);

	//按钮状态
	bool bDisable=((lpDrawItemStruct->itemState&ODS_DISABLED)!=0);
	bool bButtonDown=((lpDrawItemStruct->itemState&ODS_SELECTED)!=0);

	//加载资源
	CBitmap ImageBuffer;
	CBitImage ImageButton;
	if ((m_hResInstance!=NULL)&&(m_pszResource!=NULL))
	{
		//加载资源
		ImageBuffer.LoadBitmap(m_pszResource);
		ImageButton.LoadFromResource(m_hResInstance, m_pszResource);
	}

	//创建 DC
	if (!CdcMdc.CreateCompatibleDC(pDC)) ASSERT(FALSE);

	//绘画界面
	if (ImageButton.IsNull()==false)
	{
		INT nImagePos=0;
		INT nPartWidth=ImageButton.GetWidth()/5;
		INT nPartHeight=ImageButton.GetHeight();

		//计算位置
		if (bDisable==true) nImagePos=nPartWidth*4;
		if ((bDisable==false)&&(bButtonDown==true)) nImagePos=nPartWidth;
		if ((bDisable==false)&&(bButtonDown==false)&&(m_bHovering==true)) nImagePos=nPartWidth*3;

		//绘画界面
		CdcMdc.SetBkMode(TRANSPARENT);
		CdcMdc.SelectObject(&ImageBuffer);

		//透明绘画
		pDC->TransparentBlt(0, 0, nPartWidth, nPartHeight, &CdcMdc, nImagePos, 0, nPartWidth, nPartHeight, RGB(255, 0, 255));
	}

	DrawButtonText(pDC,lpDrawItemStruct->itemState);

	return ;
}

//绘画文字
VOID CSkinButtonEx::DrawButtonText(CDC * pDC, UINT uItemState)
{
	//获取文字
	CString strText;
	GetWindowText(strText);

	//绘画文字
	if (strText.IsEmpty()==FALSE)
	{
		//获取位置
		CRect rcClient;
		GetClientRect(&rcClient);

		//按钮状态
		bool bDisable=((uItemState&ODS_DISABLED)!=0);
		bool bButtonDown=((uItemState&ODS_SELECTED)!=0);

		//设置环境
		pDC->SetBkMode(TRANSPARENT);
		pDC->SetTextColor((bDisable==true)?GetSysColor(COLOR_GRAYTEXT):m_crButtonText);

		//绘画文字
		rcClient.top+=(bButtonDown==true)?3:1;
		pDC->DrawText(strText,strText.GetLength(),rcClient,DT_CENTER|DT_VCENTER|DT_SINGLELINE|DT_END_ELLIPSIS);
	}

	return;
}

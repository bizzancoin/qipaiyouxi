#pragma once

#include "Stdafx.h"
#include "SkinVerticleScrollbar.h"
#include "SkinScrollBarEx.h"

class CMyEdit : public CRichEditCtrl
{
DECLARE_DYNAMIC(CMyEdit)


public:
CMyEdit();
virtual ~CMyEdit();

//组件变量
protected:		
	CSkinScrollBarEx			m_SkinScrollBar;				//滚动条类

protected:
DECLARE_MESSAGE_MAP()
public:
//设置文本框背景色
void			SetBackColor(COLORREF rgb);
//设置文本框的字体颜色
void			SetTextColor(COLORREF rgb);
//设置字体
void			SetTextFont(const LOGFONT &lf);
//获取当前背景色
COLORREF		GetBackColor(void){return m_crBackGnd;}
//获取当前文本色
COLORREF		GetTextColor(void){return m_crText;}
//获取当前字体
BOOL			GetTextFont(LOGFONT &lf);
//初始化
void			Init();
//重设位置
void			ReSetLoc( int cx, int cy);

private:
COLORREF		m_crText;
COLORREF		m_crBackGnd;
CFont			m_font;
CBrush			m_brBackGnd;

afx_msg HBRUSH CtlColor(CDC* pDC, UINT nCtlColor);
protected:
	virtual void PreSubclassWindow();
public:
	afx_msg void OnChar(UINT nChar, UINT nRepCnt, UINT nFlags);
	afx_msg void OnNcCalcSize(BOOL bCalcValidRects, NCCALCSIZE_PARAMS* lpncsp);
	afx_msg int OnCreate(LPCREATESTRUCT lpCreateStruct);
	afx_msg void OnVScroll(UINT nSBCode, UINT nPos, CScrollBar* pScrollBar);
	afx_msg BOOL OnMouseWheel(UINT nFlags, short zDelta, CPoint pt);
};


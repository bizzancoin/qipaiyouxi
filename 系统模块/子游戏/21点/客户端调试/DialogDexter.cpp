#include "StdAfx.h"
#include "DialogDexter.h"
#include "ClientConfigDlg.h"

BEGIN_MESSAGE_MAP(CDialogDexter, CDialog)
    ON_WM_VSCROLL()
    ON_WM_MOUSEWHEEL()
    ON_WM_SIZE()
END_MESSAGE_MAP()

// 构造函数
CDialogDexter::CDialogDexter(UINT nIDTemplate, int nShowMax, CClientConfigDlg *pParentWnd) : CDialog(nIDTemplate, pParentWnd)
{
    m_pParentWnd = pParentWnd;
    m_bShowScroll = false;
    m_nShowMax = nShowMax;
    m_nScrollMax = 0;
    m_nScrollPos = 0;
}

// 析构函数
CDialogDexter::~CDialogDexter()
{
}

// 调试信息
bool CDialogDexter::SendDebugMessage(UINT nMessageID, void *pData, UINT nSize)
{
    m_pParentWnd->SendDebugMessage(nMessageID, pData, nSize);
    return true;
}

// 调试信息
bool CDialogDexter::SendDebugMessage(UINT nMessageID, WORD wTableID, void *pData, UINT nSize)
{
	m_pParentWnd->SendDebugMessage(nMessageID, wTableID, pData, nSize);
	return true;
}

// 初始化窗口
BOOL CDialogDexter::OnInitDialog()
{
    // 初始化窗口
    __super::OnInitDialog();

    // 设置滚动
    CRect rect;
    GetWindowRect(rect);
    m_nScrollMax = rect.Height();
    m_bShowScroll = m_nShowMax < m_nScrollMax;

    return TRUE;
}

// 滑动条消息
void CDialogDexter::OnVScroll(UINT nSBCode, UINT nPos, CScrollBar *pScrollBar)
{
    //获取参数
    CRect rcClient;
    GetClientRect(&rcClient);

    //变量定义
    INT nLastScrollPos = m_nScrollPos;

    //移动坐标
    switch(nSBCode)
    {
    case SB_TOP:
    {
        m_nScrollPos = 0L;
        break;
    }
    case SB_BOTTOM:
    {
        m_nScrollPos = m_nScrollMax - rcClient.Height();
        break;
    }
    case SB_LINEUP:
    {
        m_nScrollPos -= 10;
        break;
    }
    case SB_PAGEUP:
    {
        m_nScrollPos -= rcClient.bottom;
        break;
    }
    case SB_LINEDOWN:
    {
        m_nScrollPos += 10;
        break;
    }
    case SB_PAGEDOWN:
    {
        m_nScrollPos += rcClient.bottom;
        break;
    }
    case SB_THUMBTRACK:
    {
        m_nScrollPos = nPos;
        break;
    }
    }

    //调整位置
    m_nScrollPos = __max(m_nScrollPos, 0L);
    m_nScrollPos = __min(m_nScrollPos, m_nScrollMax - rcClient.bottom);

    //滚动窗口
    if(nLastScrollPos != m_nScrollPos)
    {
        SetScrollPos(SB_VERT, m_nScrollPos);
        ScrollWindow(0L, nLastScrollPos - m_nScrollPos, NULL, NULL);
    }

    __super::OnVScroll(nSBCode, nPos, pScrollBar);
}

// 鼠标滑轮
BOOL CDialogDexter::OnMouseWheel(UINT nFlags, short zDelta, CPoint pt)
{
    //获取位置
    CRect rcClient;
    GetClientRect(&rcClient);

    //设置滚动
    INT nLastPos = m_nScrollPos;
    INT nMaxPos = m_nScrollMax - rcClient.bottom;
    m_nScrollPos = __max(__min(m_nScrollPos - (zDelta / WHEEL_DELTA * 20), nMaxPos), 0L);

    //滚动窗口
    SetScrollPos(SB_VERT, m_nScrollPos);
    ScrollWindow(0, nLastPos - m_nScrollPos, NULL, NULL);

    return TRUE;
}

// 窗口变化
void CDialogDexter::OnSize(UINT nType, int cx, int cy)
{
    // 基类执行
    __super::OnSize(nType, cx, cy);

    if(m_bShowScroll)
    {
        // 设置滑动条
        SCROLLINFO ScrollInfo;
        ScrollInfo.cbSize = sizeof(SCROLLINFO);
        ScrollInfo.fMask = SIF_ALL;
        ScrollInfo.nMin = 0;
        ScrollInfo.nMax = m_nScrollMax;
        ScrollInfo.nPage = cy;
        ScrollInfo.nPos = 0;
        SetScrollInfo(SB_VERT, &ScrollInfo, TRUE);
    }
}

void CDialogDexter::OnTableQuery()
{
}

void CDialogDexter::SetTableCount(WORD wTableCount)
{

}


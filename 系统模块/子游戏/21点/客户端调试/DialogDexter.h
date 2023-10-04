#pragma once

class CClientConfigDlg;

// 窗口类
class CDialogDexter : public CDialog
{
public:
    CClientConfigDlg			*m_pParentWnd;						// 消息窗口

    // 滑动变量
public:
    bool						m_bShowScroll;						// 显示滚动
    int							m_nShowMax;							// 最大显示
    int							m_nScrollMax;						// 最大位置
    int							m_nScrollPos;						// 滑动位置

    // 类函数
public:
    // 构造函数
    CDialogDexter(UINT nIDTemplate, int nShowMax, CClientConfigDlg *pParentWnd = NULL);
    // 析构函数
    ~CDialogDexter();


    // 实现函数
public:
    //初始化窗口
    virtual BOOL OnInitDialog();
    // 滑动消息
    afx_msg void OnVScroll(UINT nSBCode, UINT nPos, CScrollBar *pScrollBar);
    // 鼠标滑轮
    afx_msg BOOL OnMouseWheel(UINT nFlags, short zDelta, CPoint pt);
    // 窗口变化
    afx_msg void OnSize(UINT nType, int cx, int cy);
    // 消息函数
    virtual bool OnDebugMessage(WORD nMessageID, WORD wTableID, void *pData, WORD nSize) { return false; };
    // 调试信息
    virtual bool SendDebugMessage(UINT nMessageID, void *pData = NULL, UINT nSize = 0);
	// 调试信息
	virtual bool SendDebugMessage(UINT nMessageID, WORD wTableID, void *pData = NULL, UINT nSize = 0);

	virtual void OnTableQuery();

	virtual void SetTableCount(WORD	wTableCount);



	//获取区域调试位置描述
	CString GetAreaCtrlPosDesc(BYTE cbCtrlPosIndex);

    DECLARE_MESSAGE_MAP()
};
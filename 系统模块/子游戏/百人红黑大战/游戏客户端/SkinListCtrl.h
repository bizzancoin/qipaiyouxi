#if !defined(AFX_SKINHEADERCTRL_H__5A55D5B6_CD01_4049_943B_36EAC3B4B976__INCLUDED_)
#define AFX_SKINHEADERCTRL_H__5A55D5B6_CD01_4049_943B_36EAC3B4B976__INCLUDED_

#pragma once

#include "resource.h"

#include "SkinHorizontalScrollbar.h"
#include "SkinVerticleScrollbar.h"

#include "SkinScrollBarEx.h"
//////////////////////////////////////////////////////////////////////////
class CSkinListCtrlEx;

struct sUserInfo
{
	//玩家信息
	CString							strUserName;						//玩家帐号
	LONGLONG						lUserScore;							//玩家金币
	LONGLONG						lWinScore;							//输赢金币
	WORD							wImageIndex;						//位图索引
	WORD							wAndrod;							//机器标识
};

//排序信息
struct tagSortInfo
{
	bool							bAscendSort;						//升序标志
	WORD							wColumnIndex;						//列表索引
	CSkinListCtrlEx *				pSkinListCtrl;						//列表控件
};


//换皮肤列表头
class CSkinHeaderCtrlEx : public CHeaderCtrl
{
	//消息函数
public:
	CSkinHeaderCtrlEx();
	CBitmap m_bmpTitle;
	CFont font;

	//控件消息
	virtual BOOL OnChildNotify(UINT uMessage, WPARAM wParam, LPARAM lParam, LRESULT * pLResult);

protected:
	//{{AFX_MSG(CSkinHeaderCtrlEx)
	afx_msg void OnPaint();
	afx_msg BOOL OnEraseBkgnd(CDC * pDC);
	
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
public:
//	virtual void DrawItem(LPDRAWITEMSTRUCT /*lpDrawItemStruct*/);
};

//////////////////////////////////////////////////////////////////////////

//换皮肤列表
class CSkinListCtrlEx : public CListCtrl
{
	
	//数据变量
protected:
	bool						m_bAscendSort;					//升序标志
	//变量定义
public:
	CSkinScrollBarEx			m_SkinScrollBar;				//滚动条类
	CSkinHeaderCtrlEx			m_ListHeader;					//列表头
	//CImageList					m_ImageUserStatus;				//状态位图
	CBitImage					m_ImageUserStatus;					//状态位图					

	//组件变量
protected:
	//CSkinVerticleScrollbar		m_SkinVerticleScrollbar;		//垂直滚动
	//CSkinHorizontalScrollbar	m_SkinHorizontalScrollbar;		//水平滚动
	//函数定义
public:
	//构造函数
	CSkinListCtrlEx();
	//析构函数
	virtual ~CSkinListCtrlEx();

	//插入列表
	void InserUser(sUserInfo & UserInfo);
	//查找玩家
	bool FindUser(CString lpszUserName);
	//删除用户
	void DeleteUser(sUserInfo & UserInfo);
	//更新列表
	void UpdateUser( sUserInfo & UserInfo );
	//清空列表
	void ClearAll();
	//重设位置
	void ReSetLoc( int cx, int cy);
	//设置行高
	void SetItemHeight(UINT nHeight);

	//绘画控制
protected:
	//获取颜色
	virtual VOID GetItemColor(LPDRAWITEMSTRUCT lpDrawItemStruct, COLORREF & crColorText, COLORREF & crColorBack);
	//绘画数据
	virtual VOID DrawCustomItem(CDC * pDC, LPDRAWITEMSTRUCT lpDrawItemStruct, CRect & rcSubItem, INT nColumnIndex);

	//重载函数
protected:
	//控件绑定
	virtual void PreSubclassWindow();
	virtual void DrawItem(LPDRAWITEMSTRUCT lpDrawItemStruct);

	//静态函数
protected:
	//排列函数
	static INT CALLBACK SortFunction(LPARAM lParam1, LPARAM lParam2, LPARAM lParamList);

	//排列数据
	virtual INT SortItemData(LPARAM lParam1, LPARAM lParam2, WORD wColumnIndex, bool bAscendSort);

	//消息映射
protected:
	//点击列表
	VOID OnColumnclick(NMHDR * pNMHDR, LRESULT * pResult);


	//消息函数
protected:
	//{{AFX_MSG(CSkinHeaderCtrlEx)
	afx_msg int OnCreate(LPCREATESTRUCT lpCreateStruct);
	afx_msg BOOL OnEraseBkgnd(CDC * pDC);
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
public:
	afx_msg void MeasureItem(LPMEASUREITEMSTRUCT lpMeasureItemStruct);
};

//////////////////////////////////////////////////////////////////////////

#endif

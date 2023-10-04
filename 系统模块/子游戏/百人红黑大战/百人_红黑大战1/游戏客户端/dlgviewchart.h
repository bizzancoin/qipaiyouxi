#pragma once
#include "resource.h"
#include "stdafx.h"
#include "gamelogic.h"
//操作结果
enum enOperateResult
{
	enOperateResult_NULL,
	enOperateResult_Win,
	enOperateResult_Lost
};

//记录信息
struct tagClientGameRecord
{
	enOperateResult					enOperateFlags;						//操作标识
	BYTE							cbPlayerCount;						//闲家点数
	BYTE							cbBankerCount;						//庄家点数
	BYTE							cbKingWinner;						//天王赢家
	bool							bPlayerTwoPair;						//对子标识
	bool							bBankerTwoPair;						//对子标识
};

//历史记录
#define MAX_SCORE_HISTORY			250									//历史个数

//////////////////////////////////////////////////////////////////////////////////////
class CDlgViewChart : public CDialog
{
	//历史信息
public:
	LONGLONG						m_lMeStatisticScore;				//游戏成绩
	tagClientGameRecord				m_TraceGameRecordArray[MAX_SCORE_HISTORY];		//路单记录
	tagClientGameRecord				m_GameRecordArray[MAX_SCORE_HISTORY];				//结果记录
	int								m_TraceGameRecordCount;				//路单数目
	int								m_GameRecordCount;					//记录数目
	int								m_nRecordFirst;						//开始记录
	int								m_nRecordLast;						//最后记录
	int								m_nRecordCol;						//记录列数
	bool							m_bFillTrace[6][MAX_SCORE_HISTORY];				//填充标识

	//资源变量
protected:
	CBitImage						m_ImageBack;						//背景图片
	CPngImage						m_PngPlayerFlag;					//闲家图片
	CPngImage						m_PngPlayerEXFlag;					//闲家图片
	CPngImage						m_PngBankerFlag;					//庄家图片
	CPngImage						m_PngBankerEXFlag;					//庄家图片
	CPngImage						m_PngTieFlag;						//平家图片
	CPngImage						m_PngTieEXFlag;						//平家图片
	CPngImage						m_PngTwopairFlag;					//平家图片

	//控件变量
protected:
	CSkinButton						m_btClose;							//关闭按钮
	CGameLogic						m_GameLogic;

	//界面函数
public:
	//更新界面
	void UpdateChart(){InvalidateRect(NULL);}
	//绘画百分比
	void DrawPrecent(CDC *pDC);
	//绘画表格
	void DrawChart(CDC *pDC);
	//艺术字体
	void DrawTextString(CDC * pDC, LPCTSTR pszString, COLORREF crText, COLORREF crFrame, int nXPos, int nYPos);

	//信息接口
public:
	//设置结果
	void SetGameRecord(const tagClientGameRecord &ClientGameRecord);
	//设置结果
	void SetRecordCol(int cbRecordCol){m_nRecordCol = cbRecordCol;}
	
public:
	CDlgViewChart(); 
	virtual ~CDlgViewChart();


protected:
	virtual void DoDataExchange(CDataExchange* pDX);

	DECLARE_DYNAMIC(CDlgViewChart)
	DECLARE_MESSAGE_MAP()
public:
	virtual BOOL OnInitDialog();
	afx_msg void OnPaint();
	afx_msg void OnLButtonDown(UINT nFlags, CPoint point);
	afx_msg BOOL OnEraseBkgnd(CDC* pDC);
};

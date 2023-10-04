#ifndef GAME_CLIENT_VIEW_HEAD_FILE
#define GAME_CLIENT_VIEW_HEAD_FILE

#pragma once

#include "Stdafx.h"
#include "CardControl.h"
#include "RecordGameList.h"
#include "GameLogic.h"
#include "DlgViewChart.h"
#include "ClientControl.h"
#include "MessageTipDlg.h"
#include "SkinListCtrl.h"
#include "MyEdit.h"
#include "BankTipsDlg.h"
#include "SkinButtonEx.h"
//////////////////////////////////////////////////////////////////////////

//筹码定义
#define BET_COUNT					6									//筹码数目
#define JETTON_RADII				68									//筹码半径

//消息定义
#define IDM_PALY_BET				WM_USER+200							//加住信息
#define IDM_APPLY_BANKER			WM_USER+201							//申请信息
#define IDM_SUPERROB_BANKER			WM_USER+211							//超级抢庄
#define IDM_PLAY_SOUND				WM_USER+202							//申请信息
#define IDM_GAME_OPTIONS			WM_USER+203							//游戏设置消息	
#define IDM_CHAT_MESSAGE			WM_USER+208							//游戏聊天消息	
#define WM_SET_CAPTION				WM_USER+209
#define IDM_GAME_SOUND				WM_USER+210							//游戏声音

//索引定义
#define INDEX_PLAYER				0									//闲家索引
#define INDEX_BANKER				1									//庄家索引


//路单水平个数
#define NORMAL_RECORD_COL_COUNT      27								// 正常模式下记录的路单列数
#define ZOOMED_RECORD_COL_COUNT      40								// 全屏模式下记录的路单列数

//记录数目
#define MAX_RECORD_COL_COUNT            80                         // 最大记录的路单列数
#define MAX_RECORD_SUM					250                        // 最大记录路单个数
//////////////////////////////////////////////////////////////////////////
//结构定义

//筹码信息
struct tagBetInfo
{
	int								nXPos;								//筹码位置
	int								nYPos;								//筹码位置
	BYTE							cbBetIndex;							//筹码索引
};

//选取闪动信息
struct tagFlashInfo
{
	BYTE							cbFlashArea;					//显示区域
	int								nFlashAreaAlpha;				//显示透明度
	bool							bFlashAreaAlpha;				//是否显示
};

enum enFlexMode
{
	enFlexNULL,
	enFlexBetTip,
	enFlexDealCrad,
	enFlexGameEnd,
};

//筹码数组
typedef CWHArray<tagBetInfo,tagBetInfo&> CBetInfoArray;

struct tagRecordResult
{
	int resultIndex[6];
};

typedef CWHArray<tagRecordResult> RECORDRESULT;

//////////////////////////////////////////////////////////////////////////

//游戏视图
class CGameClientView : public CGameFrameViewGDI
{
	//限制信息
protected:
	LONGLONG						m_lMeMaxScore;						//最大下注
    LONGLONG						m_lAreaLimitScore;					//区域限制


	//下注数
protected:
	LONGLONG						m_lAllBet[AREA_MAX];				//总下注
	LONGLONG						m_lPlayBet[AREA_MAX];				//玩家下注
	LONGLONG						m_lAllPlayBet[GAME_PLAYER][AREA_MAX];//所有玩家下注

	//位置信息
protected:
	CWHArray<CRect>					m_ArrayBetArea[AREA_MAX];			//下注区域
	CPoint							m_ptBetFrame[AREA_MAX];				//下注显示位置
	CSize							m_sizeWin;							//窗口大小
	BYTE							m_cbJetArea;						//下注区域
	bool							m_bFlashResult;						//显示结果

	//扑克信息
protected:	
	BYTE							m_cbCardCount[2];					//扑克数目
    BYTE							m_cbTableCardArray[2][3];			//桌面扑克

	//动画变量
protected:
	int								m_nDealMove;						//发牌步数
	int								m_nDealIndex;						//发牌索引
	CPoint							m_ptDispatchCard;					//发牌位置
	CCardControl					m_DispatchCard;						//发牌扑克

	//伸缩动画
protected:
	enFlexMode						m_enFlexMode;						//伸缩索引
	int								m_nFlexMove;						//伸缩步数
	bool							m_bFlexShow;						//显示
	CPoint							m_ptFlexBeing;						//移动位置
	CPoint							m_ptFlexMove;						//移动位置
	CPngImage*						m_pImageFlex;						//移动图片

	//历史信息
protected:
	LONGLONG						m_lMeStatisticScore;				//游戏成绩
	tagClientGameRecord				m_GameRecordArrary[MAX_RECORD_SUM]; //游戏记录
	int								m_nRecordFirst;						//开始记录
	int								m_nRecordLast;						//最后记录
	int								m_nRecordHead;						//

	//状态变量
protected:
	LONG							m_nWinCount;						//赢数量
	LONG							m_nLoseCount;						//输数量
	BYTE							m_cbGameStatus;						//游戏状态
	WORD							m_wMeChairID;						//我的位置
	LONGLONG						m_lCurrentBet;						//当前筹码
	CString							m_strDispatchCardTips;				//发牌提示
	bool							m_bShowChangeBanker;				//轮换庄家
	bool							m_bNeedSetGameRecord;				//完成设置
	bool							m_bEnableBet;

	//闪动框
protected:
	CWHArray<BYTE>					m_ArrayFlashArea;					//胜利玩家
	int								m_nFlashAreaAlpha;					//胜利显示
	bool							m_bFlashAreaAlpha;					//胜利显示
	CWHArray<tagFlashInfo>			m_ArrayCurrentFlash;				//选中区域

	//底部游戏历史记录
protected:
	tagClientGameRecord				m_LefeGameRecordArray[MAX_RECORD_SUM];		//路单记录
	tagClientGameRecord				m_RightGameRecordArray[MAX_RECORD_SUM];		//结果记录
	int								m_LefeGameRecordCount;				//路单数目
	int								m_RightGameRecordCount;				//记录数目
	bool							m_bFillTrace[6][MAX_RECORD_SUM];		//填充标识
	CPngImage						m_PngPlayerFlag;					//闲家图片
	CPngImage						m_PngPlayerFlagTowPair;
	CPngImage						m_PngPlayerEXFlag;					//闲家图片
	CPngImage						m_PngPlayerEXFlagTowPair;
	CPngImage						m_PngBankerFlag;					//庄家图片
	CPngImage						m_PngBankerFlagTowPair;
	CPngImage						m_PngBankerEXFlag;					//庄家图片
	CPngImage						m_PngBankerEXFlagTowPair;
	CPngImage						m_PngTieFlag;						//平家图片
	CPngImage						m_PngTieEXFlag;						//平家图片
	CPngImage						m_PngTwopairFlag;					//平家图片
	int								m_nScoreHead;						//成绩位置
	int								m_nHeadCol;							//记录首列
	int								m_nTotalCol;						//记录总列

	RECORDRESULT					m_RecordResult;
	//庄家信息
protected:	
	WORD							m_wBankerUser;						//当前庄家
	WORD							m_wBankerTime;						//做庄次数
	LONGLONG						m_lBankerScore;						//庄家积分
	LONGLONG						m_lBankerWinScore;					//庄家成绩	
	LONGLONG						m_lBankerWinTempScore;				//庄家成绩[零时保存]
	bool							m_bEnableSysBanker;					//系统做庄	
	WORD							m_wCurSuperRobBankerUser;			//当前超级抢庄玩家
	WORD							m_wCurSuperRobBankerUserSwitchView;	//当前超级抢庄玩家(视图VIEW chairID)
	CURRENT_BANKER_TYPE				m_typeCurrentBanker;				//当前庄家类型

	//当局成绩
public:
	LONGLONG						m_lPlayScore[AREA_MAX];				//玩家输赢
	LONGLONG						m_lPlayAllScore;					//玩家总输赢
	LONGLONG						m_lRevenue;							//当局税收
	LONGLONG						m_lBankerCurGameScore;				//当局庄家得分

	//结束动画
public:
	int								m_nWinShowArea;						//赢动画区域
	int								m_nWinShowIndex[3];					//赢动画索引

	//数据变量
protected:
	CPoint							m_ptBetNumber[AREA_MAX];			//数字位置
	CPoint							m_ptAllBetNumber[AREA_MAX];			//数字位置
	CBetInfoArray					m_BetInfoArray[AREA_MAX];			//筹码数组
	CRect							m_rcXian;							//闲家区域
	CRect							m_rcPing;							//平区域
	CRect							m_rcZhuang;							//庄家区域
	CRect							m_rcXianTian;						//闲天王区域
	CRect							m_rcZhuangTian;						//庄天王区域
	CRect							m_rcTongDui;						//同点平区域
	CRect							m_rcXianDui;							//闲对子区域
	CRect							m_rcZhuangDui;							//庄对子区域
	CRect						    m_RectUserList;						//列表位置
	CRect						    m_RectChartDisplay;					//聊天位置
	
	

	//控件变量
public:
	CSkinButton						m_btBet100;							//筹码按钮
	CSkinButton						m_btBet1000;						//筹码按钮
	CSkinButton						m_btBet10000;						//筹码按钮
	CSkinButton						m_btBet100000;						//筹码按钮
	CSkinButton						m_btBet1000000;						//筹码按钮
	CSkinButton						m_btBet5000000;						//筹码按钮
	CSkinButton						m_btBet10000000;					//筹码按钮
	CSkinButton						m_btViewChart;						//查看路子
	
	CSkinButtonEx					m_btApplyBanker;					//申请庄家
	CSkinButtonEx					m_btCancelBanker;					//取消庄家
	CSkinButtonEx					m_btSuperRobBanker;					//超级抢庄

	CSkinButton						m_btScoreMoveL;						//移动成绩
	CSkinButton						m_btScoreMoveR;						//移动成绩

	CSkinButton						m_btValleysUp;						//按钮
	CSkinButton						m_btValleysDown;					//按钮
	CSkinButton						m_btOption;							//设置按钮
	CSkinButton						m_btMin;							//最小化按钮
	CSkinButton						m_btClose;							//关闭按钮
	CSkinButton						m_btMax;							//最大化按钮
	CSkinButton						m_btRestore;						//恢复按钮
	CSkinButton						m_btBank;							//银行按钮
	CSkinButton						m_btSound;							//声音按钮
	CSkinButton						m_btSend;							//发送聊天

	CButton							m_btOpenAdmin;


	//字体资源
public:
	CDFontEx						m_FontValleysListOne;				//上庄列表字体一
	CDFontEx						m_FontValleysListTwo;				//上庄列表字体二
	CDFontEx						m_FontCaption;
	CString							m_strCaption;

	//控件变量
public:
	INT								m_nShowValleyIndex;					//显示上庄列表
	CWHArray<WORD>					m_ValleysList;						//上庄列表			
	CCardControl					m_CardControl[2];					//扑克控件	
	CGameLogic						m_GameLogic;						//游戏逻辑
	CDlgViewChart					m_DlgViewChart;						//查看路子
	CSkinListCtrlEx                 m_UserList;							//列表控件
	CRichEditMessage				m_ChatDisplay;						//显示控件
	CEdit							m_ChatInput;						//聊天输入
	CBrush							m_brush;							//画刷背景
	DWORD							m_dwChatTime;

	//界面变量
protected:
	CBitImage						m_ImageViewFill;
	CPngImage						m_ImageHistoryMid;
	CPngImage						m_ImageHistoryFront;
	CPngImage						m_ImageHistoryBack;

	CPngImage						m_ImageViewBack;					//背景位图
	CPngImage						m_ImageChipInfo;					//背景下注信息
	CPngImage						m_ImagePlayerResultInfo;               
	CPngImage						m_ImageBankerResultInfo;                 //背景庄家信息

	CPngImage						m_ImageViewBackJB;					//背景位图
	CPngImage						m_ImageWinFlags;					//标志位图
	CPngImage						m_ImageBetView;						//筹码视图
	CPngImage						m_ImageScoreBack;					//数字视图
	CPngImage						m_ImageScoreNumber;					//数字视图
	CPngImage						m_ImageMeScoreBack;					//数字视图
	CPngImage						m_ImageMeScoreNumber;				//数字视图
	CPngImage						m_ImgaeGameTimeCount;				//各个区域开出来的次数

	CPngImage						m_ImageSuperRobBanker;              //超级抢庄
	CPngImage						m_ImageSuperRobBankerUserFrame;     //超级抢庄用户框架

	//边框资源
protected:
	CPngImage						m_ImageFrame[AREA_MAX];				//边框图片
	CPngImage						m_ImageGameFrame[8];				//游戏框架	
	CPngImage						m_ImageUserBack;					//游戏玩家列表
	CPngImage						m_ImageChatBack;					//游戏消息框

	CPngImage						m_ImageMeBanker;					//切换庄家
	CPngImage						m_ImageChangeBanker;				//切换庄家
	CPngImage						m_ImageNoBanker;					//切换庄家

	//伸缩动画
protected:
	CPngImage						m_ImageBetTip;						//下注提示
	CPngImage						m_ImageGameEnd;						//成绩背景
	CPngImage						m_ImageDealBack;					//发牌背景

	//结束资源
protected:
	CPngImage						m_ImageGamePoint;					//点数图片
	CPngImage						m_ImageGameEndMyScore;				//玩家结束积分
	CPngImage						m_ImageGameEndAllScore;				//玩家结束积分
	CPngImage						m_ImageGameEndPoint;				//结束界面点数

	CPngImage						m_ImageWinType;						//输赢类型
	CPngImage						m_ImageWinXian;						//闲输
	CPngImage						m_ImageWinZhuang;					//庄输


	//界面变量
protected:
	CPngImage						m_ImageBrandBoxRight;				//牌盒右

	CPngImage						m_ImageTimeNumber;					//时间数字
	CPngImage						m_ImageTimeBack;					//时间背景
	CPngImage						m_ImageTimeType;					//时间标识
	CPngImage						m_ImageTimeFlag;					//时间标识

	CPngImage						m_ImagePlayLeft;					//玩家信息左
	CPngImage						m_ImagePlayMiddle;					//玩家信息中
	CPngImage						m_ImagePlayRight;					//玩家信息右

	CPngImage						m_ImageScoreInfo;					//分数信息
	CPngImage						m_ImageBankerInfo;					//庄家信息
	CPngImage						m_ImageWaitValleys;					//等待上庄
	CPngImage						m_ImageWaitFirst;					//第一等待
	
public:
	bool							m_blCanStore;                       //是否能保存
	CSkinButton						m_btBankerStorage;					//存款按钮
	CSkinButton						m_btBankerDraw;						//取款按钮

	//控制
public:
	HINSTANCE						m_hControlInst;
	IClientControlDlg*				m_pClientControlDlg;

	//函数定义
public:
	//构造函数
	CGameClientView();
	//析构函数
	virtual ~CGameClientView();

	//控制接口
public:
	//重置界面
	virtual VOID ResetGameView();

	//继承函数
private:
	//调整控件
	virtual VOID RectifyControl(int nWidth, int nHeight);
	//绘画界面
	virtual void DrawGameView(CDC * pDC, int nWidth, int nHeight);
	//WIN7支持
	virtual bool RealizeWIN7() { return true; }

public:
	//消息解释
	virtual BOOL PreTranslateMessage(MSG * pMsg);

	//设置函数
public:
	//设置状态
	VOID SetGameStatus(BYTE cbGameStatus);
	//我的位置
	void SetMeChairID(WORD wMeChairID);
	//设置最大下注
	void SetPlayBetScore(LONGLONG lPlayBetScore);
	//区域限制
	void SetAreaLimitScore(LONGLONG lAreaLimitScore);
	//庄家信息
	void SetBankerInfo(WORD wBankerUser, LONGLONG lBankerScore);
	//庄家信息
	void SetBankerInfo(WORD wBankerUser, LONGLONG lBankerScore, LONGLONG lBankerWinScore, WORD wBankerTime);
	//庄家信息
	void SetBankerOverInfo(LONGLONG lBankerWinScore, WORD wBankerTime);
	//设置系统是否坐庄
	void SetEnableSysBanker(bool bEnableSysBanker);
	//个人下注
	void SetPlayBet(BYTE cbViewIndex, LONGLONG lBetCount);
	//全部下注
	void SetAllBet(BYTE cbViewIndex, LONGLONG lBetCount);
	//设置筹码
	void AddChip(BYTE cbViewIndex, LONGLONG lScoreCount);
	//当局成绩
	void SetCurGameScore(LONGLONG lPlayScore[AREA_MAX], LONGLONG lPlayAllScore, LONGLONG lRevenue);
	//设置扑克
	void SetCardInfo(BYTE cbCardCount[2], BYTE cbTableCardArray[2][3]);
	//设置筹码
	void SetCurrentBet(LONGLONG lCurrentBet);
	//历史记录
	void SetGameHistory(enOperateResult OperateResult, BYTE cbPlayerCount, BYTE cbBankerCount, BYTE cbKingWinner, bool bPlayerTwoPair, bool bBankerTwoPair);
	//轮换庄家
	void ShowChangeBanker( bool bChangeBanker );
	//绘画下注区域
	void JettonAreaFrame(CDC *pDC);
	//聊天消息
	void InsertAllChatMessage(LPCTSTR pszString,int nMessageType) ;
	//系统消息
	void InsertSystemMessage(LPCTSTR pszString);
	//聊天消息
	void InsertChatMessage(LPCTSTR pszString);
	//常规消息
	void InsertNormalMessage(LPCTSTR pszString);
	//消息函数
	void InsertMessage(LPCTSTR pszString,COLORREF color=RGB(193,167,108));
	//聊天效验
	bool EfficacyUserChat(LPCTSTR pszChatString, WORD wExpressionIndex);
	//结算消息
	void InsertGameEndInfo();
	//历史记录
	void SetBottomRecord(const tagClientGameRecord &ClientGameRecord);
	//记录列数
	void SetRecordCol();
	//更新按钮
	VOID UpdateButtonContron();
	// 是否处于最大化模式
	bool IsZoomedMode();
	//更新视图
	void RefreshGameView();

	//动画函数
public:	
	//开始发牌
	void DispatchCard();
	//结束发牌
	void FinishDispatchCard(bool bScene = false);
	//伸缩动画
	void FlexAnimation(enFlexMode nFlexMode, bool bShow, bool bMove = true);
	//闪烁动画
	void FlashAnimation( bool bBegin );


	//绘画函数
protected:
	// 绘画顶部信息
	void DrawTopInfo(CDC *pDC, int nWidth, int nHeight);
	// 绘画底部信息
	void DrawBottomInfo(CDC *pDC, int nWidth, int nHeight);
	//显示输赢
	void DrawWinType(CDC *pDC, int nWidth, int nHeight, int nBeginX, int nBeginY );
	//显示结果
	void DrawGameOver(CDC *pDC, int nWidth, int nHeight, int nBeginX, int nBeginY );
	// 闪烁边框
	void DrawFlashFrame(CDC *pDC, int nWidth, int nHeight);
	//绘画框架
	void DrawGameFrame(CDC *pDC, int nWidth, int nHeight);

	//计算限制
public:
	//最大下注
	LONGLONG GetMaxPlayerScore(BYTE cbBetArea);

	//界面函数
public:
	//清理筹码
	void CleanUserBet();
	//发牌提示
	void SetDispatchCardTips();

	// 计算全屏绘画的缝隙，向右平移的像素
	INT CalFrameGap();

	// 计算最后一个记录所在的位置的列数目
	INT CalLastRecordHorCount();

	//内联函数
public:
	//当前筹码
	inline LONGLONG GetCurrentBet() { return m_lCurrentBet; }	

	//内部函数
public:
	//获取区域
	BYTE GetBetArea(CPoint MousePoint);
	//推断赢家
	void DeduceWinner(BYTE* pWinArea);
	//推断赢家
	void DeduceWinner(BYTE &cbWinner, BYTE &cbKingWinner, bool &bPlayerTwoPair, bool &bBankerTwoPair);
	// 添加逗号
	CString AddComma( LONGLONG lScore , bool bPlus = false);
	// 删除逗号
	LONGLONG DeleteComma( CString strScore );
	//设置超级抢庄玩家
	void SetCurSuperRobBankerUser(WORD wSuperRobBankerUser, WORD wSuperRobBankerUserSwitchView);
	//设置当前庄家类型
	void SetCurBankerType(CURRENT_BANKER_TYPE curbankertype) { if (curbankertype != m_typeCurrentBanker) { m_typeCurrentBanker = curbankertype; } }

	//绘画扩充函数
private:
	//艺术字体
	void DrawTextString(CDC * pDC, LPCTSTR pszString, COLORREF crText, COLORREF crFrame, int nXPos, int nYPos);
	//绘画字符
	void DrawTextString(CDC * pDC, LPCTSTR pszString, COLORREF crText, COLORREF crFrame, CRect rcRect, UINT nDrawFormat);
	//艺术字体
	void DrawTextString(CDC * pDC, CDFontEx* pFont, LPCTSTR pszString, COLORREF crText, COLORREF crFrame, int nXPos, int nYPos);
	//绘画字符
	void DrawTextString(CDC * pDC, CDFontEx* pFont, LPCTSTR pszString, COLORREF crText, COLORREF crFrame, CRect rcRect, UINT nDrawFormat);
	// 绘画数字
	void DrawNumber(CDC * pDC, CPngImage* ImageNumber, TCHAR * szImageNum, LONGLONG lOutNum, INT nXPos, INT nYPos, UINT uFormat = DT_LEFT);
	// 绘画数字
	void DrawNumber(CDC * pDC, CPngImage* ImageNumber, TCHAR * szImageNum, CString szOutNum, INT nXPos, INT nYPos, UINT uFormat = DT_LEFT);
	// 绘画数字
	void DrawNumber(CDC * pDC, CPngImage* ImageNumber, TCHAR * szImageNum, TCHAR* szOutNum ,INT nXPos, INT nYPos,  UINT uFormat = DT_LEFT);
	// 绘画时钟
	void DrawTime(CDC * pDC, WORD wUserTime,INT nXPos, INT nYPos);

	//按钮消息
protected:
	//筹码按钮
	afx_msg void OnBetButton100();
	//筹码按钮
	afx_msg void OnBetButton1000();
	//筹码按钮
	afx_msg void OnBetButton10000();
	//筹码按钮
	afx_msg void OnBetButton100000();
	//筹码按钮
	afx_msg void OnBetButton1000000();
	//筹码按钮
	afx_msg void OnBetButton5000000();
	//筹码按钮
	afx_msg void OnBetButton10000000();
	//查看路子
	afx_msg void OnViewChart();
	//上庄按钮
	afx_msg void OnApplyBanker();
	//下庄按钮
	afx_msg void OnCancelBanker();
	//超级抢庄按钮
	afx_msg void OnSuperRobBanker();
	//移动按钮
	afx_msg void OnScoreMoveL();
	//移动按钮
	afx_msg void OnScoreMoveR();
	//上翻页
	afx_msg void OnValleysUp();
	//下翻页
	afx_msg void OnValleysDown();
	//管理员控制
	afx_msg void OpenAdminWnd();
	//银行存款
	afx_msg void OnBankStorage();
	//银行取款
	afx_msg void OnBankDraw();
	//最小按钮	
	afx_msg void OnButtonMin();
	//设置按钮	
	afx_msg void OnButtonGameOption();
	//关闭按钮	
	afx_msg void OnButtonClose();
	//银行按钮
	afx_msg void OnButtonGoBanker();

	//消息映射
protected:
	//定时器消息
	afx_msg void OnTimer(UINT nIDEvent);
	//建立函数
	afx_msg int OnCreate(LPCREATESTRUCT lpCreateStruct);
	//鼠标消息
	afx_msg void OnLButtonDown(UINT nFlags, CPoint Point);	
	//鼠标消息
	afx_msg void OnRButtonDown(UINT nFlags, CPoint Point);	
	//光标消息
	afx_msg BOOL OnSetCursor(CWnd * pWnd, UINT nHitTest, UINT uMessage);
	//标题
	afx_msg LRESULT OnSetCaption(WPARAM wParam, LPARAM lParam);
	//控件命令
	virtual BOOL OnCommand(WPARAM wParam, LPARAM lParam);
	//控件颜色
	afx_msg HBRUSH OnCtlColor(CDC* pDC, CWnd* pWnd, UINT nCtlColor);

	afx_msg void OnSize( UINT nType, int cx, int cy );

	afx_msg void OnLButtonDblClk(UINT nFlags,CPoint point);

	DECLARE_MESSAGE_MAP()
};

//////////////////////////////////////////////////////////////////////////

#endif

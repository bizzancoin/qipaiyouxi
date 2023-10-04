#ifndef ANDROID_USER_ITEM_SINK_HEAD_FILE
#define ANDROID_USER_ITEM_SINK_HEAD_FILE

#pragma once

#include "Stdafx.h"
#include "..\服务器组件\GameLogic.h"

//////////////////////////////////////////////////////////////////////////



//游戏对话框
class CAndroidUserItemSink : public IAndroidUserItemSink
{
	//加注信息
protected:
	LONGLONG						m_lTurnMaxScore;						//最大下注
	SCORE							m_lCellScore;							//单元下注
	WORD							m_wBankerUser;							//当前庄家

	//用户扑克
protected:
	BYTE							m_HandCardData[2][MAX_COUNT];			//用户数据	
	BYTE							m_bStopCard[GAME_PLAYER*2];				//是否停牌
	BYTE							m_bInsureCard[2];						//是否保险
	BYTE							m_bDoubleCard[2];						//
	BYTE							m_cbCardCount[2];						//手上牌数目
	bool							m_bWin;									//是否赢牌

	//控件变量
public:
	CGameLogic						m_GameLogic;							//游戏逻辑
	IAndroidUserItem *				m_pIAndroidUserItem;					//用户接口

	//游戏AI存取款
	LONGLONG						m_lRobotScoreRange[2];					//最大范围
	LONGLONG						m_lRobotBankGetScore;					//提款数额
	LONGLONG						m_lRobotBankGetScoreBanker;				//提款数额 (庄家)
	int								m_nRobotBankStorageMul;					//存款倍数
	
	//函数定义
public:
	//构造函数
	CAndroidUserItemSink();
	//析构函数
	virtual ~CAndroidUserItemSink();

	//基础接口
public:
	//释放对象
	virtual VOID Release() { delete this; }
	//接口查询
	virtual void * QueryInterface(const IID & Guid, DWORD dwQueryVer);

	//调试接口
public:
	//初始接口
	virtual bool Initialization(IUnknownEx * pIUnknownEx);
	//重置接口
	virtual bool RepositionSink();

	//游戏事件
public:
	//时间消息
	virtual bool OnEventTimer(UINT nTimerID);
	//游戏消息
	virtual bool OnEventGameMessage(WORD wSubCmdID, void * pData, WORD wDataSize);
	//游戏消息
	virtual bool OnEventFrameMessage(WORD wSubCmdID, void * pData, WORD wDataSize);
	//场景消息
	virtual bool OnEventSceneMessage(BYTE cbGameStatus, bool bLookonOther, void * pData, WORD wDataSize);

	//用户事件
public:
	//用户进入
	virtual void OnEventUserEnter(IAndroidUserItem * pIAndroidUserItem, bool bLookonUser);
	//用户离开
	virtual void OnEventUserLeave(IAndroidUserItem * pIAndroidUserItem, bool bLookonUser);
	//用户积分
	virtual void OnEventUserScore(IAndroidUserItem * pIAndroidUserItem, bool bLookonUser);
	//用户状态
	virtual void OnEventUserStatus(IAndroidUserItem * pIAndroidUserItem, bool bLookonUser);
	//用户段位
	virtual void OnEventUserSegment(IAndroidUserItem * pIAndroidUserItem, bool bLookonUser);

	//消息处理
protected:
	//游戏开始
	bool OnSubGameStart(const void * pBuffer, WORD wDataSize);
	//发牌消息
	bool OnSubSendCard(const void * pBuffer, WORD wDataSize);
	//游戏结束
	bool OnSubGameEnd(const void * pBuffer, WORD wDataSize);
	//下注消息
	bool OnSubAddScore( const void *pBuffer, WORD wDataSize );
	//停牌消息
	bool OnSubStopCard( const void *pBuffer, WORD wDataSize );
	//加倍消息
	bool OnSubDoubleCard( const void *pBuffer, WORD wDataSize );
	//分牌消息
	bool OnSubSplitCard( const void *pBuffer, WORD wDataSize );
	//保险消息
	bool OnSubInsureCard( const void *pBuffer, WORD wDataSize );
	//要牌消息
	bool OnSubGetCard( const void *pBuffer, WORD wDataSize );

private:
	//读取配置
	void ReadConfigInformation(tagCustomAndroid *pCustomAndroid);
	//银行操作
	void BankOperate(BYTE cbType);
	//分析操作
	bool AnalyseCardOperate(BYTE cbCardType, BYTE cbLastVaule);
};

//////////////////////////////////////////////////////////////////////////

#endif

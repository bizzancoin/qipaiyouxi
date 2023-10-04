#pragma once

#include "Stdafx.h"
#include "GameClientView.h"

//////////////////////////////////////////////////////////////////////////

//游戏对话框
class CGameClientEngine : public CGameFrameEngine
{
	//友元声明
	friend class CGameClientView;

	//个人信息
protected:
	LONGLONG						m_lPlayBetScore;					//玩家最大下注
	LONGLONG						m_lPlayFreeSocre;					//玩家自由积分
	LONGLONG						m_lInitUserScore[GAME_PLAYER];		//原始分数

	//下注数
protected:
	LONGLONG						m_lAllBet[AREA_MAX];				//总下注
	LONGLONG						m_lPlayBet[AREA_MAX];				//玩家下注
	LONGLONG						m_lPlayScore[AREA_MAX];				//玩家输赢

	//庄家信息
protected:
	WORD							m_wBankerUser;						//当前庄家
	LONGLONG						m_lBankerScore;						//庄家积分
	LONGLONG						m_lBankerWinScore;					//庄家赢分
	WORD							m_wBankerTime;						//庄家局数
	bool							m_bEnableSysBanker;					//系统做庄	

	//超级抢庄
	SUPERBANKERCONFIG				m_superbankerConfig;	
	//抢庄配置
	WORD							m_wCurSuperRobBankerUser;			//当前超级抢庄玩家

	//状态变量
protected:
	bool							m_bMeApplyBanker;					//申请标识
	bool							m_bBackGroundSound;					//背景声音
	bool							m_bPlaySound;

	//限制信息
protected:
	LONGLONG						m_lAreaLimitScore;					//区域限制
	LONGLONG						m_lApplyBankerCondition;			//申请条件

	//控件变量
protected:
	CGameLogic						m_GameLogic;						//游戏逻辑
	CGameClientView					m_GameClientView;					//游戏视图

	//声音资源
protected:
	DWORD							m_dwBackID;							//背景声音ID

	//辅助变量
	CWHArray<CMD_S_PlaceBet,CMD_S_PlaceBet> m_PlaceBetArray;

	//函数定义
public:
	//构造函数
	CGameClientEngine();
	//析构函数
	virtual ~CGameClientEngine();

	//常规继承
private:
	//初始函数
	virtual bool OnInitGameEngine();
	//重置框架
	virtual bool OnResetGameEngine();
	//旁观状态
	virtual bool OnEventLookonMode(VOID * pData, WORD wDataSize);
	//时钟删除
	virtual bool OnEventGameClockKill(WORD wChairID);
	//时钟信息
	virtual bool OnEventGameClockInfo(WORD wChairID, UINT nElapse, WORD wClockID);
	//网络消息
	virtual bool OnEventGameMessage(WORD wSubCmdID, VOID * pData, WORD wDataSize);
	//游戏场景
	virtual bool OnEventSceneMessage(BYTE cbGameStatus, bool bLookonOther, VOID * pData, WORD wDataSize);
	//声音控制
	virtual bool AllowBackGroundSound(bool bAllowSound);

	//用户事件
public:
	//用户进入
	virtual VOID OnEventUserEnter(IClientUserItem * pIClientUserItem, bool bLookonUser);
	//用户离开
	virtual VOID OnEventUserLeave(IClientUserItem * pIClientUserItem, bool bLookonUser);
	//用户积分
	virtual VOID OnEventUserScore(IClientUserItem * pIClientUserItem, bool bLookonUser);
	//用户状态
	virtual VOID OnEventUserStatus(IClientUserItem * pIClientUserItem, bool bLookonUser);
	//用户段位
	virtual VOID OnEventUserSegment(IClientUserItem * pIClientUserItem, bool bLookonUser){};
	//用户头像
	virtual VOID OnEventCustomFace(IClientUserItem * pIClientUserItem, bool bLookonUser){};

	//消息处理
protected:
	//游戏开始
	bool OnSubGameStart(const void * pBuffer, WORD wDataSize);
	//游戏空闲
	bool OnSubGameFree(const void * pBuffer, WORD wDataSize);
	//用户加注
	bool OnSubPlaceBet(const void * pBuffer, WORD wDataSize);
	//游戏结束
	bool OnSubGameEnd(const void * pBuffer, WORD wDataSize);
	//申请做庄
	bool OnSubUserApplyBanker(const void * pBuffer, WORD wDataSize);
	//取消做庄
	bool OnSubUserCancelBanker(const void * pBuffer, WORD wDataSize);
	//切换庄家
	bool OnSubChangeBanker(const void * pBuffer, WORD wDataSize);
	//游戏记录
	bool OnSubGameRecord(const void * pBuffer, WORD wDataSize);
	//下注失败
	bool OnSubPlaceBetFail(const void * pBuffer, WORD wDataSize);
	//申请结果
	bool OnSubReqResult(const void * pBuffer, WORD wDataSize);
	//更新库存
	bool OnSubUpdateStorage(const void * pBuffer, WORD wDataSize);
	//更新下注
	bool OnSubSendUserBetInfo(const void * pBuffer, WORD wDataSize);
	//超级抢庄 
	bool OnSubSuperRobBanker(const void * pBuffer, WORD wDataSize);
	//超级抢庄离开
	bool OnSubCurSuperRobLeave(const void * pBuffer, WORD wDataSize);
	//更新用户列表
	void UpdateUserList();

	//功能函数
protected:
	//更新控制
	void UpdateButtonContron();	
	//获取会员等级
	int GetMemberOrderIndex(VIPINDEX vipIndex);

	//消息映射
protected:
	//加注消息
	LRESULT OnPlayBet(WPARAM wParam, LPARAM lParam);
	//申请消息
	LRESULT OnApplyBanker(WPARAM wParam, LPARAM lParam);
	//超级抢庄
	LRESULT OnSuperRobBanker(WPARAM wParam, LPARAM lParam);
	//声音消息
	LRESULT OnPlaySound(WPARAM wParam, LPARAM lParam);
	//管理员请求
	LRESULT OnAdminCommand(WPARAM wParam, LPARAM lParam);
	//更新库存
	LRESULT OnUpdateStorage(WPARAM wParam, LPARAM lParam);
	//设置
	LRESULT  OnGameSetting( WPARAM wParam, LPARAM lParam );
	//聊天
	LRESULT  OnChatMessage( WPARAM wParam, LPARAM lParam );
	//游戏声音
	LRESULT OnMessageGameSound(WPARAM wParam, LPARAM lParam);

	DECLARE_MESSAGE_MAP()
public:
	afx_msg void OnTimer(UINT nIDEvent);
};

//////////////////////////////////////////////////////////////////////////

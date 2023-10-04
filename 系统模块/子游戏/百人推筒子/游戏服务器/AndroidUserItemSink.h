#ifndef ANDROID_USER_ITEM_SINK_HEAD_FILE
#define ANDROID_USER_ITEM_SINK_HEAD_FILE

#pragma once

#include "Stdafx.h"
#include "GameLogic.h"

//////////////////////////////////////////////////////////////////////////

//最大下注次数
#define MAX_CHIP_TIME								50

//游戏对话框
class CAndroidUserItemSink : public IAndroidUserItemSink
{
	//游戏变量
protected:
	LONGLONG						m_lMaxChipBanker;					//最大下注 (庄家)
	LONGLONG						m_lMaxChipUser;						//最大下注 (个人)
	LONGLONG						m_lAreaChip[AREA_COUNT];			//区域下注 
	WORD							m_wCurrentBanker;					//庄家位置
	BYTE							m_cbTimeLeave;						//剩余时间

	int								m_nChipLimit[2];					//下注范围 (0-AREA_COUNT)
	int								m_nChipTime;						//下注次数 (本局)
	int								m_nChipTimeCount;					//已下次数 (本局)

	//上庄变量
protected:
	bool							m_bMeApplyBanker;					//申请标识
	int								m_nBankerCount;						//本机器人的坐庄次数
	int								m_nWaitBanker;						//空几盘
	static int						m_stlApplyBanker;					//申请数

	//配置变量  (全局配置)
protected:
	tagRobotInfo					m_RobotInfo;						//全局配置
	TCHAR							m_szRoomName[32];					//配置房间

	//配置变量	(游戏配置)
protected:
	LONGLONG						m_lAreaLimitScore;					//区域限制
	LONGLONG						m_lUserLimitScore;					//下注限制
	LONGLONG						m_lBankerCondition;					//上庄条件		

	//配置变量  (机器人配置)
protected:
	LONGLONG						m_lRobotJettonLimit[2];				//筹码限制	
	int								m_nRobotBetTimeLimit[2];			//次数限制	
	bool							m_bRobotBanker;						//是否坐庄
	int								m_nRobotBankerCount;				//坐庄次数
	int								m_nRobotWaitBanker;					//空盘重申
	int								m_nRobotApplyBanker;				//上庄个数
	INT64                           m_nListUserCount;					//列表人数

	//机器人存取款
	LONGLONG						m_lRobotScoreRange[2];				//最大范围
	LONGLONG						m_lRobotBankGetScore;				//提款数额
	LONGLONG						m_lRobotBankGetScoreBanker;			//提款数额 (庄家)
	int								m_nRobotBankStorageMul;				//存款倍数

	//控件变量
protected:
	CGameLogic						m_GameLogic;						//游戏逻辑
	IAndroidUserItem *				m_pIAndroidUserItem;				//用户接口

  //函数定义
public:
  //构造函数
  CAndroidUserItemSink();
  //析构函数
  virtual ~CAndroidUserItemSink();

  //基础接口
public:
  //释放对象
  virtual VOID Release()
  {
    delete this;
  }
  //接口查询
  virtual void * QueryInterface(const IID & Guid, DWORD dwQueryVer);

  //控制接口
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
	//游戏空闲
	bool OnSubGameFree(const VOID * pBuffer, WORD wDataSize);
	//游戏开始
	bool OnSubGameStart(const VOID * pBuffer, WORD wDataSize);
	//用户加注
	bool OnSubPlaceJetton(const VOID * pBuffer, WORD wDataSize);
	//下注失败
	bool OnSubPlaceJettonFail(const VOID * pBuffer, WORD wDataSize);
	//游戏结束
	bool OnSubGameEnd(const VOID * pBuffer, WORD wDataSize);
	//申请做庄
	bool OnSubUserApplyBanker(const VOID * pBuffer, WORD wDataSize);
	//取消做庄
	bool OnSubUserCancelBanker(const VOID * pBuffer, WORD wDataSize);
	//切换庄家
	bool OnSubChangeBanker(const VOID * pBuffer, WORD wDataSize);

private:
	//银行操作
	void BankOperate(BYTE cbType);

	//读取配置
	VOID ReadConfigInformation(TCHAR szFileName[], TCHAR szRoomName[], bool bReadFresh);
	//计算范围
	bool CalcJettonRange(LONGLONG lMaxScore, LONGLONG lChipLmt[], int & nChipTime, int lJetLmt[]);
	//读取长整
	LONGLONG GetPrivateProfileInt64(LPCTSTR lpAppName, LPCTSTR lpKeyName, LONGLONG lDefault, LPCTSTR lpFileName);
};

//////////////////////////////////////////////////////////////////////////

#endif

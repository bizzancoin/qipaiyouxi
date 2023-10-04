#ifndef TABLE_FRAME_SINK_HEAD_FILE
#define TABLE_FRAME_SINK_HEAD_FILE

#pragma once

#include "Stdafx.h"
#include "GameLogic.h"

//////////////////////////////////////////////////////////////////////////
//历史记录
#define MAX_SCORE_HISTORY			20									//历史个数
//////////////////////////////////////////////////////////////////////////

//游戏桌子类
class CTableFrameSink : public ITableFrameSink, public ITableUserAction
{
	//总下注数
protected:
	SCORE							m_lAllJettonScore[AREA_MAX];	//全体总注
	
	//个人下注
protected:
	SCORE							m_lUserJettonScore[GAME_PLAYER][AREA_MAX];			//个人总注

	bool							m_bUserListWin[GAME_PLAYER][USER_LIST_COUNT];		//列表玩家获胜次数
	SCORE							m_lUserListScore[GAME_PLAYER][USER_LIST_COUNT];		//列表玩家下注数目
	BYTE							m_cbUserPlayCount[GAME_PLAYER];						//列表玩家游戏局数

	//控制变量
protected:
	SCORE							m_lAreaLimitScore;						//区域限制
	SCORE							m_lUserLimitScore;						//区域限制
	SCORE							m_lApplyBankerCondition;				//申请条件

	TCHAR							m_szConfigFileName[MAX_PATH];			//配置文件

	//机器人控制
	SCORE							m_lRobotAreaLimit;						//区域统计 (机器人)
	SCORE							m_lRobotAreaScore[AREA_MAX];			//区域统计 (机器人)
	int								m_nBankerTimeLimit;						//次数限制

	//时间控制
	int								m_nFreeTime;							//空闲时间
	int								m_nPlaceJettonTime;						//下注时间
	int								m_nGameEndTime;							//结束时间

	//玩家成绩
protected:
	SCORE							m_lUserWinScore[GAME_PLAYER];			//玩家成绩
	SCORE							m_lUserReturnScore[GAME_PLAYER];		//返回下注
	SCORE							m_lUserRevenue[GAME_PLAYER];			//玩家税收
	
	//扑克信息
protected:
	BYTE							m_cbCardCount[4];						//扑克数目
    BYTE							m_cbTableCardArray[4][2];				//桌面扑克
	BYTE							m_cbTableHavaSendCardArray[4][10];		//桌面扑克
	BYTE							m_cbTableHavaSendCount[4];				//桌面扑克
	BYTE							m_cbTableCard[CARD_COUNT];				//桌面扑克
	BYTE							m_cbLeftCardCount;						//剩余扑克数目

	//状态变量
protected:
	DWORD							m_dwJettonTime;							//开始时间

	//局控
	BYTE							m_cbJuControlTimes;						//局控次数
	BYTE							m_cbJuControl;							//是否进行局控
	BYTE							m_cbJuControlArea[AREA_MAX];			//本局控制区域胜利 0不控制，1控制赢，2控制输

	//庄家信息
protected:
	CWHArray<WORD>					m_ApplyUserArray;						//申请玩家
	WORD							m_wCurrentBanker;						//当前庄家
	WORD							m_wBankerTime;							//做庄次数
	SCORE							m_lBankerScore;							//庄家分数
	SCORE							m_lBankerWinScore;						//累计成绩
	SCORE							m_lBankerCurGameScore;					//当前成绩
	SCORE							m_lSysBankerScore;						//系统庄家钱数

	//记录变量
protected:
	tagServerGameRecord				m_GameRecordArrary[MAX_SCORE_HISTORY];	//游戏记录
	int								m_nRecordFirst;							//开始记录
	int								m_nRecordLast;							//最后记录

	//组件变量
protected:
	CGameLogic						m_GameLogic;							//游戏逻辑
	ITableFrame						* m_pITableFrame;						//框架接口
	tagGameServiceOption		    *m_pGameServiceOption;					//配置参数
	tagGameServiceAttrib			*m_pGameServiceAttrib;					//游戏属性
	//属性变量
protected:
	static const WORD				m_wPlayerCount;							//游戏人数

	//函数定义
public:
	//构造函数
	CTableFrameSink();
	//析构函数
	virtual ~CTableFrameSink();

	//基础接口
public:
	//释放对象
	virtual VOID  Release();
	//接口查询
	virtual VOID * QueryInterface(REFGUID Guid, DWORD dwQueryVer);

	//管理接口
public:
	//初始化
	virtual bool  Initialization(IUnknownEx * pIUnknownEx);
	//复位桌子
	virtual void  RepositionSink();


	//游戏事件
public:
	//游戏开始
	virtual bool  OnEventGameStart();

	//游戏结束
	virtual bool  OnEventGameConclude(WORD wChairID, IServerUserItem * pIServerUserItem, BYTE cbReason);
	//发送场景
	virtual bool  OnEventSendGameScene(WORD wChiarID, IServerUserItem * pIServerUserItem, BYTE cbGameStatus, bool bSendSecret);

	//百人游戏获取游戏记录
	virtual void OnGetGameRecord(VOID *GameRecord);

	//获取百人游戏是否下注状态而且玩家下注了
	virtual bool OnGetUserBetInfo(WORD wChairID, IServerUserItem * pIServerUserItem);

	//事件接口
public:
	//定时器事件
	virtual bool  OnTimerMessage(DWORD wTimerID, WPARAM wBindParam);
	//游戏消息处理
	virtual bool  OnGameMessage(WORD wSubCmdID, VOID * pDataBuffer, WORD wDataSize, IServerUserItem * pIServerUserItem);
	//框架消息处理
	virtual bool  OnFrameMessage(WORD wSubCmdID, VOID * pDataBuffer, WORD wDataSize, IServerUserItem * pIServerUserItem);

	//动作事件
public:
	//用户断线
	virtual bool  OnActionUserOffLine(WORD wChairID, IServerUserItem * pIServerUserItem) ;
	//用户重入
	virtual bool  OnActionUserConnect(WORD wChairID, IServerUserItem * pIServerUserItem){ return true; }
	//用户坐下
	virtual bool  OnActionUserSitDown(WORD wChairID, IServerUserItem * pIServerUserItem, bool bLookonUser);
	//用户起来
	virtual bool  OnActionUserStandUp(WORD wChairID, IServerUserItem * pIServerUserItem, bool bLookonUser);
	//用户同意
	virtual bool  OnActionUserOnReady(WORD wChairID, IServerUserItem * pIServerUserItem, VOID * pData, WORD wDataSize){ return true; }


	//查询接口
public:
	//查询限额
	virtual SCORE QueryConsumeQuota(IServerUserItem * pIServerUserItem);//{return 0;}
	//最少积分
	virtual SCORE QueryLessEnterScore(WORD wChairID, IServerUserItem * pIServerUserItem){return 0;}
	//查询服务费
	virtual bool QueryBuckleServiceCharge(WORD wChairID);
	//数据事件
	virtual bool OnDataBaseMessage(WORD wRequestID, VOID * pData, WORD wDataSize){return false;}
	//积分事件
	virtual bool OnUserScroeNotify(WORD wChairID, IServerUserItem * pIServerUserItem, BYTE cbReason){return false;}
	//设置基数
	virtual void SetGameBaseScore(SCORE lBaseScore){ return; }

	//游戏事件
protected:
	//加注事件
	bool OnUserPlaceJetton(WORD wChairID, BYTE cbJettonArea, SCORE lJettonScore);
	//申请庄家
	bool OnUserApplyBanker(IServerUserItem *pIApplyServerUserItem);
	//取消申请
	bool OnUserCancelBanker(IServerUserItem *pICancelServerUserItem);
	//请求用户列表
	bool OnUserRequestUserList(WORD wChairID);
	//获取前6个用户列表的GameID
	bool OnGetUserListGameID(WORD wSeatUser[MAX_SEAT_COUNT]);

	//辅助函数
private:
	//发送庄家
	void SendApplyUser( IServerUserItem *pServerUserItem );
	//更换庄家
	bool ChangeBanker(bool bCancelCurrentBanker);
	//发送记录
	void SendGameRecord(IServerUserItem *pIServerUserItem);

	//下注计算
private:
	//最大下注
	SCORE GetUserMaxJetton(WORD wChairID);
	
	
	void ReadConfigInformation(bool bReadFresh,bool bReadBaseConfig=true);

	//选择庄家
	void TrySelectBanker();

	//游戏统计
private:
	//计算得分
	SCORE CalculateScore();
	//推断赢家
	void DeduceWinner(bool &bWinShangMen, bool &bWinTianMen, bool &bWinXiaMen);

	//计算系统输赢分
	SCORE CalculateSystemScore();
	//是否控制
	BYTE AnalyseControl();

	void GetValueFromCombStr(LONGLONG llData[], int nDataLen, LPCTSTR sTr, int nStrLen);
};

//////////////////////////////////////////////////////////////////////////

#endif

#ifndef TABLE_FRAME_SINK_HEAD_FILE
#define TABLE_FRAME_SINK_HEAD_FILE

#pragma once

#include "Stdafx.h"
#include "GameLogic.h"
#include "ServerControl.h"

//////////////////////////////////////////////////////////////////////////
//历史记录
//#define MAX_SCORE_HISTORY			65									//历史个数
#define MAX_SCORE_HISTORY			20									//历史个数
//////////////////////////////////////////////////////////////////////////

//游戏桌子类
class CTableFrameSink : public ITableFrameSink, public ITableUserAction
{
	//用户信息
protected:
	LONGLONG						m_lUserStartScore[GAME_PLAYER];		//起始分数

	//下注数
protected:
	LONGLONG						m_lAllBet[AREA_MAX];					//总下注
	LONGLONG						m_lPlayBet[GAME_PLAYER][AREA_MAX];		//玩家下注

	//分数
protected:
	LONGLONG						m_lBankerScore;							//庄家积分
	LONGLONG						m_lPlayScore[GAME_PLAYER][AREA_MAX];	//玩家输赢
	LONGLONG						m_lUserWinScore[GAME_PLAYER];			//玩家成绩
	LONGLONG						m_lUserRevenue[GAME_PLAYER];			//玩家税收

	//控制变量
protected:
	LONGLONG						m_lAreaLimitScore;						//区域限制
	LONGLONG						m_lUserLimitScore;						//区域限制

	LONGLONG						m_lApplyBankerCondition;				//申请条件
	TCHAR							m_szConfigFileName[MAX_PATH];			//配置文件
	int								m_nServiceCharge;						//服务费

	//扑克信息
protected:
	BYTE							m_cbCardCount[2];						//扑克数目
    BYTE							m_cbTableCardArray[2][3];				//桌面扑克
	SCORE						m_lCurCaiJing;								//彩金信息

	//状态变量
protected:
	DWORD							m_dwBetTime;							//开始时间
	bool							m_bControl;								//是否控制
	LONGLONG						m_lControlStorage;						//控制后的损耗写入
	TCHAR							m_szControlName[LEN_NICKNAME];			//房间名称

	//庄家信息
protected:
	CWHArray<WORD>					m_ApplyUserArray;						//申请玩家
	WORD							m_wCurrentBanker;						//当前庄家
	WORD							m_wOfflineBanker;						//离线庄家
	WORD							m_wBankerTime;							//做庄次数
	LONGLONG						m_lBankerWinScore;						//累计成绩
	LONGLONG						m_lBankerCurGameScore;					//当前成绩
	bool							m_bEnableSysBanker;						//系统做庄
	
	//超级抢庄
	SUPERBANKERCONFIG				m_superbankerConfig;					//抢庄配置
	CURRENT_BANKER_TYPE				m_typeCurrentBanker;					//当前庄家类型
	WORD							m_wCurSuperRobBankerUser;				//当前超级抢庄玩家

	//占位
	OCCUPYSEATCONFIG				m_occupyseatConfig;									//占位配置
	WORD							m_tabWOccupySeatChairID[MAX_OCCUPY_SEAT_COUNT];	//占位椅子ID

	//记录变量
protected:
	tagServerGameRecord				m_GameRecordArrary[MAX_SCORE_HISTORY];	//游戏记录
	int								m_nRecordFirst;							//开始记录
	int								m_nRecordLast;							//最后记录
	DWORD							m_dwRecordCount;						//记录数目

	//组件变量
protected:
	CGameLogic						m_GameLogic;							//游戏逻辑
	ITableFrame	*					m_pITableFrame;							//框架接口
	const tagGameServiceOption		* m_pGameServiceOption;					//配置参数

	//服务控制
protected:
	HINSTANCE						m_hControlInst;
	IServerControl*					m_pServerContro;

	//控制变量
protected:
	bool							m_bRefreshCfg;							//每盘刷新
	TCHAR							m_szGameRoomName[SERVER_LEN];			//房间名称

	LONGLONG						m_lStorageStart;						//库存数值
	LONGLONG						m_lStorageCurrent;						//房间启动每桌子的库存数值，读取失败按 0 设置
	LONGLONG						m_lStorageDeduct;						//每局游戏结束后扣除的库存比例，读取失败按 1.00 设置
	LONGLONG						m_lStorageMax1;							//库存封顶1
	LONGLONG						m_lStorageMul1;							//系统输钱概率
	LONGLONG						m_lStorageMax2;							//库存封顶2
	LONGLONG						m_lStorageMul2;							//系统输钱概率
	int								m_nStorageCount;						//循环次数


	//庄家设置
protected:
	//加庄局数设置：当庄家坐满设定的局数之后(m_nBankerTimeLimit)，
	//所带金币值还超过下面申请庄家列表里面所有玩家金币时，
	//可以再加坐庄m_nBankerTimeAdd局，加庄局数可设置。
	LONGLONG						m_nBankerTimeLimit;							//最大庄家数
	LONGLONG						m_nBankerTimeAdd;							//庄家增加数

	//金币超过m_lExtraBankerScore之后，就算是下面玩家的金币值大于他的金币值，他也可以再加庄m_nExtraBankerTime局。
	LONGLONG						m_lExtraBankerScore;						//庄家钱
	LONGLONG						m_nExtraBankerTime;						//庄家钱大时,坐庄增加数

	//最大庄家数
	LONGLONG						m_lPlayerBankerMAX;						//玩家最大庄家数

	//换庄
	bool							m_bExchangeBanker;						//交换庄家

	//时间设置
protected:
	BYTE							m_cbFreeTime;							//空闲时间
	BYTE							m_cbBetTime;							//下注时间
	BYTE							m_cbEndTime;							//结束时间

	//机器人控制
	int								m_nMaxChipRobot;						//最大数目 (下注机器人)
	int								m_nChipRobotCount;						//人数统计 (下注机器人)
	LONGLONG						m_lRobotAreaLimit;						//区域统计 (机器人)
	LONGLONG						m_lRobotAreaScore[AREA_MAX];		//区域统计 (机器人)
	int								m_nRobotListMaxCount;					//最多人数

	//函数定义
public:
	//构造函数
	CTableFrameSink();
	//析构函数
	virtual ~CTableFrameSink();

	//基础接口
public:
	//释放对象
	virtual VOID Release();
	//是否有效
	virtual bool IsValid() { return AfxIsValidAddress(this,sizeof(CTableFrameSink))?true:false; }
	//接口查询
	virtual void * QueryInterface(const IID & Guid, DWORD dwQueryVer);

	//管理接口
public:
	//初始化
	virtual bool Initialization(IUnknownEx * pIUnknownEx);
	//复位桌子
	virtual void RepositionSink();

	//查询接口
public:
	//查询限额
	virtual SCORE QueryConsumeQuota(IServerUserItem * pIServerUserItem);
	//最少积分
	virtual SCORE QueryLessEnterScore(WORD wChairID, IServerUserItem * pIServerUserItem){ return 0; }
	//查询是否扣服务费
	virtual bool QueryBuckleServiceCharge(WORD wChairID);

	//比赛接口
public:
	//设置基数
	virtual void SetGameBaseScore(LONG lBaseScore){};

public:
	//数据事件
	virtual bool OnDataBaseMessage(WORD wRequestID, VOID * pData, WORD wDataSize){return false;}
	//积分事件
	virtual bool OnUserScroeNotify(WORD wChairID, IServerUserItem * pIServerUserItem, BYTE cbReason);

	//信息接口
public:
	//游戏状态
	virtual bool IsUserPlaying(WORD wChairID);

	//游戏事件
public:
	//游戏开始
	virtual bool OnEventGameStart();
	//游戏结束
	virtual bool OnEventGameConclude(WORD wChairID, IServerUserItem * pIServerUserItem, BYTE cbReason);
	//发送场景
	virtual bool OnEventSendGameScene(WORD wChiarID, IServerUserItem * pIServerUserItem, BYTE cbGameStatus, bool bSendSecret);

	//事件接口
public:
	//定时器事件
	virtual bool OnTimerMessage(DWORD dwTimerID, WPARAM dwBindParameter);
	//游戏消息处理
	virtual bool OnGameMessage(WORD wSubCmdID, VOID * pData, WORD wDataSize, IServerUserItem * pIServerUserItem);
	//框架消息处理
	virtual bool OnFrameMessage(WORD wSubCmdID, VOID * pData, WORD wDataSize, IServerUserItem * pIServerUserItem);

	//动作事件
public:
	//用户断线
	virtual bool OnActionUserOffLine(WORD wChairID, IServerUserItem * pIServerUserItem);
	//用户重入
	virtual bool OnActionUserConnect(WORD wChairID, IServerUserItem * pIServerUserItem) { return true; }
	//用户坐下
	virtual bool OnActionUserSitDown(WORD wChairID, IServerUserItem * pIServerUserItem, bool bLookonUser);
	//用户起来
	virtual bool OnActionUserStandUp(WORD wChairID, IServerUserItem * pIServerUserItem, bool bLookonUser);
	//用户同意
	virtual bool OnActionUserOnReady(WORD wChairID, IServerUserItem * pIServerUserItem, VOID * pData, WORD wDataSize){ return true; }
	
	//框架事件
public:
	//咨询玩家
	virtual bool OnEventQueryChargeable(IServerUserItem *pIServerUserItem, bool bLookonUser);
	//咨询服务费
	virtual LONGLONG OnEventQueryCharge(IServerUserItem *pIServerUserItem);


	//游戏事件
protected:
	//加注事件
	bool OnUserPlayBet(WORD wChairID, BYTE cbBetArea, LONGLONG lBetScore);
	//加注事件
	bool OnUserPlayBet2(WORD wChairID, BYTE cbBetArea, LONGLONG lBetScore);
	//申请庄家
	bool OnUserApplyBanker(IServerUserItem *pIApplyServerUserItem);
	//取消申请
	bool OnUserCancelBanker(IServerUserItem *pICancelServerUserItem);
	//用户占位
	bool OnUserOccupySeat(WORD wOccupyChairID, BYTE cbOccupySeatIndex);
	//重复下注
	bool OnUserRepeatBet( WORD wChairID );

	//辅助函数
private:
	//发送扑克
	bool DispatchTableCard();
	//发送庄家
	void SendApplyUser( IServerUserItem *pServerUserItem );
	//更换庄家
	bool ChangeBanker(bool bCancelCurrentBanker);
	//轮换判断
	void TakeTurns();
	//发送记录
	void SendGameRecord(IServerUserItem *pIServerUserItem);
	//发送消息
	void SendGameMessage(WORD wChairID, LPCTSTR pszTipMsg);
	//发送消息
	void SendPlaceBetFail(WORD wChairID, BYTE cbBetArea, LONGLONG lBetScore);
	//管理员命令
	bool OnSubAmdinCommand(IServerUserItem*pIServerUserItem,const void*pDataBuffer);
	//读取配置
	void ReadConfigInformation();
	// 添加逗号
	CString AddComma( LONGLONG lScore );
	//是否衰减
	bool NeedDeductStorage();
	//发送下注信息
	void SendUserBetInfo( IServerUserItem *pIServerUserItem );

	//下注计算
private:
	//最大下注
	LONGLONG GetMaxPlayerScore( BYTE cbBetArea, WORD wChairID );

	//游戏统计
private:
	//游戏结束计算
	LONGLONG GameOver();
	//计算得分
    bool CalculateScore(OUT LONGLONG& lBankerWinScore, OUT tagServerGameRecord& GameRecord, BYTE cbDispatchCount);
	//推断赢家
	void DeduceWinner(BYTE* pWinArea);
	// 记录函数
	void WriteInfo( LPCTSTR pszFileName, LPCTSTR pszString );
	//获取会员等级
	int GetMemberOrderIndex(VIPINDEX vipIndex);
};

//////////////////////////////////////////////////////////////////////////

#endif

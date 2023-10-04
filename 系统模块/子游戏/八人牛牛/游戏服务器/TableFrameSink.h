#ifndef TABLE_FRAME_SINK_HEAD_FILE
#define TABLE_FRAME_SINK_HEAD_FILE

#pragma once

#include "Stdafx.h"
#include "GameLogic.h"
#include "HistoryScore.h"
#include "DlgCustomRule.h"
#include "ServerDebug.h"
#include "GameVideo.h"

#pragma warning(disable : 4244)
#pragma warning(disable : 4800)

//游戏结束
struct CMD_S_GameEndEx
{
	CMD_S_GameEnd				GameEnd;
	DWORD						dwTickCountGameEnd;
};

//////////////////////////////////////////////////////////////////////////

//游戏桌子类
class CTableFrameSink : public ITableFrameSink, public ITableUserAction
{
	//游戏变量
protected:
	BYTE							m_cbTimeRemain;							//重连剩余秒数
	WORD							m_wBankerUser;							//庄家用户
	WORD							m_wFirstEnterUser;						//首进玩家CHAIRID (对霸王庄有效)
	CList<WORD, WORD&>				m_listEnterUser;						//进去玩家CHAIRID顺序
	CList<WORD, WORD&>				m_listCardTypeOrder;					//牌型顺序
	bool							m_bReNewTurn;							//新开一局标志
	LONGLONG						m_lExitScore;							//强退分数
	
	//用户数据
protected:
	BYTE                            m_cbDynamicJoin[GAME_PLAYER];           //动态加入
	BYTE							m_cbPlayStatus[GAME_PLAYER];			//游戏状态
	BYTE							m_cbCallBankerStatus[GAME_PLAYER];		//叫庄状态
	BYTE							m_cbCallBankerTimes[GAME_PLAYER];		//叫庄倍数
	BYTE							m_cbPrevCallBankerTimes[GAME_PLAYER];	//上一局叫庄倍数

	bool							m_bOpenCard[GAME_PLAYER];				//开牌标识
	LONGLONG						m_lTableScore[GAME_PLAYER];				//下注数目
	bool							m_bBuckleServiceCharge[GAME_PLAYER];	//收服务费

	//扑克变量
protected:
	BYTE							m_cbOriginalCardData[GAME_PLAYER][MAX_CARDCOUNT];//桌面扑克
	BYTE							m_cbHandCardData[GAME_PLAYER][MAX_CARDCOUNT];//桌面扑克
	bool							m_bSpecialCard[GAME_PLAYER];			//特殊牌型标志 （四花牛，五花牛，顺子，同花，葫芦，炸弹，同花顺，五小牛）
	BYTE							m_cbOriginalCardType[GAME_PLAYER];		//玩家原始牌型（没有经过玩家组合的牌型）
	BYTE							m_cbCombineCardType[GAME_PLAYER];       //玩家组合牌型（经过玩家组合的牌型）

	//下注信息
protected:
	LONGLONG						m_lTurnMaxScore[GAME_PLAYER];			//最大下注

	//组件变量
protected:
	CGameLogic						m_GameLogic;							//游戏逻辑
	ITableFrame						* m_pITableFrame;						//框架接口
	CHistoryScore					m_HistoryScore;							//历史成绩
	tagGameServiceOption		    *m_pGameServiceOption;					//配置参数
	tagGameServiceAttrib			*m_pGameServiceAttrib;					//游戏属性

	//属性变量
protected:
	WORD							m_wPlayerCount;							//游戏人数
	
	//游戏规则
protected:
	CARDTYPE_CONFIG					m_ctConfig;
	SENDCARDTYPE_CONFIG				m_stConfig;
	KING_CONFIG						m_gtConfig;
	BANERGAMETYPE_CONFIG			m_bgtConfig;
	BETTYPE_CONFIG					m_btConfig;
	TUITYPE_CONFIG					m_tyConfig;

	//自由配置额度(无效值0)
	LONG							m_lFreeConfig[MAX_CONFIG];

	//百分比配置额度(无效值0)
	LONG							m_lPercentConfig[MAX_CONFIG];

	LONG							m_lMaxCardTimes;						//牌型最大倍数
	
	CMD_S_RECORD					m_stRecord;								//游戏记录

	CMD_S_RoomCardRecord			m_RoomCardRecord;						//房卡游戏记录
	CList<SCORE, SCORE&>			m_listWinScoreRecord[GAME_PLAYER];

	BYTE							m_cbTrusteeDelayTime;					//托管延迟时间

	//////////////////////////优化内容
	LONG							m_lBeBankerCondition;					//上庄分数 INVALID_DWORD为无限制或没配置（霸王庄必显示）
	LONG							m_lPlayerBetTimes;						//闲家推注 INVALID_DWORD为无限制或没配置(可供显示，默认无)
	BYTE							m_cbAdmitRevCard;						//允许搓牌 INVALID_BYTE为无限制或没配置(可供显示，默认无)
	BYTE							m_cbMaxCallBankerTimes;					//最大抢庄倍数 INVALID_BYTE为无限制或没配置（倍数抢庄必显示）
	BYTE							m_cbEnableCardType[MAX_SPECIAL_CARD_TYPE];//牌型激活  TRUE激活FALSE禁用 INVALID_BYTE以后台配置为准
	BYTE							m_cbClassicTypeConfig;					//配置为0则牛牛X4 牛九X3 牛八X2 牛七X2  配置为1则牛牛X3 牛九X2 牛八X2 牛七X1 INVALID_BYTE以后台为准

	LONG							m_lBgtDespotWinScore;					//私人房霸王庄庄家统计输赢
	WORD							m_wBgtRobNewTurnChairID;				//倍数抢庄新开一局抢庄的玩家（无效为INVALID_CHAIR）
	
	BYTE							m_cbRCOfflineTrustee;					//房卡断线代打

	///////////以下变量供推注功能使用
	bool							m_bLastTurnBeBanker[GAME_PLAYER];		//上局庄家标志
	LONGLONG						m_lLastTurnWinScore[GAME_PLAYER];		//上局得分
	bool							m_bLastTurnBetBtEx[GAME_PLAYER];		//上局推注标识
	LONG							m_lPlayerBetBtEx[GAME_PLAYER];			//闲家额外的推注筹码

#ifdef CARD_CONFIG
	BYTE							m_cbconfigCard[GAME_PLAYER][MAX_CARDCOUNT];	//桌面扑克
#endif

	CMD_S_GameEndEx					m_GameEndEx;

	//服务调试
protected:
	HINSTANCE						m_hInst;								//调试句柄
	IServerDebug*					m_pServerDebug;						//调试组件

	//游戏视频
protected:
	HINSTANCE						m_hVideoInst;
	IGameVideo*						m_pGameVideo;

	//函数定义
public:
	//构造函数
	CTableFrameSink();
	//析构函数
	virtual ~CTableFrameSink();

	//基础接口
public:
	//释放对象
	virtual VOID Release() { delete this; }
	//接口查询
	virtual void * QueryInterface(const IID & Guid, DWORD dwQueryVer);

	//管理接口
public:
	//初始化
	virtual bool Initialization(IUnknownEx * pIUnknownEx);
	//复位桌子
	virtual void RepositionSink();
	//游戏事件
public:
	//游戏开始
	virtual bool OnEventGameStart();
	//游戏结束
	virtual bool OnEventGameConclude(WORD wChairID, IServerUserItem * pIServerUserItem, BYTE cbReason);
	//发送场景
	virtual bool OnEventSendGameScene(WORD wChairID, IServerUserItem * pIServerUserItem, BYTE bGameStatus, bool bSendSecret);


	//事件接口
public:
	//定时器事件
	virtual bool OnTimerMessage(DWORD dwTimerID, WPARAM wBindParam);
	//游戏消息处理
	virtual bool OnGameMessage(WORD wSubCmdID, void * pDataBuffer, WORD wDataSize, IServerUserItem * pIServerUserItem);
	//框架消息处理
	virtual bool OnFrameMessage(WORD wSubCmdID, void * pDataBuffer, WORD wDataSize, IServerUserItem * pIServerUserItem);
	//数据事件
	virtual bool OnGameDataBase(WORD wRequestID, VOID * pData, WORD wDataSize){return true;}

	//查询接口
public:
	//查询限额
	virtual SCORE QueryConsumeQuota(IServerUserItem * pIServerUserItem);
	//最少积分
	virtual SCORE QueryLessEnterScore(WORD wChairID, IServerUserItem * pIServerUserItem){return 0;}
	//查询服务费
	virtual bool QueryBuckleServiceCharge(WORD wChairID);
	//数据事件
	virtual bool OnDataBaseMessage(WORD wRequestID, VOID * pData, WORD wDataSize){return false;}
	//积分事件
	virtual bool OnUserScroeNotify(WORD wChairID, IServerUserItem * pIServerUserItem, BYTE cbReason){return false;}
	//设置基数
	virtual void SetGameBaseScore(LONG lBaseScore){return;}


	//用户事件
public:
	//用户断线
	virtual bool OnActionUserOffLine(WORD wChairID, IServerUserItem * pIServerUserItem);
	//用户重入
	virtual bool OnActionUserConnect(WORD wChairID, IServerUserItem * pIServerUserItem) { return true; };
	//用户坐下
	virtual bool OnActionUserSitDown(WORD wChairID, IServerUserItem * pIServerUserItem, bool bLookonUser);
	//用户起立
	virtual bool OnActionUserStandUp(WORD wChairID, IServerUserItem * pIServerUserItem, bool bLookonUser);
	//用户同意
	virtual bool OnActionUserOnReady(WORD wChairID, IServerUserItem * pIServerUserItem, VOID * pData, WORD wDataSize);

	//游戏事件
protected:
	//叫庄事件
	bool OnUserCallBanker(WORD wChairID, bool bBanker, BYTE cbBankerTimes);
	//加注事件
	bool OnUserAddScore(WORD wChairID, LONGLONG lScore);
	//摊牌事件
	bool OnUserOpenCard(WORD wChairID, BYTE cbCombineCardData[MAX_CARDCOUNT]);
	//写分函数
	bool TryWriteTableScore(tagScoreInfo ScoreInfoArray[]);

	//功能函数
protected:
	//扑克分析
	void AnalyseCard(SENDCARDTYPE_CONFIG stConfig);
	//最大下分
	SCORE GetUserMaxTurnScore(WORD wChairID);
	//判断库存
	bool JudgeStock();
	//是否衰减
	bool NeedDeductStorage();
	//读取配置
	void ReadConfigInformation();
	//更新房间用户信息
	void UpdateRoomUserInfo(IServerUserItem *pIServerUserItem, USERACTION userAction);
	//更新同桌用户调试
	void UpdateUserDebug(IServerUserItem *pIServerUserItem);
	//除重用户调试
	void TravelDebugList(ROOMUSERDEBUG keyroomuserdebug);
	//是否满足调试条件
	void IsSatisfyDebug(ROOMUSERINFO &userInfo, bool &bEnableDebug);
	//分析房间用户调试
	bool AnalyseRoomUserDebug(ROOMUSERDEBUG &Keyroomuserdebug, POSITION &ptList);
	//获取调试类型
	void GetDebugTypeString(DEBUG_TYPE &debugType, CString &debugTypestr);
	//判断房卡房间
	bool IsRoomCardType();
	//初始默认庄家
	void InitialBanker();
	//搜索特定扑克玩家
	WORD SearchKeyCardChairID(BYTE cbKeyCardData[MAX_CARDCOUNT]);
	//流逝时间
	void EnableTimeElapse(bool bEnable);

	// 写日志文件
	void WriteInfo(LPCTSTR pszFileName, LPCTSTR pszString);
};

//////////////////////////////////////////////////////////////////////////

#endif

#ifndef TABLE_FRAME_SINK_HEAD_FILE
#define TABLE_FRAME_SINK_HEAD_FILE

#pragma once

#include "Stdafx.h"
#include "GameLogic.h"
#include "DlgCustomRule.h"
#include "GameVideo.h"
//////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////

//游戏桌子
class CTableFrameSink : public ITableFrameSink, public ITableUserAction
{
	//房卡配置
protected:
	WORD							m_wPlayerCount;							//游戏人数
	BYTE							m_cbBankerMode;							//庄家模式
	CMD_S_RECORD					m_stRecord;								//游戏记录
	std::vector<LONGLONG>			m_vecRecord[GAME_PLAYER];

	//时间信息
protected:
	BYTE							m_cbTimeStartGame;						//开始时间
	BYTE							m_cbTimeCallBanker;						//叫庄时间
	BYTE							m_cbTimeAddScore;						//下注时间
	BYTE							m_cbTimeOperateCard;					//操作时间

	BYTE							m_cbTimeTrusteeDelay;					//托管延迟时间
	//游戏变量
protected:
	WORD							m_wBankerUser;							//庄家
	WORD							m_wCurrentUser;							//当前玩家
    int                             m_nPlayers;                             //本轮参与人数
	bool							m_bOffLine[GAME_PLAYER];				//断线标识
	bool							m_bOffLineStatus;						//断线状态

	SCORE							m_lTableScore[GAME_PLAYER*2];			//桌面下注
	double							m_dInsureScore[GAME_PLAYER*2];			//保险金

	BYTE							m_cbPlayStatus[GAME_PLAYER];			//玩家状态

	BYTE							m_bStopCard[GAME_PLAYER*2];				//是否停牌
	BYTE							m_bDoubleCard[GAME_PLAYER*2];			//是否加倍
	BYTE							m_bInsureCard[GAME_PLAYER*2];			//是否保险

    LONGLONG                        m_lGameScore[GAME_PLAYER];              //玩家赢分
    double                          m_lCurChoushuiScore;                    //本轮抽水

	//扑克变量
protected:
	BYTE							m_cbCardCount[GAME_PLAYER*2];				//扑克数目
	BYTE							m_cbHandCardData[GAME_PLAYER*2][MAX_COUNT];	//桌面扑克
	BYTE							m_cbRepertoryCard[FULL_COUNT];			//剩余扑克
	BYTE							m_cbRepertoryCount;						//剩余扑克数

	//下注信息
protected:
	SCORE							m_lMaxScore;							//最大下注
	SCORE							m_lCellScore;							//单元下注
	SCORE							m_lMaxUserScore[GAME_PLAYER];
	SCORE							m_lTableScoreAll[GAME_PLAYER];

	//游戏视频
protected:
	HINSTANCE						m_hVideoInst;
	IGameVideo						*m_pGameVideo;

	//组件变量
protected:
	CGameLogic						m_GameLogic;							//游戏逻辑
	ITableFrame						* m_pITableFrame;						//框架接口
	tagGameServiceOption *			m_pGameServiceOption;					//游戏配置
	tagGameServiceAttrib *			m_pGameServiceAttrib;					//游戏属性
	tagCustomRule					*m_pGameCustomRule;						//自定规则

	//服务调试
protected:
	
    bool                            m_bDebug;
    SCORE                           m_DebugTotalScore;                      //本轮调试庄家总输赢
    //调试状态
    bool                            m_bUserWinLose[GAME_PLAYER];
    bool                            m_bCtrlUser[GAME_PLAYER];
    EM_CTRL_TYPE                    m_UserCtrlType[GAME_PLAYER];
    bool                            m_bIsBankerAI;                          //当前庄家是否为AI
    bool                            m_bCtrlBankerWin;                       //本轮是否调试庄家赢


public:
    static CList<SYSCTRL, SYSCTRL&> m_listSysCtrl;							//通用库存调试列表
    static CList<ROOMCTRL, ROOMCTRL&> m_listRoomCtrl;						//房间调试列表
    static CList<USERCTRL, USERCTRL&> m_listUserCtrl;						//玩家调试列表
    static CList<ROOMCTRL_ITEM, ROOMCTRL_ITEM&> m_listRoomCtrlItem;
    static CList<USERCTRL_ITEM, USERCTRL_ITEM&> m_listUserCtrlItem;			//玩家调试列表

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
	//接口查询
	virtual VOID * QueryInterface(REFGUID Guid, DWORD dwQueryVer);

	//管理接口
public:
	//复位接口
	virtual VOID RepositionSink();
	//配置接口
	virtual bool Initialization(IUnknownEx * pIUnknownEx);
	//比赛接口
public:
	//设置基数
	virtual void SetGameBaseScore(LONG lBaseScore){};

	//游戏事件
public:
	//游戏开始
	virtual bool OnEventGameStart();
	//游戏结束
	virtual bool OnEventGameConclude(WORD wChairID, IServerUserItem * pIServerUserItem, BYTE cbReason);
	//发送场景
	virtual bool OnEventSendGameScene(WORD wChairID, IServerUserItem * pIServerUserItem, BYTE cbGameStatus, bool bSendSecret);

	//事件接口
public:
	//定时器事件
	virtual bool OnTimerMessage(DWORD wTimerID, WPARAM wBindParam);
	//游戏消息
	virtual bool OnGameMessage(WORD wSubCmdID, VOID * pData, WORD wDataSize, IServerUserItem * pIServerUserItem);
	//框架消息
	virtual bool OnFrameMessage(WORD wSubCmdID, VOID * pData, WORD wDataSize, IServerUserItem * pIServerUserItem);

	//用户事件
public:
	//用户断线
	virtual bool OnActionUserOffLine(WORD wChairID,IServerUserItem * pIServerUserItem);
	//用户重入
	virtual bool OnActionUserConnect(WORD wChairID, IServerUserItem * pIServerUserItem);
	//用户坐下
	virtual bool OnActionUserSitDown(WORD wChairID,IServerUserItem * pIServerUserItem, bool bLookonUser);
	//用户起立
	virtual bool OnActionUserStandUp(WORD wChairID,IServerUserItem * pIServerUserItem, bool bLookonUser);
	//用户同意
	virtual bool OnActionUserOnReady(WORD wChairID,IServerUserItem * pIServerUserItem, VOID * pData, WORD wDataSize) { return true; }
	//查询接口
public:
	//查询限额
	virtual SCORE QueryConsumeQuota(IServerUserItem * pIServerUserItem){return 0;}
	//最少积分
	virtual SCORE QueryLessEnterScore(WORD wChairID, IServerUserItem * pIServerUserItem){return 0;}
	//数据事件
	virtual bool OnDataBaseMessage(WORD wRequestID, VOID * pData, WORD wDataSize){return false;}
	//积分事件
	virtual bool OnUserScroeNotify(WORD wChairID, IServerUserItem * pIServerUserItem, BYTE cbReason){return false;}
	//查询是否扣服务费
	virtual bool QueryBuckleServiceCharge(WORD wChairID){return true;}
	//游戏事件
protected:
	//放弃事件
	bool OnUserStopCard(WORD wChairID);
	//加注事件
	bool OnUserAddScore(WORD wChairID, LONGLONG lScore);
	//玩家加倍
	bool OnUserDoubleScore( WORD wChairID );
	//玩家分牌
	bool OnUserSplitCard( WORD wChairID );
	//玩家下保险
	bool OnUserInsure( WORD wChairID );
	//玩家要牌
	bool OnUserGetCard( WORD wChairID ,bool bSysGet);

	//发送消息
	void SendInfo(CString str, WORD wChairID = INVALID_CHAIR);
	//读取配置
	void ReadConfigInformation();
	
	//获取调试类型
	void GetDebugTypeString(DEBUG_TYPE &debugType, CString &debugTypestr);
	//写日志文件
	void WriteInfo(LPCTSTR pszString);


    //更新调试结果
    void UpdateCtrlRes(EM_CTRL_TYPE emCtrlType, SCORE dUserWinScore, BYTE cbChairID, bool bAndroid);
    void UpdateUserCtrlRes(SCORE dUserWinScore, BYTE cbChairID);
    void UpdateRoomCtrlRes(SCORE dUserWinScore, BYTE cbChairID, bool bAndroid);
    void UpdateSysCtrlRes(SCORE dUserWinScore, BYTE cbChairID, bool bAndroid);
    //查找房间调试
    POSITION FindRoomCtrl(DWORD dwSelCtrlIndex);
    //判断房卡房间
    bool IsRoomCardType();
    void UpdateRule(IServerUserItem * pIServerUserItem, bool bIsCleanRoomCtrl = false);
    void SetRule(CMD_C_SetRule &setRule, IServerUserItem * pIServerUserItem);
    void SetRoomCtrl(CMD_C_RoomCtrl &setRule, IServerUserItem * pIServerUserItem);
    void RefreshRoomCtrl(IServerUserItem * pIServerUserItem);
    void SetUserCtrl(CMD_C_UserCtrl &setRule, IServerUserItem * pIServerUserItem);
    void RefreshUserCtrl(IServerUserItem * pIServerUserItem);
    void RefreshAllCtrl(IServerUserItem * pIServerUserItem, bool bFreshAll = false);

    bool UserDianDebug(VOID * pData, WORD wDataSize, IServerUserItem * pIServerUserItem);
    bool QuaryUserInfo(VOID * pData, WORD wDataSize, IServerUserItem * pIServerUserItem);
    void UpdataDianCtrlInfo(WORD wChairID);
    //调试端相关
    //删除房间调试项
    void DeleteRoomCtrItem(DWORD dwCtrlIndex);
    //删除玩家调试项
    void DeleteUserCtrlItem(DWORD dwGameID);
    //删除所有房间调试日志记录
    void DeleteAllRoomCtrItem();
    //删除所有玩家调试日志记录
    void DeleteAllUserCtrlItem();
    //删除指定房间调试日志记录
    void DeleteSelectRoomCtrItem(VOID * pData);
    //删除指定玩家调试日志记录
    void DeleteSelectUserCtrlItem(VOID * pData);
    //删除指定桌子调试log
    void DeleteSelectDeskCtrlItem(VOID * pData);
    //删除所有桌子调试日志记录
    void DeleteAllDeskCtrlItem();
    //取消当前房间调试选项
    void CancelRoomCtrItem(VOID * pData);
    //取消当前指定玩家调试选项
    void CancelUserCtrItem(VOID * pData);

    //更新房间用户信息
    void UpdateRoomUserInfo(IServerUserItem *pIServerUserItem, USERACTION userAction);
    //分析庄家调试
    bool AnalyseRoomUserDebug(ROOMDESKDEBUG &Keyroomuserdebug, POSITION &ptList);
   
    void RefreshRoomCtrLog();
    void RefreshUserCtrlLog(IServerUserItem * pIServerUserItem);
    void RefreshUserCtrlItem(USERCTRL &userctrl);
    void RefreshRoomCtrlItem(ROOMCTRL &roomctrl);

    //获取本轮调试玩家输赢结果
    void GetUserDebugResult(bool bUserWinLose[GAME_PLAYER], bool bCtrlUser[GAME_PLAYER], EM_CTRL_TYPE UserCtrlType[GAME_PLAYER]);
    //获取玩家调试类型
    EM_CTRL_TYPE GetUserCtrlType(WORD wChairID);
    //服务调试
    void ServiceDebug();
    //调试
    void DebugWinLose();
    void DeskDebug(SCORE    lbankerWinScore);
    //本轮是否需要调试
    bool IsNeedDebug();

    void CaculateScore(BYTE &cbBankerCardType);
    void ChangeBanker(BYTE &cbBankerCardType);
    //调试牌处理
    void DebugUserGetCard(BYTE cbOperateIndex,WORD wChairID);
    void DebugBankerWinlose(BYTE cbOperateIndex);
   
};

//////////////////////////////////////////////////////////////////////////////////

#endif
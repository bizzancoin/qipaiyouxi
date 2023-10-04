#ifndef TABLE_FRAME_SINK_HEAD_FILE
#define TABLE_FRAME_SINK_HEAD_FILE

#pragma once

#include "Stdafx.h"
#include "GameLogic.h"
#include "DlgCustomRule.h"
#include "GameControl.h"

#pragma warning(disable : 4244)

#ifdef _DEBUG
	#define ATT_SERVER_CARD_CONFIG
#endif

//////////////////////////////////////////////////////////////////////////

//游戏桌子类
class CTableFrameSink : public ITableFrameSink, public ITableUserAction
{
	//函数定义
public:
	//构造函数
	CTableFrameSink();
	//析构函数
	virtual ~CTableFrameSink();

	//基础接口
public:
	//释放对象
	virtual VOID  Release() { delete this; }
	//接口查询
	virtual VOID * QueryInterface(const IID &Guid, DWORD dwQueryVer);

	//管理接口
public:
	//初始化
	virtual bool Initialization(IUnknownEx *pIUnknownEx);
	//复位桌子
	virtual VOID RepositionSink();

	//游戏事件
public:
	//游戏开始
	virtual bool OnEventGameStart();
	//游戏结束
	virtual bool OnEventGameConclude(WORD wChairID, IServerUserItem *pIServerUserItem, BYTE cbReason);
	//发送场景
	virtual bool OnEventSendGameScene(WORD wChairID, IServerUserItem *pIServerUserItem, BYTE cbGameStatus, bool bSendSecret);

	//事件接口
public:
	//定时器事件
	virtual bool OnTimerMessage(DWORD wTimerID, WPARAM wBindParam);
	//游戏消息处理
	virtual bool OnGameMessage(WORD wSubCmdID, VOID *pData, WORD wDataSize, IServerUserItem *pIServerUserItem);
	//框架消息处理
	virtual bool OnFrameMessage(WORD wSubCmdID, VOID *pData, WORD wDataSize, IServerUserItem *pIServerUserItem);
	//数据事件
	virtual bool OnGameDataBase(WORD wRequestID, VOID *pData, WORD wDataSize);

	//动作事件
public:
	//用户断线
	virtual bool OnActionUserOffLine(WORD wChairID,IServerUserItem *pIServerUserItem);
	//用户重入
	virtual bool OnActionUserConnect(WORD wChairID,IServerUserItem *pIServerUserItem) { return true; }
	//用户坐下
	virtual bool OnActionUserSitDown(WORD wChairID,IServerUserItem *pIServerUserItem, bool bLookonUser);
	//用户起来
	virtual bool OnActionUserStandUp(WORD wChairID,IServerUserItem *pIServerUserItem, bool bLookonUser);
	//用户同意
	virtual bool OnActionUserOnReady(WORD wChairID,IServerUserItem *pIServerUserItem, VOID *pData, WORD wDataSize) { return true; }
	//查询接口
public:
	//查询限额
	virtual SCORE QueryConsumeQuota(IServerUserItem *pIServerUserItem);
	//最少积分
	virtual SCORE QueryLessEnterScore(WORD wChairID, IServerUserItem *pIServerUserItem){return 0;}
	//数据事件
	virtual bool OnDataBaseMessage(WORD wRequestID, VOID *pData, WORD wDataSize){return false;}
	//积分事件
	virtual bool OnUserScroeNotify(WORD wChairID, IServerUserItem *pIServerUserItem, BYTE cbReason){return false;}
	//查询是否扣服务费
	virtual bool QueryBuckleServiceCharge(WORD wChairID);
	//设置基数
	virtual void SetGameBaseScore(LONG lBaseScore){};

	//功能函数
public:
	//奖池递增
	void IncreaseBonus();
	//更新poker points
	void UpdatePokerPoints();
	//更新record
	void UpdateRecord(BYTE cbCardTypeIndex);
	//获得牌型倍率
	LONG GetCardTypeRadio(BYTE cbCardTypeIndex);
	//写日志文件
	void WriteInfo(LPCTSTR pszString);
    void UpdateRoomUserInfo(IServerUserItem *pIServerUserItem, EM_USER_ACTION emUserAction, LONGLONG lGameScore);

	//发牌
	void DispatchCardData();
	//计算分数
	LONG CalculateScore(ENUMCARDTYPE *pEnumCardType, INT nEnumCardCount, SCOREEX &lSysMaxScore, SCOREEX &lSysMinScore, BYTE cbMaxCardData[MAX_CARD_COUNT]);
	//整理控牌结果
	void ArrangeControlCards(BYTE cbFirstCards[MAX_CARD_COUNT], BYTE cbSceconCards[MAX_CARD_COUNT], BYTE cbMaxCards[MAX_CARD_COUNT]);

#ifdef ATT_SERVER_CARD_CONFIG
	//配置扑克
	void ReadCardConfig(BYTE cbFirstCardData[MAX_CARD_COUNT], BYTE cbSecondCardData[MAX_CARD_COUNT], GUESSRECORD *pGuessRecord = NULL);
#endif

    //更新调试结果
    void UpdateCtrlRes(EM_CTRL_TYPE emCtrlType, SCORE lTotalGameScore, IServerUserItem * pIServerUserItem);
 
    //调试输赢
    bool DebugWinLose(IServerUserItem * pIServerUserItem);
    //获取玩家调试类型
    EM_CTRL_TYPE GetUserCtrlType();
    void UpdateRule(IServerUserItem * pIServerUserItem);
    void SetRule(CMD_C_SetRule &setRule, IServerUserItem * pIServerUserItem);
    void SetRoomCtrl(CMD_C_RoomCtrl &setRule, IServerUserItem * pIServerUserItem);
    void RefreshRoomCtrl(IServerUserItem * pIServerUserItem);
    void SetUserCtrl(CMD_C_UserCtrl &setRule, IServerUserItem * pIServerUserItem);
    void RefreshUserCtrl(IServerUserItem * pIServerUserItem);
    void RefreshAllCtrl(IServerUserItem * pIServerUserItem);
    //查询用户调试
    POSITION FindUserCtrl(DWORD dwSelCtrlIndex);
    //查找房间调试
    POSITION FindRoomCtrl(DWORD dwSelCtrlIndex);
    //读取数据
    SCORE ReadFileValue(LPCTSTR pszKeyName, LPCTSTR pszItemName, UINT nDefault);
    //写入数据
    void WriteFileValue(LPCTSTR pszKeyName, LPCTSTR pszItemName, SCORE lValue);
    //工作目录
    bool GetWorkDirectory(TCHAR szWorkDirectory[], WORD wBufferCount);
	//组件变量
protected:
	CGameLogic						m_GameLogic;							//游戏逻辑
	ITableFrame						*m_pITableFrame;						//框架接口
	tagGameServiceOption			*m_pGameServiceOption;					//配置参数
	tagGameServiceAttrib			*m_pGameServiceAttrib;					//游戏属性
	tagCustomRule					*m_pGameCustomRule;						//自定规则


	//游戏变量
protected:
	BONUS							m_Bonus;								//奖池
	LONG							m_lbureauCount;							//游戏局数
	LONG							m_lBet;									//下注的筹码
	BET_RADIO						m_lBetRadio[MAX_CARD_CT];				//牌型倍率
	bool							m_balreadySwitch;						//是否转换
	bool							m_bSwitchFlag[MAX_CARD_COUNT];			//转换标识
	bool							m_bGuess;								//是否压大小
	GUESSRECORD						m_guessRecord[MAX_GUESS_COUNT];			//猜大小记录
	BYTE							m_cbGuessCardResultRecord[MAX_GUESS_COUNT];	//猜大小牌记录
	WORD							m_wCurrentGuessCount;					//猜大小局数
	bool							m_bLuckyTimePause;						//暂停标识
	bool							m_bAuto;								//自动标识
	RECORD_INFO						m_recordInfo;							//记录信息

    SCORE                           m_lBetItem[10];

	//扑克变量
protected:
	BYTE							m_cbFirstCardData[MAX_CARD_COUNT];		//第一次扑克列表
	BYTE							m_cbSecondCardData[MAX_CARD_COUNT];		//第二次扑克列表
	BYTE							m_cbSwitchCardData[MAX_CARD_COUNT];		//经过切换的扑克列表
	BYTE							m_cbLuckyCardData[LUCKYTIME_CARDDATA_COUNT];	//LuckyCard
    BYTE                            m_GussIndex;                  
public:

    CTime							m_tmStartRecord;						    //开始记录时间

	//调试控制相关
public:
	//
	static CGameControl		m_gameStorage;
	//初始化系统库存
	void InitSystemStorage();
	//事件处理
	bool OnDebugEvent(VOID *pData, WORD wDataSize, IServerUserItem *pIServerUserItem);
   
};
//////////////////////////////////////////////////////////////////////////

#endif

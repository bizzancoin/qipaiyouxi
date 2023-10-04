
#ifndef TABLE_FRAME_SINK_H_
#define TABLE_FRAME_SINK_H_

#include "bullet.h"
#include "fish.h"
#include "entity_manager.h"
#include "scene_fish_manager.h"

#ifndef _UNICODE
#define myprintf	_snprintf
#define mystrcpy	strcpy
#define mystrlen	strlen
#define myscanf		_snscanf
#define	myLPSTR		LPCSTR
#else
#define myprintf	swprintf
#define mystrcpy	wcscpy
#define mystrlen	wcslen
#define myscanf		_snwscanf
#define	myLPSTR		LPWSTR
#endif

class CTableFrameSink : public ITableFrameSink, public ITableUserAction 
{
private:
	ITableFrame*					m_pITableFrame;
	tagGameServiceOption*			m_pGameServiceOption;
	tagGameServiceAttrib*			m_pGameServiceAttrib;
	DWORD							m_dwLasttime;
	DWORD							m_dwStarttime;
	DWORD							m_dwLastSceneTime;
	DWORD							m_dwLastWriteScoretime;
	DWORD							m_dwLastDeductStoragetime;
	DWORD							m_dwAndroidSceneTime;

	DWORD							m_dwSceneLastTime;
	int								m_nSceneBatch;
	int								m_nSceneKind;

	SCORE							m_lExchangeFishScore[GAME_PLAYER];//炮筒上分
	SCORE							m_lFishScore[GAME_PLAYER];//打到的分+炮筒上分

	DWORD							m_dwEnterGameTime[GAME_PLAYER];//cy add
	DWORD							m_dwLastFireTime[GAME_PLAYER];
	int								m_nCurrentBulletMulriple[GAME_PLAYER];

	int								m_nAndroidTargetMulriple[GAME_PLAYER];
	float							m_fAndroidChangeBulletTime[GAME_PLAYER];

	EntityManager<Fish>				m_pFishManager;
	EntityManager<Bullet>			m_pBulletManager;
	typedef std::vector<DWORD> EntityIDs;
	

	EntityIDs						m_pAndroidTargetFish[GAME_PLAYER];
	float							m_fAndroidFireElapsed[GAME_PLAYER];
	//炮火操作时间
	float							m_fFireOperateTime[GAME_PLAYER];
	int								m_nFireOperateType[GAME_PLAYER];
	int								m_nLastLockFishId[GAME_PLAYER];

	WORD							m_wReplaceCatch[GAME_PLAYER][GAME_PLAYER-1];
	float							m_fAndroidRandAngle[GAME_PLAYER];

	float							m_fAndroidGameTime[GAME_PLAYER];
	float							m_fAndroidGameElapsed[GAME_PLAYER];

	float							m_fDistributeElapsed[FISH_KIND_COUNT];
	typedef std::vector<CMD_S_FishInfo*> CMDDistributeFishVector;
	CMDDistributeFishVector			m_pDistributeFishActive; // 待发送鱼数组
	CMDDistributeFishVector			m_pDistributeFishStorage;

	float							m_fSceneElapsed;
	
	int								m_nSceneStatus;
	TCHAR							m_szConfigFileName[MAX_PATH];			//配置文件

public:
	CTableFrameSink();
	virtual ~CTableFrameSink();

	virtual VOID Release() { delete this; }
	virtual VOID* QueryInterface(REFGUID guid, DWORD query_ver);

	virtual bool Initialization(IUnknownEx* unknownex);
	virtual VOID RepositionSink();

	virtual SCORE QueryConsumeQuota(IServerUserItem* pIServerUserItem) { return 0; }
	virtual SCORE QueryLessEnterScore(WORD chair_id, IServerUserItem* pIServerUserItem) { return 0; }
	virtual bool QueryBuckleServiceCharge(WORD chair_id) { return true; }
	virtual void SetGameBaseScore(SCORE base_score) {}
	virtual bool OnDataBaseMessage(WORD request_id, VOID* data, WORD data_size) { return false; }
	virtual bool OnUserScroeNotify(WORD chair_id, IServerUserItem* pIServerUserItem, BYTE reason) { return false; }
	virtual bool OnEventGameStart();
	virtual bool OnEventGameConclude(WORD chair_id, IServerUserItem* pIServerUserItem, BYTE reason);
	virtual bool OnEventSendGameScene(WORD chair_id, IServerUserItem* pIServerUserItem, BYTE game_status, bool send_secret);

	//百人游戏获取游戏记录
	virtual void OnGetGameRecord(VOID *GameRecord) {};

	//获取百人游戏是否下注状态而且玩家下注了
	virtual bool OnGetUserBetInfo(WORD wChairID, IServerUserItem * pIServerUserItem);

	virtual bool OnTimerMessage(DWORD timer_id, WPARAM bind_param);
	virtual bool OnGameMessage(WORD sub_cmdid, void* data, WORD data_size, IServerUserItem* pIServerUserItem);
	virtual bool OnFrameMessage(WORD sub_cmdid, void* data, WORD data_size, IServerUserItem* pIServerUserItem);

	//用户断线
	virtual bool OnActionUserOffLine(WORD wChairID, IServerUserItem * pIServerUserItem) { return true; }
	virtual bool OnActionUserConnect(WORD wChairID, IServerUserItem * pIServerUserItem) { return true; }
	virtual bool OnActionUserSitDown(WORD chair_id, IServerUserItem* pIServerUserItem, bool lookon_user);
	virtual bool OnActionUserStandUp(WORD chair_id, IServerUserItem* pIServerUserItem, bool lookon_user);
	virtual bool OnActionUserOnReady(WORD chair_id, IServerUserItem * pIServerUserItem, void* data, WORD data_size) { return true; }
private:
	bool OnSubUserFire(IServerUserItem* pIServerUserItem, float fBulletAngle, DWORD dwBulletIndex);
	bool OnSubUserCatchFish(IServerUserItem* pIServerUserItem, DWORD dwBulletIndex, DWORD dwFishIndex);
	bool OnSubTimerSync(IServerUserItem* pIServerUserItem);
	void OnGameLoop(float delta_time);
	void OnSceneLoop(float delta_time);
	void DistributeFish(float delta_time);
	void BuildFish(FishKind fish_kind);
	void FishDestroy(Entity* entity);
	void BulletDestroy(Entity* entity);
	void GameUpdate(float delta_time);
	void SceneUpdate(float delta_time);
	void AndroidUpdate(float delta_time);
	void SendSceneFish(IServerUserItem* pIServerUserItem);
	void SendSceneBullets(IServerUserItem* pIServerUserItem);
	void CalcScore(IServerUserItem* pIServerUserItem, BYTE reason);
	WORD GetRandPathID(FishKind fish_kind,WORD &wStep);
	int GetStyleID();

	bool GetCheckFireError(SCORE lBulletScore, SCORE lFishScore);

	void JudgeReplaceCatchInfo();
};

#endif

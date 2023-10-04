
#ifndef CMD_FISH_H_
#define CMD_FISH_H_

#pragma pack(1)

//------------------------------------------------------------------------------
// 服务定义

#define KIND_ID               107
#define GAME_NAME             TEXT("捕鱼大亨")
#define GAME_PLAYER           4
#define VERSION_SERVER        PROCESS_VERSION(1,0,0)
#define VERSION_CLIENT        PROCESS_VERSION(1,0,0)

//------------------------------------------------------------------------------

const DWORD m_kGameLoopElasped = 3000;	//毫秒判断
const DWORD m_kSceneElasped = 30;	//毫秒判断
const DWORD m_kAndroidElasped = 200;
const float m_kAndroidFireElasped = 0.2;

const DWORD m_kMaxFishInManager = 350;
const DWORD m_kMaxBulletsInManager = 400;
const float m_kTideActionDuration = 3.0f;

enum FishKind 
{
	FISH_DAYANYU = 0,         // 大眼鱼
	FISH_XIAOLVYU,            // 小绿鱼
	FISH_XIAOHONGYU,          // 小红鱼
	FISH_XIAOHUANGYU,         // 小黄鱼
	FISH_XIAOLANYU,	          // 小蓝鱼
	FISH_XIAOKEDOU,           // 小蝌蚪
	FISH_LVHETUN,             // 绿河豚
	FISH_SHUIMU,              // 水母
	FISH_XIAOHAIGUI,          // 小海龟
	FISH_HUDIEYU,             // 蝴蝶鱼
	FISH_QUNDAIYU,            // 裙带鱼
	FISH_PANGHONGYU,          // 胖红鱼
	FISH_DENGLONGYU,          // 灯笼鱼
	FISH_JIANYU,              // 蓝剑鱼
	FISH_PANGXIE,             // 螃蟹
	FISH_MOGUIYU,             // 魔鬼鱼
	FISH_LANBIANFU,           // 蓝蝙蝠
	FISH_LANCHUISHA,          // 蓝锤头鲨
	FISH_LANSHA,              // 蓝鲨
	FISH_50ZUHE,		      // 50倍组合
	FISH_60ZUHE,              // 60倍组合
	FISH_JINCHUISHA,          // 金锤头鲨
	FISH_70ZUHE,		      // 70倍组合
	FISH_JINSHA,              // 金鲨
	FISH_80ZUHE,              // 80倍组合
	FISH_JINBIANFU,           // 金蝙蝠
	FISH_JINWUGUI,            // 金乌龟
	FISH_JINHAMA,             // 金蛤蟆
	FISH_MEIRENYU,            // 美人鱼
	FISH_ZHANGYU,             // 大章鱼
	FISH_JINLONG,             // 金龙
	FISH_YIWANG1,			  // 一网打尽
	FISH_YIWANG2,			  // 一网打尽
	FISH_YIWANG3,             // 一网打尽
	FISH_YIWANG4,             // 一网打尽
	FISH_YIWANG5,             // 一网打尽

	FISH_KIND_COUNT
};

enum SceneStatus 
{
	SCENE_NONE = 0,
	SCENE_WAIT_TIDE,
	SCENE_RUNNING
};

//------------------------------------------------------------------------------
// 服务端命令
#define SUB_S_FISH							2002        //产生鱼
#define SUB_S_USER_FIRE						2003        //用户发射子弹
#define SUB_S_EXCHANGE_BULLET				2004		//上炮
#define SUB_S_SWITCH_SCENE					2005		//切换场景
#define SUB_S_CATCH_CHAIN					2006		//命中鱼
#define SUB_S_TIMER_SYNC					2007		//时间同步
#define SUB_S_LOCK_FISH						2008        //锁定鱼
#define SUB_S_PLAYER_SYNC					2010		//同步玩家
#define SUB_S_FISH_SYNC						2011		//同步鱼
#define SUB_S_BULLET_SYNC					2012		//同步子弹

#define SUB_S_REPLACE_CATCH					2013		//让玩家帮机器人发送补中鱼消息

//场景还远信息
struct CMD_S_GameScene
{
	int				nSceneID;							//当前场景ID
	SCORE			lBaseScore;							//房间底分
	int				nStyleID;							//界面风格ID
	WORD			wPlayerCount;						//玩家数量
	WORD			wFishCount;							//鱼数量
	WORD			wBulletCount;						//子弹数量
	DWORD			dwServerTicket;						//服务器时间
};

//玩家信息
struct CMD_S_PlayerInfo
{
	int				nPlayerID;							//玩家GAMEID
	WORD			wChairID;							//玩家椅子号
	SCORE			lPlayerScore;						//用户金币
	DWORD			dwPlayerMultiple;					//用户倍数
	DWORD			dwLockFishIndex;					//锁定鱼索引
};

//鱼信息
struct CMD_S_FishInfo
{
	DWORD			dwFishIndex;						//鱼索引
	int				nFishKindID;						//鱼种类ID
	WORD			wPathID;							//路径ID
	WORD			wPath_Index;						//所处索引
	DWORD			dwCreteTicket;						//鱼生成时间
};

//子弹信息
struct CMD_S_BulletInfo
{
	DWORD			dwBulletIndex;						//子弹索引
	int				nPlayerID;							//玩家GAMEID
	DOUBLE			dBulletAngle;						//子弹角度
	DWORD			dwBulletTicket;						//子弹运行时间
};

//用户开火
struct CMD_S_UserFire
{
	int				nPlayerID;							//玩家GAMEID
	DWORD			wBulletIndex;						//子弹索引
	int				nBulletMultiple;					//子弹倍率
	DOUBLE			dBulletAngle;						//子弹角度
	SCORE			lPlayerScore;						//用户金币
	DWORD			dwCreateTicket;						//子弹产生时间
};

//用户切换炮
struct CMD_S_PlayerExchangeBullet
{
	int				nPlayerID;							//玩家GAMEID
	int				nPlayerMultiple;					//用户子弹倍率
};

//命中鱼
struct CMD_S_PlayerCatchFish
{
	int				nPlayerID;							//玩家GAMEID
	DWORD			dwBulletIndex;						//子弹索引
	DWORD			dwFishIndex;						//鱼索引
	SCORE			lFishScore;							//命中获得金币
	SCORE			lPlayerScore;						//用户金币
};

//子弹同步
struct CMD_S_BulletInfoSyn
{
	DWORD			dwBulletIndex;						//子弹索引
	DOUBLE			dCol;
	DOUBLE			dRow;
};

//场景切换
struct CMD_S_CHANGE_SCENE
{
	int				nSceneID;							//场景ID
};

//锁定鱼
struct CMD_S_LockFish
{
	int				nPlayerID;							//玩家GAMEID
	DWORD			dwLockFishIndex;					//锁定鱼索引
};

//时间同步
struct CMD_S_SynTime
{
	DWORD			dwServerTicket;						//服务器时间
};

//让玩家帮机器人发送捕中鱼消息
struct CMD_S_Replace_Catch
{
	DWORD			wMaxReplaceGameID[GAME_PLAYER-1];	//帮忙发送的椅子号
};

//------------------------------------------------------------------------------
// 客户端命令
#define SUB_C_USER_FIRE						1			//用户发射子弹
#define SUB_C_EXCHANGE_BULLET				2			//用户切换炮台
#define SUB_C_CATCH_FISH					3			//捕获鱼
#define SUB_C_TIMER_SYNC					4			//时间同步
#define SUB_C_LOCK_FISH						5			//锁定鱼

//用户开火
struct CMD_C_UserFire
{
	DWORD			dwBulletIndex;						//子弹索引
	DOUBLE			dBulletAngle;						//角度
};

//用户切换炮
struct CMD_C_PlayerExchangeBullet
{
	int				nPlayerBulletMultiple;				//用户子弹倍率
};

//用户打中鱼
struct CMD_C_PlayerCatchFish
{
	WORD			wChairID;							//捕中鱼玩家椅子号
	DWORD			dwBulletIndex;						//子弹索引
	DOUBLE			dBulletRow;							//所在网格
	DOUBLE			dBulletCol;							//所在网格
	DWORD			dwFishIndex;						//鱼索引
	WORD			wPathIndex;						
};

//用户锁定鱼
struct CMD_C_LockFish
{
	DWORD			dwLockFishIndex;					//鱼索引
};

#pragma pack()

#endif
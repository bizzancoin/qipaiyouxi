#pragma once
#include "../游戏服务器/ServerDebug.h"
#include "GameLogic.h"

class CServerDebugItemSink : public IServerDebug
{

	CGameLogic						m_GameLogic;							//游戏逻辑

public:
	CServerDebugItemSink(void);
	virtual ~CServerDebugItemSink(void);

public:
	//返回调试区域
	virtual bool __cdecl DebugResult(BYTE cbDebugCardData[GAME_PLAYER][MAX_CARDCOUNT], ROOMUSERDEBUG Keyroomuserdebug, SENDCARDTYPE_CONFIG stConfig, CARDTYPE_CONFIG ctConfig, KING_CONFIG gtConfig);

};

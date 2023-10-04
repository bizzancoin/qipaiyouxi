#pragma once

#define MAX_COUNT					11									//最大数目

//游戏调试基类
class IServerDebug
{
public:
	IServerDebug(void){};
	virtual ~IServerDebug(void){};

public:
	//服务器调试
	virtual bool __cdecl ServerDebug(BYTE cbHandCardData[GAME_PLAYER*2][11], ITableFrame * pITableFrame) = NULL;
	virtual bool __cdecl ServerDebug(CMD_S_CheatCard *pCheatCard, ITableFrame * pITableFrame) = NULL;

	//返回调试区域
	virtual bool __cdecl DebugResult(BYTE cbDebugCardData[GAME_PLAYER * 2][MAX_COUNT], BYTE	cbCardCount[GAME_PLAYER*2], ROOMUSERDEBUG Keyroomusercontrol, ITableFrame * pITableFrame, WORD wBankerUser, BYTE cbPlayStatus[GAME_PLAYER]) = NULL;
};

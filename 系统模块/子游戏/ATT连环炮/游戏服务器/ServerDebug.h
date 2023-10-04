#pragma once

//游戏调试基类
class IServerDebug
{
public:
	IServerDebug(void){};
	virtual ~IServerDebug(void){};

public:
	//返回调试区域
	virtual bool __cdecl DebugResult(BYTE cbFirstCardData[MAX_CARD_COUNT], BYTE cbSecondCardData[MAX_CARD_COUNT], S_ROOMUSERDEBUG keyRoomUserDebug) = NULL;
};

#pragma once

//游戏视频基类
class IGameVideo
{
public:
	IGameVideo(void){};
	virtual ~IGameVideo(void){};

public:
	//开始录像
	virtual bool __cdecl	StartVideo(ITableFrame	*pTableFrame, BYTE cbPlayerCount) = NULL;
	//停止和保存
	virtual bool __cdecl	StopAndSaveVideo(WORD wServerID,WORD wTableID)	= NULL;
	//增加录像数据
	virtual bool __cdecl    AddVideoData(WORD wMsgKind, Video_GameStart *pVideoGameStart, bool bFirst) = NULL;
	virtual bool __cdecl    AddVideoData(WORD wMsgKind, CMD_S_CallBanker *pVideoCallBanker) = NULL;
	virtual bool __cdecl    AddVideoData(WORD wMsgKind, CMD_S_SendFourCard *pSendFourCard) = NULL;
	virtual bool __cdecl    AddVideoData(WORD wMsgKind,CMD_S_CallBankerInfo *pVideoCallBankerInfo) = NULL;
	virtual bool __cdecl    AddVideoData(WORD wMsgKind,CMD_S_AddScore *pVideoAddScore) = NULL;
	virtual bool __cdecl    AddVideoData(WORD wMsgKind,CMD_S_SendCard *pVideoSendCard) = NULL;
	virtual bool __cdecl    AddVideoData(WORD wMsgKind,CMD_S_Open_Card *pVideoOpen_Card) = NULL;
	virtual bool __cdecl    AddVideoData(WORD wMsgKind,CMD_S_GameEnd *pVideoGameEnd) = NULL;	
};

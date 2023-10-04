#pragma once

//游戏视频基类
class IGameVideo
{
public:
	IGameVideo(void){};
	virtual ~IGameVideo(void){};

public:
	//开始录像
	virtual bool __cdecl	StartVideo(ITableFrame	*pTableFrame)		= NULL;
	//停止和保存
	virtual bool __cdecl	StopAndSaveVideo(WORD wServerID, WORD wTableID, WORD wPlayCount) = NULL;
	//增加录像数据
	virtual bool __cdecl    AddVideoData(WORD wMsgKind, VOID *pData, size_t sDataSize, bool bFirst) = NULL;

};

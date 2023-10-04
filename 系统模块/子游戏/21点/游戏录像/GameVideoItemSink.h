#pragma once
#include "..\服务器组件\GameVideo.h"

class CGameVideoItemSink : public IGameVideo
{
public:
	CGameVideoItemSink(void);
	virtual ~CGameVideoItemSink(void);

public:		
	//开始录像
	virtual bool __cdecl	StartVideo(ITableFrame	*pTableFrame);
	//停止和保存
	virtual bool __cdecl	StopAndSaveVideo(WORD wServerID, WORD wTableID, WORD wPlayCount);
	//增加录像数据
	virtual bool __cdecl    AddVideoData(WORD wMsgKind, VOID *pData, size_t sDataSize, bool bFirst);

protected:
	void					ResetVideoItem();
	bool					RectifyBuffer(size_t iSize);	
	VOID					BuildVideoNumber(CHAR szVideoNumber[], WORD wLen,WORD wServerID,WORD wTableID);

	size_t					Write(const void* data, size_t size);
	size_t					WriteUint8(UINT8 val)   { return Write(&val, sizeof(val)); }
	size_t					WriteUint16(UINT16 val) { return Write(&val, sizeof(val)); }
	size_t					WriteUint32(UINT32 val) { return Write(&val, sizeof(val)); }
	size_t					WriteUint64(UINT64 val) { return Write(&val, sizeof(val)); }
	size_t					WriteInt8(INT8 val)		{ return Write(&val, sizeof(val)); }
	size_t					WriteInt16(INT16 val)	{ return Write(&val, sizeof(val)); }
	size_t					WriteInt32(INT32 val)	{ return Write(&val, sizeof(val)); }
	size_t					WriteInt64(INT64 val)	{ return Write(&val, sizeof(val)); }	

	//数据变量
private:
	ITableFrame	*					m_pITableFrame;						//框架接口
	size_t							m_iCurPos;							//数据位置	
	size_t							m_iBufferSize;						//缓冲长度
	LPBYTE							m_pVideoDataBuffer;					//缓冲指针
};

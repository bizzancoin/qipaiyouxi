#pragma once
#include "../游戏服务器/ServerControl.h"


class CServerControlItemSink : public IServerControl
{
	//控制变量
protected:
	BYTE							m_cbWinSideControl;					//控制输赢
	BYTE							m_cbExcuteTimes;					//执行次数
	int								m_nSendCardCount;					//发送次数

public:
	CServerControlItemSink(void);
	virtual ~CServerControlItemSink(void);

public:
	//服务器控制
	virtual bool __cdecl ServerControl(WORD wSubCmdID, const void * pDataBuffer, WORD wDataSize,
		IServerUserItem * pIServerUserItem, ITableFrame * pITableFrame,const tagGameServiceOption * pGameServiceOption);

	//需要控制
	virtual bool __cdecl NeedControl();

	//返回控制区域
	virtual bool __cdecl ControlResult(BYTE	cbTableCardArray[], BYTE cbCardCount[]);

	//控制信息
	VOID ControlInfo(const void * pBuffer, IServerUserItem * pIServerUserItem, ITableFrame * pITableFrame,const tagGameServiceOption * pGameServiceOption);

	// 记录函数
	VOID WriteInfo( LPCTSTR pszFileName, LPCTSTR pszString );

};

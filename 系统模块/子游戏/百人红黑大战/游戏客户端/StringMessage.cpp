#include "StdAfx.h"
#include ".\stringmessage.h"

#define IDM_CHAT_MESSAGE			WM_USER+208

CStringMessage::CStringMessage(void)
{
}

CStringMessage::~CStringMessage(void)
{
}


//释放对象
VOID CStringMessage::Release()
{
	delete this;
}
//接口查询
VOID * CStringMessage::QueryInterface(REFGUID Guid, DWORD dwQueryVer)
{
	QUERYINTERFACE(IStringMessage,Guid,dwQueryVer);
	QUERYINTERFACE_IUNKNOWNEX(IStringMessage,Guid,dwQueryVer);
	return NULL;
}

//进入事件
bool CStringMessage::InsertUserEnter(LPCTSTR pszUserName)
{
	CString strMessage=TEXT("");
	strMessage.Format(TEXT("%s进来了"),pszUserName);

	SendMessageToEngine(strMessage,0);
	return true;
}
//离开事件
bool CStringMessage::InsertUserLeave(LPCTSTR pszUserName)
{
	CString strMessage=TEXT("");
	strMessage.Format(TEXT("%s离开了"),pszUserName);

	SendMessageToEngine(strMessage,0);
	return true;
}
//断线事件
bool CStringMessage::InsertUserOffLine(LPCTSTR pszUserName)
{
	CString strMessage=TEXT("");
	strMessage.Format(TEXT("%s断线了"),pszUserName);

	SendMessageToEngine(strMessage,0);
	return true;
}

//普通消息
bool CStringMessage::InsertNormalString(LPCTSTR pszString)
{
	
	CString strMessage=TEXT("");
	strMessage+=pszString;

	SendMessageToEngine(strMessage,0);
	
	return true;
}
//系统消息
bool CStringMessage::InsertSystemString(LPCTSTR pszString)
{
	
	CString strMessage=TEXT("");
	strMessage+=pszString;
	
	SendMessageToEngine(strMessage,1);
	//AfxMessageBox(pszString);
	return true;
}
//提示消息
bool CStringMessage::InsertPromptString(LPCTSTR pszString)
{
	
	CString strMessage=TEXT("");
	strMessage+=pszString;

	SendMessageToEngine(strMessage,1);
	
	return true;
}
//公告消息
bool CStringMessage::InsertAfficheString(LPCTSTR pszString)
{
	CString strMessage=TEXT("");
	strMessage+=pszString;

	SendMessageToEngine(strMessage,1);
	
	return true;
}

//定制消息
bool CStringMessage::InsertCustomString(LPCTSTR pszString, COLORREF crColor)
{
	CString strMessage=TEXT("");
	strMessage+=pszString;

	SendMessageToEngine(strMessage,0);

	return true;
}
//定制消息
bool CStringMessage::InsertCustomString(LPCTSTR pszString, COLORREF crColor, COLORREF crBackColor)
{
	return true;
}

//用户表情
bool CStringMessage::InsertExpression(LPCTSTR pszSendUser, LPCTSTR pszImagePath)
{
	return true;
}
//用户表情
bool CStringMessage::InsertExpression(LPCTSTR pszSendUser, LPCTSTR pszImagePath, bool bMyselfString)
{
	return true;
}
//用户表情
bool CStringMessage::InsertExpression(LPCTSTR pszSendUser, LPCTSTR pszRecvUser, LPCTSTR pszImagePath)
{
	return true;
}

//用户聊天
bool CStringMessage::InsertUserChat(LPCTSTR pszSendUser, LPCTSTR pszString, COLORREF crColor)
{
	
	CString strMessage=TEXT("");
	strMessage.Format(TEXT("[%s]:%s"),pszSendUser,pszString);

	SendMessageToEngine(strMessage,2);

	return true;
}
//用户聊天
bool CStringMessage::InsertUserChat(LPCTSTR pszSendUser, LPCTSTR pszRecvUser, LPCTSTR pszString, COLORREF crColor)
{
	return true;
}
//用户私聊
bool CStringMessage::InsertWhisperChat(LPCTSTR pszSendUser, LPCTSTR pszString, COLORREF crColor, bool bMyselfString)
{
	return true;
}

//用户喇叭
bool CStringMessage::InsertUserTrumpet( LPCTSTR pszSendUser,LPCTSTR pszString,COLORREF crColor )
{	
	return true;
}

//用户喇叭
bool CStringMessage::InsertUserTyphon( LPCTSTR pszSendUser,LPCTSTR pszString,COLORREF crColor )
{
	return true;
}

void CStringMessage::SendMessageToEngine(CString strMessage,int nMessageType)
{
	CGameFrameEngine * pGameFrameEngine=CGameFrameEngine::GetInstance();

	if (pGameFrameEngine!=NULL)
	{
		pGameFrameEngine->SendMessage(IDM_CHAT_MESSAGE,WPARAM(strMessage.GetBuffer(0)),nMessageType);
	}

}




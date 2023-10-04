#pragma once

class CStringMessage : public IStringMessage
{

public:
	CStringMessage(void);
	~CStringMessage(void);

	//基础接口
public:
	//释放对象
	virtual VOID Release();
	//接口查询
	virtual VOID * QueryInterface(REFGUID Guid, DWORD dwQueryVer);

	//事件消息
public:
	//进入事件
	virtual bool InsertUserEnter(LPCTSTR pszUserName);
	//离开事件
	virtual bool InsertUserLeave(LPCTSTR pszUserName);
	//断线事件
	virtual bool InsertUserOffLine(LPCTSTR pszUserName);

	//字符消息
public:
	//普通消息
	virtual bool InsertNormalString(LPCTSTR pszString);
	//系统消息
	virtual bool InsertSystemString(LPCTSTR pszString);
	//提示消息
	virtual bool InsertPromptString(LPCTSTR pszString);
	//公告消息
	virtual bool InsertAfficheString(LPCTSTR pszString);

	//定制消息
public:
	//定制消息
	virtual bool InsertCustomString(LPCTSTR pszString, COLORREF crColor);
	//定制消息
	virtual bool InsertCustomString(LPCTSTR pszString, COLORREF crColor, COLORREF crBackColor);

	//表情消息
public:
	//用户表情
	virtual bool InsertExpression(LPCTSTR pszSendUser, LPCTSTR pszImagePath);
	//用户表情
	virtual bool InsertExpression(LPCTSTR pszSendUser, LPCTSTR pszImagePath, bool bMyselfString);
	//用户表情
	virtual bool InsertExpression(LPCTSTR pszSendUser, LPCTSTR pszRecvUser, LPCTSTR pszImagePath);

	//聊天消息
public:
	//用户聊天
	virtual bool InsertUserChat(LPCTSTR pszSendUser, LPCTSTR pszString, COLORREF crColor);
	//用户聊天
	virtual bool InsertUserChat(LPCTSTR pszSendUser, LPCTSTR pszRecvUser, LPCTSTR pszString, COLORREF crColor);
	//用户私聊
	virtual bool InsertWhisperChat(LPCTSTR pszSendUser, LPCTSTR pszString, COLORREF crColor, bool bMyselfString);
	//用户喇叭
	virtual bool InsertUserTrumpet(LPCTSTR pszSendUser,LPCTSTR pszString,COLORREF crColor);
	//用户喇叭
	virtual bool InsertUserTyphon(LPCTSTR pszSendUser,LPCTSTR pszString,COLORREF crColor);
//内部函数
private:
	void SendMessageToEngine(CString strMessage,int nMessageType);

};

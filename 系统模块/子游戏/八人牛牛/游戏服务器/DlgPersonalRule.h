#ifndef GAME_DLG_PERSONAL_RULE_HEAD_FILE
#define GAME_DLG_PERSONAL_RULE_HEAD_FILE

#pragma once

#include "Stdafx.h"
#pragma pack(push)  
#pragma pack(1)

//////////////////////////////////////////////////////////////////////////////////
//配置结构
struct tagOxSixXSpecial
{
	tagPersonalRule					comPersonalRule;

	BYTE							cbBankerModeEnable[MAX_BANKERMODE];	//6种坐庄模式		TRUE则激活，FALSE则不激活
	BYTE							cbGameModeEnable[MAX_GAMEMODE];		//游戏模式			TRUE则激活，FALSE则不激活
	DWORD							cbBeBankerCon[MAX_BEBANKERCON];		//上庄分数 INVALID_DWORD则不激活，0则无
	DWORD							cbUserbetTimes[MAX_USERBETTIMES];	//闲家推注倍数 INVALID_DWORD则不激活，0则无
	BYTE							cbAdvancedConfig[MAX_ADVANCECONFIG];//高级配置			TRUE则激活，FALSE则不激活
	BYTE							cbSpeCardType[MAX_SPECIAL_CARD_TYPE];//牌型激活，		TRUE则激活，FALSE则不激活
	
	tagOxSixXSpecial()
	{
		ZeroMemory(&comPersonalRule, sizeof(comPersonalRule));

		ZeroMemory(cbBankerModeEnable, sizeof(cbBankerModeEnable));
		ZeroMemory(cbGameModeEnable, sizeof(cbGameModeEnable));
		ZeroMemory(cbBeBankerCon, sizeof(cbBeBankerCon));
		ZeroMemory(cbUserbetTimes, sizeof(cbUserbetTimes));
		ZeroMemory(cbAdvancedConfig, sizeof(cbAdvancedConfig));
		ZeroMemory(cbSpeCardType, sizeof(cbSpeCardType));
	}
};

//////////////////////////////////////////////////////////////////////////////////

//配置窗口
class CDlgPersonalRule : public CDialog
{
	//配置变量
protected:
	tagOxSixXSpecial					m_OxSixXSpecialRule;						//配置结构
	int									m_iyoldpos;									//滚动条位置

	//函数定义
public:
	//构造函数
	CDlgPersonalRule();
	//析构函数
	virtual ~CDlgPersonalRule();

	//重载函数
protected:
	//配置函数
	virtual BOOL OnInitDialog();
	//确定函数
	virtual VOID OnOK();
	//取消消息
	virtual VOID OnCancel();

	//功能函数
public:
	//更新控件
	bool FillDataToDebug();
	//更新数据
	bool FillDebugToData();

	//配置函数
public:
	//读取配置
	bool GetPersonalRule(tagOxSixXSpecial & OxSixXSpecialRule);
	//设置配置
	bool SetPersonalRule(tagOxSixXSpecial & OxSixXSpecialRule);

	afx_msg void OnVScroll(UINT nSBCode, UINT nPos, CScrollBar* pScrollBar);
	afx_msg void OnSize(UINT nType, int cx, int cy);

	DECLARE_MESSAGE_MAP()
};
#pragma pack(pop)
//////////////////////////////////////////////////////////////////////////////////

#endif
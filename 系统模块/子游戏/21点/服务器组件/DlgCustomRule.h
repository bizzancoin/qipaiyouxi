#ifndef GAME_DLG_CUSTOM_RULE_HEAD_FILE
#define GAME_DLG_CUSTOM_RULE_HEAD_FILE

#pragma once

#include "Stdafx.h"

//////////////////////////////////////////////////////////////////////////////////

//配置结构
struct tagCustomRule
{
    SCORE							        lConfigSysStorage;				//系统库存(系统要赢的钱)
    SCORE							        lConfigPlayerStorage;			//玩家库存(玩家要赢的钱)
    SCORE							        lConfigParameterK;				//调节系数(百分比):
    SCORE							        lResetParameterK;				//重置区间(百分比):
    SCORE							        lAnchouPercent;				    //暗抽百分比):
	//游戏AI存款取款
	SCORE									lRobotScoreMin;	
	SCORE									lRobotScoreMax;
	SCORE	                                lRobotBankGet; 
	SCORE									lRobotBankGetBanker; 
	SCORE									lRobotBankStoMul; 

	//时间定义	
	BYTE									cbTimeAddScore;				//下注时间
	BYTE									cbTimeGetCard;				//操作时间

	BYTE									cbBankerMode;				//庄家模式

	BYTE									cbTimeTrusteeDelay;			//托管延迟时间
};

//////////////////////////////////////////////////////////////////////////////////

//配置窗口
class CDlgCustomRule : public CDialog
{
	//配置变量
protected:
	tagCustomRule					m_CustomRule;						//配置结构

	//函数定义
public:
	//构造函数
	CDlgCustomRule();
	//析构函数
	virtual ~CDlgCustomRule();

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
	bool GetCustomRule(tagCustomRule & CustomRule);
	//设置配置
	bool SetCustomRule(tagCustomRule & CustomRule);

	DECLARE_MESSAGE_MAP()
};

//////////////////////////////////////////////////////////////////////////////////

#endif
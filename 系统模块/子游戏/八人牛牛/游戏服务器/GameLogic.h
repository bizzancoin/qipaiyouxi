#ifndef GAME_LOGIC_HEAD_FILE
#define GAME_LOGIC_HEAD_FILE

#pragma once

#include "Stdafx.h"

//////////////////////////////////////////////////////////////////////////
//宏定义

//数值掩码
#define	LOGIC_MASK_COLOR				0xF0								//花色掩码
#define	LOGIC_MASK_VALUE				0x0F								//数值掩码

//扑克类型
#define OX_THREE_SAME					102									//三条牌型

//经典模式
#define CT_CLASSIC_OX_VALUE0			0									//无牛
#define CT_CLASSIC_OX_VALUE1			1									//牛一
#define CT_CLASSIC_OX_VALUE2			2									//牛二
#define CT_CLASSIC_OX_VALUE3			3									//牛三
#define CT_CLASSIC_OX_VALUE4			4									//牛四
#define CT_CLASSIC_OX_VALUE5			5									//牛五
#define CT_CLASSIC_OX_VALUE6			6									//牛六
#define CT_CLASSIC_OX_VALUE7			7									//牛七
#define CT_CLASSIC_OX_VALUE8			8									//牛八
#define CT_CLASSIC_OX_VALUE9			9									//牛九
#define CT_CLASSIC_OX_VALUENIUNIU		10									//牛牛
#define CT_CLASSIC_OX_VALUE_FOURFLOWER	11									//四花牛
#define CT_CLASSIC_OX_VALUE_FIVEFLOWER	12									//五花牛
#define CT_CLASSIC_OX_VALUE_SHUNZI		13									//顺子
#define CT_CLASSIC_OX_VALUE_SAMEFLOWER	14									//同花
#define CT_CLASSIC_OX_VALUE_HULU		15									//葫芦
#define CT_CLASSIC_OX_VALUE_BOMB		16									//炸弹
#define CT_CLASSIC_OX_VALUE_TONGHUASHUN	17									//同花顺
#define CT_CLASSIC_OX_VALUE_FIVESNIUNIU	18									//五小牛

//加倍模式
#define CT_ADDTIMES_OX_VALUE0				0									//无牛
#define CT_ADDTIMES_OX_VALUE1				1									//牛一
#define CT_ADDTIMES_OX_VALUE2				2									//牛二
#define CT_ADDTIMES_OX_VALUE3				3									//牛三
#define CT_ADDTIMES_OX_VALUE4				4									//牛四
#define CT_ADDTIMES_OX_VALUE5				5									//牛五
#define CT_ADDTIMES_OX_VALUE6				6									//牛六
#define CT_ADDTIMES_OX_VALUE7				7									//牛七
#define CT_ADDTIMES_OX_VALUE8				8									//牛八
#define CT_ADDTIMES_OX_VALUE9				9									//牛九
#define CT_ADDTIMES_OX_VALUENIUNIU			10									//牛牛
#define CT_ADDTIMES_OX_VALUE_FOURFLOWER		11									//四花牛
#define CT_ADDTIMES_OX_VALUE_FIVEFLOWER		12									//五花牛
#define CT_ADDTIMES_OX_VALUE_SHUNZI			13									//顺子
#define CT_ADDTIMES_OX_VALUE_SAMEFLOWER		14									//同花
#define CT_ADDTIMES_OX_VALUE_HULU			15									//葫芦
#define CT_ADDTIMES_OX_VALUE_BOMB			16									//炸弹
#define CT_ADDTIMES_OX_VALUE_TONGHUASHUN	17									//同花顺
#define CT_ADDTIMES_OX_VALUE_FIVESNIUNIU	18									//五小牛

//////////////////////////////////////////////////////////////////////////

//分析结构
struct tagAnalyseResult
{
	BYTE 							cbBlockCount[4];					//扑克数目
	BYTE							cbCardData[4][MAX_CARDCOUNT];			//扑克数据
	BYTE							cbKingCount;
};

//////////////////////////////////////////////////////////////////////////

//游戏逻辑类
class CGameLogic
{
	//变量定义
public:
	static BYTE						m_cbCardListDataNoKing[52];					//扑克定义
	static BYTE						m_cbCardListDataHaveKing[54];				//扑克定义
	BYTE							m_cbCardTypeTimes[MAX_CARD_TYPE];			//牌型倍数
	BYTE							m_cbEnableCardType[MAX_SPECIAL_CARD_TYPE];	//牌型激活

	//函数定义
public:
	//构造函数
	CGameLogic();
	//析构函数
	virtual ~CGameLogic();

	//类型函数
public:
	//获取类型
	BYTE GetCardType(BYTE cbCardData[], BYTE cbCardCount, CARDTYPE_CONFIG ctConfig = CT_CLASSIC_);
	//获取数值
	BYTE GetCardValue(BYTE cbCardData) { return cbCardData&LOGIC_MASK_VALUE; }
	//获取花色
	BYTE GetCardColor(BYTE cbCardData) { return cbCardData&LOGIC_MASK_COLOR; }
	//获取倍数
	BYTE GetTimes(BYTE cbCardData[], BYTE cbCardCount, CARDTYPE_CONFIG ctConfig = CT_CLASSIC_, BYTE cbCombineCardType = INVALID_BYTE);
	//设置牌型倍数
	void SetCardTypeTimes(BYTE cbCardTypeTimes[MAX_CARD_TYPE]);
	//设置激活特殊牌型
	void SetEnableCardType(BYTE cbEnableCardType[MAX_SPECIAL_CARD_TYPE]);

	//调试函数
public:
	//排列扑克(通用牛牛牌型使用)
	void SortNNCardList(BYTE cbCardData[], BYTE cbCardCount);
	//排列扑克(新加牌型使用)
	void SortCardList(BYTE cbCardData[], BYTE cbCardCount, bool bDescend = true);
	//混乱扑克
	void RandCardList(BYTE cbCardBuffer[], BYTE cbBufferCount, bool bHaveKing = false);
	//功能函数
public:
	//逻辑数值(通用牛牛牌型使用)
	BYTE GetNNCardLogicValue(BYTE cbCardData);
	//逻辑数值(新加牌型使用)
	BYTE GetCardLogicValue(BYTE cbCardData);
	//对比扑克
	bool CompareCard(BYTE cbFirstData[], BYTE cbNextData[], BYTE cbCardCount, CARDTYPE_CONFIG ctConfig = CT_CLASSIC_, BYTE cbFirstTypeEX = INVALID_BYTE, BYTE cbNextTypeEX = INVALID_BYTE);
	//获取牛牛
	bool GetOxCard(BYTE cbCardData[], BYTE cbCardCount);
	//辅助函数
public:
	//分析扑克
	bool AnalysebCardData(const BYTE cbCardData[], BYTE cbCardCount, tagAnalyseResult & AnalyseResult);
	//判断五小牛
	bool IsFiveSNiuNiu(BYTE cbCardData[], BYTE cbCardCount);
	//判断同花顺
	bool IsTongHuaShun(BYTE cbCardData[], BYTE cbCardCount, BYTE cbSortCardData[]);
	//判断同花
	bool IsTongHua(BYTE cbCardData[], BYTE cbCardCount);
	//判断顺子
	bool IsShunZi(BYTE cbCardData[], BYTE cbCardCount, BYTE cbSortCardData[]);
	//判断炸弹
	bool IsBomb(BYTE cbCardData[], BYTE cbCardCount, BYTE cbSortCardData[]);
	//判断葫芦
	bool IsHuLu(BYTE cbCardData[], BYTE cbCardCount, BYTE cbSortCardData[]);
	//判断五花牛
	bool IsFiveFlowerNN(BYTE cbCardData[], BYTE cbCardCount);
	//判断四花牛
	bool IsFourFlowerNN(BYTE cbCardData[], BYTE cbCardCount);
	//是否含有王牌
	bool IsContainKingCard(BYTE cbCardData[], BYTE cbCardCount);
	//获取第一张王牌的索引
	BYTE GetKingCardIndex(BYTE cbCardData[], BYTE cbCardCount);
	//构造扑克
	BYTE ConstructCard(BYTE cbCardLogicValue, BYTE cbCardColor);
	//获取王牌张数
	BYTE GetKingCount(BYTE cbCardData[], BYTE cbCardCount);
	//是否含有A的顺子
	bool IsContainAShunZi(BYTE cbCardData[], BYTE cbCardCount, BYTE cbSortCardData[]);
	//构造牌型，从确定前面4张牌，最后一张牌可变才构造牌型,返回最后一张牌， INVALID_BYTE为无法构造
	BYTE ConstructCardType(CList<BYTE, BYTE&> &cardlist, BYTE cbConstructCardData[MAX_CARDCOUNT], BYTE cbCardType, KING_CONFIG gtConfig);
	//删除目标牌型
	bool RemoveKeyCard(CList<BYTE, BYTE&> &cardlist, BYTE cbKeyCard);
	//获取排序的特殊牌型
	void GetSpecialSortCard(BYTE cbCardType, BYTE cbHandCardData[MAX_CARDCOUNT], BYTE cbCardCount, CARDTYPE_CONFIG ctConfig);
	//发四等五模式下，根据真人中已知的四张牌算出可以组成最大的牌型
	BYTE GetMaxCardTypeSendFourRealPlayer(CList<BYTE, BYTE &> &cardlist, BYTE cbHandCardData[GAME_PLAYER][MAX_CARDCOUNT], CARDTYPE_CONFIG ctConfig, ITableFrame *pITableFrame, BYTE cbPlayStatus[GAME_PLAYER], BYTE cbDynamicJoin[GAME_PLAYER], WORD wPlayerCount);
	//发四等五模式下，单个玩家已知的四张牌算出可以组成最大的牌型
	BYTE GetMaxCardTypeSingle(CList<BYTE, BYTE &> &cardlist, BYTE cbCardData[MAX_CARDCOUNT], CARDTYPE_CONFIG ctConfig);

};

//////////////////////////////////////////////////////////////////////////

#endif

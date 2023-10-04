#ifndef GAME_LOGIC_HEAD_FILE
#define GAME_LOGIC_HEAD_FILE

#pragma once
#include "Stdafx.h"

//////////////////////////////////////////////////////////////////////////

//牌型定义
#define	CT_5K						0                                    //五条
#define	CT_RS						1									 //同花大顺
#define	CT_SF						2									 //同花顺
#define	CT_4K						3									 //四条
#define	CT_FH						4									 //葫芦
#define	CT_FL						5									 //同花
#define	CT_ST						6									 //顺子
#define	CT_3K						7									 //三条
#define	CT_2P						8									 //两对
#define	CT_1P						9									 //一对
#define	CT_INVALID					11									 //无效牌型

//数值掩码
#define	LOGIC_MASK_COLOR			0xF0								//花色掩码
#define	LOGIC_MASK_VALUE			0x0F								//数值掩码

//扑克数目
#define FULL_CARD_COUNT				54									//全副扑克数目
#define LUCKYTIME_CARDDATA_COUNT	13									//全副扑克数目

//////////////////////////////////////////////////////////////////////////

//分析结构
struct tagAnalyseResult
{
	BYTE 							cbBlockCount[4];					//单条，一对，三条，四条的数目
	BYTE							cbCardData[4][MAX_CARD_COUNT];		//扑克数据
};

//枚举牌型
typedef struct 
{
	BYTE							cbEnumCardData[MAX_CARD_COUNT];		//牌数据
	BYTE							cbCardType;							//牌型
}ENUMCARDTYPE;

//游戏逻辑
class CGameLogic
{
	//函数定义
public:
	//构造函数
	CGameLogic();
	//析构函数
	virtual ~CGameLogic();

	//类型函数
public:
	//获取数值
	BYTE GetCardValue(BYTE cbCardData) { return cbCardData&LOGIC_MASK_VALUE; }
	//获取花色
	BYTE GetCardColor(BYTE cbCardData) { return cbCardData&LOGIC_MASK_COLOR;}
	//逻辑数值
	BYTE GetCardLogicValue(BYTE cbCardData);
	//调试函数
public:
	//混乱扑克
	void RandCardList(BYTE cbCardBuffer[], BYTE cbBufferCount);
	//混乱扑克
	void RandLuckyCardList(BYTE cbCardBuffer[], BYTE cbBufferCount);
	//排列扑克
	void SortCardList(BYTE cbCardData[], BYTE cbCardCount);
	//分析扑克
	void AnalysebCardData(BYTE cbCardData[], BYTE cbCardCount, tagAnalyseResult &AnalyseResult);
	//获取类型
	BYTE GetCardType(BYTE cbCardData[], BYTE cbCardCount = MAX_CARD_COUNT);
	//是否含有王牌
	bool IsContainKingCard(BYTE cbCardData[], BYTE cbCardCount = MAX_CARD_COUNT);
	//含有王牌的张数
	BYTE CalcularKingCard(BYTE cbCardData[], BYTE cbCardCount = MAX_CARD_COUNT);
	//是否同花
	bool IsCommonFlower(BYTE cbCardData[], BYTE cbCardCount = MAX_CARD_COUNT);
	//是否顺子
	bool IsFlush(BYTE cbCardData[], BYTE cbCardCount = MAX_CARD_COUNT);
	//是否同花大顺，(10,j,q,k,a,或包含一张王牌)
	bool IsCommonFlowerBigFlush(BYTE cbCardData[], BYTE cbCardCount = MAX_CARD_COUNT);
	//是否同花顺
	bool IsCommonFlowerFlush(BYTE cbCardData[], BYTE cbCardCount = MAX_CARD_COUNT);
	//构造扑克,根据逻辑值和花色,返回扑克
	BYTE ConstructCard(BYTE cbLogicValue, BYTE cbCardColor);
	//分析保留扑克
	VOID AnalyseHeldCard(BYTE cbCardData[], BYTE cbCardCount, bool bHeldFlag[MAX_CARD_COUNT], bool bMark[MAX_CARD_CT]);
	//分析猜大小
	VOID AnalyseGuess(BYTE cbKeyCardData, bool bBig, GUESSRECORD &guessrecord);
	//枚举任意10张牌中抽取5张的所有可能
	INT EnumCardDataCount(BYTE cbFirstCardData[], BYTE cbSecondCardData[]);
	//组合
	VOID GetCombine(BYTE cbElementsArray[], int setLg, int nSelectCount);
	//获得枚举类型
	VOID GetEnumType(BYTE cbElementsArray[], bool *flags, int length);
	//分析枚举扑克类型
	bool AnalyseEnumCard(BYTE cbFirstCardData[], BYTE cbSecondCardData[], BYTE cbEnumCardData[]);
	//获得枚举牌数据
	VOID GetEnumCardData(ENUMCARDTYPE *pEnumCardType, INT nSize);

	//变量定义
private:
	static  BYTE				m_cbCardData[FULL_CARD_COUNT];					     //扑克定义

	static  BYTE				m_cbLuckyTimeCardData[LUCKYTIME_CARDDATA_COUNT];     //扑克定义
};

//////////////////////////////////////////////////////////////////////////

#endif

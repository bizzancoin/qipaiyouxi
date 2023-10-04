#include "StdAfx.h"
#include "GameLogic.h"

//////////////////////////////////////////////////////////////////////////

//扑克数据
BYTE CGameLogic::m_cbCardListData[FULL_COUNT]=
{
	0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x08,0x09,0x0A,0x0B,0x0C,0x0D,	//方块 A - K
	0x11,0x12,0x13,0x14,0x15,0x16,0x17,0x18,0x19,0x1A,0x1B,0x1C,0x1D,	//梅花 A - K
	0x21,0x22,0x23,0x24,0x25,0x26,0x27,0x28,0x29,0x2A,0x2B,0x2C,0x2D,	//红桃 A - K
	0x31,0x32,0x33,0x34,0x35,0x36,0x37,0x38,0x39,0x3A,0x3B,0x3C,0x3D,	//黑桃 A - K
};

//////////////////////////////////////////////////////////////////////////

//构造函数
CGameLogic::CGameLogic()
{
}

//析构函数
CGameLogic::~CGameLogic()
{
}

//获取类型
BYTE CGameLogic::GetCardType(BYTE cbCardData[], BYTE cbCardCount, bool bSplitCard)
{
	//分析牌
	tagAnalyseResult AnalyseResult;
	AnalysebCardData( cbCardData,cbCardCount,AnalyseResult );

	BYTE cbCardValue = 0;

	for (BYTE i = 0; i < AnalyseResult.cbCardNormalCount; i++)
	{
		if (0 <= i && i < 11)
			cbCardValue += GetCardLogicValue(AnalyseResult.cbCardNormal[i]);
	}		

	if (5 <= cbCardCount)
	{
		for (BYTE i = 0; i < AnalyseResult.cbCardACount; i++)
		{
			cbCardValue++;
		}
	}
	else
	{
		for (BYTE i = 0; i < AnalyseResult.cbCardACount; i++)
		{
			if (cbCardValue + 11 > 21) cbCardValue++;
			else cbCardValue += 11;
		}
	}

	//爆牌
	if( cbCardValue > 21 ) return CT_BAOPAI;

	//BJ
	if( AnalyseResult.cbCardACount + AnalyseResult.cbCardNormalCount == 2 && cbCardValue == 21 && !bSplitCard )
		return CT_BJ;

	//N小龙
	if( cbCardCount >= 5 )
		return CT_BJ+cbCardCount-4;

	return cbCardValue;
}

//混乱扑克
void CGameLogic::RandCardList(BYTE cbCardBuffer[], BYTE cbBufferCount)
{
	//混乱准备
	BYTE cbCardData[CountArray(m_cbCardListData)];
	CopyMemory(cbCardData,m_cbCardListData,sizeof(m_cbCardListData));

	//混乱扑克
	BYTE bRandCount=0,bPosition=0;
	do
	{
		bPosition=rand()%(CountArray(m_cbCardListData)-bRandCount);
		cbCardBuffer[bRandCount++]=cbCardData[bPosition];
		cbCardData[bPosition]=cbCardData[CountArray(m_cbCardListData)-bRandCount];
	} while (bRandCount<cbBufferCount);

	return;
}

//逻辑数值
BYTE CGameLogic::GetCardLogicValue(BYTE cbCardData)
{
	//扑克属性
	BYTE bCardValue=GetCardValue(cbCardData);

	//转换数值
	if( bCardValue == 1 ) return 11;
	return (bCardValue>=0x0A)?10:bCardValue;
}

//分析扑克
void CGameLogic::AnalysebCardData(const BYTE cbCardData[], BYTE cbCardCount, tagAnalyseResult & AnalyseResult)
{
	//设置结果
	ZeroMemory(&AnalyseResult,sizeof(tagAnalyseResult));

	//扑克分析
	for( BYTE i = 0; i < cbCardCount; i++ )
	{
		if( GetCardLogicValue(cbCardData[i]) == 11 )
		{
			AnalyseResult.cbCardACount++;
			continue;
		}
		if (AnalyseResult.cbCardNormalCount >= (MAX_COUNT-1) || 0 > AnalyseResult.cbCardNormalCount) continue;

		AnalyseResult.cbCardNormal[AnalyseResult.cbCardNormalCount++] = cbCardData[i];
	}
	return;
}

//////////////////////////////////////////////////////////////////////////

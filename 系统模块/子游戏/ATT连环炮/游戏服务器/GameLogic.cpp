#include "StdAfx.h"
#include "GameLogic.h"
#include <algorithm>
using namespace std;

//////////////////////////////////////////////////////////////////////////

//扑克数据
 BYTE CGameLogic::m_cbCardData[FULL_CARD_COUNT]=
{
	0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D,	//方块 A - K
	0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1A, 0x1B, 0x1C, 0x1D,	//梅花 A - K
	0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28, 0x29, 0x2A, 0x2B, 0x2C, 0x2D,	//红桃 A - K
	0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x3A, 0x3B, 0x3C, 0x3D,	//黑桃 A - K
	0x4E, 0x4F,
};

BYTE CGameLogic::m_cbLuckyTimeCardData[LUCKYTIME_CARDDATA_COUNT]=
{
	0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D
};

//枚举牌型链表
CList<ENUMCARDTYPE, ENUMCARDTYPE&> g_ListEnumCardType;

//////////////////////////////////////////////////////////////////////////

//构造函数
CGameLogic::CGameLogic()
{
}

//析构函数
CGameLogic::~CGameLogic()
{
}

//混乱扑克
void CGameLogic::RandCardList(BYTE cbCardBuffer[], BYTE cbBufferCount)
{
	//混乱准备
	BYTE cbCardData[CountArray(m_cbCardData)];
	CopyMemory(cbCardData, m_cbCardData, sizeof(m_cbCardData));

	//混乱扑克
	BYTE cbRandCount = 0;
	BYTE cbPosition = 0;
	do
	{
		cbPosition = (BYTE)(rand() + GetTickCount() * 2) % (CountArray(cbCardData) - cbRandCount);
		cbCardBuffer[cbRandCount++] = cbCardData[cbPosition];
		cbCardData[cbPosition] = cbCardData[CountArray(cbCardData) - cbRandCount];
	} while (cbRandCount < cbBufferCount);

	return;
}

//混乱扑克
void CGameLogic::RandLuckyCardList(BYTE cbCardBuffer[], BYTE cbBufferCount)
{
	ASSERT(cbBufferCount == LUCKYTIME_CARDDATA_COUNT);

	//混乱准备
	BYTE cbCardData[CountArray(m_cbLuckyTimeCardData)];
	CopyMemory(cbCardData, m_cbLuckyTimeCardData, sizeof(m_cbLuckyTimeCardData));

	//混乱扑克
	BYTE cbRandCount = 0;
	BYTE cbPosition = 0;
	do
	{
		cbPosition = (BYTE)(rand() + GetTickCount() * 2) % (CountArray(cbCardData) - cbRandCount);
		cbCardBuffer[cbRandCount++] = cbCardData[cbPosition];
		cbCardData[cbPosition] = cbCardData[CountArray(cbCardData) - cbRandCount];
	} while (cbRandCount < cbBufferCount);

	return;
}

//逻辑数值
BYTE CGameLogic::GetCardLogicValue(BYTE cbCardData)
{
	//扑克属性
	BYTE cbCardColor = GetCardColor(cbCardData);
	BYTE cbCardValue = GetCardValue(cbCardData);
	
	//校验数据
	ASSERT((cbCardValue > 0) && (cbCardValue <= (LOGIC_MASK_VALUE&0x4f)));
	if ((cbCardValue <= 0) || (cbCardValue > (LOGIC_MASK_VALUE&0x4f)))
	{
		return 0;
	}
	
	//转换数值
	if (cbCardColor == 0x40) 
	{
		return cbCardValue + 2;
	}

	return (cbCardValue <= 2) ? (cbCardValue + 13) : cbCardValue;
}

//排列扑克
void CGameLogic::SortCardList(BYTE cbCardData[], BYTE cbCardCount)
{
	ASSERT(cbCardCount == MAX_CARD_COUNT);

	//数目过虑
	if (cbCardCount == 0) 
	{
		return;
	}

	//转换数值
	BYTE cbSortValue[MAX_CARD_COUNT];
	ZeroMemory(cbSortValue, sizeof(cbSortValue));
	for (BYTE i=0; i<cbCardCount; i++) 
	{
		cbSortValue[i] = GetCardLogicValue(cbCardData[i]);	
	}

	//排序操作
	bool bSorted = true;
	BYTE cbSwitchData = 0;
	BYTE cbLast = cbCardCount - 1;
	do
	{
		bSorted = true;
		for (BYTE i=0; i<cbLast; i++)
		{
			if ((cbSortValue[i] < cbSortValue[i + 1]) ||
				((cbSortValue[i] == cbSortValue[i + 1]) && (cbCardData[i] < cbCardData[i + 1])))
			{
				//设置标志
				bSorted = false;

				//扑克数据
				cbSwitchData = cbCardData[i];
				cbCardData[i] = cbCardData[i + 1];
				cbCardData[i + 1] = cbSwitchData;

				//排序权位
				cbSwitchData = cbSortValue[i];
				cbSortValue[i] = cbSortValue[i + 1];
				cbSortValue[i + 1] = cbSwitchData;
			}	
		}
		cbLast--;
	} while (bSorted == false);
}

//分析扑克
void CGameLogic::AnalysebCardData(BYTE cbCardData[], BYTE cbCardCount, tagAnalyseResult &AnalyseResult)
{
	ASSERT(cbCardCount == MAX_CARD_COUNT);

	//设置结果
	ZeroMemory(&AnalyseResult, sizeof(AnalyseResult));
	
	//排序扑克
	SortCardList(cbCardData, cbCardCount);

	//扑克分析
	for (BYTE i=0; i<cbCardCount; i++)
	{
		//变量定义
		BYTE cbSameCount = 1;
		BYTE cbCardValueTemp = 0;
		BYTE cbLogicValue = GetCardLogicValue(cbCardData[i]);

		//搜索同牌
		for (BYTE j=i+1; j<cbCardCount; j++)
		{
			//获取扑克
			if (GetCardLogicValue(cbCardData[j]) != cbLogicValue) 
			{
				break;
			}

			//设置变量
			cbSameCount++;
		}

		if(cbSameCount > 4)
		{
			ASSERT(FALSE);

			//设置结果
			ZeroMemory(&AnalyseResult, sizeof(AnalyseResult));

			return;
		}

		//设置结果
		BYTE cbIndex = AnalyseResult.cbBlockCount[cbSameCount - 1]++;
		for (BYTE j=0; j<cbSameCount; j++) 
		{
			AnalyseResult.cbCardData[cbSameCount - 1][cbIndex * cbSameCount + j] = cbCardData[i + j];
		}

		//设置索引
		i += cbSameCount - 1;
	}

	return;
}

//获取类型
BYTE CGameLogic::GetCardType(BYTE cbCardData[], BYTE cbCardCount)
{
	ASSERT(cbCardCount == MAX_CARD_COUNT);
	
	//原始扑克列表
	BYTE cbOrinalCardData[MAX_CARD_COUNT];
	ZeroMemory(cbOrinalCardData, sizeof(cbOrinalCardData));
	CopyMemory(cbOrinalCardData, cbCardData, sizeof(cbOrinalCardData));

	//分析牌型
	tagAnalyseResult AnalyseResult;
	ZeroMemory(&AnalyseResult, sizeof(AnalyseResult));
	AnalysebCardData(cbOrinalCardData, cbCardCount, AnalyseResult);
	
	BYTE cbKingCardCount = CalcularKingCard(cbOrinalCardData, cbCardCount);

	for (INT i=3; i >= 0; i--)
	{
		//四张
		if (AnalyseResult.cbBlockCount[i] != 0 && i == 3)
		{	
			//含王牌
			if (IsContainKingCard(cbOrinalCardData, cbCardCount) == true)
			{
				return CT_5K;
			}
			else //不含王牌
			{
				return CT_4K;
			}
		}
		
		//三张
		if (AnalyseResult.cbBlockCount[i] != 0 && i == 2)
		{
			//含王牌
			if (IsContainKingCard(cbOrinalCardData, cbCardCount) == true)
			{
				return (cbKingCardCount == 2 ? CT_5K : CT_4K);
			}
			else  //不含王牌
			{
				if (AnalyseResult.cbBlockCount[1] != 0) // 三条包含一对
				{
					return CT_FH;
				}
				else
				{
					return CT_3K;
				}
			}
		}
		
		//两张
		if (AnalyseResult.cbBlockCount[i] != 0 && i == 1)
		{
			//含王牌
			if (IsContainKingCard(cbOrinalCardData, cbCardCount) == true)
			{
				//2张王牌
				if (cbKingCardCount == 2)
				{
					ASSERT(AnalyseResult.cbBlockCount[1] == 1);
					return CT_4K;
				}
				else if (cbKingCardCount == 1) //1张王牌
				{
					if (AnalyseResult.cbBlockCount[1] == 2)
					{
						return CT_FH;
					}
					else if (AnalyseResult.cbBlockCount[1] == 1)
					{
						return CT_3K;
					}
				}
				
			}
			else //不含王牌
			{
				if (AnalyseResult.cbBlockCount[1] == 2)
				{				
					return CT_2P;								
				}
				
				//10以上算一对
				if (AnalyseResult.cbBlockCount[1] == 1 && (GetCardValue(AnalyseResult.cbCardData[1][0]) >= 10 || GetCardValue(AnalyseResult.cbCardData[1][0]) == 1))
				{
					return CT_1P;
				}
				else if (AnalyseResult.cbBlockCount[1] == 1 && GetCardValue(AnalyseResult.cbCardData[1][0]) < 10 && GetCardValue(AnalyseResult.cbCardData[1][0]) != 1)
				{
					return CT_INVALID;
				}
			}
			
		}

		//分析是否是同花大顺，同花顺，同花，顺子，无效牌型
		if (AnalyseResult.cbBlockCount[i] != 0 && i == 0)
		{
			if (IsCommonFlowerBigFlush(cbOrinalCardData, cbCardCount))
			{
				return CT_RS;
			}
			else
			{
				if (IsCommonFlowerFlush(cbOrinalCardData, cbCardCount))
				{
					return CT_SF;
				}
				else
				{
					if (IsCommonFlower(cbOrinalCardData, cbCardCount))
					{
						return CT_FL;
					}

					if (IsFlush(cbOrinalCardData, cbCardCount))
					{
						return CT_ST;
					}
				}
			}
			
			//两张王牌其他是散牌
			if (cbKingCardCount == 2)
			{
				return CT_3K;
			}
			else if (cbKingCardCount == 1)  // 一张王牌
			{
				SortCardList(cbOrinalCardData, cbCardCount);
				
				//判断最大单牌能否凑成对10以上
				if (GetCardValue(cbOrinalCardData[1]) >= 10 || GetCardValue(cbOrinalCardData[1]) == 1)
				{
					return CT_1P;
				}

				if (GetCardValue(cbOrinalCardData[2]) >= 10 || GetCardValue(cbOrinalCardData[2]) == 1)
				{
					return CT_1P;
				}
			}
		}
	}

	return CT_INVALID;
}

bool CGameLogic::IsContainKingCard(BYTE cbCardData[], BYTE cbCardCount )
{
	ASSERT(cbCardCount == MAX_CARD_COUNT);

	for (INT i=0; i<cbCardCount; i++)
	{
		if (cbCardData[i] == 0x4E || cbCardData[i] == 0x4F)
		{
			return true;
		}
	}

	return false;
}

bool CGameLogic::IsCommonFlower(BYTE cbCardData[], BYTE cbCardCount)
{
	ASSERT(cbCardCount == MAX_CARD_COUNT);
	
	//王牌张数
	BYTE cbKingCardCount = CalcularKingCard(cbCardData, cbCardCount);
	
	//不含有王牌
	if (cbKingCardCount == 0)
	{
		for (INT i=0; i<cbCardCount-1; i++)
		{
			if (GetCardColor(cbCardData[i]) != GetCardColor(cbCardData[i + 1]))
			{
				return false;
			}
		}

		return true;
	}
	else	//含有王牌
	{
		BYTE cbCardColor = 0;
		for (INT i=0; i<cbCardCount; i++)
		{
			//过滤王牌
			if (cbCardData[i] == 0x4E || cbCardData[i] == 0x4F)
			{
				continue;
			}
			cbCardColor = GetCardColor(cbCardData[i]);
			break;
		}
		
		//同色张数
		BYTE cbCommonColorCount = 0;

		for (INT i=0; i<cbCardCount; i++)
		{
			if (GetCardColor(cbCardData[i]) == cbCardColor)
			{
				cbCommonColorCount++;
			}
		}
		
		if (cbCommonColorCount + cbKingCardCount == MAX_CARD_COUNT)
		{
			return true;
		}
		else
		{
			return false;
		}
	}

	ASSERT(false);
	return false;
}

bool CGameLogic::IsFlush(BYTE cbCardData[], BYTE cbCardCount)
{
	ASSERT(cbCardCount == MAX_CARD_COUNT);

	SortCardList(cbCardData,cbCardCount);

	//王牌张数
	BYTE cbKingCardCount = CalcularKingCard(cbCardData, cbCardCount);
	
	//不含王牌
	if (cbKingCardCount == 0)
	{
		for (INT i=0; i<cbCardCount-1; i++)
		{
			if ((GetCardLogicValue(cbCardData[i]) - GetCardLogicValue(cbCardData[i + 1])) != 1)
			{
				return false;
			}
		}

		//顺子从3开始，到10
		if (!(GetCardLogicValue(cbCardData[MAX_CARD_COUNT - 1]) >= 3 && GetCardLogicValue(cbCardData[MAX_CARD_COUNT - 1]) <= 10))
		{
			return false;
		}

		return true;
	}
	else	//含有王牌
	{
		BYTE cbFlushCount = 0;
		ASSERT(cbKingCardCount == 1 || cbKingCardCount == 2);
		for (INT i=cbKingCardCount; i<cbCardCount-1; i++)
		{
			if( (GetCardLogicValue(cbCardData[i]) - GetCardLogicValue(cbCardData[i + 1])) == 1)
			{
				cbFlushCount++;
			}
		}

		//最右边四张已经是顺子，一张王 且最右边的牌比J小 和右边三张顺子，两张王，则满足
		if (cbFlushCount == 3 && cbKingCardCount == 1)
		{
			if (cbCardData[MAX_CARD_COUNT - 1] <= 11)
			{
				return true;
			}
			else
			{
				return false;
			}
		}

		if (cbFlushCount == 2 && cbKingCardCount == 2)
		{
			if (cbCardData[MAX_CARD_COUNT - 1] <= 12)
			{
				return true;
			}
			else
			{
				return false;
			}
		}

		if (cbFlushCount + cbKingCardCount != MAX_CARD_COUNT - 1) //右边的牌不连续
		{
			//拷贝扑克
			BYTE cbTempCard[MAX_CARD_COUNT];
			ZeroMemory(cbTempCard, sizeof(cbTempCard));
			BYTE cbExChangeCount = cbKingCardCount;//王牌可以转换的次数

			//含有一张王牌
			if (cbKingCardCount == 1)
			{
				INT index = 1;
				for (INT i=1; i<cbCardCount; i++, index++)
				{
					cbTempCard[index - 1] = cbCardData[i];
					if (i+1 != MAX_CARD_COUNT && (GetCardLogicValue(cbCardData[i]) - GetCardLogicValue(cbCardData[i + 1]) != 1) && cbExChangeCount > 0)
					{
						cbTempCard[index] = ConstructCard(GetCardLogicValue(cbCardData[i]) - 1,GetCardColor(cbCardData[MAX_CARD_COUNT - 1]));
						index++;
						cbExChangeCount--;
					}
				}

				if (IsFlush(cbTempCard, MAX_CARD_COUNT))
				{
					return true;
				}
				else
				{
					return false;
				}
			}
			else if (cbKingCardCount == 2)
			{
				INT index = 2;
				if (GetCardLogicValue(cbCardData[index]) - GetCardLogicValue(cbCardData[index + 1]) == 1  
					&& GetCardLogicValue(cbCardData[index + 1]) - GetCardLogicValue(cbCardData[index + 2]) == 1)
				{
					return true;
				}

				if (GetCardLogicValue(cbCardData[index]) - GetCardLogicValue(cbCardData[index+1]) == 2  
					&&	GetCardLogicValue(cbCardData[index + 1]) - GetCardLogicValue(cbCardData[index + 2]) == 2)
				{
					return true;
				}

				if (GetCardLogicValue(cbCardData[index]) - GetCardLogicValue(cbCardData[index + 1]) == 1  
					&&	GetCardLogicValue(cbCardData[index + 1]) - GetCardLogicValue(cbCardData[index + 2]) == 2)
				{
					return true;
				}

				if (GetCardLogicValue(cbCardData[index]) - GetCardLogicValue(cbCardData[index + 1]) == 2  
					&&	GetCardLogicValue(cbCardData[index + 1]) - GetCardLogicValue(cbCardData[index + 2]) == 1)
				{
					return true;
				}

				if (GetCardLogicValue(cbCardData[index]) - GetCardLogicValue(cbCardData[index + 1]) == 1  
					&&	GetCardLogicValue(cbCardData[index + 1]) - GetCardLogicValue(cbCardData[index + 2]) == 3)
				{
					return true;
				}

				if (GetCardLogicValue(cbCardData[index]) - GetCardLogicValue(cbCardData[index + 1]) == 3  
					&&	GetCardLogicValue(cbCardData[index +1 ]) - GetCardLogicValue(cbCardData[index + 2]) == 1)
				{
					return true;
				}

				return false;
			}	
		}

	}

	ASSERT(false);
	return false;
}

bool CGameLogic::IsCommonFlowerBigFlush(BYTE cbCardData[], BYTE cbCardCount)
{
	ASSERT(cbCardCount == MAX_CARD_COUNT);

	//排序扑克
	SortCardList(cbCardData, cbCardCount);

	//如果不包含王牌
	if (!IsContainKingCard(cbCardData, cbCardCount))
	{
		//判断是否同花
		if (!IsCommonFlower(cbCardData, cbCardCount))
		{
			return false;
		}
		else // 为同花
		{
			//判断是否顺子
			if (!IsFlush(cbCardData, cbCardCount))
			{
				return false;
			}
			else//为顺子
			{
				//判断是否10起的顺子
				if (GetCardLogicValue(cbCardData[MAX_CARD_COUNT - 1]) == 10)
				{
					return true;
				}
				else
				{
					return false;
				}
			}
		}
	}
	else//包含王牌
	{
		BYTE cbCommonFlowerCount = 0;
		BYTE cbCardColor = GetCardColor(cbCardData[MAX_CARD_COUNT - 1]);
		for (INT i=0; i<cbCardCount; i++)
		{
			//过滤王牌
			if (GetCardValue(cbCardData[i]) == 0x0E || GetCardValue(cbCardData[i]) == 0x0F)
			{
				continue;
			}

			if (GetCardColor(cbCardData[i]) == cbCardColor)
			{
				cbCommonFlowerCount++;
			}
		}

		//王牌张数
		BYTE cbKingCount = CalcularKingCard(cbCardData, cbCardCount);

		//同花牌的张数等于 5-王牌张数
		if (cbCommonFlowerCount != MAX_CARD_COUNT - cbKingCount)
		{
			return false;
		}
		else 
		{
			BYTE cbFlushCount = 0;
			ASSERT(cbKingCount == 1 || cbKingCount == 2);
			for (INT i=cbKingCount; i<cbCardCount-1; i++)
			{
				if( (GetCardLogicValue(cbCardData[i]) - GetCardLogicValue(cbCardData[i + 1])) == 1)
				{
					cbFlushCount++;
				}
			}

			//最右边四张已经是顺子，一张王 且最右边的牌比J小 和右边三张顺子，两张王，则满足
			if (cbFlushCount == 3 && cbKingCount == 1)
			{
				if (cbCardData[MAX_CARD_COUNT - 1] <= 11)
				{
					return true;
				}
				else
				{
					return false;
				}
			}

			if (cbFlushCount == 2 && cbKingCount == 2)
			{
				if (cbCardData[MAX_CARD_COUNT - 1] <= 12)
				{
					return true;
				}
				else
				{
					return false;
				}
			}

			if (cbFlushCount + cbKingCount != MAX_CARD_COUNT - 1) //右边的牌不连续
			{
				//拷贝扑克
				BYTE cbTempCard[MAX_CARD_COUNT];
				ZeroMemory(cbTempCard, sizeof(cbTempCard));
				BYTE cbExChangeCount = cbKingCount;//王牌可以转换的次数

				//含有一张王牌
				if (cbKingCount == 1)
				{
					INT index = 1;
					for (INT i=1; i<cbCardCount; i++, index++)
					{
						cbTempCard[index - 1] = cbCardData[i];
						if (i+1 != MAX_CARD_COUNT && (GetCardLogicValue(cbCardData[i]) - GetCardLogicValue(cbCardData[i + 1]) != 1) && cbExChangeCount > 0)
						{
							cbTempCard[index] = ConstructCard(GetCardLogicValue(cbCardData[i]) - 1,GetCardColor(cbCardData[MAX_CARD_COUNT - 1]));
							index++;
							cbExChangeCount--;
						}
					}

					if (IsFlush(cbTempCard, MAX_CARD_COUNT))
					{
						return true;
					}
					else
					{
						return false;
					}
				}
				else if (cbKingCount == 2)
				{
					INT index = 2;
					if (GetCardLogicValue(cbCardData[index]) - GetCardLogicValue(cbCardData[index + 1]) == 1  
					 && GetCardLogicValue(cbCardData[index + 1]) - GetCardLogicValue(cbCardData[index + 2]) == 1)
					{
						return true;
					}

					if (GetCardLogicValue(cbCardData[index]) - GetCardLogicValue(cbCardData[index+1]) == 2  
					 &&	GetCardLogicValue(cbCardData[index + 1]) - GetCardLogicValue(cbCardData[index + 2]) == 2)
					{
						return true;
					}

					if (GetCardLogicValue(cbCardData[index]) - GetCardLogicValue(cbCardData[index + 1]) == 1  
					 &&	GetCardLogicValue(cbCardData[index + 1]) - GetCardLogicValue(cbCardData[index + 2]) == 2)
					{
						return true;
					}

					if (GetCardLogicValue(cbCardData[index]) - GetCardLogicValue(cbCardData[index + 1]) == 2  
					 &&	GetCardLogicValue(cbCardData[index + 1]) - GetCardLogicValue(cbCardData[index + 2]) == 1)
					{
						return true;
					}

					if (GetCardLogicValue(cbCardData[index]) - GetCardLogicValue(cbCardData[index + 1]) == 1  
					 &&	GetCardLogicValue(cbCardData[index + 1]) - GetCardLogicValue(cbCardData[index + 2]) == 3)
					{
						return true;
					}

					if (GetCardLogicValue(cbCardData[index]) - GetCardLogicValue(cbCardData[index + 1]) == 3  
					 &&	GetCardLogicValue(cbCardData[index +1 ]) - GetCardLogicValue(cbCardData[index + 2]) == 1)
					{
						return true;
					}

					return false;
				}	
			}
		}
	}

	return false;
}

//含有王牌的张数
BYTE CGameLogic::CalcularKingCard(BYTE cbCardData[], BYTE cbCardCount)
{
	ASSERT(cbCardCount == MAX_CARD_COUNT);

	BYTE cbKingCount = 0;
	for (INT i=0; i<cbCardCount; i++)
	{
		if (cbCardData[i] == 0x4E || cbCardData[i] == 0x4F)
		{
			cbKingCount++;
		}
	}

	return cbKingCount;
}

//构造扑克,根据逻辑值和花色,返回扑克
BYTE CGameLogic::ConstructCard(BYTE cbLogicValue, BYTE cbCardColor)
{
	return cbCardColor * 16 + cbLogicValue;
}

//是否同花顺
bool CGameLogic::IsCommonFlowerFlush(BYTE cbCardData[], BYTE cbCardCount)
{
	ASSERT(cbCardCount == MAX_CARD_COUNT);

	return (IsCommonFlower(cbCardData, cbCardCount) && IsFlush(cbCardData, cbCardCount));
}

//分析保留扑克
VOID CGameLogic::AnalyseHeldCard(BYTE cbCardData[], BYTE cbCardCount, bool bHeldFlag[MAX_CARD_COUNT], bool bMark[MAX_CARD_CT])
{
	ASSERT(cbCardCount == MAX_CARD_COUNT);

	//原始扑克列表
	BYTE cbOrinalCardData[MAX_CARD_COUNT];
	ZeroMemory(cbOrinalCardData, sizeof(cbOrinalCardData));
	CopyMemory(cbOrinalCardData, cbCardData, sizeof(cbOrinalCardData));
	
	//初始化参数
	ZeroMemory(bHeldFlag, sizeof(bool) * MAX_CARD_COUNT);
	ZeroMemory(bMark, sizeof(bool) * MAX_CARD_CT);

	//分析扑克
	tagAnalyseResult AnalyseResult;
	ZeroMemory(&AnalyseResult, sizeof(AnalyseResult));
	AnalysebCardData(cbOrinalCardData, cbCardCount, AnalyseResult);
	
	//获取牌型
	BYTE cbCardType = GetCardType(cbOrinalCardData, cbCardCount);

	if (cbCardType == CT_INVALID)
	{
		//遍历扑克列表
		for (INT i=0; i<MAX_CARD_COUNT; i++)
		{
			//设置保留标识
			if ((cbCardData[i] == 0x4E) || (cbCardData[i] == 0x4F))
			{
				bHeldFlag[i] = true;
			}
		}

		return;
	}
	
	bMark[cbCardType] = true;

	//设置保留
	if (cbCardType == CT_5K || cbCardType == CT_RS || cbCardType == CT_SF || cbCardType == CT_FH
	 || cbCardType == CT_FL || cbCardType == CT_ST)
	{
		memset(bHeldFlag, 1, sizeof(bool) * MAX_CARD_COUNT);
		return;
	}
	
	//不含王牌
	if (IsContainKingCard(cbOrinalCardData, cbCardCount) == false)
	{
		if (cbCardType == CT_4K || cbCardType == CT_3K)
		{
			//四条
			if (AnalyseResult.cbBlockCount[3] != 0)
			{
				BYTE cbTmpLogicValue = GetCardLogicValue(AnalyseResult.cbCardData[3][0]);

				//遍历扑克列表
				for (INT i=0; i<MAX_CARD_COUNT; i++)
				{
					//设置保留标识
					if (GetCardLogicValue(cbCardData[i]) == cbTmpLogicValue)
					{
						bHeldFlag[i] = true;
					}
				}

				return;
			}

			//三条
			if (AnalyseResult.cbBlockCount[2] != 0)
			{
				BYTE cbTmpLogicValue = GetCardLogicValue(AnalyseResult.cbCardData[2][0]);

				//遍历扑克列表
				for (INT i=0; i<MAX_CARD_COUNT; i++)
				{
					//设置保留标识
					if (GetCardLogicValue(cbCardData[i]) == cbTmpLogicValue)
					{
						bHeldFlag[i] = true;
					}
				}

				return;
			}
		}

		if (cbCardType == CT_2P)
		{
			BYTE cbFirstLogicValue = GetCardLogicValue(AnalyseResult.cbCardData[1][0]);
			BYTE cbSecondLogicValue = GetCardLogicValue(AnalyseResult.cbCardData[1][2]);

			//遍历扑克列表
			for (INT i=0; i<MAX_CARD_COUNT; i++)
			{
				//设置保留标识
				if (GetCardLogicValue(cbCardData[i]) == cbFirstLogicValue || GetCardLogicValue(cbCardData[i]) == cbSecondLogicValue)
				{
					bHeldFlag[i] = true;
				}
			}

			return;
		}

		if (cbCardType == CT_1P)
		{
			BYTE cbFirstLogicValue = GetCardLogicValue(AnalyseResult.cbCardData[1][0]);

			ASSERT(cbFirstLogicValue >= 10 && cbFirstLogicValue != 15);

			//过滤牌型(对10以下)
			if (cbFirstLogicValue < 10)
			{
				return;
			}

			//遍历扑克列表
			for (INT i=0; i<MAX_CARD_COUNT; i++)
			{
				//设置保留标识
				if (GetCardLogicValue(cbCardData[i]) == cbFirstLogicValue)
				{
					bHeldFlag[i] = true;
				}
			}

			return;
		}
	}
	else // 含有王牌
	{
		//王牌张数
		BYTE cbKingCardCount = CalcularKingCard(cbOrinalCardData, cbCardCount);
		
		//四条
		if (cbCardType == CT_4K )
		{
			//两张王牌
			if (cbKingCardCount == 2)
			{
				//校验数据
				ASSERT(AnalyseResult.cbBlockCount[1] != 0);

				BYTE cbTmpLogicValue = GetCardLogicValue(AnalyseResult.cbCardData[1][0]);
				
				//遍历扑克列表
				for (INT i=0; i<MAX_CARD_COUNT; i++)
				{
					//设置保留标识
					if ((GetCardLogicValue(cbCardData[i]) == cbTmpLogicValue) || (cbCardData[i] == 0x4E) || (cbCardData[i] == 0x4F))
					{
						bHeldFlag[i] = true;
					}
				}

				return;
			}
			else if (cbKingCardCount == 1)  //一张王牌
			{ 
				//校验数据
				ASSERT(AnalyseResult.cbBlockCount[2] != 0);

				BYTE cbTmpLogicValue = GetCardLogicValue(AnalyseResult.cbCardData[2][0]);

				//遍历扑克列表
				for (INT i=0; i<MAX_CARD_COUNT; i++)
				{
					//设置保留标识
					if ((GetCardLogicValue(cbCardData[i]) == cbTmpLogicValue) || (cbCardData[i] == 0x4E) || (cbCardData[i] == 0x4F))
					{
						bHeldFlag[i] = true;
					}
				}

				return;
			}
		}
		
		//三条
		if (cbCardType == CT_3K)
		{
			//两张王牌
			if (cbKingCardCount == 2)
			{
				//校验数据
				ASSERT(AnalyseResult.cbBlockCount[0] != 0);

				BYTE cbTmpLogicValue = GetCardLogicValue(cbOrinalCardData[2]);

				//遍历扑克列表
				for (INT i=0; i<MAX_CARD_COUNT; i++)
				{
					//设置保留标识
					if ((GetCardLogicValue(cbCardData[i]) == cbTmpLogicValue) || (cbCardData[i] == 0x4E) || (cbCardData[i] == 0x4F))
					{
						bHeldFlag[i] = true;
					}
				}

				return;
			}
			else if (cbKingCardCount == 1)  //一张王牌
			{ 
				//校验数据
				ASSERT(AnalyseResult.cbBlockCount[1] != 0);

				BYTE cbTmpLogicValue = GetCardLogicValue(AnalyseResult.cbCardData[1][0]);

				//遍历扑克列表
				for (INT i=0; i<MAX_CARD_COUNT; i++)
				{
					//设置保留标识
					if ((GetCardLogicValue(cbCardData[i]) == cbTmpLogicValue) || (cbCardData[i] == 0x4E) || (cbCardData[i] == 0x4F))
					{
						bHeldFlag[i] = true;
					}
				}

				return;
			}
		}

		if (cbCardType == CT_1P)
		{
			//校验数据
			ASSERT(cbKingCardCount == 1);

			BYTE cbFirstLogicValue = (GetCardLogicValue(cbOrinalCardData[1]) == 15 ? GetCardLogicValue(cbOrinalCardData[2]) : GetCardLogicValue(cbOrinalCardData[1]));

			ASSERT(cbFirstLogicValue >= 10 && cbFirstLogicValue != 15);

			//过滤牌型(对10以下)
			if (cbFirstLogicValue < 10)
			{
				return;
			}

			//遍历扑克列表
			for (INT i=0; i<MAX_CARD_COUNT; i++)
			{
				//设置保留标识
				if ((GetCardLogicValue(cbCardData[i]) == cbFirstLogicValue) || (cbCardData[i] == 0x4E) || (cbCardData[i] == 0x4F))
				{
					bHeldFlag[i] = true;
				}
			}

			return;
		}
	}
	
}

//分析猜大小
VOID CGameLogic::AnalyseGuess(BYTE cbKeyCardData, bool bBig, GUESSRECORD &guessrecord)
{
	ZeroMemory(&guessrecord, sizeof(guessrecord));

	BYTE cbLogicValue = GetCardValue(cbKeyCardData);

	if (cbLogicValue == 0x07)
	{
		guessrecord.bGuessRight = false;
		guessrecord.bValid = false;
		guessrecord.bIsAlreadyGuess = true;

		return;
	}
	
	//小
	if (cbLogicValue < 0x07 && cbLogicValue >= 0x01)
	{
		guessrecord.bGuessRight = (bBig == true ? false : true);
		guessrecord.bValid = true;
		guessrecord.bIsAlreadyGuess = true;

		return;
	}

	//大
	if (cbLogicValue <= 0x0D && cbLogicValue >= 0x08)
	{
		guessrecord.bGuessRight = (bBig == true ? true : false);
		guessrecord.bValid = true;
		guessrecord.bIsAlreadyGuess = true;

		return;
	}

	ASSERT(FALSE);
}

//枚举任意10张牌中抽取5张的所有可能
INT CGameLogic::EnumCardDataCount(BYTE cbFirstCardData[], BYTE cbSecondCardData[])
{
	//变量定义
	BYTE cbAllCardData[MAX_CARD_COUNT * 2];
	ZeroMemory(cbAllCardData, sizeof(cbAllCardData));

	//清空枚举链表
	g_ListEnumCardType.RemoveAll();

	CopyMemory(cbAllCardData, cbFirstCardData, sizeof(BYTE) * MAX_CARD_COUNT);
	CopyMemory(&cbAllCardData[MAX_CARD_COUNT], cbSecondCardData, sizeof(BYTE) * MAX_CARD_COUNT);
	
	//获取枚举  10张牌取5张的组合
	GetCombine(cbAllCardData, MAX_CARD_COUNT * 2, MAX_CARD_COUNT);
	
	//校验扑克,删除不可能的情况
	POSITION posHead = g_ListEnumCardType.GetHeadPosition();
	while(posHead != NULL)
	{
		POSITION pos = posHead;
		ENUMCARDTYPE enumCard = g_ListEnumCardType.GetNext(posHead);
		if (AnalyseEnumCard(cbFirstCardData, cbSecondCardData, enumCard.cbEnumCardData) == false)
		{
			g_ListEnumCardType.RemoveAt(pos);
		}
	}
	
	return g_ListEnumCardType.GetSize();
}

//cbElementsArray:集合元素; setLg:集合长度; nSelectCount:从集合中要选取的元素个数
VOID CGameLogic::GetCombine(BYTE cbElementsArray[], int setLg, int nSelectCount)
{
	BYTE cbKeyArray[MAX_CARD_COUNT * 2];
	ZeroMemory(cbKeyArray, sizeof(cbKeyArray));
	CopyMemory(cbKeyArray, cbElementsArray, sizeof(cbKeyArray));

	if (nSelectCount > setLg || nSelectCount <= 0)
	{
		return;
	}
	
	//变量定义
	bool bMark = FALSE;						//是否有"10"组合的标志:TRUE-有;FALSE-无
	INT nCombineIndex = 0;					//第一个"10"组合的索引
	INT nCombineLeftOneCount = 0;					//"10"组合左边的"1"的个数
	bool *flags = new bool[setLg];			//与元素集合对应的标志:TRUE被选中;FALSE未被选中

    //初始化,将标志的前k个元素置1,表示第一个组合为前k个数
    for (INT i=0; i<nSelectCount; i++)
	{
		flags[i] = TRUE;
	}

    for (INT i=nSelectCount; i<setLg; i++)
	{
		flags[i] = FALSE;
	}
	
	//初始组合
	GetEnumType(cbKeyArray, flags, setLg);

    while(TRUE)
    {
        nCombineLeftOneCount = 0;
        bMark= 0;

        for (INT i=0; i<setLg-1; i++)
        {
			//找到第一个"10"组合
            if (flags[i] && !flags[i+1])
            {
                nCombineIndex = i;

				//将该"10"组合变为"01"组合
                flags[i] = FALSE;
                flags[i+1] = TRUE;

				//将其左边的所有"1"全部移动到数组的最左端
                for (INT j=0; j<nCombineLeftOneCount; j++)
                {
					flags[j] = TRUE;
                }

                for(int j=nCombineLeftOneCount; j<nCombineIndex; j++)
                {
                    flags[j] = FALSE;
                }

                bMark = TRUE;

                break;
            }
            else if(flags[i])
            {

                nCombineLeftOneCount++;
            }

        }
		
		//没有"10"组合了,代表组合计算完毕
        if (!bMark)
		{
			break;
		}
		
		GetEnumType(cbKeyArray, flags, setLg);
    }

	delete[] flags;
}

//获得枚举类型
VOID CGameLogic::GetEnumType(BYTE cbElementsArray[], bool *flags, int length)
{
	//变量定义
	ENUMCARDTYPE enumCard;
	ZeroMemory(&enumCard, sizeof(enumCard));
	
	INT index = 0;

	for (WORD i=0; i<length; i++)
	{
		if (flags[i])
		{
			enumCard.cbEnumCardData[index++] = cbElementsArray[i];
		}
	}

	//获取牌型
	BYTE cbCardType = GetCardType(enumCard.cbEnumCardData, MAX_CARD_COUNT);
	enumCard.cbCardType = cbCardType;

	//压入链表
	g_ListEnumCardType.AddTail(enumCard);
}

//分析枚举扑克
bool CGameLogic::AnalyseEnumCard(BYTE cbFirstCardData[], BYTE cbSecondCardData[], BYTE cbEnumCardData[])
{
	for (WORD i=0; i<MAX_CARD_COUNT; i++)
	{
		BYTE cbFirstCard = cbFirstCardData[i];
		BYTE cbSecondCard = cbSecondCardData[i];
		
		BYTE cbFindCount = 0;
		for (WORD j=0; j<MAX_CARD_COUNT; j++)
		{
			if (cbEnumCardData[j] == cbFirstCard || cbEnumCardData[j] == cbSecondCard)
			{
				cbFindCount++;
			}
		}

		if (cbFindCount == 2)
		{
			return false;
		}
	}

	return true;
}

//获得枚举牌数据
VOID CGameLogic::GetEnumCardData(ENUMCARDTYPE *pEnumCardType, INT nSize)
{
	//校验数值
	ASSERT(nSize == g_ListEnumCardType.GetSize());

	//拷贝数据
	POSITION posHead = g_ListEnumCardType.GetHeadPosition();
	INT nIndex = 0;
	while(posHead != NULL)
	{
		ENUMCARDTYPE enumCard = g_ListEnumCardType.GetNext(posHead);
		CopyMemory(&pEnumCardType[nIndex++], &enumCard, sizeof(enumCard));
	}
}

//////////////////////////////////////////////////////////////////////////


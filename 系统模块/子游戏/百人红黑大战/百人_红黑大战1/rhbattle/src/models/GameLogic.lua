
local GameLogic = {}


--*****************************扑克类型*********************************--
--错误牌型
GameLogic.CT_ERROR				= 0
--单牌类型
GameLogic.CT_SINGLE				= 1
--对子类型
GameLogic.CT_DOUBLE				= 2
--对子类型
GameLogic.CT_DOUBLE_SHINE		= 3
--顺子类型
GameLogic.CT_SHUN_ZI			= 4
--金花类型
GameLogic.CT_JIN_HUA			= 5
--顺金类型
GameLogic.CT_SHUN_JIN			= 6
--豹子类型
GameLogic.CT_BAO_ZI				= 7
--特殊类型
GameLogic.CT_SPECIAL			= 8


--牌值掩码
GameLogic.MASK_VALUE			= 0X0F
--花色掩码
GameLogic.MASK_COLOR			= 0XF0
--最大手牌数目
GameLogic.MAX_CARDCOUNT			= 20
--牌库数目
GameLogic.FULL_COUNT			= 54
--正常手牌数目
GameLogic.NORMAL_COUNT			= 17


--取模
function GameLogic:mod(a,b)
    return a - math.floor(a/b)*b
end

--获得牌的数值（1 -- 13）
function GameLogic:getCardValue(cbCardData)
    return self:mod(cbCardData, 16)
end

--获得牌的颜色（0 -- 4）
function GameLogic:getCardColor(cbCardData)
    return math.floor(cbCardData/16)
end

function GameLogic:getCardLogicValue(cbCardData)
	local cbCardValue = self:getCardValue(cbCardData)

	if cbCardValue == 1 then
		cbCardValue = cbCardValue + 13
	end

	return cbCardValue
end

--拷贝表
function GameLogic:copyTab(st)
    local tab = {}
    for k, v in pairs(st) do
        if type(v) ~= "table" then
            tab[k] = v
        else
            tab[k] = self:copyTab(v)
        end
    end
    return tab
 end

--牌的排序
function GameLogic:sortCard(cardData)
	local cardDataTemp = self:copyTab(cardData)
    local num = table.getn(cardDataTemp)
    --先排颜色
    for i = 1, num - 1 do
        for j = 1, num - i do
            if cardDataTemp[j] < cardDataTemp[j + 1] then
                cardDataTemp[j], cardDataTemp[j + 1] = cardDataTemp[j + 1], cardDataTemp[j]
            end
        end
    end
    --再排大小
	for i = 1, num - 1 do
		for j = 1, num - i do
	        if self:getCardLogicValue(cardDataTemp[j]) < self:getCardLogicValue(cardDataTemp[j + 1]) then
	            cardDataTemp[j], cardDataTemp[j + 1] = cardDataTemp[j + 1], cardDataTemp[j]
	        end
		end
	end
    return cardDataTemp
end


--获得牌型
function GameLogic:getCardType(card)
	if #card ~= 3 then return false end

	local cardData = self:sortCard(card)
	-- for i = 1, 3 do
	-- 	print(cardData[i])
	-- end

	local cbSameColor = true
	local bLineCard = true
	local cbFirstColor = self:getCardColor(cardData[1])
	local cbFirstValue = self:getCardLogicValue(cardData[1])
	--牌型分析
	for i = 1, 3 do
		if cbFirstColor ~= self:getCardColor(cardData[i]) then cbSameColor = false end
		if cbFirstValue ~= self:getCardLogicValue(cardData[i] + i - 1) then bLineCard = false end

		if cbSameColor == false and bLineCard == false then break end
	end
	--特殊A23
	if false == bLineCard then
		local bOne = false
		local bTwo = false
		local bThree = false
		for i = 1, 3 do
			if self:getCardValue(cardData[i]) == 1 then
				bOne = true
			elseif self:getCardValue(cardData[i]) == 2 then
				bTwo = true
			elseif self:getCardValue(cardData[i]) == 3 then
				bThree = true
			end
		end
		if bOne and bTwo and bThree then 
			bLineCard = true
		end
	end
	--顺金类型
	if cbSameColor and bLineCard then
		return GameLogic.CT_SHUN_JIN
	end
	--顺子类型
	if false == cbSameColor and bLineCard then
		return GameLogic.CT_SHUN_ZI
	end
	--金花类型
	if cbSameColor and false == bLineCard then
		return GameLogic.CT_JIN_HUA
	end
	--牌型分析
	local bDouble = false
    local bDoulbeShine = false
	local bPanther = true
	--对牌类型
	for i = 1, 3 - 1 do
		for j = i + 1 , 3 do
			if self:getCardLogicValue(cardData[i]) == self:getCardLogicValue(cardData[j]) then
				bDouble = true
                if  self:getCardLogicValue(cardData[i]) > 8 then
                    bDoulbeShine =true
                end
				break
			end
		end
		if bDouble then break end
	end
	--三条（豹子）分析
	for i = 1, 3 do
		if bPanther and cbFirstValue ~= self:getCardLogicValue(cardData[i]) then
			bPanther = false
		end
	end
	--对子和豹子判断
	if bDouble then
		if bPanther then
			return GameLogic.CT_BAO_ZI
		else
            if bDoulbeShine then
                return GameLogic.CT_DOUBLE_SHINE
            end
			return GameLogic.CT_DOUBLE
		end
	end
	--特殊235
	local bTwo = false
	local bThree = false
	local bFive = false
	for i = 1, 3 do
		if self:getCardValue(cardData[i]) == 2 then
			bTwo = true
		elseif self:getCardValue(cardData[i]) == 3 then
			bThree = true
		elseif self:getCardValue(cardData[i]) == 5 then
			bFive = true
		end
	end
	if bTwo and bThree and bFive then
		return GameLogic.CT_SPECIAL
	end


	return GameLogic.CT_SINGLE
end


--对比扑克
function GameLogic:compareCard(cbFirstData, cbNextData)

	--设置变量
	local  FirstData = {}
    local  NextData = {}

    FirstData = self:sortCard(cbFirstData)
    NextData = self:sortCard(cbNextData)

	--大小排序
--	self:sortCard(FirstData)
--	self:sortCard(NextData)

	--获取类型
	local cbNextType = self:getCardType(NextData)
	local cbFirstType = self:getCardType(FirstData)

	--特殊情况分析
	--if((cbNextType+cbFirstType)==(CT_SPECIAL+CT_BAO_ZI))return (BYTE)(cbFirstType>cbNextType);

	--还原单牌类型
	if(cbNextType==GameLogic.CT_SPECIAL) then
        cbNextType=GameLogic.CT_SINGLE
    end
	if(cbFirstType==GameLogic.CT_SPECIAL) then
        cbFirstType=GameLogic.CT_SINGLE
    end

	--类型判断
	if (cbFirstType~=cbNextType) then
        --return (cbFirstType>cbNextType) and true or false
        if cbFirstType>cbNextType then
            return true
        else 
            return false
        end
    end

    if cbFirstType == GameLogic.CT_SINGLE then
        local cbNextValue= self:getCardLogicValue(NextData[1])
        local cbFirstValue= self:getCardLogicValue(FirstData[1])

        if cbFirstValue~=cbNextValue then
            return cbFirstValue>cbNextValue and true or false
        end
        return true
    elseif cbFirstType == GameLogic.CT_JIN_HUA then
        local cbNextValue= self:getCardLogicValue(NextData[1])
        local cbFirstValue= self:getCardLogicValue(FirstData[1])
        if cbFirstValue~=cbNextValue then
            return cbFirstValue>cbNextValue and true or false
        end
        return true
    elseif cbFirstType == GameLogic.CT_BAO_ZI then
        local cbNextValue= self:getCardLogicValue(NextData[1])
        local cbFirstValue= self:getCardLogicValue(FirstData[1])
        if cbFirstValue~=cbNextValue then
            return cbFirstValue>cbNextValue and true or false
        end
        return true
    elseif cbFirstType == GameLogic.CT_SHUN_ZI or cbFirstType == GameLogic.CT_SHUN_JIN then 
        local cbNextValue= self:getCardLogicValue(NextData[1])
        local cbFirstValue= self:getCardLogicValue(FirstData[1])

        if cbNextValue==14 and self:getCardLogicValue(NextData[3])==2 then
            cbNextValue=3
        end

        if cbFirstValue==14 and self:getCardLogicValue(FirstData[3])==2 then
            cbFirstValue=3
        end

        if cbFirstValue~=cbNextValue then
            return cbFirstValue>cbNextValue and true or false
        end

        return true
    elseif cbFirstType == GameLogic.CT_DOUBLE  or cbFirstType == GameLogic.CT_DOUBLE_SHINE then

        local cbNextValue= self:getCardLogicValue(NextData[1])
        local cbFirstValue= self:getCardLogicValue(FirstData[1])
        local bNextDouble = 0
        local bNextSingle = 0
        local bFirstDouble = 0
        local bFirstSingle = 0

        if cbNextValue == self:getCardLogicValue(NextData[2]) then
				bNextDouble=cbNextValue
				bNextSingle=self:getCardLogicValue(NextData[3])
        else
        		bNextDouble=self:getCardLogicValue(NextData[3])
				bNextSingle=cbNextValue
        end

        if cbFirstValue == self:getCardLogicValue(FirstData[2]) then
				bFirstDouble=cbFirstValue
				bFirstSingle=self:getCardLogicValue(FirstData[3])
        else
        		bFirstDouble=self:getCardLogicValue(FirstData[3])
				bFirstSingle=cbFirstValue
        end

        if bNextDouble~=bFirstDouble then
            return bFirstDouble>bNextDouble and true or false
        end

        if bNextSingle~=bFirstSingle then
            return bFirstSingle>bNextSingle and true or false
        end

        return true
    end

    return true
end

return GameLogic
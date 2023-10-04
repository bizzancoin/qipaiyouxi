--
-- Author: zhong
-- Date: 2016-06-27 11:36:40
--
local CardSprite = class("CardSprite", cc.Sprite);

--纹理宽高
local CARD_WIDTH = 104;
local CARD_HEIGHT = 144;
local BACK_Z_ORDER = 2;

------
--set/get
function CardSprite:setDispatched( var )
	self.m_bDispatched = var;
end

function CardSprite:getDispatched(  )
	if nil ~= self.m_bDispatched then
		return self.m_bDispatched;
	end
	return false;
end
------

function CardSprite:ctor()
	-- body
end

--创建卡牌
function CardSprite:createCard( cbCardData )
	local sp = CardSprite.new();

	sp.m_strCardFile = "game/card.png";
	local tex = cc.Director:getInstance():getTextureCache():getTextureForKey(sp.m_strCardFile);
	if nil ~= sp and nil ~= tex and sp:initWithTexture(tex, tex:getContentSize()) then
		sp.m_cardData = cbCardData;
		sp.m_cardValue = yl.POKER_VALUE[cbCardData] --math.mod(cbCardData, 16)--bit:_and(cbCardData, 0x0F)
		sp.m_cardColor = yl.CARD_COLOR[cbCardData] --math.floor(cbCardData / 16)--bit:_rshift(bit:_and(cbCardData, 0xF0), 4)

		sp:updateSprite();
		--扑克背面
		sp:createBack();

		return sp;
	end
	return nil;
end

--设置卡牌数值
function CardSprite:setCardValue( cbCardData )
	self.m_cardData = cbCardData;
	self.m_cardValue = yl.POKER_VALUE[cbCardData] --math.mod(cbCardData, 16) --bit:_and(cbCardData, 0x0F)
	self.m_cardColor = yl.CARD_COLOR[cbCardData] --math.floor(cbCardData / 16) --bit:_rshift(bit:_and(cbCardData, 0xF0), 4)

	self:updateSprite();
end

--更新纹理资源
function CardSprite:updateSprite(  )
	local m_cardData = self.m_cardData;
	local m_cardValue = self.m_cardValue;
	local m_cardColor = self.m_cardColor;

	self:setTag(m_cardData);

	local rect = cc.rect((m_cardValue - 1) * CARD_WIDTH, m_cardColor * CARD_HEIGHT, CARD_WIDTH, CARD_HEIGHT);
	if 0 ~= m_cardData then
		rect = cc.rect((m_cardValue - 1) * CARD_WIDTH, m_cardColor * CARD_HEIGHT, CARD_WIDTH, CARD_HEIGHT);
		if 0x4F == m_cardData then
			rect = cc.rect(0, 4 * CARD_HEIGHT, CARD_WIDTH, CARD_HEIGHT);
		elseif 0x4E == m_cardData then
			rect = cc.rect(CARD_WIDTH, 4 * CARD_HEIGHT, CARD_WIDTH, CARD_HEIGHT);
		end
	else
		--使用背面纹理区域
		rect = cc.rect(2 * CARD_WIDTH, 4 * CARD_HEIGHT, CARD_WIDTH, CARD_HEIGHT);
	end
	self:setTextureRect(rect);
end

--显示扑克背面
function CardSprite:showCardBack( var )
	if nil ~= self.m_spBack then
		self.m_spBack:setVisible(var);
	end	
end

--创建背面
function CardSprite:createBack(  )
	local tex = cc.Director:getInstance():getTextureCache():getTextureForKey(self.m_strCardFile);
	--纹理区域
	local rect = cc.rect(2 * CARD_WIDTH, 4 * CARD_HEIGHT, CARD_WIDTH, CARD_HEIGHT);

	local cardSize = self:getContentSize();
    local m_spBack = cc.Sprite:createWithTexture(tex, rect);
    m_spBack:setPosition(cardSize.width * 0.5, cardSize.height * 0.5);
    m_spBack:setVisible(false);
    self:addChild(m_spBack);
    m_spBack:setLocalZOrder(BACK_Z_ORDER);
    self.m_spBack = m_spBack;
end

return CardSprite;
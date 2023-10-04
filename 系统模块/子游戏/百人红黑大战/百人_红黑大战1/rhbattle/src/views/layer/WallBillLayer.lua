--
-- Author: zhong
-- Date: 2016-07-12 17:03:14
--
--路单界面
local module_pre = "game.yule.rhbattle.src";
local ExternalFun = require(appdf.EXTERNAL_SRC .. "ExternalFun")
local g_var = ExternalFun.req_var;
local cmd = require(module_pre .. ".models.CMD_Game")

local WallBillLayer = class("WallBillLayer", cc.Layer)

function WallBillLayer:ctor(viewparent)
	--注册事件
	local function onLayoutEvent( event )
		if event == "exit" then
			self:onExit();
        elseif event == "enterTransitionFinish" then
        	self:onEnterTransitionFinish();
        end
	end
	self:registerScriptHandler(onLayoutEvent);

	self.m_parent = viewparent

	self.m_spRecord = {}
	for i = 1, 20 do
		self.m_spRecord[i] = {}
		for j = 1, 6 do
			self.m_spRecord[i][j] = nil
		end
	end

	self.m_spRecord2 = {}
	for i = 1, 10 do
		self.m_spRecord2[i] = {}
		for j = 1, 2 do
			self.m_spRecord2[i][j] = nil
		end
	end

	--加载csb资源
	local csbNode = ExternalFun.loadCSB("game/WallBill.csb", self)

	--统计数据
	self.m_layoutSettle = csbNode:getChildByName("settle_layout")
    self.m_textXianSettle = self.m_layoutSettle:getChildByName("xian_settle")
    self.m_textZhuangSettle = self.m_layoutSettle:getChildByName("zhuang_settle")

	--简易路单
	local m_layoutBillSp = csbNode:getChildByName("bill_layout")
	local str = ""
	local idx = 0
	--for i = 1, 29 do
    for i = 1, 20 do
		idx = i - 1
		str = string.format("record%d_sp", idx)
		self.m_spRecord[i][1] = m_layoutBillSp:getChildByName(str)
	end
	self.m_layoutBillSp = m_layoutBillSp

	--路单
	local m_layoutBillSp2 = csbNode:getChildByName("bill2_layout")
	idx = 0
	--for i = 1, 14 do
	for i = 1, 10 do
		idx = i - 1
		str = string.format("record%d_sp", idx)
		self.m_spRecord2[i][1] = m_layoutBillSp2:getChildByName(str)
	end
	self.m_layoutBillSp2 = m_layoutBillSp2

	--位置
	self.m_vec2Pos = {}
	self.m_vec2Pos2 = {}
	idx = 0
	for i = 1, 6 do
		idx = i - 1
        self.m_vec2Pos[i] = 362 - idx * 25
		--self.m_vec2Pos2[i] = 418 - idx * 52
	end
    for i = 1,2 do
        idx = i - 1
        self.m_vec2Pos2[i] = 160 - idx * 36
    end
	self.m_spBg = csbNode:getChildByName("game_ludan_bg")

	self:reSet()
end

function WallBillLayer:onEnterTransitionFinish()
	self:registerTouch()
end

function WallBillLayer:onExit()
	local eventDispatcher = self:getEventDispatcher()
	eventDispatcher:removeEventListener(self.listener)
end

function WallBillLayer:registerTouch(  )
	local function onTouchBegan( touch, event )
		return self:isVisible()
	end

	local function onTouchEnded( touch, event )
		local pos = touch:getLocation();
		local m_spBg = self.m_spBg
        pos = m_spBg:convertToNodeSpace(pos)
        local rec = cc.rect(0, 0, m_spBg:getContentSize().width, m_spBg:getContentSize().height)
        if false == cc.rectContainsPoint(rec, pos) then
            self:showLayer(false)
        end        
	end

	local listener = cc.EventListenerTouchOneByOne:create();
	listener:setSwallowTouches(true)
	self.listener = listener;
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN );
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED );
    local eventDispatcher = self:getEventDispatcher();
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self);
end

function WallBillLayer:showLayer( var )
	self:setVisible(var)
end

function WallBillLayer:reSet(  )
	local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame("blank.png")
	if nil == frame then
		return
	end

	--for i = 1, 29 do
    for i = 1, 20 do
		for j = 1, 6 do
			if nil ~= self.m_spRecord[i][j] then				
				self.m_spRecord[i][j]:setSpriteFrame(frame)
			end
		end
	end

	for i = 1, 10 do
		for j = 1, 2 do
			if nil ~= self.m_spRecord2[i][j] then
				self.m_spRecord2[i][j]:setSpriteFrame(frame)
			end
		end
	end

	self.m_textXianSettle:setString("")
    self.m_textZhuangSettle:setString("")
    

end

function WallBillLayer:refreshWallBillList(  )
	if nil == self.m_parent then
		return
	end
	local mgr = self.m_parent:getDataMgr()
	self:reSet()
	self:refreshList()
	--统计数据
	local vec = mgr:getRecords()
	local nTotal = #vec
	local nXian = 0
	local nZhuang = 0
	for i = 1, nTotal do
		local rec = vec[i]
		if cmd.AREA_XIAN == rec.m_cbGameResult then
			nXian = nXian + 1
		elseif cmd.AREA_ZHUANG == rec.m_cbGameResult then
			nZhuang = nZhuang + 1
		end
	end

	local per = (nXian / nTotal) * 100
	local str = string.format("%d    %.2f%%", nXian, per)
	self.m_textXianSettle:setString(str)

	per = (nZhuang/nTotal) * 100
	str = string.format("%d    %.2f%%", nZhuang, per)
	self.m_textZhuangSettle:setString(str)

	self:showLayer(true)
end

function WallBillLayer:refreshList(  )
	if nil == self.m_parent then
		return
	end	
	local mgr = self.m_parent:getDataMgr()
	local vec = mgr:getWallBills()
	local walllen = #vec
	self.m_nBeginIdx = 1
	if walllen > 20 then
		self.m_nBeginIdx = walllen - 20
	end

	local nCount = 1
	local str = ""
	for i = self.m_nBeginIdx, walllen do
		if nCount > 20 then
			break
		end
		local bill = vec[i]
		for j = 1, bill.m_cbIndex do
			--数量控制
			if j > 5 then
				break
			end
			str = ""
			if cmd.AREA_XIAN == bill.m_pRecords[j] then
				str = "game_ludan1_xian.png"
			elseif cmd.AREA_ZHUANG == bill.m_pRecords[j] then
				str = "game_ludan1_zhuang.png"
			end
			local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(str)
			if nil ~= frame then
				if nil == self.m_spRecord[nCount][j] then
					self.m_spRecord[nCount][j] = cc.Sprite:createWithSpriteFrame(frame)
					self.m_layoutBillSp:addChild(self.m_spRecord[nCount][j])
				else
					self.m_spRecord[nCount][j]:setSpriteFrame(frame)
				end
				local pos = cc.p(self.m_spRecord[nCount][1]:getPositionX(), self.m_vec2Pos[j])
				self.m_spRecord[nCount][j]:setPosition(pos)
			end
		end

		if bill.m_bWinList then
			if cmd.AREA_XIAN == bill.m_pRecords[6] then
            	str = "game_ludan1_xian.png"
            elseif cmd.AREA_ZHUANG == bill.m_pRecords[6] then          
                str = "game_ludan1_zhuang.png"         
            end

            local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(str)
            if nil ~= frame then
            	if nil == self.m_spRecord[nCount][6] then
					self.m_spRecord[nCount][6] = cc.Sprite:createWithSpriteFrame(frame)
					self.m_layoutBillSp:addChild(self.m_spRecord[nCount][6])
				else
					self.m_spRecord[nCount][6]:setSpriteFrame(frame)
				end
				local pos = cc.p(self.m_spRecord[nCount][1]:getPositionX(), self.m_vec2Pos[6])
				self.m_spRecord[nCount][6]:setPosition(pos)
           	end       
		end

		nCount = nCount + 1
	end

	local vec2 = mgr:getRecords()
	nCount = 1
	local subCount = 1
	local nBegin = 1
	local len = #vec2
	if len > 84 then
		nBegin = len - 84
	end
	for i = nBegin, len do
		if nCount > 10 then
			break
		end

		local rec = vec2[i]
		str = ""
		if 7 == rec.m_cbGameType then
			str = "clearing_7.png"
		elseif 6 == rec.m_cbGameType then
			str = "clearing_6.png"
		elseif 5 == rec.m_cbGameType then
			str = "clearing_5.png"
		elseif 4 == rec.m_cbGameType then
			str = "clearing_4.png"
		elseif 3 == rec.m_cbGameType then
			str = "clearing_3.png"
		elseif 2 == rec.m_cbGameType then
			str = "clearing_2.png"
        else
            str = "clearing_1.png"
		end
		local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(str)

		if nil ~= frame then
			if nil == self.m_spRecord2[nCount][subCount] then
				self.m_spRecord2[nCount][subCount] = cc.Sprite:createWithSpriteFrame(frame)
				self.m_layoutBillSp2:addChild(self.m_spRecord2[nCount][subCount])
                self.m_spRecord2[nCount][subCount]:setScale(0.75)
			else
				self.m_spRecord2[nCount][subCount]:setSpriteFrame(frame)
                self.m_spRecord2[nCount][subCount]:setScale(0.75)
			end
			local pos = cc.p(self.m_spRecord2[nCount][1]:getPositionX(), self.m_vec2Pos2[subCount])
			self.m_spRecord2[nCount][subCount]:setPosition(pos)
		end

		subCount = subCount + 1
		--if subCount > 6 then
        if subCount > 2 then
			subCount = 1
			nCount = nCount + 1
		end
	end
end
return WallBillLayer
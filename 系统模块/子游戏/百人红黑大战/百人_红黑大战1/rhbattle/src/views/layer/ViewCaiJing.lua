--
-- Author: zhong
-- Date: 2016-07-08 17:16:26
--
--设置界面
local ExternalFun = require(appdf.EXTERNAL_SRC .. "ExternalFun")
local PopupInfoHead = require(appdf.EXTERNAL_SRC .. "PopupInfoHead")

local ViewCaiJing = class("ViewCaiJing", cc.Layer)

ViewCaiJing.BT_CLOSE = 3
ViewCaiJing.RES_PATH =device.writablePath.."game/yule/rhbattle/res/public_res/"
--构造
function ViewCaiJing:ctor(viewParent)
    self.m_parent = viewParent

	--加载csb资源
	local csbNode = ExternalFun.loadCSB("Jackpot/Jackpot.csb", self)
    self.csbNode = csbNode
	local function btnEvent( sender, eventType )
		if eventType == ccui.TouchEventType.ended then
			self:onBtnClick(sender:getTag(), sender)
		end
	end

    local Panel_1 = csbNode:getChildByName("Panel_1")
    self._lblCaiJing = Panel_1:getChildByName("AtlasLabel_2")

	--关闭按钮
	local closeBtn = csbNode:getChildByName("close_btn")
	closeBtn:setTag(ViewCaiJing.BT_CLOSE)
	closeBtn:addTouchEventListener(btnEvent)

    local middle = csbNode:getChildByName("Middle")

    self.m_Cardtype = cc.Sprite:create(ViewCaiJing.RES_PATH.."rd_6.png")
    self.m_Cardtype:setPosition(420, 305)
    self.m_Cardtype:addTo(self.csbNode)

    self.m_Text_Score = middle:getChildByName("Text_Score")
    self.m_Text_Time = middle:getChildByName("Text_Time")

    self:updateList(3)

end

--
function ViewCaiJing:showLayer( var )
	self:setVisible(var)
end

function ViewCaiJing:onBtnClick( tag, sender )
	if ViewCaiJing.BT_CLOSE == tag then
		ExternalFun.playClickEffect()
		self:removeFromParent()
	end
end

function ViewCaiJing:setCaiJingValue( var )
	self._lblCaiJing:setString(tostring(var))
end

function ViewCaiJing:setCaiJingUseValue(cardType,score,time)
    if cardType == 7 then
        self.m_Cardtype:setTexture(ViewCaiJing.RES_PATH.."rd_7.png")
    else
        self.m_Cardtype:setTexture(ViewCaiJing.RES_PATH.."rd_6.png")
    end
    self.m_Text_Score:setString(score)
    self.m_Text_Time:setString(time)
end

--更新列表 
function ViewCaiJing:updateList(listType)

    --创建列表
    for i = 1, listType do
        local x         =   164 + i * 254
        local y         =   200
        local item      =   self:getListItem(i)
        item:setPosition(x, y)
        item:addTo(self.csbNode)
        if i == 1 then 
            item.txtNickName:setString(GlobalUserItem.szNickName)
            item.txtScore:setString(GlobalUserItem.lUserScore)
        end
    end
end

--获取列表
function ViewCaiJing:getListItem(listType)
    --背景
    local item = cc.Sprite:create(ViewCaiJing.RES_PATH.."head_bg.png")
    local itemSize = item:getContentSize()

    local useItem = self.m_parent:getMeUserItem()
    local head = PopupInfoHead:createNormal(useItem, 66)
    --local pos = cc.p(300, 300)
    head:setPosition(45, 42)
    --head:enableInfoPop(true, pos, anchor)
    item:addChild(head)

    local head_frame = cc.Sprite:create(ViewCaiJing.RES_PATH.."head_kuang.png")
    head_frame:setPosition(45, 42)
    head_frame:addTo(item)

    item.txtNickName = ccui.Text:create("无人中奖", "fonts/round_body.ttf", 18)
    item.txtNickName:setColor(cc.c3b(255, 255, 255))
    item.txtNickName:setAnchorPoint(0,0.5)
    item.txtNickName:setPosition(90, 60)
    item.txtNickName:addTo(item)

    local score_icon = cc.Sprite:create(ViewCaiJing.RES_PATH.."jinbi.png")
    score_icon:setAnchorPoint(0,0.5)
    score_icon:setScale(0.6)
    score_icon:setPosition(90, 25)
    score_icon:addTo(item)

    item.txtScore = ccui.Text:create("0", "fonts/round_body.ttf", 18)
    item.txtScore:setColor(cc.c3b(255, 255, 0))
    item.txtScore:setAnchorPoint(0,0.5)
    item.txtScore:setPosition(125,25)
    item.txtScore:addTo(item)

    return item
end
return ViewCaiJing
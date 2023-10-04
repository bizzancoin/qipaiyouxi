--
-- Author: zhong
-- Date: 2016-07-08 17:16:26
--
--设置界面
local ExternalFun = require(appdf.EXTERNAL_SRC .. "ExternalFun")

local RuleLayer = class("RuleLayer", cc.Layer)

RuleLayer.BT_CLOSE = 3

--构造
function RuleLayer:ctor( )
	--加载csb资源
	local csbNode = ExternalFun.loadCSB("Jackpot/Rules.csb", self)

	local function btnEvent( sender, eventType )
		if eventType == ccui.TouchEventType.ended then
			self:onBtnClick(sender:getTag(), sender)
		end
	end
	local sp_bg = csbNode --csbNode:getChildByName("Scene")

	--关闭按钮
	local btn = sp_bg:getChildByName("close_btn")
	btn:setTag(RuleLayer.BT_CLOSE)
	btn:addTouchEventListener(btnEvent)
end

--
function RuleLayer:showLayer( var )
	self:setVisible(var)
end

function RuleLayer:onBtnClick( tag, sender )
	if RuleLayer.BT_CLOSE == tag then
		ExternalFun.playClickEffect()
		self:removeFromParent()
	end
end

return RuleLayer
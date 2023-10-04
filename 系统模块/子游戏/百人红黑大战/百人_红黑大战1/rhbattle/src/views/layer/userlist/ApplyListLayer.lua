--
-- Author: zhong
-- Date: 2016-06-28 16:40:04
--
--庄家申请列表
local module_pre = "game.yule.rhbattle.src"

local ExternalFun = require(appdf.EXTERNAL_SRC .. "ExternalFun")
local g_var = ExternalFun.req_var;
local UserItem = module_pre .. ".views.layer.userlist.UserItem"

local ApplyListLayer = class("ApplyListLayer", cc.Layer)
ApplyListLayer.BT_CLOSE = 1
ApplyListLayer.BT_APPLY = 2

function ApplyListLayer:ctor( viewParent)
	--注册事件
	local function onLayoutEvent( event )
		if event == "exit" then
			self:onExit()
        elseif event == "enterTransitionFinish" then
        	self:onEnterTransitionFinish()
        end
	end
	self:registerScriptHandler(onLayoutEvent)

	--
	self.m_parent = viewParent

	--用户列表
	self.m_userlist = {}

	--加载csb资源
	local csbNode = ExternalFun.loadCSB("game/ApplyListLayer.csb", self)

	local sp_bg = csbNode:getChildByName("sp_userlist_bg")
	self.m_spBg = sp_bg
	local content = sp_bg:getChildByName("content")

	--用户列表
	local m_tableView = cc.TableView:create(content:getContentSize())
	m_tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	m_tableView:setPosition(content:getPosition())
	m_tableView:setDelegate()
	m_tableView:registerScriptHandler(self.cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
	m_tableView:registerScriptHandler(handler(self, self.tableCellAtIndex), cc.TABLECELL_SIZE_AT_INDEX)
	m_tableView:registerScriptHandler(handler(self, self.numberOfCellsInTableView), cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
	sp_bg:addChild(m_tableView)
	self.m_tableView = m_tableView;
	content:removeFromParent()

	--关闭按钮
	local function btnEvent( sender, eventType )
		if eventType == ccui.TouchEventType.ended then
			self:onButtonClickedEvent(sender:getTag(), sender);
		end
	end
	local btn = sp_bg:getChildByName("close_btn")
	btn:setTag(ApplyListLayer.BT_CLOSE)
	btn:addTouchEventListener(btnEvent);

	local function applyBtn( sender, eventType )
		if eventType == ccui.TouchEventType.ended then
			self:onApplyClickedEvent(sender:getTag(), sender);
		end
	end
	--申请按钮
	btn = sp_bg:getChildByName("apply_btn")
	btn:addTouchEventListener(applyBtn);
	self.m_btnApply = btn

	content:removeFromParent()
end

function ApplyListLayer:refreshList( userlist )
	self:setVisible(true)
	self.m_userlist = userlist
	self.m_tableView:reloadData()

	if nil == self.m_parent or nil == self.m_parent.getApplyState then
		ExternalFun.enableBtn(self.m_btnApply, false)
		return
	end

	--获取当前申请状态
	local state = self.m_parent:getApplyState()	
	local str1 = nil
	local str2 = nil

	ExternalFun.enableBtn(self.m_btnApply, false)
	--未申请状态则申请、申请状态则取消申请、已申请则取消申请
	if state == self.m_parent._apply_state.kCancelState then
		str1 = "btn_apply_banker_0.png"
		str2 = "btn_apply_banker_1.png"

		--申请条件限制
		ExternalFun.enableBtn(self.m_btnApply, self.m_parent:getApplyable())
	elseif state == self.m_parent._apply_state.kApplyState then
		str1 = "btn_cancel_apply_0.png"
		str2 = "btn_cancel_apply_1.png"

		ExternalFun.enableBtn(self.m_btnApply, true)
	elseif state == self.m_parent._apply_state.kApplyedState then
		str1 = "btn_cancel_banker_0.png"
		str2 = "btn_cancel_banker_1.png"

		--取消上庄限制
		ExternalFun.enableBtn(self.m_btnApply, self.m_parent:getCancelable())
	end

	print("state . " .. state)
	local btn = self.m_btnApply
	if nil ~= str1 and nil ~= str2 then
		btn:loadTextureDisabled(str1,UI_TEX_TYPE_PLIST)
		btn:loadTextureNormal(str1,UI_TEX_TYPE_PLIST)
		btn:loadTexturePressed(str2,UI_TEX_TYPE_PLIST)
	end
	btn:setTag(state)
end

function ApplyListLayer:refreshBtnState(  )
	if nil == self.m_parent or nil == self.m_parent.getApplyState then
		ExternalFun.enableBtn(self.m_btnApply, false)
		return
	end

	--获取当前申请状态
	local state = self.m_parent:getApplyState()
	if state == self.m_parent._apply_state.kApplyedState then
		--已申请状态，下庄限制
		ExternalFun.enableBtn(self.m_btnApply, self.m_parent:getCancelable())
	end
end

--tableview
function ApplyListLayer.cellSizeForTable( view, idx )
	return g_var(UserItem).getSize()
end

function ApplyListLayer:numberOfCellsInTableView( view )
	if nil == self.m_userlist then
		return 0
	else
		return #self.m_userlist
	end
end

function ApplyListLayer:tableCellAtIndex( view, idx )
	local cell = view:dequeueCell()
	
	if nil == self.m_userlist then
		return cell
	end

	local useritem = self.m_userlist[idx+1].m_userItem
	local var_bRob = self.m_userlist[idx+1].m_bRob
	local item = nil

	if nil == cell then
		cell = cc.TableViewCell:new()
		item = g_var(UserItem):create()
		item:setPosition(view:getViewSize().width * 0.5, 0)
		item:setName("user_item_view")
		cell:addChild(item)
	else
		item = cell:getChildByName("user_item_view")
	end

	if nil ~= useritem and nil ~= item then
		item:refresh(useritem,var_bRob, idx / #self.m_userlist)
	end

	return cell
end
--

function ApplyListLayer:onButtonClickedEvent( tag, sender )
	ExternalFun.playClickEffect()
	if ApplyListLayer.BT_CLOSE == tag then
		self:setVisible(false)
	end
end

function ApplyListLayer:onApplyClickedEvent( tag,sender )
	ExternalFun.playClickEffect()
	if nil ~= self.m_parent then
		self.m_parent:applyBanker(tag)
	end
end

function ApplyListLayer:onExit()
	local eventDispatcher = self:getEventDispatcher()
	eventDispatcher:removeEventListener(self.listener)
end

function ApplyListLayer:onEnterTransitionFinish()
	self:registerTouch()
end

function ApplyListLayer:registerTouch()
	local function onTouchBegan( touch, event )
		return self:isVisible()
	end

	local function onTouchEnded( touch, event )
		local pos = touch:getLocation();
		local m_spBg = self.m_spBg
        pos = m_spBg:convertToNodeSpace(pos)
        local rec = cc.rect(0, 0, m_spBg:getContentSize().width, m_spBg:getContentSize().height)
        if false == cc.rectContainsPoint(rec, pos) then
            self:setVisible(false)
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
return ApplyListLayer
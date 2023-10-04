local GameViewLayer = class("GameViewLayer", function(scene)
    local gameViewLayer = display.newLayer()
    return gameViewLayer
end )
local module_pre = "game.yule.rhbattle.src"

-- external
--
local ExternalFun = require(appdf.EXTERNAL_SRC .. "ExternalFun")
local g_var = ExternalFun.req_var
local ClipText = appdf.EXTERNAL_SRC .. "ClipText"
local PopupInfoHead = appdf.EXTERNAL_SRC .. "PopupInfoHead"
--

local cmd = module_pre .. ".models.CMD_Game"
local game_cmd = appdf.HEADER_SRC .. "CMD_GameServer"
local QueryDialog = require("app.views.layer.other.QueryDialog")
local bjlDefine = module_pre .. ".models.bjlGameDefine"

-- utils
--
local UserListLayer = module_pre .. ".views.layer.userlist.UserListLayer"
local ApplyListLayer = module_pre .. ".views.layer.userlist.ApplyListLayer"
local SettingLayer = module_pre .. ".views.layer.SettingLayer"
local RuleLayer = appdf.req(module_pre .. ".views.layer.RuleLayer")
local ViewCaiJing = appdf.req(module_pre .. ".views.layer.ViewCaiJing")
local WallBillLayer = module_pre .. ".views.layer.WallBillLayer"
local SitRoleNode = module_pre .. ".views.layer.SitRoleNode"
local GameResultLayer = module_pre .. ".views.layer.GameResultLayer"
local CardSprite = appdf.req(appdf.GAME_SRC .. "yule.rhbattle.src.views.layer.CardSprite")
local GameLogic = appdf.req(appdf.GAME_SRC.."yule.rhbattle.src.models.GameLogic")
--
GameViewLayer.RES_PATH =device.writablePath.."game/yule/rhbattle/res/public_res/"
----牌显示层
-- self.m_cardLayer = nil

-- 发牌位置
local cardpoint = { cc.p(270, 700), cc.p(950+120, 700) }


GameViewLayer.TAG_START = 100
local enumTable =
{
    "BT_EXIT",
    "BT_START",
    "BT_LUDAN",
    "BT_HLPE",
    "BT_SET",
    "BT_ROBBANKER",
    "BT_APPLYBANKER",
    "BT_USERLIST",
    "BT_APPLYLIST",
    "BANK_LAYER",
    "BT_CLOSEBANK",
    "BT_TAKESCORE",
    "BT_REBET",
    "BT_VIEW_CAIJING",
}
local TAG_ENUM = ExternalFun.declarEnumWithTable(GameViewLayer.TAG_START, enumTable);
local zorders =
{
    "CLOCK_ZORDER",
    "SITDOWN_ZORDER",
    "DROPDOWN_ZORDER",
    "DROPDOWN_CHECK_ZORDER",
    "GAMECARD_ZORDER",
    "SETTING_ZORDER",
    "ROLEINFO_ZORDER",
    "BANK_ZORDER",
    "USERLIST_ZORDER",
    "WALLBILL_ZORDER",
    "GAMERS_ZORDER",
    "ENDCLOCK_ZORDER",
    "CAIJING_ZORDER",
}
local TAG_ZORDER = ExternalFun.declarEnumWithTable(1, zorders);

local enumApply =
{
    "kCancelState",
    "kApplyState",
    "kApplyedState",
    "kSupperApplyed"
}
GameViewLayer._apply_state = ExternalFun.declarEnumWithTable(0, enumApply)
local APPLY_STATE = GameViewLayer._apply_state

-- 默认选中的筹码
local DEFAULT_BET = 1
-- 筹码运行时间
local BET_ANITIME = 0.2

function GameViewLayer:ctor(scene)
    -- 注册node事件
    ExternalFun.registerNodeEvent(self)

    self._scene = scene
    self:gameDataInit()

    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("game/arm_vs/arm_vs.ExportJson")
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("game/arm_st/arm_start.ExportJson")
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("game/arm_s/arm_stop.ExportJson")

    -- 初始化csb界面
    self:initCsbRes();
    -- 初始化通用动作
    self:initAction();

    self.m_cardLayer1 = cc.Layer:create()
    self:addChild(self.m_cardLayer1, 100)

    self.m_CardArray = { }
    --桌面扑克数据
    self.m_cbTableCardArray = {}

    self.m_niuPoint = {}

    self.m_niuPointLayout = {}

    self.m_lscore = {}

    for i=1,3 do
        self.m_lscore[i] = 0
    end

--    self.m_pCaijing = ccui.TextAtlas:create()
--    local num = math.random(100000000,999999999)
--    local str = "" --""..num
--    self.m_pCaijing:setProperty(str, device.writablePath.."game/yule/rhbattle/res/game/font_jiangchi.png", 42, 58, "0")
--    self.m_pCaijing:setPosition(cc.p(667,707))   
--    self:addChild(self.m_pCaijing)

    for i = 1, 2 do
        local temp = { }
        for j = 1, 3 do
            temp[j] = CardSprite:createCard(0)
            temp[j]:setVisible(false)
            temp[j]:setAnchorPoint(0.5, 0.5)
            self.m_cardLayer1:addChild(temp[j])
        end
        self.m_CardArray[i] = temp

        self.m_niuPointLayout[i] = ccui.ImageView:create(GameViewLayer.RES_PATH.."result_1.png")
         self.m_niuPointLayout[i]:setScale(0.8)
        if i == 1 then
            self.m_niuPointLayout[i]:setPosition(cardpoint[i].x+50, cardpoint[i].y-20)
        else 
            self.m_niuPointLayout[i]:setPosition(cardpoint[i].x-60, cardpoint[i].y-20)
        end
        self.m_niuPointLayout[i]:setVisible(false)
        self.m_cardLayer1:addChild(self.m_niuPointLayout[i])
    end

end

function GameViewLayer:loadRes()
    -- 加载卡牌纹理
    cc.Director:getInstance():getTextureCache():addImage("game/card.png");
end

---------------------------------------------------------------------------------------
-- 界面初始化
function GameViewLayer:initCsbRes()
    local rootLayer, csbNode = ExternalFun.loadRootCSB("game/GameLayer.csb", self);
    self.m_rootLayer = rootLayer
    -- 底部按钮
    local bottom_sp = csbNode:getChildByName("bottom_sp");
    self.m_spBottom = bottom_sp;

    -- 初始化按钮
    self:initBtn(csbNode);

    -- 初始化庄家信息
    self:initBankerInfo();

    -- 初始化玩家信息
    self:initUserInfo();

    -- 初始化桌面下注
    self:initJetton(csbNode);

    -- 初始化座位列表
    self:initSitDownList(csbNode)

    -- 倒计时
    self:createClockNode()
end

function GameViewLayer:reSet()

end

function GameViewLayer:reSetForNewGame()
    -- 重置下注区域
    self:cleanJettonArea()

    -- 闪烁停止
    self:jettonAreaBlinkClean()

    self:showGameResult(false)

    if nil ~= self.m_cardLayer then
        self.m_cardLayer:showLayer(false)
    end
end

-- 初始化按钮
function GameViewLayer:initBtn(csbNode)
    -- 切换checkbox
    local function checkEvent(sender, eventType)
        self:onCheckBoxClickEvent(sender, eventType);
    end
    local btnlist_check = csbNode:getChildByName("btnlist_check");
    btnlist_check:addEventListener(checkEvent);
    btnlist_check:setSelected(false);
    btnlist_check:setLocalZOrder(TAG_ZORDER.DROPDOWN_CHECK_ZORDER)
    -- 按钮列表
    local function btnEvent(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            self:onButtonClickedEvent(sender:getTag(), sender);
        end
    end
    local btn_list = csbNode:getChildByName("sp_btn_list");
    self.m_btnList = btn_list;
    btn_list:setScaleY(0.0000001)
    btn_list:setLocalZOrder(TAG_ZORDER.DROPDOWN_ZORDER)

    -- 路单
    local btn = csbNode:getChildByName("ludan_btn");
    btn:setTag(TAG_ENUM.BT_LUDAN);
    btn:addTouchEventListener(btnEvent);

    -- 帮助
    btn = btn_list:getChildByName("bank_help");
    btn:setTag(TAG_ENUM.BT_HLPE);
    btn:addTouchEventListener(btnEvent);

    -- 设置
    btn = btn_list:getChildByName("set_btn");
    btn:setTag(TAG_ENUM.BT_SET);
    btn:addTouchEventListener(btnEvent);

    -- 离开
    btn = csbNode:getChildByName("back_btn");
    btn:setTag(TAG_ENUM.BT_EXIT);
    btn:addTouchEventListener(btnEvent);

    -- 上庄、抢庄
    local banker_bg = csbNode:getChildByName("banker_bg");
    self.m_spBankerBg = banker_bg;
    -- 抢庄
    btn = banker_bg:getChildByName("rob_btn");
    btn:setTag(TAG_ENUM.BT_ROBBANKER);
    btn:addTouchEventListener(btnEvent);
    self.m_btnRob = btn;
    self.m_btnRob:setEnabled(false);

    -- 上庄列表
    btn = banker_bg:getChildByName("apply_btn");
    btn:setTag(TAG_ENUM.BT_APPLYLIST);
    btn:addTouchEventListener(btnEvent);
    self.m_btnApply = btn;

    -- 玩家列表
    btn = self.m_spBottom:getChildByName("userlist_btn");
    btn:setTag(TAG_ENUM.BT_USERLIST);
    btn:addTouchEventListener(btnEvent);

    --续投
    self._btnReBet = self.m_spBottom:getChildByName("btn_continue");
    self._btnReBet:setTag(TAG_ENUM.BT_REBET);
    self._btnReBet:setEnabled(false)
    self._btnReBet:addTouchEventListener(btnEvent);

    --查看彩金
	self.btnViewCaiJing = ccui.Button:create("game/caijingbtn.png","game/caijingbtn.png","game/caijingbtn.png")
		:move(1334/2,750-150/2)
		:setTag(TAG_ENUM.BT_VIEW_CAIJING)
		:addTo(self, 300)
		:setVisible(true)
	self.btnViewCaiJing:addTouchEventListener(btnEvent)

end

-- 初始化庄家信息
function GameViewLayer:initBankerInfo(...)
    local banker_bg = self.m_spBankerBg;
    -- 庄家姓名
    local tmp = banker_bg:getChildByName("name_text");
    self.m_clipBankerNick = g_var(ClipText):createClipText(tmp:getContentSize(), "");
    self.m_clipBankerNick:setAnchorPoint(tmp:getAnchorPoint());
    self.m_clipBankerNick:setPosition(tmp:getPosition());
    banker_bg:addChild(self.m_clipBankerNick);

    -- 庄家金币
    self.m_textBankerCoin = banker_bg:getChildByName("bankercoin_text");

    self:reSetBankerInfo();
end

function GameViewLayer:reSetBankerInfo()
    self.m_clipBankerNick:setString("");
    self.m_textBankerCoin:setString("");
end

-- 初始化玩家信息
function GameViewLayer:initUserInfo()
    -- 玩家头像
    local tmp = self.m_spBottom:getChildByName("player_head")
    local frame = self.m_spBottom:getChildByName("head_head_frame"):setLocalZOrder(100)
    -- local head = g_var(PopupInfoHead):createClipHead(self:getMeUserItem(), tmp:getContentSize().width)
    local head = g_var(PopupInfoHead):createNormal(self:getMeUserItem(), tmp:getContentSize().width)

    head:setPosition(tmp:getPosition())
    self.m_spBottom:addChild(head)
    head:enableInfoPop(true)

    -- 玩家金币
    self.m_textUserCoint = self.m_spBottom:getChildByName("coin_text")
    :setFontName("fonts/round_body.ttf")
    self.m_textUserName = self.m_spBottom:getChildByName("name_text")
    :setFontName("fonts/round_body.ttf")
    self:reSetUserInfo()
end

function GameViewLayer:reSetUserInfo()
    self.m_scoreUser = 0
    local myUser = self:getMeUserItem()
    if nil ~= myUser then
        self.m_scoreUser = myUser.lScore
        self.m_nameUser = myUser.szNickName
    end
    print("自己金币:" .. ExternalFun.formatScore(self.m_scoreUser))
    local str = ExternalFun.numberThousands(self.m_scoreUser);
    if string.len(str) > 11 then
        str = string.sub(str, 1, 11) .. "...";
    end
    self.m_textUserCoint:setString(str)
    self.m_textUserName:setString(self.m_nameUser)
end

-- 初始化桌面下注
function GameViewLayer:initJetton(csbNode)
    local bottom_sp = self.m_spBottom;
    -- 下注按钮	
    local clip_layout = bottom_sp:getChildByName("clip_layout");
    self.m_layoutClip = clip_layout;
    self:initJettonBtnInfo();
    -- 下注区域
    self:initJettonArea(csbNode);
    -- 下注胜利提示
    self:initJettonSp(csbNode);
end

function GameViewLayer:enableJetton(var)
    -- 下注按钮
    self:reSetJettonBtnInfo(var);
    self._btnReBet:setEnabled(var)

    -- 下注区域
    self:reSetJettonArea(var);
end

-- 下注按钮
function GameViewLayer:initJettonBtnInfo()
    local clip_layout = self.m_layoutClip;

    local function clipEvent(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            self:onJettonButtonClicked(sender:getTag(), sender);
        end
    end

    self.m_pJettonNumber =
    {
        { k = 100, i = 2 },
        { k = 10000, i = 3 },
        { k = 100000, i = 4 },
        { k = 1000000, i = 5 },
        { k = 5000000, i = 6 },
    }

    self.m_tabJettonAnimate = { }
    for i = 1, #self.m_pJettonNumber do
        local tag = i - 1
        local str = string.format("chip%d_btn", tag)
        local btn = clip_layout:getChildByName(str)
        btn:setTag(i)
        btn:addTouchEventListener(clipEvent)
        self.m_tableJettonBtn[i] = btn

        str = string.format("chip%d", tag)
        self.m_tabJettonAnimate[i] = clip_layout:getChildByName(str)
    end

    self:reSetJettonBtnInfo(false);
end

function GameViewLayer:reSetJettonBtnInfo(var)
    for i = 1, #self.m_tableJettonBtn do
        self.m_tableJettonBtn[i]:setTag(i)
        self.m_tableJettonBtn[i]:setEnabled(var)

        self.m_tabJettonAnimate[i]:stopAllActions()
        self.m_tabJettonAnimate[i]:setVisible(false)
    end
end

function GameViewLayer:adjustJettonBtn()
    -- 可以下注的数额
    local lCanJetton = self.m_llMaxJetton - self.m_lHaveJetton;
    local lCondition = math.min(self.m_scoreUser, lCanJetton);

    for i = 1, #self.m_tableJettonBtn do
        local enable = false
        if self.m_bOnGameRes then
            enable = false
        else
            enable = self.m_bOnGameRes or(lCondition >= self.m_pJettonNumber[i].k)
        end
        self.m_tableJettonBtn[i]:setEnabled(enable);
    end

    if self.m_nJettonSelect > self.m_scoreUser then
        self.m_nJettonSelect = -1;
    end

    -- 筹码动画
    local enable = lCondition >= self.m_pJettonNumber[self.m_nSelectBet].k;
    if false == enable then
        self.m_tabJettonAnimate[self.m_nSelectBet]:stopAllActions()
        self.m_tabJettonAnimate[self.m_nSelectBet]:setVisible(false)
    end
end

function GameViewLayer:refreshJetton()
    local str = ExternalFun.numberThousands(self.m_lHaveJetton)
    self.m_clipJetton:setString(str)
    --self.m_userJettonLayout:setVisible(self.m_lHaveJetton > 0)
    self.m_userJettonLayout:setVisible(false)
end

function GameViewLayer:switchJettonBtnState(idx)
    for i = 1, #self.m_tabJettonAnimate do
        self.m_tabJettonAnimate[i]:stopAllActions()
        self.m_tabJettonAnimate[i]:setVisible(false)
    end

    -- 可以下注的数额
    local lCanJetton = self.m_llMaxJetton - self.m_lHaveJetton;
    local lCondition = math.min(self.m_scoreUser, lCanJetton);
    if nil ~= idx and nil ~= self.m_tabJettonAnimate[idx] then
        local enable = lCondition >= self.m_pJettonNumber[idx].k;
        if enable then
            local blink = cc.Blink:create(1.0, 1)
            self.m_tabJettonAnimate[idx]:runAction(cc.RepeatForever:create(blink))
        end
    end
end

-- 下注筹码结算动画
function GameViewLayer:betAnimation()
    local cmd_gameend = self:getDataMgr().m_tabGameEndCmd
    if nil == cmd_gameend then
        return
    end

    local tmp = self.m_betAreaLayout:getChildren()
    -- 数量控制
    local maxCount = 300
    local count = 0
    local children = { }
    for k, v in pairs(tmp) do
        table.insert(children, v)
        count = count + 1
        if count > maxCount then
            break
        end
    end
    local left = { }
    print("bankerscore:" .. ExternalFun.formatScore(cmd_gameend.lBankerScore))
    print("selfscore:" .. ExternalFun.formatScore(cmd_gameend.lPlayAllScore))

    -- 庄家的
    local call = cc.CallFunc:create( function()
        left = self:userBetAnimation(children, "banker", cmd_gameend.lBankerScore)
    end )
    local delay = cc.DelayTime:create(0.5)

    -- 自己的
    local meChair = self:getMeUserItem().wChairID
    local call2 = cc.CallFunc:create( function()
        left = self:userBetAnimation(left, meChair, cmd_gameend.lPlayAllScore)
    end )
    local delay2 = cc.DelayTime:create(0.5)

    -- 坐下的
    local call3 = cc.CallFunc:create( function()
        for i = 1, g_var(cmd).MAX_OCCUPY_SEAT_COUNT do
            if nil ~= self.m_tabSitDownUser[i] then
                -- 非自己
                local chair = self.m_tabSitDownUser[i]:getChair()
                local score = cmd_gameend.lOccupySeatUserWinScore[1][i]
                if meChair ~= chair then
                    left = self:userBetAnimation(left, chair, cmd_gameend.lOccupySeatUserWinScore[1][i])
                end

                local useritem = self:getDataMgr():getChairUserList()[chair + 1]
                -- 金币动画
                self.m_tabSitDownUser[i]:gameEndScoreChange(useritem, score)
            end
        end
    end )
    local delay3 = cc.DelayTime:create(0.5)

    -- 其余玩家的
    local call4 = cc.CallFunc:create( function()
        self:userBetAnimation(left, "other", 1)
    end )

    -- 剩余没有移走的
    local call5 = cc.CallFunc:create( function()
        -- 下注筹码数量显示移除
        self:cleanJettonArea()
    end )

    local seq = cc.Sequence:create(call, delay, call2, delay2, call3, delay3, call4, cc.DelayTime:create(2), call5)
    self:stopAllActions()
    self:runAction(seq)
end

-- 玩家分数
function GameViewLayer:userBetAnimation(children, wchair, score)
    if nil == score or score <= 0 then
        return children
    end

    local left = { }
    local getScore = score
    local tmpScore = 0
    local totalIdx = #self.m_pJettonNumber
    local winSize = self.m_betAreaLayout:getContentSize()
    local remove = true
    local count = 0
    for k, v in pairs(children) do
        local idx = nil

        if remove then
            if nil ~= v and v:getTag() == wchair then
                idx = tonumber(v:getName())

                local pos = self.m_betAreaLayout:convertToNodeSpace(self:getBetFromPos(wchair))
                self:generateBetAnimtion(v, { x = pos.x, y = pos.y }, count)

                if nil ~= idx and nil ~= self.m_pJettonNumber[idx] then
                    tmpScore = tmpScore + self.m_pJettonNumber[idx].k
                end

                if tmpScore >= score then
                    remove = false
                end
            elseif yl.INVALID_CHAIR == wchair then
                -- 随机抽下注筹码
                idx = self:randomGetBetIdx(getScore, totalIdx)

                local pos = self.m_betAreaLayout:convertToNodeSpace(self:getBetFromPos(wchair))

                if nil ~= idx and nil ~= self.m_pJettonNumber[idx] then
                    tmpScore = tmpScore + self.m_pJettonNumber[idx].k
                    getScore = getScore - tmpScore
                end

                if tmpScore >= score then
                    remove = false
                end
            elseif "banker" == wchair then
                -- 随机抽下注筹码
                idx = self:randomGetBetIdx(getScore, totalIdx)

                local pos = cc.p(self.m_textBankerCoin:getPositionX(), self.m_textBankerCoin:getPositionY())
                pos = self.m_textBankerCoin:convertToWorldSpace(pos)
                pos = self.m_betAreaLayout:convertToNodeSpace(pos)
                self:generateBetAnimtion(v, { x = pos.x, y = pos.y }, count)

                if nil ~= idx and nil ~= self.m_pJettonNumber[idx] then
                    tmpScore = tmpScore + self.m_pJettonNumber[idx].k
                    getScore = getScore - tmpScore
                end

                if tmpScore >= score then
                    remove = false
                end
            elseif "other" == wchair then
                self:generateBetAnimtion(v, { x = winSize.width, y = 0 }, count)
            else
                table.insert(left, v)
            end
        else
            table.insert(left, v)
        end
        count = count + 1
    end
    return left
end

function GameViewLayer:generateBetAnimtion(bet, pos, count)
    -- 筹码动画	
    local moveTo = cc.MoveTo:create(BET_ANITIME, cc.p(pos.x, pos.y))
    local call = cc.CallFunc:create( function()
        bet:removeFromParent()
    end )
    bet:stopAllActions()
    bet:runAction(cc.Sequence:create(cc.DelayTime:create(0.05 * count), moveTo, call))
end

function GameViewLayer:randomGetBetIdx(score, totalIdx)
    if score > self.m_pJettonNumber[1].k and score < self.m_pJettonNumber[2].k then
        return math.random(1, 2)
    elseif score > self.m_pJettonNumber[2].k and score < self.m_pJettonNumber[3].k then
        return math.random(1, 3)
    elseif score > self.m_pJettonNumber[3].k and score < self.m_pJettonNumber[4].k then
        return math.random(1, 4)
    else
        return math.random(totalIdx)
    end
end

-- 下注区域
function GameViewLayer:initJettonArea(csbNode)
    local tag_control = csbNode:getChildByName("tag_control");
    self.m_tagControl = tag_control

    -- 筹码区域
    self.m_betAreaLayout = tag_control:getChildByName("bet_area")

    -- 按钮列表
    local function btnEvent(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            self:onJettonAreaClicked(sender:getTag(), sender)
        end
    end

    for i = 1, 3 do
        local tag = i - 1;
        local str = string.format("tag%d_btn", tag);
        local tag_btn = tag_control:getChildByName(str);
        tag_btn:setTag(i);
        tag_btn:addTouchEventListener(btnEvent);
        self.m_tableJettonArea[i] = tag_btn;
    end

    -- 下注信息
    local m_userJettonLayout = csbNode:getChildByName("jetton_control")
    local infoSize = m_userJettonLayout:getContentSize()
    local text = ccui.Text:create("本次下注为:", "fonts/round_body.ttf", 20)
    text:setAnchorPoint(cc.p(1.0, 0.5))
    text:setPosition(cc.p(infoSize.width * 0.495, infoSize.height * 0.19))
    m_userJettonLayout:addChild(text)
    m_userJettonLayout:setVisible(false)

    local m_clipJetton = g_var(ClipText):createClipText(cc.size(120, 23), "")
    m_clipJetton:setPosition(cc.p(infoSize.width * 0.5, infoSize.height * 0.19))
    m_clipJetton:setAnchorPoint(cc.p(0, 0.5));
    m_clipJetton:setTextColor(cc.c4b(255, 165, 0, 255))
    m_userJettonLayout:addChild(m_clipJetton)

    self.m_userJettonLayout = m_userJettonLayout
    self.m_clipJetton = m_clipJetton

    self:reSetJettonArea(false)
end

function GameViewLayer:reSetJettonArea(var)
    for i = 1, #self.m_tableJettonArea do
        self.m_tableJettonArea[i]:setEnabled(var)
    end
end

function GameViewLayer:cleanJettonArea()
    -- 移除界面已下注
    self.m_betAreaLayout:removeAllChildren()

    for i = 1, #self.m_tableJettonArea do
        if nil ~= self.m_tableJettonNode[i] then
            -- self.m_tableJettonNode[i]:reSet()
            self:reSetJettonNode(self.m_tableJettonNode[i])
        end
    end
    self.m_userJettonLayout:setVisible(false)
    self.m_clipJetton:setString("")
end

-- 下注胜利提示
function GameViewLayer:initJettonSp(csbNode)
    self.m_tagSpControls = { };
    local sp_control = csbNode:getChildByName("tag_sp_control");
    for i = 1, 8 do
        local tag = i - 1;
        local str = string.format("tagsp_%d", tag);
        local tagsp = sp_control:getChildByName(str);
        self.m_tagSpControls[i] = tagsp;
    end

    self:reSetJettonSp();
end

function GameViewLayer:reSetJettonSp()
    for i = 1, #self.m_tagSpControls do
        self.m_tagSpControls[i]:setVisible(false);
    end
end

-- 胜利区域闪烁
function GameViewLayer:jettonAreaBlink(tabArea)
    for i = 1, #tabArea do
        local score = tabArea[i]
        if score > 0 then
            local rep = cc.RepeatForever:create(cc.Blink:create(1.0, 1))
            self.m_tagSpControls[i]:runAction(rep)
        end
    end
end

function GameViewLayer:jettonAreaBlinkClean()
    for i = 1, g_var(cmd).AREA_MAX do
        self.m_tagSpControls[i]:stopAllActions()
        self.m_tagSpControls[i]:setVisible(false)
    end
end

-- 座位列表
function GameViewLayer:initSitDownList(csbNode)
    local m_roleSitDownLayer = csbNode:getChildByName("role_control")
    self.m_roleSitDownLayer = m_roleSitDownLayer

    -- 按钮列表
    local function btnEvent(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            self:onSitDownClick(sender:getTag(), sender);
        end
    end

    local str = ""
    for i = 1, g_var(cmd).MAX_OCCUPY_SEAT_COUNT do
        str = string.format("sit_btn_%d", i)
        self.m_tabSitDownList[i] = m_roleSitDownLayer:getChildByName(str)
        self.m_tabSitDownList[i]:setTag(i)
        self.m_tabSitDownList[i]:addTouchEventListener(btnEvent);
    end
end

function GameViewLayer:initAction()
    local dropIn = cc.ScaleTo:create(0.2, 1.0);
    dropIn:retain();
    self.m_actDropIn = dropIn;

    local dropOut = cc.ScaleTo:create(0.2, 1.0, 0.0000001);
    dropOut:retain();
    self.m_actDropOut = dropOut;
end

function GameViewLayer:onButtonClickedEvent(tag, ref)
    ExternalFun.playClickEffect()
    if tag == TAG_ENUM.BT_EXIT then
        self:getParentNode():onQueryExitGame()
    elseif tag == TAG_ENUM.BT_REBET then
        self._btnReBet:setEnabled(false)
        self:reSetJettonBtnInfo(false)
        --发送消息
        self:getParentNode():reBet()
    elseif tag == TAG_ENUM.BT_START then
        self:getParentNode():onStartGame()
    elseif tag == TAG_ENUM.BT_USERLIST then
        if nil == self.m_userListLayer then
            self.m_userListLayer = g_var(UserListLayer):create()
            self:addToRootLayer(self.m_userListLayer, TAG_ZORDER.USERLIST_ZORDER)
        end
        local userList = self:getDataMgr():getUserList()
        self.m_userListLayer:refreshList(userList)
    elseif tag == TAG_ENUM.BT_APPLYLIST then
        if nil == self.m_applyListLayer then
            self.m_applyListLayer = g_var(ApplyListLayer):create(self)
            self:addToRootLayer(self.m_applyListLayer, TAG_ZORDER.USERLIST_ZORDER)
        end
        local userList = self:getDataMgr():getApplyBankerUserList()
        self.m_applyListLayer:refreshList(userList)
    elseif tag == TAG_ENUM.BT_HLPE then
        --showToast(self, "帮助文档！", 1)
        local rule = RuleLayer:create()
        self:addToRootLayer(rule, TAG_ZORDER.SETTING_ZORDER)
    elseif tag == TAG_ENUM.BT_VIEW_CAIJING then
        --showToast(self, "查看彩金！", 1)

--        local carJing = ViewCaiJing:create(self)
--        carJing:setCaiJingValue(self._scene._caiJingValue)
--        local cardType = 6
--        local score = 88888888
--        local time = "2018/4/13  3:33:33"
--        carJing:setCaiJingUseValue(cardType,score,time)
--        self:addToRootLayer(carJing, TAG_ZORDER.CAIJING_ZORDER)

    elseif tag == TAG_ENUM.BT_SET then
        local setting = g_var(SettingLayer):create()
        self:addToRootLayer(setting, TAG_ZORDER.SETTING_ZORDER)
    elseif tag == TAG_ENUM.BT_LUDAN then
        if nil == self.m_wallBill then
            self.m_wallBill = g_var(WallBillLayer):create(self)
            self:addToRootLayer(self.m_wallBill, TAG_ZORDER.WALLBILL_ZORDER)
        end
        self.m_wallBill:refreshWallBillList()
    elseif tag == TAG_ENUM.BT_ROBBANKER then
        -- 超级抢庄
        if g_var(cmd).SUPERBANKER_CONSUMETYPE == self.m_tabSupperRobConfig.superbankerType then
            local str = "超级抢庄将花费 " .. self.m_tabSupperRobConfig.lSuperBankerConsume .. ",确定抢庄?"
            local query = QueryDialog:create(str, function(ok)
                if ok == true then
                    self:getParentNode():sendRobBanker()
                end
            end ):setCanTouchOutside(false)
            :addTo(self)
        else
            self:getParentNode():sendRobBanker()
        end
    elseif tag == TAG_ENUM.BT_CLOSEBANK then
        if nil ~= self.m_bankLayer then
            self.m_bankLayer:setVisible(false)
        end
    elseif tag == TAG_ENUM.BT_TAKESCORE then
        self:onTakeScore()
    else
        showToast(self, "功能尚未开放！", 1)
    end
end

function GameViewLayer:onJettonButtonClicked(tag, ref)
    if tag >= 1 and tag <= 6 then
        self.m_nJettonSelect = self.m_pJettonNumber[tag].k;
    else
        self.m_nJettonSelect = -1;
    end

    self.m_nSelectBet = tag
    self:switchJettonBtnState(tag)
    print("click jetton:" .. self.m_nJettonSelect);
end

function GameViewLayer:onJettonAreaClicked(tag, ref)
    local m_nJettonSelect = self.m_nJettonSelect;

    if m_nJettonSelect < 0 then
        return;
    end

    local area = tag - 1;
    if self.m_lHaveJetton > self.m_llMaxJetton then
        showToast(self, "已超过最大下注限额", 1)
        self.m_lHaveJetton = self.m_lHaveJetton - m_nJettonSelect;
        return;
    end
    -- 下注
    self:getParentNode():sendUserBet(area, m_nJettonSelect)
    self._btnReBet:setEnabled(false)
end


function GameViewLayer:showGameResult(bShow)
    if self.m_pTextTotal == nil then
        self.m_pTextTotal = ccui.TextAtlas:create()
    end
    if true == bShow then
        if true == bShow and true == self:getDataMgr().m_bJoin then
            --print("------------jjjjjjjjjjjjjjjjjj-------------------"..self:getDataMgr().m_tabGameResult.m_llTotal)
            local total = self:getDataMgr().m_tabGameResult.m_llTotal

            if total > 0 then
		        str = "." .. ExternalFun.numberThousands(total)
                self.m_pTextTotal:setProperty(str, device.writablePath.."game/yule/rhbattle/res/game/room_clearing_win.png", 21, 34, ".")
	        elseif total < 0 then
		        str = "/" .. ExternalFun.numberThousands(total)
                self.m_pTextTotal:setProperty(str, device.writablePath.."game/yule/rhbattle/res/game/room_clearing_lose.png", 21, 34, ".")
	        else
		        str = "0"
                self.m_pTextTotal:setProperty(str, device.writablePath.."game/yule/rhbattle/res/game/room_clearing_win.png", 21, 34, ".")
	        end
            
            self.m_pTextTotal:setPosition(cc.p(200,100))   
            self:addChild(self.m_pTextTotal)

            self.m_pTextTotal:runAction(cc.Spawn:create(cc.MoveBy:create(2, ccp(0,100)),cc.FadeOut:create(2)))

        end
    else
        if self.m_pTextTotal ~= nil then
            self.m_pTextTotal:removeSelf()
            self.m_pTextTotal = nil
        end
    end
end

function GameViewLayer:onCheckBoxClickEvent(sender, eventType)
    ExternalFun.playClickEffect()
    if eventType == ccui.CheckBoxEventType.selected then
        self.m_btnList:stopAllActions();
        self.m_btnList:runAction(self.m_actDropIn);
    elseif eventType == ccui.CheckBoxEventType.unselected then
        self.m_btnList:stopAllActions();
        self.m_btnList:runAction(self.m_actDropOut);
    end
end

function GameViewLayer:onSitDownClick(tag, sender)
    print("sit ==> " .. tag)
    local useritem = self:getMeUserItem()
    if nil == useritem then
        return
    end

    -- 重复判断
    if nil ~= self.m_nSelfSitIdx and tag == self.m_nSelfSitIdx then
        return
    end

    if nil ~= self.m_nSelfSitIdx then
        -- and tag ~= self.m_nSelfSitIdx  then
        showToast(self, "当前已占 " .. self.m_nSelfSitIdx .. " 号位置,不能重复占位!", 2)
        return
    end

    -- 坐下条件限制
    if self.m_tabSitDownConfig.occupyseatType == g_var(cmd).OCCUPYSEAT_CONSUMETYPE then
        -- 金币占座
            print("---------------------------kkkkkkkkkkkkkkkkk---------------------------")
        if useritem.lScore < self.m_tabSitDownConfig.lOccupySeatConsume then
            local str = "坐下需要消耗 " .. self.m_tabSitDownConfig.lOccupySeatConsume .. " 金币,金币不足!"
            showToast(self, str, 2)
            return
        end
        local str = "坐下将花费 " .. self.m_tabSitDownConfig.lOccupySeatConsume .. ",确定坐下?"
        local query = QueryDialog:create(str, function(ok)
            if ok == true then
                self:getParentNode():sendSitDown(tag - 1, useritem.wChairID)
            end
        end ):setCanTouchOutside(false)
        :addTo(self)
    elseif self.m_tabSitDownConfig.occupyseatType == g_var(cmd).OCCUPYSEAT_VIPTYPE then
         print("---------------------------kkkkkkkkkkkkkkkkk---------------------------")
        -- 会员占座
        if useritem.cbMemberOrder < self.m_tabSitDownConfig.enVipIndex then
            local str = "坐下需要会员等级为 " .. self.m_tabSitDownConfig.enVipIndex .. " 会员等级不足!"
            showToast(self, str, 2)
            return
        end
        self:getParentNode():sendSitDown(tag - 1, self:getMeUserItem().wChairID)
    elseif self.m_tabSitDownConfig.occupyseatType == g_var(cmd).OCCUPYSEAT_FREETYPE then
     print("---------------------------kkkkkkkkkkkkkkkkk---------------------------")
        -- 免费占座
        if useritem.lScore < self.m_tabSitDownConfig.lOccupySeatFree then
            local str = "免费坐下需要携带金币大于 " .. self.m_tabSitDownConfig.lOccupySeatFree .. " ,当前携带金币不足!"
            showToast(self, str, 2)
            return
        end
        self:getParentNode():sendSitDown(tag - 1, self:getMeUserItem().wChairID)
    end
    --2018-4-15
    self:getParentNode():sendSitDown(tag - 1, self:getMeUserItem().wChairID)
end

function GameViewLayer:onResetView()
    self:stopAllActions()
    self:gameDataReset()
end

function GameViewLayer:onExit()
    self:onResetView()
end

-- 上庄状态
function GameViewLayer:applyBanker(state)
    if state == APPLY_STATE.kCancelState then
        self:getParentNode():sendApplyBanker()
    elseif state == APPLY_STATE.kApplyState then
        self:getParentNode():sendCancelApply()
    elseif state == APPLY_STATE.kApplyedState then
        self:getParentNode():sendCancelApply()
    end
end

---------------------------------------------------------------------------------------
-- 网络消息

------
-- 网络接收
function GameViewLayer:onGetUserScore(item)
    -- 自己
    if item.dwUserID == GlobalUserItem.dwUserID then
        self:reSetUserInfo()
    end

    -- 坐下用户
    for i = 1, g_var(cmd).MAX_OCCUPY_SEAT_COUNT do
        if nil ~= self.m_tabSitDownUser[i] then
            if item.wChairID == self.m_tabSitDownUser[i]:getChair() then
                self.m_tabSitDownUser[i]:updateScore(item)
            end
        end
    end

    -- 庄家
    if self.m_wBankerUser == item.wChairID then
        -- 庄家金币
        local str = string.formatNumberThousands(item.lScore);
        if string.len(str) > 11 then
            str = string.sub(str, 1, 9) .. "...";
        end
        self.m_textBankerCoin:setString("金币:" .. str);
    end
end

function GameViewLayer:refreshCondition()
    local applyable = self:getApplyable()
    if applyable then
        ------
        -- 超级抢庄

        -- 如果当前有超级抢庄用户且庄家不是自己
        if (yl.INVALID_CHAIR ~= self.m_wCurrentRobApply) or(true == self:isMeChair(self.m_wBankerUser)) then
            ExternalFun.enableBtn(self.m_btnRob, false)
        else
            local useritem = self:getMeUserItem()
            -- 判断抢庄类型
            if g_var(cmd).SUPERBANKER_VIPTYPE == self.m_tabSupperRobConfig.superbankerType then
                -- vip类型				
                ExternalFun.enableBtn(self.m_btnRob, useritem.cbMemberOrder >= self.m_tabSupperRobConfig.enVipIndex)
            elseif g_var(cmd).SUPERBANKER_CONSUMETYPE == self.m_tabSupperRobConfig.superbankerType then
                -- 游戏币消耗类型(抢庄条件+抢庄消耗)
                local condition = self.m_tabSupperRobConfig.lSuperBankerConsume + self.m_llCondition
                ExternalFun.enableBtn(self.m_btnRob, useritem.lScore >= condition)
            end
        end
    else
        ExternalFun.enableBtn(self.m_btnRob, false)
    end
end

-- 游戏free
function GameViewLayer:onGameFree()
    yl.m_bDynamicJoin = false

    self:reSetForNewGame()

    self.m_cardLayer1:setVisible(false)

    -- 上庄条件刷新
    self:refreshCondition()

    self:vsCSB()

    -- 申请按钮状态更新
    self:refreshApplyBtnState()
end

-- 游戏开始
function GameViewLayer:onGameStart()
    self.m_nJettonSelect = self.m_pJettonNumber[DEFAULT_BET].k;
    self.m_lHaveJetton = 0;

    -- 获取玩家携带游戏币	
    self:reSetUserInfo();

    self:startCSB()

    self:sendCard()

    self.m_bOnGameRes = false

    -- 不是自己庄家,且有庄家
    if false == self:isMeChair(self.m_wBankerUser) and false == self.m_bNoBanker then
        -- 下注
        self:enableJetton(true);
        -- 调整下注按钮
        self:adjustJettonBtn();

        -- 默认选中的筹码
        self:switchJettonBtnState(DEFAULT_BET)
    end

    math.randomseed(tostring(os.time()):reverse():sub(1, 6))

    -- 申请按钮状态更新
    self:refreshApplyBtnState()
end

-- 游戏进行
function GameViewLayer:reEnterStart(lUserJetton)
    self.m_nJettonSelect = self.m_pJettonNumber[DEFAULT_BET].k;
    self.m_lHaveJetton = lUserJetton;

    -- 获取玩家携带游戏币
    self.m_scoreUser = 0
    self:reSetUserInfo();

    self.m_bOnGameRes = false

    -- 不是自己庄家
    if false == self:isMeChair(self.m_wBankerUser) then
        -- 下注
        self:enableJetton(true);
        -- 调整下注按钮
        self:adjustJettonBtn();

        -- 默认选中的筹码
        self:switchJettonBtnState(DEFAULT_BET)
    end
end

-- 下注条件
function GameViewLayer:onGetApplyBankerCondition(llCon, rob_config)
    self.m_llCondition = llCon
    -- 超级抢庄配置
    self.m_tabSupperRobConfig = rob_config

    self:refreshCondition();
end

-- 刷新庄家信息
function GameViewLayer:onChangeBanker(wBankerUser, lBankerScore, bEnableSysBanker)
    print("更新庄家数据:" .. wBankerUser .. "; coin =>" .. lBankerScore)

    -- 上一个庄家是自己，且当前庄家不是自己，标记自己的状态
    if self.m_wBankerUser ~= wBankerUser and self:isMeChair(self.m_wBankerUser) then
        self.m_enApplyState = APPLY_STATE.kCancelState
    end
    self.m_wBankerUser = wBankerUser
    -- 获取庄家数据
    self.m_bNoBanker = false

    local nickstr = "";
    -- 庄家姓名
    if true == bEnableSysBanker then
        -- 允许系统坐庄
        if yl.INVALID_CHAIR == wBankerUser then
            nickstr = "系统坐庄"
        else
            local userItem = self:getDataMgr():getChairUserList()[wBankerUser + 1];
            if nil ~= userItem then
                nickstr = userItem.szNickName

                if self:isMeChair(wBankerUser) then
                    self.m_enApplyState = APPLY_STATE.kApplyedState
                end
            else
                print("获取用户数据失败")
            end
        end
    else
        if yl.INVALID_CHAIR == wBankerUser then
            nickstr = "无人坐庄"
            self.m_bNoBanker = true
        else
            local userItem = self:getDataMgr():getChairUserList()[wBankerUser + 1];
            if nil ~= userItem then
                nickstr = userItem.szNickName

                if self:isMeChair(wBankerUser) then
                    self.m_enApplyState = APPLY_STATE.kApplyedState
                end
            else
                print("获取用户数据失败")
            end
        end
    end
    self.m_clipBankerNick:setString(nickstr);

    -- 庄家金币
    local str = string.formatNumberThousands(lBankerScore);
    if string.len(str) > 11 then
        str = string.sub(str, 1, 7) .. "...";
    end
    self.m_textBankerCoin:setString("金币:" .. str);

    -- 如果是超级抢庄用户上庄
    if wBankerUser == self.m_wCurrentRobApply then
        self.m_wCurrentRobApply = yl.INVALID_CHAIR
        self:refreshCondition()
    end

    -- 坐下用户庄家
    local chair = -1
    for i = 1, g_var(cmd).MAX_OCCUPY_SEAT_COUNT do
        if nil ~= self.m_tabSitDownUser[i] then
            chair = self.m_tabSitDownUser[i]:getChair()
            self.m_tabSitDownUser[i]:updateBanker(chair == wBankerUser)
        end
    end
end

-- 超级抢庄申请
function GameViewLayer:onGetSupperRobApply()
    if yl.INVALID_CHAIR ~= self.m_wCurrentRobApply then
        self.m_bSupperRobApplyed = true
        ExternalFun.enableBtn(self.m_btnRob, false)
    end
    -- 如果是自己
    if true == self:isMeChair(self.m_wCurrentRobApply) then
        -- 普通上庄申请不可用
        self.m_enApplyState = APPLY_STATE.kSupperApplyed
    end
end

-- 超级抢庄用户离开
function GameViewLayer:onGetSupperRobLeave(wLeave)
    if yl.INVALID_CHAIR == self.m_wCurrentRobApply then
        -- 普通上庄申请不可用
        self.m_bSupperRobApplyed = false

        ExternalFun.enableBtn(self.m_btnRob, true)
    end

    -- 如果是自己
end

-- 更新用户下注
function GameViewLayer:onGetUserBet()
    local data = self:getParentNode().cmd_placebet;
    if nil == data then
        return
    end
    local area = data.cbBetArea + 1;
    local wUser = data.wChairID;
    local llScore = data.lBetScore



    for i=1, area do
        self.m_lscore[i] = llScore
    end

    if self:isMeChair(wUser) then
        if (area == 1 and self.m_lscore[1]>0) then
            self.m_tableJettonArea[3]:setEnabled(false)
        end 

        if (area == 3 and self.m_lscore[3]>0) then
            self.m_tableJettonArea[1]:setEnabled(false) 
        end 
    end

    local nIdx = self:getJettonIdx(data.lBetScore);
    local str = string.format("room_chip_%d_0.png", nIdx);
    local sp = nil
    local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(str)
    if nil ~= frame then
        sp = cc.Sprite:createWithSpriteFrame(frame);
    end
    local btn = self.m_tableJettonArea[area];
    if nil == sp then
        print("sp nil");
    end

    if nil == btn then
        print("btn nil");
    end
    if nil ~= sp and nil ~= btn then
        -- 下注
        sp:setScale(0.6);
        sp:setTag(wUser);
        local name = string.format("%d", area)
        -- ExternalFun.formatScore(data.lBetScore);
        sp:setName(name)

        -- 筹码飞行起点位置
        local pos = self.m_betAreaLayout:convertToNodeSpace(self:getBetFromPos(wUser))
        -- pos = self.m_betAreaLayout:convertToNodeSpace(self:getBetFromPos(wUser))
        sp:setPosition(pos)
        -- 筹码飞行动画
        local act = self:getBetAnimation(self:getBetRandomPos(btn), cc.CallFunc:create( function()
            -- 播放下注声音
            ExternalFun.playSoundEffect("chip.mp3")
        end ))
        sp:stopAllActions()
        sp:runAction(act)
        self.m_betAreaLayout:addChild(sp)

        -- 下注信息显示
        if nil == self.m_tableJettonNode[area] then
            local jettonNode = self:createJettonNode()
            if area == 1 then
                 jettonNode.m_textTotalJetton:move(0,100)
            end
            if area == 2 then
                 jettonNode.m_textTotalJetton:move(100,100)
            end
            if area == 3 then
                 jettonNode.m_textTotalJetton:move(200,100)
            end
            jettonNode:setPosition(btn:getPosition())
            self.m_tagControl:addChild(jettonNode)
            jettonNode:setTag(-1)
            self.m_tableJettonNode[area] = jettonNode
        end
        -- self.m_tableJettonNode[area]:refreshJetton(llScore, llScore, self:isMeChair(wUser))
        self:refreshJettonNode(self.m_tableJettonNode[area], llScore, llScore, self:isMeChair(wUser))

    end

    if self:isMeChair(wUser) then
        self.m_scoreUser = self.m_scoreUser - self.m_nJettonSelect;
        self.m_lHaveJetton = self.m_lHaveJetton + llScore;

        -- 调整下注按钮
        self:adjustJettonBtn();

        -- 显示下注信息
        self:refreshJetton();
    end
end

-- 发牌动画
function GameViewLayer:sendCard()
    self.m_cardLayer1:setVisible(true)
    self.m_niuPointLayout[1]:setVisible(false)
    self.m_niuPointLayout[2]:setVisible(false)
    local delaytime = 0.1
    for i = 1, 2 do
        for j = 1, 3 do
            local card = self.m_CardArray[i][j]
            local index =(i - 1) * 5 + j - 1
            card:setPosition(667, 700)
            card:setScale(0.55)
            card:showCardBack(true)
            card:runAction(cc.Sequence:create(cc.DelayTime:create(delaytime * index), cc.CallFunc:create(
            function()
                --if j == 1 then
                    ExternalFun.playSoundEffect("turncard.mp3")
                --end
                card:setOpacity(0)
                card:setVisible(true)
                card:runAction(cc.FadeTo:create(0.2, 255))
                if i == 1 then
                    card:runAction(cc.Sequence:create(cc.MoveTo:create(0.25,cc.p(cardpoint[i].x+(j-1)*60,cardpoint[i].y))))
                else
                    card:runAction(cc.Sequence:create(cc.MoveTo:create(0.25,cc.p(cardpoint[i].x-(j-1)*60,cardpoint[i].y))))
                end
            end
            )))
        end
    end
end

function GameViewLayer:showLudan()
	local mgr = self:getDataMgr()
   
	--统计数据
	local vec = mgr:getRecords()
	local nTotal = #vec
	local nXian = 0
	local nZhuang = 0

	if nTotal > 20 then --少于8条记录
		--删除第一条记录
		table.remove(vec,1)
		--table.insert(vec,20)
        nTotal = 20
	end

	for i = 1, nTotal do
    local pic = ccui.ImageView:create(GameViewLayer.RES_PATH.."hong_b.png")
    local picType = ccui.ImageView:create(GameViewLayer.RES_PATH.."rd_1.png")
    picType:setScale(0.5)
		local rec = vec[i]
        --print("------------iiiiiiiiiiiiiiii---"..rec.m_cbGameResult)
		if 2 == rec.m_cbGameResult then
            pic:loadTexture(GameViewLayer.RES_PATH.."hong_b.png")
			nXian = nXian + 1
		else
            pic:loadTexture(GameViewLayer.RES_PATH.."hei_b.png")
			nZhuang = nZhuang + 1
		end

        if 7 == rec.m_cbGameType then
            picType:loadTexture(GameViewLayer.RES_PATH.."rd_7.png")
        elseif 6 == rec.m_cbGameType then
            picType:loadTexture(GameViewLayer.RES_PATH.."rd_6.png")
        elseif 5 == rec.m_cbGameType then
            picType:loadTexture(GameViewLayer.RES_PATH.."rd_5.png")
        elseif 4 == rec.m_cbGameType then
            picType:loadTexture(GameViewLayer.RES_PATH.."rd_4.png")
        elseif 3 == rec.m_cbGameType then
            picType:loadTexture(GameViewLayer.RES_PATH.."rd_3.png")
        elseif 2 == rec.m_cbGameType then
            picType:loadTexture(GameViewLayer.RES_PATH.."rd_2.png")
        else 
            picType:loadTexture(GameViewLayer.RES_PATH.."rd_1.png")
        end 
       
        pic:move(160+i*45,148)
        picType:move(160+i*45,116)
        self.m_rootLayer:addChild(pic)
        self.m_rootLayer:addChild(picType)
	end

end
--显示牌跟牌值
function GameViewLayer:showCard()

    local cbBetAreaBlink = {0,0,0}

    local nowbPlayer = false
	local nowbBlaker = false

    local nowCBWinner = g_var(cmd).AREA_MAX

    for i=1,2 do
        local niuvalue = GameLogic:getCardType(self.m_cbTableCardArray[i])
        self.m_niuPoint[i] = niuvalue

        local pointstr = string.format(GameViewLayer.RES_PATH.."result_%d.png", niuvalue)
        
        local pbglayout = self.m_niuPointLayout[i]
        pbglayout:loadTexture(pointstr)

------------------------------------------------------------------

        local idleCards = self.m_cbTableCardArray[1]
        local masterCards = self.m_cbTableCardArray[2]

	    if GameLogic:compareCard(idleCards,masterCards) then		
		    cbBetAreaBlink[g_var(cmd).AREA_XIAN + 1] = 1
            nowCBWinner = g_var(cmd).AREA_XIAN
            nowbPlayer = true
	    else
		    cbBetAreaBlink[g_var(cmd).AREA_ZHUANG + 1] = 1
            nowCBWinner = g_var(cmd).AREA_ZHUANG
            nowbBlaker = true
        end

        if self.m_niuPoint[i] > 2   then
		    cbBetAreaBlink[g_var(cmd).AREA_PING + 1] = 1
	    end

	    self:getDataMgr().m_tabBetArea = cbBetAreaBlink
        

        local areaBlink = cc.CallFunc:create( function()
                self:showBetAreaBlink()     
                end )

       self:runAction(cc.Sequence:create(cc.DelayTime:create(5.5), areaBlink))

-------------------------------------------------------------------------

        local function showFunction(value)
            for j=1,3 do
                local card = self.m_CardArray[value][j]
                local scale = cc.ScaleTo:create(0.2, 0.0001, 0.55)
                local call = cc.CallFunc:create( function()
                    local cardvalue = self.m_cbTableCardArray[value][j]
                    if i == 1 then
                        card:move(cc.p(cardpoint[i].x+(j-1)*60,cardpoint[i].y))
                   else 
                        card:move(cc.p(cardpoint[i].x-(j-1)*60,cardpoint[i].y))
                    end

                    card:setVisible(true)
                    card:setCardValue(cardvalue)
                    card:showCardBack(false)
                end )

                local call2 = cc.CallFunc:create( function()
                    local cardvalue = self.m_cbTableCardArray[value][j]
                    card:setVisible(true)
                    if i == 1 then
                        card:move(cc.p(cardpoint[i].x+(j-1)*60,cardpoint[i].y))
                        if j == 3 then
                            local cardShow = cc.CallFunc:create( function()
                                    card:setCardValue(cardvalue)
                                    local scaleShow = cc.ScaleTo:create(0.2, 0.95, 0.0001)
                                    local scaleBackShow = cc.ScaleTo:create(0.2, 0.95)
                                    card:runAction(cc.Sequence:create(scaleShow, scaleBackShow))
                                    local cardDelay = cc.CallFunc:create( function()
                                        card:showCardBack(false)
                                    end)
                                    card:runAction(cc.Sequence:create(cc.DelayTime:create(0.2),cardDelay))
                            end )

                            card:runAction(cc.Sequence:create(cc.Spawn:create(cc.MoveTo:create(0.3,ccp(667,425)), cc.ScaleTo:create(0.3,0.95)),cardShow,cc.DelayTime:create(1),
                                cc.Spawn:create(cc.MoveTo:create(0.3,cc.p(cardpoint[i].x+(j-1)*60,cardpoint[i].y)), cc.ScaleTo:create(0.3,0.55))))
                        end
                
                    else 
                        card:move(cc.p(cardpoint[i].x-(j-1)*60,cardpoint[i].y))
                        if j == 1 then
                            local cardShow = cc.CallFunc:create( function()
                                    card:setCardValue(cardvalue)
                                    local scaleShow = cc.ScaleTo:create(0.2, 0.95, 0.0001)
                                    local scaleBackShow = cc.ScaleTo:create(0.2, 0.95)
                                    card:runAction(cc.Sequence:create(scaleShow, scaleBackShow))
                                    local cardDelay = cc.CallFunc:create( function()
                                        card:showCardBack(false)
                                    end)
                                    card:runAction(cc.Sequence:create(cc.DelayTime:create(0.2),cardDelay))
                            end )

                            card:runAction(cc.Sequence:create(cc.Spawn:create(cc.MoveTo:create(0.3,ccp(667,425)), cc.ScaleTo:create(0.3,0.95)),cardShow,cc.DelayTime:create(1),
                                cc.Spawn:create(cc.MoveTo:create(0.3,cc.p(cardpoint[i].x+(j-1)*60,cardpoint[i].y)), cc.ScaleTo:create(0.3,0.55))))
                        end
                    end
                end )



                local scaleBack = cc.ScaleTo:create(0.2, 0.55)

                local pointShow = cc.CallFunc:create( function()
                    self.m_niuPointLayout[value]:setVisible(true)      
                end )

                self:runAction(cc.Sequence:create(cc.DelayTime:create(2.5), pointShow))

                local seq
                if value ==1 then
                     if j==3 then
                        seq = cc.Sequence:create(cc.DelayTime:create(j*0.3), call2)
                     else
                        seq = cc.Sequence:create(cc.DelayTime:create(j*0.25), scale, call, scaleBack)
                     end 
                else
                     if j==1 then
                        seq = cc.Sequence:create(cc.DelayTime:create(0.75), call2)
                     else
                        seq = cc.Sequence:create(cc.DelayTime:create(0.75-(j-1)*0.25), scale, call, scaleBack)
                     end
                end
                card:runAction(seq)
            end

        end

        self.m_cardLayer1:runAction(cc.Sequence:create(cc.DelayTime:create((i-1)*3), cc.CallFunc:create(
             function ()
                --ExternalFun.playSoundEffect("open_card.wav")
   
                showFunction(i)
            end
            )))
     end

     local pointType = 1

     if self.m_niuPoint[1] == 7 or self.m_niuPoint[2] == 7 then
        pointType = 7
     elseif self.m_niuPoint[1] == 6 or self.m_niuPoint[2] == 6 then
        pointType = 6
     elseif self.m_niuPoint[1] == 5 or self.m_niuPoint[2] == 5 then
        pointType = 5
     elseif self.m_niuPoint[1] == 4 or self.m_niuPoint[2] == 4 then
        pointType = 4
     elseif self.m_niuPoint[1] == 3 or self.m_niuPoint[2] == 3 then
        pointType = 3
     elseif self.m_niuPoint[1] == 2 or self.m_niuPoint[2] == 2 then
        pointType = 2
     else
        pointType = 1
     end
     local rec = g_var(bjlDefine).getEmptyRecord()

     local serverrecord = g_var(bjlDefine).getEmptyServerRecord()

     serverrecord.bPlayer = nowbPlayer
     serverrecord.bBlaker = nowbBlaker
     --serverrecord.bPing = pointType

     rec.m_pServerRecord = serverrecord
     rec.m_cbGameResult = nowCBWinner
     rec.m_cbGameType = pointType

     self:getDataMgr():addGameRecord(rec)
end

-- 更新用户下注失败
function GameViewLayer:onGetUserBetFail()
    local data = self:getParentNode().cmd_jettonfail;
    if nil == data then
        return;
    end

    -- 下注玩家
    local wUser = data.wPlaceUser;
    -- 下注区域
    local cbArea = data.cbBetArea + 1;
    -- 下注数额
    local llScore = data.lPlaceScore;

    if self:isMeChair(wUser) then
        -- 提示下注失败
        local str = string.format("下注 %s 失败", ExternalFun.formatScore(llScore))
        showToast(self, str, 1)

        -- 自己下注失败
        self.m_scoreUser = self.m_scoreUser + llScore;
        self.m_lHaveJetton = self.m_lHaveJetton - llScore;
        self:adjustJettonBtn();
        self:refreshJetton()

        --
        if 0 ~= self.m_lHaveJetton then
            if nil ~= self.m_tableJettonNode[cbArea] then
                -- self.m_tableJettonNode[cbArea]:refreshJetton(-llScore, -llScore, true)
                self:refreshJettonNode(self.m_tableJettonNode[cbArea], - llScore, - llScore, true)
            end

            -- 移除界面下注元素
            local name = string.format("%d", cbArea)
            -- ExternalFun.formatScore(llScore);
            self.m_betAreaLayout:removeChildByName(name)
        end
    end
end

-- 断线重连更新界面已下注
function GameViewLayer:reEnterGameBet(cbArea, llScore)
    local btn = self.m_tableJettonArea[cbArea];
    if nil == btn or 0 == llSocre then
        return;
    end

    local vec = self:getDataMgr().calcuteJetton(llScore, false);
    for k, v in pairs(vec) do
        local info = v;
        for i = 1, info.m_cbCount do
            local str = string.format("room_chip_%d_0.png", info.m_cbIdx);
            local sp = cc.Sprite:createWithSpriteFrameName(str);
            if nil ~= sp then
                sp:setScale(0.6);
                sp:setTag(yl.INVALID_CHAIR);
                local name = string.format("%d", cbArea)
                -- ExternalFun.formatScore(info.m_llScore);
                sp:setName(name);

                self:randomSetJettonPos(btn, sp);
                self.m_betAreaLayout:addChild(sp);
            end
        end
    end

    -- 下注信息显示
    if nil == self.m_tableJettonNode[cbArea] then
        local jettonNode = self:createJettonNode()

        if cbArea == 1 then 
            jettonNode.m_textTotalJetton:move(0,100)
        end
        if cbArea == 2 then
            jettonNode.m_textTotalJetton:move(100,100)
        end
        if cbArea == 3 then
            jettonNode.m_textTotalJetton:move(200,100)
        end
        jettonNode:setPosition(btn:getPosition());
        self.m_tagControl:addChild(jettonNode);
        jettonNode:setTag(-1);
        self.m_tableJettonNode[cbArea] = jettonNode;
    end
    self:refreshJettonNode(self.m_tableJettonNode[cbArea], llScore, llScore, false)
end

-- 断线重连更新玩家已下注
function GameViewLayer:reEnterUserBet(cbArea, llScore)
    local btn = self.m_tableJettonArea[cbArea];
    if nil == btn or 0 == llSocre then
        return;
    end

    -- 下注信息显示
    if nil == self.m_tableJettonNode[cbArea] then
        local jettonNode = self:createJettonNode()
        if cbArea == 1 then 
            jettonNode.m_textTotalJetton:move(0,100)
        end
        if cbArea == 2 then
            jettonNode.m_textTotalJetton:move(100,100)
        end
        if cbArea == 3 then
            jettonNode.m_textTotalJetton:move(200,100)
        end
        jettonNode:setPosition(btn:getPosition());
        self.m_tagControl:addChild(jettonNode);
        jettonNode:setTag(-1);
        self.m_tableJettonNode[cbArea] = jettonNode;
    end
    self:refreshJettonNode(self.m_tableJettonNode[cbArea], llScore, 0, true)
end

-- 游戏结束
function GameViewLayer:onGetGameEnd()
    self.m_bOnGameRes = true

    for i=1,3 do
        self.m_lscore[i] = 0
    end
    self:showCard()

    --self:showLudan()
    -- 不可下注
    self:enableJetton(false)

    -- 界面资源清理
    self:reSet()
end

-- 申请庄家
function GameViewLayer:onGetApplyBanker()
    if self:isMeChair(self:getParentNode().cmd_applybanker.wApplyUser) then
        self.m_enApplyState = APPLY_STATE.kApplyState
    end

    self:refreshApplyList()
end

-- 取消申请庄家
function GameViewLayer:onGetCancelBanker()
    if self:isMeChair(self:getParentNode().cmd_cancelbanker.wCancelUser) then
        self.m_enApplyState = APPLY_STATE.kCancelState
    end

    self:refreshApplyList()
end

-- 刷新列表
function GameViewLayer:refreshApplyList()
    if nil ~= self.m_applyListLayer and self.m_applyListLayer:isVisible() then
        local userList = self:getDataMgr():getApplyBankerUserList()
        self.m_applyListLayer:refreshList(userList)
    end
end

function GameViewLayer:refreshUserList()
    if nil ~= self.m_userListLayer and self.m_userListLayer:isVisible() then
        local userList = self:getDataMgr():getUserList()
        self.m_userListLayer:refreshList(userList)
    end
end

-- 刷新申请列表按钮状态
function GameViewLayer:refreshApplyBtnState()
    if nil ~= self.m_applyListLayer and self.m_applyListLayer:isVisible() then
        self.m_applyListLayer:refreshBtnState()
    end
end

-- 刷新路单
function GameViewLayer:updateWallBill()
    if nil ~= self.m_wallBill and self.m_wallBill:isVisible() then
        self.m_wallBill:refreshWallBillList()
    end
end

-- 座位坐下信息
function GameViewLayer:onGetSitDownInfo(config, info)
    self.m_tabSitDownConfig = config

    local pos = cc.p(0, 0)
    -- 获取已占位信息
    for i = 1, g_var(cmd).MAX_OCCUPY_SEAT_COUNT do
        print("sit chair " .. info[i])
        self:onGetSitDown(i - 1, info[i], false)
    end
end

-- 座位坐下
function GameViewLayer:onGetSitDown(index, wchair, bAni)
    if wchair ~= nil
        and nil ~= index
        and index ~= g_var(cmd).SEAT_INVALID_INDEX
        and wchair ~= yl.INVALID_CHAIR then
        local useritem = self:getDataMgr():getChairUserList()[wchair + 1]

        if nil ~= useritem then
            -- 下标加1
            index = index + 1
            if nil == self.m_tabSitDownUser[index] then
                self.m_tabSitDownUser[index] = g_var(SitRoleNode):create(self, index)
                self.m_tabSitDownUser[index]:setPosition(self.m_tabSitDownList[index]:getPosition())
                self.m_roleSitDownLayer:addChild(self.m_tabSitDownUser[index])
            end
            self.m_tabSitDownUser[index]:onSitDown(useritem, bAni, wchair == self.m_wBankerUser)

            if useritem.dwUserID == GlobalUserItem.dwUserID then
                self.m_nSelfSitIdx = index
            end
        end
    end
end

-- 座位失败/离开
function GameViewLayer:onGetSitDownLeave(index)
    if index ~= g_var(cmd).SEAT_INVALID_INDEX
        and nil ~= index then
        index = index + 1
        if nil ~= self.m_tabSitDownUser[index] then
            self.m_tabSitDownUser[index]:removeFromParent()
            self.m_tabSitDownUser[index] = nil
        end

        if self.m_nSelfSitIdx == index then
            self.m_nSelfSitIdx = nil
        end
    end
end

-- 银行操作成功
function GameViewLayer:onBankSuccess()
    local bank_success = self:getParentNode().bank_success
    if nil == bank_success then
        return
    end
    GlobalUserItem.lUserScore = bank_success.lUserScore
    GlobalUserItem.lUserInsure = bank_success.lUserInsure

    if nil ~= self.m_bankLayer and true == self.m_bankLayer:isVisible() then
        self:refreshScore()
    end

    showToast(self, bank_success.szDescribrString, 2)
end

-- 银行操作失败
function GameViewLayer:onBankFailure()
    local bank_fail = self:getParentNode().bank_fail
    if nil == bank_fail then
        return
    end

    showToast(self, bank_fail.szDescribeString, 2)
end

-- 银行资料
function GameViewLayer:onGetBankInfo(bankinfo)
    bankinfo.wRevenueTake = bankinfo.wRevenueTake or 10
    if nil ~= self.m_bankLayer then
        local str = "温馨提示:取款将扣除" .. bankinfo.wRevenueTake .. "%的手续费"
        self.m_bankLayer.m_textTips:setString(str)
    end
end
---------------------------------------------------------------------------------------
function GameViewLayer:getParentNode()
    return self._scene;
end

function GameViewLayer:getMeUserItem()
    if nil ~= GlobalUserItem.dwUserID then
        return self:getDataMgr():getUidUserList()[GlobalUserItem.dwUserID]
    end
    return nil
end

function GameViewLayer:isMeChair(wchair)
    local useritem = self:getDataMgr():getChairUserList()[wchair + 1];
    if nil == useritem then
        return false
    else
        return useritem.dwUserID == GlobalUserItem.dwUserID
    end
end

function GameViewLayer:addToRootLayer(node, zorder)
    if nil == node then
        return
    end

    self.m_rootLayer:addChild(node)
    node:setLocalZOrder(zorder)
end

function GameViewLayer:getChildFromRootLayer(tag)
    if nil == tag then
        return nil
    end
    return self.m_rootLayer:getChildByTag(tag)
end

function GameViewLayer:getApplyState()
    return self.m_enApplyState
end

function GameViewLayer:getApplyCondition()
    return self.m_llCondition
end

-- 获取能否上庄
function GameViewLayer:getApplyable()
    -- 自己超级抢庄已申请，则不可进行普通申请
    if APPLY_STATE.kSupperApplyed == self.m_enApplyState then
        return false
    end

    local userItem = self:getMeUserItem();
    if nil ~= userItem then
        return userItem.lScore > self.m_llCondition
    else
        return false
    end
end

-- 获取能否取消上庄
function GameViewLayer:getCancelable()
    return self.m_cbGameStatus == g_var(cmd).GAME_SCENE_FREE
end

-- 下注区域闪烁
function GameViewLayer:showBetAreaBlink()
    local blinkArea = self:getDataMgr().m_tabBetArea
    self:jettonAreaBlink(blinkArea)
end

function GameViewLayer:getDataMgr()
    return self:getParentNode():getDataMgr()
end

function GameViewLayer:logData(msg)
    local p = self:getParentNode()
    if nil ~= p.logData then
        p:logData(msg)
    end
end

function GameViewLayer:showPopWait()
    self:getParentNode():showPopWait()
end

function GameViewLayer:dismissPopWait()
    self:getParentNode():dismissPopWait()
end

function GameViewLayer:gameDataInit()

    -- 播放背景音乐
    ExternalFun.playBackgroudAudio("k6tx_RedBlack.mp3")

    -- 用户列表
    self:getDataMgr():initUserList(self:getParentNode():getUserList())

    -- 加载资源
    self:loadRes()

    -- 变量声明
    self.m_nJettonSelect = -1
    self.m_lHaveJetton = 0;
    self.m_llMaxJetton = 0;
    self.m_llCondition = 0;
    yl.m_bDynamicJoin = false;
    self.m_scoreUser = self:getMeUserItem().lScore or 0

    -- 下注信息
    self.m_tableJettonBtn = { };
    self.m_tableJettonArea = { };

    -- 下注提示
    self.m_tableJettonNode = { };

    self.m_applyListLayer = nil
    self.m_userListLayer = nil
    self.m_wallBill = nil
    self.m_cardLayer = nil
    self.m_gameResultLayer = nil
    self.m_pClock = nil
    self.m_bankLayer = nil

    -- 申请状态
    self.m_enApplyState = APPLY_STATE.kCancelState
    -- 超级抢庄申请
    self.m_bSupperRobApplyed = false
    -- 超级抢庄配置
    self.m_tabSupperRobConfig = { }
    -- 金币抢庄提示
    self.m_bRobAlert = false

    -- 用户坐下配置
    self.m_tabSitDownConfig = { }
    self.m_tabSitDownUser = { }
    -- 自己坐下
    self.m_nSelfSitIdx = nil

    -- 座位列表
    self.m_tabSitDownList = { }

    -- 当前抢庄用户
    self.m_wCurrentRobApply = yl.INVALID_CHAIR

    -- 当前庄家用户
    self.m_wBankerUser = yl.INVALID_CHAIR

    -- 选中的筹码
    self.m_nSelectBet = DEFAULT_BET

    -- 是否结算状态
    self.m_bOnGameRes = false

    -- 是否无人坐庄
    self.m_bNoBanker = false
end

function GameViewLayer:gameDataReset()
    -- 资源释放
    cc.Director:getInstance():getTextureCache():removeTextureForKey("game/card.png")
    cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile("game/game.plist")
    cc.Director:getInstance():getTextureCache():removeTextureForKey("game/game.png")
    cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile("game/pk_card.plist")
    cc.Director:getInstance():getTextureCache():removeTextureForKey("game/pk_card.png")
    cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile("bank/bank.plist")
    cc.Director:getInstance():getTextureCache():removeTextureForKey("bank/bank.png")

    -- 特殊处理public_res blank.png 冲突
    local dict = cc.FileUtils:getInstance():getValueMapFromFile("public/public.plist")
    if nil ~= framesDict and type(framesDict) == "table" then
        for k, v in pairs(framesDict) do
            if k ~= "blank.png" then
                cc.SpriteFrameCache:getInstance():removeSpriteFrameByName(k)
            end
        end
    end
    cc.Director:getInstance():getTextureCache():removeTextureForKey("public_res/public_res.png")

    cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile("setting/setting.plist")
    cc.Director:getInstance():getTextureCache():removeTextureForKey("setting/setting.png")
    cc.Director:getInstance():getTextureCache():removeUnusedTextures()
    cc.SpriteFrameCache:getInstance():removeUnusedSpriteFrames()


    -- 播放大厅背景音乐
    ExternalFun.playPlazzBackgroudAudio()

    -- 变量释放
    self.m_actDropIn:release();
    self.m_actDropOut:release();
    if nil ~= self.m_cardLayer then
        self.m_cardLayer:clean()
    end

    yl.m_bDynamicJoin = false;
    self:getDataMgr():removeAllUser()
    self:getDataMgr():clearRecord()
end

function GameViewLayer:getJettonIdx(llScore)
    local idx = 2;
    for i = 1, #self.m_pJettonNumber do
        if llScore == self.m_pJettonNumber[i].k then
            idx = self.m_pJettonNumber[i].i;
            break;
        end
    end
    return idx;
end

function GameViewLayer:randomSetJettonPos(nodeArea, jettonSp)
    if nil == jettonSp then
        return;
    end

    local pos = self:getBetRandomPos(nodeArea)
    jettonSp:setPosition(cc.p(pos.x, pos.y));
end

function GameViewLayer:getBetFromPos(wchair)
    if nil == wchair then
        return { x = 0, y = 0 }
    end
    local winSize = cc.Director:getInstance():getWinSize()

    -- 是否是自己
    if self:isMeChair(wchair) then
        local tmp = self.m_spBottom:getChildByName("player_head")
        if nil ~= tmp then
            local pos = cc.p(tmp:getPositionX(), tmp:getPositionY())
            pos = self.m_spBottom:convertToWorldSpace(pos)
            return { x = pos.x, y = pos.y }
        else
            return { x = winSize.width, y = 0 }
        end
    end

    local useritem = self:getDataMgr():getChairUserList()[wchair + 1]
    if nil == useritem then
        return { x = winSize.width, y = 0 }
    end

    -- 是否是坐下列表
    local idx = nil
    for i = 1, g_var(cmd).MAX_OCCUPY_SEAT_COUNT do
        if (nil ~= self.m_tabSitDownUser[i]) and(wchair == self.m_tabSitDownUser[i]:getChair()) then
            idx = i
            break
        end
    end
    if nil ~= idx then
        local pos = cc.p(self.m_tabSitDownUser[idx]:getPositionX(), self.m_tabSitDownUser[idx]:getPositionY())
        pos = self.m_roleSitDownLayer:convertToWorldSpace(pos)
        return { x = pos.x, y = pos.y }
    end

    -- 默认位置
    return { x = winSize.width, y = 0 }
end

function GameViewLayer:getBetAnimation(pos, call_back)
    local moveTo = cc.MoveTo:create(BET_ANITIME, cc.p(pos.x, pos.y))
    if nil ~= call_back then
        return cc.Sequence:create(cc.EaseIn:create(moveTo, 2), call_back)
    else
        return cc.EaseIn:create(moveTo, 2)
    end
end

function GameViewLayer:getBetRandomPos(nodeArea)
    if nil == nodeArea then
        return { x = 0, y = 0 }
    end

    local nodeSize = cc.size(nodeArea:getContentSize().width - 80, nodeArea:getContentSize().height - 80);
    local xOffset = math.random()
    local yOffset = math.random()

    local posX = nodeArea:getPositionX() - nodeArea:getAnchorPoint().x * nodeSize.width
    local posY = nodeArea:getPositionY() - nodeArea:getAnchorPoint().y * nodeSize.height
    return cc.p(xOffset * nodeSize.width + posX, yOffset * nodeSize.height + posY)
end

------
-- 倒计时节点
function GameViewLayer:createClockNode()
    self.m_pClock = cc.Node:create()
    self.m_pClock:setPosition(705, 660)
    self:addToRootLayer(self.m_pClock, TAG_ZORDER.CLOCK_ZORDER)

    -- 加载csb资源
    local csbNode = ExternalFun.loadCSB("game/GameClockNode.csb", self.m_pClock)

    -- 倒计时
    self.m_pClock.m_atlasTimer = csbNode:getChildByName("timer_atlas")
    self.m_pClock.m_atlasTimer:setString("")

    -- 提示
    self.m_pClock.m_spTip = csbNode:getChildByName("sp_tip")

    local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame("blank.png")
    if nil ~= frame then
        self.m_pClock.m_spTip:setSpriteFrame(frame)
    end
end

function GameViewLayer:updateClock(tag, left)
    self.m_pClock:setVisible(left > 0)

    local str = string.format("%02d", left)
    self.m_pClock.m_atlasTimer:setString(str)


    if g_var(cmd).kGAMEPLAY_COUNTDOWN == tag then
        if 1 == left then
            self:stopCSB()
        end
    end

    if g_var(cmd).kGAMEOVER_COUNTDOWN == tag then
        if 8 == left then
            if self:getDataMgr().m_bJoin then
                if nil ~= self.m_cardLayer then
                    self.m_cardLayer:showLayer(false)
                end
            end
            -- 筹码动画
            self:betAnimation()
        elseif 4 == left then
            if true == self:getDataMgr().m_bJoin then
                self:showGameResult(true)
            end
            self:showLudan()
            -- 更新路单列表
            self:updateWallBill()
        elseif 3 == left then
            if nil ~= self.m_cardLayer then
                self.m_cardLayer:showLayer(false)
            end
        elseif 0 == left then
            self:showGameResult(false)

            -- 闪烁停止
            self:jettonAreaBlinkClean()
        end
    end
end

function GameViewLayer:showTimerTip(tag)
    tag = tag or -1
    local scale = cc.ScaleTo:create(0.2, 0.0001, 1.0)
    local call = cc.CallFunc:create( function()
        local str = string.format("sp_tip_%d.png", tag)
        local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(str)

        self.m_pClock.m_spTip:setVisible(false)
        if nil ~= frame then
            self.m_pClock.m_spTip:setVisible(true)
            self.m_pClock.m_spTip:setSpriteFrame(frame)
        end
    end )
    local scaleBack = cc.ScaleTo:create(0.2, 1.0)
    local seq = cc.Sequence:create(scale, call, scaleBack)

    self.m_pClock.m_spTip:stopAllActions()
    self.m_pClock.m_spTip:runAction(seq)
end
------

------
-- 下注节点
function GameViewLayer:createJettonNode()
    local jettonNode = cc.Node:create()
    -- 加载csb资源
    local csbNode = ExternalFun.loadCSB("game/JettonNode.csb", jettonNode)

    local m_imageBg = csbNode:getChildByName("jetton_bg")
    local m_textMyJetton = m_imageBg:getChildByName("jetton_my")
    local m_textTotalJetton = m_imageBg:getChildByName("jetton_total")

    jettonNode.m_imageBg = m_imageBg
    jettonNode.m_textMyJetton = m_textMyJetton
    jettonNode.m_textTotalJetton = m_textTotalJetton
    jettonNode.m_llMyTotal = 0
    jettonNode.m_llAreaTotal = 0

    return jettonNode
end

function GameViewLayer:refreshJettonNode(node, my, total, bMyJetton)
    if true == bMyJetton then
        node.m_llMyTotal = node.m_llMyTotal + my
    end

    node.m_llAreaTotal = node.m_llAreaTotal + total
    node:setVisible(node.m_llAreaTotal > 0)

    -- 自己下注数额
    local str = ExternalFun.numberThousands(node.m_llMyTotal);
--    str = str .. " /";
--    if string.len(str) > 15 then
--        str = string.sub(str, 1, 12)
--        str = str .. "... /";
--    end
    str = str .. "";
    if string.len(str) > 15 then
        str = string.sub(str, 1, 12)
        str = str .. "...";
    end
    node.m_textMyJetton:setString(str);

    -- 总下注
    str = ExternalFun.numberThousands(node.m_llAreaTotal)
    str = " " .. str;
    if string.len(str) > 15 then
        str = string.sub(str, 1, 12)
        str = str .. "..."
    else
        local strlen = string.len(str)
        local l = 15 + strlen
        if strlen > l then
            str = string.sub(str, 1, l - 3);
            str = str .. "...";
        end
    end
    node.m_textTotalJetton:setString(str);

    -- 调整背景宽度
--    local mySize = node.m_textMyJetton:getContentSize();
--    local totalSize = node.m_textTotalJetton:getContentSize();
--    local total = cc.size(mySize.width + totalSize.width + 18, 32);
--    node.m_imageBg:setContentSize(total);

    --node.m_textTotalJetton:setPositionX(6 + mySize.width);
end

function GameViewLayer:reSetJettonNode(node)
    node:setVisible(false);

    node.m_textMyJetton:setString("")
    node.m_textTotalJetton:setString("")
    --node.m_imageBg:setContentSize(cc.size(34, 32))

    node.m_llMyTotal = 0
    node.m_llAreaTotal = 0
end
------
-- 银行节点
function GameViewLayer:createBankLayer()
    self.m_bankLayer = cc.Node:create()
    self:addToRootLayer(self.m_bankLayer, TAG_ZORDER.BANK_ZORDER)
    self.m_bankLayer:setTag(TAG_ENUM.BANK_LAYER)

    -- 加载csb资源
    local csbNode = ExternalFun.loadCSB("bank/BankLayer.csb", self.m_bankLayer)
    local sp_bg = csbNode:getChildByName("sp_bg")

    ------
    -- 按钮事件
    local function btnEvent(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            self:onButtonClickedEvent(sender:getTag(), sender)
        end
    end
    -- 关闭按钮
    local btn = sp_bg:getChildByName("close_btn")
    btn:setTag(TAG_ENUM.BT_CLOSEBANK)
    btn:addTouchEventListener(btnEvent)

    --[[ 取款按钮
    btn = sp_bg:getChildByName("out_btn")
    btn:setTag(TAG_ENUM.BT_TAKESCORE)
    btn:addTouchEventListener(btnEvent)
    --]]

    ------
    -- 编辑框
    -- 取款金额
    local tmp = sp_bg:getChildByName("count_temp")
    local editbox = ccui.EditBox:create(tmp:getContentSize(), "blank.png", UI_TEX_TYPE_PLIST)
    :setPosition(tmp:getPosition())
    :setFontName("fonts/round_body.ttf")
    :setPlaceholderFontName("fonts/round_body.ttf")
    :setFontSize(24)
    :setPlaceholderFontSize(24)
    :setMaxLength(32)
    :setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
    :setPlaceHolder("请输入取款金额")
    sp_bg:addChild(editbox)
    self.m_bankLayer.m_editNumber = editbox
    tmp:removeFromParent()

    -- 取款密码
    tmp = sp_bg:getChildByName("passwd_temp")
    editbox = ccui.EditBox:create(tmp:getContentSize(), "blank.png", UI_TEX_TYPE_PLIST)
    :setPosition(tmp:getPosition())
    :setFontName("fonts/round_body.ttf")
    :setPlaceholderFontName("fonts/round_body.ttf")
    :setFontSize(24)
    :setPlaceholderFontSize(24)
    :setMaxLength(32)
    :setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)
    :setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
    :setPlaceHolder("请输入取款密码")
    sp_bg:addChild(editbox)
    self.m_bankLayer.m_editPasswd = editbox
    tmp:removeFromParent()
    ------

    -- 当前游戏币
    self.m_bankLayer.m_textCurrent = sp_bg:getChildByName("text_current")

    -- 银行游戏币
    self.m_bankLayer.m_textBank = sp_bg:getChildByName("text_bank")

    -- 取款费率
    self.m_bankLayer.m_textTips = sp_bg:getChildByName("text_tips")
    self:getParentNode():sendRequestBankInfo()
end

-- 取款
function GameViewLayer:onTakeScore()
    -- 参数判断
    local szScore = string.gsub(self.m_bankLayer.m_editNumber:getText(), "([^0-9])", "")
    local szPass = self.m_bankLayer.m_editPasswd:getText()

    if #szScore < 1 then
        showToast(self, "请输入操作金额！", 2)
        return
    end

    local lOperateScore = tonumber(szScore)
    if lOperateScore < 1 then
        showToast(self, "请输入正确金额！", 2)
        return
    end

    if #szPass < 1 then
        showToast(self, "请输入银行密码！", 2)
        return
    end
    if #szPass < 6 then
        showToast(self, "密码必须大于6个字符，请重新输入！", 2)
        return
    end

    self:showPopWait()
    self:getParentNode():sendTakeScore(szScore, szPass)
end

-- 刷新金币
function GameViewLayer:refreshScore()
    -- 携带游戏币
    local str = ExternalFun.numberThousands(GlobalUserItem.lUserScore)
    if string.len(str) > 19 then
        str = string.sub(str, 1, 19)
    end
    self.m_bankLayer.m_textCurrent:setString(str)

    -- 银行存款
    str = ExternalFun.numberThousands(GlobalUserItem.lUserInsure)
    if string.len(str) > 19 then
        str = string.sub(str, 1, 19)
    end
    self.m_bankLayer.m_textBank:setString(ExternalFun.numberThousands(GlobalUserItem.lUserInsure))

    self.m_bankLayer.m_editNumber:setText("")
    self.m_bankLayer.m_editPasswd:setText("")
end

function GameViewLayer:startCSB()
    local armature = ccs.Armature:create("arm_start")
                     :addTo(self)
                     :setPosition(667, 475)
    armature:getAnimation():playWithIndex(0)

    local function callback()
        armature:setVisible(false)
    end
    local delay = cc.DelayTime:create(1.5)
    local sequence = cc.Sequence:create(delay,cc.CallFunc:create(callback))
    self:runAction(sequence)
end

function GameViewLayer:stopCSB()
    local armature = ccs.Armature:create("arm_stop")
                     :addTo(self)
                     :setPosition(667, 475)
    armature:getAnimation():playWithIndex(0)

    local function callback()
        armature:setVisible(false)
    end
    local delay = cc.DelayTime:create(1.5)
    local sequence = cc.Sequence:create(delay,cc.CallFunc:create(callback))
    self:runAction(sequence)
end

function GameViewLayer:vsCSB()
    ExternalFun.playSoundEffect("vs.mp3")
    local armature = ccs.Armature:create("arm_vs")
                     :addTo(self)
                     :setPosition(667, 475)
    armature:getAnimation():playWithIndex(0)

    local function callback()
        armature:setVisible(false)
    end
    local delay = cc.DelayTime:create(1.5)
    local sequence = cc.Sequence:create(delay,cc.CallFunc:create(callback))
    self:runAction(sequence)

end
------
return GameViewLayer
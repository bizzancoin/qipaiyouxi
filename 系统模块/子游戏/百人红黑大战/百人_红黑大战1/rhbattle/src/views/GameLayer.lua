local GameModel = appdf.req(appdf.CLIENT_SRC.."gamemodel.GameModel")
local GameLayer = class("GameLayer", GameModel)

local module_pre = "game.yule.rhbattle.src";
require("cocos.init")
local ExternalFun =  appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local cmd = module_pre .. ".models.CMD_Game"
local game_cmd = appdf.HEADER_SRC .. "CMD_GameServer"
local GameLogic = module_pre .. ".models.GameLogic";
local GameViewLayer = appdf.req(module_pre .. ".views.layer.GameViewLayer")
local bjlDefine = appdf.req(module_pre .. ".models.bjlGameDefine")
local QueryDialog   = require("app.views.layer.other.QueryDialog")
local g_var = ExternalFun.req_var
local GameFrame = appdf.req(module_pre .. ".models.GameFrame")

function GameLayer:ctor( frameEngine,scene )
    ExternalFun.registerNodeEvent(self)
    self.m_bLeaveGame = false
    self.m_bOnGame = false
    self._dataModle = GameFrame:create()    
    GameLayer.super.ctor(self,frameEngine,scene)
    self._roomRule = self._gameFrame._dwServerRule
    self._caiJingValue = 0
end

--创建场景
function GameLayer:CreateView()
    return GameViewLayer:create(self)
        :addTo(self)
end

function GameLayer:getParentNode( )
    return self._scene
end

function GameLayer:getFrame( )
    return self._gameFrame
end

function GameLayer:getUserList(  )
    return self._gameFrame._UserList
end

function GameLayer:sendNetData( cmddata )
    return self:getFrame():sendSocketData(cmddata)
end

function GameLayer:getDataMgr( )
    return self._dataModle
end

function GameLayer:logData(msg)
    if nil ~= self._scene.logData then
        self._scene:logData(msg)
    end
end

---------------------------------------------------------------------------------------
------继承函数

--获取gamekind
function GameLayer:getGameKind()
    return g_var(cmd).KIND_ID
end

function GameLayer:onExit()
    self:KillGameClock()
    self:dismissPopWait()
    GameLayer.super.onExit(self)
end

-- 重置游戏数据
function GameLayer:OnResetGameEngine()
    self.m_bOnGame = false
    self._gameView.m_enApplyState = self._gameView._apply_state.kCancelState
    self._dataModle:removeAllUser()
    self._dataModle:initUserList(self:getUserList())
    self._gameView:refreshApplyList()
    self._gameView:refreshUserList()
    self._gameView:refreshApplyBtnState()
    self._gameView:cleanJettonArea()
end

--强行起立、退出(用户切换到后台断网处理)
function GameLayer:standUpAndQuit()
    self:sendCancelOccupy()
    GameLayer.super.standUpAndQuit(self)
end

--退出桌子
function GameLayer:onExitTable()
    self:KillGameClock()
    local MeItem = self:GetMeUserItem()
    if MeItem and MeItem.cbUserStatus > yl.US_FREE then
        self:showPopWait()
        self:runAction(cc.Sequence:create(
            cc.CallFunc:create(
                function () 
                    self:sendCancelOccupy()
                    self._gameFrame:StandUp(1)
                end
                ),
            cc.DelayTime:create(10),
            cc.CallFunc:create(
                function ()
                    --强制离开游戏(针对长时间收不到服务器消息的情况)
                    print("delay leave")
                    self:onExitRoom()
                end
                )
            )
        )
        return
    end

   self:onExitRoom()
end

--离开房间
function GameLayer:onExitRoom()
    self:getFrame():onCloseSocket()

    self._scene:onKeyBack()    
end

-- 计时器响应
function GameLayer:OnEventGameClockInfo(chair,time,clockId)
    if nil ~= self._gameView and nil ~= self._gameView.updateClock then
        self._gameView:updateClock(clockId, time)
    end
end

-- 设置计时器
function GameLayer:SetGameClock(chair,id,time)
    GameLayer.super.SetGameClock(self,chair,id,time)
    if nil ~= self._gameView and nil ~= self._gameView.showTimerTip then
        self._gameView:showTimerTip(id)
    end
end

------网络发送
--玩家下注
function GameLayer:sendUserBet( cbArea, lScore )
    local cmddata = ExternalFun.create_netdata(g_var(cmd).CMD_C_PlaceBet)
    cmddata:pushbyte(cbArea)
    cmddata:pushscore(lScore)

    self:SendData(g_var(cmd).SUB_C_PLACE_JETTON, cmddata)
end

--超级抢庄
function GameLayer:sendRobBanker(  )
    local cmddata = CCmd_Data:create(0)

    self:SendData(g_var(cmd).SUB_C_SUPERROB_BANKER, cmddata)
end

--续投
function GameLayer:reBet()
    local cmddata = CCmd_Data:create(0)
    self:SendData(g_var(cmd).SUB_C_REPEAT_BET, cmddata)
end

--申请上庄
function GameLayer:sendApplyBanker(  )
    local cmddata = CCmd_Data:create(0)
    self:SendData(g_var(cmd).SUB_C_APPLY_BANKER, cmddata)
end

--取消申请
function GameLayer:sendCancelApply(  )
    local cmddata = CCmd_Data:create(0)
    self:SendData(g_var(cmd).SUB_C_CANCEL_BANKER, cmddata)
end

--申请坐下
function GameLayer:sendSitDown( index, wchair )
    local cmddata = ExternalFun.create_netdata(g_var(cmd).CMD_C_OccupySeat)
    cmddata:pushword(wchair)
    cmddata:pushbyte(index)

    self:SendData(g_var(cmd).SUB_C_OCCUPYSEAT, cmddata)
end

--申请取消占位
function GameLayer:sendCancelOccupy(  )
    if nil ~= self._gameView.m_nSelfSitIdx then 
        local cmddata = CCmd_Data:create(0)
        self:SendData(g_var(cmd).SUB_C_QUIT_OCCUPYSEAT, cmddata)
    end 
end

--申请取款
function GameLayer:sendTakeScore( lScore,szPassword )
    local cmddata = ExternalFun.create_netdata(g_var(game_cmd).CMD_GR_C_TakeScoreRequest)
    cmddata:setcmdinfo(g_var(game_cmd).MDM_GR_INSURE, g_var(game_cmd).SUB_GR_TAKE_SCORE_REQUEST)
    cmddata:pushbyte(g_var(game_cmd).SUB_GR_TAKE_SCORE_REQUEST)
    cmddata:pushscore(lScore)
    cmddata:pushstring(md5(szPassword),yl.LEN_PASSWORD)

    self:sendNetData(cmddata)
end

--请求银行信息
function GameLayer:sendRequestBankInfo()
    local cmddata = CCmd_Data:create(67)
    cmddata:setcmdinfo(g_var(game_cmd).MDM_GR_INSURE,g_var(game_cmd).SUB_GR_QUERY_INSURE_INFO)
    cmddata:pushbyte(g_var(game_cmd).SUB_GR_QUERY_INSURE_INFO)
    cmddata:pushstring(md5(GlobalUserItem.szPassword),yl.LEN_PASSWORD)

    self:sendNetData(cmddata)
end
------网络接收

-- 场景信息
function GameLayer:onEventGameScene(cbGameStatus,dataBuffer)
    print("场景数据:" .. cbGameStatus);
    if self.m_bOnGame then
        return
    end
    self.m_bOnGame = true
    
    self._gameView.m_cbGameStatus = cbGameStatus;
	if cbGameStatus == g_var(cmd).GAME_SCENE_FREE	then                        --空闲状态
        self:onEventGameSceneFree(dataBuffer);
	elseif cbGameStatus == g_var(cmd).GAME_JETTON	then                        --下注状态
        self:onEventGameSceneJetton(dataBuffer);
	elseif cbGameStatus == g_var(cmd).GAME_END	then                            --游戏状态
        self:onEventGameSceneEnd(dataBuffer);
	end
    self:dismissPopWait()
end

function GameLayer:onEventGameSceneFree( dataBuffer )
    self._gameView:reSetForNewGame()

    local cmd_table = ExternalFun.read_netdata(g_var(cmd).CMD_S_StatusFree, dataBuffer);
    yl.m_bDynamicJoin = false
    local subRob = cmd_table.wCurSuperRobBankerUser
    --当前超级抢庄用户
    self._gameView.m_wCurrentRobApply = subRob
    self.m_wCurrentRobApply = subRob

    --申请条件
    self._gameView:onGetApplyBankerCondition(cmd_table.lApplyBankerCondition, cmd_table.superbankerConfig);

    --游戏倒计时
    self:SetGameClock(self:GetMeChairID(), g_var(cmd).kGAMEFREE_COUNTDOWN, cmd_table.cbTimeLeave)

    self.m_bEnableSystemBanker = cmd_table.bEnableSysBanker
    --刷新庄家信息
    self._gameView:onChangeBanker(cmd_table.wBankerUser, cmd_table.lBankerScore, self.m_bEnableSystemBanker);

    --从申请列表移除
    self._dataModle:removeApplyUser(cmd_table.wBankerUser)

    self._gameView:showLudan()

    --获取到占位信息
  --  self._gameView:onGetSitDownInfo(cmd_table.occupyseatConfig, cmd_table.wOccupySeatChairID[1])

    --彩金
--    self._gameView.m_pCaijing:setString(tostring(cmd_table.lCaiJing))
end

function GameLayer:onEventGameSceneJetton( dataBuffer )
    local cmd_table = ExternalFun.read_netdata(g_var(cmd).CMD_S_StatusPlay, dataBuffer);
    yl.m_bDynamicJoin = false
    local suRob = cmd_table.wCurSuperRobBankerUser
    --当前超级抢庄用户
    self._gameView.m_wCurrentRobApply = suRob
    self.m_wCurrentRobApply = suRob
    
    --申请条件
    self._gameView:onGetApplyBankerCondition(cmd_table.lApplyBankerCondition, cmd_table.superbankerConfig);

    --游戏倒计时
    --self._gameView:startCountDown(cmd_table.cbTimeLeave, g_var(cmd).kGAMEPLAY_COUNTDOWN);
    self:SetGameClock(self:GetMeChairID(), g_var(cmd).kGAMEPLAY_COUNTDOWN, cmd_table.cbTimeLeave)

    --玩家最大下注
    self._gameView.m_llMaxJetton = cmd_table.lPlayBetScore;

    --界面下注信息
    local lScore = 0;
    local ll = 0;
    for i=1,g_var(cmd).AREA_MAX do
        --界面已下注
        ll = cmd_table.lAllBet[1][i];
        self._gameView:reEnterGameBet(i, ll);

        --玩家下注
        ll = cmd_table.lPlayBet[1][i];
        self._gameView:reEnterUserBet(i, ll);
        lScore = lScore + ll;
    end
    -- 刷新下注信息
    self._gameView:refreshJetton()

    self.m_bEnableSystemBanker = cmd_table.bEnableSysBanker
    --刷新庄家信息
    self._gameView:onChangeBanker(cmd_table.wBankerUser, cmd_table.lBankerScore, self.m_bEnableSystemBanker);

    --从申请列表移除
    self._dataModle:removeApplyUser(cmd_table.wBankerUser)

    --游戏开始
    self._gameView:reEnterStart(lScore);

    self._gameView.m_cardLayer1:setVisible(true)

    self._gameView:sendCard()

    self._gameView:showLudan()

    --获取到占位信息
   -- self._gameView:onGetSitDownInfo(cmd_table.occupyseatConfig, cmd_table.wOccupySeatChairID[1])

    --彩金
--    self._gameView.m_pCaijing:setString(tostring(cmd_table.lCaiJing))
--    self._caiJingValue = cmd_table.lCaiJing
end

function GameLayer:onEventGameSceneEnd( dataBuffer )
    local cmd_table = ExternalFun.read_netdata(g_var(cmd).CMD_S_StatusPlay, dataBuffer)
    --保存游戏结果
    self._dataModle.m_tabGameEndCmd = cmd_table

    local suRob = cmd_table.wCurSuperRobBankerUser
    --当前超级抢庄用户
    self._gameView.m_wCurrentRobApply = suRob
    self.m_wCurrentRobApply = suRob

    --申请条件
    self._gameView:onGetApplyBankerCondition(cmd_table.lApplyBankerCondition, cmd_table.superbankerConfig)

    --游戏倒计时
    --self._gameView:startCountDown(cmd_table.cbTimeLeave, g_var(cmd).kGAMEOVER_COUNTDOWN);
    self:SetGameClock(self:GetMeChairID(), g_var(cmd).kGAMEOVER_COUNTDOWN, cmd_table.cbTimeLeave)
    yl.m_bDynamicJoin = true

    --玩家最大下注
    self._gameView.m_llMaxJetton = cmd_table.lPlayBetScore;
    --界面下注信息
    local ll = 0;
    local lScore = 0;
    for i=1,g_var(cmd).AREA_MAX do
        --界面已下注
        ll = cmd_table.lAllBet[1][i]        
        self._gameView:reEnterGameBet(i, ll)

        --玩家下注
        ll = cmd_table.lPlayBet[1][i]        
        self._gameView:reEnterUserBet(i, ll)
        lScore = lScore + ll
    end
    self._gameView.m_lHaveJetton = lScore
    -- 刷新下注信息
    self._gameView:refreshJetton()

    self.m_bEnableSystemBanker = cmd_table.bEnableSysBanker
    --刷新庄家信息
    self._gameView:onChangeBanker(cmd_table.wBankerUser, cmd_table.lBankerScore, self.m_bEnableSystemBanker);

    --从申请列表移除
    self._dataModle:removeApplyUser(cmd_table.wBankerUser)

    --设置游戏结果
    local res = bjlDefine.getEmptyGameResult()
    res.m_llTotal = cmd_table.lPlayAllScore
    res.m_pAreaScore = cmd_table.lPlayScore[1]
    self._dataModle.m_tabGameResult = res
    local bJoin = false
    local nWinCount = 0
    local nLoseCount = 0
    for i = 1, g_var(cmd).AREA_MAX do
        if cmd_table.lPlayScore[1][i] > 0 then
            bJoin = true
            nWinCount = nWinCount + 1
        elseif cmd_table.lPlayScore[1][i] < 0 then
            bJoin = true
            nLoseCount = nLoseCount + 1
        end
    end
    self._dataModle.m_bJoin = bJoin

    --成绩
    self._dataModle.m_llTotalScore = cmd_table.lPlayAllScore
    self._dataModle:calcuteRata(nWinCount, nLoseCount)

    --彩金
--    self._gameView.m_pCaijing:setString(tostring(self._dataModle.lCaiJing))
--    self._caiJingValue = self._dataModle.lCaiJing

    --显示扑克界面
    local tabRes = bjlDefine.getEmptyCardsResult()
    for i = 1, cmd_table.cbCardCount[1][1] do
        tabRes.m_idleCards[i] = cmd_table.cbTableCardArray[1][i]
    end
    for i=1,cmd_table.cbCardCount[1][2] do
        tabRes.m_masterCards[i] = cmd_table.cbTableCardArray[2][i]
    end
 
    self._gameView.m_cbTableCardArray = cmd_table.cbTableCardArray 
      
    if cmd_table.cbTimeLeave > 10 then
        self._gameView.m_cardLayer1:setVisible(true)
        self._gameView:showCard()
    end

    self._gameView:showLudan()
    --获取到占位信息
   -- self._gameView:onGetSitDownInfo(cmd_table.occupyseatConfig, cmd_table.wOccupySeatChairID[1])
end

-- 游戏消息
function GameLayer:onEventGameMessage(sub,dataBuffer)  
    if self.m_bLeaveGame or nil == self._gameView then
        return
    end 
	if sub == g_var(cmd).SUB_S_GAME_FREE then 
        self._gameView.m_cbGameStatus = g_var(cmd).GAME_SCENE_FREE

		self:onSubGameFree(dataBuffer);
	elseif sub == g_var(cmd).SUB_S_GAME_START then 
        self._gameView.m_cbGameStatus = g_var(cmd).GAME_START

		self:onSubGameStart(dataBuffer);
	elseif sub == g_var(cmd).SUB_S_PLACE_JETTON then 
        self._gameView.m_cbGameStatus = g_var(cmd).GAME_PLAY

		self:onSubPlaceJetton(dataBuffer)
	elseif sub == g_var(cmd).SUB_S_GAME_END then 
        self._gameView.m_cbGameStatus = g_var(cmd).GAME_PLAY

		self:onSubGameEnd(dataBuffer);
	elseif sub == g_var(cmd).SUB_S_APPLY_BANKER then
		self:onSubApplyBanker(dataBuffer);
	elseif sub == g_var(cmd).SUB_S_CHANGE_BANKER then 
		self:onSubChangeBanker(dataBuffer);
	elseif sub == g_var(cmd).SUB_S_CHANGE_USER_SCORE then 
		self:onSubChangeUserScore(dataBuffer);
    elseif sub == g_var(cmd).SUB_S_SEND_RECORD then
        self:onSubSendRecord(dataBuffer);
    elseif sub == g_var(cmd).SUB_S_PLACE_JETTON_FAIL then
        self:onSubJettonFail(dataBuffer);
    elseif sub == g_var(cmd).SUB_S_CANCEL_BANKER then
        self:onSubCancelBanker(dataBuffer);
    elseif sub == g_var(cmd).SUB_S_AMDIN_COMMAND then
        self:onSubAdminCmd(dataBuffer);
    elseif sub == g_var(cmd).SUB_S_UPDATE_STORAGE then
        self:onSubUpdateStorage(dataBuffer);
    elseif sub == g_var(cmd).SUB_S_SUPERROB_BANKER then
        self:onSubSupperRobBaner(dataBuffer);
    elseif sub == g_var(cmd).SUB_S_CURSUPERROB_LEAVE then
        self:onSubSupperRobLeave(dataBuffer);
    elseif sub == g_var(cmd).SUB_S_OCCUPYSEAT then
        self:onSubOccupySeat(dataBuffer);
    elseif sub == g_var(cmd).SUB_S_OCCUPYSEAT_FAIL then
        self:onSubOccupySeatFail(dataBuffer);
    elseif sub == g_var(cmd).SUB_S_UPDATE_OCCUPYSEAT then
        self:onSubUpdateOccupySeat(dataBuffer);
	else
		print("unknow gamemessage sub is ==>"..sub)
	end
end

function GameLayer:onSocketInsureEvent( sub,dataBuffer )
    self:dismissPopWait()
    if sub == g_var(game_cmd).SUB_GR_USER_INSURE_SUCCESS then
        local cmd_table = ExternalFun.read_netdata(g_var(game_cmd).CMD_GR_S_UserInsureSuccess, dataBuffer)
        self.bank_success = cmd_table

        self._gameView:onBankSuccess()
    elseif sub == g_var(game_cmd).SUB_GR_USER_INSURE_FAILURE then
        local cmd_table = ExternalFun.read_netdata(g_var(game_cmd).CMD_GR_S_UserInsureFailure, dataBuffer)
        self.bank_fail = cmd_table

        self._gameView:onBankFailure()
    elseif sub == g_var(game_cmd).SUB_GR_USER_INSURE_INFO then --银行资料
        local cmdtable = ExternalFun.read_netdata(g_var(game_cmd).CMD_GR_S_UserInsureInfo, dataBuffer)
        dump(cmdtable, "cmdtable", 6)

        self._gameView:onGetBankInfo(cmdtable)
    else
        print("unknow gamemessage sub is ==>"..sub)
    end
end

--游戏空闲
function GameLayer:onSubGameFree( dataBuffer )
    print("game free")
    yl.m_bDynamicJoin = false

    self.cmd_gamefree = ExternalFun.read_netdata(g_var(cmd).CMD_S_GameFree, dataBuffer);
    --游戏倒计时
    --self._gameView:startCountDown(self.cmd_gamefree.cbTimeLeave, g_var(cmd).kGAMEFREE_COUNTDOWN);
    self:SetGameClock(self:GetMeChairID(), g_var(cmd).kGAMEFREE_COUNTDOWN, self.cmd_gamefree.cbTimeLeave)

--    self._gameView.m_pCaijing:setString(tostring(self.cmd_gamefree.lCaiJing))
--    self._caiJingValue = self.cmd_gamefree.lCaiJing
    self._gameView:onGameFree();
end

--游戏开始
function GameLayer:onSubGameStart( dataBuffer )
    print("game start");
    self.cmd_gamestart = ExternalFun.read_netdata(g_var(cmd).CMD_S_GameStart,dataBuffer);
    --播放开始音效
    ExternalFun.playSoundEffect("kaishixiazhu.mp3")

    --刷新庄家信息
    self._gameView:onChangeBanker(self.cmd_gamestart.wBankerUser, self.cmd_gamestart.lBankerScore, self.m_bEnableSystemBanker);

    --玩家最大下注
    self._gameView.m_llMaxJetton = self.cmd_gamestart.lPlayBetScore;

    --游戏倒计时
    --self._gameView:startCountDown(self.cmd_gamestart.cbTimeLeave, g_var(cmd).kGAMEPLAY_COUNTDOWN);
    self:SetGameClock(self:GetMeChairID(), g_var(cmd).kGAMEPLAY_COUNTDOWN, self.cmd_gamestart.cbTimeLeave)

    self._gameView:onGameStart()
end

--用户下注
function GameLayer:onSubPlaceJetton( dataBuffer )
    print("game bet")
    self.cmd_placebet = ExternalFun.read_netdata(g_var(cmd).CMD_S_PlaceBet, dataBuffer)
    --ExternalFun.playSoundEffect("ADD_SCORE.wav")
    self._gameView:onGetUserBet()

end

--游戏结束
function GameLayer:onSubGameEnd( dataBuffer )
    print("game end");
    local cmd_table = ExternalFun.read_netdata(g_var(cmd).CMD_S_GameEnd,dataBuffer)
    --保存游戏结果
    self._dataModle.m_tabGameEndCmd = cmd_table

    --游戏倒计时
    --self._gameView:startCountDown(cmd_table.cbTimeLeave, g_var(cmd).kGAMEOVER_COUNTDOWN);
    self:SetGameClock(self:GetMeChairID(), g_var(cmd).kGAMEOVER_COUNTDOWN, cmd_table.cbTimeLeave)
    
    --设置游戏结果
    local res = bjlDefine.getEmptyGameResult()
    res.m_llTotal = cmd_table.lPlayAllScore
    res.m_pAreaScore = cmd_table.lPlayScore[1]
    self._dataModle.m_tabGameResult = res
    local bJoin = false
    local nWinCount = 0
    local nLoseCount = 0
    for i = 1, g_var(cmd).AREA_MAX do
        if cmd_table.lPlayScore[1][i] > 0 then
            bJoin = true
            nWinCount = nWinCount + 1
        elseif cmd_table.lPlayScore[1][i] < 0 then
            bJoin = true
            nLoseCount = nLoseCount + 1
        end
    end
    self._dataModle.m_bJoin = bJoin

    --成绩
    self._dataModle.m_llTotalScore = cmd_table.lPlayAllScore
    self._dataModle:calcuteRata(nWinCount, nLoseCount)

    --显示扑克界面
    local tabRes = bjlDefine.getEmptyCardsResult()
    for i = 1, cmd_table.cbCardCount[1][1] do
        tabRes.m_idleCards[i] = cmd_table.cbTableCardArray[1][i]
    end
    for i = 1, cmd_table.cbCardCount[1][2] do
        tabRes.m_masterCards[i] = cmd_table.cbTableCardArray[2][i]
    end
    
    self._gameView.m_cbTableCardArray = cmd_table.cbTableCardArray
    self._gameView:onGetGameEnd()
end

--申请庄家
function GameLayer:onSubApplyBanker( dataBuffer )
    local cmd_table = ExternalFun.read_netdata(g_var(cmd).CMD_S_ApplyBanker,dataBuffer);
    self.cmd_applybanker = cmd_table;
    self._dataModle:addApplyUser(cmd_table.wApplyUser, self.m_wCurrentRobApply == cmd_table.wApplyUser ) 

    self._gameView:onGetApplyBanker()
    print("apply banker ==>" .. cmd_table.wApplyUser)
end

--切换庄家
function GameLayer:onSubChangeBanker( dataBuffer )
    print("change banker")
    local cmd_table = ExternalFun.read_netdata(g_var(cmd).CMD_S_ChangeBanker,dataBuffer);

    self.cmd_changebanker = cmd_table;
    --从申请列表移除
    self._dataModle:removeApplyUser(cmd_table.wBankerUser)

    self._gameView:onChangeBanker(cmd_table.wBankerUser, cmd_table.lBankerScore, self.m_bEnableSystemBanker)

    --申请列表更新
    self._gameView:refreshApplyList()

    --刷新申请按钮状态
    self._gameView:refreshCondition()
end

--更新积分
function GameLayer:onSubChangeUserScore( dataBuffer )
    
end

--游戏记录
function GameLayer:onSubSendRecord( dataBuffer )
    local len = dataBuffer:getlen();
    local recordcount = math.floor(len / g_var(cmd).RECORD_LEN);
    if (len - recordcount * g_var(cmd).RECORD_LEN) ~= 0 then
        print("record_len_error" .. len);
        return;
    end
    self._dataModle:clearRecord()
    
    --游戏记录
    local game_record = {};
    --读取记录列表
    for i=1,recordcount do
        if nil == dataBuffer then
            break;
        end
        local rec = bjlDefine.getEmptyRecord()

        local serverrecord = bjlDefine.getEmptyServerRecord()
           
          serverrecord.bPlayer = dataBuffer:readbool()
          serverrecord.bBlaker = dataBuffer:readbool()
          serverrecord.bPing = dataBuffer:readbyte()

         rec.m_pServerRecord = serverrecord;

        if serverrecord.bPlayer == true then
            rec.m_cbGameResult = g_var(cmd).AREA_XIAN
        else
            rec.m_cbGameResult = g_var(cmd).AREA_ZHUANG
        end
            
            rec.m_cbGameType = serverrecord.bPing

        self._dataModle:addGameRecord(rec)
    end

    self._gameView:updateWallBill()
end

--下注失败
function GameLayer:onSubJettonFail( dataBuffer )
    self.cmd_jettonfail = ExternalFun.read_netdata(g_var(cmd).CMD_S_PlaceBetFail, dataBuffer)

    --self._gameView:onGetUserBetFail()
end

--取消申请
function GameLayer:onSubCancelBanker( dataBuffer )
    print("cancel banker")
    self.cmd_cancelbanker = ExternalFun.read_netdata(g_var(cmd).CMD_S_CancelBanker, dataBuffer)

    if self.cmd_cancelbanker.wCancelUser == self.m_wCurrentRobApply then
        self._gameView.m_wCurrentRobApply = yl.INVALID_CHAIR
        self.m_wCurrentRobApply = yl.INVALID_CHAIR
    end
    --从申请列表移除
    self._dataModle:removeApplyUser(self.cmd_cancelbanker.wCancelUser)

    self._gameView:onGetCancelBanker()
end

--管理员命令
function GameLayer:onSubAdminCmd( dataBuffer )
    
end

--更新库存
function GameLayer:onSubUpdateStorage( dataBuffer )
    
end

--超级抢庄
function GameLayer:onSubSupperRobBaner( dataBuffer )
    local cmd_table = ExternalFun.read_netdata(g_var(cmd).CMD_S_SuperRobBanker, dataBuffer)
    if true == cmd_table.bSucceed then
        print("apply " .. cmd_table.wApplySuperRobUser)
        print("cur " .. cmd_table.wCurSuperRobBankerUser)
        local rob = cmd_table.wApplySuperRobUser
        local cur = cmd_table.wCurSuperRobBankerUser
        self._gameView.m_wCurrentRobApply = rob
        self.m_wCurrentRobApply = suRob
        
        --更新超级抢庄列表
        self._dataModle:updateSupperRobBanker(rob, cur)
        --界面通知
        self._gameView:onGetSupperRobApply()

        --申请列表更新
        self._gameView:refreshApplyList()
    end
end

--超级抢庄玩家离开
function GameLayer:onSubSupperRobLeave( dataBuffer )
    local leaveUser = dataBuffer:readword()

    self._gameView.m_wCurrentRobApply = yl.INVALID_CHAIR
    self.m_wCurrentRobApply = yl.INVALID_CHAIR
    --从申请列表移除
    self._dataModle:removeApplyUser(leaveUser)
    --刷新申请调整
    self._gameView:refreshCondition()
    --
    self._gameView:onGetSupperRobLeave(leaveUser)

    --申请列表更新
    self._gameView:refreshApplyList()
end

--占位
function GameLayer:onSubOccupySeat( dataBuffer )
    local cmd_table = ExternalFun.read_netdata(g_var(cmd).CMD_S_OccupySeat, dataBuffer)

    local wchair = cmd_table.wOccupySeatChairID
    local index = cmd_table.cbOccupySeatIndex
    self._gameView:onGetSitDown(index, wchair, true)
end

--占位失败
function GameLayer:onSubOccupySeatFail( dataBuffer )
    local cmd_table = ExternalFun.read_netdata(g_var(cmd).CMD_S_OccupySeat_Fail, dataBuffer) 

    local wchair = cmd_table.wAlreadyOccupySeatChairID
    local index = cmd_table.cbAlreadyOccupySeatIndex
    self._gameView:onGetSitDownLeave(index)
end

--更新占位
function GameLayer:onSubUpdateOccupySeat( dataBuffer )
    local cmd_table = ExternalFun.read_netdata(g_var(cmd).CMD_S_UpdateOccupySeat, dataBuffer)

    for i = 1, g_var(cmd).MAX_OCCUPY_SEAT_COUNT do
        if cmd_table.tabWOccupySeatChairID[1][i] == yl.INVALID_CHAIR then
            self._gameView:onGetSitDownLeave(i - 1)
        end
    end
end

function GameLayer:onEventUserEnter( wTableID,wChairID,useritem )
    print("add user " .. useritem.wChairID .. "; nick " .. useritem.szNickName)
    --缓存用户
    self._dataModle:addUser(useritem)

    --刷新用户列表
    self._gameView:refreshUserList()
end

function GameLayer:onEventUserStatus(useritem,newstatus,oldstatus)
    print("change user " .. useritem.wChairID .. "; nick " .. useritem.szNickName)
    if newstatus.cbUserStatus == yl.US_FREE then
        print("删除")
        self._dataModle:removeUser(useritem)
    else
        --刷新用户信息
        self._dataModle:updateUser(useritem)
    end

    --刷新用户列表
    self._gameView:refreshUserList()
end

function GameLayer:onEventUserScore( item )
    self._dataModle:updateUser(item)    
    self._gameView:onGetUserScore(item)

    --刷新用户列表
    self._gameView:refreshUserList()
end
---------------------------------------------------------------------------------------
return GameLayer
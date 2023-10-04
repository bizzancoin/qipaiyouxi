--
-- Author: zhong
-- Date: 2016-06-27 09:51:53
--
local cmd = require("game.yule.rhbattle.src.models.CMD_Game")
local bjlDefine = bjlDefine or {};

--用户选择 enUserSelect
bjlDefine.kSelectDefault = -1
--庄赢
bjlDefine.kSelectMasterWin = 0
--闲赢
bjlDefine.kSelectIdleWin = 1
--平局
bjlDefine.kSelectDraw = 2

--申请列表
function bjlDefine.getEmptyApplyInfo(  )
    return
    {
        --用户信息
        m_userItem = {},
        --是否当前庄家
        m_bCurrent = false,
        --编号
        m_llIdx = 0,
        --是否超级抢庄
        m_bRob = false
    }
end

--路单
--服务器记录空table
function bjlDefine.getEmptyServerRecord(  )
    return
    {
        cbKinWinner = 0,
        bPlayerTwoPair = false,
        bBankerTwoPair = false,
        cbPlayerCount = 0,
        cbBankerCount = 0
    }
end

--游戏记录空table
function bjlDefine.getEmptyRecord(  )
    return 
    {
--        m_pServerRecord = 
--        {
--            cbKinWinner = 0,
--            bPlayerTwoPair = false,
--            bBankerTwoPair = false,
--            cbPlayerCount = 0,
--            cbBankerCount = 0
--        },
        m_pServerRecord = 
        {
            bPlayer = false,
            bBlaker = false,
            bPing = false
        },
        m_tagUserRecord = 
        {
            --是否参与
            m_bJoin = false,
            --用户选择 enUserSelect
            m_enSelect = bjlDefine.kSelectDefault,
            --输赢
            m_bWin = false
        },
        m_cbGameResult = cmd.AREA_MAX,
        m_cbGameType = 0
    }
end

--获取空路单
function bjlDefine.getEmptyWallBill(  )
    return
    {
        --路单一列数据 6个
        m_pRecords = {-1,-1,-1,-1,-1,-1},
        --路单列数据索引
        m_cbIndex = 0,
        --路单除去平局索引
        m_cbIndexWithoutPing = 1,
        --是否连胜
        m_bWinList = false,
        --是否跳过
        m_bJumpIdx = false
    }
end

--游戏结果定义
function bjlDefine.getEmptyGameResult( )
	return 
	{
		--分数
		m_pAreaScore = {},
		--总分
		m_llTotal = 0,
		--闲点数
		m_cbIdlePoint = 0,
		--庄点数
		m_cbMasterPoint = 0,
	}
end

--游戏扑克牌数据定义
function bjlDefine.getEmptyCardsResult( )
	return
	{
		m_idleCards = {},
		m_masterCards = {}
	}
end

function bjlDefine.getEmptyDispatchCard(  )
	return
	{
		m_dir = -1,
		m_cbCardData = 0
	}
end
return bjlDefine
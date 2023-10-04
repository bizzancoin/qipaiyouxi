--
-- Author: zhong
-- Date: 2016-07-04 19:06:23
--
--游戏结果层
local GameResultLayer = class("GameResultLayer", cc.Layer)
local ExternalFun = require(appdf.EXTERNAL_SRC .. "ExternalFun")
local g_var = ExternalFun.req_var
local module_pre = "game.yule.rhbattle.src"
local cmd = module_pre .. ".models.CMD_Game"

function GameResultLayer:ctor( )
	--加载csb资源
	local csbNode = ExternalFun.loadCSB("game/GameResultLayer.csb",self)
	local csbBg = csbNode:getChildByName("bg")

	--分数
	local scoreLayout = csbBg:getChildByName("userscore_layout")
	self.m_atlasScore = {}
	local str = ""
	for i = 1, g_var(cmd).AREA_MAX do
		str = string.format("score%d_atlas", i - 1)
		self.m_atlasScore[i] = scoreLayout:getChildByName(str)
	end

	--合计
	--self.m_atlasTotal = csbBg:getChildByName("scroetotal_atlas")
    self.m_atlasTotal = csbNode:getChildByName("scroetotal_atlas")

	--闲点数
	self.m_textIdlePoint = csbBg:getChildByName("idle_point")

	--庄点数
	self.m_textMasterPoint = csbBg:getChildByName("master_point")

	self:hideGameResult()
end

function GameResultLayer:hideGameResult( )
	self:reSet()
	self:setVisible(false)
end

function GameResultLayer:showGameResult( rs )
	self:reSet()
	self:setVisible(true)

	local str = ""
	for i = 1,  g_var(cmd).AREA_MAX do
		local lScore = rs.m_pAreaScore[i]
		if lScore > 0 then
			str = "." .. ExternalFun.numberThousands(lScore)
		elseif lScore < 0 then
			str = "/" .. ExternalFun.numberThousands(lScore)
		else
			str = ""
		end
		if string.len(str) > 12 then
			str = string.sub(str, 1, 12)
		end
		self.m_atlasScore[i]:setString(str)
	end

	--合计
	if rs.m_llTotal > 0 then
		str = "." .. ExternalFun.numberThousands(rs.m_llTotal)
	elseif rs.m_llTotal < 0 then
		str = "/" .. ExternalFun.numberThousands(rs.m_llTotal)
	else
		str = "0"
	end
	if string.len(str) > 12 then
		str = string.sub(str, 1, 12)
	end
	self.m_atlasTotal:setString(str)

	--点数
	str = string.format("闲 %d 点", rs.m_cbIdlePoint)
	self.m_textIdlePoint:setString(str)
	str = string.format("庄 %d 点", rs.m_cbMasterPoint)
	self.m_textMasterPoint:setString(str)
end

function GameResultLayer:reSet( )
	for i = 1, g_var(cmd).AREA_MAX do
		self.m_atlasScore[i]:setString("")
	end

	self.m_atlasTotal:setString("")
	self.m_textIdlePoint:setString("")
	self.m_textMasterPoint:setString("")
end
return GameResultLayer
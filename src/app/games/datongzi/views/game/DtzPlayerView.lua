local PlayerView = import(".PlayerView")
local DtzPlayerView = class("DtzPlayerView", PlayerView)


local BaseAlgorithm = require("app.utils.BaseAlgorithm")
local NiuGuiAlgorithm = require("app.utils.NiuGuiAlgorithm")
local FaceAnimationsData = require("app.data.FaceAnimationsData")

local DEALER_X, DEALER_Y = -40, 34
local OFFLINE_SIGN_X, OFFLINE_SIGN_Y = -38, -28
local PLAY_FLAG_X, PLAY_FLAG_Y = 40, 34
local WIN_FLAG_X, WIN_FLAG_Y = 300, 0
local HEI_TAO_X, HEI_TAO_Y = 95, -20
local TOU_XIANG_X = 70
local RANK_X, RANK_Y = 150, 40
local QI_PAO_X, QI_PAO_Y = 150, 40
local NIU_JIAO_X, NIU_JIAO_Y = 0,45
local WARNING_X = 170
local KING_X = 40
local POKER_BACK_X = 94
local PLAYER_INFO_POS = {
    {400, 150},
    {900, 500},
    {400, 500},
    {400, 200},
}
local ACTION_ANIM_POS = {
    {display.cx, 320 / DESIGN_HEIGHT * display.height},
    {display.width * 960 / DESIGN_WIDTH, display.height * 530 / DESIGN_HEIGHT},
    {display.width * 660 / DESIGN_WIDTH, display.height * 580 / DESIGN_HEIGHT},
    {display.width * 340 / DESIGN_WIDTH, display.height * 530 / DESIGN_HEIGHT},
}
local TYPES = gailun.TYPES
local GRAY_FILTERS  = {"GRAY",{0.2, 0.3, 0.5, 0.1}}
local nodeData = {
    type = TYPES.ROOT,
    children = {
        {type = TYPES.NODE, var = "nodeShowPai_"}, -- 结束展示牌
        {type = TYPES.NODE, var = "nodePlayer_", children = {  -- 玩家基本数据的对象
            {type = TYPES.CUSTOM, var = "avatar_", class = "app.views.AvatarView"},
            {type = TYPES.SPRITE, var = "spriteOffline_", filename = "res/images/game/off_line_sign.png", x = OFFLINE_SIGN_X, y = OFFLINE_SIGN_Y},
            {type = TYPES.SPRITE, var = "spriteWarning_", x = WARNING_X},
            {type = TYPES.SPRITE, var = "spriteWarning2_", x = WARNING_X},
            {type = TYPES.SPRITE, var = "shengliguang_", filename = "res/images/game/shengliguang.png", visible = false, x = WIN_FLAG_X, y =WIN_FLAG_Y},
            {type = TYPES.SPRITE, var = "winFlag_", x = WIN_FLAG_X, y =WIN_FLAG_Y, visible = false},
            {type = TYPES.LABEL, var = "labelNickName_", options = {text="fdsafdsafdsa", size=20, font = DEFAULT_FONT, align=cc.TEXT_ALIGNMENT_CENTER, color=cc.c3b(255, 255, 255)}, y = 68, x = 0, ap = {0.5, 0.5}},
            {type = TYPES.SPRITE, var = "spriteChipsBg_", filename = "res/images/game/score-bg.png", y = -54, scale9 = true, size = {116, 30}, children = {
                {type = TYPES.SPRITE, filename = "res/images/game/score-bg1.png", x = 10, ppy = 0.5},
                {type = TYPES.LABEL_ATLAS, var = "labelScore_", filename = "fonts/game_score.png", options = {text="", w = 14, h = 35, startChar = "-"}, ppy = 0.34, ppx = 0.5, ap = {0.5, 0.5}},
            }},
            {type = TYPES.SPRITE, var = "spriteZhuanQuan_", filename = "res/images/common/head_zq.png"},
            {type = TYPES.CUSTOM, var = "voiceQiPao_", class = "app.views.game.VoiceQiPao", x = QI_PAO_X, y = QI_PAO_Y, visible = false},
        }},
        {type = TYPES.NODE, var = "nodeFlags_", children = {
            {type = TYPES.SPRITE, var = "spriteRankGuang_", filename = "res/images/game/yxz_syfg.png", x = RANK_X, y = RANK_Y, scale = 0.6, visible = false},
            {type = TYPES.SPRITE, var = "spriteRank_", x = RANK_X, y = RANK_Y, visible = false},
        }},
        {type = TYPES.SPRITE, var = "spriteReady_", filename = "res/images/game/ready_sign.png", visible = false},
        {type = TYPES.SPRITE, var = "nodeChuPai_"},  -- 出牌容器
        {type = TYPES.SPRITE, var = "nodePingJu_"},  -- 出牌容器
        {type = TYPES.NODE, var = "nodeChat_"},  -- 聊天容器
        {type = TYPES.NODE, var = "nodeAnimations_"},  -- 动画容器\
    }
}

function DtzPlayerView:ctor(index)
    DtzPlayerView.super.ctor(self, index)
end

function DtzPlayerView:initNodes_()
    gailun.uihelper.render(self, nodeData)
end

function DtzPlayerView:hideAllFlags_()
    self:hideOtherFlags_()
end

function DtzPlayerView:initPosByIndex_()
    local zhuangX = DEALER_X
    local offlineX = OFFLINE_SIGN_X
    local touXiangX = TOU_XIANG_X
    local rankX = RANK_X
    local kingX = KING_X
    local qiPaoX = QI_PAO_X
    local warningX = WARNING_X
    local pokerBackX = POKER_BACK_X
    local playerFlagX = PLAY_FLAG_X
    local winFlag = WIN_FLAG_X
    if self.index_ == DTZ_TABLE_DIRECTION.RIGHT or  self.index_ == DTZ_TABLE_DIRECTION.UP then
        zhuangX = - DEALER_X
        offlineX = - OFFLINE_SIGN_X
        touXiangX = - TOU_XIANG_X
        rankX = - RANK_X
        kingX = - KING_X
        qiPaoX = - QI_PAO_X
        self.voiceQiPao_:setFlipX(true)
        warningX = - WARNING_X
        pokerBackX = -POKER_BACK_X
        playerFlagX =  -PLAY_FLAG_X
        winFlag = -WIN_FLAG_X
    elseif self.index_ == DTZ_TABLE_DIRECTION.LEFT or  self.index_ == DTZ_TABLE_DIRECTION.BOTTOM then
        rankX = RANK_X + 30
    end
    self.spriteRank_:setPositionX(rankX)
    self.spriteRankGuang_:setPositionX(rankX)
    self.spriteOffline_:setPositionX(offlineX)
    self.voiceQiPao_:setPositionX(qiPaoX)
    self.spriteWarning_:setPositionX(warningX)
    self.spriteWarning2_:setPositionX(warningX)
    self.winFlag_:setPositionX(winFlag)
    self.shengliguang_:setPositionX(winFlag)
end

return DtzPlayerView

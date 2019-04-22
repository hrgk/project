local PlayerView = import("app.games.yzchz.views.game.PlayerView")
local ReVeiwPlayerView = class("ReVeiwPlayerView", PlayerView)

local BaseAlgorithm = require("app.games.yzchz.utils.BaseAlgorithm")

local DEALER_X, DEALER_Y = -40, 34
local OFFLINE_SIGN_X, OFFLINE_SIGN_Y = -38, -28
local PLAY_FLAG_X, PLAY_FLAG_Y = -42, -95

local QI_PAO_X, QI_PAO_Y = 150, 40

local PLAYER_INFO_POS = {
    {400, 150},
    {900, 500},
    {400, 500},
}
local TYPES = gailun.TYPES
local GRAY_FILTERS  = {"GRAY",{0.2, 0.3, 0.5, 0.1}}

local nodeData = {
    type = TYPES.ROOT,
    children = {
        {type = TYPES.NODE, var = "nodePlayer_", children = {  -- 玩家基本数据的对象
            {type = TYPES.SPRITE, var = "headBg_", filename = "res/images/game/headBg.png", x = 0, y = 0},
            {type = TYPES.CUSTOM, var = "avatar_", class = "app.views.AvatarView",y = 30},
            {type = TYPES.SPRITE, var = "spriteOffline_", filename = "res/images/game/off_line_sign.png", x = OFFLINE_SIGN_X, y = OFFLINE_SIGN_Y},
            {type = TYPES.LABEL, var = "labelNickName_", options = {text="fdsafdsafdsa", size=20, font = DEFAULT_FONT, align=cc.TEXT_ALIGNMENT_CENTER, color=cc.c3b(255, 255, 255)}, y = -30, x = 0, ap = {0.5, 0.5}},
            -- {type = TYPES.SPRITE, var = "spriteChipsBg_", y = -54, scale9 = true, size = {116, 30}, children = {
            {type = TYPES.LABEL_ATLAS, var = "labelScore_", filename = "fonts/game_score.png", options = {text="", w = 14, h = 35, startChar = "-"}, y = - 65, x = 30, ap = {0.5, 0.5}},
            -- }},
            {type = TYPES.LABEL, options = {text="得分:", size=20, font = DEFAULT_FONT, align=cc.TEXT_ALIGNMENT_CENTER, color=cc.c3b(255, 255, 255)}, y = -60, x = 0, ap = {1, 0.5}},
            -- {type = TYPES.LABEL, options = {text="本局:", size=20, font = DEFAULT_FONT, align=cc.TEXT_ALIGNMENT_CENTER, color=cc.c3b(255, 255, 255)}, y = -60, x = 0, ap = {0.5, 0.5}},

            {type = TYPES.SPRITE, var = "spriteZhuanquan_", filename = "res/images/common/head_zq.png"},
            {type = TYPES.CUSTOM, var = "voiceQiPao_", class = "app.views.game.VoiceQiPao", x = QI_PAO_X, y = QI_PAO_Y, visible = false},
        }},
        {type = TYPES.NODE, var = "nodeFlags_", children = {
            {type = TYPES.SPRITE, var = "spriteZhuang_", visible = false, filename = "res/images/game/flag_zhuang.png", x = DEALER_X, y = DEALER_Y,},
        }},
        {type = TYPES.SPRITE, var = "spriteReady_", filename = "res/images/game/readyFlag.png", visible = false},
        {type = TYPES.SPRITE, var = "nodeChuPai_"},  -- 出牌容器
        {type = TYPES.SPRITE, var = "nodeZhuomianPai_"},  -- 出牌容器
        {type = TYPES.SPRITE, var = "nodeAni_"},  -- 出牌容器
        {type = TYPES.SPRITE, var = "nodehuxi",children = { 
            {type = TYPES.NODE, var = "huxiBg_", filename = "res/images/game/tablehuxibg.png", scale9 = true, size = {190, 50}, children = {
                {type = TYPES.LABEL, var = "labelzhuomianhuxi_", options = {text="息", size=30, font = DEFAULT_FONT, color=cc.c4b(255, 255, 255, 128) },ap = {0.5, 0.5}, ppx = 0.6, ppy = 0.3},
                -- {type = TYPES.LABEL, var = "labelHuxi_", filename = "fonts/胡息数字.png",options = {text="", w = 14, h = 35, startChar = "-"}, ap = {0.5, 0.5}, ppy = 0.5, ppx = 0.5, },
                {type = TYPES.LABEL_ATLAS, var = "labelHuxi_", filename = "fonts/huxinum.png", options = {text="", w = 21, h = 28, startChar = "0"}, ppy = 0.25, ppx = 0.5, ap = {1, 0.5}},
            }},  
        }},  -- 吃碰容器
        {type = TYPES.NODE, var = "nodeChat_"},  -- 聊天容器
        {type = TYPES.NODE, var = "nodeAnims_"},  -- 动画容器
        {type = TYPES.NODE, var = "nodeShowPai_"}, -- 结束展示牌
    }
}

local NumberRoller = gailun.NumberRoller.new()
NumberRoller:setFormatHandler(tostring)
local PlayerView = class("PlayerView", gailun.BaseView)

local HOST_OFFSET_X, HOST_SPACE_X = 100, 12  -- 主玩家发牌终点偏移量、两张手牌的间距
local PLAYER_OFFSET_X, PLAYER_OFFSET_Y, PLAYER_SPACE_X = 34, -18, 3  -- 其它玩家发牌终点X与Y，两张手牌的间距
local CARD_DELAY_SECONDS = 0.1  -- 发牌移动动作与旋转动作之间的时间间隔
local MO_PAI_MARGIN_BOTTOM, MO_PAI_MARGIN_OTHER = 40, 18
local MA_JIANG_BOTTOM_SCALE = 1  -- 底部的牌的缩放

local player_pos = {
    {70 / DESIGN_WIDTH, 0.355},
    {1212 / DESIGN_WIDTH, 0.865},
    {70 / DESIGN_WIDTH, 0.865},
}
local ready_pos = {
    {200, 200},
    {1050, 600},
    {200, 600},
}
local OFFSET_OF_SEATS_4 = {}
for i,v in ipairs(player_pos) do
    OFFSET_OF_SEATS_4[i] = {display.width * v[1], display.height * v[2]}
end

local MA_JIANG_SHU_WIDTH = {82, 27, 39, 27}  -- 竖着的麻将的宽度
local MA_JIANG_DAO_WIDTH = {54, 27, 35, 27}  -- 倒着的麻将的宽度
local BOTTOM_CHU_PAI_SCALE = 36 / 55
local ROUND_OVER_CHAGNE_LINE_COUNT = 9
local ROUND_OVER_PAI_HEIGTH_DIST = 40
local RIGHT_POS_ZINDEX = 100
local CHU_PAI_SCALE = 0.6
local CHU_PAI_LINE_LENGTH = 9

PlayerView.SIT_DOWN_CLICKED = "SIT_DOWN_CLICKED"
PlayerView.ON_AVATAR_CLICKED = "ON_AVATAR_CLICKED"

function ReVeiwPlayerView:ctor(index, paperCardList)
    assert(index > 0 and index < 4, "bad player index of " .. checkint(index))
    self.index_ = index
    gailun.uihelper.render(self, nodeData)
    self.nodePlayer_:pos(unpack(OFFSET_OF_SEATS_4[index]))

    self:setCascadeOpacityEnabled(true)
    self.nodePlayer_:setCascadeOpacityEnabled(true)
    
    cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()

    self.bottomShowFlagList_ = {}
    self.bottomFlags_ = {}
    -- self:hideAllBottomFlags_()
    self.threwCards = {}
    -- self:hideOtherFlags_()

    self.spriteZhuanquan_:hide()
    self:zhuanQuanAction(self.spriteZhuanquan_, 0.5)
    -- self:rankAnim_(self.spriteRankGuang_, 1)
    gailun.uihelper.setTouchHandler(self.nodePlayer_, handler(self, self.onAvatarClicked_))
    self.paperCardList_ = paperCardList
    self.paperCardList_:setTouchEnabled(false)
    self.paperCardList_:setInReView(true)
    self:resetPos()
end

function ReVeiwPlayerView:onHandCardsChanged_(event)
    self.paperCardList_:removeAllPokers()
    self.paperCardList_:showPokers(event.cards)
end
function ReVeiwPlayerView:initPosByIndex_()
    ReVeiwPlayerView.super.initPosByIndex_(self)
    self:updatePaperCardListPos_()
end

function ReVeiwPlayerView:updatePaperCardListPos_()
    if self.index_ == TABLE_YZCHZ_DIRECTION.LEFT then
    	self.paperCardList_:scale(0.5)
        self.paperCardList_:setPosition(-60, 330)
    elseif self.index_ == TABLE_YZCHZ_DIRECTION.RIGHT then
    	self.paperCardList_:scale(0.5)
    	self.paperCardList_:setPosition(700, 330)
    end 
end

return ReVeiwPlayerView 

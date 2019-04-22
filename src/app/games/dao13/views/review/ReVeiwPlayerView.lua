local PlayerView = import("app.games.dao13.views.game.PlayerView")
local ReVeiwPlayerView = class("ReVeiwPlayerView", PlayerView)
local PokerListView = import("app.games.dao13.views.game.PokerListView")
local BaseAlgorithm = require("app.games.dao13.utils.BaseAlgorithm")

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
    {400, 200},
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
        {type = TYPES.NODE, var = "nodePoker_"},  -- 动画容器\
        {type = TYPES.SPRITE, var = "nodePingJu_"},  -- 出牌容器
        {type = TYPES.SPRITE, var = "nodeChuPai_"},  -- 出牌容器
        {type = TYPES.NODE, var = "nodeChat_"},  -- 聊天容器
        {type = TYPES.NODE, var = "nodeAnimations_"},  -- 动画容器\
    
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
    {1212 / DESIGN_WIDTH, 0.65},
    {70 / DESIGN_WIDTH, 0.65},
}
local ready_pos = {
    {200, 300},
    {1060, 500},
    {200, 500},
}
local OFFSET_OF_SEATS_4 = {}
for i,v in ipairs(player_pos) do
    OFFSET_OF_SEATS_4[i] = {display.width * v[1], display.height * v[2]}
end

local MA_JIANG_SHU_WIDTH = {82, 27, 39, 27}  -- 竖着的麻将的宽度
local MA_JIANG_DAO_WIDTH = {54, 27, 35, 27}  -- 倒着的麻将的宽度
local BOTTOM_CHU_PAI_SCALE = 36 / 55
local FENPAI_LINE_COUNT = 6
local ROUND_OVER_CHAGNE_LINE_COUNT = 9
local FENPAI_HEIGTH_DIST = 50
local ROUND_OVER_PAI_HEIGTH_DIST = 40
local RIGHT_POS_ZINDEX = 100
local CHU_PAI_SCALE = 0.6
local CHU_PAI_LINE_LENGTH = 9

PlayerView.SIT_DOWN_CLICKED = "SIT_DOWN_CLICKED"
PlayerView.ON_AVATAR_CLICKED = "ON_AVATAR_CLICKED"

function ReVeiwPlayerView:ctor(index)
    assert(index > 0 and index < 5, "bad player index of " .. checkint(index))
    display.addSpriteFrames("textures/pokers.plist", "textures/pokers.png")
    self.index_ = index
    self.table_ = dataCenter:getPokerTable()
    gailun.uihelper.render(self, nodeData)
    self.nodePlayer_:pos(unpack(OFFSET_OF_SEATS_4[index]))

    self:setCascadeOpacityEnabled(true)
    self.nodePlayer_:setCascadeOpacityEnabled(true)
    
    cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()
    self:hideOtherFlags_()

    self.spriteZhuanQuan_:setScale(2)
    self.spriteZhuanQuan_:hide()
    self:zhuanQuanAction(self.spriteZhuanQuan_, 0.5)
    self:rankAnimations_(self.spriteRankGuang_, 1)
    self:initWarningAnimations_()
    gailun.uihelper.setTouchHandler(self.nodePlayer_, handler(self, self.onAvatarClicked_))
    self.isFaPai_ = false
end

function ReVeiwPlayerView:initPokerList(gameModel)
    if self.pokerList_ then return end
    self.pokerList_ = PokerListView.new()
    self.nodePoker_:addChild(self.pokerList_)
    self.pokerList_:setTouchEnabled(false)
    self.pokerList_:setInReView(true)
    self:updatePokerListPos_()
end

function ReVeiwPlayerView:onShowHunCardInReView_(event)
    if self.pokerList_ == nil then return end
   self.pokerList_:showHuCard()
end

function ReVeiwPlayerView:onChuPaiChanged_(event)
    self.nodeChuPai_:removeAllChildren()
    if not event.cards or 0 == #event.cards then
        printInfo("PlayerView:onChuPaiChanged_(event) with no cards")
        return
    end
    self:performWithDelay(function()
        self.pokerList_:removePokers(event.cards)
            self:doChuPaiAnim_(event.cards, event.isReConnect, event.inFastMode)
        end, 0.05)
end

function PlayerView:doChuPaiAnim_(cards, isReConnect, inFastMode)
    local seconds = 0.3
    for i, card in ipairs(cards) do
        local x, y, showIndex, scale = self:calcChuPaiPos_(#cards, i)
        local poker = app:createView("PokerView", card):addTo(self.nodeChuPai_, showIndex)
        poker:fanPai()
        local point = poker:getParent():convertToWorldSpace(cc.p(x, y))
        self:playChuPaiAnim_(poker, x, y, 0, true, true)
        gameAudio.playSound("sounds/common/pay_card.mp3")
    end
end

function ReVeiwPlayerView:onHandCardsChanged_(event)
    if self.pokerList_ == nil then return end
    self.pokerList_:removeAllPokers()
    if event.cards then
        self.pokerList_:showPokers(event.cards)
    end
end
function ReVeiwPlayerView:initPosByIndex_()
    ReVeiwPlayerView.super.initPosByIndex_(self)
end

function ReVeiwPlayerView:updatePokerListPos_()
    if self.index_ == TABLE_DIRECTION.LEFT then
        self.pokerList_:scale(0.5)
        self.pokerList_:setPosition(60, 400)
    elseif self.index_ == TABLE_DIRECTION.RIGHT then
        self.pokerList_:scale(0.5)
        self.pokerList_:setPosition(600, 400)
    end 
end

return ReVeiwPlayerView 

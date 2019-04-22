local BaseAlgorithm = require("app.games.shuangKou.utils.BaseAlgorithm")
local ShuangKouAlgorithm = require("app.games.shuangKou.utils.ShuangKouAlgorithm")
local ShuangKouCardType = require("app.games.shuangKou.utils.ShuangKouCardType")
local FaceAnimationsData = require("app.data.FaceAnimationsData")
-- local RemindView = import("app.games.tianzha.views.game.RemindView")
local SmallPokerView = import("app.views.game.SmallPokerView")
local PokerView = import("app.views.game.PokerView")

local DEALER_X, DEALER_Y = -40, 34
local OFFLINE_SIGN_X, OFFLINE_SIGN_Y = -38, -28
local PLAY_FLAG_X, PLAY_FLAG_Y = 40, 34
local WIN_FLAG_X, WIN_FLAG_Y = 300, 0
local HEI_TAO_X, HEI_TAO_Y = 95, -20
local TOU_XIANG_X = 70
local RANK_X, RANK_Y = 100, 40
local QI_PAO_X, QI_PAO_Y = 150, 40
local NIU_JIAO_X, NIU_JIAO_Y = 0,45
local WARNING_X = 80
local KING_X = 40
local ZHA_DAN_DE_FEN_Y = 100
local POKER_BACK_X = 94

local PLAYER_INFO_POS = {
    {400, 180},
    {900, 400},
    {400, 400},
    {900, 180},
}

local FLAG_POS = {
    {display.width * 50 / DESIGN_WIDTH, 140/ DESIGN_HEIGHT * display.height},
    {display.width * 1200 / DESIGN_WIDTH, display.height * 410 / DESIGN_HEIGHT},
    {display.width * 50 / DESIGN_WIDTH, display.height * 410 / DESIGN_HEIGHT},
}

local ACTION_ANIM_POS = {
    {display.cx, 320 / DESIGN_HEIGHT * display.height},
    {display.width * 1050 / DESIGN_WIDTH, display.height * 400 / DESIGN_HEIGHT},
    {display.width * 240 / DESIGN_WIDTH, display.height * 400 / DESIGN_HEIGHT},
}

local TYPES = gailun.TYPES
local GRAY_FILTERS  = {"GRAY",{0.2, 0.3, 0.5, 0.1}}
local nodeData = {
    type = TYPES.ROOT,
    children = {
        {type = TYPES.NODE, var = "nodeShowPai_"}, -- 结束展示牌
        {type = TYPES.NODE, var = "nodePlayer_", children = {  -- 玩家基本数据的对象
            {type = TYPES.SPRITE, scale9 = true, capInsets = cc.rect(10, 10, 10, 10), var = "headBg_", filename = "res/images/game/headBg2.png", x = 0, y = 0},
            -- {type = TYPES.SPRITE, filename = "res/images/shuangKou/game/touxiangdi.png", y = -30},
            -- {type = TYPES.CUSTOM, var = "avatar_", class = "app.views.AvatarSquareView",options = {nil, "res/images/common/smallTouXiangKuang.png", maskPath, 0.5}, scale = 0.7},
            {type = TYPES.CUSTOM, var = "avatar_", class = "app.views.AvatarView", y = 15, scale = 0.8},
            {type = TYPES.SPRITE, var = "spriteWarning_", x = WARNING_X, y = 60},
            {type = TYPES.SPRITE, var = "spriteWarning2_", x = WARNING_X, y = 60},
            {type = TYPES.SPRITE, var = "winFlag_", x = WIN_FLAG_X, y =WIN_FLAG_Y, visible = false},
            -- {type = TYPES.SPRITE, var = "spriteChipsBg_", filename = "res/images/shuangKou/game/nichengtiao.png", y = -60},
            {type = TYPES.LABEL, var = "labelNickName_", options = {text="", size=20, font = DEFAULT_FONT, align=cc.TEXT_ALIGNMENT_CENTER, color=cc.c3b(255, 255, 255)}, y = 65, x = 0, ap = {0.5, 0.5}},
            -- {type = TYPES.SPRITE, var = "spriteChipsBg_", filename = "res/images/shuangKou/game/nichengtiao.png", y = -60, children = {
                -- {type = TYPES.SPRITE, filename = "res/images/shuangKou/game/score-bg1.png", x = 10, ppy = 0.5},
            -- {type = TYPES.LABEL, options = {text="贡献:", size=20, font = DEFAULT_FONT, align=cc.TEXT_ALIGNMENT_CENTER, color=cc.c3b(255, 255, 255)}, y = -60, x = 0, ap = {1, 0.5}},
            -- {type = TYPES.LABEL_ATLAS, var = "labelContributionScore_", filename = "res/images/shuangKou/fonts/game_score.png", options = {text="0", w = 14, h = 35, startChar = "-"}, y = -65, x = 20, ap = {0.5, 0.5}},

            {type = TYPES.LABEL, options = {text="得分:", size=20, font = DEFAULT_FONT, align=cc.TEXT_ALIGNMENT_CENTER, color=cc.c3b(255, 255, 255)}, y = -30, x = 0, ap = {1, 0.5}},
            {type = TYPES.LABEL_ATLAS, var = "labelScore_", filename = "res/images/shuangKou/fonts/game_score.png", options = {text="0", w = 14, h = 35, startChar = "-"}, y = -35, x = 20, ap = {0.5, 0.5}},

            -- {type = TYPES.SPRITE, visible = false, var = "spriteFan_",y = -60, filename = "res/images/shuangKou/game/1fan.png"},

            {type = TYPES.BM_FONT_LABEL, var = "labelSpeakScore_", options={text="", UILabelType = 1,font = "res/images/shuangKou/fonts/xs.fnt",}, scale = 1.4 , ap = {0.5, 0.5}, y = 120},

            -- }},

            -- {type = TYPES.PROGRESS_TIMER, reverse = true, progressType = display.PROGRESS_TIMER_RADIAL, var = "spriteZhuanQuan_", percent = 100, bar = "res/images/shuangKou/game/daojishi.png", y = -30},
            {type = TYPES.SPRITE, var = "spriteZhuanQuan_",y = 15},
            {type = TYPES.SPRITE, var = "spriteOffline_", filename = "res/images/shuangKou/game/off_line_sign.png", x = OFFLINE_SIGN_X, y = OFFLINE_SIGN_Y},
            {type = TYPES.SPRITE, visible = false, var = "cardBack_", filename = "res/images/shuangKou/game/shoupai.png", y = 0, x = 80},
            {type = TYPES.LABEL, options = {text="余牌:", size=20, font = DEFAULT_FONT, align=cc.TEXT_ALIGNMENT_CENTER, color=cc.c3b(255, 255, 255)}, y = -60, x = 0, ap = {1, 0.5}},
            -- {type = TYPES.LABEL, var = "cardNumber_", x = 20, y=-60, options = {text="", size=24, font = DEFAULT_FONT, align=cc.TEXT_ALIGNMENT_CENTER, color=cc.c3b(255, 216, 0)}, ap = {0, 0.5}},
            {type = TYPES.LABEL_ATLAS, var = "cardNumber_", filename = "res/images/shuangKou/fonts/game_score.png", options = {text="0", w = 14, h = 35, startChar = "-"}, y = -65, x = 20, ap = {0.5, 0.5}},
            {type = TYPES.LABEL_ATLAS, var = "zhadanAddNum_", filename = "res/images/shuangKou/fonts/zhadan_num_add.png", x = 0, y = ZHA_DAN_DE_FEN_Y, options = {text="", w = 19.2, h = 34, startChar = "+"}, ap = {0.5, 0.5}},
            {type = TYPES.LABEL_ATLAS, var = "zhadanDelNum_", filename = "res/images/shuangKou/fonts/zhadan_num_del.png", x = 0, y = ZHA_DAN_DE_FEN_Y, options = {text="", w = 19.2, h = 34, startChar = "+"}, ap = {0.5, 0.5}},
            {type = TYPES.CUSTOM, var = "voiceQiPao_", class = "app.views.game.VoiceQiPao", x = QI_PAO_X, y = QI_PAO_Y, visible = false},
        }},
        {type = TYPES.NODE, var = "nodeFlags_", children = {
            {type = TYPES.SPRITE, var = "spriteRankGuang_", filename = "res/images/shuangKou/game/yxz_syfg.png", x = RANK_X, y = RANK_Y, scale = 0.6, visible = false},
            {type = TYPES.SPRITE, var = "spriteRank_", x = RANK_X, y = RANK_Y, visible = false},
        }},
        {type = TYPES.SPRITE, var = "spriteReady_", filename = "res/images/shuangKou/game/ready_sign.png", visible = false},
        {type = TYPES.SPRITE, var = "nodeChuPai_"},  -- 出牌容器
        {type = TYPES.SPRITE, var = "nodePingJu_"},  -- 出牌容器
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

local player_pos_three = {--玩家位置
    {70 / DESIGN_WIDTH, 0.20},
    {1210 / DESIGN_WIDTH, 0.65},
    {65 / DESIGN_WIDTH, 0.65},
}

local playerPosFour = {--玩家位置
    {65 / DESIGN_WIDTH, 0.38},
    {1210 / DESIGN_WIDTH, 0.65},
    {800 / DESIGN_WIDTH, 0.88},
    {65 / DESIGN_WIDTH, 0.68},
}

local player_scale = {
    1,
    0.9,
    0.9,
    0.9,
}

local ready_pos = {
    {200, 250},
    {display.right - 200, 540},
    {display.right - 200, 540},
    {200, 540},
}
local OFFSET_OF_SEATS_4 = {}

local MA_JIANG_SHU_WIDTH = {82, 27, 39, 27}  -- 竖着的麻将的宽度
local MA_JIANG_DAO_WIDTH = {54, 27, 35, 27}  -- 倒着的麻将的宽度
local BOTTOM_CHU_PAI_SCALE = 36 / 55
local FENPAI_LINE_COUNT = 6
local ROUND_OVER_CHAGNE_LINE_COUNT = 13
local FENPAI_HEIGTH_DIST = 50
local ROUND_OVER_PAI_HEIGTH_DIST = 40
local RIGHT_POS_ZINDEX = 100
local CHU_PAI_SCALE = 0.6
local CHU_PAI_LINE_LENGTH = 8
local ROUND_OVER_PAI_LINE_LENGTH = 14

PlayerView.SIT_DOWN_CLICKED = "SIT_DOWN_CLICKED"
PlayerView.ON_AVATAR_CLICKED = "ON_AVATAR_CLICKED"

function PlayerView:ctor(index)
    assert(index > 0 and index < 5, "bad player index of " .. checkint(index))
    self:initNodes_()
    self.index_ = index
    -- self.table_ = display:getRunningScene():getTable()
    self.score_ = 0
    self:setCascadeOpacityEnabled(true)
    self.nodePlayer_:setCascadeOpacityEnabled(true)
    cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()
    -- self.zhadanAddNum_:setString("+100")
    -- self.zhadanDelNum_:setString("-100")
    self.cardBack_:hide()
    self.cardNumber_:setString("")
    self:hideOtherFlags_()
    self.spriteZhuanQuan_:setScale(0.8)
    self.spriteZhuanQuan_:hide()
    -- self.spriteZhuanQuan_:setPercentage(100)

    gailun.uihelper.setTouchHandler(self.nodePlayer_, handler(self, self.onAvatarClicked_))

    self:zhuanQuanAction(self.spriteZhuanQuan_, 0.5)
    self:rankAnimations_(self.spriteRankGuang_, 1)
    self:initWarningAnimations_()
end

function PlayerView:onEnterTransitionFinish()
    self:dealData()
end

function PlayerView:dealData()
    if #OFFSET_OF_SEATS_4 ~= 0 then
        return
    end
    OFFSET_OF_SEATS_4 = {}

    local table = display:getRunningScene():getTable()

    if table == nil then
        return
    end

    if table:getMaxPlayer() == 3 then
        for i,v in ipairs(player_pos_three) do
            OFFSET_OF_SEATS_4[i] = {display.width * v[1], display.height * v[2]}--头像区域水平默认20
        end
        ACTION_ANIM_POS = {
            {display.cx, 320 / DESIGN_HEIGHT * display.height},
            {display.width * 1050 / DESIGN_WIDTH, display.height * 500 / DESIGN_HEIGHT},
            {display.width * 240 / DESIGN_WIDTH, display.height * 500 / DESIGN_HEIGHT},
        }
        FLAG_POS = {
            {display.width * 50 / DESIGN_WIDTH, 140/ DESIGN_HEIGHT * display.height},
            {display.width * 1200 / DESIGN_WIDTH, display.height * 510 / DESIGN_HEIGHT},
            {display.width * 50 / DESIGN_WIDTH, display.height * 510 / DESIGN_HEIGHT},
        }
        ready_pos = {
            {200, 250},
            {display.right - 200, 540},
            {200, 540},
        }
    elseif table:getMaxPlayer() == 4 then
        for i,v in ipairs(playerPosFour) do
            OFFSET_OF_SEATS_4[i] = {display.width * v[1], display.height * v[2]}--头像区域水平默认20
        end

        ACTION_ANIM_POS = {
            {display.cx, 320 / DESIGN_HEIGHT * display.height},
            {display.width * 1050 / DESIGN_WIDTH, display.height * 500 / DESIGN_HEIGHT},
            {display.width * 700 / DESIGN_WIDTH, display.height * 550 / DESIGN_HEIGHT},
            {display.width * 240 / DESIGN_WIDTH, display.height * 500 / DESIGN_HEIGHT},
        }
        FLAG_POS = {
            {display.width * 50 / DESIGN_WIDTH, 140/ DESIGN_HEIGHT * display.height},
            {display.width * 1200 / DESIGN_WIDTH, display.height * 310 / DESIGN_HEIGHT},
            {display.width * 700 / DESIGN_WIDTH, display.height * 310 / DESIGN_HEIGHT},
            {display.width * 50 / DESIGN_WIDTH, display.height * 510 / DESIGN_HEIGHT},
        }
        ready_pos = {
            {200, 250},
            {display.right - 200, 440},
            {display.cx - 10, 540},
            {200, 440},
        }
    end

    local index = self.index_

    self.nodePlayer_:pos(unpack(OFFSET_OF_SEATS_4[index]))
    self.nodePlayer_:setScale(player_scale[index])
end

function PlayerView:initNodes_()
    gailun.uihelper.render(self, nodeData)
    -- self.avatar_ = require("app.views.AvatarSquareView").new(nil, nil, nil, 0.5,false):addTo(self.nodePlayer_)
    -- self.avatar_:setScale(0.7)
end

function PlayerView:setPokerListView(pokerList)
    if self.pokerList_ then
        if not tolua.isnull(self.pokerList_) then
            self.pokerList_:removeSelf()
        end
        self.pokerList_ = nil
    end
    self.pokerList_ = pokerList
end

function PlayerView:onAvatarClicked_(event)
    if not self.player_ then
        return
    end
    dump(event, "onAvatarClicked_")
    local info = self.player_:getShowParams()
    info.x = PLAYER_INFO_POS[self.index_][1]
    info.y = PLAYER_INFO_POS[self.index_][2]
    info.seatID = self.player_:getSeatID()
    self:dispatchEvent({name = PlayerView.ON_AVATAR_CLICKED, params = info})
end

function PlayerView:initReadyPos_()
    local x, y = unpack(ready_pos[self.index_])
    self.spriteReady_:pos(x, y)
end

function PlayerView:initPosByIndex_()
    local zhuangX = DEALER_X
    local offlineX = OFFLINE_SIGN_X
    local touXiangX = TOU_XIANG_X
    local rankX = RANK_X
    local rankY = RANK_Y
    local kingX = KING_X
    local qiPaoX = QI_PAO_X
    local warningX = WARNING_X
    local pokerBackX = POKER_BACK_X
    local playerFlagX = PLAY_FLAG_X
    local winFlag = WIN_FLAG_X
    local heiTaoDi = HEI_TAO_X
    local table = display:getRunningScene():getController():getTable()
    print("PlayerView:initPosByIndex_",self.index_)
    if self.index_ == SK_TABLE_DIRECTION.TOP then
        self.voiceQiPao_:setFlipX(true)
        rankX = -RANK_X-200
        rankY = rankY + 100
    elseif self.index_ == SK_TABLE_DIRECTION.RIGHT then
        self.voiceQiPao_:setFlipX(true)
        heiTaoDi = - HEI_TAO_X
        zhuangX = - DEALER_X
        offlineX = - OFFLINE_SIGN_X
        touXiangX = - TOU_XIANG_X
        rankX = -RANK_X 
        kingX = - KING_X
        qiPaoX = - QI_PAO_X
        warningX = - WARNING_X
        pokerBackX = -POKER_BACK_X
        playerFlagX =  -PLAY_FLAG_X
        winFlag = -WIN_FLAG_X
    elseif self.index_ == SK_TABLE_DIRECTION.LEFT or  self.index_ == SK_TABLE_DIRECTION.BOTTOM then
        self.voiceQiPao_:setFlipX(false)
        rankX = RANK_X + 30
    end
    if self.index_ == SK_TABLE_DIRECTION.BOTTOM then
        warningX = 0
        self.spriteWarning2_:setPositionY(140)
        self.spriteWarning_:setPositionY(140)
    else
        self.spriteWarning2_:setPositionY(60)
        self.spriteWarning_:setPositionY(60)
    end
    self.spriteRank_:setPosition(rankX,rankY)
    self.spriteRankGuang_:setPosition(rankX,rankY)
    self.spriteOffline_:setPositionX(offlineX)
    self.voiceQiPao_:setPositionX(qiPaoX)
    self.spriteWarning_:setPositionX(warningX)
    self.spriteWarning2_:setPositionX(warningX)
    self.winFlag_:setPositionX(winFlag)
    self.nodeFlags_:setPosition(unpack(FLAG_POS[self.index_]))
end

function PlayerView:hideOtherFlags_()
    self.spriteReady_:hide()
    self.spriteRank_:hide()
    self.spriteRankGuang_:hide()
    transition.pauseTarget(self.spriteRankGuang_)
end

function PlayerView:hideAllFlags_()
    self:hideOtherFlags_()
end

function PlayerView:onEnter()
    self:onStateIdle_()
    self.labelNickName_:enableShadow(cc.c4b(0, 0, 0, 128), cc.size(2, -3), 1)
    self.spriteOffline_:hide()
end

function PlayerView:onExit()
    gailun.EventUtils.clear(self)
end

function PlayerView:onSitDownClicked_(event)
    self:dispatchEvent({name = PlayerView.SIT_DOWN_CLICKED})
end

function PlayerView:onCurrentPow_(event)
    -- self.spriteFan_:hide()
    if #event.callBombCount ~= 0 then
        self.labelSpeakScore_:setColor(cc.c3b(0xff, 0xff, 0xff))
        return
    end

    self.labelSpeakScore_:setColor(cc.c3b(239, 4, 239))

    if event.pow == 1 then
        self.labelSpeakScore_:setString("f")
    elseif event.pow == 2 then
        self.labelSpeakScore_:setString("g")
    elseif event.pow == 3 then
        self.labelSpeakScore_:setString("h")
    elseif event.pow >= 4 then
        self.labelSpeakScore_:setString("i")
    end

    -- if event.pow == 0 then
    --     self.spriteFan_:hide()
    --     return
    -- end

    -- self.spriteFan_:show()
    -- self.spriteFan_:setTexture("res/images/shuangKou/game/".. event.pow .. "fan.png")
end

function PlayerView:onSitDownEvent_(event)
    -- self.spriteFan_:hide()
    self:initPosByIndex_()
    self:initReadyPos_()

    self:dealData()

    print("----------------PlayerView:onSitDownEvent_--------------------")
    gameAudio.playSound("sounds/common/sound_enter.mp3")
    self.avatar_:showWithUrl(self.player_:getAvatarName())
    self:setNickName(self.player_:getNickName())
    print (self.player_:getNickName())
    -- self:setScoreWithRoller_(self.player_:getScore())
end

function PlayerView:bindPlayer(player)
    printInfo("PlayerView:bindPlayer(player)")
    assert(player)
    self.player_ = player
    gailun.EventUtils.clear(self)
    local cls = player.class
    local events = {
        {cls.CURRENT_POW, handler(self, self.onCurrentPow_)},
        {cls.SIT_DOWN_EVENT, handler(self, self.onSitDownEvent_)},
        {cls.CHANGE_STATE_EVENT, handler(self, self.onStateChanged_)},
        {cls.POKER_FOUND, handler(self, self.onPokerFound_)},
        {cls.HAND_CARDS_CHANGED, handler(self, self.onHandCardsChanged_)},
        {cls.LEFT_CARDS_CHANGED, handler(self, self.onLeftCardsChanged_)},
        {cls.HAND_CARD_SORT, handler(self, self.onHandCardsSort_)},
        {cls.INDEX_CHANGED, handler(self, self.onIndexChanged_)},
        {cls.ON_SHOWHEISAN_EVENT, handler(self, self.onShowHeiSanEvent_)},
        {cls.CHU_PAI_CHANGED, handler(self, self.onChuPaiChanged_)},
        {cls.ON_TIPS_EVENT, handler(self, self.onTipsEvent_)},
        {cls.ON_PASS_EVENT, handler(self, self.onSendPassEvent_)},
        -- {cls.SCORE_CHANGED, handler(self, self.onScoreChanged_)},
        {cls.ROUND_SCORE_CHANGED, handler(self, self.onScoreChanged_)},
        {cls.ROUND_GONG_XIAN_CHANGED, handler(self, self.onGXScoreChanged_)},
        {cls.ON_RANK_EVENT, handler(self, self.onShowRankEvent)},
        {cls.STAND_UP_EVENT, handler(self, self.onStandUp_)},
        {cls.ON_SETDEAR_EVENT, handler(self, self.onDealerEvent_)},
        {cls.PASS, handler(self, self.onPassEvent_)},
        {cls.WARNING, handler(self, self.onWarningEvent_)},
        {cls.ON_FLOW_EVENT, handler(self, self.onFlowEvent_)},  --ON_SHOWHEISAN_EVENT
        {cls.ON_ROUND_OVER_SHOW_POKER, handler(self, self.onRoundOverShowPai_)},
        {cls.ON_ROUND_START, handler(self, self.onRoundStart_)},
        {cls.ON_ROUND_OVER, handler(self, self.onRoundOver_)},
        {cls.ON_STOP_RECORD_VOICE, handler(self, self.onStopRecordVoice_)},
        {cls.ON_PLAY_RECORD_VOICE, handler(self, self.onPlayerVoice_)},
        {cls.OFFLINE_EVENT, handler(self, self.onOfflineEvent_)},
        {cls.HIDE_ALL_FLAGS_EVENT, handler(self, self.onHideAllFlags_)},
        {cls.ZHA_DAN_DE_FEN, handler(self, self.onZhaDanDeFen_)},
        {cls.GUAN_LONG, handler(self, self.onGuanLong_)},
        {cls.SHOW_POKER_BACK, handler(self, self.onShowPokerBack_)},
        {cls.CURRENT_BOMB_COUNT, handler(self, self.onCurrentBombCount)},
        {cls.CALL_BOMB_COUNT, handler(self, self.onCallBombCount)},
    }

    gailun.EventUtils.create(self, self.player_, self, events)
end

function PlayerView:onCurrentBombCount(event)
    if event.callBombCount == nil then
        return
    end

    dump(event.bombCount, "onCurrentBombCount")
    dump(event.callBombCount, "onCurrentBombCount")

    local map = {
        [0] = "a",
        [1] = "b",
        [2] = "c",
        [3] = "d",
        [4] = "e",
        [5] = "f",
        [6] = "g",
        [7] = "h",
        [8] = "i",
        [9] = "j",
    }

    local result = {}
    for _, bomb in pairs(event.callBombCount) do
        if table.indexof(event.bombCount, bomb) then
            table.removebyvalue(event.bombCount, bomb, false)
            table.insert(result, string.lower(map[bomb] or map[0]))
        else
            table.insert(result, string.upper(map[bomb] or map[0]))
        end
    end

    self.labelSpeakScore_:setString(table.concat(result))

end

function PlayerView:onCallBombCount(event)
    if #event.callBombCount == 0 then
        return
    end
    table.sort(event.callBombCount)
    local path = "res/images/shuangKou/effect/" .. table.concat(event.callBombCount) .. ".png"
    -- if self.beforePath_ ~= path then
        self:showActionAnim_(path)
    --     self.beforePath_ = path
    -- end
end

function PlayerView:onGuanLong_(event)
    local faceData = FaceAnimationsData.getFaceAnimation(9)
    faceData.isHold = true
    local toX, toY = unpack(OFFSET_OF_SEATS_4[self.index_])
    faceData.x= toX
    faceData.y= toY
    gameAnim.createCocosAnimations(faceData, self.nodeAnimations_)
end


function PlayerView:onStandUp_()
    self.cardBack_:setVisible(false)
end

function PlayerView:onShowHeiSanEvent_(event)
    -- gameAudio.playShuangKouHumanSound("woyouhei3wochutou.mp3", self.player_:getSex())
    -- RemindView.new(SmallPokerView.new(403)):addTo(self.nodeFlags_)
end

function PlayerView:onZhaDanDeFen_(event)
    local function zhaDanNumAction(target)
        transition.fadeTo(target, {time = 1, opacity = 0, onComplete = function()
            target:hide()
            target:setPositionY(ZHA_DAN_DE_FEN_Y)
        end})
        transition.moveTo(target, {time = 1, y = ZHA_DAN_DE_FEN_Y + 50})
        transition.scaleTo(target, {time = 1, scale = 1.5})
    end
    if event.score > 0 then
        self.zhadanAddNum_:show()
        self.zhadanAddNum_:setOpacity(255)
        self.zhadanAddNum_:setString(event.score)
        self.zhadanDelNum_:hide()
        zhaDanNumAction(self.zhadanAddNum_)
    else
        self.zhadanDelNum_:show()
        self.zhadanAddNum_:hide()
        self.zhadanDelNum_:setOpacity(255)
        self.zhadanDelNum_:setString(event.score)
        zhaDanNumAction(self.zhadanDelNum_)
    end
end

function PlayerView:onShowWinFlag_(event)
    self.nodePingJu_:removeAllChildren()
    local flag
    if event.score > 0 then
        flag = display.newSprite("res/images/game/dasheng.png"):addTo(self.winFlag_)
        self.winFlag_:show()
    elseif event.score == 0 then
        self.winFlag_:hide()
        if self:isHost() then
            flag = display.newSprite("res/images/game/weisheng.png"):addTo(self.nodePingJu_)
            self.nodePingJu_:setPosition(display.cx, display.cy+100)
        end
    elseif event.score == -1 then
        self.winFlag_:hide()
    end
end

function PlayerView:onShowPokerBack_(event)
    -- self.cardBack_:setVisible(event.isShow)
    self.cardBack_:setVisible(false)
end

function PlayerView:onHideAllFlags_(event)
    self:hideAllFlags_()
end

function PlayerView:onPlayerVoice_(event)
    self.voiceQiPao_:playVoiceAnim(event.time)
end

function PlayerView:onStopRecordVoice_(event)
    self.voiceQiPao_:stopRecordVoice()
end

function PlayerView:showZhuang_(isDealer)

end

function PlayerView:onDealerEvent_(event)

end

function PlayerView:onFlowEvent_(event)
    self.spriteReady_:hide()
    if event.flag ~= nil and event.flag ~= -1 then
        self.spriteZhuanQuan_:show()
        transition.resumeTarget(self.spriteZhuanQuan_)
    else
        self.spriteZhuanQuan_:hide()
        transition.pauseTarget(self.spriteZhuanQuan_)
    end
end

function PlayerView:onTipsEvent_(event)
    self.pokerList_:tishi()
end

function PlayerView:onSendPassEvent_(event)
    self.pokerList_:clearDesk()
end

function PlayerView:onPassEvent_(event)
    if event.inFastMode then return end
    self:showActionAnim_("res/images/shuangKou/actions/yao_bu_qi.png")

    -- local animaData = FaceAnimationsData.getCocosAnimation(24)
    -- gameAnim.createCocosAnimations(animaData, self.animotionContent_)
    -- local yaoBuQiSprite = display.newSprite("res/images/shuangKou/actions/yao_bu_qi.png")
    --     :addTo(self.nodeAnimations_)
    --     :pos(unpack(OFFSET_OF_SEATS_4[self.index_]))

    local count = math.random(1,4)
    local sound = "buyao" .. count .. ".mp3"
    gameAudio.playShuangKouHumanSound(sound, self.player_:getSex())
    if self:isHost() then
        self.pokerList_:resetPopUpPokers()
        self.pokerList_:removeHuise()
    end
end

function PlayerView:initWarningAnimations_()

    local animaData = FaceAnimationsData.getCocosAnimation(40)
    gameAnim.createCocosAnimations(animaData, self.spriteWarning_)

    local animaData = FaceAnimationsData.getCocosAnimation(40)
    gameAnim.createCocosAnimations(animaData, self.spriteWarning2_)

    -- display.addSpriteFrames("res/images/tianzha/game_anims.plist", "res/images/tianzha/game_anims.png")
    -- local data = gameAnim.formatAnimData("anim_baodan", "anim_baodan%d.png", 1, 4, 0.5, true)
    -- data = gameAnim.appendAnimAttrs(data, nil, false, nil)
    -- gameAnim.play(self.spriteWarning_, data)
    -- local data = gameAnim.formatAnimData("anim_baoshuang", "anim_baoshuang%d.png", 1, 4, 0.5, true)
    -- data = gameAnim.appendAnimAttrs(data, nil, false, nil)
    -- gameAnim.play(self.spriteWarning2_, data)
    -- transition.pauseTarget(self.spriteWarning_)
    -- transition.pauseTarget(self.spriteWarning2_)
    self.spriteWarning_:hide()
    self.spriteWarning2_:hide()
end

function PlayerView:onWarningEvent_(event)
    local config = display:getRunningScene():getTable():getConfigData()
    if self.index_ == SK_TABLE_DIRECTION.BOTTOM or event.warningType == -2 then
        self.spriteWarning_:hide()
        self.spriteWarning2_:hide()
        return
    end
    if event.warningType == -1 then
        self.nodeAnimations_:removeAllChildren()
        return
    end
    if not self:isHost() then
        -- self.cardBack_:show()
        -- self.cardNumber_:setString(event.warningType)
    end
    if event.warningType == 1 then
        if not event.isReConnect then
            -- gameAudio.playShuangKouHumanSound("last.mp3", self.player_:getSex())
        end
        self.spriteWarning2_:hide()
        self.spriteWarning_:show()
        if event.inFastMode then return end
        -- self:showActionAnim_("res/images/tianzha/actions/bz_bao_dan.png")
    elseif event.warningType == 2 then
        self.spriteWarning_:hide()
        self.spriteWarning2_:show()
        if event.inFastMode then return end
        -- self:showActionAnim_("res/images/tianzha/actions/bz_bao_shuang.png")
    end
end

function PlayerView:onStandUp()
    gailun.EventUtils.clear(self)
    self.player_ = nil
    gameAudio.playSound("sounds/common/sound_left.mp3")
end

function PlayerView:onOfflineEvent_(event)
    self.spriteOffline_:setVisible(event.offline)
    if not event.offline and event.isChanged then
        local str = string.format("%s回来了。", self.player_:getNickName())
        app:showTips(str)
    end
end

function PlayerView:isHost()
    -- print("isHost", self.player_:getSeatID(), display:getRunningScene():getHostPlayer():getSeatID())
    return self.player_:getSeatID() == display:getRunningScene():getHostPlayer():getSeatID()
end

function PlayerView:isFriend()
    -- print("isFriend", self.player_:getSeatID(), display:getRunningScene():getFriendPlayer():getSeatID())
    return self.player_:getSeatID() == display:getRunningScene():getFriendPlayer():getSeatID()
end

function PlayerView:onScoreChanged_(event)
    self:setScoreWithRoller_(event.score, event.from)
end

function PlayerView:onGXScoreChanged_(event)
    print("PlayerView:onGXScoreChanged_",event.score)
    self:setContributionScore_(event.score)
end

function PlayerView:onShowRankEvent(event)
    dump(event.rank,"event.rank")
    if not event.rank or event.rank < 1 then
        self.spriteRank_:hide()
        self.spriteRankGuang_:hide()
        transition.pauseTarget(self.spriteRankGuang_)
        return
    end
    self:showRank_(event.rank)
end

function PlayerView:showRank_(rank)
    local spriteName = "res/images/shuangKou/game/flag_xia_you.png"
    if 1 == rank then
        spriteName = "res/images/shuangKou/game/flag_shang_you.png"
    elseif 2 == rank then
        spriteName = "res/images/shuangKou/game/flag_zhong_you.png"
    end
    self.spriteRank_:setTexture(spriteName)
    -- self.spriteRank_:setSpriteFrame(display.newSpriteFrame(spriteName))
    self.spriteRank_:show()
    self.spriteRankGuang_:show()
    transition.resumeTarget(self.spriteRankGuang_)
end

function PlayerView:calcWaiPaiPos_(index, offset)
    if SK_TABLE_DIRECTION.BOTTOM == self.index_ then
        return self:calcWaiPaiPosBottom_(index, offset)
    elseif SK_TABLE_DIRECTION.RIGHT == self.index_ then
        return self:calcWaiPaiPosRight_(index, offset)
    else
        return self:calcWaiPaiPosLeft_(index, offset)
    end
end

function PlayerView:calcWaiPaiOffsetWidth_(width, offset)
    if offset < 4 then
        return (offset - 1) * width
    end
    return width
end

function PlayerView:calcWaiPaiOffsetHeight_(height, offset)
    if offset < 4 then
        return 0
    end
    return height / 3.8
end

function PlayerView:calcWaiPaiPosBottom_(index, offset)
    local majiang_height = 84
    local majiang_width = MA_JIANG_DAO_WIDTH[self.index_]
    local bottom_margin, mopai_space = 16, 12
    local startX = self:calcMaJiangBottomMargin_() + majiang_width / 2 + (index - 1) * (mopai_space + majiang_width * 3)
    local x = startX + self:calcWaiPaiOffsetWidth_(majiang_width, offset)
    local y = bottom_margin + majiang_height / 2 + self:calcWaiPaiOffsetHeight_(majiang_height, offset)
    return x, y
end

function PlayerView:calcWaiPaiPosRight_(index, offset)
    local majiang_width = MA_JIANG_DAO_WIDTH[self.index_]
    local bottom_margin, wai_pai_space = 186, 10
    local x = display.width * (1114 / DESIGN_WIDTH)
    local startY = bottom_margin + (index - 1) * (wai_pai_space + majiang_width * 3)
    local y = startY + self:calcWaiPaiOffsetWidth_(majiang_width, offset)
    return x, y + self:calcWaiPaiOffsetHeight_(majiang_width, offset)
end

function PlayerView:calcWaiPaiPosLeft_(index, offset)
    local majiang_width = MA_JIANG_DAO_WIDTH[self.index_]
    local top_margin, wai_pai_space = 622, 10
    local x = display.width * (268 / DESIGN_WIDTH)
    local startY = top_margin - (index - 1) * (wai_pai_space + majiang_width * 3)
    local y = startY - self:calcWaiPaiOffsetWidth_(majiang_width, offset)
    return x, y + self:calcWaiPaiOffsetHeight_(majiang_width, offset)
end

local CHU_PAI_ANIM_POS = {
    {display.cx, display.height * 0.3},
    {display.width * 0.725, display.cy},
    {display.cx, display.height * 0.65},
}

function PlayerView:onChuPaiChanged_(event)
    self.nodeChuPai_:removeAllChildren()
    if not event.cards or 0 == #event.cards then
        printInfo("PlayerView:onChuPaiChanged_(event) with no cards")
        return
    end

    local cards = ShuangKouAlgorithm.sort(1, event.cards)

    self:doChuPaiAnim_(cards, event.isReConnect, event.inFastMode, event.isLast)

    -- if self:isHost() and not event.isReConnect then
    --     print("==============删除手牌==============")
    --     dump(event.cards)
    --     self.pokerList_:removePokers(event.cards)
    -- end
    self:updateCardsCount()
end

function PlayerView:updateCardsCount(card)
    print("updateCardsCount", self.index_,  card)
    -- local index = self.index_
    -- if index == SK_TABLE_DIRECTION.RIGHT then
    --     self.cardNumber_:setPositionX(-80)
    --     self.cardBack_:setPositionX(-80)
    -- elseif index == SK_TABLE_DIRECTION.LEFT then
    --     self.cardNumber_:setPositionX(80)
    --     self.cardBack_:setPositionX(80)
    -- elseif index == SK_TABLE_DIRECTION.TOP then
    --     self.cardNumber_:setPositionX(80)
    --     self.cardBack_:setPositionX(80)
    -- end
    -- if self.player_:getLeftCards() == -1 or self:isHost() then
    --     self.cardBack_:hide()
    --     self.cardNumber_:setString("")
    -- else
    --     self.cardBack_:show()
        self.cardNumber_:setString(math.max(card or self.player_:getLeftCards(), 0))
    -- end
end

--打出的牌
function PlayerView:doChuPaiAnim_(cards, isReConnect, inFastMode, isLast)
    local seconds = 0.2
    local leftCards, rightCards = ShuangKouAlgorithm.sortOutPokers(cards)
    local cards = {}
    for _, v in ipairs(leftCards) do
        table.insert(cards, v)
    end
    local leftLen =  #leftCards
    local rightLen = #rightCards
    for _, v in ipairs(rightCards) do
        table.insert(cards, v)
    end
    for i, card in ipairs(cards) do
        local x, y, showIndex, scale = self:calcChuPaiPos_(#cards, i ,leftLen)
        local poker = PokerView.new(card):addTo(self.nodeChuPai_, showIndex)

        poker.posX_ = x
        poker.posY_ = y
        if card ~= -1 then
            poker:fanPai()
        end
        local point = poker:getParent():convertToWorldSpace(cc.p(x, y))
        if i == #cards then
            self:playChuPaiAnim_(poker, x, y, seconds, isReConnect, inFastMode, true, cards, isLast)
        else
            self:playChuPaiAnim_(poker, x, y, seconds, isReConnect, inFastMode, false, cards, isLast)
        end
    end
    self:performWithDelay(function()
        self:playChuPaiSound_(cards, isLast)
    end, 0.1)

end

function PlayerView:playChuPaiSound_(cards, isLast)
    local cardType, value = ShuangKouAlgorithm.getCardType(cards, display:getRunningScene():getTable():getConfigData())
    -- dump(result)
    if isLast then
        gameAudio.playSound("sounds/common/final_attack.mp3")
        return
    end

    if cardType == nil then
        return
    end

    local sound
    if cardType == ShuangKouCardType.DAN_ZHANG then
        if value[1] == nil then
            return
        end
        sound = "1_" .. value[1] .. ".mp3"
    elseif cardType == ShuangKouCardType.DUI_ZI then
        if value[1] == nil then
            return
        end
        sound = "2_" .. value[1] .. ".mp3"
    elseif cardType == ShuangKouCardType.SHUN_ZI then
        sound = "shunzi.mp3"
    elseif cardType == ShuangKouCardType.SAN_ZHANG then
        sound = "px_1_sanzhang.mp3"
    elseif cardType == ShuangKouCardType.LIAN_DUI then
        sound = "liandui.mp3"
    elseif cardType == ShuangKouCardType.LIAN_SAN_ZHANG then
        sound = "wing.mp3"
    elseif cardType >= ShuangKouCardType.ZHA_DAN and cardType < ShuangKouCardType.TIAN_WANG_ZHA then
        sound = "zha_" .. math.random(3) .. ".mp3"
    elseif cardType == ShuangKouCardType.TIAN_WANG_ZHA then
        sound = "zha_tianwangzha"
    end
    print(sound)
    gameAudio.playShuangKouHumanSound(sound, self.player_:getSex())
end

--打出去的牌的动画
function PlayerView:playChuPaiAnim_(poker, x, y, seconds, isReConnect, inFastMode, isdeleteCards, cards)
    seconds = 0
    local startX_ , startY_ = 0 , 0
    if (self:isHost() or self:isFriend()) and not isReConnect and self.pokerList_ then
        startX_ , startY_ = self.pokerList_:getOutPokerPos(poker:getCard())
    end

    -- print(startX_, startY_, "startX", self:isFriend())
    -- if (self:isFriend()) then
    --     startX_ , startY_ = display.cx, display.top
    -- end
    -- print(startX_, startY_, "startX", self:isFriend())

    local posx_, posy_ = x, y
    local moveX_ ,moveY_ = 0, 0
    local scaleFrom, scaleTo, rotation = 0.2, 0.5, 8
    local rotate = math.random(-rotation, rotation)
    if SK_TABLE_DIRECTION.BOTTOM == self.index_ then
        --1位置的动画
        moveX_ = -startX_ + posx_
        moveY_ = startY_ - posy_
        if (self:isHost() or self:isFriend()) and not isReConnect and self.pokerList_ then
            self.pokerList_:outPokerAction(poker:getCard(), x, y, moveX_, moveY_, seconds)--用手牌移动一般距离跟时间

            -- local sequence = transition.sequence({
            --     cc.DelayTime:create(seconds / 2),
            --     cc.CallFunc:create(function ()
            --         if isdeleteCards then
            --             self.pokerList_:removeOutPokers(cards) --删除打出去的手牌
            --         end
            --     end),
            --     cc.Spawn:create(cc.MoveTo:create(0, cc.p(posx_- moveX_ /2, posy_+ moveY_/ 2)),
            --         cc.ScaleTo:create(0, 1.7, 1.7)),
            --     cc.Spawn:create(cc.MoveTo:create(seconds / 2, cc.p(posx_, posy_)),
            --         cc.ScaleTo:create(checknumber(seconds / 2), scaleTo, scaleTo)),
            --     -- cc.DelayTime:create(3),
            --     cc.CallFunc:create(function ()
            --          -- gameAudio.playSound("sounds/datongzi/outpoker.mp3")
            --     end),
            -- })
            -- poker:scale(scaleFrom)
            -- poker:runAction(sequence) --用打出去的牌移动后一半时间跟距离

            if isdeleteCards then
                self.pokerList_:removeOutPokers(cards) --删除打出去的手牌
            end
            poker:runAction(cc.ScaleTo:create(0.1, scaleTo, scaleTo))
            poker:setPosition(posx_, posy_)
            return
        end
    elseif SK_TABLE_DIRECTION.RIGHT == self.index_ then
        if display:getRunningScene():getTable():getMaxPlayer() == 2 then
            poker:pos(posx_- 200, posy_)
            moveX_ = - 200
        elseif  display:getRunningScene():getTable():getMaxPlayer() >= 3 then
            poker:pos(posx_+ 200, posy_- 50)
            moveX_ =  200
            moveY_ = - 50
        end
    elseif SK_TABLE_DIRECTION.LEFT == self.index_ then
        poker:pos(posx_ - 200, posy_- 50)
        moveX_ = - 200
        moveY_ = - 50
    elseif SK_TABLE_DIRECTION.TOP == self.index_ then
        poker:pos(posx_ + 200, posy_)
        moveX_ = - 200

        if self:isFriend() and self.pokerList_ and not isReConnect then
            if self.player_:getLeftCards() == 0 then
                self:setPokerListView(nil)
            else
                self.pokerList_:removeOutPokers({poker:getCard()}) --删除打出去的手牌
            end
        end
    end

    --不是1位置的动画
    local sequence = transition.sequence({
         cc.Spawn:create(cc.MoveTo:create(seconds / 2, cc.p(posx_+ moveX_ /2, posy_+ moveY_/ 2)),
            cc.ScaleTo:create(checknumber(seconds / 2), scaleFrom + 0.5, scaleFrom + 0.5)),
        cc.Spawn:create(cc.MoveTo:create(seconds / 2, cc.p(posx_, posy_)),
            cc.ScaleTo:create(checknumber(seconds / 2), scaleTo, scaleTo)),
        cc.CallFunc:create(function ()
                     -- gameAudio.playSound("sounds/datongzi/outpoker.mp3")
                end),
    })
    -- poker:setRotation(rotate)
    if isReConnect or inFastMode then
        poker:pos(posx_, posy_)
        poker:scale(scaleTo)
    else
        poker:scale(scaleFrom)
        poker:runAction(sequence)
        -- poker:scale(scaleFrom)
        -- transition.moveTo(poker, {scale = scaleTo, time = seconds})--, easing = "bounceOut"
    end
end

-- 出牌的动画
function PlayerView:showChuPaiAnim_(card)
    local nodes = self:getHandPokerNode_():getChildren()
    local total = 0
    if nodes then
        total = table.nums(nodes)
    end
    local x, y, z = self:calcMaJiangPos_(total, total)
    local delObj = self:getRemoveMaJiang_(card)
    if delObj then
        x, y = delObj:getPosition()
    end
    local obj = PokerView.new(card):addTo(self.nodeAnimations_)
    local toX, toY = unpack(CHU_PAI_ANIM_POS[self.index_])
    local seconds = 0.5
    local move = cc.MoveTo:create(seconds, cc.p(toX, toY))
    local scale = cc.ScaleTo:create(seconds, 1.5)
    local walk = cc.Spawn:create(move, scale)
    local walkMagic = transition.newEasing(walk, "exponentialOut")
    local action = transition.sequence({
        walkMagic,
        cc.DelayTime:create(seconds / 2),
        cc.CallFunc:create(function ()
            obj:removeFromParent()
        end)
    })
    obj:runAction(action)
end

-- 展示玩家的动作动画
function PlayerView:showActionAnim_(spriteName,moveEnable,callback, isDown)
    local toX, toY = unpack(ACTION_ANIM_POS[self.index_])
    print(self.index_)
    if self.index_ == 1 then
        if isDown then
            toY = toY -70
        end
    elseif self.index_ == 2 then
        if isDown then
            toY = toY -110
        end
    elseif self.index_ == 3 then
        if isDown then
            toY = toY -50
        end
    elseif self.index_ == 4 then
        if isDown then
            toY = toY -110
        end
    end
    local params = {}
    if moveEnable then
        local ox, oy = unpack(OFFSET_OF_SEATS_4[self.index_])
        params.toX = ox
        params.toY = oy
        params.onComplete = callback
    else
        params.toX = toX
        params.toY = toY
    end
    local actionAnim = require("app.games.shuangKou.views.game.ActionAnim").new(spriteName,params):addTo(self.nodeAnimations_):pos(toX, toY)
    actionAnim:run()
end

function PlayerView:onHandCardRemoved_(event)
    -- self:removeHandMaJiang_(event.card)
    self.pokerList_:removeAllPokers()
end

function PlayerView:getLastChuPaiPos()
    local nodes = self.nodeChuPai_:getChildren()
    if not nodes or #nodes < 1 then
        return self:calcChuPaiPos_(1, 1)
    end
    return self:calcChuPaiPos_(#nodes, #nodes)
end

function PlayerView:calcChuPaiPos_(total, index, leftLen)
    if SK_TABLE_DIRECTION.BOTTOM == self.index_ then
        return self:calcChuPaiPosBottom_(total, index, leftLen)
    elseif SK_TABLE_DIRECTION.RIGHT == self.index_ then
        return self:calcChuPaiPosRight_(total, index, leftLen)
    elseif SK_TABLE_DIRECTION.LEFT == self.index_ then
        return self:calcChuPaiPosLeft_(total, index, leftLen)
    else
        return self:calcChuPaiPosUp_(total, index, leftLen)
    end
end

function PlayerView:calcChuPaiPosUp_(total, index, leftLen)
    local majiang_width = 53
    majiang_width = majiang_width * CHU_PAI_SCALE
    local offset = (index - (total - 1) / 2 - 1) * majiang_width
    local x = display.left + offset + 630
    local y = 615
    if total > CHU_PAI_LINE_LENGTH then
        x = (display.width - majiang_width * CHU_PAI_LINE_LENGTH) / 2 + (index - 1) % CHU_PAI_LINE_LENGTH * majiang_width - 80
        y = display.height * 180 / DESIGN_HEIGHT - math.floor((index - 1) / CHU_PAI_LINE_LENGTH) * 50 + 450
    else
        x = display.cx + offset
        y = 615
    end
    if index > leftLen and index <= math.ceil(leftLen/CHU_PAI_LINE_LENGTH)*CHU_PAI_LINE_LENGTH then
        x = x + 20
    end

    return x, y, index, CHU_PAI_SCALE
end

function PlayerView:calcChuPaiPosBottom_(total, index, leftLen)
    local majiang_width = MA_JIANG_DAO_WIDTH[self.index_] * BOTTOM_CHU_PAI_SCALE
    local offset = (index - (total - 1) / 2 - 1) * majiang_width
    local x = display.cx + offset
    local y = 300
    if index > leftLen then
        x = x + 20
    end
    return x, y, index, CHU_PAI_SCALE
end

function PlayerView:calcChuPaiPosRight_(total, index, leftLen)
    local majiang_width = 53
    majiang_width = majiang_width * CHU_PAI_SCALE
    local x = 0
    local y = 0
    if total > CHU_PAI_LINE_LENGTH then
        x = (display.width - majiang_width * CHU_PAI_LINE_LENGTH) / 2 + (index - 1) % CHU_PAI_LINE_LENGTH * majiang_width + 300
        y = display.height * 180 / DESIGN_HEIGHT - math.floor((index - 1) / CHU_PAI_LINE_LENGTH) * 50 + 290
    else
        local offset = (index - (total - 1) / 2 - 1) * majiang_width
        x = display.right + offset - 320
        y = 450
    end
    if index > leftLen and index <= math.ceil(leftLen/CHU_PAI_LINE_LENGTH)*CHU_PAI_LINE_LENGTH then
        x = x + 20
    end
    return x, y, index, CHU_PAI_SCALE
end

function PlayerView:calcChuPaiPosLeft_(total, index, leftLen)
    local majiang_width = 53
    majiang_width = majiang_width * CHU_PAI_SCALE
    local x = 0
    local y = 0
    if total > CHU_PAI_LINE_LENGTH then
        x = (display.width - majiang_width * CHU_PAI_LINE_LENGTH) / 2 + (index - 1) % CHU_PAI_LINE_LENGTH * majiang_width - 290
        y = display.height * 180 / DESIGN_HEIGHT - math.floor((index - 1) / CHU_PAI_LINE_LENGTH) * 50 + 290
    else
        local offset = (index - (total - 1) / 2 - 1) * majiang_width
        x = display.left + offset + 310
        y = 450
    end
    if index > leftLen and index <= math.ceil(leftLen/CHU_PAI_LINE_LENGTH)*CHU_PAI_LINE_LENGTH then
        x = x + 20
    end
    return x, y, index, CHU_PAI_SCALE
end

function PlayerView:onWinWithCtype(ctype)
    if not ctype or type(ctype) ~= 'number' then
        return
    end
    if not table.indexof({2, 3, 7, 8, 9, 10, 11, 12, 13, 14}, ctype) then
        return
    end
    if self.isCtypeShowDown_ then
        return
    end
    self.isCtypeShowDown_ = true
    local x, y = self:getPlayerPosition()
    local frames = display.newFrames("canim%d.png", 1, 11)
    local boom = display.newSprite(frames[1]):addTo(self.nodeAnimations_):pos(x, y)
    local spriteCtype = display.newSprite(string.format("#ctype%d.png", ctype)):addTo(self.nodeAnimations_):pos(x, y)
    transition.playAnimationOnce(boom, display.newAnimation(frames, 1 / 11), true, function ()
        transition.fadeOut(spriteCtype, {time = 1, delay = 1, onComplete = function ()
            spriteCtype:removeFromParent()
        end})
    end)
end

-- 计算节点们的四个最大值
function PlayerView:calcMaxWidthValues_(nodes)
    local maxX, maxY, minX, minY = nil, nil, nil, nil
    for i,v in ipairs(nodes) do
        local x, y = v:getPosition()
        if not maxX or not minX or not maxY or not minY then
            maxX = x
            minX = x
            maxY = y
            minY = y
        else
            maxX = math.max(maxX, x)
            minX = math.min(minX, x)
            maxY = math.max(maxY, y)
            minY = math.min(minY, y)
        end
    end
    return maxX, maxY, minX, minY
end

function PlayerView:getHandPokerNode_()
    if self:isHost() then
        return self.pokerList_
    end
end

function PlayerView:canChuPai_()
    if not dataCenter:isSocketReady() then
        return false
    end
    if display:getRunningScene():getTable():getInPublicTime() then  -- 公共牌时间不允许出牌
        return false
    end
    if not display:getRunningScene():getTable():isMyTurn(self.player_:getSeatID()) then
        return false
    end
    return true
end

function PlayerView:onMaJiangChuAction_(maJiang)
    local card = maJiang:getMaJiang()
    if not self:canChuPai_() then  -- 公共牌时间不允许出牌
        return self:resetMaJiangAfterTouch_(maJiang)
    end
    printInfo(card .. " be out!")
    maJiang:setBeOut(true)
    dataCenter:sendOverSocket(COMMANDS.CHU_PAI, {card = card})
    local allowSevenPairs = display:getRunningScene():getTable():getAllowSevenPairs()
    if self.player_:canZiMoHu(allowSevenPairs) then
        self.player_:addLouHu(card)
    end
    -- gameAudio.playSound("sounds/common/sound_card_out.mp3")
end

function PlayerView:getPlayerPosition()
    self:dealData()
    local index = self.index_
    assert(index > 0 and index < 10)
    return unpack(OFFSET_OF_SEATS_4[index])
end

-- cc.BezierTo:create(time，{cc.p(x, y), cc.p(x1, y1), cc.p(x2, y2)})
-- TODO: 贝塞尔曲线运动
function PlayerView:adjustSeatPos_(index, withAction)
    local moveTime = 0.5
    local x, y = self:getPlayerPosition()
    if withAction == true then
        self.nodePlayer_:runAction(cc.MoveTo:create(0.5, cc.p(x, y)))
        self.nodeFlags_:runAction(cc.MoveTo:create(0.5, cc.p(x, y)))
    else
        self.nodePlayer_:pos(x, y)
        self.nodeFlags_:pos(x, y)
    end

    self:initReadyPos_()
    self:initPosByIndex_()
    self:updateCardsCount()
end

function PlayerView:onIndexChanged_(event)
    print("PlayerView:onIndexChanged_(event) .. " .. self.index_ .. " " .. event.index)
    self.index_ = event.index
    self:adjustSeatPos_(self.index_, event.withAction)
    self:initPosByIndex_()
    self:updateCardsCount()

    if self.index_ == 3 then
        self.labelSpeakScore_:setPositionY(-110)
    else
        self.labelSpeakScore_:setPositionY(110)
    end
end

function PlayerView:calcPokerOffsetX_(isHost)
    if isHost then
        return HOST_OFFSET_X
    else
        return PLAYER_OFFSET_X
    end
end

function PlayerView:showHostHandCards_()
    if not self:isHost() then
        return
    end

    local majiangs = self:getMaJiangs()
    for _,v in pairs(checktable(majiangs)) do
        transition.rotateTo(v, {rotate = 0, time = 0.2})
    end
end

function PlayerView:onLeftCardsChanged_(event)
    self:updateCardsCount(event.to)
end

function PlayerView:onHandCardsChanged_(event)
    dump(event.cards, "onHandCardsChange")
    print(self:isHost(), self:isFriend())

    self:updateCardsCount()
    if not (self:isHost() or self:isFriend()) then
        return
    end

    if event.cards == nil then
        if self.pokerList_ then
            self.pokerList_ :removeAllPokers()
        end
        return
    end
    local isAnima = true
    if event.isReConnect == true then
        isAnima = false
    end
    if self.pokerList_ == nil then return end
    local function rankHandCards()
        -- self.pokerList_:showPokers(clone(event.cards), false)
        self.pokerList_:faPaiRank_(clone(event.cards))
    end
    self.pokerList_:removeAllPokers()
    if event.isReConnect then
        self.pokerList_:showPokers(clone(event.cards),false)
    else
        self.pokerList_:showPokers(clone(event.cards), isAnima, rankHandCards)
    end
end

function PlayerView:onHandCardsSort_(event)
    if not self:isHost() then
        return
    end
    self.pokerList_:sort()
end

function PlayerView:onPokerFound_(event)
    local card = event.card
    -- local x, y, z = self:calcMoPaiPos_(isDown)
    -- self:createMaJiangWithTouch_(card, #self.player_:getCards(), x, y, z, isDown, true)
    -- gameAudio.playSound("sounds/common/sound_deal_card.mp3")
end

function PlayerView:setContributionScore_(score)
    if score then
        -- self.labelContributionScore_:setString(score)
    end 
end

function PlayerView:setScoreWithRoller_(score, fromScore)
    print(score, fromScore, "score_change")
    -- if fromScore == nil then
    --     fromScore = 0
    --     self.labelScore_:setString(fromScore)
    --     return
    -- end
    if not self.isStart then
        self.labelScore_:setString(0)
        return
    end
    self.labelScore_:setString(score)
end

function PlayerView:updateLabelScore_(score, fromScore)
    local count = math.abs(score)
    local setup = 1
    if score < 0 then
        setup = -1
    end
    local actions = {}
    for i=1,count do
        table.insert(actions, cc.CallFunc:create(function ()
            fromScore = fromScore + setup
            self.labelScore_:setString(fromScore)
        end))
        table.insert(actions, cc.DelayTime:create(0.1))
    end
    if count > 0 then
        self:runAction(transition.sequence(actions))
    else
        self.labelScore_:setString(score)
    end
end

function PlayerView:setNickName(name)
    self.labelNickName_:setString(gailun.utf8.formatNickName(name, 6, '...'))--对头像名字过长进行处理
end

function PlayerView:setPlayerChildrenVisible(flag)
    local children = self.nodePlayer_:getChildren()
    for _,v in pairs(children) do
        if v ~= self.spriteOffline_  and
            v ~= self.spriteWarning_ and
            v ~= self.spriteWarning2_ and
            v ~= self.cardBack_ and
            v ~= self.winFlag_  and
            v ~= self.voiceQiPao_
            then
            v:setVisible(flag or false)
        end
    end
end

function PlayerView:clearAllPokers_()
    self.nodeChuPai_:removeAllChildren()
    if self.pokerList_ then
        self.pokerList_:removeAllPokers()
    end
end

------------- 一系列的响应状态变化而改变view的函数，下划线后面都是player model里面的状态 ---------------
function PlayerView:onPlayStateChanged_(opacity)
    -- if opacity and opacity >= 0 and opacity <= 255 then
    --     self:setOpacity(opacity)
    -- end
    self:setPlayerChildrenVisible(true)
end

function PlayerView:onStateIdle_(event)
    self:setPlayerChildrenVisible(false)
    self:setOpacity(255)
    -- self:clearAllPokers_()
    self.spriteReady_:hide()
end


function PlayerView:onStateReady_(event)
    self:hideAllFlags_()
    -- self:clearAllPokers_()
    self:showReady_()
    gameAudio.playSound("sounds/common/sound_ready.mp3")
end

function PlayerView:showReady_()
    self:adjustReady_()
end

function PlayerView:adjustReady_()
    self.spriteReady_:show()
end

function PlayerView:onStateWaiting_(event)
    self:onPlayStateChanged_(255)
    -- self:clearAllPokers_()
    self.spriteReady_:hide()
    self.spriteZhuanQuan_:hide()
    transition.pauseTarget(self.spriteZhuanQuan_)
end

function PlayerView:onStateCheckOut_(event)
    self.spriteZhuanQuan_:hide()
    transition.pauseTarget(self.spriteZhuanQuan_)
    self.spriteWarning_:hide()
    transition.pauseTarget(self.spriteWarning_)
    self.spriteWarning2_:hide()
    transition.pauseTarget(self.spriteWarning2_)
    self.winFlag_:hide()
end

function PlayerView:onStateWaitCall_(event)
    self:onPlayStateChanged_(255)
    self.isCtypeShowDown_ = false
    self.spriteReady_:hide()
    self.spriteZhuanQuan_:hide()
    transition.pauseTarget(self.spriteZhuanQuan_)
end

function PlayerView:onStateThinking_(event)
    self:onPlayStateChanged_(255)
    self:onCurrentPow_({pow = self.player_:getCurrentPow(), callBombCount = self.player_:getCallBombCount()})
    self.spriteReady_:hide()
    local seconds = checknumber(event.args[1])
    if self:isHost() then
        gameAudio.playSound("turnto.mp3")
    end
    self.spriteZhuanQuan_:show()
    transition.resumeTarget(self.spriteZhuanQuan_)
end

function PlayerView:setProgress(progress, time)
    self.spriteZhuanQuan_:runAction(cc.ProgressTo:create(progress, time))
end

function PlayerView:zhuanQuanAction(target, timer)
    local animaData = FaceAnimationsData.getCocosAnimation(6)
    gameAnim.createCocosAnimations(animaData, self.spriteZhuanQuan_)
    self.spriteZhuanQuan_:hide()
end

function PlayerView:onStateChanged_(event)
    if not event.to then
        return
    end
    local s = string.split(string.lower(event.to), '_')
    local methodName = "onState"
    for _,v in pairs(s) do
        methodName = methodName .. string.ucfirst(v)
    end
    methodName = methodName .. "_"
    if self[methodName] and type(self[methodName]) == 'function' then
        handler(self, self[methodName])(event)
    end
end

function PlayerView:onRoundOverShowPai_(event)
    self.nodeChuPai_:removeAllChildren()
    self.nodeShowPai_:removeAllChildren()
    if not event.cards then
        return
    end
    local ceng = 1
    local total = #event.cards
    local tempTotal = 0
    local index = 0
    if total > 14 then
        tempTotal = total - 14
        ceng  = 1
    else
        ceng = -1
    end
    for i=1, #event.cards do
        index = index + 1
        -- if index == tempTotal + 1 then
        --     index = 1
        --     ceng = 2
        --     tempTotal = 14
        -- end
        local x, y, z = self:calcRoundOverShowPokerPos_(#event.cards, index, ceng)
        local poker = PokerView.new(event.cards[i]):addTo(self.nodeShowPai_):scale(0.5):pos(x, y)
        poker.posX_ = x
        poker.posY_ = y
        poker:fanPai()
        poker:zorder(z)
    end
end

function PlayerView:onRoundStart_()
    self.isStart = true
    -- self:updateCardsCount()
    self.spriteRankGuang_:hide()
    self.spriteRank_:hide()
    -- self.spriteFan_:hide()
    -- self.spriteWarning2_:hide()
    -- self.spriteWarning_:hide()
    -- self.labelSpeakScore_:setString("")
    -- self:setScoreWithRoller_(0)
end

function PlayerView:onRoundOver_()
    self:performWithDelay(function()
        if self.pokerList_ then
            self.pokerList_:clearDesk()
        end
        self.isStart = false
        -- self:setScoreWithRoller_(0)
    end, 3)
end

function PlayerView:calcRoundOverShowPokerPos_(total, index, ceng)
    print("calcRoundOverShowPokerPos_")
    if SK_TABLE_DIRECTION.LEFT == self.index_ then
        return self:calcRoundOverPokerPosLeft_(total, index, ceng)
    elseif SK_TABLE_DIRECTION.RIGHT == self.index_ or SK_TABLE_DIRECTION.TOP == self.index_ then
        return self:calcRoundOverPokerPosRight_(total, index, ceng)
    end
end

function PlayerView:calcRoundOverPokerPosUp_(total, index, ceng)
    local majiang_width = 30
    majiang_width = majiang_width
    local x = index * majiang_width + 80
    local y = 0
    local playerX, playerY = self:getPlayerPosition()
    return playerX + x, playerY + y, index
end

function PlayerView:calcRoundOverPokerPosLeft_(total, index, ceng)
    local majiang_width = 30
    majiang_width = majiang_width
    index = index - 1
    local line = math.floor(index / ROUND_OVER_PAI_LINE_LENGTH)
    local x = (index - ROUND_OVER_PAI_LINE_LENGTH * line) * majiang_width + 100
    local y = 10 - 40 * line
    local playerX, playerY = self:getPlayerPosition()
    return playerX + x, playerY + y, index + 100 * line
end

function PlayerView:calcRoundOverPokerPosRight_(total, index, ceng)
    local majiang_width = 30
    majiang_width = -majiang_width
    index = index - 1
    local line = math.floor(index / ROUND_OVER_PAI_LINE_LENGTH)
    local x = (index - ROUND_OVER_PAI_LINE_LENGTH * line) * majiang_width - 100
    local y = 10 - 40 * math.floor(index / ROUND_OVER_PAI_LINE_LENGTH)
    local playerX, playerY = self:getPlayerPosition()
    return playerX + x, playerY + y, line * 100 - index
end

function PlayerView:rankAnimations_(target, time)
    local sequence1 = transition.sequence({
        cc.ScaleTo:create(time, 1),
        cc.ScaleTo:create(time, 1.1),
        cc.DelayTime:create(0.2),
        })
    local sequence2 = transition.sequence({
        cc.FadeTo:create(time, 128),
        cc.FadeTo:create(time, 255),
        cc.DelayTime:create(0.2),
        })

    target:runAction(cc.RepeatForever:create(sequence1))
    target:runAction(cc.RepeatForever:create(sequence2))
end
------------- 响应状态变化函数段结束 ------------------------------------------------------------

return PlayerView

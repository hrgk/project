local BaseAlgorithm = require("app.games.ldfpf.utils.BaseAlgorithm")
local PlayAnim = require("app.games.ldfpf.views.PlayAnim")
local PaoHuZiAlgorithm = require("app.games.ldfpf.utils.PaoHuZiAlgorithm")
local FaceAnimationsData = require("app.data.FaceAnimationsData")
local BaseApi = require("app.utils.BaseApi")

local DEALER_X, DEALER_Y = -40, 34
local OFFLINE_SIGN_X, OFFLINE_SIGN_Y = 0, 30
local PLAY_FLAG_X, PLAY_FLAG_Y = -42, -95

local QI_PAO_X, QI_PAO_Y = 150, 40

-- 桌牌的缩放比例
-- TableView中也要修改
local CURR_CARD_SCALE = 0.85
local player_pos_adjusty = 165
local player_pos_adjustx = 65

local mopai_pos_adjustx = 300
local mopai_pos_adjusty = 180

local player_pos = {
    {display.fixLeft+player_pos_adjustx , display.bottom + 80},
    {display.fixRight - player_pos_adjustx    , display.height - player_pos_adjusty+85},
    {display.fixLeft+player_pos_adjustx  , display.height - player_pos_adjusty+50},
}

-- TableView中也要修改
local mopaiX = player_pos_adjustx - 0
local mopai_pos_adjusty = 180
local cur_card_pos = 
{
    {display.cx, display.cy+50},
    {player_pos[2][1] - mopai_pos_adjustx, display.height - mopai_pos_adjusty},
    {player_pos[3][1] + mopai_pos_adjustx, display.height - mopai_pos_adjusty}
}

local ready_pos_adjustx = 100
local ready_pos = {
    {player_pos_adjustx + ready_pos_adjustx, player_pos[1][2]},
    {display.fixRight - player_pos_adjustx - ready_pos_adjustx, player_pos[2][2]},
    {player_pos_adjustx + ready_pos_adjustx, player_pos[3][2]},
}

local OFFSET_OF_SEATS_4 = {}
for i,v in ipairs(player_pos) do
    OFFSET_OF_SEATS_4[i] = {v[1],  v[2]}
end
--用户信息坐标
local PLAYER_INFO_POS = {
    {400, 500* display.height /DESIGN_HEIGHT},
    {500, 900* display.height /DESIGN_HEIGHT},
    {400, 1000* display.height /DESIGN_HEIGHT},
}

--当前牌位置  桌面摸到或者打出的牌 一张
local cur_card_adjusty = 230
local curCardPos = {
    {display.cx, player_pos[1][2] + cur_card_adjusty},
    {player_pos[2][1], player_pos[2][2] - cur_card_adjusty},
    {player_pos[3][1], player_pos[3][2] - cur_card_adjusty},
}

curCardPos = cur_card_pos

--桌面放弃的牌位置
local throw_cards_adjustx = 30
local throw_cards_adjusty = 200
local THREW_PAI_POS = {  
    {display.fixRight - throw_cards_adjustx, player_pos[1][2] + 280},
    {display.fixRight - throw_cards_adjustx-120, player_pos[2][2] - throw_cards_adjusty+ 180},
    {throw_cards_adjustx+120, player_pos[3][2] - throw_cards_adjusty+ 180},
}

local THREW_PAI_POS2 = {
    {display.fixRight - throw_cards_adjustx, player_pos[1][2]},
    {display.fixRight - throw_cards_adjustx-120, player_pos[2][2] - throw_cards_adjusty+ 180},
    {throw_cards_adjustx+120, player_pos[3][2] - throw_cards_adjusty+100},
}

--吃碰桌牌出现位置
local OP_X = cur_card_pos[1][1] - 50.5
local OP_Y = display.cy - 50
local OP_INTERRVAL = 40

--桌面吃碰偎提的位置
local zuomianpai_posx = 10
local zuomianpai_posy = 570+145

local ZHUOMIAN_PAI_POS = {  
    {10, display.bottom - 310},
    {display.fixRight - zuomianpai_posx - 31, player_pos[2][2] - zuomianpai_posy},
    {display.fixLeft+zuomianpai_posx + 10, player_pos[3][2] - zuomianpai_posy},
}

local ZHUOMIAN_PAI_POS2 = {
    {540, display.bottom - 90 },
    {display.fixRight - zuomianpai_posx - 31, player_pos[2][2] - zuomianpai_posy},
    {display.fixLeft+zuomianpai_posx + 120, player_pos[3][2] - zuomianpai_posy + 130},
}

--桌面吃碰偎提 动画移动的位置
local ZHUOMIAN_PAI_ANI_POS = {  
    {150, display.bottom + 150},
    {1000, player_pos[2][2] - 100},
    {150, player_pos[2][2] - 100},
}

-- ZHUOMIAN_PAI_ANI_POS = ZHUOMIAN_PAI_POS

local huxi_pos_adjusty = 110
local HUXI_POS = {
    {player_pos[1][1] + 65 - 130, player_pos[1][2]-90},
    {player_pos[2][1] - 220+5 + 150, player_pos[2][2] -90+80 - 80},
    {player_pos[3][1] + 62- 130,  player_pos[3][2] -90+80-80},
}

local function getCurCardPos(node ,index)
    local x, y = node:getPosition()
    local worldPos = node:convertToNodeSpace(cc.p(x, y))
end

local TYPES = gailun.TYPES
local GRAY_FILTERS  = {"GRAY",{0.2, 0.3, 0.5, 0.1}}
local nodeData = {
    type = TYPES.ROOT,
    children = {
        {type = TYPES.NODE, var = "nodePlayer_", children = {  -- 玩家基本数据的对象
            
            {type = TYPES.SPRITE, var = "headBg_", filename = "res/images/game/headBg3.png", x = 0, y = 0},
            {type = TYPES.CUSTOM, var = "avatar_", class = "app.views.AvatarView",y = 30},
            {type = TYPES.LABEL, var = "labelNickName_", options = {text="fdsafdsafdsa", size=17, font = DEFAULT_FONT, align=cc.TEXT_ALIGNMENT_CENTER, color=cc.c3b(255, 255, 255)}, y = -10, x = 0, ap = {0.5, 0.5}},
            -- {type = TYPES.SPRITE, var = "spriteChipsBg_", y = -54, scale9 = true, size = {116, 30}, children = {
            {type = TYPES.LABEL_ATLAS, var = "labelScore_", filename = "fonts/game_score.png", options = {text="", w = 14, h = 36, startChar = "-"}, y = - 65, x = 30 , ap = {0, 0.5}},
            -- }},
            {type = TYPES.LABEL, var = "scoreName_", options = {text="积分:", size=20, font = DEFAULT_FONT, align=cc.TEXT_ALIGNMENT_CENTER, color=cc.c3b(255, 255, 255)}, y = -60, x = 0, ap = {1, 0.5}},
            {type = TYPES.SPRITE, var = "spriteZhuanquan_", filename = "res/images/common/head_zq.png"},
            {type = TYPES.CUSTOM, var = "voiceQiPao_", class = "app.views.game.VoiceQiPao", x = QI_PAO_X, y = QI_PAO_Y, visible = false},
            {type = TYPES.SPRITE, var = "qipai_text_", filename = "res/images/paohuzi/game/qipai_text.png", x = 0, y = 0},
            {type = TYPES.SPRITE, var = "daniao_text_", filename = "res/images/game/icon_daniao.png", x = 0, y = 0},
        }},
        {type = TYPES.NODE, var = "nodeFlags_", children = {
            {type = TYPES.SPRITE, var = "spriteZhuang_", visible = false, filename = "res/images/game/flag_zhuang.png", x = DEALER_X, y = DEALER_Y,},
        }},
        {type = TYPES.NODE, var = "nodeOffline_", children = {  -- 玩家基本数据的对象
            {type = TYPES.SPRITE, var = "spriteOffline_", filename = "res/images/paohuzi/game/off_line/bg.png", x = OFFLINE_SIGN_X, y = OFFLINE_SIGN_Y,
                children = {
                    {type = TYPES.SPRITE, filename = "res/images/paohuzi/game/off_line/font.png", ppx =  0.5, ppy = 0.2},
                    {type = TYPES.SPRITE, filename = "res/images/paohuzi/game/off_line/mh.png", ppx =  0.5, ppy = 0.6},
                    {type = TYPES.BM_FONT_LABEL, var = "offLineMinutes_", options={text="00", UILabelType = 1,font = "fonts/jhy.fnt",}, scale =0.8, ppx = 0.45, ppy = 0.6, ap = {1, 0.5}},
                    {type = TYPES.BM_FONT_LABEL, var = "offLineSeconds_", options={text="00", UILabelType = 1,font = "fonts/jhy.fnt",}, scale =0.8, ppx = 0.55, ppy = 0.6, ap = {0, 0.5}},
                }
            },
        }},
        {type = TYPES.SPRITE, var = "spriteReady_", filename = "res/images/game/readyFlag.png", visible = false},
        {type = TYPES.SPRITE, var = "nodeChuPai_"},  -- 出牌容器
        {type = TYPES.SPRITE, var = "nodeZhuomianPai_"},  -- 出牌容器
        {type = TYPES.SPRITE, var = "nodeAni_"},  -- 出牌容器
        {type = TYPES.SPRITE, var = "nodehuxi",children = { 
                {type = TYPES.NODE, var = "huxiBg_", filename = "res/images/game/tablehuxibg.png", scale9 = true, size = {190, 50}, children = {
                {type = TYPES.LABEL, var = "labelzhuomianhuxi_", options = {text="胡息:", size=17, font = DEFAULT_FONT, color=cc.c4b(255, 255, 255, 128) },ap = {0.5, 0.5}, ppx = 0.25, ppy = 0.5},
                {type = TYPES.LABEL_ATLAS, var = "labelHuxi_", filename = "fonts/game_score.png", options = {text="", w = 14, h = 35, startChar = "-"}, ppy = 0.38, ppx = 0.425, ap = {0, 0.5}},
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

local MA_JIANG_SHU_WIDTH = {82, 35, 39, 27}  -- 竖着的麻将的宽度
local MA_JIANG_DAO_WIDTH = {80, 80, 80, 80}  -- 倒着的麻将的宽度
local BOTTOM_CHU_PAI_SCALE = 36 / 55
local ROUND_OVER_CHAGNE_LINE_COUNT = 9
local ROUND_OVER_PAI_HEIGTH_DIST = 40
local RIGHT_POS_ZINDEX = 100
local CHU_PAI_SCALE = 0.6
local CHU_PAI_LINE_LENGTH = 9

PlayerView.SIT_DOWN_CLICKED = "SIT_DOWN_CLICKED"
PlayerView.ON_AVATAR_CLICKED = "ON_AVATAR_CLICKED"
PlayerView.QUERY_DOU = "queryDou"

function PlayerView:ctor(index,totaSeats)
    assert(index > 0 and index < 4, "bad player index of " .. checkint(index))
    display.addSpriteFrames("textures/game_anims.plist", "textures/game_anims.png")
    self.index_ = index
    self.nowSeats_ = totaSeats
    gailun.uihelper.render(self, nodeData)
    if self.nowSeats_ ~= 2 then
        self.nodePlayer_:pos(unpack(OFFSET_OF_SEATS_4[index]))
    else
        if index == 2 then
            self.nodePlayer_:pos(unpack(OFFSET_OF_SEATS_4[index + 1]))
        else
            self.nodePlayer_:pos(unpack(OFFSET_OF_SEATS_4[index]))
        end
    end
    if self.nodeOffline_ then
        self.nodeOffline_:pos(unpack(OFFSET_OF_SEATS_4[index]))
    end
    self.threwCards = {}
    self:setCascadeOpacityEnabled(true)
    self.nodePlayer_:setCascadeOpacityEnabled(true)
    cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()
    self.spriteZhuanquan_:hide()
    self:zhuanQuanAction(self.spriteZhuanquan_, 0.5)
    gailun.uihelper.setTouchHandler(self.nodePlayer_, handler(self, self.onAvatarClicked_))
    self.nodehuxi:setVisible(true)
    self.lasthuxi_ = 0
    self.labelHuxi_:setString(self.lasthuxi_)
    self.getScoreInfo = {}
end

function PlayerView:SetScoreInfo(gameType,clubID,uid,sucfuc,failfuc,playerContriller)
    self.getScoreInfo.gameType = gameType
    self.getScoreInfo.clubID = clubID
    self.getScoreInfo.uid = uid
    self.getScoreInfo.sucfuc = sucfuc
    self.getScoreInfo.failfuc = failfuc
    self.getScoreInfo.playerContriller = playerContriller
end

function PlayerView:setPaperCardList(paperCardList)
    self.paperCardList_ = paperCardList
    self.paperCardList_:setPlayerView(self)
end

function PlayerView:resetPos()
    --桌面放弃的牌位置
    local review_adjusty = 100
    THREW_PAI_POS = {  
        {display.fixRight - throw_cards_adjustx, player_pos[1][2] + 280},
        {display.fixRight - throw_cards_adjustx-120, player_pos[2][2] - throw_cards_adjusty+ 180},
        {throw_cards_adjustx+120, player_pos[3][2] - throw_cards_adjusty+ 180},
    }

    local review_zhuomianpai_adjusty = 60
    ZHUOMIAN_PAI_POS = {  
        {10, display.bottom - 320},
        {display.fixRight - zuomianpai_posx - 41, player_pos[2][2] - zuomianpai_posy},
        {display.fixLeft+zuomianpai_posx, player_pos[3][2] - zuomianpai_posy},
    }
    
    local ZHUOMIAN_PAI_ANI_POS = {  
        {150, display.bottom + 150},
        {1000, player_pos[2][2] - 100},
        {150, player_pos[2][2] - 100},
    }

    -- ZHUOMIAN_PAI_ANI_POS = ZHUOMIAN_PAI_POS

    HUXI_POS = {
        {player_pos[1][1] + 65 - 130, player_pos[1][2]-90},
        {player_pos[2][1] - 220+5 + 150, player_pos[2][2] -90+80 - 80},
        {player_pos[3][1] + 62- 130,  player_pos[3][2] -90+80-80},
    }
end

function PlayerView:setIndex(index)
    self.index_ = index
    if self.nowSeats_ ~= 2 then
        self.nodePlayer_:pos(unpack(OFFSET_OF_SEATS_4[index]))
    else
        if index == 2 then
            self.nodePlayer_:pos(unpack(OFFSET_OF_SEATS_4[index + 1]))
        else
            self.nodePlayer_:pos(unpack(OFFSET_OF_SEATS_4[index]))
        end
    end
    if self.nodeOffline_ then
        self.nodeOffline_:pos(unpack(OFFSET_OF_SEATS_4[index]))
    end
    
end

function PlayerView:onAvatarClicked_(event)
    if not self.player_ then
        return
    end
    local Params = {clubID = self.getScoreInfo.clubID,uid = self.getScoreInfo.uid}
    if self.getScoreInfo.gameType == 1 then
        BaseApi.request(PlayerView.QUERY_DOU,Params,handler(self.getScoreInfo.playerContriller, self.getScoreInfo.sucfuc),self.getScoreInfo.failfuc)
    end
    local info = self.player_:getShowParams()
    info.gameType = self.getScoreInfo.gameType
    info.playerContriller = self.getScoreInfo.playerContriller
    info.x = PLAYER_INFO_POS[self.index_][1]
    info.y = PLAYER_INFO_POS[self.index_][2]
    info.seatID = self.player_:getSeatID()
    self:dispatchEvent({name = PlayerView.ON_AVATAR_CLICKED, params = info})
end

function PlayerView:initReadyPos_()
    local x,y = 0,0
    if self.nowSeats_~= 2 then
        x, y = unpack(ready_pos[self.index_])
    else
        if self.index_ == 2 then
             x, y = unpack(ready_pos[self.index_ + 1])
        else
             x, y = unpack(ready_pos[self.index_])
        end
    end
    self.spriteReady_:pos(x, y)
end

function PlayerView:initPosByIndex_()
    local zhuangX = DEALER_X
    local offlineX = OFFLINE_SIGN_X
    local qiPaoX = QI_PAO_X
    local huxiX = HUXI_X
    local direction = nil
    if self.nowSeats_ == 2 then
        direction = TABLE_DIRECTION2
    else
        direction = TABLE_DIRECTION
    end
    if self.index_ == direction.BOTTOM or self.index_ == direction.LEFT then
        self.spriteZhuang_:setPositionX(zhuangX)
        self.spriteOffline_:setPositionX(offlineX)
        self.voiceQiPao_:setFlipX(false)
        self.voiceQiPao_:setPositionX(qiPaoX) 
    elseif self.index_ == direction.RIGHT then
        zhuangX = - DEALER_X
        self.spriteZhuang_:setPositionX(zhuangX)
        offlineX = - OFFLINE_SIGN_X
        self.spriteOffline_:setPositionX(offlineX)
        qiPaoX = - QI_PAO_X
        self.voiceQiPao_:setPositionX(qiPaoX)
        self.voiceQiPao_:setFlipX(true)
    end

    local huxiX, huxiY = 0,0
    if self.nowSeats_ == 2 and self.index_ == 2 then
         huxiX, huxiY = unpack(HUXI_POS[self.index_ + 1])
    else
         huxiX, huxiY = unpack(HUXI_POS[self.index_])
    end
    self.huxiBg_:setPosition(huxiX, huxiY)
    local scorePosInfo = 
    {
        [1] = {30+112 -133, huxiY-17-10},
        [2] = {30-168+141, 55 - 100 + 10},
        [3] = {30+110-138, 55 - 100 + 10},
    }
    if self.scoreName_ and not tolua.isnull(self.scoreName_) then
        self.scoreName_:setPosition(scorePosInfo[self.index_][1], scorePosInfo[self.index_][2])
    end
    self.labelScore_:setPosition(scorePosInfo[self.index_][1] + 10, scorePosInfo[self.index_][2]-5)

    local qipaiPosInfo = 
    {
        [1] = {45,35},
        [2] = {-45,35},
        [3] = {45,35},
    }
    if self.nowSeats_ == 2 and self.index_ == 2 then
        self.qipai_text_:setPosition(qipaiPosInfo[self.index_][1]+90, qipaiPosInfo[self.index_][2])
    else
        self.qipai_text_:setPosition(qipaiPosInfo[self.index_][1], qipaiPosInfo[self.index_][2])
    end
    local daniaoPosInfo =
    {
        [1] = {-40,115-55},
        [2] = {40,115-55},
        [3] = {-40,115-55},
    }
    if self.nowSeats_ == 2 and self.index_ == 2 then
        self.daniao_text_:setPosition(daniaoPosInfo[self.index_][1]-80, daniaoPosInfo[self.index_][2])
    else
        self.daniao_text_:setPosition(daniaoPosInfo[self.index_][1], daniaoPosInfo[self.index_][2])
    end
end

function PlayerView:reViewinitPosByIndex_()
    local huxiX, huxiY = 0,0
    huxiX, huxiY = unpack(HUXI_POS[self.index_])
    self.huxiBg_:setPosition(huxiX, huxiY)
    if self.index_ == 3 then
        self.nodePlayer_:setVisible(true)
    end
    local scorePosInfo = 
    {
        [1] = {30+112 -138, huxiY-17-20},
        [2] = {30-168+141, 55 - 100},
        [3] = {30+110-138, 55 - 100},
    }
    if self.scoreName_ and not tolua.isnull(self.scoreName_) then
        self.scoreName_:setPosition(scorePosInfo[self.index_][1], scorePosInfo[self.index_][2])
    end
    self.labelScore_:setPosition(scorePosInfo[self.index_][1] + 10, scorePosInfo[self.index_][2]-5)

    local qipaiPosInfo = 
    {
        [1] = {45,35},
        [2] = {-45,35},
        [3] = {45,35},
    }
    self.qipai_text_:setPosition(qipaiPosInfo[self.index_][1], qipaiPosInfo[self.index_][2])
    local daniaoPosInfo =
    {
        [1] = {-40,115-55},
        [2] = {40,115-55},
        [3] = {-40,115-55},
    }
    self.daniao_text_:setPosition(daniaoPosInfo[self.index_][1], daniaoPosInfo[self.index_][2])
end

function PlayerView:hideAllFlags_()
    
end

function PlayerView:adjustBottomFlagPos_()
    for i, v in ipairs(self.bottomShowFlagList_) do
        v:show()
        v:pos((i - 2) * -PLAY_FLAG_X, PLAY_FLAG_Y)
    end
end

function PlayerView:onEnter()
    self:initPosByIndex_()
    self:initReadyPos_()
    self:onStateIdle_()
    self.labelNickName_:enableShadow(cc.c4b(0, 0, 0, 128), cc.size(2, -3), 1)
    self.spriteOffline_:hide()
    self:isShowQiPai(false)
    self:isShowDaNiao(false)
end

function PlayerView:onExit()
    gailun.EventUtils.clear(self)
end

function PlayerView:onSitDownClicked_(event)
    self:dispatchEvent({name = PlayerView.SIT_DOWN_CLICKED})
end

function PlayerView:onSitDownEvent_(event)
    gameAudio.playSound("sounds/common/sound_enter.mp3")
    self.avatar_:showWithUrl(self.player_:getAvatarName())
    self:setNickName(self.player_:getNickName())
    self:setScoreWithRoller_(self.player_:getScore())
    self:setVisible(true)
end

function PlayerView:bindPlayer(player)
    assert(player)
    gailun.EventUtils.clear(self)
    self.player_ = player
    local cls = player.class
    local events = {
        {cls.SIT_DOWN_EVENT, handler(self, self.onSitDownEvent_)},
        {cls.CHANGE_STATE_EVENT, handler(self, self.onStateChanged_)},
        {cls.POKER_FOUND, handler(self, self.onPokerFound_)},
        {cls.HAND_CARDS_CHANGED, handler(self, self.onHandCardsChanged_)},
        {cls.DEAL_CARDS, handler(self, self.onDealCards_)},
        {cls.SHOU_ZHANG, handler(self, self.onShouZhang_)},
        {cls.INDEX_CHANGED, handler(self, self.onIndexChanged_)},
        {cls.ROUND_START_CLEAR, handler(self, self.roundStartClear_)},

        {cls.RESUME_ZHUO_CARDS, handler(self, self.onZhuoPaiChanged_)},
        {cls.RESUME_CHU_PAI, handler(self, self.onResumeChuPai)},
        {cls.PAO_CHANGE_EVENT, handler(self, self.onPaoChanged_)},
        {cls.PENG_CHANGE_EVENT, handler(self, self.onPengChanged_)},
        {cls.CHI_CHANGE_EVENT, handler(self, self.onChiChanged_)},
        {cls.TI_CHANGE_EVENT, handler(self, self.onTiChanged_)},
        {cls.FIRST_TI_CHANGE_EVENT, handler(self, self.onFirstTiChanged_)},
        {cls.WEI_CHANGE_EVENT, handler(self, self.onWeiChanged_)},
        {cls.HU_CHANGE_EVENT, handler(self, self.onHuChanged_)},
        {cls.CHU_PAI_CHANGED, handler(self, self.onChuPaiChanged_)},
        {cls.SCORE_CHANGED, handler(self, self.onScoreChanged_)},
        {cls.ON_SETDEAR_EVENT, handler(self, self.onDealerEvent_)},
        {cls.ALL_PASS_CHANGE, handler(self, self.onAllPass_)},
        {cls.TURN_TO_OUT, handler(self, self.onTurnToOut_)},

        {cls.SHOW_TMP_MOPAI, handler(self, self.showMoPaiEvent)},
        {cls.PASS_EVENT, handler(self, self.onPassEvent_)},
        {cls.ON_FLOW_EVENT, handler(self, self.onFlwoEvent_)},  --ON_SHOWHEISAN_EVENT
        {cls.ON_ROUND_OVER_SHOW_POKER, handler(self, self.onRoundOverShowPai_)},
        {cls.ON_STOP_RECORD_VOICE, handler(self, self.onStopRecordVoice_)},
        {cls.ON_PLAY_RECORD_VOICE, handler(self, self.onPlayerVoice_)},
        {cls.OFFLINE_EVENT, handler(self, self.onOfflineEvent_)}, 
        {cls.SHOW_READY,handler(self,self.showReadyCommand_)},
        {cls.TI_PAI,handler(self,self.onTiPaiHandler_)},
        {cls.ON_QIPAI_EVENT,handler(self,self.onQiPaiHandler_)},
        {cls.ON_DANIAO_EVENT,handler(self,self.onDaNiaoHandler_)},
    }
    gailun.EventUtils.create(self, self.player_, self, events)
end

function PlayerView:onTiPaiHandler_(event)
    self.paperCardList_:tiPai()
end

function PlayerView:showReadyCommand_(event)
    if  event.isReady then
        self.spriteReady_:show()
    else
        self.spriteReady_:hide()
    end
end

function PlayerView:onHideAllFlags_(event)
 
end

function PlayerView:onPlayerVoice_(event)
    self.voiceQiPao_:playVoiceAnim(event.time)
end

function PlayerView:onStopRecordVoice_(event)
    self.voiceQiPao_:stopRecordVoice()
end

function PlayerView:showZhuang_(isDealer)
    self.spriteZhuang_:show()
    local spriteName = "flag_zhuang.png"
    if not isDealer then
        self.spriteZhuang_:hide()
    end
end

function PlayerView:onDealerEvent_(event)
    if event.isDealer == -1 or event.isDealer == nil then
        self.spriteZhuang_:hide()
        return
    end
    self:showZhuang_(event.isDealer)
end

function PlayerView:onQiPaiHandler_(event)
        self:isShowQiPai(event.isQiPai)
end

function PlayerView:onDaNiaoHandler_(event)
        self:isShowDaNiao(event.isDaNiao == 1 and true or false)
end

function PlayerView:onFlwoEvent_(event)
    self.spriteReady_:hide()
    if event.flag ~= nil and event.flag ~= -1 then
        self.spriteZhuanquan_:show()
        transition.resumeTarget(self.spriteZhuanquan_)
    else
        self.spriteZhuanquan_:hide()
        transition.pauseTarget(self.spriteZhuanquan_)
    end
end

function PlayerView:onPassEvent_(event)
    if event.inFastMode then return end
    -- self:showActionAnim_("#bz_bu_yao.png")
end

function PlayerView:onHuChanged_(event)
    print("onHuChanged_(event)"..event.typeid)
    self:playHuAnim(event.typeid)
end

function PlayerView:onStandUp()
    gailun.EventUtils.clear(self)
    self.player_ = nil
    gameAudio.playSound("sounds/common/sound_left.mp3")
    self:setVisible(false)
end

function PlayerView:startOffline(lastOfflineTime)
    self.spriteOffline_:stopAllActions()

    if lastOfflineTime then
        self.offlineTime_ =  math.modf(gailun.utils.getTime()) - lastOfflineTime
        local minutes = math.modf(self.offlineTime_/60)
        if minutes >= 60 then
            self.offlineTime_ = self.offlineTime_ - 60*60
        end
    else
        self.offlineTime_ = 0
    end

    print("self.offlineTime_",self.offlineTime_)
    
    local sequence =
        transition.sequence(
        {
            cc.CallFunc:create(
                function()
                    self.offlineTime_ = self.offlineTime_ + 1
                    local seconds = self.offlineTime_%60
                    local minutes = math.modf(self.offlineTime_/60)
                    minutes = minutes >= 10 and minutes .. "" or "0" .. minutes
                    seconds = seconds >= 10 and seconds .. "" or "0" .. seconds
                    self.offLineMinutes_:setString(minutes)
                    self.offLineSeconds_:setString(seconds)
                end
            ),
            cc.DelayTime:create(1)
        }
    )
    self.spriteOffline_:runAction(cc.RepeatForever:create(sequence))
end

function PlayerView:onOfflineEvent_(event)
    self.spriteOffline_:setVisible(event.offline)
    if event.offline then
        self:startOffline(event.lastOfflineTime)
    else
        self.spriteOffline_:stopAllActions()
    end
    if not event.offline and event.isChanged then
        local str = string.format("%s回来了。", self.player_:getNickName())
        app:showTips(str)
    end
end

function PlayerView:isHost()
    return self.player_:isHostPlayer()
end

function PlayerView:checkQuicklyTing(isOld)
    if self:isHost() then
        if isOld ~= true then
            self.tingCards = PaoHuZiAlgorithm.getTingOperate(PaoHuZiAlgorithm.getRemainCards(), self.player_:getCards(), self.player_:getZhuoCards())
        end
        if self.tingCards then
            for _, card in ipairs(self.paperCardList_:getCardsNode()) do
                card:showTingTag(table.indexof(self.tingCards, card:getCard()) ~= false)
            end
        end
    end  
end

function PlayerView:onTurnToOut_(event)
    self:checkQuicklyTing()
    -- if self:isHost() then
    --     self.paperCardList_:turnToOut()
    -- end
end

function PlayerView:onScoreChanged_(event)
    self:setScoreWithRoller_(event.score, event.from)
end

function PlayerView:calcWaiPaiPos_(index, offset)
    local direction = nil
    if self.nowSeats_ == 2 then
        direction = TABLE_DIRECTION2
    else
        direction = TABLE_DIRECTION
    end
    if direction.BOTTOM == self.index_ then
        return self:calcWaiPaiPosBottom_(index, offset)
    elseif direction.RIGHT == self.index_ then
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
    local x = display.fixRight * (1114 / DESIGN_WIDTH)
    local startY = bottom_margin + (index - 1) * (wai_pai_space + majiang_width * 3)
    local y = startY + self:calcWaiPaiOffsetWidth_(majiang_width, offset)
    return x, y + self:calcWaiPaiOffsetHeight_(majiang_width, offset)
end

function PlayerView:calcWaiPaiPosLeft_(index, offset)
    local majiang_width = MA_JIANG_DAO_WIDTH[self.index_]
    local top_margin, wai_pai_space = 622, 10
    local x = display.fixRight * (268 / DESIGN_WIDTH)
    local startY = top_margin - (index - 1) * (wai_pai_space + majiang_width * 3)
    local y = startY - self:calcWaiPaiOffsetWidth_(majiang_width, offset)
    return x, y + self:calcWaiPaiOffsetHeight_(majiang_width, offset)
end

local CHU_PAI_ANIM_POS = {
    {display.cx, display.height * 0.65},
    {display.fixRight * 0.725, display.cy},
    {display.cx, display.height * 0.65},
}

function PlayerView:onChuPaiChanged_(event)
    if not event.card then
        return
    end
    if self:isHost() then
        self.paperCardList_:removeHandCards({event.card})
        for _, card in ipairs(self.paperCardList_:getCardsNode()) do
            card:showTingTag(false)
        end
    end  
end

function PlayerView:showMoPaiEvent(event)
    if self:isHost() then
        for _, card in ipairs(self.paperCardList_:getCardsNode()) do
            card:showTingTag(false)
        end
    end
    return self:showMoPai(event.card,event.needFlip)
end

-- 显示一张临时摸牌   摸牌弃牌都由桌子管理
function PlayerView:showMoPai(card, needFlip)
end

function PlayerView:onAllPass_(event)
    local card = event.card
    local index = event.index
    table.insert(self.threwCards,card)

    if event.inFastMode then
        local x,y = self:getThrewPaiPos()
        local tmp= app:createConcreteView("PaperCardView", card, 3, false,nil):addTo(self.nodeChuPai_):pos(x,y, 100)
        tmp:setScale(1.2)
        return
    end
    local orgX, orgY = 0,0
    if self.nowSeats_ ~= 2 then
         orgX, orgY = unpack(curCardPos[index])
    else
        if index == 2 then
             orgX, orgY = unpack(curCardPos[index + 1])
        else
             orgX, orgY = unpack(curCardPos[index])
        end
    end    
    local tmpCard = app:createConcreteView("PaperCardView", card, 1, false, nil):addTo(self.nodeChuPai_):pos(orgX,orgY)
    tmpCard:fanPai()  
    tmpCard:setScale(0.8)
    local x,y = self:getThrewPaiPos()
    local mtime = 0.1
    transition.moveTo(tmpCard, {x = x, y = y, time = mtime})
    transition.scaleTo(tmpCard, {scale = 0, time = mtime})
    self:performWithDelay(function ()
        self.nodeChuPai_:removeChild(tmpCard,true)
        local tmp= app:createConcreteView("PaperCardView", card, 3, false,nil):addTo(self.nodeChuPai_):pos(x,y, 100)
        tmp:setScale(1.2)
    end, mtime )
end


function PlayerView:addThrewPai(card, needFlip)
    table.insert(self.threwCards,card)
    local x,y = self:getThrewPaiPos()
    local tmp= app:createConcreteView("PaperCardView", card, 3, false, nil):addTo(self.nodeChuPai_):pos(x,y, 100)
    tmp:setScale(1.2)
end

function PlayerView:getThrewPaiPos(totalIndex)
    local index = totalIndex or #self.threwCards
    local x, y = 0,0
    if self.nowSeats_ ~= 2 then
        x, y = unpack(THREW_PAI_POS[self.index_])
    else
        if self.index_ == 2 then
             x, y = unpack(THREW_PAI_POS2[self.index_ + 1])
        else
             x, y = unpack(THREW_PAI_POS2[self.index_])
        end
    end
    
    local ceng = math.floor(index / 10)
    local row = math.mod(index, 10)
    if row == 0 then row = 1 end
    y = y - ceng*SMALL_CARD_HEIGHT
    local direction = nil
    if self.nowSeats_ == 2 then
        direction = TABLE_DIRECTION2
    else
        direction = TABLE_DIRECTION
    end
    if direction.BOTTOM == self.index_ then   
        x   = x - (row-1) * SMALL_CARD_WIDTH
        return x,y
    elseif direction.RIGHT == self.index_ then   
        x   = x - (row-1)  * SMALL_CARD_WIDTH
        return x,y
    else   
        x   = x + (row-1) * SMALL_CARD_WIDTH + display.fixLeft
        return x,y
    end
end
 
function PlayerView:updateZhuomianHuxi(hidelizi)
    self.tableKanCards = {}
    for _,kan in ipairs(self.nodeZhuomianPai_:getChildren()) do
        local cardsType = kan:getCardsType()
        table.insert(self.tableKanCards,cardsType)
    end
    local huxi = PaoHuZiAlgorithm.calcTableHuXi(self.tableKanCards)
    self.nodehuxi:setVisible(true)
    -- if huxi > 0 then
    --     self.nodehuxi:setVisible(true)
    -- else
    --     self.nodehuxi:setVisible(false)
    -- end 
    if huxi == self.lasthuxi_ then
        return 
    end
    self.lasthuxi_ = huxi
    local str = string.format("%d", huxi)
    self.labelHuxi_:setString(str)
    if hidelizi then
        return
    end

    self.emitter_  = cc.ParticleExplosion:createWithTotalParticles(200)    --设置粒子数  
    -- self.emitter_ =cc.ParticleSystemQuad:create("textures/fireline.plist")  
    local cache = cc.Director:getInstance():getTextureCache():addImage("textures/explosion.png")
    self.emitter_:setTexture(cache)
    self.emitter_:setAutoRemoveOnFinish(true)    --设置播放完毕之后自动释放内存  
    self.emitter_:setLife(0)
    self.emitter_:setLifeVar(0.4)
    -- self.emitter_:setPosVar(cc.p(0,0))
    self.emitter_:setStartSize(34)
    self.emitter_:setEndSize(14)
    self.emitter_:setStartColor(cc.c4b(1,1,1,1))
    self.emitter_:setEndColor(cc.c4b(0.2,0.5,0.2,0.5))
    self.emitter_:setStartColorVar(cc.c4b(0,0,0,0.84))
    self.emitter_:setEndColorVar(cc.c4b(0.38,0,0,0))
    self.emitter_:setGravity(cc.p(0,1.58))
    self.emitter_:setRadialAccel(107.4)
    self.emitter_:setSpeedVar(227.8)
    self.emitter_:setBlendFunc(gl.SRC_ALPHA,gl.ONE)

    local locX,locY = 15,15
    self.emitter_:setPosition(cc.p(locX, locY))  
    self.labelHuxi_:addChild(self.emitter_,102)
end

function PlayerView:onPaoChanged_(event)
    if not event.card then
        return
    end
    if self:isHost() then
        self.paperCardList_:removeHandCards({event.card,event.card,event.card,event.card})
    end  
    self:doPaoPai(event.card,event.index, event.isReConnect, event.inFastMode)
end 

function PlayerView:doPaoPai(card,index,isReConnect,inFastMode)
    local seconds = 0.3 
    local cards = {card,card,card,card}
    local x, y, showIndex, scale = self:calcZhuomianPaiPos_(#cards, #self.nodeZhuomianPai_:getChildren())
    local mingpai  = #cards
    local zkans = self.nodeZhuomianPai_:getChildren()

   --其他情况都是找到坎增加牌 
  if index > 0 and #zkans >= index then
        local kan = zkans[index]
        kan:reSetCards(cards, mingpai, false, nil, nil, nil)
        kan:setCardsType({CTYPE_PAO,card,card,card,card})
        self:updateZhuomianHuxi() 

        if not inFastMode then
            self:playPaoAnim() 
        end
        return
    end
   --没有找到的话那就

    if inFastMode then
        --todo
        local kan = app:createConcreteView("TableKanView", cards,mingpai,false,nil,nil, #self.nodeZhuomianPai_:getChildren()):addTo(self.nodeZhuomianPai_, showIndex):pos(x,y)
        kan:setScale(2)
        kan:setCardsType({CTYPE_PAO,card,card,card,card})
        self:updateZhuomianHuxi() 
        return
    end

    self:playPaoAnim()

    local orgX, orgY = 0,0
    if self.nowSeats_ ~= 2 then
         orgX, orgY = unpack(curCardPos[self.index_])
    else
        if self.index_ == 2 then
             orgX, orgY = unpack(curCardPos[self.index_ + 1])
        else
             orgX, orgY = unpack(curCardPos[self.index_])
        end
    end    
    local py = OP_Y - OP_INTERRVAL * 3
    local aniKan = app:createConcreteView("KanView", cards,nil,false,nil,nil, #self.nodeZhuomianPai_:getChildren()):addTo(self.nodeAni_, showIndex):pos(OP_X,py+150)
    aniKan:showHuXi(false)
    aniKan:setScale(0.8)
    local mtime = 0.3 
    local anix,aniy = self:calcZhuomianPaiAniPos_()
    local action1 = cc.MoveTo:create(mtime, cc.p(anix,aniy))
    local action2 = cc.ScaleTo:create(mtime, 0.1)    
    local action3 = cc.FadeOut:create(mtime)
    local action4 =   cc.CallFunc:create(function ()
            local kan = app:createConcreteView("TableKanView", cards,mingpai,false,nil,nil, #self.nodeZhuomianPai_:getChildren()):addTo(self.nodeZhuomianPai_, showIndex):pos(x,y)
            kan:setCardsType({CTYPE_PAO,card,card,card,card})
            self:updateZhuomianHuxi() 
            aniKan:removeFromParent()
          end)
    aniKan:runAction(cc.Sequence:create(cc.Spawn:create(action1,action2,action3),action4))--cc.Sequence:create循序执行多个动作
end

function PlayerView:onWeiChanged_(event) 
    if not event.card then
        return
    end
    if self:isHost() then
        self.paperCardList_:removeHandCards({event.card,event.card})
    end  
    self:doWeiPai(event.card,event.isChou, event.isReConnect, event.inFastMode)
end

function PlayerView:doWeiPai(card,isChou,isReConnect,inFastMode)
    local seconds = 0.3 
    local cards = {card,card,card}
    local x, y, showIndex, scale = self:calcZhuomianPaiPos_(#cards, #self.nodeZhuomianPai_:getChildren())
    local mingpai  = 1
    if isChou == 1 then
        mingpai = 1
    end
    if inFastMode then
        local tempkan = app:createConcreteView("TableKanView", cards,mingpai,nil,nil,nil, #self.nodeZhuomianPai_:getChildren()):addTo(self.nodeZhuomianPai_, showIndex):pos(x,y)
        tempkan:setCardsType({CTYPE_WEI,card,card,card})
        self:updateZhuomianHuxi() 
        return
    end

    self:playWeiAnim()
    local wy = OP_Y - OP_INTERRVAL * 3
    local orgX, orgY = 0,0
    if self.nowSeats_ ~= 2 then
         orgX, orgY = unpack(curCardPos[self.index_])
    else
        if self.index_ == 2 then
             orgX, orgY = unpack(curCardPos[self.index_ + 1])
        else
             orgX, orgY = unpack(curCardPos[self.index_])
        end
    end    
    local tmpCard = app:createConcreteView("PaperCardView", 0, 1, false, nil):addTo(self.nodeChuPai_):pos(orgX,orgY)
    local mtime = 0.2
    transition.execute(tmpCard, cc.FadeOut:create(0), {
        easing = "",
        onComplete = function()
            local aniKan = app:createConcreteView("KanView", {card,0,0},nil,false,nil,nil, #self.nodeZhuomianPai_:getChildren()):addTo(self.nodeAni_, showIndex):pos(OP_X,wy+150)
            aniKan:showHuXi(false) 
            local mtime = 0.5 
            local anix,aniy = self:calcZhuomianPaiAniPos_()
            local actionDelay = cc.DelayTime:create(0.5)
            local action1 = cc.MoveTo:create(mtime, cc.p(anix,aniy))
            local action2 = cc.ScaleTo:create(mtime, 0.1)    
            local action3 = cc.FadeOut:create(mtime)
            local action4 =   cc.CallFunc:create(function ()
                    local tempkan = app:createConcreteView("TableKanView", cards,mingpai,nil,nil,nil, #self.nodeZhuomianPai_:getChildren()):addTo(self.nodeZhuomianPai_, showIndex):pos(x,y)
                    tempkan:setCardsType({CTYPE_WEI,card,card,card})
                    self:updateZhuomianHuxi() 
                    aniKan:removeFromParent()
                  end)
            aniKan:runAction(cc.Sequence:create(cc.Spawn:create(actionDelay,action1,action2,action3),action4))--cc.Sequence:create循序执行多个动作
        end,
    })
end

function PlayerView:doChouWeiPai(cards,isReConnect,inFastMode)
    local seconds = 0.3 
    local x, y, showIndex, scale = self:calcZhuomianPaiPos_(#cards, #self.nodeZhuomianPai_:getChildren())
    local mingpai  = 1

    local wy = OP_Y - OP_INTERRVAL * 3
    local kan = app:createConcreteView("TableKanView", cards,mingpai,false,nil,nil, #self.nodeZhuomianPai_:getChildren()):addTo(self.nodeZhuomianPai_, showIndex):pos(x,y)

    local point = kan:getParent():convertToWorldSpace(cc.p(x, y))
    kan:setCardsType({CTYPE_CHOU_WEI,card,card,card})
    self:playWeiAnim()
    self:updateZhuomianHuxi()
end

function PlayerView:onChiChanged_(event) 
    if not event.chiPai or 0 == #event.chiPai then
        return
    end
    print("====onChiChanged_======")
    if self:isHost() then
        --吃牌 移除除第一张牌之外其他牌
        local delCards = {}
        for k,v in pairs(event.chiPai) do
            table.insert(delCards,v)
        end 
        for _,cards in ipairs(event.biPai) do
            for k,v in pairs(cards) do
                table.insert(delCards,v)
            end
        end
        self.paperCardList_:removeHandCards(delCards)
    end  
    self:doChiPai(event.chiPai,event.biPai,event.card, event.isReConnect, event.inFastMode)
end

function PlayerView:onZhuoPaiChanged_(event)
    if not event.cards then
        return
    end
    self.nodeZhuomianPai_:removeAllChildren()
    local seconds = 0.3 
    local mingpai  = 3
    local cards = checktable(event.cards)
    for i,v in ipairs(cards) do
        local tmpCards = clone(v)
        local  cardType = tmpCards[1]
        table.remove(tmpCards,1)
        local cardChi = tmpCards[1]
        table.remove(tmpCards,1)
        table.sort(tmpCards)
        table.insert(tmpCards, 1, cardChi)
        local mingpai = 0
        if(cardType == CTYPE_TI) then
            mingpai = 1
        elseif(cardType == CTYPE_PAO)then
            mingpai = 4
        elseif(cardType == CTYPE_WEI)then
            mingpai = 1
        elseif(cardType == CTYPE_CHOU_WEI)then
            mingpai = 1
        elseif(cardType >= 1 and cardType <= 4) then
            mingpai = 3
        end
        local x1, y1, showIndex, scale = self:calcZhuomianPaiPos_(#v, #self.nodeZhuomianPai_:getChildren())
        local kan = app:createConcreteView("TableKanView", tmpCards, mingpai, false, nil, nil, #self.nodeZhuomianPai_:getChildren()):addTo(self.nodeZhuomianPai_, showIndex):pos(x1,y1)
        kan:setCardsType(v)
    end
    self:updateZhuomianHuxi(true)
end


function PlayerView:onResumeChuPai(event)    
    if not event.cards then
        return
    end
    local seconds = 0.3 
    local mingpai  = 3
    local cards = checktable(event.cards)

    self.threwCards = clone(cards)
    local index = 0
    for i,v in ipairs(cards) do
        index = index + 1
        local x,y = self:getThrewPaiPos(index) 
        local tmp= app:createConcreteView("PaperCardView", v, 3, false, nil):addTo(self.nodeChuPai_):pos(x,y, 100)
        tmp:setScale(1.2)
    end
end

function PlayerView:doChiPai(chiPai,biPai,card,isReConnect,inFastMode)
    local seconds = 0.3 
    local tempChi = clone(chiPai)
    local tempBi = clone(biPai)
    -- table.insert(chiPai,1,card)
    local x, y, showIndex, scale = self:calcZhuomianPaiPos_(#chiPai, #self.nodeZhuomianPai_:getChildren())

    local mingpai  = 3
    local movKan = {}

    if inFastMode then
        local kan = app:createConcreteView("TableKanView", chiPai,mingpai,false,nil,nil, #self.nodeZhuomianPai_:getChildren()):addTo(self.nodeZhuomianPai_, showIndex):pos(x,y)
        kan:setCardsType({BaseAlgorithm.getCtypeOfThree(clone(chiPai)),chiPai[1],chiPai[2],chiPai[3]})
        for i,v in ipairs(biPai) do
            local x1, y1, showIndex, scale = self:calcZhuomianPaiPos_(#v, #self.nodeZhuomianPai_:getChildren())
            local kan = app:createConcreteView("TableKanView", v,mingpai,false,nil,nil, #self.nodeZhuomianPai_:getChildren()):addTo(self.nodeZhuomianPai_, showIndex):pos(x1,y1)
            kan:setCardsType({BaseAlgorithm.getCtypeOfThree(v),v[1],v[2],v[3]})
        end
        self:updateZhuomianHuxi()  
        return
    end

    self:playChiAnim()
    local cy = OP_Y - OP_INTERRVAL * 3
    local aniKan = app:createConcreteView("KanView", chiPai,nil,false,nil,nil, #self.nodeZhuomianPai_:getChildren()):addTo(self.nodeAni_, showIndex):pos(OP_X,cy+150)
    aniKan:showHuXi(false)
    aniKan:setScale(0.8)
    --牌从中间运动到目标位置 
    local mtime = 0.0382 
    local anix,aniy = self:calcZhuomianPaiAniPos_()
    local actionDelay = cc.DelayTime:create(0.382)
    local action1 = cc.MoveTo:create(mtime, cc.p(anix,aniy))
    local action2 = cc.ScaleTo:create(mtime, 0.1)    
    local action3 = cc.FadeOut:create(mtime)
    local action4 =   cc.CallFunc:create(function ()
            local kan = app:createConcreteView("TableKanView", tempChi,mingpai,false,nil,nil, #self.nodeZhuomianPai_:getChildren()):addTo(self.nodeZhuomianPai_, showIndex):pos(x,y)
            kan:setCardsType({BaseAlgorithm.getCtypeOfThree(clone(chiPai)),tempChi[1],tempChi[2],tempChi[3]})
            self:updateZhuomianHuxi() 
            aniKan:removeFromParent()
          end)
    aniKan:runAction(cc.Sequence:create(actionDelay,cc.Spawn:create(action1,action2,action3),action4))--cc.Sequence:create循序执行多个动作
    --牌从中间运动到目标位置 
    local mtime = 0.1 
    local offset = 0
    for i,v in ipairs(biPai) do
        offset = offset + 70
        local aniKan = app:createConcreteView("KanView", clone(v),nil,false,nil,nil, #self.nodeZhuomianPai_:getChildren()):addTo(self.nodeAni_, showIndex):pos(OP_X+offset, cy+150)
        aniKan:showHuXi(false)
        aniKan:setScale(0.8)
            --牌从中间运动到目标位置 
            local mtime = 0.0382
            local anix,aniy = self:calcZhuomianPaiAniPos_()
            local actionDelay = cc.DelayTime:create(0.382)
            local action1 = cc.MoveTo:create(mtime, cc.p(anix,aniy))
            local action2 = cc.ScaleTo:create(mtime, 0.1)    
            local action3 = cc.FadeOut:create(mtime)
            local action4 =   cc.CallFunc:create(function ()    
                    local tempV = clone(v) 
                    local x1, y1, showIndex, scale = self:calcZhuomianPaiPos_(#v, #self.nodeZhuomianPai_:getChildren())
                    local kan = app:createConcreteView("TableKanView", tempV,mingpai,false,nil,nil, #self.nodeZhuomianPai_:getChildren()):addTo(self.nodeZhuomianPai_, showIndex):pos(x1,y1)
                    kan:setCardsType({BaseAlgorithm.getCtypeOfThree(clone(v)),tempV[1],tempV[2],tempV[3]})
                    self:updateZhuomianHuxi() 
                    aniKan:removeFromParent()
                  end)
            aniKan:runAction(cc.Sequence:create(actionDelay,cc.Spawn:create(action1,action2,action3),action4))--cc.Sequence:create循序执行多个动作
    end
end

function PlayerView:moveOperateCardFromHand(OperateCard,delfun)
    local mtime = 0.3

    local x, y, showIndex, scale = self:calcZhuomianPaiPos_(#cards, #self.nodeZhuomianPai_:getChildren())
    local toPoint =  self:convertToWorldSpace(cc.p(x, y))
    transition.moveTo(OperateCard, {x = x, y = y, time = mtime})
    local scaleRawX, scaleRawY = self.currCard:getScaleX(), self.currCard:getScaleY()
    local multiX, multiY = scaleRawX / math.abs(scaleRawX), scaleRawY / math.abs(scaleRawY)
    transition.scaleTo(OperateCard, {scaleX = 0.5 * multiX, scaleY = 0.5 * multiY, time = mtime})

    transition.fadeOut(OperateCard, {time = mtime}) 

    OperateCard:performWithDelay(function ()
       delfun()
    end, mtime * 1.1)
end
 
function PlayerView:onPengChanged_(event) 
    if not event.card then
        return
    end
    self:doPengPai(event.card, event.isReConnect, event.inFastMode)
end 

--碰牌传入操作牌，牌组
function PlayerView:doPengPai(card,isReConnect,inFastMode)
    local seconds = 0.3 
    local x, y, showIndex, scale = self:calcZhuomianPaiPos_(3, #self.nodeZhuomianPai_:getChildren())
    print("=========doPengPai=============")
    local mingpai  = 3
    if self:isHost() then
        --吃牌 移除除第一张牌之外其他牌
        self.paperCardList_:removeHandCards({card,card})
    end  

    if inFastMode then
        --todo
        local kan = app:createConcreteView("TableKanView", {card,card,card},mingpai,false,nil,nil, #self.nodeZhuomianPai_:getChildren()):addTo(self.nodeZhuomianPai_, showIndex):pos(x,y) 
        kan:setCardsType({CTYPE_PENG,card,card,card})
        self:updateZhuomianHuxi()
        return
    end

    local py = OP_Y - OP_INTERRVAL * 3
    self:playPengAnim() 
    local aniKan = app:createConcreteView("KanView", {card,card,card},nil,false,nil,nil, #self.nodeZhuomianPai_:getChildren()):addTo(self.nodeAni_, showIndex):pos(OP_X,py+150)
    aniKan:showHuXi(false)
    aniKan:setScale(0.8)
    --牌从中间运动到目标位置 
    local mtime = 0.3 
    --牌从中间运动到目标位置 
    local mtime = 0.0382 
    local anix,aniy = self:calcZhuomianPaiAniPos_()
    local actionDelay = cc.DelayTime:create(0.382)
    local action1 = cc.MoveTo:create(mtime, cc.p(anix,aniy))
    local action2 = cc.ScaleTo:create(mtime, 0.1)    
    local action3 = cc.FadeOut:create(mtime)
    local action4 =   cc.CallFunc:create(function ()   
            local kan = app:createConcreteView("TableKanView", {card,card,card},mingpai,false,nil,nil, #self.nodeZhuomianPai_:getChildren()):addTo(self.nodeZhuomianPai_, showIndex):pos(x,y) 
            kan:setCardsType({CTYPE_PENG,card,card,card})
            self:updateZhuomianHuxi() 
            aniKan:removeFromParent()
          end)
    aniKan:runAction(cc.Sequence:create(actionDelay,cc.Spawn:create(action1,action2,action3),action4))--cc.Sequence:create循序执行多个动作
end

function PlayerView:onTiChanged_(event) 
    if not event.card then
        return
    end
    if self:isHost() then
        self.paperCardList_:removeHandCards({event.card,event.card,event.card,event.card})
    end  
    self:doTiPai(event.card,event.index, event.isReConnect, event.inFastMode)
end

function PlayerView:onFirstTiChanged_(event) 
    if not event.cards then
        print("not event.cards onfi=rstTiChanged_")
        return
    end
    if self:isHost() then  
        local delCards = {}
        for _,card in ipairs(event.cards) do
            for i=1,4 do
                table.insert(delCards,card)
            end
        end
        self.paperCardList_:removeHandCards(delCards)
    end  
    self:doFirstTiPai(event.cards)
end

function PlayerView:doFirstTiPai(cards)
    local seconds = 0.3 
    local x, y, showIndex, scale = self:calcZhuomianPaiPos_(#cards, #self.nodeZhuomianPai_:getChildren())
    local mingpai  = 1

     for i,card in ipairs(cards) do
        local tiCards = {card,card,card,card}
        local x1, y1, showIndex, scale = self:calcZhuomianPaiPos_(tiCards, #self.nodeZhuomianPai_:getChildren())
        local kan = app:createConcreteView("TableKanView", tiCards,mingpai,false,nil,nil, #self.nodeZhuomianPai_:getChildren()):addTo(self.nodeZhuomianPai_, showIndex):pos(x1,y1)
        kan:setCardsType({CTYPE_TI,card,card,card,card})
        self:updateZhuomianHuxi() 
    end
    self:playTiAnim()  
end

function PlayerView:doTiPai(card,index,isReConnect,inFastMode)
    local seconds = 0.3 
    local cards = {card,card,card,card}
    local x, y, showIndex, scale = self:calcZhuomianPaiPos_(#cards, #self.nodeZhuomianPai_:getChildren())
    local mingpai  = 1
    local zkans = self.nodeZhuomianPai_:getChildren()
    if index > 0 and #zkans >= index then
        local kan = zkans[index]
        kan:reSetCards(cards, mingpai, false, nil, nil, nil)
        -- kan:addCard(card,1,false)
        kan:setCardsType({CTYPE_TI,card,card,card,card})
        self:updateZhuomianHuxi() 
        self:playTiAnim() 
        return
    end
    if inFastMode then
        --todo
        local kan = app:createConcreteView("TableKanView", cards,mingpai,false,nil,nil, #self.nodeZhuomianPai_:getChildren()):addTo(self.nodeZhuomianPai_, showIndex):pos(x,y)
        kan:setCardsType({CTYPE_TI,card,card,card,card})
        self:updateZhuomianHuxi() 
        return
    end
    self:playTiAnim()  
    local orgX, orgY = 0,0
    if self.nowSeats_ ~= 2 then
         orgX, orgY = unpack(curCardPos[self.index_])
    else
        if self.index_ == 2 then
             orgX, orgY = unpack(curCardPos[self.index_ + 1])
        else
             orgX, orgY = unpack(curCardPos[self.index_])
        end
    end    
    local tmpCard = app:createConcreteView("PaperCardView", 0, 1, false, nil):addTo(self.nodeChuPai_):pos(orgX,orgY)
    local mtime = 0.1
    local ty = OP_Y - OP_INTERRVAL * 3
    transition.execute(tmpCard, cc.FadeOut:create(0.1), {
        easing = "",
        onComplete = function()
            local aniKan = app:createConcreteView("KanView", {card,0,0,0},nil,false,nil,nil, #self.nodeZhuomianPai_:getChildren()):addTo(self.nodeAni_, showIndex):pos(OP_X,ty+150)
            aniKan:showHuXi(false)
            aniKan:setScale(0.8)
            --牌从中间运动到目标位置 
            local mtime = 0.3 
            local anix,aniy = self:calcZhuomianPaiAniPos_()
            local action1 = cc.MoveTo:create(mtime, cc.p(anix,aniy))
            local action2 = cc.ScaleTo:create(mtime, 0.1)    
            local action3 = cc.FadeOut:create(mtime)
            local action4 =   cc.CallFunc:create(function ()
                    local kan = app:createConcreteView("TableKanView", cards,mingpai,false,nil,nil, #self.nodeZhuomianPai_:getChildren()):addTo(self.nodeZhuomianPai_, showIndex):pos(x,y)
                    kan:setCardsType({CTYPE_TI,card,card,card,card})
                    self:updateZhuomianHuxi() 
                    aniKan:removeFromParent()
                  end)
            aniKan:runAction(cc.Sequence:create(cc.Spawn:create(action1,action2,action3),action4))--cc.Sequence:create循序执行多个动作
        end,
    })
end

function PlayerView:playChiPaiAnim_(kan, x, y, seconds, isReConnect, inFastMode)
    local scaleFrom, scaleTo, rotation = 1.5, 0.6, 8
    local rotate = math.random(-rotation, rotation)
    kan:pos(x, y)
    -- poker:setRotation(rotate)
    if isReConnect or inFastMode then
        kan:scale(scaleTo)
    else
        kan:scale(scaleFrom)
        transition.scaleTo(kan, {scale = scaleTo, time = seconds, easing = "bounceOut"})
    end
end
function PlayerView:playChuPaiAnim_(poker, x, y, seconds, isReConnect, inFastMode)
    local scaleFrom, scaleTo, rotation = 1.5, 0.6, 8
    local rotate = math.random(-rotation, rotation)
    poker:pos(x, y)
    poker:setRotation(rotate)
    if isReConnect or inFastMode then
        poker:scale(scaleTo)
    else
        poker:scale(scaleFrom)
        transition.scaleTo(poker, {scale = scaleTo, time = seconds, easing = "bounceOut"})
    end
end

-- 回合开始清理
function PlayerView:roundStartClear_()
    if self.paperCardList_ then
        self.paperCardList_:removeAllPokers()
    end
    self.currCard = nil
    self.threwCards = {}
    self.nodeChuPai_:removeAllChildren()
    self.nodeZhuomianPai_:removeAllChildren()
    self.labelHuxi_:setString(0)
    self.lasthuxi_ = 0
    self.nodehuxi:setVisible(true)
end

-- 出牌的动画
function PlayerView:showChuPaiAnim_(card)
    local paperCardList = self:getHandPokerNode_() 
    local nodes
    if paperCardList then
        nodes= self:getHandPokerNode_():getChildren()
    end 
    local total = 0
    if nodes then
        total = table.nums(nodes)
    end
    local x, y, z = self:calcMaJiangPos_(total, total)
    local delObj = self:getRemoveMaJiang_(card)
    if delObj then
        x, y = delObj:getPosition()
    end
    local obj = app:createConcreteView("PaperCardView", card, 1):addTo(self.nodeAnims_)
    obj:pos(x, y)
    local toX, toY = unpack(CHU_PAI_ANIM_POS[self.index_])
    local seconds = 0.3
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

local ACTION_ANIM_POS = {
    {display.cx, 432 / DESIGN_HEIGHT * display.height},
    {display.fixRight * 600 / DESIGN_WIDTH, display.height * 880 / DESIGN_HEIGHT},
    {display.fixRight * 187.5 / DESIGN_WIDTH, display.height * 880 / DESIGN_HEIGHT},
}

-- 展示玩家的动作动画
function PlayerView:showActionAnim_(spriteName,moveEnable,callback)
    local toX, toY = unpack(ACTION_ANIM_POS[self.index_])
    local params = nil
    if moveEnable then
        params = {}
        local ox, oy = unpack(OFFSET_OF_SEATS_4[self.index_])
        params.toX = ox
        params.toY = oy
        params.onComplete = callback
    end
    local actionAnim = app:createConcreteView("game.ActionAnim", spriteName,params):addTo(self.nodeAnims_):pos(toX, toY)
    actionAnim:run()
end

function PlayerView:HuAnim()
    self:setCascadeOpacityEnabled(true)

    local seconds1, seconds2 = 0.3, 1

    local long_guang = display.newSprite("#longguang.png"):addTo(self)
    local light1 = BaseAlgorithm.createPingPongLight(seconds1, 1.01, 0.99)
    long_guang:runAction(light1)
    display.newSprite("#long.png"):addTo(self)

    local hu_guang = display.newSprite("#huguang.png"):addTo(self):pos(-10, 20)
    hu_guang:setVisible(false)

    local hu = display.newSprite("#hu.png"):addTo(self):pos(-10, 20)
    hu:pos(-20, 80)
    hu:setScale(2.5)
    hu:setOpacity(0.7 * 255)

    local function showHuLight()
        local light2 = BaseAlgorithmdo.createPingPongLight(seconds1, 1.02, 0.98)
        hu_guang:runAction(light2)
        hu_guang:setVisible(true)
    end

    transition.execute(hu, cc.scale:create(seconds1 * 2, 1), {
        easing = "bounceOut",
        onComplete = showHuLight
    })
    transition.moveTo(hu, {x = -10, y = 20, time = seconds1})
    transition.fadeTo(hu, {opacity = 255, time = seconds1})

    transition.execute(self, cc.FadeTo:create(seconds1, 0), {
        delay = seconds2,
        easing = "out",
        onComplete = function()
            self:removeSelf()
        end,
    })
end

function PlayerView:onHandCardRemoved_(event)
    -- self:removeHandMaJiang_(event.card)
    self.paperCardList_:removeAllPokers()
end

function PlayerView:getLastChuPaiPos()
    local nodes = self.nodeChuPai_:getChildren()
    if not nodes or #nodes < 1 then
        return self:calcChuPaiPos_(1, 1)
    end
    return self:calcChuPaiPos_(#nodes, #nodes)
end

function PlayerView:calcChuPaiPos_(total, index)
    local direction = nil
    if self.nowSeats_ == 2 then
        direction = TABLE_DIRECTION2
    else
        direction = TABLE_DIRECTION
    end
    if direction.BOTTOM == self.index_ then
        return self:calcChuPaiPosBottom_(total, index)
    elseif direction.RIGHT == self.index_ then
        return self:calcChuPaiPosRight_(total, index)
    else
        return self:calcChuPaiPosLeft_(total, index)
    end
end

function PlayerView:calcChuPaiPosBottom_(total, index)
    local majiang_width = 62
    local majiang_width = MA_JIANG_DAO_WIDTH[self.index_] * BOTTOM_CHU_PAI_SCALE
    local offset = (index - (total - 1) / 2 - 1) * majiang_width

    local x,y = unpack(CHU_PAI_POS[self.index_])

    local x = display.fixRight + offset - 100
    local y = 470
    return x, y, index, CHU_PAI_SCALE
end

--出牌位置
function PlayerView:calcChuPaiPosRight_(total, index)
    local majiang_width = 62
    majiang_width = majiang_width * CHU_PAI_SCALE
    local x = 0
    local y = 0
    if total > CHU_PAI_LINE_LENGTH then
        x = (display.fixRight - majiang_width * CHU_PAI_LINE_LENGTH) / 2 + (index - 1) % CHU_PAI_LINE_LENGTH * majiang_width + 200
        y = display.height * 180 / DESIGN_HEIGHT - math.floor((index - 1) / CHU_PAI_LINE_LENGTH) * 44 + 480
    else
        local offset = (index - (total - 1) / 2 - 1) * majiang_width
        x = display.fixRight + offset - 100
        y = 950
    end
    return x, y, index, CHU_PAI_SCALE
end

function PlayerView:calcChuPaiPosLeft_(total, index)
    local majiang_width = 62
    majiang_width = majiang_width * CHU_PAI_SCALE
    local x = 0
    local y = 0
    if total > CHU_PAI_LINE_LENGTH then
        x = (display.fixRight - majiang_width * CHU_PAI_LINE_LENGTH) / 2 + (index - 1) % CHU_PAI_LINE_LENGTH * majiang_width - 400
        y = display.height * 180 / DESIGN_HEIGHT - math.floor((index - 1) / CHU_PAI_LINE_LENGTH) * 44 + 480
    else
        local offset = (index - (total - 1) / 2 - 1) * majiang_width
        x = display.fixLeft + offset + 100
        y = 950
    end
    return x, y, index, CHU_PAI_SCALE
end

function PlayerView:getLastZhuomianPaiPos()
    local nodes = self.nodenodeZhuomianPai__:getChildren()
    if not nodes or #nodes < 1 then
        return self:calcChuPaiPos_(1, 1)
    end
    return self:calcChuPaiPos_(#nodes, #nodes)
end
 
function PlayerView:calcZhuomianPaiPos_(total, index)
    local direction = nil
    if self.nowSeats_ == 2 then
        direction = TABLE_DIRECTION2
    else
        direction = TABLE_DIRECTION
    end
    if direction.BOTTOM == self.index_ then
        return self:calcZhuomianPaiPosBottom_(total, index)
    elseif direction.RIGHT == self.index_ then
        return self:calcZhuomianPaiPosRight_(total, index)
    else
        return self:calcZhuomianPaiPosLeft_(total, index)
    end
end 

local adjust_interval = 13
function PlayerView:calcZhuomianPaiAniPos_(total, index)
    local x,y = unpack(ZHUOMIAN_PAI_ANI_POS[self.index_])
    local width = 48 - adjust_interval
    local count = index or #self.nodeZhuomianPai_:getChildren()
    local direction = nil
    if self.nowSeats_ == 2 then
        direction = TABLE_DIRECTION2
    else
        direction = TABLE_DIRECTION
    end
    if direction.BOTTOM == self.index_ then
        return width * count + x,y
    elseif direction.RIGHT == self.index_ then
        return -width * count + x,y
    else            
        return width * count + x,y
    end

    return x,y
end 

function PlayerView:calcZhuomianPaiPosBottom_(total, index)
    local majiang_width = 40 - adjust_interval
    local offset = index * majiang_width * 1.1
    local x,y = 0,0
    if self.nowSeats_ ~= 2 then
        x,y = unpack(ZHUOMIAN_PAI_POS[self.index_])
    else
        if self.index_ == 2 then
            x,y = unpack(ZHUOMIAN_PAI_POS2[self.index_ + 1])
        else
            x,y = unpack(ZHUOMIAN_PAI_POS2[self.index_])
        end
    end
    local x = x + offset+display.fixLeft
    return x, y, index, CHU_PAI_SCALE
end

--出牌位置
function PlayerView:calcZhuomianPaiPosRight_(total, index)
    local majiang_width = 40 - adjust_interval
    local offset = index  * majiang_width * 1.1
    local x,y = 0,0
    if self.nowSeats_ ~= 2 then
        x,y = unpack(ZHUOMIAN_PAI_POS[self.index_])
    else
        if self.index_ == 2 then
            x,y = unpack(ZHUOMIAN_PAI_POS2[self.index_ + 1])
        else
            x,y = unpack(ZHUOMIAN_PAI_POS2[self.index_])
        end
    end
    local x = x - offset  
    return x, y, index, CHU_PAI_SCALE
end

function PlayerView:calcZhuomianPaiPosLeft_(total, index)
    local majiang_width = 40 - adjust_interval
    local offset = index * majiang_width * 1.1
    local x,y = 0,0
    if self.nowSeats_ ~= 2 then
        x,y = unpack(ZHUOMIAN_PAI_POS[self.index_])
    else
        if self.index_ == 2 then
            x,y = unpack(ZHUOMIAN_PAI_POS2[self.index_ + 1])
        else
            x,y = unpack(ZHUOMIAN_PAI_POS2[self.index_])
        end
    end
    local x = x + offset
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
    local boom = display.newSprite(frames[1]):addTo(self.nodeAnims_):pos(x, y)
    local spriteCtype = display.newSprite(string.format("#ctype%d.png", ctype)):addTo(self.nodeAnims_):pos(x, y)
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
        return self.paperCardList_
    end
end

function PlayerView:canChuPai_()
    if not dataCenter:isSocketReady() then
        return false
    end
    if not dataCenter:getPokerTable():isMyTurn(self.player_:getSeatID()) then
        return false
    end
    return true
end

function PlayerView:getPlayerPosition()
    local index = self.index_
    assert(index > 0 and index < 10)
    if self.nowSeats_ ~= 2 then
        return unpack(OFFSET_OF_SEATS_4[index])
    else
        if index == 2 then
            return unpack(OFFSET_OF_SEATS_4[index + 1])
        else
            return unpack(OFFSET_OF_SEATS_4[index])
        end
    end
end

-- cc.BezierTo:create(time，{cc.p(x, y), cc.p(x1, y1), cc.p(x2, y2)})
function PlayerView:adjustSeatPos_(index, withAction)
    local moveTime = 0.5
    local x, y = self:getPlayerPosition()
    print("=======adjustSeatPos_(index, w===========",x,y)
    -- if withAction then
    --     transition.moveTo(self.nodePlayer_, {x = x, y = y, time = moveTime, easing = "exponentialOut"})
    --     transition.moveTo(self.nodeFlags_, {x = x, y = y, time = moveTime, easing = "exponentialOut"})
    -- else
        self.nodePlayer_:pos(x, y)
        self.nodeFlags_:pos(x, y)
        if self.nodeOffline_ then
            self.nodeOffline_:pos(x, y)
        end
    -- end
    self:initReadyPos_()
    self:initPosByIndex_()

    --桌牌位置
    local zhuoKans = self.nodeZhuomianPai_:getChildren()
    for i,v in ipairs(zhuoKans) do
        local x, y, showIndex, scale = self:calcZhuomianPaiPos_(#v:getCards(), v:getTableIndex())
        v:setPosition(x, y)
    end

    -- 出牌
    local seconds = 0.3 
    local mingpai  = 3
    self.nodeChuPai_:removeAllChildren()
    local index = 0
    for i,v in ipairs(self.threwCards) do
        index = index + 1
        local x,y = self:getThrewPaiPos(index)
        local tmp= app:createConcreteView("PaperCardView", v, 3, false, nil):addTo(self.nodeChuPai_):pos(x,y, 100)
    end
end

function PlayerView:onIndexChanged_(event)
    self.index_ = event.index
    self:adjustSeatPos_(self.index_, event.withAction)
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

function PlayerView:onHandCardsChanged_(event)
    if not self:isHost() then
        return
    end
    self.paperCardList_:showPokers(event.cards, nil, event.isRconnect)
end

function PlayerView:onShouZhang_(event)
    --将当前牌收入手牌
    self.paperCardList_:shouzhang(event.card, event.isReview)
end

function PlayerView:onDealCards_(event)
    if not self:isHost() then
        -- local selfuid = self.player_:getUid()
        -- local hostid = dataCenter:getHostPlayer():getUid()
        return
    end
    self.paperCardList_:dealCards(event.cards)
end

function PlayerView:onPokerFound_(event)
    local card = event.card
    -- local x, y, z = self:calcMoPaiPos_(isDown)
    -- self:createMaJiangWithTouch_(card, #self.player_:getCards(), x, y, z, isDown, true)
    gameAudio.playSound("sounds/common/sound_deal_card.mp3")
end

function PlayerView:setScoreWithRoller_(score, fromScore)
    print("setScoreWithRoller_",score, fromScore)
    self.score = score
    local clockScore = display.getRunningScene():getLockScore()
    fromScore = fromScore or score
    NumberRoller:run(self.labelScore_, fromScore+clockScore, score+clockScore)
end

function PlayerView:setScore(score)
    self.score = self.score or 0
    score = score + self.score
    NumberRoller:run(self.labelScore_, score, score)
end

function PlayerView:setNickName(name)
    self.labelNickName_:setString(name)
end

function PlayerView:setPlayerChildrenVisible(flag)
    local children = self.nodePlayer_:getChildren()
    for _,v in pairs(children) do
        if v ~= self.spriteOffline_  and  v ~= self.voiceQiPao_ and v ~= self.qipai_text_ and v ~= self.daniao_text_ then
            v:setVisible(flag or false)
        end
    end
end

function PlayerView:clearAllPokers_()
    self.nodeChuPai_:removeAllChildren()
    -- if self.paperCardList_ then
    --     self.paperCardList_:removeAllPokers()
    -- end
end

------------- 一系列的响应状态变化而改变view的函数，下划线后面都是player model里面的状态 ---------------
function PlayerView:onPlayStateChanged_(opacity)
    if opacity and opacity >= 0 and opacity <= 255 then
        self:setOpacity(opacity)
    end
    self:setPlayerChildrenVisible(true)
end

function PlayerView:onStateIdle_(event)
    self:setPlayerChildrenVisible(false)
    self:setOpacity(255)
    self:clearAllPokers_()
    self.spriteReady_:hide()
end


function PlayerView:onStateReady_(event)
    print("onstageredy clear")
    self:hideAllFlags_()
    self:clearAllPokers_()
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
    self:clearAllPokers_()
    self.spriteReady_:hide()
    self.spriteZhuanquan_:hide()
    transition.pauseTarget(self.spriteZhuanquan_)
end

function PlayerView:onStateCheckout_(event)
    print("onStateCheckout_(event)")
    self.spriteZhuanquan_:hide()
    transition.pauseTarget(self.spriteZhuanquan_)
end

function PlayerView:onStateWaitCall_(event)
    self:onPlayStateChanged_(255)
    self.isCtypeShowDown_ = false
    self.spriteReady_:hide()
    self.spriteZhuanquan_:hide()
    transition.pauseTarget(self.spriteZhuanquan_)
end

function PlayerView:onStateThinking_(event)
    self:onPlayStateChanged_(255)
    self.spriteReady_:hide()
    local seconds = checknumber(event.args[1])
    if self:isHost() then
        -- gameAudio.playSound("turnto.mp3")
    end
    self.spriteZhuanquan_:show()
    transition.resumeTarget(self.spriteZhuanquan_)
end

function PlayerView:onStateTianhuthinking_(event)
    self:onPlayStateChanged_(255)
    self.spriteReady_:hide()
    local seconds = checknumber(event.args[1])
    if self:isHost() then
        -- gameAudio.playSound("turnto.mp3")
    end
    self.spriteZhuanquan_:show()
    transition.resumeTarget(self.spriteZhuanquan_)
end

function PlayerView:onStateChuPaiThinking_(event)
    self:onPlayStateChanged_(255)
    self.spriteReady_:hide()
    local seconds = checknumber(event.args[1])
    if self:isHost() then
        -- gameAudio.playSound("turnto.mp3")
    end
    self.spriteZhuanquan_:show()
    transition.resumeTarget(self.spriteZhuanquan_)
    if self:isHost() then
        self.paperCardList_:turnToOut()
    end
end

function PlayerView:zhuanQuanAction(target, timer)
    local sequence = transition.sequence({
        cc.FadeTo:create(timer, 0),
        cc.FadeTo:create(timer, 255),
        })
    target:runAction(cc.RepeatForever:create(sequence))
end

function PlayerView:onStateChanged_(event)
    if not event.to then
        return
    end
    -- if event.from == "chu_pai_thinking" or event.to ~= "chu_pai_thinking" then
    if self.paperCardList_ then
        self.paperCardList_:hideOutCardTip()
    end
    if event.to ~= "chu_pai_thinking" or event.to ~= "thinking" or event.to ~= "tianhuthinking" then
        self.spriteZhuanquan_:hide()
    end
    local s = string.split(string.lower(event.to), '_')
    local methodName = "onState"
    for _,v in pairs(s) do
        methodName = methodName .. string.ucfirst(v)
    end
    methodName = methodName .. "_"
    print(methodName)
    if self[methodName] and type(self[methodName]) == 'function' then
        print("call "..methodName)
        handler(self, self[methodName])(event)
    end
end

function PlayerView:onRoundOverShowPai_(event)   
end

function PlayerView:isShowQiPai(bool)
    if bool then
        self.qipai_text_:show()
    else
        self.qipai_text_:hide()
    end
end

function PlayerView:isShowDaNiao(bool)
    if bool then
        self.daniao_text_:show()
    else
        self.daniao_text_:hide()
    end
end

function PlayerView:calcRoundOverShowPokerPos_(total, index)
    local direction = nil
    if self.nowSeats_ == 2 then
        direction = TABLE_DIRECTION2
    else
        direction = TABLE_DIRECTION
    end
    if direction.LEFT == self.index_ then
        return self:calcRoundOverPokerPosLeft_(total, index)
    elseif direction.RIGHT == self.index_ then
        return self:calcRoundOverPokerPosRight_(total, index)
    end
    return 0, 0, 0
end

function PlayerView:calcRoundOverPokerPosLeft_(total, index)
    local majiang_width = 48
    majiang_width = majiang_width
    local line = 3
    if total > 15 then
        line = 4
    end
    local x = 18 +  math.ceil(index/line) * majiang_width 
    local y =  60 - (index % line) * majiang_width
    local playerX, playerY = self:getPlayerPosition()

    print("calcRoundOverPokerPosLeft_"..x.."-"..y..":"..index..majiang_width)
    return  x+ playerX,  y+playerY
end

function PlayerView:calcRoundOverPokerPosRight_(total, index)
    local majiang_width = 48
    local isChangeLine = false
    local line = 3
    if total > 15 then
        line = 4
    end
    local x =  math.ceil(index/line) * majiang_width + 20
    local y =  60 - (index % line)* majiang_width
    local playerX, playerY = self:getPlayerPosition()
    return playerX -x , y+playerY 
end

local ani_adjusty = 20
local ani_adjustx = 250
function PlayerView:getAnimPosBySeatid()
    local direction = nil
    if self.nowSeats_ == 2 then
        direction = TABLE_DIRECTION2
    else
        direction = TABLE_DIRECTION
    end
    if direction.BOTTOM == self.index_ then
        return player_pos[1][1] + ani_adjustx - 100, player_pos[1][2] - ani_adjusty
    elseif direction.RIGHT == self.index_ then
        return player_pos[2][1] - ani_adjustx, player_pos[2][2] - ani_adjusty
    else 
        return player_pos[3][1] + ani_adjustx, player_pos[3][2] - ani_adjusty
    end
end
 
function PlayerView:playGameAnimByType(typeid)
    self:performWithDelay(function ()
        local x, y = self:getAnimPosBySeatid(seatid)
        app:createConcreteView("PlayAnim",typeid):addTo(self.nodeAnims_):pos(x, y)
    end, 0.3)
end

function PlayerView:playPengAnim()
    -- self:playGameAnimByType("peng")
    local animaData = FaceAnimationsData.getPaoHuZiAnimation(4)
    local x, y = self:getAnimPosBySeatid(self.player_:getSeatID())
    animaData.x = x
    animaData.y = y
    gameAnim.createPaoHuZiAnimations(animaData, self.nodeAnims_)
end

function PlayerView:playChiAnim()
    -- self:playGameAnimByType("chi")
    local animaData = FaceAnimationsData.getPaoHuZiAnimation(1)
    local x, y = self:getAnimPosBySeatid(self.player_:getSeatID())
    animaData.x = x
    animaData.y = y
    gameAnim.createPaoHuZiAnimations(animaData, self.nodeAnims_)
end

function PlayerView:playWeiAnim()
    -- self:playGameAnimByType("wei")
    local animaData = FaceAnimationsData.getPaoHuZiAnimation(6)
    local x, y = self:getAnimPosBySeatid(self.player_:getSeatID())
    animaData.x = x
    animaData.y = y
    gameAnim.createPaoHuZiAnimations(animaData, self.nodeAnims_)
end

function PlayerView:playPaoAnim()
    -- self:playGameAnimByType("pao")
    local animaData = FaceAnimationsData.getPaoHuZiAnimation(3)
    local x, y = self:getAnimPosBySeatid(self.player_:getSeatID())
    animaData.x = x
    animaData.y = y
    gameAnim.createPaoHuZiAnimations(animaData, self.nodeAnims_)
end

function PlayerView:playTiAnim()
    -- self:playGameAnimByType("ti")
    local animaData = FaceAnimationsData.getPaoHuZiAnimation(5)
    local x, y = self:getAnimPosBySeatid(self.player_:getSeatID())
    animaData.x = x
    animaData.y = y
    gameAnim.createPaoHuZiAnimations(animaData, self.nodeAnims_)
end

function PlayerView:getHuAnimPos()
    local direction = nil
    if self.nowSeats_ == 2 then
        direction = TABLE_DIRECTION2
    else
        direction = TABLE_DIRECTION
    end
     if direction.BOTTOM == self.index_ then
        return display.cx,550
    elseif direction.RIGHT == self.index_ then
        return display.fixRight - 200,1000
    else 
        return 200,1000
    end
end

function PlayerView:playHuAnim(typeid)
    local animaData = FaceAnimationsData.getPaoHuZiAnimation(2)
    local x, y = self:getAnimPosBySeatid(self.player_:getSeatID())
    animaData.x = x
    animaData.y = y
    gameAnim.createPaoHuZiAnimations(animaData, self.nodeAnims_)
end

function PlayerView:showHightLight(card,isHigh)
    --桌牌   
    local zhuomiankan = self.nodeZhuomianPai_:getChildren()
    for _,v in ipairs(zhuomiankan) do
        v:showHightLight(card,isHigh)
    end 
    --出的牌
    local chudepai = self.nodeChuPai_:getChildren()
    for _,va in ipairs(chudepai) do
        if va.card == card then
            if isHigh then
                va:highLight()
            else
                va:clearHighLight()
            end 
        end
    end
end

function PlayerView:NotifyshowHightLight(card)
    -- self.player:
end
 
------------- 响应状态变化函数段结束 ------------------------------------------------------------

function PlayerView:onStopZhuanQuan_(event)
    if self.spriteZhuanquan_ then
        self.spriteZhuanquan_:hide()
        transition.pauseTarget(self.spriteZhuanquan_)
    end
end

return PlayerView

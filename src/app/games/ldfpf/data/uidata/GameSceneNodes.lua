local TYPES = gailun.TYPES

local nodes = {}

nodes.layers = {
    type = TYPES.ROOT,
    children = {
        {type = TYPES.LAYER, var = "layerBG_"},
        {type = TYPES.LAYER, var = "layerTable_"},
        {type = TYPES.LAYER, var = "layerMenu_",},
        {type = TYPES.LAYER, var = "layerAnim_"},
        {type = TYPES.LAYER, var = "layerWindows_",},
        {type = TYPES.LAYER, var = "layerTop_",},
    },
}

nodes.bg = {
    type = gailun.TYPES.ROOT, children = {
        {type = gailun.TYPES.SPRITE, var = "bgSprite_", filename = "res/images/game/bg" .. setData:getCDPHZBgIndex() .. ".jpg", x = display.cx, y = display.cy, scale = display.width / DESIGN_WIDTH},
        {type = gailun.TYPES.SPRITE, var = "logBg_", filename = "res/images/sybp/logo1.png", x = display.cx, y = display.cy+20, scale = display.width / DESIGN_WIDTH},
       

    },
}

nodes.menuLayerTree = {
    type = gailun.TYPES.ROOT, children = {
        -- {type = TYPES.BUTTON, var = "buttonShop_", normal="res/images/game/shangc.png", options = {}, align={display.RIGHT_TOP, display.width - 82, display.height - 5}, visible = false},
        -- {type = TYPES.CUSTOM, class = "app.views.game.DeviceInfoView", px = 0.65, py = 0.960, opacity = 128},
      
        {type = TYPES.BUTTON, var = "buttonStart_", normal = "res/images/game/button_StartGame.png", autoScale = 0.9, x = display.cx, y = display.cy - 100,},
        {type = TYPES.BUTTON, var = "buttonInvite_", normal = "res/images/game/button_invite_weixin.png", autoScale = 0.9, x = display.cx, y = display.cy ,Visible = false},
        {type = TYPES.BUTTON, var = "buttonCardConfig_", normal = "res/images/game/btn_shezhi.png", autoScale = 0.9, x = display.cx + 90, y = display.height - 80,},
        {type = TYPES.BUTTON, var = "buttonHuaYu_", normal = "res/images/game/huayu.png", autoScale = 0.9, x = display.right - 50, y = display.bottom + 220 +40,},
        {type = TYPES.CUSTOM, var = "buttonVoiceView_", class = "app.views.game.VoiceRecordView", px = 0.5, py = 0.65},
        {type = TYPES.BUTTON, var = "buttonDingWei_", normal = "res/images/game/btn_dingwei.png", autoScale = 0.9, x =  display.right - 50, y = display.bottom + 280 +40,},
        {type = TYPES.CUSTOM, var = "buttonVoice_", class = "app.views.game.VoiceChatButton", x = display.right - 50, y = display.bottom + 160 +40 },
        {type = TYPES.BUTTON, var = "buttonOK_", normal = "res/images/common/btn_queding.png", x = display.cx, y = 100 , autoScale = 0.9},

        {type = TYPES.BUTTON, var = "buttonReconnect_", normal = "res/images/game/refresh.png", autoScale = 0.9, x = display.right - 50, y = display.bottom + 100 +40,},
        {type = TYPES.BUTTON, var = "buttonTiPai_", normal = "res/images/paohuzi/game/btn_tiPai.png", autoScale = 0.9,  x = display.cx - 570, y = display.height - 530,},
        {type = TYPES.BUTTON, var = "buttonQiPai_", normal = "res/images/paohuzi/game/btn_qiPai.png", autoScale = 0.9,  x = display.cx - 300 , y = display.height - 35,},
        {type = TYPES.BUTTON, var = "buttonConfirmDaNiao_", normal = "res/images/game/btn_confirmdaniao_0.png", autoScale = 0.9,  x = display.cx +150 , y = display.cy ,},
        {type = TYPES.BUTTON, var = "buttonCancelDaNiao_", normal = "res/images/game/btn_cancedaniao_0.png", autoScale = 0.9,  x = display.cx - 150 , y = display.cy ,},
    },
}

return nodes

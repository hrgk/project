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
        {type = gailun.TYPES.SPRITE, var = "bgSprite_", filename = "res/images/majiang/game.png", x = display.cx, y = display.cy, scale = display.width / DESIGN_WIDTH},
        {type = TYPES.SPRITE, var = "zmTitle_", filename = "res/images/majiang/logo_mm.png", px = 0.5, py = 0.65},
    },
}

nodes.menuLayerTree = {
    type = gailun.TYPES.ROOT, children = {
        {type = TYPES.BUTTON, var = "buttonStart_", normal = "res/images/game/button_StartGame.png", autoScale = 0.9, x = display.cx, y = display.cy - 100,},
        {type = TYPES.BUTTON, var = "buttonInvite_", normal = "res/images/game/button_invite_weixin.png", autoScale = 0.9, x = display.cx, py = display.cy,},
        {type = TYPES.BUTTON, var = "buttonCardConfig_", normal = "res/images/game/btn_shezhi.png", autoScale = 0.9, x = display.cx + 90, py = display.height - 80,},
        {type = TYPES.BUTTON, var = "buttonHuaYu_", normal = "res/images/game/huayu.png", autoScale = 0.9, x = display.right - 50, y = display.cy - 20,},
        {type = TYPES.CUSTOM, var = "buttonVoiceView_", class = "app.views.game.VoiceRecordView", px = 0.5, py = 0.65},
        {type = TYPES.CUSTOM, var = "buttonVoice_", class = "app.views.game.VoiceChatButton", x = display.width - 50, y = display.cy - 100},
        {type = TYPES.BUTTON, var = "buttonOK_", normal = "res/images/common/btn_queding.png", x = display.cx, py = 90, autoScale = 0.9},
        {type = TYPES.BUTTON, var = "buttonReconnect_", normal = "res/images/game/refresh.png", autoScale = 0.9, x = display.width - 50, y = display.height - 542},
   },
}

return nodes

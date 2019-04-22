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
        {type = gailun.TYPES.SPRITE, var = "bgSprite_",filename = "res/images/game.png",scale = display.width / DESIGN_WIDTH, x = display.cx, y = display.cy},
        {type = TYPES.SPRITE, filename = "res/images/paodekuai/game/gameTitle.png", px = 0.5, py = 0.65},
    },
}

-- nodes.tableLayerTree = {
--     type = gailun.TYPES.ROOT, children = {
--         {type = TYPES.CUSTOM, var = "tableController_", class = "app.controllers.TableController"},
--     }
-- }

nodes.menuLayerTree = {
    type = gailun.TYPES.ROOT, children = {
        -- {type = TYPES.BUTTON, var = "buttonShop_", normal="#shangc.png", options = {}, align={display.RIGHT_TOP, display.width - 82, display.height - 5}, visible = false},
        -- {type = TYPES.CUSTOM, class = "app.views.game.DeviceInfoView", px = 0.65, py = 0.960, opacity = 128},

        {type = TYPES.BUTTON, var = "buttonInvite_", normal = "res/images/game/button_invite_weixin.png", autoScale = 0.9, x = display.cx, py = 372,},
        {type = TYPES.BUTTON, var = "buttonCardConfig_", normal = "res/images/game/button_setting.png", autoScale = 0.9, x = display.cx + 90, py = 1180,},
   
        {type = TYPES.BUTTON, var = "buttonDismiss_", normal = "res/images/game/button_dismiss2.png", autoScale = 0.9, x = display.right - 200, y = display.bottom + 80, visible = true},
        {type = TYPES.BUTTON, var = "buttonQuitRomm_", normal = "res/images/game/quit_room.png", autoScale = 0.9, x = display.right - 200, y = display.bottom + 80, visible = true},
        {type = TYPES.CUSTOM, var = "buttonVoiceView_", class = "app.views.game.VoiceRecordView", px = 0.5, py = 0.65},
        {type = TYPES.CUSTOM, var = "buttonVoice_", class = "app.views.game.VoiceChatButton", x = display.right - 50, y = display.cy+20 },
        {type = TYPES.BUTTON, var = "buttonOK_", normal = "res/images/common/button_ok.png", x = display.cx, y = display.bottom + 200, autoScale = 0.9},

        {type = TYPES.BUTTON, var = "buttonToWechat_", normal = "res/images/towechat.png", autoScale = 0.9, x =  display.left + 50, y = display.cy+20 },
        {type = TYPES.BUTTON, var = "buttonReconnect_", normal = "res/images/game/refresh.png", autoScale = 0.9, x = display.left+50, y = display.top - 50,},
        {type = TYPES.BUTTON, var = "buttonConfig_", normal = "res/images/game/button_setting.png", autoScale = 0.9, x =  display.right - 50, y = display.height - 50,},
    },
}

return nodes

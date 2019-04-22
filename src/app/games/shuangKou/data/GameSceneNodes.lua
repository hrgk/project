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
        {type = gailun.TYPES.SPRITE, var = "bgSprite_", filename = "res/images/game/bg2.jpg", x = display.cx, y = display.cy, scale = display.height / DESIGN_HEIGHT},
        --{type = gailun.TYPES.SPRITE, filename = "res/images/shuangKou/game/shangtiao.png", x = display.cx, y = display.cy + 350, scale = display.width / DESIGN_WIDTH},
        {type = TYPES.SPRITE, filename = "res/images/shuangKou/game/logo.png", px = 0.5, py = 0.7},
        -- {type = TYPES.SPRITE, var = "roomFlag_", filename = "res/images/tianzha/game/flag_jingdian.png", px = 0.65, py = 0.645},
       
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
        {type = TYPES.BUTTON, var = "buttonWanFa_", normal = "res/images/game/bt_gz.png", autoScale = 0.9, x = display.right -120, y = display.top - 40},
        {type = TYPES.BUTTON, var = "buttonMenu_", normal = "res/images/game/btn_tub.png", autoScale = 0.9, x = display.width - 50, y = display.top - 40,},
        {type = gailun.TYPES.SPRITE, var = "btnMenu_", filename = "res/images/game/btnBg.png", x = display.width - 115, y = display.top - 70,scale9 = true, size = {180, 270},ap = {0.5, 1},
            children = {
                {type = TYPES.BUTTON, var = "buttonConfig_", normal = "res/images/game/btn_sheZhi.png", autoScale = 0.9, ppx =  0.5, ppy = 0.6,},
                {type = TYPES.BUTTON, var = "buttonDismiss_", normal = "res/images/game/btn_jieSan.png", autoScale = 0.9, ppx = 0.5, ppy = 0.4,},
                {type = TYPES.BUTTON, var = "buttonQuitRomm_", normal = "res/images/game/btn_tuiChu.png", autoScale = 0.9, ppx = 0.5, ppy = 0.4,},
                {type = TYPES.BUTTON, var = "buttonDingWei_", normal = "res/images/game/btn_dingw.png", autoScale = 0.9, ppx =  0.5, ppy = 0.8,},
                {type = TYPES.BUTTON, var = "buttonZl_", normal = "res/images/game/btn_zanshilikai.png", autoScale = 0.9, ppx =  0.5, ppy = 0.2,},
            }
        },
        {type = TYPES.BUTTON, var = "buttonInvite_", normal = "res/images/game/button_invite_weixin.png", autoScale = 0.9, x = display.cx, py = 372,},

        --{type = TYPES.BUTTON, var = "buttonDismiss_", normal = "res/images/game/button_dismiss2.png", autoScale = 0.9, x = display.right - 170, py = 60, visible = true},
        --{type = TYPES.BUTTON, var = "buttonQuitRomm_", normal = "res/images/common/gameButton/btn_tcyxan.png", autoScale = 0.9, px = 1140, py = 50, visible = true},
        {type = TYPES.CUSTOM, var = "buttonVoiceView_", class = "app.views.game.VoiceRecordView", px = 0.5, py = 0.5},
        -- {type = TYPES.BUTTON, var = "buttonVoice_", normal = "#voice_chat.png", autoScale = 0.9, px = 0.947, py = 0.67}, --voice_chat
        --{type = TYPES.BUTTON, var = "buttonConfig_", normal = "res/images/game/btn_shezhi.png", x = display.width - 60, ppy = 0.94,autoScale = 0.9},
        {type = TYPES.CUSTOM, var = "buttonVoice_", class = "app.views.game.VoiceChatButton", x = display.width - 50, py = 290,autoScale = 0.9},
        {type = TYPES.BUTTON, var = "buttonOK_", normal = "res/images/common/gameButton/btn_qdan.png", x = display.cx, py = 200, autoScale = 0.9,autoScale = 0.9},
        {type = TYPES.BUTTON, var = "buttonRefresh_", normal = "res/images/game/refresh.png", x = display.width - 50, py = 220,autoScale = 0.9},
        {type = TYPES.BUTTON, var = "buttonHuaYu_", normal = "res/images/game/huayu.png",  x = display.width - 50, y = display.cy,},
        -- {type = TYPES.BUTTON, var = "buttonDingWei_", normal = "res/images/game/btn_dingwei.png", x = display.width - 245, ppy = 0.88,autoScale = 0.9},
      
        -- {type = TYPES.BUTTON, var = "buttonSpeaker_", normal = "#speaker1.png", autoScale = 0.9, px = 0.5, py = 0.5,},
        -- {type = TYPES.BUTTON, var = "buttonSetting_", autoScale = 0.9, normal = "#shezhi.png", options = {}, px = 0.95, py = 0.5},
        -- {type = TYPES.BUTTON, var = "buttonDuanyu_", autoScale = 0.9, normal = "#shezhi.png", options = {}, px = 0.95, py = 0.3},
    },
}

return nodes

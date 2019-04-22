local nodeData = {
    type = TYPES.ROOT,
    children = {
        {type = TYPES.NODE, var = "nodeShowPai_"}, -- 结束展示牌
        {type = TYPES.NODE, var = "nodePlayer_", children = {  -- 玩家基本数据的对象
            {type = TYPES.SPRITE, var = "niujiao_", filename = "res/images/game/niujiao.png", x = NIU_JIAO_X, y = NIU_JIAO_Y},
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
            {type = TYPES.SPRITE, var = "cardBack_", filename = "res/images/game/xiaopaibeimian.png", x = POKER_BACK_X, y = 25},
            {type = TYPES.LABEL_ATLAS, var = "cardNumber_", filename = "fonts/game_score.png", x = POKER_BACK_X, y = 10, options = {text="", w = 14, h = 35, startChar = "-"}, ap = {0.5, 0.5}},
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

return nodeData 

local ZhanJuListViewItem =class("ZhanJuListViewItem", gailun.BaseView)
local TYPES = gailun.TYPES
local nodes = {type = TYPES.ROOT, children = {
                {type = TYPES.SPRITE, size = {display.width * 0.86 * WIDTH_SCALE, display.height / 8 * HEIGHT_SCALE}, children = {
                {type = gailun.TYPES.LABEL, var = "labelNumber_", options = {text = "1", size = 28, color = cc.c4b(177, 66, 37, 0), font = DEFAULT_FONT} ,ppx = 0.15, ppy = 0.5, ap = {0,0.5}},
                {type = gailun.TYPES.LABEL, var = "labelFightTime_", options = {text = "17-10-10 22:10", font = DEFAULT_FONT,  size = 28, color = cc.c4b(177, 66, 37, 0), } ,ppx = 0.27, ppy = 0.5, ap = {0.5, 0.5}, scale = 0.8},
                {type = gailun.TYPES.LABEL, var = "playerScore_1_", options = {text = "玩家1分数", font = DEFAULT_FONT,  size = 28,  color = cc.c4b(177, 66, 37, 0)} ,ppx = 0.4, ppy = 0.56 ,ap = {0.5, 0.5}},
                {type = gailun.TYPES.LABEL, var = "playerScore_2_", options = {text = "玩家2分数", font = DEFAULT_FONT,  size = 28,  color = cc.c4b(177, 66, 37, 0)} ,ppx = 0.53, ppy = 0.56 ,ap = {0.5 ,0.5}},
                {type = gailun.TYPES.LABEL, var = "playerScore_3_", options = {text = "玩家3分数", font = DEFAULT_FONT,  size = 28,  color = cc.c4b(177, 66, 37, 0)} ,ppx = 0.66, ppy = 0.56 ,ap = {0.5, 0.5}},
                {type = gailun.TYPES.LABEL, var = "playerScore_4_", options = {text = "玩家3分数", font = DEFAULT_FONT,  size = 28,  color = cc.c4b(177, 66, 37, 0)} ,ppx = 0.79, ppy = 0.56 ,ap = {0.5, 0.5}},
                {type = TYPES.BUTTON, var = "buttonLook_", autoScale = 0.9, normal = "images/hall/ranklook.png", options = {}, ppx = 0.83, ppy = 0.1 },
                {type = TYPES.BUTTON, var = "buttonShare_", autoScale = 0.9, normal = "images/hall/zj_fx_btn.png", options = {}, ppx = 0.7, ppy = 0.1 },    
                {type = TYPES.SPRITE, filename = "images/xuxian1.png", ppx = 0.5, ppy = -0.25},
            }   
        },
    }
}

function ZhanJuListViewItem:ctor(data)
    gailun.uihelper.render(self, nodes)
    self:updateItemInfo_(data)
    self.buttonShare_:onButtonClicked(handler(self, self.onShareClicked_))
    self.buttonLook_:onButtonClicked(handler(self, self.onLookClicked_))
end

function ZhanJuListViewItem:updateItemInfo_(data)
    self.data_ = data
    self.playerScore_1_:setString(data.scores[1])
    self.playerScore_2_:setString(data.scores[2])
    self.playerScore_3_:setString(data.scores[3])
    self.playerScore_4_:setString(data.scores[4])
    self["labelNumber_"]:setString(data.seq)

    local timeStr = os.date("%m-%d %H:%M:%S", data.time)
    self["labelFightTime_"]:setString(timeStr) 
end

--获取回访码回调
function ZhanJuListViewItem:onShareClicked_(event)
    HttpApi.onHttpGenVisitNum(self.data_.roundID, handler(self, self.onHttpGenVisitNumSuccess_), handler(self, self.onHttpGenVisitNumFail_))
end

function ZhanJuListViewItem:onHttpGenVisitNumSuccess_(data)
    local result = json.decode(data)
    if not result then
        printInfo("ZhanJuListViewItem:onHttpGenVisitNumSuccess_(data)" .. data)
        return
    end
    if 1 ~= result.status then
        printInfo("HallScene: (data) flag: " .. data)
        app:showTips("分享失败")
        return
    end
    self:shareText_(checkint(result.data.reviewCode))
end

function ZhanJuListViewItem:onHttpGenVisitNumFail_(data)
    printError("ZhanJuListViewItem:onHttpGenVisitNumFail_(...)")
    app:showTips("分享失败")
end

function ZhanJuListViewItem:shareText_(code)
    local temp = "玩家[%s]分享了一个回访码，%d，在大厅点击进入战绩页面，然后点击查看回访按钮，输入回访码点击确定后即可查看。"
    local player = dataCenter:getHostPlayer()
    local playerName = player:getNickName()
    local strContent = string.format(temp, playerName, code)

    local params = {
        type = "url",
        tagName = "",
        title = "朋来牛鬼",
        description = strContent,
        imagePath = "res/images/ic_launcher.png",
        url = StaticConfig:get("shareURL") or ServerDefense.getBaseURL(),
        inScene = 0,
    }
    gailun.native.shareWeChat(params)
end

function ZhanJuListViewItem:onLookClicked_(event)
    display.getRunningScene():requestReViewData(self.data_.roundID, self.data_.seq)
end

return ZhanJuListViewItem


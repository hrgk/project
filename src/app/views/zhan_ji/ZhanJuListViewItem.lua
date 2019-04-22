local BaseElement = import("app.views.BaseElement")
local ZhanJuListViewItem = class("ZhanJuListViewItem", BaseElement)

function ZhanJuListViewItem:ctor()
    ZhanJuListViewItem.super.ctor(self)
end

function ZhanJuListViewItem:setUserName(item, userName)
    local nameLable = item:getChildByName("txt_user")
    nameLable:setString(userName)
end

function ZhanJuListViewItem:setScore(item, score)
    local scoreLable = item:getChildByName("txt_score")
    scoreLable:setString(score)
end

function ZhanJuListViewItem:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/zhanji/zhanJuItem.csb"):addTo(self)
end

function ZhanJuListViewItem:update(data,users,gameType)
    self.data_ = data
    self.gameType_ = gameType
    for i,v in ipairs(data.scores) do
        if self["item" .. i .."_"] then
            self:setScore(self["item" .. i .. "_"], v)
        end
    end
    for i,v in ipairs(users) do
        if v and self["item" .. i .. "_"] then
            self:setUserName(self["item" .. i .. "_"], v[1])
        end
    end
end

function ZhanJuListViewItem:playHandler_()
    if self.gameType_ == GAME_BCNIUNIU then
        app:showTips("敬请期待")
        return
    end
    HttpApi.getVisitDetail(self.data_.roundID,self.data_.seq, handler(self, self.sucHandler_), handler(self, self.failHandler_))
end

function ZhanJuListViewItem:sucHandler_(data)
    local info = json.decode(data)
    if info.status == 1 then
        dump(info.data,"ZhanJuListViewItem:sucHandler_")
        app:enterReviewScene(info.data.gameType, {info.data.details})
    end
end

function ZhanJuListViewItem:failHandler_()

end

function ZhanJuListViewItem:shareHandler_()
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

function ZhanJuListViewItem:shareText_(code)
    local temp = "玩家[%s]分享了一个回访码，%d，在大厅点击进入战绩页面，然后点击查看回访按钮，输入回访码点击确定后即可查看。"
    local playerName = selfData:getNickName()
    local strContent = string.format(temp, playerName, code)
    display.getRunningScene():shareWeiXin("乐途互娱",strContent,0,function()

    end)
end

function ZhanJuListViewItem:onHttpGenVisitNumFail_(data)
    printError("ZhanJuListViewItem:onHttpGenVisitNumFail_(...)")
    app:showTips("分享失败")
end

return ZhanJuListViewItem  

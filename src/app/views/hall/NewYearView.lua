local BaseView = import("app.views.BaseView")
local NewYearView = class("NewYearView", BaseView)
local ShareView = import("app.views.game.ShareView")
local TYPES = gailun.TYPES

function NewYearView:ctor(data)
    NewYearView.super.ctor(self)

    self:bindEvent()
    self:msgInit()
end

function NewYearView:msgInit()
    httpMessage.requestClubHttp({}, httpMessage.SPRING_ACTIVITY)
end


function NewYearView:bindEvent()
    cc.EventProxy.new(dataCenter, self, true)
    :addEventListener(httpMessage.SPRING_ACTIVITY, handler(self, self.onSpringActivity))
    :addEventListener(httpMessage.SPRING_ACTIVITY_RECV, handler(self, self.onSpringActivityRecv))
    :addEventListener(httpMessage.SPRING_ACTIVITY_LOGS, handler(self, self.onSpringActivityLogs))
end

function NewYearView:onSpringActivity(event)
    local data = json.decode(event.data.result).data

    local time = os.date("*t", gailun.utils.getTime())
    time.day = time.day
    time.hour = 0
    time.min = 0
    time.second = 1

    local endTime = os.time(time)
    local isRecv = data.login_bonus_time > endTime
    self.loginIconTag_:setBright(isRecv)
    self.loginGetBtn_:setBright(isRecv)
    self.loginGetBtn_:setEnabled(isRecv)

    self.currScore_:setString(data.curr_score)
    self.roundIconTag_:setBright(data.can_recv_game_bonus)

    self:updateProgress(data)
end

function NewYearView:loginGetBtnHandler_()
    httpMessage.requestClubHttp({itemID = 1}, httpMessage.SPRING_ACTIVITY_RECV)
end

function NewYearView:roundGetBtnHandler_()
    httpMessage.requestClubHttp({itemID = 2}, httpMessage.SPRING_ACTIVITY_RECV)
end

function NewYearView:getGift1Handler_()
    httpMessage.requestClubHttp({itemID = 3}, httpMessage.SPRING_ACTIVITY_RECV)
end

function NewYearView:getGift2Handler_()
    httpMessage.requestClubHttp({itemID = 4}, httpMessage.SPRING_ACTIVITY_RECV)
end

function NewYearView:getGift3Handler_()
    httpMessage.requestClubHttp({itemID = 5}, httpMessage.SPRING_ACTIVITY_RECV)
end

function NewYearView:getGift4Handler_()
    httpMessage.requestClubHttp({itemID = 6}, httpMessage.SPRING_ACTIVITY_RECV)
end

function NewYearView:getGift5Handler_()
    httpMessage.requestClubHttp({itemID = 7}, httpMessage.SPRING_ACTIVITY_RECV)
end

function NewYearView:updateProgress(data)
    local scoreList = {0, 8, 88, 188, 288, 588}
    local count = #scoreList - 1
    local interval = 1/count
    local percent = 1
    for i = 1, count do
        if data.curr_score >= scoreList[i] and data.curr_score <= scoreList[i + 1] then
            percent = interval * (i - 1) + (data.curr_score - scoreList[i])/(scoreList[i + 1] - scoreList[i]) * interval
            break
        end
    end

    self.giftProgress_:setPercent(percent * 100)
    table.remove(scoreList, 1)
    for i, score in ipairs(scoreList) do
        local alreadyReceive = data["item_" .. i .. "_status"] == 1
        self["alreadyGet" .. i .. "_"]:setVisible(alreadyReceive)
        self["gift" .. i .. "_"]:setBright(not alreadyReceive)
        self["getGift" .. i .. "_"]:setVisible(false)
        if not alreadyReceive then
            self["getGift" .. i .. "_"]:setVisible(data.curr_score >= score)
        end
    end
end

function NewYearView:onSpringActivityRecv(event)
    local data = json.decode(event.data.result)
    if data.status == -2 then
        app:showTips("当前无奖励")
        return
    end

    app:showTips("领取成功")
    display.getRunningScene():updateDiamonds()
    self:msgInit()
end

function NewYearView:onSpringActivityLogs(event)
    local data = json.decode(event.data.result)
    dump(data)
end

function NewYearView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/newYear/NewYearView.csb"):addTo(self)
    self.csbNode_:setPosition(display.cx - 640, 0)
end

function NewYearView:closeHandler_()
    self:removeSelf()
end

return NewYearView

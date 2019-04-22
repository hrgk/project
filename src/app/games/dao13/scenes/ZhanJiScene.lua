local BaseScene = import(".BaseScene")
local ZhanJiScene = class("ZhanJiScene", BaseScene)
local ReviewScene = require("app.scenes.ReviewScene")
local ZhanJiListView = import("app.views.zhan_ji.ZhanJiListView")

local TYPES = gailun.TYPES

local nodes = {type = TYPES.ROOT, 
        children = {
        {type = TYPES.SPRITE, filename = "res/images/zj_bj.png", ppx = 0.5, ppy = 0.5, ap = {0.5, 0.5},},
        {type = TYPES.SPRITE, filename = "res/images/zj_bsd.png", var = "rankBg1_", ppx = 0.5, ppy = 0.38, ap = {0.5, 0.5},},
        {type = TYPES.LABEL, var = "bottomTip_", ap = {0.5, 0.65}, x = display.cx, y = display.bottom + 30, options={text="友情提示：录像会保存24小时内最近的20条记录", 
        size = 24, font = DEFAULT_FONT, color = cc.c3b(254, 253, 207)}},
        {type = TYPES.BUTTON, var = "buttonRetrun_", autoScale = 0.9, normal = "res/images/common/arrow-return.png", options = {}, ppx = 0.05, ppy = 0.94 },
        {type = TYPES.SPRITE, var = "titlePng_", filename = "res/images/hall/ranscore.png", ppx = 0.5, ppy = 0.81, ap = {0.5, 0.5}},
        {type = TYPES.BUTTON, var = "buttonLookOther_", autoScale = 0.9, normal = "res/images/hall/lookother.png", options = {}, ppx = 0.88, ppy = 0.925, visible = true},

    }
}

function ZhanJiScene:ctor()
    gailun.uihelper.render(self, nodes)
    self.buttonRetrun_:onButtonClicked(handler(self, self.onButtonRetrunClick_))
    self.buttonLookOther_:onButtonClicked(handler(self, self.onButtonLookOtherClick_))
    self:getRoomRecords_()
    self:bindReturnKeypad_()
end

function ZhanJiScene:getRoomRecords_()
    app:showLoading("正在加载游戏数据...")
    HttpApi.onHttpGetRoomRecords(handler(self, self.onHttpGetRoomRecordsSuccess_), handler(self, self.onHttpGetRoomRecordsFail_))
end

function ZhanJiScene:onHttpGetRoomRecordsSuccess_(data)
    app:clearLoading()
    self.roomListData_ = {}
    self.userList_ = {}
    local result = json.decode(data)
    if not result then
        printInfo("RecordView:onHttpGetRoomRecordsSuccess_(data)" .. data)
        return
    end
    if 1 ~= result.status then
        printInfo("LoginScene: (data) flag: " .. data)
        return
    end
    local index = 0
    for i = #result.data.rooms, 1, -1 do
        index = index + 1
        result.data.rooms[i].index = index
        self.roomListData_[index] = result.data.rooms[i]
        self.userList_[index] = result.data.rooms[i].users
    end
    self.zhanJiView_ = ZhanJiListView.new(self.roomListData_)
    self:addChild(self.zhanJiView_)
end

function ZhanJiScene:getCorrectUserList()
    return self.userList_[self.correct_]
end

function ZhanJiScene:onHttpGetRoomRecordsFail_(data)
    app:clearLoading()
    printError("RecordView:onHttpGetRoomRecordsFail_(...)")
end

function ZhanJiScene:bindReturnKeypad_()
    if "android" ~= device.platform then
        return
    end
    self:setKeypadEnabled(true)
    self:addNodeEventListener(cc.KEYPAD_EVENT, function (event)
        if event.key == "back" then
            if self.isOpenWindow_ then return end
            self:onButtonRetrunClick_()
        end
    end)
end

function ZhanJiScene:onButtonRetrunClick_(event)
    if self.isOpenRoomInfo_ then
        if self.infoList_ then
            self.infoList_:removeFromParent()
            self.infoList_ = nil
        end
        self.isOpenRoomInfo_ = false
        self.zhanJiView_:show()
    else
        app:enterHallScene()
    end
end

function ZhanJiScene:onButtonLookOtherClick_(event)
    self.isOpenWindow_ = true
    local view = app:createView("hall.InputNumberView", "请输入他人分享的回放码"):addTo(self):pos(display.cx, display.cy)
    view:setCallback(handler(self, self.onLookBackOKClicked_))
end

function ZhanJiScene:closeWindow()
    self:performWithDelay(function()
        self.isOpenWindow_ = false
        end, 0.2)
end

function ZhanJiScene:onLookBackOKClicked_(numberStr)
    local str = numberStr
    local num = tonumber(str) or -1
    if #str ~= 6 or -1 == num then
        app:showTips("你输入的回访码有误，请重新输入")
    else
        HttpApi.getRoundInfo(num, handler(self, self.onReviewReturn_), handler(self, self.onReviewFail_))
    end
end

function ZhanJiScene:onReviewReturn_(data)
    local result = json.decode(data)
    if not result then
        printInfo("RecordView:onReviewReturn_(data)" .. data)
        return
    end
    if 1 ~= result.status then
        app:showTips("请输入正确的回访码")
        return
    end
    app:createConcreteView("zhan_ji.RecordSharedView", result.data):addTo(self)
end

function ZhanJiScene:onReviewFail_(data)
    printError("RecordView:onReviewFail_(...)")
end

function ZhanJiScene:requestReViewData(roundID, seq)
    app:showLoading("正在加载游戏数据...")
    HttpApi.getVisitDetail(roundID, seq, function (data)
        local result = json.decode(data)
        if 1 ~= result.status then
            app:showAlert(result.desc)
            return
        end
        if result.data.details == nil or #result.data.details == 0 then 
            app:showTips("无此局数据")
            app:clearLoading()
            return
        end
        self:initReView(result.data.details)
        app:clearLoading()
    end, function ()
        app:clearLoading()
    end)
end

function ZhanJiScene:initReView(data)
    ReviewScene.new(data):addTo(self)
end

function ZhanJiScene:initZhanJuInFoList(recordID, index)
    self.isOpenRoomInfo_ = true
    self.zhanJiView_:hide()
    self.correct_ = index
    HttpApi.onHttpGetRoundList(recordID, handler(self, self.onHttpGetRoomRoundsSuccess_), handler(self, self.onHttpGetRoomRoundsFails_))
end

function ZhanJiScene:onHttpGetRoomRoundsSuccess_(data)
    local result = json.decode(data)
    if not result then
        printInfo("RecordView:onHttpGetRoomRoundsSuccess_(data)" .. data)
        return
    end
    if 1 ~= result.status then
        app:showTips("请输入正确的回访码")
        return
    end
    self.infoList_ = app:createConcreteView("zhan_ji.ZhanJuListView", result.data):addTo(self)
end

function ZhanJiScene:onHttpGetRoomRoundsFails_()
    printError("RecordView:onHttpGetRoomRoundsFails_(...)")
end

return ZhanJiScene 

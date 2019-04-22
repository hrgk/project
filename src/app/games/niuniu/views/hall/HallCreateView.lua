local BaseLayer = require("app.views.base.BaseDialog")
local HallCreateView = class("HallCreateView", BaseLayer)
local nodes = import("app.data.CreateRoom")

local CHECK_COLOR_ON = cc.c3b(255, 215, 73)
local CHECK_COLOR_OFF = cc.c3b(255, 255, 255)

function HallCreateView:ctor(roomType)
    self.roomType_ = roomType
    HallCreateView.super.ctor(self)
    self.autoRemove_ = false
    self:onLoadAllFinish_(roomType)
    self:androidBack()
end

function HallCreateView:onLoadAllFinish_(roomType)
    gailun.uihelper.render(self, nodes.nodeBg)
    gailun.uihelper.render(self, nodes.windows)
    gailun.uihelper.render(self, nodes.juShuCheckGroup)
    gailun.uihelper.render(self, nodes.paiZhangCheckGroup)
    gailun.uihelper.render(self, nodes.renShuCheckGroup)
    gailun.uihelper.render(self, nodes.jiFenCheckGroup)
    gailun.uihelper.render(self, nodes.xianShouCheckGroup)

    if nodes.wanfaCheckGroup then
        gailun.uihelper.render(self, nodes.wanfaCheckGroup)
    end
    if nodes.paiXingCheckGroup then
        gailun.uihelper.render(self, nodes.paiXingCheckGroup)
    end
    self.buttonBack_:onButtonClicked(handler(self, self.onClose_))
    self.buttonCreateRoom_:onButtonClicked(handler(self, self.onButtonCreateRoomClicked_))
    self.totalJuShu_ = 4
    self:initZZView_()
    self.bg_:scale(0.9)
end

function HallCreateView:initZZView_()
    self.totalJuShu_ = gameConfig:get(CONFIG_SELECT_ROUND)
    self:initSelected_()
    self.jushuList_ = {}
    self.jushu6_:onButtonClicked(handler(self, self.juShu6Click_))
    self.jushu12_:onButtonClicked(handler(self, self.juShu12Click_))
    self.jushuList_[#self.jushuList_+1] = self.jushu6_
    self.jushuList_[#self.jushuList_+1] = self.jushu12_
    self.jiFenList_ = {}
    self.jiFenList_[#self.jiFenList_+1] = self.jifen1_
    self.jiFenList_[#self.jiFenList_+1] = self.jifen2_
    self.jifen1_:onButtonClicked(handler(self, self.jiFen1Click_))
    self.jifen2_:onButtonClicked(handler(self, self.jiFen2Click_))
    self:initDiamonds_()
    self:initWanFa_()
    self:initPaiXing_()
end

function HallCreateView:initWanFa_()
    self.wanfaList_ = {}
    if self.wanfa1_ then
        self.wanfa1_:setButtonSelected(true)
    end
    if self.wanfa2_ then
        self.wanfa2_:setButtonSelected(true)
    end
    if self.wanfa3_ then
        self.wanfa3_:setButtonSelected(true)
    end
    if self.wanfa4_ then
        self.wanfa4_:setButtonSelected(true)
    end
end

function HallCreateView:initPaiXing_()
    if self.paixing1_ then
        self.paixing1_:setButtonSelected(true)
    end
    if self.paixing2_ then
        self.paixing2_:setButtonSelected(true)
    end
    if self.paixing3_ then
        self.paixing3_:setButtonSelected(true)
    end
    if self.paixing4_ then
        self.paixing4_:setButtonSelected(true)
    end
    if self.paixing5_ then
        self.paixing5_:setButtonSelected(true)
    end
    if self.paixing6_ then
        self.paixing6_:setButtonSelected(true)
    end
end

function HallCreateView:initSelected_()
    if gameConfig:get(CONFIG_SELECT_ROUND) == 6 then
        self.totalJuShu_ = 6
        self.jushu6_:setButtonSelected(true)
        self.jushu12_:setButtonSelected(false)
    elseif gameConfig:get(CONFIG_SELECT_ROUND) == 12 then
        self.totalJuShu_ = 12
        self.jushu6_:setButtonSelected(false)
        self.jushu12_:setButtonSelected(true)
    end
    if gameConfig:get(CONFIG_SELECT_WANFA1) == 1 then
        self.score_ = 1
        self.jifen1_:setButtonSelected(true)
        self.jifen2_:setButtonSelected(false)
    elseif gameConfig:get(CONFIG_SELECT_WANFA1) == 2 then
        self.score_ = 2
        self.jifen1_:setButtonSelected(false)
        self.jifen2_:setButtonSelected(true)
    end
end

function HallCreateView:jiFen1Click_(event)
    for i,v in ipairs(self.jiFenList_) do
        v:setButtonSelected(false)
    end
    self.score_ = 1
    event.target:setButtonSelected(true)
    gameConfig:set(CONFIG_SELECT_WANFA1, 1)
end

function HallCreateView:jiFen2Click_(event)
    for i,v in ipairs(self.jiFenList_) do
        v:setButtonSelected(false)
    end
    self.score_ = 2
    event.target:setButtonSelected(true)
    gameConfig:set(CONFIG_SELECT_WANFA1, 2)
end

function HallCreateView:juShu6Click_(event)
    for i,v in ipairs(self.jushuList_) do
        v:setButtonSelected(false)
    end
    event.target:setButtonSelected(true)
    self.totalJuShu_ = 6
    gameConfig:set(CONFIG_SELECT_ROUND, 6)
end

function HallCreateView:juShu12Click_(event)
    for i,v in ipairs(self.jushuList_) do
        v:setButtonSelected(false)
    end
    event.target:setButtonSelected(true)
    self.totalJuShu_ = 12
    gameConfig:set(CONFIG_SELECT_ROUND, 12)
end

function HallCreateView:juShu18Click_(event)
    for i,v in ipairs(self.jushuList_) do
        v:setButtonSelected(false)
    end
    event.target:setButtonSelected(true)
    self.totalJuShu_ = 18
    gameConfig:set(CONFIG_SELECT_ROUND, 18)
end

function HallCreateView:initDiamonds_()
    local info = StaticConfig:get("required_diamonds")
    if not info or not info[1] then
        return
    end
    if #info[1] ~= 2 then
        return
    end
    local d1, d2 = unpack(info)
    self.jushu6_:setButtonLabelString(d1[1] .. "局")
    self.jushu12_:setButtonLabelString(d2[1].. "局")
    self.label8_:setString("x" .. d1[2])
    self.label9_:setString("x" .. d2[2])
    self.price1_ = d1[2]
    self.price2_ = d2[2]
end

function HallCreateView:onExit()
    collectgarbage("collect")
end

function HallCreateView:onClose_(event)
    display.getRunningScene():closeWindow()
    self:removeFromParent(true)
end

function HallCreateView:calcCreateRoomParams_()
    local ipLimit = 0
    local params = {
        gameType = 1,
        totalRound = self.totalJuShu_,
        ipLimit = ipLimit,
        gameMode = 1,
        score = self.score_,
        roomType = self.roomType_,
    }
    return params
end

function HallCreateView:onButtonCreateRoomClicked_(event)
    local diamonds = dataCenter:getHostPlayer():getDiamond()
    if self.totalJuShu_ == 6 then
        if diamonds < self.price1_ then
            app:createView("hall.BuyView"):addTo(self:getParent():getParent())
                return
        end
    elseif self.totalJuShu_ == 12 then
        if diamonds < self.price2_  then
            app:createView("hall.BuyView"):addTo(self:getParent():getParent())
                return
        end
    end

    if self.inCreateRoom_ then
        return
    end
    local params = self:calcCreateRoomParams_()
    self.inCreateRoom_ = true
    HttpApi.createRoom(params, handler(self, self.onCreateRoomReturn_), handler(self, self.onCreateRoomFail_))
end

function HallCreateView:onCreateRoomReturn_(data)
    self.inCreateRoom_ = false
    local result = json.decode(data)
    if DIAMONDS_CLUB_NOT_ENOUGH == checkint(result.status) or HTTP_DIAMONDS_NOT_ENOUGH == checkint(result.status) then
        if not CHANNEL_CONFIGS.DIAMOND then
            return
        end
        app:createView("hall.BuyView"):addTo(self:getParent():getParent())
        return
    end
    if HTTP_HAVE_OTHER_ROOM == checkint(result.status) then
        return app:alert("创建房间失败，只能同时创建一个房间！")
    end
    if -1 == result.status then
        app:enterLoginScene()
        return
    end
    if 1 ~= result.status then
        return app:alert("创建房间失败，未知错误 2" .. checkint(result.status))
    end
    local host = result.data.serverIP
    local port = checkint(result.data.serverPort)
    local roomID = checkint(result.data.roomID)
    dataCenter:sendEnterRoom(roomID)
end

function HallCreateView:onCreateRoomFail_(...)
    self.inCreateRoom_ = false
end

return HallCreateView

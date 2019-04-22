local BaseView = import("app.views.BaseView")
local WanFaView = class("WanFaView", BaseView)

local CreatePDKView = import("app.views.hall.CreatePDKView")
local CreateZZMJView = import("app.views.hall.CreateZZMJView")
local CreateHZMJView = import("app.views.hall.CreateHZMJView")
local CreateNNView = import("app.views.hall.CreateNNView")
local CreateMPZhuang = import("app.views.hall.CreateMPZhuang")
local CreateWorldNN = import("app.views.hall.CreateWorldNN")
local CreateNNZhuang = import("app.views.hall.CreateNNZhuang")
local CreateBCNNView = import("app.views.hall.CreateBCNNView")
local CreateCSMJView = import("app.views.hall.CreateCSMJView")
local CreateDTZView = import("app.views.hall.CreateDTZView")
local CreateCDPHZView = import("app.views.hall.CreateCDPHZView")
local CreateSKView = import("app.views.hall.CreateSKView")
local CreateD13View = import("app.views.hall.CreateD13View")
local CreateJHD13View = import("app.views.hall.CreateJHD13View")
local CreateYZCHZView = import("app.views.hall.CreateYZCHZView")
local CreateSWCHZView = import("app.views.hall.CreateSWCHZView")
local CreateLDSView = import("app.views.hall.CreateLDSView")
local CreateJY15View = import("app.views.hall.CreateJY15View")
local CreateHSMJView = import("app.views.hall.CreateHSMJView")
local CreateMMMJView = import("app.views.hall.CreateMMMJView")
local CreateFHHZMJView = import("app.views.hall.CreateFHHZMJView")
local CreateHSLMZ = import("app.views.hall.CreateHSLMZ")
local CreateHHQMTView = import("app.views.hall.CreateHHQMTView")
local CreateSYBPView = import("app.views.hall.CreateSYBPView")
local CreateLDFPFView = import("app.views.hall.CreateLDFPFView")

local gameTypeList = {}
gameTypeList[GAME_PAODEKUAI] = CreatePDKView
gameTypeList[GAME_DA_TONG_ZI] = CreateDTZView
gameTypeList[GAME_MJCHANGSHA] = CreateCSMJView
gameTypeList[GAME_MJZHUANZHUAN] = CreateZZMJView
gameTypeList[GAME_MJHONGZHONG] = CreateHZMJView
gameTypeList[GAME_CDPHZ] = CreateCDPHZView
gameTypeList[GAME_HSMJ] = CreateHSMJView
gameTypeList[GAME_MMMJ] = CreateMMMJView
gameTypeList[GAME_FHHZMJ] = CreateFHHZMJView
gameTypeList[GAME_FHLMZ] = CreateHSLMZ
gameTypeList[GAME_HHQMT] = CreateHHQMTView
gameTypeList[GAME_SYBP] = CreateSYBPView
gameTypeList[GAME_LDFPF] = CreateLDFPFView

gameTypeList[GAME_YZCHZ] = {
    [0] = "",
    [2] = CreateYZCHZView,
    [3] = CreateSWCHZView,
    [4] = CreateLDSView,
    [5] = CreateJY15View,
}

gameTypeList[GAME_BCNIUNIU] = {
    [0] = "",
    [6] = CreateBCNNView,
    [2] = CreateNNZhuang,
    [4] = CreateMPZhuang,
    [5] = CreateWorldNN,
}

gameTypeList[GAME_SHUANGKOU] = CreateSKView
gameTypeList[GAME_13DAO] =
{
    [0] = "",
    [1] = CreateD13View,
    [2] = CreateJHD13View,
} 

function WanFaView:ctor(gameType, data)
    print("========gameType========",gameType)
    self.back_ = display.newSprite("res/images/game/wanfa_bg.png"):addTo(self):pos(display.cx, display.cy)
    local game_type = gameType
    local gameTypeT = gameType
    local gameType = gameTypeList[gameType]
    local gameView = nil
    -- dump(data.config)

    if gameType[0] ~= nil then
        local ruleType = nil
        if data.config and data.config.ruleType then
            ruleType = data.config.ruleType
        elseif data.ruleType then
            ruleType = data.ruleType
        end
        gameView = gameType[ruleType]
    else
        gameView = gameType
    end
    local view = gameView.new(game_type):addTo(self.back_):pos(1087/2 - 90,647/2)
    view:setData(data)
    if gameTypeT == GAME_13DAO then
        view:initShowMaskP()
    end
    self.closeBtn_ = ccui.Button:create("res/images/common/btn_close1.png", "res/images/common/btn_close1.png")
    self.closeBtn_:setAnchorPoint(0.5,0.5)
    self.closeBtn_:setSwallowTouches(false)  
    self.closeBtn_:setPosition(1070,620)
    self.back_:addChild(self.closeBtn_,2)
    self.closeBtn_:addTouchEventListener(handler(self, self.onButtonClick_))
end

function WanFaView:setMask(operate)
    local maskLayer = display.newColorLayer(cc.c4b(0, 0, 0, operate))
    self:addChild(maskLayer, -1)
    self:performWithDelay(function()
        local layout = ccui.Layout:create()
        layout:setContentSize(cc.size(DESIGN_WIDTH, DESIGN_HEIGHT))
        layout:setTouchEnabled(true)
        layout:setSwallowTouches(true)
        self.back_:addChild(layout, 1)
        end, 0)
end

function WanFaView:onButtonClick_(item, eventType)
    if eventType == 2 or eventType == 3 then
        item:setScale(1)
        if eventType == 2 then
            self:removeSelf()
        end
    elseif eventType == 0 then
        gameAudio.playSound("sounds/common/sound_button_click.mp3")
        item:setScale(0.9)
    end
end

return WanFaView 

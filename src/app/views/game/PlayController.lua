local BaseItem = import("app.views.BaseItem")
local PlayController = class("PlayController",BaseItem)

function PlayController:ctor(model)
    self.table_ = model
    PlayController.super.ctor(self)
end

function PlayController:setNode(node)
    self.csbNode_ = node
    self:initElement_()
end

function PlayController:showButsByType(bool, cType)
    self.csbNode_:setVisible(bool)
    print("=======cType==========",cType)
    if cType == 2 then
        self.chuPaiButton_:setEnabled(false)
        self.chuPaiButton_:setBright(false)
        self.tiShiButton_:setEnabled(false)
        self.tiShiButton_:setBright(false)
        self.buYaoButton_:setEnabled(true)
        self.buYaoButton_:setBright(true)
    elseif cType == 1 then
        self.chuPaiButton_:setEnabled(true)
        self.chuPaiButton_:setBright(true)
        self.tiShiButton_:setEnabled(true)
        self.tiShiButton_:setBright(true)
        self.buYaoButton_:setEnabled(true)
        self.buYaoButton_:setBright(true)
    elseif cType == 3 then
        self.chuPaiButton_:setEnabled(true)
        self.chuPaiButton_:setBright(true)
        self.tiShiButton_:setEnabled(true)
        self.tiShiButton_:setBright(true)
        self.buYaoButton_:setEnabled(false)
        self.buYaoButton_:setBright(false)
    end
end

function PlayController:chuPaiButtonHandler_(item)
    local player = display.getRunningScene():getHostPlayer()
    player:doChuPai()
end

function PlayController:tiShiButtonHandler_(item)
    local player = display.getRunningScene():getHostPlayer()
    player:doTiShi()
end

function PlayController:buYaoButtonHandler_(item)
     display.getRunningScene():playerPass()
end

return PlayController 

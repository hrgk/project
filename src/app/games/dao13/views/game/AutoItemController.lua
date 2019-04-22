local BaseItem = import("app.views.BaseItem")
local AutoItemController = class("AutoItemController", BaseItem)

function AutoItemController:ctor()
    AutoItemController.super.ctor(self)
end

function AutoItemController:setPalyerController(palyerController)
    self.palyerController_ = palyerController
end

function AutoItemController:setNode(node)
    AutoItemController.super.setNode(self, node)
    self:initElementRecursive_(self.csbNode_)
end

function AutoItemController:update(data,index)
    self.data_ = data
    self.index_ = index
    if self.data_[1].type > 9 then
        self.pt_:hide()
        self:showTS()
    else 
        self.ts_:hide()
        self:showPT()
    end
end

function AutoItemController:showPT()
    self.pt_:show()
    for i = 1,3 do
        local pic = string.format("views/games/d13/caozuo/font/autoFont/%d.png", self.data_[i].type)
        self["dao" .. i .. "_"]:loadTexture(pic)
    end
end

function AutoItemController:showTS()
    self.ts_:show()
    local pic = string.format("views/games/d13/caozuo/font/autoFont/%d.png", self.data_[1].type)
    self.type_:loadTexture(pic)
end

function AutoItemController:selectPTHandler_()
    self.palyerController_:setAutoDaoCard(self.data_,self.index_)
end

function AutoItemController:selectTSHandler_()
    self.palyerController_:setAutoDaoCard(self.data_,self.index_)
end

function AutoItemController:showGuangQuan(index)
    self.selectShow_:setVisible(self.index_ == index)
end

return AutoItemController 

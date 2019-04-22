local BaseView = import("app.views.BaseView")
local BaseCreateView = class("BaseCreateView",BaseView)

function BaseCreateView:ctor()
    BaseCreateView.super.ctor(self)
    self:setScale(0.9)
end

function BaseCreateView:setData(data)
    
end

function BaseCreateView:setShowZFType(showZFType)
    if not showZFType then
        return
    end
    -- if showZFType == 0 then
    --     if self.zhifu1_:isSelected() then
    --         self:zhifu3Handler_()
    --     end
    --     self.zhifu1_:hide()
    --     self.zhifu1Tip_:hide()
    
    if showZFType == 1 then
        if SPECIAL_PROJECT then
            --todo
        else
            self.zhifu1_:setPositionX(self.zhifu3_:getPositionX())
            self.zhifu1Tip_:setPositionX(self.zhifu3Tip_:getPositionX())
            self.zhifu3_:hide()
            self.zhifu2_:hide()
            self.zhifu3Tip_:hide()
            self.zhifu2Tip_:hide()
            self:zhifu1Handler_()
        end
    end
end

return BaseCreateView 

local PlayerHead = import("app.views.PlayerHead")
local ChaGuanHead = class("ChaGuanHead", PlayerHead)

function ChaGuanHead:initOtherView_()
    self.flag = nil
    if self.data_.permission == 0 then
        self.flag = display.newSprite("res/images/julebu/clubMembers/t1.png"):addTo(self.csbNode_):pos(-18,18)
    elseif self.data_.permission == 1  then
        self.flag = display.newSprite("res/images/julebu/clubMembers/t2.png"):addTo(self.csbNode_):pos(-18,18)
    elseif self.data_.uid == selfData:getUid() then
        self.flag = display.newSprite("res/images/julebu/clubMembers/my.png"):addTo(self.csbNode_):pos(-18,18)
    end
end

function ChaGuanHead:setNode(node)
    ChaGuanHead.super.setNode(self, node)
    self.head_:setSwallowTouches(false)
end


function ChaGuanHead:hideOtherView_()
    if self.flag and not tolua.isnull(self.flag) then
        self.flag:hide()
    end
end

function ChaGuanHead:setOtherViewPos_(x,y)
    if self.flag and not tolua.isnull(self.flag) then
        self.flag:pos(x,y)
    end
end

function ChaGuanHead:headHandler_()
    if self.noClick_ then return end
    display.getRunningScene():initChaGuanPlayerInfo(self.data_)
end

return ChaGuanHead  

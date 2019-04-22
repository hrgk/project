local BaseAlgorithm = import("app.games.csmj.utils.BaseAlgorithm")
local MaJiangChi = import(".MaJiangChi")
local MaJiang = class("MaJiang", function()
    return display.newSprite()
end)

-- local suits = {}
-- suits[1] = "#wan/mjb_b_"
-- suits[2] = "#suo/mjb_b_"
-- suits[3] = "#tong/mjb_b_"

local beiMian = {}
beiMian[1] = "#res/images/majiang/majiang/mjbgs_r.png"
beiMian[2] = "#res/images/majiang/majiang/mjbgs_r.png"
beiMian[3] = "#res/images/majiang/majiang/mjbgs_t.png"
beiMian[4] = "#res/images/majiang/majiang/mjbgs_l.png"

local moPaiMian = {}
moPaiMian[1] = "#res/images/majiang/majiang/mjbgd_big.png"
moPaiMian[2] = "#res/images/majiang/majiang/mjbgd_r.png"
moPaiMian[3] = "#res/images/majiang/majiang/mjbgd_t.png"
moPaiMian[4] = "#res/images/majiang/majiang/mjbgd_l.png"

local directions = {}
directions[1] = {"#res/images/majiang/majiang/wan/mjb_b_", "#res/images/majiang/majiang/suo/mjb_b_", "#res/images/majiang/majiang/tong/mjb_b_"}
directions[2] = {"#res/images/majiang/majiang/wan/mj_r_", "#res/images/majiang/majiang/suo/mj_r_", "#res/images/majiang/majiang/tong/mj_r_"}
directions[3] = {"#res/images/majiang/majiang/wan/mj_t_", "#res/images/majiang/majiang/suo/mj_t_", "#res/images/majiang/majiang/tong/mj_t_"}
directions[4] = {"#res/images/majiang/majiang/wan/mj_l_", "#res/images/majiang/majiang/suo/mj_l_", "#res/images/majiang/majiang/tong/mj_l_"}

function MaJiang:ctor(card, index)
    display.addSpriteFrames("res/images/majiang/majiang.plist", "res/images/majiang/majiang.png")
    self.card_ = card
    self.index_ = index
    self.flag_ = 0
    local path = self:clacMaJiangName_()
    self.maJiangSp_ = display.newSprite(path):addTo(self)
    self.moPaiSp_ = display.newSprite(moPaiMian[self.index_]):addTo(self)
    self.moPaiSp_:setVisible(false)
    if self.index_ == 1 then
        self:setTouchEnabled(true)
        self:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self,self.onTouch_))
    end
end

function MaJiang:isShowMoPaiMian(bool)
    self.moPaiSp_:setVisible(bool)
    -- self.moPaiSp_:setVisible(false)
    self.maJiangSp_:setVisible(not bool)
end

function MaJiang:setMaJiangPos(x, y)
    self.oldX_ = x
    self.oldY_ = y
    self:setPosition(x, y)
end

function MaJiang:onTouch_(event)
    if event.name == "began" then
        self:onTouchBegin_(event)
        return true
    elseif event.name == "moved" then
        self:onTouchMoved_(event)
        return true
    elseif event.name == "ended" then
        self:onTouchEnded_(event)
        return true
    end
end

function MaJiang:onTouchBegin_(event)
    local p = self:getParent():convertToNodeSpace(cc.p(event.x,event.y))
end

function MaJiang:onTouchMoved_(event)
    local p = self:getParent():convertToNodeSpace(cc.p(event.x,event.y))
    self.endY_ = p.y
    self:setPosition(p.x,p.y)
end

function MaJiang:onTouchEnded_(event)
    local p = self:getParent():convertToNodeSpace(cc.p(event.x,event.y))
    self.endY_ = p.y
    if self.endY_ - 0 >= 100 then
        display.getRunningScene():chuPai(self.card_)
    else
        transition.moveTo(self, {x= self.oldX_, y = self.oldY_,time = 0.2})
    end
end

function MaJiang:setFlag(flag)
    self.flag_ = flag
end

function MaJiang:getFlag()
    return self.flag_
end

function MaJiang:getCard()
    return self.card_
end

function MaJiang:clacMaJiangName_()
    if self.card_ == 0 then 
        local path = beiMian[self.index_]
        return path
    end
    local suit = BaseAlgorithm.getSuit(self.card_)
    local value = BaseAlgorithm.getValue(self.card_)
    local suits = directions[self.index_]
    return suits[suit] .. value .. ".png"
end

function MaJiang:qiShouHu(card)
    self.maJiangSp_:hide()
    self.tp_ = MaJiangChi.new(card, self.index_):addTo(self)
end

function MaJiang:qiShouHuOver()
    self.maJiangSp_:show()
    if self.tp_ then
        self.tp_:removeSelf()
        self.tp_ = nil
    end
end

return MaJiang 

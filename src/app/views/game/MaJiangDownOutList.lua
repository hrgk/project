local MaJiangOut = import(".MaJiangOut")
local MaJiangDownOutList = class("MaJiangDownOutList", function()
    return display.newSprite()
end)

function MaJiangDownOutList:ctor(cards, index)
    self.maJiangList_ = {}
    self:initList_(cards, index)
end

function MaJiangDownOutList:initList_(cards, index)
    self.index_ = index
    self.maJiangCount_ = 0
    self.ceng_ = 0
    self.row_ = 0
    for i,v in ipairs(cards) do
        local x, y = self:clacMaJiangPos_()
        local maJiang = MaJiangOut.new(v, index):addTo(self):pos(x,y)
        self.maJiangCount_ = self.maJiangCount_ + 1
        table.insert(self.maJiangList_, maJiang)
    end
end

function MaJiangDownOutList:addMaJiang(card)
    local x, y = self:clacMaJiangPos_()
    local maJiang = MaJiangOut.new(card, self.index_):addTo(self):pos(x,y)
    self.maJiangCount_ = self.maJiangCount_ + 1
    table.insert(self.maJiangList_, maJiang)
end

function MaJiangDownOutList:clacMaJiangPos_()
    self.ceng_ = math.floor(self.maJiangCount_ / 9)
    self.row_ = math.mod(self.maJiangCount_, 9)
    local x = (self.row_)* 38 -  150
    local y = self.ceng_ * (-50)
    return x, y
end

function MaJiangDownOutList:delMaJiang(card)
    self.maJiangCount_ = self.maJiangCount_ - 1
    self.ceng_ = math.floor(self.maJiangCount_ / 9)
    self.row_ = math.mod(self.maJiangCount_, 9)
    local maJiang = self.maJiangList_[#self.maJiangList_]
    table.removebyvalue(self.maJiangList_, maJiang)
    self:removeChild(maJiang)
    maJiang = nil
end
    dump("删除")

return MaJiangDownOutList  

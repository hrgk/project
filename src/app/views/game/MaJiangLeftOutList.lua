local MaJiangOut = import(".MaJiangOut")
local MaJiangLeftOutList = class("MaJiangLeftOutList", function()
    return display.newSprite()
end)

function MaJiangLeftOutList:ctor(cards, index)
    self.maJiangList_ = {}
    self:initList_(cards, index)
end

function MaJiangLeftOutList:initList_(cards, index)
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

function MaJiangLeftOutList:clacMaJiangPos_()
    self.row_ = math.mod(self.maJiangCount_, 8)
    self.ceng_ = math.floor(self.maJiangCount_ / 8)
    local y = self.row_* -33 + 115
    local x = self.ceng_ * (-55) - 120
    return x, y
end

function MaJiangLeftOutList:addMaJiang(card)
    local x, y = self:clacMaJiangPos_()
    local maJiang = MaJiangOut.new(card, self.index_):addTo(self):pos(x,y)
    self.maJiangCount_ = self.maJiangCount_ + 1
    table.insert(self.maJiangList_, maJiang)
end

function MaJiangLeftOutList:delMaJiang(card)
    self.maJiangCount_ = self.maJiangCount_ - 1
    self.ceng_ = math.floor(self.maJiangCount_ / 8)
    self.row_ = math.mod(self.maJiangCount_, 8)
    local maJiang = self.maJiangList_[#self.maJiangList_]
    table.removebyvalue(self.maJiangList_, maJiang)
    self:removeChild(maJiang)
    maJiang = nil
    dump("删除")
end

return MaJiangLeftOutList  

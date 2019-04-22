local XinRenZongZuan = class("XinRenZongZuan", function()
    return display.newSprite()
    end)

function XinRenZongZuan:ctor()
    local view = display.newSprite("res/images/huodong/zhuceyouli.jpg"):addTo(self)
end

return XinRenZongZuan 

local BaiWanXuanShang = class("BaiWanXuanShang", function()
    return display.newSprite()
    end)

function BaiWanXuanShang:ctor()
    local view = display.newSprite("res/images/xiaoxi/baiwanxuanshang.png"):addTo(self)
end

return BaiWanXuanShang   

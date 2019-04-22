local DaiLiZhaoMu = class("DaiLiZhaoMu", function()
    return display.newSprite()
    end)

function DaiLiZhaoMu:ctor()
    local view = display.newSprite("res/images/xiaoxi/dailishenqing.png"):addTo(self)
    local btnPath = "res/images/xiaoxi/btn_fuzhi.png"
    self.copyBtn_ = ccui.Button:create(btnPath, btnPath, btnPath)
    self.copyBtn_:setSwallowTouches(false)  
    self.copyBtn_:setPosition(0, -250)
    self:addChild(self.copyBtn_)
    self.copyBtn_:addTouchEventListener(handler(self, self.onButtonClick_))
end

function DaiLiZhaoMu:onButtonClick_(sender, eventType)
    if (2== eventType) then  
        gailun.native.copy("yageqipai168")
        app:showTips("复制成功!")
    end
end

return DaiLiZhaoMu  

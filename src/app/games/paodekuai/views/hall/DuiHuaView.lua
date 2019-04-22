local DuiHuaView = class("DuiHuaView", gailun.BaseView)
local TYPES = gailun.TYPES
local nodes = {
    type = TYPES.ROOT,
    children = {
        {type = TYPES.SPRITE, filename = "res/images/duihua/juxing.png", x = display.cx, y = display.bottom + 150, scale9 = true, size = {1280, 300}, capInsets = cc.rect(10, 10, 10, 10), children = {
        {type = TYPES.SPRITE, var = "actorPng_"},
        {type = TYPES.SPRITE, var = "actorNamePng_"},
        {type = TYPES.LABEL, var = "word_", options = {text = "提示", size = 48, font = DEFAULT_FONT, color = cc.c4b(255, 255, 255, 255)}, ppx = 0.5, ppy = 0.5, ap = {0.5, 0.5}},
        }
      },
    }
}

function DuiHuaView:ctor(data)
    gailun.uihelper.render(self, nodes)
    local headPng = display.newSprite(data.actorPng):addTo(self.actorPng_)
    local namePng = display.newSprite(data.actorName):addTo(self.actorNamePng_)
    self.word_:setString(data.word)
    if data.director == 1 then
        headPng:setPosition(120, 200)
        namePng:setPosition(350, 280)
    else
        headPng:setPosition(1100, 200)
        namePng:setPosition(850, 280)
    end
end

return DuiHuaView

local JiFuXiZeView = class("JiFuXiZeView", gailun.BaseView)

local TYPES = gailun.TYPES
local nodes = {
    type = TYPES.ROOT, children = {
            {type = TYPES.SPRITE, filename = "res/images/jifu/jifu_ditu.png", px = 0.5, py = 0.44 ,scale9 = true, size ={914, 522}},
            {type = TYPES.SPRITE, filename = "res/images/jifu/activity_xize.png", px = 0.498, py = 0.45, ap = {0.5, 0.5}},
            {type = TYPES.LABEL, var = "activityTime_", options = {text="", size = 24, 
            font = DEFAULT_FONT, color = cc.c4b(255, 255, 255, 255)}, px = 0.5, py = 0.75, ap = {0.5, 0.5}},
        }
}

function JiFuXiZeView:ctor()
    gailun.uihelper.render(self, nodes)
end

function JiFuXiZeView:update(str)
    self.activityTime_:setString(str)
end

return JiFuXiZeView 

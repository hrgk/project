local GameMarqueeView = class("GameMarqueeView", gailun.BaseView)
local TYPES = gailun.TYPES
local bg_width, bg_height = 600, 30
local data = {
    type = TYPES.ROOT,
    children = {
        {type = TYPES.LAYER, children = {
                {type = TYPES.SPRITE, filename = "res/images/game/guizetiao.png", var = "spriteBg_", scale9 = true, opacity = 128, size = {bg_width, bg_height}, children = {
                }},
                {type = TYPES.CLIPPING_NODE, var = "nodeMarquee_", rect = cc.rect(0, 0, 1, 1), children = {
                    {type = TYPES.LABEL, var = "labelNotice_", options = {text = "", size = 24, font = DEFAULT_FONT, color = cc.c4b(255, 215, 51, 255)}, ap = {0,0.5}}
                }},
            }
        }
    }
}

-- 重新加工界面中的位置及大小信息
function GameMarqueeView:reFormatData_(x, y)
    local data = data
    data.children[1].children[1].x = x
    data.children[1].children[1].y = y

    self.textX_, self.textY_ = (x + bg_width / 2), y - 1
    data.children[1].children[2].children[1].x = self.textX_
    data.children[1].children[2].children[1].y = self.textY_

    local left_x, left_y = (display.width - bg_width) / 2 + 55, y - bg_height / 2
    local clip_width = bg_width - 55 - 20
    local clip_height = bg_height
    data.children[1].children[2].rect = cc.rect(left_x-660* display.width / DESIGN_WIDTH, left_y, clip_width, clip_height)
    return data
end

function GameMarqueeView:ctor(x, y)
    local data = self:reFormatData_(x, y)
    gailun.uihelper.render(self, data)
end

-- 创建一个来回的动作
function GameMarqueeView:createAction_()
    local size = self.labelNotice_:getContentSize()
    local moveX = bg_width + size.width
    local speed = 480 / 10
    local seconds = checkint(moveX / speed)
    local actionMoveTo = cc.MoveBy:create(seconds, cc.p(-moveX, 0)) --移动
    local sequence = transition.sequence({ --按顺序来执行
        cc.CallFunc:create(function ()
            self.labelNotice_:pos(self.textX_, self.textY_)
        end),
        actionMoveTo,
    })
    return cc.RepeatForever:create(sequence) --一直重复
end

function GameMarqueeView:run(msg)
    local content = msg
    self.labelNotice_:setString(content)
    self.labelNotice_:runAction(self:createAction_())
end

return GameMarqueeView

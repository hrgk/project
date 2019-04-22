local MarqueeView = class("MarqueeView", gailun.BaseView)
local TYPES = gailun.TYPES
local bg_width, bg_height = display.width / 3 * 2+72, 50
local data = {
    type = TYPES.ROOT,
    children = {
        {type = TYPES.LAYER, children = {
                {type = TYPES.SPRITE, filename = "res/images/common/paoma_bg.png", var = "spriteBg_", scale9 = true, opacity = 128, size = {bg_width, bg_height}, children = {
                    {type = TYPES.SPRITE, filename = "res/images/common/xiaolaba.png", ppx = 0.03, ppy = 0.5},
                }},
                {type = TYPES.CLIPPING_NODE, var = "nodeMarquee_", rect = cc.rect(0, 0, 1, 1), children = {
                    {type = TYPES.LABEL, var = "labelNotice_", options = {text = "", size = 30, font = DEFAULT_FONT, color = cc.c4b(239, 233, 199, 255)}, ap = {0,0.5}}
                }},
            }
        }
    }
}

-- 重新加工界面中的位置及大小信息
function MarqueeView:reFormatData_(x, y)
    local data = data
    data.children[1].children[1].x = x
    data.children[1].children[1].y = y

    self.textX_, self.textY_ = x + bg_width / 2, y - 1
    data.children[1].children[2].children[1].x = self.textX_
    data.children[1].children[2].children[1].y = self.textY_

    local left_x, left_y = (display.width - bg_width) / 2 + 55, y - bg_height / 2
    local clip_width = bg_width - 55 - 20
    local clip_height = bg_height
    data.children[1].children[2].rect = cc.rect(left_x, left_y, clip_width, clip_height)
    return data
end

function MarqueeView:ctor(x, y)
    local data = self:reFormatData_(x, y)
    gailun.uihelper.render(self, data)
end

-- 创建一个来回的动作
function MarqueeView:createAction_()
    local size = self.labelNotice_:getContentSize()
    local moveX = bg_width + size.width -350
    local speed = 872 / 8.5
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

function MarqueeView:run(msg)
    transition.stopTarget(self.labelNotice_)
    local content = msg or StaticConfig:get("sysBroadcast")
    self.labelNotice_:setString(content)
    self.labelNotice_:runAction(self:createAction_())
end

return MarqueeView

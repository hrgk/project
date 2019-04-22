local ReviewActionView = class("ReviewActionView", gailun.BaseView)
local TYPES = gailun.TYPES

local posListX = {51, 113, 171, 231, 293, 350}
local posListY = {350, 293, 231, 171, 113, 51}
local bg_width, bg_height = 400, 58
local buttonY = 0.52
local data1 = {
    type = TYPES.ROOT,
    children = {
        {type = TYPES.SPRITE, scale9 = true, filename = "mages/replay/review_bg.png", size = bgSize, var = "spriteBg_", children = {
            {type = TYPES.SPRITE, var = "spriteChiBg_", filename = "#action_chi.png", x = posListX[1], ppy = buttonY, scale = 0.5, isGray = true },
            {type = TYPES.SPRITE, var = "spritePengBg_", filename = "#action_peng.png", x = posListX[2], ppy = buttonY, scale = 0.5, isGray = true },
            {type = TYPES.SPRITE, var = "spriteGangBg_", filename = "#action_gang.png", x = posListX[3], ppy = buttonY, scale = 0.5, isGray = true },
            {type = TYPES.SPRITE, var = "spriteBuBg_", filename = "#action_bu.png", x = posListX[4], ppy = buttonY, scale = 0.5, isGray = true },
            {type = TYPES.SPRITE, var = "spriteHuBg_", filename = "#action_hu.png", x = posListX[5], ppy = buttonY, scale = 0.5, isGray = true },
            {type = TYPES.SPRITE, var = "spritePassBg_", filename = "#action_pass.png", x = posListX[6], ppy = buttonY, scale = 0.5, isGray = true },

            {type = TYPES.SPRITE, var = "spriteChi_", filename = "#action_chi.png", x = posListX[1], ppy = buttonY, scale = 0.5, },
            {type = TYPES.SPRITE, var = "spritePeng_", filename = "#action_peng.png", x = posListX[2], ppy = buttonY, scale = 0.5, },
            {type = TYPES.SPRITE, var = "spriteGang_", filename = "#action_gang.png", x = posListX[3], ppy = buttonY, scale = 0.5, },
            {type = TYPES.SPRITE, var = "spriteBu_", filename = "#action_bu.png", x = posListX[4], ppy = buttonY, scale = 0.5, },
            {type = TYPES.SPRITE, var = "spriteHu_", filename = "#action_hu.png", x = posListX[5], ppy = buttonY, scale = 0.5, },
            {type = TYPES.SPRITE, var = "spritePass_", filename = "#action_pass.png", x = posListX[6], ppy = buttonY, scale = 0.5, },

            {type = TYPES.SPRITE, var = "spriteHand_", filename = "#review_hand.png", x = posListX[2], ppy = 0.2},
        }},
    }
}

function ReviewActionView:ctor()
    -- display.addSpriteFrames("textures/replay.plist", "textures/replay.png")
    gailun.uihelper.render(self, data1)
end

function ReviewActionView:hideAllLight_()
    self.spriteChi_:hide()
    self.spritePeng_:hide()
    self.spriteGang_:hide()
    self.spriteBu_:hide()
    self.spriteHu_:hide()
    self.spritePass_:hide()
end

-- 根据点亮的功能来显示对应的图标
function ReviewActionView:lightByActions_(actions)
    self.spritePass_:show()
    if table.indexof(actions, ACTIONS.PENG) then
        self.spritePeng_:show()
    end
    if table.indexof(actions, ACTIONS.CHI) then
        self.spriteChi_:show()
    end
    if table.indexof(actions, ACTIONS.AN_GANG) or 
        table.indexof(actions, ACTIONS.CHI_GANG) or 
        table.indexof(actions, ACTIONS.BU_GANG) then
        self.spriteGang_:show()
    end
    if table.indexof(actions, ACTIONS.CHI_HU) or 
        table.indexof(actions, ACTIONS.ZI_MO) then
        self.spriteHu_:show()
    end
end

local mini_pos = {
    {display.cx, 210},
    {display.width * 1044 / DESIGN_WIDTH, display.cy},
    {display.cx, display.height * 590 / DESIGN_HEIGHT},
    {display.width * 336 / DESIGN_WIDTH, display.cy},
}
function ReviewActionView:adjustPos_(index)
    local x, y = unpack(mini_pos[index] or {0, 0})
    self:pos(x, y)
end

function ReviewActionView:adjustShape_(index)
    if index == TABLE_HHQMT_DIRECTION.BOTTOM then
        return self:toWider_()
    end
    return self:toHigher_()
end

function ReviewActionView:calcButtonPos_(i, x, y, list)
    local nx, ny = x, y
    if not nx then
        nx = list[i]
    elseif not ny then
        ny = list[i]
    end
    return nx, ny
end

function ReviewActionView:setPosOfButtons_(x, y, list)
    local buttons1 = {self.spriteChi_, self.spritePeng_, self.spriteGang_, self.spriteBu_, self.spriteHu_, self.spritePass_}
    local buttons2 = {self.spriteChiBg_, self.spritePengBg_, self.spriteGangBg_, self.spriteBuBg_, self.spriteHuBg_, self.spritePassBg_}
    for i,v in ipairs(buttons1) do
        local nx, ny = self:calcButtonPos_(i, x, y, list)
        v:pos(nx, ny)
        buttons2[i]:pos(nx, ny)
    end
end

function ReviewActionView:toWider_()
    self.spriteBg_:setContentSize(cc.size(bg_width, bg_height))
    self:setPosOfButtons_(nil, buttonY * bg_height, posListX)
end

function ReviewActionView:toHigher_()
    self.spriteBg_:setContentSize(cc.size(bg_height, bg_width))
    self:setPosOfButtons_(bg_height / 2, nil, posListY)
end

function ReviewActionView:setHandIndex_(direction, index)
    local nx, ny, ox, oy
    if direction == TABLE_HHQMT_DIRECTION.LEFT or direction == TABLE_HHQMT_DIRECTION.RIGHT then
        nx, ny = self:calcButtonPos_(index, bg_height / 2, nil, posListY)
        ox = 10
        oy = -20
    else
        nx, ny = self:calcButtonPos_(index, nil, buttonY * bg_height, posListX)
        ox = 10
        oy = -20
    end
    self.spriteHand_:pos(nx + ox, ny + oy)
end

function ReviewActionView:showHand_(direction, data)
    local index = 6
    if ACTIONS.CHI == data.actType then
        index = 1
    elseif ACTIONS.PENG == data.actType then
        index = 2
    elseif table.indexof({ACTIONS.CHI_GANG, ACTIONS.AN_GANG, ACTIONS.BU_GANG}, data.actType) then
        index = 3
    elseif table.indexof({ACTIONS.CHI_HU, ACTIONS.ZI_MO}, data.actType) then
        index = 5
    end
    self:setHandIndex_(direction, index)
end

function ReviewActionView:showWithData(index, data, actions)
    self:cleanup()
    self:show()
    self:hideAllLight_()
    self:adjustPos_(index)
    self:adjustShape_(index)
    self:lightByActions_(actions or {})
    self:showHand_(index, data)
    self:performWithDelay(handler(self, self.hide), 1)
end

return ReviewActionView

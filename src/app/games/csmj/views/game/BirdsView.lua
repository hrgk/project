local BaseAlgorithm = require("app.games.csmj.utils.BaseAlgorithm")
local BirdsView = class("BirdsView", gailun.BaseView)
local TYPES = gailun.TYPES

local RES_SCALE = 1 / 0.6

local player_pos = {
    {0.061, 0.308},
    {0.94, 0.594},
    {0.79, 0.88},
    {0.061, 0.635},
}

local adjust_ready_x = 200
local ready_pos = {
    {display.cx, display.height * 0.3},
    {display.width * 0.7, display.cy},
    {display.cx, display.height * 0.75},
    {display.width * 0.3, display.cy},
}

local OFFSET_OF_SEATS_4 = {}
for i,v in ipairs(player_pos) do
    OFFSET_OF_SEATS_4[i] = {display.width * v[1], display.height * v[2]}
    ready_pos[i][2] = OFFSET_OF_SEATS_4[i][2]
end

ready_pos[1][1] = OFFSET_OF_SEATS_4[1][1] + adjust_ready_x
ready_pos[2][1] = OFFSET_OF_SEATS_4[2][1] - adjust_ready_x
ready_pos[3][1] = OFFSET_OF_SEATS_4[3][1] - adjust_ready_x + 70
ready_pos[4][1] = OFFSET_OF_SEATS_4[4][1] + adjust_ready_x

ready_pos[3][2] = ready_pos[3][2] - 60

local nodes = {
    type = TYPES.ROOT, children = {
        {type = TYPES.LAYER_COLOR, color = {0, 0, 0, 100}},
        {type = TYPES.NODE, var = "nodeAnim_", children = {
            -- {type = TYPES.SPRITE, var = "spriteNumBg_", filename = "#mj/bird_bg.png", px = 0.5, py = 595, scale = RES_SCALE},
            {type = TYPES.NODE, var = "spriteNumBg_", px = 0.5, py = 595, scale = RES_SCALE},
        }},
    }
}

function BirdsView:ctor(data)
    display.addSpriteFrames("textures/game_anims.plist", "textures/game_anims.png")
    print("============BirdsView==================")
    dump(data)
    gailun.uihelper.render(self, nodes)
    self:showBirds_(data)
end

-- isBird(card, isZiMo, isSortBird, isTongPao, jiePaoIndex, fangPaoIndex)
local isZiMo = false
local isSortBird = true
local isTongPao = false
local jiePaoIndex = {3, 1}
local fangPaoIndex = 4

function BirdsView:createLightAt_(x, y)
    local sprite = display.newSprite("#mj/birdanimbg1.png"):addTo(self.nodeAnim_, -1):pos(x, y):scale(RES_SCALE)
    -- local frames = display.newFrames("birdanimbg%d.png", 1, 12)
    local frames = {}
    for i=1,12 do
        local frame = display.newSpriteFrame(string.format("mj/birdanimbg%d.png", i))
        table.insert(frames, frame)
    end
    local animation = display.newAnimation(frames, 1.5 / 12)
    sprite:playAnimationForever(animation) -- 播放动画

    for i=1, #self.maJiangTb do
        if self.maJiangTb[i].isAction then
            self.maJiangTb[i].sprite = sprite
            self.maJiangTb[i].isAction = false
            break
        end
    end
end

function BirdsView:createBird_(bird, total, index, birdCount, zhuangIndex, zhuangType)
    self.cardIndx = self.cardIndx or 1
    local x, y = self:calcBirdPos_(total, index)
    local maJiang = app:createConcreteView("MaJiangView", 0, MJ_TABLE_DIRECTION.BOTTOM, false, true):addTo(self.nodeAnim_):pos(x, y)
    maJiang:setOpacity(120)
    transition.fadeTo(maJiang, {time = 0.2, opacity = 255})
    local count = 1
    maJiang:turn(bird)
    local tb = {}
    tb.maJiang = maJiang
    local playerCount = self.data_.playerCount
    local isSortBird = self.data_.isSortBird
    if not isSortBird then
        playerCount = 4
    end
    local ret, birdShunXu, startSeatID = BaseAlgorithm.isBird(bird, isZiMo, isSortBird, isTongPao, jiePaoIndex, fangPaoIndex,zhuangIndex,zhuangType, playerCount)
    for i=1, #birdShunXu do
        if birdShunXu[i](bird, startSeatID, playerCount) then
            local index = self.data_.tableController:getPlayerBySeatID(i):getIndex()
            tb.index = index
            break
        end
    end
    if ret then
        tb.isAction = true
    end
    table.insert(self.maJiangTb, tb)
    self:performWithDelay(function ()
        if BaseAlgorithm.isBird(bird, isZiMo, isSortBird, isTongPao, jiePaoIndex, fangPaoIndex, zhuangIndex, zhuangType, playerCount) then
            self:performWithDelay(function ()
                self:createLightAt_(x, y + 14)
                maJiang:clearMaxLowLight()
            end, (total - index) * 0.2 + birdCount * 0.2)
            count = count + 1
        end
    end, index * 0.2)
end

function BirdsView:calcBirdPos_(total, index)
    local x, y = display.cx, display.cy + 30
    local width = 130
    x = x + index * width - total * width / 2 - width / 2
    return x, y
end

function BirdsView:showBirds_(data)
    self.data_ = data
    isZiMo, isSortBird, isTongPao, jiePaoIndex, fangPaoIndex = BaseAlgorithm.getZhongNiaoParams(data)
    local zhuangIndex = data.zhuangIndex
    local zhuangType = data.zhuangType
    self.data_.isSortBird = isSortBird
    local cards = data.birdList
    self.maJiangTb = {}
    local birdCount = 0

    if self.data_.oneBrid then
        local huUser = data.huInfo
        for i,v in ipairs(huUser) do
            local x, y = self:calcBirdPos_(1, 1)
            local maJiang = app:createConcreteView("MaJiangView", 0, MJ_TABLE_DIRECTION.BOTTOM, false, true):addTo(self.nodeAnim_):pos(x, y)
            maJiang:setOpacity(120)
            transition.fadeTo(maJiang, {time = 0.2, opacity = 255})
            local count = 1
            maJiang:turn(cards[1])
            local tb = {}
            tb.maJiang = maJiang
            tb.index = self.data_.tableController:getPlayerBySeatID(v.seatID):getIndex()
            tb.isAction = true
            table.insert(self.maJiangTb, tb)
            self:performWithDelay(function ()
                self:performWithDelay(function ()
                    self:createLightAt_(x, y + 14)
                    maJiang:clearMaxLowLight()
                end, (#huUser - i) * 0.2 + birdCount * 0.2)
                count = count + 1
            end, i * 0.2)
        end
        local delayTime = #huUser * 0.2 + 0.8 + 0.5
        local indextb = {1, 1, 1, 1}
        for i,v in ipairs(huUser) do
            if self.maJiangTb[i] then
                self:performWithDelay(function ()
                    local x = ready_pos[self.maJiangTb[i].index][1] + (indextb[self.maJiangTb[i].index] - 1) * 130
                    if self.maJiangTb[i].index == 2 or self.maJiangTb[i].index == 3 then
                        x = ready_pos[self.maJiangTb[i].index][1] - (indextb[self.maJiangTb[i].index] - 1) * 130
                    end
                    indextb[self.maJiangTb[i].index] = indextb[self.maJiangTb[i].index] + 1
                    local y = ready_pos[self.maJiangTb[i].index][2]
                    local action = cc.MoveTo:create(0.1, cc.p(x, y))
                    self.maJiangTb[i].maJiang:runAction(action)
                    if self.maJiangTb[i].sprite then
                        local action1 = cc.MoveTo:create(0.1, cc.p(x, y + 14))
                        self.maJiangTb[i].sprite:runAction(action1)
                    end
                end, delayTime)
                delayTime = delayTime + 0.1
            end
        end
    else
        for i,v in ipairs(cards) do
            if BaseAlgorithm.isBird(v, isZiMo, isSortBird, isTongPao, jiePaoIndex, fangPaoIndex, zhuangIndex, zhuangType, data.playerCount) then
                birdCount = birdCount + 1
            end
            self:createBird_(v, #cards, i, birdCount, zhuangIndex, zhuangType)
        end
        local delayTime = #cards * 0.2 + 0.8 + 0.5
        local indextb = {1, 1, 1, 1}
        if not isSortBird then return end
        for i,v in ipairs(cards) do
            if self.maJiangTb[i] then
                self:performWithDelay(function ()
                    local x = ready_pos[self.maJiangTb[i].index][1] + (indextb[self.maJiangTb[i].index] - 1) * 130
                    if self.maJiangTb[i].index == 2 or self.maJiangTb[i].index == 3 then
                        x = ready_pos[self.maJiangTb[i].index][1] - (indextb[self.maJiangTb[i].index] - 1) * 130
                    end
                    indextb[self.maJiangTb[i].index] = indextb[self.maJiangTb[i].index] + 1
                    local y = ready_pos[self.maJiangTb[i].index][2]
                    local action = cc.MoveTo:create(0.1, cc.p(x, y))
                    self.maJiangTb[i].maJiang:runAction(action)
                    if self.maJiangTb[i].sprite then
                        local action1 = cc.MoveTo:create(0.1, cc.p(x, y + 14))
                        self.maJiangTb[i].sprite:runAction(action1)
                    end
                end, delayTime)
                delayTime = delayTime + 0.1
            end
        end
    end
end


return BirdsView

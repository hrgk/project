local TYPES = gailun.TYPES

local node = {
    type = TYPES.ROOT,
    children = {
        {type = TYPES.SPRITE, filename = "views/club/leftBg.png", scale9 = true, size = {300, display.height - 100}, ap = {0, 0}, x = display.left, y = display.bottom, capInsets = cc.rect(10, 10, 10, 10) },
        {type = TYPES.LIST_VIEW, 
            var = "gameTypeList_",
            size = {300, display.height - 130},
            x = 0,
            y = 0,
            ap = {0, 0},
            options = {
                        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL, 
                        viewRect = cc.rect(10, 10, 280, display.height - 130),
                        },
        }
    }
}

local GameType = require("app.views.chaguan.ClubGameType")
local ClubLeft = class("ClubLeft", gailun.BaseView)

function ClubLeft:ctor()
    gailun.uihelper.render(self, node)

    self.callback = nil
    self.gameTypeList = {}
end

-- 未添加的游戏用0填充, {1, 2, 0, 0, 0}
function ClubLeft:setGameTypeList(list)
    self.gameTypeData = list
end

function ClubLeft:setCallback(callback)
    self.callback = callback
end

function ClubLeft:clickCallback(index, gameType)
    self:updateByIndex(index)
end

function ClubLeft:updateByIndex(index)
    self.callback(index, self.gameTypeData[index])
    self.gameTypeList_:removeAllItems()
    if index > #self.gameTypeData or index < 1 then
        index = 1
    end

    for i, floorData in ipairs(self.gameTypeData) do
        local layout = self.gameTypeList_:newItem()
        local gameTypeView = GameType.new(i, handler(self, self.clickCallback))
        local isChoice = index == i
        gameTypeView:updateView(floorData, isChoice)
        local width, height = gameTypeView:getViewSize()
        layout:setItemSize(width, height, true)
        layout:addContent(gameTypeView)
        self.gameTypeList_:addItem(layout)
    end
    self.gameTypeList_:reload()
end

return ClubLeft
local BaseElement = import("app.views.BaseElement")

local GameType = class("GameType", BaseElement)

local prefix = "views/club/gameIcon/"
local suffix = ".png"



local gameTypeMap = {
    [0] = "playAdd",
    [GAME_PAODEKUAI] = "pdk",
    [GAME_MJZHUANZHUAN] = "zzmj",
    [GAME_MJHONGZHONG] = "hzmj",
    [GAME_CDPHZ] = "cdphz",
    [GAME_MJCHANGSHA] = "csmj",
    [GAME_YXHZP] = "yxph",
    [GAME_DA_TONG_ZI] = "dtz",
    [GAME_BCNIUNIU] = "bcps",
    [GAME_SHUANGKOU] = "sk",
    [GAME_13DAO] = "d13",
    [GAME_YZCHZ] = "yzchz",
    [GAME_HSMJ] = "hsmj",
    [GAME_MMMJ] = "mmmj",
    [GAME_FHHZMJ] = "fhhzmj",
    [GAME_FHLMZ] = "nxzmz",
    [GAME_HHQMT] = "hhqmt",
    [GAME_SYBP] = "sybp",
    [GAME_LDFPF] = "ldfpf",
    -- [GAME_BCNIUNIU] = "psf",
}

if SPECIAL_PROJECT then
    gameTypeMap = {
    [0] = "playAdd",
    [GAME_PAODEKUAI] = "pdk",
    [GAME_MJZHUANZHUAN] = "zzmj",
    [GAME_MJHONGZHONG] = "hzmj",
    [GAME_LDFPF] = "ldfpf",
    }
end

function GameType:ctor(index, callback)
    GameType.super.ctor(self)
    self:initElementRecursive_(self.csbNode_)

    self.clickNowGame_:setSwallowTouches(false)
    self.clickGame_:setSwallowTouches(false)
    -- self.addGame_:setSwallowTouches(false)

    self.index = index
    self.callback = callback
    self.width = 244
    self.height = 90

    self.elevator_:setVisible(false)
    self.clickGame_:setVisible(false)

    local elevatorIndex = 1
    self:schedule(function ()
        elevatorIndex = elevatorIndex + 1

        local index = elevatorIndex % 2
        self["elevator" .. index .. "_"]:setVisible(true)
        index = (index + 1) % 2
        self["elevator" .. index .. "_"]:setVisible(false)
    end, 0.5)
end

function GameType:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/club/gameType.csb"):addTo(self)
    self.csbNode_:setPosition(-122, 70)
end

function GameType:getViewSize()
    return self.width, self.height
end

function GameType:updateEditRoomView(gameType, isChoice)
    if gameType == nil then
        return
    end

    self.data = {game_type = gameType}

    self.elevator_:setVisible(false)
    self.clickGame_:setVisible(true)

    if self.addTag == nil then
        local spr = display.newSprite("views/club/choiceGame/addTag.png")
        spr:setAnchorPoint(cc.p(1, 1))
        local size = self.clickGame_:getContentSize()
        spr:setPosition(cc.p(size.width, size.height))
        self.clickGame_:addChild(spr)
        self.addTag = spr
    end

    self:setVisible(gameType ~= nil)

    if isChoice then
        self.csbNode_:setColor(cc.c4b(115, 164, 164, 255)) 
        self.addTag:setVisible(false)
    else
        self.csbNode_:setColor(cc.c4b(255, 255, 255, 255)) 
        self.addTag:setVisible(true)
    end
    self.clickGame_:loadTexture(prefix .. gameTypeMap[gameType] .. "2" .. suffix)
    self.csbNode_:setPosition(0, 0)
end

function GameType:updateChoiceView(gameType, isChoice)
    if gameType == nil then
        return
    end

    self.data = {game_type = gameType}
    print(gameType, "gameType1")

    self.elevator_:setVisible(false)
    self.clickGame_:setVisible(true)

    self:setVisible(gameType ~= nil)

    if self.addTag == nil then
        local spr = display.newSprite("views/club/choiceGame/addTag.png")
        spr:setAnchorPoint(cc.p(1, 1))
        local size = self.clickGame_:getContentSize()
        spr:setPosition(cc.p(size.width, size.height))
        self.clickGame_:addChild(spr)
        self.addTag = spr
    end

    if self.choiceBg == nil then
        local spr = display.newSprite("views/club/choiceGame/choiceBg.png")
        spr:setPosition(self.clickGame_:getPosition())
        self.csbNode_:addChild(spr, -1)
        self.choiceBg = spr
    end

    self.choiceBg:setVisible(isChoice == true)
    print("====gameTypeMap[gameType]=========",gameTypeMap[gameType])
    self.clickGame_:loadTexture(prefix .. gameTypeMap[gameType] .. "2" .. suffix)
    self.csbNode_:setPosition(0, 0)
end

function GameType:updateView(floorData, isChoice)
    self.data = floorData
    local gameType = floorData.game_type
    if gameTypeMap[gameType] == nil then
        return
    end

    if isChoice == false then
        self.clickGame_:loadTexture(prefix .. gameTypeMap[gameType] .. "0" .. suffix)
        self.elevator_:setVisible(false)
        self.clickGame_:setVisible(true)
        self.csbNode_:setPosition(-122, 70)
        self.height = 90
    else
        self.nowGame_:setTexture(prefix .. gameTypeMap[gameType] .. "1" .. suffix)
        self.elevator_:setVisible(true)
        self.clickGame_:setVisible(false)
        self.height = 240
        self.csbNode_:setPosition(-122, 130)
    end
end

function GameType:clickGameHandler_()
    self.callback(self.index, self.data)
end

function GameType:addGameHandler_()
    self.callback(self.index, self.data)
end

function GameType:clickNowGameHandler_()
    self.callback(self.index, self.data)
end

return GameType
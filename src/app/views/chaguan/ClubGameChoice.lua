-- local BaseGameResult = import("app.views.BaseGameResult")
-- local ClubGameChoice =class("ClubGameChoice", BaseGameResult)
local BaseView = import("app.views.BaseView")
local ClubGameChoice =class("ClubGameChoice", BaseView)

local GameType = require("app.views.chaguan.ClubGameType")
local ChaGuanData = import("app.data.ChaGuanData")

function ClubGameChoice:ctor(data, callback)
    ClubGameChoice.super.ctor(self)
    self.callback = callback
    self:setMask(0)

    if ChaGuanData:getMatchType() == 1 then
        self.nowGame = clone(GAME_CHAMPION)
    else
        self.nowGame = clone(GAME_CLUB)
    end

    for i = #self.nowGame, 1, -1 do
        if table.indexof(data, self.nowGame[i]) then
            table.remove(self.nowGame, i)
        end
    end
    local roomInfoList = {}
    if SPECIAL_PROJECT then
        roomInfoList = {
        [GAME_PAODEKUAI] = {
            switch = CHANNEL_CONFIGS.PAO_DE_KUAI,
        },
        [GAME_MJHONGZHONG] = {
            switch = CHANNEL_CONFIGS.CHANG_SHA_MA_JIANG,
        },
        [GAME_MJZHUANZHUAN] = {
            switch = CHANNEL_CONFIGS.ZHUAN_ZHUAN_MA_JIANG,
        },
        [GAME_LDFPF] = {
            switch = CHANNEL_CONFIGS.LDFPF,
        },
        }
    else
        roomInfoList = {
        [GAME_CDPHZ] = {
            switch = CHANNEL_CONFIGS.CDPHZ,
        },
        [GAME_PAODEKUAI] = {
            switch = CHANNEL_CONFIGS.PAO_DE_KUAI,
        },
        [GAME_MJCHANGSHA] = {
            switch = CHANNEL_CONFIGS.CHANG_SHA_MA_JIANG,
        },
        [GAME_MJZHUANZHUAN] = {
            switch = CHANNEL_CONFIGS.ZHUAN_ZHUAN_MA_JIANG,
        },
        [GAME_DA_TONG_ZI] = {
            switch = CHANNEL_CONFIGS.DA_TONG_ZI,
        },
        [GAME_BCNIUNIU] = {
            switch = CHANNEL_CONFIGS.BING_CHENG_NIU_NIU,
        },
        [GAME_MJHONGZHONG] = {
            switch = CHANNEL_CONFIGS.HONG_ZHONG_MA_JIANG,
        },
        [GAME_HSMJ] = {
            switch = CHANNEL_CONFIGS.HSMJ,
        },
        [GAME_SHUANGKOU] = {
            switch = CHANNEL_CONFIGS.SHUANG_KOU,
        },
        [GAME_13DAO] = {
            switch = CHANNEL_CONFIGS.DAO13,
        },
        [GAME_FHHZMJ] = {
            switch = CHANNEL_CONFIGS.FHHZMJ,
        },
        [GAME_FHLMZ] = {
            switch = CHANNEL_CONFIGS.GAME_FHLMZ,
        },
        [GAME_SYBP] = {
            switch = CHANNEL_CONFIGS.SYBP,
        },
        [GAME_LDFPF] = {
            switch = CHANNEL_CONFIGS.LDFPF,
        },
    }
    end

    for i = #self.nowGame, 1, -1 do
        print("i===",i,"self.nowGame[i]===",self.nowGame[i],"roomInfoList[self.nowGame[i]]===",roomInfoList[self.nowGame[i]])
        if not roomInfoList[self.nowGame[i]].switch then
            table.remove(self.nowGame, i)
        end
    end

    self.nowChoice = -1

    self:initTableView_()
end

function ClubGameChoice:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/club/choiceGame/choiceGame.csb"):addTo(self)
    self.csbNode_:setPosition(display.cx + 120, display.cy - 80)
end

function ClubGameChoice:closeBtnHandler_()
    self:removeFromParent()
end

function ClubGameChoice:closeGameBtnHandler_()
    self.callback(self.nowChoice, false)
    self:removeFromParent()
end

function ClubGameChoice:addGameBtnHandler_()
    if self.nowChoice ~= -1 then
        self.callback(self.nowChoice, true)
    end
    self:removeFromParent()
end

function ClubGameChoice:initTableView_()
    self.tableView_ = cc.TableView:create(cc.size(860, 420))      --列表的显示区域的大小
    self.tableView_:setDirection(1)         --设置列表是竖直方向
    self.tableView_:setVerticalFillOrder(0)
    -- self.tableView_:setPosition(10, 110)
    self.tableView_:registerScriptHandler(handler(self, self.cellSizeForTable_), cc.TABLECELL_SIZE_FOR_INDEX)
    self.tableView_:registerScriptHandler(handler(self, self.tableCellAtIndex_), cc.TABLECELL_SIZE_AT_INDEX)
    self.tableView_:registerScriptHandler(handler(self, self.tableCellTouched_), cc.TABLECELL_TOUCHED)
    self.tableView_:registerScriptHandler(handler(self, self.numberOfCellsInTableView_), cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.tableViewNode_:addChild(self.tableView_)
    self.tableView_:reloadData()
end

function ClubGameChoice:cellSizeForTable_(table, idx)
    return 110, 860
end

function ClubGameChoice:choiceGame(_, data)
    self.nowChoice = data.game_type
    self.tableView_:reloadData()
end

function ClubGameChoice:tableCellAtIndex_(table, idx)
    local cell = table:dequeueCell() 
    local index = idx + 1 
    local base = idx * 3
    if nil == cell then  
        cell = cc.TableViewCell:new() 

        for i = 1, 3 do
            local item = GameType.new(nil, handler(self, self.choiceGame))
            item:updateChoiceView(self.nowGame[base + i], self.nowGame[base + i] == self.nowChoice)
            item:setPosition(cc.p((i - 1) * 260 + 30, 115))  
            item:setName("1" .. i)  
            cell:addChild(item)  
        end
    else  
        for i = 1, 3 do
            local item = cell:getChildByName("1" .. i)
            item:updateChoiceView(self.nowGame[base + i], self.nowGame[base + i] == self.nowChoice)
        end
    end
    return cell  
end

function ClubGameChoice:tableCellTouched_(table, cell)
end

function ClubGameChoice:numberOfCellsInTableView_()
    return math.ceil(#self.nowGame / 3)
end


return ClubGameChoice 

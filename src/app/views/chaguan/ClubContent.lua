local TYPES = gailun.TYPES

local node = {
    type = TYPES.ROOT,
    children = {
        {type = TYPES.NODE, var = "tableViewNode_", x = display.cx - 300, y = display.bottom}, --公共牌容器
    }
}

local ClubScoreTable = require("app.views.chaguan.ClubScoreTable")
local ClubCircleScoreTable = require("app.views.chaguan.ClubCircleScoreTable")
local ClubGameSetting = require("app.views.chaguan.ClubGameSetting")
local ClubContent = class("ClubContent", gailun.BaseView)
local ChaGuanData = import("app.data.ChaGuanData")

function ClubContent:ctor()
    gailun.uihelper.render(self, node)
    self.itemList_ = {}

    self.tableList = {}
    self.tableTemplate = ClubScoreTable
    self:initTableView_()
    self.subFloorList = {}
    self:bindEvent()
end

function ClubContent:bindEvent()
    cc.EventProxy.new(dataCenter, self, true)
    :addEventListener(httpMessage.GET_SUB_FLOOR, handler(self, self.onGetSubFloorHandler_))
    :addEventListener(httpMessage.GET_SUB_FLOOR2, handler(self, self.onGetSubFloorHandler2_))
    :addEventListener(httpMessage.ADD_SUB_FLOOR, handler(self, self.onAddSubFloorHandler_))
    :addEventListener(httpMessage.EDIT_SUB_FLOOR, handler(self, self.onEditSubFloorHandler_))
    :addEventListener(httpMessage.DEL_SUB_FLOOR, handler(self, self.onDelSubFloorHandler_))
end

function ClubContent:updateRooms()
end

function ClubContent:onGetSubFloorHandler_(event)
    if not self:isVisible() then
        return
    end

    local data = json.decode(event.data.result)
    
    if data.status == 1 then
        data = data.data
        if data.floor == 0 then
            return
        end
        ChaGuanData.setFloorGameConfig(data.floor, data.data)

        if #data.data == 0 and (ChaGuanData.getClubInfo().permission == 1 or ChaGuanData.getClubInfo().permission == 0) then
            app:showTips("请设置当前游戏玩法规则")
            self:clickTable({game_type = 0})
            -- display.getRunningScene():openGameChoice()
        end
    else
    end
end

function ClubContent:onGetSubFloorHandler2_(event)
    local data = json.decode(event.data.result)
    print("match_config ====",data.data.data.match_config)
    clubScoreRuleData:setNowRule(data.data.data)
end

function ClubContent:onAddSubFloorHandler_(event)
    if not self:isVisible() then
        return
    end

    local data = json.decode(event.data.result)
    if data.status ~= 1 then
        app:alert(CLUB_HTTP_ERR[data.status])
    end
    ChaGuanData.requestGetSubFloor()
    ChaGuanData.requestRoomList()
end

function ClubContent:onEditSubFloorHandler_(event)
    if not self:isVisible() then
        return
    end

    local data = json.decode(event.data.result)
    if data.status == -33 then
        app:showTips("修改失败，钻石不足。")
    end

    ChaGuanData.requestGetSubFloor()
    ChaGuanData.requestRoomList()
end

function ClubContent:onDelSubFloorHandler_(event)
    if not self:isVisible() then
        return
    end
    ChaGuanData.requestGetSubFloor()
    ChaGuanData.requestRoomList()
end

function ClubContent:initTableView_()
    self.tableView_ = cc.TableView:create(cc.size(1000, 520))      --列表的显示区域的大小
    self.tableView_:setDirection(1)         --设置列表是竖直方向
    self.tableView_:setVerticalFillOrder(0)
    -- self.tableView_:setPosition(-560, -250+20)
    self.tableView_:registerScriptHandler(handler(self, self.cellSizeForTable_), cc.TABLECELL_SIZE_FOR_INDEX)
    self.tableView_:registerScriptHandler(handler(self, self.tableCellAtIndex_), cc.TABLECELL_SIZE_AT_INDEX)
    self.tableView_:registerScriptHandler(handler(self, self.tableCellTouched_), cc.TABLECELL_TOUCHED)
    self.tableView_:registerScriptHandler(handler(self, self.numberOfCellsInTableView_), cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.tableViewNode_:addChild(self.tableView_)
    self.tableView_:reloadData()
end

function ClubContent:updateView(data)
    self:initTableInfo()
    local data = clone(data)
    table.sort(data, function(lh, rh)
        if lh.subFloor ~= rh.subFloor then
            return lh.subFloor < rh.subFloor
        elseif lh.status ~= rh.status then
            return lh.status > rh.status
        end

        return #lh.playerList > #rh.playerList
    end)

    local floorInfo = ChaGuanData.getNowFloorInfo()
    local floor = ChaGuanData.getFloorGameConfig(floorInfo.id) or {}

    if ChaGuanData.getClubInfo().permission == 0 or ChaGuanData.getClubInfo().permission == 1 then
        local subFloorRoomsCount = {}
        for k, v in ipairs(data) do
            if subFloorRoomsCount[v.subFloor] == nil then
                subFloorRoomsCount[v.subFloor] = 0
            end
            subFloorRoomsCount[v.subFloor] = subFloorRoomsCount[v.subFloor] + 1
        end

        local isNull = false
        for k = #floor, 1, -1 do
            local v = floor[k]
            if subFloorRoomsCount[v.id] == nil then
                isNull = true
                table.insert(data, 1, self:createTable(v))
            end
        end

        if isNull then
            -- app:showTips("钻石不足,游戏将不能自动开桌,请及时充值")
        end
    end

    if ChaGuanData.getClubInfo().permission == 1 or ChaGuanData.getClubInfo().permission == 0 then
        if ChaGuanData.getNowFloorInfo().game_type ~= 0 and #floor < 6 then
            table.insert(data, {game_type = 0})
        end
    end

    self.tableList = data
    if self.tableView_ and not tolua.isnull(self.tableView_) then
        self.tableView_:reloadData()
    end
end

function ClubContent:createTable(subFloor)
    local config = clone(json.decode(subFloor.play_config))

    config.ruleDetails = json.encode(config.ruleDetails)
    config.roundIndex = 0
    config.owner = ChaGuanData.getClubInfo().uid
    config.matchType = config.matchType
    config.players = {}
    config.tid = 0
    config.subFloor = subFloor.id
    config.isFaker = true

    return config
end

function ClubContent:initTableInfo()
    local floorInfo = ChaGuanData.getNowFloorInfo()

    local template = nil

    if table.indexof({GAME_BCNIUNIU}, floorInfo.game_type) then
        template = ClubCircleScoreTable
    else
        template = ClubScoreTable
    end

    -- if template ~= self.tableTemplate then
    --     self.tableViewNode_:removeAllChildren(true)
    --     self:initTableView_()
    -- end

    self.tableTemplate = template
end

function ClubContent:cellSizeForTable_(table, idx)
    return 230, 1000
end

function ClubContent:updateZhuoZiByTid_(tid)
    for k,v in pairs(self.itemList_) do
        if v:getTid() == tid then
            if tolua.isnull(v) then
                return
            end
            v:update(ChaGuanData.getRoomInfoByTid(tid))
        end
    end
end

function ClubContent:tableCellAtIndex_(table, idx)
    local cell = table:dequeueCell() 
    local index = idx + 1 

    local interval, padding, y, count = self:getTableParams()
    local base = idx * count
    if nil == cell then  
        cell = cc.TableViewCell:new() 
    end

    if cell:getName() ~= self.tableTemplate.className then
        cell:removeAllChildren()
    end

    for i = 0, count - 1 do
        local tid = (self.tableList[base + i + 1] or {}).tid

        local item = cell:getChildByName("1" .. i)

        if item == nil then
            item = self.tableTemplate.new()
            item:setCallback(handler(self, self.clickTable))
            cell:addChild(item)  
            item:setName("1" .. i) 
        end

        item:setPosition(cc.p(i * interval + padding, y))  
        item:update(self.tableList[base + i + 1], ChaGuanData.getRoomInfoByTid(tid))

        self.itemList_[base + i + 1 ] = item
    end

    cell:setName(self.tableTemplate.className)

    return cell  
end

function ClubContent:getTableParams()
    if self.tableTemplate.className == ClubCircleScoreTable.className then
        return 500, 180, 115, 2
    end

    return 300, 150, 115, 3
end

function ClubContent:tableCellTouched_(table, cell)
end

function ClubContent:numberOfCellsInTableView_()
    local _, _, _, count = self:getTableParams()
    return math.ceil(#self.tableList / count)
end

function ClubContent:clickTable(data)
    local floorConfig = ChaGuanData.getNowFloorInfo()
    local matchType = ChaGuanData.getMatchType()
    local clubId = ChaGuanData.getClubID()
    local subFloor = data.id
    if data.game_type == 0 then
        self:showClubGameSetting(floorConfig, matchType, subFloor, true)
    end
end

function ClubContent:showClubGameSetting(floorConfig, matchType, subFloor, isAdd)
    local gameSettingView = ClubGameSetting.new(floorConfig, matchType, subFloor, isAdd)
    display.getRunningScene():addChild(gameSettingView)
end

return ClubContent
local TYPES = gailun.TYPES

local node = {
    type = TYPES.ROOT,
    children = {
        {type = TYPES.NODE, var = "tableViewNode_", x = display.left + 50, y = display.bottom}, --公共牌容器
    }
}

local ClubScoreTable = require("app.views.chaguan.ClubScoreTable")
local ClubCircleScoreTable = require("app.views.chaguan.ClubCircleScoreTable")
local ClubGameSetting = require("app.views.chaguan.ClubGameSetting")
local ClubHallContent = class("ClubHallContent", gailun.BaseView)
local ChaGuanData = import("app.data.ChaGuanData")

function ClubHallContent:ctor()
    gailun.uihelper.render(self, node)
    self.itemList_ = {}

    self.tableList = {}
    self.tableTemplate = ClubScoreTable
    self:initTableView_()
    self.subFloorList = {}
end

function ClubHallContent:updateRooms()
end

function ClubHallContent:onGetSubFloorHandler_(event)
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

function ClubHallContent:onAddSubFloorHandler_(event)
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

function ClubHallContent:onEditSubFloorHandler_(event)
    if not self:isVisible() then
        return
    end

    ChaGuanData.requestGetSubFloor()
    ChaGuanData.requestRoomList()
end

function ClubHallContent:onDelSubFloorHandler_(event)
    if not self:isVisible() then
        return
    end

    ChaGuanData.requestGetSubFloor()
    ChaGuanData.requestRoomList()
end

function ClubHallContent:initTableView_()
    self.tableView_ = cc.TableView:create(cc.size(1280, 520))      --列表的显示区域的大小
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

function ClubHallContent:formatData(data)
    local beforeFloor = nil
    local beforeSubFloor = nil

    local result = {{}}
    local lineCount = 0
    for _, tableData in ipairs(data) do
        -- if beforeFloor ~= tableData.floor or self:getNowTableCount(result[#result]) >= 4 then
        if self:getNowTableCount(result[#result]) >= 3.3 then
            table.insert(result, {})
        end

        beforeFloor = tableData.floor
        beforeSubFloor = tableData.subFloor

        table.insert(result[#result], tableData)
    end

    return result
end

function ClubHallContent:getNowTableParams(tableData)
    local tableMap = {
        [0] = {
            perch = 1,
            table = ClubScoreTable
        },
        [GAME_BCNIUNIU] = {
            perch = 1.5,
            table = ClubCircleScoreTable
        }
    }

    return tableMap[tableData.gameType] or tableMap[0]
end

function ClubHallContent:getNowTableCount(line, index)
    local length = 0
    index = index or math.huge
    for i, v in ipairs(line) do
        if i > index then
            return length
        end

        length = length + self:getNowTableParams(v).perch
    end

    return length
end

function ClubHallContent:updateView(data)
    self:initTableInfo()
    data = clone(data)

    table.sort(data, function(lh, rh)
        if lh.floor ~= rh.floor then
            return lh.floor < rh.floor
        elseif lh.subFloor ~= rh.subFloor then
            return lh.subFloor < rh.subFloor
        elseif lh.status ~= rh.status then
            return lh.status > rh.status
        end

        return #lh.playerList > #rh.playerList
    end)

    data = self:formatData(data)

    -- local floorInfo = ChaGuanData.getNowFloorInfo()
    -- local floor = ChaGuanData.getFloorGameConfig(floorInfo.id) or {}
    -- if ChaGuanData.getClubInfo().permission == 1 or ChaGuanData.getClubInfo().permission == 0 then
    --     if ChaGuanData.getNowFloorInfo().game_type ~= 0 and #floor < 4 then
    --         table.insert(data, {game_type = 0})
    --     end
    -- end

    self.tableList = data
    if self.tableView_ and not tolua.isnull(self.tableView_) then
        self.tableView_:reloadData()
    end
end

function ClubHallContent:initTableInfo()
    local floorInfo = ChaGuanData.getNowFloorInfo()

    local template = nil

    -- if table.indexof({GAME_BCNIUNIU}, floorInfo.game_type) then
        template = ClubCircleScoreTable
    -- else
    --     template = ClubScoreTable
    -- end

    -- if template ~= self.tableTemplate then
    --     self.tableViewNode_:removeAllChildren(true)
    --     self:initTableView_()
    -- end

    self.tableTemplate = template
end

function ClubHallContent:cellSizeForTable_(table, idx)
    return 230, 1000
end

function ClubHallContent:updateZhuoZiByTid_(tid)
    for k,v in pairs(self.itemList_) do
        if v:getTid() == tid then
            if tolua.isnull(v) then
                return
            end
            v:update(ChaGuanData.getRoomInfoByTid(tid))
        end
    end
end

function ClubHallContent:tableCellAtIndex_(table, idx)
    local cell = table:dequeueCell() 
    local index = idx + 1 

    if nil == cell then  
        cell = cc.TableViewCell:new() 
    end

    local posX = 0

    for i = 1, 4 do
        local data = self.tableList[index][i]
        local tid = (data or {}).tid

        local interval, padding, y, tableClass, perch = self:getTableParams(data)
        local realIndex = self:getNowTableCount(self.tableList, i)

        local item = cell:getChildByName("" .. i)
        if item ~= nil and tableClass.className ~= item.className then
            item:removeFromParent()
            item = nil
        end

        if item == nil then
            item = tableClass.new()
            item:setCallback(handler(self, self.clickTable))
            cell:addChild(item)  
            item:setName("" .. i) 
        end

        posX = posX + perch * interval
        item:setPosition(cc.p(posX + padding, y))  
        item:updateHallView(data, ChaGuanData.getRoomInfoByTid(tid))
    end

    return cell  
end

function ClubHallContent:getTableParams(data)
    local params = self:getNowTableParams(data or {gameType = 0})
    if params.table == ClubCircleScoreTable then
        return 280, -220, 115, params.table, params.perch
    end

    return 300, -150, 115, params.table, params.perch
end

function ClubHallContent:tableCellTouched_(table, cell)
end

function ClubHallContent:numberOfCellsInTableView_()
    return #self.tableList
end

function ClubHallContent:clickTable(data)
    local floorConfig = ChaGuanData.getNowFloorInfo()
    local matchType = ChaGuanData.getMatchType()

    local subFloor = data.id
    if data.game_type == 0 then
        self:showClubGameSetting(floorConfig, matchType, subFloor, true)
    end
end

function ClubHallContent:showClubGameSetting(floorConfig, matchType, subFloor, isAdd)
    local gameSettingView = ClubGameSetting.new(floorConfig, matchType, subFloor, isAdd)
    display.getRunningScene():addChild(gameSettingView)
end

return ClubHallContent
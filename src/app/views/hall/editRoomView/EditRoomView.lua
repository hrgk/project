local BaseView = import("app.views.BaseView")
local EditRoomView = class("EditRoomView", BaseView)
local TabButton = import("app.views.TabButton")
local GameType = require("app.views.chaguan.ClubGameType")
local ChaGuanData = import("app.data.ChaGuanData")

function EditRoomView:ctor(nowGameList, callback)
    EditRoomView.super.ctor(self)
    self.nowGame = clone(GAME_COMMON)
    self.callback = callback

    self.nowGameList = clone(nowGameList or {})

    createRoomData:setOpenGameList(self.nowGameList)
    self:initGamesButton_()
    -- self:initScrollView()
    self:initTabButtonList_()
    -- self:updateView_(#self.iconList_)
end

function EditRoomView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/editCreateRoom/editCreateRoomView.csb"):addTo(self)
    self.csbNode_:setPosition(display.cx, display.cy)
end

function EditRoomView:initTabButtonList_()
    self.tableView_ = cc.TableView:create(cc.size(250, 602)) --列表的显示区域的大小
    self.tableView_:setDirection(1) --设置列表是竖直方向
    self.tableView_:setPosition(0, -9)
    self.tableView_:registerScriptHandler(handler(self, self.cellSizeForTable_), cc.TABLECELL_SIZE_FOR_INDEX)
    self.tableView_:registerScriptHandler(handler(self, self.tableCellAtIndex_), cc.TABLECELL_SIZE_AT_INDEX)
    self.tableView_:registerScriptHandler(handler(self, self.tableCellTouched_), cc.TABLECELL_TOUCHED)
    self.tableView_:registerScriptHandler(handler(self, self.numberOfCellsInTableView_), cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.content_:addChild(self.tableView_)
    self.tableView_:zorder(100)
    self.tableView_:reloadData()

    -- 未选中游戏
    self.tableViewNotOpen_ = cc.TableView:create(cc.size(960, 450))      --列表的显示区域的大小
    self.tableViewNotOpen_:setDirection(1)         --设置列表是竖直方向
    self.tableViewNotOpen_:setVerticalFillOrder(0)
    self.tableViewNotOpen_:registerScriptHandler(handler(self, self.cellSizeForTableNotOpen_), cc.TABLECELL_SIZE_FOR_INDEX)
    self.tableViewNotOpen_:registerScriptHandler(handler(self, self.tableCellAtIndexNotOpen_), cc.TABLECELL_SIZE_AT_INDEX)
    self.tableViewNotOpen_:registerScriptHandler(handler(self, self.tableCellTouchedNotOpen_), cc.TABLECELL_TOUCHED)
    self.tableViewNotOpen_:registerScriptHandler(handler(self, self.numberOfCellsInTableViewNotOpen_), cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.csbNode_:addChild(self.tableViewNotOpen_)
    self.tableViewNotOpen_:zorder(101)
    self.tableViewNotOpen_:setPosition(-420, -210)

    self.tableViewNotOpen_:reloadData()
end

function EditRoomView:initGamesButton_()
    self.iconList_ = {}
    self.iconMap = {}

    local roomInfoList = {
        [GAME_CDPHZ] = {
            spr = {"res/images/createRoom/btn_cdphz_n.png", "res/images/createRoom/btn_cdphz_o.png"},
            game = GAME_CDPHZ,
            switch = CHANNEL_CONFIGS.CDPHZ,
            name = "CDPHZ"
        },
        [GAME_PAODEKUAI] = {
            spr = {"res/images/createRoom/btn_pdk_n.png", "res/images/createRoom/btn_pdk_o.png"},
            game = GAME_PAODEKUAI,
            switch = CHANNEL_CONFIGS.PAO_DE_KUAI,
            name = "PAO_DE_KUAI"
        },
        [GAME_MJCHANGSHA] = {
            spr = {"res/images/createRoom/btn_csmj_n.png", "res/images/createRoom/btn_csmj_o.png"},
            game = GAME_MJCHANGSHA,
            switch = CHANNEL_CONFIGS.CHANG_SHA_MA_JIANG,
            name = "CHANG_SHA_MA_JIANG"
        },
        [GAME_MMMJ] = {
            spr = {"res/images/createRoom/btn_mmmj_n.png", "res/images/createRoom/btn_mmmj_o.png"},
            game = GAME_MMMJ,
            switch = CHANNEL_CONFIGS.MO_MO_MA_JIANG,
            name = "MO_MO_MA_JIANG"
        },
        [GAME_MJZHUANZHUAN] = {
            spr = {"res/images/createRoom/btn_zzmj_n.png", "res/images/createRoom/btn_zzmj_o.png"},
            game = GAME_MJZHUANZHUAN,
            switch = CHANNEL_CONFIGS.ZHUAN_ZHUAN_MA_JIANG,
            name = "ZHUANG_ZHUANG_MA_JIANG"
        },
        [GAME_DA_TONG_ZI] = {
            spr = {"res/images/createRoom/btn_dtz_n.png", "res/images/createRoom/btn_dtz_o.png"},
            game = GAME_DA_TONG_ZI,
            switch = CHANNEL_CONFIGS.DA_TONG_ZI,
            name = "DA_TONG_ZI"
        },
        [GAME_BCNIUNIU] = {
            spr = {"res/images/createRoom/btn_niuniu_n.png", "res/images/createRoom/btn_niuniu_o.png"},
            game = GAME_BCNIUNIU,
            switch = CHANNEL_CONFIGS.BING_CHENG_NIU_NIU,
            name = "BING_CHENG_NIU_NIU"
        },
        [GAME_MJHONGZHONG] = {
            spr = {"res/images/createRoom/btn_hzmj_n.png", "res/images/createRoom/btn_hzmj_o.png"},
            game = GAME_MJHONGZHONG,
            switch = CHANNEL_CONFIGS.HONG_ZHONG_MA_JIANG,
            name = "HONG_ZHONG_MA_JIANG"
        },
        [GAME_SHUANGKOU] = {
            spr = {"res/images/createRoom/btn_sk_n.png", "res/images/createRoom/btn_sk_o.png"},
            game = GAME_SHUANGKOU,
            switch = CHANNEL_CONFIGS.SHUANG_KOU,
            name = "SHUANG_KOU"
        },
        [GAME_13DAO] = {
            spr = {"res/images/createRoom/btn_13d_n.png", "res/images/createRoom/btn_13d_o.png"},
            switch = CHANNEL_CONFIGS.DAO13,
            name = "DAO13",
            game = GAME_13DAO,
        },
        [GAME_YZCHZ] = {
            spr = {"res/images/createRoom/btn_yzchz_n.png", "res/images/createRoom/btn_yzchz_o.png"},
            game = GAME_YZCHZ,
            switch = CHANNEL_CONFIGS.YZCHZ,
            name = "YZCHZ"
        },
        [GAME_HSMJ] = {
            spr = {"res/images/createRoom/btn_hsmj_n.png", "res/images/createRoom/btn_hsmj_o.png"},
            switch = CHANNEL_CONFIGS.HSMJ,
            name = "HSMJ",
            game = GAME_HSMJ,
        },
        [GAME_FHHZMJ] = {
            spr = {"res/images/createRoom/btn_fhhzmj_n.png", "res/images/createRoom/btn_fhhzmj_o.png"},
            game = GAME_FHHZMJ,
            switch = CHANNEL_CONFIGS.FHHZMJ,
            name = "FHHZMJ"
        },
        [GAME_FHLMZ] = {
            spr = {"res/images/createRoom/btn_nxzmz_n.png", "res/images/createRoom/btn_nxzmz_o.png"},
            game = GAME_FHLMZ,
            switch = CHANNEL_CONFIGS.GAME_FHLMZ,
            name = "GAME_FHLMZ"
        },
        [GAME_HHQMT] = {
            spr = {"res/images/createRoom/btn_hhqmt_n.png", "res/images/createRoom/btn_hhqmt_o.png"},
            game = GAME_HHQMT,
            switch = CHANNEL_CONFIGS.HHQMT,
            name = "HHQMT"
        },
        [GAME_SYBP] = {
            spr = {"res/images/createRoom/btn_sybp_n.png", "res/images/createRoom/btn_sybp_o.png"},
            game = GAME_SYBP,
            switch = CHANNEL_CONFIGS.SYBP,
            name = "SYBP"
        },
        [GAME_LDFPF] = {
            spr = {"res/images/createRoom/btn_ldfpf_n.png", "res/images/createRoom/btn_ldfpf_o.png"},
            game = GAME_LDFPF,
            switch = CHANNEL_CONFIGS.LDFPF,
            name = "LDFPF"
        },
    }
    for k, v in ipairs(self.nowGameList) do
        local roomInfo = roomInfoList[v]
        if roomInfo ~= nil and roomInfo.switch ~= false and table.indexof(self.nowGameList, roomInfo.game) then
            table.insert(self.iconList_, 1, roomInfo)
            self.iconMap[roomInfo.game] = roomInfo
        end
    end
    for i = #self.nowGame, 1, -1 do
        if not roomInfoList[self.nowGame[i]].switch then
            table.remove(self.nowGame, i)
        end
    end
end

function EditRoomView:cellSizeForTable_(table, idx)
    return 121, 250
end

function EditRoomView:tableCellAtIndex_(table, idx)
    local cell = table:dequeueCell()
    local index = idx + 1
    if nil == cell then
        cell = cc.TableViewCell:new()
        local item = TabButton.new()
        item:updateEditRoom(self.iconList_[index], index)
        item:setPosition(cc.p(0, 55 + 4))
        item:setEditRoomCallback(handler(self, self.click))
        item:setTag(123)
        cell:addChild(item)
    else
        local item = cell:getChildByTag(123)
        if nil ~= item then
            item:updateEditRoom(self.iconList_[index], index)
            item:setEditRoomCallback(handler(self, self.click))
        end
    end
    return cell
end

function EditRoomView:click(data)
    if #self.nowGameList == 1 then
        app:showTips("最少需要保留一个游戏")
        return
    end

    for k, game in ipairs(self.nowGameList) do
        if game == data.game then
            table.remove(self.nowGameList, k)
            break
        end
    end

    self:updateAll()
end

function EditRoomView:updateView_(index)
    if self.currentIndex_ == index then
        return
    end
    self.currentIndex_ = index
    for i, v in pairs(self.itemList_) do
        v:updateState(self.currentIndex_ == i)
    end
    if self.itemList_[index] then
        self.itemList_[index]:updateState(true)
    end
    self:removeCurrentView_()
    local name = self.nameList_[index]
    self.history[name] = tonumber(os.time())
    createRoomData:setGameHistory(json.encode(self.history))
    if self.activityList_[self.currentIndex_] then
        self.activityList_[self.currentIndex_](data)
    else
        self:hide()
    end
end

function EditRoomView:tableCellTouched_(table, cell)
end

function EditRoomView:numberOfCellsInTableView_()
    return #self.iconList_
end

function EditRoomView:createRoomHandler_()
    app:showLoading("正在创建房间。。。。")
    local params = self.currView_:calcCreateRoomParams()
    HttpApi.createRoom(params, handler(self, self.onCreateRoomReturn_), handler(self, self.onCreateRoomFail_))
end

function EditRoomView:xiugaiHandler_()
    local params = self.currView_:calcCreateRoomParams()
    local data = ChaGuanData.getClubInfo()
    params.clubID = data.clubID
    params.floor = gameData:getClubFloor()
    httpMessage.requestClubHttp(params, httpMessage.SET_CLUB_MODE)
    self:performWithDelay(
        function()
            self:setAutoKaiFang_()
        end,
        0.5
    )
end

function EditRoomView:setAutoKaiFang_()
    local data = ChaGuanData.getClubInfo()
    local params = {}
    params.clubID = data.clubID
    params.maxAutoCreateRoom = 16
    params.floor = gameData:getClubFloor()
    httpMessage.requestClubHttp(params, httpMessage.SET_CLUB_AUTO_ROOM)
    if self.roomType_ == 2 then
        self:closeHandler_()
    end
end

function EditRoomView:onCreateRoomFail_(...)
    app:clearLoading()
end

function EditRoomView:onExit()
    print("==========EditRoomViewEditRoomView==================")
end

function EditRoomView:closeHandler_()
    EditRoomView.super.closeHandler_(self)
    self.callback(false)
end

function EditRoomView:sureBtnHandler_()
    EditRoomView.super.closeHandler_(self)
    createRoomData:setOpenGameList(self.nowGameList)

    self.callback(true)
end

function EditRoomView:choiceGame_(index, data)
    dump(data, index)
    if self.iconMap[data.game_type] then
        print("已添加")
        return
    end
    table.insert(self.nowGameList, 1, data.game_type)
    self:updateAll()
end

function EditRoomView:updateAll()
    dump(self.nowGameList)
    self:initGamesButton_()
    self.tableView_:reloadData()
    self.tableViewNotOpen_:reloadData()
end
 
function EditRoomView:tableCellAtIndexNotOpen_(table, idx)
    local cell = table:dequeueCell() 
    local index = idx + 1 
    local base = idx * 4
    if nil == cell then  
        cell = cc.TableViewCell:new() 

        for i = 1, 4 do
            local item = GameType.new(nil, handler(self, self.choiceGame_))
            item:updateEditRoomView(self.nowGame[base + i], self.iconMap[self.nowGame[base + i]])
            item:setPosition(cc.p((i - 1) * 230 + 30, 115))  
            item:setName("1" .. i)  
            cell:addChild(item)  
        end
    else  
        for i = 1, 4 do
            local item = cell:getChildByName("1" .. i)
            item:updateEditRoomView(self.nowGame[base + i], self.iconMap[self.nowGame[base + i]])
        end
    end
    return cell  
end

function EditRoomView:tableCellTouchedNotOpen_(table, cell)
end

function EditRoomView:numberOfCellsInTableViewNotOpen_()
    return math.ceil(#self.nowGame / 4)
end

function EditRoomView:cellSizeForTableNotOpen_(table, idx)
    return 110, 860
end

return EditRoomView

local BaseElement = import("app.views.BaseElement")
local ChaGuanData = import("app.data.ChaGuanData")

local GameInputView = import("app.views.GameInputView")
local PullDownContent = import("app.views.chaguan.ClubRulePullDownContent")
local ClubRuleSetting = class("ClubRuleSetting", BaseElement)

function ClubRuleSetting:ctor(data, matchType)
    ClubRuleSetting.super.ctor(self)
    self:initElementRecursive_(self.csbNode_)
    self.params = {
        matchConfig = {}
    }
    self.pullData = {}
    self:initView(matchType)
    self:initConfig_(data.game_type,matchType)
end

function ClubRuleSetting:initConfig_(game_type,matchType)
    self:updateTableCount_(tonumber(ruleSetData:getTableCount()) or 1)
    self.manageLabel_:setString(ruleSetData:getDaShangFei() or 0)
    self.params.maxAutoCreateRoom = 1
    self.params.tip = 0
    if matchType == 0 then
        return
    end
    local info = nil
    if clubScoreRuleData:getNowRule() ~= nil then
       info = json.decode(clubScoreRuleData:getNowRule().match_config)
    end
    if not info then
        info = {
        ["score"] = 200,
        ["enterScore"] = 1,
        ["limitType"] = 1,
        ["limitScore"] = 50,
        ["limitRate"] = 5,
        ["limitFixScore"] = 5
        }
    end
    self.joinGameScore_:setString(info.score)
    self.params.matchConfig["score"] = info.score
    self.baseScoreLabel_:setString(info.enterScore)
    self.params.matchConfig["enterScore"] = info.enterScore
    local playerListList = {"大赢家", "前两名", "前三名"}
    self.playerCount_:setString(playerListList[info.limitType])
    self.params.matchConfig["limitType"] = info.limitType
    self.scoreLimit_:setString(info.limitScore)
    self.params.matchConfig["limitScore"] = info.limitScore
    self.chouCheng_:setString(info.limitFixScore)
    self.params.matchConfig["limitRate"] = info.limitRate
    self.params.matchConfig["limitFixScore"] = info.limitFixScore
end

function ClubRuleSetting:initView(matchType)
    if matchType == 1 then
        self.tipNode_:setVisible(false)
        return
    end
    self.champion_:setVisible(false)
    self.tableCount_:setPositionY(120)
    self.tipNode_:setPositionY(20)
    self.tipNode_:setVisible(true)
end

function ClubRuleSetting:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/club/subFloorSet/ruleSetting.csb"):addTo(self)
end

function ClubRuleSetting:createPullDown(pullData, node, height)
    self.pullData = pullData
    if self.tableView_ ~= nil then
        self.tableView_:removeFromParent(true)
        self.bg:removeFromParent(true)
    end

    self:initTableView(node, height)
    node:addChild(self.bg)
    node:addChild(self.tableView_)

    self.tableView_:reloadData()
end

function ClubRuleSetting:initTableView(node, height)
    local height = height or 150
    self.tableView_ = cc.TableView:create(cc.size(1000, height))      --列表的显示区域的大小
    self.bg = display.newScale9Sprite("views/club/subFloorSet/choiceBg.png", 0, 0, cc.size(347, height), {10, 10, 10, 10})

    local layout = ccui.Layout:create()
    layout:setAnchorPoint(0, 0)
    layout:setContentSize(cc.size(1000, height))
    layout:setTouchEnabled(true)
    layout:setSwallowTouches(true)
    self.bg:addChild(layout, -1)
    self.bg:setAnchorPoint(0, 0)
    -- self.tableView_:addChild()
    self.tableView_:setDirection(1)         --设置列表是竖直方向
    self.tableView_:setVerticalFillOrder(0)
    -- self.tableView_:setPosition(-560, -250+20)
    self.tableView_:registerScriptHandler(handler(self, self.cellSizeForTable_), cc.TABLECELL_SIZE_FOR_INDEX)
    self.tableView_:registerScriptHandler(handler(self, self.tableCellAtIndex_), cc.TABLECELL_SIZE_AT_INDEX)
    self.tableView_:registerScriptHandler(handler(self, self.tableCellTouched_), cc.TABLECELL_TOUCHED)
    self.tableView_:registerScriptHandler(handler(self, self.numberOfCellsInTableView_), cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
end

function ClubRuleSetting:cellSizeForTable_(table, idx)
    return 60, 1000
end

function ClubRuleSetting:tableCellTouched_(table, cell)
end

function ClubRuleSetting:numberOfCellsInTableView_()
    return #self.pullData
end

function ClubRuleSetting:tableCellAtIndex_(table, idx)
    local cell = table:dequeueCell() 
    local index = idx + 1 
    if nil == cell then  
        cell = cc.TableViewCell:new() 
        local item = PullDownContent.new()
        item:setPosition(cc.p(0, 0))  
        item:setCallback(handler(self, self.itemCallback))
        item:setName("1") 
        item:update(index, self.pullData[index])
        cell:addChild(item)  
    else  
        local item = cell:getChildByName("1")
        item:update(index, self.pullData[index])
    end
    return cell  
end

--[[
"score":50,  // 50 ~ 5000   入场分数
"enterScore":2, // 1 ~ 200    设置游戏底分
"limitType":1, // 1,2,3 抽水玩家{大赢家，前2名，前3名)
"limitScore":0, // 0,50,100,200,300   多少分进行抽水
"limitRate":1  //1,2,3,4,5    抽水比列
]]

function ClubRuleSetting:itemCallback(index, str)
    if self.tableView_ ~= nil then
        self.tableView_:removeFromParent(true)
        self.bg:removeFromParent(true)
    end
    self.tableView_ = nil
    ruleSetData:setDaShangFei(str)
    self.nowLabel:setString(str)

    self.params.matchConfig[self.nowKey] = self.nowList[index]
end

function ClubRuleSetting:baseScoreBtnHandler_()
    display.getRunningScene():initGameInput(function (value,isChange)
        print("initGameInput0",value,isChange)
        if isChange then
            if value > 200 then
                app:showTips("最多只能设置200")
                return 200
            end
            return value
        end
        if value < 0 then
            value = 1
            app:showTips("最小必须设置0")
        end
        self.baseScoreLabel_:setString(value)
    end)
end

function ClubRuleSetting:joinGameScoreBtnHandler_()
    -- local view = GameInputView.new():addTo(self):pos(display.left, display.bottom)
    -- view:tanChuang(150)
    display.getRunningScene():initGameInput(function (value,isChange)
        print("initGameInput1",value,isChange)
        if isChange then
            if value > 10000 then
                app:showTips("最多只能设置10000")
                return 5000
            end
            return value
        end
        if value < 10 then
            value = 10
            app:showTips("最小必须设置10")
        end
        self.joinGameScore_:setString(value)
    end)
end

function ClubRuleSetting:playerLimitBtnHandler_()
    local playerListList = {"大赢家", "前两名", "前三名"}
    self:createPullDown(playerListList, self.playerLimitBtn_)
    self.nowKey = "limitType"
    self.nowList = {1, 2, 3}
    self.nowLabel = self.playerCount_
end

function ClubRuleSetting:scoreLimitBtnHandler_()
    display.getRunningScene():initGameInput(function (value,isChange)
        print("initGameInput1",value,isChange)
        if isChange then
            if value > 500 then
                app:showTips("最多只能设置500")
                return 500
            end
            return value
        end
        if value < 10 then
            value = 10
            app:showTips("最小必须设置10")
        end
        self.scoreLimit_:setString(value)
    end)


--    local scoreLimitList = {"0分", "50分", "100分", "200分", "300分"}
--    self:createPullDown(scoreLimitList, self.scoreLimitBtn_)
--    self.nowKey = "limitScore"
--    self.nowList = {0, 50, 100, 200, 300}
--    self.nowLabel = self.scoreLimit_
end

function ClubRuleSetting:gratuityBtnHandler_()
    display.getRunningScene():initGameInput(function (value,isChange)
        print("initGameInput1",value,isChange)
        if isChange then
            if value > 50 then
                app:showTips("最多只能设置50")
                return 50
            end
            return value
        end
        if value < 0 then
            value = 0
            app:showTips("最小必须设置0")
        end
        self.chouCheng_:setString(value)
    end)

---------选择拉宽类型
--    local gratuityList = {"限制一次", "限制两次", "限制三次", "限制四次", "限制五次"}
--    self:createPullDown(gratuityList, self.gratuityBtn_)
--    self.nowKey = "limitRate"
--    self.nowList = {1, 2, 3, 4, 5}
--    self.nowLabel = self.chouCheng_
end

function ClubRuleSetting:manageBtnHandler_()
    local tipList = {0, 5, 10, 15, 20, 30, 40, 50, 60, 70, 80, 90, 100}
    self:createPullDown(tipList, self.manageBtn_, 250)
    self.nowKey = "tip"
    self.nowList = clone(tipList)
    self.nowLabel = self.manageLabel_
end

function ClubRuleSetting:tableCount1Handler_()
    self:updateTableCount_(1)
    self.params.maxAutoCreateRoom = 1
end

function ClubRuleSetting:tableCount2Handler_()
    self:updateTableCount_(2)
    self.params.maxAutoCreateRoom = 2
end

function ClubRuleSetting:tableCount3Handler_()
    self:updateTableCount_(3)
    self.params.maxAutoCreateRoom = 3
end

function ClubRuleSetting:tableCount4Handler_()
    self:updateTableCount_(4)
    self.params.maxAutoCreateRoom = 4
end

function ClubRuleSetting:tableCount5Handler_()
    self:updateTableCount_(5)
    self.params.maxAutoCreateRoom = 5
end

function ClubRuleSetting:tableCount6Handler_()
    self:updateTableCount_(6)
    self.params.maxAutoCreateRoom = 6
end

function ClubRuleSetting:updateTableCount_(index)
    ruleSetData:setTableCount(index)
    for i = 1, 6 do
        local item = self["tableCount" .. i .. "_"]
        if index ~= i then
            item:setSelected(false)
            item:setEnabled(true)
        else
            item:setEnabled(false)
        end
    end
end

function ClubRuleSetting:calcParams()
    local score = tonumber(self.joinGameScore_:getString())
    self.params.matchConfig.score = score

    local baseScore = tonumber(self.baseScoreLabel_:getString())
    self.params.matchConfig.enterScore = baseScore

    local tip = tonumber(self.manageLabel_:getString())
    self.params.tip = tip

    local limitFixScore = tonumber(self.chouCheng_:getString())
    self.params.matchConfig.limitFixScore = limitFixScore

    local limitScore = tonumber(self.scoreLimit_:getString())
    self.params.matchConfig.limitScore = limitScore

    return self.params
end

return ClubRuleSetting
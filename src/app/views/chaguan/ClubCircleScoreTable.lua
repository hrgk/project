local BaseElement = import("app.views.BaseElement")
local ClubCircleScoreTable = class("ClubCircleScoreTable", BaseElement)
local PlayerHead = import("app.views.PlayerHead")
local ChaGuanData = import("app.data.ChaGuanData")

ClubCircleScoreTable.className = "ClubCircleScoreTable"

function ClubCircleScoreTable:ctor(data)
    self.data_ = data
    ClubCircleScoreTable.super.ctor(self)
    self:initElementRecursive_(self.csbNode_)
    self:initZhuoZi_()

    -- self.zhuoZi_:removeSelf()
    self.zhuoZi_:setSwallowTouches(false)
end

function ClubCircleScoreTable:getTid()
    return self.data_.tid
end

function ClubCircleScoreTable:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/club/clubTable/clubCircleTable.csb"):addTo(self)
end

function ClubCircleScoreTable:updateZhuoZiSkin_(skinType)
    if not skinType then
        return 
    end
    skinType = math.min(skinType, 6)
    self.zhuoZi_:loadTexture("views/club/clubTable/ntable" .. skinType .. ".png")
end

function ClubCircleScoreTable:addTableHandler_()
    self.callback(self.data)
end

function ClubCircleScoreTable:setCallback(callback)
    self.callback = callback
end

function ClubCircleScoreTable:getCDPHZRuleInfo(config)
    if config.ruleType == 1 then
        return "全明堂"
    elseif config.ruleType == 3 then
        return "红黑点"
    end
    return ""
end

function ClubCircleScoreTable:getRuleDes(info)
    local gameTypeMap = {
        [GAME_CDPHZ] = handler(self, self.getCDPHZRuleInfo)
    }
    local str = ""
    if info then
        local rule = json.decode(info.ruleDetails)
        str = str ..GAMES_NAME[info.gameType] 
        str = str .. "\n" ..SUB_GAMES_NAME[info.gameType][info.ruleType] 
        str = str .. "\n" .. (rule.totalSeat or rule.maxPlayerCount or rule.playerCount) .. "人"

        if gameTypeMap[info.gameType] ~= nil then
            str = str .. "\n" .. gameTypeMap[info.gameType](info)
        end

        if info.matchType == 1 then
            matchConfig = json.decode(info.matchConfig)
            str = str .. "\n入场分数:" .. matchConfig.score
            str = str .. "\n游戏底分:" .. matchConfig.enterScore
        end

        if rule.tip ~= nil and rule.tip ~= 0 then
            str = str .. "\n打赏费" .. rule.tip .. "元宝"
        end

        if info.status == 0 then
            self.gaming_:setVisible(false)
            self.wating_:setVisible(true)
        else
            self.gaming_:setVisible(true)
            self.wating_:setVisible(false)
            if info.totalRound then
                str = str .."\n" ..info.roundIndex.."/"..info.totalRound.."局"
            end
        end
    end
    return str
end

function ClubCircleScoreTable:update(info, centerData)
    self.data = info
    if info == nil then
        self:setVisible(false)
        return
    end

    self:setVisible(true)
    if info.game_type == 0 then
        self.gameNode_:setVisible(false)
        self.addTable_:setVisible(true)
        return
    end
    local roomInfo = self:getRuleDes(info)
    self.ruleInfo_:setFontSize(20)
    self.ruleInfo_:setString(roomInfo)
    self.gameNode_:setVisible(true)
    self.addTable_:setVisible(false)
    self.data_ = info
    self:updatePlayerHead_()

    local skin = 1
    local floorInfo = ChaGuanData.getNowFloorInfo()
    if floorInfo ~= nil then
        local floor = ChaGuanData.getFloorGameConfig(floorInfo.id)
        for i, subFloor in ipairs(floor or {}) do
            if subFloor.id == info.subFloor then
                skin = i
                break
            end
        end
    end

    self:updateZhuoZiSkin_(skin)
end

function ClubCircleScoreTable:updateHallView(info, centerData)
    self.data = info
    if info == nil then
        self:setVisible(false)
        return
    end

    self:setVisible(true)
    if info.game_type == 0 then
        self.gameNode_:setVisible(false)
        self.addTable_:setVisible(true)
        return
    end
    local roomInfo = self:getRuleDes(info)
    self.ruleInfo_:setFontSize(20)
    self.ruleInfo_:setString(roomInfo)
    self.gameNode_:setVisible(true)
    self.addTable_:setVisible(false)
    self.data_ = info
    self:updatePlayerHead_()
    if ChaGuanData.getDaTingFloor() == 0 then
        ChaGuanData.setDaTingFloor(self.data_.floor)
        ChaGuanData.setDaTingsubFloor(self.data_.subFloor)
        ChaGuanData.setFloorIndex(1)
    end
    if ChaGuanData.getDaTingFloor() == self.data_.floor then
        if ChaGuanData.getDaTingsubFloor() ~= self.data_.subFloor then
            local index = ChaGuanData.getFloorIndex()
            index = index + 1
            ChaGuanData.setFloorIndex(index)
        end
    else
        ChaGuanData.setDaTingFloor(self.data_.floor)
        ChaGuanData.setDaTingsubFloor(self.data_.subFloor)
        ChaGuanData.setFloorIndex(1)
    end

    local skin = (ChaGuanData.getFloorIndexByGameType(self.data_.gameType, self.data_.subFloor))
    self:updateZhuoZiSkin_(skin)
end

function ClubCircleScoreTable:updatePlayerHead_()
    for i,v in ipairs(self.headList_) do
        local obj = self.data_.players[i]
        if obj then
            v.playerName:setString(obj.nickName)
            v.playerHead:showWithUrl(obj.avatar)
            v.playerHead:show()
        else
            v.playerName:setString("")
            v.playerHead:showWithUrl("")
            v.playerHead:hide()
        end
    end
end

function ClubCircleScoreTable:addPlayer(data)
end

function ClubCircleScoreTable:delePlayer(data)
end

function ClubCircleScoreTable:initZhuoZi_()
    self.headList_ = {}
    for i=1,10 do
        local head = "head"..i.."_"
        local nameLabel = self["nickName" .. i .."_"]
        nameLabel:setString("")
        local obj = {}
        obj.playerHead = self:initHead_(self[head])
        obj.playerName = nameLabel
        obj.playerHead:hide()
        table.insert(self.headList_, obj)
    end
end

function ClubCircleScoreTable:hide()
    self.csbNode_:hide()
end

function ClubCircleScoreTable:show()
    self.csbNode_:show()
end

function ClubCircleScoreTable:zhuoZiHandler_()
    if CHANNEL_CONFIGS.DOU then
        if not ChaGuanData.isMyClub() and ChaGuanData.getClubInfo().dou < ChaGuanData.getClubInfo().lowestScore then
            app:showTips("豆子不够")
            return
        end
    end
    if self.data_ == nil then
        app:showTips("请先设置游戏玩法")
        return 
    end
    if self.data_.tid then
        display.getRunningScene():enterGameRoom(self.data_.tid, self.data_)
    end
end

function ClubCircleScoreTable:initHead_(node)
    local head = PlayerHead.new(nil, true)
    head:setNode(node)
    head:showWithUrl("")
    return head
end

return ClubCircleScoreTable 

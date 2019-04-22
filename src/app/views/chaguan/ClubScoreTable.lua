local BaseElement = import("app.views.BaseElement")
local ClubScoreTable = class("ClubScoreTable", BaseElement)
local PlayerHead = import("app.views.PlayerHead")
local ChaGuanData = import("app.data.ChaGuanData")

ClubScoreTable.className = "ClubScoreTable"

function ClubScoreTable:ctor(data)
    self.data_ = data
    ClubScoreTable.super.ctor(self)
    self:initElementRecursive_(self.csbNode_)

    
    self:initZhuoZi_()

    -- self.zhuoZi_:removeSelf()
    self.zhuoZi_:setSwallowTouches(false)
    self.ruleBg_:setVisible(false)
end

function ClubScoreTable:getTid()
    return self.data_.tid
end

function ClubScoreTable:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/club/clubTable/clubTable.csb"):addTo(self)
end

function ClubScoreTable:updateZhuoZiSkin_(skinType, gameType, playerCount)
    print("========skinType, gameType=========",skinType, gameType)
    if SPECIAL_PROJECT then
        if not gameType then
            return
        end
        local playerCountSkin = {"","erren","sanren","tableBg"}
        local gameColour = {[GAME_LDFPF] = "1",[GAME_MJHONGZHONG] = "2",[GAME_MJZHUANZHUAN] = "2",[GAME_PAODEKUAI] = "5"}
        if playerCount then
            self.zhuoZi_:loadTexture("views/club/clubTable/" .. playerCountSkin[playerCount] .. gameColour[gameType] .. ".png")
        end
    else
        if not skinType then
            return 
        end
        skinType = math.min(skinType, 6)
        local playerCountSkin = {"","erren","sanren","tableBg"}
        if playerCount then
            self.zhuoZi_:loadTexture("views/club/clubTable/" .. playerCountSkin[playerCount] .. skinType .. ".png")
        else
            if gameType == GAME_CDPHZ or gameType == GAME_PAODEKUAI then
                self.zhuoZi_:loadTexture("views/club/clubTable/sanren" .. skinType .. ".png")
            else
                self.zhuoZi_:loadTexture("views/club/clubTable/tableBg" .. skinType .. ".png")
            end
        end
    end
end

function ClubScoreTable:addTableHandler_()
    self.callback(self.data)
end

function ClubScoreTable:setCallback(callback)
    self.callback = callback
end

function ClubScoreTable:getCDPHZRuleInfo(config)
    if config.ruleType == 1 then
        return "红黑点"
    elseif config.ruleType == 3 then
        return "全明堂"
    end
    return ""
end

function ClubScoreTable:getSKRuleInfo(config)
    local data = json.decode(config.ruleDetails)
    local str = ""
    if data.bianPai == 0 then
        str = str .. "不变 "
    elseif data.bianPai == 1 then
        str = str .. "百变 "
    elseif data.bianPai == 2 then
        str = str .. "千变 "
    end

    if data.contribution == 0 then
        str = str .. "无进贡"
    elseif data.contribution == 1 then
        str = str .. "有进贡"
    end

    return str
end

function ClubScoreTable:get13DRuleInfo(config)
    local data = json.decode(config.ruleDetails)
    local str = ""
    if data.maPai == 1 then
        str = "有马牌"
    elseif data.maPai == 0 then
        str = "无马牌"
    end

    if data.specialType == 1 then
        str = str .. "\n有特殊牌"
    elseif data.specialType == 0 then
        str = str .. "\n无特殊牌"
    end
    local msInfo = {"\n随机庄模式","\n无庄模式","\n轮庄模式"}
    str = str .. msInfo[data.zhuangType]
    return str
end

function ClubScoreTable:getRuleDes(info)
    local gameTypeMap = {
        [GAME_CDPHZ] = handler(self, self.getCDPHZRuleInfo),
        [GAME_SHUANGKOU] = handler(self, self.getSKRuleInfo),
        [GAME_13DAO] = handler(self, self.get13DRuleInfo),
    }
    local str = ""
    local playerNum = nil
    if info then
        dump(info)
        local rule = json.decode(info.ruleDetails)
        
        str = str ..GAMES_NAME[info.gameType] 
        playerNum = rule.totalSeat or rule.maxPlayerCount or rule.playerCount
        if info.gameType ~= 42 then
            --str = str .. "\n" .. playerNum .. "人"
        end
        if gameTypeMap[info.gameType] ~= nil then
            str = str .. "\n" .. gameTypeMap[info.gameType](info)
        end

        if info.matchType == 1  then
            local matchConfig = json.decode(info.matchConfig)
            if  matchConfig == nil then
                matchConfig = info.matchConfig
            end
            if info.gameType ~= 42 then
                --str = str .. "\n入场分数:" .. matchConfig.score
            end
            if matchConfig.enterScore < 1 then
                str = str .. "\n游戏底分:" ..   string.format("%.1f", matchConfig.enterScore * 10) .."毛"
            else
                str = str .. "\n游戏底分:" ..   string.format("%.1f", matchConfig.enterScore) .."元"
            end
            
        end

        if rule.tip ~= nil and rule.tip ~= 0 then
            str = str .. "\n打赏费" .. rule.tip .. "元宝"
        end

        if info.status == 0 then
            self.gaming_:setVisible(false)
            self.wating_:setVisible(true)
            if info.gameType == GAME_DA_TONG_ZI then
                if rule.totalScore then
                    str = str .."\n" ..rule.totalScore.."分"
                end
            else
                if info.totalRound then
                    if info.gameType ~=42 then
                        str = str .."\n" ..info.totalRound.."局"
                    end
                end
            end
            if info.gameType == GAME_HSMJ then
                if rule.piaoScore then
                    str = str .."\n" ..rule.piaoScore.."条鱼"
                end
                if rule.fengPai ==1 then
                    str = str .."\n" .."带风"
                else
                    str = str .."\n" .."不带风"
                end
                if rule.paiType == 1 then
                    str = str .."\n" .."快速场"
                else
                    str = str .."\n" .."普通场"
                end
            end
            if info.gameType == GAME_FHHZMJ then
                if rule.piaoScore then
                    str = str .."\n" ..rule.piaoScore.."条鱼"
                end
                if rule.huType ==1 then
                    str = str .."\n" .."点炮胡"
                else
                    str = str .."\n" .."自摸胡"
                end
            end
        else
            self.gaming_:setVisible(true)
            self.wating_:setVisible(false)
            if info.gameType == GAME_DA_TONG_ZI then
                if rule.totalScore then
                    str = str .."\n" ..rule.totalScore.."分"
                end
            else
                if info.totalRound then
                    str = str .."\n" ..info.roundIndex.."/"..info.totalRound.."局"
                end
            end
            if info.gameType == GAME_HSMJ then
                if rule.piaoScore then
                    str = str .."\n" ..rule.piaoScore.."条鱼"
                end
                if rule.fengPai == 1 then
                    str = str .."\n" .."带风"
                else
                    str = str .."\n" .."不带风"
                end
                if rule.paiType == 1 then
                    str = str .."\n" .."快速场"
                else
                    str = str .."\n" .."普通场"
                end
            end
            if info.gameType == GAME_FHHZMJ then
                if rule.piaoScore then
                    str = str .."\n" ..rule.piaoScore.."条鱼"
                end
                if rule.huType ==1 then
                    str = str .."\n" .."点炮胡"
                else
                    str = str .."\n" .."自摸胡"
                end
            end
        end

        if info.tid == 0 then
            if ChaGuanData.getClubInfo().permission == 1 then
                str = str .."\n钻石不足,此玩法未开启,请联系群主"
            elseif ChaGuanData.getClubInfo().permission == 0 then
                str = str .."\n钻石不足，此玩法未开启"
            end
        end
    end
    return str,playerNum
end

function ClubScoreTable:update(info, centerData)
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
    local roomInfo,playerNum = self:getRuleDes(info)
    self.ruleInfo_:setFontSize(20)
    self.ruleInfo_:setString(roomInfo)
    self.gameNode_:setVisible(true)
    self.addTable_:setVisible(false)
    self.data_ = info
    self:updatePlayerHead_()

    local floorInfo = ChaGuanData.getNowFloorInfo()
    local skin = 1
    if floorInfo ~= nil then
        local floor = ChaGuanData.getFloorGameConfig(floorInfo.id)
        for i, subFloor in ipairs(floor or {}) do
            if subFloor.id == info.subFloor then
                skin = i
                break
            end
        end
    end
    self:updateZhuoZiSkin_(skin, floorInfo.game_type,playerNum)
end

function ClubScoreTable:updateHallView(info, centerData)
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
    local roomInfo,playerNum = self:getRuleDes(info)
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
    self:updateZhuoZiSkin_(skin,self.data_.gameType,playerNum)
end

function ClubScoreTable:updatePlayerHead_()
    for i,v in ipairs(self.headList_) do
        local obj = self.data_.players[i]
        if obj then
            v.playerName:setString(obj.nickName)
            v.playerHead:showWithUrl(obj.avatar)
            v.playerHead:setData(obj)
            -- v.playerHead:setCallback(handler(self, self.headClick_))
            v.playerHead:show()
        else
            v.playerName:setString("")
            v.playerHead:showWithUrl("")
            v.playerHead:hide()
        end
    end
end

function ClubScoreTable:headClick_(playerData)
    local function callfunc(bool)
        if bool then
            app:showTips("踢出成功")
        end
    end
    app:confirm("是否踢掉玩家" .. playerData.nickName, callfunc)
end

function ClubScoreTable:addPlayer(data)
end

function ClubScoreTable:delePlayer(data)
end

function ClubScoreTable:initZhuoZi_()
    self.headList_ = {}
    for i=1,4 do
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

function ClubScoreTable:hide()
    self.csbNode_:hide()
end

function ClubScoreTable:show()
    self.csbNode_:show()
end

function ClubScoreTable:zhuoZiHandler_()
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
    local floorConfig = ChaGuanData.getNowFloorInfo()
    local matchType = ChaGuanData.getMatchType()
    local clubId = ChaGuanData.getClubID()
    local subFloor = self.data_.subFloor
    if subFloor and clubId then
        ChaGuanData.requestGetSubFloor2(subFloor,clubId)
    end
    if self.data_.tid then
        display.getRunningScene():enterGameRoom(self.data_.tid, self.data_)
    end
end

function ClubScoreTable:initHead_(node)
    local head = PlayerHead.new(nil, true)
    head:setNode(node)
    head:showWithUrl("")
    return head
end

return ClubScoreTable 

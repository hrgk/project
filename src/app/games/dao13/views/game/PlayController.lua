local BaseItem = import("app.views.BaseItem")
local PokerListView = import("app.games.dao13.views.game.PokerListView")
local D13Algorithm = import("app.games.dao13.utils.D13Algorithm")
local AutoItemController = import("app.games.dao13.views.game.AutoItemController")
local PlayController = class("PlayController",BaseItem)

function PlayController:ctor(model)
    self.table_ = model
    PlayController.super.ctor(self)
    self.daoCardInfo = {}
    self.daoCardShow = {}
    self.autoDaoCardShow = {}
end

function PlayController:setNode(node)
    PlayController.super.setNode(self, node)
    self.node = node
    self:initElementRecursive_(self.node)
    self:initUINode()
end

function PlayController:initUINode()
    self.cardBgList = {}
    self.cardBgList[1] = self.card1Bg_
    self.cardBgList[2] = self.card2Bg_
    self.cardBgList[3] = self.card3Bg_

    self.daoCloseList = {}
    self.daoCloseList[1] = self.dao1Close_
    self.daoCloseList[2] = self.dao2Close_
    self.daoCloseList[3] = self.dao3Close_

    self.zPTypeList = {}
    self.zPTypeList[1] = self.sdCard_
    self.zPTypeList[2] = self.autoCard_

    self.zPTypeShowList = {}
    self.zPTypeShowList[1] = self.sdP_
    self.zPTypeShowList[2] = self.autoP_

    self.sDSelectType = {}
    self.sDSelectType[2] = self.type2_
    self.sDSelectType[3] = self.type3_
    self.sDSelectType[4] = self.type4_
    self.sDSelectType[5] = self.type5_
    self.sDSelectType[6] = self.type6_
    self.sDSelectType[7] = self.type7_
    self.sDSelectType[8] = self.type8_
    self.sDSelectType[9] = self.type9_

    self.sortTypeList = {}
    self.sortTypeList[1] = self.dx_
    self.sortTypeList[2] = self.hs_
    
    self.sortShowTagList = {}
    self.sortShowTagList[1] = self.dxGou_
    self.sortShowTagList[2] = self.hsGou_

    self.daoShowList = {}
    self.daoShowList[1] = self.daoShow1_
    self.daoShowList[2] = self.daoShow2_
    self.daoShowList[3] = self.daoShow3_
    
    self.autoItemList = {}
    self.autoItemList[1] = self.item1_
    self.autoItemList[2] = self.item2_
    self.autoItemList[3] = self.item3_
    self.autoItemList[4] = self.item4_
    self.autoItemList[5] = self.item5_
    self.autoItemList[6] = self.item6_

    self.selectP_:hide()
    self.maskPanel_:hide()
    self:setAutoItem()
    self:initDaoCardShow()
end

function PlayController:setAutoItem()
    self.autoItemController = {}
    for i = 1,6 do
        self.autoItemController[i] = AutoItemController.new()
        self.autoItemController[i]:setNode(self.autoItemList[i])
        self.autoItemController[i]:setPalyerController(self)
        self.autoItemList[i]:hide()
    end
end

function PlayController:initHandCards_(data)
    local date = display.getRunningScene():getTable():getConfigData()
    self.needTipCard = -99
    if date.config.rules.maPai == 1 then
        self.needTipCard = 410
    end
    for i = 1,3 do
        self.daoCardShow[i]:setNeedTipCard(self.needTipCard)
    end
    if self.handPokerList_ then
        self.handPokerList_:removeFromParent()
        self.handPokerList_ = nil
    end
    self.handPokerList_ = PokerListView.new(self.needTipCard):addTo(self.cardPos_)
    local scale = display.widthInPixels / display.heightInPixels
    self.handPokerList_:pos(250 ,-105)
    self.handPokerList_:setScale(1.3)

    self.data_ = data
    self.handCard_ = clone(data.handCards)
    self.sortIndex_ = 1
    self:hideAutoSelect_()
    local cards = D13Algorithm.getSortCards(self.handCard_, self.sortIndex_)
    self.handPokerList_:removeAllPokers()
    self.handPokerList_:setTouchEnabled(true)
    local function rankHandCards()
        self.handPokerList_:faPaiRank_(clone(cards))
        self.selectP_:show()
        self.maskPanel_:show()
        self:sdCardHandler_()
    end
    if data.isReConnect then
        self.handPokerList_:showPokers(clone(cards),false)
        self.selectP_:show()
        self.maskPanel_:show()
        self:sdCardHandler_()
    else
        self.handPokerList_:showPokers(clone(cards), true, rankHandCards)
    end
end

function PlayController:showFlow(index,fenList)
    
end

function PlayController:setSDBtnVisible(bool)
    self.cxbp_:setVisible(bool)
    self.sdok_:setVisible(bool)
end

function PlayController:dao1CloseHandler_()
    self:deleteDaoCard(1)
end

function PlayController:dao2CloseHandler_()
    self:deleteDaoCard(2)
end

function PlayController:dao3CloseHandler_()
    self:deleteDaoCard(3)
end

function PlayController:deleteDaoCard(index,isRest)
    if not self.daoCardInfo[index] then
        return 
    end
    if not isRest then
        self.handCard_ = D13Algorithm.addByTable(self.handCard_,self.daoCardInfo[index],self.sortIndex_)
        self.handPokerList_:showPokersWithoutAnim_(clone(self.handCard_),false)
        self.handPokerList_:show()
    end
    self.cardBgList[index]:show()
    self.daoCloseList[index]:hide()
    self.daoCardShow[index]:hide()
    self.daoCardInfo[index] = nil
    self:setSDBtnVisible(false)
    self:setSDType()
end

function PlayController:daoShow1Handler_()
    self:addDaoCard(1)
end

function PlayController:daoShow2Handler_()
    self:addDaoCard(2)
end

function PlayController:daoShow3Handler_()
    self:addDaoCard(3)
end

function PlayController:initDaoCardShow()
    for index = 1,3 do
        self.daoCardShow[index] = PokerListView.new():addTo(self.daoShowList[index])
        self.daoCardShow[index]:setScale(1.2)
        if index == 1 then
            self.daoCardShow[index]:pos(-150+240,15)
        else
            self.daoCardShow[index]:pos(-160+250,15)
        end
        self.daoCardShow[index]:hide()
    end
end

function PlayController:showDaoCard(index)
    if #self.daoCardInfo[index] == 5 then
        self.daoCardInfo[index] = D13Algorithm.sortCardByA(self.daoCardInfo[index])
    end
    self.cardBgList[index]:hide()
    self.daoCardShow[index]:show()
    self.daoCardShow[index]:showPokers(clone(self.daoCardInfo[index]),false)
end

function PlayController:cheackDaoShuiByIndex(index,card)
    if index == 1 then
        if self.daoCardInfo[2] then
            if D13Algorithm.cheackDaoShui(card,self.daoCardInfo[2]) then
                return true
            end
        end
        if self.daoCardInfo[3] then
            if D13Algorithm.cheackDaoShui(card,self.daoCardInfo[3]) then
                return true
            end
        end
    elseif index == 2 then
        if self.daoCardInfo[1] then
            if D13Algorithm.cheackDaoShui(self.daoCardInfo[1],card) then
                return true
            end
        end
        if self.daoCardInfo[3] then
            if D13Algorithm.cheackDaoShui(card,self.daoCardInfo[3]) then
                return true
            end
        end
    elseif index == 3 then
        if self.daoCardInfo[1] then
            if D13Algorithm.cheackDaoShui(self.daoCardInfo[1],card) then
                return true
            end
        end
        if self.daoCardInfo[2] then
            if D13Algorithm.cheackDaoShui(self.daoCardInfo[2],card) then
                return true
            end
        end
    end
    return false
end

function PlayController:addDaoCard(index)
    local selectCard = self.handPokerList_:getPopUpPokers()
    if self.daoCardInfo[index] then
        if not self.specialType or self.specialType <= 9 then
            self:deleteDaoCard(index)
            self:hideAutoSelect_()
        else
            app:showTips("特殊牌型无法修改,请重新摆牌")
        end
        return 
    end

    if (index == 1 and #selectCard ~= 3) or  (index ~= 1 and #selectCard ~= 5) then
        if #selectCard == 0 and ((index == 1 and #self.handCard_ == 3) or (index ~= 1 and #self.handCard_ == 5)) then
            selectCard = clone(self.handCard_)
        else
            app:showTips("所选牌不满足条件")
            return
        end
    end
    if self:cheackDaoShuiByIndex(index,selectCard) then
        app:showTips("倒水,请重新选择")
        return
    end
    self.daoCardInfo[index] = clone(selectCard)
    self:showDaoCard(index)
    D13Algorithm.removeByTable(self.handCard_,self.daoCardInfo[index])
    if self.daoCardInfo[1] and self.daoCardInfo[2] and self.daoCardInfo[3] then
        self:setSDBtnVisible(true)
        self.handPokerList_:hide()
    else
        self:upDateHandCardPos()
        self:checkAutoSet()
    end
    self:setSDType()
end

function PlayController:dxHandler_()
    self:updatesortShowTagList_(1)
end

function PlayController:hsHandler_()
    self:updatesortShowTagList_(2)
end

function PlayController:setAutoDaoCard(data,index)
    self.autoIndex = index
    self.specialType = data[1].type
    for i = 1,3 do
        self.daoCardInfo[i] = clone(data[i].card)
        self:showDaoCard(i)
    end
    for i = 1, 6 do
        if self.autoItemList[i]:isVisible() then
            self.autoItemController[i]:showGuangQuan(index)
        else
            break
        end
    end
    self.handCard_ = {}
    self.handPokerList_:removeAllPokers()
    self:setSDType()
    self:setSDBtnVisible(true)
end

function PlayController:updatesortShowTagList_(index,notCard)
    for i = 1, 2 do
        self.sortShowTagList[i]:setVisible(index == i)
    end
    if notCard then
        return 
    end
    self.sortIndex_ = index
    self:upDateHandCardPos()
end

function PlayController:checkAutoSet()
    dump(self.handCard_,"self.handCard_self.handCard_self.handCard_")
    if #self.handCard_ == 3 or #self.handCard_ == 5 then
        for i = 1,3 do
            if not self.daoCardInfo[i] then
                self:addDaoCard(i)
            end
        end
    end
end

function PlayController:upDateHandCardPos()
    if self.handCard_ and #self.handCard_ > 0 then
        local cards = D13Algorithm.getSortCards(self.handCard_, self.sortIndex_)
        self.handPokerList_:showPokersWithoutAnim_(clone(cards),false)
        self.handPokerList_:show()
    end
end

function PlayController:sdCardHandler_()
    self:updatezPTypeList_(1)
    self:updatesortShowTagList_(self.sortIndex_,true)
    self:setSDBtnVisible(false)
    self:setSDType()
    self:clearAllDaoCard()
    self.handPokerList_:show()
    self.autoP_:show()
    self:setAutoItemInfo()
end

function PlayController:autoCardHandler_()
    self.autoIndex = self.autoIndex or 0
    self.autoIndex = self.autoIndex + 1
    if self.autoIndex > #self.autoItemInfo then
        self.autoIndex = 1
    end
    if self.autoItemInfo and self.autoItemInfo[self.autoIndex] then
        self:setAutoDaoCard(self.autoItemInfo[self.autoIndex],self.autoIndex)
    end
end

function PlayController:setAutoItemInfo()
    self.autoIndex = nil
    self.autoItemInfo = D13Algorithm.autoCard(clone(self.data_.handCards),self.data_.type)
    for i = 1,#self.autoItemInfo do
        self.autoItemList[i]:show()
        self.autoItemController[i]:update(self.autoItemInfo[i],i)
    end
    self:hideAutoSelect_()
    if self.data_.type > 9 then
        self.tsS_:show()
        local pic = string.format("views/games/d13/caozuo/font/autoFont/%d.png", self.data_.type)
        self.tsType_:loadTexture(pic)
    end
end

function PlayController:updatezPTypeList_(index)
    for i = 1, 2 do
        self.zPTypeList[i]:setVisible(index ~= i)
        self.zPTypeShowList[i]:setVisible(index == i)
    end
end

function PlayController:clearAllDaoCard()
    for i = 1,3 do
        self:deleteDaoCard(i,true)
    end
end

function PlayController:hideAutoSelect_()
    self.specialType = nil
    self.autoIndex = nil
    for i = 1, 6 do
        if self.autoItemList[i]:isVisible() then
            self.autoItemController[i]:showGuangQuan(-1)
        else
            break
        end
    end
end

function PlayController:cxbpHandler_()
    self:clearAllDaoCard()
    self.handCard_ = clone(self.data_.handCards)
    local cards = D13Algorithm.getSortCards(self.handCard_, self.sortIndex_)
    self.handPokerList_:showPokersWithoutAnim_(clone(cards),false)
    self.handPokerList_:show()
    self:setSDType()
    self:hideAutoSelect_()
end

function PlayController:setSDType()
    self.cardTypeInfo = D13Algorithm.getAllTypeCard(self.handCard_)
    self.tSIndex = nil
    for i = 2,#self.cardTypeInfo do
        local aimBtn = self["type" .. i .. "_"]
        local bool = #self.cardTypeInfo[i] > 0
        aimBtn:setEnabled(bool)
        aimBtn:setBright(bool)
    end
end

function PlayController:type2Handler_()
    self:getTiShiCard(2)
end

function PlayController:type3Handler_()
    self:getTiShiCard(3)
end

function PlayController:type4Handler_()
    self:getTiShiCard(4)
end

function PlayController:type5Handler_()
    self:getTiShiCard(5)
end

function PlayController:type6Handler_()
    self:getTiShiCard(6)
end

function PlayController:type7Handler_()
    self:getTiShiCard(7)
end

function PlayController:type8Handler_()
    self:getTiShiCard(8)
end

function PlayController:type9Handler_()
    self:getTiShiCard(9)
end

function PlayController:getTiShiCard(index)
    self.tSIndex = self.tSIndex or 0 
    if self.tSIndex ~= index then
        self.handPokerList_:initTishi(self.cardTypeInfo[index])
        self.tSIndex = index
        self.handPokerList_:tishi()
    else
        self.handPokerList_:tishi()
    end
end

function PlayController:sdokHandler_()
    local res = D13Algorithm.isDaoShui(self.daoCardInfo[1],self.daoCardInfo[2],self.daoCardInfo[3])
    self.specialType = self.specialType or -1
    if self.specialType <= 9 then
        self.specialType = -1 
    end
    if res and self.specialType <= 9 then
        app:showTips("倒水,请重新选择")
        return 
    end
    local sendCard = {}
    for i = 1,3 do
        table.insertto(sendCard, table.values(D13Algorithm.sortCardByCardType(self.daoCardInfo[i])), #sendCard+1)
    end
    local data = {handCards = sendCard,specialType = self.specialType}
    dataCenter:sendOverSocket(COMMANDS.DAO13_PLAY_CARDS, data)
    self.handPokerList_:removeAllPokers()
end

function PlayController:clearHandCards_()
    self:sdCardHandler_()
    self.autoItemInfo = nil
    self.autoIndex = nil
    for i = 1,6 do
        self.autoItemList[i]:hide()
    end
    self.selectP_:hide()
    self.maskPanel_:hide()
    self.tsS_:hide()
    self.handPokerList_:removeAllPokers()
    self:hideAutoSelect_()
end

function PlayController:tsSHandler_()
    if self.autoItemInfo[1] then
        self:setAutoDaoCard(self.autoItemInfo[1],1)
    end
end

return PlayController 

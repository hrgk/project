local D13Algorithm = require("app.games.dao13.utils.D13Algorithm")
local GameSceneTest = {}

function GameSceneTest.test(self)
    -- local cards = {114,203,204,102,305}
    -- local res = D13Algorithm.sortCardByCardType(cards)
    -- dump(res,"D13Algorithm.sortCardByCardType")
    -- local cards = {101,201,102,102,208,104,105,103}
    -- local res,result = D13Algorithm.getMDY(cards)
    -- dump(result,"XXXXXXXXXXXXXXX")
    -- GameSceneTest.sitDownAll(self)
    -- GameSceneTest.testRoomInfo(self)
    --local card = {
    --     --211,212,312,412,113,213,313,314,306,406,304,104,403}
    --     --412,209,303,210,310,402,302,413,411,311,211,314,214}
    --     --112,111,304,305,205,105,214,114,409,309,209,403,203}
    --     --114,413,412,112,211,410,210,308,108,205,104,303,202}
    --    -- 407,207,114,411,211,403,108,412,213,113,405,105,402}
    --     --214,412,212,311,211,109,308,208,108,407,307,207,306}
    --     405,305,102,210,109,108,207,306,413,412,410,404,403}
    -- 410,310,210,413,313,402,102,404,406,106,403,103,207}
    --313,210,306,414,412,407,405,404,304,104,402,302,102}
    --112,410,310,213,113,209,208,203,305,404,303,302,414}
    --403,303,103,413,313,113,112,207,414,314,114,210,308}
    -- 403,303,103,413,313,113,112,207,414,314,114,210,308}
    -- 214,207,106,404,304,104,402,303,412,311,110,209,408}
    --113,302,102,409,209,108,404,103,414,213,312,411,210}
    -- 210,110,413,409,309,403,303,108,412,112,402,302,406}
    -- local info = D13Algorithm.autoCard(card,0)
    -- dump(info,"infoinfoinfoinfo222")
    -- for i = 1,#info do
    --     dump(info[i],"infoinfoinfoinfoinfoinfoinfoinfoinfo")
    -- end
    -- local res,info = D13Algorithm.getMST(card)
    -- dump(info,"infoinfoinfo")
    -- local res,info = D13Algorithm.getMSZ(card,1,1)
    -- print("resresres",res)
    -- dump(info,"infoinfoinfo")
    -- local res,info = D13Algorithm.getMSZ(card)
    -- print("resresres",res)
    -- dump(info,"infoinfoinfo")
    -- local cards = {211,212,312,412,113,213,313,314}
    -- local info,res = D13Algorithm.getMDY(cards)
    -- dump(info,"infoinfo")
    -- dump(res,"res")
    -- local card = {409,209,207,106,304}
    -- local res,cmp = D13Algorithm.isDZ(card)
    -- dump(cmp,"resresresresres")
    -- local card1 = {308,105,103}
    -- local card2 = {214,
    -- 213,
    -- 210,
    -- 209,
    -- 206,
    -- }
    -- local card3 = {409,410,411,412,213}
    -- local res = D13Algorithm.isDaoShui(card1,card2,card3)
    -- dump(res,"res")
    -- dump(info,"GameSceneTest.test")
    -- GameSceneTest.testRoundStart_(self,2)
    -- GameSceneTest.testFlow(self)
    -- GameSceneTest.testDealCards(self,2)
    --GameSceneTest.testOnePlayerKaiPai(self, 2)
    -- GameSceneTest.testQiangZhuang(self, 4)
    -- GameSceneTest.testDingTest(self, 5)
    -- GameSceneTest.testDeFen(self,0)
    -- 
    -- GameSceneTest.testRoundOver(self)
    -- GameSceneTest.testDeFen(self,2)
    -- GameSceneTest.testXiaZhu(self,1)
    -- GameSceneTest.testGameOver(self)
end

function GameSceneTest.testYuYin_(self, delayTime)
    local data= {}
    data.seq = 2
    data.action = "chat"
    data.seatID = 1
    data.messageType = 4
    local msg = {}
    msg.data = data
    self:performWithDelay(function()
        self:onBroadcast_({data = msg})
    end, delayTime)
end

function GameSceneTest.testRoundStart_(self, delayTime)
    local data= {}
    data.seq = 2
    self:performWithDelay(function()
        self:onRoundStart_({data = data})
    end, delayTime)
end

function GameSceneTest.testDeFen(self, delayTime)
    local data= {9, -10}
    self:performWithDelay(function()
        self:onDeFenHandler_({data = data})
    end, delayTime)
end

function GameSceneTest.testDingTest(self, delayTime)
    local data= {}
    data.dealer = 10
    self:performWithDelay(function()
        self:onDingZhuang_({data = data})
    end, delayTime)
end

function GameSceneTest.testXiaZhu(self, delayTime)
    local data= {}
    data.callScore = 3
    data.seatID = 4
    self:performWithDelay(function()
        self:onCallScore_({data = data})
    end, delayTime)

    local data= {}
    data.callScore = 3
    data.seatID = 1
    self:performWithDelay(function()
        self:onCallScore_({data = data})
    end, delayTime)

    local data= {}
    data.callScore = 3
    data.seatID = 10
    self:performWithDelay(function()
        self:onCallScore_({data = data})
    end, delayTime)

    local data= {}
    data.callScore = 3
    data.seatID = 2
    self:performWithDelay(function()
        self:onCallScore_({data = data})
    end, delayTime)

    local data= {}
    data.callScore = 3
    data.seatID = 6
    self:performWithDelay(function()
        self:onCallScore_({data = data})
    end, delayTime)
end

function GameSceneTest.testQiangZhuang(self, delayTime)
    local data= {}
    data.callScore = 4
    data.seatID = 4
    self:performWithDelay(function()
        self:onQiangZhuangHandler_({data = data})
    end, delayTime)

    local data= {}
    data.callScore = 4
    data.seatID = 7
    self:performWithDelay(function()
        self:onQiangZhuangHandler_({data = data})
    end, delayTime)

    local data= {}
    data.callScore = 4
    data.seatID = 9
    self:performWithDelay(function()
        self:onQiangZhuangHandler_({data = data})
    end, delayTime)


    local data= {}
    data.callScore = 4
    data.seatID = 3
    self:performWithDelay(function()
        self:onQiangZhuangHandler_({data = data})
    end, delayTime)

    local data= {}
    data.callScore = 4
    data.seatID = 10
    self:performWithDelay(function()
        self:onQiangZhuangHandler_({data = data})
    end, delayTime)
end

function GameSceneTest.testOnePlayerKaiPai(self, delayTime)
    -- 0,1,2,3  无状态   待叫分  待开牌   待选择

    local data= {}
    data.cards = {105, 207, 108, 210, 314}
    data.type = 90
    data.seatID = 2
    self:performWithDelay(function()
        self:onKaiPaiHandler_({data = data})
    end, delayTime)

    local data= {}
    data.cards = {105, 207, 108, 210, 314}
    data.type = 5
    data.seatID = 3
    self:performWithDelay(function()
        self:onKaiPaiHandler_({data = data})
    end, delayTime)

    local data= {}
    data.cards = {105, 207, 108, 210, 314}
    data.type = 30
    data.seatID = 5
    self:performWithDelay(function()
        self:onKaiPaiHandler_({data = data})
    end, delayTime)

    local data= {}
    data.cards = {105, 207, 108, 210, 314}
    data.type = 20
    data.seatID = 4
    self:performWithDelay(function()
        self:onKaiPaiHandler_({data = data})
    end, delayTime)

    local data= {}
    data.cards = {105, 207, 108, 210, 314}
    data.type = 100
    data.seatID = 6
    self:performWithDelay(function()
        self:onKaiPaiHandler_({data = data})
    end, delayTime)

    local data= {}
    data.cards = {105, 207, 108, 210, 314}
    data.type = 9
    data.seatID = 7
    self:performWithDelay(function()
        self:onKaiPaiHandler_({data = data})
    end, delayTime)

    local data= {}
    data.cards = {105, 207, 108, 210, 314}
    data.type = 1
    data.seatID = 8
    self:performWithDelay(function()
        self:onKaiPaiHandler_({data = data})
    end, delayTime)

    local data= {}
    data.cards = {105, 207, 108, 210, 314}
    data.type = 2
    data.seatID = 9
    self:performWithDelay(function()
        self:onKaiPaiHandler_({data = data})
    end, delayTime)

    local data= {}
    data.cards = {105, 207, 108, 210, 314}
    data.type = 3
    data.seatID = 10
    self:performWithDelay(function()
        self:onKaiPaiHandler_({data = data})
    end, delayTime)
end

function GameSceneTest.testFlow(self)
    -- 0,1,2,3  无状态   待叫分  待开牌   待选择庄
    local data= {}
    data.flow = 3
    self:onRoundFlow_({data = data})
end

function GameSceneTest.testPokerAnim(self)
    for i=1, 3 do
        -- self.tableController_.tableView_:playPokerAnimation(i, math.random(0, 2), {520})
        -- self.tableController_.tableView_:playPokerAnimation(i, math.random(0, 2), {103, 404, 203, 105, 204, 205, 206, 306})
        self.tableController_.tableView_:playPokerAnimation(i, math.random(0, 2), {104, 204, 304, 404})
    end
    -- self.tableController_.tableView_:playPokerAnimation(i, math.random(0, 2), {103, 404, 203, 105, 204, 205, 206, 306})
    --103, 404, 203, 105, 204, 205, 206, 306
    -- self.tableController_.tableView_:playPokerAnimation(math.random(1, 3), math.random(0, 2), {205, 305, 405, 206, 306, 406, 107})
end

function GameSceneTest.testChuPaiPos_(self)
    self:schedule(function ()
        GameSceneTest.testChuPai(self, {105, 207, 108, 210, 314, 316, 109, 105, 207, 108, 210, 314, 316, 109, 105, 207, 108})
    end, 3)
end

function GameSceneTest.testFenPaiPos(self)
    for i,v in ipairs(self.tableController_.seats_) do
        v.view_:onRoundOverShowPai_({cards = {105, 207, 108, 210, 314, 316, 109, 105, 207, 108, 210, 314, 316, 109, 105, 207, 108}})
    end
end

function GameSceneTest.testDealCards(self,delayTime)
    local data = {}
    data.dealerSeatID = 2
    data.handCards = {107,410,106,108,105,209,110,109,303,113,411,302,412}
    data.code = 0
    data.randomPoker = 104
    data.type = 22
    self:performWithDelay(function()
        self:onDealCards_({data = data})
    end, delayTime)
end

function GameSceneTest.testRoundStart(self)
    self.onRoundStart_(self)
end

function GameSceneTest.testFenPaiZOrder(self)
    local list = {
        '{"zhuangWin":false,"code":0,"winner":2,"fenPai":[313,310,105],"vs":[[305,113],[313,310,105]]}',
        '{"zhuangWin":false,"code":0,"winner":3,"fenPai":[205,213,210],"vs":[[305,113],[313,310,105,205,213,210]]}',
        '{"zhuangWin":false,"code":0,"winner":3,"fenPai":[410,413,405],"vs":[[305,113],[313,310,105,205,213,210,410,413,405]]}',
        '{"zhuangWin":false,"code":0,"winner":2,"fenPai":[110],"vs":[[305,113],[313,310,105,110,205,213,210,410,413,405]]}',
    }
    for i,v in ipairs(list) do
        self:performWithDelay(function ()
            self.tableController_:doTurnEnd_(json.decode(v))
        end, i * 2)
    end
end

function GameSceneTest.testTurnEnd(self)
    local data = {
        winner = 2,
        zhuangWin = false,
        fenPai = {405, 110},
        vs = {
            {105, 205},
            {105, 205, 305, 405, 110, 210, 310},
        },
    }
    self.tableController_:doTurnEnd_(data)
    data = clone(data)
    data.zhuangWin = true
    self.tableController_:doTurnEnd_(data)

    self:performWithDelay(function ()
        local data = {
            winner = 2,
            zhuangWin = false,
            fenPai = {113, 213, 313, 413},
            vs = {
                {105, 205, 305, 405, 110, 210, 310, 410, 113, 213, 313, 413},
                {105, 205, 305, 405, 110, 210, 310, 410, 113, 213, 313, 413},
            },
        }
        self.tableController_:doTurnEnd_(data)
        data = clone(data)
        data.zhuangWin = true
        self.tableController_:doTurnEnd_(data)
    end, 3)
end

function GameSceneTest.testPlayerEnterRoom(self)
    local data = {
        score = -3,
        IP = "192.168.1.2",
        seatID = 1,
        isPrepare = true, 
        status = 0,
        fenPai = {205, 105, 305, 405, 110, 210, 310, 113, 213, 313, 413},
        chui = true,
        fanQiang = false,
        kaiQiang = false,
        dou = false,
        fanDou = true,
        roomID = 10000,
        shouPai = {305, 405, 205, 304, 404},
        data = json.encode({uid = 2, sex = 2, nickName = "abc", avatar = "#defaulthead.png" })  --\"uid\":2,\"sex\":2,\"nickName\":\"nomobile\",\"avatar\":\"#defaulthead.png\
    }
    for i = 1, 3 do
        local playerData = clone(data)
        playerData.seatID = i
        local data = json.decode(playerData.data)
        data.uid = data.uid + i
        if i == 1 then
            data.nickName = "ascfvg"
            local player = dataCenter:getHostPlayer()
            player:setMulti(data)
        elseif i == 2 then
            data.nickName = "hdsffpo"
        elseif i == 3 then
            data.nickName = "cdxfgshgi"
        end
        playerData.data = json.encode(data)
        self.tableController_:onPlayerEnterRoom_({data = playerData})
        self:onPlayerEnterRoom_({data = playerData})
    end
    self:performWithDelay(function ( ... )
        GameSceneTest.testChuPai(self, {304, 404})
    end, 1.5)
    
end

function GameSceneTest.testRoomInfo(self)
    local data = {
        config = {
            juShu = 1,
            tid = 1232123,
            rules = {
            playerCount = 10,
            },
        },
        creator = 2, -- 创建者
        clubID = -1,
        status = 2, -- 房间状态 0 空闲中 1 准备中 2 游戏中 3 结算中
        inFlow = 6, -- 所处游戏流程标记，参考最下面的游戏流程通知消息查看具体表述
        roundIndex = 1, -- 正在进行的局数索引
        dealer = 1, -- 庄家，当游戏开局后才有此标识
        currSeatID = 1,
        tid = 304356,
        remainSeconds = 30,
    }
    self.tableController_:doRoomInfo(data)
end

function GameSceneTest.testIsBigger(self)
    local seats = self.tableController_.seats_
    local pokerTable = dataCenter:getPokerTable()
    -- local cards = {306}
    -- local cards = {203}
    -- local cards = {203, 303, 204, 304}
    -- local cards = {203, 303, 403,103, 205}
    -- local cards = {304, 404, 204, 405, 305, 205}
    -- local cards = {304, 305, 306, 307, 208}
    -- local cards = {304, 404, 204, 104, 205, 206, 207}
    local cards =  {404, 204, 104, 304}
    -- local cards = {305, 410, 213}
    -- local cards = {305, 310, 313}
    -- local cards = {304, 404, 204, 104}
    -- local cards = {304, 305, 306, 307, 308}
    -- local cards = {304, 305, 306, 307, 204, 205, 206, 207}
    -- local cards = {304, 404, 204, 205, 206, 207,405, 305, 208}
    pokerTable:setCurCards(cards)
    for k,v in pairs(seats) do
        if k == 3 then
            v:setChuPai(pokerTable:getCurCards())
        end
    end
    local dizha_tonghuashun = {520, 306, 406, 206, 106, 107, 207, 407, 308, 408, 208, 108,
                               520, 306, 406, 206, 106, 107, 207, 407, 308, 408, 208, 108}
    local cards = dizha_tonghuashun
    local player = dataCenter:getHostPlayer()
    -- self:performWithDelay(function()
    --     -- player:setCards(dizha_tonghuashun)
    --     -- print("===121212====")
    -- end, 2)
    -- assert(TianZhaAlgorithm.isBigger(myCards, cards))
    NiuGuiAlgorithm.sort(1, cards)
    player:setCards(cards)
    -- self.tableController_.tableView_.nodeHostMaJiang_:show()
    -- self.tableController_.tableView_.nodeHostMaJiang_:showPokers(cards)
    -- self.buttonSort_:show()
end

function GameSceneTest.testTurnTo(self)
    local seatID = dataCenter:getHostPlayer():getSeatID()
    local data = {}
    data.seatID = seatID
    data.remainTime = 15
    self.tableController_:onTurnTo_({data = data})
end

function GameSceneTest.testSort(self)
    local player = dataCenter:getHostPlayer()
    local dizha_tonghuashun = {313, 412, 211, 411, 311, 410, 310, 309, 308, 307, 306, 305, 203, 213, 312}
    player:setCards(dizha_tonghuashun)
end

function GameSceneTest.testChuPai(self, cards)
    local seatID = dataCenter:getHostPlayer():getSeatID()
    local data = {
        seatID = 2,
        cards = cards,
    }
    for i=1, 3 do
        local tmp = clone(data)
        tmp.seatID = i
        self.tableController_:onPlayerChuPai_({data = tmp})
    end
end

function GameSceneTest.testDismiss(self)
    local params = {
        configTime = 300, -- 固定配置，单位秒
        remainTime = 120,
        yesSeatIDs = {3, 1}, -- 第一个是申请人
        noSeatIDs = {2},
        myChoosed = false
        -- result = 'yes', -- 为空是尚无结论 yes解散 no继续
    }
    -- if math.random(0, 1) == 0 then
    --     params.result = 'no'
    -- end
    self:onDismissInRequest_({data = params})

    self:performWithDelay(function ()
        params.noSeatIDs = {2, 4}
        self:onDismissInRequest_({data = params})
    end, 10000)

    self:performWithDelay(function ()
        params.result = 'no'
        self:onDismissInRequest_({data = params})
    end, 10000)
end

function GameSceneTest.testChat(self)
    for i=1,4 do
        local params = {
            action      = "chat",
            messageData = 3,
            messageType = 2,
            seatID      = i,
        }
        self.tableController_.seats_[i]:doChat(params)
    end
end

function GameSceneTest.testIPTips(self)
    local seatID = dataCenter:getHostPlayer():getSeatID()
    local uid = dataCenter:getHostPlayer():getUid()
    local data = {
        gold       = 2000,
        uid         = uid,
        nickName   = "my昵称goo434",
        seatID    = seatID,
        sex        = 0,
        IP = '192.168.0.112',
    }
    self:onPlayerSitDown_({data = data})
end

function GameSceneTest.testRoundOver(self)
    local  data = {
        seq = 8,
        hasNextRound = false,
        seats = {
            {
                totalScore = 20, 
                score = -1, 
                seatID = 1, 
            },
            {
                totalScore = 5, 
                score = -16, 
                seatID = 2, 
            },
            {
                totalScore = 0, 
                score = 2, 
                seatID = 3, 
            },
        }
    }
    self:onRoundOver_({data = data})
end

function GameSceneTest.testGameOver(self)
    local  data = {gid = 8,
    no_score_seat_id = {1,2},
    seats = {
        {totalScore = 3, seatID = 1, maxScore =12, bombCount = 2, winCount = 5,guanCount = 2,},
        {totalScore = - 9, seatID = 2, maxScore =12,bombCount = 3, winCount = 4,guanCount = 2,},
        {totalScore = 13, seatID = 3, maxScore =12,bombCount = 4, winCount = 3,guanCount = 2,},
        {totalScore = 13, seatID = 3, maxScore =12,bombCount = 4, winCount = 3,guanCount = 2,},
        {totalScore = 1333, seatID = 3, maxScore =12,bombCount = 4, winCount = 3,guanCount = 2,},
    }
    }
    self:onGameOver_({data = data})
end

function GameSceneTest.testAnim(self)
    self:schedule(function ()
        self.tableController_.seats_[1].view_:showActionAnim_("#bz_bao_dan.png")
        self.tableController_.seats_[2].view_:showActionAnim_("#bz_bu_yao.png")
        self.tableController_.seats_[3].view_:showActionAnim_("#bz_kai_qiang.png")
        for k,v in pairs(self.tableController_.seats_) do
            -- v.view_:showChuPaiAnim_(110)
        end
    end, 4)
end

-- 测试17张牌的显示
function GameSceneTest.testChuPai17(self)
    local seats = self.tableController_.seats_
    local cards = {313, 413, 113, 210, 110, 410, 310, 405, 105, 307, 306, 305, 203, 213, 312}
    for k,v in pairs(seats) do
        v:setCards(cards)
    end
    local timers = 2
    for i = 1, #cards do
        self:performWithDelay(function ()
            GameSceneTest.testChuPai(self, {cards[1], cards[2], cards[3]})
        end, timers)
        timers = timers + 2
        break
    end
end

function GameSceneTest.testPokerPosition(self)
    local seats = self.tableController_.seats_
    for k,v in pairs(seats) do
        local cards = {520, 416, 110, 314, 210, 103, 207, 308, 307, 412, 413}
        v:showCards(cards)
    end
end

function GameSceneTest.testPoker(self)
    local c = require("app.views.PokerView")
    local alg = require("app.utils.BaseAlgorithm")
    for i=3,14 do
        for j=1,4 do
            local card = alg.makeCard(j, i)
            local x, y = math.random(100, display.width - 100), math.random(100, display.height - 100)
            c.new(card):addTo(self):pos(x, y)
        end
    end
end

function GameSceneTest.testBetChips(self)
    for i=1,9 do
        local chips = i * math.random(1,1000) * 100
        self.tableController_.checkOutController_:doPlayerBet_(i, chips, false)
    end
    
end

-- 此项测试先要坐下
function GameSceneTest.testTimer(self)
    local seatID = math.random(1, 9)
    self.tableController_.seats_[seatID].view_:onStateThinking_({args = {math.random(1, 20)}})
end

function GameSceneTest.testCalcIndex(self)
    local c = self.tableController_
    print(c.maxPlayer_)
    c.hostSeatID_ = 9
    printf("======== hostSeatID_: %d", c.hostSeatID_)
    for i=1, 9 do
        printf("seatID: %d, index: %d", i, c:calcPlayerIndex(i))
    end
end

function GameSceneTest.sitDownAll(self)
    local IPList = {"192.168.0.9"}
    local data = {
        gold       = 2000,
        uid         = 101,
        nickName   = "my昵称",
        seatID    = 0,
        sex        = 0,
        IP = '192.168.0.111',
        score = 0,
        data = json.encode({})
    }
    selfData:setUid(102)
    local noHostSeats = {}
    for i=1,10 do
        local data = clone(data)
        data.nickName = data.nickName .. i
        data.seatID = i
        data.uid = data.uid + i
        noHostSeats[#noHostSeats+1] = data
    end
    for i,v in ipairs(noHostSeats) do
        self.tableController_:doPlayerSitDown(v)
    end
end

return GameSceneTest

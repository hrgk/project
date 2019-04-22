local ZMZAlgorithm = require("app.games.nxlmz.utils.ZMZAlgorithm")
local GameSceneTest = {}

function GameSceneTest.test(self)
    -- local cards = {}
    -- local handCards = {115,114,113,213,110,109,108,106,105,205,104,204,103,203,303,403}
    -- local cardsInfo = {102,104,106,202,203}
    -- ZMZAlgorithm.getCardType(cardsInfo)
    -- local config = display.getRunningScene():getRuleDetails()
    -- local isBaoDan = nil
    -- local res = ZMZAlgorithm.tishi(cards, handCards, config,isBaoDan)
    -- GameSceneTest.sitDownAll(self)
    -- GameSceneTest.testPoker(self)
    -- GameSceneTest.testSocket(self)
    -- GameSceneTest.testPokerPosition(self)
    -- GameSceneTest.testChuPai(self)
    -- GameSceneTest.testAnim(self)
    -- GameSceneTest.testSort(self)
    -- GameSceneTest.testIsBigger(self)
    -- GameSceneTest.testTurnTo(self)
    -- GameSceneTest.testIPTips(self)
    -- GameSceneTest.testChat(self)
    -- GameSceneTest.testRoomInfo(self)
    -- GameSceneTest.testChuPai(self)
    -- GameSceneTest.testRoundOver(self)
    -- GameSceneTest.testGameOver(self)
    -- GameSceneTest.testDismiss(self)
    -- GameSceneTest.testPlayerEnterRoom(self)
    -- GameSceneTest.testTurnEnd(self)
    -- GameSceneTest.testRoundStart(self)
    -- GameSceneTest.testDealCards(self)
    -- require("app.utils.RulesTest").new()
    -- GameSceneTest.testFenPaiPos(self)
    -- GameSceneTest.testChuPaiPos_(self)
    -- GameSceneTest.testDismiss(self)
    -- GameSceneTest.testPokerAnim(self)
    -- GameSceneTest.testFenPaiZOrder(self)
end

function GameSceneTest.xuanPaiTest(self, delay)
    local data = {}
    data.seatID = 1
    data.card = 410
    self:performWithDelay(function()
        self:onXuanPaiHandler_({data = data})
        end, delay)
end

function GameSceneTest.flowTest(self)
    local data = {}
    data.flow = 2
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

function GameSceneTest.testDealCards(self)
    local data = {}
    data.dealerSeatID = 2
    data.handCards = {213, 212, 211, 211, 210, 205, 209}
    self.tableController_:onDealCard_({data = data})
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
            rules = {
                playerCount = 3,
                cardCount =15,
                red10 = 1,
            },
        },
        clubID = 12345,
        creator = 125894673, -- 创建者
        status = 2, -- 房间状态 0 空闲中 1 准备中 2 游戏中 3 结算中
        inFlow = 6, -- 所处游戏流程标记，参考最下面的游戏流程通知消息查看具体表述
        roundIndex = 1, -- 正在进行的局数索引
        dealer = 1, -- 庄家，当游戏开局后才有此标识
        jokerSeatID = 1, -- 拿大王的玩家坐位ID
        currSeatID = 1,
        remainSeconds = 30 ,
        tid = 10000,
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

function GameSceneTest.testChuPai(self)
    local data = {
        seatID = 2,
        cards = {110,210,310,211,111,311,212,312,412,106,108,109,205,305,406},
    }
    self:onPlayerChuPai_({data = data})
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
                rank = 2, 
                turnCards = {{113},{313},{213},{409},{309},{205},{114},{316},{416},{107},{313},{108},{213},{410}}, 
                totalScore = 20, 
                score = -1, 
                seatID = 1, 
                rate = 1,
                winCount = 1, 
                guanCount = 1, 
                cards = 2,
                bomb = 1, 
                loseCount = 1, 
                handCards = {},
            },
            {
                rank = 1, 
                turnCards = {{113,313,213,409,416,416}}, 
                totalScore = 5, 
                maxScore = 12,
                score = -16, 
                seatID = 2, 
                rate = 1, 
                winCount = 1, 
                cards = 15,
                guanCount = 1, 
                bomb = 1, 
                loseCount = 1, 
                handCards = {108,213,410,113,313,213,108,213,410,113,108,213,410,113,313,213},
            },
            {
                rank = 3, 
                turnCards = {{113,313,213,409,309},{205},{114},{316,416}}, 
                totalScore = 0, 
                maxScore = 12,
                score = 2, 
                seatID = 3, 
                rate = 1, 
                winCount = 1, 
                guanCount = 1, 
                cards = 16,
                maxScore = 12,
                bomb = 1, 
                loseCount = 1, 
                handCards = {108,213,410,113,313,213,108,213,410,113,108,213,410,113,313,213},
            },
        }
    }
    self:onRoundOver_({data = data})
end

function GameSceneTest.testGameOver(self)
    local  data = {gid = 8,
            seats = {
                {totalScore = 3, seatID = 1, maxScore =12, bombCount = 2, winCount = 5,guanCount = 2,},
                {totalScore = - 9, seatID = 2, maxScore =12,bombCount = 3, winCount = 4,guanCount = 2,},
                {totalScore = 13, seatID = 3, maxScore =12,bombCount = 4, winCount = 3,guanCount = 2,},
            }
    }
    self:performWithDelay(function()
        self:doGameOver_(data)
        -- self:doGameOver_({data = data})
        end, 2)

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
    local hostSeatID = 1
    for i=1,3 do
        local data = clone(data)
        data.nickName = data.nickName .. i
        data.seatID = i
        data.uid = data.uid + i
        -- data.IP = IPList[math.random(1, #IPList)]
        self.tableController_:doPlayerSitDown(data)
    end
    -- data.seatID = 1
    -- data.uid = data.uid + 1
    -- local player = dataCenter:getHostPlayer()
    -- player:setMulti(data)
    -- self.tableController_:doPlayerSitDown(data)

    self:performWithDelay(function ()
        -- self.tableController_.table_:setDealerSeatID(1)
    end, 1)
    
    
    -- for k,v in pairs(self.tableController_.seats_) do
    --     v:doRoundStart()
    -- end
end

return GameSceneTest

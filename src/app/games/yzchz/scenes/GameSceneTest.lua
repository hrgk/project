local GameSceneTest = {}
local PaperCardGroup = require("app.games.yzchz.utils.PaperCardGroup")
local PaoHuZiAlgorithm = require("app.games.yzchz.utils.PaoHuZiAlgorithm")

function GameSceneTest.test(self)
    -- GameSceneTest.showConfigCard(self)
    -- GameSceneTest.testCardGroup(self)
    -- GameSceneTest.sitDownAll(self)
    -- GameSceneTest.testRoomInfo(self)
    -- GameSceneTest.testPlayerViewAni(self)
    --GameSceneTest.testRoundOver(self, 1)
    -- GameSceneTest.testGameOver(self)
    -- local cards = {210,301,209}
    -- PaoHuZiAlgorithm.calcHuXiShun(cards)
    -- GameSceneTest.testTianhu(self)
    -- GameSceneTest.testAlgorithm()
    -- GameSceneTest.testFullFLow(self)
    -- GameSceneTest.testRoundStart(self,1)
    -- GameSceneTest.testDealCards(self,2)
    -- GameSceneTest.testTianHuStart(self,4)
    -- GameSceneTest.testTianHuEnd(self,6)
    -- GameSceneTest.testTurnTo(self,1,5)
    -- GameSceneTest.testChuPai(self,1,201,7)
    -- GameSceneTest.testChiPai(self,2,9)
    -- GameSceneTest.testTurnTo(self,2,12)
    -- GameSceneTest.testChuPai(self,2,108,15)
    -- GameSceneTest.testPengPai(self,1,108,18)
    -- GameSceneTest.testTurnTo(self,1,20)
    -- GameSceneTest.testChuPai(self,1,103,23)
    -- GameSceneTest.testPaoPai(self,3,103,25)
    -- GameSceneTest.testChuPai(self,3,203,27)
    -- GameSceneTest.testpass(self,1,29)
    -- GameSceneTest.testAllpass(self,3,203,31)
    -- GameSceneTest.testMopai(self,1,203,33)
    -- GameSceneTest.testPaoPai(self,1,103,35)

    -- GameSceneTest.testChuPai(self,1,208,15)
    -- GameSceneTest.testPaopai(self)
    -- GameSceneTest.testChipai(self)
    -- GameSceneTest.testPengpai(self)
    -- GameSceneTest.testWeipai(self)
    -- GameSceneTest.testTipai(self)
    -- GameSceneTest.testGuopai(self)
    -- GameSceneTest.testtmpCards(self)
    -- GameSceneTest.testHupai(self)
    -- GameSceneTest.testChiPath(self)

end

function GameSceneTest.testCardGroup(self)
    local chaicards = {101,101,101,202,207,210,204,104,206,206}
    local chaicards1 = {107,107,209,209,209,110,109,207,102,102,204,203}
    local cards = PaperCardGroup.chaiPai(chaicards,true)
    dump(cards)
end

function GameSceneTest.testPlayerViewAni(self)
    -- self:schedule(function ()
    --     for k,v in pairs(self.tableController_.seats_) do
    --         v.view_:doWeiPai(0,true,false,false)
    --     end
    -- end, 2)
    self:schedule(function ()
        for k,v in pairs(self.tableController_.seats_) do
            -- v.view_:doTiPai(103,2,true,false,false)
            v.view_:doPaoPai(103,2,true,false,false)
        end
    end, 5)
end

function GameSceneTest.showConfigCard(self)
    print("showconfigcard")
    self.editConfigType = cc.ui.UIInput.new({
    image = "res/images/game/score-bg.png",
    size = cc.size(100, 46),
    x = display.cx ,
    y = display.height - 80,
    listener = function(event, editbox)
            if event == "began" then 
            elseif event == "ended" then
            elseif event == "return" then
            elseif event == "changed" then
            else
                printf("EditBox event %s", tostring(event))
            end
        end
    })
    self.editConfigType:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND)
    self.layerBG_:addChild(self.editConfigType)
    self.buttonCardConfig_:show()
    self.buttonCardConfig_:onButtonClicked(handler(self, GameSceneTest.configCards))
end

function GameSceneTest.configCards(self)
    local cardid = self.editConfigType:getText()
    print("cardid .."..cardid)
    GameSceneTest.testDebugSetPoker(self, cardid)
end

function GameSceneTest.testDebugSetPoker(self, cardId)
    local testData = require("app.games.yzchz.data.test")
    local data = testData[tonumber(cardId)]
    if not data or not data.cards then
        printError("test data fail!")
        return
    end
    dump(data)
    dataCenter:sendOverSocket(COMMANDS.DEBUG_CONFIG_CARD, data)
end

function GameSceneTest.testTianhu(self)
    GameSceneTest.testRoundStart(self,1)
    GameSceneTest.testDealCards(self,2)
    GameSceneTest.testTianHuStart(self,4)
    GameSceneTest.testHupai(self,1,0,6)
    GameSceneTest.testHupai(self,1,1,7)
    GameSceneTest.testRoundOver(self,8)

end

function GameSceneTest.testFullFLow(self)
    GameSceneTest.testRoundStart(self,1)
    GameSceneTest.testDealCards(self,2)
    GameSceneTest.testTianHuStart(self,4)
    GameSceneTest.testTianHuEnd(self,4)
    GameSceneTest.testTurnTo(self,1,5)
    GameSceneTest.testChuPai(self,1,201,7)
    GameSceneTest.testChiPai(self,2,9)
    GameSceneTest.testTurnTo(self,2,12)
    GameSceneTest.testChuPai(self,2,108,15)
    GameSceneTest.testPengPai(self,1,108,18)
    GameSceneTest.testTurnTo(self,1,20)
    GameSceneTest.testChuPai(self,1,103,23)
    GameSceneTest.testPaoPai(self,3,103,25)
    GameSceneTest.testChuPai(self,3,203,27)
    GameSceneTest.testpass(self,1,29)
    GameSceneTest.testAllpass(self,3,204,31)
    GameSceneTest.testMopai(self,1,203,33)
    GameSceneTest.testpass(self,1,34)
    GameSceneTest.testAllpass(self,1,204,35)
    GameSceneTest.testTipai(self,2,205,37)
    GameSceneTest.testTurnTo(self,2,38)
    GameSceneTest.testChuPai(self,2,201,40)
    GameSceneTest.testpass(self,1,42)
    GameSceneTest.testAllpass(self,2,201,44)
    GameSceneTest.testWeipai(self,3,0,0,46)
    GameSceneTest.testChuPai(self,3,102,48)
    GameSceneTest.testpass(self,1,50)
    GameSceneTest.testAllpass(self,3,102,52)
    GameSceneTest.testWeipai(self,1,102,1,54)
    GameSceneTest.testChuPai(self,1,105,56)
    GameSceneTest.testpass(self,1,58)
    GameSceneTest.testAllpass(self,1,105,60)
    GameSceneTest.testMopai(self,2,207,62)
    GameSceneTest.testHupai(self,1,0,64)
    GameSceneTest.testHupai(self,1,1,64)

    GameSceneTest.testRoundOver(self,65)

end

function GameSceneTest.testMopai(self,seatid,card,seconds)
    self:performWithDelay(function() 
        local seatID = dataCenter:getHostPlayer():getSeatID()
        local data = {
            seatID = seatid,
            card = card
        } 
        self.tableController_:onPlayerMoPai_({data = data})
    end, seconds)
end

function GameSceneTest.testpass(self,seatid,seconds)
    self:performWithDelay(function() 
        local seatID = dataCenter:getHostPlayer():getSeatID()
        local data = {
            seatID = seatid
        } 

        self.tableController_:onPlayerPass_({data = data})
    end, seconds)
end

function GameSceneTest.testAllpass(self,seatid,card,seconds)
    self:performWithDelay(function() 
        local seatID = dataCenter:getHostPlayer():getSeatID()
        local data = {
            seatID = seatid,
            card = card
        } 

        self.tableController_:onAllPass_({data = data})
    end, seconds)
end

function GameSceneTest.testTurnTo(self,seatid,seconds)
       self:performWithDelay(function() 
        local seatID = dataCenter:getHostPlayer():getSeatID()
        local data = {
            seatID = seatid,
            remainTime = 100
        } 

        self.tableController_:onTurnTo_({data = data})
    end, seconds)
end


function GameSceneTest.testRoundStart(self,seconds)
       self:performWithDelay(function() 
        local seatID = dataCenter:getHostPlayer():getSeatID()
        local data = {
            seq = 1,
            dealerSeatID = 1
        } 

        self.tableController_:onRoundStart_({data = data})
    end, seconds)
end
-- 3级吃路径测试
function GameSceneTest.testChiPath(self)
    local  cards ={106,106,106,102,102,103,110,110,209,109,109,108,208,108,207,107,107,206,105,203,201}
    local data = {}
    data.dealerSeatID = 1
    data.handCards = cards
    self:performWithDelay(function()
        self.tableController_:onDealCards_({data = data})
        end, 3)
    GameSceneTest.testtmpCards(self)
end

function GameSceneTest.testTianHuStart(self,seconds)
    self:performWithDelay(function() 
        local seatID = dataCenter:getHostPlayer():getSeatID()
        local data = {
            card = 109,
            canTianHu = 1,
            seconds = 99
        } 

        self.tableController_:onTianHuStart_({data = data})
    end, seconds)
end

function GameSceneTest.testTianHuEnd(self,seconds)
    self:performWithDelay(function() 
        local cards = {203,201,202,202,203,204}
        local seatID = dataCenter:getHostPlayer():getSeatID()
        local data = {
        }  
        self.tableController_:onTianHuEnd_({data = data})
    end, seconds)
end

function GameSceneTest.testHupai(self,seatID,finish,seconds)
    self:performWithDelay(function() 
        local cards = {203,201,202,202,203,204}
        local seatID = dataCenter:getHostPlayer():getSeatID()
        local data = {
            seatID = seatID,
            isFinish = finish
        } 
        self.tableController_:onUserHu_({data = data})

    end, seconds)
end

function GameSceneTest.testGuopai(self)
    self:performWithDelay(function() 
        local cards = {203,201,202,202,203,204}
        local seatID = dataCenter:getHostPlayer():getSeatID()
        local data = {
            seatID = 2,
        } 
        for i=1, 3 do
            local tmp = clone(data)
            tmp.seatID = i
            self.tableController_:onPlayerPass_({data = tmp})
        end
    end, 2)
end

function GameSceneTest.testTipai(self,seatID,card,seconds)
    self:performWithDelay(function() 
        local cards = {203,201,202,202,203,204}
        local seatID = dataCenter:getHostPlayer():getSeatID()
        local data = {
            seatID = seatID,
            card = card,
            index = 2
        } 
        self.tableController_:onUserTi_ ({data = data})
    end, seconds)
end

function GameSceneTest.testWeipai(self,seatID,card,ischou,seconds)
    self:performWithDelay(function() 
        local cards = {203,201,202,202,203,204}
        local seatID = dataCenter:getHostPlayer():getSeatID()
        local data = {
            seatID = 2,
            isChou = ischou
        } 
        self.tableController_:onUserWei_({data = data})
        
    end, seconds)
end

function GameSceneTest.testChiPai(self,seatid,seconds)
    self:performWithDelay(function() 
        local cards = {203,201,202,202,203,204}
        local seatID = dataCenter:getHostPlayer():getSeatID()
        local data = {
            seatID = 2,
            card = 201,
            chiPai = {202,203},
            biPai = {{201,101,201},{202,203,201}},
            -- biPai = {{102,102,202}},
            isFinish = 1
        }  
        local tmp = clone(data)
        tmp.seatID = seatid
        self.tableController_:onUserChi_({data = tmp})
    end, seconds)
end

function GameSceneTest.testPengPai(self,seatID,card,seconds)
    self:performWithDelay(function() 
        local cards = {107,107,107}
        local tmp = {
            seatID = seatID,
            card = card,
            isFinish = 1
        } 
        self.tableController_:onUserPeng_({data = tmp})
    end, seconds)
end

function GameSceneTest.testPaoPai(self,seatID,card,seconds)
    self:performWithDelay(function() 
        local cards = {207,207,207,207}
        local seatID = seatID
        local data = {
            seatID = seatID,
            card = card,
            index = 0
        }    
        self.tableController_:onUserPao_({data = data})
    end, seconds)
end

function GameSceneTest.testChuPai(self,seatID,card,seconds)
    local data = {
        seatID = 2,
        cards = 102,
        code = 0,
        seconds = 99
    }
    self:performWithDelay(function ( ... )
        -- for i=1, 3 do
        local tmp = clone(data)
        tmp.seatID = seatID
        tmp.cards = card
        self.tableController_:onPlayerChuPai_({data = tmp})
        -- end
    end, seconds)
end

function GameSceneTest.testtmpCards(self)
    self:performWithDelay(function() 
        local seatID = dataCenter:getHostPlayer():getSeatID()
        local data = {
            seatID = 2,
            card = 203
        } 
        -- for i=1, 3 do
        local tmp = clone(data)
        tmp.seatID = 2
        tmp.card = 107 
        self.tableController_:onPlayerMoPai_({data = tmp})
        -- end
    end, 5)
end

function GameSceneTest.testAlgorithm()
    require("app.games.yzchz.utils.PaoHuZiTest")
    require("app.games.yzchz.utils.GroupTest")
end

function GameSceneTest.testDealCards(self,seconds)
    --local cards ={106,106,106,102,102,103,110,110,209,109,109,108,208,108,207,107,107,206,105,203}
    local cards ={301,301,106,102,102,103,110,110,209,109,109,108,208,108,207,107,107,206,105,203}
    local data = {}
    data.dealerSeatID = 1
    data.handCards = cards
    self:performWithDelay(function()
        self.tableController_:onDealCards_({data = data})
        end, seconds)
end

function GameSceneTest:testChi()
    local  cards ={106,106,106,102,102,102,110,110,209,209,109,208,208,108,207,207,107,206,105,203,201}
    self.tableController_.seats_[1]:setCards(cards)
    self.tableController_.seats_[2].view_:showMoPai(107)
    self.tableController_.seats_[1].view_:doPengPai( self.tableController_.seats_[2].view_.currCard,{102,102,102},true,true)

    self:performWithDelay(function()  
        self.tableController_.seats_[2].view_:showMoPai(102)
        self.tableController_.seats_[3].view_:showMoPai(107)
        self.tableController_:showActions(true,false,true,true,true,true)
        end, 3)

    self:performWithDelay(function() 
        self.tableController_.seats_[1].view_:doWeiPai({207,207,207}, true , true)
        self.tableController_.seats_[1].view_:doPaoPai(self.tableController_.seats_[3].view_.currCard,{107,107,107,107},0,true,true)
        end, 6)
    self:performWithDelay(function() 
        self.tableController_.seats_[1].view_:doWeiPai({207,207,207}, true , true)
        self.tableController_.seats_[2].view_:doPaoPai(self.tableController_.seats_[3].view_.currCard,{107,107,107,107},0,true,true)
        end, 9)
    self:schedule(function ()
        -- self.tableController_.seats_[1].view_:showActionAnim_("#bz_bao_dan.png")
        -- self.tableController_.seats_[2].view_:showActionAnim_("#bz_bu_yao.png")
        -- self.tableController_.seats_[3].view_:showActionAnim_("#bz_kai_qiang.png")
 
        self.tableController_.seats_[2].view_:showMoPai(102)

        self.tableController_.seats_[1]:setCards(cards)
        -- self.tableController_.seats_[2].view_:addThrewPai(102,false)
        -- self.tableController_.seats_[1].view_:addThrewPai(101,false)
        -- self.tableController_.seats_[3].view_:addThrewPai(103,false)
        -- self.tableController_.seats_[2].view_:moveCurrCardToPlayer(self.tableController_.seats_[1])
        -- self.tableController_.seats_[3].view_:doTiPai({102,102,102,102}, false, false) 

        -- self.tableController_.seats_[1].view_:doPengPai( self.tableController_.seats_[2].view_.currCard,{102,102,102},true,true)
        -- self.tableController_.seats_[3].view_:doPengPai( self.tableController_.seats_[1].view_.currCard,{103,103,103},true,true)
        -- self.tableController_.seats_[3].view_:doChouWeiPai({102,102,102,102},true,true)

        -- self.tableController_.seats_[1].view_:doPengPai({103,103,103},true,true)

        -- self.tableController_.seats_[1].view_:playHuAnim()
        -- self.tableController_.seats_[2].view_:playTiAnim()
        -- self.tableController_.seats_[3].view_:playPaoAnim()
        for k,v in pairs(self.tableController_.seats_) do
            v.view_:updateZhuomianHuxi(11,false,false)

            -- v.view_:doTiPai({102,102,102,102}, false, false) 

            -- v.view_:doPengPai( self.tableController_.seats_[2].view_.currCard,{102,102,102},true,true)
            -- v.view_:doPaoPai(self.tableController_.seats_[2].view_.currCard,{102,102,102,102},0,true,true)
            -- v.view_:doWeiPai({110,110,110}, true , true)

            v.view_:showReady_()
            -- v.view_:doChiAnim({102,102,102,102}, true , true)
     
            -- v.view_:playHuAnim()
            -- local cards ={106,106,106,102,102,102,110,110,209,209,109,208,208,108,207,207,107,206,105,203,201}

            -- v.view_.tableView_:showPokersWithoutAnim_(cards, nil)
        end
    end, 5)

end



function GameSceneTest:playTiAnim(seatid)
    local px, py = self.seats[seatid]:getPosition()
    local x, y = display.cx, display.cy
    AnimManager.play(self, ANIM.ti_light, x, y)

    display.addSpriteFramesWithFile(RES.PLAY_ANIM_PLIST, RES.PLAY_ANIM_PNG)
    local sprite = display.newSprite("#ti.png"):addTo(self):pos(x, y)
    local sequence = transition.sequence({
        CCFadeTo:create(0.1, 128),
        CCDelayTime:create(0.2),
        CCFadeTo:create(0.1, 0),
    })
    sprite:runAction(sequence)
    --transition.fadeOut(sprite, {time = 0.5})
    transition.scaleTo(sprite, {scale = 1.5, time = 0.4})
end

function GameSceneTest.testChuPaiPos_(self)
    self:schedule(function ()
        GameSceneTest.testChuPai(self, {105, 207, 108, 210, 314, 316, 109, 105, 207, 108, 210, 314, 316, 109, 105, 207, 108})
    end, 3)
end
 


function GameSceneTest.testPlayerEnterRoom(self)
    local data = {
        score = -3,
        IP = "192.168.1.2",
        seatID = 1,
        isPrepare = true, 
        status = 0,
        roomID = 10000,
        shouPai = {305, 405, 205, 304, 404},
        data = json.encode({uid = 2, sex = 2, nickName = "abc", avatar = "res/images/common/defaulthead.png" })  --\"uid\":2,\"sex\":2,\"nickName\":\"nomobile\",\"avatar\":\"#defaulthead.png\
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
            ruleType = 3,
            rules = {
                limitScore = 0, -- 单局得分上限
                baseTun = 1,  -- 起胡记等
                santi5kan = 0,  -- 3提5坎 0关1开
                shuaHou = 0,  -- 耍猴 0关1开
                huangFan = 0,  -- 黄番 0关1开
                hangHangXi = 0,  -- 行行息 0关1开
                tingHu = 0,  -- 听胡 0关1开
            }
        },
        creator = 125894673, -- 创建者
        status = 2, -- 房间状态 0 空闲中 1 准备中 2 游戏中 3 结算中
        inFlow = 0, -- 所处游戏流程标记，参考最下面的游戏流程通知消息查看具体表述
        roundIndex = 1, -- 正在进行的局数索引
        dealer = 1, -- 庄家，当游戏开局后才有此标识
        jokerSeatID = 1, -- 拿大王的玩家坐位ID
        currSeatID = 1,
        remainSeconds = 30 ,
        turnCards = {
        {1, {103, 104, 105}},
        {2, {103, 104, 105}},
        {3, {103, 104, 105}},
        } -- 此圈中的所打出的牌
    }
    self:onRoomInfo_({data = data})
end

function GameSceneTest.testSort(self)
    local player = dataCenter:getHostPlayer()
    local dizha_tonghuashun = {313, 412, 211, 411, 311, 410, 310, 309, 308, 307, 306, 305, 203, 213, 312}
    player:setCards(dizha_tonghuashun)
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

function GameSceneTest.testRoundOver(self,seconds)
    -- 提前解散数据

    --{'seq': 6, 'hasNextRound': True, 'seats': [{'seatID': 1, 'handCards': [105, 209, 108, 104, 203, 204, 110, 204, 204, 109], 'tableCards': [[3, 101, 201, 101], [4, 210, 210, 210], [8, 206, 206, 206, 206]], 'score': -16, 'totalScore': 29}, {'seatID': 2, 'handCards': [109, 104, 106, 109], 'tableCards': [[4, 102, 102, 102], [4, 202, 202, 202], [1, 208, 209, 210], [7, 107, 107, 107, 107], [7, 207, 207, 207, 207]], 'score': 32, 'totalScore': -43}, {'seatID': 3, 'handCards': [208, 208, 205, 205, 110, 110, 205, 201, 104, 109], 'tableCards': [[4, 203, 203, 203], [7, 103, 103, 103, 103], [4, 106, 106, 106]], 'score': -16, 'totalScore': 14}], 'finishType': 0, 'rate': 1, 'isHuangZhuang': 0, 'leftCards': [209, 208, 204, 201, 105, 101, 202, 205, 110, 104, 102, 108, 101], 'winInfo': {'rate': 1, 'winner': 2, 'huCard': 105, 'totalHuXi': 19, 'totalTun': 4, 'isTianHu': 0, 'isZiMo': 0, 'huList': [4], 'fanList': [4], 'huPath': [[4, 102, 102, 102], [4, 202, 202, 202], [1, 208, 209, 210], [7, 107, 107, 107, 107], [7, 207, 207, 207, 207], [1, 104, 105, 106], [0, 109, 109]], 'huCardIndex': 6, 'handCardIndex': 6, 'huangFanRate': 1}, 'spare_card': [], 'code': 0}
    -- local data = json.decode('{"finishType":0,"code":0,"rate":1,"seq":8,"isHuangZhuang":0,"seats":[{"handCards":[110,203,210,204,203,207,207,210,110,104],"totalScore":29,"seatID":1,"tableCards":[[4,209,209,209],[7,107,107,107,107],[4,105,105,105]],"score":-14},{"handCards":[108,108,203,203],"totalScore":137,"seatID":2,"tableCards":[[7,109,109,109,109],[7,205,205,205,205],[7,206,206,206,206],[7,202,202,202,202],[4,101,101,101]],"score":28},{"handCards":[108,201,110,207,105,101,106,207,204,102,209,208,104,210,110,204,108],"totalScore":-166,"seatID":3,"tableCards":[[4,103,103,103]],"score":-14}],"hasNextRound":false,"winInfo":{"huList":[5,6,17],"huPath":[[1,106,107,108],[6,203,203,203],[7,209,209,209,209],[6,207,207,207],[6,202,202,202],[1,101,102,103],[0,209,209]],"rate":1,"winner":2,"totalTun":7,"isZiMo":0,"huangFanRate":2,"handCardIndex":7,"huCardIndex":4,"fanList":[2],"isTianHu":0,"huCard":207,"totalHuXi":34},"leftCards":[106,201,104,102,210,102,102,204,106]}')
    -- local data = json.decode("{'seq': 6, 'hasNextRound': True, 'seats': [{'seatID': 1, 'handCards': [105, 209, 108, 104, 203, 204, 110, 204, 204, 109], 'tableCards': [[3, 101, 201, 101], [4, 210, 210, 210], [8, 206, 206, 206, 206]], 'score': -16, 'totalScore': 29}, {'seatID': 2, 'handCards': [109, 104, 106, 109], 'tableCards': [[4, 102, 102, 102], [4, 202, 202, 202], [1, 208, 209, 210], [7, 107, 107, 107, 107], [7, 207, 207, 207, 207]], 'score': 32, 'totalScore': -43}, {'seatID': 3, 'handCards': [208, 208, 205, 205, 110, 110, 205, 201, 104, 109], 'tableCards': [[4, 203, 203, 203], [7, 103, 103, 103, 103], [4, 106, 106, 106]], 'score': -16, 'totalScore': 14}], 'finishType': 0, 'rate': 1, 'isHuangZhuang': 0, 'leftCards': [209, 208, 204, 201, 105, 101, 202, 205, 110, 104, 102, 108, 101], 'winInfo': {'rate': 1, 'winner': 2, 'huCard': 105, 'totalHuXi': 19, 'totalTun': 4, 'isTianHu': 0, 'isZiMo': 0, 'huList': [4], 'fanList': [4], 'huPath': [[4, 102, 102, 102], [4, 202, 202, 202], [1, 208, 209, 210], [7, 107, 107, 107, 107], [7, 207, 207, 207, 207], [1, 104, 105, 106], [0, 109, 109]], 'huCardIndex': 6, 'handCardIndex': 6, 'huangFanRate': 1}, 'spare_card': [], 'code': 0}")
    local data = json.decode('{"finishType":0,"code":0,"rate":1,"seq":6,"spare_card":[110,203,210,204,207,207,210,110,104],"isHuangZhuang":0,"seats":[{"handCards":[110,203,210,204,203,207,207,210,110,104],"totalScore":29,"seatID":1,"tableCards":[[4,209,209,209],[7,107,107,107,107],[4,105,105,105]],"score":-14},{"handCards":[108,108,203,203,109,109,109],"totalScore":137,"seatID":2,"tableCards":[[7,109,109,109,109],[7,205,205,205,205],[7,206,206,206,206],[7,202,202,202,202],[4,101,101,101]],"score":28}],"hasNextRound":false,"winInfo":{"huList":[4,16,17,13],"huPath":[[4,102,102,102],[4,202,202,202],[1,208,209,210],[7,107,107,107,107],[7,207,207,207,207],[1,104,105,106],[1,101,102,103],[0,109,109]],"rate":1,"winner":1,"totalTun":4,"isZiMo":1,"huangFanRate":2,"handCardIndex":6,"huCardIndex":6,"fanList":[4,5,6,7],"isTianHu":0,"huCard":105,"totalHuXi":19},"leftCards":[106,201,104,102,210,102,102,204,106,106,201,104,102,210,102,102,204,106,106,201,104,102,210,102,102,204,106,106,201,104,102,210,102,102,204,106]}')

    self:performWithDelay(function ()
        self:onRoundOver_({data = data})
    end,seconds)
end

function GameSceneTest.testGameOver(self)
    local data2 = json.decode('{"seats":[{"totalScore":-282,"roundMaxScore":0,"zhuangCount":0,"mingTangList":[[3,30],[5,30]],"mingTangCount":0,"winCount":0,"seatID":1,"ziMoCount":0,"loseCount":6},{"totalScore":564,"roundMaxScore":468,"zhuangCount":5,"mingTangList":[[11,30],[12,30]],"mingTangCount":5,"winCount":5,"seatID":2,"ziMoCount":5,"loseCount":1},{"totalScore":-282,"roundMaxScore":0,"zhuangCount":1,"mingTangList":[[10,30],[14,30]],"mingTangCount":0,"winCount":0,"seatID":3,"ziMoCount":0,"loseCount":6}],"code":0,"gid":1}')
    self:performWithDelay(function()
        dump(data2)
        self:onGameOver_({data = data2})
    end, 3)
    
end

-- 此项测试先要坐下
function GameSceneTest.testTimer(self)
    local seatID = math.random(1, 9)
    self.tableController_.seats_[seatID].view_:onStateThinking_({args = {math.random(1, 20)}})
end

function GameSceneTest.testCalcIndex(self)
    local c = self.tableController_
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
        uid         = 125894672,
        nickName   = "my昵称",
        seatID    = 0,
        sex        = 0,
        IP = '192.168.0.111',
        score = 0,
        data = json.encode({uid = 125894672})
    }
    selfData:setUid(data.uid)
    data.seatID = 2
    data.data = json.encode({uid = data.uid})
    self.tableController_:doPlayerSitDown(data)
    local hostSeatID = 2
    local tmp = clone(data)
    for i=1,2 do        
        tmp.nickName = tmp.nickName .. i
        if i ~= hostSeatID then
            tmp.seatID = i
            local uid = tmp.uid + math.random(100, 20000)
            tmp.uid = uid
            tmp.IP = IPList[math.random(1, #IPList)]
            tmp.data = json.encode({uid = uid})
            self.tableController_:doPlayerSitDown(tmp)
        end
    end
end

return GameSceneTest

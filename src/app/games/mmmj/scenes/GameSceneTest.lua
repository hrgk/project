local GameSceneTest = {}
-- local PaperCardGroup = require("app.utils.PaperCardGroup")

function GameSceneTest.test(self)
    -- GameSceneTest.showConfigCard(self)
    -- GameSceneTest.testCardGroup(self)
    -- GameSceneTest.sitDownAll(self)
    -- GameSceneTest.testRoomInfo(self)
    -- GameSceneTest.testRoundStart(self,1)
    -- GameSceneTest.testDealCards(self,2)
    -- GameSceneTest.testQiShouHu_(self,3)
    -- GameSceneTest.testTurnTo(self,2,3)
    -- GameSceneTest.testChuPai(self,2,11,7)
    -- GameSceneTest.testPublicTime(self,2,11,8)
    -- GameSceneTest.testPeng(self,1,11,10)
    -- GameSceneTest.testChuPai(self,1,13,11)
    -- GameSceneTest.testMopai(self,4,0,12)
    -- GameSceneTest.testChuPai(self,4,11,13)
    -- GameSceneTest.testUpdateScore(self,1,11,4)
    -- GameSceneTest.testGang(self,1,11,4)
    -- GameSceneTest.testGang(self,1,11,5)
    -- GameSceneTest.testGang(self,1,11,6)
    -- GameSceneTest.testGang(self,1,11,7)
    -- GameSceneTest.testMopai(self,2,16,9)
    -- GameSceneTest.testTurnTo(self,2,10)
    -- GameSceneTest.testChuPai(self,2,12,11)
    -- GameSceneTest.testAllpass(self,2,12,12)
    -- GameSceneTest.testMopai(self,3,0,13)
    -- GameSceneTest.testTurnTo(self,3,14)
    -- GameSceneTest.testChuPai(self,3,12,15)
    -- GameSceneTest.testAllpass(self,3,12,16)
    -- GameSceneTest.testMopai(self,4,0,17)
    -- GameSceneTest.testTurnTo(self,4,18)
    -- GameSceneTest.testChuPai(self,4,12,19)
    -- GameSceneTest.testAllpass(self,4,12,20)

    -- GameSceneTest.testMopai(self,1,23,21)
    -- GameSceneTest.testTurnTo(self,1,22)
    -- GameSceneTest.testChuPai(self,1,12,23)
    -- GameSceneTest.testChiPai(self,2,24)
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
    -- GameSceneTest.testHupai(self,2,11,3.5)
    -- GameSceneTest.testbird(self,2,11,1)
    -- GameSceneTest.testChiPath(self)

    -- GameSceneTest.testRoundOver(self, 5)
    -- GameSceneTest.testGameOver(self, 6)
    -- GameSceneTest.testAfterGangHou_(self, 5)
end

function GameSceneTest.testAfterGangHou_(self,seconds)
    local  cards ={11,  22, 22 , 19}
    local data = {}
    data.cards = cards
    data.seatID = 2
    data.dennyAnim = true
    self:performWithDelay(function()
        self.tableController_:doCSMJUserAfterGang_(data)
    end, seconds)
end

function GameSceneTest.testDealCards(self,seconds)
    local  cards ={11, 11, 11, 22, 22,22,23,23,23,24,24,24,25}
    local data = {}
    data.dealerSeatID = 2
    data.handCards = cards
    data.seq = 3
    self:performWithDelay(function()
        self.tableController_:onDealCards_({data = data})
        end, seconds)
end

function GameSceneTest.testQiShouHu_(self,seconds)
    -- ["recv",{"msg":{"seats":{"2":{"seatID":2,"score":-16},"4":{"seatID":4,"score":-16},"1":{"score":44,"huNameList":["liuLiuShun","qiShouSiZhang"],"cards":[11,11,11,22,22,22,22],"seatID":1},"3":{"seatID":3,"score":-12}},"code":0,"diceList":[6,4,3,6,4,1]},"cmd":1234}]
    local data = {}
    data.seats = {}
    data.seats[1] = {seatID = 1, score = 44, huNameList = {"liuLiuShun"}, cards = {11,11,11,22,22,22}}
    data.seats[2] = {seatID = 2, score = -12,huNameList = {"liuLiuShun"}, cards = {11,11,11,22,22,22}}
    data.seats[3] = {seatID = 3, score = -16,huNameList = {"liuLiuShun"}, cards = {11,11,11,22,22,22}}
    -- data.seats[4] = {seatID = 4, score = -16,huNameList = {"liuLiuShun"}, cards = {11,11,11,22,22,22}}
    data.diceList = {2,4,3,6,5,1}
    self:performWithDelay(function()
        self.tableController_:onCSTanPai_({data = data})
        end, seconds)
end

function GameSceneTest.testQiShouHuShuaNiao_(self)
    -- ["recv",{"msg":{"code":0,"scoreInfo":[{"updateScore":44,"currScore":44,"seatID":1},{"updateScore":-16,"currScore":-24,"seatID":2},{"updateScore":-12,"currScore":-12,"seatID":3},{"updateScore":-16,"currScore":-8,"seatID":4}]},"cmd":1237}]
end

function GameSceneTest.testbird(self,seatid,card,seconds)
   self:performWithDelay(function()
        local seatID = 1
        local data = {
            seatID = seatid,
            remainTime = 20,
            birdList = {11,12,13,14}
        }

        self:onShowBirds_({data = data})
    end, seconds)
end

function GameSceneTest.testPublicTime(self,seatid,card,seconds)
   self:performWithDelay(function()
        local seatID = dataCenter:getHostPlayer():getSeatID()
        local data = {
            seatID = seatid,
            remainTime = 20
        }

        self.tableController_:onPublicTime_({data = data})
    end, seconds)
end

function GameSceneTest.testPlayerAction(self,seatid,card,seconds)
   self:performWithDelay(function()
        local seatID = dataCenter:getHostPlayer():getSeatID()
        local data = {
            seatID = 2,
            remainTime = 20,
            code = 0,
            actType = CSMJ_ACTIONS.PENG,
            dennyAnim = false,
            cards = {11},
        }
        print("test playeraction")
        self.tableController_:onPlayAction_({data = data})
    end, seconds)
end

function GameSceneTest.testPeng(self,seatid,card,seconds)
   self:performWithDelay(function()
        local seatID = dataCenter:getHostPlayer():getSeatID()
        local data = {
            seatID = 1,
            fromSeatId = 2,
            isFinish = 1,
            act = CSMJ_ACTIONS.PENG,
            dennyAnim = false,
            card = card,
        }
        print("test testPeng")
        self.tableController_:onUserPeng_({data = data})
    end, seconds)
end
function GameSceneTest.testGang(self,seatid,card,seconds)
   self:performWithDelay(function()
        local seatID = 1
        local data = {
            seatID = 1,
            fromSeatId = 2,
            code = 0,
            act = CSMJ_ACTIONS.BU_GANG,
            dennyAnim = false,
            card = card,
        }
        print("test testGang")
        self.tableController_:onUserGang_({data = data})
    end, seconds)
end

function GameSceneTest.testUpdateScore(self,seatid,card,seconds)
   self:performWithDelay(function()
        local seatID = dataCenter:getHostPlayer():getSeatID()
        local data = {
            seatID = seatid,
            fromSeatId = 2,
            code = 0,
            act = CSMJ_ACTIONS.BU_GANG,
            dennyAnim = false,
            card = card,
            scoreInfo = {
                {
                    seatID = 1,
                    updateScore = 20,
                    currScore = 30,
                },
                {
                    seatID = 2,
                    updateScore = 20,
                    currScore = 40,
                },
                {
                    seatID = 3,
                    updateScore = 20,
                    currScore = 50,
                },
                {
                    seatID = 4,
                    updateScore = 20,
                    currScore = 60,
                },
            }
        }
        print("test testGang")
        self.tableController_:onUpdateScore_({data = data})
    end, seconds)
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
    image = "res/images/majiang/game/score-bg.png",
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
    local testData = require("app.games.mmmj.data.test")
    local data = testData[tonumber(cardId)]
    if not data or not data.cards then
        printError("test data fail!")
        return
    end
    dump(data)
    dataCenter:sendOverSocket(COMMANDS.MMMJ_DEBUG_CONFIG_CARD, data)
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
            seconds = 100
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
        local data = {
            -- seatID = seatID,
            -- isFinish = finish,
            -- act = CSMJ_ACTIONS.ZI_MO,
            -- code = 0,
            -- cards = {11,12,13,14,15,16}
            code = 0,
            huInfo = {{finish = finish, shouPai = {11,12,13}, isZiMo = false, seatID =1, preSeatID = 1},{finish = finish, shouPai = {11,12,13}, isZiMo = false, seatID =2, preSeatID = 1}}
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
        self.tableController_:onUserGang_ ({data = data})
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
        local cards = {23,21,22}
        local seatID = dataCenter:getHostPlayer():getSeatID()
        local data = {
            seatID = 2,
            card = 21,
            chiPai = {22,23},
            biPai = {},
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
        seatID = seatID,
        cards = card,
        code = 0,
        seconds = 99,
        operates = {},
    }
    self:performWithDelay(function ( ... )
        -- for i=1, 3 do
        local tmp = clone(data)
        tmp.seatID = seatID
        tmp.card = card
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
    require("app.utils.PaoHuZiTest")
    require("app.utils.GroupTest")
end

function GameSceneTest:testChi()
    local  cards ={106,106,106,102,102,102,110,110,209,209,109,208,208,108,207,207,107,206,105,203,201}
    self.tableController_.seats_[1]:setCards(cards)
    self.tableController_.seats_[2].view_:showMoPai(107)
    self.tableController_.seats_[1].view_:doPengPai( self.tableController_.seats_[2].view_.currCard,{102,102,102},true,true)

    self:performWithDelay(function()
        self.tableController_.seats_[2].view_:showMoPai(102)
        self.tableController_.seats_[3].view_:showMoPai(107)
        self.tableController_:showActions(true,false,true)
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
    local sprite = display.newSprite("res/images/majiang/game/button_gang.png"):addTo(self):pos(x, y)
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
        data = json.encode({uid = 2, sex = 2, nickName = "abc", avatar = "res/images/common/defaulthead.png" })  --\"uid\":2,\"sex\":2,\"nickName\":\"nomobile\",\"avatar\":\"res/images/common/defaulthead.png\
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
                totalSeat = 3,
                birdType = 0,
                birdCount = 6,
                birdScore = 1,
            }
        },
        creator = 125894673, -- 创建者
        status = 0, -- 房间状态 0 空闲中 1 准备中 2 游戏中 3 结算中
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
    -- dataCenter:getPokerTable():setOwner(1)
    local data = {
        seq = 8,
        hasNextRound = true,
        rate = 1, --// 倍率，计算总倍数时直接用当局得分除以倍率即可
        winner = {1}, -- // 赢家坐位ID
        totalHuXi = 18,-- // 总胡息
        finishType = 0, -- //结束类型，0正常结束 1房间解散结束
        isHuangZhuang = 0, -- // 黄庄
        -- rate = 1, --// 倍率，计算总倍数时直接用当局得分除以倍率即可
        -- winner = 3, -- // 赢家坐位ID
        -- totalHuXi = 18,-- // 总胡息
        -- isZiMo =  1, -- // 是否自摸
        -- isZhongzhuang = 1, -- // 是否中庄
        -- haiDiFan = 2, --// 海底番 平胡则为1，名堂胡则为2，非海底胡牌则为0
        -- huList = {2, 3, 9},-- // 胡型列表
        -- fanList = {2, 4, 8}, -- // 番率列表
        leftCards = {102, 102,103,104,105,203,205,209,103,104,105,203,205,209},-- // 剩余的牌
        winInfo = -- // 赢家信息，当解散或黄庄时不会有此信息
        {
            {
                rate = 1, -- // 倍率，计算总倍数时直接用当局得分除以倍率即可
                winner = 1, -- // 赢家坐位ID
                huCards = {26, 11}, -- // 胡的哪张牌
                isTianHu = 0,  -- // 是否天胡
                isDiHu = 0,  -- // 是否天胡
                isZiMo = 1, -- // 是否自摸
                isHaiDiFan = 2, --// 海底番 平胡则为1，名堂胡则为2，非海底胡牌则为0
                -- isZhongzhuang = 1, -- // 是否中庄
                huPath = {{11,12,51}, {24,51,26}, {35,36,37}, {33,33,33}, {15,15}},-- // 胡牌路径
                huCardIndex = 6, -- // 胡的牌张在胡牌路径中的索引
                handCardIndex = 2, -- // 手牌的在胡牌路径中的起始位置
                birdList = {11,22,33,34,35,36}
            },
        },

        -- jiePao,fangPao,jieGang,fangGang,anGang,mingGang,zhongNiao,qiangGangHu,zhuangXian
        seats ={
            {
                seatID = 1,
                tableCards= {},  --// 桌面牌公示
                handCards = {21,23,11,12,14,15,18}, --// 剩余没出的牌
                score =10, --// 当局得分
                totalScore = 0, --// 总得分,
                scoreFrom = {
                    qiangGangHu=0,
                    zhuangXian=2,
                    zhongNiao=3,
                    ziMo = 0,
                    dianPao = 0,
                    mingGang = 1,
                    anGang = 2,
                    fangGang = -1,
                    jieGang = 1,
                    fangPao = -1,
                    jiePao = 1,
                }
            },
            {
                seatID = 2,

                tableCards= {},  --// 桌面牌公示
                handCards = {21,23,11,12,14,15,18,11, 11, 11, 11,12}, --// 剩余没出的牌
                score =0, --2// 当局得分
                totalScore = 20 ,--// 总得分
                scoreFrom = {
                    qiangGangHu=0,
                    zhuangXian=2,
                    zhongNiao=3,
                    ziMo = 0,
                    dianPao = 0,
                     mingGang = 1,
                    anGang = 2,
                    fangGang = 0,
                    jieGang = 1,
                    fangPao = 1,
                    jiePao = 1,
                }
            },
            {
                seatID = 3,
                tableCards= {},  --// 桌面牌公示
                handCards = {21,23,11,12,14,15,18,11, 11, 11, 11,12}, --// 剩余没出的牌
                score =10, --// 当局得分
                totalScore = 10, --// 总得分
                scoreFrom = {
                    qiangGangHu=0,
                    zhuangXian=2,
                    zhongNiao=3,
                    ziMo = 0,
                    dianPao = 0,
                    mingGang = 1,
                    anGang = 2,
                    fangGang = -1,
                    jieGang = 1,
                    fangPao = 0,
                    jiePao = 1,
                }
            },
        }
    }

    -- 提前解散数据
    -- data = json.decode('{"finishType":1,"code":0,"rate":1,"seq":1,"isHuangZhuang":0,"seats":[{"totalScore":0,"handCards":[107,204,110,108,209,206,106,201,207,106,202,105,206,101,104,202,208,110,203,105],"score":0,"tableCards":{},"seatID":1},{"totalScore":0,"handCards":[202,210,210,210,201,109,209,108,105,204,102,104,208,109,106,208,102,206,105,207,205],"score":0,"tableCards":{},"seatID":2},{"totalScore":0,"handCards":[203,202,104,208,110,103,205,109,203,209,107,101,207,102,203,207,102,204,103,101],"score":0,"tableCards":{},"seatID":3}],"hasNextRound":false,"winInfo":{},"leftCards":[104,206,108,103,205,201,107,205,204,107,201,103,109,210,106,209,108,101,110]}')
    -- 正常数据dump(data2)
    -- data = json.decode('{"finishType":0,"code":0,"rate":1,"seq":6,"isHuangZhuang":1,"seats":[{"totalScore":-42,"score":0,"tableCards":[[3,202,102,102],[1,108,107,106],[3,209,109,109],[1,205,204,203],[1,105,104,103]],"handCards":[101,204,101,101,206],"seatID":1},{"totalScore":78,"score":0,"tableCards":[[3,210,210,110],[1,107,106,105],[1,106,108,107],[1,105,104,103],[1,205,204,203]],"handCards":[209,102,209,109,209],"seatID":2},{"totalScore":-36,"score":0,"tableCards":[[1,208,207,206],[3,208,108,108],[1,104,103,102],[1,104,106,105],[1,203,202,201],[3,207,207,107]],"handCards":[101,205],"seatID":3}],"hasNextRound":false,"winInfo":{},"leftCards":{}}')
    self:performWithDelay(function ()
        self:onRoundOver_({data = data})
    end,0)
end

function GameSceneTest.testGameOver(self)
    local  data = {gid = 8,
    seats = {
        {totalScore = -1, seatID = 1, ziMoCount = 1, chiHuCount = 5, dianPaoCount = 3, anGangCount = 3, mingGangCount = 3, winCount = 4},
        {totalScore = - 9, seatID = 2, ziMoCount = 5, chiHuCount = 4, dianPaoCount = 5, anGangCount = 3, mingGangCount = 3},
        {totalScore = 13, seatID = 3, ziMoCount = 2, chiHuCount = 3, dianPaoCount = 5, anGangCount = 3, mingGangCount = 3},
        {totalScore = 13, seatID = 4, ziMoCount = 2, chiHuCount = 3, dianPaoCount = 55, anGangCount = 3, mingGangCount = 3, winCount = 4},}
    }
    -- local data2 = json.decode('{"seats":[{"totalScore":-182,"roundMaxScore":0,"mingGangCount":0,"mingTangList":[[3,30],[5,30]],"anGangCount":0,"dianPaoCount":0,"seatID":4,"ziMoCount":1,"chiHuCount":6},{"totalScore":-282,"roundMaxScore":0,"zhuangCount":0,"mingTangList":[[3,30],[5,30]],"mingTangCount":0,"winCount":0,"seatID":1,"ziMoCount":0,"loseCount":6},{"totalScore":564,"roundMaxScore":468,"zhuangCount":5,"mingTangList":[[11,30],[12,30]],"mingTangCount":5,"winCount":5,"seatID":2,"ziMoCount":5,"loseCount":1},{"totalScore":-282,"roundMaxScore":0,"zhuangCount":1,"mingTangList":[[10,30],[14,30]],"mingTangCount":0,"winCount":0,"seatID":3,"ziMoCount":0,"loseCount":6}],"code":0,"gid":1}')
   
    self:onGameOver_({data = data})

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
        seatID    = 1,
        sex        = 0,
        IP = '192.168.0.111',
        score = 0,
        data = json.encode({uid = 125894672})
    }
    selfData:setUid(data.uid)
    local hostSeatID = 1
    local tmp = clone(data)
    dump(tmp)
    self:onPlayerEnterRoom_({data = tmp})
    for i=1,3 do
        tmp.nickName = tmp.nickName .. i
        if i ~= hostSeatID then
            tmp.seatID = i
            local uid = tmp.uid + math.random(100, 20000)
            tmp.uid = uid
            tmp.IP = IPList[math.random(1, #IPList)]
            tmp.data = json.encode({uid = uid})
            dump(tmp)
            self:onPlayerEnterRoom_({data = tmp})
        end
    end
end

return GameSceneTest

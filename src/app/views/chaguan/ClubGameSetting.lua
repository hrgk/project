local BaseView = import("app.views.BaseView")
local ClubGameSetting = class("ClubGameSetting", BaseView)
local TabButton = import("app.views.TabButton")
local CreatePDKView = import("app.views.hall.CreatePDKView")
local CreateZZMJView = import("app.views.hall.CreateZZMJView")
local CreateHZMJView = import("app.views.hall.CreateHZMJView")
local CreateNNView = import("app.views.hall.CreateNNView")
local CreateMPZhuang = import("app.views.hall.CreateMPZhuang")
local CreateNNZhuang = import("app.views.hall.CreateNNZhuang")
local CreateWorldNN = import("app.views.hall.CreateWorldNN")
local CreateBCNNView = import("app.views.hall.CreateBCNNView")
local CreateCSMJView = import("app.views.hall.CreateCSMJView")
local CreateDTZView = import("app.views.hall.CreateDTZView")
local CreateCDPHZView = import("app.views.hall.CreateCDPHZView")
local CreateYiYangNiuNiuView = import("app.views.hall.CreateYiYangNiuNiuView")
local CreateHSMJView = import("app.views.hall.CreateHSMJView")
local CreateSKView = import("app.views.hall.CreateSKView")
local CreateD13View = import("app.views.hall.CreateD13View")
local CreateJHD13View = import("app.views.hall.CreateJHD13View")
local ClubRuleSetting = import("app.views.chaguan.ClubRuleSetting")
local CreateFHHZMJView = import("app.views.hall.CreateFHHZMJView")
local CreateHSLMZ = import("app.views.hall.CreateHSLMZ")
local CreateSYBPView = import("app.views.hall.CreateSYBPView")
local CreateLDFPFView = import("app.views.hall.CreateLDFPFView")


local ChaGuanData = import("app.data.ChaGuanData")

function ClubGameSetting:ctor(floorConfig, matchType, subFloor, isAdd)
    self.subFloor_ = subFloor
    self.floorConfig_ = floorConfig
    self.matchType_ = matchType
    self.isAdd_ = isAdd
    ClubGameSetting.super.ctor(self)

    self.subList_ = {}
    self:setMask(0)
    self:loadRuleView(floorConfig, matchType, subFloor)
    self.ruleInfo = ChaGuanData.getFloorGameConfigBySubFloor(subFloor)
    self.itemList_ = {}
    self:initGamesButton_()
    self:addBtnToListView_()
    -- self:updateView_(#self.iconList_)
    self:initView()

    self.ruleSetting_:setVisible(false)

    self:onButtonClick_(self.btnList_[1], 2)
end

function ClubGameSetting:loadRuleView(floorConfig, matchType, subFloor)
   
    self.ruleView_ = ClubRuleSetting.new(floorConfig, matchType)
    self.csbNode_:addChild(self.ruleView_)
    self.ruleView_:setVisible(false)
    self.ruleView_:setPosition(0, 80)
end

function ClubGameSetting:initWorldNNView_()
    self:clearCurrView_()
    self.currView_ = CreateWorldNN.new():addTo(self.csbNode_)
    self.currView_:setPosition(0, 10)
end

function ClubGameSetting:initNNZhuangView_()
    self:clearCurrView_()
    self.currView_ = CreateNNZhuang.new():addTo(self.csbNode_)
    self.currView_:setPosition(0, 10)
end

function ClubGameSetting:initMPZhuangView_()
    self:clearCurrView_()
    self.currView_ = CreateMPZhuang.new():addTo(self.csbNode_)
    self.currView_:setPosition(0, 10)
end

function ClubGameSetting:initView()
    if self.isAdd_ then
        self.xiugai_:setVisible(false)
        self.createRoom_:setVisible(true)
    else
        self.xiugai_:setVisible(true)
        self.createRoom_:setVisible(false)
    end
end

function ClubGameSetting:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/club/subFloorSet/clubSetGame.csb"):addTo(self)
    self.csbNode_:setPosition(display.cx, display.cy)
end

function ClubGameSetting:initScrollView()
    local scrollView = ccui.ScrollView:create() 
    scrollView:setTouchEnabled(true) 
    scrollView:setBounceEnabled(true) --这句必须要不然就不会滚动噢 
    scrollView:setDirection(ccui.ScrollViewDir.vertical) --设置滚动的方向 
    scrollView:setContentSize(cc.size(1000,500)) --设置尺寸 
    scrollView:setInnerContainerSize(cc.size(1000, 500))
    scrollView:setAnchorPoint(cc.p(0.5,0.5))
    scrollView:setPosition(100, 20) 

    self.csbNode_:addChild(scrollView)
    -- scrollView:getInnerContainer():addChild(self.userList_)
    self.scrollView = scrollView
end

function ClubGameSetting:initGamesButton_()
    local roomInfoList = {
        [GAME_CDPHZ] = {
            spr = {"res/images/createRoom/btn_cdphz_n.png", "res/images/createRoom/btn_cdphz_o.png"},
            handler = handler(self, self.initCDPHZView_),
            switch = CHANNEL_CONFIGS.CDPHZ,
            name = "CDPHZ"
        },
        [GAME_PAODEKUAI] = {
            spr = {"res/images/createRoom/btn_pdk_n.png", "res/images/createRoom/btn_pdk_o.png"},
            handler = handler(self, self.initPdkView_),
            switch = CHANNEL_CONFIGS.PAO_DE_KUAI,
            name = "PAO_DE_KUAI"
        },
        [GAME_MJCHANGSHA] = {
            spr = {"res/images/createRoom/btn_csmj_n.png", "res/images/createRoom/btn_csmj_o.png"},
            handler = handler(self, self.initCsmjView_),
            switch = CHANNEL_CONFIGS.CHANG_SHA_MA_JIANG,
            name = "CHANG_SHA_MA_JIANG"
        },
        [GAME_MJZHUANZHUAN] = {
            spr = {"res/images/createRoom/btn_zzmj_n.png", "res/images/createRoom/btn_zzmj_o.png"},
            handler = handler(self, self.initZzmjView_),
            switch = CHANNEL_CONFIGS.ZHUAN_ZHUAN_MA_JIANG,
            name = "ZHUANG_ZHUANG_MA_JIANG"
        },
        [GAME_DA_TONG_ZI] ={
            spr = {"res/images/createRoom/btn_dtz_n.png", "res/images/createRoom/btn_dtz_o.png"},
            handler = handler(self, self.initDtzView_),
            switch = CHANNEL_CONFIGS.DA_TONG_ZI,
            name = "DA_TONG_ZI"
        },
        [GAME_BCNIUNIU] = {
            spr = {"res/images/createRoom/btn_niuniu_n.png", "res/images/createRoom/btn_niuniu_o.png"},
            handler = handler(self, self.initBcnnView_),
            switch = CHANNEL_CONFIGS.BING_CHENG_NIU_NIU,
            subList = {
                {
                    handler = handler(self, self.initWorldNNView_),
                    spr = {"res/images/createRoom/btn_sj_n.png","res/images/createRoom/btn_sj_o.png"},
                },
                {
                    handler = handler(self, self.initMPZhuangView_),
                    spr = {"res/images/createRoom/btn_mp_n.png","res/images/createRoom/btn_mp_o.png"},
                },
                {
                    handler = handler(self, self.initNNZhuangView_),
                    spr = {"res/images/createRoom/btn_nn_n.png","res/images/createRoom/btn_nn_o.png"},
                },
                {
                    handler = handler(self, self.initBcnnView_),
                    spr = {"res/images/createRoom/btn_bc_n.png","res/images/createRoom/btn_bc_o.png"},
                },
            },
            name = "BING_CHENG_NIU_NIU"
        },
        [GAME_13DAO] = {
            spr = {"res/images/createRoom/btn_13d_n.png", "res/images/createRoom/btn_13d_o.png"},
            handler = handler(self, self.initD13View_),
            switch = CHANNEL_CONFIGS.DAO13,
            subList = {
                {
                    handler = handler(self, self.initJHD13View_),
                    spr = {"res/images/createRoom/btn_jhs3d_n.png","res/images/createRoom/btn_jhs3d_o.png"},
                },
                {
                    handler = handler(self, self.initD13View_),
                    spr = {"res/images/createRoom/btn_bzs3d_n.png","res/images/createRoom/btn_bzs3d_o.png"},
                },
            
            },
            name = "DAO13"
        },
        [GAME_MJHONGZHONG] = {
            spr = {"res/images/createRoom/btn_hzmj_n.png", "res/images/createRoom/btn_hzmj_o.png"},
            handler = handler(self, self.initHzmjView_),
            switch = CHANNEL_CONFIGS.HONG_ZHONG_MA_JIANG,
            name = "HONG_ZHONG_MA_JIANG"
        },
        [GAME_SHUANGKOU] = {
            spr = {"res/images/createRoom/btn_sk_n.png", "res/images/createRoom/btn_sk_o.png"},
            handler = handler(self, self.initSKView_),
            switch = CHANNEL_CONFIGS.SHUANG_KOU,
            name = "SHUANG_KOU"
        },
        [GAME_HSMJ] = {
            spr = {"res/images/createRoom/btn_hsmj_n.png", "res/images/createRoom/btn_hsmj_o.png"},
            handler = handler(self, self.initHsmjView_),
            switch = CHANNEL_CONFIGS.HSMJ,
            name = "HSMJ"
        },
        [GAME_FHHZMJ] = {
            spr = {"res/images/createRoom/btn_fhhzmj_n.png", "res/images/createRoom/btn_fhhzmj_o.png"},
            handler = handler(self, self.initFHHZMJView_),
            switch = CHANNEL_CONFIGS.FHHZMJ,
            name = "FHHZMJ"
        },
        [GAME_FHLMZ] = {
            spr = {"res/images/createRoom/btn_nxzmz_n.png", "res/images/createRoom/btn_nxzmz_o.png"},
            handler = handler(self, self.initLMZView_),
            switch = CHANNEL_CONFIGS.GAME_FHLMZ,
            name = "FHHZMJ"
        },
        [GAME_SYBP] = {
            spr = {"res/images/createRoom/btn_sybp_n.png", "res/images/createRoom/btn_sybp_o.png"},
            handler = handler(self, self.initSYBPView_),
            switch = CHANNEL_CONFIGS.SYBP,
            name = "SYBP"
        },
        [GAME_LDFPF] = {
            spr = {"res/images/createRoom/btn_ldfpf_n.png", "res/images/createRoom/btn_ldfpf_o.png"},
            handler = handler(self, self.initLDFPFView_),
            switch = CHANNEL_CONFIGS.LDFPF,
            name = "LDFPF"
        },
    }


    self.gameInfoList = {}
    local info = setData:getAddress()
    info = string.split(info, ':')
    local mainId = info[1] and info[1]+0 or 0
    local subId = info[2] and info[2]+0 or 0
    if mainId == ADDRESS_ZJ then
        roomInfoList[GAME_13DAO].subList[2] = nil
    end
    for _, roomInfo in ipairs({roomInfoList[self.floorConfig_.game_type]}) do
        if roomInfo.switch ~= false then
            table.insert(self.gameInfoList, roomInfo)
        else
            print(roomInfo.name .. "is close")
        end
    end
end

function ClubGameSetting:clearCurrView_()
    -- self.scrollView:scrollToTop(0.5, true)
    if self.currView_ then
        self.currView_:removeFromParent()
        self.currView_ = nil
    end
end

function ClubGameSetting:initSKView_()
    self:clearCurrView_()
    self.currView_ = CreateSKView.new():addTo(self.csbNode_)
    self.currView_:setPosition(0, 10)
end

function ClubGameSetting:initJHD13View_()
    self:clearCurrView_()
    self.currView_ = CreateJHD13View.new():addTo(self.csbNode_)
    self.currView_:setPosition(0, 20)
end

function ClubGameSetting:initD13View_()
    self:clearCurrView_()
    self.currView_ = CreateD13View.new():addTo(self.csbNode_)
    self.currView_:setPosition(0, 20)
end

function ClubGameSetting:initLMZView_()
    self:clearCurrView_()
    self.currView_ = CreateHSLMZ.new():addTo(self.csbNode_)
    self.currView_:setPosition(0, 10)
end

function ClubGameSetting:initFHHZMJView_()
    self:clearCurrView_()
    self.currView_ = CreateFHHZMJView.new():addTo(self.csbNode_)
    if self.ruleInfo then
        self.currView_:setPosition(0, 18)
        local data = {
            consumeType = self.ruleInfo.consumeType,
            totalRound = self.ruleInfo.totalRound,
            ruleDetails = self.ruleInfo.ruleDetails,
            ruleType = self.ruleInfo.ruleType,
            juShu = self.ruleInfo.totalRound,
            matchConfig = self.ruleInfo.matchConfig,
            matchType = self.ruleInfo.matchType
        }
        self.currView_:setData(data,true) 
    else
        self.currView_:setPosition(0, 78)
    end
end

function ClubGameSetting:initHsmjView_()
    self:clearCurrView_()
    self.currView_ = CreateHSMJView.new():addTo(self.csbNode_)
   
    if self.ruleInfo then
        self.currView_:setPosition(0, 18)
        local data = {
            consumeType = self.ruleInfo.consumeType,
            totalRound = self.ruleInfo.totalRound,
            ruleDetails = self.ruleInfo.ruleDetails,
            ruleType = self.ruleInfo.ruleType,
            juShu = self.ruleInfo.totalRound,
            matchConfig = self.ruleInfo.matchConfig,
            matchType = self.ruleInfo.matchType
        }
        self.currView_:setData(data,true) 
    else
        self.currView_:setPosition(0, 78)
    end
end

function ClubGameSetting:initPhView_()
    self:clearCurrView_()
    -- self.currView_ = CreateYXPH.new():addTo(self.scrollView:getInnerContainer())
    -- self.currView_:setPosition(450,300)
    -- self.scrollView:setInnerContainerSize(cc.size(1000, 560))
    self.currView_ = CreateYXPH.new():addTo(self.csbNode_)
    self.currView_:setPosition(0,10)
    self.currView_:setShowZFType(self.matchType_)
end

function ClubGameSetting:initNnView_()
    self:clearCurrView_()
    -- self.currView_ = CreateNNView.new():addTo(self.scrollView:getInnerContainer())
    -- self.currView_:setPosition(450,300)
    -- self.scrollView:setInnerContainerSize(cc.size(1000, 560))
    self.currView_ = CreateNNView.new():addTo(self.csbNode_)
    self.currView_:setPosition(0,10)
    self.currView_:setShowZFType(self.matchType_)
end

function ClubGameSetting:initBcnnView_()
    self:clearCurrView_()
    -- self.currView_ = CreateBCNNView.new():addTo(self.scrollView:getInnerContainer())
    -- self.currView_:setPosition(450,300)
    -- self.scrollView:setInnerContainerSize(cc.size(1000, 560))
    self.currView_ = CreateBCNNView.new():addTo(self.csbNode_)
    self.currView_:setPosition(0,10)
    self.currView_:setShowZFType(self.matchType_)
    if self.ruleInfo then
        local data = {
            config = {
                consumeType = self.ruleInfo.consumeType,
                juShu = self.ruleInfo.totalRound,
                rules = self.ruleInfo.ruleDetails,
            }
        }
        self.currView_:setData(data)
    end
end

function ClubGameSetting:initDtzView_()
    self:clearCurrView_()
    -- self.currView_ = CreateDTZView.new():addTo(self.scrollView:getInnerContainer())
    -- self.currView_:setPosition(450,300)
    -- self.scrollView:setInnerContainerSize(cc.size(1000, 560))
    self.currView_ = CreateDTZView.new():addTo(self.csbNode_)
    self.currView_:setPosition(0,10)
    self.currView_:setShowZFType(self.matchType_)
    if self.ruleInfo then
        local data = {
            cardCount    = self.ruleInfo.ruleDetails.cardCount,
            consumeType  = self.ruleInfo.consumeType,
            maxPlayer    = self.ruleInfo.ruleDetails.totalSeat,
            mustDenny    = self.ruleInfo.ruleDetails.mustDenny,
            overBonus    = self.ruleInfo.ruleDetails.overBonus,
            randomDealer = self.ruleInfo.ruleDetails.randomDealer,
            showCard     = self.ruleInfo.ruleDetails.showCard,
            totalScore   = self.ruleInfo.ruleDetails.totalScore,
            totalSeat    = self.ruleInfo.ruleDetails.totalSeat,
        }
        self.currView_:setData(data)
    end
end

function ClubGameSetting:initYiYangView_()
    self:clearCurrView_()
    -- self.currView_ = CreateYiYangNiuNiuView.new():addTo(self.scrollView:getInnerContainer())
    -- self.currView_:setPosition(450,230)
    -- self.scrollView:setInnerContainerSize(cc.size(1000, 500))
    -- self.currView_ = CreateDTZView.new():addTo(self)
    -- self.currView_:setPosition(0,0)
end

function ClubGameSetting:initPdkView_()
    self:clearCurrView_()
    -- self.currView_ = CreatePDKView.new():addTo(self.scrollView:getInnerContainer())
    -- self.currView_:setPosition(450,230)
    -- self.scrollView:setInnerContainerSize(cc.size(1000, 500))
    self.currView_ = CreatePDKView.new():addTo(self.csbNode_)
    
    self.currView_:setShowZFType(self.matchType_)
    if self.ruleInfo then
        self.currView_:setPosition(0,35)
        local data = {
            config = {
                consumeType = self.ruleInfo.consumeType,
                juShu = self.ruleInfo.totalRound,
                rules = self.ruleInfo.ruleDetails,
            }
        }
        self.currView_:setData(data)
    else
        self.currView_:setPosition(0,70)
    end
end

function ClubGameSetting:initZzmjView_()
    self:clearCurrView_()
    -- self.currView_ = CreateZZMJView.new(0):addTo(self.scrollView:getInnerContainer())
    -- self.currView_:setPosition(450,230)
    -- self.scrollView:setInnerContainerSize(cc.size(1000, 500))
    self.currView_ = CreateZZMJView.new():addTo(self.csbNode_)
    self.currView_:setPosition(0,40)
    self.currView_:setShowZFType(self.matchType_)
    if self.ruleInfo then
        local data = {
            maJiangType = self.ruleInfo.gameType,
            consumeType = self.ruleInfo.consumeType,
            totalRound = self.ruleInfo.totalRound,
            huType = self.ruleInfo.huType,
            limitScore = self.ruleInfo.limitScore,
            birdCount = self.ruleInfo.birdCount,
            ruleDetails = self.ruleInfo.ruleDetails,
            ruleType = self.ruleInfo.ruleType,
            juShu = self.ruleInfo.totalRound,
            matchConfig = self.ruleInfo.matchConfig,
            matchType = self.ruleInfo.matchType
        }
        self.currView_:setData(data) 
    end
end

function ClubGameSetting:initCDPHZView_()
    self:clearCurrView_()
    self.currView_ = CreateCDPHZView.new():addTo(self.csbNode_)
    self.currView_:setPosition(0,20)
    self.currView_:setShowZFType(self.matchType_)
    if self.ruleInfo then
        local data = {
            consumeType = self.ruleInfo.consumeType,
            totalRound = self.ruleInfo.totalRound,
            ruleType = self.ruleInfo.ruleType,
            rules = self.ruleInfo.ruleDetails,
        }
        self.currView_:setData(data)
    end
end

function ClubGameSetting:initSYBPView_()
    self:clearCurrView_()
    self.currView_ = CreateSYBPView.new():addTo(self.csbNode_)
    self.currView_:setPosition(0,20)
    self.currView_:setShowZFType(self.matchType_)
    if self.ruleInfo then
        local data = {
            consumeType = self.ruleInfo.consumeType,
            totalRound = self.ruleInfo.totalRound,
            ruleType = self.ruleInfo.ruleType,
            rules = self.ruleInfo.ruleDetails,
        }
        self.currView_:setData(data)
    end
end

function ClubGameSetting:initLDFPFView_(eventType)
    self:clearCurrView_()
    self.currView_ = CreateLDFPFView.new(eventType):addTo(self.csbNode_)
    self.currView_:setPosition(0,20)
    self.currView_:setShowZFType(self.matchType_)
    if self.ruleInfo then
        local data = {
            consumeType = self.ruleInfo.consumeType,
            totalRound = self.ruleInfo.totalRound,
            ruleType = self.ruleInfo.ruleType,
            rules = self.ruleInfo.ruleDetails,
        }
        self.currView_:setData(data)
    end
end

function ClubGameSetting:initHzmjView_()
    self:clearCurrView_()
    self.currView_ = CreateHZMJView.new(1):addTo(self.csbNode_)
    self.currView_:setShowZFType(self.matchType_)
    if self.ruleInfo then
        self.currView_:setPosition(0,40)
        local data = {
            consumeType = self.ruleInfo.consumeType,
            ruleDetails = self.ruleInfo.ruleDetails,
            juShu = self.ruleInfo.totalRound
        }
        self.currView_:setData(data)
    else
        self.currView_:setPosition(0,78)
    end
end

function ClubGameSetting:initCsmjView_()
    self:clearCurrView_()
    self.currView_ = CreateCSMJView.new():addTo(self.csbNode_)
    self.currView_:setShowZFType(self.matchType_)
    if self.ruleInfo then
        self.currView_:setPosition(0,45)
        local data = {
            maJiangType = self.ruleInfo.gameType,
            consumeType = self.ruleInfo.consumeType,
            totalRound = self.ruleInfo.totalRound,
            limitScore = self.ruleInfo.ruleDetails.limitScore,
            birdCount = self.ruleInfo.ruleDetails.birdCount,
            ruleDetails = self.ruleInfo.ruleDetails,
            beginHuList = self.ruleInfo.ruleDetails.beginHuList,
            ruleType = self.ruleInfo.ruleType,
            birdScoreType = self.ruleInfo.ruleDetails.birdScoreType,
            haiDiType = self.ruleInfo.ruleDetails.haiDiType,
            zhuangType = self.ruleInfo.ruleDetails.zhuangType,
            juShu = self.ruleInfo.juShu,
            piao_type = self.ruleInfo.ruleDetails.piao_type,
            matchConfig = self.ruleInfo.matchConfig,
            matchType = self.ruleInfo.matchType
        }
        self.currView_:setData(data)
    else
        self.currView_:setPosition(0,100)
    end
end

function ClubGameSetting:addBtnToListView_()
    self.listView_:removeAllChildren()
    self.btnList_ = {}
    for i,v in ipairs(self.gameInfoList) do
        local listItemLayout = ccui.Layout:create()
        listItemLayout:setContentSize(260,124)
        local btn =ccui.Button:create(v.spr[1], v.spr[1], v.spr[2])
        btn:addTouchEventListener(handler(self, self.onButtonClick_))
        btn:pos(120,62)
        listItemLayout:addChild(btn,1,12)
        table.insert(self.btnList_, btn)
        if v.name == "CDPHZ" or v.name == "HONG_ZHONG_MA_JIANG" then
            local sp = display.newSprite("res/images/createRoom/hotFlag.png"):pos(175,110)
            listItemLayout:addChild(sp)
        elseif v.name == "SHUANG_KOU" then
            local sp = display.newSprite("res/images/createRoom/gcFlag.png"):pos(175,110)
            listItemLayout:addChild(sp)
        end
        self.listView_:pushBackCustomItem(listItemLayout)
    end
end

function ClubGameSetting:onSubButtonClick_(sender, eventType)
    if eventType == 0 then
        gameAudio.playSound("sounds/common/sound_button_click.mp3")
    elseif eventType == 2 then
        self:onSubBtnUpdate_(sender)
    end
end

function ClubGameSetting:onSubBtnUpdate_(sender)
    for i,v in ipairs(self.subList_) do
        if v == sender then
            v:setEnabled(false)
            v:setBright(false)
            self:subGameHandler_(i)
        else
            v:setEnabled(true)
            v:setBright(true)
        end
    end
end

function ClubGameSetting:subGameHandler_(index)
    if self.curSubIndex_ == index then return end
    self.curSubIndex_ = index

    local subList = self.gameInfoList[self.currentIndex_].subList
    for i,v in ipairs(subList) do
        if v.handler and self.curSubIndex_ == i then
            v.handler()
        end
    end
end

function ClubGameSetting:onButtonClick_(sender, eventType)
    if eventType == 0 then
        gameAudio.playSound("sounds/common/sound_button_click.mp3")
    elseif eventType == 2 then
        for i,v in ipairs(self.btnList_) do
            if v == sender then
                v:setEnabled(false)
                v:setBright(false)
                self:updateView_(i,eventType)
                if self.gameInfoList[i].subList ~= nil and #self.gameInfoList[i].subList ~= 0 then
                    local subList = self.gameInfoList[i].subList
                    for j,v in ipairs(subList) do
                        local listItemLayout = ccui.Layout:create()
                        listItemLayout:setContentSize(260,60)
                        local btn =ccui.Button:create(v.spr[1], v.spr[1], v.spr[2])
                        btn:addTouchEventListener(handler(self, self.onSubButtonClick_))
                        btn:pos(100,30)
                        listItemLayout:addChild(btn,1,12)
                        listItemLayout:setTag(j)
                        table.insert(self.subList_, btn)
                        self.listView_:insertCustomItem(listItemLayout, i)
                    end
                    self:onSubBtnUpdate_(self.subList_[#self.subList_])
                else
                    for i,v in ipairs(self.subList_) do
                        self.listView_:removeChildByTag(i)
                    end
                    self.subList_ = {}
                end
            else
                v:setEnabled(true)
                v:setBright(true)
            end
        end
    end
end

function ClubGameSetting:removeCurrentView_()
    if self.currentView_ then
        self.currentView_:removeFromParent()
        self.currentView_ = nil
    end
end

function ClubGameSetting:updateView_(index, eventType)
    if self.currentIndex_ == index and isForce ~= true then
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
    local name = self.gameInfoList[index].name
    local gameInfo = self.gameInfoList[self.currentIndex_]
    local activityHandler = gameInfo.handler
    local subList = gameInfo.subList or {}

    if activityHandler then
        activityHandler(eventType)
    else
        self:hide()
    end
end

function ClubGameSetting:gameSettingHandler_()
    self.ruleSetting_:setVisible(true)
    self.gameSetting_:setVisible(false)

    self.currView_:setVisible(false)
    self.ruleView_:setVisible(true)
end

function ClubGameSetting:ruleSettingHandler_()
    self.ruleSetting_:setVisible(false)
    self.gameSetting_:setVisible(true)

    self.currView_:setVisible(true)
    self.ruleView_:setVisible(false)
end

function ClubGameSetting:createRoomHandler_()
    -- app:showLoading("正在创建房间。。。。")
    local params = self.currView_:calcCreateRoomParams()
    local data = ChaGuanData.getClubInfo()
    params.clubID = data.clubID
    params.floor = self.floorConfig_.id
    -- params.maxAutoCreateRoom = 3 -- TODO: 临时写死
    params.matchType = self.matchType_

    local ruleParams = self.ruleView_:calcParams()
    local ruleParams = self.ruleView_:calcParams()
    local str = json.encode(ruleParams.matchConfig)
    table.merge(params, ruleParams or {})
    if tonumber(params.matchConfig.score or 100) < 50 then
        return app:showTips("参与游戏分数不能低于50")
    end
    if tonumber(params.matchConfig.score or 0) > 2000 then
        return app:showTips("参与游戏分数不能高于2000")
    end
    httpMessage.requestClubHttp(params, httpMessage.ADD_SUB_FLOOR)
    self:closeHandler_()
end

function ClubGameSetting:xiugaiHandler_()
    if display.getRunningScene():cheakHavePlaying(2,self.subFloor_) then
        app:showTips("桌子坐人,无法修改")
        return 
    end
    local params = self.currView_:calcCreateRoomParams()
    local data = ChaGuanData.getClubInfo()
    params.clubID = data.clubID
    params.subFloor = self.subFloor_
    params.matchType = self.matchType_

    local ruleParams = self.ruleView_:calcParams()
    local str = json.encode(ruleParams.matchConfig)
    table.merge(params, ruleParams or {})
    httpMessage.requestClubHttp(params, httpMessage.EDIT_SUB_FLOOR)
    self:closeHandler_()
end

function ClubGameSetting:closeGameHandler_()
    if display.getRunningScene():cheakHavePlaying(2,self.subFloor_) then
        app:showTips("桌子坐人,无法删除")
        return 
    end
    local params = {}
    local data = ChaGuanData.getClubInfo()
    params.clubID = data.clubID
    params.subFloor = self.subFloor_
    params.gameType = self.floorConfig_.game_type
    httpMessage.requestClubHttp(params, httpMessage.DEL_SUB_FLOOR)
    self:closeHandler_()
end

function ClubGameSetting:onCreateRoomReturn_(data)
    app:clearLoading()
    local result = json.decode(data)
    if HTTP_DIAMONDS_NOT_ENOUGH == checkint(result.status) then
        if not CHANNEL_CONFIGS.DIAMOND then
            return
        end
        app:confirm("钻石不足，请充值", function (isOK)
            if not isOK then
                return
            end
            display.getRunningScene():shopHandler_()
        end)
        return
    end

    if DIAMONDS_CLUB_NOT_ENOUGH == checkint(result.status) then
        if not CHANNEL_CONFIGS.DIAMOND then
            return
        end
        app:confirm("钻石因俱乐部开房预扣导致不足，请充值", function (isOK)
            if not isOK then
                return
            end
            display.getRunningScene():shopHandler_()
        end)
        return
    end

    if HTTP_HAVE_OTHER_ROOM == checkint(result.status) then
        return app:alert("创建房间失败，只能同时创建一个房间！")
    end
    if -1 == result.status then
        app:enterLoginScene()
        return
    end
    if 1 ~= result.status then
        return app:alert("创建房间失败，未知错误 " .. checkint(result.status))
    end
    local host = result.data.serverIP
    local port = checkint(result.data.serverPort)
    local roomID = checkint(result.data.roomID)
    dataCenter:sendEnterRoom(roomID)
    self:closeHandler_()
end

function ClubGameSetting:onCreateRoomFail_(...)
    app:clearLoading()
end

function ClubGameSetting:onExit()
    print("==========CreateRoomViewCreateRoomView==================")
end

return ClubGameSetting
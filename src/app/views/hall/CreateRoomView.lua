local BaseView = import("app.views.BaseView")
local CreateRoomView = class("CreateRoomView", BaseView)
local TabButton = import("app.views.TabButton")
local CreatePDKView = import(".CreatePDKView")
local CreateZZMJView = import(".CreateZZMJView")
local CreateHZMJView = import(".CreateHZMJView")
local CreateMPZhuang = import(".CreateMPZhuang")
local CreateWorldNN = import(".CreateWorldNN")
local CreateNNZhuang = import(".CreateNNZhuang")
local CreateBCNNView = import(".CreateBCNNView")
local CreateCSMJView = import(".CreateCSMJView")
local CreateMMMJView = import(".CreateMMMJView")
local CreateDTZView = import(".CreateDTZView")
local CreateCDPHZView = import(".CreateCDPHZView")
local CreateYZCHZView = import(".CreateYZCHZView")
local CreateSWCHZView = import(".CreateSWCHZView")
local CreateJY15View = import(".CreateJY15View")
local CreateLDSView = import(".CreateLDSView")
local CreateSKView = import(".CreateSKView")
local CreateYiYangNiuNiuView = import(".CreateYiYangNiuNiuView")
local CreateD13View = import(".CreateD13View")
local CreateJHD13View = import(".CreateJHD13View")
local CreateHSMJView = import(".CreateHSMJView")
local CreateFHHZMJView = import(".CreateFHHZMJView")
local CreateHSLMZ = import(".CreateHSLMZ")
local CreateHHQMTView = import(".CreateHHQMTView")
local CreateSYBPView = import(".CreateSYBPView")
local CreateLDFPFView = import(".CreateLDFPFView")

local ChaGuanData = import("app.data.ChaGuanData")
local EditRoomView = import("app.views.hall.editRoomView.EditRoomView")

function CreateRoomView:ctor(roomType, isFirst)
    self.roomType_ = roomType
    self.isOpen = false
    self.isFirst_ = isFirst
    self.itemList_ = {}
    self.subList_ = {}
    self.curSubIndex_ = 0
    CreateRoomView.super.ctor(self)

    self.editGame_:setTouchEnabled(true)
    self.editGame_:setSwallowTouches(true)

    self:initGamesButton_()
    self:addBtnToListView_()
    for i,v in ipairs(self.btnList_) do
        if i == 1 then
            v:setEnabled(false)
            v:setBright(false)
        else
            v:setEnabled(true)
            v:setBright(true)
        end
    end
    if roomType == 2 then
        self.xiugaiwanfa_:show()
        self.xiugai_:show()
        self.cjfj_:hide()
        self.createRoom_:hide()
        if self.isFirst_ then
            self.close_:hide()
        end
        if ChaGuanData.getClubInfo().permission == 99 then
            self.xiugai_:hide()
        end
    elseif roomType == 1 then
        self.xiugaiwanfa_:hide()
        self.xiugai_:hide()
        self.cjfj_:show()
        self.createRoom_:show()
    end

    local animation = cc.Animation:create()
    self.tipIndex = 1
    local sequence =
        transition.sequence(
        {
            cc.DelayTime:create(0.3),
            cc.CallFunc:create(
                function()
                    self.tipIndex = self.tipIndex + 1
                    if self.tipIndex > 3 then
                        self.tipIndex = 1
                    end
                    local frameName = string.format("res/res/images/createRoom/tip%d.png", self.tipIndex)
                    self.showTip_:loadTexture(frameName)
                end
            )
        }
    )
    self.showTip_:runAction(cc.RepeatForever:create(sequence))

    self:onButtonClick_(self.btnList_[1], 2)

    if SPECIAL_PROJECT then
        self.editGame_:hide()
    end
end

function CreateRoomView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/createRoom/createRoomView.csb"):addTo(self)
    self.csbNode_:setPosition(display.cx, display.cy)
end

function CreateRoomView:addBtnToListView_()
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
            listItemLayout:addChild(sp,100)
        elseif v.name == "SHUANG_KOU" or  v.name == "YZCHZ" or  v.name == "DAO13" or v.name == "HSMJ" or v.name == "FHHZMJ" or v.name == "HHQMT" or v.name == "SYBP" or v.name == "LDFPF" then
            local sp = display.newSprite("res/images/createRoom/gcFlag.png"):pos(175,110)
            listItemLayout:addChild(sp,100)
        end
        self.listView_:pushBackCustomItem(listItemLayout)
    end
end

function CreateRoomView:onButtonClick_(sender, eventType)
    if eventType == 0 then
        gameAudio.playSound("sounds/common/sound_button_click.mp3")
    elseif eventType == 2 then
        for i,v in ipairs(self.btnList_) do
            if v == sender then
                v:setEnabled(false)
                v:setBright(false)
                self:updateView_(i)
                for i,v in ipairs(self.subList_) do
                    self.listView_:removeChildByTag(i)
                end
                self.subList_ = {}
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
                    self:onSubBtnUpdate_(self.subList_[#subList])
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

function CreateRoomView:onSubButtonClick_(sender, eventType)
    if eventType == 0 then
        gameAudio.playSound("sounds/common/sound_button_click.mp3")
    elseif eventType == 2 then
        self:onSubBtnUpdate_(sender)
    end
end

function CreateRoomView:onSubBtnUpdate_(sender)
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

function CreateRoomView:subGameHandler_(index)
    if self.curSubIndex_ == index then return end
    self.curSubIndex_ = index

    local subList = self.gameInfoList[self.currentIndex_].subList
    for i,v in ipairs(subList) do
        if v.handler and self.curSubIndex_ == i then
            v.handler()
        end
    end
end

function CreateRoomView:initJR15View_()
    self:clearCurrView_()
    self.currView_ = CreateJY15View.new():addTo(self.csbNode_)
    self.currView_:setPosition(0, 20)
end
function CreateRoomView:initSWCHZView_()
    self:clearCurrView_()
    self.currView_ = CreateSWCHZView.new():addTo(self.csbNode_)
    self.currView_:setPosition(0, 20)
end
function CreateRoomView:initLDSView_()
    self:clearCurrView_()
    self.currView_ = CreateLDSView.new():addTo(self.csbNode_)
    self.currView_:setPosition(0, 20)
end

function CreateRoomView:initGamesButton_()
    self.roomInfoCof = {
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
        [GAME_MMMJ] ={
            spr = {"res/images/createRoom/btn_mmmj_n.png", "res/images/createRoom/btn_mmmj_o.png"},
            handler = handler(self, self.initMmmjView_),
            switch = CHANNEL_CONFIGS.MO_MO_MA_JIANG,
            name = "MO_MO_MA_JIANG"
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
        [GAME_MJHONGZHONG] = {
            spr = {"res/images/createRoom/btn_hzmj_n.png", "res/images/createRoom/btn_hzmj_o.png"},
            handler = handler(self, self.initHzmjView_),
            switch = CHANNEL_CONFIGS.HONG_ZHONG_MA_JIANG,
            name = "HONG_ZHONG_MA_JIANG"
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
        [GAME_SHUANGKOU] = {
            spr = {"res/images/createRoom/btn_sk_n.png", "res/images/createRoom/btn_sk_o.png"},
            handler = handler(self, self.initSKView_),
            switch = CHANNEL_CONFIGS.SHUANG_KOU,
            name = "SHUANG_KOU"
        },
        [GAME_YZCHZ] = {
            spr = {"res/images/createRoom/btn_yzchz_n.png", "res/images/createRoom/btn_yzchz_o.png"},
            handler = handler(self, self.initYZCHZView_),
            switch = CHANNEL_CONFIGS.YZCHZ,
            subList = {
                {
                    handler = handler(self, self.initJR15View_),
                    spr = {"res/images/createRoom/btn_jr15_n.png","res/images/createRoom/btn_jr15_o.png"},
                },
                {
                    handler = handler(self, self.initLDSView_),
                    spr = {"res/images/createRoom/btn_lds_n.png","res/images/createRoom/btn_lds_o.png"},
                },
                {
                    handler = handler(self, self.initSWCHZView_),
                    spr = {"res/images/createRoom/btn_swchz_n.png","res/images/createRoom/btn_swchz_o.png"},
                },
                {
                    handler = handler(self, self.initYZCHZView_),
                    spr = {"res/images/createRoom/btn_rzchzS_n.png","res/images/createRoom/btn_rzchzS_o.png"},
                },
            },
            name = "YZCHZ"
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
        [GAME_HHQMT] = {
            spr = {"res/images/createRoom/btn_hhqmt_n.png", "res/images/createRoom/btn_hhqmt_o.png"},
            handler = handler(self, self.initHHQMTView_),
            switch = CHANNEL_CONFIGS.HHQMT,
            name = "HHQMT"
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
    local roomInfoList = self:getRoomInfo()
    self.history = json.decode(createRoomData:getGameHistory()) or {}
    table.sort(
        roomInfoList,
        function(lh, rh)
            local lhTime = tonumber(self.history[lh.name]) or 0
            local rhTime = tonumber(self.history[rh.name]) or 0
            return lhTime > rhTime
        end
    )

    self.gameInfoList = {}
    for _, roomInfo in ipairs(roomInfoList) do
        if roomInfo.switch ~= false then
            table.insert(self.gameInfoList, roomInfo)
        end
    end
end

function CreateRoomView:getRoomInfo()
    local roomInfoList = {}
    for i,v in ipairs(self:getRoomList()) do
        roomInfoList[i] = self.roomInfoCof[v]
    end

    return roomInfoList
end

function CreateRoomView:getRoomList()
    local info = setData:getAddress()
    info = string.split(info, ':')
    local mainId = info[1] and info[1]+0 or 0
    local subId = info[2] and info[2]+0 or 0
    if mainId == ADDRESS_ZJ then
        self.roomInfoCof[GAME_13DAO].subList[2] = nil
    end
    local aimGameCof = createRoomData:getOpenGameList()
    if aimGameCof ~= nil and #aimGameCof ~= 0 then
        return aimGameCof
    end
    if ADDRESS_SOMEGAME_CONF[mainId] then
        aimGameCof = ADDRESS_SOMEGAME_CONF[mainId]
    elseif ADDRESS_GAME_CONF[mainId] and ADDRESS_GAME_CONF[mainId][subId] then
        aimGameCof = ADDRESS_GAME_CONF[mainId][subId]
    else
        aimGameCof = ADDRESS_NONE_GAME_CONF
    end
    return aimGameCof
end

function CreateRoomView:clearCurrView_()
    -- self.scrollView:scrollToTop(0.5, true)
    if self.currView_ then
        self.currView_:removeFromParent()
        self.currView_ = nil
    end
end

function CreateRoomView:initSKView_()
    self:clearCurrView_()
    self.currView_ = CreateSKView.new():addTo(self.csbNode_)
    self.currView_:setPosition(0, 10)
end

function CreateRoomView:initLMZView_()
    self:clearCurrView_()
    self.currView_ = CreateHSLMZ.new():addTo(self.csbNode_)
    self.currView_:setPosition(0, 10)
end

function CreateRoomView:initPhView_()
    self:clearCurrView_()
    -- self.currView_ = CreateYXPH.new():addTo(self.scrollView:getInnerContainer())
    -- self.currView_:setPosition(450,300)
    -- self.scrollView:setInnerContainerSize(cc.size(1000, 560))
    self.currView_ = CreateYXPH.new():addTo(self.csbNode_)
    self.currView_:setPosition(0, 10)
end

function CreateRoomView:initBcnnView_()
    self:clearCurrView_()
    self.currView_ = CreateBCNNView.new():addTo(self.csbNode_)
    self.currView_:setPosition(0, 10)
end

function CreateRoomView:initWorldNNView_()
    self:clearCurrView_()
    self.currView_ = CreateWorldNN.new():addTo(self.csbNode_)
    self.currView_:setPosition(0, 10)
end

function CreateRoomView:initNNZhuangView_()
    self:clearCurrView_()
    self.currView_ = CreateNNZhuang.new():addTo(self.csbNode_)
    self.currView_:setPosition(0, 10)
end

function CreateRoomView:initMPZhuangView_()
    self:clearCurrView_()
    self.currView_ = CreateMPZhuang.new():addTo(self.csbNode_)
    self.currView_:setPosition(0, 10)
end

function CreateRoomView:initDtzView_()
    self:clearCurrView_()
    self.currView_ = CreateDTZView.new():addTo(self.csbNode_)
    self.currView_:setPosition(0, 10)
end

function CreateRoomView:initYiYangView_()
    self:clearCurrView_()
    -- self.currView_ = CreateYiYangNiuNiuView.new():addTo(self.scrollView:getInnerContainer())
    -- self.currView_:setPosition(450,230)
    -- self.scrollView:setInnerContainerSize(cc.size(1000, 500))
    -- self.currView_ = CreateDTZView.new():addTo(self)
    -- self.currView_:setPosition(0,0)
end

function CreateRoomView:initPdkView_()
    self:clearCurrView_()
    -- self.currView_ = CreatePDKView.new():addTo(self.scrollView:getInnerContainer())
    -- self.currView_:setPosition(450,230)
    -- self.scrollView:setInnerContainerSize(cc.size(1000, 500))
    self.currView_ = CreatePDKView.new():addTo(self.csbNode_)
    self.currView_:setPosition(0, 70)
end

function CreateRoomView:initZzmjView_()
    self:clearCurrView_()
    -- self.currView_ = CreateZZMJView.new(0):addTo(self.scrollView:getInnerContainer())
    -- self.currView_:setPosition(450,230)
    -- self.scrollView:setInnerContainerSize(cc.size(1000, 500))
    self.currView_ = CreateZZMJView.new(0):addTo(self.csbNode_)
    self.currView_:setPosition(0, 40)
end

function CreateRoomView:initHHQMTView_()
    self:clearCurrView_()
    self.currView_ = CreateHHQMTView.new():addTo(self.csbNode_)
    self.currView_:setPosition(0, 20)
end

function CreateRoomView:initSYBPView_()
    self:clearCurrView_()
    self.currView_ = CreateSYBPView.new():addTo(self.csbNode_)
    self.currView_:setPosition(0, 20)
end

function CreateRoomView:initLDFPFView_()
    self:clearCurrView_()
    self.currView_ = CreateLDFPFView.new():addTo(self.csbNode_)
    self.currView_:setPosition(0, 20)
end

function CreateRoomView:initCDPHZView_()
    self:clearCurrView_()
    self.currView_ = CreateCDPHZView.new():addTo(self.csbNode_)
    self.currView_:setPosition(0, 20)
end

function CreateRoomView:initD13View_()
    self:clearCurrView_()
    self.currView_ = CreateD13View.new():addTo(self.csbNode_)
    self.currView_:setPosition(0, 20)
end

function CreateRoomView:initJHD13View_()
    self:clearCurrView_()
    self.currView_ = CreateJHD13View.new():addTo(self.csbNode_)
    self.currView_:setPosition(0, 20)
end

function CreateRoomView:initYZCHZView_()
    self:clearCurrView_()
    self.currView_ = CreateYZCHZView.new():addTo(self.csbNode_)
    self.currView_:setPosition(0, 20)
end

function CreateRoomView:initHzmjView_()
    self:clearCurrView_()
    -- self.currView_ = CreateZZMJView.new(1):addTo(self.scrollView:getInnerContainer())
    -- self.currView_:setPosition(450,280)
    -- self.scrollView:setInnerContainerSize(cc.size(1000, 540))
    self.currView_ = CreateHZMJView.new(1):addTo(self.csbNode_)
    self.currView_:setPosition(0, 78)
end


function CreateRoomView:initMmmjView_()
    self:clearCurrView_()
    -- self.currView_ = CreateCSMJView.new():addTo(self.scrollView:getInnerContainer())
    -- self.currView_:setPosition(450,280)
    -- self.scrollView:setInnerContainerSize(cc.size(1000, 540))
    self.currView_ = CreateMMMJView.new():addTo(self.csbNode_)
    self.currView_:setPosition(0, 100)
end

function CreateRoomView:initCsmjView_()
    self:clearCurrView_()
    -- self.currView_ = CreateCSMJView.new():addTo(self.scrollView:getInnerContainer())
    -- self.currView_:setPosition(450,280)
    -- self.scrollView:setInnerContainerSize(cc.size(1000, 540))
    self.currView_ = CreateCSMJView.new():addTo(self.csbNode_)
    self.currView_:setPosition(0, 100)
end

function CreateRoomView:initHsmjView_()
    self:clearCurrView_()
    self.currView_ = CreateHSMJView.new():addTo(self.csbNode_)
    self.currView_:setPosition(0, 78)
end

function CreateRoomView:initFHHZMJView_()
    self:clearCurrView_()
    self.currView_ = CreateFHHZMJView.new():addTo(self.csbNode_)
    self.currView_:setPosition(0, 78)
end

function CreateRoomView:removeCurrentView_()
    if self.currentView_ then
        self.currentView_:removeFromParent()
        self.currentView_ = nil
    end
end

function CreateRoomView:updateView_(index, isForce)
    if self.currentIndex_ == index and isForce ~= true then
        return
    end
    self.curSubIndex_ = 0
    self.currentIndex_ = index
    for i, v in pairs(self.itemList_) do
        v:updateState(self.currentIndex_ == i)
    end
    if self.itemList_[index] then
        self.itemList_[index]:updateState(true)
    end
    self:removeCurrentView_()
    local name = self.gameInfoList[index].name
    self.history[name] = tonumber(os.time())
    createRoomData:setGameHistory(json.encode(self.history))
    local gameInfo = self.gameInfoList[self.currentIndex_]
    local activityHandler = gameInfo.handler
    local subList = gameInfo.subList or {}

    if activityHandler then
        activityHandler(data)
    else
        self:hide()
    end
end

function CreateRoomView:createRoomHandler_()
    app:showLoading("正在创建房间。。。。")
    local params = self.currView_:calcCreateRoomParams()
    dump(params)
    HttpApi.createRoom(params, handler(self, self.onCreateRoomReturn_), handler(self, self.onCreateRoomFail_))
end

function CreateRoomView:xiugaiHandler_()
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

function CreateRoomView:editGameHandler_()
    local view = EditRoomView.new(self:getRoomList(), handler(self, self.editCallback)):addTo(self, 100)
    view:tanChuang()
end

function CreateRoomView:editCallback(isEdit)
    if isEdit then
        self:initGamesButton_()
        -- self.tableView_:reloadData()
        self:addBtnToListView_()
    end
end

function CreateRoomView:setAutoKaiFang_()
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

function CreateRoomView:onCreateRoomReturn_(data)
    app:clearLoading()
    local result = json.decode(data)
    if result == nil then
        return app:showTips("创建房间失败！！")
    end
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
        dump(result, "resultresultresultresult")
        return app:alert("创建房间失败，未知错误 3" .. checkint(result.status))
    end
    local host = result.data.serverIP
    local port = checkint(result.data.serverPort)
    local roomID = checkint(result.data.roomID)
    dataCenter:sendEnterRoom(roomID)
    self:closeHandler_()
end

function CreateRoomView:onCreateRoomFail_(...)
    app:clearLoading()
end

function CreateRoomView:onExit()
end

return CreateRoomView

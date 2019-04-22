
local BaseView = import("app.views.BaseView")
local ClubZhanJi = class("ClubZhanJi", BaseView)
local DuiZhanList = import(".DuiZhanList")
local DaYingJiaList = import(".DaYingJiaList")
local ChaGuanData = import("app.data.ChaGuanData")
local SelectedView = import("app.views.SelectedView")
local TabButton = import("app.views.TabButton")

function ClubZhanJi:ctor(data)
    ClubZhanJi.super.ctor(self)
    self:initElementRecursive_(self.csbNode_)
    --self:update(data)
    self.confList = {
        [1] = {
            spr = {"views/club/memManagement/gameIcon/btn_gameAll_n.png", "views/club/memManagement/gameIcon/btn_gameAll_o.png"},
            gameType = GAME_GAME_ALL,
        },
        [2] = {
            spr = {"views/club/memManagement/gameIcon/btn_pdk_n.png", "views/club/memManagement/gameIcon/btn_pdk_o.png"},
            gameType = GAME_PAODEKUAI,
        },
        [3] = {
            spr = {"views/club/memManagement/gameIcon/btn_cdphz_n.png", "views/club/memManagement/gameIcon/btn_cdphz_o.png"},
            gameType = GAME_CDPHZ,
        },
        [4] = {
            spr = {"views/club/memManagement/gameIcon/btn_csmj_n.png", "views/club/memManagement/gameIcon/btn_csmj_o.png"},
            gameType = GAME_MJCHANGSHA,
        },
        [5] = {
            spr = {"views/club/memManagement/gameIcon/btn_zzmj_n.png", "views/club/memManagement/gameIcon/btn_zzmj_o.png"},
            gameType = GAME_MJZHUANZHUAN,
        },
        [6] ={
            spr = {"views/club/memManagement/gameIcon/btn_dtz_n.png", "views/club/memManagement/gameIcon/btn_dtz_o.png"},
            gameType = GAME_DA_TONG_ZI,
        },
        [7] = {
            spr = {"views/club/memManagement/gameIcon/btn_niuniu_n.png", "views/club/memManagement/gameIcon/btn_niuniu_o.png"},
            gameType = GAME_BCNIUNIU,
        },
        [8] = {
            spr = {"views/club/memManagement/gameIcon/btn_hzmj_n.png", "views/club/memManagement/gameIcon/btn_hzmj_o.png"},
            gameType = GAME_MJHONGZHONG,
        },
        [9] = {
            spr = {"views/club/memManagement/gameIcon/btn_13d_n.png", "views/club/memManagement/gameIcon/btn_13d_o.png"},
            gameType = GAME_13DAO,
        },
        [10] = {
            spr = {"views/club/memManagement/gameIcon/btn_sk_n.png", "views/club/memManagement/gameIcon/btn_sk_o.png"},
            gameType = GAME_SHUANGKOU,
        },
        [11] = {
            spr = {"views/club/memManagement/gameIcon/btn_yzchz_n.png", "views/club/memManagement/gameIcon/btn_yzchz_o.png"},
            gameType = GAME_YZCHZ,
        },
        [12] = {
            spr = {"views/club/memManagement/gameIcon/btn_hsmj_n.png", "views/club/memManagement/gameIcon/btn_hsmj_o.png"},
            gameType = GAME_HSMJ,
        },
        [13] = {
            spr = {"views/club/memManagement/gameIcon/btn_fhhzmj_n.png", "views/club/memManagement/gameIcon/btn_fhhzmj_o.png"},
            gameType = GAME_FHHZMJ,
        },
    }
    self:initGamesButton_()
    self.currentGameType_ = -1
    self.isOpen = true
  
    self.viewList_ = {}
    if ChaGuanData.getClubInfo().permission == 1 or ChaGuanData.getClubInfo().permission == 0 then
    else
        self.qyqzj_:hide()
        self.myzj_:hide()
    end
    if self.currentGameIndex_ then
        self:onButtonClick_(self.btnList_[self.currentGameIndex_], 2)
    else
        self:onButtonClick_(self.btnList_[1], 2)
    end
    self.isOwner = 0
    self.gameSelectBg_:setVisible(false)
    self.gameList_:setVisible(false)
    self:initTime_()
    self:eDay7Handler_()
    self:sDay7Handler_()
    self:getZhanJiInfo()
end

function ClubZhanJi:getClassData(data)
    self.classInfo = {}
    self.classInfoZJNum = {}
    self.zzjNum = 0
    local nowTime = os.date("*t", gailun.utils.getTime())
    self.classInfo[GAME_GAME_ALL] = {}
    self.classInfoZJNum[GAME_GAME_ALL] = 0
    for key,value in pairs(data) do
        local type = value.gameType
        local aimTime = os.date("*t", value.time)
        self.classInfo[type] = self.classInfo[type] or {}
        self.classInfoZJNum[type] = self.classInfoZJNum[type] or 0
        table.insert(self.classInfo[type],value)
        table.insert(self.classInfo[GAME_GAME_ALL],value)
        self.zzjNum = self.zzjNum + 1
        self.classInfoZJNum[type] = self.classInfoZJNum[type] + 1
        self.classInfoZJNum[GAME_GAME_ALL] = self.classInfoZJNum[GAME_GAME_ALL] + 1
    end
    if not self.zzjNum_ or tolua.isnull(self.zzjNum_) then
        self.zzjNum_ = cc.LabelBMFont:create(0, "fonts/dtz_result_sm_score.fnt")
        self.zzjNum_:setPosition(self.zzjTip_:getPositionX()+58, self.zzjTip_:getPositionY())
        self.zzjNum_:setAnchorPoint(0,0.5)
        self.csbNode_:addChild(self.zzjNum_)
    end
    self.zzjNum_:setString(self.zzjNum)
    dump(self.classInfo,"self.classInfo")
end

function ClubZhanJi:initGamesButton_()
    local gameType = ChaGuanData.getGameType()
    local tag = {}
    for key,value in pairs(gameType) do
        tag[value.game_type] = true
    end
    self.gameList_:removeAllChildren()
    self.btnList_ = {}
    for i,v in ipairs(self.confList) do
        if tag[v.gameType] or v.gameType == GAME_GAME_ALL then
            local listItemLayout = ccui.Layout:create()
            listItemLayout:setContentSize(180,52)
            local btn =ccui.Button:create(v.spr[1], v.spr[1], v.spr[2])
            btn:addTouchEventListener(handler(self, self.onButtonClick_))
            btn:pos(86,26)
            listItemLayout:addChild(btn,1,12)
            btn.gameType = v.gameType
            btn.index = #self.btnList_+1
            table.insert(self.btnList_, btn)
            self.gameList_:pushBackCustomItem(listItemLayout)
        end
    end
end

function ClubZhanJi:onButtonClick_(sender, eventType)
    if eventType == 0 then
        gameAudio.playSound("sounds/common/sound_button_click.mp3")
    elseif eventType == 2 then
        for i,v in ipairs(self.btnList_) do
            if v == sender then
                v:setEnabled(false)
                v:setBright(false)
                self:updateGame_(v.gameType,v.index)
            else
                v:setEnabled(true)
                v:setBright(true)
            end
        end
    end
end

function ClubZhanJi:updateGame_(gameType)
    self.currentGameType_ = gameType
    self.currentGameIndex_ = index
    self.gameName_:setString(GAMES_NAME[gameType])
    self:yxxzHandler_()   
end

function ClubZhanJi:qyqzjHandler_()
    self:jieSuanHandler_(1)
end

function ClubZhanJi:myzjHandler_()
    self:jieSuanHandler_(2)
end

function ClubZhanJi:jieSuanHandler_(index)
    if index == 1 then
        self.isOwner = 0
    else
        self.isOwner = 1
    end
    self:getZhanJiInfo()
end

function ClubZhanJi:update(data)
    self.data_ = data
    self:getClassData(data)
end

function ClubZhanJi:updateShowView(data)
    self.data_ = data
    self:getClassData(data)
    self.gameSelectBg_:setVisible(false)
    self.gameList_:setVisible(false)
    dump(self.data_,"updateShowView")
    self:initJLBList_(self.classInfo[self.currentGameType_],GAMES_NAME[self.currentGameType_],self.classInfoZJNum[self.currentGameType_])
end

function ClubZhanJi:initJLBList_(data,name,zjNum)
    data = data or {}
    zjNum = zjNum or 0
    if not self.dqzjNum_ or tolua.isnull(self.dqzjNum_) then
        self.dqzjNum_ = cc.LabelBMFont:create(0, "fonts/dtz_result_sm_score.fnt")
        self.dqzjNum_:setPosition(self.dqzjTip_:getPositionX()+80, self.dqzjTip_:getPositionY())
        self.dqzjNum_:setAnchorPoint(0,0.5)
        self.csbNode_:addChild(self.dqzjNum_)
    end
    self.dqzjNum_:setString(zjNum)
    if self.jlbList_ and not tolua.isnull(self.jlbList_) then
        self.jlbList_:removeAllChildren()
    end
    self.jlbList_ = DuiZhanList.new(data):addTo(self.showItem_)
end

function ClubZhanJi:initMYList_(data)
    if self.myList_ then
        self.myList_:update(data)
        self.myList_:show()
        return
    end
    self.myList_ = DuiZhanList.new(data):addTo(self.showItem_)
end

function ClubZhanJi:initDYJList_(data)
    if self.dyjList_ then
        self.dyjList_:update(data)
        self.dyjList_:show()
        return
    end
    self.dyjList_ = DaYingJiaList.new(data):addTo(self.showItem_)
end

function ClubZhanJi:yxxzHandler_()
    local isShow = self.gameSelectBg_:isVisible()
    self.gameSelectBg_:setVisible(not isShow)
    self.gameList_:setVisible(not isShow)
end


function ClubZhanJi:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/club/memManagement/zhanji/zhanjiView.csb"):addTo(self)
end

function ClubZhanJi:initTime_()
    local time = os.date("*t", gailun.utils.getTime())
    time.day = time.day
    time.hour = 23
    time.min = 59
    time.second = 59
    self.timeValue = {}
    for i = 1,7 do
        if i > 1 then
            time.day = time.day - 1
        end
        local combInfo = os.time(time)
        table.insert(self.timeValue, 1, combInfo)
    end
    for i = 1,7 do
        local str = os.date("%Y.%m.%d", self.timeValue[i])
        self["daySV" .. i .. "_"]:setString(str)
        self["dayEV" .. i .. "_"]:setString(str)
    end
end

function ClubZhanJi:setBeginTime(index)
    local time = os.date("*t",self.timeValue[index])
    time.hour = 0
    time.min = 0
    time.second = 0
    time.sec = 0
    self.beginTime = os.time(time)
    self.sTimeValue_:setString(self["daySV" .. index .. "_"]:getString())
    self:sTimeHandler_()
end

function ClubZhanJi:setEndTime(index)
    local time = os.date("*t",self.timeValue[index])
    time.hour = 23
    time.min = 59
    time.second = 59
    time.sec = 59
    self.endTime = os.time(time)
    self.eTimeValue_:setString(self["daySV" .. index .. "_"]:getString())
    self:eTimeHandler_()
end

function ClubZhanJi:sTimeHandler_()
    self.sTimeBg_:setVisible(not self.sTimeBg_:isVisible())
end

function ClubZhanJi:eTimeHandler_()
    self.eTimeBg_:setVisible(not self.eTimeBg_:isVisible())
end

function ClubZhanJi:cxHandler_()
    self:getZhanJiInfo()
end

function ClubZhanJi:sDay1Handler_()
    self:setBeginTime(1)
end

function ClubZhanJi:sDay2Handler_()
    self:setBeginTime(2)
end

function ClubZhanJi:sDay3Handler_()
    self:setBeginTime(3)
end

function ClubZhanJi:sDay4Handler_()
    self:setBeginTime(4)
end

function ClubZhanJi:sDay5Handler_()
    self:setBeginTime(5)
end

function ClubZhanJi:sDay6Handler_()
    self:setBeginTime(6)
end

function ClubZhanJi:sDay7Handler_()
    self:setBeginTime(7)
end


function ClubZhanJi:eDay1Handler_()
    self:setEndTime(1)
end

function ClubZhanJi:eDay2Handler_()
    self:setEndTime(2)
end

function ClubZhanJi:eDay3Handler_()
    self:setEndTime(3)
end

function ClubZhanJi:eDay4Handler_()
    self:setEndTime(4)
end

function ClubZhanJi:eDay5Handler_()
    self:setEndTime(5)
end

function ClubZhanJi:eDay6Handler_()
    self:setEndTime(6)
end

function ClubZhanJi:eDay7Handler_()
    self:setEndTime(7)
end

function ClubZhanJi:getZhanJiInfo()
    local params = {}
    local clubInfo = ChaGuanData.getClubInfo()
    params.clubID = clubInfo.clubID
    params.startTime = self.beginTime
    params.endTime = self.endTime
    params.gameType = 0
    if ChaGuanData.getClubInfo().permission == 1 or ChaGuanData.getClubInfo().permission == 0 then
        params.isOwner = self.isOwner
    else
        params.isOwner = 1
    end
    if self.beforeparams then
        if params.clubID == self.beforeparams.clubID and params.startTime == self.beforeparams.startTime 
            and params.endTime == self.beforeparams.endTime 
            and params.isOwner == self.beforeparams.isOwner then
                self:initJLBList_(self.classInfo[self.currentGameType_],GAMES_NAME[self.currentGameType_],self.classInfoZJNum[self.currentGameType_])
            return
        end
    end
    self.beforeparams = clone(params)
    httpMessage.requestClubHttp(params, httpMessage.GET_CLUB_SCORE_LIST_BY_GAME_TYPE_AND_TIME)
end

return ClubZhanJi 

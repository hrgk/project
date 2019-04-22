local BaseItem = import("app.views.BaseItem")
local GameSetting = class("GameSetting", BaseItem)

function GameSetting:ctor(table)
    GameSetting.super.ctor(self)
    self.inGame_ = false
end

function GameSetting:setNode(node)
    GameSetting.super.setNode(self, node)
end

function GameSetting:setMode(mode)
    self.table_ = mode
    if self.table_:getClubID() == nil or self.table_:getClubID() < 0 then
        self.zl_:hide()
    end
end

function GameSetting:setCMD(cmd1, cmd2, gameType)
    self.tuiChuCMD_ = cmd1 
    self.jieSanCMD_ = cmd2
    self.gameType_ = gameType
end

function GameSetting:isWanJia(bool,inGame)
    if bool then
        self.tuiChu_:show()
        self.jieSan_:hide()
    else
        self.tuiChu_:hide()
        self.jieSan_:show()
    end
    if inGame and display.getRunningScene().tableController_:getHostPlayer() then
        self:showNewPos()
    end
end

function GameSetting:tuiChuHandler_()
    local function callback(bool)
        if bool then
            selfData:setNowRoomID(0)
            dataCenter:sendOverSocket(self.tuiChuCMD_)
        end
    end
    app:confirm("是否确定退出房间", callback)
end

function GameSetting:jieSanHandler_()
    local function callback(bool)
        if bool then
            selfData:setNowRoomID(0)
            dataCenter:sendOverSocket(self.jieSanCMD_)
        end
    end
    app:confirm("是否确定解散房间", callback)
end

function GameSetting:settingHandler_()
    print("========== self.gameType_=========", self.gameType_)
    display.getRunningScene():showGameSheZhi(true, self.gameType_)
end

function GameSetting:dingweiHandler_()
    if self.gameType_ == GAME_BCNIUNIU then
        return app:showTips("拼十暂不支持定位")
    end
    display.getRunningScene():sendDingWeiCMD()
end

function GameSetting:showNewPos()
    local name = display.getRunningScene().name
    dump(name,"namenamename")
    self.tuiChu_:hide()
    self.jieSan_:hide()
    self.jieSan_:hide()
    self.zl_:hide()
    local date = display.getRunningScene():getRuleDetails()
    if not date then
        date = display.getRunningScene():getTable():getConfigData().config.rules
    end
    if "NIUNIU" == name or date and date.playerCount and date.playerCount == 2 then
        self.dingwei_:hide()
        self.csbNode_:loadTexture("res/images/game/btnBg1.png")
        local height = 90
        self.csbNode_:setContentSize(cc.size(180, height))
        self.setting_:setPositionY(height*0.5)
        self.csbNode_:setPositionY(90)
    else
        local height = self.csbNode_:getContentSize().height
        self.dingwei_:setPositionY(height*0.3)
        self.setting_:setPositionY(height*0.7)
    end
end

function GameSetting:setNewPos()
    local tableControl = display.getRunningScene().tableController_
    if tableControl.isStanding then
        if not tableControl:isStanding() then
            self:showNewPos()
        end
    else
        self:showNewPos()
    end
    
end

function GameSetting:setVisible(visible)
    local name = display.getRunningScene().name
    local tableControl = display.getRunningScene().tableController_
    local date = display.getRunningScene():getRuleDetails()
    if "NIUNIU" == name or date and date.playerCount and date.playerCount == 2 then
        self.dingwei_:hide()
        if self.table_ and (self.table_:getClubID() == nil or self.table_:getClubID() < 0) then
            local height = 170
            self.csbNode_:setContentSize(cc.size(180, height))
            self.tuiChu_:setPositionY(height*0.3)
            self.jieSan_:setPositionY(height*0.3)
            self.setting_:setPositionY(height*0.7)
        else
            self.csbNode_:setContentSize(cc.size(180, 200))
        end
    end
    self.csbNode_:setVisible(visible)
end


function GameSetting:zlHandler_(visible)
    selfData:setNowRoomID(dataCenter:getRoomID())
    display.getRunningScene():enterQianScene()
end

return GameSetting 

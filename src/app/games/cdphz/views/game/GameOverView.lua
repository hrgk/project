local BaseView = import("app.views.BaseView")
local GameOverView = class("GameOverView", BaseView)
local ShareView = import("app.views.game.ShareView")
local TYPES = gailun.TYPES

function GameOverView:setRoomLabel_(params)
    self.gameRule_:setString(params.ruleString)
end

function GameOverView:setRoundInfo_(currRound, totalRound)
	local tableId = display.getRunningScene():getTable():getTid()
	local str = string.format("房间号:%d", tableId) .. " " .. "局数:" .. currRound .. "/" .. totalRound
    self.roomInfo_:setString(str)
end

function GameOverView:setTimeLable_(params)
	local overTime = ""
	if params.finishTime then
		overTime = overTime .. params.finishTime
	else
		overTime = overTime .. os.date("%Y-%m-%d %H:%M:%S")
	end
	self.time_:setString(overTime)
end

function GameOverView:ctor(data)
    dump(data,"datadatadatadatadatadatadatadatadatadata")
    GameOverView.super.ctor(self)
	if not CHANNEL_CONFIGS.SHARE then
		self.share_:hide()
	end
    if display.getRunningScene():getTable():getConfigData().rules.totalSeat == 2 then
        data.seats[3] = nil
    end
	local playerPos = {{},{300,800},{200,540,880}}
    local playerTable = display.getRunningScene():getTable()
    self:setRoundInfo_(data.gid, playerTable:getTotalRound())
	self:setRoomLabel_(data)
	self:setTimeLable_(data)
 	local length = #checktable(data.seats)
	for i,v in pairs(checktable(data.seats)) do
		local item = app:createConcreteView("game.GameOverItemView")
        local x,y = self:clacItemPos_(length, i)
		item:update(v,data.dismissSeat)
        item:setPosition(x,y)  
		self.csbNode_:addChild(item)  
    end
    local fxPosx = self.share_:getPositionX()
    local fxPosImagex = self.share2_:getPositionX()
    self.share_:setPositionX(fxPosImagex)
    self.share2_:setPositionX(fxPosx)
    self.recordId = gameLocalData:getGameRecordID()
    gameLocalData:setGameRecordID("")
end

function GameOverView:clacItemPos_(total, index)
    local offset = (index - (total - 1) / 2 - 1) * 400
    local x = offset
    local y = 0
    return x, y, index
end

function GameOverView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/games/cdphz/GameOver.csb"):addTo(self)
    self.csbNode_:setPosition(display.cx, display.cy)
end

function GameOverView:backHandler_()
	dataCenter:setRoomID(0)
	local clubId = display.getRunningScene():getTable():getClubID()
    if clubId > 0 then
        local params = {}
        params.clubID = clubId
        params.floor = gameData:getClubFloor()
		httpMessage.requestClubHttp(params, httpMessage.GET_CLUB_INFO)
        return
    end
    app:enterHallScene()
end

function GameOverView:shareHandler_()
	local function callback()
    end
    display.getRunningScene():gameShareWeiXin("常德跑胡","",callback,display.getRunningScene():getTable():getTid(),selfData:getUid(), self.recordId)
end

function GameOverView:share2Handler_()
    local function callback()
       
    end
    display.captureScreen(function (bSuc, filePath)
        --bSuc 截屏是否成功
        --filePath 文件保存所在的绝对路径
        if not bSuc then
            print("bSuc = false")
            return
        end
        display.getRunningScene():shareImage(2,"常德跑胡","",0, callback, filePath)
    end, gailun.native.getSDCardPath() .. "/screen.jpg")
end

return GameOverView

local GameOverView = class("GameOverView", function()
    return display.newColorLayer(cc.c4b(0,0,0,125))
end)

local FaceAnimationsData = require("app.data.FaceAnimationsData")
local csbPath =  "views/games/datongzi/roundOver/gameOverView.csb"
local ShareView = import("app.views.game.ShareView")
function GameOverView:ctor(data)
    self.data_ = data
    self.isShare_ = false
    self.csbNode = cc.uiloader:load(csbPath)
    self.csbNode:setAnchorPoint(cc.p(0, 0))

    self.csbNode:setPosition(display.cx - 5, display.cy-50)
    self:addChild(self.csbNode,1000)
    self:setRoomLabel_(data)
    self:setTimeLable_(data)
    self:initButton_()
    self:initItems_(data)
    self.recordId = gameLocalData:getGameRecordID()
    gameLocalData:setGameRecordID("")
end

function GameOverView:initItems_(data)
    for i,v in ipairs(data.seats) do
        local overItem = require("app.games.datongzi.views.game.GameOVerItemView").new(v)
        :addTo(UIHelp.seekNodeByNameEx(self.csbNode, "bg_2"))
        overItem:setAnchorPoint(cc.p(0,1))
        overItem:setPosition(cc.p(7,310 - (i-1)*150))
    end
end

function GameOverView:initButton_()
    local closeButton_= UIHelp.seekNodeByNameEx(self.csbNode, "closeButton_")
    UIHelp.addTouchEventListenerToBtnWithScale(closeButton_, function() self:onClose_() end)
    local returnButton_= UIHelp.seekNodeByNameEx(self.csbNode, "returnButton_")
    UIHelp.addTouchEventListenerToBtnWithScale(returnButton_, function() self:onClose_() end)
    local shareButton_= UIHelp.seekNodeByNameEx(self.csbNode, "shareButton_")
    UIHelp.addTouchEventListenerToBtnWithScale(shareButton_, function() self:onShareClicked_() end)
    local shareButton_= UIHelp.seekNodeByNameEx(self.csbNode, "shareImage_")
    UIHelp.addTouchEventListenerToBtnWithScale(shareButton_, function() self:onShareImageClicked_() end)

end

function GameOverView:setRoomLabel_(data)
    local rule = display:getRunningScene():getTable():getConfigData()
    local test = ""
    if rule.totalSeat == 3 then
        test = test.."三人打筒子  "
    elseif rule.totalSeat == 4 then
        test = test.."四人打筒子  "
    end
    if rule.totalScore == 600 then
        test = test.."600分  "
    elseif rule.totalScore == 1000 then
        test = test.."1000分  "
    end
    if rule.cardCount == 3 then
        test = test.."三副牌  "
    elseif rule.cardCount == 4 then
        test = test.."四副牌  "
    end
    if rule.showCard == 0 then
        test = test.."不显示手牌 "
    elseif rule.showCard == 1 then
        test = test.."显示手牌  "
    end
    local zhongJuLabel_ = UIHelp.seekNodeByNameEx(self.csbNode, "zhongJuLabel_")
    dump(rule)
    local zhongJuScore_ = display.newBMFontLabel({
            text = tostring(rule.overBonus),
            font = "fonts/dtzzs.fnt",
            })
    zhongJuScore_:setAnchorPoint(cc.p(0.5, 0.5))
    zhongJuLabel_:addChild(zhongJuScore_)
    zhongJuScore_:setPosition(cc.p(0,28))
    zhongJuLabel_:setString(" ")
    UIHelp.seekNodeByNameEx(self.csbNode, "roomNumLabel_"):setString(data.tableId)
    UIHelp.seekNodeByNameEx(self.csbNode, "wanfa_"):setString(test)
    -- UIHelp.seekNodeByNameEx(self.csbNode, "zhongJuLabel_"):setString(rule.overBonus)
end

function GameOverView:setTimeLable_(data)
    local overTime = "结束时间："
    if data.finishTime then
        overTime = overTime .. data.finishTime
    else
        overTime = overTime .. os.date("%Y-%m-%d %H:%M:%S")
    end
    UIHelp.seekNodeByNameEx(self.csbNode, "data_"):setString(overTime)
end

function GameOverView:onClose_()
    dataCenter:setRoomID(0)
    if display:getRunningScene():getTable():getClubID() > 0 then
        app:showLoading("正在返回俱乐部")
        local params = {}
        params.clubID = display:getRunningScene():getTable():getClubID()
        params.floor = gameData:getClubFloor()
        httpMessage.requestClubHttp(params, httpMessage.GET_CLUB_INFO)
        return
    end
    if self.data_.isClub then
        return self:removeSelf()
    end
    app:enterHallScene()
end

function GameOverView:onShareClicked_(event)
    local function callback()
       
    end
    display.getRunningScene():gameShareWeiXin("打筒子","",callback,display.getRunningScene():getTable():getTid(),selfData:getUid(), self.recordId)
end

function GameOverView:onShareImageClicked_()
    local function callback()
       
    end
    display.captureScreen(function (bSuc, filePath)
        --bSuc 截屏是否成功
        --filePath 文件保存所在的绝对路径
        if not bSuc then
            print("bSuc = false")
            return
        end
        display.getRunningScene():shareImage(2,"打筒子","",0, callback, filePath)
    end, gailun.native.getSDCardPath() .. "/screen.jpg")
end

return GameOverView

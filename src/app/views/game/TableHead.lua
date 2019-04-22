local BaseItem = import("app.views.BaseItem")
local TableHead = class("TableHead",BaseItem)

function TableHead:ctor(model)
    self.table_ = model
    self.secondTime = 0
    self.isFirstBattry = true
    self.secondBattery = 0
    TableHead.super.ctor(self)
end

function TableHead:initEventListeners_()
    cc.EventProxy.new(self.table_, self.csbNode_, true)
    :addEventListener(self.table_.INIT_TABLE_INFO, handler(self, self.onTableInfoHandler_))
    :addEventListener(self.table_.ROUND_CHANGE, handler(self, self.onRoundChange_))
end

function TableHead:onRoundChange_(event)
    local roomID = self.table_:getTid()
    local confJS = self.table_:getConfig().juShu 
    local text = "房间号:"..roomID.."   局数"..event.round.."/"..confJS
    if confJS <= 0 then
        text = "房间号:"..roomID.."   第"..event.round .. "局"
    end
    self.labelInfo_:setString(text)
    self.table_:setRoundIndex(event.round)
end

function TableHead:onTableInfoHandler_(event)
    local roomID = self.table_:getTid()
    local confJS = self.table_:getConfig().juShu 
    local text = "房间号:"..roomID.."   局数"..self.table_:getRoundIndex().."/"..confJS
    if confJS <= 0 then
        text = "房间号:"..roomID.."   第".. self.table_:getRoundIndex() .. "局"
    end
    self.labelInfo_:setString(text)
end

function TableHead:update(dt)
    self:batteryUpdate(dt)
    self:timeUpdate_(dt)
end

function TableHead:batteryUpdate(dt)
    self.secondBattery = self.secondBattery + dt
    local number = 0.1
    if not self.isFirstBattry then
        number = 5
    end
    if self.secondBattery > number then
        self.isFirstBattry = false
        self.secondBattery = 0
        local num_ = gailun.native.getBattery()/100
        self.batteryHong_:setVisible(false)
        self.batteryLv_:setVisible(false)
        self.batteryHong_:setScaleX(num_)
        self.batteryLv_:setScaleX(num_)
        if num_ > 0.1 then
            self.batteryHong_:setVisible(false)
            self.batteryLv_:setVisible(true)
        elseif num_ <= 0.1 then
            self.batteryHong_:setVisible(true)
            self.batteryLv_:setVisible(false)
        end
    end
end

function TableHead:timeUpdate_(dt)
    self.secondTime = self.secondTime + dt
    if self.secondTime > 1 then
        self.secondTime = 0
        local time = os.date("%X", os.time())
        time = string.sub(time,1,-4)
        self.timeLabel_:setString(time)
    end
end

function TableHead:setNode(node)
    self.csbNode_ = node
    self:initElement_()
    self:initEventListeners_()
end

function TableHead:setSubHandler(callfunc)
    self.subClickHandler_ =  callfunc
end

function TableHead:setWanFaHandler(callfunc)
    self.wanFaClickHandler_ =  callfunc
end

function TableHead:subHandler_(item)
    if self.subClickHandler_ then
        self.subClickHandler_()
    end
end

function TableHead:wanFaHandler_(item)
    if self.wanFaClickHandler_ then
        self.wanFaClickHandler_()
    end
end

function TableHead:hideSub()
    self.sub_:hide()
end

return TableHead 

local BaseView = import("app.views.BaseView")
local SetPHZView = class("SetPHZView",BaseView)

function SetPHZView:ctor(gameType)
    SetPHZView.super.ctor(self)
    self.gameType_ = gameType
    self:initState_()
end

function SetPHZView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/gameSetView/phzSetView.csb"):addTo(self)
end

function SetPHZView:initState_()
    self.hxts_:setSelected(setData:getCDPHZHXTS())
    self.tpts_:setSelected(setData:getCDPHZTPTS())
    local nowIndex = setData:getCDPHZBgIndex()
    --根据index设置显示
    self:showBgTip(nowIndex)
    local index = setData:getCDPHZCardType()
    if self.gameType_ == GAME_HHQMT then
        index = setData:getHHQMTCardType()
    else
        index = setData:getCDPHZCardType()
    end
    if self.gameType_ == GAME_LDFPF then
        index = 2
        self.card1_:hide()
    end
    self.card1_:setSelected(index == 1)
    self.card2_:setSelected(index == 2)

    local index = setData:getCDPHZCardLayout()
    local cardSizeIndex = setData:getCDPHZCardSize()
    self.layout1Pic_:loadTexture("res/images/setNew/layout1_" .. cardSizeIndex .. ".png")
    if index == 2 then
        self.layout2_:setSelected(true)
    else
        self.layout1DD_:setSelected(cardSizeIndex == 2)
        self.layout1D_:setSelected(cardSizeIndex == 0)
        self.layout1X_:setSelected(cardSizeIndex == 1)
        
    end
end


function SetPHZView:card1Handler_()
    self.card1_:setSelected(true)
    self.card2_:setSelected(false)
    self:doChangeCardType(1)
end

function SetPHZView:card2Handler_()
    self.card1_:setSelected(false)
    self.card2_:setSelected(true)
    self:doChangeCardType(2)
end

function SetPHZView:layout1DDHandler_()
    self.layout1D_:setSelected(false)
    self.layout1DD_:setSelected(true)
    self.layout1X_:setSelected(false)
    self.layout2_:setSelected(false)
    self:doChangeLayout(1)
    self:doChangeCardSize(2)
end

function SetPHZView:layout1DHandler_()
    self.layout1D_:setSelected(true)
    self.layout1DD_:setSelected(false)
    self.layout1X_:setSelected(false)
    self.layout2_:setSelected(false)
    self:doChangeLayout(1)
    self:doChangeCardSize(0)
end

function SetPHZView:layout1XHandler_()
    self.layout1X_:setSelected(true)
    self.layout1DD_:setSelected(false)
    self.layout1D_:setSelected(false)
    self.layout2_:setSelected(false)
    self:doChangeLayout(1)
    self:doChangeCardSize(1)
end

function SetPHZView:layout2Handler_()
    self.layout1X_:setSelected(false)
    self.layout1DD_:setSelected(false)
    self.layout1D_:setSelected(false)
    self.layout2_:setSelected(true)
    self:doChangeLayout(2)
end

function SetPHZView:doChangeCardSize(index)
    local nowIndex = setData:getCDPHZCardSize()
    if nowIndex ~= index then
        setData:setCDPHZCardSize(index)
        self.layout1Pic_:loadTexture("res/images/setNew/layout1_" .. index .. ".png")
        local aimTable = display.getRunningScene():getTable()
        if aimTable and aimTable.doChangeCardType_ then
            aimTable:doChangeLayout_(1) 
        end
    end
end

function SetPHZView:doChangeCardType(index)
    local nowIndex
    if self.gameType_ == GAME_HHQMT then
        nowIndex = setData:getHHQMTCardType()
    else
        nowIndex = setData:getCDPHZCardType()
    end
    if nowIndex ~= index then
        if self.gameType_ == GAME_HHQMT then
            setData:setHHQMTCardType(index)
        else
            setData:setCDPHZCardType(index)
        end
        local aimTable = display.getRunningScene():getTable()
        if aimTable and aimTable.doChangeCardType_ then
            aimTable:doChangeCardType_(index) 
        end
    end
end

function SetPHZView:doChangeLayout(index)
    local nowIndex = setData:getCDPHZCardLayout()
    if nowIndex ~= index then
        setData:setCDPHZCardLayout(index)
        local aimTable = display.getRunningScene():getTable()
        if aimTable and aimTable.doChangeLayout_ then
            aimTable:doChangeLayout_(index) 
        end
    end
end


function SetPHZView:changeTableBg(index)
    local nowIndex = setData:getCDPHZBgIndex()
    if nowIndex ~= index then
        self:showBgTip(index)
        local aimTable = display.getRunningScene():getTable()
        if aimTable and aimTable.doChangeTableBg_ then
            aimTable:doChangeTableBg_(index) 
            setData:setCDPHZBgIndex(index)
        end
    end
end


function SetPHZView:showBgTip(index)
    for i = 1, 4 do
        local aimTip = self["mask" .. i .. "_"]
        print(i,"mask" .. index .. "_",index == i)
        aimTip:setVisible(index == i)
    end
end


function SetPHZView:tptsHandler_(item)
    local res = item:isSelected()
    setData:setCDPHZTPTS(res)
    local aimTable = display.getRunningScene():getTable()
    if aimTable and aimTable.doTPTS_ then
        aimTable:doTPTS_(res) 
    end
end

function SetPHZView:hxtsHandler_(item)
    local res = item:isSelected()
    setData:setCDPHZHXTS(res)
    local aimTable = display.getRunningScene():getTable()
    if aimTable and aimTable.doHXTS_ then
        aimTable:doHXTS_(res) 
    end
end

function SetPHZView:bg1Handler_()
    self:changeTableBg(1)
end

function SetPHZView:bg2Handler_()
    self:changeTableBg(2)
end

function SetPHZView:bg3Handler_()
    self:changeTableBg(3)
end

function SetPHZView:bg4Handler_()
    self:changeTableBg(4)
end

return SetPHZView 

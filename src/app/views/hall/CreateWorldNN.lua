local BaseCreateView = import(".BaseCreateView")
local TeShuNiuView = import(".TeShuNiuView")
local BeiShuView = import(".BeiShuView")

local CreateWorldNN = class("CreateWorldNN", BaseCreateView)

function CreateWorldNN:ctor(showZFType)
    CreateWorldNN.super.ctor(self)
    self:scale(0.8)
    self.joker_:hide()
    self.daxiaowang_:setString("")
    self.jushuConf = {10,20,30}
    self.renShuConf = {6,8,10}
    self.beiSelected_ = false
    self.teShuSelected_ = false

    self.teShuNiuSelected_ = TeShuNiuView.new()
    self.teShuNiuSelected_:setNode(self.teShuContent_)

    self.beiShuSelected_ = BeiShuView.new(handler(self, self.beiShuSelectedHandler_))
    self.beiShuSelected_:setNode(self.beiShuContent_)


    self.juShuList_ = {}
    self.juShuList_[1] = self.juShu1_
    self.juShuList_[2] = self.juShu2_
    self.juShuList_[3] = self.juShu3_

    self.xiazhuList_ = {}
    self.xiazhuList_[1] = self.xiaZhu1_
    self.xiazhuList_[2] = self.xiaZhu2_
    self.xiazhuList_[3] = self.xiaZhu3_
    self.xiazhuList_[4] = self.xiaZhu4_
    self.xiazhuList_[5] = self.xiaZhu5_

    self.renList_ = {}
    self.renList_[1] = self.renShu1_
    self.renList_[2] = self.renShu2_
    self.renList_[3] = self.renShu3_

    self.zhuangList_ = {}
    self.zhuangList_[3] = self.zhuang3_
    
    self.tuiZhuList_ = {}
    self.tuiZhuList_[1] = self.tuiZhu1_
    self.tuiZhuList_[2] = self.tuiZhu2_

    self.zhiFuList_ = {}
    self.zhiFuList_[1] = self.zhifu1_
    self.zhiFuList_[2] = self.zhifu2_
    self.zhiFuList_[3] = self.zhifu3_

    self.taiXingList_ = {}   
    self.taiXingList_[1] = self.taiXing1_
    self.taiXingList_[2] = self.taiXing2_
 
    self:initZhiFuType_()

    self:initJuShu_()
    self:initRenShu_()
    self:initXiaZhu_()
    self:initZhuangType_()
    self:initTeShu_()
    self:initJoker_()
    -- self:initBeiShu_()
    self:initTuiZhu_()
    self:initTaiXing_()
    createRoomData:setGameIndex(GAME_BCNIUNIU)
    self:setShowZFType(showZFType)

    if self.teShuNiuSelected_:isAllSelected() then
        self.teShuInfo_:setString("全部勾选")
    else
        self.teShuInfo_:setString("部分勾选")
    end
    local beiType = tonumber(worldnnData:getFanBeiType())
    if  beiType == 1 then
        self.fanBeiInfo_:setString("牛八2倍，牛九2倍，牛牛3倍")
    else
        self.fanBeiInfo_:setString("牛八2倍，牛九3倍，牛牛4倍")
    end
    self.beiShuSelected_:setFanBeiType(beiType)
    self.cuoPai_:setSelected(worldnnData:getJZCP()+0 == 1)
    self.zhongTuJia_:setSelected(worldnnData:getJZJR()+0 == 1)
end

function CreateWorldNN:setData(data)
    dump(data,"CreateWorldNN:setData")
    self:updateZhiFuList_(data.config.consumeType+1)
    for key,value in pairs(self.jushuConf) do
        if value == data.config.juShu then
            self:updateJuShuList_(key)
            break
        end
    end
    for key,value in pairs(self.renShuConf) do
        if value == data.config.rules.playerCount then
            self:updateRenList_(key)
            break
        end
    end
    local reaCount = 0
    local count = 0
    for key,value in pairs(data.config.rules.specType) do
        count = count + 1
        if value == 1 then
            reaCount = reaCount + 1
        end
    end 
    if reaCount == count then
        self.teShuInfo_:setString("全部勾选")
    else
        self.teShuInfo_:setString("部分勾选")
    end
    if  data.config.rules.fanBeiType == 1 then
        self.fanBeiInfo_:setString("牛八2倍，牛九2倍，牛牛3倍")
    else
        self.fanBeiInfo_:setString("牛八2倍，牛九3倍，牛牛4倍")
    end
    self:updateXiaZhuList_(data.config.rules.score)
    self.cuoPai_:setSelected(data.config.rules.prohibitFanCard == 1)
    self.zhongTuJia_:setSelected(data.config.rules.prohibitEnter == 1)
    self:updateTaiXingList_(data.config.rules.detailType)
    -- self:updateBeiShuList_(data.config.rules.detailType)

    self.renShu_ = data.config.rules.playerCount
    self.xiaZhu_ = data.config.rules.score
    self.TXType_ = data.config.rules.detailType
    self.juShu_ = data.config.juShu
    self.zhiFuType_ = data.config.consumeType
end

function CreateWorldNN:beiShuSelectedHandler_(index)
    if index == 1 then
        self.fanBeiInfo_:setString("牛八2倍，牛九2倍，牛牛3倍")
    else
        self.fanBeiInfo_:setString("牛八2倍，牛九3倍，牛牛4倍")
    end
    self.beiSelected_ = false
end

function CreateWorldNN:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/createRoom/createNNZ.csb"):addTo(self)
end

function CreateWorldNN:initTaiXing_()
    local index = tonumber(worldnnData:getPX())
    self:updateTaiXingList_(index)
end

function CreateWorldNN:taiXing1Handler_()
    self:updateTaiXingList_(1)
end

function CreateWorldNN:taiXing2Handler_()
    self:updateTaiXingList_(2)
end

function CreateWorldNN:updateTaiXingList_(index)
    for i, v in ipairs(self.taiXingList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
    self.TXType_ = index
    worldnnData:setPX(index)
end

function CreateWorldNN:initZhiFuType_()
    local index = tonumber(worldnnData:getZhiFu())
    self:updateZhiFuList_(index)
    if self.zhiFuList_[index] then
        self.zhiFuList_[index]:setSelected(true)
    else
        self.zhiFuList_[1]:setSelected(true)
    end
    if index == 1 then
        self.zhiFuType_ = 0
    elseif index == 2 then
        self.zhiFuType_ = 1
    else
        self.zhiFuType_ = 2
    end
end

function CreateWorldNN:updateZhiFuList_(index)
    for i, v in ipairs(self.zhiFuList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
end

function CreateWorldNN:zhifu1Handler_()
    self:updateZhiFuList_(1)
    self.zhiFuType_ = 0
    worldnnData:setZhiFu(1)
end

function CreateWorldNN:zhifu2Handler_()
    self:updateZhiFuList_(2)
    worldnnData:setZhiFu(2)
    self.zhiFuType_ = 1
end

function CreateWorldNN:zhifu3Handler_()
    self:updateZhiFuList_(3)
    worldnnData:setZhiFu(3)
    self.zhiFuType_ = 2
end

function CreateWorldNN:initJoker_()
    local index = tonumber(worldnnData:getJoker())
    if index == 1 then
        self.joker_:setSelected(true)
    elseif index == 0 then
        self.joker_:setSelected(false)
    else
        self.joker_:setSelected(true)
    end
end

function CreateWorldNN:initTuiZhu_()
    local index = tonumber(worldnnData:getTuiZhu())
    self:updateTuiZhuList_(index)
    if index == 1 then
        self.tuiZhu_ = 0
    else
        self.tuiZhu_ = 1
    end
end

function CreateWorldNN:initTeShu_()
    local teShuGuiZe = tonumber(worldnnData:getTeShu())
    -- if teShuGuiZe == 1 then
    --     self.teShu_:setSelected(true)
    --     self.specType_ = {-1}
    -- else
    --     self.teShu_:setSelected(false)
    --     self.specType_ = {0}
    -- end
end

function CreateWorldNN:initJuShu_()
    local index = tonumber(worldnnData:getJuShu())
    self:updateJuShuList_(index)
    if index == 1 then
        self.juShu_ = 10
    elseif index == 2 then
        self.juShu_ = 20
    elseif index == 3 then
        self.juShu_ = 30
    end
end

function CreateWorldNN:initRenShu_()
    local index = tonumber(worldnnData:getRenShu())
    self:updateRenList_(index)
    if index == 1 then
        self.renShu_ = 6
    elseif index == 2 then
        self.renShu_ = 8
    elseif index == 3 then
        self.renShu_ = 10
    end
end

function CreateWorldNN:initBeiShu_()
    local index = tonumber(worldnnData:getBeiShu())
    self:updateBeiShuList_(index)
    self.beiType_ = index
end

function CreateWorldNN:initXiaZhu_()
    local index = tonumber(worldnnData:getXiaZhu())
    self:updateXiaZhuList_(index)
    self.xiaZhu_ = index
end

function CreateWorldNN:initZhuangType_()
    local index = tonumber(worldnnData:getZuoZhuang())
    self:updateZhuangList_(index)
    self.zhuangType_ = index
end

function CreateWorldNN:updateXiaZhuList_(index)
    for i,v in ipairs(self.xiazhuList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setEnabled(false)
        end
    end
end

function CreateWorldNN:updateBeiShuList_(index)
    for i,v in ipairs(self.beiShuList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setEnabled(false)
        end
    end
end

function CreateWorldNN:updateRenList_(index)
    for i,v in ipairs(self.renList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setEnabled(false)
        end
    end
end

function CreateWorldNN:updateJuShuList_(index)
    for i,v in ipairs(self.juShuList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setEnabled(false)
        end
    end
end

function CreateWorldNN:updateZhuangList_(index)
    -- self.zhuangList_[3]:setSelected(true)
    -- for i,v in ipairs(self.zhuangList_) do
    --     if index ~= i then
    --         v:setSelected(false)
    --         v:setEnabled(true)
    --     else
    --         v:setEnabled(false)
    --     end
    -- end
end

function CreateWorldNN:updateTuiZhuList_(index)
    for i,v in ipairs(self.tuiZhuList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setEnabled(false)
        end
    end
end

function CreateWorldNN:juShu1Handler_()
    self:updateJuShuList_(1)
    self.juShu_ = 10
    worldnnData:setJuShu(1)
end

function CreateWorldNN:juShu2Handler_()
    self:updateJuShuList_(2)
    self.juShu_ = 20
    worldnnData:setJuShu(2)
end

function CreateWorldNN:juShu3Handler_()
    self:updateJuShuList_(3)
    self.juShu_ = 30
    worldnnData:setJuShu(3)
end

function CreateWorldNN:renShu1Handler_()
    self:updateRenList_(1)
    self.renShu_ = 6
    worldnnData:setRenShu(1)
end

function CreateWorldNN:renShu2Handler_()
    self:updateRenList_(2)
    self.renShu_ = 8
    worldnnData:setRenShu(2)
end

function CreateWorldNN:renShu3Handler_()
    self:updateRenList_(3)
    self.renShu_ = 10
    worldnnData:setRenShu(3)
end

function CreateWorldNN:zhuang1Handler_(item)
    self:updateZhuangList_(1)
    self.zhuangType_ = 1
    worldnnData:setZuoZhuang(1)
end

function CreateWorldNN:zhuang2Handler_(item)
    self:updateZhuangList_(2)
    self.zhuangType_ = 2
    worldnnData:setZuoZhuang(2)
end

function CreateWorldNN:zhuang3Handler_(item)
    self:updateZhuangList_(3)
    self.zhuangType_ = 3
    worldnnData:setZuoZhuang(3)
end

function CreateWorldNN:zhuang4Handler_(item)
    self:updateZhuangList_(4)
    self.zhuangType_ = 4
    worldnnData:setZuoZhuang(4)
end

function CreateWorldNN:xiaZhu1Handler_(item)
    self:updateXiaZhuList_(1)
    self.xiaZhu_ = 1
    worldnnData:setXiaZhu(1)
end

function CreateWorldNN:xiaZhu2Handler_(item)
    self:updateXiaZhuList_(2)
    self.xiaZhu_ = 2
    worldnnData:setXiaZhu(2)
end

function CreateWorldNN:xiaZhu3Handler_(item)
    self:updateXiaZhuList_(3)
    self.xiaZhu_ = 3
    worldnnData:setXiaZhu(3)
end

function CreateWorldNN:xiaZhu4Handler_(item)
    self:updateXiaZhuList_(4)
    self.xiaZhu_ = 4
    worldnnData:setXiaZhu(4)
end

function CreateWorldNN:xiaZhu5Handler_(item)
    self:updateXiaZhuList_(5)
    self.xiaZhu_ = 5
    worldnnData:setXiaZhu(5)
end

function CreateWorldNN:beiShu1Handler_(item)
    self:updateBeiShuList_(1)
    self.beiType_ = 1
    worldnnData:setBeiShu(1)
end

function CreateWorldNN:beiShu2Handler_(item)
    self:updateBeiShuList_(2)
    self.beiType_ = 2
    worldnnData:setBeiShu(2)
end

function CreateWorldNN:beiShu3Handler_(item)
    self:updateBeiShuList_(3)
    self.beiType_ = 3
    worldnnData:setBeiShu(3)
end

function CreateWorldNN:beiShu4Handler_(item)
    self:updateBeiShuList_(4)
    self.beiType_ = 4
    worldnnData:setBeiShu(4)
end

function CreateWorldNN:tuiZhu1Handler_(item)
    self:updateTuiZhuList_(1)
    self.tuiZhu_ = 0
    worldnnData:setTuiZhu(1)
end

function CreateWorldNN:tuiZhu2Handler_(item)
    self:updateTuiZhuList_(2)
    self.tuiZhu_ = 1
    worldnnData:setTuiZhu(2)
end

function CreateWorldNN:teShuHandler_(item)
    if item:isSelected() then
        worldnnData:setTeShu(1)
        self.specType_ = {-1}
    else
        worldnnData:setTeShu(0)
        self.specType_ = {0}
    end
end

function CreateWorldNN:jokerHandler_(item)
    if item:isSelected() then
        worldnnData:setJoker(1)
    else
        worldnnData:setJoker(0)
    end
end

function CreateWorldNN:teShuGzHandler_(item)
    self.teShuSelected_ = not self.teShuSelected_
    self.teShuNiuSelected_:setVisible(self.teShuSelected_)
    if not self.teShuSelected_ then
        if self.teShuNiuSelected_:isAllSelected() then
            self.teShuInfo_:setString("全部勾选")
        else
            self.teShuInfo_:setString("部分勾选")
        end
    end
    self.teShuNiuSelected_:setDefaults()
end

function CreateWorldNN:fanbeiGzHandler_(item)
    self.beiSelected_ = not self.beiSelected_
    self.beiShuSelected_:setVisible(self.beiSelected_)
end

function CreateWorldNN:calcCreateRoomParams(daiKai)
    self.teShuNiuSelected_:setDefaults()
    local ipLimit = 0
    local guiZe = {}
    guiZe.playerCount = self.renShu_
    guiZe.zhuangType = 5
    guiZe.score = self.xiaZhu_
    guiZe.tuiZhu = self.tuiZhu_
    guiZe.maxQiang = 1
    guiZe.specType = self.teShuNiuSelected_:getNiuQun()
    guiZe.fanBeiType = self.beiShuSelected_:getFanBeiType()
    guiZe.joker = 0
    guiZe.prohibitFanCard = self.cuoPai_:isSelected() and 1 or 0
    guiZe.prohibitEnter = self.zhongTuJia_:isSelected() and 1 or 0
    worldnnData:setJZCP(guiZe.prohibitFanCard)
    worldnnData:setJZJR(guiZe.prohibitEnter)
    guiZe.detailType = self.TXType_
    local params = {
        gameType = GAME_BCNIUNIU, -- 游戏服务类型
        totalRound = self.juShu_, -- 游戏局数
        consumeType = self.zhiFuType_,
        isAgent = 0,  -- 代开 0为否 1为是
        ipLimit = 0,  -- 是否禁止相同IP入坐，1为禁止，0为不禁止
        ruleType = 5,  -- 游戏小规则类型 默认为1, 可由不同游戏自己定义
        ruleDetails = guiZe -- 任意定义的规则选项, 参考下面的各游戏详细规则说明 -- 规则详情
    }
    return params
end

return CreateWorldNN 

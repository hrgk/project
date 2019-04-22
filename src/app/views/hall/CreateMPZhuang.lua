local BaseCreateView = import(".BaseCreateView")
local TeShuNiuView = import(".TeShuNiuView")
local BeiShuView = import(".BeiShuView")

local CreateMPZhuang = class("CreateMPZhuang", BaseCreateView)

function CreateMPZhuang:ctor(showZFType)
    CreateMPZhuang.super.ctor(self)
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

    self.beiShuList_ = {
        self.beiShu1_, self.beiShu2_, self.beiShu3_, self.beiShu4_
    }

    self.taiXingList_ = {}   
    self.taiXingList_[1] = self.taiXing1_
    self.taiXingList_[2] = self.taiXing2_
 
    -- dump(self.zhiFuList_)
    -- self.zhiFuList_[2] = self.zhifu2_
    -- self.zhiFuList_[3] = self.zhifu3_

    self:initZhiFuType_()

    self:initJuShu_()
    self:initRenShu_()
    self:initXiaZhu_()
    self:initZhuangType_()
    self:initTeShu_()
    self:initJoker_()
    self:initBeiShu_()
    self:initTuiZhu_()
    self:initTaiXing_()
    createRoomData:setGameIndex(GAME_BCNIUNIU)
    self:setShowZFType(showZFType)

    if self.teShuNiuSelected_:isAllSelected() then
        self.teShuInfo_:setString("全部勾选")
    else
        self.teShuInfo_:setString("部分勾选")
    end
    local beiType = tonumber(mpnnData:getFanBeiType())
    if  beiType == 1 then
        self.fanBeiInfo_:setString("牛八2倍，牛九2倍，牛牛3倍")
    else
        self.fanBeiInfo_:setString("牛八2倍，牛九3倍，牛牛4倍")
    end
    self.beiShuSelected_:setFanBeiType(beiType)
    self.cuoPai_:setSelected(mpnnData:getJZCP()+0 == 1)
    self.zhongTuJia_:setSelected(mpnnData:getJZJR()+0 == 1)
end

function CreateMPZhuang:setData(data)
    dump(data,"CreateMPZhuang:setData")
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

    dump(data.config)
    self:updateXiaZhuList_(data.config.rules.score)
    self.cuoPai_:setSelected(data.config.rules.prohibitFanCard == 1)
    self.zhongTuJia_:setSelected(data.config.rules.prohibitEnter == 1)
    self:updateTaiXingList_(data.config.rules.detailType)
    self:updateBeiShuList_(data.config.rules.maxQiang)

    self.beiType_ = data.config.rules.maxQiang
    self.renShu_ = data.config.rules.playerCount
    self.xiaZhu_ = data.config.rules.score
    self.TXType_ = data.config.rules.detailType
    self.juShu_ = data.config.juShu
    self.zhiFuType_ = data.config.consumeType
end

function CreateMPZhuang:beiShuSelectedHandler_(index)
    if index == 1 then
        self.fanBeiInfo_:setString("牛八2倍，牛九2倍，牛牛3倍")
    else
        self.fanBeiInfo_:setString("牛八2倍，牛九3倍，牛牛4倍")
    end
    self.beiSelected_ = false
end

function CreateMPZhuang:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/createRoom/createPTNN.csb"):addTo(self)
end

function CreateMPZhuang:initTaiXing_()
    local index = tonumber(mpnnData:getPX())
    self:updateTaiXingList_(index)
end

function CreateMPZhuang:taiXing1Handler_()
    self:updateTaiXingList_(1)
end

function CreateMPZhuang:taiXing2Handler_()
    self:updateTaiXingList_(2)
end

function CreateMPZhuang:updateTaiXingList_(index)
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
    mpnnData:setPX(index)
end

function CreateMPZhuang:initZhiFuType_()
    local index = tonumber(mpnnData:getZhiFu())
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

function CreateMPZhuang:updateZhiFuList_(index)
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

function CreateMPZhuang:zhifu1Handler_()
    self:updateZhiFuList_(1)
    self.zhiFuType_ = 0
    mpnnData:setZhiFu(1)
end

function CreateMPZhuang:zhifu2Handler_()
    self:updateZhiFuList_(2)
    mpnnData:setZhiFu(2)
    self.zhiFuType_ = 1
end

function CreateMPZhuang:zhifu3Handler_()
    self:updateZhiFuList_(3)
    mpnnData:setZhiFu(3)
    self.zhiFuType_ = 2
end

function CreateMPZhuang:initJoker_()
    local index = tonumber(mpnnData:getJoker())
    if index == 1 then
        self.joker_:setSelected(true)
    elseif index == 0 then
        self.joker_:setSelected(false)
    else
        self.joker_:setSelected(true)
    end
end

function CreateMPZhuang:initTuiZhu_()
    local index = tonumber(mpnnData:getTuiZhu())
    self:updateTuiZhuList_(index)
    if index == 1 then
        self.tuiZhu_ = 0
    else
        self.tuiZhu_ = 1
    end
end

function CreateMPZhuang:initTeShu_()
    local teShuGuiZe = tonumber(mpnnData:getTeShu())
    -- if teShuGuiZe == 1 then
    --     self.teShu_:setSelected(true)
    --     self.specType_ = {-1}
    -- else
    --     self.teShu_:setSelected(false)
    --     self.specType_ = {0}
    -- end
end

function CreateMPZhuang:initJuShu_()
    local index = tonumber(mpnnData:getJuShu())
    self:updateJuShuList_(index)
    if index == 1 then
        self.juShu_ = 10
    elseif index == 2 then
        self.juShu_ = 20
    elseif index == 3 then
        self.juShu_ = 30
    end
end

function CreateMPZhuang:initRenShu_()
    local index = tonumber(mpnnData:getRenShu())
    self:updateRenList_(index)
    if index == 1 then
        self.renShu_ = 6
    elseif index == 2 then
        self.renShu_ = 8
    elseif index == 3 then
        self.renShu_ = 10
    end
end

function CreateMPZhuang:initBeiShu_()
    local index = tonumber(mpnnData:getBeiShu())
    self:updateBeiShuList_(index)
    self.beiType_ = index
end

function CreateMPZhuang:initXiaZhu_()
    local index = tonumber(mpnnData:getXiaZhu())
    self:updateXiaZhuList_(index)
    self.xiaZhu_ = index
end

function CreateMPZhuang:initZhuangType_()
    local index = tonumber(mpnnData:getZuoZhuang())
    self:updateZhuangList_(index)
    self.zhuangType_ = index
end

function CreateMPZhuang:updateXiaZhuList_(index)
    for i,v in ipairs(self.xiazhuList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
end

function CreateMPZhuang:updateBeiShuList_(index)
    for i,v in ipairs(self.beiShuList_) do
        print(index ~= i, index, i)
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
end

function CreateMPZhuang:updateRenList_(index)
    for i,v in ipairs(self.renList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setEnabled(false)
        end
    end
end

function CreateMPZhuang:updateJuShuList_(index)
    for i,v in ipairs(self.juShuList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setEnabled(false)
        end
    end
end

function CreateMPZhuang:updateZhuangList_(index)
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

function CreateMPZhuang:updateTuiZhuList_(index)
    for i,v in ipairs(self.tuiZhuList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setEnabled(false)
        end
    end
end

function CreateMPZhuang:juShu1Handler_()
    self:updateJuShuList_(1)
    self.juShu_ = 10
    mpnnData:setJuShu(1)
end

function CreateMPZhuang:juShu2Handler_()
    self:updateJuShuList_(2)
    self.juShu_ = 20
    mpnnData:setJuShu(2)
end

function CreateMPZhuang:juShu3Handler_()
    self:updateJuShuList_(3)
    self.juShu_ = 30
    mpnnData:setJuShu(3)
end

function CreateMPZhuang:renShu1Handler_()
    self:updateRenList_(1)
    self.renShu_ = 6
    mpnnData:setRenShu(1)
end

function CreateMPZhuang:renShu2Handler_()
    self:updateRenList_(2)
    self.renShu_ = 8
    mpnnData:setRenShu(2)
end

function CreateMPZhuang:renShu3Handler_()
    self:updateRenList_(3)
    self.renShu_ = 10
    mpnnData:setRenShu(3)
end

function CreateMPZhuang:zhuang1Handler_(item)
    self:updateZhuangList_(1)
    self.zhuangType_ = 1
    mpnnData:setZuoZhuang(1)
end

function CreateMPZhuang:zhuang2Handler_(item)
    self:updateZhuangList_(2)
    self.zhuangType_ = 2
    mpnnData:setZuoZhuang(2)
end

function CreateMPZhuang:zhuang3Handler_(item)
    self:updateZhuangList_(3)
    self.zhuangType_ = 3
    mpnnData:setZuoZhuang(3)
end

function CreateMPZhuang:zhuang4Handler_(item)
    self:updateZhuangList_(4)
    self.zhuangType_ = 4
    mpnnData:setZuoZhuang(4)
end

function CreateMPZhuang:xiaZhu1Handler_(item)
    self:updateXiaZhuList_(1)
    self.xiaZhu_ = 1
    mpnnData:setXiaZhu(1)
end

function CreateMPZhuang:xiaZhu2Handler_(item)
    self:updateXiaZhuList_(2)
    self.xiaZhu_ = 2
    mpnnData:setXiaZhu(2)
end

function CreateMPZhuang:xiaZhu3Handler_(item)
    self:updateXiaZhuList_(3)
    self.xiaZhu_ = 3
    mpnnData:setXiaZhu(3)
end

function CreateMPZhuang:xiaZhu4Handler_(item)
    self:updateXiaZhuList_(4)
    self.xiaZhu_ = 4
    mpnnData:setXiaZhu(4)
end

function CreateMPZhuang:xiaZhu5Handler_(item)
    self:updateXiaZhuList_(5)
    self.xiaZhu_ = 5
    mpnnData:setXiaZhu(5)
end

function CreateMPZhuang:beiShu1Handler_(item)
    self:updateBeiShuList_(1)
    self.beiType_ = 1
    mpnnData:setBeiShu(1)
end

function CreateMPZhuang:beiShu2Handler_(item)
    self:updateBeiShuList_(2)
    self.beiType_ = 2
    mpnnData:setBeiShu(2)
end

function CreateMPZhuang:beiShu3Handler_(item)
    self:updateBeiShuList_(3)
    self.beiType_ = 3
    mpnnData:setBeiShu(3)
end

function CreateMPZhuang:beiShu4Handler_(item)
    self:updateBeiShuList_(4)
    self.beiType_ = 4
    mpnnData:setBeiShu(4)
end

function CreateMPZhuang:tuiZhu1Handler_(item)
    self:updateTuiZhuList_(1)
    self.tuiZhu_ = 0
    mpnnData:setTuiZhu(1)
end

function CreateMPZhuang:tuiZhu2Handler_(item)
    self:updateTuiZhuList_(2)
    self.tuiZhu_ = 1
    mpnnData:setTuiZhu(2)
end

function CreateMPZhuang:teShuHandler_(item)
    if item:isSelected() then
        mpnnData:setTeShu(1)
        self.specType_ = {-1}
    else
        mpnnData:setTeShu(0)
        self.specType_ = {0}
    end
end

function CreateMPZhuang:jokerHandler_(item)
    if item:isSelected() then
        mpnnData:setJoker(1)
    else
        mpnnData:setJoker(0)
    end
end

function CreateMPZhuang:teShuGzHandler_(item)
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

function CreateMPZhuang:fanbeiGzHandler_(item)
    self.beiSelected_ = not self.beiSelected_
    self.beiShuSelected_:setVisible(self.beiSelected_)
end

function CreateMPZhuang:calcCreateRoomParams(daiKai)
    self.teShuNiuSelected_:setDefaults()
    local ipLimit = 0
    local guiZe = {}
    guiZe.playerCount = self.renShu_
    guiZe.zhuangType = 4
    guiZe.score = self.xiaZhu_
    guiZe.tuiZhu = self.tuiZhu_
    guiZe.maxQiang = self.beiType_
    guiZe.specType = self.teShuNiuSelected_:getNiuQun()
    guiZe.fanBeiType = self.beiShuSelected_:getFanBeiType()
    guiZe.joker =  0
    guiZe.prohibitFanCard = self.cuoPai_:isSelected() and 1 or 0
    guiZe.prohibitEnter = self.zhongTuJia_:isSelected() and 1 or 0
    mpnnData:setJZCP(guiZe.prohibitFanCard)
    mpnnData:setJZJR(guiZe.prohibitEnter)
    guiZe.detailType = self.TXType_
    dump(guiZe,"guiZeguiZeguiZe")
    local params = {
        gameType = GAME_BCNIUNIU, -- 游戏服务类型
        totalRound = self.juShu_, -- 游戏局数
        consumeType = self.zhiFuType_,
        isAgent = 0,  -- 代开 0为否 1为是
        ipLimit = 0,  -- 是否禁止相同IP入坐，1为禁止，0为不禁止
        ruleType = 4,  -- 游戏小规则类型 默认为1, 可由不同游戏自己定义
        ruleDetails = guiZe -- 任意定义的规则选项, 参考下面的各游戏详细规则说明 -- 规则详情
    }
    return params
end

return CreateMPZhuang 

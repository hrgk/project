local BaseCreateView = import(".BaseCreateView")
local CreateNNView = class("CreateNNView", BaseCreateView)

function CreateNNView:ctor(showZFType)
    CreateNNView.super.ctor(self)
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
    self.zhuangList_[1] = self.zhuang1_
    self.zhuangList_[2] = self.zhuang2_
    self.zhuangList_[3] = self.zhuang3_
    self.zhuangList_[4] = self.zhuang4_

    self.beiShuList_ = {}
    self.beiShuList_[1] = self.beiShu1_
    self.beiShuList_[2] = self.beiShu2_
    self.beiShuList_[3] = self.beiShu3_
    self.beiShuList_[4] = self.beiShu4_

    self.tuiZhuList_ = {}
    self.tuiZhuList_[1] = self.tuiZhu1_
    self.tuiZhuList_[2] = self.tuiZhu2_

    self.zhiFuList_ = {}
    self.zhiFuList_[1] = self.zhifu1_
    self.zhiFuList_[2] = self.zhifu2_
    self.zhiFuList_[3] = self.zhifu3_

    self:initZhiFuType_()
    self:initJuShu_()
    self:initRenShu_()
    self:initXiaZhu_()
    self:initZhuangType_()
    self:initTeShu_()
    self:initBeiShu_()
    self:initTuiZhu_()
    createRoomData:setGameIndex(GAME_BCNIUNIU)
    self:setShowZFType(showZFType)
end

function CreateNNView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/createRoom/createNN.csb"):addTo(self)
end

function CreateNNView:initZhiFuType_()
    local index = tonumber(xtnnData:getZhiFu())
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

function CreateNNView:updateZhiFuList_(index)
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

function CreateNNView:zhifu1Handler_()
    self:updateZhiFuList_(1)
    self.zhiFuType_ = 0
    xtnnData:setZhiFu(1)
end

function CreateNNView:zhifu2Handler_()
    self:updateZhiFuList_(2)
    xtnnData:setZhiFu(2)
    self.zhiFuType_ = 1
end

function CreateNNView:zhifu3Handler_()
    self:updateZhiFuList_(3)
    xtnnData:setZhiFu(3)
    self.zhiFuType_ = 2
end

function CreateNNView:initTuiZhu_()
    local index = tonumber(xtnnData:getTuiZhu())
    self:updateTuiZhuList_(index)
    if index == 1 then
        self.tuiZhu_ = 0
    else
        self.tuiZhu_ = 1
    end
end

function CreateNNView:initTeShu_()
    local teShuGuiZe = tonumber(xtnnData:getTeShu())
    if teShuGuiZe == 1 then
        self.teShu_:setSelected(true)
        self.specType_ = {-1}
    else
        self.teShu_:setSelected(false)
        self.specType_ = {0}
    end
end

function CreateNNView:initJuShu_()
    local index = tonumber(xtnnData:getJuShu())
    self:updateJuShuList_(index)
    if index == 1 then
        self.juShu_ = 10
    elseif index == 2 then
        self.juShu_ = 20
    elseif index == 3 then
        self.juShu_ = 30
    end
end

function CreateNNView:initRenShu_()
    local index = tonumber(xtnnData:getRenShu())
    self:updateRenList_(index)
    if index == 1 then
        self.renShu_ = 6
    elseif index == 2 then
        self.renShu_ = 8
    elseif index == 3 then
        self.renShu_ = 10
    end
end

function CreateNNView:initBeiShu_()
    local index = tonumber(xtnnData:getBeiShu())
    self:updateBeiShuList_(index)
    self.beiType_ = index
end

function CreateNNView:initXiaZhu_()
    local index = tonumber(xtnnData:getXiaZhu())
    self:updateXiaZhuList_(index)
    self.xiaZhu_ = index
end

function CreateNNView:initZhuangType_()
    local index = tonumber(xtnnData:getZuoZhuang())
    self:updateZhuangList_(index)
    self.zhuangType_ = index
end

function CreateNNView:updateXiaZhuList_(index)
    for i,v in ipairs(self.xiazhuList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setEnabled(false)
        end
    end
end

function CreateNNView:updateBeiShuList_(index)
    for i,v in ipairs(self.beiShuList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setEnabled(false)
        end
    end
end

function CreateNNView:updateRenList_(index)
    for i,v in ipairs(self.renList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setEnabled(false)
        end
    end
end

function CreateNNView:updateJuShuList_(index)
    for i,v in ipairs(self.juShuList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setEnabled(false)
        end
    end
end

function CreateNNView:updateZhuangList_(index)
    for i,v in ipairs(self.zhuangList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setEnabled(false)
        end
    end
end

function CreateNNView:updateTuiZhuList_(index)
    for i,v in ipairs(self.tuiZhuList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setEnabled(false)
        end
    end
end

function CreateNNView:juShu1Handler_()
    self:updateJuShuList_(1)
    self.juShu_ = 10
    xtnnData:setJuShu(1)
end

function CreateNNView:juShu2Handler_()
    self:updateJuShuList_(2)
    self.juShu_ = 20
    xtnnData:setJuShu(2)
end

function CreateNNView:juShu3Handler_()
    self:updateJuShuList_(3)
    self.juShu_ = 30
    xtnnData:setJuShu(3)
end

function CreateNNView:renShu1Handler_()
    self:updateRenList_(1)
    self.renShu_ = 6
    xtnnData:setRenShu(1)
end

function CreateNNView:renShu2Handler_()
    self:updateRenList_(2)
    self.renShu_ = 8
    xtnnData:setRenShu(2)
end

function CreateNNView:renShu3Handler_()
    self:updateRenList_(3)
    self.renShu_ = 10
    xtnnData:setRenShu(3)
end

function CreateNNView:zhuang1Handler_(item)
    self:updateZhuangList_(1)
    self.zhuangType_ = 1
    xtnnData:setZuoZhuang(1)
end

function CreateNNView:zhuang2Handler_(item)
    self:updateZhuangList_(2)
    self.zhuangType_ = 2
    xtnnData:setZuoZhuang(2)
end

function CreateNNView:zhuang3Handler_(item)
    self:updateZhuangList_(3)
    self.zhuangType_ = 3
    xtnnData:setZuoZhuang(3)
end

function CreateNNView:zhuang4Handler_(item)
    self:updateZhuangList_(4)
    self.zhuangType_ = 4
    xtnnData:setZuoZhuang(4)
end

function CreateNNView:xiaZhu1Handler_(item)
    self:updateXiaZhuList_(1)
    self.xiaZhu_ = 1
    xtnnData:setXiaZhu(1)
end

function CreateNNView:xiaZhu2Handler_(item)
    self:updateXiaZhuList_(2)
    self.xiaZhu_ = 2
    xtnnData:setXiaZhu(2)
end

function CreateNNView:xiaZhu3Handler_(item)
    self:updateXiaZhuList_(3)
    self.xiaZhu_ = 3
    xtnnData:setXiaZhu(3)
end

function CreateNNView:xiaZhu4Handler_(item)
    self:updateXiaZhuList_(4)
    self.xiaZhu_ = 4
    xtnnData:setXiaZhu(4)
end

function CreateNNView:xiaZhu5Handler_(item)
    self:updateXiaZhuList_(5)
    self.xiaZhu_ = 5
    xtnnData:setXiaZhu(5)
end

function CreateNNView:beiShu1Handler_(item)
    self:updateBeiShuList_(1)
    self.beiType_ = 1
    xtnnData:setBeiShu(1)
end

function CreateNNView:beiShu2Handler_(item)
    self:updateBeiShuList_(2)
    self.beiType_ = 2
    xtnnData:setBeiShu(2)
end

function CreateNNView:beiShu3Handler_(item)
    self:updateBeiShuList_(3)
    self.beiType_ = 3
    xtnnData:setBeiShu(3)
end

function CreateNNView:beiShu4Handler_(item)
    self:updateBeiShuList_(4)
    self.beiType_ = 4
    xtnnData:setBeiShu(4)
end

function CreateNNView:tuiZhu1Handler_(item)
    self:updateTuiZhuList_(1)
    self.tuiZhu_ = 0
    xtnnData:setTuiZhu(1)
end

function CreateNNView:tuiZhu2Handler_(item)
    self:updateTuiZhuList_(2)
    self.tuiZhu_ = 1
    xtnnData:setTuiZhu(2)
end

function CreateNNView:teShuHandler_(item)
    if item:isSelected() then
        xtnnData:setTeShu(1)
        self.specType_ = {-1}
    else
        xtnnData:setTeShu(0)
        self.specType_ = {0}
    end
end

function CreateNNView:calcCreateRoomParams(daiKai)
    local ipLimit = 0
    local guiZe = {}
    guiZe.playerCount = self.renShu_
    guiZe.zhuangType = self.zhuangType_
    guiZe.score = self.xiaZhu_
    guiZe.tuiZhu = self.tuiZhu_
    guiZe.maxQiang = self.beiType_
    guiZe.specType = self.specType_
    guiZe.detailType = 1
    local params = {
        gameType = GAME_BCNIUNIU, -- 游戏服务类型
        totalRound = self.juShu_, -- 游戏局数
        consumeType = self.zhiFuType_,
        isAgent = 0,  -- 代开 0为否 1为是
        ipLimit = 0,  -- 是否禁止相同IP入坐，1为禁止，0为不禁止
        ruleType = 1,  -- 游戏小规则类型 默认为1, 可由不同游戏自己定义
        ruleDetails = guiZe -- 任意定义的规则选项, 参考下面的各游戏详细规则说明 -- 规则详情
    }
    return params
end

return CreateNNView 

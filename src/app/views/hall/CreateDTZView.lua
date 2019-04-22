local BaseCreateView = import(".BaseCreateView")
local CreateDTZView = class("CreateDTZView", BaseCreateView)

function CreateDTZView:ctor(showZFType)
    CreateDTZView.super.ctor(self)
    self.renShuConf = {2,3}
    self.juShuList_ = {}
    self.juShuList_[1] = self.jushu1_
    self.juShuList_[2] = self.jushu2_

    self.renshuList_ = {}
    self.renshuList_[1] = self.renshu1_
    self.renshuList_[2] = self.renshu2_

    self.paiZhangList_ = {}
    self.paiZhangList_[1] = self.paiZhang1_
    self.paiZhangList_[2] = self.paiZhang2_

    self.jiangLiList_ = {}
    self.jiangLiList_[1] = self.jiangLi1_
    self.jiangLiList_[2] = self.jiangLi2_
    self.jiangLiList_[3] = self.jiangLi3_
    self.jiangLiList_[4] = self.jiangLi4_
    self.jiangLiList_[5] = self.jiangLi5_

    self.zhiFuList_ = {}
    self.zhiFuList_[1] = self.zhifu1_
    self.zhiFuList_[2] = self.zhifu2_
    self.zhiFuList_[3] = self.zhifu3_

    self:initZhiFuType_()

    self:initJuShu_()
    self:initRenShu_()
    -- self:initHouZi_()
    self:initPaiZhang_()
    self:initJiangLi()
    self:initShowRemainCard()
    self:initTail3WithCard()
    self:initRandomFirst()
    self:initMustDenny()

    -- self.price1_:hide()
    -- self.price2_:hide()

    -- self.zuanshi1_:hide()
    -- self.zuanshi2_:hide()
    self:setShowZFType(showZFType)
end


function CreateDTZView:setData(data)
    self:updateZhiFuList_(data.consumeType+1)
    self:updatePaiZhangList_(data.cardCount - 2)
    self:updateJuShuList_(data.totalScore == 600 and 1 or 2)
    for key,value in pairs(self.renShuConf) do
        if value == data.maxPlayer then
            self:updateRenShuList_(key)
            break
        end
    end
    if data.overBonus == 500 then
        self:updateJiangLiList_(data.overBonus/100)
    else
        self:updateJiangLiList_(data.overBonus/100+1)
    end
    
    self.showRemainCard_:setSelected(data.showCard  == 1)
    self.mustDenny_:setSelected(data.mustDenny== 1)
    self.randomFirst_:setSelected(data.randomDealer == 1)
    self.tail3WithCard_:setSelected(data.tail3WithCard == 2)
    self.tail3WithCardType_ = data.tail3WithCard
    self.totalScore_ = data.totalScore
    self.playerCount_ = data.maxPlayer
    self.paiCount_ = data.cardCount
    local overBonusMap = {0, 100, 200, 300, 500}
    self.jiangLiIndex_ = table.indexof(overBonusMap, data.overBonus)
    self.isRandomFirst_ = data.randomDealer
    self.isShowRemainCard_ = data.showCard
    self.isMustDenny_ = data.mustDenny
    if self.totalScore_ == 600 then
        self.juShuCount_ = 8
    elseif self.totalScore_ == 1000 then
        self.juShuCount_ = 16
    end
    self.zhiFuType_ = data.consumeType
end

function CreateDTZView:initZhiFuType_()
    local index = tonumber(dtzData:getZhiFu())
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

function CreateDTZView:updateZhiFuList_(index)
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

function CreateDTZView:zhifu1Handler_()
    self:updateZhiFuList_(1)
    self.zhiFuType_ = 0
    dtzData:setZhiFu(1)
end

function CreateDTZView:zhifu2Handler_()
    self:updateZhiFuList_(2)
    dtzData:setZhiFu(2)
    self.zhiFuType_ = 1
end

function CreateDTZView:zhifu3Handler_()
    self:updateZhiFuList_(3)
    dtzData:setZhiFu(3)
    self.zhiFuType_ = 2
end

function CreateDTZView:initRandomFirst()
    local index = tonumber(dtzData:getRandomFirst())
    if index == 1 then
        self.randomFirst_:setSelected(true)
    else
        self.randomFirst_:setSelected(false)
    end
    self.isRandomFirst_ = index
end

function CreateDTZView:initTail3WithCard()
    local index = tonumber(dtzData:getTail3WithCard())
    if index == 2 then
        self.tail3WithCard_:setSelected(true)
        self.tail3WithCardType_ = 2
    else
        self.tail3WithCard_:setSelected(false)
        self.tail3WithCardType_ = 0
    end
end

function CreateDTZView:initShowRemainCard()
    local index = tonumber(dtzData:getShowRemainCard())
    if index == 1 then
        self.showRemainCard_:setSelected(true)
    else
        self.showRemainCard_:setSelected(false)
    end
    self.isShowRemainCard_ = index
end

function CreateDTZView:initMustDenny()
    local index = tonumber(dtzData:getMustDenny())
    if index == 1 then
        self.mustDenny_:setSelected(true)
    else
        self.mustDenny_:setSelected(false)
    end
    self.isMustDenny_ = index
end

function CreateDTZView:initHouZi_()
    local index = tonumber(dtzData:getHouZi())
    if index == 1 then
        self.houzi_:setSelected(true)
    else
        self.houzi_:setSelected(false)
    end
    self.isHouZi_ = index
end

function CreateDTZView:initJiangLi()
    local index = tonumber(dtzData:getJiangLi())
    self:updateJiangLiList_(index)
    if self.jiangLiList_[index] then
        self.jiangLiList_[index]:setSelected(true)
    else
        self.jiangLiList_[1]:setSelected(true)
    end
    self.jiangLiIndex_ = index
end

function CreateDTZView:initRenShu_()
    local index = tonumber(dtzData:getRenShu())
    self:updateRenShuList_(index)
    if self.renshuList_[index] then
        self.renshuList_[index]:setSelected(true)
    else
        self.renshuList_[1]:setSelected(true)
    end
    if index == 1 then
        self.playerCount_ = 2
    else
        self.playerCount_ = 3
    end
end

function CreateDTZView:initJuShu_()
    local index = tonumber(dtzData:getJuShu())
    self:updateJuShuList_(index)
    if self.juShuList_[index] then
        self.juShuList_[index]:setSelected(true)
    else
        self.juShuList_[1]:setSelected(true)
    end
    if index == 1 then
        self.juShuCount_ = 8
        self.totalScore_ = 600
    elseif index == 2 then
        self.juShuCount_ = 16
        self.totalScore_ = 1000
    end
end

function CreateDTZView:initPaiZhang_()
    local index = tonumber(dtzData:getPaiZhang())
    self:updatePaiZhangList_(index)
    if self.paiZhangList_[index] then
        self.paiZhangList_[index]:setSelected(true)
    else
        self.paiZhangList_[1]:setSelected(true)
    end

    if index == 1 then
        self.paiCount_ = 3
    else
        self.paiCount_ = 4
    end
end

function CreateDTZView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/createRoom/createDTZ.csb"):addTo(self)
end

function CreateDTZView:updateJuShuList_(index)
    for i, v in ipairs(self.juShuList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
end

function CreateDTZView:updateJiangLiList_(index)
    for i, v in ipairs(self.jiangLiList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
end

function CreateDTZView:updateRenShuList_(index)
    for i, v in ipairs(self.renshuList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
end

function CreateDTZView:updatePaiZhangList_(index)
    for i, v in ipairs(self.paiZhangList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
end

function CreateDTZView:randomFirstHandler_(item)
    if item:isSelected() then
        dtzData:setRandomFirst(1)
        self.isRandomFirst_ = 1
    else
        dtzData:setRandomFirst(0)
        self.isRandomFirst_ = 0
    end
end

function CreateDTZView:jushu1Handler_()
    self:updateJuShuList_(1)
    self.juShuCount_ = 8
    self.totalScore_ = 600
    dtzData:setJuShu(1)
end

function CreateDTZView:jushu2Handler_()
    self:updateJuShuList_(2)
    self.juShuCount_ = 16
    self.totalScore_ = 1000
    dtzData:setJuShu(2)
end

function CreateDTZView:renshu1Handler_()
    self:updateRenShuList_(1)
    self.playerCount_ = 2
    dtzData:setRenShu(1)
end

function CreateDTZView:renshu2Handler_()
    self:updateRenShuList_(2)
    self.playerCount_ = 3
    dtzData:setRenShu(2)
end

function CreateDTZView:paiZhang1Handler_()
    self:updatePaiZhangList_(1)
    self.paiCount_ = 3
    dtzData:setPaiZhang(1)
end

function CreateDTZView:paiZhang2Handler_()
    self:updatePaiZhangList_(2)
    self.paiCount_ = 4
    dtzData:setPaiZhang(2)
end

function CreateDTZView:jiangLi1Handler_()
    self:updateJiangLiList_(1)
    self.jiangLiIndex_ = 1
    dtzData:setJiangLi(1)
end

function CreateDTZView:jiangLi2Handler_()
    self:updateJiangLiList_(2)
    self.jiangLiIndex_ = 2
    dtzData:setJiangLi(2)
end

function CreateDTZView:jiangLi3Handler_()
    self:updateJiangLiList_(3)
    self.jiangLiIndex_ = 3
    dtzData:setJiangLi(3)
end

function CreateDTZView:jiangLi4Handler_()
    self:updateJiangLiList_(4)
    self.jiangLiIndex_ = 4
    dtzData:setJiangLi(4)
end

function CreateDTZView:jiangLi5Handler_()
    self:updateJiangLiList_(5)
    self.jiangLiIndex_ = 5
    dtzData:setJiangLi(5)
end

function CreateDTZView:showRemainCardHandler_(item)
    if item:isSelected() then
        dtzData:setShowRemainCard(1)
        self.isShowRemainCard_ = 1
    else
        dtzData:setShowRemainCard(0)
        self.isShowRemainCard_ = 0
    end
end

function CreateDTZView:tail3WithCardHandler_(item)
    if item:isSelected() then
        dtzData:setTail3WithCard(2)
        self.tail3WithCardType_ = 2
    else
        dtzData:setTail3WithCard(0)
        self.tail3WithCardType_ = 0
    end
end

function CreateDTZView:mustDennyHandler_(item)
    -- item:setSelected(true)
    if item:isSelected() then
        dtzData:setMustDenny(1)
        self.isMustDenny_ = 1
    else
        dtzData:setMustDenny(0)
        self.isMustDenny_ = 0
    end
end

-- function CreateDTZView:calcCreateRoomParams(daiKai)
--     local guiZe = {}
--     guiZe.limitScore = 20
--     guiZe.baseTun = 1
--     guiZe.santi5kan = 1
--     guiZe.shuaHou = 1
--     guiZe.huangFan = 1
--     guiZe.hangHangXi = 1
--     guiZe.siQiHong = 1
--     guiZe.daTuanYuan = 1
--     guiZe.tingHu = 1

--     local overBonusMap = {0, 100, 200, 300, 500}
--     guiZe.overBonus = overBonusMap[self.jiangLiIndex_]

--     guiZe.randomDealer = self.isRandomFirst_
--     guiZe.showCard = self.isShowRemainCard_

--     guiZe.mustDenny = self.isMustDenny_
    
--     local params = {
--         gameType = GAME_CDPHZ, -- 游戏服务类型
--         totalRound = self.juShuCount_ , -- 游戏局数
--         isAgent = 0, -- 代开 0为否 1为是
--         ipLimit = 0, -- 是否禁止相同IP入坐，1为禁止，0为不禁止
--         ruleType = 1, -- 游戏小规则类型 默认为1, 可由不同游戏自己定义
--         ruleDetails = guiZe -- 任意定义的规则选项, 参考下面的各游戏详细规则说明 -- 规则详情
--     }
--     createRoomData:setGameIndex(GAME_CDPHZ)
--     return params
-- end

function CreateDTZView:calcCreateRoomParams(daiKai)
    local guiZe = {}
    guiZe.cardCount = self.paiCount_
    guiZe.totalScore = self.totalScore_
    guiZe.totalSeat = self.playerCount_
    local overBonusMap = {0, 100, 200, 300, 500}
    guiZe.overBonus = overBonusMap[self.jiangLiIndex_]
    
    guiZe.randomDealer = self.isRandomFirst_
    guiZe.showCard = self.isShowRemainCard_

    guiZe.mustDenny = self.isMustDenny_
    guiZe.tail3WithCard = self.tail3WithCardType_

    local params = {
        gameType = GAME_DA_TONG_ZI, -- 游戏服务类型
        totalRound = self.juShuCount_ , -- 游戏局数
        consumeType = self.zhiFuType_,
        isAgent = 0, -- 代开 0为否 1为是
        ipLimit = 0, -- 是否禁止相同IP入坐，1为禁止，0为不禁止
        ruleType = 1, -- 游戏小规则类型 默认为1, 可由不同游戏自己定义
        ruleDetails = guiZe -- 任意定义的规则选项, 参考下面的各游戏详细规则说明 -- 规则详情
    }
    createRoomData:setGameIndex(GAME_DA_TONG_ZI)
    return params
end

return CreateDTZView 

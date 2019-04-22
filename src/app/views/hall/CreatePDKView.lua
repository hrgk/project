local BaseCreateView = import(".BaseCreateView")
local CreatePDKView = class("CreatePDKView", BaseCreateView)

function CreatePDKView:ctor(showZFType)
    CreatePDKView.super.ctor(self)
    self.jushuConf = {10,20,30}
    self.renShuConf = {2,3}
    self.juShuList_ = {}
    self.juShuList_[1] = self.jushu1_
    self.juShuList_[2] = self.jushu2_
    self.juShuList_[3] = self.jushu3_

    self.renshuList_ = {}
    self.renshuList_[1] = self.renshu1_
    self.renshuList_[2] = self.renshu2_

    self.paiZhangList_ = {}
    self.paiZhangList_[1] = self.paiZhang1_
    self.paiZhangList_[2] = self.paiZhang2_

    self.diFenList_ = {}
    self.diFenList_[1] = self.diFen1_
    self.diFenList_[2] = self.diFen2_
    self.diFenList_[3] = self.diFen3_

    self.zhiFuList_ = {}
    self.zhiFuList_[1] = self.zhifu1_
    self.zhiFuList_[2] = self.zhifu2_
    self.zhiFuList_[3] = self.zhifu3_


    self.chuType_ = {}
    self.chuType_[1] = self.chuType1_
    self.chuType_[2] = self.chuType2_

    self.baoDan_ = {}
    self.baoDan_[1] = self.baoDan1_
    self.baoDan_[2] = self.baoDan2_

    self.sdList_ = {}
    self.sdList_[1] = self.sd1_
    self.sdList_[2] = self.sd2_
    self.sdList_[3] = self.sd3_

    self.fzbList_ = {}
    self.fzbList_[1] = self.fzb1_
    self.fzbList_[2] = self.fzb2_
    self.fzbList_[3] = self.fzb3_

    self.zhanDanTipInfo = {"3个K为炸弹","3个A为炸弹"}
    self:initZhiFuType_()
    self:initJuShu_()
    self:initRenShu_()
    self:initHouZi_()
    self:initPaiZhang_()
    self:initDiFen_()
    self:initCardNum_()
    self:initSiDai_()
    self:initSanDaiYi_()
    self:initFangQiangGuan_()
    self:initChuType_()
    self:initBaoDan_()
    self:initA3boom_()
    self:initFZB_()
    self:initZDBKC_()
    self:initSW3_()
    createRoomData:setGameIndex(GAME_PAODEKUAI)

    if CHANNEL_CONFIGS.DIAMOND == false then
        self.zuanshi1_:setVisible(false)
        self.zuanshi2_:setVisible(false)
        self.zuanshi3_:setVisible(false)
        self.price1_:setVisible(false)
        self.price2_:setVisible(false)
        self.price3_:setVisible(false)
    end
    self:setShowZFType(showZFType)
    self.csbNode_:setScale(1,0.94)
    self:setScale(0.85)
    self.price1_:setString("12")
    self.price2_:setString("24")
end

function CreatePDKView:setData(data)
    dump(data,"CreatePDKView:setData")
    self.csbNode_:setPositionY(self.csbNodePosY+40)
    self:updateZhiFuList_(data.config.consumeType+1)
    for key,value in pairs(self.jushuConf) do
        if value == data.config.juShu then
            self:updateJuShuList_(key)
            break
        end
    end
    self.playerCount_ = data.config.rules.playerCount
    for key,value in pairs(self.renShuConf) do
        if value ==  self.playerCount_ then
            self:updateRenShuList_(key)
            break
        end
    end
    self:updateBaoDanList_(data.config.rules.bao_dan_type+1)
    self:updateChuTypeList_(data.config.rules.xian_chu_type+1)
    self:updatePaiZhangList_(data.config.rules.cardCount-14)
    local score = {1,5,10}
    self:updateDiFenList_(table.indexof(score, data.config.rules.score))
    
    --self.siDaiSan_:setSelected(data.config.rules.siDaiSan == 1)
    self.cardNum_:setSelected(data.config.rules.xianPai == 1)
    self.fangQiangGuan_:setSelected(data.config.rules.fangQiangGuan == 1)

    self.zdbkc_:setSelected(data.config.rules.denySplitBomb == 1)
    self.a3boom_:setSelected(data.config.rules.threeABomb == 1)
    self.houzi_:setSelected(data.config.rules.red10 == 1)
    self.weiPai_:setSelected(data.config.rules.tail3With1 == 1)
    self.sw3_:setSelected(data.config.rules.same_card_count == 0)
    --self.fzb_:setSelected(data.config.rules.fang_zuo_bi == 1)

    self.paiCount_ = data.config.rules.cardCount
    self.cardNum = data.config.rules.xianPai
    self.diFen_ = data.config.rules.score
    self.isHouZi_ = data.config.rules.red10
    if data.config.rules.siDaiSan == 1 then
        self.sd_ = 2
    else
        self.sd_ = 3
        if not data.config.rules.siDaiEr or (data.config.rules.siDaiSan == 0 and data.config.rules.siDaiEr == 0) then
            self.sd_ = 1
        end
    end

    if not data.config.rules.simple_fang_zuo_bi then
        if data.config.rules.fang_zuo_bi == 1 then
            self.fzb_ = 3
        else
            self.fzb_ = 1
        end
    else
        if data.config.rules.fang_zuo_bi == 1 and data.config.rules.simple_fang_zuo_bi == 0 then
            self.fzb_ = 3
        elseif data.config.rules.fang_zuo_bi == 1 and data.config.rules.simple_fang_zuo_bi == 1 then
            self.fzb_ = 2
        elseif data.config.rules.fang_zuo_bi == 0 and data.config.rules.simple_fang_zuo_bi == 0 then
            self.fzb_ = 1
        end
    end

    self:updatefzbList_(self.fzb_)
    self:updatesdList_(self.sd_)

    self.zdbkc = data.config.rules.denySplitBomb
    self.isSanDaiYi_ = data.config.rules.tail3With1
    self.isFangQiangGuan_ = data.config.rules.fangQiangGuan
    self.a3boom = data.config.rules.threeABomb
    self.cType = data.config.rules.xian_chu_type
    self.baoDan = data.config.rules.bao_dan_type
    self.sw3 = data.config.rules.same_card_count
    self.fzb = data.config.rules.fang_zuo_bi
    self.juShuCount_ = data.config.juShu
    self.zhiFuType_ = data.config.consumeType
end

function CreatePDKView:chuType1Handler_()
    self:updateChuTypeList_(1)
    self.cType = 0
    xtpkdData:setChuType(1)
end

function CreatePDKView:chuType2Handler_()
    self:updateChuTypeList_(2)
    self.cType = 1
    xtpkdData:setChuType(2)
end

function CreatePDKView:updateChuTypeList_(index)
    for i, v in ipairs(self.chuType_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
end

function CreatePDKView:initChuType_()
    dump(xtpkdData:getChuType(),"CreatePDKView:initChuType_")
    local index = tonumber(xtpkdData:getChuType())
    self:updateChuTypeList_(index)
    if self.chuType_[index] then
        self.chuType_[index]:setSelected(true)
    else
        self.chuType_[1]:setSelected(true)
    end
    if index == 1 then
        self.cType = 0
    elseif index == 2 then
        self.cType = 1
    end
end

function CreatePDKView:baoDan1Handler_()
    self:updateBaoDanList_(1)
    self.baoDan = 0
    xtpkdData:setBaoDan(1)
end

function CreatePDKView:baoDan2Handler_()
    self:updateBaoDanList_(2)
    self.baoDan = 1
    xtpkdData:setBaoDan(2)
end

function CreatePDKView:updateBaoDanList_(index)
    for i, v in ipairs(self.baoDan_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
end

function CreatePDKView:initBaoDan_()
    local index = tonumber(xtpkdData:getBaoDan())
    self:updateBaoDanList_(index)
    if self.baoDan_[index] then
        self.baoDan_[index]:setSelected(true)
    else
        self.baoDan_[1]:setSelected(true)
    end
    if index == 1 then
        self.baoDan = 0
    elseif index == 2 then
        self.baoDan = 1
    end
end

function CreatePDKView:initZDBKC_()
    local index = tonumber(xtpkdData:getZDBKC())
    if index == 1 then
        self.zdbkc_:setSelected(true)
    else
        self.zdbkc_:setSelected(false)
    end
    self.zdbkc = index
end

function CreatePDKView:initSW3_()
    local index = tonumber(xtpkdData:getSW3())
    if index == 1 then
        self.sw3_:setSelected(true)
    else
        self.sw3_:setSelected(false)
    end
    self.sw3 = index == 1 and 0 or 1
end

function CreatePDKView:initA3boom_()
    local index = tonumber(xtpkdData:getA3boom())
    if index == 1 then
        self.a3boom_:setSelected(true)
    else
        self.a3boom_:setSelected(false)
    end
    self.a3boom = index
end

function CreatePDKView:a3boomHandler_(item)
    if item:isSelected() then
        xtpkdData:setA3boom(1)
        self.a3boom = 1
    else
        xtpkdData:setA3boom(0)
        self.a3boom = 0
    end
end

function CreatePDKView:fzb1Handler_()
    self:updatefzbList_(1)
    self.fzb_ = 1
    xtpkdData:setFZBINDEX(1)
end

function CreatePDKView:fzb2Handler_()
    self:updatefzbList_(2)
    self.fzb_ = 2
    xtpkdData:setFZBINDEX(2)
end

function CreatePDKView:fzb3Handler_()
    self:updatefzbList_(3)
    self.fzb_ = 3
    xtpkdData:setFZBINDEX(3)
end

function CreatePDKView:updatefzbList_(index)
    for i, v in ipairs(self.fzbList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
end

function CreatePDKView:initFZB_()
    local index = tonumber(xtpkdData:getFZBINDEX())
    self:updatefzbList_(index)
    if self.fzbList_[index] then
        self.fzbList_[index]:setSelected(true)
    else
        self.fzbList_[1]:setSelected(true)
    end
    self.fzb_ = index
end

function CreatePDKView:initSiDai_()
    local index = tonumber(xtpkdData:getSiDai())
    self:updatesdList_(index)
    if self.sdList_[index] then
        self.sdList_[index]:setSelected(true)
    else
        self.sdList_[1]:setSelected(true)
    end
    self.sd_ = index
end

function CreatePDKView:initSanDaiYi_()
    local index = tonumber(xtpkdData:getSanDaiYi())
    if index == 1 then
        self.weiPai_:setSelected(true)
    else
        self.weiPai_:setSelected(false)
    end
    self.isSanDaiYi_ = index
end

function CreatePDKView:initFangQiangGuan_()
    local index = tonumber(xtpkdData:getQiangGuan())
    if index == 1 then
        self.fangQiangGuan_:setSelected(true)
    else
        self.fangQiangGuan_:setSelected(false)
    end
    self.isFangQiangGuan_ = index
end

function CreatePDKView:initCardNum_()
    local index = tonumber(xtpkdData:getCardNum())
    if index == 1 then
        self.cardNum_:setSelected(true)
    else
        self.cardNum_:setSelected(false)
    end
    self.cardNum = index
end

function CreatePDKView:initHouZi_()
    local index = tonumber(xtpkdData:getHouZi())
    if index == 1 then
        self.houzi_:setSelected(true)
    else
        self.houzi_:setSelected(false)
    end
    self.isHouZi_ = index
end

function CreatePDKView:initDiFen_()
    local index = tonumber(xtpkdData:getDiFen())
    self:updateDiFenList_(index)
    if self.diFenList_[index] then
        self.diFenList_[index]:setSelected(true)
    else
        self.diFenList_[1]:setSelected(true)
    end
    if index == 1 then
        self.diFen_ = 1
    elseif index == 2 then
        self.diFen_ = 5
    elseif index == 3 then
        self.diFen_ = 10
    end
end

function CreatePDKView:initRenShu_()
    local index = tonumber(xtpkdData:getRenShu())
    if index == 1 then
        self.playerCount_ = 2
    else
        self.playerCount_ = 3
    end
    self:updateRenShuList_(index)
    if self.renshuList_[index] then
        self.renshuList_[index]:setSelected(true)
    else
        self.renshuList_[1]:setSelected(true)
    end
end

function CreatePDKView:initZhiFuType_()
    local index = tonumber(xtpkdData:getZhiFu())
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

function CreatePDKView:initJuShu_()
    local index = tonumber(xtpkdData:getJuShu())
    if index == 3 then
        index = 1
    end
    self:updateJuShuList_(index)
    if self.juShuList_[index] then
        self.juShuList_[index]:setSelected(true)
    else
        self.juShuList_[1]:setSelected(true)
    end
    if index == 1 then
        self.juShuCount_ = 10
    elseif index == 2 then
        self.juShuCount_ = 20
    elseif index == 3 then
        self.juShuCount_ = 30
    end
end

function CreatePDKView:initPaiZhang_()
    local index = tonumber(xtpkdData:getPaiZhang())
    self:updatePaiZhangList_(index)
    if self.paiZhangList_[index] then
        self.paiZhangList_[index]:setSelected(true)
    else
        self.paiZhangList_[1]:setSelected(true)
    end
    if index == 1 then
        self.paiCount_ = 15
    elseif index == 2 then
        self.paiCount_ = 16
    end
end

function CreatePDKView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/createRoom/createPDK.csb"):addTo(self)
    self.csbNodePosY = self.csbNode_:getPositionY()
end

function CreatePDKView:updateJuShuList_(index)
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

function CreatePDKView:updateZhiFuList_(index)
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

function CreatePDKView:sd1Handler_()
    self:updatesdList_(1)
    self.sd_ = 1
    xtpkdData:setSiDai(1)
end

function CreatePDKView:sd2Handler_()
    self:updatesdList_(2)
    self.sd_ = 2
    xtpkdData:setSiDai(2)
end

function CreatePDKView:sd3Handler_()
    self:updatesdList_(3)
    self.sd_ = 3
    xtpkdData:setSiDai(3)
end

function CreatePDKView:updatesdList_(index)
    for i, v in ipairs(self.sdList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
end

function CreatePDKView:updateDiFenList_(index)
    for i, v in ipairs(self.diFenList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
end

function CreatePDKView:userCountConf()
    if self.playerCount_ == 2 then
        self.chupTip_:hide()
        self.chuType1_:hide()
        self.chuType2_:hide()
        self.chuType1Font_:hide()
        self.chuType2Font_:hide()
        self:updateChuTypeList_(1)
        self.cType = 0
        self.fzb = 0
        for i = 1,3 do
            self["fzb" .. i .. "_"]:hide()
            self["fzbFont" .. i .. "_"]:hide()
        end
        self.fzbTip_:hide()
        self.fzbLine_:hide()
    else
        self.chupTip_:show()
        self.chuType1_:show()
        self.chuType2_:show()
        self.chuType1Font_:show()
        self.chuType2Font_:show()
        for i = 1,3 do
            self["fzb" .. i .. "_"]:show()
            self["fzbFont" .. i .. "_"]:show()
        end
        self.fzbTip_:show()
        self.fzbLine_:show()
    end
end

function CreatePDKView:updateRenShuList_(index)
    for i, v in ipairs(self.renshuList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
    self:userCountConf()
end

function CreatePDKView:updatePaiZhangList_(index)
    for i, v in ipairs(self.paiZhangList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
    if index and index >= 1 and index <= 2 then
        self.zhanDanTip_:setString(self.zhanDanTipInfo[index])
    else
        self.zhanDanTip_:setString("")
    end
    
end

function CreatePDKView:zhifu1Handler_()
    self:updateZhiFuList_(1)
    self.zhiFuType_ = 0
    xtpkdData:setZhiFu(1)
end

function CreatePDKView:zhifu2Handler_()
    self:updateZhiFuList_(2)
    xtpkdData:setZhiFu(2)
    self.zhiFuType_ = 1
end

function CreatePDKView:zhifu3Handler_()
    self:updateZhiFuList_(3)
    xtpkdData:setZhiFu(3)
    self.zhiFuType_ = 2
end

function CreatePDKView:jushu1Handler_()
    self:updateJuShuList_(1)
    self.juShuCount_ = 10
    xtpkdData:setJuShu(1)
end

function CreatePDKView:jushu2Handler_()
    self:updateJuShuList_(2)
    self.juShuCount_ = 20
    xtpkdData:setJuShu(2)
end

function CreatePDKView:jushu3Handler_()
    self:updateJuShuList_(3)
    self.juShuCount_ = 30
    xtpkdData:setJuShu(3)
end

function CreatePDKView:renshu1Handler_()
    self.playerCount_ = 2
    self:updateRenShuList_(1)
    xtpkdData:setRenShu(1)
end

function CreatePDKView:renshu2Handler_()
    self.playerCount_ = 3
    self:updateRenShuList_(2)
    xtpkdData:setRenShu(2)
end

function CreatePDKView:paiZhang1Handler_()
    self:updatePaiZhangList_(1)
    self.paiCount_ = 15
    xtpkdData:setPaiZhang(1)
end

function CreatePDKView:paiZhang2Handler_()
    self:updatePaiZhangList_(2)
    self.paiCount_ = 16
    xtpkdData:setPaiZhang(2)
end

function CreatePDKView:diFen1Handler_()
    self:updateDiFenList_(1)
    self.diFen_ = 1
    xtpkdData:setDiFen(1)
end

function CreatePDKView:diFen2Handler_()
    self:updateDiFenList_(2)
    self.diFen_ = 5
    xtpkdData:setDiFen(2)
end

function CreatePDKView:diFen3Handler_()
    self:updateDiFenList_(3)
    self.diFen_ = 10
    xtpkdData:setDiFen(3)
end

function CreatePDKView:houziHandler_(item)
    if item:isSelected() then
        xtpkdData:setHouZi(1)
        self.isHouZi_ = 1
    else
        xtpkdData:setHouZi(0)
        self.isHouZi_ = 0
    end
end

function CreatePDKView:cardNumHandler_(item)
    if item:isSelected() then
        xtpkdData:setCardNum(1)
        self.cardNum = 1
    else
        xtpkdData:setCardNum(0)
        self.cardNum = 0
    end
end

function CreatePDKView:weiPaiHandler_(item)
    if item:isSelected() then
        xtpkdData:setSanDaiYi(1)
        self.isSanDaiYi_ = 1
    else
        xtpkdData:setSanDaiYi(0)
        self.isSanDaiYi_ = 0
    end
end

function CreatePDKView:sw3Handler_(item)
    if item:isSelected() then
        xtpkdData:setSW3(1)
        self.sw3 = 0
    else
        xtpkdData:setSW3(0)
        self.sw3 = 1
    end
end

function CreatePDKView:fzbHandler_(item)
    if item:isSelected() then
        xtpkdData:setFZB(1)
        self.fzb = 1
    else
        xtpkdData:setFZB(0)
        self.fzb = 0
    end
end

function CreatePDKView:zdbkcHandler_(item)
    if item:isSelected() then
        xtpkdData:setZDBKC(1)
        self.zdbkc = 1
    else
        xtpkdData:setZDBKC(0)
        self.zdbkc = 0
    end
    print("======self.zdbkc========",self.zdbkc)
end

function CreatePDKView:fangQiangGuanHandler_(item)
    if item:isSelected() then
        xtpkdData:setQiangGuan(1)
        self.isFangQiangGuan_ = 1
    else
        xtpkdData:setQiangGuan(0)
        self.isFangQiangGuan_ = 0
    end
end

function CreatePDKView:calcCreateRoomParams(daiKai)
    local guiZe = {}
    guiZe.cardCount = self.paiCount_
    guiZe.xianPai = self.cardNum
    guiZe.score = self.diFen_
    guiZe.playerCount = self.playerCount_
    guiZe.red10 = self.isHouZi_
    if self.sd_ == 1 then
        guiZe.siDaiSan = 0
        guiZe.siDaiEr = 0
    elseif self.sd_ == 2 then
        guiZe.siDaiSan = 1
        guiZe.siDaiEr = 0
    elseif self.sd_ == 3 then
        guiZe.siDaiSan = 0
        guiZe.siDaiEr = 1
    end
    if self.fzb_ == 1 then
        guiZe.fang_zuo_bi = 0
        guiZe.simple_fang_zuo_bi = 0
    elseif self.fzb_ == 2 then
        guiZe.fang_zuo_bi = 1
        guiZe.simple_fang_zuo_bi = 1
    elseif self.fzb_ == 3 then
        guiZe.fang_zuo_bi = 1
        guiZe.simple_fang_zuo_bi = 0
    end
    if guiZe.playerCount == 2 then
        guiZe.fang_zuo_bi = 0
        guiZe.simple_fang_zuo_bi = 0
    end
    guiZe.tail3With1 = self.isSanDaiYi_
    guiZe.fangQiangGuan = self.isFangQiangGuan_
    guiZe.threeABomb = self.a3boom
    guiZe.xian_chu_type = self.cType
    guiZe.bao_dan_type = self.baoDan
    guiZe.same_card_count  = self.sw3
    guiZe.denySplitBomb = self.zdbkc
    local params = {
        gameType = GAME_PAODEKUAI, -- 游戏服务类型
        totalRound = self.juShuCount_, -- 游戏局数
        consumeType = self.zhiFuType_,
        isAgent = 0, -- 代开 0为否 1为是
        ipLimit = 0, -- 是否禁止相同IP入坐，1为禁止，0为不禁止
        ruleType = 1, -- 游戏小规则类型 默认为1, 可由不同游戏自己定义
        ruleDetails = guiZe -- 任意定义的规则选项, 参考下面的各游戏详细规则说明 -- 规则详情
    }
    dump(params,"paramsparamsparams")
    return params
end

return CreatePDKView 

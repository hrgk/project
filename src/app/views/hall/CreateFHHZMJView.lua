local BaseCreateView = import(".BaseCreateView")
local CreateFHHZMJView = class("CreateFHHZMJView", BaseCreateView)

function CreateFHHZMJView:ctor(isHongZhong,showZFType)
    self.jushuConf = {8,16}
    self.renShuConf = {3,4,2}
    self.xyNum = 0
    CreateFHHZMJView.super.ctor(self)
    self.huType_ = 1
    self.juShuList_ = {}
    self.juShuList_[1] = self.ju1_
    self.juShuList_[2] = self.ju2_
    self.juShuList_[3] = self.ju3_

    self.renshuList_ = {}
    self.renshuList_[1] = self.renShu1_
    self.renshuList_[2] = self.renShu2_
    self.renshuList_[3] = self.renShu3_

    self.paiTypeList_ = {}
    self.paiTypeList_[1] = self.paiType1_
    self.paiTypeList_[2] = self.paiType2_
    
    self.zhiFuList_ = {}
    self.zhiFuList_[1] = self.zhifu1_
    self.zhiFuList_[2] = self.zhifu2_
    self.zhiFuList_[3] = self.zhifu3_
    
    self.hutypeList_ = {}
    self.hutypeList_[1] = self.hutype1_
    self.hutypeList_[2] = self.hutype2_

    self.zbList_ = {}
    self.zbList_[1] = self.zb1_
    self.zbList_[2] = self.zb2_

    self:initZhiFuType_()
    self:initJuShu_()
    self:initXY_()
    self:initHutype_()
    self:initZB_()
    self:initRenShu_()
    self:initpaiType_()
    self.qd_:setSelected(fhhzmjData:getQXD()+0 == 1)
    self.hhqd_:setSelected(fhhzmjData:getHQXD()+0 == 1)
    self.hhqd2_:setSelected(fhhzmjData:getSHQXD()+0 == 1)
    self.gsh_:setSelected(fhhzmjData:getGSH()+0 == 1)
    self.qgh_:setSelected(fhhzmjData:getQGH()+0 == 1)
    self.hhqd3_:setSelected(fhhzmjData:getSANHQXD()+0 == 1)
    createRoomData:setGameIndex(GAME_MJZHUANZHUAN)
    self:setShowZFType(showZFType)
end

function CreateFHHZMJView:setData(data,needCZ)
    dump(data,"CreateFHHZMJView:setData")
    self:updateZhiFuList_(data.consumeType+1)
    for key,value in pairs(self.jushuConf) do
        if value == data.juShu then
            self:updateJuShuList_(key)
            break
        end
    end
    for key,value in pairs(self.renShuConf) do
        if value == data.ruleDetails.totalSeat then
            self:updateRenShuList_(key)
            break
        end
    end
    if data.ruleDetails.fullPai and data.ruleDetails.fullPai > 0 then
        self:updatepaiTypeList_(data.ruleDetails.fullPai)
    end
    if not needCZ then
        self.yzAdd_:hide()
        self.yzReduce_:hide()
    end
 
    self.yzNum_:setString(data.ruleDetails.piaoScore)
    self:updatehutypeList_(data.ruleDetails.huType == 1 and 1 or 2)
    self:updatezbList_(data.ruleDetails.autoReady == 1 and 1 or 2)
    self.xyNum = data.ruleDetails.piaoScore
    self.csbNode_:setPositionY(self.csbNodePosY+60)

    self.qd_:setSelected(data.ruleDetails.wanFa.qxd == 1)
    self.hhqd_:setSelected(data.ruleDetails.wanFa.hqxd == 1)
    self.hhqd2_:setSelected(data.ruleDetails.wanFa.shqxd == 1)
    self.gsh_:setSelected(data.ruleDetails.wanFa.gsh == 1)
    self.qgh_:setSelected(data.ruleDetails.wanFa.qgh == 1)
    self.hhqd3_:setSelected(data.ruleDetails.wanFa.sanhqxd == 1)
end

function CreateFHHZMJView:zb1Handler_()
    self:updatezbList_(1)
end

function CreateFHHZMJView:zb2Handler_()
    self:updatezbList_(2)
end

function CreateFHHZMJView:updatezbList_(index)
    for i,v in ipairs(self.zbList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
    self.zb_ = index
    fhhzmjData:setAutoReady(index)
end

function CreateFHHZMJView:initZB_()
    local index = tonumber(fhhzmjData:getAutoReady())
    self:updatezbList_(index)
    if self.zbList_[index] then
        self.zbList_[index]:setSelected(true)
        self.zb_ = index
    else
        self.paiTypeList_[1]:setSelected(true)
        self.zb_ = 1
    end
end

function CreateFHHZMJView:hutype1Handler_()
    self:updatehutypeList_(1)
end

function CreateFHHZMJView:hutype2Handler_()
    self:updatehutypeList_(2)
end

function CreateFHHZMJView:updatehutypeList_(index)
    for i,v in ipairs(self.hutypeList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
    self.hutype_ = index
    fhhzmjData:setHuPai(index)
end

function CreateFHHZMJView:initHutype_()
    local index = tonumber(fhhzmjData:getHuPai())
    self:updatehutypeList_(index)
    if self.hutypeList_[index] then
        self.hutypeList_[index]:setSelected(true)
        self.hutype_ = index
    else
        self.paiTypeList_[1]:setSelected(true)
        self.hutype_ = 1
    end
end

function CreateFHHZMJView:initXY_()
    self.xyNum = tonumber(fhhzmjData:getXYNuM())
    self.yzNum_:setString(self.xyNum)
end

function CreateFHHZMJView:yzAddHandler_()
    if self.xyNum < 20 then
        self.xyNum = self.xyNum + 1
    end
    self.yzNum_:setString(self.xyNum)
end

function CreateFHHZMJView:yzReduceHandler_()
    if self.xyNum > 0 then
        self.xyNum = self.xyNum - 1
    end
    self.yzNum_:setString(self.xyNum)
end

function CreateFHHZMJView:initpaiType_()
    local index = tonumber(fhhzmjData:getpaiType())
    self:updatepaiTypeList_(index)
    if self.paiTypeList_[index] then
        self.paiTypeList_[index]:setSelected(true)
        self.paiType_ = index
    else
        self.paiTypeList_[1]:setSelected(true)
        self.paiType_ = 1
    end
end

function CreateFHHZMJView:paiType1Handler_()
    fhhzmjData:setpaiType(1)
    self:updatepaiTypeList_(1)
    self.paiType_ = 1
end

function CreateFHHZMJView:paiType2Handler_()
    fhhzmjData:setpaiType(2)
    self:updatepaiTypeList_(2)
    self.paiType_ = 2
end

function CreateFHHZMJView:updatepaiTypeList_(index)
    for i,v in ipairs(self.paiTypeList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
end

function CreateFHHZMJView:initZhiFuType_()
    local index = tonumber(fhhzmjData:getZhiFu())
    self:updateZhiFuList_(index)
    if self.zhiFuList_[index] then
        self.zhiFuList_[index]:setSelected(true)
    else
        self.zhiFuList_[1]:setSelected(true)
    end
end

function CreateFHHZMJView:updateZhiFuList_(index)
    for i, v in ipairs(self.zhiFuList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
    if index == 1 then
        self.zhiFuType_ = 0
    elseif index == 2 then
        self.zhiFuType_ = 1
    else
        self.zhiFuType_ = 2
    end
end

function CreateFHHZMJView:initJuShu_()
    local index = tonumber(fhhzmjData:getJuShu())
    self:updateJuShuList_(index)
    if self.juShuList_[index] then
        self.juShuList_[index]:setSelected(true)
    else
        self.juShuList_[1]:setSelected(true)
    end
end

function CreateFHHZMJView:initRenShu_()
    local index = tonumber(fhhzmjData:getRenShu())
    self:updateRenShuList_(index)
    if self.renshuList_[index] then
        self.renshuList_[index]:setSelected(true)
    else
        self.renshuList_[1]:setSelected(true)
    end
end

function CreateFHHZMJView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/createRoom/createFHHZ.csb"):addTo(self)
    self.csbNodePosY = self.csbNode_:getPositionY()
end

function CreateFHHZMJView:updateJuShuList_(index)
    for i,v in ipairs(self.juShuList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
    if index == 1 then
        self.juShuCount_ = 8 
    elseif index == 2 then 
        self.juShuCount_ = 16
    else
        self.juShuCount_ = 24
    end
end

function CreateFHHZMJView:updateRenShuList_(index)
    for i,v in ipairs(self.renshuList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
    for i = 1,2 do
        self["paiType" .. i .. "_"]:setVisible(index == 3)
        self["paiTypeTip" .. i .. "_"]:setVisible(index == 3)
    end
    if index ~= 3 then
        self.paiType_ = 0
    end
    self.price1_:setString("x" .. 8 * self.renShuConf[index])
    self.price2_:setString("x" .. 16 * self.renShuConf[index])
    if index == 1 then
        self.playerCount_ = 3 
    elseif index == 2 then 
        self.playerCount_ = 4
    elseif index == 3 then
        self.playerCount_ = 2 
    end
end

function CreateFHHZMJView:zhifu1Handler_()
    self:updateZhiFuList_(1)
    self.zhiFuType_ = 0
    fhhzmjData:setZhiFu(1)
end

function CreateFHHZMJView:zhifu2Handler_()
    self:updateZhiFuList_(2)
    fhhzmjData:setZhiFu(2)
    self.zhiFuType_ = 1
end

function CreateFHHZMJView:zhifu3Handler_()
    self:updateZhiFuList_(3)
    fhhzmjData:setZhiFu(3)
    self.zhiFuType_ = 2
end

function CreateFHHZMJView:ju1Handler_()
    fhhzmjData:setJuShu(1)
    self:updateJuShuList_(1)
    self.juShuCount_ = 8
end

function CreateFHHZMJView:ju2Handler_()
    fhhzmjData:setJuShu(2)
    self:updateJuShuList_(2)
    self.juShuCount_ = 16
end

function CreateFHHZMJView:ju3Handler_()
    fhhzmjData:setJuShu(3)
    self:updateJuShuList_(3)
    self.juShuCount_ = 24
end

function CreateFHHZMJView:renShu1Handler_()
    fhhzmjData:setRenShu(1)
    self:updateRenShuList_(1)
    self.playerCount_ = 3
end

function CreateFHHZMJView:renShu2Handler_()
    fhhzmjData:setRenShu(2)
    self:updateRenShuList_(2)
    self.playerCount_ = 4
end

function CreateFHHZMJView:renShu3Handler_()
    fhhzmjData:setRenShu(3)
    self:updateRenShuList_(3)
    self.playerCount_ = 2
end

function CreateFHHZMJView:calcCreateRoomParams()
    local ruleDetails = {
                            fullPai = tonumber(fhhzmjData:getpaiType()),
                            piaoScore = self.xyNum,  -- 几条鱼
                            limitScore = 0,  -- 单局得分上限
                            totalSeat = self.playerCount_,
                            autoReady = self.zb_ == 1 and 1 or 0,
                            huType = self.hutype_ == 1 and 1 or 0,  -- 胡牌类型 1 可接炮 0  自摸胡
                        }
    if self.playerCount_ ~= 2 then
        ruleDetails.fullPai = 0
    end
    fhhzmjData:setXYNuM(self.xyNum)
    ruleDetails.wanFa = {
        qxd = self.qd_:isSelected() and 1 or 0,
        hqxd = self.hhqd_:isSelected() and 1 or 0,
        shqxd = self.hhqd2_:isSelected() and 1 or 0,
        gsh = self.gsh_:isSelected() and 1 or 0,
        qgh = self.qgh_:isSelected() and 1 or 0,
        sanhqxd = self.hhqd3_:isSelected() and 1 or 0,
    }
    fhhzmjData:setQXD(ruleDetails.wanFa.qxd)
    fhhzmjData:setHQXD(ruleDetails.wanFa.hqxd)
    fhhzmjData:setSHQXD(ruleDetails.wanFa.shqxd)
    fhhzmjData:setGSH(ruleDetails.wanFa.gsh)
    fhhzmjData:setQGH(ruleDetails.wanFa.qgh)
    fhhzmjData:setSANHQXD(ruleDetails.wanFa.sanhqxd)
    local mjHuType = 0
    local params = {
        gameType = GAME_FHHZMJ, -- 游戏服务类型
        totalRound = self.juShuCount_, -- 游戏局数
        consumeType = self.zhiFuType_,
        isAgent = 0,  -- 代开 0为否 1为是
        ipLimit = 0,  -- 是否禁止相同IP入坐，1为禁止，0为不禁止
        ruleType = 1,  -- 游戏小规则类型 默认为1, 可由不同游戏自己定义
        ruleDetails = ruleDetails -- 任意定义的规则选项, 参考下面的各游戏详细规则说明 -- 规则详情
    }
    dump(params,"CreateFHHZMJView:calcCreateRoomParams")
    return params
end

return CreateFHHZMJView 

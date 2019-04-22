local BaseCreateView = import(".BaseCreateView")
local CreateHHQMTView = class("CreateHHQMTView", BaseCreateView)

function CreateHHQMTView:ctor(showZFType)
    CreateHHQMTView.super.ctor(self)
    self.jushuConf = {8,16}
    self.renShuConf = {3,2}
    self.juShuList_ = {}
    self.juShuList_[1] = self.juShu1_
    self.juShuList_[2] = self.juShu2_

    self.fdList_ = {}
    self.fdList_[1] = self.fd1_
    self.fdList_[2] = self.fd2_
    self.fdList_[3] = self.fd3_

    self.ctList_ = {}
    self.ctList_[1] = self.ct1_
    self.ctList_[2] = self.ct2_
    self.ctList_[3] = self.ct3_

    self.wfList_ = {}
    self.wfList_[1] = self.qmt_
    self.wfList_[2] = self.hhd_

    self.rsList_ = {}
    self.rsList_[1] = self.ren3_
    self.rsList_[2] = self.ren2_

    self.zhiFuList_ = {}
    self.zhiFuList_[1] = self.zhifu1_
    self.zhiFuList_[2] = self.zhifu2_
    self.zhiFuList_[3] = self.zhifu3_

    self.radioInfo = {"dzh","dty"}
    self:initShow()
    createRoomData:setGameIndex(GAME_CDPHZ)
    self:setShowZFType(showZFType)
end

function CreateHHQMTView:setData(data)

    local score = {{0,100,200},{0,20,40}}

    self:updateZFList_(data.consumeType+1)
    for key,value in pairs(self.jushuConf) do
        if value == data.totalRound then
            self:updateJuShuList_(key)
            break
        end
    end
    self.tiPai_:setSelected(tonumber(data.rules.quPai) == 1)
    self.huXiType_:setSelected(tonumber(data.rules.twoPlayerBaseXi) == 1)
    self.qiShouTi_:setSelected(tonumber(data.rules.qiShouTi) == 1)
    for key,value in pairs(self.renShuConf) do
        if value == data.rules.totalSeat then
            self:updateRSList_(key)
            break
        end
    end
    self:updateCTList_(data.rules.baseTun)
    if data.ruleType == 3 then
        self:qmtHandler_()
    else
        self:hhdHandler_()
    end
    if data.rules.limitScore == 0 then
        self:updateFDList_(1)
    elseif data.rules.limitScore == 100 or data.rules.limitScore == 20 then
        self:updateFDList_(2)
    elseif data.rules.limitScore == 200 or data.rules.limitScore == 40 then
        self:updateFDList_(3)
    end
         
    local conf = {"duiDuiHu","daTuanYuan"}
    for i = 1, #conf do
        local item = self[self.radioInfo[i].."_"] 
        item:setSelected(data.rules[conf[i]] == 1)
    end
end

function CreateHHQMTView:initShow()
    local guiZe = hhqmtData:getRuleInfo()
    self:updateJuShuList_(guiZe.jushu)
    self:updateRSList_(guiZe.rs)
    self:updateFDList_(guiZe.fd)
    self:updateCTList_(guiZe.ct)
    self:updateZFList_(guiZe.zhifu)

    self.tiPai_:setSelected(tonumber(guiZe.quPai) == 1)
    self.huXiType_:setSelected(tonumber(guiZe.twoPlayerBaseXi) == 1)
    self.qiShouTi_:setSelected(tonumber(guiZe.qiShouTi) == 1)
    self.quPai_ = tonumber(guiZe.quPai)
    self.huXiIndex_ = tonumber(guiZe.twoPlayerBaseXi)
    self.qiShouTiPai_ = tonumber(guiZe.qiShouTi)
    if guiZe.wf == 1 then
        self:qmtHandler_()
    else
        self:hhdHandler_()
    end
    
    for i = 1, #self.radioInfo do
        local item = self[self.radioInfo[i].."_"] 
        item:setSelected(guiZe[self.radioInfo[i]] == 1)
    end
end

function CreateHHQMTView:getElement(aimNode,aimType)
    for k,v in pairs(aimNode:getChildren()) do
        local vInfo = string.split(v:getName(), "_")
        local itemName
        local itemType = vInfo[1]
        if itemType == aimType then
            if vInfo[2] then
                itemName =  vInfo[2] .. "_"
                self[itemName] = v
            end
        end
    end
end

function CreateHHQMTView:initElement_()
    CreateHHQMTView.super.initElement_(self)
    self.node_subQMT = self.csbNode_:getChildByName("Node_subQMT")
    self.node_subHHD = self.csbNode_:getChildByName("Node_subHHD")
    self.Text_fdInfo2 = self.csbNode_:getChildByName("Text_fdInfo2")
    self.Text_fdInfo3 = self.csbNode_:getChildByName("Text_fdInfo3")
    self:getElement(self.node_subQMT,"checkBox")
    self:getElement(self.node_subHHD,"checkBox")
    self.node_subQMT:setVisible(false)
    self.node_subHHD:setVisible(false)
end

function CreateHHQMTView:ren3Handler_()
    self:updateRSList_(1)
end

function CreateHHQMTView:ren2Handler_()
    self:updateRSList_(2)
end

function CreateHHQMTView:zhifu1Handler_()
    self:updateZFList_(1)
end

function CreateHHQMTView:zhifu2Handler_()
    self:updateZFList_(2)
end

function CreateHHQMTView:zhifu3Handler_()
    self:updateZFList_(3)
end

function CreateHHQMTView:updateRSList_(index)
    for i, v in ipairs(self.rsList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
    self.huXiType_:setVisible(index == 2)
    self.huLabel_:setVisible(index == 2)
    self.tiPai_:setVisible(index == 2)
    self.tiLabel_:setVisible(index == 2)
end

function CreateHHQMTView:huXiTypeHandler_(item)
    if item:isSelected() then
        self.huXiIndex_ = 1
    else
        self.huXiIndex_ = 0
    end
end

function CreateHHQMTView:tiPaiHandler_(item)
    if item:isSelected() then
        self.quPai_ = 1
    else
        self.quPai_ = 0
    end
end

function CreateHHQMTView:qiShouTiHandler_(item)
    if item:isSelected() then
        self.qiShouTiPai_ = 1
    else
        self.qiShouTiPai_ = 0
    end
end

function CreateHHQMTView:juShu1Handler_()
    self:updateJuShuList_(1)
end

function CreateHHQMTView:juShu2Handler_()
    self:updateJuShuList_(2)
end

function CreateHHQMTView:updateJuShuList_(index)
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

function CreateHHQMTView:fd1Handler_()
    self:updateFDList_(1)
end

function CreateHHQMTView:fd2Handler_()
    self:updateFDList_(2)
end

function CreateHHQMTView:fd3Handler_()
    self:updateFDList_(3)
end

function CreateHHQMTView:updateFDList_(index)
    for i, v in ipairs(self.fdList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
end

function CreateHHQMTView:ct1Handler_()
    self:updateCTList_(1)
end

function CreateHHQMTView:ct2Handler_()
    self:updateCTList_(2)
end

function CreateHHQMTView:ct3Handler_()
    self:updateCTList_(3)
end

function CreateHHQMTView:updateCTList_(index)
    for i, v in ipairs(self.ctList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
end

function CreateHHQMTView:updateZFList_(index)
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

function CreateHHQMTView:qmtHandler_()
    self.node_subQMT:setVisible(true)
    self.node_subHHD:setVisible(false)
    self.Text_fdInfo2:setString("100封顶")
    self.Text_fdInfo3:setString("200封顶")
    self:updateWFList_(1)
end

function CreateHHQMTView:hhdHandler_()
    self.node_subQMT:setVisible(false)
    self.node_subHHD:setVisible(true)
    self.Text_fdInfo2:setString("20封顶")
    self.Text_fdInfo3:setString("40封顶")
    self:updateWFList_(2)
end

function CreateHHQMTView:updateWFList_(index)
    for i, v in ipairs(self.wfList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
end

function CreateHHQMTView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/createRoom/createHHQMT.csb"):addTo(self)
end

function CreateHHQMTView:getRuleInfo()
    local guiZe = {}
    local strRule = ""
    local juShuConf = {8,16}
    for i = 1,2 do
        local item = self.juShuList_[i]
        if item:isSelected() then
            self.juShuCount_ = juShuConf[i]
            guiZe.jushu = i
        end
    end

    for i = 1,2 do
        local item = self.rsList_[i]
        if item:isSelected() then
            guiZe.rs = i
            break
        end
    end

    for i = 1,3 do
        local item = self.fdList_[i]
        if item:isSelected() then
            guiZe.fd = i
            break
        end
    end
    for i = 1,3 do
        local item = self.ctList_[i]
        if item:isSelected() then
            guiZe.ct = i
            break
        end
    end
    for i = 1,2 do
        local item = self.wfList_[i]
        if item:isSelected() then
            guiZe.wf = i
            break
        end
    end
    for i = 1,3 do
        local item = self.zhiFuList_[i]
        if item:isSelected() then
            guiZe.zhifu = i
            break
        end
    end
    for i = 1, #self.radioInfo do
        local item = self[self.radioInfo[i].."_"] 
        if item:isSelected() then
            guiZe[self.radioInfo[i]] = 1
        else
            guiZe[self.radioInfo[i]] = 0
        end
    end
    guiZe.quPai  = self.quPai_
    guiZe.twoPlayerBaseXi  = self.huXiIndex_
    guiZe.qiShouTi  = self.qiShouTiPai_
    print("=======guiZe.quPai============",guiZe.quPai,self.quPai_)
    print("=======guiZe.twoPlayerBaseXi============",guiZe.twoPlayerBaseXi,self.huXiIndex_)
    print("=======guiZe.qiShouTi============",guiZe.qiShouTi,self.qiShouTiPai_)
    return guiZe
end

function CreateHHQMTView:getAimGuiZe(guiZe)
    local aimGuiZe = {}
    aimGuiZe.ruleType = guiZe["wf"] == 1 and 3 or 1
    local score = {{0,100,200},{0,20,40}}
    aimGuiZe.limitScore = score[guiZe["wf"]][guiZe["fd"]]
    aimGuiZe.baseTun  = guiZe["ct"]
    aimGuiZe.santi5kan  = 0
    aimGuiZe.daTuanYuan  = guiZe["dty"]
    aimGuiZe.duiZiHu  = guiZe["dzh"]
    aimGuiZe.quPai  = guiZe["quPai"]
    aimGuiZe.twoPlayerBaseXi  = guiZe["twoPlayerBaseXi"]
    aimGuiZe.qiShouTi  = guiZe["qiShouTi"]
    aimGuiZe.totalSeat  = guiZe["rs"] == 1 and 3 or 2
    aimGuiZe.tingHu  = 1
    aimGuiZe.shuaHou  = 1
    aimGuiZe.huangFan  = 1
    return aimGuiZe
end

function CreateHHQMTView:calcCreateRoomParams(daiKai)
    local guiZe = self:getRuleInfo()
    local str = json.encode(guiZe)
    hhqmtData:setRuleInfo(str)
    local aimGuiZe = self:getAimGuiZe(guiZe)
    local params = {
        gameType = GAME_HHQMT, -- 游戏服务类型
        totalRound = self.juShuCount_, -- 游戏局数
        consumeType = guiZe["zhifu"] - 1,
        isAgent = 0, -- 代开 0为否 1为是
        ipLimit = 0, -- 是否禁止相同IP入坐，1为禁止，0为不禁止
        ruleType = aimGuiZe.ruleType, -- 游戏小规则类型 默认为1, 可由不同游戏自己定义
        ruleDetails = aimGuiZe -- 任意定义的规则选项, 参考下面的各游戏详细规则说明 -- 规则详情
    }
    return params
end

return CreateHHQMTView 

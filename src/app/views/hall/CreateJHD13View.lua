local BaseCreateView = import(".BaseCreateView")
local CreateJHD13View = class("CreateJHD13View", BaseCreateView)

function CreateJHD13View:ctor(showZFType)
    CreateJHD13View.super.ctor(self)
    self:initElementRecursive_(self.csbNode_)
    self.jushuConf = {10,20,30}
    self.renShuConf = {2,3,4}

    self.rsList_ = {}
    self.rsList_[1] = self.ren1_
    self.rsList_[2] = self.ren2_
    self.rsList_[3] = self.ren3_

    self.juShuList_ = {}
    self.juShuList_[1] = self.jushu1_
    self.juShuList_[2] = self.jushu2_
    self.juShuList_[3] = self.jushu3_

    self.zhiFuList_ = {}
    self.zhiFuList_[1] = self.zhifu1_
    self.zhiFuList_[2] = self.zhifu2_
    self.zhiFuList_[3] = self.zhifu3_

    self.msList_ = {}
    self.msList_[1] = self.mS1_
    self.msList_[2] = self.mS2_
    self.msList_[3] = self.mS3_
    self.msList_[4] = self.mS4_
    self.msList_[5] = self.mS5_

    self.jfList_ = {}
    self.jfList_[1] = self.jf1_
    self.jfList_[2] = self.jf2_

    self.fsList_ = {}
    self.fsList_[1] = self.fs1_
    self.fsList_[2] = self.fs2_
    self.fsList_[3] = self.fs3_

    self.jfShowList_ = {}
    self.jfShowList_[1] = self.js_
    self.jfShowList_[2] = self.fs_
    self.guize_:setScale(1.3,1.2)
    self:initShow()
    createRoomData:setGameIndex(GAME_13DAO)
end

function CreateJHD13View:setData(data)
    dump(data,"datadata")
    self:updateZFList_(data.config.consumeType+1)
    
    for key,value in pairs(self.jushuConf) do
        if value == data.config.juShu then
            self:updateJSList_(key)
            break
        end
    end
    if data.config.rules.playerCount then
        for key,value in pairs(self.renShuConf) do
            if value == data.config.rules.playerCount then
                self:updateRSList_(key)
                break
            end
        end
    else
        self:updateRSList_(3)
    end
    
    self:updatejfList_(data.config.rules.roundType+1)
    if data.config.rules.zhuangType == 1 then
        self:updateMSList_(1)
    elseif data.config.rules.zhuangType == 2 then
        self:updateMSList_(3)
    elseif data.config.rules.zhuangType == 3 then
        self:updateMSList_(2)
    elseif data.config.rules.zhuangType == 4 then
        self:updateMSList_(4)
    elseif data.config.rules.zhuangType == 5 then
        self:updateMSList_(5)
    end
    local score = {50,100,200}
    self:updatefsList_(table.indexof(score,data.config.rules.bundleScore))
    self.tspx_:setSelected(data.config.rules.specialType == 1)
    if data.config.rules.maPai then
        self.mp_:setSelected(data.config.rules.maPai == 1)
    end
end

function CreateJHD13View:initShowMaskP()
    self.maskP_:show()
end

function CreateJHD13View:initShow()
    local guiZe = d13Data:getRuleInfo()
    self:updateJSList_(guiZe.jushu)
    self:updateZFList_(guiZe.zhifu)
    self:updateMSList_(guiZe.ms)
    self:updatejfList_(guiZe.jf)
    self:updatefsList_(guiZe.fs)
    self:updateRSList_(guiZe.rs)
    self.tspx_:setSelected(guiZe.tspx == 1)
    self.mp_:setSelected(guiZe.mp == 1)
end

function CreateJHD13View:ren1Handler_()
    self:updateRSList_(1)
end

function CreateJHD13View:ren2Handler_()
    self:updateRSList_(2)
end

function CreateJHD13View:ren3Handler_()
    self:updateRSList_(3)
end

function CreateJHD13View:updateRSList_(index)
    for i, v in ipairs(self.rsList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
    self.rs_ = index
end

function CreateJHD13View:updatejfShowList_(index)
    for i, v in ipairs(self.jfShowList_) do
        v:setVisible(index == i)
    end
end

function CreateJHD13View:fs1Handler_()
    self:updatefsList_(1)
end

function CreateJHD13View:fs2Handler_()
    self:updatefsList_(2)
end

function CreateJHD13View:fs3Handler_()
    self:updatefsList_(3)
end

function CreateJHD13View:updatefsList_(index)
    for i, v in ipairs(self.fsList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
    self.fsIndex_ = index
end

function CreateJHD13View:jf1Handler_()
    self:updatejfList_(1)
end

function CreateJHD13View:jf2Handler_()
    self:updatejfList_(2)
end

function CreateJHD13View:updatejfList_(index)
    for i, v in ipairs(self.jfList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
    self.jf_ = index
    self:updatejfShowList_(index)
end

function CreateJHD13View:mS1Handler_()
    self:updateMSList_(1)
end

function CreateJHD13View:mS2Handler_()
    self:updateMSList_(2)
end

function CreateJHD13View:mS3Handler_()
    self:updateMSList_(3)
end

function CreateJHD13View:mS4Handler_()
    self:updateMSList_(4)
end

function CreateJHD13View:mS5Handler_()
    self:updateMSList_(5)
end

function CreateJHD13View:updateMSList_(index)
    for i, v in ipairs(self.msList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
    self.ms_ = index
end

function CreateJHD13View:jushu1Handler_()
    self:updateJSList_(1)
end

function CreateJHD13View:jushu2Handler_()
    self:updateJSList_(2)
end

function CreateJHD13View:jushu3Handler_()
    self:updateJSList_(3)
end

function CreateJHD13View:updateJSList_(index)
    for i, v in ipairs(self.juShuList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
    self.js_ = index
    self.juShuCount_ = self.jushuConf[index]
end

function CreateJHD13View:zhifu1Handler_()
    self:updateZFList_(1)
end

function CreateJHD13View:zhifu2Handler_()
    self:updateZFList_(2)
end

function CreateJHD13View:zhifu3Handler_()
    self:updateZFList_(3)
end

function CreateJHD13View:wenhaoHandler_()
    self.isShowWH_ = not self.isShowWH_
    self.guize_:setVisible(self.isShowWH_)
end

function CreateJHD13View:updateZFList_(index)
    for i, v in ipairs(self.zhiFuList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
    self.zf_ = index
end


function CreateJHD13View:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/createRoom/createHZD13.csb"):addTo(self)
end

function CreateJHD13View:getRuleInfo()
    local guiZe = {
        ["jushu"] = self.js_,
        ["zhifu"] = self.zf_,
        ["ms"] = self.ms_,
        ["jf"] = self.jf_,
        ["fs"] = self.fsIndex_,
        ["tspx"] = self.tspx_:isSelected() and 1 or 0,
        ["rs"] = self.rs_,
        ["mp"] = self.mp_:isSelected() and 1 or 0,
    }
    local str = json.encode(guiZe)
    d13Data:setRuleInfo(str)

    local ruleDetails = {}
    ruleDetails.playerCount = self.renShuConf[self.rs_]
    if self.ms_ == 1 then
        ruleDetails.zhuangType = 1
    elseif self.ms_ == 2 then 
        ruleDetails.zhuangType = 3
    elseif self.ms_ == 3 then 
        ruleDetails.zhuangType = 2
    elseif self.ms_ == 4 then 
        ruleDetails.zhuangType = 4
    elseif self.ms_ == 5 then 
        ruleDetails.zhuangType = 5
    end
    ruleDetails.roundType = self.jf_ - 1
    local score = {50,100,200}
    ruleDetails.bundleScore = score[self.fsIndex_]
    ruleDetails.specialType = guiZe.tspx
    ruleDetails.maPai = guiZe.mp
    return ruleDetails
end

function CreateJHD13View:calcCreateRoomParams(daiKai)
    local aimGuiZe = self:getRuleInfo()
    local params = {
        gameType = GAME_13DAO, -- 游戏服务类型
        totalRound = self.juShuCount_, -- 游戏局数
        consumeType = self.zf_ - 1,
        isAgent = 0, -- 代开 0为否 1为是
        ipLimit = 0, -- 是否禁止相同IP入坐，1为禁止，0为不禁止
        ruleType = 2, -- 游戏小规则类型 默认为1, 可由不同游戏自己定义
        ruleDetails = aimGuiZe -- 任意定义的规则选项, 参考下面的各游戏详细规则说明 -- 规则详情
    }
    return params
end

return CreateJHD13View 

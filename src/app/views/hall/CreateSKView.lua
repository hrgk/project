local BaseCreateView = import(".BaseCreateView")
local CreateSKView = class("CreateSKView", BaseCreateView)

function CreateSKView:ctor(showZFType)
    CreateSKView.super.ctor(self)
    self.jushuConf = {6, 12}
    self.renShuConf = {3,4}
    self.juShuList_ = {}
    self.juShuList_[1] = self.jushu1_
    self.juShuList_[2] = self.jushu2_

    self.SKList_ = {}
    self.SKList_[1] = self.SK1_
    self.SKList_[2] = self.SK2_
    self.SKList_[3] = self.SK3_

    self.zhiFuList_ = {}
    self.zhiFuList_[1] = self.zhifu1_
    self.zhiFuList_[2] = self.zhifu2_
    self.zhiFuList_[3] = self.zhifu3_

    self.JGList_ = {}
    self.JGList_[1] = self.JG1_
    self.JGList_[2] = self.JG2_

    self.MPList_ = {}
    self.MPList_[1] = self.MP1_
    self.MPList_[2] = self.MP2_
    
    self:initShow()
    createRoomData:setGameIndex(GAME_SHUANGKOU)
end

function CreateSKView:setData(data)
    dump(data,"CreateSKView:setData")
    self:updateZFList_(data.consumeType+1)
    self:updateSKList_(data.bianPai+1)
    for key,value in pairs(self.jushuConf) do
        if value == data.juShu then
            self:updateJSList_(key)
            break
        end
    end
    self:updateJGList_(data.contribution+1)
    
end

function CreateSKView:initShow()
    local guiZe = skData:getRuleInfo()
    dump(guiZe,"CreateSKView:initShow")
    self:updateJSList_(guiZe.jushu)
    self:updateZFList_(guiZe.zhifu)
    self:updateMPList_(guiZe.mp)
    self:updateJGList_(guiZe.jg)
    self:updateSKList_(guiZe.sk)
end

function CreateSKView:MP1Handler_()
    self:updateMPList_(1)
end

function CreateSKView:MP2Handler_()
    self:updateMPList_(2)
end

function CreateSKView:updateMPList_(index)
    print("index22222222222",index)
    for i, v in ipairs(self.MPList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
    self.MP_ = index
end

function CreateSKView:JG1Handler_()
    self:updateJGList_(1)
end

function CreateSKView:JG2Handler_()
    self:updateJGList_(2)
end

function CreateSKView:updateJGList_(index)
    for i, v in ipairs(self.JGList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
    self.JG_ = index
end

function CreateSKView:SK1Handler_()
    self:updateSKList_(1)
end

function CreateSKView:SK2Handler_()
    self:updateSKList_(2)
end

function CreateSKView:SK3Handler_()
    self:updateSKList_(3)
end

function CreateSKView:updateSKList_(index)
    for i, v in ipairs(self.SKList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
    self.SK_ = index
end

function CreateSKView:jushu1Handler_()
    self:updateJSList_(1)
end

function CreateSKView:jushu2Handler_()
    self:updateJSList_(2)
end

function CreateSKView:jushu3Handler_()
    self:updateJSList_(3)
end

function CreateSKView:updateJSList_(index)
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

function CreateSKView:zhifu1Handler_()
    self:updateZFList_(1)
end

function CreateSKView:zhifu2Handler_()
    self:updateZFList_(2)
end

function CreateSKView:zhifu3Handler_()
    self:updateZFList_(3)
end

function CreateSKView:updateZFList_(index)
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


function CreateSKView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/createRoom/createSK.csb"):addTo(self)
end

function CreateSKView:getRuleInfo()
    local guiZe = {
        ["jushu"] = self.js_,
        ["zhifu"] = self.zf_,
        ["jg"] = self.JG_,
        ["sk"] = self.SK_ ,
        ["mp"] = self.MP_,
    }
    dump(guiZe,"guiZeguiZeguiZe")
    local str = json.encode(guiZe)
    skData:setRuleInfo(str)

    local ruleDetails = {}
    ruleDetails.bianPai = self.SK_ - 1
    ruleDetails.totalSeat = 4
    ruleDetails.contribution = self.JG_ - 1
    return ruleDetails
end

function CreateSKView:calcCreateRoomParams(daiKai)
    local aimGuiZe = self:getRuleInfo()
    local params = {
        gameType = GAME_SHUANGKOU, -- 游戏服务类型
        totalRound = self.juShuCount_, -- 游戏局数
        consumeType = self.zf_ - 1,
        isAgent = 0, -- 代开 0为否 1为是
        ipLimit = 0, -- 是否禁止相同IP入坐，1为禁止，0为不禁止
        ruleType = 1, -- 游戏小规则类型 默认为1, 可由不同游戏自己定义
        ruleDetails = aimGuiZe -- 任意定义的规则选项, 参考下面的各游戏详细规则说明 -- 规则详情
    }
    dump(params,"paramsparams")
    return params
end

return CreateSKView 

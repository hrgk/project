local BaseCreateView = import(".BaseCreateView")
local CreateLDFPFView = class("CreateLDFPFView", BaseCreateView)

function CreateLDFPFView:ctor(eventType)
    CreateLDFPFView.super.ctor(self)
    --人数toggle
    self.renShuList_ = {}
    for i = 1, 2 do
        self.renShuList_[i] = self["renshu"..tostring(i).."_"] 
    end
    --胡息上限toggle
    self.huXiList_ = {}
    for i = 1, 2 do
        self.huXiList_[i] = self["huxi"..tostring(i).."_"]
    end
    --起胡胡息toggle
    self.qiHuList_ = {}
    for i = 1, 3 do
        self.qiHuList_[i] = self["qihu"..tostring(i).."_"]
    end
    self.zhiFuList_ = {}
    for i = 1, 3 do
        self.zhiFuList_[i] = self["zhifu"..tostring(i).."_"]
    end
    self:initShow(eventType)
    createRoomData:setGameIndex(GAME_LDFPF)
    self:setShowZFType(showZFType)
end

function CreateLDFPFView:setData(data)
    -- self:updateZFList_(data.consumeType+1)
end

function CreateLDFPFView:initShow(eventType)
    local guiZe = {}
    if eventType and (eventType == 42 or eventType ==2) then
        if clubScoreRuleData:getNowRule() ~= nil then
            local play_config = json.decode(clubScoreRuleData:getNowRule().play_config)
            if play_config and play_config.ruleDetails and play_config.consumeType then
                guiZe = play_config.ruleDetails
                guiZe.consumeType = play_config.consumeType
                print(play_config.ruleDetails)
            else
                guiZe = nil
            end
        else
            guiZe.totalSeat = 2
            guiZe.limitScore =200
            guiZe.qiHu = 1
            guiZe.consumeType = 0
            guiZe.piaoHu = 0
            guiZe.daNiao = 0
            guiZe.fanBei = 0
        end
        
    else
        guiZe.totalSeat = 2
        guiZe.limitScore =200
        guiZe.qiHu = 1
        guiZe.consumeType = 0
        guiZe.piaoHu = 0
        guiZe.daNiao = 0
        guiZe.fanBei = 0
    end
    if guiZe == nil then
        guiZe = {}
        guiZe.totalSeat = 2
        guiZe.limitScore =200
        guiZe.qiHu = 1
        guiZe.consumeType = 0
        guiZe.piaoHu = 0
        guiZe.daNiao = 0
        guiZe.fanBei = 0
    end
    self:updateRSList_(guiZe.totalSeat - 1)
    self:updateHXList_(guiZe.limitScore == 200 and 1 or 2)
    local qiHuList = {[6] = 1,[10] = 2,[15] = 3}
    self:updateQHList_(qiHuList[guiZe.qiHu])
    self:updateZFList_(guiZe.consumeType + 1)
    self.piaohu_:setSelected(tonumber(guiZe.piaoHu) == 1)
    self.daniao_:setSelected(tonumber(guiZe.daNiao) > 1)
    self.fanbei_:setSelected(tonumber(guiZe.fanBei) == 1)
    self.reduce_:setVisible(self.daniao_:isSelected())
    self.add_:setVisible(self.daniao_:isSelected())
    self.DNNumbg_:setVisible(self.daniao_:isSelected())
    self.DNNum_:setString(tostring(guiZe.daNiao))
    self.DNNum_:setVisible(self.daniao_:isSelected())
    
end

function CreateLDFPFView:renshu1Handler_()
    self:updateRSList_(1)
end

function CreateLDFPFView:renshu2Handler_()
    self:updateRSList_(2)
end

function CreateLDFPFView:huxi1Handler_()
    self:updateHXList_(1)
end

function CreateLDFPFView:huxi2Handler_()
    self:updateHXList_(2)
end

function CreateLDFPFView:qihu1Handler_()
    self:updateQHList_(1)
end

function CreateLDFPFView:qihu2Handler_()
    self:updateQHList_(2)
end

function CreateLDFPFView:qihu3Handler_()
    self:updateQHList_(3)
end
 
function CreateLDFPFView:daniaoHandler_(item)
    self.reduce_:setVisible(item:isSelected())
    self.add_:setVisible(item:isSelected())
    self.DNNumbg_:setVisible(item:isSelected())
    self.DNNum_:setVisible(item:isSelected())
--    if item:isSelected() then
--        reduce_:setVisible()
--    else
--    end
end

function CreateLDFPFView:zhifu1Handler_()
    self:updateZFList_(1)
end

function CreateLDFPFView:zhifu2Handler_()
    self:updateZFList_(2)
end

function CreateLDFPFView:zhifu3Handler_()
    self:updateZFList_(3)
end

function CreateLDFPFView:addHandler_()
    local num = tonumber(self.DNNum_:getString())
    local string = ""
    if num < 100 then
        string = tostring(num + 10)
    else
        string = tostring(num)
    end
    print(string,"print(string)")
    self.DNNum_:setString(string)
end

function CreateLDFPFView:reduceHandler_()
    local num = tonumber(self.DNNum_:getString())
    local string = ""
    if num > 10 then
        string = tostring(num - 10)
    else
        string = tostring(num)
    end
    print(string,"print(string)")
    self.DNNum_:setString(string)
end

function CreateLDFPFView:updateZFList_(index)
    for i,v in ipairs(self.zhiFuList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
end

function CreateLDFPFView:updateRSList_(index)
    for i,v in ipairs(self.renShuList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
    self.fanbei_:setVisible(index == 1)
    self.TXfanbei_:setVisible(index == 1)
    self.IMfanbei_:setVisible(index == 1)
end

function CreateLDFPFView:updateHXList_(index)
    for i,v in ipairs(self.huXiList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
end

function CreateLDFPFView:updateQHList_(index)
    for i,v in ipairs(self.qiHuList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
end

function CreateLDFPFView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/createRoom/createLDFPF.csb"):addTo(self)
end

function CreateLDFPFView:getRuleInfo()
    local guiZe = {}
    for i = 1,2 do
        local item = self.renShuList_[i]
        if item:isSelected() then
            guiZe.renshu = i
            break
        end
    end
    for i = 1,2 do
        local item = self.huXiList_[i]
        if item:isSelected() then
            guiZe.huxi = i
            break
        end
    end
    for i = 1,3 do
        local item = self.qiHuList_[i]
        if item:isSelected() then
            guiZe.qihu = i
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
    guiZe.piaohu = self.piaohu_:isSelected() and 1 or 0
    guiZe.daniao = self.daniao_:isSelected() and 1 or 0
    guiZe.fanbei = self.fanbei_:isSelected() and 1 or 0
    guiZe.daniao_text = tonumber(self.DNNum_:getString())
    return guiZe
end

function CreateLDFPFView:getAimGuiZe(guiZe)
    local aimGuiZe = {}
    aimGuiZe.totalSeat = guiZe["renshu"] == 1 and 2 or 3
    aimGuiZe.limitScore = guiZe["huxi"] == 1 and 200 or 400
    aimGuiZe.piaoHu	= guiZe["piaohu"]
    local score = {6,10,15}
    aimGuiZe.qiHu = score[guiZe["qihu"]]
    
    --添加选择分数后加入
    if guiZe["daniao"] == 1 then
        aimGuiZe.daNiao = guiZe["daniao_text"]
    else
        aimGuiZe.daNiao = 0
    end
    if guiZe["renshu"] == 2 then
        aimGuiZe.fanBei = 0
    else
        aimGuiZe.fanBei = guiZe["fanbei"]
    end

    return aimGuiZe
end

function CreateLDFPFView:calcCreateRoomParams(daiKai)
    local guiZe = self:getRuleInfo()
    local str = json.encode(guiZe)
    ldfpfData:setRuleInfo(str)
    local aimGuiZe = self:getAimGuiZe(guiZe)
    local params = {
        gameType = GAME_LDFPF, -- 游戏服务类型
        totalRound = 8,-- 游戏局数
        consumeType = guiZe["zhifu"] - 1,
        isAgent = 0, -- 代开 0为否 1为是
        ipLimit = 0, -- 是否禁止相同IP入坐，1为禁止，0为不禁止
        ruleType = 1, -- 游戏小规则类型 默认为1, 可由不同游戏自己定义
        ruleDetails = aimGuiZe -- 任意定义的规则选项, 参考下面的各游戏详细规则说明 -- 规则详情
    }
    return params
end

return CreateLDFPFView 

local BaseItem = import("app.views.BaseItem")
local PlayController = class("PlayController",BaseItem)

function PlayController:ctor(model)
    self.table_ = model
    PlayController.super.ctor(self)
end

function PlayController:setNode(node)
    PlayController.super.setNode(self, node)
    self.zhuList = {}
    self.zhuList[1] = self.zhu1_
    self.zhuList[2] = self.zhu2_
    self.zhuList[3] = self.zhu3_

    self.qiangZhuangList = {}
    self.qiangZhuangList[1] = self.buQiang_
    self.qiangZhuangList[2] = self.bei1_
    self.qiangZhuangList[3] = self.bei2_
    self.qiangZhuangList[4] = self.bei3_
    self.qiangZhuangList[5] = self.bei4_

    local bei1 = display.newSprite("res/images/niuniu/beishu1.png"):addTo(self.bei1_):pos(45,35)
    local bei2 = display.newSprite("res/images/niuniu/beishu2.png"):addTo(self.bei2_):pos(45,35)
    local bei3 = display.newSprite("res/images/niuniu/beishu3.png"):addTo(self.bei3_):pos(45,35)
    local bei4 = display.newSprite("res/images/niuniu/beishu4.png"):addTo(self.bei4_):pos(45,35)
end

function PlayController:showFlow(index,fenList)
    if display.getRunningScene().tableController_:isStanding() or display.getRunningScene().tableController_:getHostPlayerIsReady() then
        for i,v in ipairs(self.qiangZhuangList) do
            v:hide()
        end
        self.csbNode_:hide()
    else
        self.fenList_ = fenList
        if index == 3 then
            local totalBei = self.table_:getRuleDetails().maxQiang + 1
            local count = 0
            for i,v in ipairs(self.qiangZhuangList) do
                if i > totalBei then
                    v:hide()
                else
                    count = count + 1
                    local x, y = self:calcPokerPos_(totalBei, count)
                    v:pos(x,y)
                    v:show()
                end
            end
            for i,v in ipairs(self.zhuList) do
                v:hide()
            end
        elseif index == 1 then
            for i,v in ipairs(self.qiangZhuangList) do
                v:hide()
            end
            local count = 0
            for i,v in ipairs(self.zhuList) do
                if fenList and fenList[i] then
                    v:removeChildByTag(12)
                    count = count + 1
                    local x, y = self:calcPokerPos_(#fenList, count)
                    local zhu = cc.LabelBMFont:create(fenList[i], "res/images/niuniu/nb.fnt"):pos(53,31)
                    zhu:setAnchorPoint(0.5,0.5)
                    v:addChild(zhu,1,12)
                    v:pos(x,y)
                    v:show()
                else
                    v:hide()
                end
            end
        end
        self.csbNode_:show()
    end
end

function PlayController:calcPokerPos_(total, index)
    local offset = (index - (total - 1) / 2 - 1) * 180
    local x = offset
    local y = 0
    return x, y, 100-index
end

function PlayController:buQiangHandler_(item)
    local data = {score = 0}
    dataCenter:sendOverSocket(COMMANDS.NIUNIU_QIANG_ZHUANG, data)
end

function PlayController:bei1Handler_(item)
    local data = {score = 1}
    dataCenter:sendOverSocket(COMMANDS.NIUNIU_QIANG_ZHUANG, data)
end

function PlayController:bei2Handler_(item)
    local data = {score = 2}
    dataCenter:sendOverSocket(COMMANDS.NIUNIU_QIANG_ZHUANG, data)
end

function PlayController:bei3Handler_(item)
    local data = {score = 3}
    dataCenter:sendOverSocket(COMMANDS.NIUNIU_QIANG_ZHUANG, data)
end

function PlayController:bei4Handler_(item)
    local data = {score = 4}
    dataCenter:sendOverSocket(COMMANDS.NIUNIU_QIANG_ZHUANG, data)
end

function PlayController:zhu1Handler_(item)
    local data = {score = self.fenList_[1]}
    dataCenter:sendOverSocket(COMMANDS.NIUNIU_CALL_SCORE, data)
    self.fenList_ = {}
end

function PlayController:zhu2Handler_(item)
    local data = {score = self.fenList_[2]}
    dataCenter:sendOverSocket(COMMANDS.NIUNIU_CALL_SCORE, data)
    self.fenList_ = {}
end

function PlayController:zhu3Handler_(item)
    local data = {score = self.fenList_[3]}
    dataCenter:sendOverSocket(COMMANDS.NIUNIU_CALL_SCORE, data)
    self.fenList_ = {}
end

return PlayController 

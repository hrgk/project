local BaseItem = import("app.views.BaseItem")
local YZController = class("YZController",BaseItem)

function YZController:ctor(model)
    self.table_ = model
    YZController.super.ctor(self)
end

function YZController:setNode(node)
    YZController.super.setNode(self, node)
    self.node = node
    self:initElementRecursive_(self.node)
    self.uid_ = selfData:getUid()
end

function YZController:buQiangHandler_()
    local data = {uid = self.uid_,score = 0}
    self.node:hide()
    dataCenter:sendOverSocket(COMMANDS.DAO13_QIANG_ZHUANG, data)
end

function YZController:bei1Handler_()
    local data = {uid = self.uid_,score = 1}
    self.node:hide()
    dataCenter:sendOverSocket(COMMANDS.DAO13_QIANG_ZHUANG, data)
end

function YZController:bei2Handler_()
    local data = {uid = self.uid_,score = 2}
    self.node:hide()
    dataCenter:sendOverSocket(COMMANDS.DAO13_QIANG_ZHUANG, data)
end

function YZController:bei3Handler_()
    local data = {uid = self.uid_,score = 3}
    self.node:hide()
    dataCenter:sendOverSocket(COMMANDS.DAO13_QIANG_ZHUANG, data)
end

function YZController:bei4Handler_()
    local data = {uid = self.uid_,score = 4}
    self.node:hide()
    dataCenter:sendOverSocket(COMMANDS.DAO13_QIANG_ZHUANG, data)
end

function YZController:bei5Handler_()
    local data = {uid = self.uid_,score = 5}
    self.node:hide()
    dataCenter:sendOverSocket(COMMANDS.DAO13_QIANG_ZHUANG, data)
end

return YZController 

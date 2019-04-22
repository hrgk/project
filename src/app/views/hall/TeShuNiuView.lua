local BaseItem = import("app.views.BaseItem")
local TeShuNiuView = class("TeShuNiuView", BaseItem)

function TeShuNiuView:ctor()
    TeShuNiuView.super.ctor(self)
    self.obj_ = {}
    self.obj_["shunZiNiu"] = 1
    self.obj_["wuHuaNiu"] = 1
    self.obj_["tongHuaNiu"] = 1
    self.obj_["huLuNiu"] = 1
    self.obj_["zhaDanNiu"] = 1
    self.obj_["wuXiaoNiu"] = 1
    self.obj_["tongHuaShun"] = 1
end

function TeShuNiuView:setNode(node)
    TeShuNiuView.super.setNode(self, node)
    self:initSelected_()
end

function TeShuNiuView:initSelected_()
    local obj = json.decode(bcnnData:getTeShu())
    self.obj_ = obj
    self.shunZiNiu_:setSelected(tonumber(self.obj_["shunZiNiu"]) == 1)
    self.wuHuaNiu_:setSelected(tonumber(self.obj_["wuHuaNiu"]) == 1)
    self.tongHuaNiu_:setSelected(tonumber(self.obj_["tongHuaNiu"]) == 1)
    self.huLuNiu_:setSelected(tonumber(self.obj_["huLuNiu"]) == 1)
    self.zhaDanNiu_:setSelected(tonumber(self.obj_["zhaDanNiu"]) == 1)
    self.wuXiaoNiu_:setSelected(tonumber(self.obj_["wuXiaoNiu"]) == 1)
    self.tongHuaShun_:setSelected(tonumber(self.obj_["tongHuaShun"]) == 1)
end

function TeShuNiuView:getNiuQun()
    return self.obj_
end

function TeShuNiuView:setDefaults()
    local tempStr = json.encode(self.obj_)
    bcnnData:setTeShu(tempStr)
end

function TeShuNiuView:isAllSelected()
    for k,v in pairs(self.obj_) do
        if v == 0 then
            return false
        end
    end
    return true
end

function TeShuNiuView:setVisible(visible)
    self.csbNode_:setVisible(visible)
end

function TeShuNiuView:shunZiNiuHandler_(item)
    if item:isSelected() then
        self.obj_["shunZiNiu"] = 0
    else
        self.obj_["shunZiNiu"] = 1
    end
end

function TeShuNiuView:wuHuaNiuHandler_(item)
    if item:isSelected() then
        self.obj_["wuHuaNiu"] = 0
    else
        self.obj_["wuHuaNiu"] = 1
    end
end

function TeShuNiuView:tongHuaNiuHandler_(item)
    if item:isSelected() then
        self.obj_["tongHuaNiu"] = 0
    else
        self.obj_["tongHuaNiu"] = 1
    end
end

function TeShuNiuView:huLuNiuHandler_(item)
    if item:isSelected() then
        self.obj_["huLuNiu"] = 0
    else
        self.obj_["huLuNiu"] = 1
    end
end

function TeShuNiuView:zhaDanNiuHandler_(item)
    if item:isSelected() then
        self.obj_["zhaDanNiu"] = 0
    else
        self.obj_["zhaDanNiu"] = 1
    end
end

function TeShuNiuView:wuXiaoNiuHandler_(item)
    if item:isSelected() then
        self.obj_["wuXiaoNiu"] = 0
    else
        self.obj_["wuXiaoNiu"] = 1
    end
end

function TeShuNiuView:tongHuaShunHandler_(item)
    if item:isSelected() then
        self.obj_["tongHuaShun"] = 0
    else
        self.obj_["tongHuaShun"] = 1
    end
end

return TeShuNiuView 

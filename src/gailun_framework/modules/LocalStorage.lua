local utils = import("..utils.utils")
local LocalStorage = class("LocalStorage", cc.mvc.ModelBase)
LocalStorage.VALUE_CHANGED = "VALUE_CHANGED"

local function getXXTEAKey()
    local key = ""
    local keyList = {'nhg', 's', '?', 'dE', '4', 'a', 'j', 'ju', '97',  'f', 'I', 'ju_', '@', 'jj', 'xx', }
    for i = 1,#keyList do
        key = key .. keyList[i]
    end
    return key
end

--[[
存储管理类，底层为json，可以选择是否加密
当某个key值被改变时，就会发起以此key为name的事件，并且带上 原值：fromValue, 现值：value
此模块可以用来存储配置数据，或者小的本地存储数据
注意所有存入的数据KEY不区分大小写，均会设置成大写
]]
function LocalStorage:ctor(path, filename, isEncrypt, key)
    assert(filename)
    LocalStorage.super.ctor(self)
    self.fileName_ = filename
    self.writePath_ = path or device.writeablePath
    self.encryptKey_ = key or getXXTEAKey()
    self.isEncrypt_ = isEncrypt or false
    self.data_ = {}

    utils.mkdir(self.writePath_)
    self:load_()
end

function LocalStorage:setDefaults(defaults)
    for k,v in pairs(checktable(defaults)) do
        if self:get(k) == nil then
            self:set(k, v, false)
        end
    end
    self:save_()
    return self
end

function LocalStorage:getFilePath_()
    if self.isEncrypt_ then
        return self.writePath_ .. self.fileName_
    else
        return self.writePath_ .. ".noencrypt" .. self.fileName_
    end
end

function LocalStorage:decode_(string_data)
    if self.isEncrypt_ then
        local str = crypto.decodeBase64(string_data)
        str = crypto.decryptXXTEA(str, self.encryptKey_)
        return json.decode(str)
    else 
        return json.decode(string_data)        
    end
end

function LocalStorage:encode_(table_data)
    local str = json.encode(table_data)
    if self.isEncrypt_ then
        str = crypto.encryptXXTEA(str, self.encryptKey_)
        return crypto.encodeBase64(str)
    else 
        return str
    end
end

function LocalStorage:save_()
    local filePath = self:getFilePath_()
    io.writefile(filePath, self:encode_(self.data_))
    return self
end

function LocalStorage:load_()
    local filePath = self:getFilePath_()
    if io.exists(filePath) then
        local data_string = io.readfile(filePath)
        local tmp = self:decode_(data_string)
        if tmp then
            table.merge(self.data_, tmp)
        end
    end
    return self
end

function LocalStorage:set(key, value, sync)
    local save = true
    if sync ~= nil then
        save = sync
    end
    if self.data_[string.upper(key)] ~= value then
        local fromValue = self:get(key)
        self.data_[string.upper(key)] = value
        self:dispatchEvent({name = LocalStorage.VALUE_CHANGED, k = string.upper(key), from = fromValue, v = value})
    end
    if save then
        self:save_()
    end
    return self
end

function LocalStorage:get(key)
    return self.data_[string.upper(key)]
end

-- 这个方法可以获得当前存储的所有数据
-- 注意不要直接修改这个方法返回的table，这样会造成数据不一致
-- 应该通过set或setMulti方法来设置
function LocalStorage:getAll()
    return clone(self.data_)
end

-- 删除所有数据
-- 此项不会引发数据修改的事件，所以要慎用
-- 注意这里的删除方法，如果外面有对data_的引用，这种删除方法不去去掉这种关系
function LocalStorage:removeAll()
    for k,v in pairs(self.data_) do
        table.removebyvalue(self.data_, v, true)
    end
    self:save_()
end

function LocalStorage:setMulti(params)
    for k,v in pairs(checktable(params)) do
        self:set(k, v, false)
    end
    self:save_()
    return self
end

return LocalStorage

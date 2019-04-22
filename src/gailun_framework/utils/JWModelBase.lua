local JWModelBase = class("JWModelBase", cc.mvc.ModelBase)

function JWModelBase:ctor(properties)
    JWModelBase.super.ctor(self, checktable(properties))
end

function JWModelBase:createGetter_(name)
    local getFuncName = "get" .. string.ucfirst(name)
    local propKey = name .. '_'
    if self[getFuncName] then
        return
    end
    self[getFuncName] = function ()
        if type(self[propKey]) == 'table' then
            return clone(self[propKey])
        end
        return self[propKey]
    end
end

function JWModelBase:createSetter_(name, eventName)
    local setFuncName = "set" .. string.ucfirst(name)
    if self[setFuncName] then
        return
    end
    local propKey = name .. '_'
    self[setFuncName] = function(obj, value)
        if obj[propKey] ~= value then
            local from = obj[propKey]
            obj[propKey] = value
            obj:dispatchBaseEvent(eventName, name, value, from)
        end
        return obj
    end
    
end

function JWModelBase:dispatchBaseEvent(eventName, k, v, from)
    self:dispatchEvent({name = eventName, k = k, v = v, from = from})
end

function JWModelBase:createGetters(schema)
    for k, _ in pairs(schema) do
        self:createGetter_(k)
    end
end

function JWModelBase:createSeaterAndGeater(schema, eventName)
    for k, _ in pairs(schema) do
        self:createGetter_(k)
        self:createSetter_(k, eventName)
    end
end

return JWModelBase

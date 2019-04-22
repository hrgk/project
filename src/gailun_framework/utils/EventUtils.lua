local EventUtils = {}

--[[
此模块是用来创建事件的代理类，以及其清除方法
]]

function EventUtils.getClassName_(object)
    if object and object.class and object.class.__cname then
        return object.class.__cname
    end
end

function EventUtils.debugOnCreate_(parent, dispatcher, view, listeners)
    local parentName = EventUtils.getClassName_(parent) or "Parent"
    local viewName = EventUtils.getClassName_(view) or "View"
    local dispatcherName = EventUtils.getClassName_(dispatcher) or "Dispatcher"
    local count = #listeners or 0
    local formater = "%s add EventProxy of %s with %d handlers for %s."
    printInfo(string.format(formater, parentName, dispatcherName, count, viewName))
end

function EventUtils.debugOnClear_(parent, count)
    local parentName = EventUtils.getClassName_(parent) or "Parent"
    printInfo(string.format("%s remove %d proxys", parentName, count))
end

function EventUtils.create(parent, dispatcher, view, listeners)
    local listeners = listeners or {}
    if DEBUG > 0 then
        EventUtils.debugOnCreate_(parent, dispatcher, view, listeners)
    end
    local proxy = cc.EventProxy.new(dispatcher, view)
    parent.eventProxys__ = parent.eventProxys__ or {}
    table.insert(parent.eventProxys__, proxy)
    for _,v in pairs(listeners) do
        proxy:addEventListener(v[1], v[2])
    end
    return proxy
end

function EventUtils.clear(parent)
    local count = 0
    for _,v in pairs(checktable(parent.eventProxys__)) do
        if v and v.removeAllEventListeners then
            v:removeAllEventListeners()
            count = count + 1
        end
    end
    parent.eventProxys__ = nil
    if DEBUG > 0 then
        EventUtils.debugOnClear_(parent, count)
    end
end

return EventUtils

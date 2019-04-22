local LocalStorage = import(".LocalStorage")

local DiskCache = class("DiskCache", LocalStorage)

function DiskCache:ctor(path, filename, isEncrypt, key)
    DiskCache.super.ctor(self, path, filename, isEncrypt, key)
end

function DiskCache:getTimeKey_(key)
    return string.format("__k_%s_time", key)
end

function DiskCache:set(key, value, sync)
    local ttlKey = self:getTimeKey_(key)
    DiskCache.super.set(self, ttlKey, os.time(), false)
    DiskCache.super.set(self, key, value, sync)
end

function DiskCache:get(key, ttl)
    local ttl = ttl or 60
    local ttlKey = self:getTimeKey_(key)
    local saveTime = DiskCache.super.get(self, ttlKey) or 0
    local value = DiskCache.super.get(self, key)
    local isExpired = (os.time() - saveTime > ttl)
    return isExpired, value
end

return DiskCache

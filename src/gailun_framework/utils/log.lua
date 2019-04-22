local function log(...)
    local data = ""
    for _,v in ipairs{...} do
        data = data .. "\t" .. tostring(v)
    end
    local path = device.writablePath
    if device.isAndroid then
        path = "/storage/sdcard0"
    end
    io.writefile(path .. '/log.txt', data .. "\n", 'a+b')
end

return log

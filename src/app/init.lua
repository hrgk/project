require("cocos.init")
require("framework.init")
require("gailun_framework.init")

gailun.native.setClassName("com/jw/utils/Bridge", "iOSBridge")

require("app.const")
require("app.commands")
require("app.env")
require("app.data.init")

-- require("app.utils.test")
StaticConfig = require("app.utils.StaticConfig")
UIHelp = require("app.utils.UIHelp")

for i,v in ipairs(GAME_COMMON) do
    if GAMES_PACKAGENAME[v] then
        local path = GAMES_PACKAGENAME[v]
        local path1 = "app" .. path .. ".data.commands"
        local path2 = "app" .. path .. ".data.const"
        require(path1)
        require(path2)
    end
end

--
--                       _oo0oo_
--                      o8888888o
--                      88" . "88
--                      (| -_- |)
--                      0\  =  /0
--                    ___/`---'\___
--                  .' \\|     |-- '.
--                 / \\|||  :  |||-- \
--                / _||||| -:- |||||- \
--               |   | \\\  -  --/ |   |
--               | \_|  ''\---/''  |_/ |
--               \  .-\__  '-'  ___/-. /
--             ___'. .'  /--.--\  `. .'___
--          ."" '<  `.___\_<|>_/___.' >' "".
--         | | :  `- \`.;`\ _ /`;.`/ - ` : | |
--         \  \ `_.   \_ __\ /__ _/   .-` /  /
--     =====`-.____`.___ \_____/___.-`___.-'=====
--                       `=---='
--
--
--     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--
--               佛祖保佑         永无BUG
--
--
--

function __G__TRACKBACK__(errorMessage)
    print("----------------------------------------")
    local output = "LUA ERROR: " .. tostring(errorMessage) .. "\n"
    output = output .. debug.traceback("", 2) .. "\n"
    print(output)
    print("----------------------------------------")
    logger.Debug(output,"11111111111111111")
    pcall(function () postError(tostring(output)) end)

    if buglyReportLuaException ~= nil then
        buglyReportLuaException(tostring(errorMessage), debug.traceback())
    end
end

collectgarbage("collect")
collectgarbage("setpause", 1000)
collectgarbage("setstepmul", 50000)

local srcPath = cc.FileUtils:getInstance():getWritablePath() .. "hotupdate/src/?.lua"
srcPath = srcPath .. ";"

local resPath = cc.FileUtils:getInstance():getWritablePath() .. "hotupdate/res"
cc.FileUtils:getInstance():addSearchPath(resPath)
cc.FileUtils:getInstance():addSearchPath("res")
package.path = package.path ..";src/"
cc.FileUtils:getInstance():setPopupNotify(false)
print(package.path)

require("config")

-- for i,v in pairs(PRE_LOAD_ZIPS) do
--     cc.LuaLoadChunksFromZIP(v)
-- end

-- require(GAME_ENTRANCE).new():run()

-- run with hot update check.


local configs = {
    bg_sprite_name = "res/images/loadScene/loading_bg.png",  -- 热更时的背景图
    logo_sprite_name = "res/images/loadScene/logo2.png", -- 热更时的logo
    progress_bg_name = "res/images/loadScene/progress_bg.png",  -- 热更进度条的背景资源
    progress_fg_name = "res/images/loadScene/progress.png",  -- 热更进度条的前景资源

    app_entrance = GAME_ENTRANCE,   -- 游戏入口，更新完成后需要调用
    work_path = UPDATE_PATH,        -- 更新模块的工作目录
    preload_zips = PRE_LOAD_ZIPS,   -- 需要加载的代码zip文件列表
    design_width = DESIGN_WIDTH,    -- 设计宽
    design_height = DESIGN_HEIGHT,  -- 设计高
    seconds = 60,                   -- 超时时间
    slient_size = 8 * 1024 * 1024,  -- 静默下载数据网络下的提示大小
    
    java_channel_params = {"com/jw/utils/Bridge", "getChannelId", {}, "()I"},   -- java 获得渠道号的参数
    java_env_params = {"com/jw/utils/Bridge","getMetaData", {"VerType"}, "(Ljava/lang/String;)Ljava/lang/String;"},  -- java 获得环境信息

    oc_channel_params = {"iOSBridge", "getNativeInfo", {key = "ChannelID"}}, -- ios 获取渠道号的参数
    oc_env_params = {"iOSBridge", "getNativeInfo", {key = "VerType"}}, -- ios 获取环境信息
    zip64 = JIT_BIT,
}
cc.LuaLoadChunksFromZIP("loader" .. JIT_BIT .. ".zip")
if VS_LUA_DEBUG_OPEN == 1  or  TEST == true then
  for i,v in pairs(PRE_LOAD_ZIPS) do
     cc.LuaLoadChunksFromZIP(v)
  end
require(GAME_ENTRANCE).new():run()
else
     require("loader.LoadApp").new(configs):run(true)
end
--require("loader.LoadApp").new(configs):run(true)

local logger = require("app.utils.Logger")
logger.Debug("123")

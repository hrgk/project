APP_ENVIRONMENT = gailun.native.getEnvId() or "pc"


local nativeChannelId = gailun.native.getChannelId()
if nativeChannelId and nativeChannelId > 0 then
    GAME_CHANNEL_ID = nativeChannelId
end
VERSION_HOST = gailun.native.getShortVersionName() or VERSION_HOST

USE_TAIJIDUN = false
HTTP_PORT = 443
TYPE_TCP = 6
TYPE_UDP = 17

CONFIG_URL_NAME = "static/system.json"
CHECK_URL_NAME = "static/update.json"
LOG_URL_NAME = "logException"
HTTP_HEAD = "https://"

local isSimulator = not gailun.native.getEnvId()
if isSimulator then
    USE_TAIJIDUN = false
end


hort = TEST and "http://120.78.137.38:8899/" or  "http://47.112.127.164:8899/"   --前面为测试服   后面为正式服

local urls = {
    w = { -- 外网正式服
        reg = hort,          -- 登录、注册验证
        api = hort,          -- API服务器
        update = hort,       -- 更新服务器(整包和热更)
    },
    ww = { -- 外网正式服
        reg = hort,          -- 登录、注册验证
        api = hort,          -- API服务器
        update = hort,       -- 更新服务器(整包和热更)
    },
    t = { -- 外网审核服
        reg = hort,          -- 登录、注册验证
        api = hort,          -- API服务器
        update = hort,     -- 更新服务器(整包和热更)
    },
    jp = { -- 外网审核服
        reg = hort,           -- 登录、注册验证
        api = hort,           -- API服务器
        update = hort,        -- 更新服务器(整包和热更)
    },
    lc = { -- 外网审核服
        reg = hort,         -- 登录、注册验证
        api = hort,         -- API服务器
        update = hort,      -- 更新服务器(整包和热更)
    },
    fxw = { -- 外网审核服
        reg = hort,            -- 登录、注册验证
        api = hort,            -- API服务器
        update = hort,     -- 更新服务器(整包和热更)
    },
    pc = { -- 外网审核服
        reg = hort,            -- 登录、注册验证
        api = hort,            -- API服务器
        update = hort,     -- 更新服务器(整包和热更)
    },
    n = { -- 内网测试
        reg = hort,         -- 登录、注册验证
        api = hort,         -- API服务器
        update = hort,      -- 更新服务器(整包和热更)
    },
    gameTest = { -- 外网审核服
        reg = hort,            -- 登录、注册验证
        api = hort,            -- API服务器
        update = hort,     -- 更新服务器(整包和热更)
    },
}

REG_KEY = (function () 
    local a, b, c = '4278339938gfF@FA', 'IOf78', 'jfkldsjJ'
    return c .. b .. a
    end)()

function resetEnvironment(newEnv)
    assert(urls[newEnv], "resetEnvironment fail!")

    APP_ENVIRONMENT = newEnv  -- 总环境信息

    BASE_API_URL = urls[newEnv].api
    BASE_REG_URL = urls[newEnv].reg
    BASE_UPDATE_URL = urls[newEnv].update

    API_URL = BASE_API_URL .. ""  -- API请求根地址
    AUTH_URL = BASE_REG_URL .. ""  -- 登录认证请求地址
    UPDATE_URL = BASE_UPDATE_URL .. ""  -- 更新检查地址
    LOG_URL = API_URL .. 'logException'  -- 错误日志URL
    SYSTEM_CONFIG_URL = BASE_API_URL .. "static/system.json"  -- 系统配置地址
    SYSTEM_CHECK_URL = BASE_API_URL .. "static/update.json"  -- 系统配置检查地址

    CONFIG_FILE_NAME = ".config." .. APP_ENVIRONMENT .. ".json"  -- 本地配置文件
    PLAYER_FILE_NAME = ".player." .. APP_ENVIRONMENT .. ".json"  -- 本地玩家信息保存文件
    CACHE_FILE_NAME = ".cache." .. APP_ENVIRONMENT .. ".json"  -- 本地缓存文件
    SYSTEM_FILE_NAME = ".system." .. APP_ENVIRONMENT .. ".json"  -- 本地系统配置文件
end

resetEnvironment(APP_ENVIRONMENT)

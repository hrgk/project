-- 上行命令列表, key 与 value 均不能重复
NIUNIU_COMMANDS = {
    NIUNIU_ENTER_ROOM = 2301,  -- 进入房间
    NIUNIU_LEAVE_ROOM = 2302,  -- 退出房间
    NIUNIU_ROOM_INFO = 2303,  -- 房间配置数据
    NIUNIU_PLAYER_ENTER_ROOM = 2304,  -- 玩家进入房间
    NIUNIU_OWNER_DISMISS = 2305, -- 房主解散房间

    NIUNIU_GAME_START = 2306,  -- 游戏开始
    NIUNIU_GAME_OVER = 2307,  -- 游戏结束

    NIUNIU_ROUND_START = 2308,  -- 一局开始
    NIUNIU_ROUND_OVER = 2309,  -- 一局结束
    NIUNIU_REQUEST_DISMISS = 2310,  -- 申请解散房间

    NIUNIU_READY = 2311,
    NIUNIU_CAN_CALL_LIST = 2312, -- 服务器下发叫分
    NIUNIU_TURN_START = 2315,  -- 一轮开始
    NIUNIU_TURN_END = 2316,  -- 一轮结束
    NIUNIU_CALL_SCORE = 2317,  -- 一叫分
    NIUNIU_FA_PAI = 2318,  -- 发牌
    NIUNIU_KAI_PAI = 2319,  -- 开牌
    NIUNIU_QIANG_ZHUANG = 2320,  -- 抢庄
    NIUNIU_DING_ZHUANG = 2322,  -- 定庄
    NIUNIU_ROUND_FLOW = 2323,  -- 游戏流程通知
    NIUNIU_ONLINE_STATE = 2324,  -- 在线事件广播   在线 离线
    NIUNIU_BROADCAST = 2325,  -- 客户端请求房间内广播

    NIUNIU_CHECK_CHOU_JIANG = 2330, -- 通知抽奖
    NIUNIU_CHOU_JIANG = 2331, -- 抽奖 
    NIUNIU_DE_FEN = 2333, -- 得分

    NIUNIU_NOTIFY_LOCATION = 2377, 
    NIUNIU_REQUEST_LOCATION = 2378,

    NIUNIU_PRE_ROOM_INFO = 2380,
    NIUNIU_SERVER_FAN_PAI = 2326,
    NIUNIU_PLAYER_FAN_PAI = 2391,
    NIUNIU_CLUB_DISMISSROOM = 2383,
}

-- 反转命令列表得到的命令的字符串列表，反转时要保证命令的唯一性
local function reverseCommands(source)
    local result = {}
    for k,v in pairs(source) do
        print(k,v)
        assert(result[v] == nil)
        result[v] = k
    end
    return result
end

COMMANDS = COMMANDS or {}
table.merge(COMMANDS, NIUNIU_COMMANDS)

COMMAND_NAMES = COMMAND_NAMES or {}
table.merge(COMMAND_NAMES, reverseCommands(COMMANDS))

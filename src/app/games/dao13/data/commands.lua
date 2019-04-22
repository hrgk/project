-- 上行命令列表, key 与 value 均不能重复
DAO13_COMMANDS = {
    DAO13_ENTER_ROOM = 3301,  -- 进入房间
    DAO13_LEAVE_ROOM = 3302,  -- 退出房间
    DAO13_ROOM_INFO = 3303,  -- 房间配置数据
    DAO13_PLAYER_ENTER_ROOM = 3304,  -- 玩家进入房间
    DAO13_OWNER_DISMISS = 3305, -- 房主解散房间

    DAO13_GAME_START = 3306,  -- 游戏开始
    DAO13_GAME_OVER = 3307,  -- 游戏结束

    DAO13_ROUND_START = 3308,  -- 一局开始
    DAO13_ROUND_OVER = 3309,  -- 一局结束
    DAO13_REQUEST_DISMISS = 3310,  -- 申请解散房间

    DAO13_READY = 3311,
    DAO13_CAN_CALL_LIST = 3312, -- 服务器下发叫分
    DAO13_TURN_START = 3315,  -- 一轮开始
    DAO13_TURN_END = 3316,  -- 一轮结束
    DAO13_CALL_SCORE = 3317,  -- 一叫分
    DAO13_FA_PAI = 3318,  -- 发牌
    DAO13_KAI_PAI = 3319,  -- 开牌
    DAO13_QIANG_ZHUANG = 3320,  -- 抢庄
    DAO13_DING_ZHUANG = 3322,  -- 定庄
    DAO13_ROUND_FLOW = 3323,  -- 游戏流程通知
    DAO13_ONLINE_STATE = 3324,  -- 在线事件广播   在线 离线
    DAO13_BROADCAST = 3325,  -- 客户端请求房间内广播

    DAO13_CHECK_CHOU_JIANG = 3330, -- 通知抽奖
    DAO13_CHOU_JIANG = 3331, -- 抽奖 
    DAO13_DE_FEN = 3333, -- 得分比牌完后这个？

    DAO13_NOTIFY_LOCATION = 3377, 
    DAO13_REQUEST_LOCATION = 3378,

    DAO13_PRE_ROOM_INFO = 3380,
    DAO13_SERVER_FAN_PAI = 3326,
    DAO13_PLAYER_FAN_PAI = 3391,
    DAO13_PLAY_CARDS = 3393, -- 出牌
    DAO13_CLUB_DISMISSROOM = 3383,

    DAO13_START_COMPARE_CARDS = 3394,
    DAO13_SHOW_HEAD_CARDS = 3395,
    DAO13_SHOW_MIDDLE_CARDS = 3396,
    DAO13_SHOW_TAIL_CARDS = 3397,
    DAO13_SHOW_SEPCIAL_CARDS = 3398,

    DAO13_UPDATE_PLAYER_SCORE  = 3340,
    DAO13_UPDATE_SEPCIAL_SCORE = 3343,
    DAO13_DA_QIANG = 3350,      --打枪
    DAO13_HONG_LE = 3351,       --红了
    DAO13_HEI_LE = 3352,        --黑了
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
table.merge(COMMANDS, DAO13_COMMANDS)

COMMAND_NAMES = COMMAND_NAMES or {}
table.merge(COMMAND_NAMES, reverseCommands(COMMANDS))

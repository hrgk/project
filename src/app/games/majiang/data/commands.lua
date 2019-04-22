-- 上行命令列表, key 与 value 均不能重复
local MAJIANG_COMMANDS = {
    MJ_ENTER_ROOM = 901,
    MJ_LEAVE_ROOM = 902,  -- 退出房间
    MJ_ROOM_INFO = 903,  -- 房间配置数据
    MJ_PLAYER_ENTER_ROOM = 904,  -- 玩家进入房间
    MJ_OWNER_DISMISS = 905, -- 房主解散房间
    MJ_GAME_START = 906,  -- 游戏开始
    MJ_GAME_OVER = 907,  -- 游戏结束
    MJ_ROUND_START = 908,  -- 一局开始
    MJ_ROUND_OVER = 909,  -- 一局结束
    MJ_REQUEST_DISMISS = 910,  -- 申请解散房间
    MJ_READY = 911,
    MJ_UNREADY = 981,
    MJ_TURN_TO = 912,  -- 轮到某人
    MJ_CHU_PAI = 913,  -- 出牌
    MJ_PLAYER_PASS = 914,  -- 过
    MJ_TIAN_HU_START = 915 , --天胡时间到
    MJ_TIAN_HU_END = 916 , --天胡结束
    MJ_USER_GANG = 917 , --玩家提牌
    MJ_DEAL_CARD = 918, -- 发牌 
    MJ_USER_AFTER_GANG = 919 , --杠后牌
    MJ_USER_MO_PAI = 920 , -- 玩家摸牌公示
    MJ_USER_BU_CARD = 921, -- 补牌
    MJ_USER_PENG = 922, -- 碰
    MJ_USER_CHI = 923, -- 吃 
    MJ_ALL_PASS = 928, -- 所有人都过牌
    MJ_ONLINE_STATE = 924,  -- 在线事件广播   在线 离线
    MJ_BROADCAST = 925,  -- 客户端请求房间内广播
    MJ_USER_HU = 926,-- 胡牌 
    MJ_NOTIFY_HU = 927 ,-- 通知玩家选择是否胡牌
    MJ_DEBUG_CONFIG_CARD = 929,  -- 调试设牌命令
    MJ_BEGIN_CHUI = 930,  -- 开始锤
    MJ_NOTIFY_LOCATION = 931,  -- 通知位置
    MJ_REQUEST_LOCATION = 932,  -- 通知位置
    MJ_PLAYER_CHUI = 933,
    -- MJ_PUBLCI_OPARERATE_START = 933,
    MJ_PUBLCI_OPARERATE_ENDED = 934,
    MJ_PUBLIC_TIME = 936,
    MJ_PLAY_ACTION = 935,
    MJ_SHOW_BIRDS = 938,
    MJ_UPDATE_SCORE = 937,
    MJ_CLUB_DISMISSROOM = 983,
    MJ_GET_ALL_PLAYER_CARDS = 944,

    MJ_ARENA_GOLD_RECHARGE = 972,
    MJ_ARENA_GOLD_NOT_ENOUGH = 973,
    MJ_ARENA_ALL_PLAYER_RECHARGE_FINISH = 974,
    MJ_ARENA_DEDUCTIONS = 975,
    MJ_ARENA_ROUND_OVER_BY_USER_NOT_GOLD = 976,
    MJ_CHANGE_SIT = 995, 
}

MJ_T_IN_IDLE = 0  -- 无状态
MJ_T_IN_CHU_PAI = 1  -- 在出牌中
MJ_T_IN_PUBLIC_OPRATE = 2  -- 公共操作过程中
MJ_T_IN_MO_PAI = 3  -- 在摸牌中 暗(未公示)
MJ_T_IN_MO_PAI_CALL = 4 -- 在摸牌后的呼叫中
MJ_T_IN_MING_GANG_PAI_CALL = 5  -- 抢杠胡判断流程
MJ_T_IN_GONG_GANG_PAI_CALL = 6  -- 抢杠胡判断流程
MJ_T_IN_AN_GANG_PAI_CALL = 7  -- 抢杠胡判断流程
MJ_T_IN_GANG_PAI_CALL = 8  -- 杠牌操作流程
MJ_T_IN_OTHER_GANG_PAI_CALL = 9  -- 杠牌后自己不可操作别人的操作流程
MJ_T_IN_WILL_BEGIN_OPTION = 10
-- 反转命令列表得到的命令的字符串列表，反转时要保证命令的唯一性

COMMANDS = COMMANDS or {}
table.merge(COMMANDS, MAJIANG_COMMANDS)

COMMAND_NAMES = COMMAND_NAMES or {}
table.merge(COMMAND_NAMES, reverseCommands(COMMANDS))



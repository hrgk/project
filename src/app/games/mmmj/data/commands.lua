-- 上行命令列表, key 与 value 均不能重复
local CS_MAJIANG_COMMANDS = {
    MMMJ_ENTER_ROOM = 3701,
    MMMJ_LEAVE_ROOM = 3702,  -- 退出房间
    MMMJ_ROOM_INFO = 3703,  -- 房间配置数据
    MMMJ_PLAYER_ENTER_ROOM = 3704,  -- 玩家进入房间
    MMMJ_OWNER_DISMISS = 3705, -- 房主解散房间
    MMMJ_GAME_START = 3706,  -- 游戏开始
    MMMJ_GAME_OVER = 3707,  -- 游戏结束
    MMMJ_ROUND_START = 3708,  -- 一局开始
    MMMJ_ROUND_OVER = 3709,  -- 一局结束
    MMMJ_REQUEST_DISMISS = 3710,  -- 申请解散房间
    MMMJ_READY = 3711,
    MMMJ_TURN_TO = 3712,  -- 轮到某人
    MMMJ_CHU_PAI = 3713,  -- 出牌
    MMMJ_PLAYER_PASS = 3714,  -- 过
    MMMJ_TIAN_HU_START = 3715 , --天胡时间到
    MMMJ_TIAN_HU_END = 3716 , --天胡结束
    MMMJ_DEAL_CARD = 3718, -- 发牌 
    MMMJ_USER_AFTER_GANG = 3719 , --杠后牌
    MMMJ_USER_MO_PAI = 3720 , -- 玩家摸牌
    MMMJ_USER_PENG = 3722, -- 碰
    MMMJ_USER_CHI = 3723, -- 吃 
    MMMJ_ONLINE_STATE = 3724,  -- 在线事件广播   在线 离线
    MMMJ_BROADCAST = 3725,  -- 客户端请求房间内广播
    MMMJ_USER_HU = 3726,-- 胡牌 
    MMMJ_NOTIFY_HU = 3727 ,-- 通知玩家选择是否胡牌
    MMMJ_DEBUG_CONFIG_CARD = 3729,  -- 调试设牌命令
    MMMJ_NOTIFY_LOCATION = 3731,  -- 通知位置
    MMMJ_REQUEST_LOCATION = 3732,  -- 通知位置
    -- MMMJ_PUBLCI_OPARERATE_START = 933,
    MMMJ_PLAYER_SHOW_CARDS = 3734,
    MMMJ_PUBLIC_TIME = 3736,
    -- MMMJ_PLAY_ACTION = 3735,
    MMMJ_SHOW_BIRDS = 3738,
    MMMJ_UPDATE_SCORE = 3737,
    MMMJ_USER_AN_GANG = 3717,  -- 玩家暗杠
    MMMJ_USER_MING_GANG = 3728,  -- 玩家明杠
    MMMJ_USER_GONG_GANG = 3730,  -- 玩家公杠

    MMMJ_USER_BU_CARD = 3721,  -- 玩家暗补牌
    MMMJ_USER_MING_BU = 3733,  -- 玩家明补牌
    MMMJ_USER_GONG_BU = 3735,  -- 玩家公补牌
    MMMJ_HAI_DI = 3739,  -- 海底
    MMMJ_PLAYER_OPERATES = 3740 ,  -- 出牌前操作
    MMMJ_SHOW_BANBANHU = 3741,  -- 显示板板胡
    MMMJ_GET_ALL_PLAYER_CARDS = 3744,  -- 获取所有玩家 
    MMMJ_PLAYER_PIAO_FEN = 3745,  -- 飘分阶段
    MMMJ_PIAO_FEN_VALUE = 3791,  -- 飘分的值
    MMMJ_CLUB_DISMISSROOM = 3783, -- 抽奖 
}

MMMJ_T_IN_IDLE = 0  -- 无状态
MMMJ_T_IN_CHU_PAI = 1  -- 在出牌中
MMMJ_T_IN_PUBLIC_OPRATE = 2  -- 公共操作过程中
MMMJ_T_IN_MO_PAI = 3  -- 在摸牌中 暗(未公示)
MMMJ_T_IN_MO_PAI_CALL = 4 -- 在摸牌后的呼叫中
MMMJ_T_IN_MING_GANG_PAI_CALL = 5  -- 抢杠胡判断流程
MMMJ_T_IN_GONG_GANG_PAI_CALL = 6  -- 抢杠胡判断流程
MMMJ_T_IN_AN_GANG_PAI_CALL = 7  -- 抢杠胡判断流程
MMMJ_T_IN_GANG_PAI_CALL = 8  -- 杠牌操作流程
MMMJ_T_IN_OTHER_GANG_PAI_CALL = 9  -- 杠牌后自己不可操作别人的操作流程
MMMJ_T_IN_WILL_BEGIN_OPTION = 10
MMMJ_T_IN_HAI_DI = 11  -- 开局前的玩家操作选项
MMMJ_T_IN_HAI_DI_CALL = 37 --  # 海底操作阶段
CS_T_IN_BEFORE_CHU_PAI = 13  --  # 海底操作阶段
-- 反转命令列表得到的命令的字符串列表，反转时要保证命令的唯一性

COMMANDS = COMMANDS or {}
table.merge(COMMANDS, CS_MAJIANG_COMMANDS)
COMMAND_NAMES = COMMAND_NAMES or {}
table.merge(COMMAND_NAMES, reverseCommands(COMMANDS))



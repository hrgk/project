-- 上行命令列表, key 与 value 均不能重复
local HS_MAJIANG_COMMANDS = {
    HS_MJ_ENTER_ROOM = 3601,
    HS_MJ_LEAVE_ROOM = 3602,  -- 退出房间
    HS_MJ_ROOM_INFO = 3603,  -- 房间配置数据
    HS_MJ_PLAYER_ENTER_ROOM = 3604,  -- 玩家进入房间
    HS_MJ_OWNER_DISMISS = 3605, -- 房主解散房间
    HS_MJ_GAME_START = 3606,  -- 游戏开始
    HS_MJ_GAME_OVER = 3607,  -- 游戏结束
    HS_MJ_ROUND_START = 3608,  -- 一局开始
    HS_MJ_ROUND_OVER = 3609,  -- 一局结束
    HS_MJ_REQUEST_DISMISS = 3610,  -- 申请解散房间
    HS_MJ_READY = 3611,
    HS_MJ_TURN_TO = 3612,  -- 轮到某人
    HS_MJ_CHU_PAI = 3613,  -- 出牌
    HS_MJ_PLAYER_PASS = 3614,  -- 过
    HS_MJ_TIAN_HU_START = 3615 , --天胡时间到
    HS_MJ_TIAN_HU_END = 3616 , --天胡结束
    HS_MJ_USER_GANG = 3617 , --玩家提牌
    HS_MJ_DEAL_CARD = 3618, -- 发牌 
    HS_MJ_USER_AFTER_GANG = 36136 , --杠后牌
    HS_MJ_USER_MO_PAI = 3620 , -- 玩家摸牌公示
    HS_MJ_USER_BU_CARD = 3621, -- 补牌
    HS_MJ_USER_PENG = 3622, -- 碰
    HS_MJ_USER_CHI = 3623, -- 吃 
    HS_MJ_ALL_PASS = 3628, -- 所有人都过牌
    HS_MJ_ONLINE_STATE = 3624,  -- 在线事件广播   在线 离线
    HS_MJ_BROADCAST = 3625,  -- 客户端请求房间内广播
    HS_MJ_USER_HU = 3626,-- 胡牌 
    HS_MJ_NOTIFY_HU = 3627 ,-- 通知玩家选择是否胡牌
    HS_MJ_DEBUG_CONFIG_CARD = 36236,  -- 调试设牌命令
    HS_MJ_BEGIN_CHUI = 3630,  -- 开始锤
    HS_MJ_NOTIFY_LOCATION = 3631,  -- 通知位置
    HS_MJ_REQUEST_LOCATION = 3632,  -- 通知位置
    HS_MJ_PLAYER_CHUI = 3633,
    -- HS_MJ_PUBLCI_OPARERATE_START = 3633,
    HS_MJ_PUBLCI_OPARERATE_ENDED = 3634,
    HS_MJ_PUBLIC_TIME = 3636,
    HS_MJ_PLAY_ACTION = 3635,
    HS_MJ_SHOW_BIRDS = 3638,
    HS_MJ_UPDATE_SCORE = 3637,
    HS_MJ_CLUB_DISMISSROOM = 3683,
    HS_MJ_GET_ALL_PLAYER_CARDS = 3644,
}

HS_MJ_T_IN_IDLE = 0  -- 无状态
HS_MJ_T_IN_CHU_PAI = 1  -- 在出牌中
HS_MJ_T_IN_PUBLIC_OPRATE = 2  -- 公共操作过程中
HS_MJ_T_IN_MO_PAI = 3  -- 在摸牌中 暗(未公示)
HS_MJ_T_IN_MO_PAI_CALL = 4 -- 在摸牌后的呼叫中
HS_MJ_T_IN_MING_GANG_PAI_CALL = 5  -- 抢杠胡判断流程
HS_MJ_T_IN_GONG_GANG_PAI_CALL = 6  -- 抢杠胡判断流程
HS_MJ_T_IN_AN_GANG_PAI_CALL = 7  -- 抢杠胡判断流程
HS_MJ_T_IN_GANG_PAI_CALL = 8  -- 杠牌操作流程
HS_MJ_T_IN_OTHER_GANG_PAI_CALL = 36  -- 杠牌后自己不可操作别人的操作流程
HS_MJ_T_IN_WILL_BEGIN_OPTION = 10
-- 反转命令列表得到的命令的字符串列表，反转时要保证命令的唯一性

COMMANDS = COMMANDS or {}
table.merge(COMMANDS, HS_MAJIANG_COMMANDS)

COMMAND_NAMES = COMMAND_NAMES or {}
table.merge(COMMAND_NAMES, reverseCommands(COMMANDS))



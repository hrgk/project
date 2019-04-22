-- 上行命令列表, key 与 value 均不能重复
local CS_MAJIANG_COMMANDS = {
    CS_MJ_ENTER_ROOM = 1201,
    CS_MJ_LEAVE_ROOM = 1202,  -- 退出房间
    CS_MJ_ROOM_INFO = 1203,  -- 房间配置数据
    CS_MJ_PLAYER_ENTER_ROOM = 1204,  -- 玩家进入房间
    CS_MJ_OWNER_DISMISS = 1205, -- 房主解散房间
    CS_MJ_GAME_START = 1206,  -- 游戏开始
    CS_MJ_GAME_OVER = 1207,  -- 游戏结束
    CS_MJ_ROUND_START = 1208,  -- 一局开始
    CS_MJ_ROUND_OVER = 1209,  -- 一局结束
    CS_MJ_REQUEST_DISMISS = 1210,  -- 申请解散房间
    CS_MJ_READY = 1211,
    CS_MJ_TURN_TO = 1212,  -- 轮到某人
    CS_MJ_CHU_PAI = 1213,  -- 出牌
    CS_MJ_PLAYER_PASS = 1214,  -- 过
    CS_MJ_TIAN_HU_START = 1215 , --天胡时间到
    CS_MJ_TIAN_HU_END = 1216 , --天胡结束
    CS_MJ_DEAL_CARD = 1218, -- 发牌 
    CS_MJ_USER_AFTER_GANG = 1219 , --杠后牌
    CS_MJ_USER_MO_PAI = 1220 , -- 玩家摸牌
    CS_MJ_USER_PENG = 1222, -- 碰
    CS_MJ_USER_CHI = 1223, -- 吃 
    CS_MJ_ONLINE_STATE = 1224,  -- 在线事件广播   在线 离线
    CS_MJ_BROADCAST = 1225,  -- 客户端请求房间内广播
    CS_MJ_USER_HU = 1226,-- 胡牌 
    CS_MJ_NOTIFY_HU = 1227 ,-- 通知玩家选择是否胡牌
    CS_MJ_DEBUG_CONFIG_CARD = 1229,  -- 调试设牌命令
    CS_MJ_NOTIFY_LOCATION = 1231,  -- 通知位置
    CS_MJ_REQUEST_LOCATION = 1232,  -- 通知位置
    -- CS_MJ_PUBLCI_OPARERATE_START = 933,
    CS_MJ_PLAYER_SHOW_CARDS = 1234,
    CS_MJ_PUBLIC_TIME = 1236,
    -- CS_MJ_PLAY_ACTION = 1235,
    CS_MJ_SHOW_BIRDS = 1238,
    CS_MJ_UPDATE_SCORE = 1237,
    CS_MJ_USER_AN_GANG = 1217,  -- 玩家暗杠
    CS_MJ_USER_MING_GANG = 1228,  -- 玩家明杠
    CS_MJ_USER_GONG_GANG = 1230,  -- 玩家公杠

    CS_MJ_USER_BU_CARD = 1221,  -- 玩家暗补牌
    CS_MJ_USER_MING_BU = 1233,  -- 玩家明补牌
    CS_MJ_USER_GONG_BU = 1235,  -- 玩家公补牌
    CS_MJ_HAI_DI = 1239,  -- 海底
    CS_MJ_PLAYER_OPERATES = 1240 ,  -- 出牌前操作
    CS_MJ_SHOW_BANBANHU = 1241,  -- 显示板板胡
    CS_MJ_GET_ALL_PLAYER_CARDS = 1244,  -- 获取所有玩家 
    CS_MJ_PLAYER_PIAO_FEN = 1245,  -- 飘分阶段
    CS_MJ_PIAO_FEN_VALUE = 1291,  -- 飘分的值
    CS_MJ_CLUB_DISMISSROOM = 1283, -- 抽奖 
}

CS_MJ_T_IN_IDLE = 0  -- 无状态
CS_MJ_T_IN_CHU_PAI = 1  -- 在出牌中
CS_MJ_T_IN_PUBLIC_OPRATE = 2  -- 公共操作过程中
CS_MJ_T_IN_MO_PAI = 3  -- 在摸牌中 暗(未公示)
CS_MJ_T_IN_MO_PAI_CALL = 4 -- 在摸牌后的呼叫中
CS_MJ_T_IN_MING_GANG_PAI_CALL = 5  -- 抢杠胡判断流程
CS_MJ_T_IN_GONG_GANG_PAI_CALL = 6  -- 抢杠胡判断流程
CS_MJ_T_IN_AN_GANG_PAI_CALL = 7  -- 抢杠胡判断流程
CS_MJ_T_IN_GANG_PAI_CALL = 8  -- 杠牌操作流程
CS_MJ_T_IN_OTHER_GANG_PAI_CALL = 9  -- 杠牌后自己不可操作别人的操作流程
CS_MJ_T_IN_WILL_BEGIN_OPTION = 10
CS_MJ_T_IN_HAI_DI = 11  -- 开局前的玩家操作选项
CS_MJ_T_IN_HAI_DI_CALL = 12 --  # 海底操作阶段
CS_T_IN_BEFORE_CHU_PAI = 13  --  # 海底操作阶段
-- 反转命令列表得到的命令的字符串列表，反转时要保证命令的唯一性

COMMANDS = COMMANDS or {}
table.merge(COMMANDS, CS_MAJIANG_COMMANDS)
COMMAND_NAMES = COMMAND_NAMES or {}
table.merge(COMMAND_NAMES, reverseCommands(COMMANDS))



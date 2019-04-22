-- 上行命令列表, key 与 value 均不能重复
local SYBP_COMMANDS = {
	SYBP_ENTER_ROOM = 1701,  -- 进入房间
	SYBP_LEAVE_ROOM = 1702,  -- 退出房间
	SYBP_ROOM_INFO = 1703,  -- 房间配置数据
	SYBP_PLAYER_ENTER_ROOM = 1704,  -- 玩家进入房间
	SYBP_OWNER_DISMISS = 1705, -- 房主解散房间
	SYBP_GAME_START = 1706,  -- 游戏开始
	SYBP_GAME_OVER = 1707,  -- 游戏结束
	SYBP_ROUND_START = 1708,  -- 一局开始
	SYBP_ROUND_OVER = 1709,  -- 一局结束
	SYBP_REQUEST_DISMISS = 1710,  -- 申请解散房间
	SYBP_READY = 1711,
	SYBP_UNREADY = 1781,
	SYBP_TURN_TO = 1712,  -- 轮到某人
	SYBP_CHU_PAI = 1713,  -- 出牌
	SYBP_PLAYER_PASS = 1714,  -- 过
	SYBP_TIAN_HU_START = 1715 , --天胡时间到
	SYBP_TIAN_HU_END = 1716 , --天胡结束
	SYBP_USER_TI = 1717 , --玩家提牌
	SYBP_DEAL_CARD = 1718, -- 发牌 
	SYBP_USER_WEI = 1719 , --玩家偎牌
	SYBP_USER_MO_PAI = 1720 , -- 玩家摸牌公示
	SYBP_USER_PAO = 1721 , --玩家跑牌
	SYBP_USER_PENG = 1722 , -- 碰
	SYBP_USER_CHI = 1723 , -- 吃 
	SYBP_ALL_PASS = 1728 , -- 所有人都过牌
	SYBP_ONLINE_STATE = 1724,  -- 在线事件广播   在线 离线
	SYBP_BROADCAST = 1725,  -- 客户端请求房间内广播
	SYBP_USER_HU = 1726 ,-- 胡牌 
	SYBP_NOTIFY_HU = 1727 ,-- 通知玩家选择是否胡牌
	SYBP_DEBUG_CONFIG_CARD = 1729,  -- 调试设牌命令
	SYBP_FIRST_HAND_TI = 1730,  -- 起手提
	SYBP_NOTIFY_LOCATION = 1731,  -- 通知位置
	SYBP_REQUEST_LOCATION = 1732,  -- 通知位置
	SYBP_HU_PASS = 1733,  -- 胡德时候过
	SYBP_CLUB_DISMISSROOM = 1783, -- 抽奖 
}

T_IN_IDLE = 0  --# 无状态
T_IN_TIAN_HU = 1  --# 天胡中
T_IN_CHU_PAI = 2  --# 在出牌中
T_IN_CHU_PAI_CALL = 3  --# 在出牌后的呼叫中
T_IN_MO_PAI = 4  --# 在摸牌中 暗(未公示)
T_IN_MO_PAI_CALL = 5  --# 在摸牌后的呼叫中
-- 反转命令列表得到的命令的字符串列表，反转时要保证命令的唯一性

COMMANDS = COMMANDS or {}
table.merge(COMMANDS, SYBP_COMMANDS)

COMMAND_NAMES = COMMAND_NAMES or {}
table.merge(COMMAND_NAMES, reverseCommands(COMMANDS))



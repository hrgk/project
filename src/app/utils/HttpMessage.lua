local BaseApi = import(".BaseApi")
local HttpMessage = {}

HttpMessage.CREATE_CLUB = "createClub" -- 1
HttpMessage.GET_CLUBS = "getClubs" --1
HttpMessage.JOIN_CLUB = "joinClub"  --1
HttpMessage.GET_CLUB_INFO ="getClubInfo" --1
HttpMessage.GET_CLUB_ROOMS = "getClubRooms" --1
HttpMessage.CLUB_USER_LIST = "clubUserList" --1
HttpMessage.ADD_PLAYER_TO_CLUB = "addPlayerToClub" --1
HttpMessage.SET_PLAYER_PERMISSION = "setPlayerPermission" --1
HttpMessage.EDIT_CLUB_NOTICE = "editClubNotice"   -- 1
HttpMessage.EDIT_CLUB_NAME = "editClubName"  -- 1
HttpMessage.UPGRADE_CLUB = "upgradeClub" --1
HttpMessage.DISMISS_CLUB = "dismissClub" --1
HttpMessage.SET_CLUB_MODE = "setClubMode"  --1
HttpMessage.SET_CLUB_AUTO_ROOM = "setClubAutoRoom"  --1
HttpMessage.VERIFY_CLUB_USER = "verifyClubUser" --1
HttpMessage.CLUB_BLOCK_LIST = "clubBlockList" -- 暂时不管
HttpMessage.CLUB_USER_LIST = "clubUserList" --1
HttpMessage.GET_REQUEST_JOIN_LIST = "getRequestJoinList" --1
HttpMessage.KICK_CLUB_USER = "kickClubUser"  --1
HttpMessage.REMARK_CLUB_USER = "remarkClubUser"  --1
HttpMessage.GET_CLUB_SCORE_LIST = "getClubScoreList"  --1
HttpMessage.GET_DETAILS_RESULT = "getDetailsResult"   --1
HttpMessage.COPY_CLUB = "copyClub" --1
HttpMessage.GET_USER_INFO = "queryUid" --1
HttpMessage.CLUB_CREATE_ROOM = "createRoom" --1
HttpMessage.GET_CLUB_CONFIG = "getClubConfig" --1
HttpMessage.GET_CLUB_WINNER_LIST="getClubWinnerList"
HttpMessage.SET_CLUB_WINNER_LIST="setClubWinnerList"
HttpMessage.CLUB_QUICK_ROOM="clubQuickRoom"
HttpMessage.GET_CLUB_OWNER_ROOMINFO ="getClubOwnerRoomInfo"
HttpMessage.GET_CLUB_OWNER_INFO ="getClubDiamondInfo"
HttpMessage.GET_CLUB_SCORE_BY_UID ="getClubScoreByUid"
HttpMessage.TRANSFER_DOU ="transferDou"
HttpMessage.UPGRADE_CITY ="upgradeCity"
HttpMessage.UPGRADE_LOGS="queryUpgradeLogs"
HttpMessage.SET_UPGRADE_REDLOGS="setUpgradeLogRead"
HttpMessage.SET_LOWEST_SCORE="setLowestScore"
HttpMessage.SET_OVERSCORE_REDUCESCORE="setOverScoreAndReduceScore"
HttpMessage.QUIT_CLUB = "quitClub"
HttpMessage.CLUB_USER_RANK="clubUserRank"
HttpMessage.CLUB_SCORE_RANK="getClubWinnerRank"
HttpMessage.CLUB_TRANSFER="transferClub"
HttpMessage.CLUB_USER_DETAIL_DOU_LOGS="clubUserDetailDouLogs"
HttpMessage.CLUB_USER_DOU_LOGS = "clubUserDouLogs"
HttpMessage.CLUB_INCREASE_DOU = "increaseDou"
HttpMessage.CLUB_REDUCE_DOU = "reduceDou"
HttpMessage.CLUB_DOU_OPER_LOGS = "queryDouOperLogs"

HttpMessage.GET_FLOOR = "getFloor"
HttpMessage.ADD_FLOOR = "addFloor"
HttpMessage.EDIT_FLOOR = "editFloor"
HttpMessage.DEL_FLOOR = "delFloor"
HttpMessage.GET_SUB_FLOOR = "getSubFloor"
HttpMessage.GET_SUB_FLOOR2 = "getSubFloor2"
HttpMessage.ADD_SUB_FLOOR = "addSubFloor"
HttpMessage.EDIT_SUB_FLOOR = "editSubFloor"
HttpMessage.DEL_SUB_FLOOR = "delSubFloor"
HttpMessage.FEED_BACK="feedBack"
HttpMessage.SHOP_CONF="recharge"
HttpMessage.MODIFY_ADDRESS="modifyAddress"
HttpMessage.CHECK_ROOM = "checkRoom"

HttpMessage.GET_CLUB_ALL_ROOMS = "getClubRoomsByMatchType"
HttpMessage.GET_CLUB_ALL_SUB_FLOOR = "getSubFloorByMatchType"
HttpMessage.GET_GAME_COUNT_LOGS = "getGameCountLogs" 
HttpMessage.SET_GAME_COUNT_LOGS = "setGameCountLogs" 

HttpMessage.SET_CLUB_BLOCK = "setClubBlock" 

HttpMessage.GET_DETAILS_RESULT = "getDetailsResult" 
HttpMessage.GET_CLUB_USER_ROOM_INFO = "getClubUserRoomInfo"

HttpMessage.GET_CLUB_GAME_PLAY = "getClubGamePlay" 
HttpMessage.QUERY_CLUB_BLOCK = "queryClubBlock" 

HttpMessage.TRANSFER_CLUBUSER = "transferClubUser" 
HttpMessage.TAG_CLUBUSER = "tagClubUser" 
HttpMessage.GET_CLUB_TAGUSER_ROOMINFO = "getClubTagUserRoomInfo" 
HttpMessage.GET_CLUB_BASE_INFO = "getClubBaseInfo"
HttpMessage.GET_CLUB_ROOM_LIST = "getClubRoomList"  
HttpMessage.GET_CLUB_GAME_LOGS = "getClubGameLogs" 
HttpMessage.SET_CLUB_QUERY_WINNER_SCORE = "setClubQueryWinnerScore" 
HttpMessage.GET_CLUB_SCORE_LIST_BY_GAME_TYPE_AND_TIME = "getClubScoreListByGameTypeAndTime" 


HttpMessage.SPRING_ACTIVITY = "springActivity" 
HttpMessage.SPRING_ACTIVITY_RECV = "springActivityRecv" 
HttpMessage.SPRING_ACTIVITY_LOGS = "springActivityLogs" 
HttpMessage.QUERY_DOU = "queryDou"
HttpMessage.LIST_CLUB_COMMISSION_LOG = "listClubCommissionLog"
local function makeHttpHandler(api)
    local suc = function (result)
        app:clearLoading()
        dataCenter:publishHttpSuccess(api, result)
    end
    local fail = function ()
        app:clearLoading()
        dataCenter:publishHttpFail(api)
    end
    return suc, fail
end

function HttpMessage.requestClubHttp(params, api)
    local suc, fail = makeHttpHandler(api)
    return BaseApi.request(api, params, suc, fail)
end

return HttpMessage

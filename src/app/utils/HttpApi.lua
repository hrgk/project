local BaseApi = import(".BaseApi")
local HttpApi = {}

function HttpApi.guestLogin(sucHandler, failHandler)
    if not CHANNEL_CONFIGS.GUEST_LOGIN then
        return
    end
    local api = "guestLogin"
    local params = dataCenter:getDeviceInfo()
    return BaseApi.requestWithoutToken(api, params, sucHandler, failHandler)
end

function HttpApi.getQrcode(sucHandler, failHandler)
    local api = "qrcode"
    BaseApi.request(api,nil, sucHandler, failHandler)
end

function HttpApi.fenXiangDeZuan(sucHandler, failHandler)
    local api = "shareDiamond"
    BaseApi.request(api,nil, sucHandler, failHandler)
end

function HttpApi.shareDiamondEveryDay(sucHandler, failHandler)
    local api = "shareDiamondEveryDay"
    BaseApi.request(api,nil, sucHandler, failHandler)
end

function HttpApi.onHttpGetAddress(sucHandler, failHandler)
    local api = "getAddress"
    BaseApi.request(api,nil, sucHandler, failHandler)
end

--牌组信息查询
function HttpApi.onHttpGetRoomRecords(clubID, sucHandler, failHandler)
    local api = "getRoomList"
    local params = dataCenter:getDeviceInfo()
    params.clubID = clubID or -1
    return BaseApi.request(api, params, sucHandler, failHandler)
end

--牌局信息查询
function HttpApi.onHttpGetRoundList(clubID, paiZuID, sucHandler, failHandler)
    local api = "getRoundList"
    local params = dataCenter:getDeviceInfo()
    params.recordID = paiZuID
    params.clubID = clubID or -1
    return BaseApi.request(api, params, sucHandler, failHandler)
end

--获取回访码
function HttpApi.onHttpGenVisitNum(roundID, sucHandler, failHandler)
    local api = "makeReviewCode"
    -- local params = dataCenter:getDeviceInfo()
    -- params.paiZuID = tostring(paiZuID)
    -- params.seq = tonumber(seq)
    return BaseApi.request(api, {roundID = roundID}, sucHandler, failHandler)
end

function HttpApi.iapSendTransaction(params, sucHandler, failHandler)
    local api = "iap"
    return BaseApi.request(api, params, sucHandler, failHandler)
end

--查看牌局回放
function HttpApi.getVisitDetail(roundID, seq, sucHandler, failHandler)
    local api = "getRoundPlayDetail"
    return BaseApi.request(api, {roundID = roundID, seq = seq}, sucHandler, failHandler)
end

--输入回放码查看牌局
function HttpApi.getRoundInfo(reviewCode, sucHandler, failHandler)
    local api = "getRoundInfo"
    return BaseApi.request(api, {reviewCode = reviewCode}, sucHandler, failHandler)
end

-- 第三方登录
--[[
    param 需要传递的json格式信息
]]
function HttpApi.sdkLogin(param, sucHandler, failHandler)
    if not CHANNEL_CONFIGS.WECHAT_LOGIN then
        return
    end
    local api = "wechatLogin"
    local params = dataCenter:getDeviceInfo()
    params.code = param.code
    return BaseApi.requestWithoutToken(api, params, sucHandler, failHandler)
end

-- 第三方自动登录
function HttpApi.autoLogin(param, sucHandler, failHandler)
    local api = "wechatLogin"
    local params = dataCenter:getDeviceInfo()
    params.autoToken = param.autoToken
    return BaseApi.requestWithoutToken(api, params, sucHandler, failHandler)
end

function HttpApi.createRoom(params, sucHandler, failHandler)
    local api = "createRoom"
    -- if params and params.isMj then
    --  api = "mjCreateRoom"
    -- end
    BaseApi.request(api, params, sucHandler, failHandler)
end

function HttpApi.getServerInfo(roomID, sucHandler, failHandler)
    local api = "queryServerInfo"
    BaseApi.request(api, {roomID = roomID}, sucHandler, failHandler)
end

function HttpApi.getJiFuInfo(sucHandler, failHandler)
    local api = "getJiFu"
    BaseApi.request(api, nil, sucHandler, failHandler)
end

function HttpApi.getJiFuList(sucHandler, failHandler)
    local api = "getJiFuList"
    BaseApi.request(api, nil, sucHandler, failHandler)
end

function HttpApi.getBindInviter(uid, sucHandler, failHandler)
    local api = "bindInvite"
    BaseApi.request(api, {agentID = uid}, sucHandler, failHandler)
end

function HttpApi.getQueryUid(uid, sucHandler, failHandler)
    local api = "queryUid"
    BaseApi.request(api, {uid = uid}, sucHandler, failHandler)
end

function HttpApi.getInviteList(sucHandler, failHandler)        --请求推广明细信息
    local api = "getInviteList"
    BaseApi.request(api, nil, sucHandler, failHandler)
end

function HttpApi.setInviter(uid, sucHandler, failHandler)         --绑定推广邀请人
    local api = "setInviter"
    BaseApi.request(api, {uid = uid}, sucHandler, failHandler)
end

function HttpApi.getUserInfo(sucHandler, failHandler)
    local api = "getUserInfo"
    BaseApi.request(api, nil, sucHandler, failHandler)
end

function HttpApi.queryDiamondMessage(sucHandler, failHandler)
    local api = "getDiamondsChange"
    BaseApi.request(api, nil, sucHandler, failHandler)
end

function HttpApi.giveDiamonds(uid, diamonds, sucHandler, failHandler)          --赠送钻石
    local api = "giveDiamonds"
    BaseApi.request(api, {uid = uid, diamonds = diamonds}, sucHandler, failHandler)
end

function HttpApi.geteditProfiles(oldPwd, pwd, sucHandler, failHandler)           --修改密码
    local api = "editProfiles"
    BaseApi.request(api, {oldPwd = oldPwd, pwd = pwd}, sucHandler, failHandler)
end

function HttpApi.getDiamondRecords(sucHandler, failHandler)          --获取钻石变更记录
    local api = "getDiamondRecords"
    BaseApi.request(api, nil, sucHandler, failHandler)
end

function HttpApi.forgetPassword(verifyCode, password, sucHandler, failHandler)
    local api = "resetPwd"
    BaseApi.request(api, {verifyCode = verifyCode, pwd = password}, sucHandler, failHandler)
end

function HttpApi.requestVerifyCode(sucHandler, failHandler)
    local api = "requestVerifyCode"
    BaseApi.request(api, nil, sucHandler, failHandler)
end

function HttpApi.checkNewVersion(sucHandler, failHandler)
    local api = "checkUpdate"
    BaseApi.requestWithoutToken(api, nil, sucHandler, failHandler)
end

function HttpApi.getSwitchInfo(sucHandler, failHandler)
    local api = "getChannelConfig"
    BaseApi.requestWithoutToken(api, nil, sucHandler, failHandler)
end

function HttpApi.keepOnline(sucHandler, failHandler)
    local api = "refreshToken"
    BaseApi.request(api, nil, sucHandler, failHandler)
end

function HttpApi.getRoundDetail(paiZuID, index, sucHandler, failHandler)
    local api = "getRoundDetail"
    local params = {paiZuID = paiZuID, index = checkint(index)}
    BaseApi.request(api, params, sucHandler, failHandler)
end

function HttpApi.jfChange(params, sucHandler, failHandler)
    local api = "buyScoreItem"
    BaseApi.request(api, params, sucHandler, failHandler)
end

function HttpApi.getSignInItems(sucHandler, failHandler)
    local api = "signInItemInfo"
    BaseApi.request(api, nil, sucHandler, failHandler)
end

function HttpApi.signInActivity(sucHandler, failHandler)
    local api = "signInActivity"
    BaseApi.request(api, nil, sucHandler, failHandler)
end

function HttpApi.wxpay(params, sucHandler, failHandler)
    local api = "wxpay"
    BaseApi.request(api, params, sucHandler, failHandler)
end

function HttpApi.buyYuanBaoHandler(params, sucHandler, failHandler)
    local api = "buyYuanBaoHandler"
    BaseApi.request(api, params, sucHandler, failHandler)
end

function HttpApi.changeYuanBaoToDiamond(params, sucHandler, failHandler)
    local api = "changeYuanBaoToDiamond"
    BaseApi.request(api, params, sucHandler, failHandler)
end

function HttpApi.uploadAAC(roomID, fileName, sucHandler, failHandler)
    local api = "uploadAAC"
    local params = {fieldName = "aac", fileName = fileName, contentType = "application/octet-stream"}
    local extra = {roomID = roomID}
    BaseApi.upload(api, params, extra, sucHandler, failHandler)
end

function HttpApi.download(url, filename, sucFunc, failFunc, timeoutSeconds, progressFunc)
    BaseApi.download(url, filename, sucFunc, failFunc, timeoutSeconds, progressFunc)
end

return HttpApi

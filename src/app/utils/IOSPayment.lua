-- local ApiBase = import("BaseApi")

local IOSPayment = {}

function IOSPayment.startListening()
    local IAP = require("gailun_framework.modules.IAPWrapper")

    dataCenter.IAPWrapper:addEventListener(IAP.LOAD_PRODUCTS_FINISHED, IOSPayment.onLoadProductsFinished)
    dataCenter.IAPWrapper:addEventListener(IAP.TRANSACTION_PURCHASED, IOSPayment.onTransactionPurchased)
    dataCenter.IAPWrapper:addEventListener(IAP.TRANSACTION_FAILED, IOSPayment.onTransactionFailed)
    dataCenter.IAPWrapper:addEventListener(IAP.TRANSACTION_UNKNOWN_ERROR, IOSPayment.onTransactionUnknownError)
end

function IOSPayment.loadProducts()
    dataCenter.IAPWrapper:loadProducts(IOS_IAP_PRODUCTS)
end

function IOSPayment.rechargeTransactions()
    local trans = DataCenter.IAPPayment:getAllTransactions()
    if not trans or table.nums(trans) < 1 then
        return
    end
    for k,v in pairs(trans) do
        printInfo("rechargeTransactions: %s", k)
        IOSPayment.sendTransactionToAuthServer(v)
    end
end

--[[
code为支付点击索引
1：支付宝
2：微信
3：银行卡
4：信用卡
5：话费卡
]]
function IOSPayment.startPayment(data, callback)
    local params = {
        uid = data.uid,
        goodsId = data.goodsId,
        source = data.source,  -- 来源，1是安卓 2IOS
        -- payment = payment,  -- 支付方式，后台配置，微信是110，支付宝101
        channelId = data.channel,  -- 客户端渠道ID
        gameId = data.gameId,  -- 游戏ID，炸金花为102
        psub = 0,  -- 运营商 1 移动 2 联通 3 电信
        userData = data.userData,  -- 额外数据，暂时为空
        desc = data.desc or IOS_IAP_PRODUCTS[1],  -- ios商品ID
        version = "zjh_1_1",  -- 支付版本号
    }
    -- if data.code == 1 then -- 支付宝支付
    --     params.payment = AliPayment.PAY_FLAG
    --     AliPayment.new():order(params)
    -- elseif data.code == 2 then -- 微信支付
    --     params.payment = WXPayment.PAY_FLAG
    --     WXPayment.new():order(params)
    -- elseif data.code == 6 then
        if dataCenter.IAPWrapper:canMakePurchases() then
            dataCenter.IAPWrapper:purchaseProduct(params.desc)
        else
            device.showAlert("温馨提示", "IOS内购抽风了暂时不能使用，请稍后再试！", {"ok"})
        end
    -- else
    --     printInfo("============= this method is not support ===========")
    -- end
end

function IOSPayment.onLoadProductsFinished(event)
    dump(event)
    if not event or not event.transaction then
        return
    end
    
    local transaction = event.transaction

    device.showActivityIndicator() -- 因为scene的hide事件会让这里显示不出来加载中的图标,帮延时执行
    IOSPayment.sendTransactionToAuthServer(transaction)
end

function IOSPayment.onTransactionPurchased(event)
    if not event or not event.transaction then
        return
    end
    local transaction = event.transaction

    device.showActivityIndicator() -- 因为scene的hide事件会让这里显示不出来加载中的图标,帮延时执行
    IOSPayment.sendTransactionToAuthServer(transaction)
end

function IOSPayment.sendTransactionToAuthServer(transaction)
    local function onSendTransactionFail_()
        printInfo("onSendTransactionFail_ %s ", transaction.transactionIdentifier)
        device.hideActivityIndicator()
        device.showAlert("支付未成功", "抱歉，您没有支付成功!", {"OK"})
    end
    local function onSendTransactionSuccess_(data)
        --[[0 通知成功，已到账
            1 记录成功，未到账
            2 已经提交过的订单
            -1 参数错误
        ]]
        device.hideActivityIndicator()
        local result = json.decode(data)
        if not result then
            return
        end
        dump(result)
        local status = checkint(result.status)
        if -1 == status then
            printInfo("%s %s", "支付系统异常", "很抱歉充值未成功!")
            return
        elseif 0 == status then
            device.showAlert("支付成功", "恭喜您，订单已成功!", {"OK"})
        elseif 1 == status then
            device.showAlert("支付成功", "恭喜您，订单已成功，系统到账可能有2-5分钟的延时，请耐心等待!", {"OK"})
            local diamonds = result.data.diamond
            local hostPlayer = dataCenter:getHostPlayer()

            hostPlayer:setDiamond(diamonds)
        else
            printInfo("pay status %d", status)
        end
        dataCenter.IAPWrapper:removeLocalTransaction(transaction)
    end

    local params = {
        ticket = 
        {
            receipt = transaction
        },
    }
    dump(params)
    print("iapSendTransaction")
    HttpApi.iapSendTransaction(params, onSendTransactionSuccess_, onSendTransactionFail_)

    -- params.sign = ApiBase.makeHttpSign(params, PAY_SIGN_KEY)
    -- params = ApiBase.formatPostData(params)
    -- params.ticket = crypto.encodeBase64(json.encode(transaction))
    -- local url = HTTP_URL_CONFIG.IOS_PAYMENT_URL
    -- gailun.HTTP.post(url, params, onSendTransactionSuccess_, onSendTransactionFail_)
end

function IOSPayment.onTransactionFailed(event)
    device.hideActivityIndicator()
    local transaction = event.transaction
    local msg = string.format("原因： %s，请稍候再试，错误码：%s", 
        tostring(transaction.errorString), tostring(transaction.errorCode))
    device.showAlert("购买失败", msg, {"OK"})
end

function IOSPayment.onTransactionUnknownError(event)
    device.hideActivityIndicator()
end

return IOSPayment

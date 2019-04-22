local LocalStorage = import(".LocalStorage")
local IAPWrapper = class("IAPWrapper")
local Store = require "framework.cc.sdk.Store"
IAPWrapper.LOAD_PRODUCTS_FINISHED    = "LOAD_PRODUCTS_FINISHED"
IAPWrapper.TRANSACTION_PURCHASED     = "TRANSACTION_PURCHASED"
IAPWrapper.TRANSACTION_RESTORED      = "TRANSACTION_RESTORED"
IAPWrapper.TRANSACTION_FAILED        = "TRANSACTION_FAILED"
IAPWrapper.TRANSACTION_UNKNOWN_ERROR = "TRANSACTION_UNKNOWN_ERROR"

local TRANSTION_KEY = "TRANSTION_KEY"

function IAPWrapper:ctor(path, filename, isEncrypt, key)
    cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()
    self.localStorage_ = LocalStorage.new(path, filename, isEncrypt, key)
    self.transactions_ = self.localStorage_:get(TRANSTION_KEY) or {}
    
    self.provider_ = Store
    self.provider_.init(handler(self, self.transactionCallback))
    self.products_ = {}
end

function IAPWrapper:getAllTransactions()
    return self.transactions_
end

function IAPWrapper:saveTransaction(transaction)
    assert(transaction and transaction.transactionIdentifier)
    self.transactions_[transaction.transactionIdentifier] = transaction
    self.localStorage_:set(TRANSTION_KEY, self.transactions_)
end

function IAPWrapper:canMakePurchases()
    return self.provider_.canMakePurchases()
end

function IAPWrapper:loadProducts(productsId)
    self.provider_.loadProducts(productsId, function(event)
        self.products_ = {}
        if event and event.products then
            for _, product in ipairs(event.products) do
                self.products_[product.productIdentifier] = clone(product)
            end
        end

        self:dispatchEvent({
            name = IAPWrapper.LOAD_PRODUCTS_FINISHED,
            products = event.products,
            invalidProducts = event.invalidProducts
        })
    end)
end

function IAPWrapper:getProductDetails(productId)
    local product = self.products_[productId]
    if product then
        return clone(product)
    else
        return nil
    end
end

function IAPWrapper:cancelLoadProducts()
    self.provider_.cancelLoadProducts()
end

function IAPWrapper:isProductLoaded(productId)
    return self.provider_.isProductLoaded(productId)
end

function IAPWrapper:purchaseProduct(productId)
    self.provider_.purchase(productId)
end

function IAPWrapper:transactionCallback(event)
    if not event or not event.transaction then
        printError("transactionCallback with broken event")
        return
    end

    local transaction = event.transaction
    self:saveTransaction(transaction)
    local eventName = IAPWrapper.TRANSACTION_UNKNOWN_ERROR
    if transaction.state == "purchased" then
        eventName = IAPWrapper.TRANSACTION_PURCHASED
    elseif transaction.state == "restored" then
        eventName = IAPWrapper.TRANSACTION_RESTORED
    elseif transaction.state == "failed" then
        eventName = IAPWrapper.TRANSACTION_FAILED
    end

    -- Once we are done with a transaction, call this to tell the store
    -- we are done with the transaction.
    -- If you are providing downloadable content, wait to call this until
    -- after the download completes.
    self.provider_.finishTransaction(transaction)
    self:dispatchEvent({name = eventName, transaction = transaction})
end

function IAPWrapper:removeLocalTransaction(transaction)
    if not transaction or not transaction.transactionIdentifier then
        printError("removeLocalTransaction with no transaction")
        return
    end
    if not self.transactions_ or not self.transactions_[transaction.transactionIdentifier] then
        return
    end
    self.transactions_[transaction.transactionIdentifier] = nil
    self.localStorage_:set(TRANSTION_KEY, self.transactions_)
end

return IAPWrapper

local BaseElement = import("app.views.BaseElement")
local DebugView = class("DebugView",BaseElement)

function DebugView:ctor(debugCommand, debugMap)
    print(APP_ENVIRONMENT, DEBUG)
    if CHANNEL_CONFIGS.DEBUG_CARD == false or APP_ENVIRONMENT == "w" or DEBUG <= 0 then
        return
    end
    DebugView.super.ctor(self)

    assert(debugCommand)
    assert(debugMap)
    self.debugMap_ = debugMap or {}
    self.debugCommand_ = debugCommand
end

function DebugView:onEnter()
end

function DebugView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/games/debugNode.csb"):addTo(self)
end

function DebugView:debugHandler_()
    local debugId = self.input_:getString()
    debugId = tonumber(debugId) or debugId
    local debugInfo = self.debugMap_[debugId]
    if not debugInfo then
        printError("debug set Failed")
        return
    end
    dump(debugInfo)
    dataCenter:sendOverSocket(self.debugCommand_, debugInfo)
end

return DebugView
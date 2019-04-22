local BaseItem = import(".BaseItem")
local PlayerHead = class("PlayerHead",BaseItem)
PlayerHead.BORDER = "res/images/common/avatar_border.png"  -- 头像的边框
PlayerHead.MASK = "res/images/common/headmask.png"  -- 剪切的模板
PlayerHead.SCALE = 0.46  -- 实际显示头像时所需要缩放的比例

function PlayerHead:ctor(data, noClick)
    self.data_ = data
    self.noClick_ = noClick
    PlayerHead.super.ctor(self)

    self.downloadUrl_ = ""
    -- self:bindEvent()
end

function PlayerHead:setData(data)
    self.data_ = data
end

function PlayerHead:setNode(node)
    PlayerHead.super.setNode(self, node)
    cc.EventProxy.new(dataCenter, self.csbNode_, true)
    :addEventListener(dataCenter.eventName.DOWNLOAD_FINISH, handler(self, self.onDownloadFinish))
end

function PlayerHead:hide()
    self.csbNode_:hide()
end

function PlayerHead:show()
    self.csbNode_:show()
end

function PlayerHead:setCallback(callfunc)
    self.callfunc_ = callfunc
end

function PlayerHead:headHandler_()
    if self.noClick_ then return end
    if self.callfunc_ then
        self.callfunc_(self.data_)
        return
    end
    display.getRunningScene():initPlayerInfoView(self.data_)
end

function PlayerHead:showWithUrl(url)
    if not url then
        printInfo("show with url fail by no url")
        return
    end
    if url == nil or string.len(url) == 0 then
        -- self:showAvatar_("res/images/common/defaulthead.png")
    else
        if string.lower(string.sub(url, 1, 4)) ~= 'http' then
            return self:showAvatar_(url)
        end
        self:displayNetImage_(url)
    end
end

function PlayerHead:showAvatar_(image)
   if tolua.isnull(self.csbNode_) then return end
    if self.avatar_ then
        self.avatar_:removeSelf()
        self.avatar_ = nil
    end
    self.avatar_ = display.newSprite(image):addTo(self.headContent_)
    self.avatar_:setScale(PlayerHead.SCALE)
    return self
end

function PlayerHead:setAvatarScale(scale)
    self.avatar_:setScale(scale or PlayerHead.SCALE)
end

function PlayerHead:getIconPath_()
    return DATA_PATH_HEADICON
end

function PlayerHead:makeIconPath_(url)
    return self:getIconPath_() .. crypto.md5(url)
end

function PlayerHead:onDownloadFinish(event)
    if event.url == self.downloadUrl_ then
        self:showAvatar_(event.path)
    end
end

function PlayerHead:downloadIcon_(url, path)
    dataCenter:download(url, path)
    -- gailun.HTTP.download(url, path, handler(self, self.showAvatar_))
end

-- 此方法还没测试的，别用
function PlayerHead:displayNetImage_(url)
    if not io.exists(self:getIconPath_()) then
        gailun.utils.mkdir(self:getIconPath_())
    end
    local path = self:makeIconPath_(url)
    if not io.exists(path) then
        self.downloadUrl_ = url
        return self:downloadIcon_(url, path)
    else
        return self:showAvatar_(path)
    end
end

return PlayerHead 
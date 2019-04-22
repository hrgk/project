local BaseView = import(".BaseView")
local ErWeiShareView = class("ErWeiShareView",BaseView)
local AvatarView = import(".AvatarView")

function ErWeiShareView:ctor(inScene, callfunc)
    self.inScene_ = inScene
    self.callfunc_ = callfunc
    ErWeiShareView.super.ctor(self)
    if selfData:getCustomType() == 0 then
        local maImage = ccui.ImageView:create("res/images/share/ma.png")
        maImage:addTo(self.csbNode_):scale(0.8)
        maImage:pos(270,230)
        self:shareHandler_()
    else
        self:getEWCode_()
    end
end

function ErWeiShareView:getEWCode_()
    local erweima = QCODE_PATH .. selfData:getUid() .. ".jpg"
    local function sucHandler(data)
        local info = json.decode(data)
        if info.status == 1 then
            local url = info.data.qcodes
            local function sucFunc(path)
                local maZi = display.newSprite(path):addTo(self.csbNode_):scale(0.45)
                maZi:pos(270,230)
                self:shareHandler_()
            end
            local function failFunc()
                print("failed")
            end
            local function progressFunc()
            end
            if url ~= "" then
                HttpApi.download(url, erweima, sucFunc, failFunc, 5, progressFunc)
            end
        end
    end
    local function failHandler()
    end
    if not io.exists(erweima) then
        HttpApi.getQrcode(sucHandler, failHandler)
    else
        local maZi = display.newSprite(erweima):addTo(self.csbNode_):scale(0.45)
        maZi:pos(270,230)
        -- if "ios" == device.platform then
        --     maZi:pos(100,380)
        -- end
        self:shareHandler_()
    end
end

function ErWeiShareView:shareHandler_()
    --需要截的屏幕大小
    local size = self.csbNode_:getContentSize()
    local render_texture = cc.RenderTexture:create(405, 720)
    --开始截屏
    local fileName = "share.jpg"
    local path = cc.FileUtils:getInstance():getWritablePath() .. fileName
    render_texture:begin()
    --截self.node_container包含的内容
    self:visit()
    --关闭
    render_texture:endToLua()
    --调用
    -- local photo_texture = render_texture:getSprite():getTexture()
    -- local sprite_photo = cc.Sprite:createWithTexture(photo_texture)
    -- --截屏后的sprite_photo为原始图片沿y轴翻转后的样子。若需要原图，调用如下函数.
    -- sprite_photo:flipY()
    local result = render_texture:saveToFile(fileName, cc.IMAGE_FORMAT_JPEG)
    -- saveToFile函数会默认添加根路径。
    if not result then
        print("save file failed")
    end
    local actions = {}
    local function shareFunc() 
        display.getRunningScene():shareImage(2,"乐途互娱","",self.inScene_,self.callfunc_,path,true)
    end
    table.insert(actions, cc.DelayTime:create(0.5))
    table.insert(actions, cc.CallFunc:create(shareFunc))
    table.insert(actions, cc.DelayTime:create(1))
    local function shareReward()
        local function sucHandler(data)
            -- dump(data)
            local info = json.decode(data)
            if info.status == 1 then
                local diamond = info.data.diamond
                local totalDiamond = selfData:getDiamond() + tonumber(diamond)
                selfData:setDiamond(totalDiamond)
                app:showTips("恭喜获得了".. diamond .."颗钻石")
            elseif info.status == -9 then
                app:showTips("今日已分享")
            end
        end

        local function failHandler(data)
        end
        if selfData:getCustomType() == 1 then
            return
        end
        HttpApi.shareDiamondEveryDay(sucHandler, failHandler)
    end
    table.insert(actions, cc.CallFunc:create(shareReward))
    table.insert(actions, cc.DelayTime:create(0.1))
    table.insert(actions, cc.CallFunc:create(function()
        self:removeSelf()
        end))
    local seq = transition.sequence(actions)
    self:runAction(seq)
end

function ErWeiShareView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/erWeiMaShareView.csb"):addTo(self)
end

return ErWeiShareView 

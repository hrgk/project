local FaceAnimationsData = {}

local FaceAnimations = {
    {id = 1, price = 1, faceCmd = 5, flyIcon = "res/images/faceIcon/gutou_fly.png", flyIconOffsetX = 0, flyIconOffsetY = 0, offsetX = 0, offsetY = 0, icon = "res/images/faceIcon/gutou.png", target = 1, actionType = 1, isXuanZhuan = true, animation = "coscosgouyao", sound = "sounds/chat/gou_jiao.mp3", soundDelaySeconds = 0, continueAnimation = 0},
    {id = 2, price = 1, faceCmd = 5, flyIcon = "res/images/faceIcon/hua_fly.png", flyIconOffsetX = 0, flyIconOffsetY = 0, offsetX = 50, offsetY = 15, icon = "res/images/faceIcon/hua.png", target = 1, actionType = 1, isXuanZhuan = true, animation = "coscossonghua", sound = "sounds/chat/song_hua.mp3", soundDelaySeconds = 0, continueAnimation = 0},
    {id = 3, price = 1, faceCmd = 5, flyIcon = "res/images/faceIcon/jidan_fly.png", flyIconOffsetX = 0, flyIconOffsetY = 0, offsetX = 0, offsetY = 0, icon = "res/images/faceIcon/jidan.png", target = 1, actionType = 1, isXuanZhuan = true, animation = "coscosjidan", sound = "sounds/chat/reng_ji_dan.mp3", soundDelaySeconds = 0, continueAnimation = 0},
    {id = 4, price = 1, faceCmd = 5, flyIcon = "res/images/faceIcon/xiezi_fly.png", flyIconOffsetX = 0, flyIconOffsetY = 0, offsetX = 0, offsetY = 0, icon = "res/images/faceIcon/xiezi.png", target = 1, actionType = 1, isXuanZhuan = false, animation = "coscostuoxie", sound = "sounds/chat/ren_xie_zi.mp3", soundDelaySeconds = 0, continueAnimation = 0},
    {id = 5, price = 2, faceCmd = 5, flyIcon = "res/images/faceIcon/zhadan_fly.png", flyIconOffsetX = 0, flyIconOffsetY = 0, offsetX = 0, offsetY = 0, icon = "res/images/faceIcon/zhadan.png", target = 2, actionType = 1, isXuanZhuan = true, animation = "coscoszhadan", sound = "sounds/zhadanbaozha.mp3", soundDelaySeconds = 0, continueAnimation = 0},
    {id = 6, price = 1, faceCmd = 5, flyIcon = "res/images/faceIcon/liwu_fly.png", flyIconOffsetX = 0, flyIconOffsetY = 0, offsetX = 0, offsetY = 0, icon = "res/images/faceIcon/liwu.png", target = 1, actionType = 1, isXuanZhuan = true, animation = "coscosliwu", sound = "sounds/chat/tou_xiang.mp3", soundDelaySeconds = 0, continueAnimation = 0},
  }
local MyFaceAnimations = {
    {id = 10, price = 1, faceCmd = 1, icon = "#game_face1.png", actionType = 1, sound = "sounds/chat/game_face_1.mp3", soundDelaySeconds = 0, continueAnimation = 0},
    {id = 11, price = 2, faceCmd = 1, icon = "#game_face2.png", actionType = 1, sound = "sounds/chat/game_face_2.mp3", soundDelaySeconds = 1, continueAnimation = 0},
    {id = 12, price = 1, faceCmd = 1, icon = "#game_face3.png", actionType = 1, sound = "sounds/chat/game_face_3.mp3", soundDelaySeconds = 0.2, continueAnimation = 0},
    {id = 13, price = 1, faceCmd = 1, icon = "#game_face4.png", actionType = 1, sound = "sounds/chat/game_face_4.mp3", soundDelaySeconds = 0, continueAnimation = 0},
    {id = 14, price = 1, faceCmd = 1, icon = "#game_face5.png", actionType = 1, sound = "sounds/chat/game_face_5.mp3", soundDelaySeconds = 0, continueAnimation = 0},
    {id = 15, price = 1, faceCmd = 1, icon = "#game_face6.png", actionType = 1, sound = "sounds/chat/game_face_6.mp3", soundDelaySeconds = 0, continueAnimation = 0},
    {id = 16, price = 1, faceCmd = 1, icon = "#game_face7.png", actionType = 1, sound = "sounds/chat/game_face_7.mp3", soundDelaySeconds = 0, continueAnimation = 0},
    {id = 17, price = 1, faceCmd = 1, icon = "#game_face8.png", actionType = 1, sound = "sounds/chat/game_face_8.mp3", soundDelaySeconds = 0, continueAnimation = 0},
}

local cocosAnimations = {
	{id = 1, animation = "coscosguang", x = display.cx, y = display.cy+100, isLoop = true, sound = "sounds/chat/game_face1.mp3", soundDelaySeconds = 0},
	{id = 2, animation = "coscoshongbao", x = display.cx+2, y = display.cy-12, isLoop = false, sound = "sounds/chat/game_face1.mp3", soundDelaySeconds = 0},
	{id = 3, animation = "coscosloading", x = display.cx, y = display.cy, isLoop = true, sound = "", soundDelaySeconds = 0},
	{id = 4, animation = "coscosbuyao", x = display.cx, y = display.cy, isLoop = false, sound = "", soundDelaySeconds = 0},
	{id = 5, animation = "coscosguanlong", x = display.cx, y = display.cy, isLoop = false, sound = "", soundDelaySeconds = 0},
	{id = 6, animation = "coscoszhuanzuan", x = 0, y = 0, scale = 0.83,isLoop = true, sound = "", soundDelaySeconds = 0},
    {id = 7, animation = "coscoszhadang", x = 0, y = 0, scale = 1.5,isLoop = false, sound = "", soundDelaySeconds = 0},
    {id = 8, animation = "coscosbuzhang", x = 0, y = 0, scale = 1,isLoop = false, sound = "", soundDelaySeconds = 0},
    {id = 9, animation = "coscoschi", x = 0, y = 0, scale = 1,isLoop = false, sound = "", soundDelaySeconds = 0},
    {id = 10, animation = "coscosgang", x = 0, y = 0, scale = 1,isLoop = false, sound = "", soundDelaySeconds = 0},
    {id = 11, animation = "coscoshu2", x = 0, y = 0, scale = 1,isHold = true,isLoop = false, sound = "", soundDelaySeconds = 0},
    {id = 12, animation = "coscospeng", x = 0, y = 0, scale = 1,isLoop = false, sound = "", soundDelaySeconds = 0},
    {id = 13, animation = "coscosqiangganghu", x = 0, y = 0, scale = 1,isLoop = false, sound = "", soundDelaySeconds = 0},
    {id = 14, animation = "coscoszimo", x = 0, y = 0, scale = 1,isLoop = false, sound = "", soundDelaySeconds = 0},
    {id = 15, animation = "coscosniao", x = 2, y = -10, scale = 1,isLoop = true, sound = "", soundDelaySeconds = 0},
    {id = 16, animation = "coscoszhongniao", x = 2, y = -10, scale = 1,isLoop = true, sound = "", soundDelaySeconds = 0},
    {id = 17, animation = "coscosjinbao", x = 2, y = -10, scale = 1,isLoop = true, sound = "", soundDelaySeconds = 0},
    {id = 18, animation = "coscosfenji", x = 2, y = -10, scale = 1,isLoop = true, sound = "", soundDelaySeconds = 0},
    {id = 19, animation = "coscosliandui", x = 2, y = -10, scale = 1,isLoop = true, sound = "", soundDelaySeconds = 0},
    {id = 20, animation = "coscossandaier", x = 2, y = -10, scale = 1,isLoop = true, sound = "", soundDelaySeconds = 0},
    {id = 21, animation = "coscossandaiyi", x = 2, y = -10, scale = 1,isLoop = true, sound = "", soundDelaySeconds = 0},
    {id = 22, animation = "coscossunzi", x = 2, y = -10, scale = 1,isLoop = true, sound = "", soundDelaySeconds = 0},
    {id = 23, animation = "coscoswoxianchu", x = 2, y = -10, scale = 1,isLoop = true, sound = "", soundDelaySeconds = 0},
    {id = 24, animation = "coscosyaobuqi", x = 2, y = -10, scale = 1,isLoop = true, sound = "", soundDelaySeconds = 0},
    {id = 25, animation = "coscosyuyin", x = 2, y = -10, scale = 1,isLoop = true, sound = "", soundDelaySeconds = 0},
    {id = 26, animation = "coscosjiazai2", x = 0, y = 20, scale = 1,isLoop = true, sound = "", soundDelaySeconds = 0},
    {id = 27, animation = "coscosniu", x = 0, y = 0, scale = 1,isLoop = true, sound = "", soundDelaySeconds = 0},
    {id = 28, animation = "coscoskuang", x = 0, y = 0, scale = 1,isLoop = true, sound = "", soundDelaySeconds = 0},
    {id = 29, animation = "coscosbaodan", x = 0, y = 0, scale = 1,isLoop = true, sound = "", soundDelaySeconds = 0},
    {id = 30, animation = "coscosfeiji", x = 150, y = 0, scale = 1,isLoop = false, sound = "sounds/feijifeiguo.mp3", soundDelaySeconds = 0},
    {id = 31, animation = "coscosshunzi1", x = 150, y = 40, scale = 1,isLoop = false, sound = "", soundDelaySeconds = 0},
    {id = 32, animation = "coscoszhadan1", x = 0, y = 0, scale = 1,isLoop = false, sound = "", soundDelaySeconds = 0},
    {id = 33, animation = "cocosdaqian", x = 0, y = 0, scale = 1,isLoop = false, sound = "", soundDelaySeconds = 0},
    {id = 34, animation = "cocosdankong", x = 0, y = 0, scale = 1,isLoop = false, sound = "", soundDelaySeconds = 0},
    {id = 35, animation = "cocoshongle", x = 0, y = 0, scale = 1,isLoop = false, sound = "", soundDelaySeconds = 0},
    {id = 36, animation = "cocosheile", x = 0, y = 0, scale = 1,isLoop = false, sound = "", soundDelaySeconds = 0},
    {id = 37, animation = "cocoswangdiao", x = 0, y = 0, scale = 1,isLoop = false, sound = "", soundDelaySeconds = 0},
    {id = 38, animation = "cocoswangchuang", x = 0, y = 0, scale = 1,isLoop = false, sound = "", soundDelaySeconds = 0},
    {id = 39, animation = "cocoswangzha", x = 0, y = 0, scale = 1,isLoop = false, sound = "", soundDelaySeconds = 0},
    {id = 40, animation = "coscosjingbao", x = 0, y = 0, scale = 1,isLoop = true, sound = "", soundDelaySeconds = 0},
    {id = 44, animation = "coscoshuadong", x = display.right-150, y = display.bottom+300, scale = 1,isLoop = true, sound = "", soundDelaySeconds = 0},
    {id = 45, animation = "coscosyanhua1", x = 0, y = 0, scale = 1,isLoop = true, sound = "", soundDelaySeconds = 0},
    {id = 46, animation = "coscosyanhua2", x = 0, y = 0, scale = 1,isLoop = true, sound = "", soundDelaySeconds = 0},

}

local paohuziAnimations = {
    {id = 1, animation = "coscoschi", x = 0, y = 0, scale = 1,isLoop = false, sound = "", soundDelaySeconds = 0},
    {id = 2, animation = "coscoshu", x = 0, y = 0, scale = 1,isLoop = false, sound = "", soundDelaySeconds = 0},
    {id = 3, animation = "coscospao", x = 0, y = 0, scale = 1,isLoop = false, sound = "", soundDelaySeconds = 0},
    {id = 4, animation = "coscospeng", x = 0, y = 0, scale = 1,isLoop = false, sound = "", soundDelaySeconds = 0},
    {id = 5, animation = "coscosti", x = 0, y = 0, scale = 1,isLoop = false, sound = "", soundDelaySeconds = 0},
    {id = 6, animation = "coscoswei", x = 0, y = 0, scale = 1,isLoop = false, sound = "", soundDelaySeconds = 0},
}

function FaceAnimationsData.getPaoHuZiAnimation(id)
    for i,v in ipairs(paohuziAnimations) do
        if id == v.id then
            return clone(v)
        end
    end
end

function FaceAnimationsData.getCocosAnimations()
    return cocosAnimations
end

function FaceAnimationsData.getCocosAnimation(id)
    for i,v in ipairs(cocosAnimations) do
        if id == v.id then
            return clone(v)
        end
    end
end

function FaceAnimationsData.getFaceAnimations()
    return FaceAnimations
end

function FaceAnimationsData.getMyFaceAnimations()
    return MyFaceAnimations
end

function FaceAnimationsData.getMyFaceAnimationById(id)
    for i,v in ipairs(MyFaceAnimations) do
        if id == v.id then
            return clone(v)
        end
    end
end

function FaceAnimationsData.getFaceAnimation(id)
    for i,v in ipairs(FaceAnimations) do
        if id == v.id then
            return clone(v)
        end
    end
end

return FaceAnimationsData  

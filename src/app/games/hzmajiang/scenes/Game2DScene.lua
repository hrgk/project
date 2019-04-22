local Nodes2D = import("..data.uidata.GameScene2DNodes")
local GameScene = import(".GameScene")
local Game2DScene = class("Game2DScene", GameScene)

function Game2DScene:getGameSceneNodes()
    return Nodes2D
end

function Game2DScene:setSceneName()
    self.name = "GAME_MJHONGZHONG2D"
end

return Game2DScene

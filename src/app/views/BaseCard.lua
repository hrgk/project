local BaseCard = class("BaseCard", function()
    return display.newSprite()
end)

function BaseCard:ctor()
    self:loaderCsb()
    self:initElement()
end

function BaseCard:loaderCsb()

end

function BaseCard:initElement()
    if self.csbNode_ == nil then return end
    for k,v in pairs(self.csbNode_:getChildren()) do
        local vInfo = string.split(v:getName(), "_")
        local itemName
        if vInfo[2] then
            itemName = vInfo[2] .. "_"
            self[itemName] = v
        end
    end
end

return BaseCard 

local doorPos = Position(32030, 32184, 6)

local tomBedroom = Action()

function tomBedroom.onUse(player, item, fromPosition, target, toPosition)
    local door = Tile(doorPos):getItemById(5732)
    local doorUnlocked = Tile(doorPos):getItemById(5733)

    if item.itemid == 1945 then
        item:transform(1946)
        door:transform(5733)
    elseif item.itemid == 1946 and doorUnlocked then
        item:transform(1945)
        doorUnlocked:transform(5732)
    end

    return true
end

tomBedroom:aid(9988)
tomBedroom:register()

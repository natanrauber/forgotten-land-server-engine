local itemPos = Position(31987, 32254, 8)

local santiagoSnakeHead = Action()

function santiagoSnakeHead.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local itemOff = Tile(itemPos):getItemById(5058)
    local itemOn = Tile(itemPos):getItemById(5057)

    if (item.itemid == 2772) then
        item:transform(2773)
        itemOff:transform(5057)
    elseif (item.itemid == 2773) then
        item:transform(2772)
        itemOn:transform(5058)
    end

    return true
end

santiagoSnakeHead:aid(9987)
santiagoSnakeHead:register()

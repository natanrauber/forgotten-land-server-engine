local item1pos = Position(32038, 32149, 8)
local item2pos = Position(32038, 32150, 8)
local item3pos = Position(32038, 32151, 8)

local wallpos1 = Position(32038, 32148, 8)
local wallpos2 = Position(32039, 32148, 8)
local wallpos3 = Position(32040, 32148, 8)
local wallpos4 = Position(32041, 32148, 8)
local wallpos5 = Position(32042, 32148, 8)
local wallpos6 = Position(32043, 32148, 8)

local teleportRoom = Action()

function teleportRoom.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local item1 = Tile(item1pos):getItemById(9899)
    local item2 = Tile(item2pos):getItemById(9893)
    local item3 = Tile(item3pos):getItemById(9888)

    local wall1 = Tile(wallpos1):getItemById(5071)
    local wall2 = Tile(wallpos2):getItemById(5071)
    local wall3 = Tile(wallpos3):getItemById(5071)
    local wall4 = Tile(wallpos4):getItemById(5071)
    local wall5 = Tile(wallpos5):getItemById(5071)
    local wall6 = Tile(wallpos6):getItemById(5071)

    if (wall1) then
        if item.itemid == 9888 then
            item:transform(9887)
        elseif item.itemid == 9887 then
            item:transform(9888)
        elseif item.itemid == 9893 then
            item:transform(9892)
        elseif item.itemid == 9892 then
            item:transform(9893)
        elseif item.itemid == 9899 then
            item:transform(9898)
        elseif item.itemid == 9898 then
            item:transform(9899)
        end

        if item.itemid == 10045 then
            if (item1 and item2 and item3) then
                item:transform(10044)
                wall1:transform(5068)
                wall2:transform(5068)
                wall3:remove()
                wall4:transform(5068)
                wall5:transform(5068)
                wall6:transform(5068)
            end
        end
    elseif (item.itemid == 10044) then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The system seems to be broken.")
    end

    return true
end

teleportRoom:aid(9989)
-- teleportRoom:register()

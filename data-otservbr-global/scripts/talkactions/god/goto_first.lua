local function sortById(a, b)
    return a:getId() < b:getId()
end

local storage = 95095
local gotoFirst = TalkAction("/gotofirst")

function gotoFirst.onSay(player, words, param)
    if not player:getGroup():getAccess() or player:getAccountType() < ACCOUNT_TYPE_GOD then
        return true
    end

    local players = Game.getPlayers()
    table.sort(players, sortById)

    -- no other player online
    if #players < 2 then
        player:sendTextMessage(MESSAGE_GAME_HIGHLIGHT, "There is no other player.")
        return true
    end

    local tmpPlayer = players[1]
    if player:getName() == tmpPlayer:getName() then
        tmpPlayer = players[2]
    end
    if player:getPosition() ~= tmpPlayer:getPosition() then
        player:teleportTo(tmpPlayer:getPosition())
    end
    player:setStorageValue(storage, tmpPlayer:getId())
    return true
end

gotoFirst:separator(" ")
gotoFirst:register()

local function sortById(a, b)
    return a:getId() < b:getId()
end

local storage = 95095
local gotoNext = TalkAction("/gotonext")

function gotoNext.onSay(player, words, param)
    if not player:getGroup():getAccess() or player:getAccountType() < ACCOUNT_TYPE_GOD then
        return true
    end

    local players = Game.getPlayers()
    table.sort(players, sortById)
    local lastCheckedPlayerId = player:getStorageValue(storage)

    -- no other player online
    if #players < 2 then
        player:sendTextMessage(MESSAGE_GAME_HIGHLIGHT, "There is no other player.")
        return true
    end

    -- lastCheckedPlayerId not set yet
    if not lastCheckedPlayerId then
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

    for i = 1, #players do
        local tmpPlayer = players[i]
        -- tmpPlayer is self
        if tmpPlayer:getName() == player:getName() then
            -- do nothing
        elseif tmpPlayer:getId() > lastCheckedPlayerId then
            player:teleportTo(tmpPlayer:getPosition())
            player:setStorageValue(storage, tmpPlayer:getId())
            return true
        end
    end

    -- restart list
    player:sendTextMessage(MESSAGE_GAME_HIGHLIGHT, "End of player list. Going back to first player.")
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

gotoNext:separator(" ")
gotoNext:register()

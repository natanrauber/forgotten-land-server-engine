local storage = 456113

local mute = TalkAction("/mute")

function mute.onSay(player, words, param)
    if not player:getGroup():getAccess() or player:getAccountType() < ACCOUNT_TYPE_GOD then
        return true
    end

    local split = param:split(",")
    if not split or #split < 2 then
        player:sendCancelMessage("Missing param minutes.")
        return false
    end

    local targetName = string.sub(split[1], 1)
    local target = Player(targetName)
    local minutes = tonumber(string.sub(split[2], 2))

    if not target then
        player:sendCancelMessage("Player not found." .. target:getName())
        return false
    end

    if not minutes then
        player:sendCancelMessage("Param minutes must be a number.")
        return false
    end

    if target:getGroup():getAccess() then
        player:sendCancelMessage("You cannot mute this player.")
        return false
    end

    player:sendTextMessage(MESSAGE_GAME_HIGHLIGHT, "The player " .. target:getName() .. " has been muted.")
    target:setStorageValue(storage, os.time() + (minutes * 60))

    return true
end

mute:separator(" ")
mute:register()

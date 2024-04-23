local coconutPalm = Action()

function coconutPalm.onUse(player)
    local onCooldown = player:getStorageValue(Storage.QuestChests.CoconutPalm) > os.time()
    local chance = math.random(100)

    if not onCooldown then
        player:setStorageValue(Storage.QuestChests.CoconutPalm, os.time() + 1800)
        if chance >= 30 then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a coconut.")
            player:addItem(3589, 1)
        elseif chance < 30 and chance >= 25 then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found two coconuts.")
            player:addItem(3589, 2)
        elseif chance < 25 and chance >= 20 then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found three coconuts.")
            player:addItem(3589, 3)
        else
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found nothing.")
        end
        return true
    end
    return false
end

coconutPalm:id(3640)
coconutPalm:register()

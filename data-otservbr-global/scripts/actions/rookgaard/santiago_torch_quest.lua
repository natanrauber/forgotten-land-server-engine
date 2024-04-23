local santiagoTorchQuest = Action()

function santiagoTorchQuest.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if player:getStorageValue(Storage.RookgaardTutorialIsland.SantiagoTorchQuest) ~= 2 then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a torch.")
        player:addItem(2920)
        player:setStorageValue(Storage.RookgaardTutorialIsland.SantiagoTorchQuest, 2)
    else
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The chest is empty.")
    end
    return true
end

santiagoTorchQuest:uid(60102)
santiagoTorchQuest:register()

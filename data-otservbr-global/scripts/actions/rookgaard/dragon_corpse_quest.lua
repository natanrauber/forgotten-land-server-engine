local dragonCorpseQuest = Action()

function dragonCorpseQuest.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if player:getStorageValue(Storage.QuestChests.DragonCorpse) == 1 then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The dragon corpse is empty.")
    else
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a plate shield.")
        player:addItem(3410, 1)
        player:setStorageValue(Storage.QuestChests.DragonCorpse, 1)
    end
    return true
end

dragonCorpseQuest:uid(5641)
dragonCorpseQuest:register()

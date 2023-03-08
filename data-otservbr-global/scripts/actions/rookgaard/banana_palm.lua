local bananaPalm = Action()

function bananaPalm.onUse(player)
	if player:getStorageValue(Storage.QuestChests.BananaPalm) < os.time() then
		local chance = math.random(100)
		if chance >= 30 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a banana.")
			player:addItem(3587, 1)
		elseif chance < 30 and chance >= 25 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found two bananas.")
			player:addItem(3587, 2)
		elseif chance < 25 and chance >= 22 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found three bananas.")
			player:addItem(3587, 3)
		end
		player:setStorageValue(Storage.QuestChests.BananaPalm, os.time() + 3600)
	end
	return true
end

bananaPalm:id(3639)
bananaPalm:register()

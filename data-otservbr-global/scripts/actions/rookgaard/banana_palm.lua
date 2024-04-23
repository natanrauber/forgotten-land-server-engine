local bananaPalm = Action()

function bananaPalm.onUse(player)
	local onCooldown = player:getStorageValue(Storage.QuestChests.BananaPalm) > os.time()
	local chance = math.random(100)

	if not onCooldown then
		player:setStorageValue(Storage.QuestChests.BananaPalm, os.time() + 1800)
		if chance >= 30 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a banana.")
			player:addItem(3587, 1)
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found nothing.")
		end
		return true
	end
	return false
end

bananaPalm:id(3639)
bananaPalm:register()

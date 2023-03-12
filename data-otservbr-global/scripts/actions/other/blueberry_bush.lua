local blueberryBush = Action()

function blueberryBush.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	item:transform(3700)
	item:decay()
	player:feed(3 * 15)
	player:say("Yum.", TALKTYPE_MONSTER_SAY)
	Game.createItem(3588, math.random(5), fromPosition)
	player:addAchievementProgress('Bluebarian', 500)
	return true
end

blueberryBush:id(3699)
blueberryBush:register()

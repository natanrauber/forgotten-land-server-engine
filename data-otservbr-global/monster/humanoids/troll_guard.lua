local mType = Game.createMonsterType("Troll Guard")
local monster = {}

monster.description = "a troll guard"
monster.experience = 30
monster.outfit = {
	lookType = 281,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 745
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 5,
	FirstUnlock = 2,
	SecondUnlock = 3,
	CharmsPoints = 30,
	Stars = 2,
	Occurrence = 3,
	Locations = "Rookgaard's central cave in the new western Troll tunnel, \z
		north-west of Carlin during raids and Thais Knights' Guild arena during raids on Kingsday."
}

monster.health = 60
monster.maxHealth = 60
monster.race = "blood"
monster.corpse = 861
monster.speed = 68
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 20
}

monster.strategiesTarget = {
	nearest = 100,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = false,
	pushable = true,
	rewardBoss = false,
	illusionable = false,
	canPushItems = false,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 15,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{name = "gold coin", chance = 65530, maxCount = 12},
	{name = "meat", chance = 15120},
	{id = 3003, chance = 7100}, -- rope
	{name = "bunch of troll hair", chance = 1050},
	{name = "silver amulet", chance = 20},
	--
	{name = "hand axe", chance = 5000},
	{name = "studded club", chance = 5000},
	{id = 3412, chance = 2000}, -- wooden shield
	{name = "leather helmet", chance = 2000},
	{name = "leather armor", chance = 2000},
	{name = "leather legs", chance = 2000},
	{name = "leather boots", chance = 2000}
}

monster.attacks = {
	{name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -18}
}

monster.defenses = {
	defense = 7,
	armor = 7
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 20},
	{type = COMBAT_EARTHDAMAGE, percent = -10},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE, percent = 10},
	{type = COMBAT_DEATHDAMAGE, percent = -10}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = false},
	{type = "bleed", condition = false}
}

mType:register(monster)

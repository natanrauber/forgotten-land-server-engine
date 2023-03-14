local mType = Game.createMonsterType("Goblin")
local monster = {}

monster.description = "a goblin"
monster.experience = 25
monster.outfit = {
	lookType = 61,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 61
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 250,
	FirstUnlock = 10,
	SecondUnlock = 100,
	CharmsPoints = 5,
	Stars = 1,
	Occurrence = 0,
	Locations = "Femor Hills, north east of Carlin, Edron Goblin Cave, Rookgaard (Premium Area), \z
		Maze of Lost Souls and Fenrock."
	}

monster.health = 50
monster.maxHealth = 50
monster.race = "blood"
monster.corpse = 6002
monster.speed = 60
monster.manaCost = 290

monster.changeTarget = {
	interval = 5000,
	chance = 0
}

monster.strategiesTarget = {
	nearest = 100,
}

monster.flags = {
	summonable = true,
	attackable = true,
	hostile = true,
	convinceable = true,
	pushable = true,
	rewardBoss = false,
	illusionable = true,
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
	{text = "Me have him!", yell = false},
	{text = "Zig Zag! Gobo attack!", yell = false},
	{text = "Help! Goblinkiller!", yell = false},
	{text = "Bugga! Bugga!", yell = false},
	{text = "Me green, me mean!", yell = false}
}

monster.loot = {
	{name = "gold coin", chance = 50230, maxCount = 9},
	{id = 3578, chance = 13020}, -- fish
	{id = 3115, chance = 1070}, -- bone
	{name = "mouldy cheese", chance = 1000},
	{name = "goblin ear", chance = 910},
	--
	{name = "small stone", chance = 15000},
	{name = "spear", chance = 7000},
	{name = "short sword", chance = 5000},
	{name = "bone club", chance = 5000},
	{name = "leather helmet", chance = 2000},
	{name = "leather armor", chance = 2000},
	{name = "leather legs", chance = 2000},
	{name = "leather boots", chance = 2000},
	{name = "small axe", chance = 2700},
	{name = "dagger", chance = 1800},
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -10},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -25, range = 7, shootEffect = CONST_ANI_SMALLSTONE, target = false}
}

monster.defenses = {
	defense = 6,
	armor = 6
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
	{type = COMBAT_HOLYDAMAGE , percent = 20},
	{type = COMBAT_DEATHDAMAGE , percent = -10}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = false},
	{type = "bleed", condition = false}
}

mType:register(monster)

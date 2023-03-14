local mType = Game.createMonsterType("Minotaur")
local monster = {}

monster.description = "a minotaur"
monster.experience = 50
monster.outfit = {
	lookType = 25,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 25
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 0,
	Locations = "Mino Hell (Rookgaard), Two outside Bear Room Quest, (Rookgaard) and also 2x on the premium side, \z
		Mintwallin, Folda, Minotaur Pyramid, Outlaw Camp, Kazordoon minotaur cave, Plains of Havoc, Elven Bane, \z
		Deeper Fibula Dungeon (level 50+ to open the door), Ancient Temple, Maze of Lost Souls, \z
		Thais Minotaur Camp, Foreigner Quarter."
	}

monster.health = 100
monster.maxHealth = 100
monster.race = "blood"
monster.corpse = 5969
monster.speed = 84
monster.manaCost = 330

monster.changeTarget = {
	interval = 4000,
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
	runHealth = 0,
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
	{text = "Kaplar!", yell = false},
	{text = "Hurr", yell = false}
}

monster.loot = {
	{name = "gold coin", chance = 66290, maxCount = 25},
	{name = "meat", chance = 4960},
	{name = "minotaur horn", chance = 2030, maxCount = 2},
	{name = "minotaur leather", chance = 1010},
	{id = 3457, chance = 310}, -- shovel
	{name = "bronze amulet", chance = 110},
	--
	{id = 3264, chance = 5000}, -- sword
	{name = "mace", chance = 5000},
	{name = "hatchet", chance = 5000},
	{name = "plate shield", chance = 2000},
	{name = "chain armor", chance = 2000},
	{name = "chain legs", chance = 2000},
	{name = "chain helmet", chance = 2000}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -45}
}

monster.defenses = {
	defense = 11,
	armor = 11
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 20},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = -10},
	{type = COMBAT_HOLYDAMAGE , percent = 10},
	{type = COMBAT_DEATHDAMAGE , percent = -10}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = false},
	{type = "bleed", condition = false}
}

mType:register(monster)

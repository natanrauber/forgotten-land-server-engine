local mType = Game.createMonsterType("Orc Spearman")
local monster = {}

monster.description = "an orc spearman"
monster.experience = 38
monster.outfit = {
	lookType = 50,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 50
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 0,
	Locations = "Orc Fortress, Folda Dungeon, Edron Orc Cave and around it, Ancient Temple, \z
		Venore Orc Cave, below the Point of No Return in Outlaw Camp, Plains of Havoc, \z
		North of Thais in the Orc Peninsula, Elvenbane and Orc Camp in Foreigner Quarter. \z
		Also found in Rookgaard West plains, Zao Orc Land."
	}

monster.health = 105
monster.maxHealth = 105
monster.race = "blood"
monster.corpse = 5996
monster.speed = 88
monster.manaCost = 310

monster.changeTarget = {
	interval = 4000,
	chance = 10
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
	targetDistance = 4,
	runHealth = 10,
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
	{text = "Ugaar!", yell = false}
}

monster.loot = {
	{name = "meat", chance = 30380},
	{name = "gold coin", chance = 24390, maxCount = 11},
	{name = "orc leather", chance = 1920},
	{name = "orc tooth", chance = 100},
	--
	{name = "spear", chance = 10000},
	{name = "sabre", chance = 5000},
	{name = "axe", chance = 5000},
	{name = "machete", chance = 3000},
	{name = "studded shield", chance = 2000},
	{name = "studded helmet", chance = 2000},
	{name = "studded armor", chance = 2000},
	{name = "studded legs", chance = 2000},
	{name = "leather boots", chance = 2000}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -25},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -30, range = 7, shootEffect = CONST_ANI_SPEAR, target = false}
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

local mType = Game.createMonsterType("Wounded Dragon")
local monster = {}

monster.description = "a wounded dragon"
monster.experience = 350
monster.outfit = {
    lookType = 34,
    lookHead = 0,
    lookBody = 0,
    lookLegs = 0,
    lookFeet = 0,
    lookAddons = 0,
    lookMount = 0
}

monster.health = 200
monster.maxHealth = 500
monster.race = "blood"
monster.corpse = 2844
monster.speed = 175
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
    interval = 4000,
    chance = 10
}

monster.strategiesTarget = {
    nearest = 70,
    health = 10,
    damage = 10,
    random = 10
}

monster.flags = {
    summonable = false,
    attackable = true,
    hostile = true,
    convinceable = false,
    pushable = false,
    rewardBoss = false,
    illusionable = true,
    canPushItems = true,
    canPushCreatures = true,
    staticAttackChance = 80,
    targetDistance = 1,
    runHealth = 100,
    healthHidden = false,
    isBlockable = false,
    canWalkOnEnergy = false,
    canWalkOnFire = true,
    canWalkOnPoison = false,
    pet = false
}

monster.light = {
    level = 0,
    color = 0
}

monster.voices = {
    interval = 5000,
    chance = 10,
    {text = "GROOAAARRR", yell = true},
    {text = "FCHHHHH", yell = true}
}

monster.loot = {
    {id = 3028, chance = 380}, -- small diamond
    {id = 3031, chance = 47500, maxCount = 70}, -- gold coin
    {id = 3031, chance = 37500, maxCount = 45}, -- gold coin
    {id = 3285, chance = 4000}, -- longsword
    {id = 3583, chance = 65500, maxCount = 3} -- dragon ham
}

monster.attacks = {
    {name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -75},
    {
        name = "combat",
        interval = 2000,
        chance = 15,
        type = COMBAT_FIREDAMAGE,
        minDamage = -45,
        maxDamage = -105,
        range = 7,
        radius = 5,
        shootEffect = CONST_ANI_FIRE,
        effect = CONST_ME_FIREAREA,
        target = true
    },
    {
        name = "combat",
        interval = 2000,
        chance = 15,
        type = COMBAT_FIREDAMAGE,
        minDamage = -55,
        maxDamage = -125,
        length = 8,
        spread = 3,
        effect = CONST_ME_FIREAREA,
        target = false
    }
}

monster.defenses = {
    defense = 15,
    armor = 15,
    {
        name = "combat",
        interval = 4000,
        chance = 15,
        type = COMBAT_HEALING,
        minDamage = 15,
        maxDamage = 50,
        effect = CONST_ME_MAGIC_BLUE,
        target = false
    }
}

monster.elements = {
    {type = COMBAT_PHYSICALDAMAGE, percent = 0},
    {type = COMBAT_ENERGYDAMAGE, percent = 20},
    {type = COMBAT_EARTHDAMAGE, percent = 80},
    {type = COMBAT_FIREDAMAGE, percent = 100},
    {type = COMBAT_LIFEDRAIN, percent = 0},
    {type = COMBAT_MANADRAIN, percent = 0},
    {type = COMBAT_DROWNDAMAGE, percent = 0},
    {type = COMBAT_ICEDAMAGE, percent = -10},
    {type = COMBAT_HOLYDAMAGE, percent = 0},
    {type = COMBAT_DEATHDAMAGE, percent = 0}
}

monster.immunities = {
    {type = "paralyze", condition = true},
    {type = "outfit", condition = false},
    {type = "invisible", condition = true},
    {type = "bleed", condition = false}
}

mType:register(monster)

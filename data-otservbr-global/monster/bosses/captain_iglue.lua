local mType = Game.createMonsterType("Captain Iglue")
local monster = {}

monster.description = "Captain Iglue"
monster.experience = 250
monster.outfit = {
    lookType = 196,
    lookHead = 0,
    lookBody = 0,
    lookLegs = 0,
    lookFeet = 0,
    lookAddons = 0,
    lookMount = 0
}

monster.health = 275
monster.maxHealth = 275
monster.race = "blood"
monster.corpse = 5566
monster.speed = 250
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
    interval = 5000,
    chance = 8
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
    illusionable = false,
    canPushItems = true,
    canPushCreatures = true,
    staticAttackChance = 90,
    targetDistance = 1,
    runHealth = 0,
    healthHidden = false,
    isBlockable = false,
    canWalkOnEnergy = true,
    canWalkOnFire = true,
    canWalkOnPoison = true,
    pet = false
}

monster.light = {
    level = 0,
    color = 0
}

monster.voices = {
    interval = 5000,
    chance = 10,
    {text = "Yooh Ho Hooh Ho!", yell = false},
    {text = "Hell is waiting for You!", yell = false},
    {text = "The curse! Aww the curse!", yell = false},
    {text = "You will not get my treasure!", yell = false}
}

monster.loot = {
    {name = "gold coin", chance = 48000, maxCount = 67},
    {name = "light shovel", chance = 27000},
    -- torch
    {id = 2050, chance = 10000},
    {name = "sabre", chance = 37000},
    -- die
    {id = 5792, chance = 250}
}

monster.attacks = {
    {
        name = "melee",
        interval = 2000,
        chance = 100,
        minDamage = 0,
        maxDamage = -50,
        condition = {type = CONDITION_POISON, totalDamage = 200, interval = 4000}
    },
    {
        name = "combat",
        interval = 2000,
        chance = 20,
        type = COMBAT_LIFEDRAIN,
        minDamage = -35,
        maxDamage = -95,
        range = 7,
        radius = 3,
        effect = CONST_ME_DRAWBLOOD,
        target = false
    },
    {
        name = "combat",
        interval = 2000,
        chance = 15,
        type = COMBAT_DEATHDAMAGE,
        minDamage = -20,
        maxDamage = -55,
        range = 7,
        radius = 7,
        effect = CONST_ME_SOUND_RED,
        target = false
    },
    {
        name = "speed",
        interval = 2000,
        chance = 30,
        speedChange = -300,
        range = 7,
        radius = 5,
        effect = CONST_ME_MAGIC_RED,
        target = false,
        duration = 2000
    }
}

monster.defenses = {
    defense = 10,
    armor = 10,
    {
        name = "combat",
        interval = 4000,
        chance = 15,
        type = COMBAT_HEALING,
        minDamage = 10,
        maxDamage = 20,
        effect = CONST_ME_MAGIC_BLUE,
        target = false
    }
}

monster.elements = {
    {type = COMBAT_PHYSICALDAMAGE, percent = 70},
    {type = COMBAT_ENERGYDAMAGE, percent = 0},
    {type = COMBAT_EARTHDAMAGE, percent = 0},
    {type = COMBAT_FIREDAMAGE, percent = 0},
    {type = COMBAT_LIFEDRAIN, percent = 0},
    {type = COMBAT_MANADRAIN, percent = 0},
    {type = COMBAT_DROWNDAMAGE, percent = 0},
    {type = COMBAT_ICEDAMAGE, percent = 0},
    {type = COMBAT_HOLYDAMAGE, percent = -25},
    {type = COMBAT_DEATHDAMAGE, percent = 0}
}

monster.immunities = {
    {type = "paralyze", condition = true},
    {type = "outfit", condition = true},
    {type = "invisible", condition = true},
    {type = "bleed", condition = true}
}

mType.onThink = function(monster, interval)
end

mType.onAppear = function(monster, creature)
    if monster:getType():isRewardBoss() then
        monster:setReward(true)
    end
end

mType.onDisappear = function(monster, creature)
end

mType.onMove = function(monster, creature, fromPosition, toPosition)
end

mType.onSay = function(monster, creature, type, message)
end

mType:register(monster)

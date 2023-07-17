-- [tree id] = {stump id, resistance, leaves chance 1/x, twigs chance 1/x, branch chance 1/x, drop, drop max count, drop chance 1/x, changeTo}
local trees = {
    [957] = {7958, 3, 12, 20, 50}, -- birch
    [3612] = {7958, 3, 12, 20, 50}, -- willow
    [3614] = {7958, 3, 12, 20, 50, 19111, 1, 20}, -- fir tree
    [3615] = {7958, 3, 12, 20, 50}, -- sycamore
    [3617] = {7958, 3, 12, 20, 50, 8011, 2, 20}, -- plum tree
    [3618] = {7958, 3, 12, 20, 50}, -- red maple
    [3619] = {7958, 3, 12, 20, 50, 3584, 2, 20}, -- pear tree
    [3620] = {7958, 3, 12, 20, 50}, -- yellow maple
    [3621] = {7958, 3, 12, 20, 50}, -- beech
    [3622] = {7958, 3, 12, 20, 50}, -- poplar
    [3626] = {7958, 3, 12, 20, 50}, -- pine
    [3639] = {7964, 1.5, 16, 0, 0}, -- palm
    [3681] = {7958, 2, 16, 0, 0}, -- bush
    [3682] = {7958, 2, 16, 0, 0}, -- small fir tree
    [3699] = {7958, 2, 16, 0, 0, 3588, 3, 3, 3700}, -- charged blueberry bush
    [3700] = {7958, 2, 16, 0, 0} -- blueberry bush
    -- [50144] = {7958, 3, 12, 20, 50, 8011, 2, 10, 50145}, -- charged plum tree
    -- [50145] = {7958, 3, 12, 20, 50}, --  plum tree
    -- [50146] = {7958, 3, 12, 20, 50, 3584, 2, 20, 50147}, -- charged pear tree
    -- [50147] = {7958, 3, 12, 20, 50} --  pear tree
}

local fruits = {
    [3584] = {5, "Yum."}, -- pear
    [3588] = {1, "Yum."}, -- blueberry
    [8011] = {5, "Yum."} -- plum
}

-- [ON USE TREE]
local tree = Action()
function tree.onUse(player, item, fromPosition, target, toPosition)
    local tree = trees[item.itemid]

    if not tree then
        return false
    end

    local drop = tree[6]
    local fruit = fruits[drop]
    local dropMaxCount = tree[7]
    local dropChance = tree[8]
    local changeTo = tree[9]
    local condition = player:getCondition(CONDITION_REGENERATION, CONDITIONID_DEFAULT)

    if not drop or not fruit or not dropMaxCount or not dropChance or not changeTo then
        return false
    end

    if condition then
        local full = math.floor(condition:getTicks() / 1000 + (fruit[1] * dropMaxCount * 12)) >= 1800
        if full then
            player:sendTextMessage(MESSAGE_FAILURE, "You are full.")
            return true
        end
    end

    item:transform(changeTo)
    player:addItem(drop, math.random(dropMaxCount) - math.random(dropMaxCount) + 1)

    for i = 1, math.random(dropMaxCount) do
        player:feed(fruit[1] * 12)
        player:say(fruit[2], TALKTYPE_MONSTER_SAY)
        player:getPosition():sendSingleSoundEffect(SOUND_EFFECT_TYPE_ACTION_EAT)
    end

    return true
end

for key, value in pairs(trees) do
    if value[6] then
        tree:id(key)
    end
end
tree:register()

-- [ON CUT TREE]
function onCutTree(player, item, fromPosition, target, toPosition, isHotkey)
    local weaponType = ItemType(item.itemid):getWeaponType()
    local tree = trees[target.itemid]

    if weaponType ~= WEAPON_AXE or not tree then
        return false
    end

    local stump = tree[1]
    local resistance = tree[2]

    if not stump or not resistance then
        return false
    end

    local attack = math.min(ItemType(item.itemid):getAttack(), 35)
    local skill = math.min(player:getEffectiveSkillLevel(SKILL_AXE), 35)
    local resultValue = math.floor((10 + (attack * 0.5) + (skill * 0.5)) / resistance)

    if not attack or not skill or not resultValue then
        return false
    end

    if resultValue >= math.random(100) then
        local leavesChance = tree[3]
        local twigsChance = tree[4]
        local branchChance = tree[5]
        local drop = tree[6]
        local dropMaxCount = tree[7]
        local dropChance = tree[8]
        local positions = {
            Position(toPosition.x + 1, toPosition.y + 1, toPosition.z),
            Position(toPosition.x, toPosition.y + 1, toPosition.z),
            Position(toPosition.x - 1, toPosition.y + 1, toPosition.z),
            Position(toPosition.x - 1, toPosition.y, toPosition.z),
            Position(toPosition.x - 1, toPosition.y - 1, toPosition.z),
            Position(toPosition.x, toPosition.y - 1, toPosition.z),
            Position(toPosition.x + 1, toPosition.y - 1, toPosition.z),
            Position(toPosition.x + 1, toPosition.y, toPosition.z)
        }

        target:transform(stump)

        for k, v in pairs(positions) do
            v:sendMagicEffect(CONST_ME_HITBYPOISON)
            v:sendMagicEffect(CONST_ME_POFF)

            local validTile = Tile(v):isWalkable(false, false, false, true, true)

            if validTile then
                if branchChance ~= 0 and math.random(branchChance) == 1 then
                    Game.createItem(30226, 1, v) -- branch
                elseif twigsChance ~= 0 and math.random(twigsChance) == 1 then
                    Game.createItem(3130, 1, v) -- twigs
                elseif leavesChance ~= 0 and math.random(leavesChance) == 1 then
                    Game.createItem(3129, 1, v) -- leaves
                end
                if drop and math.random(dropChance) == 1 then
                    Game.createItem(drop, math.random(dropMaxCount), v) -- drop
                end
            end
        end
    elseif math.random(10) == 1 then
        toPosition:sendMagicEffect(CONST_ME_BLOCKHIT)
        player:addSkillTries(SKILL_AXE, 1, true)
    else
        toPosition:sendMagicEffect(CONST_ME_POFF)
    end

    -- player:sendTextMessage(
    --     MESSAGE_FAILURE,
    --     "skill: " ..
    --         skill ..
    --             "\natk: " ..
    --                 attack ..
    --                     "\nresist: " ..
    --                         resistance ..
    --                             "\ncut chance: " ..
    --                                 (resultValue / 100) * 100 ..
    --                                     "%" .. "\nleaves chance: " .. (1 / leavesChance) * 100 .. "%"
    -- )

    return true
end

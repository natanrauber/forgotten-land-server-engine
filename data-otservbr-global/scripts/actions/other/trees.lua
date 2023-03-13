-- [tree id] = {stump id, resistance, leaves chance 1/x, twigs chance 1/x, branch chance 1/x, drop, drop max count, drop chance 1/x}
local trees = {
    [957] = {7958, 3, 12, 20, 50}, -- birch
    [3614] = {7958, 3, 12, 20, 50, 19111, 1, 20}, -- fir tree
    [3615] = {7958, 3, 12, 20, 50}, -- sycamore
    [3612] = {7958, 3, 12, 20, 50}, -- willow
    [3617] = {7958, 3, 12, 20, 50, 8011, 2, 20}, -- plum tree
    [3618] = {7958, 3, 12, 20, 50}, -- red maple
    [3619] = {7958, 3, 12, 20, 50, 3584, 2, 20}, -- pear tree
    [3620] = {7958, 3, 12, 20, 50}, -- yellow maple
    [3621] = {7958, 3, 12, 20, 50}, -- beech
    [3622] = {7958, 3, 12, 20, 50}, -- poplar
    [3626] = {7958, 3, 12, 20, 50}, -- pine
    [3639] = {7964, 1.5, 16, 0, 0, 3587, 2, 20}, -- palm
    [3640] = {7964, 1.5, 16, 0, 0, 3589, 2, 20}, -- coconut palm
    [3681] = {7958, 2, 16, 0, 0}, -- bush
    [3682] = {7958, 2, 16, 0, 0}, -- small fir tree
    [3699] = {7958, 2, 16, 0, 0, 3588, 5, 3}, -- charged blueberry bush
    [3700] = {7958, 2, 16, 0, 0} -- blueberry bush
}

-- [ON USE TREE]
local tree = Action()

function tree.onUse(player, item, fromPosition, target, toPosition)
    local tree = trees[item.itemid]

    if not tree then
        return false
    end

    if player:getStorageValue(Storage.QuestChests.Tree) > os.time() then
        return false
    end

    local drop = tree[6]
    local dropMaxCount = tree[7]
    local dropChance = tree[8]

    if not drop or not dropMaxCount or not dropChance then
        return false
    end

    toPosition:sendMagicEffect(CONST_ME_POFF)

    if drop and math.random(dropChance) == 1 then
        player:addItem(drop, math.random(dropMaxCount))
    end

    player:setStorageValue(Storage.QuestChests.Tree, os.time() + 60)
    return true
end

for k, v in pairs(trees) do
    local drop = v[5]
    if drop and k ~= 3699 then
        tree:id(k)
    end
end
tree:register()

-- [ON CUT TREE]
function onCutTree(player, item, fromPosition, target, toPosition, isHotkey)
    if ItemType(item.itemid):getWeaponType() ~= WEAPON_AXE then
        return false
    end

    local tree = trees[target.itemid]

    if not tree then
        return false
    end

    local stump = tree[1]
    local resistance = tree[2]
    local leavesChance = tree[3]
    local twigsChance = tree[4]
    local branchChance = tree[5]
    local drop = tree[6]
    local dropMaxCount = tree[7]
    local dropChance = tree[8]

    local attack = math.min(ItemType(item.itemid):getAttack(), 35)
    local skill = math.min(player:getEffectiveSkillLevel(SKILL_AXE), 35)
    local resultValue = math.floor((10 + (attack * 0.5) + (skill * 0.5)) / resistance)

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

    if resultValue >= math.random(100) then
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
            if Tile(v):isWalkable(false, false, false, true, true) then
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

    return true
end

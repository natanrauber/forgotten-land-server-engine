-- [tree id] = {stump id, resistance, leaves chance 1/x, twigs chance 1/x, drop, drop max count, drop chance 1/x}
local trees = {
    [957] = {7958, 3, 16, 20}, -- birch
    [3614] = {7958, 3, 16, 20, 19111, 1, 20}, -- fir tree
    [3615] = {7958, 3, 16, 20}, -- sycamore
    [3616] = {7958, 3, 16, 20}, -- willow
    [3617] = {7958, 3, 16, 20, 8011, 2, 20}, -- plum tree
    [3618] = {7958, 3, 16, 20}, -- red maple
    [3619] = {7958, 3, 16, 20, 3584, 2, 20}, -- pear tree
    [3620] = {7958, 3, 16, 20}, -- yellow maple
    [3621] = {7958, 3, 16, 20}, -- beech
    [3622] = {7958, 3, 16, 20}, -- poplar
    [3626] = {7958, 3, 16, 20}, -- pine
    [3639] = {7964, 1.5, 20, 0, 3587, 2, 20}, -- palm
    [3640] = {7964, 1.5, 20, 0, 3589, 2, 20}, -- coconut palm
    [3681] = {7958, 2, 20, 0}, -- bush
    [3682] = {7958, 2, 20, 0}, -- small fir tree
    [3699] = {7958, 2, 20, 0, 3588, 5, 3}, -- charged blueberry bush
    [3700] = {7958, 2, 20, 0} -- blueberry bush
}

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
    local drop = tree[5]
    local dropMaxCount = tree[6]
    local dropChance = tree[7]

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
            v:sendMagicEffect(CONST_ME_POFF)
            if Tile(v):isWalkable(false, false, false, true, true) then
                if twigsChance ~= 0 and math.random(twigsChance) == 1 then
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

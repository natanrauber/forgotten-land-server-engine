local flowers = {
    [3654] = {3655, 3}, -- moon flowers
    [3656] = {102, 1}, -- white flower
    [3657] = {5921, 1}, -- heaven blossom
    [3892] = {102, 1}, -- dew kisser flower
    [3893] = {102, 1} -- dew kisser flower (3)
}

function onCollectFlower(player, item, fromPosition, target, toPosition, isHotkey)
    local flower = flowers[target.itemid]
    local chance = math.random(5)

    if not flower then
        return false
    elseif chance == 1 then
        toPosition:sendMagicEffect(CONST_ME_BLOCKHIT)
        target:remove(1)
        player:addItemEx(Game.createItem(flower[1], flower[2]), true, CONST_SLOT_WHEREEVER)
    elseif chance == 2 then
        toPosition:sendMagicEffect(CONST_ME_BLOCKHIT)
        target:remove(1)
    else
        toPosition:sendMagicEffect(CONST_ME_BLOCKHIT)
    end

    return true
end

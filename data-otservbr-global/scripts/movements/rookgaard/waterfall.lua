local waterFall = MoveEvent()

function waterFall.onStepIn(creature, item, position, fromPosition)
    local player = creature:getPlayer()
    if not player then
        return true
    end

    if position.y == 32061 then
        player:teleportTo(Position(position.x, 32059, position.z))
    elseif position.y == 32060 then
        player:teleportTo(Position(position.x, 32062, position.z))
    end

    return true
end

waterFall:type("stepin")
waterFall:aid(9991)
waterFall:register()

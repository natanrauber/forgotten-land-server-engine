local drawWell = Action()

function drawWell.onUse(cid, item, position, fromPosition)
    local t = {x = 32023, y = 32174, z = 8}
    doTeleportThing(cid, t)
    return true
end

drawWell:aid(9990)
drawWell:register()

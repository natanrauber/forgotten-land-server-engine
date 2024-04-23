local twinesFarm = Action()

local t = {x = 32021, y = 32182, z = 6}

function twinesFarm.onUse(cid, item, position, fromPosition)
    doTeleportThing(cid, t)
end

twinesFarm:aid(9985)
twinesFarm:register()

local twinesFarm = Action()

local t = {x = 32021, y = 32182, z = 5}

function twinesFarm.onUse(cid, item, position, fromPosition)
    if getPlayerPosition(cid).y == 32183 then
        doTeleportThing(cid, position)
    end
end

twinesFarm:aid(9985)
twinesFarm:register()

local twinesFarm = Action()

local position = {x = 32021, y = 32182, z = 5}

function twinesFarm.onUse(cid)
    if getPlayerPosition(cid).y == 32183 then
        doTeleportThing(cid, position)
    end
end

twinesFarm:aid(9985)
twinesFarm:register()

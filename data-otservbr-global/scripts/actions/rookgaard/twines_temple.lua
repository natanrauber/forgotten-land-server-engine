local twinesTemple = Action()

local position = {x = 32056, y = 32163, z = 4}

function twinesTemple.onUse(cid)
    if getPlayerPosition(cid).x == 32057 then
        doTeleportThing(cid, position)
    end
end

twinesTemple:aid(9999)
twinesTemple:register()

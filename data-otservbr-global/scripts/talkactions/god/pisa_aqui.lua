local pisaAqui = TalkAction("/pisaaqui")

function pisaAqui.onSay(player, words, param)
    if not player:getGroup():getAccess() or player:getAccountType() < ACCOUNT_TYPE_GOD then
        return true
    end

    local position = player:getPosition()

    player:say("Pisa aqui, por favor.", TALKTYPE_MONSTER_SAY)
    position:sendMagicEffect(CONST_ME_TUTORIALARROW)

    return false
end

pisaAqui:separator(" ")
pisaAqui:register()

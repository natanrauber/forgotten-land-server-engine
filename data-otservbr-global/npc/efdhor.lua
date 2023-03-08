local internalNpcName = "A Sweaty Cyclops"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
    lookType = 22
}

npcConfig.flags = {
    floorchange = false
}

npcConfig.voices = {
    interval = 15000,
    chance = 50,
    {text = "Hum hum, huhum"},
    {text = "Silly lil' human"}
}

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

function onCreatureAppear(cid)
    npcHandler:onCreatureAppear(cid)
end
function onCreatureDisappear(cid)
    npcHandler:onCreatureDisappear(cid)
end
function onCreatureSay(cid, type, msg)
    npcHandler:onCreatureSay(cid, type, msg)
end
function onThink()
    npcHandler:onThink()
end

local voices = {
    {text = "Hum hum, huhum"},
    {text = "Silly lil' human"}
}

npcHandler:addModule(VoiceModule:new(voices))

local function creatureSayCallback(cid, type, msg)
    local player = Player(cid)
    local helmetStorageValue = player:getStorageValue(Storage.EfdhorIronHelmet)
    local shieldStorageValue = player:getStorageValue(Storage.EfdhorBattleShield)

    if not npcHandler:isFocused(cid) then
        return false
    end

    if msgcontains(msg, "broken helmet") then
        if helmetStorageValue < 1 then
            npcHandler:say(
                "Me can do unbroken but need iron 100 and need a lil' time to make it unbroken. Yes or no??",
                cid
            )
            npcHandler.topic[cid] = 1
        elseif helmetStorageValue > 1 and helmetStorageValue < os.time() then
            npcHandler:say("Ahh, lil' one wants helmet. Here! Have it! Good helmet lil' one has!", cid)
            player:addItem(2459, 1)
            player:setStorageValue(Storage.EfdhorIronHelmet, 0)
            npcHandler.topic[cid] = 0
        elseif helmetStorageValue > os.time() then
            npcHandler:say("Helmet not finished. Come back later!", cid)
        end
    elseif msgcontains(msg, "battle shield") then
        if shieldStorageValue < 1 then
            npcHandler:say(
                "Lil' one will battle? Me can do good shield to battle. But work no cheap is. Me want plate shield to make it battle. Me want iron 100 too. Yes or no??",
                cid
            )
            npcHandler.topic[cid] = 2
        elseif shieldStorageValue > 1 and shieldStorageValue < os.time() then
            npcHandler:say("Ahh, lil' one wants shield. Here! Have it! Good shield lil' one has!", cid)
            player:addItem(2513, 1)
            player:setStorageValue(Storage.EfdhorBattleShield, 0)
            npcHandler.topic[cid] = 0
        elseif shieldStorageValue > os.time() then
            npcHandler:say("No shield to battle yet. Come back later!", cid)
        end
    elseif msgcontains(msg, "yes") then
        if npcHandler.topic[cid] == 1 then -- iron helmet
            if player:getItemCount(12409) > 0 and player:getItemCount(2225) > 99 then
                player:removeItem(12409, 1)
                player:removeItem(2225, 100)
                -- player:setStorageValue(Storage.EfdhorIronHelmet, os.time() + 86400)
                player:setStorageValue(Storage.EfdhorIronHelmet, os.time() + 10)
                npcHandler:say(
                    "Well, well, I do that! Efdhor makes helmet unbroken! No worry! Come back later for broken helmet.",
                    cid
                )
                npcHandler.topic[cid] = 0
            else
                npcHandler:say("Lil' one do not have what I asked!", cid)
                npcHandler.topic[cid] = 0
            end
        elseif npcHandler.topic[cid] == 2 then -- battle shield
            if player:getItemCount(2510) > 0 and player:getItemCount(2225) > 99 then
                player:removeItem(2510, 1)
                player:removeItem(2225, 100)
                -- player:setStorageValue(Storage.EfdhorBattleShield, os.time() + 86400)
                player:setStorageValue(Storage.EfdhorBattleShield, os.time() + 10)
                npcHandler:say(
                    "Well, well, I do that! Efdhor makes shield to battle! No worry! Come back later for battle shield.",
                    cid
                )
                npcHandler.topic[cid] = 0
            else
                npcHandler:say("Lil' one do not have what I asked!", cid)
                npcHandler.topic[cid] = 0
            end
        end
    end
    return true
end

keywordHandler:addKeyword(
    {"job"},
    StdModule.say,
    {npcHandler = npcHandler, text = "I am smith. But work not much more. Lack steel now."}
)
keywordHandler:addKeyword(
    {"smith"},
    StdModule.say,
    {npcHandler = npcHandler, text = "Working steel is my profession. Me still make some stuff."}
)
keywordHandler:addKeyword(
    {"steel"},
    StdModule.say,
    {
        npcHandler = npcHandler,
        text = "Manny kinds of. Like {Mesh Kaha Rogh'}, {Za'Kalortith}, {Uth'Byth}, {Uth'Amon}, {Uth'Maer}, {Uth'Doon}, and {Zatragil}."
    }
)
keywordHandler:addKeyword(
    {"zatragil"},
    StdModule.say,
    {
        npcHandler = npcHandler,
        text = "Most ancients use dream silver for different stuff. Now ancients most gone. Most not know about."
    }
)
keywordHandler:addKeyword(
    {"uth'doon"},
    StdModule.say,
    {npcHandler = npcHandler, text = "It's high steel called. Only lil' lil' ones know how make."}
)
keywordHandler:addKeyword(
    {"za'kalortith"},
    StdModule.say,
    {
        npcHandler = npcHandler,
        text = "It's evil. Demon iron is. No good cyclops goes where you can find and need evil flame to melt."
    }
)
keywordHandler:addKeyword(
    {"mesh kaha rogh"},
    StdModule.say,
    {npcHandler = npcHandler, text = "Steel that is singing when forged. No one knows where find today."}
)
keywordHandler:addKeyword(
    {"uth'byth"},
    StdModule.say,
    {npcHandler = npcHandler, text = "Not good to make stuff off. Bad steel it is. But eating magic, so useful is."}
)
keywordHandler:addKeyword(
    {"uth'maer"},
    StdModule.say,
    {
        npcHandler = npcHandler,
        text = "Brightsteel is. Much art made with it. Sorcerers too lazy and afraid to enchant much."
    }
)
keywordHandler:addKeyword(
    {"uth'amon"},
    StdModule.say,
    {
        npcHandler = npcHandler,
        text = "Heartiron from heart of big old mountain, found very deep. Lil' lil ones fiercely defend. Not wanting to have it used for stuff but holy stuff."
    }
)
keywordHandler:addKeyword({"lil' lil'"}, StdModule.say, {npcHandler = npcHandler, text = "Lil' lil' ones are so fun."})
keywordHandler:addKeyword({"tibia"}, StdModule.say, {npcHandler = npcHandler, text = "One day I'll go and look."})
keywordHandler:addKeyword({"god"}, StdModule.say, {npcHandler = npcHandler, text = "You shut up. Me not want to hear."})
keywordHandler:addKeyword(
    {"minotaurs"},
    StdModule.say,
    {
        npcHandler = npcHandler,
        text = "They were friend with me {brother}. Me haven't seen him for a while, and me don't know anything about minotaurs since then."
    }
)
keywordHandler:addKeyword(
    {"brother"},
    StdModule.say,
    {
        npcHandler = npcHandler,
        text = "He was working with minotaurs. Me haven't seen him for a while."
    }
)
keywordHandler:addKeyword(
    {"cyclops"},
    StdModule.say,
    {npcHandler = npcHandler, text = "Me people not live here much. Most are far away."}
)
keywordHandler:addKeyword(
    {"iron helmet"},
    StdModule.say,
    {npcHandler = npcHandler, text = "Me can repair broken helmet. And make it better"}
)
keywordHandler:addKeyword({"wood"}, StdModule.say, {npcHandler = npcHandler, text = "Me no work wood. Me work steel."})
keywordHandler:addKeyword(
    {"equipment"},
    StdModule.say,
    {
        npcHandler = npcHandler,
        text = "Me can repair broken equipment. Me can make equipment better too!"
    }
)
keywordHandler:addKeyword(
    {"spike sword"},
    StdModule.say,
    {npcHandler = npcHandler, text = "Me wish I could make weapon like it."}
)
keywordHandler:addKeyword(
    {"iron"},
    StdModule.say,
    {npcHandler = npcHandler, text = "Ahh, yes. Me work iron. Dwarves work iron too. They have quite iron."}
)
keywordHandler:addKeyword(
    {"dwarves"},
    StdModule.say,
    {npcHandler = npcHandler, text = "Me no longer see dwarves. Lil' lil' ones hide very deep."}
)

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setMessage(MESSAGE_GREET, "Hum Humm! Hello.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye lil' one.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye lil' one.")

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)

local internalNpcName = "Dallheim"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
    lookType = 268,
    lookHead = 76,
    lookBody = 38,
    lookLegs = 76,
    lookFeet = 95,
    lookAddons = 2
}

npcConfig.flags = {
    floorchange = false
}

npcConfig.voices = {
    interval = 15000,
    chance = 50,
    {text = "The most dangerous monsters of Rookgaard are on the other side of this bridge."},
    {text = "Want to know what monsters are good for you at your level? Just ask me!"},
    {text = "I'll crush all monsters who dare to attack our base."},
    {text = "Are you injured or poisoned? I can help you."},
    {text = "For Rookgaard! For Tibia!"}
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
    {text = "For Rookgaard! For Tibia!"},
    {text = "No monster shall go past me."},
    {text = "<whispers> ... the dead are coming for us all..."},
    {text = "<whispers> ... until my death..."}
}
npcHandler:addModule(VoiceModule:new(voices))

-- Greeting and Farewell
keywordHandler:addGreetKeyword(
    {"hi"},
    {npcHandler = npcHandler, text = "Greetings, |PLAYERNAME|!"},
    function(player)
        return player:getSex() == PLAYERSEX_MALE
    end
)
keywordHandler:addAliasKeyword({"hello"})

keywordHandler:addGreetKeyword(
    {"hi"},
    {npcHandler = npcHandler, text = "At your service, protecting the {village} from {monsters}."},
    function(player)
        return player:getSex() == PLAYERSEX_FEMALE
    end
)
keywordHandler:addAliasKeyword({"hello"})

keywordHandler:addFarewellKeyword({"bye"}, {npcHandler = npcHandler, text = "Bye, |PLAYERNAME|."})
keywordHandler:addAliasKeyword({"farewell"})

local function addMonsterKeyword(level, text, marks)
    keywordHandler:addKeyword(
        {"monster"},
        StdModule.say,
        {npcHandler = npcHandler, text = text},
        function(player)
            return player:getLevel() >= level
        end,
        function(player)
            if marks then
                for i = 1, #marks do
                    player:addMapMark(marks[i].position, marks[i].type, marks[i].description)
                end
            end
        end
    )
end

-- Monster
keywordHandler:addKeyword(
    {"monster"},
    StdModule.say,
    {
        npcHandler = npcHandler,
        text = "You really should not go into the {wilderness} without a {shield}."
    },
    function(player)
        return not player:hasRookgaardShield()
    end
)

addMonsterKeyword(10, "It looks like you have mastered the drill.")

-- Basic keywords
keywordHandler:addKeyword({"hint"}, StdModule.rookgaardHints, {npcHandler = npcHandler})
keywordHandler:addKeyword(
    {"name"},
    StdModule.say,
    {npcHandler = npcHandler, text = "Daznheimr, in the service of the kingdom."}
)
keywordHandler:addKeyword(
    {"job"},
    StdModule.say,
    {
        npcHandler = npcHandler,
        text = "I'm the guard of this bridge. I defend Rookgaard against the beasts of the {wilderness} and the dungeons."
    }
)
keywordHandler:addKeyword(
    {"time"},
    StdModule.say,
    {npcHandler = npcHandler, text = "I shall live and die at my post. Time is of no importance."}
)
keywordHandler:addKeyword(
    {"bank"},
    StdModule.say,
    {
        npcHandler = npcHandler,
        text = "I don't serve the money."
    }
)
keywordHandler:addKeyword({"how", "are", "you"}, StdModule.say, {npcHandler = npcHandler, text = "Fine."})
keywordHandler:addKeyword(
    {"help"},
    StdModule.say,
    {
        npcHandler = npcHandler,
        text = "I shall live and die at my post. Dallheim can heal you if you are wounded. You can also find other people to help you."
    }
)
keywordHandler:addKeyword(
    {"rat"},
    StdModule.say,
    {
        npcHandler = npcHandler,
        text = "They still can hurt."
    }
)
keywordHandler:addKeyword(
    {"spider"},
    StdModule.say,
    {
        npcHandler = npcHandler,
        text = "They can poison you. Beware of them!"
    }
)
keywordHandler:addKeyword(
    {"troll"},
    StdModule.say,
    {
        npcHandler = npcHandler,
        text = "Once you have a good equipment - maybe leather stuff - and got a better weapon as well as a shield, you should be able to kill trolls."
    }
)
keywordHandler:addKeyword(
    {"wolf"},
    StdModule.say,
    {
        npcHandler = npcHandler,
        text = "They are not that bad."
    }
)
keywordHandler:addAliasKeyword({"wolves"})
keywordHandler:addKeyword(
    {"orc"},
    StdModule.say,
    {
        npcHandler = npcHandler,
        text = "The orcs are numerous and have a fortress. Be very careful!"
    }
)
keywordHandler:addKeyword(
    {"minotaur"},
    StdModule.say,
    {
        npcHandler = npcHandler,
        text = "Minotaurs are very strong. You will need a group of people or be very strong to be able to kill them."
    }
)
keywordHandler:addKeyword(
    {"bug"},
    StdModule.say,
    {
        npcHandler = npcHandler,
        text = "They are a little tougher than they look like."
    }
)
keywordHandler:addKeyword(
    {"skeleton"},
    StdModule.say,
    {
        npcHandler = npcHandler,
        text = "The skeletons are usually fairly hidden, for now. They are often found near graves. Beware of their evil life drain."
    }
)
keywordHandler:addKeyword(
    {"bear"},
    StdModule.say,
    {npcHandler = npcHandler, text = "There is some bear caves close to the village. Be careful, they hit hard!"}
)
keywordHandler:addKeyword(
    {"snake"},
    StdModule.say,
    {
        npcHandler = npcHandler,
        text = "Snakes can poison you, too. Just be careful and kill them fast."
    }
)
keywordHandler:addKeyword({"king"}, StdModule.say, {npcHandler = npcHandler, text = "I take no part."})
keywordHandler:addKeyword(
    {"temple"},
    StdModule.say,
    {npcHandler = npcHandler, text = "A place of protection. Nothing shall harm you there."}
)
keywordHandler:addKeyword(
    {"wilderness"},
    StdModule.say,
    {
        npcHandler = npcHandler,
        text = "There are {bears}, {snakes}, {spiders} and some other monsters in the wilderness past this bridge."
    }
)
-- keywordHandler:addKeyword({"god"}, StdModule.say, {npcHandler = npcHandler, text = "I'm a follower of {Banor}."})
keywordHandler:addKeyword(
    {"banor"},
    StdModule.say,
    {npcHandler = npcHandler, text = "The heavenly warrior! Read {books} to learn about him."}
)
keywordHandler:addKeyword({"magic"}, StdModule.say, {npcHandler = npcHandler, text = "You should talk to Hyacinth."})
keywordHandler:addKeyword(
    {"tibia"},
    StdModule.say,
    {npcHandler = npcHandler, text = "In the world of Tibia, many challenges await the brave adventurer."}
)
keywordHandler:addKeyword(
    {"book"},
    StdModule.say,
    {
        npcHandler = npcHandler,
        text = "There are many books in the {academy}. Theory can be just as important as practice."
    }
)

keywordHandler:addKeyword(
    {"rookgaard"},
    StdModule.say,
    {npcHandler = npcHandler, text = "It's my duty to protect this village and its citizens."}
)
keywordHandler:addAliasKeyword({"protect"})

keywordHandler:addKeyword(
    {"monster"},
    StdModule.say,
    {npcHandler = npcHandler, text = "It looks like you have mastered the drill."}
)

keywordHandler:addKeyword(
    {"trade"},
    StdModule.say,
    {npcHandler = npcHandler, text = "I don't trade. Ask the shop owners instead."}
)
keywordHandler:addAliasKeyword({"offer"})
keywordHandler:addAliasKeyword({"stuff"})
keywordHandler:addAliasKeyword({"wares"})
keywordHandler:addAliasKeyword({"sell"})
keywordHandler:addAliasKeyword({"buy"})
keywordHandler:addAliasKeyword({"sword"})
keywordHandler:addAliasKeyword({"sabre"})
keywordHandler:addAliasKeyword({"equip"})
keywordHandler:addAliasKeyword({"weapon"})
keywordHandler:addAliasKeyword({"armor"})
keywordHandler:addAliasKeyword({"shield"})
keywordHandler:addAliasKeyword({"food"})
keywordHandler:addAliasKeyword({"potion"})

-- Names
keywordHandler:addKeyword(
    {"norma"},
    StdModule.say,
    {
        npcHandler = npcHandler,
        text = "I heard she has a bar, but I don't know her."
    }
)
keywordHandler:addKeyword({"loui"}, StdModule.say, {npcHandler = npcHandler, text = "I think he's going mad."})
keywordHandler:addKeyword(
    {"obi"},
    StdModule.say,
    {npcHandler = npcHandler, text = "He sells {weapons}. His shop is close to the {temple}."}
)
keywordHandler:addKeyword(
    {"santiago"},
    StdModule.say,
    {npcHandler = npcHandler, text = "He dedicated his life to welcoming newcomers to this island."}
)
-- keywordHandler:addKeyword({"zirella"}, StdModule.say, {npcHandler = npcHandler, text = "She has her own problems."})
keywordHandler:addKeyword(
    {"al", "dee"},
    StdModule.say,
    {npcHandler = npcHandler, text = "There's something about this guy I don't like."}
)
keywordHandler:addKeyword(
    {"amber"},
    StdModule.say,
    {npcHandler = npcHandler, text = "She's a beautiful adventurer. People talk about her journeys."}
)
keywordHandler:addKeyword(
    {"cipfried"},
    StdModule.say,
    {
        npcHandler = npcHandler,
        text = "He guards the temple and can heal you."
    }
)
keywordHandler:addKeyword(
    {"dixi"},
    StdModule.say,
    {
        npcHandler = npcHandler,
        text = "She's {Obi's} granddaughter and deals with {armors} and {shields}."
    }
)
keywordHandler:addKeyword(
    {"hyacinth"},
    StdModule.say,
    {npcHandler = npcHandler, text = "One of these reclusive druids."}
)
keywordHandler:addKeyword(
    {"lee'delle"},
    StdModule.say,
    {npcHandler = npcHandler, text = "She runs a shop, west of the village."}
)
keywordHandler:addKeyword(
    {"lily"},
    StdModule.say,
    {
        npcHandler = npcHandler,
        text = "She's a druid, just like {Hyacinth}. Her {potions} might come in handy."
    }
)
-- keywordHandler:addKeyword(
-- 	{"oracle"},
-- 	StdModule.say,
-- 	{
-- 		npcHandler = npcHandler,
-- 		text = "You can find the oracle on the top floor of the {academy}, just above {Seymour}. Go there when you are level 8."
-- 	}
-- )
-- keywordHandler:addKeyword({"paulie"}, StdModule.say, {npcHandler = npcHandler, text = "The local {bank} clerk."})
keywordHandler:addKeyword(
    {"seymour"},
    StdModule.say,
    {npcHandler = npcHandler, text = "His job of teaching young heroes is important for the survival of all of us."}
)
keywordHandler:addKeyword(
    {"tom"},
    StdModule.say,
    {npcHandler = npcHandler, text = "He's the local tanner. You could try selling fresh corpses or leather to him."}
)
keywordHandler:addKeyword(
    {"dallheim"},
    StdModule.say,
    {
        npcHandler = npcHandler,
        text = "He does a fine job, protecting the village."
    }
)
-- keywordHandler:addKeyword({"Daznheimr"}, StdModule.say, {npcHandler = npcHandler, text = "At your service."})
-- keywordHandler:addKeyword(
-- 	{"billy"},
-- 	StdModule.say,
-- 	{
-- 		npcHandler = npcHandler,
-- 		text = "He's a farmer. A little more friendly than his cousin {Willie}, he also buys and sells {food}."
-- 	}
-- )
-- keywordHandler:addKeyword(
-- 	{"willie"},
-- 	StdModule.say,
-- 	{npcHandler = npcHandler, text = "He's quite rude. Also, he buys and sells {food}."}
-- )

-- Healing
keywordHandler:addKeyword(
    {"heal"},
    StdModule.say,
    {npcHandler = npcHandler, text = "Eat some food to regain strength. If you're really bad, Cipfried can help you."}
)

npcHandler:setMessage(MESSAGE_WALKAWAY, "Hm.")
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)

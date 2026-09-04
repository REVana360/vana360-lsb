describe('July Southern San dOria tutorial profile', function()
    local tutorialVar = 'HQuest[Tutorial]Prog'

    it('uses the July introduction and Signet events', function()
        local player = xi.test.world:spawnPlayer({ zone = xi.zone.SOUTHERN_SAN_DORIA })

        player.entities:gotoAndTrigger('Alaune', { eventId = 934 })
        assert(player:getCharVar(tutorialVar) == 1)

        player.entities:gotoAndTrigger('Alaune', { eventId = 916 })
        assert(player:getCharVar(tutorialVar) == 2)
    end)

    it('uses the July reward path through the auction lesson', function()
        local player = xi.test.world:spawnPlayer({ zone = xi.zone.SOUTHERN_SAN_DORIA })

        player:setCharVar(tutorialVar, 2)
        player:addStatusEffect(xi.effect.SIGNET, { origin = player })
        player.entities:gotoAndTrigger('Alaune', { eventId = 918 })
        assert(player:getItemCount(xi.item.STRIP_OF_MEAT_JERKY) == 6)
        assert(player:getCharVar(tutorialVar) == 3)

        player:setCharVar(tutorialVar, 4)
        player:setSkillLevel(xi.skill.SWORD, 50)
        player.entities:gotoAndTrigger('Alaune', { eventId = 922 })
        assert(player:getItemCount(xi.item.CHUNK_OF_ROCK_SALT) == 1)
        assert(player:getItemCount(xi.item.SLICE_OF_HARE_MEAT) == 1)
        assert(player:getItemCount(xi.item.FIRE_CRYSTAL) == 1)
        assert(player:getCharVar(tutorialVar) == 5)

        player.entities:gotoAndTrigger('Alaune', { eventId = 923 })
        assert(player:getCharVar(tutorialVar) == 5)
    end)

    it('uses the July level and gate-crystal events', function()
        local player = xi.test.world:spawnPlayer({ zone = xi.zone.SOUTHERN_SAN_DORIA })

        player:setCharVar(tutorialVar, 6)
        player.entities:gotoAndTrigger('Alaune', { eventId = 924 })
        assert(player:hasKeyItem(xi.ki.CONQUEST_PROMOTION_VOUCHER))
        assert(player:getCharVar(tutorialVar) == 7)

        player:setLevel(4)
        player.entities:gotoAndTrigger('Alaune', { eventId = 926 })
        assert(player:getItemCount(xi.item.RAISING_EARRING) == 1)
        assert(player:getCharVar(tutorialVar) == 8)

        player.entities:gotoAndTrigger('Alaune', { eventId = 927 })
        assert(player:getCharVar(tutorialVar) == 9)

        player:setCharVar(tutorialVar, 11)
        player:addKeyItem(xi.ki.HOLLA_GATE_CRYSTAL)
        player.entities:gotoAndTrigger('Alaune', { eventId = 932 })
        assert(player:getItemCount(xi.item.FREE_CHOCOPASS) == 3)
        assert(player:getCharVar(tutorialVar) == 12)

        player.entities:gotoAndTrigger('Alaune', { eventId = 933 })
    end)
end)

describe("July 2009 quest: A Knight's Test", function()
    it('does not grant the post-July paladin gesture', function()
        local player = xi.test.world:spawnPlayer({ zone = xi.zone.SOUTHERN_SAN_DORIA })

        player:addQuest(xi.questLog.SANDORIA, xi.quest.id.sandoria.A_KNIGHTS_TEST)
        player:addKeyItem(xi.ki.KNIGHTS_SOUL)
        player.entities:gotoAndTrigger('Balasiel', { eventId = 628 })

        player.assert:hasCompletedQuest(xi.questLog.SANDORIA, xi.quest.id.sandoria.A_KNIGHTS_TEST)
        player.assert.no:hasKI(xi.ki.JOB_GESTURE_PALADIN)
    end)
end)

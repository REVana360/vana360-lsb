-----------------------------------
-- Attachment: Ice Maker
-- Description: Consumes Ice Maneuvers to increase magic damage.
-- Adds 20%, 40%, or 60% to the magic attack bonus coefficient.
-- https://wiki.ffo.jp/html/11198.html
-----------------------------------
---@type TAttachment
local attachmentObject = {}

local validIceMakerSpells = set
{
    xi.magic.spell.FIRE,
    xi.magic.spell.FIRE_II,
    xi.magic.spell.FIRE_III,
    xi.magic.spell.FIRE_IV,
    xi.magic.spell.FIRE_V,
    xi.magic.spell.BLIZZARD,
    xi.magic.spell.BLIZZARD_II,
    xi.magic.spell.BLIZZARD_III,
    xi.magic.spell.BLIZZARD_IV,
    xi.magic.spell.BLIZZARD_V,
    xi.magic.spell.AERO,
    xi.magic.spell.AERO_II,
    xi.magic.spell.AERO_III,
    xi.magic.spell.AERO_IV,
    xi.magic.spell.AERO_V,
    xi.magic.spell.STONE,
    xi.magic.spell.STONE_II,
    xi.magic.spell.STONE_III,
    xi.magic.spell.STONE_IV,
    xi.magic.spell.STONE_V,
    xi.magic.spell.THUNDER,
    xi.magic.spell.THUNDER_II,
    xi.magic.spell.THUNDER_III,
    xi.magic.spell.THUNDER_IV,
    xi.magic.spell.THUNDER_V,
    xi.magic.spell.WATER,
    xi.magic.spell.WATER_II,
    xi.magic.spell.WATER_III,
    xi.magic.spell.WATER_IV,
    xi.magic.spell.WATER_V,
}

attachmentObject.onEquip = function(pet, attachment)
    pet:addListener('MAGIC_USE', 'AUTO_ICE_MAKER_USE', function(automaton, target, spell, action)
        if not validIceMakerSpells[spell:getID()] then
            return
        end

        local master = automaton:getMaster()

        if not master then
            return
        end

        local iceManeuvers = master:countEffect(xi.effect.ICE_MANEUVER)

        for i = 1, iceManeuvers do
            master:delStatusEffectSilent(xi.effect.ICE_MANEUVER)
        end

        master:updateAttachments()
    end)

    xi.automaton.onAttachmentEquip(pet, attachment)
end

attachmentObject.onUnequip = function(pet, attachment)
    xi.automaton.onAttachmentUnequip(pet, attachment)
    pet:removeListener('AUTO_ICE_MAKER_USE')
end

attachmentObject.onManeuverGain = function(pet, attachment, maneuvers)
    xi.automaton.onManeuverGain(pet, attachment, maneuvers)
end

attachmentObject.onManeuverLose = function(pet, attachment, maneuvers)
    xi.automaton.onManeuverLose(pet, attachment, maneuvers)
end

attachmentObject.onUpdate = function(pet, attachment, maneuvers)
    xi.automaton.updateAttachmentModifier(pet, attachment, maneuvers)
end

return attachmentObject

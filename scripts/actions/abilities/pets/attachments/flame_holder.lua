-----------------------------------
-- Attachment: Flame Holder
-- Description: Consumes Fire Maneuvers to increase weapon skill damage.
-- Adds 12.5%, 15%, or 17.5% per maneuver with one, two, or three maneuvers.
-- https://wiki.ffo.jp/html/11183.html
-----------------------------------
---@type TAttachment
local attachmentObject = {}

local validFlameHolderSkills = set
{
    xi.mobSkill.ARCUBALLISTA_AUTOMATON,
    xi.mobSkill.ARMOR_PIERCER_AUTOMATON,
    xi.mobSkill.ARMOR_SHATTERER_AUTOMATON,
    xi.mobSkill.BONE_CRUSHER_AUTOMATON,
    xi.mobSkill.CANNIBAL_BLADE_AUTOMATON,
    xi.mobSkill.CHIMERA_RIPPER_AUTOMATON,
    xi.mobSkill.DAZE_AUTOMATON,
    xi.mobSkill.KNOCKOUT_AUTOMATON,
    xi.mobSkill.MAGIC_MORTAR_AUTOMATON,
    xi.mobSkill.SLAPSTICK_AUTOMATON,
    xi.mobSkill.STRING_CLIPPER_AUTOMATON,
    xi.mobSkill.STRING_SHREDDER_AUTOMATON,
}

attachmentObject.onEquip = function(pet, attachment)
    pet:addListener('WEAPONSKILL_STATE_EXIT', 'AUTO_FLAME_HOLDER_END', function(automaton, skillId, wasExecuted)
        if not validFlameHolderSkills[skillId] then
            return
        end

        if not wasExecuted then
            return
        end

        local master = automaton:getMaster()

        if not master then
            return
        end

        -- Consume all Fire Maneuvers on weaponskill execution.
        local fireManeuvers = master:countEffect(xi.effect.FIRE_MANEUVER)

        for i = 1, fireManeuvers do
            master:delStatusEffectSilent(xi.effect.FIRE_MANEUVER)
        end

        master:updateAttachments()
    end)

    xi.automaton.onAttachmentEquip(pet, attachment)
end

attachmentObject.onUnequip = function(pet, attachment)
    xi.automaton.onAttachmentUnequip(pet, attachment)
    pet:removeListener('AUTO_FLAME_HOLDER_END')
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

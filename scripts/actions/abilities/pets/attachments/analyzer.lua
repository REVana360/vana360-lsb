-----------------------------------
-- Attachment: Analyzer
-- Description: Remembers one mob skill and reduces its subsequent damage.
-- Damage reduction is 10% plus 10% per Earth Maneuver.
-- https://wiki.ffo.jp/html/10746.html
-----------------------------------
---@type TAttachment
local attachmentObject = {}

attachmentObject.onEquip = function(pet, attachment)
    pet:setLocalVar('analyzedSkill1', 0)

    pet:addListener('WEAPONSKILL_TAKE', 'ANALYZER_WEAPONSKILL_TAKE', function(mob, target, skill, tp, action)
        local analyzerModifier = target:getMod(xi.mod.AUTO_ANALYZER)
        local incomingSkill    = skill:getID()

        if analyzerModifier <= 0 then
            return
        end

        local analyzedSkill = target:getLocalVar('analyzedSkill1')

        if incomingSkill == analyzedSkill then
            return
        end

        if incomingSkill ~= analyzedSkill then
            target:setLocalVar('analyzedSkill1', incomingSkill)
        end
    end)

    xi.automaton.onAttachmentEquip(pet, attachment)
end

attachmentObject.onUnequip = function(pet, attachment)
    pet:setLocalVar('analyzedSkill1', 0)

    pet:removeListener('ANALYZER_WEAPONSKILL_TAKE')

    xi.automaton.onAttachmentUnequip(pet, attachment)
end

attachmentObject.onManeuverGain = function(pet, attachment, maneuvers)
end

attachmentObject.onManeuverLose = function(pet, attachment, maneuvers)
end

attachmentObject.onUpdate = function(pet, attachment, maneuvers)
end

return attachmentObject

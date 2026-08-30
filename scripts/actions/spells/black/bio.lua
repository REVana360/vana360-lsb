-----------------------------------
-- Spell: Bio
-- Deals dark damage that weakens an enemy's attacks and gradually reduces its HP.
-----------------------------------
---@type TSpell
local spellObject = {}

spellObject.onMagicCastingCheck = function(caster, target, spell)
    return 0
end

-- Source: https://forum.square-enix.com/ffxi/threads/55263-April.-3-2019-%28JST%29-Version-Update
spellObject.onSpellCast = function(caster, target, spell)
    local damage = xi.spells.damage.useDamageSpell(caster, target, spell)
    local tier   = 2

    -- Check for Dia.
    local dia = target:getStatusEffect(xi.effect.DIA)
    if
        not dia or
        (dia and dia:getTier() < tier)
    then
        target:delStatusEffect(xi.effect.DIA)

        -- Calculate DoT effect: http://wiki.ffo.jp/html/1954.html
        local power = caster:getSkillLevel(xi.skill.DARK_MAGIC)
        power       = math.ceil(power / 40)
        power       = utils.clamp(power, 1, 3)

        target:addStatusEffect(xi.effect.BIO, { power = power, duration = 60, origin = caster, tick = 3, subPower = 5, tier = tier })
    end

    return damage
end

return spellObject

-----------------------------------
-- Spell: Dia III
-- Lowers an enemy's defense and gradually deals light elemental damage.
-----------------------------------
---@type TSpell
local spellObject = {}

spellObject.onMagicCastingCheck = function(caster, target, spell)
    return 0
end

-- Source: https://forum.square-enix.com/ffxi/threads/55263-April.-3-2019-%28JST%29-Version-Update
spellObject.onSpellCast = function(caster, target, spell)
    local damage = xi.spells.damage.useDamageSpell(caster, target, spell)
    local tier   = 5

    -- Check for Bio
    local bio = target:getStatusEffect(xi.effect.BIO)
    if
        not bio or
        (bio and bio:getTier() < tier)
    then
        target:delStatusEffect(xi.effect.BIO)
        local power = 3 + caster:getMod(xi.mod.DIA_DOT)

        target:addStatusEffect(xi.effect.DIA, { power = power, duration = 180, origin = caster, tick = 3, subPower = 15, tier = tier })
    end

    return damage
end

return spellObject

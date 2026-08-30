-----------------------------------
-- Ability: Healer's Roll
-- Restores MP over time for party members within area of effect
-- Optimal Job: White Mage
-- Lucky Number: 3
-- Unlucky Number: 7
-- Level: 20
-- Phantom Roll +1 Value: 3
--
-- Die Roll    |No WHM  |With WHM
-- --------    -------  -----------
-- 1           |+2MP/Tick |+5MP/Tick
-- 2           |+3MP/Tick |+6MP/Tick
-- 3           |+10MP/Tick|+13MP/Tick
-- 4           |+4MP/Tick |+7MP/Tick
-- 5           |+4MP/Tick |+7MP/Tick
-- 6           |+5MP/Tick |+8MP/Tick
-- 7           |+1MP/Tick |+4MP/Tick
-- 8           |+6MP/Tick |+9MP/Tick
-- 9           |+7MP/Tick |+10MP/Tick
-- 10          |+7MP/Tick |+10MP/Tick
-- 11          |+12MP/Tick|+15MP/Tick
-- Bust        |-3MP/Tick |-3MP/Tick
--
-- Note that this roll restores MP to the recipient; it does not modify a caster's spell potency
-----------------------------------
---@type TAbility
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return xi.job_utils.corsair.onRollAbilityCheck(player, target, ability)
end

abilityObject.onUseAbility = function(caster, target, ability, action)
    return xi.job_utils.corsair.onRollUseAbility(caster, target, ability, action)
end

return abilityObject

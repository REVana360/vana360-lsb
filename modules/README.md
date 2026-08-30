# Modules

Please see `init.txt` for how to load modules.

Please see [the module guide on the wiki](https://github.com/LandSandBoat/server/wiki/Module-Guide) for a comprehensive guide on how to write and use Lua, C++, and SQL modules.

## The module contract

A module is a bag of overrides. A Lua module constructs a `Module` and declares at least one override; a `Module` with no declared overrides is a startup error. Module files return nothing: constructing a `Module` registers it with the loader. A file that constructs no `Module` at all is treated as a data or helper file for other modules to `require`, and is left alone.

```lua
require('modules/module_utils')

local m = Module:new('my_module_name')

m:addOverride('xi.some.target.func', function(...)
    -- super(...) calls the function this one replaced
end)
```

Overrides are always declared. Whether they are applied is a separate question, controlled in one of two ways:

- A module-level condition: `Module:new('my_module', someBooleanCondition)`. When the condition is false the module's overrides are declared, logged, and skipped.
- Per-era cases with `addOverrideByEra` (see below).

The loader logs every declared override at debug level (`logging.DEBUG_MODULES`), including why a skipped override was skipped.

Command modules register with `xi.module.registerCommand('name', commandTable)` instead of returning the command table.

Mutating game data at require time is forbidden. Data changes are declared as an override of `xi.server.onServerStart` that calls `super()` first and then applies the changes.

## Expansion-aware modules

An override that changes across retail eras can declare one implementation per era with `addOverrideByEra`, keyed by `xi.expansion` (defined in `module_utils.lua`). A case applies when its expansion's content is disabled:

```lua
m:addOverrideByEra('xi.job_utils.dragoon.addWyvernExp', {
    [xi.expansion.ROV]  = function(player, exp) ... end, -- applies when ENABLE_ROV is off
    [xi.expansion.SOA]  = function(player, exp) ... end, -- applies when ENABLE_SOA is off
    [xi.expansion.WOTG] = function(player, exp) ... end, -- applies when ENABLE_WOTG is off
})
```

Every applicable case is applied, newest era first, so the oldest era's implementation ends up outermost and its `super` chain reaches back through the newer reverts. Declaration order in the file does not matter.

Use `addOverrideByEra` only when more than one expansion makes changes in the file. A module whose changes all belong to one expansion takes the gate as a module condition and declares plain overrides:

```lua
local m = Module:new('pre_wotg_behavior', xi.pre(xi.expansion.WOTG))
```

`xi.pre(expansion)` is true when the server is configured to before that expansion's changes (content restriction on, expansion content disabled).

`xi.expansion` covers every `ENABLE_<tag>` content setting, in release order:

- ROTZ      : Rise of the Zilart (April 2003)
- COP       : Chains of Promathia (September 2004 - March 2006)
- TOAU      : Treasures of Aht Urhgan (April 2006 - October 2007)
- WOTG      : Wings of the Goddess (November 2007 - May 2010)
- ACP       : A Crystalline Prophecy (June 2009)
- AMK       : A Moogle Kupo d'Etat (July 2009)
- ASA       : A Shantotto Ascension (March 2010)
- ABYSSEA   : Abyssea Add-ons (June 2010 - February 2013)
- VOIDWATCH : Voidwatch (November 2011)
- SOA       : Seekers of Adoulin (March 2013 - April 2015)
- ROV       : Rhapsodies of Vana'diel (May 2015 - July 2020)
- TVR       : The Voracious Resurgence (August 2020 - Present)

The module header comment should carry the dates and patch notes for the behavior it changes.

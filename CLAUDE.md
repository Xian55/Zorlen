## Zorlen WoW Addon

Spell casting and combat helper addon for **vanilla WoW 1.12** (Interface 11200) with **TurtleWoW** support. Written in **Lua 5.0**.

### Target Environment
- WoW 1.12.x vanilla API — uses `getfenv(0)`, `CastSpellByName()`, `UseAction()`, classic event names (`SPELLCAST_START`, not `UNIT_SPELLCAST_START`)
- TurtleWoW custom spells supported (CrusaderStrike, HolyStrike, Zeal, KillCommand)
- Max player level: 60, max debuff slots: 16
- No `C_Timer`, no `_G` shorthand, no `#` length operator (use `table.getn()`)

### Project Structure
```
Zorlen/                              Main addon package
  Zorlen.toc                         TOC (Interface 11200)
  Zorlen.xml                         Frame + script load order manifest
  Bindings.xml                       Key binding declarations
  Localization_Zorlen_EN.lua         English (master, creates LOCALIZATION_ZORLEN = {})
  Localization_Zorlen_FR/DE/KR/      Other languages (overwrite EN entries)
    CN/TW/RU.lua
  Zorlen.lua                         Core: events, spell info, utilities (~5800 lines)
  Zorlen_ImmuneMobList.lua           Hardcoded immune mob tracking
  Zorlen_Other.lua                   Racials, creature types, attack/shoot
  Zorlen_Pets.lua                    Pet management + map-generated pet functions
  Zorlen_Druid.lua                   Class-specific files (one per class)
  Zorlen_Hunter.lua
  Zorlen_Mage.lua
  Zorlen_Paladin.lua
  Zorlen_Priest.lua
  Zorlen_Rogue.lua
  Zorlen_Shaman.lua
  Zorlen_Warlock.lua
  Zorlen_Warrior.lua
  MyFunctions.lua                    User extension slot (not in repo)

Zorlen_WarriorSpam/                  Companion addon (depends on Zorlen)
  Zorlen_WarriorSpam.toc
  Zorlen_WarriorSpam.xml
  Zorlen_WarriorSpam.lua             Warrior rotation logic
  Bindings.xml
```

Load order (from `Zorlen.xml`): Localization files first, then `Zorlen.lua`, `Zorlen_ImmuneMobList.lua`, `Zorlen_Other.lua`, `Zorlen_Pets.lua`, class files alphabetically, then `MyFunctions.lua`.

### Code Conventions
- **Indentation:** Tabs
- **Global functions:** `camelCase` for public API (`castBattleStance`, `isRenew`, `needPet`)
- **Zorlen_ prefix functions:** `PascalCase` after prefix (`Zorlen_CastCommonRegisteredSpell`, `Zorlen_checkBuff`)
- **Config constants:** `ZORLEN_ALL_CAPS` (`ZORLEN_DEBUG`, `ZORLEN_FOODOFF`)
- **Pet functions:** `z` prefix (`zDash`, `zGrowl`, `zFireShield`)
- **Aliases:** Short aliases assigned after definition: `petInCombat = Zorlen_petInCombat`
- **File build numbers:** `Zorlen_FILENAME_FileBuildNumber` at top of each file

### Cast Function Pattern (primary pattern)
The `z = {}` table + `Zorlen_CastCommonRegisteredSpell(z)` dispatch:
```lua
function castBattleStance(test)
	local z = {}
	z.Test = test
	z.SpellName = LOCALIZATION_ZORLEN.BattleStance
	z.EnemyTargetNotNeeded = 1
	return Zorlen_CastCommonRegisteredSpell(z)
end
```

Common `z` table fields: `SpellName`, `Rank`, `Test` (dry-run), `ManaNeeded`, `DebuffName`, `BuffName`, `EnemyTargetNotNeeded`, `StopCasting`, `NoRangeCheck`, `SelfHealthGreaterThanPercent`, `DebuffTimer`.

When adding precondition guards (weapon checks, stealth checks, etc.), place them **before** the `local z = {}` allocation to avoid unnecessary table creation on early exit.

### Map-Based Function Generation (newer pattern)
Used in `Zorlen_Priest.lua`, `Zorlen_Paladin.lua`, `Zorlen_Pets.lua`. Generates global functions from declarative maps:
```lua
local global = getfenv(0)

local SpellMap = {
	isRenew = {icon = "Spell_Holy_Renew", type = "buff"},
	isShadowWordPain = {icon = "Shadow_ShadowWordPain", type = "debuff"},
}

for funcName, config in pairs(SpellMap) do
	do  -- do block creates fresh scope for closure captures
		local cfg = config
		global[funcName] = function(unit, param2)
			if cfg.type == "buff" then
				return Zorlen_checkBuff(cfg.icon, unit or "target", param2)
			end
			return false
		end
	end
end
```

Always wrap loop body in `do ... end` to prevent closure capture bugs.

### Loop Continue Idiom
Lua 5.0 has no `continue`. Use `repeat...until true` inside `for`/`while`:
```lua
for i = 1, n do repeat
	if not condition then break end  -- acts as "continue"
	-- main logic here
until true end
```

`break` exits only the inner `repeat` block, advancing to the next loop iteration. Code that must run unconditionally each iteration (like `counter = counter + 1`) goes **after** `until true` but **before** `end`.

### Class File Structure
Each class file follows this order:
1. `Zorlen_ClassName_FileBuildNumber` global
2. Changelog in `--[[ ... ]]` block
3. Class-agnostic utility functions (loaded for all classes)
4. Guard: `if not Zorlen_isCurrentClassXxx then return end`
5. Map definitions and generated functions (newer files)
6. Hand-written cast/utility functions
7. Sanity check / test functions

### Localization
Single global `LOCALIZATION_ZORLEN` table. EN file creates it, other languages overwrite entries:
```lua
-- Keys are CamelCase identifiers, values are in-game strings
LOCALIZATION_ZORLEN["ShadowWordPain"] = "Shadow Word: Pain"
```

Access via `LOCALIZATION_ZORLEN.SpellName` or `LOCALIZATION_ZORLEN["SpellName"]`.

### Event Handling
All events registered on `ZorlenFrame` in `Zorlen_OnLoad()`, dispatched through a single `Zorlen_OnEvent(event, arg1, arg2, arg3)` if/elseif chain. Some modules (Priest, Pets) create additional per-module frames for specific events like `PLAYER_LOGIN` and `PET_BAR_UPDATE`.

### Key Spell Systems
- `Zorlen_Button[SpellName]` — action bar slot for spell (populated by scanning)
- `Zorlen_SpellInfo[spellId]` — spell data (name, rank, cost, castTime, minVal, maxVal)
- `Zorlen_SpellIdsByRankbySpellName[name][rank]` — reverse lookup
- `Zorlen_GetSpellID(name, rank)`, `Zorlen_IsSpellKnown(name)`, `Zorlen_GetSpellRank(name)`
- `Zorlen_checkCooldown(SpellID)`, `Zorlen_checkBuff(icon, unit)`, `Zorlen_checkDebuff(icon, unit)`

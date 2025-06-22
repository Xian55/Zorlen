Zorlen_Paladin_FileBuildNumber = 700

if not Zorlen_isCurrentClassPaladin then return end

local global = getfenv(0)
local find = string.find

local countFunctions = 0


local BuffCheckMap = {
	-- Auras
	isDAA  = "DevotionAura",
	isCAA  = "ConcentrationAura",
	isFiRAA = "FireResistanceAura",
	isFrRAA = "FrostResistanceAura",
	isRAA  = "RetributionAura",
	isSRAA = "ShadowResistanceAura",
	isSAA  = "SanctityAura",

	-- Blessings
	isBoFA = "BlessingOfFreedom",
	isBoKA = "BlessingOfKings",
	isBoLA = "BlessingOfLight",
	isBoMA = "BlessingOfMight",
	isBoPA = "BlessingOfProtection",
	isBoSacA = "BlessingOfSacrifice",
	isBoSalA = "BlessingOfSalvation",
	isBoSanA = "BlessingOfSanctuary",
	isBoWA = "BlessingOfWisdom",

	-- Greater Blessings
	isGBoKA = "GreaterBlessingOfKings",
	isGBoLA = "GreaterBlessingOfLight",
	isGBoMA = "GreaterBlessingOfMight",
	isGBoSalA = "GreaterBlessingOfSalvation",
	isGBoSanA = "GreaterBlessingOfSanctuary",
	isGBoWA = "GreaterBlessingOfWisdom",

	-- Seals
	isSoJA = "SealOfJustice",
	isSoLA = "SealOfLight",
	isSoRA = "SealOfRighteousness",
	isSoWA = "SealOfWisdom",
	isSotCA = "SealOfTheCrusader",
	isSoCA = "SealOfCommand",

	-- Other buffs
	isSenseUndeadActive = "SenseUndead",
	isHolyShieldActive = "HolyShield",
	isDivineProtectionActive = "DivineProtection",
	isRighteousFuryActive = "RighteousFury",
	isRedoubtActive = "Redoubt",
	isZealActive = "Zeal"
}

for funcName, localizedKey in pairs(BuffCheckMap) do
	local f = funcName
	local key = localizedKey

	global[f] = function()
		local spellName = LOCALIZATION_ZORLEN and LOCALIZATION_ZORLEN[key]
		if not spellName then return false end
		return Zorlen_checkBuffByOnlyName(spellName)
	end

	-- Create a function to check if the buff is active
	-- This is used for the is*Active functions
	global["is" .. key .. "Active"] = global[f]  -- Create an alias for the active check

	countFunctions = countFunctions + 2
end


local AuraCastMap = {
	castDA    = "DevotionAura",
	castRA    = "RetributionAura",
	castCA    = "ConcentrationAura",
	castSRA   = "ShadowResistanceAura",
	castFrRA  = "FrostResistanceAura",
	castFiRA  = "FireResistanceAura",
	castSotC  = "SealOfTheCrusader",
	castSoR   = "SealOfRighteousness",
	castSoJ   = "SealOfJustice",
	castSoL   = "SealOfLight",
	castSoW   = "SealOfWisdom",
	castSoC   = "SealOfCommand",
	--
	castCrusaderStrike = "CrusaderStrike",
	castHolyStrike = "HolyStrike",
}

for funcName, spellKey in pairs(AuraCastMap) do
	do
		local f = funcName
		local key = spellKey

		global[f] = function(AnySealOrTest, test)

			AnySealOrTest = AnySealOrTest or false
			test = test or false

			Zorlen_debug("Zorlen: " .. f .. " called with AnySealOrTest: " .. tostring(AnySealOrTest) .. ", test: " .. tostring(test))

			-- Handle optional arguments: (AnySeal, test) vs (test)
			local isSealCast = (find(f, "^castSo") ~= nil) or (f == "castSotC")
			local isSealBlocked = isSealCast and AnySealOrTest
			local actualTest = isSealCast and test or AnySealOrTest

			if isSealBlocked and isSealActive() then
				return false
			end

			local spellName = LOCALIZATION_ZORLEN[key]
			if not spellName then return false end

			local z = {}
			z.Test = actualTest
			z.SpellName = spellName
			z.BuffName = spellName
			z.EnemyTargetNotNeeded = 1

			return Zorlen_CastCommonRegisteredSpell(z)
		end

		countFunctions = countFunctions + 1
	end
end

-- You can also register spells here if needed
Zorlen_debug("Zorlen Paladin successfully loaded " .. countFunctions .. " functions.", 1)

-------------------------------------
-- Logical buff group checkers --
-------------------------------------

function isPaladinResistanceAuraActive()
	return isSRAA() or isFrRAA() or isFiRAA()
end

function isPaladinAuraActive()
	return isPaladinResistanceAuraActive() or isSAA() or isRAA() or isDAA() or isCAA()
end

function isRegularBlessingActive()
	return isBoFA() or isBoKA() or isBoLA() or isBoMA() or isBoPA() or isBoSacA() or isBoSalA() or isBoSanA() or isBoWA()
end

function isGreaterBlessingActive()
	return isGBoKA() or isGBoLA() or isGBoMA() or isGBoSalA() or isGBoSanA() or isGBoWA()
end

function isBlessingActive()
	return isRegularBlessingActive() or isGreaterBlessingActive()
end

function isSealActive()
	return isSoCA() or isSoJA() or isSoLA() or isSoRA() or isSoWA() or isSotCA()
end

------------------------------
-- Zeal utility functions --
------------------------------

local ZealIconName = "INV_Jewelry_Talisman_01"

function ZealCount()
	local SpellName = LOCALIZATION_ZORLEN.Zeal
	return Zorlen_GetBuffCount(ZealIconName, nil, false, SpellName)
end

function ZealTimeLeft()
	local SpellName = LOCALIZATION_ZORLEN.Zeal
	return Zorlen_GetBuffTimeLeft_ByExactName(SpellName)
end

-- Judgement has unique logic (only cast if a seal is active)
function castJudgement(test)
	if not isSealActive() then
		return false
	end
	local z = {}
	z.Test = test
	z.SpellName = LOCALIZATION_ZORLEN.Judgement
	return Zorlen_CastCommonRegisteredSpell(z)
end

-- Divine Protection (not in cast map)
function castDivineProtection(test)
	local z = {}
	z.Test = test
	z.SpellName = LOCALIZATION_ZORLEN.DivineProtection
	z.BuffName = z.SpellName
	z.EnemyTargetNotNeeded = 1
	return Zorlen_CastCommonRegisteredSpell(z)
end

function castHolyShield(test)
	local z = {}
	z.Test = test
	z.SpellName = LOCALIZATION_ZORLEN.HolyShield
	z.BuffName = z.SpellName
	z.EnemyTargetNotNeeded = 1
	return Zorlen_CastCommonRegisteredSpell(z)
end

-- Auto blessing functions

function blessingForUnit(unit)
  unit = unit or "target"

  local wisdom = LOCALIZATION_ZORLEN.BlessingOfWisdom
  local might = LOCALIZATION_ZORLEN.BlessingOfMight
  local wisdomKnown = Zorlen_IsSpellKnown(wisdom)

  -- Choose fallback if Wisdom is not known
  local defaultBlessing = wisdomKnown and wisdom or might

  -- No target or invalid target: fallback to default
  if not UnitExists(unit) then
    if not IsAltKeyDown() then
      return might
    else
      return defaultBlessing
    end
  end

  if UnitLevel(unit) < 4 then
    return might
  end

  if isDruid(unit) or isHunter(unit) or isPriest(unit) or isMage(unit) or isWarlock(unit) or isShaman(unit) then
    return defaultBlessing
  end

  if isPaladin(unit) or isWarrior(unit) or isRogue(unit) then
    return might
  end

  return might -- fallback
end

function castAutoBlessing()
  local SpellName = blessingForUnit()
  local SpellID = Zorlen_GetSpellID(SpellName)
  if not Zorlen_checkCooldown(SpellID) then
    return false
  end

  -- Cast on friendly target (if different than self and doesn't already have buff)
  if UnitIsFriend("player", "target") and not UnitIsUnit("player", "target") and not Zorlen_checkBuffByName(SpellName, "target") then
    CastSpell(SpellID, 0)
    if SpellIsTargeting() then
      SpellStopTargeting()
      return false
    end
    return true
  end

  -- Self-cast if target is missing or enemy
  if (not UnitExists("target") or not UnitIsFriend("player", "target")) and not Zorlen_checkBuffByName(SpellName) then
    local retarget = nil
    if UnitIsFriend("player", "target") and not UnitIsUnit("player", "target") then
      retarget = true
      TargetUnit("player")
    end

    CastSpell(SpellID, 0)

    if retarget then
      TargetLastTarget()
    end

    if SpellIsTargeting() then
      if SpellCanTargetUnit("player") then
        SpellTargetUnit("player")
      else
        SpellStopTargeting()
        return false
      end
    end

    return true
  end

  return false
end
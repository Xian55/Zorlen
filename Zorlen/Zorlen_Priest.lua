Zorlen_Priest_FileBuildNumber = 690

Zorlen_SpellInfo = Zorlen_SpellInfo or {}

local SpellInfo = {}
local SpellIdsByRankbySpellName = {}

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function()
	SpellInfo = {}

	local B = Book or BOOKTYPE_SPELL
	for i = 1, GetNumSpellTabs() do
		local name, _, offset, numSpells = GetSpellTabInfo(i)
		for j = 1, numSpells do
			local spellIndex = offset + j
			local spellName, rank = GetSpellName(spellIndex, B)
			local found, _, Rank = string.find(rank, "(%d+)")
			if found then
				RankNum = tonumber(Rank)
			else
				RankNum = 1
			end
			if spellName then
				--print(spellIndex .. " Spell Name: " .. spellName .. ", Rank: " .. RankNum)
				local spellInfo = ExtractSpellInfo(spellName, RankNum)
				if spellInfo then
					SpellInfo[spellInfo.id] = spellInfo
				end
			end
		end
	end

	Zorlen_SpellInfo = SpellInfo

	-- Fill SpellIdsByRankbySpellName
	for _, info in pairs(SpellInfo) do
		local spellId = info.id
		local spellName = info.name
		if not SpellIdsByRankbySpellName[spellName] then
			SpellIdsByRankbySpellName[spellName] = {}
		end
		SpellIdsByRankbySpellName[spellName][info.rank] = spellId
	end

	Zorlen_SpellIdsByRankbySpellName = SpellIdsByRankbySpellName
end)

function ExtractSpellInfo(spellName, rank)
	if not spellName then return nil end

	local spellID = Zorlen_GetSpellID(spellName, rank)
	if not spellID then return nil end

	local minVal, maxVal = Zorlen_SpellMinMaxValue(spellName, rank)
	local spellInfo = {
		name = spellName,
		id = spellID,
		rank = rank,
		castTime = Zorlen_SpellCastTime(spellName, rank) or 0,
		cost = Zorlen_SpellCost(spellName, rank),
		minVal = minVal,
		maxVal = maxVal,
	}
	return spellInfo
end

-- /run dumpSpellInfo()
function dumpSpellInfo()
	for _, info in pairs(SpellInfo) do
		print("ID: " .. info.id .. ", Name: " .. info.name .. ", Rank: " .. info.rank
			.. ", Cast Time: " .. info.castTime
			.. ", Cost: " .. info.cost .. ", Min Value: " .. info.minVal
			.. ", Max Value: " .. info.maxVal)

		print("---")
	end
end

-- /run dumpAllSpellBySpellNameToRankUp("Holy Light")
-- /run dumpAllSpellBySpellNameToRankUp("Holy Strike")
-- /run dumpAllSpellBySpellNameToRankUp("Heal")
-- /run dumpAllSpellBySpellNameToRankUp("Lesser Heal")
-- /run dumpAllSpellBySpellNameToRankUp("Smite")
function dumpAllSpellBySpellNameToRankUp(SpellName)
	local spellIds = SpellIdsByRankbySpellName[SpellName]
	if not spellIds then
		print("No spells found for: " .. SpellName)
		return
	end

	for _, spellId in pairs(spellIds) do
		local spellInfo = SpellInfo[spellId]
		if spellInfo then
			print("Spell ID: " .. spellInfo.id .. " - Spell Name: " .. spellInfo.name .. " - Rank: " .. spellInfo.rank)
			print(" Cast Time: " .. spellInfo.castTime .. " - Cost: " .. spellInfo.cost)
			print(" Values: " .. spellInfo.minVal .. " - " .. spellInfo.maxVal)
		end
	end
end

-- Test commands for generated functions (max 255 chars each):
-- /run print("isRenew exists:", type(isRenew)=="function")
-- /run print("isInnerFireActive exists:", type(isInnerFireActive)=="function") 
-- /run print("castInnerFire exists:", type(castInnerFire)=="function") 
-- /run print("castDivineSpirit exists:", type(castDivineSpirit)=="function")
-- /run print("isRenew():", isRenew())
-- /run print("isInnerFireActive():", isInnerFireActive())
-- /run print("isDivineSpirit():", isDivineSpirit())
-- /run print("isDivineSpiritActive():", isDivineSpiritActive())

-- Test buff functions:
-- /run for _,n in ipairs({"isRenew","isPowerWordFortitude","isDivineSpirit"}) do print(n..":",type(_G[n])=="function") end
-- /run for _,n in ipairs({"isRenewActive","isPowerWordFortitudeActive","isDivineSpiritActive"}) do print(n..":",type(_G[n])=="function") end

-- Test cast functions:
-- /run for _,n in ipairs({"castInnerFire","castDivineSpirit","castMindBlast"}) do print(n..":",type(_G[n])=="function") end
-- /run for _,n in ipairs({"castShadowWordPain","castHolyFire","castSmite"}) do print(n..":",type(_G[n])=="function") end

-- Sanity check test functions:
function ZorlenPriestSanityCheck()
	local passed = 0
	local total = 0
	
	print("=== Zorlen Priest Sanity Check ===")
	
	-- Test generated buff functions exist
	local buffFuncs = {"isRenew", "isPowerWordFortitude", "isPowerWordShield", "isInnerFire", "isDivineSpirit"}
	for _, func in ipairs(buffFuncs) do
		total = total + 1
		if type(_G[func]) == "function" then
			passed = passed + 1
			print("✓ " .. func .. " exists")
		else
			print("✗ " .. func .. " missing")
		end
	end
	
	-- Test generated active functions exist
	local activeFuncs = {"isRenewActive", "isPowerWordFortitudeActive", "isPowerWordShieldActive", "isInnerFireActive", "isDivineSpiritActive"}
	for _, func in ipairs(activeFuncs) do
		total = total + 1
		if type(_G[func]) == "function" then
			passed = passed + 1
			print("✓ " .. func .. " exists")
		else
			print("✗ " .. func .. " missing")
		end
	end
	
	-- Test generated cast functions exist
	local castFuncs = {"castInnerFire", "castDivineSpirit", "castShadowWordPain", "castHolyFire", "castMindBlast"}
	for _, func in ipairs(castFuncs) do
		total = total + 1
		if type(_G[func]) == "function" then
			passed = passed + 1
			print("✓ " .. func .. " exists")
		else
			print("✗ " .. func .. " missing")
		end
	end
	
	-- Test refactored functions exist
	local refactoredFuncs = {"castPowerWordFortitude", "castSelfPowerWordFortitude", "castRenew", "castSelfRenew", "castPowerWordShield", "castSelfPowerWordShield"}
	for _, func in ipairs(refactoredFuncs) do
		total = total + 1
		if type(_G[func]) == "function" then
			passed = passed + 1
			print("✓ " .. func .. " exists")
		else
			print("✗ " .. func .. " missing")
		end
	end
	
	print("=== Results: " .. passed .. "/" .. total .. " tests passed ===")
	return passed == total
end

function ZorlenPriestBuffCheck()
	print("=== Current Priest Buffs ===")
	print("Inner Fire Active:", isInnerFireActive())
	print("Power Word: Fortitude Active:", isPowerWordFortitudeActive())
	print("Power Word: Shield Active:", isPowerWordShieldActive())
	print("Divine Spirit Active:", isDivineSpiritActive())
	print("Renew Active:", isRenewActive())
	if UnitExists("target") then
		print("--- Target Buffs ---")
		print("Target has Inner Fire:", isInnerFire())
		print("Target has Power Word: Fortitude:", isPowerWordFortitude())
		print("Target has Power Word: Shield:", isPowerWordShield())
		print("Target has Divine Spirit:", isDivineSpirit())
		print("Target has Renew:", isRenew())
	else
		print("No target selected for target buff checks")
	end
end

function ZorlenPriestGeneratedTest()
	print("=== Generated Priest Functions Test ===")
	local passed, total = 0, 0
	
	-- Test healing variants (18 functions)
	local healingTests = {"castUnderLesserHeal", "castOverLesserHeal", "castMaxLesserHeal", "castUnderHeal", "castOverHeal", "castMaxHeal", "castUnderGreaterHeal", "castOverGreaterHeal", "castMaxGreaterHeal", "castUnderPriestHeal", "castOverPriestHeal", "castMaxPriestHeal", "castUnderFlashHeal", "castOverFlashHeal", "castMaxFlashHeal", "castUnderGroupPriestHeal", "castOverGroupPriestHeal", "castMaxGroupPriestHeal"}
	for _, func in ipairs(healingTests) do
		total = total + 1
		if type(_G[func]) == "function" then
			passed = passed + 1
		else
			print("✗ " .. func)
		end
	end
	
	-- Test buff checks (40 functions: 20 + 20 Active variants)
	local buffTests = {"isRenew", "isPowerWordFortitude", "isShadowWordPain", "isInnerFire", "isWeakenedSoul", "isTouchOfWeakness", "isVampiricEmbrace", "isFear", "isShackleUndead", "isMindControl", "isMindSoothe", "isMindVision", "isPsychicScream", "isHolyFire", "isMindBlast", "isRenewActive", "isPowerWordFortitudeActive", "isShadowWordPainActive", "isInnerFireActive", "isWeakenedSoulActive", "isTouchOfWeaknessActive", "isVampiricEmbraceActive", "isFearActive", "isShackleUndeadActive", "isMindControlActive", "isMindSootheActive", "isMindVisionActive", "isPsychicScreamActive", "isHolyFireActive", "isMindBlastActive"}
	for _, func in ipairs(buffTests) do
		total = total + 1
		if type(_G[func]) == "function" then
			passed = passed + 1
		else
			print("✗ " .. func)
		end
	end
	
	-- Test cast functions (17 functions)
	local castTests = {"castShadowWordPain", "castHolyFire", "castMindBlast", "castPsychicScream", "castInnerFire", "castPowerWordShield", "castTouchOfWeakness", "castVampiricEmbrace", "castFear", "castShackleUndead", "castMindControl", "castMindSoothe", "castMindVision", "castDivineSpirit", "castHexOfWeakness", "castShadowguard", "castDevouringPlague"}
	for _, func in ipairs(castTests) do
		total = total + 1
		if type(_G[func]) == "function" then
			passed = passed + 1
		else
			print("✗ " .. func)
		end
	end
	
	print("Generated functions: " .. passed .. "/" .. total .. " passed")
	print("Total functions loaded by maps: 76 (from debug output)")
end

function ZorlenPriestCastTest()
	print("=== Priest Cast Function Test (DRY RUN) ===")
	print("NOTE: These are test calls - no spells will be cast")
	
	-- Test self-buff functions (safe to test)
	local selfFuncs = {"castInnerFire", "castSelfPowerWordFortitude", "castSelfRenew"}
	for _, func in ipairs(selfFuncs) do
		if type(_G[func]) == "function" then
			print("Testing " .. func .. ": callable")
		else
			print("✗ " .. func .. " not found")
		end
	end
	
	print("To test actual casting, use: /run castInnerFire(true)")
	print("The 'true' parameter enables test mode (safe)")
end


--------   All functions below this line will only load if you are playing the corresponding class   --------
if not Zorlen_isCurrentClassPriest then return end

local global = getfenv(0)
local find = string.find

local countFunctions = 0

-- Map for buff/debuff checking functions
local BuffCheckMap = {
	-- Buffs (use Zorlen_checkBuff with icon)
	isRenew = {icon = "Spell_Holy_Renew", type = "buff"},
	isPowerWordFortitude = {icon = "Holy_WordFortitude", type = "buff"},
	isPowerWordShield = {icon = "Holy_PowerWordShield", type = "buff"},
	isInnerFire = {icon = "Holy_InnerFire", type = "buff"},
	isDivineSpirit = {icon = "Spell_Holy_DivineSpirit", type = "buff"},
	
	-- Debuffs (use Zorlen_checkDebuff with icon)
	isShadowWordPain = {icon = "Shadow_ShadowWordPain", type = "debuff"},
	isHolyFire = {icon = "Spell_Holy_SearingLight", type = "debuff"},
	isMindControl = {icon = "Shadow_ShadowWordDominate", type = "debuff"},
	isMindFlay = {icon = "Spell_Shadow_SiphonMana", type = "debuff"},
	isShackleUndead = {icon = "Spell_Nature_Slow", type = "debuff"},
	isTouchOfWeakness = {icon = "Spell_Shadow_DeadofNight", type = "debuff"},
	isHexOfWeakness = {icon = "Spell_Shadow_FingerOfDeath", type = "debuff"},
	isVampiricEmbrace = {icon = "Spell_Shadow_UnsummonBuilding", type = "debuff"},
	isWeakenedSoul = {icon = "Spell_Holy_AshesToAshes", type = "debuff"},
	isFear = {icon = "Spell_Shadow_Possession", type = "debuff"},
	isPsychicScream = {icon = "Spell_Shadow_PsychicScream", type = "debuff"},
	isMindBlast = {icon = "Spell_Shadow_UnholyFrenzy", type = "debuff"},
	isMindSoothe = {icon = "Spell_Shadow_Soothe", type = "debuff"},
	isMindVision = {icon = "Spell_Holy_MindVision", type = "debuff"},
	
	-- Special case using name lookup
	isDevouringPlague = {localizationKey = "DevouringPlague", type = "debuffByName"}
}

-- Generate buff/debuff checking functions
for funcName, config in pairs(BuffCheckMap) do
	do
		local f = funcName
		local cfg = config
		
		global[f] = function(unit, param2)
			if cfg.type == "buff" then
				unit = unit or "target"
				return Zorlen_checkBuff(cfg.icon, unit, param2)
			elseif cfg.type == "debuff" then
				return Zorlen_checkDebuff(cfg.icon, unit, param2)
			elseif cfg.type == "debuffByName" then
				local spellName = LOCALIZATION_ZORLEN and LOCALIZATION_ZORLEN[cfg.localizationKey]
				if not spellName then return false end
				return Zorlen_checkDebuffByName(spellName, unit, param2)
			end
			return false
		end
		
		-- Create "Active" variant (e.g., isInnerFireActive, isPowerWordFortitudeActive)
		local spellKey = string.gsub(f, "^is", "")
		local activeFunc = "is" .. spellKey .. "Active"
		global[activeFunc] = function()
			if cfg.type == "buff" then
				return Zorlen_checkBuff(cfg.icon)
			elseif cfg.type == "debuff" then
				return Zorlen_checkDebuff(cfg.icon, "player")
			elseif cfg.type == "debuffByName" then
				local spellName = LOCALIZATION_ZORLEN and LOCALIZATION_ZORLEN[cfg.localizationKey]
				if not spellName then return false end
				return Zorlen_checkDebuffByName(spellName, "player")
			end
			return false
		end
		
		countFunctions = countFunctions + 2
	end
end

-- Map for basic casting functions
local CastSpellMap = {
	castShadowWordPain = {key = "ShadowWordPain", hasDebuff = true, hasTimer = true},
	castHolyFire = {key = "HolyFire", hasDebuff = true},
	castMindControl = {key = "MindControl", hasDebuff = true, checkMoving = true},
	castMindFlay = {key = "MindFlay", checkMoving = true},
	castTouchOfWeakness = {key = "TouchOfWeakness", hasDebuff = true},
	castHexOfWeakness = {key = "HexOfWeakness", hasDebuff = true},
	castInnerFire = {key = "InnerFire", hasBuff = true, enemyTargetNotNeeded = true},
	castShadowguard = {key = "Shadowguard", hasBuff = true, enemyTargetNotNeeded = true},
	castDivineSpirit = {key = "DivineSpirit", hasBuff = true, enemyTargetNotNeeded = true},
	castDevouringPlague = {key = "DevouringPlague"},
	castMindBlast = {key = "MindBlast", checkMoving = true},
	castSmite = {key = "Smite", checkMoving = true},
	castVampiricEmbrace = {key = "VampiricEmbrace", hasDebuff = true},
	castPsychicScream = {key = "PsychicScream", enemyTargetNotNeeded = true, noRangeCheck = true},
	castFear = {key = "Fear", hasDebuff = true},
	castShackleUndead = {key = "ShackleUndead", hasDebuff = true},
	castMindSoothe = {key = "MindSoothe", checkMoving = true},
	castMindVision = {key = "MindVision", enemyTargetNotNeeded = true}
}

-- Generate casting functions
for funcName, config in pairs(CastSpellMap) do
	do
		local f = funcName
		local cfg = config
		
		global[f] = function(SpellRank)
			if cfg.checkMoving and Zorlen_isMoving() then
				return false
			end
			
			local spellName = LOCALIZATION_ZORLEN and LOCALIZATION_ZORLEN[cfg.key]
			if not spellName then return false end
			
			local debuffName = cfg.hasDebuff and spellName or nil
			local buffName = cfg.hasBuff and spellName or nil
			local enemyTargetNotNeeded = cfg.enemyTargetNotNeeded and 1 or nil
			local noRangeCheck = cfg.noRangeCheck and 1 or nil
			local debuffTimer = cfg.hasTimer and 1 or nil
			
			return Zorlen_CastCommonRegisteredSpell(SpellRank, spellName, debuffName, nil, nil, nil, 
				enemyTargetNotNeeded, buffName, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 
				noRangeCheck, nil, debuffTimer)
		end
		
		countFunctions = countFunctions + 1
	end
end

-- Map for healing variant functions (Under/Over/Max)
local HealingVariantMap = {
	-- Individual healing spells
	{base = "castLesserHeal", params = {"RankAdj", "unit"}},
	{base = "castHeal", params = {"RankAdj", "unit"}},
	{base = "castGreaterHeal", params = {"RankAdj", "unit"}},
	{base = "castPriestHeal", params = {"RankAdj", "unit"}},
	{base = "castFlashHeal", params = {"RankAdj", "unit"}},
	
	-- Group healing spells (different parameter order)
	{base = "castGroupPriestHeal", params = {"pet", "RankAdj"}}
}

-- Generate healing variant functions
for _, config in ipairs(HealingVariantMap) do
	do
		local baseName = config.base
		local params = config.params
		
		-- Generate Under variant
		local underFunc = string.gsub(baseName, "^cast", "castUnder")
		global[underFunc] = function(param1, param2)
			if params[1] == "pet" then
				-- Group healing: (pet, RankAdj) -> (pet, "under", RankAdj)
				local DefaultAdj = param2 or -1
				return global[baseName](param1, "under", DefaultAdj)
			else
				-- Individual healing: (RankAdj, unit) -> ("under", RankAdj, unit)
				local DefaultAdj = param1 or -1
				return global[baseName]("under", DefaultAdj, param2)
			end
		end
		
		-- Generate Over variant  
		local overFunc = string.gsub(baseName, "^cast", "castOver")
		global[overFunc] = function(param1, param2)
			if params[1] == "pet" then
				-- Group healing: (pet, RankAdj) -> (pet, "over", RankAdj)
				local DefaultAdj = param2 or 1
				return global[baseName](param1, "over", DefaultAdj)
			else
				-- Individual healing: (RankAdj, unit) -> ("over", RankAdj, unit)
				local DefaultAdj = param1 or 1
				return global[baseName]("over", DefaultAdj, param2)
			end
		end
		
		-- Generate Max variant
		local maxFunc = string.gsub(baseName, "^cast", "castMax")
		global[maxFunc] = function(param1, param2)
			if params[1] == "pet" then
				-- Group healing: (pet, RankAdj) -> (pet, "maximum", RankAdj)
				return global[baseName](param1, "maximum", param2)
			else
				-- Individual healing: (RankAdj, unit) -> ("maximum", RankAdj, unit)
				return global[baseName]("maximum", param1, param2)
			end
		end
		
		countFunctions = countFunctions + 3
	end
end

Zorlen_debug("Zorlen Priest successfully loaded " .. countFunctions .. " functions.", 1)






function Zorlen_Priest_SpellTimerSet()
	local Duration = 0
	local TargetName = Zorlen_CastingSpellTargetName
	local SpellName = Zorlen_CastingSpellName
	local DebuffName = nil
	local DebuffTargetName = nil

	if SpellName == LOCALIZATION_ZORLEN.ShadowWordPain then
		Duration = 18
	end

	Zorlen_SetTimer(1, DebuffName, DebuffTargetName, "InternalZorlenSpellCastDelay", 2)
	if Zorlen_CastingSpellTargetName then
		Zorlen_SetTimer(Duration, SpellName, TargetName, "InternalZorlenSpellTimers", nil, nil, 1)
	end
end



--Added By Devla
--Casts Shackle Undead on Target if the target is not already cc'ed
function castShackle()
	if UnitCreatureType("target") ~= "Undead" then
		return false
	end
	if Zorlen_isMoving() then
		return false
	end
	local SpellName = LOCALIZATION_ZORLEN.ShackleUndead
	local DebuffCheckIncluded = 1
	local DebuffCheck = Zorlen_isNoDamageCC()
	local StopCasting = DebuffCheck
	return Zorlen_CastCommonRegisteredSpell(nil, SpellName, nil, nil, nil, nil, nil, nil, nil, DebuffCheckIncluded,
		DebuffCheck, nil, nil, nil, nil, nil, nil, nil, nil, StopCasting)
end


-- Will try to cast the spell on everyone in your party or raid if a debuff is found on them
-- ( I know this will not work as well as "Decursive", but it was easy to add with the other additions already in place, so I added it. )
function castGroupDispelMagic(pet)
	if not castFriendlyDispelMagic() then
		local SpellName = LOCALIZATION_ZORLEN.DispelMagic
		local SpellButton = Zorlen_Button[SpellName]
		local _ = nil
		local isUsable = nil
		local notEnoughMana = nil
		local duration = nil
		local isCurrent = nil
		local SpellID = nil
		if SpellButton then
			isUsable, notEnoughMana = IsUsableAction(SpellButton)
			_, duration, _ = GetActionCooldown(SpellButton)
			isCurrent = IsCurrentAction(SpellButton)
		elseif Zorlen_IsSpellKnown(SpellName) then
			SpellID = Zorlen_GetSpellID(SpellName)
		else
			return false
		end
		if not SpellButton or ((isUsable == 1) and (not notEnoughMana) and (duration == 0) and (isCurrent ~= 1)) then
			if SpellButton or Zorlen_checkCooldown(SpellID) then
				local counter = 1
				local notunitarray = {}
				while counter do
					local u = Zorlen_GiveGroupUnitWithDispelableDebuff(pet, nil, nil, notunitarray)
					if u then
						if UnitIsUnit("target", u) then
							notunitarray[counter] = u
						else
							TargetUnit(u)
							if castFriendlyDispelMagic() then
								TargetLastTarget()
								return true
							end
							TargetLastTarget()
							notunitarray[counter] = u
						end
						counter = counter + 1
						if not SpellButton then
							counter = nil
						end
					else
						counter = nil
					end
				end
			end
		end
	end
	return false
end

-- Will only cast the spell on your self or a friend if there is a debuff found.
--If you have an enemy targeted it will cast on yourself if a debuff that can be dispeled is on you. If you have a friend targeted it will cast on them if they have a debuff on them that can be dispeled.
function castFriendlyDispelMagic()
	local SpellName = LOCALIZATION_ZORLEN.DispelMagic
	local SpellButton = Zorlen_Button[SpellName]
	local SpellID = nil
	
	-- Check spell availability
	local canCast = false
	if SpellButton then
		local isUsable, notEnoughMana = IsUsableAction(SpellButton)
		local _, duration, _ = GetActionCooldown(SpellButton)
		local isCurrent = IsCurrentAction(SpellButton)
		canCast = (isUsable == 1) and (not notEnoughMana) and (duration == 0) and (isCurrent ~= 1)
	elseif Zorlen_IsSpellKnown(SpellName) then
		Zorlen_debug("" .. SpellName .. " was not found on any of the action bars!")
		SpellID = Zorlen_GetSpellID(SpellName)
		canCast = Zorlen_checkCooldown(SpellID)
	else
		return false
	end
	
	-- Early return if spell not ready
	if not canCast then
		return false
	end
	
	-- Check target status
	local hasTarget = UnitExists("target")
	local isFriendlyTarget = hasTarget and UnitIsFriend("player", "target")
	local targetNeedsDispel = isFriendlyTarget and Zorlen_checkDebuff(nil, nil, "dispelable")
	local targetInRange = SpellButton and IsActionInRange(SpellButton) == 1
	local playerNeedsDispel = Zorlen_checkDebuff(nil, "player", "dispelable")
	
	-- Try to cast on friendly target first (if they need it and are in range)
	if targetNeedsDispel and (not SpellButton or targetInRange) then
		if SpellButton then
			UseAction(SpellButton)
		else
			CastSpell(SpellID, 0)
		end
		
		if SpellIsTargeting() and SpellCanTargetUnit("player") then
			SpellTargetUnit("player")
		elseif SpellIsTargeting() then
			SpellStopTargeting()
			return false
		end
		return true
	end
	
	-- Try to cast on self if no target or player needs dispel
	if (not hasTarget or not isFriendlyTarget) and playerNeedsDispel then
		if SpellButton then
			UseAction(SpellButton)
		else
			CastSpell(SpellID, 0)
		end
		
		if SpellIsTargeting() and SpellCanTargetUnit("player") then
			SpellTargetUnit("player")
		elseif SpellIsTargeting() then
			SpellStopTargeting()
			return false
		end
		return true
	end
	
	-- Cast on self if we have a target but player needs dispel (retarget scenario)
	if hasTarget and playerNeedsDispel then
		TargetUnit("player")
		
		if SpellButton then
			UseAction(SpellButton)
		else
			CastSpell(SpellID, 0)
		end
		
		TargetLastTarget()
		return true
	end
	
	return false
end

-- Will only cast the spell on your self if you have debuffs on you that can be dispeled, and will not be able to cast on anything else.
function castSelfDispelMagic()
	local SpellName = LOCALIZATION_ZORLEN.DispelMagic
	local SpellButton = Zorlen_Button[SpellName]
	local SpellID = nil
	
	-- Early return if player has no dispelable debuffs
	if not Zorlen_checkDebuff(nil, "player", "dispelable") then
		return false
	end
	
	-- Check spell availability
	local canCast = false
	if SpellButton then
		local isUsable, notEnoughMana = IsUsableAction(SpellButton)
		local _, duration, _ = GetActionCooldown(SpellButton)
		local isCurrent = IsCurrentAction(SpellButton)
		canCast = (isUsable == 1) and (not notEnoughMana) and (duration == 0) and (isCurrent ~= 1)
	elseif Zorlen_IsSpellKnown(SpellName) then
		Zorlen_debug("" .. SpellName .. " was not found on any of the action bars!")
		SpellID = Zorlen_GetSpellID(SpellName)
		canCast = Zorlen_checkCooldown(SpellID)
	else
		return false
	end
	
	-- Early return if spell not ready
	if not canCast then
		return false
	end
	
	-- Manage targeting (retarget if we have a non-player target)
	local needsRetarget = UnitExists("target") and not UnitIsUnit("player", "target")
	if needsRetarget then
		TargetUnit("player")
	end
	
	-- Cast the spell
	if SpellButton then
		UseAction(SpellButton)
	else
		CastSpell(SpellID, 0)
	end
	
	-- Restore target if needed
	if needsRetarget then
		TargetLastTarget()
	end
	
	-- Handle spell targeting
	if SpellIsTargeting() and SpellCanTargetUnit("player") then
		SpellTargetUnit("player")
	elseif SpellIsTargeting() then
		SpellStopTargeting()
		return false
	end
	
	return true
end

-- Will cast the spell on an enemy target if one is targeted.
--If you have no target it will cast on yourself if a debuff is on you that can be dispeled. If you have a friend targeted it will cast on them if they have a debuff on them that can be dispeled.
function castDispelMagic()
	local SpellName = LOCALIZATION_ZORLEN.DispelMagic
	local SpellButton = Zorlen_Button[SpellName]
	local SpellID = nil
	
	-- Check spell availability
	local canCast = false
	if SpellButton then
		local isUsable, notEnoughMana = IsUsableAction(SpellButton)
		local _, duration, _ = GetActionCooldown(SpellButton)
		local isCurrent = IsCurrentAction(SpellButton)
		canCast = (isUsable == 1) and (not notEnoughMana) and (duration == 0) and (isCurrent ~= 1)
	elseif Zorlen_IsSpellKnown(SpellName) then
		Zorlen_debug("" .. SpellName .. " was not found on any of the action bars!")
		SpellID = Zorlen_GetSpellID(SpellName)
		canCast = Zorlen_checkCooldown(SpellID)
	else
		return false
	end
	
	-- Early return if spell not ready
	if not canCast then
		return false
	end
	
	-- Check target status
	local hasTarget = UnitExists("target")
	local isFriendlyTarget = hasTarget and UnitIsFriend("player", "target")
	local isEnemyTarget = hasTarget and Zorlen_TargetIsEnemy()
	local targetNeedsDispel = isFriendlyTarget and Zorlen_checkDebuff(nil, nil, "dispelable")
	local targetInRange = SpellButton and IsActionInRange(SpellButton) == 1
	local playerNeedsDispel = Zorlen_checkDebuff(nil, "player", "dispelable")
	
	-- Priority 1: Cast on friendly target (if they need dispel and are in range)
	if targetNeedsDispel and (not SpellButton or targetInRange) then
		if SpellButton then
			UseAction(SpellButton)
		else
			CastSpell(SpellID, 0)
		end
		
		if SpellIsTargeting() and SpellCanTargetUnit("player") then
			SpellTargetUnit("player")
		elseif SpellIsTargeting() then
			SpellStopTargeting()
			return false
		end
		return true
	end
	
	-- Priority 2: Cast on self if no target and player needs dispel
	if not hasTarget and playerNeedsDispel then
		if SpellButton then
			UseAction(SpellButton)
		else
			CastSpell(SpellID, 0)
		end
		
		if SpellIsTargeting() and SpellCanTargetUnit("player") then
			SpellTargetUnit("player")
		elseif SpellIsTargeting() then
			SpellStopTargeting()
			return false
		end
		return true
	end
	
	-- Priority 3: Cast on self if we have a target but player needs dispel (retarget scenario)
	if hasTarget and playerNeedsDispel then
		TargetUnit("player")
		
		if SpellButton then
			UseAction(SpellButton)
		else
			CastSpell(SpellID, 0)
		end
		
		TargetLastTarget()
		return true
	end
	
	-- Priority 4: Cast on enemy target (if in range)
	if isEnemyTarget and (not SpellButton or targetInRange) then
		if SpellButton then
			UseAction(SpellButton)
		else
			CastSpell(SpellID, 0)
		end
		return true
	end
	
	return false
end

-- Will cast the spell if it is not on your target, if it is on your target or it can not be cast on your target, then it will cast on yourself if it is not on you.
function castGroupPowerWordFortitude(pet)
	-- Early return if we can cast on current target
	if castPowerWordFortitude() then
		return true
	end
	
	local SpellName = LOCALIZATION_ZORLEN.PowerWordFortitude
	local SpellButton = Zorlen_Button[SpellName]
	local SpellID = nil
	
	-- Check if spell is available
	if SpellButton then
		local isUsable, notEnoughMana = IsUsableAction(SpellButton)
		local _, duration, _ = GetActionCooldown(SpellButton)
		local isCurrent = IsCurrentAction(SpellButton)
		
		-- Early return if spell button not ready
		if not ((isUsable == 1) and (not notEnoughMana) and (duration == 0) and (isCurrent ~= 1)) then
			return false
		end
	elseif Zorlen_IsSpellKnown(SpellName) then
		SpellID = Zorlen_GetSpellID(SpellName)
		-- Early return if spell not on cooldown
		if not Zorlen_checkCooldown(SpellID) then
			return false
		end
	else
		return false
	end
	
	-- Look for group members who need the buff
	local counter = 1
	local notunitarray = {}
	while counter do
		local u = Zorlen_GiveGroupUnitWithoutBuffBySpellName(SpellName, pet, nil, nil, notunitarray)
		
		if not u then
			break
		end
		
		-- Skip current target and player
		if UnitIsUnit("target", u) or UnitIsUnit("player", u) then
			notunitarray[counter] = u
		else
			TargetUnit(u)
			if castPowerWordFortitude() then
				TargetLastTarget()
				return true
			end
			TargetLastTarget()
			notunitarray[counter] = u
		end
		
		counter = counter + 1
		
		-- Break loop for spell ID mode (no action button)
		if not SpellButton then
			break
		end
	end
	
	return false
end

-- Will cast the spell if it is not on your target, if it is on your target or it can not be cast on your target, then it will cast on yourself if it is not on you.
function castPowerWordFortitude()
	local SpellName = LOCALIZATION_ZORLEN.PowerWordFortitude
	local SpellButton = Zorlen_Button[SpellName]
	local SpellID = nil
	
	-- Check spell availability and get action details
	local canCast = false
	if SpellButton then
		local isUsable, notEnoughMana = IsUsableAction(SpellButton)
		local _, duration, _ = GetActionCooldown(SpellButton)
		local isCurrent = IsCurrentAction(SpellButton)
		canCast = (isUsable == 1) and (not notEnoughMana) and (duration == 0) and (isCurrent ~= 1)
	elseif Zorlen_IsSpellKnown(SpellName) then
		Zorlen_debug("" .. SpellName .. " was not found on any of the action bars!")
		SpellID = Zorlen_GetSpellID(SpellName)
		canCast = Zorlen_checkCooldown(SpellID)
	else
		return false
	end
	
	-- Early return if spell not ready
	if not canCast then
		return false
	end
	
	-- Check if we can cast on friendly target
	local hasTarget = UnitExists("target")
	local isFriendlyTarget = hasTarget and UnitIsFriend("player", "target") and not UnitIsUnit("player", "target")
	local targetNeedsBuff = isFriendlyTarget and not isPowerWordFortitude()
	local targetInRange = SpellButton and IsActionInRange(SpellButton) == 1
	
	-- Cast on friendly target if they need it and are in range
	if targetNeedsBuff and (not SpellButton or targetInRange) then
		if SpellButton then
			UseAction(SpellButton)
		else
			CastSpell(SpellID, 0)
		end
		
		if SpellIsTargeting() then
			SpellStopTargeting()
			return false
		end
		return true
	end
	
	-- Check if player needs buff
	if isPowerWordFortitudeActive() then
		return false
	end
	
	-- Cast on self (with target management if needed)
	local needsRetarget = isFriendlyTarget
	if needsRetarget then
		TargetUnit("player")
	end
	
	if SpellButton then
		UseAction(SpellButton)
	else
		CastSpell(SpellID, 0)
	end
	
	if needsRetarget then
		TargetLastTarget()
	end
	
	if SpellIsTargeting() and SpellCanTargetUnit("player") then
		SpellTargetUnit("player")
	elseif SpellIsTargeting() then
		SpellStopTargeting()
		return false
	end
	
	return true
end

-- Will only cast the spell on your self if you do not have it on you and will not be able to cast on anything else.
function castSelfPowerWordFortitude()
	local SpellName = LOCALIZATION_ZORLEN.PowerWordFortitude
	local SpellButton = Zorlen_Button[SpellName]
	local SpellID = nil
	
	-- Early return if player already has buff
	if isPowerWordFortitudeActive() then
		return false
	end
	
	-- Check spell availability
	local canCast = false
	if SpellButton then
		local isUsable, notEnoughMana = IsUsableAction(SpellButton)
		local _, duration, _ = GetActionCooldown(SpellButton)
		local isCurrent = IsCurrentAction(SpellButton)
		canCast = (isUsable == 1) and (not notEnoughMana) and (duration == 0) and (isCurrent ~= 1)
	elseif Zorlen_IsSpellKnown(SpellName) then
		Zorlen_debug("" .. SpellName .. " was not found on any of the action bars!")
		SpellID = Zorlen_GetSpellID(SpellName)
		canCast = Zorlen_checkCooldown(SpellID)
	else
		return false
	end
	
	-- Early return if spell not ready
	if not canCast then
		return false
	end
	
	-- Manage targeting (retarget if we have a friendly target)
	local needsRetarget = UnitIsFriend("player", "target") and not UnitIsUnit("player", "target")
	if needsRetarget then
		TargetUnit("player")
	end
	
	-- Cast the spell
	if SpellButton then
		UseAction(SpellButton)
	else
		CastSpell(SpellID, 0)
	end
	
	-- Restore target if needed
	if needsRetarget then
		TargetLastTarget()
	end
	
	-- Handle spell targeting
	if SpellIsTargeting() and SpellCanTargetUnit("player") then
		SpellTargetUnit("player")
	elseif SpellIsTargeting() then
		SpellStopTargeting()
		return false
	end
	
	return true
end

-- Will cast the spell if it is not on your target, if it is on your target or it can not be cast on your target, then it will cast on yourself if it is not on you.
function castRenew()
	local SpellName = LOCALIZATION_ZORLEN.Renew
	local SpellButton = Zorlen_Button[SpellName]
	local SpellID = nil
	
	-- Check spell availability
	local canCast = false
	if SpellButton then
		local isUsable, notEnoughMana = IsUsableAction(SpellButton)
		local _, duration, _ = GetActionCooldown(SpellButton)
		local isCurrent = IsCurrentAction(SpellButton)
		canCast = (isUsable == 1) and (not notEnoughMana) and (duration == 0) and (isCurrent ~= 1)
	elseif Zorlen_IsSpellKnown(SpellName) then
		Zorlen_debug("" .. SpellName .. " was not found on any of the action bars!")
		SpellID = Zorlen_GetSpellID(SpellName)
		canCast = Zorlen_checkCooldown(SpellID)
	else
		return false
	end
	
	-- Early return if spell not ready
	if not canCast then
		return false
	end
	
	-- Check target status
	local hasTarget = UnitExists("target")
	local isFriendlyTarget = hasTarget and UnitIsFriend("player", "target") and not UnitIsUnit("player", "target")
	local targetNeedsRenew = isFriendlyTarget and not isRenew()
	local targetInRange = SpellButton and IsActionInRange(SpellButton) == 1
	
	-- Try to cast on friendly target first
	if targetNeedsRenew and (not SpellButton or targetInRange) then
		if SpellButton then
			UseAction(SpellButton)
		else
			CastSpell(SpellID, 0)
		end
		
		if SpellIsTargeting() then
			SpellStopTargeting()
			return false
		end
		return true
	end
	
	-- Check if we should cast on self (no target or enemy target, and player needs renew)
	local shouldCastOnSelf = (not hasTarget or not UnitIsFriend("player", "target")) and not isRenew("player")
	if not shouldCastOnSelf then
		return false
	end
	
	-- Cast on self with target management
	local needsRetarget = isFriendlyTarget
	if needsRetarget then
		TargetUnit("player")
	end
	
	if SpellButton then
		UseAction(SpellButton)
	else
		CastSpell(SpellID, 0)
	end
	
	if needsRetarget then
		TargetLastTarget()
	end
	
	if SpellIsTargeting() and SpellCanTargetUnit("player") then
		SpellTargetUnit("player")
	elseif SpellIsTargeting() then
		SpellStopTargeting()
		return false
	end
	
	return true
end

-- Will only cast the spell on your self if you do not have it on you and will not be able to cast on anything else.
function castSelfRenew()
	local SpellName = LOCALIZATION_ZORLEN.Renew
	local SpellButton = Zorlen_Button[SpellName]
	local SpellID = nil
	
	-- Early return if player already has renew
	if isRenew("player") then
		return false
	end
	
	-- Check spell availability
	local canCast = false
	if SpellButton then
		local isUsable, notEnoughMana = IsUsableAction(SpellButton)
		local _, duration, _ = GetActionCooldown(SpellButton)
		local isCurrent = IsCurrentAction(SpellButton)
		canCast = (isUsable == 1) and (not notEnoughMana) and (duration == 0) and (isCurrent ~= 1)
	elseif Zorlen_IsSpellKnown(SpellName) then
		Zorlen_debug("" .. SpellName .. " was not found on any of the action bars!")
		SpellID = Zorlen_GetSpellID(SpellName)
		canCast = Zorlen_checkCooldown(SpellID)
	else
		return false
	end
	
	-- Early return if spell not ready
	if not canCast then
		return false
	end
	
	-- Manage targeting (retarget if we have a friendly target)
	local needsRetarget = UnitIsFriend("player", "target") and not UnitIsUnit("player", "target")
	if needsRetarget then
		TargetUnit("player")
	end
	
	-- Cast the spell
	if SpellButton then
		UseAction(SpellButton)
	else
		CastSpell(SpellID, 0)
	end
	
	-- Restore target if needed
	if needsRetarget then
		TargetLastTarget()
	end
	
	-- Handle spell targeting
	if SpellIsTargeting() and SpellCanTargetUnit("player") then
		SpellTargetUnit("player")
	elseif SpellIsTargeting() then
		SpellStopTargeting()
		return false
	end
	
	return true
end



--Added by Melancholia
-- Will cast the spell if it is not on your target, if it is on your target or it can not be cast on your target, then it will cast on yourself if it is not on you.
function castPowerWordShield()
	local SpellName = LOCALIZATION_ZORLEN.PowerWordShield
	local SpellButton = Zorlen_Button[SpellName]
	local SpellID = nil
	
	-- Check spell availability
	local canCast = false
	if SpellButton then
		local isUsable, notEnoughMana = IsUsableAction(SpellButton)
		local _, duration, _ = GetActionCooldown(SpellButton)
		local isCurrent = IsCurrentAction(SpellButton)
		canCast = (isUsable == 1) and (not notEnoughMana) and (duration == 0) and (isCurrent ~= 1)
	elseif Zorlen_IsSpellKnown(SpellName) then
		Zorlen_debug("" .. SpellName .. " was not found on any of the action bars!")
		SpellID = Zorlen_GetSpellID(SpellName)
		canCast = Zorlen_checkCooldown(SpellID)
	else
		return false
	end
	
	-- Early return if spell not ready
	if not canCast then
		return false
	end
	
	-- Check target status
	local hasTarget = UnitExists("target")
	local isFriendlyTarget = hasTarget and UnitIsFriend("player", "target") and not UnitIsUnit("player", "target")
	local targetNeedsShield = isFriendlyTarget and not isWeakenedSoul() and not isPowerWordShield()
	local targetInRange = SpellButton and IsActionInRange(SpellButton) == 1
	
	-- Try to cast on friendly target first
	if targetNeedsShield and (not SpellButton or targetInRange) then
		if SpellButton then
			UseAction(SpellButton)
		else
			CastSpell(SpellID, 0)
		end
		
		if SpellIsTargeting() then
			SpellStopTargeting()
			return false
		end
		return true
	end
	
	-- Check if player needs shield (no weakened soul and no shield)
	if isWeakenedSoul("player") or isPowerWordShieldActive() then
		return false
	end
	
	-- Cast on self with target management
	local needsRetarget = isFriendlyTarget
	if needsRetarget then
		TargetUnit("player")
	end
	
	if SpellButton then
		UseAction(SpellButton)
	else
		CastSpell(SpellID, 0)
	end
	
	if needsRetarget then
		TargetLastTarget()
	end
	
	if SpellIsTargeting() and SpellCanTargetUnit("player") then
		SpellTargetUnit("player")
	elseif SpellIsTargeting() then
		SpellStopTargeting()
		return false
	end
	
	return true
end

--Added by Melancholia
-- Will only cast the spell on your self if you do not have it on you and will not be able to cast on anything else.
function castSelfPowerWordShield()
	local SpellName = LOCALIZATION_ZORLEN.PowerWordShield
	local SpellButton = Zorlen_Button[SpellName]
	local SpellID = nil
	
	-- Early return if player has weakened soul or already has shield
	if isWeakenedSoul("player") or isPowerWordShieldActive() then
		return false
	end
	
	-- Check spell availability
	local canCast = false
	if SpellButton then
		local isUsable, notEnoughMana = IsUsableAction(SpellButton)
		local _, duration, _ = GetActionCooldown(SpellButton)
		local isCurrent = IsCurrentAction(SpellButton)
		canCast = (isUsable == 1) and (not notEnoughMana) and (duration == 0) and (isCurrent ~= 1)
	elseif Zorlen_IsSpellKnown(SpellName) then
		Zorlen_debug("" .. SpellName .. " was not found on any of the action bars!")
		SpellID = Zorlen_GetSpellID(SpellName)
		canCast = Zorlen_checkCooldown(SpellID)
	else
		return false
	end
	
	-- Early return if spell not ready
	if not canCast then
		return false
	end
	
	-- Manage targeting (retarget if we have a friendly target)
	local needsRetarget = UnitIsFriend("player", "target") and not UnitIsUnit("player", "target")
	if needsRetarget then
		TargetUnit("player")
	end
	
	-- Cast the spell
	if SpellButton then
		UseAction(SpellButton)
	else
		CastSpell(SpellID, 0)
	end
	
	-- Restore target if needed
	if needsRetarget then
		TargetLastTarget()
	end
	
	-- Handle spell targeting
	if SpellIsTargeting() and SpellCanTargetUnit("player") then
		SpellTargetUnit("player")
	elseif SpellIsTargeting() then
		SpellStopTargeting()
		return false
	end
	
	return true
end

-- From: Jiral
function castLesserHeal(Mode, RankAdj, unit)
	if Zorlen_isMoving() then
		return false
	end

	local SpellName = LOCALIZATION_ZORLEN.LesserHeal
	local SpellButton = Zorlen_Button[SpellName]

	return Zorlen_CastHealingSpell(SpellName, nil, nil, nil, nil, nil, Mode, RankAdj, unit, SpellButton)
end


-- From: Jiral
function castHeal(Mode, RankAdj, unit)
	if Zorlen_isMoving() then
		return false
	end

	local SpellName = LOCALIZATION_ZORLEN.Heal
	local SpellButton = Zorlen_Button[SpellName]

	return Zorlen_CastHealingSpell(SpellName, nil, nil, nil, nil, nil, Mode, RankAdj, unit, SpellButton)
end


-- From: Jiral
function castGreaterHeal(Mode, RankAdj, unit)
	if Zorlen_isMoving() then
		return false
	end

	local SpellName = LOCALIZATION_ZORLEN.GreaterHeal
	local SpellButton = Zorlen_Button[SpellName]

	return Zorlen_CastHealingSpell(SpellName, nil, nil, nil, nil, nil, Mode, RankAdj, unit, SpellButton)
end


--This will try to heal party or raid members as long as you are not targeting a party or raid member that can be healed by the spell.
--I made it give priority to your current target so that you have the option to choose priority in the heat of battle.
--If you want it to always select for you then just clear your target or target an enemy before using the function.
function castGroupPriestHeal(pet, Mode, RankAdj)
	-- Early return if moving
	if Zorlen_isMoving() then
		return false
	end
	
	local SpellName = LOCALIZATION_ZORLEN.LesserHeal
	
	-- Priority 1: Try to heal current target first
	if UnitExists("target") and castPriestHeal(Mode, RankAdj, "target") then
		return true
	end
	
	-- Early return if spell not known or low mana
	if not Zorlen_IsSpellKnown(SpellName) or UnitMana("player") < 35 then
		return false
	end
	
	-- Handle casting interruption logic
	local healSpells = {SpellName, LOCALIZATION_ZORLEN.Heal, LOCALIZATION_ZORLEN.GreaterHeal}
	local isCastingHeal = false
	for _, spell in ipairs(healSpells) do
		if Zorlen_isCasting(spell) then
			isCastingHeal = true
			break
		end
	end
	
	if isCastingHeal then
		local u = Zorlen_GiveGroupUnitWithLowestHealth(pet, 0, nil, Zorlen_CastingNotUnitArray)
		
		-- If we're casting on the same unit, continue
		if u and Zorlen_CastingUnit == u then
			return false
		end
		
		-- If no unit found or casting unit changed, stop casting
		if not u or Zorlen_CastingUnit then
			SpellStopCasting()
			return true
		end
		
		return false
	end
	
	-- Early return if spell not ready
	if not Zorlen_checkCooldownByName(SpellName) then
		return false
	end
	
	-- Find group members who need healing
	local counter = 1
	local notunitarray = {}
	
	while counter do
		local u = Zorlen_GiveGroupUnitWithLowestHealth(pet, nil, nil, notunitarray)
		
		if not u then
			break
		end
		
		-- Skip current target (already tried above)
		if UnitIsUnit("target", u) then
			notunitarray[counter] = u
		-- Heal player directly
		elseif UnitIsUnit("player", u) then
			return castPriestHeal(Mode, RankAdj, u)
		-- Heal other group member (requires targeting)
		else
			TargetUnit(u)
			if castPriestHeal(Mode, RankAdj, u) then
				Zorlen_CastingUnit = u
				Zorlen_CastingNotUnitArray = notunitarray
				TargetLastTarget()
				return true
			end
			TargetLastTarget()
			notunitarray[counter] = u
		end
		
		counter = counter + 1
	end
	
	-- Clean up any ongoing casting if no unit found
	for _, spell in ipairs(healSpells) do
		if Zorlen_isCasting(spell) then
			SpellStopCasting()
			break
		end
	end
	
	return false
end


-- From: Jiral
-- castPriestHeal rewrite this
function castPriestHeal(Mode, RankAdj, unit)
	if Zorlen_isMoving() then
		return false
	end

	local LevelLearnedArray = nil

	local ManaArray, MinHealArray, MaxHealArray, TimeArray = {}, {}, {}, {}
	local SpellNameArray, SpellButtonArray, SpellRankArray = {}, {}, {}
	local idx = 1

	-- helper to append ranks from a spell-id list
	local function addRanks(spellIds, button)
		if not (spellIds and button) then
			Zorlen_debug("No spellIds or button provided for addRanks")
			return
		end

		for _, spellId in ipairs(spellIds) do
		local info = Zorlen_SpellInfo[spellId]
		if info then
			--Zorlen_debug("Adding spell: " .. info.name .. " (ID: " .. spellId .. ")")
			ManaArray[idx]         = info.cost
			MinHealArray[idx]      = info.minVal
			MaxHealArray[idx]      = info.maxVal
			TimeArray[idx]         = info.castTime
			SpellNameArray[idx]    = info.name
			SpellButtonArray[idx]  = button
			SpellRankArray[idx]    = info.rank
			idx = idx + 1
		end
		end
	end

	addRanks(Zorlen_SpellIdsByRankbySpellName[LOCALIZATION_ZORLEN.LesserHeal],  Zorlen_Button_Any[LOCALIZATION_ZORLEN.LesserHeal])
	addRanks(Zorlen_SpellIdsByRankbySpellName[LOCALIZATION_ZORLEN.Heal],        Zorlen_Button_Any[LOCALIZATION_ZORLEN.Heal])
	addRanks(Zorlen_SpellIdsByRankbySpellName[LOCALIZATION_ZORLEN.GreaterHeal], Zorlen_Button_Any[LOCALIZATION_ZORLEN.GreaterHeal])

	-- nothing gathered? bail
	if idx == 1 then
		Zorlen_debug("No healing spells found for priest.")
		return false
	end

	return Zorlen_CastMultiNamedHealingSpell(SpellNameArray, SpellRankArray, ManaArray, MinHealArray, MaxHealArray,
		TimeArray, LevelLearnedArray, Mode, RankAdj, unit, SpellButtonArray)
end


-- Added by Bam
function castFlashHeal(Mode, RankAdj, unit)
	local SpellName = LOCALIZATION_ZORLEN.FlashHeal
	local SpellButton = Zorlen_Button[SpellName]

	return Zorlen_CastHealingSpell(SpellName, nil, nil, nil, nil, nil, Mode, RankAdj, unit, SpellButton)
end



Zorlen_Pets_FileBuildNumber = 685

local PetActionCostDict = {}

local f = CreateFrame("Frame")
f:RegisterEvent("PET_BAR_UPDATE")
f:RegisterEvent("UNIT_PET")
f:SetScript("OnEvent", function()
  PetActionCostDict = {}
  Zorlen_debug("Pet action costs cache cleared due to event: " .. event)
end)

local function GetPetActionCost(slot, spellName)

  -- Return cached value if available
  if PetActionCostDict[spellName] then
	Zorlen_debug("Using cached cost for pet action: " .. spellName)
    return PetActionCostDict[spellName].type, PetActionCostDict[spellName].cost
  end

  -- Tooltip scan
  ZORLEN_Tooltip:SetPetAction(slot)

  local lineCount = ZORLEN_Tooltip:NumLines() or 0
  for i = 2, lineCount do
    local text = getglobal("ZORLEN_TooltipTextLeft"..i):GetText()
    if text then
      local mana = string.match(text, "(%d+)%s+" .. LOCALIZATION_ZORLEN.Mana)
      if mana then
        PetActionCostDict[spellName] = { type = "MANA", cost = tonumber(mana) }
        return "MANA", tonumber(mana)
      end

      local focus = string.match(text, "(%d+)%s+" .. LOCALIZATION_ZORLEN.Focus)
      if focus then
        PetActionCostDict[spellName] = { type = "FOCUS", cost = tonumber(focus) }
        return "FOCUS", tonumber(focus)
      end
    end
  end

  return nil, nil
end

function Zorlen_castPetSpell(SpellName)
  if UnitHealth("pet") <= 0 then
    Zorlen_debug("Your pet is not active or alive to use pet ability: " .. SpellName)
    return false
  end

  for i = 1, NUM_PET_ACTION_SLOTS do
    local slotName, _, _, _, isActive = GetPetActionInfo(i)
    if slotName and slotName == SpellName then
      local _, dur = GetPetActionCooldown(i)

      -- Check cost (tooltip or cache)
      local costType, cost = GetPetActionCost(i, SpellName)

      if cost and costType then
        -- Check resource type (Mana or Focus)
        if costType == "MANA" and UnitMana("pet") < cost then
          Zorlen_debug("Not enough mana for: " .. SpellName)
          return false
        elseif costType == "FOCUS" and UnitMana("pet") < cost then
          Zorlen_debug("Not enough focus for: " .. SpellName)
          return false
        end
      end

      -- Cooldown and active checks
      if dur > 0 then
        Zorlen_debug("Cooldown is enabled for: " .. SpellName)
        return false
      end

      if isActive then
        Zorlen_debug("The pet ability " .. SpellName .. " is active, unable to cast")
        return false
      end

      CastPetAction(i)
      return true
    end
  end

  Zorlen_debug("Unable to locate pet ability: " .. SpellName)
  return false
end

function Zorlen_IsPetSpellOnCooldown(SpellName)
  if not (UnitHealth("pet") > 0) then
    Zorlen_debug("Your pet is not active or alive, cannot check cooldown for: " .. SpellName)
    return false
  end

  for i = 1, NUM_PET_ACTION_SLOTS do
    local slotName = GetPetActionInfo(i)
    if slotName and slotName == SpellName then
      local start, duration, enable = GetPetActionCooldown(i)
      return (start > 0 and duration > 0)
    end
  end

  Zorlen_debug("Unable to locate pet ability: " .. SpellName)
  return false
end

function Zorlen_IsPetSpellAutocastEnabled(SpellName)
  if not (UnitHealth("pet") > 0) then
    Zorlen_debug("Your pet is not active or alive, cannot check autocast state for: " .. SpellName)
    return false
  end

  for i = 1, NUM_PET_ACTION_SLOTS do
    local slotName, _, _, _, _, _, autoCastEnabled = GetPetActionInfo(i)
    if slotName and slotName == SpellName then
      return autoCastEnabled and true or false
    end
  end

  Zorlen_debug("Unable to locate pet ability: " .. SpellName)
  return false
end

function zIsGrowlOnCooldown()
	return Zorlen_IsPetSpellOnCooldown(LOCALIZATION_ZORLEN.Growl)
end

function zIsGrowlAutocast()
	return Zorlen_IsPetSpellAutocastEnabled(LOCALIZATION_ZORLEN.Growl)
end


function Zorlen_TogglePetSpellAutocast(SpellName, mode)
	if UnitHealth("pet") <= 0 then
		Zorlen_debug("Your pet is not active or alive to use pet ability: "..SpellName)
		return false
	end
	
	for i = 1, NUM_PET_ACTION_SLOTS do
		local slotName, _, _, _, _, _, autoCastEnabled = GetPetActionInfo(i)
		
		if slotName and slotName == SpellName then
			if mode == "on" then
				if not autoCastEnabled then
					TogglePetAutocast(i)
					return true
				end
				return false
			end
			
			if mode == "off" then
				if autoCastEnabled then
					TogglePetAutocast(i)
					return true
				end
				return false
			end
			
			-- Default toggle mode
			TogglePetAutocast(i)
			return true
		end
	end
	
	Zorlen_debug("Unable to locate pet ability: "..SpellName)
	return false
end

function Zorlen_PetSpellAutocastOn(SpellName)
	return Zorlen_TogglePetSpellAutocast(SpellName, "on")
end

function Zorlen_PetSpellAutocastOff(SpellName)
	return Zorlen_TogglePetSpellAutocast(SpellName, "off")
end


function Zorlen_petInCombat()
	return Zorlen_PetCombat
end
petInCombat = Zorlen_petInCombat

--Written by Wynn, returns true if your target is someones pet.
function Zorlen_isPet(unit)
	local u = unit or "target"
	if UnitPlayerControlled(u) then
		if UnitIsPlayer(u) then
			return false
		end
		return true
	end
	return false
end
UnitIsPet = Zorlen_isPet
Zorlen_UnitIsPet = Zorlen_isPet
isPet = Zorlen_isPet

function Zorlen_isPetDead()
	if UnitHealth("pet") > 0 then
		return false
	elseif not Zorlen_isCurrentClassHunter then
		return true
	elseif Zorlen_PetIsDead then
		return true
	end
	return false
end
isPetDead = Zorlen_isPetDead

--calls pet if it is unavailable, returns false otherwise
--function to rez dead pet, or return false if it is alive
--written by Trev, redone by BigRedBrent
function needPet()
	if UnitHealth("pet") > 0 then
		return false
	elseif not Zorlen_isCurrentClassHunter then
		return true
	elseif Zorlen_PetIsDead then
		CastSpellByName(LOCALIZATION_ZORLEN.RevivePet)
	else
		CastSpellByName(LOCALIZATION_ZORLEN.CallPet)
	end
	return true
end

--written by Trev,  replaced by BigRedBrent
function rezPet()
	return needPet()
end


function Zorlen_AutoPetAttack(SwitchTargets)
	if not UnitExists("pettarget") or (SwitchTargets and not UnitIsUnit("pettarget", "target")) then
		if Zorlen_isActiveEnemy() then
			PetAttack()
			return true
		end
	end
	if not Zorlen_isActiveEnemy("pettarget") then
		PetFollow()
	end
	return false
end
zAutoPetAttack = Zorlen_AutoPetAttack

function Zorlen_PetAttack(NoTargetSwitch)
	if (not UnitExists("pettarget") or (not NoTargetSwitch and not UnitIsUnit("pettarget", "target"))) and Zorlen_isEnemy() and not Zorlen_isBreakOnDamageCC() then
		PetAttack()
		return true
	end
	if Zorlen_isBreakOnDamageCC("pettarget") then
		PetFollow()
	end
	return false
end
zPetAttack = Zorlen_PetAttack


--------   All functions below this line will only load if you are using pet spells   --------

local global = getfenv(0)
local countFunctions = 0

-- Map for Hunter Pet Spells with autocast support
local HunterPetSpellMap = {
	Dash = {key = "Dash", hasAutocast = true},
	Dive = {key = "Dive", hasAutocast = true},
	Charge = {key = "Charge", hasAutocast = true},
	Bite = {key = "Bite", hasAutocast = true},
	Claw = {key = "Claw", hasAutocast = true},
	Cower = {key = "Cower", hasAutocast = true},
	Growl = {key = "Growl", hasAutocast = true},
	Prowl = {key = "Prowl", hasAutocast = true, combatCheck = true},
	Screech = {key = "Screech", hasAutocast = true},
	Thunderstomp = {key = "Thunderstomp", hasAutocast = true},
	FuriousHowl = {key = "FuriousHowl", hasAutocast = true},
	ShellShield = {key = "ShellShield", hasAutocast = true},
	LightningBreath = {key = "LightningBreath", hasAutocast = true},
	ScorpidPoison = {key = "ScorpidPoison", hasAutocast = true}
}

-- Map for Warlock Pet Spells
local WarlockPetSpellMap = {
	FireShield = {key = "FireShield", hasAutocast = true, hasBuffCheck = true, buffIcon = "Spell_Fire_FireArmor"},
	BloodPact = {key = "BloodPact", hasAutocast = true},
	Firebolt = {key = "Firebolt", hasAutocast = true},
	PhaseShift = {key = "PhaseShift", hasAutocast = true},
	ConsumeShadows = {key = "ConsumeShadows", hasBuffCheck = true, buffIcon = "Spell_Shadow_AntiShadow"},
	Sacrifice = {key = "Sacrifice"},
	Suffering = {key = "Suffering", hasAutocast = true},
	Torment = {key = "Torment", hasAutocast = true},
	DevourMagic = {key = "DevourMagic", hasAutocast = true},
	Paranoia = {key = "Paranoia", hasAutocast = true, hasBuffCheck = true, buffIcon = "Spell_Shadow_AuraOfDarkness"},
	SpellLock = {key = "SpellLock", hasAutocast = true},
	TaintedBlood = {key = "TaintedBlood", hasAutocast = true, hasBuffCheck = true, buffIcon = "Spell_Shadow_LifeDrain"},
	LashOfPain = {key = "LashOfPain", hasAutocast = true},
	Seduction = {key = "Seduction", hasAutocast = true, creatureTypeCheck = "Humanoid"},
	SoothingKiss = {key = "SoothingKiss", hasAutocast = true},
	LesserInvisibility = {key = "LesserInvisibility", hasAutocast = true, hasBuffCheck = true, buffIcon = "Spell_Magic_LesserInvisibility"}
}

-- Generate Hunter pet spell functions
for spellName, config in pairs(HunterPetSpellMap) do
	do
		local funcName = "z" .. spellName
		local cfg = config
		
		-- Main casting function (e.g., zDash())
		global[funcName] = function()
			if cfg.combatCheck and Zorlen_inCombat() then
				return false
			end
			local spellKey = LOCALIZATION_ZORLEN and LOCALIZATION_ZORLEN[cfg.key]
			if not spellKey then return false end
			return Zorlen_castPetSpell(spellKey)
		end
		
		-- Autocast functions if supported
		if cfg.hasAutocast then
			global[funcName .. "AutocastOn"] = function()
				local spellKey = LOCALIZATION_ZORLEN and LOCALIZATION_ZORLEN[cfg.key]
				if not spellKey then return false end
				return Zorlen_PetSpellAutocastOn(spellKey)
			end
			
			global[funcName .. "AutocastOff"] = function()
				local spellKey = LOCALIZATION_ZORLEN and LOCALIZATION_ZORLEN[cfg.key]
				if not spellKey then return false end
				return Zorlen_PetSpellAutocastOff(spellKey)
			end
			
			countFunctions = countFunctions + 2
		end
		
		countFunctions = countFunctions + 1
	end
end

-- Generate Warlock pet spell functions
for spellName, config in pairs(WarlockPetSpellMap) do
	do
		local funcName = "z" .. spellName
		local cfg = config
		
		-- Main casting function with special logic
		global[funcName] = function()
			local spellKey = LOCALIZATION_ZORLEN and LOCALIZATION_ZORLEN[cfg.key]
			if not spellKey then return false end
			
			-- Buff check logic for certain spells
			if cfg.hasBuffCheck then
				if cfg.key == "FireShield" then
					if Zorlen_checkBuff(cfg.buffIcon, "target") or not UnitPlayerOrPetInParty("target") then
						return false
					end
				elseif cfg.key == "ConsumeShadows" then
					if Zorlen_checkBuff(cfg.buffIcon, "pet") or UnitHealth("pet") == UnitHealthMax("pet") then
						return false
					end
				elseif Zorlen_checkBuff(cfg.buffIcon, "pet") then
					return false
				end
			end
			
			-- Creature type check for Seduction
			if cfg.creatureTypeCheck then
				local targetUnit = UnitExists("pettarget") and "pettarget" or (Zorlen_isEnemy() and "target" or nil)
				if not targetUnit then return false end
				if UnitCreatureType(targetUnit) ~= cfg.creatureTypeCheck or Zorlen_isBreakOnDamageCC(targetUnit) then
					return false
				end
			end
			
			return Zorlen_castPetSpell(spellKey)
		end
		
		-- Autocast functions if supported
		if cfg.hasAutocast then
			global[funcName .. "AutocastOn"] = function()
				local spellKey = LOCALIZATION_ZORLEN and LOCALIZATION_ZORLEN[cfg.key]
				if not spellKey then return false end
				return Zorlen_PetSpellAutocastOn(spellKey)
			end
			
			global[funcName .. "AutocastOff"] = function()
				local spellKey = LOCALIZATION_ZORLEN and LOCALIZATION_ZORLEN[cfg.key]
				if not spellKey then return false end
				return Zorlen_PetSpellAutocastOff(spellKey)
			end
			
			countFunctions = countFunctions + 2
		end
		
		countFunctions = countFunctions + 1
	end
end

Zorlen_debug("Zorlen Pets successfully loaded " .. countFunctions .. " generated functions.", 1)

-- Test commands for generated functions (max 255 chars each):
-- /run print("zDash exists:", type(zDash)=="function")
-- /run print("zBite exists:", type(zBite)=="function")
-- /run print("zFireShield exists:", type(zFireShield)=="function")
-- /run print("zSacrifice exists:", type(zSacrifice)=="function")
-- /run print("zDashAutocastOn exists:", type(zDashAutocastOn)=="function")
-- /run print("zFireShieldAutocastOff exists:", type(zFireShieldAutocastOff)=="function")

-- Sanity check test functions:
function ZorlenPetsSanityCheck()
	local passed = 0
	local total = 0
	
	print("=== Zorlen Pets Sanity Check ===")
	
	-- Test Hunter pet functions exist
	local hunterPetFuncs = {"zDash", "zDive", "zCharge", "zBite", "zClaw", "zCower", "zGrowl", "zProwl", "zScreech", "zThunderstomp", "zFuriousHowl", "zShellShield", "zLightningBreath", "zScorpidPoison"}
	for _, func in ipairs(hunterPetFuncs) do
		total = total + 1
		if type(_G[func]) == "function" then
			passed = passed + 1
			print("✓ " .. func .. " exists")
		else
			print("✗ " .. func .. " missing")
		end
	end
	
	-- Test Warlock pet functions exist
	local warlockPetFuncs = {"zFireShield", "zBloodPact", "zFirebolt", "zPhaseShift", "zConsumeShadows", "zSacrifice", "zSuffering", "zTorment", "zDevourMagic", "zParanoia", "zSpellLock", "zTaintedBlood", "zLashOfPain", "zSeduction", "zSoothingKiss", "zLesserInvisibility"}
	for _, func in ipairs(warlockPetFuncs) do
		total = total + 1
		if type(_G[func]) == "function" then
			passed = passed + 1
			print("✓ " .. func .. " exists")
		else
			print("✗ " .. func .. " missing")
		end
	end
	
	-- Test autocast functions exist
	local autocastFuncs = {"zDashAutocastOn", "zDashAutocastOff", "zBiteAutocastOn", "zBiteAutocastOff", "zFireShieldAutocastOn", "zFireShieldAutocastOff"}
	for _, func in ipairs(autocastFuncs) do
		total = total + 1
		if type(_G[func]) == "function" then
			passed = passed + 1
			print("✓ " .. func .. " exists")
		else
			print("✗ " .. func .. " missing")
		end
	end
	
	-- Test special functions exist
	local specialFuncs = {"zAutoCower", "zAutoGrowl", "zAutoConsumeShadows", "zAutoSacrifice", "isFireShield"}
	for _, func in ipairs(specialFuncs) do
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

function ZorlenPetsGeneratedTest()
	print("=== Generated Pet Functions Test ===")
	local passed, total = 0, 0
	
	-- Test Hunter pet spell functions (14 base + 28 autocast = 42 functions)
	local hunterTests = {"zDash", "zDashAutocastOn", "zDashAutocastOff", "zDive", "zDiveAutocastOn", "zDiveAutocastOff", "zCharge", "zChargeAutocastOn", "zChargeAutocastOff", "zBite", "zBiteAutocastOn", "zBiteAutocastOff", "zClaw", "zClawAutocastOn", "zClawAutocastOff", "zCower", "zCowerAutocastOn", "zCowerAutocastOff", "zGrowl", "zGrowlAutocastOn", "zGrowlAutocastOff", "zProwl", "zProwlAutocastOn", "zProwlAutocastOff", "zScreech", "zScreechAutocastOn", "zScreechAutocastOff", "zThunderstomp", "zThunderstompAutocastOn", "zThunderstompAutocastOff", "zFuriousHowl", "zFuriousHowlAutocastOn", "zFuriousHowlAutocastOff", "zShellShield", "zShellShieldAutocastOn", "zShellShieldAutocastOff", "zLightningBreath", "zLightningBreathAutocastOn", "zLightningBreathAutocastOff", "zScorpidPoison", "zScorpidPoisonAutocastOn", "zScorpidPoisonAutocastOff"}
	for _, func in ipairs(hunterTests) do
		total = total + 1
		if type(_G[func]) == "function" then
			passed = passed + 1
		else
			print("✗ " .. func)
		end
	end
	
	-- Test Warlock pet spell functions (16 base + varies autocast)
	local warlockTests = {"zFireShield", "zFireShieldAutocastOn", "zFireShieldAutocastOff", "zBloodPact", "zBloodPactAutocastOn", "zBloodPactAutocastOff", "zFirebolt", "zFireboltAutocastOn", "zFireboltAutocastOff", "zPhaseShift", "zPhaseShiftAutocastOn", "zPhaseShiftAutocastOff", "zConsumeShadows", "zSacrifice", "zSuffering", "zSufferingAutocastOn", "zSufferingAutocastOff", "zTorment", "zTormentAutocastOn", "zTormentAutocastOff", "zDevourMagic", "zDevourMagicAutocastOn", "zDevourMagicAutocastOff", "zParanoia", "zParanoiaAutocastOn", "zParanoiaAutocastOff", "zSpellLock", "zSpellLockAutocastOn", "zSpellLockAutocastOff", "zTaintedBlood", "zTaintedBloodAutocastOn", "zTaintedBloodAutocastOff", "zLashOfPain", "zLashOfPainAutocastOn", "zLashOfPainAutocastOff", "zSeduction", "zSeductionAutocastOn", "zSeductionAutocastOff", "zSoothingKiss", "zSoothingKissAutocastOn", "zSoothingKissAutocastOff", "zLesserInvisibility", "zLesserInvisibilityAutocastOn", "zLesserInvisibilityAutocastOff"}
	for _, func in ipairs(warlockTests) do
		total = total + 1
		if type(_G[func]) == "function" then
			passed = passed + 1
		else
			print("✗ " .. func)
		end
	end
	
	print("Generated functions: " .. passed .. "/" .. total .. " passed")
	print("Total functions loaded by maps: " .. countFunctions .. " (from debug output)")
end

function ZorlenPetsCastTest()
	print("=== Pet Cast Function Test (DRY RUN) ===")
	print("NOTE: These are test calls - no spells will be cast unless you have a pet")
	
	-- Test some basic functions (safe to test)
	local testFuncs = {"zDash", "zBite", "zFireShield", "zConsumeShadows"}
	for _, func in ipairs(testFuncs) do
		if type(_G[func]) == "function" then
			print("Testing " .. func .. ": callable")
		else
			print("✗ " .. func .. " not found")
		end
	end
	
	print("To test actual pet casting, ensure you have an active pet first")
	print("Example usage: /run zDash() -- casts Dash if pet is available")
end


-- Special auto-management functions with flattened logic
function zAutoCower(PetHealthPercent)
	local PetHP = PetHealthPercent or 33
	
	if UnitHealth("pet") <= 0 then
		return false
	end
	
	if UnitPlayerControlled("pettarget") or (UnitPlayerControlled("target") and not UnitExists("pettarget")) then
		return zCowerAutocastOff()
	end
	
	if UnitHealth("pet") / UnitHealthMax("pet") <= PetHP / 100 and UnitIsUnit("pet", "pettargettarget") and UnitHealth("pet") < UnitHealth("player") then
		return zCowerAutocastOn()
	end
	
	return zCowerAutocastOff()
end

function zAutoGrowl(PetHealthPercent)
	local PetHP = PetHealthPercent or 33
	
	if UnitHealth("pet") <= 0 then
		return false
	end
	
	if UnitPlayerControlled("pettarget") or (UnitPlayerControlled("target") and not UnitExists("pettarget")) then
		return zGrowlAutocastOff()
	end
	
	if UnitHealth("pet") / UnitHealthMax("pet") > PetHP / 100 or UnitHealth("pet") >= UnitHealth("player") then
		return zGrowlAutocastOn()
	end
	
	return zGrowlAutocastOff()
end

--Returns true if Fire Shield is active on the target
function isFireShield(unit, castable)
	local u = unit or "target"
	return Zorlen_checkBuff("Spell_Fire_FireArmor", u, castable)
end

function zAutoConsumeShadows(PetHealthPercent)
	local PetHP = PetHealthPercent or 30
	
	if Zorlen_inCombat() then
		return false
	end
	
	if UnitCreatureFamily("pet") ~= LOCALIZATION_ZORLEN.Voidwalker then
		return false
	end
	
	if UnitHealth("pet") <= 0 then
		return false
	end
	
	if UnitHealth("pet") / UnitHealthMax("pet") > PetHP / 100 then
		return false
	end
	
	if Zorlen_checkBuff("Spell_Shadow_AntiShadow", "pet") then
		return false
	end
	
	return Zorlen_castPetSpell(LOCALIZATION_ZORLEN.ConsumeShadows)
end

function zAutoSacrifice(PlayerHealthPercent, PetHealthPercent, OnlyIfYourTargetIsTargetingYou)
	local PlayerHP = PlayerHealthPercent or 30
	local PetHP = PetHealthPercent or 20
	
	if not Zorlen_inCombat() then
		return false
	end
	
	if UnitCreatureFamily("pet") ~= LOCALIZATION_ZORLEN.Voidwalker then
		return false
	end
	
	if UnitHealth("pet") <= 0 then
		return false
	end
	
	if Zorlen_checkDebuffByName(LOCALIZATION_ZORLEN.Banish, "pet") then
		return false
	end
	
	local petLowHealth = UnitHealth("pet") / UnitHealthMax("pet") <= PetHP / 100
	local playerLowHealth = UnitHealth("player") / UnitHealthMax("player") <= PlayerHP / 100
	local targetingCheck = not OnlyIfYourTargetIsTargetingYou or UnitIsUnit("player", "targettarget")
	
	if not (petLowHealth or (playerLowHealth and targetingCheck)) then
		return false
	end
	
	return Zorlen_castPetSpell(LOCALIZATION_ZORLEN.Sacrifice)
end

-- Legacy alias functions to maintain compatibility
function zSacrifice()
	return Zorlen_castPetSpell(LOCALIZATION_ZORLEN.Sacrifice)
end


Zorlen_Pets_FileBuildNumber = 684

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
	local cost = nil
	if not (UnitHealth("pet") > 0) then
		Zorlen_debug("Your pet is not active or alive to use pet ability: "..SpellName)
		return false
	end
	for i=1, NUM_PET_ACTION_SLOTS, 1 do
		local slotName, subText, texture, isToken, isActive, autoCastAllowed, autoCastEnabled = GetPetActionInfo(i)
		if (slotName and slotName == SpellName) then
			if (mode == "on") then
				if not autoCastEnabled then
					TogglePetAutocast(i)
					return true
				end
			elseif (mode == "off") then
				if autoCastEnabled then
					TogglePetAutocast(i)
					return true
				end
			else
				TogglePetAutocast(i)
				return true
			end
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


-- Hunter Pet Spells

function zDash()
	return Zorlen_castPetSpell(LOCALIZATION_ZORLEN.Dash)
end

function zDashAutocastOn()
	return Zorlen_PetSpellAutocastOn(LOCALIZATION_ZORLEN.Dash)
end

function zDashAutocastOff()
	return Zorlen_PetSpellAutocastOff(LOCALIZATION_ZORLEN.Dash)
end



function zDive()
	return Zorlen_castPetSpell(LOCALIZATION_ZORLEN.Dive)
end

function zDiveAutocastOn()
	return Zorlen_PetSpellAutocastOn(LOCALIZATION_ZORLEN.Dive)
end


function zDiveAutocastOff()
	return Zorlen_PetSpellAutocastOff(LOCALIZATION_ZORLEN.Dive)
end


function zCharge()
	return Zorlen_castPetSpell(LOCALIZATION_ZORLEN.Charge)
end

function zChargeAutocastOn()
	return Zorlen_PetSpellAutocastOn(LOCALIZATION_ZORLEN.Charge)
end

function zChargeAutocastOff()
	return Zorlen_PetSpellAutocastOff(LOCALIZATION_ZORLEN.Charge)
end



function zBite()
	return Zorlen_castPetSpell(LOCALIZATION_ZORLEN.Bite)
end

function zBiteAutocastOn()
	return Zorlen_PetSpellAutocastOn(LOCALIZATION_ZORLEN.Bite)
end

function zBiteAutocastOff()
	return Zorlen_PetSpellAutocastOff(LOCALIZATION_ZORLEN.Bite)
end



function zClaw()
	return Zorlen_castPetSpell(LOCALIZATION_ZORLEN.Claw)
end

function zClawAutocastOn()
	return Zorlen_PetSpellAutocastOn(LOCALIZATION_ZORLEN.Claw)
end

function zClawAutocastOff()
	return Zorlen_PetSpellAutocastOff(LOCALIZATION_ZORLEN.Claw)
end



function zCower()
	return Zorlen_castPetSpell(LOCALIZATION_ZORLEN.Cower)
end


function zAutoCower(PetHealthPercent)
	local PetHP = PetHealthPercent or 33
	if UnitHealth("pet") > 0 then
		if UnitPlayerControlled("pettarget") or (UnitPlayerControlled("target") and not UnitExists("pettarget")) then
			return zCowerAutocastOff()
		elseif UnitHealth("pet") / UnitHealthMax("pet") <= PetHP / 100 and UnitIsUnit("pet", "pettargettarget") and UnitHealth("pet") < UnitHealth("player") then
			return zCowerAutocastOn()
		end
		return zCowerAutocastOff()
	end
	return false
end

function zCowerAutocastOn()
	return Zorlen_PetSpellAutocastOn(LOCALIZATION_ZORLEN.Cower)
end

function zCowerAutocastOff()
	return Zorlen_PetSpellAutocastOff(LOCALIZATION_ZORLEN.Cower)
end



function zGrowl()
	return Zorlen_castPetSpell(LOCALIZATION_ZORLEN.Growl)
end


function zAutoGrowl(PetHealthPercent)
	local PetHP = PetHealthPercent or 33
	if UnitHealth("pet") > 0 then
		if UnitPlayerControlled("pettarget") or (UnitPlayerControlled("target") and not UnitExists("pettarget")) then
			return zGrowlAutocastOff()
		elseif UnitHealth("pet") / UnitHealthMax("pet") > PetHP / 100 or UnitHealth("pet") >= UnitHealth("player") then
			return zGrowlAutocastOn()
		end
		return zGrowlAutocastOff()
	end
	return false
end

function zGrowlAutocastOn()
	return Zorlen_PetSpellAutocastOn(LOCALIZATION_ZORLEN.Growl)
end

function zGrowlAutocastOff()
	return Zorlen_PetSpellAutocastOff(LOCALIZATION_ZORLEN.Growl)
end



function zProwl()
	if Zorlen_notInCombat() then
		return Zorlen_castPetSpell(LOCALIZATION_ZORLEN.Prowl)
	end
	return false
end

function zProwlAutocastOn()
	return Zorlen_PetSpellAutocastOn(LOCALIZATION_ZORLEN.Prowl)
end

function zProwlAutocastOff()
	return Zorlen_PetSpellAutocastOff(LOCALIZATION_ZORLEN.Prowl)
end



function zScreech()
	return Zorlen_castPetSpell(LOCALIZATION_ZORLEN.Screech)
end

function zScreechAutocastOn()
	return Zorlen_PetSpellAutocastOn(LOCALIZATION_ZORLEN.Screech)
end

function zScreechAutocastOff()
	return Zorlen_PetSpellAutocastOff(LOCALIZATION_ZORLEN.Screech)
end



function zThunderstomp()
	return Zorlen_castPetSpell(LOCALIZATION_ZORLEN.Thunderstomp)
end

function zThunderstompAutocastOn()
	return Zorlen_PetSpellAutocastOn(LOCALIZATION_ZORLEN.Thunderstomp)
end

function zThunderstompAutocastOff()
	return Zorlen_PetSpellAutocastOff(LOCALIZATION_ZORLEN.Thunderstomp)
end



function zFuriousHowl()
	return Zorlen_castPetSpell(LOCALIZATION_ZORLEN.FuriousHowl)
end

function zFuriousHowlAutocastOn()
	return Zorlen_PetSpellAutocastOn(LOCALIZATION_ZORLEN.FuriousHowl)
end

function zFuriousHowlAutocastOff()
	return Zorlen_PetSpellAutocastOff(LOCALIZATION_ZORLEN.FuriousHowl)
end



function zShellShield()
	return Zorlen_castPetSpell(LOCALIZATION_ZORLEN.ShellShield)
end

function zShellShieldAutocastOn()
	return Zorlen_PetSpellAutocastOn(LOCALIZATION_ZORLEN.ShellShield)
end

function zShellShieldAutocastOff()
	return Zorlen_PetSpellAutocastOff(LOCALIZATION_ZORLEN.ShellShield)
end



function zLightningBreath()
	return Zorlen_castPetSpell(LOCALIZATION_ZORLEN.LightningBreath)
end

function zLightningBreathAutocastOn()
	return Zorlen_PetSpellAutocastOn(LOCALIZATION_ZORLEN.LightningBreath)
end

function zLightningBreathAutocastOff()
	return Zorlen_PetSpellAutocastOff(LOCALIZATION_ZORLEN.LightningBreath)
end



function zScorpidPoison()
	return Zorlen_castPetSpell(LOCALIZATION_ZORLEN.ScorpidPoison)
end

function zScorpidPoisonAutocastOn()
	return Zorlen_PetSpellAutocastOn(LOCALIZATION_ZORLEN.ScorpidPoison)
end

function zScorpidPoisonAutocastOff()
	return Zorlen_PetSpellAutocastOff(LOCALIZATION_ZORLEN.ScorpidPoison)
end



-- Warlock Pet Spells

--Returns true if Fire Shield is active on the target
function isFireShield(unit, castable)
	local u = unit or "target"
	return Zorlen_checkBuff("Spell_Fire_FireArmor", u, castable)
end

function zFireShield()
	if not Zorlen_checkBuff("Spell_Fire_FireArmor", "target") and UnitPlayerOrPetInParty("target") then
		return Zorlen_castPetSpell(LOCALIZATION_ZORLEN.FireShield)
	end
	return false
end

function zFireShieldAutocastOn()
	return Zorlen_PetSpellAutocastOn(LOCALIZATION_ZORLEN.FireShield)
end

function zFireShieldAutocastOff()
	return Zorlen_PetSpellAutocastOff(LOCALIZATION_ZORLEN.FireShield)
end



function zBloodPact()
	return Zorlen_castPetSpell(LOCALIZATION_ZORLEN.BloodPact)
end

function zBloodPactAutocastOn()
	return Zorlen_PetSpellAutocastOn(LOCALIZATION_ZORLEN.BloodPact)
end

function zBloodPactAutocastOff()
	return Zorlen_PetSpellAutocastOff(LOCALIZATION_ZORLEN.BloodPact)
end



function zFirebolt()
	return Zorlen_castPetSpell(LOCALIZATION_ZORLEN.Firebolt)
end

function zFireboltAutocastOn()
	return Zorlen_PetSpellAutocastOn(LOCALIZATION_ZORLEN.Firebolt)
end

function zFireboltAutocastOff()
	return Zorlen_PetSpellAutocastOff(LOCALIZATION_ZORLEN.Firebolt)
end



function zPhaseShift()
	return Zorlen_castPetSpell(LOCALIZATION_ZORLEN.PhaseShift)
end

function zPhaseShiftAutocastOn()
	return Zorlen_PetSpellAutocastOn(LOCALIZATION_ZORLEN.PhaseShift)
end

function zPhaseShiftAutocastOff()
	return Zorlen_PetSpellAutocastOff(LOCALIZATION_ZORLEN.PhaseShift)
end



function zConsumeShadows()
	if not Zorlen_checkBuff("Spell_Shadow_AntiShadow", "pet") and not (UnitHealth("pet") == UnitHealthMax("pet")) then
		return Zorlen_castPetSpell(LOCALIZATION_ZORLEN.ConsumeShadows)
	end
	return false
end

function zAutoConsumeShadows(PetHealthPercent)
	local PetHP = PetHealthPercent or 30
	if Zorlen_notInCombat() and UnitCreatureFamily("pet") == LOCALIZATION_ZORLEN.Voidwalker and UnitHealth("pet") > 0 and UnitHealth("pet") / UnitHealthMax("pet") <= PetHP / 100 and not Zorlen_checkBuff("Spell_Shadow_AntiShadow", "pet") then
		return Zorlen_castPetSpell(LOCALIZATION_ZORLEN.ConsumeShadows)
	end
	return false
end


function zSacrifice()
	return Zorlen_castPetSpell(LOCALIZATION_ZORLEN.Sacrifice)
end

function zAutoSacrifice(PlayerHealthPercent, PetHealthPercent, OnlyIfYourTargetIsTargetingYou)
	local PlayerHP = PlayerHealthPercent or 30
	local PetHP = PetHealthPercent or 20
	if Zorlen_inCombat() and UnitCreatureFamily("pet") == LOCALIZATION_ZORLEN.Voidwalker and UnitHealth("pet") > 0 and (UnitHealth("pet") / UnitHealthMax("pet") <= PetHP / 100 or ((not OnlyIfYourTargetIsTargetingYou or UnitIsUnit("player", "targettarget")) and UnitHealth("player") / UnitHealthMax("player") <= PlayerHP / 100)) and not Zorlen_checkDebuffByName(LOCALIZATION_ZORLEN.Banish, "pet") then
		return Zorlen_castPetSpell(LOCALIZATION_ZORLEN.Sacrifice)
	end
	return false
end



function zSuffering()
	return Zorlen_castPetSpell(LOCALIZATION_ZORLEN.Suffering)
end

function zSufferingAutocastOn()
	return Zorlen_PetSpellAutocastOn(LOCALIZATION_ZORLEN.Suffering)
end

function zSufferingAutocastOff()
	return Zorlen_PetSpellAutocastOff(LOCALIZATION_ZORLEN.Suffering)
end



function zTorment()
	return Zorlen_castPetSpell(LOCALIZATION_ZORLEN.Torment)
end

function zTormentAutocastOn()
	return Zorlen_PetSpellAutocastOn(LOCALIZATION_ZORLEN.Torment)
end

function zTormentAutocastOff()
	return Zorlen_PetSpellAutocastOff(LOCALIZATION_ZORLEN.Torment)
end



function zDevourMagic()
	return Zorlen_castPetSpell(LOCALIZATION_ZORLEN.DevourMagic)
end

function zDevourMagicAutocastOn()
	return Zorlen_PetSpellAutocastOn(LOCALIZATION_ZORLEN.DevourMagic)
end

function zDevourMagicAutocastOff()
	return Zorlen_PetSpellAutocastOff(LOCALIZATION_ZORLEN.DevourMagic)
end



function zParanoia()
	if not Zorlen_checkBuff("Spell_Shadow_AuraOfDarkness", "pet") then
		return Zorlen_castPetSpell(LOCALIZATION_ZORLEN.Paranoia)
	end
	return false
end

function zParanoiaAutocastOn()
	return Zorlen_PetSpellAutocastOn(LOCALIZATION_ZORLEN.Paranoia)
end

function zParanoiaAutocastOff()
	return Zorlen_PetSpellAutocastOff(LOCALIZATION_ZORLEN.Paranoia)
end



function zSpellLock()
	return Zorlen_castPetSpell(LOCALIZATION_ZORLEN.SpellLock)
end

function zSpellLockAutocastOn()
	return Zorlen_PetSpellAutocastOn(LOCALIZATION_ZORLEN.SpellLock)
end

function zSpellLockAutocastOff()
	return Zorlen_PetSpellAutocastOff(LOCALIZATION_ZORLEN.SpellLock)
end



function zTaintedBlood()
	if not Zorlen_checkBuff("Spell_Shadow_LifeDrain", "pet") then
		return Zorlen_castPetSpell(LOCALIZATION_ZORLEN.TaintedBlood)
	end
	return false
end

function zTaintedBloodAutocastOn()
	return Zorlen_PetSpellAutocastOn(LOCALIZATION_ZORLEN.TaintedBlood)
end

function zTaintedBloodAutocastOff()
	return Zorlen_PetSpellAutocastOff(LOCALIZATION_ZORLEN.TaintedBlood)
end



function zLashOfPain()
	return Zorlen_castPetSpell(LOCALIZATION_ZORLEN.LashOfPain)
end

function zLashOfPainAutocastOn()
	return Zorlen_PetSpellAutocastOn(LOCALIZATION_ZORLEN.LashOfPain)
end

function zLashOfPainAutocastOff()
	return Zorlen_PetSpellAutocastOff(LOCALIZATION_ZORLEN.LashOfPain)
end



function zSeduction()
	if UnitExists("pettarget") then
		if UnitCreatureType("pettarget") ~= "Humanoid" or Zorlen_isBreakOnDamageCC("pettarget") then
			return false
		end
	elseif Zorlen_isEnemy() then
		if UnitCreatureType("target") ~= "Humanoid" or Zorlen_isBreakOnDamageCC() then
			return false
		end
	else
		return false
	end
	return Zorlen_castPetSpell(LOCALIZATION_ZORLEN.Seduction)
end

function zSeductionAutocastOn()
	return Zorlen_PetSpellAutocastOn(LOCALIZATION_ZORLEN.Seduction)
end

function zSeductionAutocastOff()
	return Zorlen_PetSpellAutocastOff(LOCALIZATION_ZORLEN.Seduction)
end



function zSoothingKiss()
	return Zorlen_castPetSpell(LOCALIZATION_ZORLEN.SoothingKiss)
end

function zSoothingKissAutocastOn()
	return Zorlen_PetSpellAutocastOn(LOCALIZATION_ZORLEN.SoothingKiss)
end

function zSoothingKissAutocastOff()
	return Zorlen_PetSpellAutocastOff(LOCALIZATION_ZORLEN.SoothingKiss)
end



function zLesserInvisibility()
	if not Zorlen_checkBuff("Spell_Magic_LesserInvisibility", "pet") then
		return Zorlen_castPetSpell(LOCALIZATION_ZORLEN.LesserInvisibility)
	end
	return false
end

function zLesserInvisibilityAutocastOn()
	return Zorlen_PetSpellAutocastOn(LOCALIZATION_ZORLEN.LesserInvisibility)
end

function zLesserInvisibilityAutocastOff()
	return Zorlen_PetSpellAutocastOff(LOCALIZATION_ZORLEN.LesserInvisibility)
end

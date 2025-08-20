# Zorlen
Zorlen Functions Library

# Added support for Turtle WoW custom spells

## Paladin

| Function | Spell Name | Description | Alias |
|----------|-------------|-------------|--------|
| `isDAA()` | `DevotionAura` | (no description) |  |
| `isCAA()` | `ConcentrationAura` | (no description) |  |
| `isFiRAA()` | `FireResistanceAura` | (no description) |  |
| `isFrRAA()` | `FrostResistanceAura` | (no description) |  |
| `isRAA()` | `RetributionAura` | (no description) |  |
| `isSRAA()` | `ShadowResistanceAura` | (no description) |  |
| `isSAA()` | `SanctityAura` | (no description) |  |
| `isBoFA()` | `BlessingOfFreedom` | (no description) |  |
| `isBoKA()` | `BlessingOfKings` | (no description) |  |
| `isBoLA()` | `BlessingOfLight` | (no description) |  |
| `isBoMA()` | `BlessingOfMight` | (no description) |  |
| `isBoPA()` | `BlessingOfProtection` | (no description) |  |
| `isBoSacA()` | `BlessingOfSacrifice` | (no description) |  |
| `isBoSalA()` | `BlessingOfSalvation` | (no description) |  |
| `isBoSanA()` | `BlessingOfSanctuary` | (no description) |  |
| `isBoWA()` | `BlessingOfWisdom` | (no description) |  |
| `isGBoKA()` | `GreaterBlessingOfKings` | (no description) |  |
| `isGBoLA()` | `GreaterBlessingOfLight` | (no description) |  |
| `isGBoMA()` | `GreaterBlessingOfMight` | (no description) |  |
| `isGBoSalA()` | `GreaterBlessingOfSalvation` | (no description) |  |
| `isGBoSanA()` | `GreaterBlessingOfSanctuary` | (no description) |  |
| `isGBoWA()` | `GreaterBlessingOfWisdom` | (no description) |  |
| `isSoJA()` | `SealOfJustice` | (no description) |  |
| `isSoLA()` | `SealOfLight` | (no description) |  |
| `isSoRA()` | `SealOfRighteousness` | (no description) |  |
| `isSoWA()` | `SealOfWisdom` | (no description) |  |
| `isSotCA()` | `SealOfTheCrusader` | (no description) |  |
| `isSoCA()` | `SealOfCommand` | (no description) |  |
| `isSenseUndeadActive()` | `SenseUndead` | (no description) |  |
| `isHolyShieldActive()` | `HolyShield` | (no description) |  |
| `isDivineProtectionActive()` | `DivineProtection` | (no description) |  |
| `isRighteousFuryActive()` | `RighteousFury` | (no description) |  |
| `isRedoubtActive()` | `Redoubt` | (no description) |  |
| `isZealActive()` | `Zeal` | (no description) |  |
| `castDA()` | `DevotionAura` | (no description) |  |
| `castRA()` | `RetributionAura` | (no description) |  |
| `castCA()` | `ConcentrationAura` | (no description) |  |
| `castSRA()` | `ShadowResistanceAura` | (no description) |  |
| `castFrRA()` | `FrostResistanceAura` | (no description) |  |
| `castFiRA()` | `FireResistanceAura` | (no description) |  |
| `castSotC()` | `SealOfTheCrusader` | (no description) |  |
| `castSoR()` | `SealOfRighteousness` | (no description) |  |
| `castSoJ()` | `SealOfJustice` | (no description) |  |
| `castSoL()` | `SealOfLight` | (no description) |  |
| `castSoW()` | `SealOfWisdom` | (no description) |  |
| `castSoC()` | `SealOfCommand` | (no description) |  |
| `castCrusaderStrike()` | `CrusaderStrike` | (no description) |  |
| `castHolyStrike()` | `HolyStrike` | (no description) |  |
| `isPaladinResistanceAuraActive()` | `-` | ----------------------------------- | `isPRAA()` |
| `isPaladinAuraActive()` | `-` | (no description) | `isPAA()` |
| `isRegularBlessingActive()` | `-` | (no description) | `isRBA()` |
| `isGreaterBlessingActive()` | `-` | (no description) | `isGBA()` |
| `isBlessingActive()` | `-` | Returns true if any blessing is active | `isBA()` |
| `isSealActive()` | `-` | (no description) | `isSA()` |
| `ZealCount()` | `-` | (no description) |  |
| `ZealTimeLeft()` | `-` | (no description) |  |
| `castJudgement()` | `-` | Casts judgement if a seal is active |  |
| `castDivineProtection()` | `-` | Divine Protection (not in cast map) |  |
| `castHolyShield()` | `-` | (no description) |  |
| `blessingForUnit()` | `-` | Auto blessing functions |  |
| `castAutoBlessing()` | `-` | (no description) |  |

## Priest

### Buff/Debuff Checking Functions

| Function | Spell Name | Description | Alias |
|----------|-------------|-------------|--------|
| `isRenew()` | `Renew` | Checks if Renew buff is active |  |
| `isPowerWordFortitude()` | `Power Word: Fortitude` | Checks if Power Word: Fortitude buff is active |  |
| `isPowerWordShield()` | `Power Word: Shield` | Checks if Power Word: Shield buff is active |  |
| `isInnerFire()` | `Inner Fire` | Checks if Inner Fire buff is active |  |
| `isDivineSpirit()` | `Divine Spirit` | Checks if Divine Spirit buff is active |  |
| `isShadowWordPain()` | `Shadow Word: Pain` | Checks if Shadow Word: Pain debuff is active |  |
| `isHolyFire()` | `Holy Fire` | Checks if Holy Fire debuff is active |  |
| `isMindControl()` | `Mind Control` | Checks if Mind Control debuff is active |  |
| `isMindFlay()` | `Mind Flay` | Checks if Mind Flay debuff is active |  |
| `isShackleUndead()` | `Shackle Undead` | Checks if Shackle Undead debuff is active |  |
| `isTouchOfWeakness()` | `Touch of Weakness` | Checks if Touch of Weakness debuff is active |  |
| `isHexOfWeakness()` | `Hex of Weakness` | Checks if Hex of Weakness debuff is active |  |
| `isVampiricEmbrace()` | `Vampiric Embrace` | Checks if Vampiric Embrace debuff is active |  |
| `isWeakenedSoul()` | `Weakened Soul` | Checks if Weakened Soul debuff is active |  |
| `isFear()` | `Fear` | Checks if Fear debuff is active |  |
| `isPsychicScream()` | `Psychic Scream` | Checks if Psychic Scream debuff is active |  |
| `isMindBlast()` | `Mind Blast` | Checks if Mind Blast debuff is active |  |
| `isMindSoothe()` | `Mind Soothe` | Checks if Mind Soothe debuff is active |  |
| `isMindVision()` | `Mind Vision` | Checks if Mind Vision debuff is active |  |
| `isDevouringPlague()` | `Devouring Plague` | Checks if Devouring Plague debuff is active |  |

### Active Variant Functions

| Function | Description |
|----------|-------------|
| `isRenewActive()` | Alias for isRenew() |
| `isPowerWordFortitudeActive()` | Alias for isPowerWordFortitude() |
| `isPowerWordShieldActive()` | Alias for isPowerWordShield() |
| `isInnerFireActive()` | Alias for isInnerFire() |
| `isDivineSpiritActive()` | Alias for isDivineSpirit() |
| `isShadowWordPainActive()` | Alias for isShadowWordPain() |
| `isHolyFireActive()` | Alias for isHolyFire() |
| `isMindControlActive()` | Alias for isMindControl() |
| `isMindFlayActive()` | Alias for isMindFlay() |
| `isShackleUndeadActive()` | Alias for isShackleUndead() |
| `isTouchOfWeaknessActive()` | Alias for isTouchOfWeakness() |
| `isHexOfWeaknessActive()` | Alias for isHexOfWeakness() |
| `isVampiricEmbraceActive()` | Alias for isVampiricEmbrace() |
| `isWeakenedSoulActive()` | Alias for isWeakenedSoul() |
| `isFearActive()` | Alias for isFear() |
| `isPsychicScreamActive()` | Alias for isPsychicScream() |
| `isMindBlastActive()` | Alias for isMindBlast() |
| `isMindSootheActive()` | Alias for isMindSoothe() |
| `isMindVisionActive()` | Alias for isMindVision() |
| `isDevouringPlagueActive()` | Alias for isDevouringPlague() |

### Spell Casting Functions

| Function | Spell Name | Description |
|----------|-------------|-------------|
| `castShadowWordPain()` | `Shadow Word: Pain` | Casts Shadow Word: Pain with debuff timer tracking |
| `castHolyFire()` | `Holy Fire` | Casts Holy Fire with debuff tracking |
| `castMindControl()` | `Mind Control` | Casts Mind Control (checks if moving) |
| `castMindFlay()` | `Mind Flay` | Casts Mind Flay (checks if moving) |
| `castTouchOfWeakness()` | `Touch of Weakness` | Casts Touch of Weakness with debuff tracking |
| `castHexOfWeakness()` | `Hex of Weakness` | Casts Hex of Weakness with debuff tracking |
| `castInnerFire()` | `Inner Fire` | Casts Inner Fire (self-buff, no target needed) |
| `castShadowguard()` | `Shadowguard` | Casts Shadowguard (self-buff, no target needed) |
| `castDivineSpirit()` | `Divine Spirit` | Casts Divine Spirit (self-buff, no target needed) |
| `castDevouringPlague()` | `Devouring Plague` | Casts Devouring Plague |
| `castMindBlast()` | `Mind Blast` | Casts Mind Blast (checks if moving) |
| `castSmite()` | `Smite` | Casts Smite (checks if moving) |
| `castVampiricEmbrace()` | `Vampiric Embrace` | Casts Vampiric Embrace with debuff tracking |
| `castPsychicScream()` | `Psychic Scream` | Casts Psychic Scream (no target/range check needed) |
| `castFear()` | `Fear` | Casts Fear with debuff tracking |
| `castShackleUndead()` | `Shackle Undead` | Casts Shackle Undead with debuff tracking |
| `castMindSoothe()` | `Mind Soothe` | Casts Mind Soothe (checks if moving) |
| `castMindVision()` | `Mind Vision` | Casts Mind Vision (no target needed) |

### Healing Functions

| Function | Description |
|----------|-------------|
| `castLesserHeal(Mode, RankAdj, unit)` | Casts Lesser Heal with specified mode and rank adjustment |
| `castHeal(Mode, RankAdj, unit)` | Casts Heal with specified mode and rank adjustment |
| `castGreaterHeal(Mode, RankAdj, unit)` | Casts Greater Heal with specified mode and rank adjustment |
| `castPriestHeal(Mode, RankAdj, unit)` | Intelligent heal selection (Lesser/Heal/Greater) |
| `castFlashHeal(Mode, RankAdj, unit)` | Casts Flash Heal with specified mode and rank adjustment |
| `castGroupPriestHeal(pet, Mode, RankAdj)` | Group healing with lowest health priority |

### Healing Variant Functions (Auto-generated)

| Function | Description |
|----------|-------------|
| `castUnderLesserHeal(RankAdj, unit)` | Casts Lesser Heal with "under" mode (lower ranks) |
| `castOverLesserHeal(RankAdj, unit)` | Casts Lesser Heal with "over" mode (higher ranks) |
| `castMaxLesserHeal(RankAdj, unit)` | Casts Lesser Heal with "maximum" mode (highest rank) |
| `castUnderHeal(RankAdj, unit)` | Casts Heal with "under" mode (lower ranks) |
| `castOverHeal(RankAdj, unit)` | Casts Heal with "over" mode (higher ranks) |
| `castMaxHeal(RankAdj, unit)` | Casts Heal with "maximum" mode (highest rank) |
| `castUnderGreaterHeal(RankAdj, unit)` | Casts Greater Heal with "under" mode (lower ranks) |
| `castOverGreaterHeal(RankAdj, unit)` | Casts Greater Heal with "over" mode (higher ranks) |
| `castMaxGreaterHeal(RankAdj, unit)` | Casts Greater Heal with "maximum" mode (highest rank) |
| `castUnderPriestHeal(RankAdj, unit)` | Casts intelligent heal with "under" mode (lower ranks) |
| `castOverPriestHeal(RankAdj, unit)` | Casts intelligent heal with "over" mode (higher ranks) |
| `castMaxPriestHeal(RankAdj, unit)` | Casts intelligent heal with "maximum" mode (highest rank) |
| `castUnderFlashHeal(RankAdj, unit)` | Casts Flash Heal with "under" mode (lower ranks) |
| `castOverFlashHeal(RankAdj, unit)` | Casts Flash Heal with "over" mode (higher ranks) |
| `castMaxFlashHeal(RankAdj, unit)` | Casts Flash Heal with "maximum" mode (highest rank) |
| `castUnderGroupPriestHeal(pet, RankAdj)` | Group heal with "under" mode (lower ranks) |
| `castOverGroupPriestHeal(pet, RankAdj)` | Group heal with "over" mode (higher ranks) |
| `castMaxGroupPriestHeal(pet, RankAdj)` | Group heal with "maximum" mode (highest rank) |

### Additional Priest Functions

| Function | Description |
|----------|-------------|
| `castSelfPowerWordFortitude()` | Casts Power Word: Fortitude on self |
| `castGroupPowerWordFortitude(unit)` | Casts Power Word: Fortitude on group members |
| `castPowerWordFortitude(unit)` | Casts Power Word: Fortitude with intelligent targeting |
| `castSelfRenew()` | Casts Renew on self |
| `castRenew(unit)` | Casts Renew with intelligent targeting |
| `castSelfPowerWordShield()` | Casts Power Word: Shield on self |
| `castPowerWordShield(unit)` | Casts Power Word: Shield with intelligent targeting |
| `castSelfDispelMagic()` | Casts Dispel Magic on self |
| `castFriendlyDispelMagic(unit)` | Casts Dispel Magic on friendly target |
| `castDispelMagic(unit)` | Casts Dispel Magic with intelligent targeting |

### Test Functions

| Function | Description |
|----------|-------------|
| `ZorlenPriestGeneratedTest()` | Tests all generated priest functions (76 total) |
| `ZorlenPriestCastTest()` | Dry run test for basic priest casting functions |
| `ZorlenPriestBuffTest()` | Tests priest buff checking functions |

**Note**: All priest functions support the standard Zorlen parameters:
- `Mode`: "under", "over", "maximum" for healing spells
- `RankAdj`: Rank adjustment (-1 for lower ranks, +1 for higher ranks)
- `unit`: Target unit ("target", "player", "party1", etc.)
- Most functions include `test` parameter for dry-run testing

## Pets

### Hunter Pet Spells

| Function | Spell Name | Description | Type |
|----------|-------------|-------------|------|
| `zDash()` | `Dash` | Casts pet Dash ability | Hunter |
| `zDashAutocastOn()` | `Dash` | Enables autocast for Dash | Hunter |
| `zDashAutocastOff()` | `Dash` | Disables autocast for Dash | Hunter |
| `zDive()` | `Dive` | Casts pet Dive ability | Hunter |
| `zDiveAutocastOn()` | `Dive` | Enables autocast for Dive | Hunter |
| `zDiveAutocastOff()` | `Dive` | Disables autocast for Dive | Hunter |
| `zCharge()` | `Charge` | Casts pet Charge ability | Hunter |
| `zChargeAutocastOn()` | `Charge` | Enables autocast for Charge | Hunter |
| `zChargeAutocastOff()` | `Charge` | Disables autocast for Charge | Hunter |
| `zBite()` | `Bite` | Casts pet Bite ability | Hunter |
| `zBiteAutocastOn()` | `Bite` | Enables autocast for Bite | Hunter |
| `zBiteAutocastOff()` | `Bite` | Disables autocast for Bite | Hunter |
| `zClaw()` | `Claw` | Casts pet Claw ability | Hunter |
| `zClawAutocastOn()` | `Claw` | Enables autocast for Claw | Hunter |
| `zClawAutocastOff()` | `Claw` | Disables autocast for Claw | Hunter |
| `zCower()` | `Cower` | Casts pet Cower ability | Hunter |
| `zCowerAutocastOn()` | `Cower` | Enables autocast for Cower | Hunter |
| `zCowerAutocastOff()` | `Cower` | Disables autocast for Cower | Hunter |
| `zGrowl()` | `Growl` | Casts pet Growl ability | Hunter |
| `zGrowlAutocastOn()` | `Growl` | Enables autocast for Growl | Hunter |
| `zGrowlAutocastOff()` | `Growl` | Disables autocast for Growl | Hunter |
| `zProwl()` | `Prowl` | Casts pet Prowl ability (out of combat only) | Hunter |
| `zProwlAutocastOn()` | `Prowl` | Enables autocast for Prowl | Hunter |
| `zProwlAutocastOff()` | `Prowl` | Disables autocast for Prowl | Hunter |
| `zScreech()` | `Screech` | Casts pet Screech ability | Hunter |
| `zScreechAutocastOn()` | `Screech` | Enables autocast for Screech | Hunter |
| `zScreechAutocastOff()` | `Screech` | Disables autocast for Screech | Hunter |
| `zThunderstomp()` | `Thunderstomp` | Casts pet Thunderstomp ability | Hunter |
| `zThunderstompAutocastOn()` | `Thunderstomp` | Enables autocast for Thunderstomp | Hunter |
| `zThunderstompAutocastOff()` | `Thunderstomp` | Disables autocast for Thunderstomp | Hunter |
| `zFuriousHowl()` | `Furious Howl` | Casts pet Furious Howl ability | Hunter |
| `zFuriousHowlAutocastOn()` | `Furious Howl` | Enables autocast for Furious Howl | Hunter |
| `zFuriousHowlAutocastOff()` | `Furious Howl` | Disables autocast for Furious Howl | Hunter |
| `zShellShield()` | `Shell Shield` | Casts pet Shell Shield ability | Hunter |
| `zShellShieldAutocastOn()` | `Shell Shield` | Enables autocast for Shell Shield | Hunter |
| `zShellShieldAutocastOff()` | `Shell Shield` | Disables autocast for Shell Shield | Hunter |
| `zLightningBreath()` | `Lightning Breath` | Casts pet Lightning Breath ability | Hunter |
| `zLightningBreathAutocastOn()` | `Lightning Breath` | Enables autocast for Lightning Breath | Hunter |
| `zLightningBreathAutocastOff()` | `Lightning Breath` | Disables autocast for Lightning Breath | Hunter |
| `zScorpidPoison()` | `Scorpid Poison` | Casts pet Scorpid Poison ability | Hunter |
| `zScorpidPoisonAutocastOn()` | `Scorpid Poison` | Enables autocast for Scorpid Poison | Hunter |
| `zScorpidPoisonAutocastOff()` | `Scorpid Poison` | Disables autocast for Scorpid Poison | Hunter |

### Warlock Pet Spells

| Function | Spell Name | Description | Type |
|----------|-------------|-------------|------|
| `zFireShield()` | `Fire Shield` | Casts Fire Shield (checks if target needs it) | Warlock |
| `zFireShieldAutocastOn()` | `Fire Shield` | Enables autocast for Fire Shield | Warlock |
| `zFireShieldAutocastOff()` | `Fire Shield` | Disables autocast for Fire Shield | Warlock |
| `zBloodPact()` | `Blood Pact` | Casts pet Blood Pact ability | Warlock |
| `zBloodPactAutocastOn()` | `Blood Pact` | Enables autocast for Blood Pact | Warlock |
| `zBloodPactAutocastOff()` | `Blood Pact` | Disables autocast for Blood Pact | Warlock |
| `zFirebolt()` | `Firebolt` | Casts pet Firebolt ability | Warlock |
| `zFireboltAutocastOn()` | `Firebolt` | Enables autocast for Firebolt | Warlock |
| `zFireboltAutocastOff()` | `Firebolt` | Disables autocast for Firebolt | Warlock |
| `zPhaseShift()` | `Phase Shift` | Casts pet Phase Shift ability | Warlock |
| `zPhaseShiftAutocastOn()` | `Phase Shift` | Enables autocast for Phase Shift | Warlock |
| `zPhaseShiftAutocastOff()` | `Phase Shift` | Disables autocast for Phase Shift | Warlock |
| `zConsumeShadows()` | `Consume Shadows` | Casts Consume Shadows (checks buff status) | Warlock |
| `zSacrifice()` | `Sacrifice` | Casts pet Sacrifice ability | Warlock |
| `zSuffering()` | `Suffering` | Casts pet Suffering ability | Warlock |
| `zSufferingAutocastOn()` | `Suffering` | Enables autocast for Suffering | Warlock |
| `zSufferingAutocastOff()` | `Suffering` | Disables autocast for Suffering | Warlock |
| `zTorment()` | `Torment` | Casts pet Torment ability | Warlock |
| `zTormentAutocastOn()` | `Torment` | Enables autocast for Torment | Warlock |
| `zTormentAutocastOff()` | `Torment` | Disables autocast for Torment | Warlock |
| `zDevourMagic()` | `Devour Magic` | Casts pet Devour Magic ability | Warlock |
| `zDevourMagicAutocastOn()` | `Devour Magic` | Enables autocast for Devour Magic | Warlock |
| `zDevourMagicAutocastOff()` | `Devour Magic` | Disables autocast for Devour Magic | Warlock |
| `zParanoia()` | `Paranoia` | Casts Paranoia (checks buff status) | Warlock |
| `zParanoiaAutocastOn()` | `Paranoia` | Enables autocast for Paranoia | Warlock |
| `zParanoiaAutocastOff()` | `Paranoia` | Disables autocast for Paranoia | Warlock |
| `zSpellLock()` | `Spell Lock` | Casts pet Spell Lock ability | Warlock |
| `zSpellLockAutocastOn()` | `Spell Lock` | Enables autocast for Spell Lock | Warlock |
| `zSpellLockAutocastOff()` | `Spell Lock` | Disables autocast for Spell Lock | Warlock |
| `zTaintedBlood()` | `Tainted Blood` | Casts Tainted Blood (checks buff status) | Warlock |
| `zTaintedBloodAutocastOn()` | `Tainted Blood` | Enables autocast for Tainted Blood | Warlock |
| `zTaintedBloodAutocastOff()` | `Tainted Blood` | Disables autocast for Tainted Blood | Warlock |
| `zLashOfPain()` | `Lash of Pain` | Casts pet Lash of Pain ability | Warlock |
| `zLashOfPainAutocastOn()` | `Lash of Pain` | Enables autocast for Lash of Pain | Warlock |
| `zLashOfPainAutocastOff()` | `Lash of Pain` | Disables autocast for Lash of Pain | Warlock |
| `zSeduction()` | `Seduction` | Casts Seduction (checks creature type) | Warlock |
| `zSeductionAutocastOn()` | `Seduction` | Enables autocast for Seduction | Warlock |
| `zSeductionAutocastOff()` | `Seduction` | Disables autocast for Seduction | Warlock |
| `zSoothingKiss()` | `Soothing Kiss` | Casts pet Soothing Kiss ability | Warlock |
| `zSoothingKissAutocastOn()` | `Soothing Kiss` | Enables autocast for Soothing Kiss | Warlock |
| `zSoothingKissAutocastOff()` | `Soothing Kiss` | Disables autocast for Soothing Kiss | Warlock |
| `zLesserInvisibility()` | `Lesser Invisibility` | Casts Lesser Invisibility (checks buff status) | Warlock |
| `zLesserInvisibilityAutocastOn()` | `Lesser Invisibility` | Enables autocast for Lesser Invisibility | Warlock |
| `zLesserInvisibilityAutocastOff()` | `Lesser Invisibility` | Disables autocast for Lesser Invisibility | Warlock |

### Pet Management Functions

| Function | Description | Parameters |
|----------|-------------|------------|
| `zAutoCower(PetHealthPercent)` | Automatically manages Cower autocast based on pet health | `PetHealthPercent` (default: 33%) |
| `zAutoGrowl(PetHealthPercent)` | Automatically manages Growl autocast based on pet health | `PetHealthPercent` (default: 33%) |
| `zAutoConsumeShadows(PetHealthPercent)` | Auto-casts Consume Shadows when conditions are met | `PetHealthPercent` (default: 30%) |
| `zAutoSacrifice(PlayerHealthPercent, PetHealthPercent, OnlyIfTargeting)` | Auto-casts Sacrifice based on health thresholds | Player HP% (30%), Pet HP% (20%), targeting check |

### Pet Utility Functions

| Function | Description |
|----------|-------------|
| `Zorlen_castPetSpell(SpellName)` | Core function to cast any pet spell with validation |
| `Zorlen_IsPetSpellOnCooldown(SpellName)` | Checks if a pet spell is on cooldown |
| `Zorlen_IsPetSpellAutocastEnabled(SpellName)` | Checks if autocast is enabled for a pet spell |
| `Zorlen_TogglePetSpellAutocast(SpellName, mode)` | Toggles pet spell autocast ("on", "off", or toggle) |
| `Zorlen_PetSpellAutocastOn(SpellName)` | Enables autocast for specified pet spell |
| `Zorlen_PetSpellAutocastOff(SpellName)` | Disables autocast for specified pet spell |
| `zIsGrowlOnCooldown()` | Checks if Growl is on cooldown |
| `zIsGrowlAutocast()` | Checks if Growl autocast is enabled |
| `isFireShield(unit, castable)` | Checks if Fire Shield buff is active on target |

### Pet Combat Functions

| Function | Description |
|----------|-------------|
| `Zorlen_AutoPetAttack(SwitchTargets)` | Automatically manages pet attack/follow behavior |
| `Zorlen_PetAttack(NoTargetSwitch)` | Commands pet to attack with CC considerations |
| `Zorlen_petInCombat()` | Returns true if pet is in combat |
| `Zorlen_isPet(unit)` | Returns true if unit is a pet |
| `Zorlen_isPetDead()` | Returns true if pet is dead |
| `needPet()` | Calls/revives pet if needed |
| `rezPet()` | Alias for needPet() |

### Pet Test Functions

| Function | Description |
|----------|-------------|
| `ZorlenPetsSanityCheck()` | Tests that all pet functions exist and are callable |
| `ZorlenPetsGeneratedTest()` | Comprehensive test of all generated pet functions (80+ total) |
| `ZorlenPetsCastTest()` | Dry run test for basic pet casting functions |

### Pet Function Statistics

- **Total Functions Generated**: 80+ (automatically generated from maps)
- **Hunter Pet Functions**: 42 functions (14 spells × 3 functions each)
- **Warlock Pet Functions**: 44+ functions (16 spells with varying autocast support)
- **Utility Functions**: 15+ core pet management functions
- **Auto-Management Functions**: 4 intelligent pet behavior functions

**Note**: All pet functions include:
- Automatic pet health/status validation
- Resource cost checking (mana/focus)
- Cooldown verification
- Localization support
- Debug output for troubleshooting

**Usage Examples**:
```lua
-- Basic pet spell casting
zBite()                    -- Cast Bite if conditions are met
zGrowlAutocastOn()         -- Enable Growl autocast
zFireShield()              -- Cast Fire Shield on valid target

-- Auto-management
zAutoCower(25)             -- Auto-manage Cower at 25% pet health
zAutoSacrifice(20, 15, true) -- Auto-sacrifice at 20% player, 15% pet health

-- Testing
ZorlenPetsSanityCheck()    -- Validate all functions loaded
ZorlenPetsCastTest()       -- Test basic functionality
```
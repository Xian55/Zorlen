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
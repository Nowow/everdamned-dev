Scriptname ET_VLPowerVampiricDrainScript extends ActiveMagicEffect  

Event OnEffectStart(Actor akTarget, Actor akCaster)
	Debug.Trace("VAMPIRE DRAIN: effect applied")
	Victim = akTarget
	SpellCaster = akCaster
EndEvent

Event OnDying(Actor akKiller)
	Debug.Trace("VAMPIRE DRAIN: Target dying")
	if akKiller == Game.GetPlayer()
		If Victim.HasMagicEffect(ReanimateSecondaryFFAimed) == false && Victim.HasSpell(GhostAbilityNew) == false
			Debug.Trace("VAMPIRE DRAIN: Absorb Health spell - is not a ghost or a commanded actor")
			DLC1PlayerVampireQuest.BloodlineProgress()
			if ProhibitedCreatures.HasForm( GetTargetActor().GetRace() ) == False
			endif
		endif
	endif
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	Debug.Trace("VAMPIRE DRAIN: effect finished")
	if victim.IsDead()
		Utility.Wait(0.1)
	endif
endEvent

actor SpellCaster
actor Victim

FormList Property ProhibitedCreatures  Auto  

MagicEffect Property ReanimateSecondaryFFAimed  Auto  

SPELL Property GhostAbilityNew  Auto

DLC1PlayerVampireChangeScript Property DLC1PlayerVampireQuest Auto  
Scriptname ET_DeathAshSCR extends ActiveMagicEffect  

import debug
import FormList

float property fDelay = 0.75 auto
float property fDelayEnd = 1.65 auto
float property ShaderDuration = 0.00 auto
Activator property AshPileObject auto
EffectShader property MagicEffectShader auto
Bool property bSetAlphaZero = True auto
FormList Property ImmunityList auto
Bool property bSetAlphaToZeroEarly = False Auto

actor Victim
race VictimRace
bool TargetIsImmune = True

Event OnEffectStart(Actor Target, Actor Caster)
	victim = target
	; DeadAlready = Victim.IsDead()
	trace("victim == " + victim + ", is this right?")
EndEvent


Event OnDying(Actor Killer)

	if ImmunityList == none
		TargetIsImmune = False
	else
		ActorBase VictimBase = Victim.GetBaseObject() as ActorBase
		VictimRace = VictimBase.GetRace()
		
		if ImmunityList.hasform(VictimRace)
			TargetIsImmune = True
		elseif ImmunityList.hasform(VictimBase)
			TargetIsImmune = True
		else
			TargetIsImmune = False
		endif
	endif

	if TargetIsImmune == False
		trace("victim just died")
		; DeadAlready = true
		victim.SetCriticalStage(Victim.CritStage_DisintegrateStart)
		;victim.SetAlpha (0.99,False)
		if	MagicEffectShader != none
			MagicEffectShader.play(Victim,ShaderDuration)
		endif
		if bSetAlphaToZeroEarly
			victim.SetAlpha (0.0,True)
		endif
		utility.wait(fDelay)     
		Victim.AttachAshPile(AshPileObject)
		; AshPileRef = AshPileObject
		; AshPileRef.SetAngle(0.0,0.0,(Victim.GetAngleZ()))
		utility.wait(fDelayEnd)
		if	MagicEffectShader != none
			MagicEffectShader.stop(Victim)
		endif
		if bSetAlphaZero == True
			victim.SetAlpha (0.0,True)
		endif
			if	victim != Game.GetPlayer()
				victim.SetCriticalStage(Victim.CritStage_DisintegrateEnd)
			endif
	endif
	
EndEvent


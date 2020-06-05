Scriptname ET_PowerMagicMSBShamblingHordesSecSCR extends ActiveMagicEffect  

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
Keyword Property ActorTypeDaedra  Auto  
Keyword Property ActorTypeFamiliar  Auto  
bool Property AshPileCreated  Auto  

actor Victim
race VictimRace
bool TargetIsImmune = False

bool function IsSummoned()
	if Victim.HasKeyword(ActorTypeFamiliar) || Victim.HasKeyword(ActorTypeDaedra)
		return true
	else
		return false
	endIf
endFunction

bool function TurnToAsh()
		trace("victim just died")
		victim.SetCriticalStage(Victim.CritStage_DisintegrateStart)
		if	MagicEffectShader != none
			MagicEffectShader.play(Victim,ShaderDuration)
		endif
		if bSetAlphaToZeroEarly
			victim.SetAlpha (0.0,True)
		endif
		utility.wait(fDelay)     
		Victim.AttachAshPile(AshPileObject)
		utility.wait(fDelayEnd)
		if	MagicEffectShader != none
			MagicEffectShader.stop(Victim)
		endif
		if bSetAlphaZero == True
			victim.SetAlpha (0.0,True)
		endif
		victim.SetCriticalStage(Victim.CritStage_DisintegrateEnd)

endFunction

Event OnEffectStart(Actor Target, Actor Caster)
	victim = target

	if Victim.IsCommandedActor() == True && IsSummoned() == False
		TargetIsImmune = False
		SHList.AddForm(GetTargetActor())
	else
		TargetIsImmune = True
	endIf

EndEvent


Event OnDying(Actor Killer)

	if TargetIsImmune == False && AshPileCreated == False
		TurnToAsh()
		AshPileCreated == True
	endif
	
EndEvent

Event OnEffectFinish(Actor Target, Actor Caster)

	if TargetIsImmune == False && AshPileCreated == False
		TurnToAsh()
		AshPileCreated == True
	endif

EndEvent

FormList Property SHList Auto
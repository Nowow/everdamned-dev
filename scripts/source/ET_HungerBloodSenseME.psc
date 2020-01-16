Scriptname ET_HungerBloodSenseME extends ActiveMagicEffect 

Event OnEffectStart(Actor akTarget, Actor akCaster)
	RegisterForSingleUpdate(10)
EndEvent

Event OnUpdate()
	int random = Utility.RandomInt()
	if (random <= 35 && GetTargetActor().HasSpell(HungerState3) || GetTargetActor().HasSpell(HungerState4))
		DetectLife.Cast(GetTargetActor())
	endif
	RegisterForSingleUpdate(10)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	GetTargetActor().RemoveSpell(DetectLife)
EndEvent

SPELL Property DetectLife  Auto  
SPELL Property HungerState3 Auto  
SPELL Property HungerState4 Auto  

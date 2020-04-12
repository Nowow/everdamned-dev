Scriptname ET_PowerMightFortitudeAVigorMortisSCR extends activemagiceffect  

Event OnEffectStart(Actor Target, Actor Caster)
	CostTotal = CostBase
	ET_VampireBloodPoolDelta.Mod(-CostTotal)
EndEvent

Event OnEffectFinish(Actor Target, Actor Caster)
	ET_VampireBloodPoolDelta.Mod(CostTotal)
EndEvent

GlobalVariable Property ET_VampireBloodPoolDelta  Auto  
Float Property CostBase Auto
Float Property CostTotal Auto
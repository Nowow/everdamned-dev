Scriptname ET_VLPowerMagicBMAVampiricDrainScript extends activemagiceffect  

float TargHealth

Event OnEffectStart(Actor akTarget, Actor akCaster)
	TargHealth = akTarget.GetAV("Health")
Endevent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	if akTarget.IsDead() == TRUE
		ET_VampireBloodPoolCurrent.Mod(TargHealth*ET_VampireBLoodPoolRatio.GetValue())
		ET_Exp.Mod((TargHealth*ET_VampireBLoodPoolRatio.GetValue())/5*ET_ExpMult.GetValue())
	endif
Endevent

GlobalVariable Property ET_VampireBloodPoolCurrent Auto
GlobalVariable Property ET_VampireBLoodPoolRatio Auto
GlobalVariable Property ET_Exp Auto
GlobalVariable Property ET_ExpMult Auto
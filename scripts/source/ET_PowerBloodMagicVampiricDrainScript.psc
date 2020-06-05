Scriptname ET_PowerBloodMagicVampiricDrainScript extends activemagiceffect  

float TargHealth

Event OnEffectStart(Actor akTarget, Actor akCaster)
	TargHealth = akTarget.GetAV("Health")
Endevent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
;TODO
;VampricDrain Blood Meter recovery
;exp?
	

;	if akTarget.IsDead() == TRUE
;		mslVTBloodCur.Mod(TargHealth*mslVTBloodRatio.GetValue())
;		mslVTExp.Mod((TargHealth*mslVTBloodRatio.GetValue())/5*mslVTExpMult.GetValue())
;	endif
Endevent

GlobalVariable Property ET_VampireBloodPoolCurrent Auto
GlobalVariable Property ET_VampireBloodPoolRatio Auto
GlobalVariable Property ET_Exp Auto
GlobalVariable Property ET_ExpMult Auto
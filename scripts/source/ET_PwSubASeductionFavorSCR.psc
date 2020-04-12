Scriptname ET_PwSubASeductionFavorSCR extends ActiveMagicEffect  

Event OnEffectStart(Actor akTarget, Actor akCaster)
	akTarget.EvaluatePackage()
Endevent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	akTarget.SetDoingFavor(false)
Endevent
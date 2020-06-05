Scriptname ET_PowerUndyingGluttonyEffectScript extends activemagiceffect  

Event OnEffectStart(actor akTarget, actor akCaster)
	ET_VampireBloodPoolMaxOnTop.Value = akTarget.GetLevel()*100
Endevent

Event OnEffectFinish(actor akTarget, actor akCaster)
	ET_VampireBloodPoolMaxOnTop.Value = 0
Endevent

GlobalVariable Property ET_VampireBloodPoolMaxOnTop Auto
Scriptname ET_SunRestrictionsSCR extends activemagiceffect  

Event OnEffectStart(actor akTarget, actor akCaster)
	Game.SetInChargen(false, true, true)
Endevent

Event OnEffectFinish(actor akTarget, actor akCaster)
	Game.SetInChargen(false, false, false)
Endevent
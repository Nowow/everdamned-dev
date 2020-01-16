Scriptname ET_HungerFearScript extends activemagiceffect  

Event OnEffectStart(Actor akTarget, Actor akCaster)
	akTarget.StartCombat(akCaster)
Endevent

Event OnEffectStop(Actor akTarget, Actor akCaster)
	akTarget.StopCombat()
Endevent
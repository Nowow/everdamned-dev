Scriptname ET_PowerCorpseMarionetteAnim extends activemagiceffect  

Event OnEffectStart(Actor akTarget, Actor akCaster)
	If RegisterForAnimationEvent(akCaster, "ET_CutHandBlood")
		akCaster.SetRestrained(true)
		Debug.SendAnimationEvent(akCaster, "ET_CutHandBlood")
		Utility.wait(9.0)
		akCaster.SetRestrained(false)
	Else
		Debug.Trace("Corpse Marionette casting animation event unavailable! Someone was naughty and didn't run FNIS.", 2)
	Endif
Endevent
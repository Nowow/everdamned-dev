Scriptname ET_SleepControlSCR extends activemagiceffect  

Event OnEffectStart(Actor akTarget, Actor akCaster)
	If (akTarget == Game.GetPlayer())
		RegisterForSleep()
	Endif
Endevent

Event OnSleepStart(float afSleepStartTime, float afDesiredSleepEndTime)
	DetActMult.SetValue(0.5)
	DetNatMult.SetValue(0.5)
	;Debug.Notification("Zzzzzz...")
Endevent

Event OnSleepStop(bool abInterrupted)
	utility.wait(2.0)
	DetActMult.SetValue(1)
	DetNatMult.SetValue(1)
	;Debug.Notification("Good morning!")
Endevent

GlobalVariable Property DetActMult Auto
GlobalVariable Property DetNatMult Auto
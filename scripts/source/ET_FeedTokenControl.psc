Scriptname ET_FeedTokenControl extends activemagiceffect  

float Property TimeNew Auto
float Property TimePassed Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)

	Actor targetActor = GetTargetActor()
	
	Debug.Trace("DEBUG: Everdamned:  Health recovery manager on NPC " + targetActor + " started!")

	float lastTimeUpdated = targetActor.GetAV("Fame")
	
	if lastTimeUpdated != 0
		TimeNew = GameDaysPassed.GetValue()
		TimePassed = TimeNew - lastTimeUpdated
		targetActor.ModAV("Variable08", -(0.5*TimePassed)) 
	Endif
	targetActor.ForceAV("Fame", GameDaysPassed.GetValue())
	
	float currentHealth = targetActor.GetAV("Health")
	float baseHealth = targetActor.GetBaseAV("Health")
	float recoveryControlAV = targetActor.GetAV("Variable08")

	if currentHealth > baseHealth*(1-recoveryControlAV)
		float healthSurplus = currentHealth - baseHealth*(1-recoveryControlAV)
		targetActor.DamageAV("Health", healthSurplus)
	endif

	if recoveryControlAV <= 0
		
		Debug.Trace("DEBUG: Everdamned: Health recovery manager on NPC " + targetActor + ": work done! SELF DESTRUCTING NOW!" )
		
		targetActor.ForceAV("Variable08",0)
		targetActor.RemoveFromFaction(ET_FeedRecoveryFAC)
	endif

Endevent

GlobalVariable Property GameDaysPassed Auto
Faction Property ET_FeedRecoveryFAC Auto

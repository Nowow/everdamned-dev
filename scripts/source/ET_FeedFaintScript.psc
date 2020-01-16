Scriptname ET_FeedFaintScript extends activemagiceffect  

Event OnEffectStart(Actor akTarget, Actor akCaster)
	akCaster.PushActorAway(akTarget, 0.0)
Endevent
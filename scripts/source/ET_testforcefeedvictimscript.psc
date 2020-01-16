Scriptname ET_testforcefeedvictimscript extends ActiveMagicEffect  

Spell Property ET_SustainedFeedingControlSpell Auto

Event OnEffectStart(Actor Target, Actor Caster)
    
	Debug.Notification("Attaching feed spell to victim " + Target as string)
    Target.AddSpell(ET_SustainedFeedingControlSpell)
	
EndEvent


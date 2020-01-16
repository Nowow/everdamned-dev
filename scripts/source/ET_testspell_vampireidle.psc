Scriptname ET_testspell_vampireidle extends ActiveMagicEffect  

; Armor Property VampireSkinFXArmor auto

VisualEffect property FeedBloodVFX auto
Idle Property IdleVampireTransformation auto
Sound Property NPCVampireTransformation auto
Sound Property NPCVampireTransformationB2D auto
Sound Property NPCVampireTransformationB3D auto
Explosion Property FXVampChangeExplosion auto
SPELL Property DLC1VampireChangeStagger  Auto  

Event OnEffectStart(Actor Target, Actor Caster)

    Debug.Trace("TEST EFFECT STARTED")
	Debug.Notification("TEST EFFECT STARTED")
	
	Actor PlayerRef = Game.GetPlayer()
	
	if Target == PlayerRef
		Debug.Notification("Target is player ref!")
	elseif (Target != None)
		Debug.Notification("Target is NOT player ref!")
	else
		Debug.Notification("Target is NONE! LOL!")
	endif
		
       ; RegisterForAnimationEvent(Target, "SetRace")
        Target.PlayIdle(IdleVampireTransformation)
	; I added this explosion and blood to give the transition some pop!
		Target.placeatme(FXVampChangeExplosion)
		DLC1VampireChangeStagger.Cast(Target, Target)
		;splatters? --me
		utility.Wait(0.33)
		Game.TriggerScreenBlood(5)
		utility.Wait(0.1)
		Game.TriggerScreenBlood(10)
EndEvent
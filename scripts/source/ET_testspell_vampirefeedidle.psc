Scriptname ET_testspell_vampirefeedidle extends ActiveMagicEffect  

; Armor Property VampireSkinFXArmor auto

Idle Property ET_vampirefeedback auto

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
		
	if Caster.PlayIdleWithTarget(ET_vampirefeedback, Target)
		Debug.Trace("Feeeeeed")
		Debug.Notification("Feeeeeed")
	else
		Debug.Trace("Something went wrong")
		Debug.Notification("Something went wrong")
	endIf
;[03/23/2019 - 02:40:10AM] [Actor < (00000014)>]: PairEnd
;[03/23/2019 - 02:40:10AM] [Actor < (00000014)>]: 2_PairEnd
;[03/23/2019 - 02:40:10AM] [Actor < (00000014)>]: tailUnequip
;[03/23/2019 - 02:40:10AM] [Actor < (00000014)>]: weaponSheathe
;[03/23/2019 - 02:52:43AM] [Actor < (00000014)>]: tailEquip ??????????
;?????
		
EndEvent
Scriptname ET_testgunidlescript extends ActiveMagicEffect  


Idle Property ET_gun_idle auto

Event OnEffectStart(Actor Target, Actor Caster)

    Debug.Trace("TEST EFFECT STARTED")
	;Debug.Notification("TEST EFFECT STARTED")
	
	Actor PlayerRef = Game.GetPlayer()
	
	if Target == PlayerRef
		Debug.Trace("ET_TESTSPELL: Target is player ref!")
	elseif (Target != None)
		Debug.Trace("ET_TESTSPELL: Target is NOT player ref!")
	else
		Debug.Trace("ET_TESTSPELL: Target is NONE! LOL!")
	endif
	

	Debug.SendAnimationEvent(PlayerRef, "SexualVampireFeedAnimations_VampFeed10_A2_S1")
	Debug.Notification("SexualVampireFeedAnimations_VampFeed10_A2_S1")
	Utility.Wait(4.0)
	Debug.SendAnimationEvent(PlayerRef, "SexualVampireFeedAnimations_VampFeed9_A2_S2")
	Debug.Notification("SexualVampireFeedAnimations_VampFeed9_A2_S2")
	Utility.Wait(4.0)
	Debug.SendAnimationEvent(PlayerRef, "SexualVampireFeedAnimations_VampFeed8_A2_S1")
	Debug.Notification("SexualVampireFeedAnimations_VampFeed8_A2_S1")
	Utility.Wait(4.0)
	Debug.SendAnimationEvent(PlayerRef, "SexualVampireFeedAnimations_VampFeed7_A2_S1")
	Debug.Notification("SexualVampireFeedAnimations_VampFeed7_A2_S1")
	Utility.Wait(4.0)
	Debug.SendAnimationEvent(PlayerRef, "SexualVampireFeedAnimations_VampFeed6_A2_S1")
	Debug.Notification("SexualVampireFeedAnimations_VampFeed6_A2_S1")
	Utility.Wait(4.0)
	Debug.SendAnimationEvent(PlayerRef, "SexualVampireFeedAnimations_VampFeed5_A2_S1")
	Debug.Notification("SexualVampireFeedAnimations_VampFeed5_A2_S1")
	Utility.Wait(4.0)
	Debug.SendAnimationEvent(PlayerRef, "SexualVampireFeedAnimations_VampFeed4_A2_S2")
	Debug.Notification("SexualVampireFeedAnimations_VampFeed4_A2_S2")
	Utility.Wait(4.0)
	Debug.SendAnimationEvent(PlayerRef, "SexualVampireFeedAnimations_VampFeed3_A2_S1")
	Debug.Notification("SexualVampireFeedAnimations_VampFeed3_A2_S1")
	Utility.Wait(4.0)
	Debug.SendAnimationEvent(PlayerRef, "SexualVampireFeedAnimations_VampFeed2_A2_S1")
	Debug.Notification("SexualVampireFeedAnimations_VampFeed2_A2_S1")
	Utility.Wait(4.0)
	Debug.SendAnimationEvent(PlayerRef, "SexualVampireFeedAnimations_VampFeed1_A2_S2")
	Debug.Notification("SexualVampireFeedAnimations_VampFeed1_A2_S2")

	
	;if Caster.PlayIdle(ET_gun_idle)
	;	Debug.Trace("ET_TESTSPELL: Dance!")
		
	;else
	;	Debug.Trace("ET_TESTSPELL: Something went wrong")
	;	;Debug.Notification("Something went wrong")
	;endIf
;[03/23/2019 - 02:40:10AM] [Actor < (00000014)>]: PairEnd
;[03/23/2019 - 02:40:10AM] [Actor < (00000014)>]: 2_PairEnd
;[03/23/2019 - 02:40:10AM] [Actor < (00000014)>]: tailUnequip
;[03/23/2019 - 02:40:10AM] [Actor < (00000014)>]: weaponSheathe
;[03/23/2019 - 02:52:43AM] [Actor < (00000014)>]: tailEquip ??????????
;?????
		
		
EndEvent

Scriptname ET_GarkainBeastTransformVisual extends ActiveMagicEffect  

; Armor Property VampireSkinFXArmor auto
Race Property ET_VampireGarkainBeastRace auto

;VisualEffect property FeedBloodVFX auto

Idle Property IdleVampireTransformation auto

Sound Property NPCVampireTransformation auto
Sound Property NPCVampireTransformationB2D auto
Sound Property NPCVampireTransformationB3D auto
Explosion Property FXVampChangeExplosion auto

Quest Property DLC1PlayerVampireQuest auto
Quest Property DLC1TrackingQuest auto
Quest Property PlayerGarkainBeastQuest auto

Event OnEffectStart(Actor Target, Actor Caster)
    Debug.Trace("VAMPIRE: Starting change anim...")

    if (Target.GetActorBase().GetRace() != ET_VampireGarkainBeastRace)
		; Add the tranformation wolf skin Armor effect 
		; Target.equipitem(VampireSkinFXArmor,False,True)
		
        RegisterForAnimationEvent(Target, "SetRace")
        Target.PlayIdle(IdleVampireTransformation)
        Utility.Wait(10)
        TransformIfNecessary(Target)
    endif
EndEvent

Event OnAnimationEvent(ObjectReference akSource, string asEventName)
    Debug.Trace("VAMPIRE: Getting anim event -- " + akSource + " " + asEventName)
    if (asEventName == "SetRace")
        TransformIfNecessary(akSource as Actor)
    endif
EndEvent

Function TransformIfNecessary(Actor Target)
	if (Target == None)
		Debug.Trace("VAMPIRE: Trying to transform something that's not an actor; bailing out.", 2)
		return
	endif

	UnRegisterForAnimationEvent(Target, "SetRace")

	Actor PlayerRef = Game.GetPlayer()
	Race currRace = Target.GetRace()
	
	if (currRace != ET_VampireGarkainBeastRace)
		Debug.Trace("VAMPIRE: VISUAL: Setting race " + ET_VampireGarkainBeastRace + " on " + Target)

		if Target != PlayerRef
			Debug.Trace("VAMPIRE: VISUAL: Target is not player, doing the transition here.")
			Target.SetRace(ET_VampireGarkainBeastRace)
			
		else ;Target == PlayerRef
			Debug.Trace("VAMPIRE: VISUAL: Target is  player, doing the transition in ET_garkainbeastchangescript.")
			DLC1VampireTrackingQuest vts = (DLC1TrackingQuest as DLC1VampireTrackingQuest)
			if (vts.PlayerRace == None)
				vts.PlayerRace = currRace
			endif
			Debug.Trace("VAMPIRE: VISUAL: DLC1TrackingQuest player race is set to " + currRace)

			PlayerGarkainBeastQuest.SetStage(1)

        endif

		; I added this explosion and blood to give the transition some pop!
		target.placeatme(FXVampChangeExplosion)
		if target == PlayerRef
			DLC1VampireChangeStagger.Cast(Target, Target)
		endif

		if Target == PlayerRef || Target.GetDistance(PlayerRef) < 300
			utility.Wait(0.33)
			Game.TriggerScreenBlood(5)
			utility.Wait(0.1)
			Game.TriggerScreenBlood(10)
		endif
		
    endif

EndFunction



SPELL Property DLC1VampireChangeStagger  Auto  

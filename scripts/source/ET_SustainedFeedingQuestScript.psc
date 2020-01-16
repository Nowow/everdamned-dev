Scriptname ET_SustainedFeedingQuestScript extends Quest  

Event OnInit()
	Debug.Notification("Sucking quest initiated")
	Debug.Trace("Sucking quest initiated")
	Actor PlayerActor = Game.GetPlayer()
	RegisterForAnimationEvent(PlayerActor, "pairedStop")
	Debug.Notification("Animation event registred.")
	Debug.Trace("Animation event registred.")
EndEvent


Event OnAnimationEvent(ObjectReference akSource, string asEventName)
	Debug.Notification(asEventName + " event catched.")
	Debug.Trace(asEventName + " event catched.")
	Actor PlayerActor = Game.GetPlayer()
	String animStopperEvent = "IdleForceDefaultState"
	if (akSource == PlayerActor) && (asEventName == "pairedStop")
		Debug.Notification(asEventName + " event catched succsessfully.")
		Debug.Trace(asEventName + " event catched succsessfully.")
		Debug.SendAnimationEvent(PlayerActor, animStopperEvent)
		Debug.Trace("Sent "+animStopperEvent)
		RegisterForAnimationEvent(PlayerActor, "pairedStop")
		
	endif

endEvent
;IdleOffsetStop
;EnableBumper
;"IdleForceDefaultState"
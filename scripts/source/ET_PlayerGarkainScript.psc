Scriptname ET_PlayerGarkainScript extends ReferenceAlias  

Race Property ET_VampireGarkainBeastRace auto

Event OnRaceSwitchComplete()
	if (GetActorReference().GetRace() == ET_VampireGarkainBeastRace)
; 		Debug.Trace("WEREWOLF: Getting notification that race swap TO werewolf is complete.")
		(GetOwningQuest() as ET_garkainbeastchangescript).StartTracking()
	else
; 		Debug.Trace("WEREWOLF: Getting notification that race swap FROM werewolf is complete.")
		(GetOwningQuest() as ET_garkainbeastchangescript).Shutdown()
	endif
EndEvent

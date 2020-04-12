Scriptname ET_PwSubMesAEntrancementSCR extends ActiveMagicEffect

Event OnEffectStart(Actor akTarget, Actor akCaster)

	int EntranceLimit = ET_Age.GetValueInt()

	If EntranceTarget1.GetRef() == NONE && EntranceLimit >= 1
		MyAlias = EntranceTarget1
	Elseif EntranceTarget2.GetRef() == NONE && EntranceLimit >= 2
		MyAlias = EntranceTarget2
	Elseif EntranceTarget3.GetRef() == NONE && EntranceLimit >= 3
		MyAlias = EntranceTarget3
	Elseif EntranceTarget4.GetRef() == NONE && EntranceLimit >= 4
		MyAlias = EntranceTarget4
	Elseif EntranceTarget5.GetRef() == NONE && EntranceLimit >= 5
		MyAlias = EntranceTarget5
	Elseif EntranceTarget6.GetRef() == NONE && EntranceLimit >= 6
		MyAlias = EntranceTarget6
	Elseif EntranceTarget7.GetRef() == NONE && EntranceLimit >= 7
		MyAlias = EntranceTarget7
	Elseif EntranceTarget8.GetRef() == NONE && EntranceLimit >= 8
		MyAlias = EntranceTarget8
	Elseif EntranceTarget9.GetRef() == NONE && EntranceLimit >= 9
		MyAlias = EntranceTarget9
	Elseif EntranceTarget10.GetRef() == NONE && EntranceLimit >= 10
		MyAlias = EntranceTarget10
	Else
		(TargetsList.GetAt(0) as Actor).RemoveFromFaction(EntranceFaction)
		TargetsList.RemoveAddedForm(TargetsList.GetAt(0))
		;Debug.Notification("You cannot entrance any more subjects!")
		;Debug.Notification("Limit Reached! Spilling over...")
		if EntranceTarget1.GetRef() == NONE && EntranceLimit >= 1
			MyAlias = EntranceTarget1
		elseif EntranceTarget2.GetRef() == NONE && EntranceLimit >= 2
			MyAlias = EntranceTarget2
		elseif EntranceTarget3.GetRef() == NONE && EntranceLimit >= 3
			MyAlias = EntranceTarget3
		elseif EntranceTarget4.GetRef() == NONE && EntranceLimit >= 4
			MyAlias = EntranceTarget4
		elseif EntranceTarget5.GetRef() == NONE && EntranceLimit >= 5
			MyAlias = EntranceTarget5
		elseif EntranceTarget6.GetRef() == NONE && EntranceLimit >= 6
			MyAlias = EntranceTarget6
		elseif EntranceTarget7.GetRef() == NONE && EntranceLimit >= 7
			MyAlias = EntranceTarget7
		elseif EntranceTarget8.GetRef() == NONE && EntranceLimit >= 8
			MyAlias = EntranceTarget8
		elseif EntranceTarget9.GetRef() == NONE && EntranceLimit >= 9
			MyAlias = EntranceTarget9
		elseif EntranceTarget10.GetRef() == NONE && EntranceLimit >= 10
			MyAlias = EntranceTarget10
		endif
	Endif

	MyAlias.ForceRefTo(akTarget)
	akTarget.EvaluatePackage()
	TargetsList.AddForm(akTarget)
	if akTarget.IsPlayerTeammate() == 0
		akTarget.SetPlayerTeammate(True)
	else
		TeammateCheck = TRUE
	Endif
	;Debug.Notification("Number of subjects: " + TargetsList.GetSize())

	RegisterForSingleUpdate(1)
Endevent

Event OnUpdate()
	if game.GetPlayer().getCombatTarget() && !GetTargetActor().getCombatTarget()
		GetTargetActor().startCombat(game.GetPlayer().getCombatTarget())
	endif
	RegisterForSingleUpdate(1)
Endevent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	UnregisterForUpdate()
	akTarget.RemoveFromFaction(EntranceFaction)
	TargetsList.RemoveAddedForm(akTarget)
	MyAlias.Clear()
	if TeammateCheck != TRUE
		akTarget.SetPlayerTeammate(False)
	endif
	;Debug.Notification("Number of subjects: " + TargetsList.GetSize())
Endevent

Quest Property EntrancementQuest  Auto  
ReferenceAlias Property EntranceTarget1  Auto  
ReferenceAlias Property EntranceTarget2  Auto  
ReferenceAlias Property EntranceTarget3  Auto  
ReferenceAlias Property EntranceTarget4  Auto  
ReferenceAlias Property EntranceTarget5  Auto  
ReferenceAlias Property EntranceTarget6  Auto  
ReferenceAlias Property EntranceTarget7  Auto  
ReferenceAlias Property EntranceTarget8  Auto  
ReferenceAlias Property EntranceTarget9  Auto  
ReferenceAlias Property EntranceTarget10  Auto
ReferenceAlias Property MyAlias  Auto  
GlobalVariable Property ET_Age Auto
FormList Property TargetsList Auto
MagicEffect Property SeductionEffect Auto
Bool Property TeammateCheck = FALSE Auto
Faction Property EntranceFaction Auto
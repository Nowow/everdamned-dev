Scriptname ET_SustainedFeedingControlScript extends activemagiceffect  
;do not need aaSexScene01 at all
;spell is added to victim, it controls victim and Game.GetPlayer()
;magic effect ends when this spell gets removed
		
Idle Property PlayerFeedIdle Auto
Idle Property VictimFeedIdle Auto
Idle Property VictimExitIdle Auto
Idle Property PlayerExitIdle Auto

Spell Property SustainedFeedingControlSpell Auto

GlobalVariable Property ET_SustainedFeedingIsOn  Auto
GlobalVariable Property ET_FeedingUseScale Auto

bool SkseFound = false

Actor lMe 
Actor PlayerActor 

Int WasTeam = 0 
Int myStage = 1
Float  TimeOfOneScene = 10.0

String debug_string = "ET_SustainedFeedingControlScript:  "

EVENT OnEffectStart(Actor akTarget, Actor akCaster)

	;stages of scene
	PlayerActor = Game.GetPlayer()
	Debug.Trace(debug_string+"effect started")
	Debug.Trace(debug_string+"stage is now: "+ myStage as String)
	myStage = 1
	;disable controls
	Game.ForceThirdPerson()
	Game.DisablePlayerControls(abMovement = true, abFighting = true, abCamSwitch = true , abLooking = false, abSneaking = true, abMenu = true, abActivate = true, abJournalTabs = true, aiDisablePOVType = 0)  
	Debug.Trace(debug_string+"controls disbled")
	;spell caster
	lMe = akCaster
	Debug.Trace(debug_string+"lMe is " + lMe as String)
	
	;proper way to import sex functions, no bs SexDate (???)
	;Quest __temp = aaSex as Quest
	;aaSexScript SexFunctions = __temp as aaSexScript
	
	;might be a timesaver
	;yet to know where to use
	ET_SustainedFeedingIsOn.SetValue(1)
	PlayerActor.StopCombatAlarm()
	
	;might be a timesaver
	;apparently should not do teammates
	Debug.Trace(debug_string+"checking if victim is teammate")
	if lMe.IsPlayerTeammate() == 1
		
		WasTeam = 1
		lMe.SetPlayerTeammate(0)
		Debug.Trace(debug_string+"victim was teammate")
	endif
	
	;might be a timesaver
	;cant do alerted
	lMe.SetAlert(0)
	Debug.Trace(debug_string+"lMe is not alerted")
	
	;might be a timesaver
	;investigate that
	;If aaSexScene01.IsRunning() == 0
	;	aaSexScene01Scene01.Stop()
	;	aaSexScene01.ReSet()
	;	aaSexScene01.Start()
	;	aaSexScene01.SetStage(0)
	;Endif
	
	;setting a second actor for scene quest
	;but actors are set here lMe and Game.GetPlayer()
	;investigate why
	;aaSexScene01 as QF_aaSexScene01_01005EA5).Alias_PlayerTarget.ForceRefTo (akCaster)
	
	;investigate
	;aaSexSexScriptEnding.SetValue(0)
	
	;why need that?
	TurnBumpingOff()
	Debug.Trace(debug_string+"turned bumping off")
	
	;probably need to restrain caster
	lMe.SetDontMove(True)
	Debug.Trace(debug_string+"victim is SetDontMove()")
	
	registerForUpdate(1)
	Debug.Trace(debug_string+"registred for update")

endEVENT

Event OnUpdate()
	
	
	;quest stages controls scene progression
	;aaSexScene01 seems to be a mere stage number holder
	;maybe some varibles too
	
	;initial scene
	Debug.Trace(debug_string+"update catch happened")
	Debug.Trace(debug_string+"stage is now: "+ myStage as String)
	If myStage == 1
		
		;why?
		UnregisterForUpdate()
		Debug.Trace(debug_string+"unregistred from update")
		
		;head tracking
		
		lMe.SetHeadTracking(False)
		PlayerActor.SetHeadTracking(False)
		Debug.Trace(debug_string+"turned off head tracking")
		
		;no twithes
		;PlayerActor.AddSpell(aaSexTwitchSpell  ,false)
		;lMe.AddSpell(aaSexTwitchSpell  ,false)
		
		;try without this one
		;lMe.AddSpell(aaSexKeepActorstogetherSpell ,false)
		
		;dont need dont care
		;lMe.AddSpell(aaSexEffectTimerAB,false)
		
		;face expressions
		;probably dont need those 
		;If SKSE.GetVersionMinor() != 0
		;	SkseFound.SetValue(1)
		;Else
		;	SkseFound.SetValue(0)
		;endif
		;If SkseFound.GetValue() == 1
		;	lMe.SetExpressionOverride(10,100)
		;	PlayerActor.SetExpressionOverride(10,100)
		;	If aaSexCompTway.GetValue() == 1
		;		TherdParty.GetActorRef().SetExpressionOverride(10,100)
		;	Endif
		;Endif
		
		;Scaling actors
		;how does that work???????
		;ScaleActorToHeight(lMe)
		;ScaleActorToHeight(PlayerActor)
		;Debug.Trace(debug_string+"adjusted actor scales")
		
		;head tracking false again?
		lMe.SetHeadTracking(false)
		Debug.Trace(debug_string+"turned off victim headtracking again (why tho)")
		
		;position actors
		SetActorPos(PlayerActor,lMe)
		Debug.Trace(debug_string+"set actor positions")
		
		;play idles
		if PlayerActor.playidle(PlayerFeedIdle)
			Debug.Trace(debug_string+"player idle started successfully")
		else
			Debug.Trace(debug_string+"player idle failed to start")
		endif
		
		
		Debug.Trace(debug_string+"")
		;if actor not dead he he
		If lMe.isDead() != 1
			Debug.Trace(debug_string+"victim not dead")
			if lMe.playidle(VictimFeedIdle)
				Debug.Trace(debug_string+"victim idle started successfully")
			else
				Debug.Trace(debug_string+"victim idle failed")
			endif
			
		else 
			Debug.Trace(debug_string+"victim dead")
		endif
		
		
		;wrapping up
		myStage = 2
		Debug.Trace(debug_string+"Stage set to 2")
		;reregister for update
		RegisterForUpdate(TimeOfOneScene)
		Debug.Trace(debug_string+"Unregistred from update")
		Return

	endif
	
	;wrapping up
	
	If myStage == 2
		Debug.Trace(debug_string+"preparing to shut down")
		UnregisterForUpdate()
		
		;brake loop
		Debug.SendAnimationEvent(lMe, "IdleForceDefaultState")
		Debug.SendAnimationEvent(PlayerActor, "IdleForceDefaultState")
		;exit animations
		Debug.Trace(debug_string+"playing exit idles")
		
		
		if lMe.playidle(VictimExitIdle) ;Brake loop idles
			Debug.Trace(debug_string+"player exit idle successfull")
		else
			Debug.Trace(debug_string+"player exit idle failed")
		endif
		
		
		if PlayerActor.playidle(PlayerExitIdle) ;Brake loop idles
			Debug.Trace(debug_string+"victim exit animation successfull")
		else
			Debug.Trace(debug_string+"victim exit animation failed")
		endif
		
		;remove effect timer???
		;do not use it in this implementation
		;lMe.RemoveSpell(aaSexEffectTimerAB)
		
		;investigate
		Debug.Trace(debug_string+"finishing animation handling on actors")
		FinishAnimationHandlingOnNPC (lMe)
		FinishAnimationHandlingOnNPC (PlayerActor)	
		
		;scaling back
		;Debug.Trace(debug_string+"scaling back")
		;ScaleActorBack(lMe)
		;ScaleActorBack(PlayerActor)
		
		;reset scene quest
		;investigate
		;aaSexSexScriptEnding.SetValue(1)
		;aaSexScene01.SetStage (80)
		;aaSexScene01Scene01.Stop()
		;whats that
		;(aaSexScene01 as QF_aaSexScene01_01005EA5).Alias_PlayerTarget.Clear()
		;aaSexScene01.ReSet()
		;not sure if needed
		;aaSexSexScriptEnding.SetValue(0)
		
		;team back if unteamed
		if WasTeam  == 1
			Debug.Trace(debug_string+"teaming back")
			lMe.SetPlayerTeammate(1)
			WasTeam  = 0
		endif
		
		;needed for what exactly?
		;not use now
		;lMe.AddSpell (aaSexBlockerSpell)
		
		;expressions back
		;dont need probably
		;If SkseFound.GetValue() == 1
		;	lMe.ClearExpressionOverride()
		;	PlayerActor.ClearExpressionOverride()
		;	If aaSexCompTway.GetValue() == 1
		;		TherdParty.GetActorRef().ClearExpressionOverride()
		;	Endif
		;endif
		
		;head tracking back
		
		lMe.SetHeadTracking(true)
		Debug.Trace(debug_string+"victim head tracking back on")
		lMe.SetDontMove(False)
		Debug.Trace(debug_string+"victim unrestrained back")
		
		;might be a timesaver again
		;not sure where yet tho
		;ET_SustainedFeedingIsOn.SetValue(0)
		TurnBumpingOn()
		Debug.Trace(debug_string+"turned bumping back on")
		
		;what for?
		;myStage = 3
		
		;enable controls back
		Game.EnablePlayerControls(true, true, true,true,true, true,true, true, 0)
		Debug.Trace(debug_string+"enabled player controls")

		;IMPORTANT
		;removes spell that controls this ME and removes ME (check)
		;probably should be done in quest
		lMe.RemoveSpell(SustainedFeedingControlSpell) ;<- Last of all remove the spell. Done.
		Debug.Trace(debug_string+"spell removed")
		
		
		
	endif

endEVENT


Event OnEffectFinish(Actor akTarget, Actor akCaster) 
	
	; OK
	UnregisterForUpdate() 
	Debug.Trace(debug_string+"unregistred from updates last time")
	Debug.Trace(debug_string+"shutting down...")
	; KO

ENDEVENT

Bool Function FindSKSE()
	If SKSE.GetVersionMinor() != 0
		SkseFound = true
	Else
		SkseFound = false
	endif
EndFunction

Bool Function SetActorPos (Actor Main, Actor Seckond, Float DistanceOffset = 40.0 , Float AngleOffset = 0.0,Bool Reversed = false,Bool FlipHeading = false,Bool DontTouchSeckond = false)

	Float PlayerPosX= 0.0
	Float PlayerPosY= 0.0
	Float PlayerPosZ= 0.0

	Float PlayerAngX= 0.0
	Float PlayerAngY= 0.0
	Float PlayerAngZ= 0.0

	Float TherePosX= 0.0
	Float TherePosY= 0.0
	Float TherePosZ= 0.0

	Float ThereAngX= 0.0
	Float ThereAngY= 0.0
	Float ThereAngZ= 0.0

	Float ThereStartPosX= 0.0
	Float ThereStartPosY= 0.0
	Float ThereStartPosZ= 0.0
	Float ThereStartAng= 0.0

	;debug.ToggleCollisions()
	PlayerPosX = Main.GetPositionx()
	PlayerPosY = Main.GetPositiony()
	PlayerPosZ = Main.GetPositionz()
	PlayerAngX = Main.getangleX()
	PlayerAngY = Main.getangleY()
	PlayerAngZ = Main.getangleZ()

	ThereStartPosX = Seckond.GetPositionx()
	ThereStartPosY = Seckond.GetPositiony()
	ThereStartPosZ = Seckond.GetPositionZ()

	ThereAngX = Seckond.getangleX()
	ThereAngY = Seckond.getangleY()
	ThereAngZ = Seckond.getangleZ()
	
	TherePosX = Main.GetPositionx()
	TherePosY = Main.GetPositiony()
	TherePosZ = Main.GetPositionZ()

	if AngleOffset != 0.0
		TherePosX = TherePosX + ((math.sin(PlayerAngZ + AngleOffset )) *  DistanceOffset )
		TherePosY = TherePosY + ((math.cos(PlayerAngZ + AngleOffset )) * DistanceOffset )
	else
		TherePosX = TherePosX + ((math.sin(PlayerAngZ)) *  DistanceOffset )
		TherePosY = TherePosY + ((math.cos(PlayerAngZ)) * DistanceOffset )
	endif

	If FlipHeading == False
		ThereAngZ = PlayerAngZ +180 
		if ThereAngZ >= 360
			ThereAngZ  = ThereAngZ  - 360
		endif
	Else
		ThereAngZ = PlayerAngZ
	Endif

	;Set Player's and NPC's pos
	If DontTouchSeckond == False
		Main.setPosition (PlayerPosX,PlayerPosY,PlayerPosz )
		Main.setangle (PlayerAngX,PlayerAngY,PlayerAngZ )
	Endif

	Seckond.setPosition( TherePosX ,TherePosY ,TherePosZ  )
	if Reversed == False
		Seckond.setangle (ThereAngX,ThereAngY,ThereAngZ )
	else
		ThereAngY = ThereAngY +  Main.GetHeadingAngle(Seckond) 
		Seckond.setangle (ThereAngX,ThereAngY ,ThereAngZ )
	endif


EndFunction 

Bool Function ScaleActorToHeight(Actor Who)
	if ET_FeedingUseScale.GetValue() == 1
		ScaleActorToHeightOne(Who)
	elseIf ET_FeedingUseScale.GetValue() == 2
		if who != Game.GetPlayer()
			ScaleActorToPlayerHeight(Who)
		endif
	Endif
EndFunction

Bool Function ScaleActorToPlayerHeight(Actor Who)


	;mScale  = Game.GetPlayer().GetScale()
	Float mScale  = 0.0
	mScale  = Who.GetScale()
	;If mScale  != 1
	Who.SetScale (Game.GetPlayer().GetScale() / mScale)
	;endif

EndFunction

Bool Function ScaleActorToHeightOne(Actor Who)
	Float mScale  = 0.0
	mScale  = Who.GetScale()
	If mScale  != 1
		Who.SetScale (1 / mScale)
	endif
EndFunction

Bool Function ScaleActorBack(Actor Who)
	if ET_FeedingUseScale.GetValue() == 1
		Who.SetScale (1)
	endif
	if ET_FeedingUseScale.GetValue() == 2
		Who.SetScale (1)
	endif
EndFunction

;Bool Function BrakePlayerIdle(Actor Who)
;
;	Who.playidle ( IdleStopInstant ) ;Brake loop idles

;EndFunction

Bool Function FinishAnimationHandlingOnNPC(Actor Who)


		Who.SetHeadTracking(True)
		Who.SetRestrained (False)
		Who.ClearKeepOffsetFromActor()
		if Who != Game.GetPlayer()
			Who.EvaluatePackage()
		endif

EndFunction

Bool Function TurnBumpingOff()

	If SkseFound == true
		Game.SetGameSettingFloat("fBumpReactionSmallDelayTime" , 9999999.0)
		Game.SetGameSettingFloat("fBumpReactionSmallWaitTimer", 0.0)
	endif

EndFunction

Bool Function TurnBumpingOn()

	If SkseFound == true
		Game.SetGameSettingFloat("fBumpReactionSmallDelayTime" , 1.0)
		Game.SetGameSettingFloat("fBumpReactionSmallWaitTimer", 3.0)
	endif

EndFunction


ScriptName PlayerVampireQuestScript extends Quest Conditional
;Importing functions from other scripts
Import Game
Import Debug
Import Utility

;Variable to track if the player is a vampire
;0 = Not a Vampire
;1 = Vampire
;2 = Vampire Stage 2
;3 = Vampire Stage 3
;4 = Vampire Stage 4
Int Property VampireStatus Auto Conditional

Message Property VampireFeedMessage Auto
Message Property VampireStageProgressionMessage Auto

Race Property CureRace Auto
Static Property XMarker Auto

Faction Property VampirePCFaction  Auto  

Float Property LastFeedTime Auto
Float Property FeedTimer Auto
GlobalVariable Property GameDaysPassed Auto
GlobalVariable Property GameHour  Auto

Idle Property VampireFeedingBedRight Auto
Idle Property VampireFeedingBedrollRight Auto
GlobalVariable Property VampireFeedReady Auto
imageSpaceModifier Property VampireTransformIncreaseISMD  Auto
imageSpaceModifier Property VampireTransformDecreaseISMD  Auto 
effectShader property VampireChangeFX auto

float Property TimeOld Auto
float Property TimeNew Auto
float Property TimePassed Auto

float Function RealTimeSecondsToGameTimeDays(float realtime)
	float scaledSeconds = realtime * TimeScale.Value
	return scaledSeconds / (60 * 60 * 24)
EndFunction

float Function GameTimeDaysToRealTimeSeconds(float gametime)
	float gameSeconds = gametime * (60 * 60 * 24)
	return (gameSeconds / TimeScale.Value)
EndFunction

Function ET_debug_trace(string msg)
	Debug.Trace("DEBUG: Everdamned: " + msg)
EndFunction

Function ET_debug_trace_toggleable(string msg, bool IsOn)
	if IsOn
		Debug.Trace("DEBUG: Everdamned: " + msg)
	endif
EndFunction
;;;;;;;;;;;;;;;;
;blood detriment management
;
;;;;;;;;;;;;;;;;

Event OnUpdateGameTime()

	; update loop that triggers once every 3 hours and calls Devolve() if necessary
	
	;log call
	ET_debug_trace("OnUpdateGameTime called")
	ET_debug_trace("FeedTimer is : "+ FeedTimer + ", VampireStatus is " + VampireStatus)
	ET_debug_trace("LastFeedTime is : "+ LastFeedTime + ", GameDaysPassed is :" + GameDaysPassed.Value)
	
	Actor Player = Game.GetPlayer()

	; set time of next stage
	FeedTimer = (GameDaysPassed.Value - LastFeedTime) * (24.01 / ET_Mechanics_Global_DelayBetweenStages.GetValue())

	; no progression occurs if:
	; - player is in combat
	; - controls are locked
	; - the player can't fast travel
	; - the player is a vampire lord
	; if any of these fail, will try again in a bit
	
	

	If Game.IsMovementControlsEnabled() && Game.IsFightingControlsEnabled() && Player.GetCombatState() == 0 && !Player.HasMagicEffect(DLC1VampireChangeEffect) && !Player.HasMagicEffect(DLC1VampireChangeFXEffect)
		
			ET_debug_trace("Calling devolve")
			Devolve(false)
	EndIf
	
EndEvent


Event OnUpdate()
	
	ET_debug_trace_toggleable("OnUpdate got called!", ET_DeepLoogingToggle)
	
;Checking if player is a vampire
	
	
	If PlayerIsVampire.Value > 0

;Timescale adjuster so that the math is right no matter what scale player has set

	float TSAdjust = TimeScale.GetValue()/60

;Active and Natural detorioration levels (I don't care how it's spelled!)
;Natural detorioration is equal to 1 blood point every game time minute (default)
;Active detorioration is modified by toggleable powers and equals 0 if none are active

	;float DetActVar = (DetAct.GetValue()*TSAdjust)*DetActMult.GetValue()
	;float DetNatVar = (DetNat.GetValue()*TSAdjust)*DetNatMult.GetValue()
	float BloodPoolDeltaVar = (BloodPoolDelta.GetValue()*TSAdjust)*BloodPoolDeltaMult.GetValue()

;Maximum and Current blood levels

	float BloodPoolCurrentVar = BloodPoolCurrent.GetValue()
	float BloodPoolMaxVar = BloodPoolMax.GetValue() + BloodPoolMaxOnTop.GetValue()

;ET;
;TBD;
;change message to reflect new meaning of blood pool

;Informng player if the blood pool is full

	if BloodPoolCurrentVar >= BloodPoolMaxVar
		;Notification("I feel full, my hunger is quiet.")
		ET_debug_trace("BloodPool overflowed")
		ET_HunFullMSG.Show()
		BloodPoolCurrentVar = BloodPoolMaxVar
		
	endif

;Checking for passage of time (including large time jumps like sleep, fast travel and so on)
	
	TimeNew = GameDaysPassed.GetValue()
	TimePassed = TimeNew - TimeOld
	float DeltaMult = GameTimeDaysToRealTimeSeconds(TimePassed)
	If TimeOld != 0
		BloodPoolCurrentVar = BloodPoolCurrentVar + BloodPoolDeltaVar*DeltaMult
	Endif
	
	ET_debug_trace_toggleable("This much game time has passed: " + TimePassed + " Old: " + TimeOld + " New: " + TimeNew, ET_DeepLoogingToggle)
	ET_debug_trace_toggleable("This much real time has passed: " + DeltaMult + " seconds", ET_DeepLoogingToggle)
;	MessageBox("This much game time has passed: " + TimePassed + " Old: " + TimeOld + " New: " + TimeNew)
;	MessageBox("This much real time has passed: " + DetMult + " seconds")

	TimeOld = GameDaysPassed.GetValue()

;Updating globals

	BloodPoolCurrent.SetValue(BloodPoolCurrentVar)

;Imposing bottom and top limits

	If (BloodPoolCurrentVar > BloodPoolMaxVar)
		BloodPoolCurrent.SetValue(BloodPoolMaxVar)
	Elseif (BloodPoolCurrentVar < 0)
		BloodPoolCurrent.SetValue(0)
	Endif

;Manage hunger state abilities

;ET;
;moved to VampireProgression

;Manage ageing and experience

;ET;
;TBD;
;compare SCS and mslvt ageing and implement

	mslVTFeedDialogueSpeech.SetValue(akPlayer.GetBaseActorValue("Speechcraft"))
	;ET_FeedDialogueSpeech.SetValue(akPlayer.GetBaseActorValue("Speechcraft"))
	

	Endif

	RegisterForSingleUpdate(1)
	
EndEvent

;Alias control

Function SetPlayerAlias(bool Fill)
	ET_debug_trace("SetPlayerAlias got called!")
	ET_debug_trace("Fill is:" + Fill)
	If Fill == TRUE
		PlayerVampireAlias.ForceRefTo(akPlayer)
		SendModEvent("VTAliasFilled")
		ET_debug_trace("Filled!")
	Else
		PlayerVampireAlias.Clear()
		SendModEvent("VTAliasCleared")
		ET_debug_trace("Cleared!")
	Endif
Endfunction

;Update procedure

Function StartVTUpdate()
	ET_debug_trace("StartVTUpdate got called")

;	Notification("Vampiric Thirst has finished updating!")

EndFunction

;Authentication check

bool Function AuthenticateScript()
	return True
EndFunction

;Toggle appearance function
;danila ti kreizi!
;vampire abilities for player live in playervampirequest alias
;when player gets setrace(vampirerace) vampire abilities are forcefully removed and player alias is set (?)

Function ToggleAppearance(int Mode, actor Target)

	ET_debug_trace("ToggleAppearance got called")
	ET_debug_trace("Mode is:" + Mode)
	
	If PlayerIsVampire.Value != 0
		SetPlayerAlias(FALSE)
		if Mode == 0	;vamp me up!
			if Races.HasForm(Target.GetActorBase().GetRace())
				int Index = 0
				bool RaceChanged = FALSE
				while (RaceChanged == FALSE)
					if (Target.GetActorBase().GetRace() == (Races.GetAt(Index) as Race))
						ET_debug_trace("Player's mortal race is " + (Races.GetAt(Index) as Race))
						Target.SetRace(RacesVampires.GetAt(Index) as Race)
;						wait(2.0)
						ET_debug_trace("Player's vampire race is " + (RacesVampires.GetAt(Index) as Race))
						RaceChanged = TRUE
					else
						Index += 1
					endif 
				endwhile
			endif
		else				;normal me up!
			if RacesVampires.HasForm(Target.GetActorBase().GetRace())
				int Index = 0
				bool RaceChanged = FALSE
				while (RaceChanged == FALSE)
					if (Target.GetActorBase().GetRace() == (RacesVampires.GetAt(Index) as Race))
						ET_debug_trace("Player's vampire race is " + (RacesVampires.GetAt(Index) as Race))
						Target.SetRace(Races.GetAt(Index) as Race)
;						wait(2.0)
						ET_debug_trace("Player's mortal race is " + (Races.GetAt(Index) as Race))
						RaceChanged = TRUE
					else
						Index += 1
					endif
				endwhile
			endif
		endif
	akPlayer.RemoveSpell(VampireVampirism)
	akPlayer.RemoveSpell(VampirePoisonResist)
	akPlayer.RemoveSpell(VampireHuntersSight)
	SetPlayerAlias(TRUE)
	Endif
EndFunction


Bool Function Devolve(Bool abForceDevolve = true)

	; progresses hunger based on your current hunger stage
	; this is a public method  and can safely be called from elsewhere
	;Debug.MessageBox("DEVOLVE = " + abForceDevolve + " FeedTimer = " + FeedTimer + " VampireStatus = " + VampireStatus)

	Actor Player = Game.GetPlayer()
	
	ET_debug_trace("Devolve got called")
	ET_debug_trace("abForceDevolve is: " + abForceDevolve)	
	ET_debug_trace("FeedTimer is : "+ FeedTimer + ", VampireStatus is " + VampireStatus)
	ET_debug_trace("LastFeedTime is : "+ LastFeedTime)



	If (FeedTimer >= 3 || abForceDevolve == true) && (VampireStatus == 3)
		; stage 3 to 4
		
		VampireFeedReady.SetValue(3)
		VampireStatus = 4
		Debug.MessageBox("Devolving at vampire status 4")
		VampireProgression(Player, 4)
		; stop checking GameTime until the player feeds again
		UnregisterforUpdateGameTime()

	ElseIf (FeedTimer >= 2 || abForceDevolve == true) && (VampireStatus == 2)
		; stage 2 to 3

		If abForceDevolve
			LastFeedTime -= 1
		EndIf

		VampireFeedReady.SetValue(2)
		VampireStatus = 3
		Debug.MessageBox("Devolving at vampire status 3")
		VampireProgression(Player, 3)

	ElseIf (FeedTimer >= 1 || abForceDevolve == true) && (VampireStatus == 1)
		; stage 1 to 2

		If abForceDevolve
			LastFeedTime -= 1
		EndIf

		VampireFeedReady.SetValue(1)
		VampireStatus = 2
		Debug.MessageBox("Devolving at vampire status 2")
		VampireProgression(Player, 2)

	EndIf

EndFunction

;Modified VampireProgression function

;ET;
;scs progression
Function VampireProgression(Actor Player, int VampireStage)

	; this function processes all the spell switching when your hunger stage changes
	; VampireStage is legacy, please pass the value of VampireStatus at all times
	
	ET_debug_trace("VampireProgression got called")
	ET_debug_trace("VampireStage is: " + VampireStage)

	If VampireStage == 2
		; progress from stage 1 to stage 2

		VampireTransformIncreaseISMD.applyCrossFade(2.0)
		Utility.Wait(2.0)
		imageSpaceModifier.removeCrossFade()

		akPlayer.RemoveSpell(HungerState1)
		akPlayer.RemoveSpell(HungerState3)
		akPlayer.RemoveSpell(HungerState4)

	ElseIf VampireStage == 3
		; progress from stage 2 to stage 3

		VampireTransformIncreaseISMD.applyCrossFade(2.0)
		utility.wait(2.0)
		imageSpaceModifier.removeCrossFade()

		akPlayer.RemoveSpell(HungerState1)
		akPlayer.AddSpell(HungerState3, false)
		akPlayer.RemoveSpell(HungerState4)		

	ElseIf VampireStage == 4
		; progress from stage 3 to stage 4
		
		VampireTransformIncreaseISMD.applyCrossFade(2.0)
		utility.wait(2.0)
		imageSpaceModifier.removeCrossFade()
		
		akPlayer.RemoveSpell(HungerState1)
		akPlayer.RemoveSpell(HungerState3)
		akPlayer.AddSpell(HungerState4, false)

	ElseIf VampireStage == 1
		; feed down to stage 1
		
		VampireTransformIncreaseISMD.applyCrossFade(2.0)
		utility.wait(2.0)
		imageSpaceModifier.removeCrossFade()

		akPlayer.AddSpell(HungerState1, false)
		akPlayer.RemoveSpell(HungerState3)
		akPlayer.RemoveSpell(HungerState4)
	
	EndIf

EndFunction

Function VampireFeedBed()
	
	ET_debug_trace("VampireFeedBed got called")

	akPlayer.PlayIdle(VampireFeedingBedRight)

EndFunction

Function VampireFeedBedRoll()

	ET_debug_trace("VampireFeedBedRoll got called")

	akPlayer.PlayIdle(VampireFeedingBedrollRight)

EndFunction

Function VampireChange(Actor Target)

	;ET;
	;likely finished

	;Start dramatic scene of death, prepare some tissues
	;Notification("Something is wrong... I feel strange...")
	ET_ChangeMSG.Show()
	
	DeathCloseSound.Play(Target)
	wait(1.0)
	
	FadeToBlackISMD.apply()
	wait(1.0)
	DisablePlayerControls()
		If (ET_SetDeathSceneAnim.Value == 1) && !Target.IsInLocation(CastleVolkiharLoc)
	Target.PlayIdle(Faint)
		Endif
	DeathSoundToMute.Mute()
	wait(0.5)
		If (ET_SetDeathSceneAnim.Value == 1) && !Target.IsInLocation(CastleVolkiharLoc)
	Target.PushActorAway(Target, 1)
		Endif
	wait(2.0)
	ObjectReference myXmarker = Target.PlaceAtMe(Xmarker)
	DeathSoundTransform.Play(myXmarker)
	myXmarker.Disable()

	;Stay dead for some time and make sure it's night when player wakes up
	;Play japanese commercial during blackout to distract player from noticing our cheap tricks

	If (GameHour.GetValue() < 20) && (GameHour.GetValue() > 4)
		GameHour.SetValue(20)
	Endif

	wait(3.0)

	;Change player's race, check FormList "mslVTRacesFL" for viable races, vampire race MUST have the same index as its mortal version on the "mslVTRacesVampiresFL" list!

	SetPlayerAlias(FALSE)
	
;ET addition
	
	Race PlayerRace = Target.GetActorBase().GetRace()
	CureRace = PlayerRace
	
	Int RaceID = Races.Find(PlayerRace)
	If RaceID >= 0
		Target.SetRace(RacesVampires.GetAt(RaceID) as Race)
	Else
		;SCS_Mechanics_Message_RaceBroken.Show()
		MessageBox("DEBUG: Everdamned: Race " + PlayerRace + " not in race list, changing to Nord Vampire")
		ET_debug_trace("Race " + PlayerRace + " not in race list, changing to Nord Vampire")
		Target.SetRace(NordRaceVampire)
	EndIf


	SetPlayerAlias(TRUE)

	;Clear player's diseases
	Target.AddSpell(VampireCureDisease, false)
	VampireCureDisease.Cast(Target)
	Target.RemoveSpell(VampireCureDisease)

	VampireStatus = 1
	VampireProgression(Target, 1)
	
	; setup the feed timer
	RegisterForUpdateGameTime(3)
	LastFeedTime = GameDaysPassed.Value

	; set the Global for stat tracking
	PlayerIsVampire.SetValue(1)
	
	If BloodPoolMax.GetValue() <= 0
		BloodPoolMax.SetValue(1000)
	Endif

	;Give player some starting blood (converted from health)
	BloodPoolCurrent.SetValue(akPlayer.GetActorValue("health"))
	
	wait(1.0)
	If (ET_SetDeathSceneAnim.Value == 1) && !Target.IsInLocation(CastleVolkiharLoc)
		Target.PushActorAway(Target, 1)
	Endif
	wait(1.0)
	EnablePlayerControls()
	FadeToBlackISMD.popto(FadeFromBlackISMD) 

	wait(10.0)
	DeathSoundToMute.UnMute()
	wait(5.0)

	DateOfChange.SetValue(GameDaysPassed.GetValue())

	UnRegisterForUpdate()
	RegisterForSingleUpdate(1)

	;If the player has been cured before, restart the cure quest
	If VC01.GetStageDone(200) == 1
		VC01.SetStage(25)
	EndIf

;mslvt vampire sight ability
	Target.AddSpell(VampiresSightSP, false)

	SendModEvent("VTVampireChange")
	
EndFunction


Function Harvest(Actor akTarget, Int FeedType = 0)
	
	ET_debug_trace("Harvest got called!")
	ET_debug_trace("FeedType: " + FeedType)
	
	Actor Player = Game.GetPlayer()
	bool targetIsVampire = akTarget.HasKeyword(Vampire)
	bool targetIsVampireBoss = NPCVampireBosses.HasForm(akTarget.GetActorBase())
	if targetIsVampireBoss
		ET_debug_trace("Target is vampire boss")
	endif
	if targetIsVampire
		ET_debug_trace("Target is vampire")
	endif
	
	if FeedType == 0 || FeedType == 5
		FeedHealthAmount = akTarget.GetBaseAV("Health")*0.10
	elseif FeedType == 1
		FeedHealthAmount = akTarget.GetBaseAV("Health")*0.25
	elseif FeedType == 2
		FeedHealthAmount = akTarget.GetBaseAV("Health")*0.50
	elseif FeedType == 3
		FeedHealthAmount = (BloodPoolMax.GetValue() + BloodPoolMaxOnTop.GetValue() - BloodPoolCurrent.GetValue())/(BloodRatio.GetValue())
	elseif FeedType == 4 || targetIsVampireBoss || targetIsVampire
		FeedHealthAmount = akTarget.GetAV("Health")
	endif
	
	ET_debug_trace("FeedHealthAmount: "+ FeedHealthAmount + "target health: " + akTarget.GetAV("Health") + ", target base health: " + akTarget.GetBaseAV("Health"))
	
	if FeedHealthAmount >= akTarget.GetAV("Health")
		if FeedType == 5
			Notification("There is hardly enough blood left to fill a spoon let alone a bottle!")
			mslVTFeedBottleFailMSG.Show()
			return
		elseif ET_SetKillEssential.GetValue() == 0 && akTarget.IsEssential()
			MessageBox("DEBUG: Everdamned: This one cannot be drained dry.")
			ET_FeedEssentialFailMSG.Show()
			return
		endif
	endif
	
	if FeedType < 5
		if FeedHealthAmount > akTarget.GetAV("Health")
			FeedHealthAmount = akTarget.GetAV("Health")
		endif
		
		BloodPoolCurrent.Mod(FeedHealthAmount * BloodRatio.GetValue())
		akTarget.DamageAV("Health", FeedHealthAmount)
		Player.RestoreAV("Health", FeedHealthAmount)
		
		akTarget.ModAV("Variable08", FeedHealthAmount / akTarget.GetBaseAV("Health"))
		akTarget.AddToFaction(ET_FeedRecoveryFAC)
			
		;restore if keeping blood quality system
		;akTarget.ModAV("Infamy", (FeedHealthAmount)/(akTarget.GetBaseAV("Health"))*PercentMult.Value)

		if ET_FeedDelay.value > 0
			wait(ET_FeedDelay.value) 
		endif
		
	;ET;
	;TBD;
	;mslvt diablerie remained unchanged, fix later when ageing gets figured out
		if targetIsVampireBoss
		
			mslVTAgeDiablerieMod.Mod(akTarget.GetLevel()*0.2)
			Debug.Notification("This vampire's blood feels powerful and as the last drop of it trickles down my throat... so do I!")
			mslVTFeedDiablerieMSG.Show()
			;akTarget.DamageAV("Health", akTarget.GetAV("Health"))
			akTarget.KillEssential(akPlayer)
			
		elseif targetIsVampire
		
			mslVTAgeDiablerieMod.Mod(akTarget.GetLevel()*0.1)
			Debug.Notification("This vampire's blood feels powerful and as the last drop of it trickles down my throat... so do I!")
			mslVTFeedDiablerieMSG.Show()
			;akTarget.DamageAV("Health", akTarget.GetAV("Health"))
			akTarget.KillEssential(akPlayer)
			
		endif

	Elseif FeedType == 5

		akTarget.DamageAV("Health", FeedHealthAmount)
		akTarget.ModAV("Variable08", FeedHealthAmount/akTarget.GetBaseAV("Health"))
		;akTarget.ModAV("Infamy", (BottleBloodAmount)/(akTarget.GetBaseAV("Health"))*PercentMult.Value)
		akTarget.AddToFaction(ET_FeedRecoveryFAC)
		
		bool EmptyRemoved = FALSE
		int Index = 0
		int EmpyBottleTypesCount = EmptyBottles.GetSize()
		
		while Index < EmpyBottleTypesCount && !EmptyRemoved
			if akPlayer.GetItemCount(EmptyBottles.GetAt(Index) as Form)
				akPlayer.RemoveItem(EmptyBottles.GetAt(Index) as Form, 1)
				akPlayer.AddItem(BottledBloodPOT)
				EmptyRemoved = TRUE
				Index += 1
			else
				Index += 1
			endif
		endwhile
		if Index >= EmpyBottleTypesCount && !EmptyRemoved
			ET_debug_trace("Somethings wrong with bottleing, likely accessed bottling options with no bottles in invo")
		endif
	Endif

EndFunction

Function VampireFeed(Actor akTarget, Int FeedType = 0, Int PassOut = 0)

	ET_debug_trace("VampireFeed got called")
	
	if FeedType < 0 
		MessageBox("NO feeding on corpses!!1")
		return
	endif

	FeedISMD.apply()

	If akTarget.GetAV("Variable08") <= 0
		Game.IncrementStat( "Necks Bitten" )
	Endif

	if akPlayer.GetRace() != DLC1VampireBeastRace
		akPlayer.SetRestrained(true)
	endif
	if !akTarget.IsDead()
		akTarget.SetRestrained(true)
	endif

	Harvest(akTarget, FeedType)
	
	VampireFeedReady.SetValue(0)

	; revert to stage 1
	LastFeedTime =  GameDaysPassed.Value
	VampireStatus = 1
	VampireProgression(Game.GetPlayer(), 1)
	
	
	akPlayer.SetRestrained(false)
	if !akTarget.IsDead()
		akTarget.SetRestrained(false)
	endif

	If PassOut == 1
		ET_FeedFaint.Cast(akPlayer, akTarget)
	Endif
	
	; start checking GameTime again if we weren't already
	
	UnregisterforUpdateGameTime()
	RegisterForUpdateGameTime(3)

EndFunction


Function VampireCure(Actor Player)
	
	;ET;
	;mostly done, has TBDs

	PlayerIsVampire.SetValue(0)
	
	IncrementStat( "Vampirism Cures" )
	;Stop tracking the Feed Timer
	UnregisterforUpdate()

	VampireStatus = 0
	;Player is no longer hated
	Player.RemoveFromFaction(VampirePCFaction)
	Player.SetAttackActorOnSight(False)
	
	;Change player's race to whatever she or he was as a mortal
	If !CureRace
		Player.SetRace(NordRace)
	Else
		Player.SetRace(CureRace)
	EndIf

	;TBD
	
	;Reset the experience system and remove powers
	
	mslVTExp.SetValue(0)
	mslVTExpLevel.SetValue(1)
	mslVTExpPoints.SetValue(0)
	mslVTAge.SetValue(0)
	
	;ET;
	;as of yet undecided if the same system would be implemented
	
	;ET_Exp.SetValue(0)
	;ET_ExpLevel.SetValue(1)
	;ET_ExpPoints.SetValue(0)
	
	ET_Age.SetValue(0)

	int Index = 0
	while (Index < CurePowers.GetSize())
		Player.RemoveSpell(CurePowers.GetAt(Index) as Spell)
		Player.DispelSpell(CurePowers.GetAt(Index) as Spell)
		Index += 1
	endwhile

	SetPlayerAlias(FALSE)

	;Set the Global for stat tracking
	PlayerIsVampire.SetValue(0)

	RedVisionImod.Remove()

	SendModEvent("VTVampireCure")
	
EndFunction

;Properties

Spell Property VampireCureDisease Auto

GlobalVariable Property PlayerIsVampire  Auto  

Sound  Property MagVampireTransform01  Auto  
Message Property VampireStage4Message Auto

Quest Property VC01 Auto
FormList Property CrimeFactions  Auto 

; ET_properties

GlobalVariable Property BloodPoolCurrent  Auto  
GlobalVariable Property BloodPoolMax  Auto  
GlobalVariable Property BloodPoolMaxOnTop  Auto 
GlobalVariable Property BloodPoolDelta  Auto
GlobalVariable Property BloodPoolDeltaMult  Auto 

GlobalVariable Property ET_Mechanics_Global_DelayBetweenStages Auto 

GlobalVariable Property ET_SetDeathSceneAnim  Auto

GlobalVariable Property ET_SetAppearance  Auto

GlobalVariable Property ET_Exp  Auto
GlobalVariable Property ET_ExpLevel  Auto
GlobalVariable Property ET_ExpPoints  Auto
GlobalVariable Property ET_Age  Auto

GlobalVariable Property ET_FeedDialogueSpeech Auto

GlobalVariable Property ET_FeedDelay Auto
GlobalVariable Property ET_SetKillEssential Auto

GlobalVariable Property ET_DeepLoogingToggle Auto

MagicEffect Property DLC1VampireChangeEffect Auto
MagicEffect Property DLC1VampireChangeFXEffect Auto

Message Property ET_HunFullMSG Auto
Message Property ET_ChangeMSG Auto
Message Property ET_FeedEssentialFailMSG Auto

Faction Property ET_FeedRecoveryFAC Auto

Spell Property ET_FeedFaint Auto

Race Property NordRaceVampire Auto
Race Property NordRace Auto

FormList Property FeedAmountLookup Auto  

float Property FeedHealthAmount Auto

; VAMPIRIC THIRST properties
  

GlobalVariable Property BloodRatio Auto

SPELL Property HungerState1  Auto  
SPELL Property HungerState3  Auto  
SPELL Property HungerState4  Auto  

ImageSpaceModifier Property RedVisionImod  Auto  

GlobalVariable Property TimeScale  Auto  

Float Property Mark  Auto
  

FormList Property EmptyBottles Auto
Potion Property BottledBloodPOT Auto
ImageSpaceModifier Property FeedISMD  Auto

Keyword Property Vampire Auto
GlobalVariable Property mslVTAgeDiablerieMod Auto
FormList Property NPCVampireBosses Auto

GlobalVariable Property PercentMult Auto

FormList Property Races  Auto 
FormList Property RacesVampires  Auto
ImageSpaceModifier Property FadeToBlackISMD  Auto  
ImageSpaceModifier Property FadeFromBlackISMD  Auto  
Idle Property Faint  Auto  
Sound Property DeathLoopSound  Auto  
Sound Property DeathCloseSound  Auto  
SoundCategory Property DeathSoundToMute  Auto  
Sound Property DeathSoundTransform  Auto  

GlobalVariable Property DateOfChange Auto
FormList Property AgeStages  Auto 
FormList Property AgeReq  Auto 
GlobalVariable Property mslVTAge Auto
GlobalVariable Property mslVTExp Auto
GlobalVariable Property mslVTExpMult Auto
GlobalVariable Property mslVTExpLevel Auto
GlobalVariable Property mslVTExpPoints Auto
Sound Property mslVTAdvanceSM Auto
Spell Property mslVTPSMenu Auto
Spell Property mslVTFeedAction Auto
Spell Property mslVTHotkeyControl Auto
Spell Property VampiresSightSP Auto

Spell Property VampirePoisonResist Auto
Spell Property VampireVampirism Auto

FormList Property CurePowers Auto

GlobalVariable Property mslVTSetKillEssential Auto
GlobalVariable Property mslVTSetAgeingMult Auto
GlobalVariable Property mslVTSetNPCPowers Auto

Location Property CastleVolkiharLoc Auto

GlobalVariable Property mslVTFeedDialogueSpeech Auto

ReferenceAlias Property PlayerVampireAlias  Auto  

SPELL Property VampireHuntersSight  Auto  

Race Property DLC1VampireBeastRace Auto

;MESSAGES

Message Property mslVTAdvanceMSG Auto
Message Property mslVTChangeMSG Auto
Message Property mslVTFeedEssentialFailMSG Auto
Message Property mslVTFeedBottleFailMSG Auto
Message Property mslVTFeedDiablerieMSG Auto

Actor Property akPlayer  Auto  

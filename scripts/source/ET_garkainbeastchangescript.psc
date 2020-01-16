Scriptname ET_garkainbeastchangescript extends Quest   

float Property StandardDurationSeconds auto
{How long (in real seconds) the transformation lasts}

float Property DurationWarningTimeSeconds auto
{How long (in real seconds) before turning back we should warn the player}

float Property FeedExtensionTimeSeconds auto
{How long (in real seconds) that feeding extends werewolf time}

VisualEffect property FeedBloodVFX auto
{Visual Effect on Wolf for Feeding Blood}

Perk Property PlayerWerewolfFeed auto

Message Property PlayerWerewolfExpirationWarning auto
Message Property PlayerWerewolfFeedMessage auto
GlobalVariable Property GameDaysPassed auto
GlobalVariable Property TimeScale auto
GlobalVariable Property ET_PlayerVampireGarkainBeastShiftBackTime auto

ImageSpaceModifier Property WerewolfWarn auto

Idle Property SpecialFeeding auto

Spell Property ET_PlayerVampireGarkainBeast10AndBelowAbility auto
Spell Property ET_PlayerVampireGarkainBeast15AndBelowAbility auto
Spell Property ET_PlayerVampireGarkainBeast20AndBelowAbility auto
Spell Property ET_PlayerVampireGarkainBeast25AndBelowAbility auto
Spell Property ET_PlayerVampireGarkainBeast30AndBelowAbility auto
Spell Property ET_PlayerVampireGarkainBeast35AndBelowAbility auto
Spell Property ET_PlayerVampireGarkainBeast40AndBelowAbility auto
Spell Property ET_PlayerVampireGarkainBeast45AndBelowAbility auto
Spell Property ET_PlayerVampireGarkainBeast50AndOverAbility auto

Spell Property FeedBoost auto
Spell property BleedingFXSpell auto
{This Spell is for making the target of feeding bleed.}

bool Property Untimed auto

FormList Property CrimeFactions auto
;;changed for vampirecrimefactions

;garkain vars

ImageSpaceModifier Property VampireWarn auto 
ImageSpaceModifier Property VampireChange auto 
Sound Property VampireIMODSound auto

Race Property VampireGarkainBeastRace auto
Quest Property VampireTrackingQuest auto

Faction Property PlayerVampireFaction auto
Faction Property HunterFaction  Auto  

EffectShader Property DLC1VampireChangeBackFXS Auto
EffectShader Property DLC1VampireChangeBack02FXS Auto

float __durationWarningTime = -1.0
float __feedExtensionTime = -1.0
bool __tryingToShiftBack = false
bool __shiftingBack = false
bool __shuttingDown = false
bool __trackingStarted = false

float Function RealTimeSecondsToGameTimeDays(float realtime)
    float scaledSeconds = realtime * TimeScale.Value
    return scaledSeconds / (60 * 60 * 24)
EndFunction

float Function GameTimeDaysToRealTimeSeconds(float gametime)
    float gameSeconds = gametime * (60 * 60 * 24)
    return (gameSeconds / TimeScale.Value)
EndFunction

Function PrepShift()
;     Debug.Trace("WEREWOLF: Prepping shift...")
    Actor player = Game.GetPlayer()

    ; sets up the UI restrictions
    Game.SetBeastForm(True)
    Game.EnableFastTravel(False)

    ; set up perks/abilities
    ;  (don't need to do this anymore since it's on from gamestart)
    ; Game.GetPlayer().AddPerk(PlayerWerewolfFeed)

	;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; screen effect
    ;WerewolfChange.Apply()
    ;WerewolfIMODSound.Play(Game.GetPlayer())
	
	;SHOULD BE --me
	actor PlayerActor = Game.GetPlayer()
	VampireChange.Apply()
	VampireIMODSound.Play(PlayerActor)
	;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ; get rid of your summons
    ;int count = 0
    ;while (count < WerewolfDispelList.GetSize())
    ;    Spell gone = WerewolfDispelList.GetAt(count) as Spell
    ;    if (gone != None)
    ;        Game.GetPlayer().DispelSpell(gone)
     ;   endif
    ;    count += 1
   ; endwhile
	;should we retain that? prlly not

    Game.DisablePlayerControls(abMovement = false, abFighting = false, abCamSwitch = true, abMenu = false, abActivate = false, abJournalTabs = false, aiDisablePOVType = 1)
    Game.ForceThirdPerson()
    Game.ShowFirstPersonGeometry(false)
EndFunction

Function InitialShift()
;     Debug.Trace("WEREWOLF: Player beginning transformation.")

    ;WerewolfWarn.Apply()
	;change for vampire warn?
	VampireWarn.Apply()


    if (Game.GetPlayer().IsDead())
;         Debug.Trace("WEREWOLF: Player is dead; bailing out.")
        return
    endif

	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;

	;Actor player = Game.GetPlayer()
;	actual switch
	;player.SetRace(VampireGarkainBeastRace)


	;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
    Game.GetPlayer().SetRace(VampireGarkainBeastRace)
	
	
EndFunction

Function StartTracking()
    if (__trackingStarted)
        return
    endif

    __trackingStarted = true

;     Debug.Trace("WEREWOLF: Race swap done; starting tracking and effects.")
    
    ; take all the player's stuff (since he/she can't use it anyway)
    ; Game.GetPlayer().RemoveAllItems(LycanStash)
    Game.GetPlayer().UnequipAll()
    ;Game.GetPlayer().EquipItem(WolfSkinFXArmor, False, True)
	;not sure if needed 

    ;Add Blood Effects
    ;FeedBloodVFX.Play(Game.GetPlayer())

    ; make everyone hate you
    Game.GetPlayer().SetAttackActorOnSight(true)

    ; alert anyone nearby that they should now know the player is a werewolf
    Game.SendWereWolfTransformation()

    ;Game.GetPlayer().AddToFaction(PlayerWerewolfFaction)
    ;Game.GetPlayer().AddToFaction(WerewolfFaction)
	Game.GetPlayer().AddToFaction(PlayerVampireFaction)

    int cfIndex = 0
    while (cfIndex < CrimeFactions.GetSize())
;         Debug.Trace("WEREWOLF: Setting enemy flag on " + CrimeFactions.GetAt(cfIndex))
        (CrimeFactions.GetAt(cfIndex) as Faction).SetPlayerEnemy()
        cfIndex += 1
    endwhile
	HunterFaction.SetPlayerEnemy()
	;???? hunter who

    ; but they also don't know that it's you
    Game.SetPlayerReportCrime(false)

    ; recalc times
    __durationWarningTime = RealTimeSecondsToGameTimeDays(DurationWarningTimeSeconds)
    __feedExtensionTime   = RealTimeSecondsToGameTimeDays(FeedExtensionTimeSeconds)

    ; unequip magic
	Debug.Trace("VAMPIRE: UNEQUIPPING MAGIC!")
    Spell left = Game.GetPlayer().GetEquippedSpell(0)
    Spell right = Game.GetPlayer().GetEquippedSpell(1)
    Spell power = Game.GetPlayer().GetEquippedSpell(2)
    Shout voice = Game.GetPlayer().GetEquippedShout()
	if (left != None)
		Debug.Trace("VAMPIRE: Spell in left hand was" + left)
        Game.GetPlayer().UnequipSpell(left, 0)
	else
		Debug.Trace("VAMPIRE: No spell in left hand.")
    endif
    if (right != None)
		Debug.Trace("VAMPIRE: Spell in right hand was" + right)
        Game.GetPlayer().UnequipSpell(right, 1)
	else
		Debug.Trace("VAMPIRE: No spell in right hand.")
    endif
    if (power != None)
        ; some players are overly clever and sneak a power equip between casting
        ;  beast form and when we rejigger them there. this will teach them.
         Debug.Trace("WEREWOLF: " + power + " was equipped; removing.")
        Game.GetPlayer().UnequipSpell(power, 2)
    else
         Debug.Trace("WEREWOLF: No power equipped.")
    endif
    if (voice != None)
        ; same deal here, but for shouts
         Debug.Trace("WEREWOLF: " + voice + " was equipped; removing.")
        Game.GetPlayer().UnequipShout(voice)
    else
         Debug.Trace("WEREWOLF: No shout equipped.")
    endif

    ; but make up for it by giving you the sweet howl
    ;CurrentHowlWord1 = (CompanionsTrackingQuest as CompanionsHousekeepingScript).CurrentHowlWord1
    ;CurrentHowlWord2 = (CompanionsTrackingQuest as CompanionsHousekeepingScript).CurrentHowlWord2
    ;CurrentHowlWord3 = (CompanionsTrackingQuest as CompanionsHousekeepingScript).CurrentHowlWord3
    ;CurrentHowl = (CompanionsTrackingQuest as CompanionsHousekeepingScript).CurrentHowl

    ;Game.UnlockWord(CurrentHowlWord1)
    ;Game.UnlockWord(CurrentHowlWord2)
    ;Game.UnlockWord(CurrentHowlWord3)
    ;Game.GetPlayer().AddShout(CurrentHowl)
    ;Game.GetPlayer().EquipShout(CurrentHowl)

    ; and some rad claws
    int playerLevel = Game.GetPlayer().GetLevel()
    if     (playerLevel <= 10)
        Game.GetPlayer().AddSpell(ET_PlayerVampireGarkainBeast10AndBelowAbility, false)
    elseif (playerLevel <= 15)
        Game.GetPlayer().AddSpell(ET_PlayerVampireGarkainBeast15AndBelowAbility, false)
    elseif (playerLevel <= 20)
        Game.GetPlayer().AddSpell(ET_PlayerVampireGarkainBeast20AndBelowAbility, false)
    elseif (playerLevel <= 25)
        Game.GetPlayer().AddSpell(ET_PlayerVampireGarkainBeast25AndBelowAbility, false)
    elseif (playerLevel <= 30)
        Game.GetPlayer().AddSpell(ET_PlayerVampireGarkainBeast30AndBelowAbility, false)
    elseif (playerLevel <= 35)
        Game.GetPlayer().AddSpell(ET_PlayerVampireGarkainBeast35AndBelowAbility, false)
    elseif (playerLevel <= 40)
        Game.GetPlayer().AddSpell(ET_PlayerVampireGarkainBeast40AndBelowAbility, false)
    elseif (playerLevel <= 45)
        Game.GetPlayer().AddSpell(ET_PlayerVampireGarkainBeast45AndBelowAbility, false)
    else
        Game.GetPlayer().AddSpell(ET_PlayerVampireGarkainBeast50AndOverAbility, false)
    endif

    ; calculate when the player turns back into a pumpkin
    float currentTime = GameDaysPassed.GetValue()
    float regressTime = currentTime + RealTimeSecondsToGameTimeDays(StandardDurationSeconds)
    ET_PlayerVampireGarkainBeastShiftBackTime.SetValue(regressTime)
;     Debug.Trace("WEREWOLF: Current day -- " + currentTime)
;     Debug.Trace("WEREWOLF: Player will turn back at day " + regressTime)

    ; increment stats
    ;Game.IncrementStat("Werewolf Transformations")

    ; set us up to check when we turn back
    RegisterForUpdate(5)

    SetStage(10) ; we're done with the transformation handling
EndFunction


Event OnUpdate()
    if (Untimed)
        return
    endif
    float currentTime = GameDaysPassed.GetValue()
    float regressTime = ET_PlayerVampireGarkainBeastShiftBackTime.GetValue()

    if (  (currentTime >= regressTime) && (!Game.GetPlayer().IsInKillMove()) && !__tryingToShiftBack )
        UnregisterForUpdate()
        SetStage(100) ; time to go, buddy
        return
    endif

    if (currentTime >= regressTime - __durationWarningTime)
        if (GetStage() == 10)
            SetStage(20)  ; almost there
            return
        endif
    endif

;     Debug.Trace("WEREWOLF: Checking, still have " + GameTimeDaysToRealTimeSeconds(regressTime - currentTime) + " seconds to go.")
EndEvent

Function SetUntimed(bool untimedValue)
    Untimed = untimedValue
    if (Untimed)
        UnregisterForUpdate()
    endif
EndFunction

; called from stage 11
Function Feed(Actor victim)
    float newShiftTime = ET_PlayerVampireGarkainBeastShiftBackTime.GetValue() + __feedExtensionTime
    Game.GetPlayer().PlayIdle(SpecialFeeding)
    
    ;This is for adding a spell that simulates bleeding
    BleedingFXSpell.Cast(victim,victim)
    
   
        ET_PlayerVampireGarkainBeastShiftBackTime.SetValue(newShiftTime)
        PlayerWerewolfFeedMessage.Show()
        FeedBoost.Cast(Game.GetPlayer())
		
;;;;;;;;;;feed boost?

        ; victim.SetActorValue("Variable08", 100)
;         Debug.Trace("WEREWOLF: Player feeding -- new regress day is " + newShiftTime)
 
    SetStage(10)
EndFunction


; called from stage 20
Function WarnPlayer()
;     Debug.Trace("WEREWOLF: Player about to transform back.")
    ;WerewolfWarn.Apply()
	VampireWarn.Apply()
;;;;;;;;;;;;	should replace?
EndFunction


; called from stage 100
Function ShiftBack()
    __tryingToShiftBack = true

    while (Game.GetPlayer().GetAnimationVariableBool("bIsSynced"))
;         Debug.Trace("WEREWOLF: Waiting for synced animation to finish...")
        Utility.Wait(0.1)
    endwhile
	
;;;;;;;;; guess still relevant for garkain?

;     Debug.Trace("WEREWOLF: Sending transform event to turn player back to normal.")

    __shiftingBack = false
    ; RegisterForAnimationEvent(Game.GetPlayer(), "TransformToHuman")
    ; Game.GetPlayer().PlayIdle(WerewolfTransformBack)
    ; Utility.Wait(10)
    ActuallyShiftBackIfNecessary()
EndFunction

Event OnAnimationEvent(ObjectReference akSource, string asEventName)
    if (asEventName == "TransformToHuman")
        ActuallyShiftBackIfNecessary()
    endif
	;;;;;; where does anim event come from?
EndEvent

Function ActuallyShiftBackIfNecessary()
    if (__shiftingBack)
        return
    endif

    __shiftingBack = true

;     Debug.Trace("WEREWOLF: Player returning to normal.")

    Game.SetInCharGen(true, true, false)

    UnRegisterForAnimationEvent(Game.GetPlayer(), "TransformToHuman")
	;;;;;; where is register?
    UnRegisterForUpdate() ; just in case

    if (Game.GetPlayer().IsDead())
;         Debug.Trace("WEREWOLF: Player is dead; bailing out.")
        return
    endif

    ;Remove Blood Effects
    ;FeedBloodVFX.Stop(Game.GetPlayer())

    ; imod
;    WerewolfChange.Apply()
 ;   WerewolfIMODSound.Play(Game.GetPlayer())

	
	;SHOULD BE --me
	actor PlayerActor = Game.GetPlayer()
	VampireChange.Apply()
	VampireIMODSound.Play(PlayerActor)
	
	;	We now add the effect with a long duration and remove it later.
	DLC1VampireChangeBackFXS.Play(PlayerActor,12.0)
	;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ; get rid of your summons if you have any
    ;int count = 0
    ;while (count < WerewolfDispelList.GetSize())
    ;    Spell gone = WerewolfDispelList.GetAt(count) as Spell
    ;    if (gone != None)
;   ;          Debug.Trace("WEREWOLF: Dispelling " + gone)
    ;        Game.GetPlayer().DispelSpell(gone)
    ;    endif
    ;    count += 1
    ;endwhile

    ; make sure the transition armor is gone
    ;Game.GetPlayer().UnequipItem(WolfSkinFXArmor, False, True)

    ; clear out perks/abilities
    ;  (don't need to do this anymore since it's on from gamestart)
    ; Game.GetPlayer().RemovePerk(PlayerWerewolfFeed)

    ; make sure your health is reasonable before turning you back
    ; Game.GetPlayer().GetActorBase().SetInvulnerable(true)
    Game.GetPlayer().SetGhost()
    float currHealth = Game.GetPlayer().GetAV("health")
    if (currHealth <= 70)
;         Debug.Trace("WEREWOLF: Player's health is only " + currHealth + "; restoring.")
        Game.GetPlayer().RestoreAV("health", 70 - currHealth)
    endif

;	change you back
	
	Debug.Trace("VAMPIRE: Setting race " + (VampireTrackingQuest as DLC1VampireTrackingQuest).PlayerRace + " on " + PlayerActor)
	;PlayerActor.RemoveItem(DLC1VampireLordArmor, 2, true)
	PlayerActor.SetRace((VampireTrackingQuest as DLC1VampireTrackingQuest).PlayerRace)
	
	DLC1VampireChangeBackFXS.stop(PlayerActor)
    DLC1VampireChangeBack02FXS.Play(PlayerActor,0.1)

    ; release the player controls
;     Debug.Trace("WEREWOLF: Restoring camera controls")
    Game.EnablePlayerControls(abMovement = false, abFighting = false, abCamSwitch = true, abLooking = false, abSneaking = false, abMenu = false, abActivate = false, abJournalTabs = false, aiDisablePOVType = 1)
    Game.ShowFirstPersonGeometry(true)

    ; no more howling for you
    ;Game.GetPlayer().UnequipShout(CurrentHowl)
    ;Game.GetPlayer().RemoveShout(CurrentHowl)

    ; or those claws
    Game.GetPlayer().RemoveSpell(ET_PlayerVampireGarkainBeast10AndBelowAbility)
    Game.GetPlayer().RemoveSpell(ET_PlayerVampireGarkainBeast15AndBelowAbility)
    Game.GetPlayer().RemoveSpell(ET_PlayerVampireGarkainBeast20AndBelowAbility)
    Game.GetPlayer().RemoveSpell(ET_PlayerVampireGarkainBeast25AndBelowAbility)
    Game.GetPlayer().RemoveSpell(ET_PlayerVampireGarkainBeast30AndBelowAbility)
    Game.GetPlayer().RemoveSpell(ET_PlayerVampireGarkainBeast35AndBelowAbility)
    Game.GetPlayer().RemoveSpell(ET_PlayerVampireGarkainBeast40AndBelowAbility)
    Game.GetPlayer().RemoveSpell(ET_PlayerVampireGarkainBeast45AndBelowAbility)
    Game.GetPlayer().RemoveSpell(ET_PlayerVampireGarkainBeast50AndOverAbility)

    ; gimme back mah stuff
    ; LycanStash.RemoveAllItems(Game.GetPlayer())

    ; people don't hate you no more
    Game.GetPlayer().SetAttackActorOnSight(false)
    ;Game.GetPlayer().RemoveFromFaction(PlayerWerewolfFaction)
    ;Game.GetPlayer().RemoveFromFaction(WerewolfFaction)
	Game.GetPlayer().RemoveFromFaction(PlayerVampireFaction)
    int cfIndex = 0
    while (cfIndex < CrimeFactions.GetSize())
;         Debug.Trace("WEREWOLF: Removing enemy flag from " + CrimeFactions.GetAt(cfIndex))
        (CrimeFactions.GetAt(cfIndex) as Faction).SetPlayerEnemy(false)
        cfIndex += 1
    endwhile

    ; and you're now recognized
    Game.SetPlayerReportCrime(true)

    ; alert anyone nearby that they should now know the player is a werewolf
    Game.SendWereWolfTransformation()
	;;;;;;;;;; change to vamp trans?

    ; give the set race event a chance to come back, otherwise shut us down
    Utility.Wait(5)
    Shutdown()
EndFunction

Function Shutdown()
    if (__shuttingDown)
        return
    endif

    __shuttingDown = true

    Game.GetPlayer().GetActorBase().SetInvulnerable(false)
    Game.GetPlayer().SetGhost(false)

    Game.SetBeastForm(False)
    Game.EnableFastTravel(True)

    Game.SetInCharGen(false, false, false)

    Stop()
EndFunction

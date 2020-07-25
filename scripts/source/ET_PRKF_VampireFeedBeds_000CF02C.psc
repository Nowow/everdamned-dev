;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 49
Scriptname ET_PRKF_VampireFeedBeds_000CF02C Extends Perk Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akTargetRef, Actor akActor)
;BEGIN CODE
int button = FeedChoice.Show()

	If (button >= 0 && button <= 5)
		DLC1VampireTurn.PlayerBitesMe(akTargetRef as actor)
		Game.GetPlayer().StartVampireFeed(aktargetRef as actor)
		PlayerVampireQuest.VampireFeed(aktargetRef as actor, button, 0)
	Endif
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_27
Function Fragment_27(ObjectReference akTargetRef, Actor akActor)
;BEGIN CODE
int button = FeedChoice.Show()

	If (button >= 0 && button <= 5)
		DLC1VampireTurn.PlayerBitesMe(akTargetRef as actor)
		Game.GetPlayer().StartVampireFeed(aktargetRef as actor)
		PlayerVampireQuest.VampireFeed(aktargetRef as actor, button, 0)
	Endif
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

PlayerVampireQuestScript Property PlayerVampireQuest  Auto  

Message Property FeedChoice  Auto  

dlc1vampireturnscript Property DLC1VampireTurn  Auto  

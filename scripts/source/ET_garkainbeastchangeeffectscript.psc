Scriptname ET_garkainbeastchangeeffectscript extends ActiveMagicEffect  
{Scripted effect for the ET vampire garkain change}



;======================================================================================;
;               PROPERTIES  /
;=============/

Quest Property PlayerVampireGarkainBeastQuest auto
Spell Property VFXSpell auto


;======================================================================================;
;               EVENTS                     /
;=============/

Event OnEffectStart(Actor Target, Actor Caster)
; 	Debug.Trace("WEREWOLF: Casting transformation spell on " + Target)

	; set up tracking
	if (Target == Game.GetPlayer())
; 		Debug.Trace("WEREWOLF: Target is player.")
		; if this is the first time, don't actually do anything (transform handled in rampage script)

; 		Debug.Trace("WEREWOLF: Starting player tracking.")

		PlayerVampireGarkainBeastQuest.Start()
	endif

	;;;;;;;make vampire vfx
	VFXSpell.Cast(Target)
EndEvent


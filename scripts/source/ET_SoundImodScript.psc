Scriptname ET_SoundImodScript extends ActiveMagicEffect 


ImageSpaceModifier property IntroFX auto
ImageSpaceModifier property StaticFX auto
ImageSpaceModifier property OutroFX auto
Float property fStaticDelay auto
Sound property IntroSoundFX auto
Sound property OutroSoundFX auto

bool bIsFinishing = false

Event OnEffectStart(Actor Target, Actor Caster)
	If IntroSoundFX != none
		int instanceID = IntroSoundFX.play((target as objectReference))
	Endif
	If IntroFX != None
		introFX.apply()
	EndIf
	Utility.wait (fStaticDelay)
	If bIsFinishing == false
		If StaticFX != None
			StaticFX.apply()
		Endif
	EndIf
EndEvent

Event OnEffectFinish(Actor Target, Actor Caster)
	If OutroSoundFX != none
		int instanceID = OutroSoundFX.play((target as objectReference))
	Endif
	bIsFinishing = true
	If OutroFX != None
		OutroFX.apply()
	EndIf
	If StaticFX != None
		StaticFX.remove()
	Endif
EndEvent
Scriptname ET_PowerSubtelyAVampiresSightScript extends ActiveMagicEffect  

import GlobalVariable

float property fDelay = 0.83 auto
ImageSpaceModifier property IntroFX auto
ImageSpaceModifier property MainFX auto
ImageSpaceModifier property OutroFX auto
Float Property fImodStrength = 1.0 auto
sound property IntroSoundFX auto
sound property OutroSoundFX auto
GlobalVariable Property NightEyeTransitionGlobal auto

Event OnEffectStart(Actor Target, Actor Caster)	
	if NightEyeTransitionGlobal.GetValue() == 0.0
		NightEyeTransitionGlobal.setValue(1.0)
		int instanceID = IntroSoundFX.play((target as objectReference))
		introFX.apply(fImodStrength)
		utility.wait(fDelay)
		if NightEyeTransitionGlobal.GetValue() == 1.0
			introFX.PopTo(MainFX,fImodStrength)	
			NightEyeTransitionGlobal.setValue(2.0)
		endif
	elseif NightEyeTransitionGlobal.GetValue() == 1.0
		introFX.PopTo(MainFX,fImodStrength)	
		NightEyeTransitionGlobal.setValue(2.0)
		self.dispel()
	else
		self.dispel()
	endif
	RegisterForSingleUpdate(1)
EndEvent

Event OnUpdate()
	if GetTargetActor().HasSpell(ToggleEffect) == 0
		GetTargetActor().RemoveSpell(CurrentEffect)
	endif
	RegisterForSingleUpdate(1)
Endevent

Event OnEffectFinish(Actor Target, Actor Caster)
	if NightEyeTransitionGlobal.GetValue() == 2.0
		NightEyeTransitionGlobal.setValue(3.0)
		int instanceID = OutroSoundFX.play((target as objectReference))
		MainFX.PopTo(OutroFX,fImodStrength)
		introFX.remove()
		NightEyeTransitionGlobal.setValue(0.0)
	endif
	Target.RemoveSpell(CurrentEffect)
endEvent

SPELL Property CurrentEffect  Auto  
SPELL Property ToggleEffect  Auto
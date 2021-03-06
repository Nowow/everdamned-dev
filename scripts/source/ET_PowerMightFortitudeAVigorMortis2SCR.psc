Scriptname ET_PowerMightFortitudeAVigorMortis2SCR extends ActiveMagicEffect  

Event OnEffectStart(Actor akTarget, Actor akCaster)
	CostTotal = CostBase
	ET_VampireBloodPoolDelta.Mod(CostTotal)
Endevent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	ET_VampireBloodPoolDelta.Mod(-CostTotal)
	If ET_VampireBloodPoolCurrent.GetValue() <= 0
		;Debug.Notification("The power sparked and fizzled miserably. I am too hungry to maintain it right now!")
		PowerFailMSG.Show()
		GetTargetActor().DispelSpell(CurrentEffect)
	Endif
	If GetTargetActor().HasSpell(ToggleEffect) == 0
		GetTargetActor().DispelSpell(CurrentEffect)
	Endif
Endevent

GlobalVariable Property ET_VampireBloodPoolCurrent  Auto
Spell Property CurrentEffect  Auto  
Spell Property ToggleEffect  Auto
Message Property PowerFailMSG Auto
GlobalVariable Property ET_VampireBloodPoolDelta  Auto
Float Property CostBase Auto
Float Property CostTotal Auto
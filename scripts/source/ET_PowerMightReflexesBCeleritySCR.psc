Scriptname ET_PowerMightReflexesBCeleritySCR extends ActiveMagicEffect  

Event OnEffectStart(Actor akTarget, Actor akCaster)
	ActiveEP = FALSE
	CostTotal = CostBase*ET_PowerCostMult.GetValue()
	If ET_VampireBloodPoolCurrent.GetValue() < CostTotal
		;Debug.Notification("The power sparked and fizzled miserably. I am too hungry to maintain it right now!")
		PowerFailMSG.Show()
	else
		ET_VampireBloodPoolCurrent.Mod(-CostTotal)
		;mslVTExp.Mod(CostBase/2*mslVTExpMult.GetValue())
		If akTarget.HasSpell(ExtendedPerceptionSP)
			ActiveEP = TRUE
			akTarget.RemoveSpell(ExtendedPerceptionSP)
		Endif
		utility.wait(0.1)
		akTarget.AddSpell(CeleritySP, false)
	Endif
Endevent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	akTarget.RemoveSpell(CeleritySP)
	akTarget.DispelSpell(CeleritySP)
	utility.wait(0.1)
	If ActiveEP == TRUE
		akTarget.AddSpell(ExtendedPerceptionSP, false)
	Endif
Endevent

SPELL Property ExtendedPerceptionSP  Auto  
SPELL Property CeleritySP  Auto  
Bool Property ActiveEP Auto
GlobalVariable Property ET_VampireBloodPoolCurrent  Auto
GlobalVariable Property ET_PowerCostMult  Auto  
;GlobalVariable Property mslVTExp  Auto
;GlobalVariable Property mslVTExpMult Auto
Message Property PowerFailMSG Auto
Float Property CostBase Auto
Float Property CostTotal Auto
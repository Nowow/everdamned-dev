Scriptname ET_PowerBloodPoolCostManager extends ActiveMagicEffect  

Event OnEffectStart(Actor akTarget, Actor akCaster)
	CostTotal = CostBase*ET_PowerCostMult.GetValue()
	If ET_VampireBloodPoolCurrent.GetValue() < CostTotal
		Debug.Trace("The power sparked and fizzled miserably. I am too hungry to maintain it right now!")
		;PowerFailMSG.Show()
		akTarget.DispelSpell(CurrentEffect)
	else
		ET_VampireBloodPoolCurrent.Mod(-CostTotal)
		;mslVTExp.Mod(CostBase/2*mslVTExpMult.GetValue())
		Debug.Trace("DEBUG: Everdamned: Hit! Spell: " + CurrentEffect)
	Endif
Endevent

GlobalVariable Property ET_VampireBloodPoolCurrent Auto
GlobalVariable Property ET_PowerCostMult  Auto  
;GlobalVariable Property mslVTExp  Auto
;GlobalVariable Property mslVTExpMult Auto
Spell Property CurrentEffect  Auto  
Message Property PowerFailMSG Auto
Float Property CostBase Auto
Float Property CostTotal Auto
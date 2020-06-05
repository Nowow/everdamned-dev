Scriptname ET_PowerBloodRiteScript extends ActiveMagicEffect  

Event OnEffectStart(Actor akTarget, Actor akCaster)
	CostTotal = CostBase*ET_PowerCostMult.GetValue()
	if ET_VampireBloodPoolCurrent.GetValue() < CostTotal
		;Debug.Notification("I do not have enough blood to perform this ritual!")
		RiteFailMSG.Show()
	else
		akCaster.PlayIdle(RiteIdle)
		RiteVisual.Play(akCaster)
		utility.wait(2.0)
		RiteSpell.Cast(akCaster, akTarget)
		ET_VampireBloodPoolCurrent.Mod(-CostTotal)
		ET_Exp.Mod(CostBase/2*ET_ExpMult.GetValue())
	endif
Endevent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	akCaster.RemoveSpell(RiteSpell)
Endevent

Idle Property RiteIdle  Auto  
GlobalVariable Property ET_VampireBloodPoolCurrent	  Auto
GlobalVariable Property ET_PowerCostMult  Auto  
GlobalVariable Property ET_Exp  Auto
GlobalVariable Property ET_ExpMult Auto
Spell Property RiteSpell Auto
VisualEffect Property RiteVisual Auto
Message Property RiteFailMSG Auto
Float Property CostBase Auto
Float Property CostTotal Auto
Scriptname ET_PowerMagicMSBShamHordesControlSCR extends ActiveMagicEffect  

Event OnEffectFinish(Actor akTarget, Actor akCaster)

;	Debug.Notification("Number of forms at the start: " + SHList.GetSize())

	CostTotal = CostBase*ET_PowerCostMult.GetValue()*SHList.GetSize()
	If ET_VampireBloodPoolCurrent.GetValue() < CostTotal
		;Debug.Notification("I am too hungry to maintain so many undead thralls right now!")
		RiteFailMSG.Show()
		while (ET_VampireBloodPoolCurrent.GetValue() < CostTotal)
			(SHList.GetAt(0) as Actor).Kill()
			SHList.RemoveAddedForm(SHList.GetAt(0) as Actor)
			CostTotal = CostBase*ET_PowerCostMult.GetValue()*SHList.GetSize()
		endwhile
		ET_VampireBloodPoolCurrent.Mod(-CostTotal)
		ET_Exp.Mod(CostBase*SHList.GetSize()/2)
	else
		ET_VampireBloodPoolCurrent.Mod(-CostTotal)
		ET_Exp.Mod(CostBase*SHList.GetSize()/2)
	Endif

;	Debug.Notification("Number of forms after surplus termination: " + SHList.GetSize())

	If SHList.GetSize() > 0
		while (SHList.GetSize() > 0)
			SHList.RemoveAddedForm(SHList.GetAt(0) as Actor)
		endwhile
	Endif

;	Debug.Notification("Number of forms at the end: " + SHList.GetSize())

Endevent

FormList Property SHList Auto
GlobalVariable Property ET_VampireBloodPoolCurrent  Auto
GlobalVariable Property ET_PowerCostMult  Auto  
GlobalVariable Property ET_Exp  Auto
Message Property RiteFailMSG Auto
Float Property CostBase Auto
Float Property CostTotal Auto
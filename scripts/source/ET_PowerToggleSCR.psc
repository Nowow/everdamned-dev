Scriptname ET_PowerToggleSCR extends activemagiceffect  

Event OnEffectStart(Actor akTarget, Actor akCaster)
	If akTarget.HasSpell(CurrentEffect) == 1
		ET_PowerToggleOffMSG.Show()
		akTarget.RemoveSpell(CurrentEffect)
	Else
		ET_PowerToggleOnMSG.Show()
		akTarget.AddSpell(CurrentEffect, false)
	Endif
Endevent

SPELL Property CurrentEffect Auto

Message Property ET_PowerToggleOnMSG Auto
Message Property ET_PowerToggleOffMSG Auto
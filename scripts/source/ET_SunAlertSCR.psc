Scriptname ET_SunAlertSCR extends activemagiceffect  

Event OnEffectStart(Actor akTarget, Actor akCaster)
;	Debug.Notification("I feel uneasy as the sky brightens and sunrise is coming closer.")
	ET_SunAlertMSG.Show()
endEvent

Message Property ET_SunAlertMSG Auto
scriptname ET_BloodPoolMeterWidgetUpdate extends Quest


; -------------------------------------------------------------------------------------------------
; VARIABLES ---------------------------------------------------------------------------------------


ET_BloodPoolMeter property ExposureMeter auto
GlobalVariable Property ET_VampireBloodPoolMeterEnabled Auto
GlobalVariable Property ET_VampireBloodPoolCurrent Auto
GlobalVariable Property ET_VampireBloodPoolMax Auto
GlobalVariable Property ET_VampireBloodPoolMaxOnTop Auto
GlobalVariable property ET_VampireBloodPoolMeterDisplay_Contextual auto
GlobalVariable property ET_VampireBloodPoolMeter_Opacity auto
GlobalVariable Property ET_VampireBloodPoolMeterScale Auto
GlobalVariable property ET_VampireBloodPoolMeterX auto
GlobalVariable property ET_VampireBloodPoolMeterY auto
GlobalVariable property ET_VampireBloodPoolMeterDisplayTime auto
 
float LastBloodPoolCurrent
int iDisplayIterationsRemaining


; -------------------------------------------------------------------------------------------------
; EVENTS ------------------------------------------------------------------------------------------


Event OnInit()

	ExposureMeter.HAnchor = "left"
	ExposureMeter.VAnchor = "bottom"
	ExposureMeter.X = ET_VampireBloodPoolMeterX.GetValue() ; Default is 67
	ExposureMeter.Y = ET_VampireBloodPoolMeterY.GetValue() ; Default is 640
	
	StartUpdating()
	
endEvent


Event OnGameReload()

	StartUpdating()
	
endEvent


function StartUpdating()

	RegisterForSingleUpdate(2)
	
endFunction


Event OnUpdate()

	if ET_VampireBloodPoolMeterEnabled.GetValue() == 0
		ExposureMeter.Alpha = 0.0
		;UnRegisterForUpdate()
	else
		UpdateMeter()
	endif

	if ET_VampireBloodPoolMeterEnabled.GetValue() != 0
		RegisterForSingleUpdate(2)
	endif	
	
endEvent


; -------------------------------------------------------------------------------------------------
; FUNCTIONS ---------------------------------------------------------------------------------------


function UpdateMeter(bool bSkipDisplayHandling = false)



	float BloodPoolCurrent = ET_VampireBloodPoolCurrent.GetValue()
	float BloodPoolMax = ET_VampireBloodPoolMax.GetValue() + ET_VampireBloodPoolMaxOnTop.GetValue()
	
	
	if ET_VampireBloodPoolMeterEnabled.GetValue() != 0
		UpdateBlood(BloodPoolCurrent, bSkipDisplayHandling)
	endif
	
	LastBloodPoolCurrent = BloodPoolCurrent

	if iDisplayIterationsRemaining > 0
		iDisplayIterationsRemaining -= 1
		if iDisplayIterationsRemaining <= 0
			iDisplayIterationsRemaining = 0
			if ET_VampireBloodPoolMeterDisplay_Contextual.GetValueInt() != 1
				ExposureMeter.FadeTo(0.0, 3.0)
			endif
		endif
	elseif iDisplayIterationsRemaining == 0
		if ExposureMeter.Alpha == ET_VampireBloodPoolMeter_Opacity.GetValue()
			if ET_VampireBloodPoolMeterDisplay_Contextual.GetValueInt() != 1
				ExposureMeter.FadeTo(0.0, 3.0)
			endif
		endif
	else
	endif	
	
endFunction


function UpdateBlood(float fThisBloodPointValue, bool bSkipDisplayHandling = false)

	float BloodPoolCurrent = ET_VampireBloodPoolCurrent.GetValue()
	float BloodPoolMax = ET_VampireBloodPoolMax.GetValue() + ET_VampireBloodPoolMaxOnTop.GetValue()
	float BloodMeterPercent = BloodPoolCurrent / BloodPoolMax
	
	if ET_VampireBloodPoolMeterDisplay_Contextual.GetValueInt() == 1
		ExposureMeter.Alpha = ET_VampireBloodPoolMeter_Opacity.GetValue()
	elseif ET_VampireBloodPoolMeterDisplay_Contextual.GetValueInt() == 2 || bSkipDisplayHandling
		ContextualDisplay(BloodPoolCurrent)
	elseif ET_VampireBloodPoolMeterDisplay_Contextual.GetValueInt() == 0 && iDisplayIterationsRemaining == 0
		ExposureMeter.Alpha = 0.0
		return
	endif
	if LastBloodPoolCurrent <= 0
		ExposureMeter.ForcePercent(0.0)
	endif

	ExposureMeter.HAnchor = "left" 
	ExposureMeter.VAnchor = "bottom" 
	ExposureMeter.X = ET_VampireBloodPoolMeterX.GetValue() ; Default is 67
	ExposureMeter.Y = ET_VampireBloodPoolMeterY.GetValue() ; Default is 640
	Exposuremeter.Height = ((ET_VampireBloodPoolMeterScale.GetValue()/100)*25.2) ; Default Scale is 100 with Height of 25.2
	Exposuremeter.Width = ((ET_VampireBloodPoolMeterScale.GetValue()/100)*292.8) ; Default Scale is 100 with Width of 292.8
	
	ExposureMeter.SetPercent(BloodMeterPercent)

	Int _primaryColor = 11141120
	
	ExposureMeter.SetColors(_primaryColor, 3276800)
	
endFunction


function ContextualDisplay(float fThisBloodPointValue, bool bSkipDisplayHandling = false)

	if bSkipDisplayHandling
		iDisplayIterationsRemaining = ET_VampireBloodPoolMeterDisplayTime.GetValueInt()
		return
	endif

	bool BloodPointsChanged = LastBloodPoolCurrent != fThisBloodPointValue	
	
	if BloodPointsChanged
		ExposureMeter.FadeTo(ET_VampireBloodPoolMeter_Opacity.GetValue(), 1.0)
		iDisplayIterationsRemaining = ET_VampireBloodPoolMeterDisplayTime.GetValueInt()
	endif	

endFunction

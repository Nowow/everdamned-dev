Scriptname ET_SunDamageSCR extends ActiveMagicEffect  

float Property TimeOld Auto
float Property TimeNew Auto
float Property TimePassed Auto

float Function GameTimeDaysToRealTimeSeconds(float gametime)
	float gameSeconds = gametime * (60 * 60 * 24)
	return (gameSeconds / TimeScale.Value)
EndFunction

Event OnEffectStart(Actor akTarget, Actor akCaster)
	TimeOld = 0
	RegisterForSingleUpdate(1)
Endevent

Event OnUpdate()

	If GetTargetActor().IsInInterior() == 0 && GetTargetActor().HasMagicEffectWithKeyword(SunDamageGrace) == 0 && GameHour.GetValue() <= ET_SunDusk.GetValue() && GameHour.GetValue() >= ET_SunDawn.GetValue() && SunDamageExceptionWorldSpaces.HasForm(GetTargetActor().GetWorldSpace()) == 0 && DLC1EclipseActive.GetValue() == 0 && ET_SunDmg.GetValue() > 0

		float BaseMult
		float TimeMult
		float WeatherMult
		float HungerMod
		float SunDamage

;Check time of day

		If (GameHour.GetValue() <= 12)
			BaseMult = 12 - GameHour.GetValue()
		Elseif (GameHour.GetValue() >= 12)
			BaseMult = GameHour.GetValue() - 12
		Endif

		TimeMult = (1 - BaseMult*0.125)

;Check weather type

		If Weather.GetCurrentWeather().GetClassification() == -1; None
			WeatherMult = 0
		Elseif Weather.GetCurrentWeather().GetClassification() == 0; Pleasant
			WeatherMult = 1
		Elseif Weather.GetCurrentWeather().GetClassification() == 1; Cloudy
			WeatherMult = 0.7
		Elseif Weather.GetCurrentWeather().GetClassification() == 2; Rainy
			WeatherMult = 0.4
		Elseif Weather.GetCurrentWeather().GetClassification() == 3; Snowy
			WeatherMult = 0.2
		Endif

;Check hunger

		If GetTargetActor().HasSpell(HungerState2) == 1
			HungerMod = 5
		Elseif GetTargetActor().HasSpell(HungerState3) == 1
			HungerMod = 10
		Elseif GetTargetActor().HasSpell(HungerState4) == 1
			HungerMod = 15
		Else
			HungerMod = 0
		Endif

;Account for large time jumps and finally get burny!

		TimeNew = GameDaysPassed.GetValue()
		TimePassed = TimeNew - TimeOld
		float DelayMult = GameTimeDaysToRealTimeSeconds(TimePassed)
		If TimeOld != 0
			SunDamage = (ET_SunDmg.GetValue()+HungerMod+DetAct.GetValue())*TimeMult*WeatherMult*DelayMult*(GetTargetActor().GetLightLevel()/100)
			GetTargetActor().damageAV("Health", SunDamage)
		Endif

		TimeOld = GameDaysPassed.GetValue()

		If GetTargetActor().GetAVPercentage("Health") < 0.8 && !GetTargetActor().IsSwimming() && !GetTargetActor().IsDead()
			DmgVis1.Play(GetTargetActor(), 3)
			If GetTargetActor().GetAVPercentage("Health") >= 0.5 && GetTargetActor().GetAVPercentage("Health") < 0.7
				DmgVis2.Play(GetTargetActor(), 3)
			Elseif GetTargetActor().GetAVPercentage("Health") >= 0.2 && GetTargetActor().GetAVPercentage("Health") < 0.5
				DmgVis3.Play(GetTargetActor(), 3)
			Elseif GetTargetActor().GetAVPercentage("Health") < 0.2
				DmgVis4.Play(GetTargetActor(), 3)
			Endif
		Endif

		RegisterForSingleUpdate(1)

	Else

		TimeOld = 0
		UnregisterForUpdate()

	Endif

Endevent

GlobalVariable Property ET_SunDmg Auto

GlobalVariable Property ET_SunDawn Auto
GlobalVariable Property ET_SunDusk Auto

GlobalVariable Property GameDaysPassed Auto
GlobalVariable Property GameHour Auto
GlobalVariable Property TimeScale Auto

GlobalVariable Property DetAct Auto

Keyword Property SunDamageGrace Auto
WorldSpace Property Sovngarde Auto
FormList Property SunDamageExceptionWorldSpaces Auto
GlobalVariable Property DLC1EclipseActive Auto

SPELL Property HungerState2 Auto 
SPELL Property HungerState3 Auto  
SPELL Property HungerState4 Auto  

EffectShader Property DmgVis1  Auto  
EffectShader Property DmgVis2  Auto  
EffectShader Property DmgVis3  Auto  
EffectShader Property DmgVis4  Auto
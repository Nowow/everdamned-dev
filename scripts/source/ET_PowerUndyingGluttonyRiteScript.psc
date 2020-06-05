Scriptname ET_PowerUndyingGluttonyRiteScript extends activemagiceffect

float property fDelay = 0.75 auto
									{time to wait before Spawning Ash Pile}
float property fDelayEnd = 1.65 auto
									{time to wait before Removing Base Actor}
float property ShaderDuration = 0.00 auto
									{Duration of Effect Shader.}
Activator property AshPileObject auto
									{The object we use as a pile.}
EffectShader property MagicEffectShader auto
									{The Effect Shader we want.}
Bool property bSetAlphaZero = True auto
									{The Effect Shader we want.}
Bool property bSetAlphaToZeroEarly = False Auto
									{Use this if we want to set the acro to invisible somewhere before the effect shader is done.}

bool function TurnToAsh()
		GetTargetActor().SetCriticalStage(GetTargetActor().CritStage_DisintegrateStart)
		if	MagicEffectShader != none
			MagicEffectShader.play(GetTargetActor(),ShaderDuration)
		endif
		if bSetAlphaToZeroEarly
			GetTargetActor().SetAlpha (0.0,True)
		endif
		utility.wait(fDelay)     
		GetTargetActor().AttachAshPile(AshPileObject)
		utility.wait(fDelayEnd)
		if	MagicEffectShader != none
			MagicEffectShader.stop(GetTargetActor())
		endif
		if bSetAlphaZero == True
			GetTargetActor().SetAlpha (0.0,True)
		endif
		GetTargetActor().SetCriticalStage(GetTargetActor().CritStage_DisintegrateEnd)
endFunction

Event OnEffectStart(actor akTarget, actor akCaster)
	Float UWMult = 1.0
	If akCaster.HasPerk(DLC1UnearthlyWill)
		UWMult = 0.67
	Endif
	CostTotal = CostBase*ET_PowerCostMult.GetValue()*UWMult
	If akCaster.HasMagicEffect(ET_PowerMagicMSUndyingGluttonyME)
		;Debug.Notification("This spell cannot be cast again while its effects still linger!")
		ET_PowerFailUndyingGluttonyEffectMSG.Show()
		Self.Dispel()
	Elseif ET_VampireBloodPoolCurrent.GetValue() < CostTotal
		;Debug.Notification("I do not have enough blood to perform this ritual!")
		RiteFailMSG.Show()
		Self.Dispel()
	Elseif !akTarget.HasKeyword(ActorTypeNPC)
		;Debug.Notification("Only humanoids can be subject to this rite!")
		ET_PowerFailUndyingGluttonyHumanoidMSG.Show()
		Self.Dispel()
	Else
		If DLC1VampireLevitateStateGlobal.Value > 0
			akCaster.PlayIdleWithTarget(FeedVLIdle, akTarget)
		Else
			akCaster.PlayIdleWithTarget(FeedNormalIdle, akTarget)
		Endif
		utility.wait(1.0)
		ET_PowerMagicMSBUndyingGluttony.Cast(akTarget, akCaster)
		utility.wait(1.0)
		akTarget.KillEssential(akCaster)
	Endif
Endevent

Event OnDying(Actor Killer)
	TurnToAsh()
EndEvent

Keyword Property ActorTypeNPC Auto
Idle Property FeedNormalIdle Auto
Idle Property FeedVLIdle Auto
GlobalVariable Property DLC1VampireLevitateStateGlobal Auto
MagicEffect Property ET_PowerMagicMSUndyingGluttonyME Auto
GlobalVariable Property ET_VampireBloodPoolCurrent  Auto  
GlobalVariable Property ET_PowerCostMult  Auto  
Message Property RiteFailMSG Auto
Message Property ET_PowerFailUndyingGluttonyEffectMSG Auto
Message Property ET_PowerFailUndyingGluttonyHumanoidMSG Auto
Perk Property DLC1UnearthlyWill Auto
Float Property CostBase Auto
Float Property CostTotal Auto
SPELL Property ET_PowerMagicMSBUndyingGluttony Auto
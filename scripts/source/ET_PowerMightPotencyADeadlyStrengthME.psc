Scriptname ET_PowerMightPotencyADeadlyStrengthME extends ActiveMagicEffect  

Event OnEffectStart(Actor akTarget, Actor akCaster)
	JumpBon = ET_Age.Value*35
	Game.SetGameSettingFloat("fJumpHeightMin", 76+JumpBon)
Endevent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	Game.SetGameSettingFloat("fJumpHeightMin", 76)
Endevent

Event OnPlayerLoadGame()
	JumpBon = ET_Age.Value*35
	Game.SetGameSettingFloat("fJumpHeightMin",76+JumpBon)
EndEvent

GlobalVariable Property ET_Age Auto
Float Property JumpBon Auto
Scriptname ET_PowerSelectionMenuSCR extends ActiveMagicEffect  

Function ET_debug_trace(string msg)
	Debug.Trace("DEBUG: Everdamned: " + msg)
EndFunction


Function ET_debug_trace_toggleable(string msg, bool IsOn)
	if IsOn
		Debug.Trace("DEBUG: Everdamned: " + msg)
	endif
EndFunction


Event OnEffectStart(Actor akTarget, Actor akCaster)

	bool Done = FALSE
	while (Done == FALSE)
		ET_debug_trace("Offering main menu")
		int buttonMain = MainMSG.Show(ET_ExpPoints.GetValueInt())
		ET_debug_trace("buttonMain is: " + buttonMain)
		if buttonMain == 3
			ET_debug_trace("Exiting from main menu")
			Done = TRUE
		else
			Message CategoryMSG = CategoryMsgFL.GetAt(buttonMain) as Message
			int buttonCategory = CategoryMSG.Show()
			ET_debug_trace("buttonCategory is: " + buttonMain)
			if buttonCategory == 4
				ET_debug_trace("Exiting from category menu")
				Done = TRUE
			elseif buttonCategory == 3
				ET_debug_trace("Returning to main menu")
				;return to main menu
			else
				Formlist SubCategoryMessageFL = MainNavMsgFL.GetAt(buttonMain) as Formlist
				Message SubCategoryMSG = SubCategoryMessageFL.GetAt(buttonCategory) as Message
				int buttonSubCategory = SubCategoryMSG.Show()
				ET_debug_trace("buttonCategory is: " + buttonMain)
				if buttonSubCategory == 9
					ET_debug_trace("Exiting from subcategory menu")
					Done = TRUE
				elseif buttonSubCategory == 8
					ET_debug_trace("Returning to main menu")
					;return to main menu
				else
					Formlist SubCategoryNavMessageFL = MainNavFL.GetAt(buttonMain) as Formlist
					Formlist PowerMessageFL = SubCategoryNavMessageFL.GetAt(buttonCategory) as Formlist
					Message PowerMSG = PowerMessageFL.GetAt(buttonSubCategory) as Message
					int buttonPower = PowerMSG.Show(ET_ExpPoints.GetValueInt())
					ET_debug_trace("buttonPower is: " + buttonMain)
					if buttonPower == 3
						ET_debug_trace("Exiting from power menu")
						Done = TRUE
					elseif buttonPower == 2
						ET_debug_trace("Returning to main menu")
						;return to main menu
					elseif buttonPower == 1
						ET_debug_trace("You do not have enough points available to unlock this power!")
						;Debug.MessageBox("You do not have enough points available to unlock this power!")
						mslVTPSMenuNoPointsMSG.Show()
					elseif buttonPower == 0
						Formlist SpellCategoryFL = SpellMainFL.GetAt(buttonMain) as Formlist
						Formlist SpellFL = SpellCategoryFL.GetAt(buttonCategory) as Formlist
						Spell SelectedSpell = SpellFL.GetAt(buttonSubCategory) as Spell
						
						;if LevelAFL.HasForm(PowerSP)
						;	ET_ExpPoints.Mod(-1)
						;	Game.GetPlayer().AddSpell(PowerSP)
						;elseif LevelBFL.HasForm(PowerSP)
						;	ET_ExpPoints.Mod(-2)
						;	Game.GetPlayer().AddSpell(PowerSP)
						;elseif LevelCFL.HasForm(PowerSP)
						;	ET_ExpPoints.Mod(-3)
						;	Game.GetPlayer().AddSpell(PowerSP)
						;endif
						
						ET_ExpPoints.Mod(-1)
						Game.GetPlayer().AddSpell(SelectedSpell)
						Done = TRUE
						Debug.Notification("You have gained a new power!")
						ET_PowerSelectionMenuGainMSG.Show()
						PowerLearnedSM.Play(akTarget)
					endif
				endif
			endif
		endif
	endwhile

Endevent



Formlist Property CategoryMsgFL Auto
Formlist Property MainNavMsgFL Auto
Formlist Property MainNavFL Auto
Formlist Property SpellMainFL Auto
Formlist Property LevelAFL Auto
Formlist Property LevelBFL Auto
Formlist Property LevelCFL Auto

Message Property MainMSG Auto
Message Property ET_PowerSelectionMenuGainMSG Auto
Message Property mslVTPSMenuNoPointsMSG Auto

GlobalVariable Property ET_ExpPoints Auto

Sound Property PowerLearnedSM Auto

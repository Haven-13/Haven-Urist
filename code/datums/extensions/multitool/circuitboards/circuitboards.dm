/datum/extension/interactive/multitool/circuitboards/extension_status(mob/user)
	if(is_ai(user)) // No remote AI access
		return UI_CLOSE

	return ..()

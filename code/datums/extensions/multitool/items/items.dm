/datum/extension/interactive/multitool/items/extension_status(mob/user)
	if(is_ai(user)) // No remote AI access
		return UI_CLOSE

	return ..()

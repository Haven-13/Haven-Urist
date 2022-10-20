/datum/extension/interactive/multitool/items/extension_status(var/mob/user)
	if(is_ai(user)) // No remote AI access
		return UI_CLOSE

	return ..()

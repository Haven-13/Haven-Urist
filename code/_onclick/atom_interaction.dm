/atom/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(!CanInteract(user, state))
		. = min(., UI_UPDATE)

/atom/proc/interact(mob/user)
	// todo add boolean/flag for fingerprints
	add_fingerprint(user)
	// todo add boolean/flag for UI-interaction
	return ui_interact(user)
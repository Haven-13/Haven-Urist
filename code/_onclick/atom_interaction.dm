/atom/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(!CanInteract(user, state))
		. = min(., UI_UPDATE)

/atom/proc/attack_hand(mob/user as mob)
	return interact(user)

/atom/proc/interact(mob/user)
	// todo add boolean/flag for fingerprints
	if (src.Adjacent(user))
		src.add_fingerprint(user)
	// todo add boolean/flag for UI-interaction
	return ui_interact(user)

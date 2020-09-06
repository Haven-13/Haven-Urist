/*
 * public
 *
 *
 *
 * Source: Baystation 12 code
 */
/datum/proc/ui_container()
	return src

/datum/proc/CanUseTopic(mob/user, /datum/ui_state/state = ui_default_state())
	var/datum/src_object = ui_host()
	return state.can_use_topic(src_object, user)

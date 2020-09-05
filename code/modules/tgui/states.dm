<<<<<<< HEAD
 /**
  * tgui states
  *
  * Base state and helpers for states. Just does some sanity checks, implement a state for in-depth checks.
 **/
=======
/**
 * Base state and helpers for states. Just does some sanity checks,
 * implement a proper state for in-depth checks.
 *
 * Copyright (c) 2020 Aleksej Komarov
 * SPDX-License-Identifier: MIT
 */
>>>>>>> 0cf00a2... tgui 4.0 (#52085)

 /**
  * public
  *
  * Checks the UI state for a mob.
  *
  * required user mob The mob who opened/is using the UI.
  * required state datum/ui_state The state to check.
  *
  * return UI_state The state of the UI.
 **/
/datum/proc/ui_status(mob/user, datum/ui_state/state)
	var/datum/src_object = ui_host()
	if(src_object != src)
		return src_object.ui_status(user, state)

<<<<<<< HEAD
	if(isghost(user)) // Special-case ghosts.
		if(user.can_admin_interact())
			return UI_INTERACTIVE // If they turn it on, admins can interact.
		if(get_dist(src_object, src) < user.client.view)
			return UI_UPDATE // Regular ghosts can only view.
		return UI_CLOSE // To keep too many UIs from being opened.
	return state.can_use_topic(src_object, user) // Check if the state allows interaction.
=======
		// Regular ghosts can always at least view if in range.
		if(user.client)
			var/clientviewlist = getviewsize(user.client.view)
			if(get_dist(src_object, user) < max(clientviewlist[1], clientviewlist[2]))
				. = max(., UI_UPDATE)
>>>>>>> 0cf00a2... tgui 4.0 (#52085)

 /**
  * private
  *
  * Checks if a user can use src_object's UI, and returns the state.
  * Can call a mob proc, which allows overrides for each mob.
  *
  * required src_object datum The object/datum which owns the UI.
  * required user mob The mob who opened/is using the UI.
  *
  * return UI_state The state of the UI.
 **/
/datum/ui_state/proc/can_use_topic(src_object, mob/user)
	// Don't allow interaction by default.
	return UI_CLOSE

 /**
  * public
  *
  * Standard interaction/sanity checks. Different mob types may have overrides.
  *
  * return UI_state The state of the UI.
 **/
/mob/proc/shared_ui_interaction(src_object)
	// Close UIs if mindless.
	if(!client)
		return UI_CLOSE
	// Disable UIs if unconcious.
	else if(stat)
		return UI_DISABLED
<<<<<<< HEAD
	else if(incapacitated() || lying) // Update UIs if incapicitated but concious.
=======
	// Update UIs if incapicitated but concious.
	else if(incapacitated())
>>>>>>> 0cf00a2... tgui 4.0 (#52085)
		return UI_UPDATE
	return UI_INTERACTIVE

/mob/living/silicon/ai/shared_ui_interaction(src_object)
<<<<<<< HEAD
	if(!has_power()) // Disable UIs if the AI is unpowered.
=======
	// Disable UIs if the AI is unpowered.
	if(lacks_power())
>>>>>>> 0cf00a2... tgui 4.0 (#52085)
		return UI_DISABLED
	return ..()

/mob/living/silicon/robot/shared_ui_interaction(src_object)
<<<<<<< HEAD
	if(cell.charge <= 0 || lockcharge) // Disable UIs if the Borg is unpowered or locked.
=======
	// Disable UIs if the Borg is unpowered or locked.
	if(!cell || cell.charge <= 0 || lockcharge)
>>>>>>> 0cf00a2... tgui 4.0 (#52085)
		return UI_DISABLED
	return ..()

/**
  * public
  *
  * Check the distance for a living mob.
  * Really only used for checks outside the context of a mob.
  * Otherwise, use shared_living_ui_distance().
  *
  * required src_object The object which owns the UI.
  * required user mob The mob who opened/is using the UI.
  *
  * return UI_state The state of the UI.
 **/
/atom/proc/contents_ui_distance(src_object, mob/living/user)
	// Just call this mob's check.
	return user.shared_living_ui_distance(src_object)

<<<<<<< HEAD
 /**
  * public
  *
  * Distance versus interaction check.
  *
  * required src_object atom/movable The object which owns the UI.
  *
  * return UI_state The state of the UI.
 **/
/mob/living/proc/shared_living_ui_distance(atom/movable/src_object)
	if(!(src_object in view(src))) // If the object is obscured, close it.
=======
/**
 * public
 *
 * Distance versus interaction check.
 *
 * required src_object atom/movable The object which owns the UI.
 *
 * return UI_state The state of the UI.
 */
/mob/living/proc/shared_living_ui_distance(atom/movable/src_object, viewcheck = TRUE)
	// If the object is obscured, close it.
	if(viewcheck && !(src_object in view(src)))
>>>>>>> 0cf00a2... tgui 4.0 (#52085)
		return UI_CLOSE
	var/dist = get_dist(src_object, src)
	// Open and interact if 1-0 tiles away.
	if(dist <= 1)
		return UI_INTERACTIVE
	// View only if 2-3 tiles away.
	else if(dist <= 2)
		return UI_UPDATE
	// Disable if 5 tiles away.
	else if(dist <= 5)
		return UI_DISABLED
	// Otherwise, we got nothing.
	return UI_CLOSE

/mob/living/carbon/human/shared_living_ui_distance(atom/movable/src_object)
	if((TK in mutations))
		return UI_INTERACTIVE
	return ..()

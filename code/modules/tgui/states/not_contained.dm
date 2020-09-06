/**
 * tgui state: not_contained_state
 *
 * Checks that the user is not inside src_object, and then makes the
 * default checks.
 *
 * Copyright (c) 2020 Aleksej Komarov
 * SPDX-License-Identifier: MIT
 */

GLOBAL_DATUM_INIT(tgui_not_contained_state, /datum/ui_state/not_contained_state, new)

/datum/ui_state/not_contained_state/can_use_topic(atom/src_object, mob/user)
	. = user.shared_ui_interaction(src_object)
	if(. > UI_CLOSE)
		return min(., user.tgui_not_contained_can_use_topic(src_object))

/mob/proc/tgui_not_contained_can_use_topic(src_object)
	return UI_CLOSE

/mob/living/tgui_not_contained_can_use_topic(atom/src_object)
	if(src_object.contains(src))
		return UI_CLOSE // Close if we're inside it.
	return tgui_default_can_use_topic(src_object)

/mob/living/silicon/tgui_not_contained_can_use_topic(src_object)
	return tgui_default_can_use_topic(src_object) // Silicons use default bevhavior.

/mob/living/simple_animal/drone/tgui_not_contained_can_use_topic(src_object)
	return tgui_default_can_use_topic(src_object) // Drones use default bevhavior.

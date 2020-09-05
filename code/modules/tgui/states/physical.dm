<<<<<<< HEAD
 /**
  * tgui state: physical_state
  *
  * Short-circuits the default state to only check physical distance.
 **/
=======
/**
 * tgui state: physical_state
 *
 * Short-circuits the default state to only check physical distance.
 *
 * Copyright (c) 2020 Aleksej Komarov
 * SPDX-License-Identifier: MIT
 */
>>>>>>> 0cf00a2... tgui 4.0 (#52085)

/var/global/datum/ui_state/physical/tg_physical_state = new()

/datum/ui_state/physical/can_use_topic(src_object, mob/user)
	. = user.shared_ui_interaction(src_object)
	if(. > UI_CLOSE)
		return min(., user.physical_can_use_topic(src_object))

/mob/proc/physical_can_use_topic(src_object)
	return UI_CLOSE

/mob/living/physical_can_use_topic(src_object)
	return shared_living_ui_distance(src_object)

/mob/living/silicon/physical_can_use_topic(src_object)
	return max(UI_UPDATE, shared_living_ui_distance(src_object)) // Silicons can always see.

/mob/living/silicon/ai/physical_can_use_topic(src_object)
	return UI_UPDATE // AIs are not physical.

<<<<<<< HEAD
 /**
  * tgui state: contained_state
  *
  * Checks that the user is inside the src_object.
 **/
=======
/**
 * tgui state: contained_state
 *
 * Checks that the user is inside the src_object.
 *
 * Copyright (c) 2020 Aleksej Komarov
 * SPDX-License-Identifier: MIT
 */
>>>>>>> 0cf00a2... tgui 4.0 (#52085)

/var/global/datum/ui_state/contained_state/tg_contained_state = new()

/datum/ui_state/contained_state/can_use_topic(atom/src_object, mob/user)
	if(!src_object.contains(user))
		return UI_CLOSE
	return user.shared_ui_interaction(src_object)

<<<<<<< HEAD
 /**
  * tgui state: self_state
  *
  * Only checks that the user and src_object are the same.
 **/
=======
/**
 * tgui state: self_state
 *
 * Only checks that the user and src_object are the same.
 *
 * Copyright (c) 2020 Aleksej Komarov
 * SPDX-License-Identifier: MIT
 */
>>>>>>> 0cf00a2... tgui 4.0 (#52085)

/var/global/datum/ui_state/self_state/tg_self_state = new()

/datum/ui_state/self_state/can_use_topic(src_object, mob/user)
	if(src_object != user)
		return UI_CLOSE
	return user.shared_ui_interaction(src_object)

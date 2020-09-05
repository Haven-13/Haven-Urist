<<<<<<< HEAD
 /**
  * tgui state: conscious_state
  *
  * Only checks if the user is conscious.
 **/
=======
/**
 * tgui state: conscious_state
 *
 * Only checks if the user is conscious.
 *
 * Copyright (c) 2020 Aleksej Komarov
 * SPDX-License-Identifier: MIT
 */
>>>>>>> 0cf00a2... tgui 4.0 (#52085)

/var/global/datum/ui_state/conscious_state/tg_conscious_state = new()

/datum/ui_state/conscious_state/can_use_topic(src_object, mob/user)
	if(user.stat == CONSCIOUS)
		return UI_INTERACTIVE
	return UI_CLOSE

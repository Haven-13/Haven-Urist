<<<<<<< HEAD
 /**
  * tgui state: admin_state
  *
  * Checks that the user is an admin, end-of-story.
 **/
=======
/**
 * tgui state: admin_state
 *
 * Checks that the user is an admin, end-of-story.
 *
 * Copyright (c) 2020 Aleksej Komarov
 * SPDX-License-Identifier: MIT
 */
>>>>>>> 0cf00a2... tgui 4.0 (#52085)

/var/global/datum/ui_state/admin_state/tg_admin_state = new()

/datum/ui_state/admin_state/can_use_topic(src_object, mob/user)
	if(check_rights(R_ADMIN, 0, user))
		return UI_INTERACTIVE
	return UI_CLOSE

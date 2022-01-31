/*!
 * Copyright (c) 2022 Martin Lyrå
 * SPDX-License-Identifier: MIT
 */

/**
 * tgui state: silicon_only_state
 *
 * Checks that the user is an silicon mob, ghosts are allowed to view
 */
GLOBAL_DATUM_INIT(silicon_only_state, /datum/ui_state/silicon_only, new)

/datum/ui_state/silicon_only/can_use_topic(src_object, mob/user)
	if (isobserver(user))
		return is_admin(user) ? UI_INTERACTIVE : UI_UPDATE
	if (issilicon(user))
		return user.default_can_use_topic(src_object)
	return UI_CLOSE

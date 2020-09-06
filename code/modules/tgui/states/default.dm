/**
 * tgui state: default_state
 *
 * Checks a number of things -- mostly physical distance for humans
 * and view for robots.
 *
 * Copyright (c) 2020 Aleksej Komarov
 * SPDX-License-Identifier: MIT
 */

GLOBAL_DATUM_INIT(tgui_default_state, /datum/ui_state/default, new)

/datum/ui_state/default/can_use_topic(src_object, mob/user)
	return user.tgui_default_can_use_topic(src_object) // Call the individual mob-overriden procs.

/mob/proc/tgui_default_can_use_topic(src_object)
	return UI_CLOSE // Don't allow interaction by default.

/mob/living/tgui_default_can_use_topic(src_object)
	. = shared_ui_interaction(src_object)
	if(. > UI_CLOSE && loc)
		. = min(., loc.contents_ui_distance(src_object, src)) // Check the distance...
	if(. == UI_INTERACTIVE) // Non-human living mobs can only look, not touch.
		return UI_UPDATE

/mob/living/carbon/human/tgui_default_can_use_topic(src_object)
	. = shared_ui_interaction(src_object)
	if(. > UI_CLOSE)
		. = min(., shared_living_ui_distance(src_object)) // Check the distance...
		// Derp a bit if we have brain loss.
		if(prob(getBrainLoss()))
			return UI_UPDATE

/mob/living/silicon/robot/tgui_default_can_use_topic(src_object)
	. = shared_ui_interaction(src_object)
	if(. <= UI_DISABLED)
		return

	// Robots can interact with anything they can see.
	if(get_dist(src, src_object) <= client.view)
		return UI_INTERACTIVE
	return UI_DISABLED // Otherwise they can keep the UI open.

/mob/living/silicon/ai/tgui_default_can_use_topic(src_object)
	. = shared_ui_interaction(src_object)
	if(. < UI_INTERACTIVE)
		return

	// The AI can interact with anything it can see nearby, or with cameras while wireless control is enabled.
	if(!control_disabled && can_see(src_object))
		return UI_INTERACTIVE
	return UI_CLOSE

/mob/living/simple_animal/tgui_default_can_use_topic(src_object)
	. = shared_ui_interaction(src_object)
	if(. > UI_CLOSE)
		. = min(., shared_living_ui_distance(src_object)) //simple animals can only use things they're near.
	else
		return ..()

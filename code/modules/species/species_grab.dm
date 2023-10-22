/datum/species/proc/attempt_grab(mob/living/carbon/human/grabber, atom/movable/target, grab_type)
	grabber.visible_message("<span class='danger'>[grabber] attempted to grab \the [target]!</span>")
	return grabber.make_grab(grabber, target, grab_type)

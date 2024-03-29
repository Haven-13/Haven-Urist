/datum/proc/extra_ghost_link(prefix, sufix, short_links)
	return list()

/atom/movable/extra_ghost_link(atom/ghost, prefix, sufix, short_links)
	if(src == ghost)
		return list()
	return list(create_ghost_link(ghost, src, short_links ? "F" : "Follow", prefix, sufix))

/client/extra_ghost_link(atom/ghost, prefix, sufix, short_links)
	return mob.extra_ghost_link(ghost, prefix, sufix, short_links)

/mob/extra_ghost_link(atom/ghost, prefix, sufix, short_links)
	. = ..()
	if(client && eyeobj)
		. += create_ghost_link(ghost, eyeobj, short_links ? "E" : "Eye", prefix, sufix)

/mob/observer/ghost/extra_ghost_link(atom/ghost, prefix, sufix, short_links)
	. = ..()
	if(mind && (mind.current && !is_ghost(mind.current)))
		. += create_ghost_link(ghost, mind.current, short_links ? "B" : "Body", prefix, sufix)

/proc/create_ghost_link(ghost, target, text, prefix, sufix)
	return "<a href='byond://?src=[REF(ghost)];track=[REF(target)]'>[prefix][text][sufix]</a>"

/datum/proc/get_ghost_follow_link(atom/target, delimiter, prefix, sufix)
	return

/client/get_ghost_follow_link(atom/target, delimiter, prefix, sufix)
	return mob.get_ghost_follow_link(target, delimiter, prefix, sufix)

/mob/observer/ghost/get_ghost_follow_link(atom/target, delimiter, prefix, sufix)
	var/short_links = get_preference_value(/datum/client_preference/ghost_follow_link_length) == GLOB.PREF_SHORT
	return ghost_follow_link(target, src, delimiter, prefix, sufix, short_links)

/proc/ghost_follow_link(atom/target, atom/ghost, delimiter = "|", prefix = "", sufix = "", short_links = TRUE)
	if((!target) || (!ghost)) return
	return jointext(target.extra_ghost_link(ghost, prefix, sufix, short_links),delimiter)

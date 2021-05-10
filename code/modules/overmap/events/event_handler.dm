/var/decl/overmap_event_handler/overmap_event_handler = new()

/decl/overmap_event_handler
	var/list/event_turfs_by_z_level

/decl/overmap_event_handler/New()
	..()
	event_turfs_by_z_level = list()

/decl/overmap_event_handler/proc/bind_event_to(datum/overmap_event/E, turf/target)
	GLOB.entered_event.register(target, src, /decl/overmap_event_handler/proc/on_turf_entered)
	GLOB.exited_event.register(target, src, /decl/overmap_event_handler/proc/on_turf_exited)

	var/obj/effect/overmap_event/event = new(target)
	event.SetName(E.name)
	event.icon_state = pick(E.event_icon_states)
	event.opacity =  E.opacity
	event.color = E.icon_color

/decl/overmap_event_handler/proc/get_event_turfs_by_z_level(var/z_level)
	var/z_level_text = num2text(z_level)
	. = event_turfs_by_z_level[z_level_text]
	if(!.)
		. = list()
		event_turfs_by_z_level[z_level_text] = .

/decl/overmap_event_handler/proc/on_turf_exited(var/turf/old_loc, var/obj/effect/overmap/ship/entering_ship, var/new_loc)
	if(!istype(entering_ship))
		return
	if(new_loc == old_loc)
		return

	var/list/events_by_turf = get_event_turfs_by_z_level(old_loc.z)
	var/datum/overmap_event/old_event = events_by_turf[old_loc]
	var/datum/overmap_event/new_event = events_by_turf[new_loc]

	if(old_event == new_event)
		return
	if(old_event)
		if(new_event && old_event.difficulty == new_event.difficulty && old_event.event == new_event.event)
			return
		old_event.leave(entering_ship)

/decl/overmap_event_handler/proc/on_turf_entered(var/turf/new_loc, var/obj/effect/overmap/ship/entering_ship, var/old_loc)
	if(!istype(entering_ship))
		return
	if(new_loc == old_loc)
		return

	var/list/events_by_turf = get_event_turfs_by_z_level(new_loc.z)
	var/datum/overmap_event/old_event = events_by_turf[old_loc]
	var/datum/overmap_event/new_event = events_by_turf[new_loc]

	if(old_event == new_event)
		return
	if(new_event)
		if(old_event && old_event.difficulty == new_event.difficulty && initial(old_event.event) == initial(new_event.event))
			return
		new_event.enter(entering_ship)

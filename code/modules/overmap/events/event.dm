// We don't subtype /obj/effect/overmap because that'll create sections one can travel to
//  And with them "existing" on the overmap Z-level things quickly get odd.
/obj/effect/overmap_event
	name = "event"
	icon = 'resources/icons/obj/overmap.dmi'
	icon_state = "event"
	opacity = 1

/obj/effect/overmap_event/New(turf/T, datum/overmap_event/E)
	..()
	src.loc = T
	SetName(E.name)
	icon_state = pick(E.event_icon_states)
	opacity =  E.opacity
	color = E.icon_color

/obj/effect/overmap_event/Initialize()
	SHOULD_CALL_PARENT(FALSE)
	atom_flags |= ATOM_FLAG_INITIALIZED
	return INITIALIZE_HINT_NORMAL

/datum/overmap_event
	var/name = "map event"
	var/radius = 2
	var/count = 6
	var/event = null
	var/list/event_icon_states = list("event")
	var/icon_color = ""
	var/opacity = 1
	var/difficulty = EVENT_LEVEL_MODERATE
	var/list/victims
	var/continuous = TRUE //if it should form continous blob, or can have gaps

/datum/overmap_event/proc/enter(obj/effect/overmap/ship/victim)
	if(victim in victims)
		log_error("Multiple attempts to trigger the same event by [victim] detected.")
		return
	LAZY_ADD(victims, victim)
	var/datum/event_meta/EM = new(difficulty, "Overmap event - [name]", event, add_to_queue = FALSE, is_one_shot = TRUE)
	var/datum/event/E = new event(EM)
	E.startWhen = 0
	E.endWhen = INFINITY
	E.affecting_z = victim.map_z
	victims[victim] = E

/datum/overmap_event/proc/leave(victim)
	if(victims && victims[victim])
		var/datum/event/E = victims[victim]
		E.kill()
		LAZY_REMOVE(victims, victim)

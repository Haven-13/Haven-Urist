
/datum/overmap_event/meteor
	name = "asteroid field"
	event = /datum/event/meteor_wave/overmap
	icon_color = "#cc5474"
	count = 15
	radius = 4
	continuous = FALSE
	event_icon_states = list("meteor1", "meteor2", "meteor3", "meteor4")
	difficulty = EVENT_LEVEL_MAJOR

/datum/overmap_event/meteor/enter(var/obj/effect/overmap/ship/victim)
	..()
	if(victims[victim])
		var/datum/event/meteor_wave/overmap/E = victims[victim]
		E.victim = victim

/datum/overmap_event/electric
	name = "electrical storm"
	event = /datum/event/electrical_storm
	icon_color = "#e8da5f"
	count = 11
	radius = 3
	opacity = 0
	event_icon_states = list("electrical1", "electrical2", "electrical3", "electrical4")
	difficulty = EVENT_LEVEL_MAJOR

/datum/overmap_event/dust
	name = "dust cloud"
	event = /datum/event/dust
	icon_color = "#ada89e"
	count = 16
	radius = 4
	event_icon_states = list("dust1", "dust2", "dust3", "dust4")

/datum/overmap_event/ion
	name = "ion cloud"
	event = /datum/event/ionstorm/overmap
	icon_color = "#85f5ff"
	count = 8
	radius = 3
	opacity = 0
	event_icon_states = list("ion1", "ion2", "ion3", "ion4")
	difficulty = EVENT_LEVEL_MAJOR

/datum/overmap_event/carp
	name = "carp shoal"
	event = /datum/event/carp_migration
	icon_color = "#bc85ff"
	count = 8
	radius = 3
	opacity = 0
	difficulty = EVENT_LEVEL_MODERATE
	continuous = FALSE
	event_icon_states = list("carp1", "carp2")

/datum/overmap_event/carp/major
	name = "carp school"
	count = 5
	radius = 4
	difficulty = EVENT_LEVEL_MAJOR
	event_icon_states = list("carp3", "carp4")

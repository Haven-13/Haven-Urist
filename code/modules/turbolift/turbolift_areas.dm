// Used for creating the exchange areas.

/var/list/area/turbolift_areas = list()

/area/turbolift
	name = "Turbolift"
	base_turf = /turf/simulated/open
	requires_power = 0
	sound_env = SMALL_ENCLOSED

	var/lift_floor_label = null
	var/lift_floor_name = null
	var/lift_announce_str = "Ding!"
	var/arrival_sound = 'resources/sound/machines/ding.ogg'

/area/turbolift/New()
	SHOULD_CALL_PARENT(TRUE)
	. = ..()
	if (!(src.type in turbolift_areas))
		turbolift_areas[src.type] = list(x,y,z)

/datum/map/tyclo_pluto/setup_map()
	..()
	system_name = generate_system_name()
	minor_announcement = new(new_sound = sound('sound/AI/commandreport.ogg', volume = 45))

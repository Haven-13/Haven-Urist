// Hey! Listen! Update \config\away_site_blacklist.txt with your new ruins!

/datum/map_template/ruin/away_site
	var/spawn_weight = 1
	var/list/generate_mining_by_z
	prefix = "resources/maps/away/"

/datum/map_template/ruin/away_site/after_load(z)
	var/current_z
	if(!is_list(generate_mining_by_z))
		generate_mining_by_z = list(generate_mining_by_z)

	for(var/i in generate_mining_by_z)
		current_z = z + i - 1
		testing("Generating mining caves for z-level [current_z]")
		new /datum/random_map/automata/cave_system(null, 1, 1, current_z, world.maxx, world.maxy)
		new /datum/random_map/noise/ore(null, 1, 1, current_z, world.maxx, world.maxy)
		GLOB.using_map.refresh_mining_turfs(current_z)

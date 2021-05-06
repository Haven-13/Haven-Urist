var/image/static_starlights = list()

/proc/_create_static_starlight(zlevel)
	var/image/I = image('icons/primitives.dmi', icon_state = "white")
	I.plane = calculate_plane(zlevel, LIGHTING_PLANE)
	I.layer = LIGHTING_LAYER - 1
	I.opacity = 0.2
	I.color = SSskybox.BGcolor
	I.blend_mode = BLEND_ADD
	I.invisibility = INVISIBILITY_LIGHTING
	return I

/turf/space/update_starlight()
	if(!config.starlight)
		return
	else if (config.starlight == 2)
		src.dynamic_lighting = TRUE
		src.luminosity = 1

	if(locate(/turf/simulated) in orange(src,1))
		set_light(0.2, 1, 3, l_color = SSskybox.BGcolor)
	else
		set_light(0)

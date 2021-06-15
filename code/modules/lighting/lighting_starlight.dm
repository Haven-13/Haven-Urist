/turf/space/update_starlight()
	if(!config.starlight)
		return
	switch(config.starlight)
		if (2)
			src.dynamic_lighting = TRUE
			src.luminosity = 1
		if (1)
			if(locate(/turf/simulated) in orange(src,1))
				set_light(0.2, 1, 3, l_color = SSskybox.BGcolor)
			else
				set_light(0)

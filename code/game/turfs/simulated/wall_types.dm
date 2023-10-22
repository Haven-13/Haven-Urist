/turf/simulated/wall/r_wall
	icon_state = "rgeneric"

/turf/simulated/wall/r_wall/New(newloc)
	..(newloc, "plasteel","plasteel") //3strong

/turf/simulated/wall/ocp_wall
	icon_state = "rgeneric"

/turf/simulated/wall/ocp_wall/New(newloc)
	..(newloc, "osmium-carbide plasteel", "osmium-carbide plasteel")
/turf/simulated/wall/r_titanium
	icon_state = "rgeneric"
/turf/simulated/wall/r_titanium/New(newloc)
	..(newloc,"titanium", "titanium")

/turf/simulated/wall/r_wall/rglass_wall/New(newloc)
	..(newloc, "rglass", "steel")
	icon_state = "rgeneric"

/turf/simulated/wall/r_wall/hull
	name = "hull"
	color = COLOR_HULL

/turf/simulated/wall/prepainted
	paint_color = COLOR_GUNMETAL
/turf/simulated/wall/r_wall/prepainted
	paint_color = COLOR_GUNMETAL

/turf/simulated/wall/r_wall/hull/Initialize()
	. = ..()
	paint_color = color
	color = null //color is just for mapping
	if(prob(40))
		var/spacefacing = FALSE
		for(var/direction in GLOB.cardinal)
			var/turf/T = get_step(src, direction)
			var/area/A = get_area(T)
			if(A && (A.area_flags & AREA_FLAG_EXTERNAL))
				spacefacing = TRUE
				break
		if(spacefacing)
			var/bleach_factor = rand(10,50)
			paint_color = adjust_brightness(paint_color, bleach_factor)
	update_icon()

/turf/simulated/wall/iron/New(newloc)
	..(newloc,"iron")

/turf/simulated/wall/uranium/New(newloc)
	..(newloc,"uranium")

/turf/simulated/wall/diamond/New(newloc)
	..(newloc,"diamond")

/turf/simulated/wall/gold/New(newloc)
	..(newloc,"gold")

/turf/simulated/wall/silver/New(newloc)
	..(newloc,"silver")

/turf/simulated/wall/phoron/New(newloc)
	..(newloc,"phoron")

/turf/simulated/wall/sandstone/New(newloc)
	..(newloc,"sandstone")

/turf/simulated/wall/wood/New(newloc)
	..(newloc,"wood")

/turf/simulated/wall/ironphoron/New(newloc)
	..(newloc,"iron","phoron")

/turf/simulated/wall/golddiamond/New(newloc)
	..(newloc,"gold","diamond")

/turf/simulated/wall/silvergold/New(newloc)
	..(newloc,"silver","gold")

/turf/simulated/wall/sandstonediamond/New(newloc)
	..(newloc,"sandstone","diamond")


// Kind of wondering if this is going to bite me in the butt.
/turf/simulated/wall/voxshuttle/New(newloc)
	..(newloc,"voxalloy")
/turf/simulated/wall/voxshuttle/attackby()
	return
/turf/simulated/wall/titanium/New(newloc)
	..(newloc,"titanium")

/turf/simulated/wall/alium
	icon_state = "jaggy"
	floor_type = /turf/simulated/floor/fixed/alium
	blend_objects = newlist()

/turf/simulated/wall/alium/New(newloc)
	..(newloc,"aliumium")

/turf/simulated/wall/alium/ex_act(severity)
	if(prob(explosion_resistance))
		return
	..()

/turf/simulated/wall/crystal/New(newloc)
	..(newloc,"crystal")

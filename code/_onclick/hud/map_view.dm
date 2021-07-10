/atom/movable/map_view
	var/assigned_map
	var/list/obj/screen/plane_master/plane_master_cache = list()
	var/list/obj/screen/openspace_overlay/openspace_overlay_cache = list()

	var/list/active_planes = list()
	var/list/active_overlays = list()

/atom/movable/map_view/Destroy()
	. = ..()
	QDEL_NULL_ASSOC_LIST(plane_master_cache)
	QDEL_NULL_ASSOC_LIST(openspace_overlay_cache)
	QDEL_NULL_ASSOC_LIST(active_planes)
	QDEL_NULL_ASSOC_LIST(active_overlays)

/atom/movable/map_view/proc/update_map_view(var/z_depth)
	active_planes.Cut()
	active_overlays.Cut()

	for(var/idx in 1 to z_depth)
		for(var/mytype in subtypesof(/obj/screen/plane_master))
			var/key = "[idx]-[mytype]"
			if(!plane_master_cache.Find(key))
				var/obj/screen/plane_master/instance = new mytype()
				instance.update_screen_plane(idx)
				if(assigned_map)
					instance.screen_loc = "[assigned_map]:CENTER"
				plane_master_cache[key] = instance
			active_planes[key] += plane_master_cache[key]

		var/z_delta = z_depth - idx // How far away from top are we?
		if (z_delta)
			for (var/pidx in multiz_rendering_planes())
				var/key = "[idx]-[pidx]"
				if(!openspace_overlay_cache.Find(key))
					var/obj/screen/openspace_overlay/oover = new
					oover.plane = calculate_plane(idx, pidx)
					oover.alpha = min(255,z_delta*60 + 30)
					if(assigned_map)
						oover.screen_loc = "[assigned_map]:CENTER"
					openspace_overlay_cache[key] = oover
				active_overlays[key] += openspace_overlay_cache[key]

/atom/movable/map_view/proc/add_all_active(var/mob/mymob)
	if(!mymob.client)
		return

	for(var/key in active_planes)
		var/obj/screen/plane_master/PM = active_planes[key]
		mymob.client.screen += PM
		PM.backdrop(mymob)

	for(var/key in active_overlays)
		var/obj/screen/openspace_overlay/OO = active_overlays[key]
		mymob.client.screen += OO

/atom/movable/map_view/proc/clear_all(var/mob/mymob)
	if(!mymob.client)
		return

	for(var/key in active_planes)
		var/obj/screen/plane_master/PM = active_planes[key]
		mymob.client.screen -= PM

	for(var/key in active_overlays)
		var/obj/screen/openspace_overlay/OO = active_overlays[key]
		mymob.client.screen -= OO

/atom/movable/map_view/proc/get_active_planes()
	return active_planes

/atom/movable/map_view/proc/get_active_overlays()
	return active_overlays

// Returns which access is relevant to passed network. Used by the program.
/proc/get_camera_access(var/network)
	if(!network)
		return 0
	. = GLOB.using_map.get_network_access(network)
	if(.)
		return

	switch(network)
		if(NETWORK_ENGINEERING, NETWORK_ALARM_ATMOS, NETWORK_ALARM_CAMERA, NETWORK_ALARM_FIRE, NETWORK_ALARM_POWER)
			return access_engine
		if(NETWORK_CRESCENT, NETWORK_ERT)
			return access_cent_specops
		if(NETWORK_MEDICAL)
			return access_medical
		if(NETWORK_MINE)
			return access_mailsorting // Cargo office - all cargo staff should have access here.
		if(NETWORK_RESEARCH)
			return access_research
		if(NETWORK_THUNDER)
			return 0

	return access_security // Default for all other networks

/proc/create_camera_map_id(atom/source, index)
	return "camera_[REF(source)]_[index]_map"

/datum/ui_module/program/camera_monitor
	name = "Camera Monitoring program"
	ui_interface_name = "programs/NtosCameraMonitor"

	var/list/selected_cameras = list()
	var/list/selected_networks = list()
	var/list/last_camera_turf = list()

	var/list/atom/movable/map_view/camera_map_views = list()
	var/list/obj/screen/background/camera_foregrounds = list()

# define MAX_ACTIVE_CAMERAS 4

/datum/ui_module/program/camera_monitor/New(host, program)
	. = ..()
	for(var/index in 1 to MAX_ACTIVE_CAMERAS)
		// Construct data structure for active_views
		selected_cameras += null
		selected_networks += null
		last_camera_turf += null

		// Add map_view object for corresponding camera
		var/atom/movable/map_view/cam = new()
		var/key = create_camera_map_id(src, index)
		cam.name = "screen"
		cam.assigned_map = key
		cam.screen_loc = "[key]:1,1"
		cam.update_map_view(3)
		camera_map_views[key] = cam

		// Create the bounding-box canvas & effect overlay for the view
		var/obj/screen/background/foreground = new
		foreground.screen_loc = "[key]:1,1 to [DEFAULT_VIEW_SIZE],[DEFAULT_VIEW_SIZE]"
		foreground.plane = FULLSCREEN_PLANE
		foreground.layer = FULLSCREEN_LAYER
		camera_foregrounds += foreground

# undef MAX_ACTIVE_CAMERAS

/datum/ui_module/program/camera_monitor/Destroy()
	selected_cameras = null
	selected_networks = null
	last_camera_turf = null
	QDEL_NULL_ASSOC_LIST(camera_map_views)
	QDEL_NULL_LIST(camera_foregrounds)
	. = ..()

// ADD THE SCREEN OBJECTS
/datum/ui_module/program/camera_monitor/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)

	if(!ui)
		for(var/obj/screen/background/fg in camera_foregrounds)
			user.client.screen += fg
		for(var/key in camera_map_views)
			var/atom/movable/map_view/MV = camera_map_views[key]
			MV.add_all_active(user)
			user.client.screen += MV
		. = ..()

// REMOVE THE SCREEN OBJECTS
/datum/ui_module/program/camera_monitor/ui_close(mob/user)
	. = ..()
	for(var/obj/screen/background/fg in camera_foregrounds)
		user.client.screen -= fg
	for(var/key in camera_map_views)
		var/atom/movable/map_view/MV = camera_map_views[key]
		MV.clear_all(user)
		user.client.screen -= MV

/datum/ui_module/program/camera_monitor/ui_static_data(mob/user)
	. = list()
	.["camera_view_refs"] = list()
	for (var/key in camera_map_views)
		.["camera_view_refs"] += key

/datum/ui_module/program/camera_monitor/ui_data(mob/user)
	var/list/data = host.initial_data()

	data["active_view_data"] = list()

	// The data should be constructed like this:
	//
	// active_view_data
	//	├─ 1: first view
	//  │   ├─ camera
	//  │   └─ network
	// 	...
	//	└─ n: last view
	//      ├─ camera
	//      └─ network

	for (var/i in 1 to camera_map_views.len)
		var/obj/machinery/camera/CC = selected_cameras[i]
		data["active_view_data"] += list(list(
			"camera" = (!!CC && CC.ui_json_structure()) || null,
			"network" = selected_networks[i],
		))

	var/list/all_networks[0]
	for(var/network in GLOB.using_map.station_networks)
		all_networks.Add(list(list(
			"tag" = network,
			"has_access" = can_access_network(user, get_camera_access(network)),
			"cameras" = camera_repository.cameras_in_network(network),
		)))

	all_networks = modify_networks_list(all_networks)

	data["networks"] = all_networks

	data["user_is_AI"] = isAI(user)

	return data

// Intended to be overriden by subtypes to manually add non-station networks to the list.
/datum/ui_module/program/camera_monitor/proc/modify_networks_list(var/list/networks)
	return networks

/datum/ui_module/program/camera_monitor/proc/can_access_network(var/mob/user, var/network_access)
	// No access passed, or 0 which is considered no access requirement. Allow it.
	if(!network_access)
		return 1

	return check_access(user, access_security) || check_access(user, network_access)

/datum/ui_module/program/camera_monitor/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE

	switch(action)
		if("switch_camera")
			var/view_index = text2num(params["index"])
			if(between(1, view_index, camera_map_views.len) != view_index)
				return FALSE

			var/obj/machinery/camera/C = locate(params["camera"]) in cameranet.cameras
			if(!C)
				return FALSE
			if(!(selected_networks[view_index] in C.network))
				return FALSE

			switch_to_camera(usr, view_index, C)
			return TRUE

		if("switch_network")
			// Either security access, or access to the specific camera network's department is required in order to access the network.
			var/view_index = text2num(params["index"])
			if(between(1, view_index, camera_map_views.len) != view_index)
				return FALSE

			var/network = params["network"]
			if(can_access_network(usr, get_camera_access(network)))
				selected_networks[view_index] = network
			else
				to_chat(usr, "\The [ui_host()] shows an \"Network Access Denied\" error message.")
			return TRUE

		if("jump_to_camera")
			if(isAI(usr))
				var/mob/living/silicon/ai/A = usr
				// Only allow non-carded AIs to view because the interaction with the eye gets all wonky otherwise.
				if(!A.is_in_chassis())
					return FALSE

				var/obj/machinery/camera/C = locate(params["camera"]) in cameranet.cameras
				A.eyeobj.setLoc(get_turf(C))
				A.client.eye = A.eyeobj
				return TRUE

/datum/ui_module/program/camera_monitor/proc/switch_to_camera(mob/user, index, obj/machinery/camera/C)
	set_current(index, C)

	if(!C?.can_use())
		show_camera_static(index)
		return TRUE

	var/cam_location = (isliving(C.loc) && C.loc) || C

	var/newturf = get_turf(cam_location)
	if(last_camera_turf[index] == newturf)
		return FALSE
	last_camera_turf[index] = newturf

	// Collect turfs that can be seen from this camera
	var/list/turf/visible_turfs = list()
	var/list/visible_atoms = view(C.view_range, cam_location)
	for(var/turf/visible_turf in visible_atoms)
		visible_turfs += visible_turf

	var/key = create_camera_map_id(src, index)
	var/atom/movable/map_view/MV = camera_map_views[key]
	MV.vis_contents = visible_turfs

	// Compute ByondUI map canvas size
	var/list/bbox = get_bound_box_of_atoms(visible_turfs)
	var/size_x = bbox[3] - bbox[1] + 1
	var/size_y = bbox[4] - bbox[2] + 1

	var/obj/screen/background/foreground = camera_foregrounds[index]
	foreground.screen_loc = "[key]:1,1 to [size_x],[size_y]"

	// And done
	return TRUE

/datum/ui_module/program/camera_monitor/proc/show_camera_static(index)
	var/key = create_camera_map_id(src, index)
	var/atom/movable/map_view/MV = camera_map_views[key]
	MV.vis_contents.Cut()

	var/obj/screen/background/foreground = camera_foregrounds[index]
	foreground.screen_loc = "[key]:1,1 to [DEFAULT_VIEW_SIZE],[DEFAULT_VIEW_SIZE]"
	return TRUE

/datum/ui_module/program/camera_monitor/proc/set_current(index, obj/machinery/camera/C)
	var/obj/machinery/camera/old = selected_cameras[index]
	if(old == C)
		return FALSE

	if(old)
		reset_camera(old)

	selected_cameras[index] = C
	if(C)
		var/mob/living/L = C.loc
		if(istype(L))
			L.tracking_initiated()

/datum/ui_module/program/camera_monitor/proc/reset_camera(obj/machinery/camera/C)
	if(C)
		var/mob/living/L = C.loc
		if(istype(L))
			L.tracking_cancelled()

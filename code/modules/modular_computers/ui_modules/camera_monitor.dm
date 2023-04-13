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

	var/selected_network
	var/list/selected_cameras = list()
	var/list/turf/last_camera_turf = list()

	var/list/atom/movable/map_view/camera_map_views = list()
	var/list/atom/movable/screen/background/camera_foregrounds = list()
	var/list/atom/movable/screen/background/camera_skyboxes = list()

# define MAX_ACTIVE_CAMERAS 4

/datum/ui_module/program/camera_monitor/New(host, program)
	. = ..()
	for(var/index in 1 to MAX_ACTIVE_CAMERAS)
		// Construct data structure for active_views
		selected_cameras += null
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
		var/atom/movable/screen/background/foreground = new
		foreground.screen_loc = "[key]:1,1 to [8],[6]"
		foreground.icon = 'resources/icons/primitives.dmi'
		foreground.icon_state = "white"
		foreground.plane = FULLSCREEN_PLANE
		foreground.layer = FULLSCREEN_LAYER

		var/mutable_appearance/scanlines = mutable_appearance('resources/icons/effects/static.dmi', "scanlines")
		scanlines.plane = FULLSCREEN_PLANE
		scanlines.layer = FULLSCREEN_LAYER
		scanlines.alpha = 125

		var/mutable_appearance/noise = mutable_appearance('resources/icons/effects/static.dmi', "1 moderate")
		noise.plane = FULLSCREEN_PLANE
		noise.layer = FULLSCREEN_LAYER

		foreground.overlays += scanlines
		foreground.overlays += noise

		camera_foregrounds += foreground

		// Create the local skybox for the camera
		// Because the obj/skybox type is a sealed nasty piece of shit, we'll use
		// atom/movable/screen/background for now.
		var/atom/movable/screen/background/skybox = new
		skybox.name = "skybox"
		skybox.mouse_opacity = 0
		skybox.blend_mode = BLEND_MULTIPLY
		skybox.plane = SKYBOX_PLANE
		skybox.layer = BASE_SKYBOX_LAYER
		skybox.screen_loc = "[key]:CENTER,CENTER"
		skybox.color = SSskybox.BGcolor
		skybox.appearance_flags |= TILE_BOUND

		var/mutable_appearance/sky = mutable_appearance('resources/icons/turf/skybox.dmi', "background_[SSskybox.BGstate]")
		sky.appearance_flags = RESET_ALPHA
		skybox.overlays += sky

		camera_skyboxes += skybox

# undef MAX_ACTIVE_CAMERAS

/datum/ui_module/program/camera_monitor/Destroy()
	. = ..()
	selected_cameras = null
	last_camera_turf = null
	QDEL_NULL_ASSOC_VAL_LIST(camera_map_views)
	QDEL_NULL_LIST(camera_foregrounds)
	QDEL_NULL_LIST(camera_skyboxes)

// ADD THE SCREEN OBJECTS
/datum/ui_module/program/camera_monitor/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)

	if(!ui)
		for(var/i in 1 to camera_foregrounds.len)
			user.client.screen += camera_foregrounds[i]
			user.client.screen += camera_skyboxes[i]
		for(var/key in camera_map_views)
			var/atom/movable/map_view/MV = camera_map_views[key]
			MV.add_all_active(user)
			user.client.screen += MV
		. = ..()

// REMOVE THE SCREEN OBJECTS
/datum/ui_module/program/camera_monitor/ui_close(mob/user)
	. = ..()
	for(var/i in 1 to camera_foregrounds.len)
		user.client.screen -= camera_foregrounds[i]
		user.client.screen -= camera_skyboxes[i]
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

	// This list used to have two elements per entry, but I am
	// leaving it like this for the convenience for new features
	// that might come later.
	//
	// The data should be constructed like this:
	//
	// active_view_data
	//	├─ 1: first view
	//  │   └─ camera
	// 	...
	//	└─ n: last view
	//      └─ camera

	for (var/i in 1 to camera_map_views.len)
		var/obj/machinery/camera/CC = selected_cameras[i]
		data["active_view_data"] += list(list(
			"camera" = (!!CC && CC.ui_json_structure()) || null,
		))

	var/list/all_networks[0]
	for(var/network in GLOB.using_map.station_networks)
		all_networks.Add(list(list(
			"tag" = network,
			"has_access" = can_access_network(user, get_camera_access(network)),
			"cameras" = camera_repository.cameras_in_network(network),
		)))

	all_networks = modify_networks_list(all_networks)

	data["selected_network"] = selected_network
	data["networks"] = all_networks

	data["user_is_AI"] = is_ai(user)

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
	UI_ACT_CHECK

	switch(action)
		if("switch_camera")
			var/view_index = text2num(params["index"])
			if(between(1, view_index, camera_map_views.len) != view_index)
				return FALSE

			var/obj/machinery/camera/C = locate(params["camera"]) in cameranet.cameras
			if(!C)
				return FALSE
			if(!(selected_network in C.network))
				return FALSE

			switch_to_camera(usr, view_index, C)
			return TRUE

		if("switch_network")
			// Either security access, or access to the specific camera network's department is required in order to access the network.
			var/network = params["network"]
			if(can_access_network(usr, get_camera_access(network)))
				selected_network = network
			else
				to_chat(usr, "\The [ui_host()] shows an \"Network Access Denied\" error message.")
			return TRUE

		if("jump_to_camera")
			if(is_ai(usr))
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

	if(!C || !C?.can_use())
		show_camera_static(index)
		return TRUE

	var/cam_location = (is_living_mob(C.loc) && C.loc) || C

	var/turf/T = get_turf(cam_location)
	var/last_z = last_camera_turf[index]?.z || 0
	if(last_camera_turf[index] == T)
		return FALSE
	last_camera_turf[index] = T

	// Collect turfs that can be seen from this camera
	var/list/turf/visible_turfs = list()
	var/list/visible_atoms = view(C.view_range, T)
	for(var/turf/visible_turf in visible_atoms)
		visible_turfs += visible_turf

	var/key = create_camera_map_id(src, index)
	var/atom/movable/map_view/MV = camera_map_views[key]
	MV.vis_contents = visible_turfs

	if(last_z != T.z)
		MV.clear_all(user)
		MV.update_map_view(GetZDepth(T.z))
		MV.add_all_active(user)

	// Compute ByondUI map canvas size
	var/list/bbox = get_bound_box_of_atoms(visible_turfs)
	var/size_x = bbox[3] - bbox[1] + 1
	var/size_y = bbox[4] - bbox[2] + 1

	var/atom/movable/screen/background/foreground = camera_foregrounds[index]
	foreground.icon_state = "blank"
	foreground.screen_loc = "[key]:1,1 to [size_x],[size_y]"

	var/atom/movable/screen/background/skybox = camera_skyboxes[index]
	var/matrix/M = matrix()
	// The skybox does not always cover the background, so upscale it a bit
	M.Scale(between(1, 1 + max(size_x, size_y)/DEFAULT_VIEW_SIZE, 2))
	skybox.transform = M
	skybox.screen_loc = "[key]:CENTER:[(-224)-(T.x)],CENTER:[(-224)-(T.y)]"

	// And done
	return TRUE

/datum/ui_module/program/camera_monitor/proc/show_camera_static(index)
	var/key = create_camera_map_id(src, index)
	var/atom/movable/map_view/MV = camera_map_views[key]
	MV.vis_contents.Cut()

	var/atom/movable/screen/background/foreground = camera_foregrounds[index]
	foreground.icon_state = "white"
	foreground.screen_loc = "[key]:1,1 to [8],[6]"
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

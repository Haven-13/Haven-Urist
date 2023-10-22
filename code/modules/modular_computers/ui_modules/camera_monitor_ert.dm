/datum/ui_module/program/camera_monitor/ert
	name = "Advanced Camera Monitoring Program"
	available_to_ai = FALSE

// The ERT variant has access to ERT and crescent cams, but still checks for accesses. ERT members should be able to use it.
/datum/ui_module/program/camera_monitor/ert/modify_networks_list(list/networks)
	..()
	networks.Add(list(list("tag" = NETWORK_ERT, "has_access" = 1)))
	networks.Add(list(list("tag" = NETWORK_CRESCENT, "has_access" = 1)))
	return networks

/*
/datum/ui_module/program/camera_monitor/apply_visual(mob/M)
	if(current_camera)
		current_camera.apply_visual(M)
	else
		remove_visual(M)

/datum/ui_module/program/camera_monitor/remove_visual(mob/M)
	if(current_camera)
		current_camera.remove_visual(M)
*/

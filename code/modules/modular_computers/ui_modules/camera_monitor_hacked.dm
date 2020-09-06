/datum/ui_module/camera_monitor/hacked
	name = "Hacked Camera Monitoring Program"
	available_to_ai = FALSE

/datum/ui_module/camera_monitor/hacked/can_access_network(var/mob/user, var/network_access)
	return 1

// The hacked variant has access to all commonly used networks.
/datum/ui_module/camera_monitor/hacked/modify_networks_list(var/list/networks)
	networks.Add(list(list("tag" = NETWORK_MERCENARY, "has_access" = 1)))
	networks.Add(list(list("tag" = NETWORK_ERT, "has_access" = 1)))
	networks.Add(list(list("tag" = NETWORK_CRESCENT, "has_access" = 1)))
	return networks

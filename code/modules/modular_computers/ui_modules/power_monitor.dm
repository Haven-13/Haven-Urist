
/datum/ui_module/program/power_monitor
	name = "Power monitor"
	ui_interface_name = "programs/PowerMonitorProgram"

	var/list/grid_sensors
	var/active_sensor = null	//name_tag of the currently selected sensor

/datum/ui_module/program/power_monitor/New()
	..()
	refresh_sensors()

/datum/ui_module/program/power_monitor/Destroy()
	for(var/grid_sensor in grid_sensors)
		remove_sensor(grid_sensor, FALSE)
	grid_sensors = null
	. = ..()

// Checks whether there is an active alarm, if yes, returns 1, otherwise returns 0.
/datum/ui_module/program/power_monitor/proc/has_alarm()
	for(var/obj/machinery/power/sensor/S in grid_sensors)
		if(S.check_grid_warning())
			return 1
	return 0

/datum/ui_module/program/power_monitor/ui_data(mob/user)
	var/list/data = host.initial_data()

	var/list/sensors = list()
	// Focus: If it remains null if no sensor is selected and UI will display sensor list, otherwise it will display sensor reading.
	var/obj/machinery/power/sensor/focus = null

	// Build list of data from sensor readings.
	for(var/obj/machinery/power/sensor/S in grid_sensors)
		sensors.Add(list(list(
		"name" = S.name_tag,
		"alarm" = S.check_grid_warning()
		)))
		if(S.name_tag == active_sensor)
			focus = S

	data["all_sensors"] = sensors
	if(focus)
		data["focus"] = focus.return_reading_data()

	return data

// Refreshes list of active sensors kept on this computer.
/datum/ui_module/program/power_monitor/proc/refresh_sensors()
	grid_sensors = list()
	var/turf/T = get_turf(ui_host())
	if(!T) // Safety check
		return
	var/connected_z_levels = GetConnectedZlevels(T.z)
	for(var/obj/machinery/power/sensor/S in SSmachines.machinery)
		if((S.long_range) || (S.loc.z in connected_z_levels)) // Consoles have range on their Z-Level. Sensors with long_range var will work between Z levels.
			if(S.name_tag == "#UNKN#") // Default name. Shouldn't happen!
				warning("Powernet sensor with unset ID Tag! [S.x]X [S.y]Y [S.z]Z")
			else
				grid_sensors += S
				GLOB.destroyed_event.register(S, src, /datum/ui_module/program/power_monitor/proc/remove_sensor)

/datum/ui_module/program/power_monitor/proc/remove_sensor(var/removed_sensor, var/update_ui = TRUE)
	if(active_sensor == removed_sensor)
		active_sensor = null
		if(update_ui)
			SStgui.update_uis(src)
	grid_sensors -= removed_sensor
	GLOB.destroyed_event.unregister(removed_sensor, src, /datum/ui_module/program/power_monitor/proc/remove_sensor)

// Allows us to process UI clicks, which are relayed in form of hrefs.
/datum/ui_module/program/power_monitor/Topic(href, href_list)
	if(..())
		return 1
	if( href_list["clear"] )
		active_sensor = null
		. = 1
	if( href_list["refresh"] )
		refresh_sensors()
		. = 1
	else if( href_list["setsensor"] )
		active_sensor = href_list["setsensor"]
		. = 1

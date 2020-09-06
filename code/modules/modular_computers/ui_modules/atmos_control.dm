/datum/ui_module/atmos_control
	name = "Atmospherics Control"
	var/obj/access = new()
	var/emagged = 0
	var/ui_ref
	var/list/monitored_alarms = list()

/datum/ui_module/atmos_control/New(atmos_computer, var/list/req_access, var/list/req_one_access, monitored_alarm_ids)
	..()

	if(istype(req_access))
		access.req_access = req_access
	else if(req_access)
		log_debug("\The [src] was given an unepxected req_access: [req_access]")

	if(istype(req_one_access))
		access.req_one_access = req_one_access
	else if(req_one_access)
		log_debug("\The [src] given an unepxected req_one_access: [req_one_access]")

	if(monitored_alarm_ids)
		for(var/obj/machinery/alarm/alarm in SSmachines.machinery)
			if(alarm.alarm_id && alarm.alarm_id in monitored_alarm_ids)
				monitored_alarms += alarm
		// machines may not yet be ordered at this point
		monitored_alarms = dd_sortedObjectList(monitored_alarms)

/datum/ui_module/atmos_control/Topic(href, href_list)
	if(..())
		return 1

	if(href_list["alarm"])
		if(ui_ref)
			var/obj/machinery/alarm/alarm = locate(href_list["alarm"]) in (monitored_alarms.len ? monitored_alarms : SSmachines.machinery)
			if(alarm)
				alarm.ui_interact(usr)
		return 1

/datum/ui_module/atmos_control/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AtmosControlProgram")
		ui.open()

/datum/ui_module/atmos_control/ui_data(mob/user)
	var/list/data = host.initial_data()
	var/alarms[0]

	// TODO: Move these to a cache, similar to cameras
	for(var/obj/machinery/alarm/alarm in (monitored_alarms.len ? monitored_alarms : SSmachines.machinery))
		alarms[++alarms.len] = list("name" = sanitize(alarm.name), "ref"= "\ref[alarm]", "danger" = max(alarm.danger_level, alarm.alarm_area.atmosalm))
	data["alarms"] = alarms

	return data

/datum/ui_module/atmos_control/proc/generate_state(air_alarm)
	var/datum/ui_state/air_alarm/state = new()
	state.atmos_control = src
	state.air_alarm = air_alarm
	return state

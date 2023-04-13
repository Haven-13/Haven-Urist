/datum/ui_module/program/atmos_control
	name = "Atmospherics Control"
	ui_interface_name = "programs/AtmosControlProgram"
	var/obj/access = new()
	var/emagged = 0
	var/alarm_ref
	var/list/monitored_alarms = list()

/datum/ui_module/program/atmos_control/New(atmos_computer, var/list/req_access, var/list/req_one_access, monitored_alarm_ids)
	..()

	if(program)
		access.req_access = program.required_access

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
			if(alarm.alarm_id && (alarm.alarm_id in monitored_alarm_ids))
				monitored_alarms += alarm
		// machines may not yet be ordered at this point
		monitored_alarms = dd_sortedObjectList(monitored_alarms)

/datum/ui_module/program/atmos_control/ui_status(mob/user, datum/ui_state/state)
	var/obj/machinery/alarm/alarm = fetch_alarm(alarm_ref)
	if(alarm)
		var/rcon_status = fetch_remote_status(usr, alarm)
		if(rcon_status < UI_DISABLED)
			alarm_ref = null
			update_static_data()
	else if (alarm_ref)
		alarm_ref = null
		update_static_data()
	. = ..()

/datum/ui_module/program/atmos_control/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE

	switch(action)
		if("select")
			var/ref = params["ref"]
			var/obj/machinery/alarm/alarm = fetch_alarm(ref)
			if(istype(alarm) && (fetch_remote_status(usr, alarm) >= UI_DISABLED))
				alarm_ref = ref
				update_static_data(usr, ui)
			return TRUE
		else
			var/obj/machinery/alarm/alarm = fetch_alarm(alarm_ref)
			if(alarm)
				var/rcon_status = alarm.CanUseTopic(
					usr,
					ui_always_state(),
					list("[action]" = action) | get_remote_params(usr, alarm) // MASSIVE HACK FOR BAYCODE
				)
				if(rcon_status == UI_INTERACTIVE)
					alarm.ui_act(action, params, ui)
			return TRUE

/datum/ui_module/program/atmos_control/proc/fetch_alarm(ref)
	if(ref)
		var/list/container = (monitored_alarms.len ? monitored_alarms : SSmachines.machinery)
		var/obj/machinery/alarm/alarm = locate(ref) in container
		return (istype(alarm) ? alarm : null)
	return null

/datum/ui_module/program/atmos_control/proc/fetch_remote_status(mob/user,  obj/machinery/alarm/alarm)
	return alarm.CanUseTopic(
		user,
		ui_always_state(),
		get_remote_params(user, alarm)
	)

/datum/ui_module/program/atmos_control/proc/get_remote_params(mob/user, obj/machinery/alarm/alarm)
	. = list(
		"remoteConnection" = TRUE,
		"remoteAccess" =\
			is_ai(user)\
			|| src.access.allowed(user)\
			|| src.emagged\
			|| alarm.rcon_setting == RCON_YES\
			|| (alarm.alarm_area.atmosalm && alarm.rcon_setting == RCON_AUTO)\

	)

/datum/ui_module/program/atmos_control/ui_static_data(mob/user)
	. = ..()
	var/obj/machinery/alarm/alarm = fetch_alarm(alarm_ref)
	. |= alarm?.ui_static_data(user) || null
	.["selected"] = list(
		"name" = alarm?.name || 0,
		"ref" = alarm_ref || 0
	)

/datum/ui_module/program/atmos_control/ui_data(mob/user)
	. = host.initial_data()

	var/obj/machinery/alarm/alarm = fetch_alarm(alarm_ref)
	if(alarm)
		. |= alarm.ui_data(user)
		. |= get_remote_params(user, alarm)
		if(!.["controlsPopulated"])
			alarm.populate_controls(.)

	// TODO: Move these to a cache, similar to cameras
	var/list/alarms = list()
	for(var/obj/machinery/alarm/myalarm in (monitored_alarms.len ? monitored_alarms : SSmachines.machinery))
		var/area/A = get_area(myalarm)
		alarms[++alarms.len] = list(
			"name" = sanitize(A.name),
			"ref"= REF(myalarm),
			"powered" = !HAS_FLAG(myalarm.stat, NOPOWER),
			"danger" = max(myalarm.danger_level, myalarm.alarm_area.atmosalm)
		)
	.["alarms"] = alarms

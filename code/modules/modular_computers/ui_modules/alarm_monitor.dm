/datum/ui_module/program/alarm_monitor
	name = "Alarm monitor"
	ui_interface_name = "programs/AlarmMonitorProgram"

	var/list_cameras = 0						// Whether or not to list camera references. A future goal would be to merge this with the enginering/security camera console. Currently really only for AI-use.
	var/list/datum/alarm_handler/alarm_handlers // The particular list of alarm handlers this alarm monitor should present to the user.
	available_to_ai = FALSE

/datum/ui_module/program/alarm_monitor/New()
	..()
	alarm_handlers = list()

/datum/ui_module/program/alarm_monitor/all
	available_to_ai = TRUE

/datum/ui_module/program/alarm_monitor/all/New()
	..()
	alarm_handlers = SSalarm.all_handlers

/datum/ui_module/program/alarm_monitor/engineering/New()
	..()
	alarm_handlers = list(atmosphere_alarm, camera_alarm, fire_alarm, power_alarm)

/datum/ui_module/program/alarm_monitor/security/New()
	..()
	alarm_handlers = list(camera_alarm, motion_alarm)

/datum/ui_module/program/alarm_monitor/proc/register_alarm(var/object, var/procName)
	for(var/datum/alarm_handler/AH in alarm_handlers)
		AH.register_alarm(object, procName)

/datum/ui_module/program/alarm_monitor/proc/unregister_alarm(var/object)
	for(var/datum/alarm_handler/AH in alarm_handlers)
		AH.unregister_alarm(object)

/datum/ui_module/program/alarm_monitor/proc/all_alarms()
	var/list/all_alarms = new()
	for(var/datum/alarm_handler/AH in alarm_handlers)
		all_alarms += AH.alarms(get_host_z())

	return all_alarms

/datum/ui_module/program/alarm_monitor/proc/major_alarms()
	var/list/all_alarms = new()
	for(var/datum/alarm_handler/AH in alarm_handlers)
		all_alarms += AH.major_alarms(get_host_z())

	return all_alarms

// Modified version of above proc that uses slightly less resources, returns 1 if there is a major alarm, 0 otherwise.
/datum/ui_module/program/alarm_monitor/proc/has_major_alarms()
	for(var/datum/alarm_handler/AH in alarm_handlers)
		if(AH.has_major_alarms(get_host_z()))
			return 1

	return 0

/datum/ui_module/program/alarm_monitor/proc/minor_alarms()
	var/list/all_alarms = new()
	for(var/datum/alarm_handler/AH in alarm_handlers)
		all_alarms += AH.minor_alarms(get_host_z())

	return all_alarms

/datum/ui_module/program/alarm_monitor/Topic(ref, href_list)
	if(..())
		return 1
	if(href_list["switchTo"])
		var/obj/machinery/camera/C = locate(href_list["switchTo"]) in cameranet.cameras
		if(!C)
			return

		usr.switch_to_camera(C)
		return 1

/datum/ui_module/program/alarm_monitor/ui_data(mob/user)
	var/list/data = host.initial_data()

	var/categories[0]
	for(var/datum/alarm_handler/AH in alarm_handlers)
		categories[++categories.len] = list("name" = AH.category, "alarms" = list())
		for(var/datum/alarm/A in AH.major_alarms(get_host_z()))

			var/cameras[0]
			var/lost_sources[0]

			if(isAI(user))
				for(var/obj/machinery/camera/C in A.cameras())
					cameras[++cameras.len] = C.ui_json_structure()
			for(var/datum/alarm_source/AS in A.sources)
				if(!AS.source)
					lost_sources[++lost_sources.len] = AS.source_name

			categories[categories.len]["alarms"] += list(list(
					"name" = sanitize(A.alarm_name()),
					"origin_lost" = A.origin == null,
					"has_cameras" = cameras.len,
					"cameras" = cameras,
					"lost_sources" = lost_sources.len ? sanitize(english_list(lost_sources, nothing_text = "", and_text = ", ")) : ""))
	data["categories"] = categories

	return data

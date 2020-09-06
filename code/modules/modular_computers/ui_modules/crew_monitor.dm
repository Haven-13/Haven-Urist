/datum/ui_module/crew_monitor
	name = "Crew monitor"

/datum/ui_module/crew_monitor/proc/has_alerts()
	for(var/z_level in GLOB.using_map.map_levels)
		if (crew_repository.has_health_alert(z_level))
			return TRUE
	return FALSE

/datum/ui_module/crew_monitor/Topic(href, href_list)
	if(..()) return 1

	if(href_list["track"])
		if(isAI(usr))
			var/mob/living/silicon/ai/AI = usr
			var/mob/living/carbon/human/H = locate(href_list["track"]) in SSmobs.mob_list
			if(hassensorlevel(H, SUIT_SENSOR_TRACKING))
				AI.ai_actual_track(H)
		return 1

/datum/ui_module/crew_monitor/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CrewMonitorProgram")
		ui.open()

/datum/ui_module/crew_monitor/ui_data(mob/user)
	var/list/data = host.initial_data()

	data["isAI"] = isAI(user)
	data["crewmembers"] = list()
	for(var/z_level in GLOB.using_map.map_levels)
		data["crewmembers"] += crew_repository.health_data(z_level)

	return data

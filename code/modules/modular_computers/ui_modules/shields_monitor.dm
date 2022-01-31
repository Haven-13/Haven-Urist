
/datum/ui_module/program/shields_monitor
	name = "Shields Monitoring"
	ui_interface_name = "programs/ShieldsMonitorProgram"

	var/obj/machinery/power/shield_generator/active = null

/datum/ui_module/program/shields_monitor/Destroy()
	deselect_shield()
	. = ..()

/datum/ui_module/program/shields_monitor/proc/get_shields()
	var/turf/T = get_turf(ui_host())
	if(!T)
		return list()

	var/list/shields = list()
	var/connected_z_levels = GetConnectedZlevels(T.z)
	for(var/obj/machinery/power/shield_generator/S in SSmachines.machinery)
		if(!(S.z in connected_z_levels))
			continue
		shields.Add(S)

	if(!(active in shields))
		deselect_shield()
	return shields

/datum/ui_module/program/shields_monitor/ui_data(mob/user)
	. = host.initial_data()

	.["active"] = active ? REF(active) : 0
	if (active)
		.["running"] = active.running
		.["modes"] = active.get_flag_descriptions()
		.["overloaded"] = active.overloaded
		.["mitigation_max"] = active.mitigation_max
		.["mitigation_physical"] = active.mitigation_physical
		.["mitigation_em"] = active.mitigation_em
		.["mitigation_heat"] = active.mitigation_heat
		.["field_integrity"] = active.field_integrity()
		.["max_energy"] = active.max_energy
		.["current_energy"] = active.current_energy
		.["total_segments"] = active.field_segments ? active.field_segments.len : 0
		.["functional_segments"] = active.damaged_segments ? .["total_segments"] - active.damaged_segments.len : .["total_segments"]
		.["field_radius"] = active.field_radius
		.["input_cap_kw"] = active.input_cap
		.["upkeep_power_usage"] = active.upkeep_power_usage
		.["power_usage"] = active.power_usage
		.["hacked"] = active.hacked
		.["offline_for"] = active.offline_for * 2
		.["pos_x"] = active.x
		.["pos_y"] = active.y
		.["pos_z"] = active.z

	var/list/shields = get_shields()
	var/list/shields_info = list()
	for(var/obj/machinery/power/shield_generator/S in shields)
		var/area/A = get_area(S)
		var/list/temp = list(list(
			"shield_status" = S.running,
			"shield_ref" = any2ref(S),
			"area" = A.name))
		shields_info.Add(temp)
	.["shields"] = shields_info

/datum/ui_module/program/shields_monitor/ui_act(action, list/params)
	if(..())
		return TRUE

	switch(action)
		if("refresh")
			get_shields()
			. = TRUE
		if("return")
			deselect_shield()
			. = TRUE
		if("ref")
			select_shield(params["ref"])
			. = TRUE

/datum/ui_module/program/shields_monitor/proc/select_shield(ref)
	var/list/shields = get_shields()
	var/obj/machinery/power/shield_generator/S = locate(ref) in shields
	if(S)
		deselect_shield()
		GLOB.destroyed_event.register(
			S,
			src,
			/datum/ui_module/program/shields_monitor/proc/deselect_shield
		)
		active = S

/datum/ui_module/program/shields_monitor/proc/deselect_shield(source)
	if(!active)
		return
	GLOB.destroyed_event.unregister(active, src)
	active = null
	if(source) // source is only set if called by the shield destroyed event, which is the only time we want to update the UI
		SStgui.update_uis(src)

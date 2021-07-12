/datum/ui_module/program/supermatter_monitor
	name = "Supermatter monitor"
	ui_interface_name = "programs/NtosSupermatterMonitor"

	var/list/supermatters
	var/obj/machinery/power/supermatter/active = null		// Currently selected supermatter crystal.

/datum/ui_module/program/supermatter_monitor/Destroy()
	. = ..()
	active = null
	supermatters = null

/datum/ui_module/program/supermatter_monitor/New()
	..()
	refresh()

// Refreshes list of active supermatter crystals
/datum/ui_module/program/supermatter_monitor/proc/refresh()
	supermatters = list()
	var/turf/T = get_turf(ui_host())
	if(!T)
		return
	var/valid_z_levels = (GetConnectedZlevels(T.z) & GLOB.using_map.station_levels)
	for(var/obj/machinery/power/supermatter/S in SSmachines.machinery)
		// Delaminating, not within coverage, not on a tile.
		if(S.grav_pulling || S.exploded || !(S.z in valid_z_levels) || !istype(S.loc, /turf/))
			continue
		supermatters.Add(S)

	if(!(active in supermatters))
		active = null

/datum/ui_module/program/supermatter_monitor/proc/get_status()
	. = SUPERMATTER_INACTIVE
	for(var/obj/machinery/power/supermatter/S in supermatters)
		. = max(., S.get_status())

/datum/ui_module/program/supermatter_monitor/ui_data(mob/user)
	. = host.initial_data()

	if(istype(active))
		var/turf/T = get_turf(active)
		if(!T)
			active = null
			return
		var/datum/gas_mixture/air = T.return_air()
		if(!istype(air))
			active = null
			return

		.["active"] = 1
		.["SM_integrity"] = active.get_integrity()
		.["SM_power"] = active.power
		.["SM_ambienttemp"] = air.temperature
		.["SM_ambientpressure"] = air.return_pressure()
		.["SM_EPR"] = active.get_epr()
		.["SM_PHO"] = round(active.phoron_release_modifier / 15, 0.1)
		.["SM_RAD"] = active.radiation_release_modifier
		.["SM_atmosphere"] = list(
			"total_moles" = air.total_moles,
			"composition" = list()
		)
		for (var/gas in air.gas)
			.["SM_atmosphere"]["composition"] += list(list(
				"id" = gas,
				"moles" = !!air.total_moles && air.gas[gas] || 0
			))

	else
		var/list/SMS = list()
		for(var/obj/machinery/power/supermatter/S in supermatters)
			var/area/A = get_area(S)
			if(!A)
				continue

			SMS.Add(list(list(
				"area_name" = A.name,
				"integrity" = S.get_integrity(),
				"uid" = S.uid
			)))

		.["active"] = 0
		.["supermatters"] = SMS

/datum/ui_module/program/supermatter_monitor/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE

	switch(action)
		if("clear_active")
			active = null
			return TRUE
		if("refresh")
			refresh()
			return TRUE
		if("set_active")
			var/newuid = text2num(params["value"])
			for(var/obj/machinery/power/supermatter/S in supermatters)
				if(S.uid == newuid)
					active = S
			return TRUE

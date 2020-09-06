/datum/ui_module/supermatter_monitor
	name = "Supermatter monitor"
	var/list/supermatters
	var/obj/machinery/power/supermatter/active = null		// Currently selected supermatter crystal.

/datum/ui_module/supermatter_monitor/Destroy()
	. = ..()
	active = null
	supermatters = null

/datum/ui_module/supermatter_monitor/New()
	..()
	refresh()

// Refreshes list of active supermatter crystals
/datum/ui_module/supermatter_monitor/proc/refresh()
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

/datum/ui_module/supermatter_monitor/proc/get_status()
	. = SUPERMATTER_INACTIVE
	for(var/obj/machinery/power/supermatter/S in supermatters)
		. = max(., S.get_status())

/datum/ui_module/supermatter_monitor/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "SupermatterMonitorProgram")
		ui.open()

/datum/ui_module/supermatter_monitor/ui_data(mob/user)
	var/list/data = host.initial_data()

	if(istype(active))
		var/turf/T = get_turf(active)
		if(!T)
			active = null
			return
		var/datum/gas_mixture/air = T.return_air()
		if(!istype(air))
			active = null
			return

		data["active"] = 1
		data["SM_integrity"] = active.get_integrity()
		data["SM_power"] = active.power
		data["SM_ambienttemp"] = air.temperature
		data["SM_ambientpressure"] = air.return_pressure()
		data["SM_EPR"] = active.get_epr()
		data["SM_PHO"] = round(active.phoron_release_modifier / 15, 0.1)
		data["SM_RAD"] = active.radiation_release_modifier
		if(air.total_moles)
			data["SM_gas_O2"] = round(100*air.gas["oxygen"]/air.total_moles,0.01)
			data["SM_gas_CO2"] = round(100*air.gas["carbon_dioxide"]/air.total_moles,0.01)
			data["SM_gas_N2"] = round(100*air.gas["nitrogen"]/air.total_moles,0.01)
			data["SM_gas_PH"] = round(100*air.gas["phoron"]/air.total_moles,0.01)
			data["SM_gas_N2O"] = round(100*air.gas["sleeping_agent"]/air.total_moles,0.01)
			data["SM_gas_H2"] = round(100*air.gas["hydrogen"]/air.total_moles,0.01)
			data["SM_gas_CH3BR"] = round(100*air.gas["methyl_bromide"]/air.total_moles,0.01)
		else
			data["SM_gas_O2"] = 0
			data["SM_gas_CO2"] = 0
			data["SM_gas_N2"] = 0
			data["SM_gas_PH"] = 0
			data["SM_gas_N2O"] = 0
			data["SM_gas_H2"] = 0
			data["SM_gas_CH3BR"] = 0
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

		data["active"] = 0
		data["supermatters"] = SMS

	return data

/datum/ui_module/supermatter_monitor/Topic(href, href_list)
	if(..())
		return 1
	if( href_list["clear"] )
		active = null
		return 1
	if( href_list["refresh"] )
		refresh()
		return 1
	if( href_list["set"] )
		var/newuid = text2num(href_list["set"])
		for(var/obj/machinery/power/supermatter/S in supermatters)
			if(S.uid == newuid)
				active = S
		return 1

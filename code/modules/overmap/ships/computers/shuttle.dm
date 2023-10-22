//Shuttle controller computer for shuttles going between sectors
/obj/machinery/computer/shuttle_control/explore
	name = "general shuttle control console"
	ui_template = "spacecraft/ShuttleConsole"

/obj/machinery/computer/shuttle_control/explore/get_shuttle_ui_data(datum/shuttle/autodock/overmap/shuttle)
	. = ..()
	if(istype(shuttle))
		var/fuel_pressure = 0
		var/fuel_max_pressure = 0
		for(var/obj/structure/fuel_port/FP in shuttle.fuel_ports) //loop through fuel ports
			var/obj/item/weapon/tank/fuel_tank = locate() in FP
			if(fuel_tank)
				fuel_pressure += fuel_tank.air_contents.return_pressure()
				fuel_max_pressure += 1013

		if(fuel_max_pressure == 0) fuel_max_pressure = 1

		. += list(
			"possibleDestinations" = shuttle.get_possible_destinations(),
			"selectedDestination" = shuttle.get_destination_info(),
			"canPick" = shuttle.moving_status == SHUTTLE_IDLE,
			"dockingCode" = shuttle.docking_codes,
			"fuelConsumption" = shuttle.fuel_consumption? 1 : 0,
			"fuelPressure" = fuel_pressure,
			"fuelMaxPressure" = fuel_max_pressure,
			"fuelPressureStatus" = (fuel_pressure/fuel_max_pressure > 0.2)? "good" : "bad"
		)

/obj/machinery/computer/shuttle_control/explore/handle_ui_act(datum/shuttle/autodock/overmap/shuttle, action, list/params)
	if((. = ..()) || !istype(shuttle))
		return .

	switch(action)
		if ("set_destination")
			var/destination = params["destination"]
			var/obj/effect/shuttle_landmark/LM = SSshuttle.get_landmark(destination)
			if (istype(LM) && LM.is_valid(shuttle))
				shuttle.set_destination(LM)
			else
				shuttle.set_destination(null)
			. = TRUE

/obj/machinery/portable_atmospherics/powered/pump
	name = "portable air pump"

	icon = 'resources/icons/obj/atmos.dmi'
	icon_state = "psiphon:0"
	density = 1
	w_class = ITEM_SIZE_NORMAL

	var/on = 0
	var/direction_out = 0 //0 = siphoning, 1 = releasing
	var/target_pressure = ONE_ATMOSPHERE

	var/pressuremin = 0
	var/pressuremax = 10 * ONE_ATMOSPHERE

	volume = 1000

	power_rating = 7500 //7500 W ~ 10 HP
	power_losses = 150

/obj/machinery/portable_atmospherics/powered/pump/filled
	start_pressure = 90 * ONE_ATMOSPHERE

/obj/machinery/portable_atmospherics/powered/pump/New()
	..()
	cell = new/obj/item/weapon/cell/apc(src)

	var/list/air_mix = StandardAirMix()
	src.air_contents.adjust_multi("oxygen", air_mix["oxygen"], "nitrogen", air_mix["nitrogen"])

/obj/machinery/portable_atmospherics/powered/pump/update_icon()
	src.overlays = 0

	if(on && cell && cell.charge)
		icon_state = "psiphon:1"
	else
		icon_state = "psiphon:0"

	if(holding)
		overlays += "siphon-open"

	if(connected_port)
		overlays += "siphon-connector"

	return

/obj/machinery/portable_atmospherics/powered/pump/emp_act(severity)
	if(stat & (BROKEN|NOPOWER))
		..(severity)
		return

	if(prob(50/severity))
		on = !on

	if(prob(100/severity))
		direction_out = !direction_out

	target_pressure = rand(0,1300)
	update_icon()

	..(severity)

/obj/machinery/portable_atmospherics/powered/pump/Process()
	..()
	var/power_draw = -1

	if(on && ( powered() || (cell && cell.charge) ) )
		var/datum/gas_mixture/environment
		if(holding)
			environment = holding.air_contents
		else
			environment = loc.return_air()

		var/pressure_delta
		var/output_volume
		var/air_temperature
		if(direction_out)
			pressure_delta = target_pressure - environment.return_pressure()
			output_volume = environment.volume * environment.group_multiplier
			air_temperature = environment.temperature || air_contents.temperature
		else
			pressure_delta = environment.return_pressure() - target_pressure
			output_volume = air_contents.volume * air_contents.group_multiplier
			air_temperature = air_contents.temperature || environment.temperature

		var/transfer_moles = pressure_delta*output_volume/(air_temperature * R_IDEAL_GAS_EQUATION)

		if (pressure_delta > 0.01)
			if (direction_out)
				power_draw = pump_gas(src, air_contents, environment, transfer_moles, power_rating)
			else
				power_draw = pump_gas(src, environment, air_contents, transfer_moles, power_rating)

	if (power_draw < 0)
		last_flow_rate = 0
		last_power_draw = 0
	else
		power_draw = max(power_draw, power_losses)
		if(!powered() && cell)
			cell.use(power_draw * CELLRATE)
		else
			use_power(power_draw)
		last_power_draw = power_draw

		update_connected_network()

		//ran out of charge
		if (!cell.charge && !powered())
			power_change()
			update_icon()

	src.updateDialog()

/obj/machinery/portable_atmospherics/powered/pump/attack_ai(mob/user)
	src.add_hiddenprint(user)
	return src.attack_hand(user)

/obj/machinery/portable_atmospherics/powered/pump/attack_ghost(mob/user)
	return src.attack_hand(user)

/obj/machinery/portable_atmospherics/powered/pump/attack_hand(mob/user)
	ui_interact(user)

/obj/machinery/portable_atmospherics/powered/pump/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "atmospherics/PortablePump")
		ui.open()

/obj/machinery/portable_atmospherics/powered/pump/ui_data(mob/user)
	var/list/data[0]
	data["port_connected"] = connected_port ? 1 : 0
	data["pressure"] = round(air_contents.return_pressure() > 0 ? air_contents.return_pressure() : 0)
	data["target_pressure"] = round(target_pressure)
	data["pump_dir"] = direction_out
	data["min_pressure"] = round(pressuremin)
	data["max_pressure"] = round(pressuremax)
	data["power_draw"] = round(last_power_draw)
	data["cell_charge"] = cell ? cell.charge : 0
	data["cell_max_charge"] = cell ? cell.maxcharge : 1
	data["on"] = on ? 1 : 0

	if (holding)
		data["holding_tank"] = list("name" = holding.name, "pressure" = round(holding.air_contents.return_pressure() > 0 ? holding.air_contents.return_pressure() : 0))

	return data

/obj/machinery/portable_atmospherics/powered/pump/ui_act(action, list/params)
	UI_ACT_CHECK

	switch(action)
		if ("power")
			on = !on
			. = TRUE
		if("direction")
			direction_out = !direction_out
			. = TRUE
		if ("remove_tank")
			if(holding)
				holding.dropInto(loc)
				holding = null
			. = TRUE
		if ("pressure_adj")
			var/diff = text2num(params["pressure_adj"])
			target_pressure = min(10*ONE_ATMOSPHERE, max(0, target_pressure+diff))
			. = TRUE

	if (.)
		update_icon()

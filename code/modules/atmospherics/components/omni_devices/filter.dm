//--------------------------------------------
// Gas filter - omni variant
//--------------------------------------------
/obj/machinery/atmospherics/omni/filter
	name = "omni gas filter"
	icon_state = "map_filter"

	var/list/gas_filters = new()
	var/datum/omni_port/input
	var/datum/omni_port/output
	var/max_output_pressure = MAX_OMNI_PRESSURE

	use_power = 1
	idle_power_usage = 150		//internal circuitry, friction losses and stuff
	power_rating = 7500			//7500 W ~ 10 HP

	var/max_flow_rate = ATMOS_DEFAULT_VOLUME_FILTER
	var/set_flow_rate = ATMOS_DEFAULT_VOLUME_FILTER

	var/list/filtering_outputs = list()	//maps gasids to gas_mixtures

/obj/machinery/atmospherics/omni/filter/New()
	..()
	rebuild_filtering_list()
	for(var/datum/omni_port/P in ports)
		P.air.volume = ATMOS_DEFAULT_VOLUME_FILTER

/obj/machinery/atmospherics/omni/filter/Destroy()
	input = null
	output = null
	gas_filters.Cut()
	. = ..()

/obj/machinery/atmospherics/omni/filter/sort_ports()
	for(var/datum/omni_port/P in ports)
		if(P.update)
			if(output == P)
				output = null
			if(input == P)
				input = null
			if(P in gas_filters)
				gas_filters -= P

			P.air.volume = ATMOS_DEFAULT_VOLUME_FILTER
			switch(P.mode)
				if(ATM_INPUT)
					input = P
				if(ATM_OUTPUT)
					output = P
				if(ATM_O2 to ATM_H2)
					gas_filters += P

/obj/machinery/atmospherics/omni/filter/error_check()
	if(!input || !output || !gas_filters)
		return 1
	if(gas_filters.len < 1) //requires at least 1 filter ~otherwise why are you using a filter?
		return 1

	return 0

/obj/machinery/atmospherics/omni/filter/Process()
	if(!..())
		return 0

	var/datum/gas_mixture/output_air = output.air	//BYOND doesn't like referencing "output.air.return_pressure()" so we need to make a direct reference
	var/datum/gas_mixture/input_air = input.air		// it's completely happy with them if they're in a loop though i.e. "P.air.return_pressure()"... *shrug*

	var/delta = between(0, (output_air ? (max_output_pressure - output_air.return_pressure()) : 0), max_output_pressure)
	var/transfer_moles_max = calculate_transfer_moles(input_air, output_air, delta, (output && output.network && output.network.volume) ? output.network.volume : 0)
	for(var/datum/omni_port/filter_output in gas_filters)
		delta = between(0, (filter_output.air ? (max_output_pressure - filter_output.air.return_pressure()) : 0), max_output_pressure)
		transfer_moles_max = min(transfer_moles_max, (calculate_transfer_moles(input_air, filter_output.air, delta, (filter_output && filter_output.network && filter_output.network.volume) ? filter_output.network.volume : 0)))

	//Figure out the amount of moles to transfer
	var/transfer_moles = between(0, ((set_flow_rate/input_air.volume)*input_air.total_moles), transfer_moles_max)

	var/power_draw = -1
	if (transfer_moles > MINIMUM_MOLES_TO_FILTER)
		power_draw = filter_gas_multi(src, filtering_outputs, input_air, output_air, transfer_moles, power_rating)

	if (power_draw >= 0)
		last_power_draw = power_draw
		use_power(power_draw)

		if(input.network)
			input.network.update = 1
		if(output.network)
			output.network.update = 1
		for(var/datum/omni_port/P in gas_filters)
			if(P.network)
				P.network.update = 1

	return 1

/obj/machinery/atmospherics/omni/filter/ui_interact(mob/user, var/datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "atmospherics/OmniFilter", name)
		ui.open()

/obj/machinery/atmospherics/omni/filter/ui_data(mob/user)
	var/list/data = new()

	data["power"] = use_power

	var/portData[0]
	for(var/datum/omni_port/P in ports)
		var/input = 0
		var/output = 0
		var/is_filter = 0
		var/f_type = null
		switch(P.mode)
			if(ATM_INPUT)
				input = 1
			if(ATM_OUTPUT)
				output = 1
			if(ATM_O2 to ATM_H2)
				is_filter = 1
				f_type = mode_send_switch(P.mode)

		portData[++portData.len] = list("dir" = dir_name(P.dir, capitalize = 1), \
										"input" = input, \
										"output" = output, \
										"isFilter" = is_filter, \
										"fType" = f_type)

	if(portData.len)
		data["ports"] = portData
	if(output)
		data["setFlowRate"] = set_flow_rate
		data["maxFlowRate"] = max_flow_rate

	return data

/obj/machinery/atmospherics/omni/filter/proc/mode_send_switch(var/mode = ATM_NONE)
	switch(mode)
		if(ATM_O2)
			return "Oxygen"
		if(ATM_N2)
			return "Nitrogen"
		if(ATM_CO2)
			return "Carbon Dioxide"
		if(ATM_P)
			return "Phoron" //*cough* Plasma *cough*
		if(ATM_N2O)
			return "Nitrous Oxide"
		if(ATM_H2)
			return "Hydrogen"
		else
			return null

/obj/machinery/atmospherics/omni/filter/ui_act(action, list/params)
	if(. = ..()) return

	switch(action)
		if("power")
			use_power = !use_power
			. = 1

		if("set_flow_rate")
			var/new_flow_rate = params["set_flow_rate"]
			set_flow_rate = between(0, new_flow_rate, max_flow_rate)
			. = 1

		if("switch_mode")
			switch_mode(dir_flag(params["dir"]), mode_return_switch(params["mode"]))
			. = 1

		if("switch_filter")
			var/new_filter = input(usr,"Select filter mode:","Change filter",params["mode"]) in list("None", "Oxygen", "Nitrogen", "Carbon Dioxide", "Phoron", "Nitrous Oxide", "Hydrogen")
			switch_filter(dir_flag(params["dir"]), mode_return_switch(new_filter))
			. = 1

	if (.)
		update_icon()

/obj/machinery/atmospherics/omni/filter/proc/mode_return_switch(var/mode)
	switch(mode)
		if("Oxygen")
			return ATM_O2
		if("Nitrogen")
			return ATM_N2
		if("Carbon Dioxide")
			return ATM_CO2
		if("Phoron")
			return ATM_P
		if("Nitrous Oxide")
			return ATM_N2O
		if("Hydrogen")
			return ATM_H2
		if("in")
			return ATM_INPUT
		if("out")
			return ATM_OUTPUT
		if("None")
			return ATM_NONE
		else
			return null

/obj/machinery/atmospherics/omni/filter/proc/switch_filter(var/dir, var/mode)
	//check they aren't trying to disable the input or output ~this can only happen if they hack the cached tmpl file
	for(var/datum/omni_port/P in ports)
		if(P.dir == dir)
			if(P.mode == ATM_INPUT || P.mode == ATM_OUTPUT)
				return

	switch_mode(dir, mode)

/obj/machinery/atmospherics/omni/filter/proc/switch_mode(var/port, var/mode)
	if(mode == null || !port)
		return
	var/datum/omni_port/target_port = null
	var/list/other_ports = new()

	for(var/datum/omni_port/P in ports)
		if(P.dir == port)
			target_port = P
		else
			other_ports += P

	var/previous_mode = null
	if(target_port)
		previous_mode = target_port.mode
		target_port.mode = mode
		if(target_port.mode != previous_mode)
			handle_port_change(target_port)
			rebuild_filtering_list()
		else
			return
	else
		return

	if(use_power)
		use_power = 0

	for(var/datum/omni_port/P in other_ports)
		if(P.mode == mode)
			var/old_mode = P.mode
			P.mode = previous_mode
			if(P.mode != old_mode)
				handle_port_change(P)

	update_ports()

/obj/machinery/atmospherics/omni/filter/proc/rebuild_filtering_list()
	filtering_outputs.Cut()
	for(var/datum/omni_port/P in ports)
		var/gasid = mode_to_gasid(P.mode)
		if(gasid)
			filtering_outputs[gasid] = P.air

/obj/machinery/atmospherics/omni/filter/proc/handle_port_change(var/datum/omni_port/P)
	switch(P.mode)
		if(ATM_NONE)
			initialize_directions &= ~P.dir
			P.disconnect()
		else
			initialize_directions |= P.dir
			P.connect()
	P.update = 1
/obj/machinery/air_sensor
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "gsensor1"
	name = "Gas Sensor"

	anchored = 1
	var/state = 0

	var/id_tag
	var/frequency = 1439

	var/on = 1
	var/output = 3
	//Flags:
	// 1 for pressure
	// 2 for temperature
	// Output >= 4 includes gas composition
	// 4 for oxygen concentration
	// 8 for phoron concentration
	// 16 for nitrogen concentration
	// 32 for carbon dioxide concentration
	// 64 for hydrogen concentration

	var/datum/radio_frequency/radio_connection

/obj/machinery/air_sensor/update_icon()
	icon_state = "gsensor[on]"

/obj/machinery/air_sensor/Process()
	if(on)
		var/datum/signal/signal = new
		signal.transmission_method = 1 //radio signal
		signal.data["tag"] = id_tag
		signal.data["timestamp"] = world.time

		var/datum/gas_mixture/air_sample = return_air()

		if(output&1)
			signal.data["pressure"] = num2text(round(air_sample.return_pressure(),0.1),)
		if(output&2)
			signal.data["temperature"] = round(air_sample.temperature,0.1)

		if(output>4)
			var/total_moles = air_sample.total_moles
			if(total_moles > 0)
				if(output&4)
					signal.data["oxygen"] = round(100*air_sample.gas["oxygen"]/total_moles,0.1)
				if(output&8)
					signal.data["phoron"] = round(100*air_sample.gas["phoron"]/total_moles,0.1)
				if(output&16)
					signal.data["nitrogen"] = round(100*air_sample.gas["nitrogen"]/total_moles,0.1)
				if(output&32)
					signal.data["carbon_dioxide"] = round(100*air_sample.gas["carbon_dioxide"]/total_moles,0.1)
				if(output&64)
					signal.data["hydrogen"] = round(100*air_sample.gas["hydrogen"]/total_moles,0.1)
			else
				signal.data["oxygen"] = 0
				signal.data["phoron"] = 0
				signal.data["nitrogen"] = 0
				signal.data["carbon_dioxide"] = 0
				signal.data["hydrogen"] = 0
		signal.data["sigtype"]="status"
		radio_connection.post_signal(src, signal, radio_filter = RADIO_ATMOSIA)


/obj/machinery/air_sensor/proc/set_frequency(new_frequency)
	radio_controller.remove_object(src, frequency)
	frequency = new_frequency
	radio_connection = radio_controller.add_object(src, frequency, RADIO_ATMOSIA)

/obj/machinery/air_sensor/Initialize()
	set_frequency(frequency)
	. = ..()

obj/machinery/air_sensor/Destroy()
	if(radio_controller)
		radio_controller.remove_object(src,frequency)
	. = ..()

/obj/machinery/computer/general_air_control
	icon = 'icons/obj/computer.dmi'
	icon_keyboard = "atmos_key"
	icon_screen = "tank"

	name = "Computer"

	var/frequency = 1439
	var/list/sensors = list()

	var/list/sensor_information = list()
	var/datum/radio_frequency/radio_connection
	circuit = /obj/item/weapon/circuitboard/air_management

obj/machinery/computer/general_air_control/Destroy()
	if(radio_controller)
		radio_controller.remove_object(src, frequency)
	..()

/obj/machinery/computer/general_air_control/receive_signal(datum/signal/signal)
	if(!signal || signal.encryption) return

	var/id_tag = signal.data["tag"]
	if(!id_tag || !sensors.Find(id_tag)) return

	sensor_information[id_tag] = signal.data

/obj/machinery/computer/general_air_control/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "atmospherics/GeneralAirControl", name)
		ui.open()

/obj/machinery/computer/general_air_control/ui_data(mob/user)
	var/list/data = list()

	data["sensors"] = list()
	for(var/id_tag in sensors)
		var/sensor_data = sensor_information[id_tag]
		if(!sensor_data)
			sensor_data = list()
		sensor_data["name"] = sensors[id_tag]
		sensor_data["id_tag"] = id_tag
		sensor_data["found"] = (sensor_information[id_tag] != 0)
		data["sensors"] += list(sensor_data)

	return data

/obj/machinery/computer/general_air_control/proc/set_frequency(new_frequency)
	radio_controller.remove_object(src, frequency)
	frequency = new_frequency
	radio_connection = radio_controller.add_object(src, frequency, RADIO_ATMOSIA)

/obj/machinery/computer/general_air_control/Initialize()
	set_frequency(frequency)
	. = ..()

/obj/machinery/computer/general_air_control/large_tank_control
	icon = 'icons/obj/computer.dmi'

	frequency = 1441
	var/input_tag
	var/output_tag

	var/list/input_info
	var/list/output_info

	var/input_flow_setting = 200
	var/pressure_setting = ONE_ATMOSPHERE * 45
	circuit = /obj/item/weapon/circuitboard/air_management/tank_control

/obj/machinery/computer/general_air_control/large_tank_control/receive_signal(datum/signal/signal)
	if(!signal || signal.encryption) return

	var/id_tag = signal.data["tag"]

	if(input_tag == id_tag)
		input_info = signal.data
	else if(output_tag == id_tag)
		output_info = signal.data
	else
		..(signal)

/obj/machinery/computer/general_air_control/large_tank_control/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "atmospherics/GasTankControl", name)
		ui.open()

/obj/machinery/computer/general_air_control/large_tank_control/ui_data(mob/user)
	var/list/data = ..()

	data["input_info"] = list(
		"found" = 0,
		"min_value" = 0,
		"max_value" = ATMOS_DEFAULT_VOLUME_PUMP + 500
	)
	if (input_info)
		data["input_info"]["found"] = 1
		data["input_info"]["power"] = input_info["power"]
		data["input_info"]["value"] = input_info["volume_rate"]

	data["output_info"] = list(
		"found" = 0,
		"min_value" = 0,
		"max_value" = MAX_PUMP_PRESSURE
	)
	if (output_info)
		data["output_info"]["found"] = 1
		data["output_info"]["power"] = output_info["power"]
		data["output_info"]["value"] = output_info["internal"]

	return data

/obj/machinery/computer/general_air_control/large_tank_control/ui_act(action, list/params)
	switch(action)
		if ("out_set_value")
			var/change = text2num(params["new_value"])
			pressure_setting = between(0, change, MAX_PUMP_PRESSURE)

		if ("in_set_value")
			var/change = text2num(params["new_value"])
			input_flow_setting = between(0, change, ATMOS_DEFAULT_VOLUME_PUMP + 500) //default flow rate limit for air injectors

	if(!radio_connection)
		return FALSE

	var/datum/signal/signal = new
	signal.transmission_method = 1 //radio signal
	signal.source = src

	switch (action)
		if("in_refresh_status")
			input_info = null
			signal.data = list ("tag" = input_tag, "status" = 1)
			. = 1

		if("in_toggle_injector")
			input_info = null
			signal.data = list ("tag" = input_tag, "power_toggle" = 1)
			. = 1

		if("in_set_value")
			input_info = null
			signal.data = list ("tag" = input_tag, "set_volume_rate" = "[input_flow_setting]")
			. = 1

		if("out_refresh_status")
			output_info = null
			signal.data = list ("tag" = output_tag, "status" = 1)
			. = 1

		if("out_toggle_power")
			output_info = null
			signal.data = list ("tag" = output_tag, "power_toggle" = 1)
			. = 1

		if("out_set_value")
			output_info = null
			signal.data = list ("tag" = output_tag, "set_internal_pressure" = "[pressure_setting]")
			. = 1

	signal.data["sigtype"]="command"
	radio_connection.post_signal(src, signal, radio_filter = RADIO_ATMOSIA)

/obj/machinery/computer/general_air_control/supermatter_core
	icon = 'icons/obj/computer.dmi'

	frequency = 1438
	var/input_tag
	var/output_tag

	var/list/input_info
	var/list/output_info

	var/input_flow_setting = 700
	var/pressure_setting = 100
	circuit = /obj/item/weapon/circuitboard/air_management/supermatter_core


/obj/machinery/computer/general_air_control/supermatter_core/proc/return_text()
	//if(signal.data)
	//	input_info = signal.data // Attempting to fix intake control -- TLE

	var/output = "<B>Core Cooling Control System</B><BR><BR>"
	if(input_info)
		var/power = (input_info["power"])
		var/volume_rate = round(input_info["volume_rate"], 0.1)
		output += "<B>Coolant Input</B>: [power?("Injecting"):("On Hold")] <A href='?src=[REF(src)];in_refresh_status=1'>Refresh</A><BR>Flow Rate Limit: [volume_rate] L/s<BR>"
		output += "Command: <A href='?src=[REF(src)];in_toggle_injector=1'>Toggle Power</A> <A href='?src=[REF(src)];in_set_flowrate=1'>Set Flow Rate</A><BR>"

	else
		output += "<FONT color='red'>ERROR: Can not find input port</FONT> <A href='?src=[REF(src)];in_refresh_status=1'>Search</A><BR>"

	output += "Flow Rate Limit: <A href='?src=[REF(src)];adj_input_flow_rate=-100'>-</A> <A href='?src=[REF(src)];adj_input_flow_rate=-10'>-</A> <A href='?src=[REF(src)];adj_input_flow_rate=-1'>-</A> <A href='?src=[REF(src)];adj_input_flow_rate=-0.1'>-</A> [round(input_flow_setting, 0.1)] L/s <A href='?src=[REF(src)];adj_input_flow_rate=0.1'>+</A> <A href='?src=[REF(src)];adj_input_flow_rate=1'>+</A> <A href='?src=[REF(src)];adj_input_flow_rate=10'>+</A> <A href='?src=[REF(src)];adj_input_flow_rate=100'>+</A><BR>"

	output += "<BR>"

	if(output_info)
		var/power = (output_info["power"])
		var/pressure_limit = output_info["external"]
		output += {"<B>Core Outpump</B>: [power?("Open"):("On Hold")] <A href='?src=[REF(src)];out_refresh_status=1'>Refresh</A><BR>
Min Core Pressure: [pressure_limit] kPa<BR>"}
		output += "Command: <A href='?src=[REF(src)];out_toggle_power=1'>Toggle Power</A> <A href='?src=[REF(src)];out_set_pressure=1'>Set Pressure</A><BR>"

	else
		output += "<FONT color='red'>ERROR: Can not find output port</FONT> <A href='?src=[REF(src)];out_refresh_status=1'>Search</A><BR>"

	output += "Min Core Pressure Set: <A href='?src=[REF(src)];adj_pressure=-100'>-</A> <A href='?src=[REF(src)];adj_pressure=-50'>-</A> <A href='?src=[REF(src)];adj_pressure=-10'>-</A> <A href='?src=[REF(src)];adj_pressure=-1'>-</A> [pressure_setting] kPa <A href='?src=[REF(src)];adj_pressure=1'>+</A> <A href='?src=[REF(src)];adj_pressure=10'>+</A> <A href='?src=[REF(src)];adj_pressure=50'>+</A> <A href='?src=[REF(src)];adj_pressure=100'>+</A><BR>"

	return output

/obj/machinery/computer/general_air_control/supermatter_core/receive_signal(datum/signal/signal)
	if(!signal || signal.encryption) return

	var/id_tag = signal.data["tag"]

	if(input_tag == id_tag)
		input_info = signal.data
	else if(output_tag == id_tag)
		output_info = signal.data
	else
		..(signal)

/obj/machinery/computer/general_air_control/supermatter_core/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "atmospherics/GasTankControl", name)
		ui.open()

/obj/machinery/computer/general_air_control/supermatter_core/Topic(href, href_list)
	if(..())
		return 1

	if(href_list["adj_pressure"])
		var/change = text2num(href_list["adj_pressure"])
		pressure_setting = between(0, pressure_setting + change, MAX_PUMP_PRESSURE)
		spawn(1)
			src.updateUsrDialog()
		return 1

	if(href_list["adj_input_flow_rate"])
		var/change = text2num(href_list["adj_input_flow_rate"])
		input_flow_setting = between(0, input_flow_setting + change, ATMOS_DEFAULT_VOLUME_PUMP + 500) //default flow rate limit for air injectors
		spawn(1)
			src.updateUsrDialog()
		return 1

	if(!radio_connection)
		return 0
	var/datum/signal/signal = new
	signal.transmission_method = 1 //radio signal
	signal.source = src
	if(href_list["in_refresh_status"])
		input_info = null
		signal.data = list ("tag" = input_tag, "status" = 1)
		. = 1

	if(href_list["in_toggle_injector"])
		input_info = null
		signal.data = list ("tag" = input_tag, "power_toggle" = 1)
		. = 1

	if(href_list["in_set_flowrate"])
		input_info = null
		signal.data = list ("tag" = input_tag, "set_volume_rate" = "[input_flow_setting]")
		. = 1

	if(href_list["out_refresh_status"])
		output_info = null
		signal.data = list ("tag" = output_tag, "status" = 1)
		. = 1

	if(href_list["out_toggle_power"])
		output_info = null
		signal.data = list ("tag" = output_tag, "power_toggle" = 1)
		. = 1

	if(href_list["out_set_pressure"])
		output_info = null
		signal.data = list ("tag" = output_tag, "set_external_pressure" = "[pressure_setting]", "checks" = 1)
		. = 1

	signal.data["sigtype"]="command"
	radio_connection.post_signal(src, signal, radio_filter = RADIO_ATMOSIA)

	spawn(5)
		src.updateUsrDialog()

/obj/machinery/computer/general_air_control/fuel_injection
	icon = 'icons/obj/computer.dmi'
	icon_screen = "alert:0"

	var/device_tag
	var/list/device_info

	var/automation = 0

	var/cutoff_temperature = 2000
	var/on_temperature = 1200
	circuit = /obj/item/weapon/circuitboard/air_management/injector_control

/obj/machinery/computer/general_air_control/fuel_injection/Process()
	if(automation)
		if(!radio_connection)
			return 0

		var/injecting = 0
		for(var/id_tag in sensor_information)
			var/list/data = sensor_information[id_tag]
			if(data["temperature"])
				if(data["temperature"] >= cutoff_temperature)
					injecting = 0
					break
				if(data["temperature"] <= on_temperature)
					injecting = 1

		var/datum/signal/signal = new
		signal.transmission_method = 1 //radio signal
		signal.source = src

		signal.data = list(
			"tag" = device_tag,
			"power" = injecting,
			"sigtype"="command"
		)

		radio_connection.post_signal(src, signal, radio_filter = RADIO_ATMOSIA)

	..()

/obj/machinery/computer/general_air_control/fuel_injection/proc/return_text()
	var/output = "<B>Fuel Injection System</B><BR>"
	if(device_info)
		var/power = device_info["power"]
		var/volume_rate = device_info["volume_rate"]
		output += {"Status: [power?("Injecting"):("On Hold")] <A href='?src=[REF(src)];refresh_status=1'>Refresh</A><BR>
Rate: [volume_rate] L/sec<BR>"}

		if(automation)
			output += "Automated Fuel Injection: <A href='?src=[REF(src)];toggle_automation=1'>Engaged</A><BR>"
			output += "Injector Controls Locked Out<BR>"
		else
			output += "Automated Fuel Injection: <A href='?src=[REF(src)];toggle_automation=1'>Disengaged</A><BR>"
			output += "Injector: <A href='?src=[REF(src)];toggle_injector=1'>Toggle Power</A> <A href='?src=[REF(src)];injection=1'>Inject (1 Cycle)</A><BR>"

	else
		output += "<FONT color='red'>ERROR: Can not find device</FONT> <A href='?src=[REF(src)];refresh_status=1'>Search</A><BR>"

	return output

/obj/machinery/computer/general_air_control/fuel_injection/receive_signal(datum/signal/signal)
	if(!signal || signal.encryption) return

	var/id_tag = signal.data["tag"]

	if(device_tag == id_tag)
		device_info = signal.data
	else
		..(signal)

/obj/machinery/computer/general_air_control/fuel_injection/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "atmospherics/FuelInjectionControl", name)
		ui.open()

/obj/machinery/computer/general_air_control/fuel_injection/ui_data(mob/user)
	var/list/data = list()

	if (device_info)
		data["power"] = device_info["power"]
		data["volume_rate"] = device_info["volume_rate"]
		data["automation"] = automation

	return data

/obj/machinery/computer/general_air_control/fuel_injection/ui_act(action, list/params)
	switch (action)
		if ("refresh_status")
			device_info = null
			if(!radio_connection)
				return FALSE

			var/datum/signal/signal = new
			signal.transmission_method = 1 //radio signal
			signal.source = src
			signal.data = list(
				"tag" = device_tag,
				"status" = 1,
				"sigtype"="command"
			)
			radio_connection.post_signal(src, signal, radio_filter = RADIO_ATMOSIA)

		if("toggle_automation")
			automation = !automation

		if("toggle_injector")
			device_info = null
			if(!radio_connection)
				return FALSE

			var/datum/signal/signal = new
			signal.transmission_method = 1 //radio signal
			signal.source = src
			signal.data = list(
				"tag" = device_tag,
				"power_toggle" = 1,
				"sigtype"="command"
			)

			radio_connection.post_signal(src, signal, radio_filter = RADIO_ATMOSIA)

		if("injection")
			if(!radio_connection)
				return FALSE

			var/datum/signal/signal = new
			signal.transmission_method = 1 //radio signal
			signal.source = src
			signal.data = list(
				"tag" = device_tag,
				"inject" = 1,
				"sigtype"="command"
			)

			radio_connection.post_signal(src, signal, radio_filter = RADIO_ATMOSIA)


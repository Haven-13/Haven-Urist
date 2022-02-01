//Engine control and monitoring console

/obj/machinery/computer/ship/engines
	name = "engine control console"
	icon_keyboard = "tech_key"
	icon_screen = "engines"
	circuit = /obj/item/weapon/circuitboard/engine

/obj/machinery/computer/ship/engines/attack_hand(var/mob/user as mob)
	if(..())
		user.unset_machine()
		return

	if(!isAI(user))
		user.set_machine(src)

	ui_interact(user)

/obj/machinery/computer/ship/engines/ui_interact(mob/user, var/datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "spacecraft/ShipEnginesControl", name)
		ui.open()

/obj/machinery/computer/ship/engines/ui_data(mob/user)
	var/data[0]
	data["globalState"] = linked.engines_state
	data["globalThrustLimit"] = linked.thrust_limit
	var/total_thrust = 0

	var/list/enginfo[0]
	for(var/datum/ship_engine/E in linked.engines)
		var/list/rdata[0]
		rdata["type"] = E.name
		rdata["on"] = E.is_on()
		rdata["thrust"] = E.get_thrust()
		rdata["locationName"] = E.get_area_name()
		rdata["thrustLimit"] = E.get_thrust_limit()
		rdata["status"] = E.get_status()
		rdata["reference"] = REF(E)
		total_thrust += E.get_thrust()
		enginfo.Add(list(rdata))

	data["enginesInfo"] = enginfo
	data["totalThrust"] = total_thrust

	return data

/obj/machinery/computer/ship/engines/ui_act(action, list/params)
	UI_ACT_CHECK

	switch(action)
		if("global_set_state")
			linked.engines_state = params["state"]
			for(var/datum/ship_engine/E in linked.engines)
				if(linked.engines_state != E.is_on())
					E.toggle()
		if("set_global_limit")
			linked.thrust_limit = Clamp(params["set_global_limit"], 0, 1)
			for(var/datum/ship_engine/E in linked.engines)
				E.set_thrust_limit(linked.thrust_limit)
		if("engine")
			var/datum/ship_engine/E = locate(params["engine"])
			if (istype(E))
				switch(params["action"])
					if("set_limit")
						E.set_thrust_limit(Clamp(params["value"], 0, 1))
					if("toggle")
						E.toggle()
	. = TRUE

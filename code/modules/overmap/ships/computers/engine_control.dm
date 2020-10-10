//Engine control and monitoring console

/obj/machinery/computer/engines
	name = "engine control console"
	icon_keyboard = "tech_key"
	icon_screen = "engines"
	circuit = /obj/item/weapon/circuitboard/engine
	var/state = "status"
	var/obj/effect/overmap/ship/linked

/obj/machinery/computer/engines/Initialize()
	. = ..()
	linked = map_sectors["[z]"]

/obj/machinery/computer/engines/attack_hand(var/mob/user as mob)
	if(..())
		user.unset_machine()
		return

	if(!isAI(user))
		user.set_machine(src)

	ui_interact(user)

/obj/machinery/computer/engines/ui_interact(mob/user, var/datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "spacecraft/ShipEnginesControl")
		ui.open()

/obj/machinery/computer/engines/ui_data(mob/user)
	var/data[0]
	data["state"] = state
	data["global_state"] = linked.engines_state
	data["global_limit"] = round(linked.thrust_limit*100)
	var/total_thrust = 0

	var/list/enginfo[0]
	for(var/datum/ship_engine/E in linked.engines)
		var/list/rdata[0]
		rdata["eng_type"] = E.name
		rdata["eng_on"] = E.is_on()
		rdata["eng_thrust"] = E.get_thrust()
		rdata["eng_thrust_limiter"] = round(E.get_thrust_limit()*100)
		rdata["eng_status"] = E.get_status()
		rdata["eng_reference"] = "\ref[E]"
		total_thrust += E.get_thrust()
		enginfo.Add(list(rdata))

	data["engines_info"] = enginfo
	data["total_thrust"] = total_thrust

	return data

/obj/machinery/computer/engines/ui_act(action, list/params)
	switch(action)
		if("state")
			state = params["state"]
		if("global_toggle")
			linked.engines_state = !linked.engines_state
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

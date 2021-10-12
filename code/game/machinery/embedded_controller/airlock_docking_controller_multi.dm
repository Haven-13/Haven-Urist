//a controller for a docking port with multiple independent airlocks
//this is the master controller, that things will try to dock with.
/obj/machinery/embedded_controller/radio/docking_port_multi
	name = "docking port controller"

	var/child_tags_txt
	var/child_names_txt
	var/list/child_names = list()

	var/datum/computer/file/embedded_program/docking/multi/docking_program

/obj/machinery/embedded_controller/radio/docking_port_multi/New()
	..()
	docking_program = new/datum/computer/file/embedded_program/docking/multi(src)
	program = docking_program

	var/list/names = splittext(child_names_txt, ";")
	var/list/tags = splittext(child_tags_txt, ";")

	if (names.len == tags.len)
		for (var/i = 1; i <= tags.len; i++)
			child_names[tags[i]] = names[i]


/obj/machinery/embedded_controller/radio/docking_port_multi/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "AirlockDockingMultiController")
		ui.open()


/obj/machinery/embedded_controller/radio/docking_port_multi/ui_data(mob/user)
	var/data[0]

	var/list/airlocks[child_names.len]
	var/i = 1
	for (var/child_tag in child_names)
		airlocks[i++] = list("name"=child_names[child_tag], "override_enabled"=(docking_program.children_override[child_tag] == "enabled"))

	data = list(
		"docking_status" = docking_program.get_docking_status(),
		"airlocks" = airlocks,
	)

	return data

/obj/machinery/embedded_controller/radio/docking_port_multi/Topic(href, href_list)
	return



//a docking port based on an airlock
/obj/machinery/embedded_controller/radio/airlock/docking_port_multi
	name = "docking port controller"
	var/master_tag	//for mapping
	var/datum/computer/file/embedded_program/airlock/multi_docking/airlock_program
	tag_secure = 1

/obj/machinery/embedded_controller/radio/airlock/docking_port_multi/Initialize()
	. = ..()
	airlock_program = new/datum/computer/file/embedded_program/airlock/multi_docking(src)
	program = airlock_program

/obj/machinery/embedded_controller/radio/airlock/docking_port_multi/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "AirlockDockingController")
		ui.open()

/obj/machinery/embedded_controller/radio/airlock/docking_port_multi/ui_data(mob/user)
	. = list(
		"chamberPressure" = round(airlock_program.memory["chamber_sensor_pressure"]),
		"exteriorStatus" = airlock_program.memory["exterior_status"],
		"interiorStatus" = airlock_program.memory["interior_status"],
		"processing" = airlock_program.memory["processing"],
		"dockingStatus" = airlock_program.master_status,
		"airlockDisabled" = (airlock_program.docking_enabled && !airlock_program.override_enabled),
		"overrideEnabled" = airlock_program.override_enabled,
	)

/obj/machinery/embedded_controller/radio/airlock/docking_port_multi/ui_act(action, list/params)
	switch(action)
		if("command")
			if(params["command"] in list(
					"cycle_ext",
					"cycle_int",
					"force_int",
					"force_ext",
					"abort",
					"toggle_override",
					"dock"))
				program.receive_user_command(params["command"])
			. = TRUE
/*** DEBUG VERBS ***

/datum/computer/file/embedded_program/docking/multi/proc/print_state()
	log_debug("id_tag: [id_tag]")
	log_debug("dock_state: [dock_state]")
	log_debug("control_mode: [control_mode]")
	log_debug("tag_target: [tag_target]")
	log_debug("response_sent: [response_sent]")

/datum/computer/file/embedded_program/docking/multi/post_signal(datum/signal/signal, comm_line)
	log_debug("Program [id_tag] sent a message!")

	print_state()
	log_debug("[id_tag] sent command \"[signal.data["command"]]\" to \"[signal.data["recipient"]]\"")

	..(signal)

/obj/machinery/embedded_controller/radio/docking_port_multi/verb/view_state()
	set category = "Debug"
	set src in view(1)
	src.program:print_state()

/obj/machinery/embedded_controller/radio/docking_port_multi/verb/spoof_signal(var/command as text, var/sender as text)
	set category = "Debug"
	set src in view(1)
	var/datum/signal/signal = new
	signal.data["tag"] = sender
	signal.data["command"] = command
	signal.data["recipient"] = id_tag

	src.program:receive_signal(signal)

/obj/machinery/embedded_controller/radio/docking_port_multi/verb/debug_init_dock(var/target as text)
	set category = "Debug"
	set src in view(1)
	src.program:initiate_docking(target)

/obj/machinery/embedded_controller/radio/docking_port_multi/verb/debug_init_undock()
	set category = "Debug"
	set src in view(1)
	src.program:initiate_undocking()

*/

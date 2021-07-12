
/*
General message handling stuff
*/
GLOBAL_LIST_EMPTY(comm_message_listeners) //We first have to initialize list then we can use it.
GLOBAL_DATUM_INIT(global_message_listener, /datum/comm_message_listener, new) //May be used by admins
GLOBAL_VAR_INIT(last_message_id, 0)

/proc/get_comm_message_id()
	GLOB.last_message_id += 1
	return GLOB.last_message_id

/proc/post_comm_message(var/message_title, var/message_text)
	var/list/message = list()
	message["id"] = get_comm_message_id()
	message["title"] = message_title
	message["contents"] = message_text

	for (var/datum/comm_message_listener/l in GLOB.comm_message_listeners)
		l.Add(message)

/datum/comm_message_listener
	var/list/messages

/datum/comm_message_listener/New()
	..()
	messages = list()
	GLOB.comm_message_listeners.Add(src)

/datum/comm_message_listener/proc/Add(var/list/message)
	messages[++messages.len] = message

/datum/comm_message_listener/proc/Remove(var/list/message)
	messages -= list(message)

/proc/post_status(var/command, var/data1, var/data2)

	var/datum/radio_frequency/frequency = radio_controller.return_frequency(1435)

	if(!frequency) return

	var/datum/signal/status_signal = new
	status_signal.transmission_method = 1
	status_signal.data["command"] = command

	switch(command)
		if("message")
			status_signal.data["msg1"] = data1
			status_signal.data["msg2"] = data2
			log_admin("STATUS: [key_name(usr)] set status screen message: [data1] [data2]")
		if("image")
			status_signal.data["picture_state"] = data1

	frequency.post_signal(signal = status_signal)

/proc/cancel_call_proc(var/mob/user)
	if (!evacuation_controller)
		return

	if(evacuation_controller.cancel_evacuation())
		log_game("[key_name(user)] has cancelled the evacuation.")
		message_admins("[key_name_admin(user)] has cancelled the evacuation.", 1)

	return


/proc/is_relay_online()
	for(var/obj/machinery/bluespacerelay/M in SSmachines.machinery)
		if(M.stat == 0)
			return 1
	return 0

/proc/call_shuttle_proc(var/mob/user, var/emergency)
	if (!evacuation_controller)
		return

	if(isnull(emergency))
		emergency = 1

	if(!GLOB.universe.OnShuttleCall(usr))
		to_chat(user, "<span class='notice'>Cannot establish a bluespace connection.</span>")
		return

	if(GLOB.deathsquad.deployed)
		to_chat(user, "[GLOB.using_map.boss_short] will not allow an evacuation to take place. Consider all contracts terminated.")
		return

	if(evacuation_controller.deny)
		to_chat(user, "An evacuation cannot be called at this time. Please try again later.")
		return

	if(evacuation_controller.is_on_cooldown()) // Ten minute grace period to let the game get going without lolmetagaming. -- TLE
		to_chat(user, evacuation_controller.get_cooldown_message())

	if(evacuation_controller.is_evacuating())
		to_chat(user, "An evacuation is already underway.")
		return

	if(evacuation_controller.call_evacuation(user, _emergency_evac = emergency))
		log_and_message_admins("[user? key_name(user) : "Autotransfer"] has called the shuttle.")

/proc/init_autotransfer()

	if (!evacuation_controller)
		return

	. = evacuation_controller.call_evacuation(null, _emergency_evac = FALSE, autotransfer = TRUE)
	if(.)
		//delay events in case of an autotransfer
		var/delay = evacuation_controller.evac_arrival_time - world.time + (2 MINUTES)
		SSevent.delay_events(EVENT_LEVEL_MODERATE, delay)
		SSevent.delay_events(EVENT_LEVEL_MAJOR, delay)

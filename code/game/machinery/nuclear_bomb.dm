var/bomb_set

#define NUKEUI_AWAIT_DISK 1
#define NUKEUI_AWAIT_CODE 2
#define NUKEUI_AWAIT_TIMER 3
#define NUKEUI_AWAIT_ARM 4
#define NUKEUI_TIMING 5
#define NUKEUI_EXPLODED 6

/obj/machinery/nuclearbomb
	name = "\improper Nuclear Fission Explosive"
	desc = "Uh oh. RUN!"
	icon = 'resources/icons/obj/nuke.dmi'
	icon_state = "idle"
	density = 1
	use_power = 0
	unacidable = 1

	var/timer_set = 90
	var/minimum_timer_set = 90
	var/maximum_timer_set = 3600

	var/numeric_input = ""
	var/ui_mode = NUKEUI_AWAIT_DISK

	var/exploded = FALSE
	var/deployable = FALSE
	var/extended = FALSE
	var/lighthack = 0
	var/time_left = 120
	var/timing = 0
	var/r_code = "ADMIN"
	var/code = ""
	var/yes_code = FALSE
	var/safety = TRUE
	var/obj/item/weapon/disk/nuclear/auth = null
	var/removal_stage = 0 // 0 is no removal, 1 is covers removed, 2 is covers open, 3 is sealant open, 4 is unwrenched, 5 is removed from bolts.
	var/lastentered
	var/previous_level = ""
	var/datum/wires/nuclearbomb/wires = null
	var/decl/security_level/original_level

/obj/machinery/nuclearbomb/New()
	..()
	r_code = "[rand(10000, 99999.0)]"//Creates a random code upon object spawn.
	wires = new/datum/wires/nuclearbomb(src)

/obj/machinery/nuclearbomb/Destroy()
	qdel(wires)
	wires = null
	qdel(auth)
	auth = null
	return ..()

/obj/machinery/nuclearbomb/Process(var/wait)
	if(timing)
		time_left = max(time_left - (wait / 10), 0)
		playsound(loc, 'resources/sound/items/timer.ogg', 50)
		if(time_left <= 0)
			addtimer(CALLBACK(src, PROC_REF(explode)), 0)
		SStgui.update_uis(src)

/obj/machinery/nuclearbomb/attackby(obj/item/weapon/O as obj, mob/user as mob, params)
	if(is_screwdriver(O))
		add_fingerprint(user)
		if(auth)
			if(panel_open == 0)
				panel_open = 1
				overlays |= "panel_open"
				to_chat(user, "You unscrew the control panel of [src].")
				playsound(src, 'resources/sound/items/Screwdriver.ogg', 50, 1)
			else
				panel_open = 0
				overlays -= "panel_open"
				to_chat(user, "You screw the control panel of [src] back on.")
				playsound(src, 'resources/sound/items/Screwdriver.ogg', 50, 1)
		else
			if(panel_open == 0)
				to_chat(user, "\The [src] emits a buzzing noise, the panel staying locked in.")
			if(panel_open == 1)
				panel_open = 0
				overlays -= "panel_open"
				to_chat(user, "You screw the control panel of \the [src] back on.")
				playsound(src, 'resources/sound/items/Screwdriver.ogg', 50, 1)
			flick("lock", src)
		return

	if(panel_open && is_multitool(O) || is_wirecutter(O))
		return attack_hand(user)

	if(extended)
		if(istype(O, /obj/item/weapon/disk/nuclear))
			if(!user.unEquip(O, src))
				return
			auth = O
			add_fingerprint(user)
			return attack_hand(user)

	if(anchored)
		switch(removal_stage)
			if(0)
				if(is_welder(O))
					var/obj/item/weapon/weldingtool/WT = O
					if(!WT.isOn()) return
					if(WT.get_fuel() < 5) // uses up 5 fuel.
						to_chat(user, "<span class='warning'>You need more fuel to complete this task.</span>")
						return

					user.visible_message("[user] starts cutting loose the anchoring bolt covers on [src].", "You start cutting loose the anchoring bolt covers with [O]...")

					if(do_after(user,40, src))
						if(!src || !user || !WT.remove_fuel(5, user)) return
						user.visible_message("\The [user] cuts through the bolt covers on \the [src].", "You cut through the bolt cover.")
						removal_stage = 1
				return

			if(1)
				if(is_crowbar(O))
					user.visible_message("[user] starts forcing open the bolt covers on [src].", "You start forcing open the anchoring bolt covers with [O]...")

					if(do_after(user, 15, src))
						if(!src || !user) return
						user.visible_message("\The [user] forces open the bolt covers on \the [src].", "You force open the bolt covers.")
						removal_stage = 2
				return

			if(2)
				if(is_welder(O))
					var/obj/item/weapon/weldingtool/WT = O
					if(!WT.isOn()) return
					if (WT.get_fuel() < 5) // uses up 5 fuel.
						to_chat(user, "<span class='warning'>You need more fuel to complete this task.</span>")
						return

					user.visible_message("[user] starts cutting apart the anchoring system sealant on [src].", "You start cutting apart the anchoring system's sealant with [O]...")

					if(do_after(user, 40, src))
						if(!src || !user || !WT.remove_fuel(5, user)) return
						user.visible_message("\The [user] cuts apart the anchoring system sealant on \the [src].", "You cut apart the anchoring system's sealant.")
						removal_stage = 3
				return

			if(3)
				if(is_wrench(O))
					user.visible_message("[user] begins unwrenching the anchoring bolts on [src].", "You begin unwrenching the anchoring bolts...")
					if(do_after(user, 50, src))
						if(!src || !user) return
						user.visible_message("[user] unwrenches the anchoring bolts on [src].", "You unwrench the anchoring bolts.")
						removal_stage = 4
				return

			if(4)
				if(is_crowbar(O))
					user.visible_message("[user] begins lifting [src] off of the anchors.", "You begin lifting the device off the anchors...")
					if(do_after(user, 80, src))
						if(!src || !user) return
						user.visible_message("\The [user] crowbars \the [src] off of the anchors. It can now be moved.", "You jam the crowbar under the nuclear device and lift it off its anchors. You can now move it!")
						anchored = 0
						removal_stage = 5
				return
	..()

/obj/machinery/nuclearbomb/attack_ghost(mob/user as mob)
	attack_hand(user)

/obj/machinery/nuclearbomb/attack_hand(mob/user as mob)
	update_ui_mode()
	if(extended)
		if(panel_open)
			wires.Interact(user)
		else
			ui_interact(user)
	else if(deployable)
		if(removal_stage < 5)
			src.anchored = 1
			visible_message("<span class='warning'>With a steely snap, bolts slide out of [src] and anchor it to the flooring!</span>")
		else
			visible_message("<span class='warning'>\The [src] makes a highly unpleasant crunching noise. It looks like the anchoring bolts have been cut.</span>")
		extended = 1
		if(!src.lighthack)
			flick("lock", src)
			update_icon()
	return

/obj/machinery/nuclearbomb/verb/toggle_deployable()
	set category = "Object"
	set name = "Toggle Deployable"
	set src in oview(1)

	if(usr.incapacitated())
		return

	if(deployable)
		to_chat(usr, "<span class='warning'>You close several panels to make [src] undeployable.</span>")
		deployable = 0
	else
		to_chat(usr, "<span class='warning'>You adjust some panels to make [src] deployable.</span>")
		deployable = 1
	return

/obj/machinery/nuclearbomb/ui_interact(mob/user, var/datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "NuclearBomb")
		ui.open()

/obj/machinery/nuclearbomb/proc/update_ui_mode()
	if(exploded)
		ui_mode = NUKEUI_EXPLODED
		return

	if(!auth)
		ui_mode = NUKEUI_AWAIT_DISK
		return

	if(timing)
		ui_mode = NUKEUI_TIMING
		return

	if(!safety)
		ui_mode = NUKEUI_AWAIT_ARM
		return

	if(!yes_code)
		ui_mode = NUKEUI_AWAIT_CODE
		return

	ui_mode = NUKEUI_AWAIT_TIMER

/obj/machinery/nuclearbomb/ui_data(mob/user)
	. = list()

	var/hidden_code = (ui_mode == NUKEUI_AWAIT_CODE && numeric_input != "ERROR")

	var/current_code = ""
	if(hidden_code)
		while(length(current_code) < length(numeric_input))
			current_code = "[current_code]*"
	else
		current_code = numeric_input
	while(length(current_code) < 5)
		current_code = "[current_code]-"

	var/first_status
	var/second_status
	switch(ui_mode)
		if(NUKEUI_AWAIT_DISK)
			first_status = "DEVICE LOCKED"
			if(timing)
				second_status = "TIME: [get_time_left()]"
			else
				second_status = "AWAITING DISK"
		if(NUKEUI_AWAIT_CODE)
			first_status = "INPUT CODE"
			second_status = "CODE: [current_code]"
		if(NUKEUI_AWAIT_TIMER)
			first_status = "INPUT TIME"
			second_status = "TIME: [current_code]"
		if(NUKEUI_AWAIT_ARM)
			first_status = "DEVICE READY"
			second_status = "TIME: [get_time_left()]"
		if(NUKEUI_TIMING)
			first_status = "DEVICE ARMED"
			second_status = "TIME: [get_time_left()]"
		if(NUKEUI_EXPLODED)
			first_status = "DEVICE DEPLOYED"
			second_status = "THANK YOU"

	.["status1"] = first_status
	.["status2"] = second_status
	.["immobile"] = FALSE

/obj/machinery/nuclearbomb/ui_act(action, params)
	. = ..()
	if(.)
		return
	playsound(src, "terminal_type", 20, FALSE)
	switch(action)
		if("eject_disk")
			if(auth && auth.loc == src)
				playsound(src, 'resources/sound/machines/terminal_insert_disc.ogg', 50, FALSE)
				playsound(src, 'resources/sound/machines/nuke/general_beep.ogg', 50, FALSE)
				auth.forceMove(get_turf(src))
				auth = null
				. = TRUE
			else
				var/obj/item/I = usr.get_active_hand()
				if(I && istype(I, /obj/item/weapon/disk/nuclear) && usr.drop_item(I) && I.forceMove(src))
					playsound(src, 'resources/sound/machines/terminal_insert_disc.ogg', 50, FALSE)
					playsound(src, 'resources/sound/machines/nuke/general_beep.ogg', 50, FALSE)
					auth = I
					. = TRUE
			update_ui_mode()
		if("keypad")
			if(auth)
				var/digit = params["digit"]
				switch(digit)
					if("C")
						if(auth && ui_mode == NUKEUI_AWAIT_ARM)
							set_safety()
							yes_code = FALSE
							playsound(src, 'resources/sound/machines/nuke/confirm_beep.ogg', 50, FALSE)
							update_ui_mode()
						else
							playsound(src, 'resources/sound/machines/nuke/general_beep.ogg', 50, FALSE)
						numeric_input = ""
						. = TRUE
					if("E")
						switch(ui_mode)
							if(NUKEUI_AWAIT_CODE)
								if(numeric_input == r_code)
									numeric_input = ""
									yes_code = TRUE
									playsound(src, 'resources/sound/machines/nuke/general_beep.ogg', 50, FALSE)
									. = TRUE
								else
									playsound(src, 'resources/sound/machines/nuke/angry_beep.ogg', 50, FALSE)
									numeric_input = "ERROR"
							if(NUKEUI_AWAIT_TIMER)
								var/number_value = text2num(numeric_input)
								if(number_value)
									timer_set = clamp(number_value, minimum_timer_set, maximum_timer_set)
									playsound(src, 'resources/sound/machines/nuke/general_beep.ogg', 50, FALSE)
									set_safety()
									. = TRUE
							else
								playsound(src, 'resources/sound/machines/nuke/angry_beep.ogg', 50, FALSE)
						update_ui_mode()
					if("0","1","2","3","4","5","6","7","8","9")
						if(numeric_input != "ERROR")
							numeric_input += digit
							if(length(numeric_input) > 5)
								numeric_input = "ERROR"
							else
								playsound(src, 'resources/sound/machines/nuke/general_beep.ogg', 50, FALSE)
							. = TRUE
			else
				playsound(src, 'resources/sound/machines/nuke/angry_beep.ogg', 50, FALSE)
		if("arm")
			if(auth && yes_code && !safety && !exploded)
				playsound(src, 'resources/sound/machines/nuke/confirm_beep.ogg', 50, FALSE)
				set_active()
				update_ui_mode()
				. = TRUE
			else
				playsound(src, 'resources/sound/machines/nuke/angry_beep.ogg', 50, FALSE)
		if("anchor")
			if(auth)
				playsound(src, 'resources/sound/machines/nuke/general_beep.ogg', 50, FALSE)
				set_anchor()
			else
				playsound(src, 'resources/sound/machines/nuke/angry_beep.ogg', 50, FALSE)

/obj/machinery/nuclearbomb/proc/set_anchor()
	if(isinspace() && !anchored)
		to_chat(usr, "<span class='warning'>There is nothing to anchor to!</span>")
	else
		anchored = !anchored

/obj/machinery/nuclearbomb/proc/set_active()
	if(safety)
		to_chat(usr, "<span class='danger'>The safety is still on.</span>")
		return
	timing = !timing
	if(timing)
		start_bomb()
	else
		check_cutoff()

/obj/machinery/nuclearbomb/proc/set_safety()
	safety = !safety
	if(safety)
		check_cutoff()

/obj/machinery/nuclearbomb/proc/get_time_left()
	if(timing)
		. = round(max(0, time_left), 1)
	else
		. = timer_set

/obj/machinery/nuclearbomb/proc/start_bomb()
	timing = 1
	time_left = clamp(timer_set, minimum_timer_set, maximum_timer_set)
	log_and_message_admins("activated the detonation countdown of \the [src]")
	bomb_set++ //There can still be issues with this resetting when there are multiple bombs. Not a big deal though for Nuke/N
	var/decl/security_state/security_state = decls_repository.get_decl(GLOB.using_map.security_state)
	original_level = security_state.current_security_level
	security_state.set_security_level(security_state.severe_security_level, TRUE)
	update_icon()

/obj/machinery/nuclearbomb/proc/check_cutoff()
	secure_device()

/obj/machinery/nuclearbomb/proc/secure_device()
	if(timing <= 0)
		return
	var/decl/security_state/security_state = decls_repository.get_decl(GLOB.using_map.security_state)
	security_state.set_security_level(original_level, TRUE)
	bomb_set--
	safety = TRUE
	timing = 0
	time_left = clamp(time_left, minimum_timer_set, maximum_timer_set)
	update_icon()

/obj/machinery/nuclearbomb/ex_act(severity)
	return

#define NUKERANGE 80
/obj/machinery/nuclearbomb/proc/explode()
	if (safety)
		timing = 0
		return
	timing = -1
	yes_code = 0
	safety = 1
	exploded = TRUE
	update_icon()

	SetUniversalState(/datum/universal_state/nuclear_explosion, arguments=list(src))

/obj/machinery/nuclearbomb/update_icon()
	if(lighthack)
		icon_state = "idle"
	else if(timing == -1)
		icon_state = "exploding"
	else if(timing)
		icon_state = "urgent"
	else if(extended || !safety)
		icon_state = "greenlight"
	else
		icon_state = "idle"

//====The nuclear authentication disc====
/obj/item/weapon/disk/nuclear
	name = "nuclear authentication disk"
	desc = "Better keep this safe."
	icon = 'resources/icons/obj/items.dmi'
	icon_state = "nucleardisk"
	item_state = "card-id"
	w_class = ITEM_SIZE_TINY


/obj/item/weapon/disk/nuclear/Initialize()
	. = ..()
	nuke_disks |= src
	// Can never be quite sure that a game mode has been properly initiated or not at this point, so always register
	GLOB.moved_event.register(src, src, /obj/item/weapon/disk/nuclear/proc/check_z_level)

/obj/item/weapon/disk/nuclear/proc/check_z_level()
	if(!(istype(SSticker.mode, /datum/game_mode/nuclear)))
		GLOB.moved_event.unregister(src, src, /obj/item/weapon/disk/nuclear/proc/check_z_level) // However, when we are certain unregister if necessary
		return
	var/turf/T = get_turf(src)
	if(!T || isNotStationLevel(T.z))
		qdel(src)

/obj/item/weapon/disk/nuclear/Destroy()
	GLOB.moved_event.unregister(src, src, /obj/item/weapon/disk/nuclear/proc/check_z_level)
	nuke_disks -= src
	if(!nuke_disks.len)
		var/turf/T = pick_area_turf(/area/maintenance, list(GLOBAL_PROC_REF(is_station_turf), GLOBAL_PROC_REF(not_turf_contains_dense_objects)))
		if(T)
			var/obj/D = new /obj/item/weapon/disk/nuclear(T)
			log_and_message_admins("[src], the last authentication disk, has been destroyed. Spawning [D] at ([D.x], [D.y], [D.z]).", location = T)
		else
			log_and_message_admins("[src], the last authentication disk, has been destroyed. Failed to respawn disc!")
	return ..()

//====the nuclear football (holds the disk and instructions)====
/obj/item/weapon/storage/secure/briefcase/nukedisk
	desc = "A large briefcase with a digital locking system."
	startswith = list(
		/obj/item/weapon/disk/nuclear,
		/obj/item/weapon/pinpointer,
		/obj/item/weapon/folder/envelope/nuke_instructions,
		/obj/item/modular_computer/laptop/preset/custom_loadout/cheap/
	)

/obj/item/weapon/storage/secure/briefcase/nukedisk/examine(var/user)
	..()
	to_chat(user,"On closer inspection, you see \a [GLOB.using_map.company_name] emblem is etched into the front of it.")

/obj/item/weapon/folder/envelope/nuke_instructions
	name = "instructions envelope"
	desc = "A small envelope. The label reads 'open only in event of high emergency'."

/obj/item/weapon/folder/envelope/nuke_instructions/Initialize()
	. = ..()
	var/obj/item/weapon/paper/R = new(src)
	R.set_content("<center><img src=sollogo.png><br><br>\
	<b>Warning: Classified<br>[GLOB.using_map.station_name] Self-Destruct System - Instructions</b></center><br><br>\
	In the event of a Delta-level emergency, this document will guide you through the activation of the vessel's \
	on-board nuclear self-destruct system. Please read carefully.<br><br>\
	1) (Optional) Announce the imminent activation to any surviving crew members, and begin evacuation procedures.<br>\
	2) Notify two heads of staff, both with ID cards with access to the ship's Keycard Authentication Devices.<br>\
	3) Proceed to the self-destruct chamber, located on Deck One by the stairwell.<br>\
	4) Unbolt the door and enter the chamber.<br>\
	5) Both heads of staff should stand in front of their own Keycard Authentication Devices. On the KAD interface, select \
	Grant Nuclear Authentication Code. Both heads of staff should then swipe their ID cards simultaneously.<br>\
	6) The KAD will now display the Authentication Code. Memorize this code.<br>\
	7) Insert the nuclear authentication disk into the self-destruct terminal.<br>\
	8) Enter the code into the self-destruct terminal.<br>\
	9) Authentication procedures are now complete. Open the two cabinets containing the nuclear cylinders. They are \
	located on the back wall of the chamber.<br>\
	10) Place the cylinders upon the six nuclear cylinder inserters.<br>\
	11) Activate the inserters. The cylinders will be pulled down into the self-destruct system.<br>\
	12) Return to the terminal. Enter the desired countdown time.<br>\
	13) When ready, disable the safety switch.<br>\
	14) Start the countdown.<br><br>\
	This concludes the instructions.", "vessel self-destruct instructions")

	//stamp the paper
	var/image/stampoverlay = image('resources/icons/obj/bureaucracy.dmi')
	stampoverlay.icon_state = "paper_stamp-hos"
	R.stamped += /obj/item/weapon/stamp
	R.overlays += stampoverlay
	R.stamps += "<HR><i>This paper has been stamped as 'Top Secret'.</i>"

//====vessel self-destruct system====
/obj/machinery/nuclearbomb/station
	name = "self-destruct terminal"
	desc = "For when it all gets too much to bear. Do not taunt."
	icon = 'resources/icons/obj/nuke_station.dmi'
	anchored = 1
	deployable = 1
	extended = 1

	var/list/flash_tiles = list()
	var/list/inserters = list()
	var/last_turf_state

	var/announced = 0
	var/time_to_explosion = 0
	var/self_destruct_cutoff = 60 //Seconds

/obj/machinery/nuclearbomb/station/Initialize()
	. = ..()
	verbs -= /obj/machinery/nuclearbomb/verb/toggle_deployable
	for(var/turf/simulated/floor/T in get_area(src))
		if(istype(T.flooring, /decl/flooring/reinforced/circuit/red))
			flash_tiles += T
	update_icon()
	for(var/obj/machinery/self_destruct/ch in get_area(src))
		inserters += ch

/obj/machinery/nuclearbomb/station/attackby(obj/item/weapon/O as obj, mob/user as mob)
	if(istype(O, /obj/item/weapon/disk/nuclear))
		if(!user.unEquip(O, src))
			return
		auth = O
		add_fingerprint(user)
		return attack_hand(user)

/obj/machinery/nuclearbomb/station/start_bomb()
	for(var/inserter in inserters)
		var/obj/machinery/self_destruct/sd = inserter
		if(!istype(sd) || !sd.armed)
			to_chat(usr, "<span class='warning'>An inserter has not been armed or is damaged.</span>")
			return
	visible_message("<span class='warning'>Warning. The self-destruct sequence override will be disabled [self_destruct_cutoff] seconds before detonation.</span>")
	..()

/obj/machinery/nuclearbomb/station/check_cutoff()
	if(time_left <= self_destruct_cutoff)
		visible_message("<span class='warning'>Self-Destruct abort is no longer possible.</span>")
		return
	..()

/obj/machinery/nuclearbomb/station/ui_data(mob/user)
	. = ..()
	.["immobile"] = TRUE

/obj/machinery/nuclearbomb/station/Destroy()
	flash_tiles.Cut()
	return ..()

/obj/machinery/nuclearbomb/station/Process()
	..()
	if(time_left > 0 && GAME_STATE < RUNLEVEL_POSTGAME)
		if(time_left <= self_destruct_cutoff)
			if(!announced)
				priority_announcement.Announce("The self-destruct sequence has reached terminal countdown, abort systems have been disabled.", "Self-Destruct Control Computer")
				announced = 1
			if(world.time >= time_to_explosion)
				var/range
				var/high_intensity
				var/low_intensity
				if(time_left <= (self_destruct_cutoff/2))
					range = rand(2, 3)
					high_intensity = rand(5,8)
					low_intensity = rand(7,10)
					time_to_explosion = world.time + 2 SECONDS
				else
					range = rand(1, 2)
					high_intensity = rand(3, 6)
					low_intensity = rand(5, 8)
					time_to_explosion = world.time + 5 SECONDS
				var/turf/T = pick_area_and_turf(GLOB.is_station_but_not_space_or_shuttle_area)
				explosion(T, range, high_intensity, low_intensity)

/obj/machinery/nuclearbomb/station/secure_device()
	..()
	announced = 0

/obj/machinery/nuclearbomb/station/update_icon()
	var/target_icon_state
	if(lighthack)
		target_icon_state = "rcircuit_off"
		icon_state = "idle"
	else if(timing == -1)
		target_icon_state = "rcircuitanim"
		icon_state = "exploding"
	else if(timing)
		target_icon_state = "rcircuitanim"
		icon_state = "urgent"
	else if(!safety)
		target_icon_state = "rcircuit"
		icon_state = "greenlight"
	else
		target_icon_state = "rcircuit_off"
		icon_state = "idle"

	if(!last_turf_state || target_icon_state != last_turf_state)
		for(var/thing in flash_tiles)
			var/turf/simulated/floor/T = thing
			if(!istype(T.flooring, /decl/flooring/reinforced/circuit/red))
				flash_tiles -= T
				continue
			T.icon_state = target_icon_state
		last_turf_state = target_icon_state

#undef NUKEUI_AWAIT_DISK
#undef NUKEUI_AWAIT_CODE
#undef NUKEUI_AWAIT_TIMER
#undef NUKEUI_AWAIT_ARM
#undef NUKEUI_TIMING
#undef NUKEUI_EXPLODED

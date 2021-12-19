//Ion drive

// Originally lifted from Nebula, heavily modified for this codebase

/datum/ship_engine/ion_drive
	name = "ion drive"
	var/obj/machinery/ion_drive/drive

/datum/ship_engine/ion_drive/New(obj/machinery/_holder)
	..()
	drive = _holder

/datum/ship_engine/ion_drive/Destroy()
	drive = null
	. = ..()

/datum/ship_engine/ion_drive/set_thrust_limit(new_limit)
	drive.thrust_limit = new_limit

/datum/ship_engine/ion_drive/get_thrust_limit()
	. = drive.thrust_limit

/datum/ship_engine/ion_drive/get_thrust()
	. = drive.get_thrust()

/datum/ship_engine/ion_drive/burn()
	. = drive.burn()

/datum/ship_engine/ion_drive/is_on()
	. = drive.powered()

/datum/ship_engine/ion_drive/toggle()
	drive.use_power = !drive.use_power

/datum/ship_engine/ion_drive/can_burn()
	. = src.is_on()

/datum/ship_engine/ion_drive/get_status()
	. = list()
	if(!istype(drive))
		. += "Hardware failure - check machinery."
	else if(!drive.powered())
		. += "Insufficient power or hardware offline."
	else
		. += "Online."
	return jointext(.,"<br>")

/obj/machinery/ion_drive
	name = "ion drive"
	desc = "An advanced propulsion device, using energy and minutes amount of gas to generate thrust."
	icon = 'resources/icons/obj/ship_engine.dmi'
	icon_state = "nozzle_ion"
	density = 1
	power_channel = ENVIRON
	idle_power_usage = 100
	anchored = TRUE
	use_power = TRUE

	var/datum/ship_engine/ion_drive/controller

	var/thrust_limit = 1
	var/burn_cost = 750
	var/generated_thrust = 5

/obj/machinery/ion_drive/Initialize()
	. = ..()
	controller = new(src)

/obj/machinery/ion_drive/Destroy()
	QDEL_NULL(controller)
	. = ..()

/obj/machinery/ion_drive/proc/get_thrust()
	. = thrust_limit * generated_thrust

/obj/machinery/ion_drive/proc/burn()
	if(!use_power || !powered())
		return 0
	use_power(thrust_limit * burn_cost)
	. = get_thrust()

/obj/item/weapon/circuitboard/unary_atmos/engine
	name = T_BOARD("ion drive")
	icon_state = "mcontroller"
	build_path = /obj/machinery/ion_drive
	origin_tech = list(TECH_POWER = 1, TECH_ENGINEERING = 2)
	req_components = list(
		/obj/item/stack/cable_coil = 2,
		/obj/item/weapon/stock_parts/matter_bin = 1,
		/obj/item/weapon/stock_parts/capacitor = 2
	)


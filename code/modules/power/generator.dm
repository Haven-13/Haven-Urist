/obj/machinery/power/generator
	name = "thermoelectric generator"
	desc = "It's a high efficiency thermoelectric generator."
	icon_state = "teg"
	density = 1
	anchored = 0

	use_power = 1
	idle_power_usage = 100 //Watts, I hope.  Just enough to do the computer and display things.
	atom_flags = ATOM_FLAG_OPEN_CONTAINER

	var/max_power = 500000
	var/thermal_efficiency = 0.65

	var/obj/machinery/atmospherics/binary/circulator/circ1
	var/obj/machinery/atmospherics/binary/circulator/circ2

	var/last_circ1_gen = 0
	var/last_circ2_gen = 0
	var/last_thermal_gen = 0
	var/stored_energy = 0
	var/lastgen1 = 0
	var/lastgen2 = 0
	var/effective_gen = 0
	var/lastgenlev = 0
	var/lubricated = 0

	var/list/soundverb = list("shudders violently", "rumbles brutally", "vibrates disturbingly", "shakes with a deep rumble", "bangs and thumps")
	var/list/soundlist = list('resources/sound/ambience/ambigen9.ogg','resources/sound/effects/meteorimpact.ogg','resources/sound/effects/caution.ogg')

/obj/machinery/power/generator/New()
	create_reagents(120)
	..()
	desc = initial(desc) + " Rated for [round(max_power/1000)] kW."
	spawn(1)
		reconnect()

/obj/machinery/power/generator/examine(mob/user)
	..()
	to_chat(user, "Auxilary tank shows [reagents.total_volume]u of liquid in it.")
	if(!lubricated)
		to_chat(user, "It seems to be in need of oiling.")

//generators connect in dir and reverse_dir(dir) directions
//mnemonic to determine circulator/generator directions: the cirulators orbit clockwise around the generator
//so a circulator to the NORTH of the generator connects first to the EAST, then to the WEST
//and a circulator to the WEST of the generator connects first to the NORTH, then to the SOUTH
//note that the circulator's outlet dir is it's always facing dir, and it's inlet is always the reverse
/obj/machinery/power/generator/proc/reconnect()
	circ1 = null
	circ2 = null
	if(src.loc && anchored)
		if(src.dir & (EAST|WEST))
			circ1 = locate(/obj/machinery/atmospherics/binary/circulator) in get_step(src,WEST)
			circ2 = locate(/obj/machinery/atmospherics/binary/circulator) in get_step(src,EAST)

			if(circ1 && circ2)
				if(circ1.dir != NORTH || circ2.dir != SOUTH)
					circ1 = null
					circ2 = null

		else if(src.dir & (NORTH|SOUTH))
			circ1 = locate(/obj/machinery/atmospherics/binary/circulator) in get_step(src,NORTH)
			circ2 = locate(/obj/machinery/atmospherics/binary/circulator) in get_step(src,SOUTH)

			if(circ1 && circ2 && (circ1.dir != EAST || circ2.dir != WEST))
				circ1 = null
				circ2 = null

/obj/machinery/power/generator/update_icon()
	if(stat & (NOPOWER|BROKEN))
		overlays.Cut()
	else
		overlays.Cut()

		if(lastgenlev != 0)
			overlays += image('resources/icons/obj/power.dmi', "teg-op[lastgenlev]")

/obj/machinery/power/generator/Process()
	if(!circ1 || !circ2 || !anchored || stat & (BROKEN|NOPOWER))
		stored_energy = 0
		return

	updateDialog()
	var/datum/gas_mixture/air1 = circ1.return_transfer_air()
	var/datum/gas_mixture/air2 = circ2.return_transfer_air()

	lastgen2 = lastgen1
	lastgen1 = 0
	last_thermal_gen = 0
	last_circ1_gen = 0
	last_circ2_gen = 0

	if(air1 && air2)
		var/air1_heat_capacity = air1.heat_capacity()
		var/air2_heat_capacity = air2.heat_capacity()
		var/delta_temperature = abs(air2.temperature - air1.temperature)

		if(delta_temperature > 0 && air1_heat_capacity > 0 && air2_heat_capacity > 0)
			var/energy_transfer = delta_temperature*air2_heat_capacity*air1_heat_capacity/(air2_heat_capacity+air1_heat_capacity)
			var/heat = energy_transfer*(1-thermal_efficiency)
			last_thermal_gen = energy_transfer*thermal_efficiency

			if(air2.temperature > air1.temperature)
				air2.temperature = air2.temperature - energy_transfer/air2_heat_capacity
				air1.temperature = air1.temperature + heat/air1_heat_capacity
			else
				air2.temperature = air2.temperature + heat/air2_heat_capacity
				air1.temperature = air1.temperature - energy_transfer/air1_heat_capacity
		playsound(src.loc, 'resources/sound/effects/beam.ogg', 25, 0, 10,  is_ambiance = 1)

	//Transfer the air
	if (air1)
		circ1.air2.merge(air1)
	if (air2)
		circ2.air2.merge(air2)

	//Update the gas networks
	if(circ1.network2)
		circ1.network2.update = 1
	if(circ2.network2)
		circ2.network2.update = 1

	//Exceeding maximum power leads to some power loss
	//exceeding max power is supposed to be bad, have there be a small chance of some visual and audio effects to stress this
	//remember to lubricate your engines kiddos
	if(!lubricated)
		if(effective_gen > max_power && prob(5))
			var/datum/effect/effect/system/spark_spread/s = new()
			s.set_up(2, 1, src)
			s.start()
			stored_energy *= 0.5
			if(prob(55))
				visible_message("<span class='danger'>[src] [pick(soundverb)]!</span>")
				var/malfsound = pick(soundlist)
				playsound(src.loc, malfsound, 50, 0, 10)
				if(prob(20))
					var/datum/effect/effect/system/smoke_spread/SM = new()
					SM.set_up(5, 0, src.loc)
					playsound(src.loc, 'resources/sound/machines/warning-buzzer.ogg', 50, 1, -3)
					spawn(2 SECONDS)
						playsound(src.loc, 'resources/sound/effects/meteorimpact.ogg', 50, 1, -3)
						for(var/mob/living/M in view(7, src))
							shake_camera(M, 1, 2)
						spawn(0.5 SECONDS)
							SM.start()
							playsound(src.loc, 'resources/sound/effects/smoke.ogg', 50, 1, -3)
	//Power
	last_circ1_gen = circ1.return_stored_energy()
	last_circ2_gen = circ2.return_stored_energy()
	stored_energy += last_thermal_gen + last_circ1_gen + last_circ2_gen
	lastgen1 = stored_energy*0.4 //smoothened power generation to prevent slingshotting as pressure is equalized, then restored by pumps
	stored_energy -= lastgen1
	effective_gen = (lastgen1 + lastgen2) / 2

	// update icon overlays and power usage only if displayed level has changed
	var/genlev = max(0, min( round(11*effective_gen / max_power), 11))
	if(effective_gen > 100 && genlev == 0)
		genlev = 1
	if(genlev != lastgenlev)
		lastgenlev = genlev
		update_icon()
	add_avail(effective_gen)
	lubricated = 0
	thermal_efficiency = 0.65
	if(reagents.has_reagent(/datum/reagent/lube/oil))
		reagents.remove_reagent(/datum/reagent/lube/oil, 0.01)
		thermal_efficiency = 0.80
		lubricated = 1
	else
		reagents.remove_any(1)

/obj/machinery/power/generator/attack_ai(mob/user)
	attack_hand(user)

/obj/machinery/power/generator/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(is_wrench(W))
		playsound(src.loc, 'resources/sound/items/Ratchet.ogg', 75, 1)
		anchored = !anchored
		user.visible_message("[user.name] [anchored ? "secures" : "unsecures"] the bolts holding [src.name] to the floor.", \
					"You [anchored ? "secure" : "unsecure"] the bolts holding [src] to the floor.", \
					"You hear a ratchet")
		use_power = anchored
		if(anchored) // Powernet connection stuff.
			connect_to_network()
		else
			disconnect_from_network()
		reconnect()
	if(istype(W, /obj/item/weapon/reagent_containers))
		var/obj/item/weapon/reagent_containers/R = W
		R.standard_pour_into(user, src)
		to_chat(user, "<span class='notice'>You pour the fluid into [src].</span>")
	else
		..()

/obj/machinery/power/generator/attack_hand(mob/user)
	add_fingerprint(user)
	if(stat & (BROKEN|NOPOWER) || !anchored) return
	if(!circ1 || !circ2) //Just incase the middle part of the TEG was not wrenched last.
		reconnect()
	ui_interact(user)

/obj/machinery/power/generator/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "TegGenerator")
		ui.open()

/obj/machinery/power/generator/ui_data(mob/user)
	// this is the data which will be sent to the ui
	var/vertical = 0
	if (dir == NORTH || dir == SOUTH)
		vertical = 1

	var/data[0]
	data["totalOutput"] = effective_gen/1000
	data["maxTotalOutput"] = max_power/1000
	data["thermalOutput"] = last_thermal_gen/1000
	data["circConnected"] = 0

	if(circ1)
		//The one on the left (or top)
		data["primaryDir"] = vertical ? "top" : "left"
		data["primaryOutput"] = last_circ1_gen/1000
		data["primaryFlowCapacity"] = circ1.volume_capacity_used*100
		data["primaryInletPressure"] = circ1.air1.return_pressure()
		data["primaryInletTemperature"] = circ1.air1.temperature
		data["primaryOutletPressure"] = circ1.air2.return_pressure()
		data["primaryOutletTemperature"] = circ1.air2.temperature

	if(circ2)
		//Now for the one on the right (or bottom)
		data["secondaryDir"] = vertical ? "bottom" : "right"
		data["secondaryOutput"] = last_circ2_gen/1000
		data["secondaryFlowCapacity"] = circ2.volume_capacity_used*100
		data["secondaryInletPressure"] = circ2.air1.return_pressure()
		data["secondaryInletTemperature"] = circ2.air1.temperature
		data["secondaryOutletPressure"] = circ2.air2.return_pressure()
		data["secondaryOutletTemperature"] = circ2.air2.temperature

	if(circ1 && circ2)
		data["circConnected"] = 1
	else
		data["circConnected"] = 0

	return data

/obj/machinery/power/generator/verb/rotate_clock()
	set category = "Object"
	set name = "Rotate Generator (Clockwise)"
	set src in view(1)

	if (usr.stat || usr.restrained()  || anchored)
		return

	src.set_dir(turn(src.dir, 90))

/obj/machinery/power/generator/verb/rotate_anticlock()
	set category = "Object"
	set name = "Rotate Generator (Counterclockwise)"
	set src in view(1)

	if (usr.stat || usr.restrained()  || anchored)
		return

	src.set_dir(turn(src.dir, -90))

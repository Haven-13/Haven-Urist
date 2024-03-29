/obj/machinery/computer/ship/sensors
	name = "sensors console"
	icon_keyboard = "teleport_key"
	icon_screen = "teleport"
	light_color = "#77fff8"
	//circuit = /obj/item/weapon/circuitboard/sensors
	var/obj/machinery/shipsensors/sensors
	var/viewing = 0
	var/list/viewers

/obj/machinery/computer/ship/sensors/Initialize()
	. = ..()
	linked = map_sectors["[z]"]
	find_sensors()

/obj/machinery/computer/ship/sensors/Destroy()
	sensors = null
	if(LAZY_LENGTH(viewers))
		for(var/weakref/W in viewers)
			var/M = W.resolve()
			if(M)
				unlook(M)
	. = ..()

/obj/machinery/computer/ship/sensors/attempt_hook_up(obj/effect/overmap/ship/sector)
	if(!(. = ..()))
		return
	find_sensors()

/obj/machinery/computer/ship/sensors/proc/find_sensors()
	if(!linked)
		return
	for(var/obj/machinery/shipsensors/S in SSmachines.machinery)
		if (linked.check_ownership(S))
			sensors = S
			break

/obj/machinery/computer/ship/sensors/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "spacecraft/ShipSensors", name)
		ui.open()

/obj/machinery/computer/ship/sensors/ui_static_data(mob/user)
	. = list(
		"minRange" = 1,
		"maxRange" = world.view,
		"maxHealth" = sensors.max_health,
		"criticalHeat" = sensors.critical_heat
	)

/obj/machinery/computer/ship/sensors/ui_data(mob/user)
	var/data[0]

	data["viewing"] = viewing
	if(sensors)
		data["on"] = sensors.use_power
		data["range"] = sensors.range
		data["health"] = sensors.health
		data["heat"] = sensors.heat
		if(sensors.health == 0)
			data["status"] = "DESTROYED"
		else if(!sensors.powered())
			data["status"] = "NO POWER"
		else if(!sensors.in_vacuum())
			data["status"] = "VACUUM SEAL BROKEN"
		else
			data["status"] = "OK"
	else
		data["status"] = "MISSING"
		data["range"] = "N/A"
		data["on"] = 0

	return data

/obj/machinery/computer/ship/sensors/ui_act(action, list/params)
	UI_ACT_CHECK

	switch(action)
		if("view")
			viewing = !viewing
			if(usr && !is_ai(usr))
				viewing ? look(usr) : unlook(usr)
			. = TRUE
		if("link")
			find_sensors()
			. = TRUE

	if(sensors)
		switch(action)
			if("range")
				sensors.set_range(between(1, params["range"], world.view))
			if("toggle")
				sensors.toggle()
				. = TRUE

/obj/machinery/computer/ship/sensors/check_eye(mob/user as mob)
	if (!get_dist(user, src) > 1 || user.blinded || !linked )
		viewing = 0
	if (!viewing)
		return -1
	else
		return 0

/obj/machinery/computer/ship/sensors/attack_hand(mob/user as mob)
	if(..())
		user.unset_machine()
		viewing = 0
		unlook(user)
		return

	if(!is_ai(user))
		user.set_machine(src)
		if(viewing)
			look(user)
	ui_interact(user)

/obj/machinery/computer/ship/sensors/proc/look(mob/user)
	if(linked)
		user.reset_view(linked)
	if(user.client)
		user.client.view = world.view + 4
	GLOB.moved_event.register(user, src, TYPE_PROC_REF(/obj/machinery/computer/ship/sensors, unlook))
	GLOB.stat_set_event.register(user, src, TYPE_PROC_REF(/obj/machinery/computer/ship/sensors, unlook))
	LAZY_ADD_UNIQUE(viewers, weakref(user))

/obj/machinery/computer/ship/sensors/proc/unlook(mob/user)
	user.reset_view()
	if(user.client)
		user.client.view = world.view
	GLOB.moved_event.unregister(user, src, TYPE_PROC_REF(/obj/machinery/computer/ship/sensors, unlook))
	GLOB.stat_set_event.unregister(user, src, TYPE_PROC_REF(/obj/machinery/computer/ship/sensors, unlook))
	LAZY_REMOVE(viewers, weakref(user))

/obj/machinery/computer/ship/sensors/Process()
	..()
	if(!linked)
		return
	if(sensors && sensors.use_power && sensors.powered())
		var/sensor_range = round(sensors.range*1.5) + 1
		linked.set_light(1, sensor_range, sensor_range+1)
	else
		linked.set_light(0)

/obj/machinery/shipsensors
	name = "sensors suite"
	desc = "Long range gravity scanner with various other sensors, used to detect irregularities in surrounding space. Can only run in vacuum to protect delicate quantum BS elements."
	icon = 'resources/icons/obj/stationobjs.dmi'
	icon_state = "sensors"
	var/max_health = 200
	var/health = 200
	var/critical_heat = 50 // sparks and takes damage when active & above this heat
	var/heat_reduction = 1.5 // mitigates this much heat per tick
	var/heat = 0
	var/range = 1
	idle_power_usage = 5000

/obj/machinery/shipsensors/attackby(obj/item/weapon/W, mob/user)
	var/damage = max_health - health
	if(damage && is_welder(W))

		var/obj/item/weapon/weldingtool/WT = W

		if(!WT.isOn())
			return

		if(WT.remove_fuel(0,user))
			to_chat(user, "<span class='notice'>You start repairing the damage to [src].</span>")
			playsound(src, 'resources/sound/items/Welder.ogg', 100, 1)
			if(do_after(user, max(5, damage / 5), src) && WT && WT.isOn())
				to_chat(user, "<span class='notice'>You finish repairing the damage to [src].</span>")
				take_damage(-damage)
		else
			to_chat(user, "<span class='notice'>You need more welding fuel to complete this task.</span>")
			return
		return
	..()

/obj/machinery/shipsensors/proc/in_vacuum()
	var/turf/T=get_turf(src)
	if(istype(T))
		var/datum/gas_mixture/environment = T.return_air()
		if(environment && environment.return_pressure() > MINIMUM_PRESSURE_DIFFERENCE_TO_SUSPEND)
			return 0
	return 1

/obj/machinery/shipsensors/update_icon()
	if(use_power)
		icon_state = "sensors"
	else
		icon_state = "sensors_off"

/obj/machinery/shipsensors/examine(mob/user)
	. = ..()
	if(health <= 0)
		to_chat(user, "\The [src] is wrecked.")
	else if(health < max_health * 0.25)
		to_chat(user, "<span class='danger'>\The [src] looks like it's about to break!</span>")
	else if(health < max_health * 0.5)
		to_chat(user, "<span class='danger'>\The [src] looks seriously damaged!</span>")
	else if(health < max_health * 0.75)
		to_chat(user, "\The [src] shows signs of damage!")

/obj/machinery/shipsensors/bullet_act(obj/item/projectile/Proj)
	take_damage(Proj.get_structure_damage())
	..()

/obj/machinery/shipsensors/proc/toggle()
	if(!use_power && health == 0)
		return
	if(!use_power) //need some juice to kickstart
		use_power(idle_power_usage*5)
	use_power = !use_power
	update_icon()

/obj/machinery/shipsensors/Process()
	..()
	if(use_power) //can't run in non-vacuum
		if(!in_vacuum())
			toggle()
		if(heat > critical_heat)
			src.visible_message("<span class='danger'>\The [src] violently spews out sparks!</span>")
			var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
			s.set_up(3, 1, src)
			s.start()

			take_damage(rand(10,50))
			toggle()
		heat += idle_power_usage/15000

	if (heat > 0)
		heat = max(0, heat - heat_reduction)

/obj/machinery/shipsensors/power_change()
	if(use_power && !powered())
		toggle()

/obj/machinery/shipsensors/proc/set_range(nrange)
	range = nrange
	idle_power_usage = 1500 * (range**2) // Exponential increase, also affects speed of overheating

/obj/machinery/shipsensors/emp_act(severity)
	if(!use_power)
		return
	take_damage(20/severity)
	toggle()

/obj/machinery/shipsensors/proc/take_damage(value)
	health = min(max(health - value, 0),max_health)
	if(use_power && health == 0)
		toggle()

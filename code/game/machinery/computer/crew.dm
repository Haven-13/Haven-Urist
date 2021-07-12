/obj/machinery/computer/crew
	name = "crew monitoring computer"
	desc = "Used to monitor active health sensors built into most of the crew's uniforms."
	icon_keyboard = "med_key"
	icon_screen = "crew"
	light_color = "#315ab4"
	use_power = 1
	idle_power_usage = 250
	active_power_usage = 500
	circuit = /obj/item/weapon/circuitboard/crew
	var/datum/ui_module/program/crew_monitor/crew_monitor

/obj/machinery/computer/crew/New()
	crew_monitor = new(src)
	..()

/obj/machinery/computer/crew/Destroy()
	qdel(crew_monitor)
	crew_monitor = null
	..()

/obj/machinery/computer/crew/attack_ai(mob/user)
	ui_interact(user)

/obj/machinery/computer/crew/ui_interact(mob/user, datum/tgui/ui)
	crew_monitor.ui_interact(user, ui)

/obj/machinery/computer/crew/ui_container()
	return crew_monitor
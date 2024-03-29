// RCON REMOTE CONTROL CONSOLE
//
// Last Change 1.1.2015 by Atlantis
//
// Allows remote operation of electrical systems on station (SMESs and Breaker Boxes)

/obj/machinery/computer/rcon
	name = "\improper RCON console"
	desc = "Console used to remotely control machinery."
	icon_keyboard = "power_key"
	icon_screen = "ai-fixer"
	light_color = "#a97faa"
	circuit = /obj/item/weapon/circuitboard/rcon_console
	req_one_access = list(access_engine)
	var/current_tag = null
	var/datum/ui_module/program/rcon/rcon

/obj/machinery/computer/rcon/New()
	..()
	rcon = new(src)

/obj/machinery/computer/rcon/Destroy()
	qdel(rcon)
	rcon = null
	..()

// Proc: attack_hand()
// Parameters: 1 (user - Person which clicked this computer)
// Description: Opens UI of this machine.
/obj/machinery/computer/rcon/attack_hand(mob/user as mob)
	..()
	ui_interact(user)

// Proc: ui_interact()
// Parameters: 4 (standard NanoUI parameters)
// Description: Uses dark magic (NanoUI) to render this machine's UI
/obj/machinery/computer/rcon/ui_interact(mob/user, datum/tgui/ui)
	rcon.ui_interact(user, ui)

/obj/machinery/computer/rcon/update_icon()
	..()
	if(is_operable())
		overlays += image('resources/icons/obj/computer.dmi', "ai-fixer-empty", overlay_layer)

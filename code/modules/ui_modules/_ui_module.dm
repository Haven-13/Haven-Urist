/datum/ui_module
	var/name
	var/datum/host
	var/available_to_ai = TRUE
	var/list/using_access = list()

/datum/ui_module/New(datum/host)
	..()
	src.host = host.ui_host()

/datum/ui_module/Destroy()
	SStgui.close_uis(src)
	host = null
	. = ..()

/datum/ui_module/ui_host()
	return host || src

/datum/ui_module/proc/can_still_topic(datum/ui_state/state = ui_default_state())
	return CanUseTopic(usr, state) == UI_INTERACTIVE

/datum/ui_module/proc/check_eye(mob/user)
	return -1

//returns a list.
/datum/ui_module/proc/get_access(mob/user)
	. = using_access
	if(istype(user))
		var/obj/item/weapon/card/id/I = user.GetIdCard()
		if(I)
			. |= I.access

/datum/ui_module/proc/check_access(mob/user, access)
	if(!access)
		return 1
	if(!is_list(access))
		access = list(access) //listify a single access code.
	if(has_access(access, list(), using_access))
		return 1 //This is faster, and often enough.
	return has_access(access, list(), get_access(user)) //Also checks the mob's ID.

/datum/ui_module/Topic(href, href_list)
	. = ..()

/datum/ui_module/proc/get_host_z()
	var/atom/host = ui_host()
	return istype(host) ? get_z(host) : 0

/datum/ui_module/proc/print_text(text, mob/user)
	var/obj/item/modular_computer/MC = ui_host()
	if(istype(MC))
		if(!MC.nano_printer)
			to_chat(user, "Error: No printer detected. Unable to print document.")
			return

		if(!MC.nano_printer.print_text(text))
			to_chat(user, "Error: Printer was unable to print the document. It may be out of paper.")
	else
		to_chat(user, "Error: Unable to detect compatible printer interface. Are you running NTOSv2 compatible system?")

/datum/proc/initial_data()
	return list()

/datum/proc/update_layout()
	return FALSE

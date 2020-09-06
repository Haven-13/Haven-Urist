/datum/computer_file/program/revelation
	filename = "revelation"
	filedesc = "Revelation"
	program_icon_state = "hostile"
	program_key_state = "security_key"
	program_menu_icon = "home"
	extended_desc = "This virus can destroy hard drive of system it is executed on. It may be obfuscated to look like another non-malicious program. Once armed, it will destroy the system upon next execution."
	size = 13
	requires_ntnet = FALSE
	available_on_ntnet = FALSE
	available_on_syndinet = TRUE
	tgui_id = "NtosRevelation"
	var/armed = 0

/datum/computer_file/program/revelation/run_program(var/mob/living/user)
	. = ..(user)
	if(armed)
		activate()

/datum/computer_file/program/revelation/proc/activate()
	if(!computer)
		return

	computer.visible_message("<span class='notice'>\The [computer]'s screen brightly flashes and loud electrical buzzing is heard.</span>")
	computer.enabled = 0
	computer.update_icon()
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(10, 1, computer.loc)
	s.start()

	if(computer.hard_drive)
		qdel(computer.hard_drive)

	if(computer.battery_module && prob(25))
		qdel(computer.battery_module)

	if(computer.tesla_link && prob(50))
		qdel(computer.tesla_link)

/datum/computer_file/program/revelation/Topic(href, href_list)
	if(..())
		return 1
	else if(href_list["PRG_arm"])
		armed = !armed
	else if(href_list["PRG_activate"])
		activate()
	else if(href_list["PRG_obfuscate"])
		var/mob/living/user = usr
		var/newname = sanitize(input(user, "Enter new program name: "))
		if(!newname)
			return
		filedesc = newname
		for(var/datum/computer_file/program/P in ntnet_global.available_station_software)
			if(filedesc == P.filedesc)
				program_menu_icon = P.program_menu_icon
				break
	return 1

/datum/computer_file/program/revelation/clone()
	var/datum/computer_file/program/revelation/temp = ..()
	temp.armed = armed
	return temp

/datum/ui_module/program/uplink
	name = "TaxQuickly 2559"

/datum/ui_module/program/uplink/ui_interact(var/mob/user)
	var/datum/computer_file/program/uplink/prog = program
	var/obj/item/modular_computer/computer = host
	if(istype(computer) && istype(prog))
		if(computer.hidden_uplink && prog.password)
			if(prog.authenticated)
				if(alert(user, "Resume or close and secure?", name, "Resume", "Close") == "Resume")
					computer.hidden_uplink.trigger(user)
					return
			else if(computer.hidden_uplink.check_trigger(user, input(user, "Please enter your unique tax ID:", "Authentication"), prog.password))
				prog.authenticated = 1
				return
		else
			to_chat(user, "<span class='warning'>[computer] displays an \"ID not found\" error.</span>")

	prog.authenticated = 0
	computer.kill_program()

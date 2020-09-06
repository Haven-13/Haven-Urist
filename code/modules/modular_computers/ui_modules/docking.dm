/datum/ui_module/docking
	name = "Docking Control program"
	var/list/docking_controllers = list() //list of tags

/datum/ui_module/docking/proc/refresh_docks()
	var/atom/movable/AM = ui_host()
	if(!istype(AM))
		return
	docking_controllers.Cut()
	var/list/zlevels = GetConnectedZlevels(AM.z)
	for(var/obj/machinery/embedded_controller/radio/airlock/docking_port/D in SSmachines.machinery)
		if(D.z in zlevels)
			var/shuttleside = 0
			for(var/sname in SSshuttle.shuttles) //do not touch shuttle-side ones
				var/datum/shuttle/autodock/S = SSshuttle.shuttles[sname]
				if(istype(S) && S.shuttle_docking_controller)
					if(S.shuttle_docking_controller.id_tag == D.docking_program.id_tag)
						shuttleside = 1
						break
			if(shuttleside)
				continue
			docking_controllers += D.docking_program.id_tag

/datum/ui_module/docking/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "DockingProgram")
		ui.open()

/datum/ui_module/docking/ui_data(mob/user)
	var/list/data = host.initial_data()
	var/list/docks = list()
	for(var/docktag in docking_controllers)
		var/datum/computer/file/embedded_program/docking/P = locate(docktag)
		if(P)
			var/docking_attempt = P.tag_target && !P.dock_state
			var/docked = P.tag_target && (P.dock_state == STATE_DOCKED)
			docks.Add(list(list(
				"tag"=P.id_tag,
				"location" = P.get_name(),
				"status" = capitalize(P.get_docking_status()),
				"docking_attempt" = docking_attempt,
				"docked" = docked,
				"codes" = P.docking_codes ? P.docking_codes : "Unset"
				)))
	data["docks"] = docks

	return data

/datum/ui_module/docking/Topic(href, href_list, state)
	if(..())
		return 1
	if(href_list["edit_code"])
		var/datum/computer/file/embedded_program/docking/P = locate(href_list["edit_code"])
		if(P)
			var/newcode = input("Input new docking codes", "Docking codes", P.docking_codes) as text|null
			if(!CanInteract(usr,state))
				return
			if (newcode)
				P.docking_codes = uppertext(newcode)
		return 1
	if(href_list["dock"])
		var/datum/computer/file/embedded_program/docking/P = locate(href_list["dock"])
		if(P)
			P.receive_user_command("dock")
		return 1
	if(href_list["undock"])
		var/datum/computer/file/embedded_program/docking/P = locate(href_list["undock"])
		if(P)
			P.receive_user_command("undock")
		return 1

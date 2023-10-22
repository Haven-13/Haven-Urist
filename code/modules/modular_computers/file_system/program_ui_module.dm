
/datum/ui_module/program
	available_to_ai = FALSE
	var/ui_interface_name = "programs/NotDefined"
	var/datum/computer_file/program/program = null	// Program-Based computer program that runs this nano module. Defaults to null.

/datum/ui_module/program/New(host, program)
	..()
	src.program = program

/datum/ui_module/program/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/simple/ntos_headers)
	)

/datum/ui_module/program/ui_host()
	return program ? program.ui_host() : ..()

/datum/ui_module/program/ui_status(mob/user, datum/ui_state/state)
	return program ? program.ui_status(user, state) : ..()

/datum/ui_module/program/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, ui_interface_name, name)
		ui.open()

/datum/ui_module/program/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	UI_ACT_CHECK
	return program && program.ui_act(action, params, ui, state)

/datum/computer_file/program/apply_visual(mob/M)
	if(NM)
		NM.apply_visual(M)

/datum/computer_file/program/remove_visual(mob/M)
	if(NM)
		NM.remove_visual(M)

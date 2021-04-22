/datum/ui_module/program/crew_manifest
	name = "Crew Manifest"
	ui_interface_name = "programs/NtosCrewManifest"

/datum/ui_module/program/crew_manifest/ui_static_data(mob/user)
	. = list(
		"manifest" = ui_crew_manifest_data()
	)

/datum/ui_module/program/crew_manifest/ui_data(mob/user)
	var/list/data = host.initial_data()

	data["has_printer"] = (program && program.computer) ? !!program.computer.nano_printer : FALSE

	return data
/datum/ui_module/program/crew_manifest
	name = "Crew Manifest"
	ui_interface_name = "programs/NtosCrewManifest"

/datum/ui_module/program/crew_manifest/ui_data(mob/user)
	var/list/data = host.initial_data()

	data["crew_manifest"] = html_crew_manifest(TRUE)

	return data
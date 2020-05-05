/datum/job/qm
	minimal_player_age = 1
	economic_power = 9
	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain and the first officer."
	outfit_type = /decl/hierarchy/outfit/job/pluto/qm
	access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_qm, access_mining, access_mining_station,
	access_expedition_shuttle_helm, access_expedition, access_robotics, access_research,
	access_RC_announce, access_keycard_auth, access_heads, access_eva, access_bridge, access_hydroponics, access_chapel_office, access_library, access_bar, access_kitchen, access_janitor)
	minimal_access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_qm, access_mining, access_mining_station,
	access_expedition_shuttle_helm, access_expedition, access_robotics, access_research,
	access_RC_announce, access_keycard_auth, access_heads, access_eva, access_bridge, access_hydroponics, access_chapel_office, access_library, access_bar, access_janitor)

/datum/job/cargo_tech
	minimal_player_age = 0
	economic_power = 4
	title = "Supply Technician"
	supervisors = "the quartermaster"
	alt_titles = list("Cargo Technician", "Resource Technician", "Fabrication Technician", "Salvage Technician",
	"Roboticist" = /decl/hierarchy/outfit/job/pluto/roboticist)
	total_positions = 6 //because we're replacing science
	spawn_positions = 4
	hud_icon = "hudcargotechnician"
	outfit_type = /decl/hierarchy/outfit/job/pluto/supplytech
	access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_mining, access_mining_station,
	access_expedition_shuttle_helm, access_expedition, access_robotics, access_research)
	minimal_access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_mining, access_mining_station,
	access_expedition_shuttle_helm, access_expedition, access_robotics, access_research)

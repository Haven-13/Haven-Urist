
/datum/job/chief_engineer
	minimal_player_age = 2
	supervisors = "the captain and the first officer."
	access = list(access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels, access_heads,
						access_teleporter, access_external_airlocks, access_atmospherics, access_emergency_storage, access_eva,
						access_bridge, access_construction, access_sec_doors,
						access_ce, access_RC_announce, access_keycard_auth, access_tcomsat, access_ai_upload,
						access_expedition_shuttle_helm, access_expedition)
	minimal_access = list(access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels, access_heads,
						access_teleporter, access_external_airlocks, access_atmospherics, access_emergency_storage, access_eva,
						access_bridge, access_construction, access_sec_doors,
						access_ce, access_RC_announce, access_keycard_auth, access_tcomsat, access_ai_upload,
						access_expedition_shuttle_helm, access_expedition)

/datum/job/senior_engineer
	title = "Assistant Engineer"
	department = "Engineering"
	department_flag = ENG

	minimal_player_age = 1
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Chief Engineer"
	selection_color = "#5b4d20"

	outfit_type = /decl/hierarchy/outfit/job/engineering/engineer

	access = list(access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels, access_heads,
						access_teleporter, access_external_airlocks, access_atmospherics, access_emergency_storage, access_eva,
						access_bridge, access_construction, access_sec_doors,
						access_ce, access_RC_announce, access_keycard_auth, access_tcomsat, access_ai_upload,
						access_expedition_shuttle_helm, access_expedition)
	minimal_access = list(access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels, access_heads,
						access_teleporter, access_external_airlocks, access_atmospherics, access_emergency_storage, access_eva,
						access_bridge, access_construction, access_sec_doors,
						access_ce, access_RC_announce, access_keycard_auth, access_tcomsat, access_ai_upload,
						access_expedition_shuttle_helm, access_expedition)

/datum/job/engineer
	minimal_player_age = 0
	total_positions = 5
	spawn_positions = 3

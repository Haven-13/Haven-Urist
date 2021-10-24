/datum/job/hos
	minimal_player_age = 5
	title = "Security Chief"
	supervisors = "the captain and the first mate."
	outfit_type = /decl/hierarchy/outfit/job/security/pluto/cos
	hud_icon = "hudheadofsecurity"
	access = list(access_security, access_eva, access_sec_doors, access_brig, access_armory, access_heads,
						access_forensics_lockers, access_morgue, access_maint_tunnels, access_all_personal_lockers,
						access_research, access_engine, access_mining, access_medical, access_construction, access_mailsorting,
						access_bridge, access_hos, access_RC_announce, access_keycard_auth, access_gateway, access_external_airlocks,
						access_expedition_shuttle_helm, access_expedition)
	minimal_access = list(access_security, access_eva, access_sec_doors, access_brig, access_armory, access_heads,
						access_forensics_lockers, access_morgue, access_maint_tunnels, access_all_personal_lockers,
						access_research, access_engine, access_mining, access_medical, access_construction, access_mailsorting,
						access_bridge, access_hos, access_RC_announce, access_keycard_auth, access_gateway, access_external_airlocks,
						access_expedition_shuttle_helm, access_expedition)

/datum/job/officer
	minimal_player_age = 0
	supervisors = "the chief of security."
	alt_titles = list("Detective")
	outfit_type = /decl/hierarchy/outfit/job/security/pluto/secofficer
	access = list(access_security, access_forensics_lockers, access_eva, access_sec_doors, access_brig, access_maint_tunnels, access_morgue, access_external_airlocks, access_expedition, access_expedition_shuttle_helm)
	minimal_access = list(access_security, access_forensics_lockers, access_eva, access_sec_doors, access_brig, access_maint_tunnels, access_external_airlocks, access_expedition, access_expedition_shuttle_helm)

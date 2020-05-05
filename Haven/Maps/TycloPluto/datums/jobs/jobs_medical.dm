
/datum/job/cmo
	title = "Second Mate"
	minimal_player_age = 1
	supervisors = "the captain and the first officer."
	access = list(access_medical, access_medical_equip, access_morgue, access_genetics, access_bridge, access_heads,
			access_chemistry, access_virology, access_cmo, access_surgery, access_RC_announce,
			access_keycard_auth, access_sec_doors, access_psychiatrist, access_eva, access_maint_tunnels, access_external_airlocks,
			access_expedition_shuttle_helm, access_expedition)
	minimal_access = list(access_medical, access_medical_equip, access_morgue, access_genetics, access_bridge, access_heads,
			access_chemistry, access_virology, access_cmo, access_surgery, access_RC_announce,
			access_keycard_auth, access_sec_doors, access_psychiatrist, access_eva, access_maint_tunnels, access_external_airlocks,
			access_expedition_shuttle_helm, access_expedition)

/datum/job/doctor
	minimal_player_age = 0
	access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_chemistry, access_virology, access_genetics, access_maint_tunnels)
	minimal_access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_chemistry, access_virology, access_genetics, access_maint_tunnels)
	alt_titles = list("Chemist" = /decl/hierarchy/outfit/job/medical/doctor/chemist,
		"Surgeon" = /decl/hierarchy/outfit/job/medical/doctor/surgeon,
		"Emergency Physician" = /decl/hierarchy/outfit/job/medical/doctor/emergency_physician,
		)

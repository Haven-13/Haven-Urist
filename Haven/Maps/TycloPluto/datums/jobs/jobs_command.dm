/datum/job/ai
	minimal_player_age = 7

/datum/job/cyborg
	minimal_player_age = 0

/datum/job/bodybuard
	title = "Bodyguard"
	department_flag = SEC|COM
	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain, who hired you to protect them. If the captain is not present, follow the chain of command as to who you will be protecting."
	selection_color = "#004a7f"
	req_admin_notify = 1
	minimal_player_age = 3
	economic_power = 7
	outfit_type = /decl/hierarchy/outfit/job/bodyguard
	hud_icon = "hudbodyguard"
	access = list(access_security, access_sec_doors, access_court, access_forensics_lockers,
						access_medical, access_engine, access_ai_upload, access_eva, access_heads, access_bridge,
						access_all_personal_lockers, access_maint_tunnels, access_construction, access_morgue,
						access_cargo, access_mailsorting, access_qm, access_lawyer,
						access_theatre, access_research, access_mining, access_mining_station,
						access_clown, access_mime, access_RC_announce, access_keycard_auth, access_blueshield,
						)
	minimal_access = list(access_security, access_sec_doors, access_court, access_forensics_lockers,
						access_medical, access_engine, access_eva, access_heads, access_bridge,
						access_all_personal_lockers, access_maint_tunnels, access_construction, access_morgue,
						access_cargo, access_mailsorting, access_qm, access_lawyer,
						access_theatre, access_research, access_mining, access_mining_station,
						access_clown, access_mime, access_RC_announce, access_keycard_auth, access_blueshield)

/datum/job/firstofficer
	title = "First Mate"
	supervisors = "the captain"
	department_flag = COM
	total_positions = 1
	spawn_positions = 1
	selection_color = "#004a7f"
	req_admin_notify = 1
	minimal_player_age = 5
	economic_power = 15
	outfit_type = /decl/hierarchy/outfit/job/pluto/firstofficer
	hud_icon = "hudheadofpersonnel"
	access = list(access_security, access_sec_doors, access_brig, access_forensics_lockers, access_heads,
						access_engine, access_change_ids, access_ai_upload, access_eva, access_bridge,
						access_all_personal_lockers, access_maint_tunnels, access_bar, access_janitor, access_construction, access_morgue,
						access_crematorium, access_kitchen, access_cargo, access_cargo_bot, access_mailsorting, access_qm, access_hydroponics, access_lawyer,
						access_chapel_office, access_library, access_research, access_mining, access_heads_vault, access_mining_station,
						access_hop, access_RC_announce, access_keycard_auth, access_gateway,
						access_expedition_shuttle_helm, access_expedition, access_fo, access_teleporter,
						access_tcomsat, access_engine_equip, access_tech_storage, access_ce, access_external_airlocks, access_atmospherics, access_emergency_storage, access_construction,
						access_medical, access_medical_equip, access_morgue, access_genetics,
						access_chemistry, access_virology, access_cmo, access_surgery,
						access_robotics, access_research, access_armory, access_hos,
						access_tox, access_tox_storage, access_xenobiology, access_xenoarch, access_psychiatrist
						)
	minimal_access = list(access_security, access_sec_doors, access_brig, access_forensics_lockers, access_heads,
						access_engine, access_change_ids, access_ai_upload, access_eva, access_bridge,
						access_all_personal_lockers, access_maint_tunnels, access_bar, access_janitor, access_construction, access_morgue,
						access_crematorium, access_kitchen, access_cargo, access_cargo_bot, access_mailsorting, access_qm, access_hydroponics, access_lawyer,
						access_chapel_office, access_library, access_research, access_mining, access_heads_vault, access_mining_station,
						access_hop, access_RC_announce, access_keycard_auth, access_gateway,
						access_expedition_shuttle_helm, access_expedition, access_fo, access_teleporter,
						access_tcomsat, access_engine_equip, access_tech_storage, access_ce, access_external_airlocks, access_atmospherics, access_emergency_storage, access_construction,
						access_medical, access_medical_equip, access_morgue, access_genetics,
						access_chemistry, access_virology, access_cmo, access_surgery,
						access_robotics, access_research, access_armory, access_hos,
						access_tox, access_tox_storage, access_xenobiology, access_xenoarch, access_psychiatrist
						)

/datum/job/firstofficer/get_description_blurb()
	return "You are the First Officer, and second in command of the ICS Nerva. As the clear second in command of the ship, your job is to work with the captain to run the ship, and take charge of navigation according to the captain's orders. Moreover, if there is no second officer, your job is also to oversee personnel issues and organize away missions. In the event of combat, your job is to work with the Chief of Security to coordinate the ship's defence."

/datum/job/captain
	title = "Captain"
	supervisors = "yourself, as you are the owner of this ship and the sole arbiter of its destiny. However, be careful not to anger NanoTrasen and the other factions that have set up outposts in this sector, or your own staff for that matter. It could lead to your undoing"
	minimal_player_age = 7
	outfit_type = /decl/hierarchy/outfit/job/pluto/captain
	economic_power = 24

/datum/job/captain/get_description_blurb()
	return "You are the Captain and owner of the ICS Nerva. You are the top dog. Your backstory and destiny is your own to decide, however, you are ultimately responsible for all that happens onboard. Your job is to make sure the that Nerva survives its time in this sector, and turns a profit for you. Delegate to your First Officer, the Second Officer, and your department heads to effectively manage the ship, and listen to and trust their expertise. It might be the difference between life and death. Oh, and watch out for pirates. The ICS Nerva only has a small complement of weapons at first, which can be upgraded at certain stations in the sector. Good luck."

/*
/datum/job/secondofficer
	minimal_player_age = 3
	title = "Second Mate"
	supervisors = "the captain and the first mate."
	hud_icon = "hudheadofpersonnel"
	outfit_type = /decl/hierarchy/outfit/job/pluto/secondofficer
	access = list(access_security, access_sec_doors, access_brig, access_forensics_lockers, access_heads,
						access_medical, access_engine, access_change_ids, access_ai_upload, access_eva, access_bridge,
						access_all_personal_lockers, access_maint_tunnels, access_janitor, access_construction, access_morgue,
						access_crematorium, access_cargo, access_hydroponics, access_lawyer,
						access_chapel_office, access_library, access_research, access_heads_vault,
						access_hop, access_RC_announce, access_keycard_auth, access_gateway,
						access_expedition_shuttle_helm, access_expedition)
	minimal_access = list(access_security, access_sec_doors, access_brig, access_forensics_lockers, access_heads,
						access_medical, access_engine, access_change_ids, access_ai_upload, access_eva, access_bridge,
						access_all_personal_lockers, access_maint_tunnels, access_janitor, access_construction, access_morgue,
						access_crematorium, access_cargo, access_hydroponics, access_lawyer,
						access_chapel_office, access_library, access_research, access_heads_vault,
						access_hop, access_RC_announce, access_keycard_auth, access_gateway,
						access_expedition_shuttle_helm, access_expedition)

/datum/job/secondofficer/get_description_blurb()
	return "You are the Second Mate, third in command, after the First Officer and the Captain. As the Second Officer, it is your job to oversee personnel issues, which includes managing access, delegating crew grievances, and ensuring the proper upkeep and operation of the ship's recreational and mess facilities. Thus, you are the direct supervisor for the janitorial staff, as well as the culinary and hydroponics staff. As Second Officer, it is also your job to organize and lead awaymissions, and in cases where there is no First Officer present, to pilot the AFCUV Pluto."
*/
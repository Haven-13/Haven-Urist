/datum/computer_file/program/aidiag
	filename = "aidiag"
	filedesc = "AI Maintenance Utility"
	program_icon_state = "generic"
	program_key_state = "mining_key"
	program_menu_icon = "person"
	extended_desc = "This program is capable of reconstructing damaged AI systems. It can also be used to upload basic laws to the AI. Requires direct AI connection via inteliCard slot."
	size = 12
	requires_ntnet = 0
	required_access = access_bridge
	requires_access_to_run = 0
	available_on_ntnet = 1
	ui_module_path = /datum/ui_module/program/computer_aidiag/
	var/restoring = 0

/datum/computer_file/program/aidiag/proc/get_ai()
	if(computer && computer.ai_slot && computer.ai_slot.check_functionality() && computer.ai_slot.enabled && computer.ai_slot.stored_card && computer.ai_slot.stored_card.carded_ai)
		return computer.ai_slot.stored_card.carded_ai
	return null

/datum/computer_file/program/aidiag/Topic(href, href_list)
	if(..())
		return 1
	var/mob/living/silicon/ai/A = get_ai()
	if(!A)
		return 0
	if(href_list["PRG_beginReconstruction"])
		if((A.hardware_integrity() < 100) || (A.backup_capacitor() < 100))
			restoring = 1
		return 1

	// Following actions can only be used by non-silicon users, as they involve manipulation of laws.
	if(issilicon(usr))
		return 0
	if(href_list["PRG_purgeAiLaws"])
		A.laws.clear_zeroth_laws()
		A.laws.clear_ion_laws()
		A.laws.clear_inherent_laws()
		A.laws.clear_supplied_laws()
		to_chat(A, "<span class='danger'>All laws purged.</span>")
		return 1
	if(href_list["PRG_resetLaws"])
		A.laws.clear_ion_laws()
		A.laws.clear_supplied_laws()
		to_chat(A, "<span class='danger'>Non-core laws reset.</span>")
		return 1
	if(href_list["PRG_uploadDefault"])
		A.laws = new GLOB.using_map.default_law_type
		to_chat(A, "<span class='danger'>All laws purged. Default lawset uploaded.</span>")
		return 1
	if(href_list["PRG_addCustomSuppliedLaw"])
		var/law_to_add = sanitize(input("Please enter a new law for the AI.", "Custom Law Entry"))
		var/sector = input("Please enter the priority for your new law. Can only write to law sectors 15 and above.", "Law Priority (15+)") as num
		sector = between(MIN_SUPPLIED_LAW_NUMBER, sector, MAX_SUPPLIED_LAW_NUMBER)
		A.add_supplied_law(sector, law_to_add)
		to_chat(A, "<span class='danger'>Custom law uploaded to sector [sector]: [law_to_add].</span>")
		return 1


/datum/computer_file/program/aidiag/process_tick()
	var/mob/living/silicon/ai/A = get_ai()
	if(!A || !restoring)
		restoring = 0	// If the AI was removed, stop the restoration sequence.
		return
	A.adjustFireLoss(-4)
	A.adjustBruteLoss(-4)
	A.adjustOxyLoss(-4)
	A.updatehealth()
	// If the AI is dead, revive it.
	if (A.health >= -100 && A.stat == DEAD)
		A.set_stat(CONSCIOUS)
		A.lying = 0
		A.switch_from_dead_to_living_mob_list()
		A.add_ai_verbs()
		A.update_icon()
		var/obj/item/weapon/aicard/AC = A.loc
		if(AC)
			AC.update_icon()
	// Finished restoring
	if((A.hardware_integrity() == 100) && (A.backup_capacitor() == 100))
		restoring = 0

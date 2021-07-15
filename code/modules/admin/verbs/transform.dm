/client/proc/transform_precheck(mob/M)
	if(!check_rights(R_SPAWN))
		to_chat(usr, "+SPAWN right required to use this command.")
		return FALSE

	if(GAME_STATE < RUNLEVEL_GAME)
		to_chat(usr, "Wait until the game starts")
		return FALSE

	if(!ishuman(M))
		to_chat(usr, "This can only be used on instances of type /mob/living/carbon/human")
		return FALSE

	return TRUE

/client/proc/cmd_admin_slimeize(mob/living/carbon/human/M in SSmobs.mob_list)
	if(transform_precheck(M))
		log_and_message_admins("has slimized [key_name_admin(M)]")
		M.slimeize()
	feedback_add_details("admin_verb","MKSLI") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_aiize(mob/living/carbon/human/M in SSmobs.mob_list)
	if(transform_precheck(M))
		log_and_message_admins("has AIized [key_name_admin(M)]!")
		M.AIize()
	feedback_add_details("admin_verb","MKAIC")

/client/proc/cmd_admin_animalize(mob/living/carbon/human/M in SSmobs.mob_list)
	if(transform_precheck(M))
		log_and_message_admins("has animalized [key_name_admin(M)].")
		M.Animalize()
	feedback_add_details("admin_verb","MKANI")

/client/proc/cmd_admin_robotize(mob/living/carbon/human/M in SSmobs.mob_list)
	if(transform_precheck(M))
		log_and_message_admins("has robotized [key_name_admin(M)].")
		M.Robotize()
	feedback_add_details("admin_verb","MKROB")

/client/proc/cmd_admin_corgize(mob/living/carbon/human/M in SSmobs.mob_list)
	if(transform_precheck(M))
		log_and_message_admins("has corgized [key_name_admin(M)]")
		M.corgize()
	feedback_add_details("admin_verb", "MKCOR")

/client/proc/cmd_admin_monkeyize(mob/living/carbon/human/M in SSmobs.mob_list)
	if(transform_precheck(M))
		log_and_message_admins("has monkeyized [key_name_admin(M)]")
		M.monkeyize()
	feedback_add_details("admin_verb", "MKMON")

/client/proc/warpallplayers()

	set name = "Warp All Players"
	set category = "Fun"
	set desc = "Warp all players to you."
	if(!check_rights(R_FUN))
		src <<"<span class='danger'> You do not have the required admin rights.</span>"
		return

	for(var/mob/living/M in GLOB.player_list)
		M.loc = get_turf(usr)
		message_admins("[key_name(usr)] has warped all players to their location.")
		log_admin("[key_name(src)] has warped all players to their location.")

//Urist mass-callproc, call it by regular callproc. SUPER risky.
/client/proc/mass_callproc(var/atom/A, var/procpath, var/strict_typing = 1)
	set category = "Debug"
	set name = "ProcCall All"
	set background = 1


	if(!check_rights(R_DEBUG)) return
	if(config.debugparanoid && !check_rights(R_ADMIN)) return

	var/list/subargs = list()
	if(args.len >= 4)
		for(var/i = 4, i < args.len, i++)
			subargs += args[i]

	var/affecting_type = A.type
	for(var/atom/target in world.contents) //this will be really friggin slow, what did you expect
		if((strict_typing && (target.type == affecting_type)) || (!strict_typing && (istype(target, affecting_type))))
			if(hascall(target, procpath))
				log_admin("[key_name(src)] called [procpath]() on all [strict_typing ? "objects with type [target.type]" : "subtypes of [target.type]"] with [subargs.len ? "the arguments [list2params(subargs)]" : "no arguments"].")
				call(target, procpath)(arglist(subargs))

/client/proc/consul_mode()
	set category = "Fun"
	set name = "Consul Mode"
	set desc = "Double the captains, double the fun."

	if(!check_rights(R_FUN))
		to_chat(src, "<span class='danger'> You do not have the required admin rights.</span>")
		return

	if(GAME_STATE > RUNLEVEL_LOBBY)
		to_chat(usr, "This option is currently only usable during pregame. This may change at a later date.")
		return

	if(job_master)
		var/datum/job/job = job_master.GetJob("Captain")
		if(!job)
			job = job_master.GetJob("Consul")
			if(!job)
				to_chat(usr, "Okay, something fucked up. Can't locate the Captain/Consul job.")
				return
			else
				message_admins("[key_name(usr)] has disabled Consul Mode, everything's back to normal.")
				log_admin("[key_name(src)] has disabled Consul Mode.")
				job.spawn_positions = 1
				job.total_positions = 1
				job.title = "Captain"

				if(GLOB.using_map.name == "Nerva")
					job.supervisors = "yourself, as you are the owner of this ship and the sole arbiter of its destiny. However, be careful not to anger NanoTrasen and the other factions that have set up outposts in this sector, or your own staff for that matter. It could lead to your undoing"


		else
			message_admins("[key_name(usr)] has enabled Consul Mode, you need to warn players that they will need to set job preferences for Consul.")
			log_admin("[key_name(src)] has enabled Consul Mode.")
			job.spawn_positions = 2
			job.total_positions = 2
			job.title = "Consul"

			if(GLOB.using_map.name == "Nerva")
				job.supervisors = "yourself and your counterpart, as you are the owners of this ship and the sole arbiters of its destiny. However, be careful not to anger NanoTrasen and the other factions that have set up outposts in this sector, or your own staff for that matter. It could lead to your undoing."

	return

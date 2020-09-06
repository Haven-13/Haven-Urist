#define TGS_STATUS_THROTTLE 5

/datum/tgs_chat_command/tgsstatus
	name = "status"
	help_text = "Gets the admincount, playercount, gamemode, and true game mode of the server"
	admin_only = TRUE
	var/last_tgs_status = 0

/datum/tgs_chat_command/tgsstatus/Run(datum/tgs_chat_user/sender, params)
	var/rtod = REALTIMEOFDAY
	if(rtod - last_tgs_status < TGS_STATUS_THROTTLE)
		return
	last_tgs_status = rtod
	var/list/allmins = GLOB.admins
	var/status = "Admins: [allmins.len] ([english_list(allmins)])."
	status += "Players: [GLOB.clients.len]. Mode: [SSticker.mode ? SSticker.mode.name : "Not started"]."
	return status

/datum/tgs_chat_command/tgscheck
	name = "check"
	help_text = "Gets the playercount, gamemode, and address of the server"
	var/last_tgs_check = 0

/datum/tgs_chat_command/tgscheck/Run(datum/tgs_chat_user/sender, params)
	var/rtod = REALTIMEOFDAY
	if(rtod - last_tgs_check < TGS_STATUS_THROTTLE)
		return
	last_tgs_check = rtod
	var/server = config.server
	return "[game_id ? "Round #[game_id]: " : ""][GLOB.clients.len] players on [GLOB.using_map.full_name], Mode: [SSticker.mode ? SSticker.mode.name : "Not started"]; Round [Master.current_runlevel >= RUNLEVEL_GAME ? (Master.current_runlevel == RUNLEVEL_GAME ? "Active" : "Finishing") : "Starting"] -- [server ? server : "[world.internet_address]:[world.port]"]"


/mob/new_player/proc/update_new_player_panel()
	if (client && !QDELING(src))
		return new_player_panel_proc()
	return FALSE

/hook/roundstart/proc/update_new_player_panels()
	for(var/mob/new_player/player in GLOB.player_list)
		player.update_new_player_panel()
	return 1

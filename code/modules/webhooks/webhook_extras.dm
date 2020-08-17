/proc/get_world_url()
	. = "byond://"
	if(config.serverurl)
		. += config.serverurl
	else if(config.server)
		. += config.server
	else
		. += "[world.address]:[world.port]"
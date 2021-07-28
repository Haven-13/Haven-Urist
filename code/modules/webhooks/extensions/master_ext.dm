/datum/controller/master/StartProcessing(delay)
	SSwebhooks.send(WEBHOOK_ROUNDSTART, list("url" = get_world_url()))
	. = ..()

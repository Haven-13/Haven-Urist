/datum/game_mode/declare_completion()
	. = ..()
	SSwebhooks.send(
		WEBHOOK_ROUNDEND,
		null
	)

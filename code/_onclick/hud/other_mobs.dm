/mob/living/carbon/slime
	hud_type = /datum/hud/slime

/datum/hud/slime/FinalizeInstantiation(ui_style = 'resources/icons/mob/screen1_Midnight.dmi')
	src.adding = list()

	var/atom/movable/screen/using

	using = new /atom/movable/screen/intent()
	src.adding += using
	action_intent = using

	mymob.client.screen = list()
	mymob.client.screen += src.adding

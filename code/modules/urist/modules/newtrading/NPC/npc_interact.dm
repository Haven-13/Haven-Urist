
/mob/living/simple_animal/hostile/npc/verb/npc_interact()
	set src in view(1)
	set name = "Interact with NPC"
	set category = "NPC"

	attack_hand(usr)

/mob/living/simple_animal/hostile/npc/attack_hand(var/mob/living/user)
	if(user && istype(user) && can_use(user))

		if(interacting_mob && !can_use(interacting_mob))
			interacting_mob = null

		if(interacting_mob && interacting_mob != user)
			to_chat(user, "[src] is already dealing with [interacting_mob]!")

		else
			current_greeting_index = rand(1, greetings.len)
			say(greetings[current_greeting_index])
			speak_chance = 0

			add_fingerprint(user)
			user.set_machine(src)
			interacting_mob = user
			ui_interact(user)


/mob/living/simple_animal/hostile/npc/ui_state(mob/user)
	return ui_default_state()

/mob/living/simple_animal/hostile/npc/ui_interact(mob/user, var/datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "npcs/NpcInteraction", name)
		ui.open()

/mob/living/simple_animal/hostile/npc/ui_data(mob/user)
	wander = 0
	/*spawn(600)
		wander = 1
		interacting_mob = null*/
	src.dir = get_dir(src, user)

	var/data[0]
	data["name"] = src.name
	data["interactIcon"] = interact_icon
	data["interactScreen"] = interact_screen
	data["canTrade"] = interact_inventory.len ? 1 : 0
	data["canService"] = 0

	data["greeting"] = greetings[current_greeting_index]
	data["speechTopics"] = list()
	for (var/i in 1 to length(speech_triggers))
		var/datum/npc_speech_trigger/T = GLOB.npc_speech_topics[speech_triggers[i]]
		data["speechTopics"] += list(list(
			"key" = i,
			"id" = T,
			"name" = T.name
		))

	data["interactInventory"] = interact_inventory

	var/mob/living/carbon/M = user
	data["leftHand"] = M.l_hand ? list(
		"name" = M.l_hand,
		"icon" = getFlatIcon(M.l_hand),
		"worth" = round(get_trade_value(M.l_hand) * 0.9),
		"sellable" = check_tradeable(M.l_hand),
		"isStorage" = istype(M.l_hand, /obj/item/weapon/storage)
	) : null
	data["rightHand"] = M.r_hand ? list(
		"name" = M.r_hand,
		"icon" = getFlatIcon(M.r_hand),
		"worth" = round(get_trade_value(M.r_hand) * 0.9),
		"sellable" = check_tradeable(M.r_hand),
		"isStorage" = istype(M.r_hand, /obj/item/weapon/storage)
	) : null

	data["user"] = REF(user)

	return data

/mob/living/simple_animal/hostile/npc/ui_act(action, list/params, datum/tgui/ui)
	switch(action)
		if("sell_item_l")
			var/mob/living/carbon/M = locate(params["user"])
			if(M && istype(M))
				var/obj/O = M.l_hand
				var/worth = text2num(params["worth"])
				player_sell(O, M, worth)
			. = TRUE
		if("ask_question")
			var/mob/living/carbon/M = locate(params["user"])
			if(say_next)
				to_chat(M,"<span class='warning'>[src] is already responding to something...</span>")
			else
				var/choice = text2num(params["topic"])
				handle_question(M, choice)
			. = TRUE
		if("sell_item_r")
			var/mob/living/carbon/M = locate(params["user"])
			if(M && istype(M))
				var/obj/O = M.r_hand
				var/worth = text2num(params["worth"])
				player_sell(O, M, worth)
			. = TRUE
		if("buy_item")
			var/mob/living/carbon/M = locate(params["user"])
			if(M && istype(M))
				var/item_name = params["buy_item"]
				player_buy(item_name, M)
			. = TRUE
		if("close")
			close_ui(ui)

/mob/living/simple_animal/hostile/npc/proc/close_ui(var/datum/tgui/ui = null)
	if(ui)
		ui.close()
	interacting_mob = null
	say(pick(goodbyes))
	speak_chance = initial(speak_chance)

/mob/living/simple_animal/hostile/npc/proc/handle_question(var/mob/living/carbon/user, var/choice)
	if(!choice)
		return

	var/datum/npc_speech_trigger/T = GLOB.npc_speech_topics[speech_triggers[choice]]
	if(angryspeak)
		src.say(T.get_angryresponse_phrase())
	else
		src.say(T.get_response_phrase())
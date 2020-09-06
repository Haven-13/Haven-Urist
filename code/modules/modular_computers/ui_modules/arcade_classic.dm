// Nano module the program uses.
// This can be either /datum/ui_module/ or /datum/ui_module/program. The latter is intended for nano modules that are suposed to be exclusively used with modular computers,
// and should generally not be used, as such nano modules are hard to use on other places.
/datum/ui_module/arcade_classic/
	name = "Classic Arcade"
	var/player_mana			// Various variables specific to the nano module. In this case, the nano module is a simple arcade game, so the variables store health and other stats.
	var/player_health
	var/enemy_mana
	var/enemy_health
	var/enemy_name = "Greytide Horde"
	var/gameover
	var/information

/datum/ui_module/arcade_classic/New()
	..()
	new_game()

// ui_interact handles transfer of data to NanoUI. Keep in mind that data you pass from here is actually sent to the client. In other words, don't send anything you don't want a client
// to see, and don't send unnecessarily large amounts of data (due to laginess).
/datum/ui_module/arcade_classic/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "ArcadeClassicGame")
		ui.open()

/datum/ui_module/arcade_classic/ui_data(mob/user)
	var/list/data = host.initial_data()

	data["player_health"] = player_health
	data["player_mana"] = player_mana
	data["enemy_health"] = enemy_health
	data["enemy_mana"] = enemy_mana
	data["enemy_name"] = enemy_name
	data["gameover"] = gameover
	data["information"] = information

	return data

// Three helper procs i've created. These are unique to this particular nano module. If you are creating your own nano module, you'll most likely create similar procs too.
/datum/ui_module/arcade_classic/proc/enemy_play()
	if((enemy_mana < 5) && prob(60))
		var/steal = rand(2, 3)
		player_mana -= steal
		enemy_mana += steal
		information += "[enemy_name] steals [steal] of your power!"
	else if((enemy_health < 15) && (enemy_mana > 3) && prob(80))
		var/healamt = min(rand(3, 5), enemy_mana)
		enemy_mana -= healamt
		enemy_health += healamt
		information += "[enemy_name] heals for [healamt] health!"
	else
		var/dam = rand(3,6)
		player_health -= dam
		information += "[enemy_name] attacks for [dam] damage!"

/datum/ui_module/arcade_classic/proc/check_gameover()
	if((player_health <= 0) || player_mana <= 0)
		if(enemy_health <= 0)
			information += "You have defeated [enemy_name], but you have died in the fight!"
		else
			information += "You have been defeated by [enemy_name]!"
		gameover = 1
		return TRUE
	else if(enemy_health <= 0)
		gameover = 1
		information += "Congratulations! You have defeated [enemy_name]!"
		return TRUE
	return FALSE

/datum/ui_module/arcade_classic/proc/new_game()
	player_mana = 10
	player_health = 30
	enemy_mana = 20
	enemy_health = 45
	gameover = FALSE
	information = "A new game has started!"



/datum/ui_module/arcade_classic/Topic(href, href_list)
	if(..())		// Always begin your Topic() calls with a parent call!
		return 1
	if(href_list["new_game"])
		new_game()
		return 1	// Returning 1 (TRUE) in Topic automatically handles UI updates.
	if(gameover)	// If the game has already ended, we don't want the following three topic calls to be processed at all.
		return 1	// Instead of adding checks into each of those three, we can easily add this one check here to reduce on code copy-paste.
	if(href_list["attack"])
		var/damage = rand(2, 6)
		information = "You attack for [damage] damage."
		enemy_health -= damage
		enemy_play()
		check_gameover()
		return 1
	if(href_list["heal"])
		var/healfor = rand(6, 8)
		var/cost = rand(1, 3)
		information = "You heal yourself for [healfor] damage, using [cost] energy in the process."
		player_health += healfor
		player_mana -= cost
		enemy_play()
		check_gameover()
		return 1
	if(href_list["regain_mana"])
		var/regen = rand(4, 7)
		information = "You rest of a while, regaining [regen] energy."
		player_mana += regen
		enemy_play()
		check_gameover()
		return 1
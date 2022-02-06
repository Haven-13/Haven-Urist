var/atom/movable/screen/robot_inventory

/mob/living/silicon/robot
	hud_type = /datum/hud/robot

/datum/hud/robot/FinalizeInstantiation()

	src.adding = list()
	src.other = list()

	var/atom/movable/screen/using

	var/mob/living/silicon/robot/myrobot = mymob

//Radio
	using = new /atom/movable/screen()
	using.SetName("radio")
	using.set_dir(SOUTHWEST)
	using.icon = 'resources/icons/mob/screen1_robot.dmi'
	using.icon_state = "radio"
	using.screen_loc = ui_movi
	src.adding += using

//Module select

	using = new /atom/movable/screen()
	using.SetName("module1")
	using.set_dir(SOUTHWEST)
	using.icon = 'resources/icons/mob/screen1_robot.dmi'
	using.icon_state = "inv1"
	using.screen_loc = ui_inv1
	src.adding += using
	myrobot.inv1 = using

	using = new /atom/movable/screen()
	using.SetName("module2")
	using.set_dir(SOUTHWEST)
	using.icon = 'resources/icons/mob/screen1_robot.dmi'
	using.icon_state = "inv2"
	using.screen_loc = ui_inv2
	src.adding += using
	myrobot.inv2 = using

	using = new /atom/movable/screen()
	using.SetName("module3")
	using.set_dir(SOUTHWEST)
	using.icon = 'resources/icons/mob/screen1_robot.dmi'
	using.icon_state = "inv3"
	using.screen_loc = ui_inv3
	src.adding += using
	myrobot.inv3 = using

//End of module select

//Intent
	using = new /atom/movable/screen()
	using.SetName("act_intent")
	using.set_dir(SOUTHWEST)
	using.icon = 'resources/icons/mob/screen1_robot.dmi'
	using.icon_state = mymob.a_intent
	using.screen_loc = ui_acti
	src.adding += using
	action_intent = using

//Cell
	myrobot.cells = new /atom/movable/screen()
	myrobot.cells.icon = 'resources/icons/mob/screen1_robot.dmi'
	myrobot.cells.icon_state = "charge-empty"
	myrobot.cells.SetName("cell")
	myrobot.cells.screen_loc = ui_toxin

//Health
	mymob.healths = new /atom/movable/screen()
	mymob.healths.icon = 'resources/icons/mob/screen1_robot.dmi'
	mymob.healths.icon_state = "health0"
	mymob.healths.SetName("health")
	mymob.healths.screen_loc = ui_borg_health

//Installed Module
	mymob.hands = new /atom/movable/screen()
	mymob.hands.icon = 'resources/icons/mob/screen1_robot.dmi'
	mymob.hands.icon_state = "nomod"
	mymob.hands.SetName("module")
	mymob.hands.screen_loc = ui_borg_module

//Module Panel
	using = new /atom/movable/screen()
	using.SetName("panel")
	using.icon = 'resources/icons/mob/screen1_robot.dmi'
	using.icon_state = "panel"
	using.screen_loc = ui_borg_panel
	src.adding += using

//Store
	mymob.throw_icon = new /atom/movable/screen()
	mymob.throw_icon.icon = 'resources/icons/mob/screen1_robot.dmi'
	mymob.throw_icon.icon_state = "store"
	mymob.throw_icon.SetName("store")
	mymob.throw_icon.screen_loc = ui_borg_store

//Inventory
	robot_inventory = new /atom/movable/screen()
	robot_inventory.SetName("inventory")
	robot_inventory.icon = 'resources/icons/mob/screen1_robot.dmi'
	robot_inventory.icon_state = "inventory"
	robot_inventory.screen_loc = ui_borg_inventory

//Temp
	mymob.bodytemp = new /atom/movable/screen()
	mymob.bodytemp.icon_state = "temp0"
	mymob.bodytemp.SetName("body temperature")
	mymob.bodytemp.screen_loc = ui_temp


	mymob.oxygen = new /atom/movable/screen()
	mymob.oxygen.icon = 'resources/icons/mob/screen1_robot.dmi'
	mymob.oxygen.icon_state = "oxy0"
	mymob.oxygen.SetName("oxygen")
	mymob.oxygen.screen_loc = ui_oxygen

	mymob.fire = new /atom/movable/screen()
	mymob.fire.icon = 'resources/icons/mob/screen1_robot.dmi'
	mymob.fire.icon_state = "fire0"
	mymob.fire.SetName("fire")
	mymob.fire.screen_loc = ui_fire

	mymob.pullin = new /atom/movable/screen()
	mymob.pullin.icon = 'resources/icons/mob/screen1_robot.dmi'
	mymob.pullin.icon_state = "pull0"
	mymob.pullin.SetName("pull")
	mymob.pullin.screen_loc = ui_borg_pull

	mymob.zone_sel = new /atom/movable/screen/zone_sel()
	mymob.zone_sel.icon = 'resources/icons/mob/screen1_robot.dmi'
	mymob.zone_sel.overlays.Cut()
	mymob.zone_sel.overlays += image('resources/icons/mob/zone_sel.dmi', "[mymob.zone_sel.selecting]")

	//Handle the gun settings buttons
	mymob.gun_setting_icon = new /atom/movable/screen/gun/mode(null)
	mymob.item_use_icon = new /atom/movable/screen/gun/item(null)
	mymob.gun_move_icon = new /atom/movable/screen/gun/move(null)
	mymob.radio_use_icon = new /atom/movable/screen/gun/radio(null)

	mymob.client.screen = list()
	mymob.client.screen += list(mymob.throw_icon, mymob.zone_sel, mymob.oxygen, mymob.fire, mymob.hands, mymob.healths, myrobot.cells, mymob.pullin, robot_inventory, mymob.gun_setting_icon)
	mymob.client.screen += src.adding + src.other

/datum/hud/proc/toggle_show_robot_modules()
	if(!is_robot(mymob))
		return

	var/mob/living/silicon/robot/r = mymob

	r.shown_robot_modules = !r.shown_robot_modules
	update_robot_modules_display()


/datum/hud/proc/update_robot_modules_display()
	if(!is_robot(mymob))
		return

	var/mob/living/silicon/robot/r = mymob

	if(r.shown_robot_modules)
		if(r.s_active)
			r.s_active.close(r) //Closes the inventory ui.
		//Modules display is shown
		//r.client.screen += robot_inventory	//"store" icon

		if(!r.module)
			to_chat(usr, "<span class='danger'>No module selected</span>")
			return

		if(!r.module.modules)
			to_chat(usr, "<span class='danger'>Selected module has no modules to select</span>")
			return

		if(!r.robot_modules_background)
			return

		var/display_rows = -round(-(r.module.modules.len) / 8)
		r.robot_modules_background.screen_loc = "CENTER-4:16,SOUTH+1:7 to CENTER+3:16,SOUTH+[display_rows]:7"
		r.client.screen += r.robot_modules_background

		var/x = -4	//Start at CENTER-4,SOUTH+1
		var/y = 1

		//Unfortunately adding the emag module to the list of modules has to be here. This is because a borg can
		//be emagged before they actually select a module. - or some situation can cause them to get a new module
		// - or some situation might cause them to get de-emagged or something.
		if(r.emagged)
			if(!(r.module.emag in r.module.modules))
				r.module.modules.Add(r.module.emag)
		else
			if(r.module.emag in r.module.modules)
				r.module.modules.Remove(r.module.emag)

		for(var/atom/movable/A in r.module.modules)
			if( (A != r.module_state_1) && (A != r.module_state_2) && (A != r.module_state_3) )
				//Module is not currently active
				r.client.screen += A
				if(x < 0)
					A.screen_loc = "CENTER[x]:[WORLD_ICON_SIZE/2],SOUTH+[y]:7"
				else
					A.screen_loc = "CENTER+[x]:[WORLD_ICON_SIZE/2],SOUTH+[y]:7"
				A.hud_layerise()

				x++
				if(x == 4)
					x = -4
					y++

	else
		//Modules display is hidden
		//r.client.screen -= robot_inventory	//"store" icon
		for(var/atom/A in r.module.modules)
			if( (A != r.module_state_1) && (A != r.module_state_2) && (A != r.module_state_3) )
				//Module is not currently active
				r.client.screen -= A
		r.shown_robot_modules = 0
		r.client.screen -= r.robot_modules_background

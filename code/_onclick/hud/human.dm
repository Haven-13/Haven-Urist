/mob/living/carbon/human
	hud_type = /datum/hud/human

/datum/hud/human/FinalizeInstantiation(var/ui_style='icons/mob/screen1_White.dmi', var/ui_color = "#ffffff", var/ui_alpha = 255)
	var/mob/living/carbon/human/target = mymob
	var/datum/hud_data/hud_data
	if(!istype(target))
		hud_data = new()
	else
		hud_data = target.species.hud

	if(hud_data.icon)
		ui_style = hud_data.icon

	ui_style = 'icons/mob/screen/neue.dmi'

	src.adding = list()
	src.other = list()
	src.hotkeybuttons = list() //These can be disabled for hotkey usersx

	var/list/hud_elements = list()
	var/atom/movable/screen/using
	var/atom/movable/screen/inventory/inv_box

	using = new /atom/movable/screen() //Right hud bar
	using.dir = SOUTH
	using.icon = ui_style
	using.icon_state = "right_bg"
	using.screen_loc = "EAST+1,SOUTH to EAST+1,NORTH"
	using.layer = UNDER_HUD_LAYER
	adding += using

	using = new /atom/movable/screen() //Left hud bar (leftmost)
	using.dir = WEST
	using.icon = ui_style
	using.icon_state = "left_left"
	using.screen_loc = "WEST-3,SOUTH to WEST-3,NORTH"
	using.layer = UNDER_HUD_LAYER
	adding += using

	using = new /atom/movable/screen() //Left hud bar (center)
	using.dir = WEST
	using.icon = ui_style
	using.icon_state = "left_mid"
	using.screen_loc = "WEST-2,SOUTH to WEST-2,NORTH"
	using.layer = UNDER_HUD_LAYER
	adding += using

	using = new /atom/movable/screen() //Left hud bar (rightmost)
	using.dir = WEST
	using.icon = ui_style
	using.icon_state = "left_right"
	using.screen_loc = "WEST-1,SOUTH to WEST-1,NORTH"
	using.layer = UNDER_HUD_LAYER
	adding += using

	// Draw the various inventory equipment slots.
	for(var/gear_slot in hud_data.gear)

		inv_box = new /atom/movable/screen/inventory()
		inv_box.icon = ui_style
		inv_box.color = ui_color
		inv_box.alpha = ui_alpha

		var/list/slot_data =  hud_data.gear[gear_slot]
		inv_box.SetName(slot_data["name"])
		inv_box.screen_loc =  slot_data["loc"]
		inv_box.slot_id =     slot_data["slot"]
		inv_box.icon_state =  slot_data["state"]

		if(slot_data["dir"])
			inv_box.set_dir(slot_data["dir"])

		src.adding += inv_box

	// Draw the attack intent dialogue.
	if(hud_data.has_a_intent)
		using = new /atom/movable/screen/intent()
		src.adding += using
		action_intent = using

		hud_elements |= using

	if(hud_data.has_m_intent)
		using = new /atom/movable/screen()
		using.SetName("mov_intent")
		using.icon = ui_style
		using.icon_state = mymob.move_intent.hud_icon_state
		using.screen_loc = UI_INTENT_PACE
		using.color = ui_color
		using.alpha = ui_alpha
		src.adding += using
		move_intent = using

	if(hud_data.has_drop)
		using = new /atom/movable/screen()
		using.SetName("drop")
		using.icon = ui_style
		using.icon_state = "act_drop"
		using.screen_loc = UI_BUTTON_THROW
		using.color = ui_color
		using.alpha = ui_alpha
		src.hotkeybuttons += using

	if(hud_data.has_hands)

		using = new /atom/movable/screen()
		using.SetName("equip")
		using.icon = ui_style
		using.icon_state = "act_equip"
		using.screen_loc = UI_EQUIP
		using.color = ui_color
		using.alpha = ui_alpha
		src.adding += using

		inv_box = new /atom/movable/screen/inventory()
		inv_box.SetName("r_hand")
		inv_box.icon = ui_style
		inv_box.icon_state = "r_hand_inactive"
		if(mymob && !mymob.hand)	//This being 0 or null means the right hand is in use
			inv_box.icon_state = "r_hand_active"
		inv_box.screen_loc = UI_HAND_RIGHT
		inv_box.slot_id = slot_r_hand
		inv_box.color = ui_color
		inv_box.alpha = ui_alpha

		src.r_hand_hud_object = inv_box
		src.adding += inv_box

		inv_box = new /atom/movable/screen/inventory()
		inv_box.SetName("l_hand")
		inv_box.icon = ui_style
		inv_box.icon_state = "l_hand_inactive"
		if(mymob && mymob.hand)	//This being 1 means the left hand is in use
			inv_box.icon_state = "l_hand_active"
		inv_box.screen_loc = UI_HAND_LEFT
		inv_box.slot_id = slot_l_hand
		inv_box.color = ui_color
		inv_box.alpha = ui_alpha
		src.l_hand_hud_object = inv_box
		src.adding += inv_box

		using = new /atom/movable/screen/inventory()
		using.SetName("hand")
		using.icon = ui_style
		using.icon_state = "swap"
		using.screen_loc = UI_SWAPHAND1
		using.color = ui_color
		using.alpha = ui_alpha
		src.adding += using

	if(hud_data.has_resist)
		using = new /atom/movable/screen()
		using.SetName("resist")
		using.icon = ui_style
		using.icon_state = "act_resist"
		using.screen_loc = UI_BUTTON_RESIST
		using.color = ui_color
		using.alpha = ui_alpha
		src.hotkeybuttons += using

	if(hud_data.has_throw)
		mymob.throw_icon = new /atom/movable/screen()
		mymob.throw_icon.icon = ui_style
		mymob.throw_icon.icon_state = "act_throw_off"
		mymob.throw_icon.SetName("throw")
		mymob.throw_icon.screen_loc = UI_BUTTON_THROW
		mymob.throw_icon.color = ui_color
		mymob.throw_icon.alpha = ui_alpha
		src.hotkeybuttons += mymob.throw_icon
		hud_elements |= mymob.throw_icon

		mymob.pullin = new /atom/movable/screen()
		mymob.pullin.icon = ui_style
		mymob.pullin.icon_state = "pull0"
		mymob.pullin.SetName("pull")
		mymob.pullin.screen_loc = UI_BUTTON_RESIST
		src.hotkeybuttons += mymob.pullin
		hud_elements |= mymob.pullin

	if(hud_data.has_internals)
		mymob.internals = new /atom/movable/screen()
		mymob.internals.icon = ui_style
		mymob.internals.icon_state = "internal0"
		mymob.internals.SetName("internal")
		mymob.internals.screen_loc = UI_METER_INTERNAL
		hud_elements |= mymob.internals

	/**
	*** RIGHT HUD BAR
	**/

	// Warnings background
	using = new /atom/movable/screen()
	using.dir = SOUTH
	using.icon = ui_style
	using.icon_state = "dash_cap"
	using.screen_loc = UI_WARNING_TOXIN
	using.layer = UNDER_HUD_LAYER
	adding += using

	using = new /atom/movable/screen()
	using.dir = NORTH
	using.icon = ui_style
	using.icon_state = "dash_cap"
	using.screen_loc = UI_WARNING_FREEZE
	using.layer = UNDER_HUD_LAYER
	adding += using

	using = new /atom/movable/screen()
	using.dir = SOUTH
	using.icon = ui_style
	using.icon_state = "dash_vertical"
	using.screen_loc = "[UI_WARNING_OXYGEN] to [UI_WARNING_FIRE]"
	using.layer = UNDER_HUD_LAYER
	adding += using

	if(hud_data.has_warnings)
		mymob.toxin = new /atom/movable/screen()
		mymob.toxin.icon = ui_style
		mymob.toxin.icon_state = "tox0"
		mymob.toxin.SetName("toxin")
		mymob.toxin.screen_loc = UI_WARNING_TOXIN
		hud_elements |= mymob.toxin

		mymob.oxygen = new /atom/movable/screen()
		mymob.oxygen.icon = ui_style
		mymob.oxygen.icon_state = "oxy0"
		mymob.oxygen.SetName("oxygen")
		mymob.oxygen.screen_loc = UI_WARNING_OXYGEN
		hud_elements |= mymob.oxygen

		mymob.fire = new /atom/movable/screen()
		mymob.fire.icon = ui_style
		mymob.fire.icon_state = "fire0"
		mymob.fire.SetName("fire")
		mymob.fire.screen_loc = UI_WARNING_FIRE
		hud_elements |= mymob.fire

		mymob.freeze = new /atom/movable/screen()
		mymob.freeze.icon = ui_style
		mymob.freeze.icon_state = "freeze0"
		mymob.freeze.SetName("freeze")
		mymob.freeze.screen_loc = UI_WARNING_FREEZE
		hud_elements |= mymob.freeze

		mymob.healths = new /atom/movable/screen()
		mymob.healths.icon = ui_style
		mymob.healths.icon_state = "health0"
		mymob.healths.SetName("health")
		mymob.healths.screen_loc = UI_METER_HEALTH
		hud_elements |= mymob.healths

	if(hud_data.has_pressure)
		using = new /atom/movable/screen()
		using.dir = SOUTH
		using.icon = ui_style
		using.icon_state = "gauge_pressure"
		using.screen_loc = UI_METER_PRESSURE
		using.layer = UNDER_HUD_LAYER
		adding += using

		mymob.pressure = new /atom/movable/screen()
		mymob.pressure.icon = ui_style
		mymob.pressure.icon_state = "gauge_indictator"
		mymob.pressure.SetName("Pressure")
		mymob.pressure.screen_loc = UI_METER_PRESSURE
		hud_elements |= mymob.pressure

		mymob.pressure_lamp = new /atom/movable/screen()
		mymob.pressure_lamp.icon = ui_style
		mymob.pressure_lamp.icon_state = "cover_alert_0"
		mymob.pressure_lamp.screen_loc = UI_METER_PRESSURE
		mymob.pressure_lamp.layer = UNDER_HUD_LAYER + 2
		hud_elements |= mymob.pressure_lamp

		using = new /atom/movable/screen()
		using.dir = SOUTH
		using.icon = ui_style
		using.icon_state = "cover_pressure"
		using.screen_loc = UI_METER_PRESSURE
		using.layer = UNDER_HUD_LAYER + 1
		adding += using

	if(hud_data.has_bodytemp)
		using = new /atom/movable/screen()
		using.dir = SOUTH
		using.icon = ui_style
		using.icon_state = "gauge_temp"
		using.screen_loc = UI_METER_BODY_TEMPERATURE
		using.layer = UNDER_HUD_LAYER
		adding += using

		mymob.bodytemp = new /atom/movable/screen()
		mymob.bodytemp.icon = ui_style
		mymob.bodytemp.icon_state = "gauge_indictator"
		mymob.bodytemp.SetName("Body Temperature")
		mymob.bodytemp.screen_loc = UI_METER_BODY_TEMPERATURE
		hud_elements |= mymob.bodytemp

		mymob.bodytemp_lamp = new /atom/movable/screen()
		mymob.bodytemp_lamp.icon = ui_style
		mymob.bodytemp_lamp.icon_state = "cover_alert_0"
		mymob.bodytemp_lamp.screen_loc = UI_METER_BODY_TEMPERATURE
		mymob.bodytemp_lamp.layer = UNDER_HUD_LAYER + 2
		hud_elements |= mymob.bodytemp_lamp

		using = new /atom/movable/screen()
		using.dir = SOUTH
		using.icon = ui_style
		using.icon_state = "cover_temp"
		using.screen_loc = UI_METER_BODY_TEMPERATURE
		using.layer = UNDER_HUD_LAYER + 1
		adding += using

	if(target.isSynthetic())

		target.cells = new /atom/movable/screen()
		target.cells.icon = 'icons/mob/screen1_robot.dmi'
		target.cells.icon_state = "charge-empty"
		target.cells.SetName("cell")
		target.cells.screen_loc = UI_METER_NUTRITION
		hud_elements |= target.cells

	else if(hud_data.has_nutrition)
		mymob.nutrition_icon = new /atom/movable/screen()
		mymob.nutrition_icon.icon = ui_style
		mymob.nutrition_icon.icon_state = "nutrition0"
		mymob.nutrition_icon.SetName("nutrition")
		mymob.nutrition_icon.screen_loc = UI_METER_NUTRITION
		hud_elements |= mymob.nutrition_icon


	mymob.pain = new /atom/movable/screen/fullscreen/pain( null )
	hud_elements |= mymob.pain

	mymob.zone_sel = new /atom/movable/screen/zone_sel( null )
	mymob.zone_sel.icon = ui_style
	mymob.zone_sel.color = ui_color
	mymob.zone_sel.alpha = ui_alpha
	mymob.zone_sel.overlays.Cut()
	mymob.zone_sel.overlays += image('icons/mob/zone_sel.dmi', "[mymob.zone_sel.selecting]")
	hud_elements |= mymob.zone_sel

	//Handle the gun settings buttons
	mymob.gun_setting_icon = new /atom/movable/screen/gun/mode(null)
	mymob.gun_setting_icon.icon = ui_style
	mymob.gun_setting_icon.color = ui_color
	mymob.gun_setting_icon.alpha = ui_alpha
	hud_elements |= mymob.gun_setting_icon

	mymob.item_use_icon = new /atom/movable/screen/gun/item(null)
	mymob.item_use_icon.icon = ui_style
	mymob.item_use_icon.color = ui_color
	mymob.item_use_icon.alpha = ui_alpha

	mymob.gun_move_icon = new /atom/movable/screen/gun/move(null)
	mymob.gun_move_icon.icon = ui_style
	mymob.gun_move_icon.color = ui_color
	mymob.gun_move_icon.alpha = ui_alpha

	mymob.radio_use_icon = new /atom/movable/screen/gun/radio(null)
	mymob.radio_use_icon.icon = ui_style
	mymob.radio_use_icon.color = ui_color
	mymob.radio_use_icon.alpha = ui_alpha

	mymob.client.screen = list()

	mymob.client.screen += hud_elements
	mymob.client.screen += src.adding + src.hotkeybuttons
	inventory_shown = 0

/mob/living/carbon/human/verb/toggle_hotkey_verbs()
	set category = "OOC"
	set name = "Toggle hotkey buttons"
	set desc = "This disables or enables the user interface buttons which can be used with hotkeys."

	if(hud_used.hotkey_ui_hidden)
		client.screen += hud_used.hotkeybuttons
		hud_used.hotkey_ui_hidden = 0
	else
		client.screen -= hud_used.hotkeybuttons
		hud_used.hotkey_ui_hidden = 1

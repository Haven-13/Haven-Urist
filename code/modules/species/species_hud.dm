/datum/hud_data
	var/icon              // If set, overrides ui_style.
	var/has_a_intent = 1  // Set to draw intent box.
	var/has_m_intent = 1  // Set to draw move intent box.
	var/has_warnings = 1  // Set to draw environment warnings.
	var/has_pressure = 1  // Draw the pressure indicator.
	var/has_nutrition = 1 // Draw the nutrition indicator.
	var/has_bodytemp = 1  // Draw the bodytemp indicator.
	var/has_hands = 1     // Set to draw hands.
	var/has_drop = 1      // Set to draw drop button.
	var/has_throw = 1     // Set to draw throw button.
	var/has_resist = 1    // Set to draw resist button.
	var/has_internals = 1 // Set to draw the internals toggle button.
	var/list/equip_slots = list() // Checked by mob_can_equip().

	// Contains information on the position and tag for all inventory slots
	// to be drawn for the mob. This is fairly delicate, try to avoid messing with it
	// unless you know exactly what it does.
	var/list/gear = list(
		"i_clothing" = list(
			"loc" = UI_INVENTORY_SLOT_UNDERSUIT,
			"name" = "Uniform",
			"slot" = slot_w_uniform,
			"state" = "center"
		),
		"o_clothing" = list(
			"loc" = UI_INVENTORY_SLOT_OVERSUIT,
			"name" = "Suit",
			"slot" = slot_wear_suit,
			"state" = "suit"
		),
		"mask" = list(
			"loc" = UI_INVENTORY_SLOT_MASK,
			"name" = "Mask",
			"slot" = slot_wear_mask,
			"state" = "mask"
		),
		"gloves" = list(
			"loc" = UI_INVENTORY_SLOT_GLOVES,
			"name" = "Gloves",
			"slot" = slot_gloves,
			"state" = "gloves"
		),
		"eyes" = list(
			"loc" = UI_INVENTORY_SLOT_GLASSES,
			"name" = "Glasses",
			"slot" = slot_glasses,
			"state" = "glasses"
		),
		"l_ear" = list(
			"loc" = UI_INVENTORY_SLOT_EAR_LEFT,
			"name" = "Left Ear",
			"slot" = slot_l_ear,
			"state" = "ears"
		),
		"r_ear" = list(
			"loc" = UI_INVENTORY_SLOT_EAR_RIGHT,
			"name" = "Right Ear",
			"slot" = slot_r_ear,
			"state" = "ears"
		),
		"head" = list(
			"loc" = UI_INVENTORY_SLOT_HEADWEAR,
			"name" = "Hat",
			"slot" = slot_head,
			"state" = "hair",
		),
		"shoes" = list(
			"loc" = UI_INVENTORY_SLOT_SHOES,
			"name" = "Shoes",
			"slot" = slot_shoes,
			"state" = "shoes"
		),
		"suit storage" = list(
			"loc" = UI_INVENTORY_SLOT_POCKET_SUIT,
			"name" = "Suit Storage",
			"slot" = slot_s_store,
			"state" = "suitstore"
		),
		"back" = list(
			"loc" = UI_INVENTORY_SLOT_BACK,
			"name" = "Back",
			"slot" = slot_back,
			"state" = "back"
		),
		"id" = list(
			"loc" = UI_INVENTORY_SLOT_CARD,
			"name" = "ID",
			"slot" = slot_wear_id,
			"state" = "id"
		),
		"storage1" = list(
			"loc" = UI_INVENTORY_SLOT_POCKET_LEFT,
			"name" = "Left Pocket",
			"slot" = slot_l_store,
			"state" = "pocket"
		),
		"storage2" = list(
			"loc" = UI_INVENTORY_SLOT_POCKET_RIGHT,
			"name" = "Right Pocket",
			"slot" = slot_r_store,
			"state" = "pocket"
		),
		"belt" = list(
			"loc" = UI_INVENTORY_SLOT_BELT,
			"name" = "Belt",
			"slot" = slot_belt,
			"state" = "belt"
		)
	)

/datum/hud_data/New()
	..()
	for(var/slot in gear)
		equip_slots |= gear[slot]["slot"]

	if(has_hands)
		equip_slots |= slot_l_hand
		equip_slots |= slot_r_hand
		equip_slots |= slot_handcuffed

	if(slot_back in equip_slots)
		equip_slots |= slot_in_backpack

	if(slot_w_uniform in equip_slots)
		equip_slots |= slot_tie

	equip_slots |= slot_legcuffed

/datum/hud_data/nabber
	has_internals = 0
	gear = list(
		"i_clothing" = list(
			"loc" = UI_INVENTORY_SLOT_UNDERSUIT,
			"name" = "Uniform",
			"slot" = slot_w_uniform,
			"state" = "center"
		),
		"o_clothing" = list(
			"loc" = UI_INVENTORY_SLOT_SHOES,
			"name" = "Suit",
			"slot" = slot_wear_suit,
			"state" = "suit"
		),
		"l_ear" = list(
			"loc" = UI_INVENTORY_SLOT_OVERSUIT,
			"name" = "Ear",
			"slot" = slot_l_ear,
			"state" = "ears"
		),
		"gloves" = list(
			"loc" = UI_INVENTORY_SLOT_GLOVES,
			"name" = "Gloves",
			"slot" = slot_gloves,
			"state" = "gloves"
		),
		"suit storage" = list(
			"loc" = UI_INVENTORY_SLOT_POCKET_SUIT,
			"name" = "Suit Storage",
			"slot" = slot_s_store,
			"state" = "suitstore"
		),
		"back" = list(
			"loc" = UI_INVENTORY_SLOT_BACK,
			"name" = "Back",
			"slot" = slot_back,
			"state" = "back"
		),
		"id" = list(
			"loc" = UI_INVENTORY_SLOT_CARD,
			"name" = "ID",
			"slot" = slot_wear_id,
			"state" = "id"
		),
		"storage1" = list(
			"loc" = UI_INVENTORY_SLOT_POCKET_LEFT,
			"name" = "Left Pocket",
			"slot" = slot_l_store,
			"state" = "pocket"
		),
		"storage2" = list(
			"loc" = UI_INVENTORY_SLOT_POCKET_RIGHT,
			"name" = "Right Pocket",
			"slot" = slot_r_store,
			"state" = "pocket"
		),
		"belt" = list(
			"loc" = UI_INVENTORY_SLOT_BELT,
			"name" = "Belt",
			"slot" = slot_belt,
			"state" = "belt"
		)
	)

/datum/hud_data/monkey
	gear = list(
		"i_clothing" = list(
			"loc" = UI_INVENTORY_SLOT_UNDERSUIT,
			"name" = "Uniform",
			"slot" = slot_w_uniform,
			"state" = "center"
		),
		"storage1" = list(
			"loc" = UI_INVENTORY_SLOT_POCKET_LEFT,
			"name" = "Left Pocket",
			"slot" = slot_l_store,
			"state" = "pocket"
		),
		"storage2" = list(
			"loc" = UI_INVENTORY_SLOT_POCKET_RIGHT,
			"name" = "Right Pocket",
			"slot" = slot_r_store,
			"state" = "pocket"
		),
		"head" = list(
			"loc" = UI_INVENTORY_SLOT_HEADWEAR,
			"name" = "Hat",
			"slot" = slot_head,
			"state" = "hair"
		),
		"mask" = list(
			"loc" = UI_INVENTORY_SLOT_SHOES,
			"name" = "Mask",
			"slot" = slot_wear_mask,
			"state" = "mask"
		),
		"back" = list(
			"loc" = UI_INVENTORY_SLOT_POCKET_SUIT,
			"name" = "Back",
			"slot" = slot_back,
			"state" = "back"
		),
	)

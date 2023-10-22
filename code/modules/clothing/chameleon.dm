var/global/datum/chameleon_choice_cache/chameleon_cache = new

/datum/chameleon_choice_cache
	var/list/backpacks
	var/list/eyegear
	var/list/facewear
	var/list/footwear
	var/list/headwear
	var/list/handwear
	var/list/oversuits
	var/list/jumpsuits

/datum/chameleon_choice_cache/New()
	. = ..()

	backpacks = generate_chameleon_choices(
		/obj/item/weapon/storage/backpack,
		list(
			/obj/item/weapon/storage/backpack/chameleon,
			/obj/item/weapon/storage/backpack/satchel/grey/withwallet
		)
	)
	eyegear = generate_chameleon_choices(
		/obj/item/clothing/glasses,
		list(/obj/item/clothing/glasses/chameleon)
	)
	facewear = generate_chameleon_choices(
		/obj/item/clothing/mask,
		list(/obj/item/clothing/mask/chameleon)
	)
	footwear = generate_chameleon_choices(
		/obj/item/clothing/shoes,
		list(
			/obj/item/clothing/shoes/chameleon,
			/obj/item/clothing/shoes/syndigaloshes,
			/obj/item/clothing/shoes/cyborg
		)
	)
	handwear = generate_chameleon_choices(
		/obj/item/clothing/gloves,
		list(/obj/item/clothing/gloves/chameleon)
	)
	headwear = generate_chameleon_choices(
		/obj/item/clothing/head,
		list(
			/obj/item/clothing/head/chameleon,
			/obj/item/clothing/head/justice,
		)
	)
	oversuits = generate_chameleon_choices(
		/obj/item/clothing/suit,
		list(
			/obj/item/clothing/suit/chameleon,
			/obj/item/clothing/suit/cyborg_suit,
			/obj/item/clothing/suit/justice,
			/obj/item/clothing/suit/greatcoat,
		)
	)
	jumpsuits = generate_chameleon_choices(
		/obj/item/clothing/under,
		list(
			/obj/item/clothing/under/chameleon,
			/obj/item/clothing/under/cloud,
			/obj/item/clothing/under/gimmick,
		)
	)

/datum/chameleon_choice_cache/proc/generate_chameleon_choices(basetype, blacklist=list())
	. = list()

	var/i = 1 //in case there is a collision with both name AND icon_state
	for(var/typepath in typesof(basetype) - blacklist)
		var/obj/O = typepath
		if(initial(O.icon) && initial(O.icon_state))
			var/name = initial(O.name)
			if(name in .)
				name += " ([initial(O.icon_state)])"
			if(name in .)
				name += " \[[i++]\]"
			.[name] = typepath

//*****************
//**Cham Jumpsuit**
//*****************

/obj/item/proc/disguise(newtype, mob/user)
	if(!user || user.incapacitated())
		return
	//this is necessary, unfortunately, as initial() does not play well with list vars
	var/obj/item/copy = new newtype(null) //so that it is GCed once we exit

	desc = copy.desc
	name = copy.name
	icon_state = copy.icon_state
	item_state = copy.item_state
	body_parts_covered = copy.body_parts_covered
	flags_inv = copy.flags_inv

	if(copy.item_icons)
		item_icons = copy.item_icons.Copy()
	if(copy.item_state_slots)
		item_state_slots = copy.item_state_slots.Copy()
	if(copy.sprite_sheets)
		sprite_sheets = copy.sprite_sheets.Copy()
	//copying sprite_sheets_obj should be unnecessary as chameleon items are not refittable.

	return copy //for inheritance

/obj/item/clothing/under/chameleon
//starts off as a jumpsuit
	name = "jumpsuit"
	icon_state = "jumpsuit"
	item_state = "jumpsuit"
	worn_state = "jumpsuit"
	desc = "It's a plain jumpsuit. It seems to have a small dial on the wrist."
	origin_tech = list(TECH_ILLEGAL = 3)

/obj/item/clothing/under/chameleon/verb/change(picked in chameleon_cache.jumpsuits)
	set name = "Change Jumpsuit Appearance"
	set category = "Chameleon Items"
	set src in usr

	if(!ispath(chameleon_cache.jumpsuits[picked]))
		return

	disguise(chameleon_cache.jumpsuits[picked], usr)
	update_clothing_icon()	//so our overlays update.

//*****************
//**Chameleon Hat**
//*****************

/obj/item/clothing/head/chameleon
	name = "grey cap"
	icon_state = "greysoft"
	desc = "It looks like a plain hat, but upon closer inspection, there's an advanced holographic array installed inside. It seems to have a small dial inside."
	origin_tech = list(TECH_ILLEGAL = 3)
	body_parts_covered = 0

/obj/item/clothing/head/chameleon/verb/change(picked in chameleon_cache.headwear)
	set name = "Change Hat/Helmet Appearance"
	set category = "Chameleon Items"
	set src in usr

	if(!ispath(chameleon_cache.headwear[picked]))
		return

	disguise(chameleon_cache.headwear[picked], usr)
	update_clothing_icon()	//so our overlays update.

//******************
//**Chameleon Suit**
//******************

/obj/item/clothing/suit/chameleon
	name = "armor"
	icon_state = "armor"
	item_state = "armor"
	desc = "It appears to be a vest of standard armor, except this is embedded with a hidden holographic cloaker, allowing it to change it's appearance, but offering no protection.. It seems to have a small dial inside."
	origin_tech = list(TECH_ILLEGAL = 3)

/obj/item/clothing/suit/chameleon/verb/change(picked in chameleon_cache.oversuits)
	set name = "Change Oversuit Appearance"
	set category = "Chameleon Items"
	set src in usr

	if(!ispath(chameleon_cache.oversuits[picked]))
		return

	disguise(chameleon_cache.oversuits[picked], usr)
	update_clothing_icon()	//so our overlays update.

//*******************
//**Chameleon Shoes**
//*******************
/obj/item/clothing/shoes/chameleon
	name = "black shoes"
	icon_state = "black"
	item_state = "black"
	desc = "They're comfy black shoes, with clever cloaking technology built in. It seems to have a small dial on the back of each shoe."
	origin_tech = list(TECH_ILLEGAL = 3)

/obj/item/clothing/shoes/chameleon/verb/change(picked in chameleon_cache.footwear)
	set name = "Change Footwear Appearance"
	set category = "Chameleon Items"
	set src in usr

	if(!ispath(chameleon_cache.footwear[picked]))
		return

	disguise(chameleon_cache.footwear[picked], usr)
	update_clothing_icon()	//so our overlays update.

//**********************
//**Chameleon Backpack**
//**********************
/obj/item/weapon/storage/backpack/chameleon
	name = "backpack"
	icon_state = "backpack"
	item_state = "backpack"
	desc = "A backpack outfitted with cloaking tech. It seems to have a small dial inside, kept away from the storage."
	origin_tech = list(TECH_ILLEGAL = 3)

/obj/item/weapon/storage/backpack/chameleon/verb/change(picked in chameleon_cache.backpacks)
	set name = "Change Backpack Appearance"
	set category = "Chameleon Items"
	set src in usr

	if(!ispath(chameleon_cache.backpacks[picked]))
		return

	disguise(chameleon_cache.backpacks[picked], usr)

	//so our overlays update.
	if (is_mob(src.loc))
		var/mob/M = src.loc
		M.update_inv_back()

//********************
//**Chameleon Gloves**
//********************

/obj/item/clothing/gloves/chameleon
	name = "black gloves"
	icon_state = "black"
	item_state = "bgloves"
	desc = "It looks like a pair of gloves, but it seems to have a small dial inside."
	origin_tech = list(TECH_ILLEGAL = 3)

/obj/item/clothing/gloves/chameleon/verb/change(picked in chameleon_cache.handwear)
	set name = "Change Gloves Appearance"
	set category = "Chameleon Items"
	set src in usr

	if(!ispath(chameleon_cache.handwear[picked]))
		return

	disguise(chameleon_cache.handwear[picked], usr)
	update_clothing_icon()	//so our overlays update.

//******************
//**Chameleon Mask**
//******************

/obj/item/clothing/mask/chameleon
	name = "gas mask"
	icon_state = "fullgas"
	item_state = "gas_alt"
	desc = "It looks like a plain gask mask, but on closer inspection, it seems to have a small dial inside."
	origin_tech = list(TECH_ILLEGAL = 3)

/obj/item/clothing/mask/chameleon/verb/change(picked in chameleon_cache.facewear)
	set name = "Change Mask Appearance"
	set category = "Chameleon Items"
	set src in usr

	if(!ispath(chameleon_cache.facewear[picked]))
		return

	disguise(chameleon_cache.facewear[picked], usr)
	update_clothing_icon()	//so our overlays update.

//*********************
//**Chameleon Glasses**
//*********************

/obj/item/clothing/glasses/chameleon
	name = "Optical Meson Scanner"
	icon_state = "meson"
	item_state = "glasses"
	desc = "It looks like a plain set of mesons, but on closer inspection, it seems to have a small dial inside."
	origin_tech = list(TECH_ILLEGAL = 3)

/obj/item/clothing/glasses/chameleon/verb/change(picked in chameleon_cache.eyegear)
	set name = "Change Glasses Appearance"
	set category = "Chameleon Items"
	set src in usr

	if(!ispath(chameleon_cache.eyegear[picked]))
		return

	disguise(chameleon_cache.eyegear[picked], usr)
	update_clothing_icon()	//so our overlays update.

//*****************
//**Chameleon Gun**
//*****************
/obj/item/weapon/gun/energy/chameleon
	name = "revolver"
	desc = "A hologram projector in the shape of a gun. There is a dial on the side to change the gun's disguise."
	icon_state = "revolver"
	w_class = ITEM_SIZE_SMALL
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2, TECH_ILLEGAL = 8)
	matter = list()

	fire_sound = 'resources/sound/weapons/gunshot/gunshot_pistol.ogg'
	projectile_type = /obj/item/projectile/chameleon
	charge_meter = 0
	charge_cost = 20 //uses next to no power, since it's just holograms
	max_shots = 50

	var/obj/item/projectile/copy_projectile
	var/global/list/gun_choices

/obj/item/weapon/gun/energy/chameleon/New()
	..()

	if(!gun_choices)
		gun_choices = list()
		for(var/gun_type in typesof(/obj/item/weapon/gun/) - src.type)
			var/obj/item/weapon/gun/G = gun_type
			src.gun_choices[initial(G.name)] = gun_type
	return

/obj/item/weapon/gun/energy/chameleon/consume_next_projectile()
	var/obj/item/projectile/P = ..()
	if(P && ispath(copy_projectile))
		P.SetName(initial(copy_projectile.name))
		P.icon = initial(copy_projectile.icon)
		P.icon_state = initial(copy_projectile.icon_state)
		P.pass_flags = initial(copy_projectile.pass_flags)
		P.hitscan = initial(copy_projectile.hitscan)
		P.step_delay = initial(copy_projectile.step_delay)
		P.muzzle_type = initial(copy_projectile.muzzle_type)
		P.tracer_type = initial(copy_projectile.tracer_type)
		P.impact_type = initial(copy_projectile.impact_type)
	return P

/obj/item/weapon/gun/energy/chameleon/disguise(newtype)
	var/obj/item/weapon/gun/copy = ..()
	if(!copy)
		return

	flags_inv = copy.flags_inv
	fire_sound = copy.fire_sound
	fire_sound_text = copy.fire_sound_text

	var/obj/item/weapon/gun/energy/E = copy
	if(istype(E))
		copy_projectile = E.projectile_type
		//charge_meter = E.charge_meter //does not work very well with icon_state changes, ATM
	else
		copy_projectile = null
		//charge_meter = 0

/obj/item/weapon/gun/energy/chameleon/verb/change(picked in gun_choices)
	set name = "Change Gun Appearance"
	set category = "Chameleon Items"
	set src in usr

	if(!ispath(gun_choices[picked]))
		return

	disguise(gun_choices[picked], usr)

	//so our overlays update.
	if (is_mob(src.loc))
		var/mob/M = src.loc
		M.update_inv_r_hand()
		M.update_inv_l_hand()

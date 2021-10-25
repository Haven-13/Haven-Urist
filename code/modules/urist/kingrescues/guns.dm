/obj/item/ammo_casing/musket
	name = "large musket ball"
	desc = "A ball for a long flintlock musket."
	caliber = "balllong"
	projectile_type = /obj/item/projectile/bullet/rifle/musket
	icon = 'resources/icons/urist/king/gunsmith.dmi'
	icon_state = "bullet"
	spent_icon = "bullet-left"

/obj/item/ammo_casing/musket/short
	name = "musket ball"
	desc = "A ball for a short flintlock musket."
	caliber = "ballshort"
	projectile_type = /obj/item/projectile/bullet/rifle/musket/short
	icon_state = "bullets"

/obj/item/ammo_casing/musket/flintlock
	name = "small musket ball"
	desc = "A ball for a flintlock pistol."
	caliber = "ballflintlock"
	projectile_type = /obj/item/projectile/bullet/rifle/musket/flintlock
	icon_state = "bulletf"

//

/obj/item/projectile/bullet/rifle/musket
	icon = 'resources/icons/urist/king/gunsmith.dmi'
	icon_state = "bullet-fire"
	fire_sound = 'resources/sound/weapons/gunshot/gunshot3.ogg'
	damage = 28
	armor_penetration = 12

/obj/item/projectile/bullet/rifle/musket/short
	damage = 20
	armor_penetration = 8

/obj/item/projectile/bullet/rifle/musket/flintlock
	damage = 14
	armor_penetration = 4

//

/obj/item/weapon/gun/projectile/manualcycle/musket
	name = "long musket"
	desc = "It's a long rifle, it fires ball ammo."
	icon = 'resources/icons/urist/king/gunsmith.dmi'
	icon_state = "longrifle"
	item_state = "mosin"
	caliber = "balllong"
//	bulletinsert_sound 	= 'resources/sound/weapons/guns/interact/rifle_load.ogg'
//	casingsound = 'resources/sound/weapons/guns/misc/casingfall1.ogg'
//	pumpsound = 'resources/sound/weapons/boltpump.ogg'
	ammo_type = /obj/item/ammo_casing/musket
	w_class = ITEM_SIZE_NORMAL
	max_shells = 1
	var/datum/effect/effect/system/smoke_spread/bad/smoke

/obj/item/weapon/gun/projectile/manualcycle/musket/handle_post_fire(mob/user, atom/target)
	var/datum/effect/effect/system/smoke_spread/smoke = new /datum/effect/effect/system/smoke_spread()
	smoke.set_up(1,0, src.loc, 0)
	smoke.start()
	..()
	if(chambered)
		chambered.expend()
		process_chambered()

/obj/item/weapon/gun/projectile/manualcycle/musket/short
	name = "short rifle"
	desc = "It's a short rifle, it fires ball ammo."
	icon = 'resources/icons/urist/king/gunsmith.dmi'
	icon_state = "shortrifle"
	item_state = "mosin"
	caliber = "ballshort"
	ammo_type = /obj/item/ammo_casing/musket/short
	w_class = ITEM_SIZE_NORMAL

/obj/item/weapon/gun/projectile/manualcycle/musket/flintlock
	name = "flintlock pistol"
	desc = "It's a flintlock pistol, it fires ball ammo."
	icon = 'resources/icons/urist/king/gunsmith.dmi'
	icon_state = "flintlock"
	item_state = "mosin"
	caliber = "ballflintlock"
	ammo_type = /obj/item/ammo_casing/musket/flintlock
	w_class = ITEM_SIZE_SMALL
	slot_flags = SLOT_BELT
//

/obj/item/weapon/storage/bullet
	name = "musket ball bag"
	desc = "Leather bag for holding all the musket balls you could need."
	icon = 'resources/icons/urist/king/gunsmith.dmi'
	icon_state = "bag"
	slot_flags = SLOT_BELT
	max_storage_space = 200
	max_w_class = ITEM_SIZE_NORMAL
	w_class = ITEM_SIZE_LARGE
	can_hold = list(/obj/item/ammo_casing/musket, /obj/item/ammo_casing/musket/short, /obj/item/ammo_casing/musket/flintlock)
	allow_quick_gather = 1
	allow_quick_empty = 1
	use_to_pickup = 1

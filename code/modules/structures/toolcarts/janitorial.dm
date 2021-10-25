/obj/structure/tool_cart/janitorial
	name = "janitorial cart"
	desc = "The ultimate in janitorial carts! Has space for water, mops, signs, trash bags, and more!"
	icon = 'resources/icons/obj/janitor.dmi'
	icon_state = "cart"

	var/amount_per_transfer_from_this = 5 //shit I dunno, adding this so syringes stop runtime erroring. --NeoFite
	var/signs = 0	//maximum capacity hardcoded below

/obj/structure/tool_cart/janitorial/New()
	. = ..()
	create_reagents(180)
	items = list(
		"mybag" = new /datum/tool_cart_item(
			"Garbage bag",
			"cart_garbage",
			/obj/item/weapon/storage/bag/trash
		),
		"mymop" = new /datum/tool_cart_item(
			"Mop",
			"cart_mop",
			/obj/item/weapon/mop
		),
		"myspray" = new /datum/tool_cart_item(
			"Spray bottle",
			"cart_spray",
			/obj/item/weapon/reagent_containers/spray
		),
		"myreplacer" = new /datum/tool_cart_item(
			"Light replacer",
			"cart_replacer",
			/obj/item/device/lightreplacer
		)
	)
	stacks = list(
		"signs" = new /datum/tool_cart_stack(
			"Signs",
			"cart_sign",
			/obj/item/weapon/caution,
			4
		)
	)

/obj/structure/tool_cart/janitorial/examine(mob/user)
	if(..(user, 1))
		to_chat(user, "[src] \icon[src] contains [reagents.total_volume] unit\s of liquid!")

/obj/structure/tool_cart/janitorial/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/weapon/mop))
		if(I.reagents.total_volume < I.reagents.maximum_volume)	//if it's not completely soaked we assume they want to wet it, otherwise store it
			if(reagents.total_volume < 1)
				to_chat(user, "<span class='warning'>[src] is out of water!</span>")
			else
				reagents.trans_to_obj(I, I.reagents.maximum_volume)
				to_chat(user, "<span class='notice'>You wet [I] in [src].</span>")
				playsound(loc, 'resources/sound/effects/slosh.ogg', 25, 1)
		else
			..()

	else if(..())
		return TRUE

	else if(istype(I, /obj/item/weapon/reagent_containers/glass))
		return // So we do not put them in the trash bag as we mean to fill the mop bucket

	else if(items["mybag"].item)
		items["mybag"].item.attackby(I, user)

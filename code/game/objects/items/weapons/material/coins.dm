/obj/item/weapon/material/coin
	name = "coin"
	icon = 'resources/icons/obj/coin.dmi'
	icon_state = "coin1"
	applies_material_colour = TRUE
	randpixel = 8
	force = 1
	throwforce = 1
	w_class = 1
	slot_flags = SLOT_EARS
	var/string_colour

/obj/item/weapon/material/coin/New()
	icon_state = "coin[rand(1,10)]"
	..()

/obj/item/weapon/material/coin/update_icon()
	if(!isnull(string_colour))
		var/image/I = image(icon = icon, icon_state = "coin_string_overlay")
		I.appearance_flags |= RESET_COLOR
		I.color = string_colour
		overlays += I
	else
		overlays.Cut()

/obj/item/weapon/material/coin/attackby(obj/item/W, mob/user)
	if(is_coil(W) && isnull(string_colour))
		var/obj/item/stack/cable_coil/CC = W
		if(CC.use(1))
			string_colour = CC.color
			to_chat(user, "<span class='notice'>You attach a string to the coin.</span>")
			update_icon()
			return
	else if(is_wirecutter(W) && !isnull(string_colour))
		new /obj/item/stack/cable_coil/single(get_turf(user))
		string_colour = null
		to_chat(user, "<span class='notice'>You detach the string from the coin.</span>")
		update_icon()
	else ..()

/obj/item/weapon/material/coin/attack_self(mob/user)
	user.visible_message("<span class='notice'>\The [user] has thrown \the [src]. It lands on [rand(1, 2) == 1 ? "tails" : "heads"]!</span>")

// Subtypes.
/obj/item/weapon/material/coin/gold
	default_material = "gold"

/obj/item/weapon/material/coin/silver
	default_material = "silver"

/obj/item/weapon/material/coin/diamond
	default_material = "diamond"

/obj/item/weapon/material/coin/iron
	default_material = "iron"

/obj/item/weapon/material/coin/uranium
	default_material = "uranium"

/obj/item/weapon/material/coin/platinum
	default_material = "platinum"

/obj/item/weapon/material/coin/phoron
	default_material = "phoron"

/obj/item/clothing/shoes/black
	name = "black shoes"
	icon_state = "black"
	desc = "A pair of black shoes."

	cold_protection = FEET
	min_cold_protection_temperature = SHOE_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = FEET
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/shoes/brown
	name = "brown shoes"
	desc = "A pair of brown shoes."
	icon_state = "brown"

/obj/item/clothing/shoes/blue
	name = "blue shoes"
	icon_state = "blue"

/obj/item/clothing/shoes/green
	name = "green shoes"
	icon_state = "green"

/obj/item/clothing/shoes/yellow
	name = "yellow shoes"
	icon_state = "yellow"

/obj/item/clothing/shoes/purple
	name = "purple shoes"
	icon_state = "purple"

/obj/item/clothing/shoes/brown
	name = "brown shoes"
	icon_state = "brown"

/obj/item/clothing/shoes/red
	name = "red shoes"
	desc = "Stylish red shoes."
	icon_state = "red"

/obj/item/clothing/shoes/white
	name = "white shoes"
	icon_state = "white"
	permeability_coefficient = 0.01

/obj/item/clothing/shoes/leather
	name = "leather shoes"
	desc = "A sturdy pair of leather shoes."
	icon_state = "leather"

/obj/item/clothing/shoes/rainbow
	name = "rainbow shoes"
	desc = "Very gay shoes."
	icon_state = "rain_bow"

/obj/item/clothing/shoes/orange
	name = "orange shoes"
	icon_state = "orange"
	force = 0 //nerf brig shoe throwing
	throwforce = 0
	desc = "A pair of flimsy, cheap shoes. The soles have been made of a soft rubber."
	var/obj/item/weapon/handcuffs/chained = null

/obj/item/clothing/shoes/orange/proc/attach_cuffs(obj/item/weapon/handcuffs/cuffs, mob/user as mob)
	if (src.chained) return

	if(!user.unequip_item())
		return
	cuffs.loc = src
	src.chained = cuffs
	src.slowdown_per_slot[slot_shoes] += 15
	src.icon_state = "orange1"

/obj/item/clothing/shoes/orange/proc/remove_cuffs(mob/user as mob)
	if (!src.chained) return

	user.put_in_hands(src.chained)
	src.chained.add_fingerprint(user)

	src.slowdown_per_slot[slot_shoes] -= 15
	src.icon_state = "orange"
	src.chained = null

/obj/item/clothing/shoes/orange/attack_self(mob/user as mob)
	..()
	remove_cuffs(user)

/obj/item/clothing/shoes/orange/attackby(H as obj, mob/user as mob)
	..()
	if (istype(H, /obj/item/weapon/handcuffs))
		attach_cuffs(H, user)

/obj/item/clothing/shoes/flats
	name = "flats"
	desc = "Sleek flats."
	icon_state = "flatswhite"

/obj/item/clothing/shoes/hightops
	name = "white high tops"
	desc = "A pair of shoes that extends past the ankle. Based on a centuries-old, timeless design."
	icon_state = "whitehi"

/obj/item/clothing/shoes/hightops/red
	name = "red high tops"
	icon_state = "redhi"

/obj/item/clothing/shoes/hightops/brown
	name = "brown high tops"
	icon_state = "brownhi"

/obj/item/clothing/shoes/hightops/black
	name = "black high tops"
	icon_state = "blackhi"

/obj/item/clothing/shoes/hightops/orange
	name = "orange high tops"
	icon_state = "orangehi"

/obj/item/clothing/shoes/hightops/blue
	name = "blue high tops"
	icon_state = "bluehi"

/obj/item/clothing/shoes/hightops/green
	name = "green high tops"
	icon_state = "greenhi"

/obj/item/clothing/shoes/hightops/purple
	name = "purple high tops"
	icon_state = "purplehi"

/obj/item/clothing/shoes/hightops/yellow
	name = "yellow high tops"
	icon_state = "yellowhi"
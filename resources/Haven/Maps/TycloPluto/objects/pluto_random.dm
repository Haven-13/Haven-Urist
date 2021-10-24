/obj/random/ore
	name = "random ore"
	desc = "This is a random ore."
	icon = 'icons/obj/clothing/ties.dmi'
	icon_state = "horribletie"

/obj/random/ore/spawn_choices()
	return list(
		/obj/item/weapon/ore/uranium,
		/obj/item/weapon/ore/gold,
		/obj/item/weapon/ore/silver,
		/obj/item/weapon/ore/slag,
		/obj/item/weapon/ore/phoron)

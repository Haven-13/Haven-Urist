// Rod for railguns. Slightly less nasty than the sniper round.
/obj/item/projectile/bullet/magnetic
	name = "rod"
	icon_state = "rod"
	damage = 55
	penetrating = 5
	armor_penetration = 70
	penetration_modifier = 1.1
	fire_sound = 'resources/sound/weapons/railgun.ogg'

/obj/item/projectile/bullet/magnetic/slug
	name = "slug"
	icon_state = "gauss_silenced"
	stun = 1
	damage = 75
	armor_penetration = 90

/obj/item/projectile/bullet/magnetic/flechette
	name = "flechette"
	icon_state = "flechette"
	damage = 20
	armor_penetration = 100
	fire_sound = 'resources/sound/weapons/rapidslice.ogg'

/obj/effect/urist/projectile_landmark
	icon_state = "x3"
	icon = 'resources/icons/mob/screen1.dmi'
	invisibility = 101
	anchored = 1
	var/shipid = null
	var/obj/effect/overmap/ship/combat/mothership = null

/obj/effect/urist/projectile_landmark/proc/Fire()
	return

/obj/effect/urist/projectile_landmark/ship

/obj/effect/urist/projectile_landmark/ship/New()
	GLOB.ship_projectile_landmarks += src
	. = ..()

/obj/effect/urist/projectile_landmark/ship/Fire(obj/projectile_type = null)
	var/obj/item/projectile/P = new projectile_type

	var/target_x = rand(mothership.target_x_bounds[1],mothership.target_x_bounds[2])
	var/target_y = rand(mothership.target_y_bounds[1],mothership.target_y_bounds[2])
	//message_admins("An enemy ship has fired a [P.name] at the ship targeting <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[target_x];Y=[target_y];Z=[src.z]'>(JMP)</a>.", 1)

	P.loc = (get_turf(src.loc))

	var/turf/target = locate(target_x, target_y, src.z)

	P.launch(target)

/obj/effect/urist/projectile_landmark/target

/obj/effect/urist/projectile_landmark/target/New()
	GLOB.target_projectile_landmarks += src
	. = ..()

/obj/effect/urist/projectile_landmark/target/Fire(projectile_type)
	var/obj/item/projectile/P = new projectile_type

	var/target_x = 100 //set up values for enemy ships
	var/target_y = 100
	var/turf/T = get_turf(src)

	P.loc = (get_turf(src.loc))
	P.redirect(target_x, target_y, T)

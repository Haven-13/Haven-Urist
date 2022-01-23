// Landmark-based marker intended to be more extendable
// than using radio beacons that are potentially exploitable
// Currently pretty bare because I am tired of sitting on
// this PR for nearly a month by now...
// - Irra

/obj/effect/urist/boarding_hint
	icon_state = "x3"
	icon = 'resources/icons/mob/screen1.dmi'
	invisibility = 101
	var/shipid
	var/obj/effect/overmap/ship/combat/mothership = null

/obj/effect/urist/boarding_hint/New()
	GLOB.boarding_hint_landmarks += src
	. = ..()

/obj/effect/urist/boarding_hint/Destroy()
	GLOB.boarding_hint_landmarks -= src
	. = ..()

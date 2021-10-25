var/list/star_prefixes = list(
	"Alpha",
	"Beta",
	"Gamma",
	"Zeta",
	"Phi",
	"Einstein",
	"Curie",
	"Tycho",
	"Schwartzchild",
	"Glesier",
	"Kaifu",
	"Ogden",
	"Abetti",
	"Akiyama",
	"Bhaskara",
	"Bolton",
	"Copernicus",
	"da Vinci",
	"de Ball",
	"Hell",
	"bar Hiyya",
	"Herschel",
	"Wing",
	"Wolf"
)

var/list/star_classes = list(
		"O" = "#94d4ff",
		"B" = "#bee5ff",
		"A" = "#eaf7ff",
		"F" = "#ffffff",
		"G" = "#ffebd7",
		"K" = "#ffec7e",
		"M" = "#ff8b48",
		"L" = "#ff4b33",
		"T" = "#ff0000",

		"D" = "#ffffff", // white dwarves
		"W" = "#94d4ff"  // wolf-rayet stars
	)

/obj/effect/overmap_static
	name = "event"
	icon = 'resources/icons/obj/overmap.dmi'
	icon_state = "event"
	opacity = 1
	plane = EFFECTS_PLANE

/obj/effect/overmap_static/star
	name = "Star"
	icon_state = "star"
	bound_height = 32
	bound_width = 32
	anchored = TRUE

	appearance_flags = PIXEL_SCALE

/obj/effect/overmap_static/star/New()
	. = ..()
	var/class = pick(star_classes)
	var/heat = rand(0,9)
	color = star_classes[class]
	name = "&laquo;[pick(star_prefixes)]-[rand(10, 99)]-[class][heat]-[rand(100,999)]&raquo;"
	desc = "A star of the spectral type [class][heat]."
	transform = transform.Scale(2)
	pixel_x = 1
	pixel_y = -1

	add_overlay(list(mutable_appearance(
		icon,
		icon_state,
		plane = get_float_plane(EMISSIVE_PLANE)
	)))

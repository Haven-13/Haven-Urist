
// Taken from code/game/machinery/doors/airlock.dm for prosperity
/*
/obj/machinery/door/airlock/autoname

/obj/machinery/door/airlock/autoname/New()
	var/area/A = get_area(src)
	name = A.name
	..()
*/

# define COLOR_SPACE_CADET "#152050"
# define COLOR_ROMAN_SILVER "#7e8495"

# define COLOR_MEDICAL_GREEN "#448044"

/*
 Colour list:
 Command:
	- COLOR_SPACE_CADET (#152050)
	- COLOR_ROMAN_SILVER (#7e8495)

 Command (Gunnery):
	- COLOR_SPACE_CADET (#152050)
	- COLOR_NT_RED

 Security:
	- COLOR_NT_RED
	- COLOR_MAROON

 Medical:
	- COLOR_GREEN
	- COLOR_WHITE

 Medical (inverted):
	- COLOR_WHITE
	- COLOR_GREEN

 Engineering:
	- COLOR_AMBER
	- COLOR_ORANGE

 Engineering (Engine/Inverted)
	- COLOR_ORANGE
	- COLOR_AMBER

 Engineering (Atmos)
	- COLOR_AMBER
	- COLOR_CYAN

 Cargo:
	- COLOR_PALE_ORANGE
	- COLOR_BEASTY_BROWN

	Maintenance:
	 - COLOR_AMBER
	 - COLOR_DARK_GREY

	Maintenance (Substation):
	 - COLOR_DARK_GREY
	 - COLOR_AMBER

	Maintenance (Firefighter closet):
	 - COLOR_DARK_GREY
	 - COLOR_NT_RED

	Maintenance (Thruster)
	 -

*/

// I hate myself sometimes
/*
 * Block macros to define instance presets for airlocks
 * please make sure that each line that is not the last
 * one ends with \, else DM will refuse to compile it.
 */
#define CREATE_DOOR_VARIETIES(base)\
base/command {\
	door_color = COLOR_COMMAND_BLUE;\
	stripe_color = COLOR_WHITE;\
}\
base/gunnery {\
	door_color = COLOR_COMMAND_BLUE;\
	stripe_color = COLOR_NT_RED;\
}\
base/security {\
	door_color = COLOR_ROMAN_SILVER;\
	stripe_color = COLOR_MAROON;\
}\
base/medical {\
	door_color = COLOR_MEDICAL_GREEN;\
	stripe_color = COLOR_WHITE;\
}\
base/medical/inverted {\
	door_color = COLOR_WHITE;\
	stripe_color = COLOR_MEDICAL_GREEN;\
}\
base/engineering {\
	door_color = COLOR_AMBER;\
	stripe_color = COLOR_NT_RED;\
}\
base/engineering/inverted {\
	door_color = COLOR_NT_RED;\
	stripe_color = COLOR_AMBER;\
}\
base/engineering/atmos {\
	stripe_color = COLOR_CYAN;\
}\
base/cargo {\
	door_color = COLOR_PALE_ORANGE;\
	stripe_color = COLOR_BEASTY_BROWN;\
}
// end CREATE_DOOR_VARIETIES

#define CREATE_MAINT_DOOR_VARIETIES(base) \
base/maintenance {\
	door_color = COLOR_AMBER;\
	stripe_color = COLOR_DARK_GRAY;\
}\
base/maintenance/substation {\
	door_color = COLOR_DARK_GRAY;\
	stripe_color = COLOR_AMBER;\
}\
base/maintenance/fire {\
	door_color = COLOR_DARK_GRAY;\
	stripe_color = COLOR_NT_RED;\
}\
base/maintenance/air {\
	door_color = COLOR_DARK_GRAY;\
	stripe_color = COLOR_CYAN;\
}
// end CREATE_MAINT_DOOR_VARIETIES

// Define the autoname types first
// PS: Another TODO here; port this back to the base code
// But who fucking cares about Bay and Baycode holy shit
/obj/machinery/door/airlock/autoname/glass
	glass = TRUE
	opacity = FALSE

/obj/machinery/door/airlock/multi_tile/autoname
/obj/machinery/door/airlock/multi_tile/autoname/glass
	glass = TRUE
	opacity = FALSE

/obj/machinery/door/airlock/multi_tile/autoname/New()
	var/area/A = get_area(src)
	name = A.name
	..()

// Define all the door presets
CREATE_DOOR_VARIETIES(/obj/machinery/door/airlock/autoname/pluto)
CREATE_DOOR_VARIETIES(/obj/machinery/door/airlock/autoname/glass/pluto)
CREATE_DOOR_VARIETIES(/obj/machinery/door/airlock/multi_tile/autoname/pluto)
CREATE_DOOR_VARIETIES(/obj/machinery/door/airlock/multi_tile/autoname/glass/pluto)

CREATE_MAINT_DOOR_VARIETIES(/obj/machinery/door/airlock/autoname/pluto)
CREATE_MAINT_DOOR_VARIETIES(/obj/machinery/door/airlock/autoname/glass/pluto)
CREATE_MAINT_DOOR_VARIETIES(/obj/machinery/door/airlock/multi_tile/autoname/pluto)

// Clean up - undefine macros, because we don't need them anymore
#undef CREATE_DOOR_VARIETIES
#undef CREATE_MAINT_DOOR_VARIETIES

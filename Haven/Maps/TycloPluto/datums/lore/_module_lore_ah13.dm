
// Include guard
#ifndef MODULE_LORE_AH13_INCLUDED
#define MODULE_LORE_AH13_INCLUDED

/*
	Because I don't have the resources or the time to go make a more sane rewrite
	of the system used by Baycode. Specially not one that relies on macros as
	a total solution to everything.

	Here's an explanation of how Bay's system serves as evidence of how Bay is
	completely stripped of any sign of intelligence and rational thinking.
	Fuck you, Bay, with a five-grit sandpaper cactus.

	Either way, this is how the sytem works:

	1. Define name macros with human-readable string values
	2. Use the macros inside /decl/culture_info declarations and definitions
	3. Put them inside species datums' available_cultural_info list of associated
		lists with corresponding tags;
		- Cultures                   -> TAG_CULTURE
		- Factions | nations         -> TAG_FACTION
		- Locations | homeworlds     -> TAG_HOMEWORLD
	4. The game looks up those strings inserted from the macros and return it

	And you're done. Enjoy your technical debt!

	Also, this one file should be marked as included in either the .dme or from
	inside the map's top-level .dm, you decide. In the original, it was included
	from the top-level .dm.
*/

// Set new default values
#include "overrides_culture_info.dm"

// Define macros
#include "strings_names.dm"

// Define culture
#include "cultures/cultures_common.dm"
#include "cultures/cultures_human.dm"
#include "cultures/cultures_skrell.dm"
#include "cultures/cultures_teshari.dm"
#include "cultures/cultures_unathi.dm"
#include "cultures/cultures_vox.dm"

// Define factions
#include "factions/factions_common.dm"
#include "factions/factions_human.dm"
#include "factions/factions_machine.dm"
#include "factions/factions_skrell.dm"
#include "factions/factions_teshari.dm"
#include "factions/factions_unathi.dm"
#include "factions/factions_vox.dm"

// Define locations
#include "locations/locations_human.dm"
#include "locations/locations_skrell.dm"
#include "locations/locations_teshari.dm"
#include "locations/locations_unathi.dm"
#include "locations/locations_vox.dm"

// Override with new defines
#include "overrides_species.dm"

// Fallback
/datum/map/tyclo_pluto
	available_cultural_info = list(
		TAG_HOMEWORLD = list(
			LOCATION_OTHER
		),
		TAG_FACTION = list(
			FACTION_IND,
			FACTION_OTHER
		),
		TAG_CULTURE = list(
			CULTURE_OTHER_AH13
		)
	)

	default_cultural_info = list(
		TAG_HOMEWORLD = HOME_SYSTEM_OTHER,
		TAG_FACTION =	 FACTION_IND,
		TAG_CULTURE =	 CULTURE_OTHER_AH13
	)

#endif


/datum/map/away_sites_testing
	name = "Away Sites Testing"
	full_name = "Away Sites Testing Land"
	path = "away_sites_testing"

	lobby_icon = 'resources/maps/example/example_lobby.dmi'

	station_levels = list()
	contact_levels = list()
	player_levels = list()

	allowed_spawns = list()

	use_overmap = TRUE
	overmap_size = 10

/datum/map/away_sites_testing/build_away_sites()
	var/list/unsorted_sites = list_values(SSmapping.away_sites_templates)
	var/list/sorted_sites = sortTim(unsorted_sites, GLOBAL_PROC_REF(cmp_sort_templates_tallest_to_shortest))
	for (var/datum/map_template/ruin/away_site/A in sorted_sites)
		testing("Spawning [A]")
		A.load_new_z(FALSE)

/proc/cmp_sort_templates_tallest_to_shortest(datum/map_template/a, datum/map_template/b)
	return b.tallness - a.tallness

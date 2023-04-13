#if !defined(USING_MAP_DATUM)
	#include "away_sites_testing_lobby.dm"
	#include "away_sites_testing_unit_testing.dm"

	#include "blank.dmm"

	#include "../away/empty.dmm"
	#include "../away/bearcat/bearcat.dm"
	#include "../away/derelict/derelict.dm"
	#include "../away/destroyed_colony/destroyed_colony.dm"
	#include "../away/glloyd_jungle/glloyd_jungle.dm"
	#include "../away/lost_supply_base/lost_supply_base.dm"
	#include "../away/mining/mining.dm"
	#include "../away/noctis/noctis.dm"
	#include "../away/slavers/slavers_base.dm"

	#include "../away/stations/pirate/pirate_station.dm"

	#define USING_MAP_DATUM /datum/map/away_sites_testing

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Away Sites Testing

#endif

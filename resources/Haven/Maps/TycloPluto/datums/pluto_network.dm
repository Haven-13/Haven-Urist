var/const/NETWORK_FIRST_DECK                    = "First Deck" //bottom
var/const/NETWORK_SECOND_DECK                   = "Second Deck" //central
var/const/NETWORK_THIRD_DECK                    = "Third Deck" //top
var/const/NETWORK_COMMAND                       = "Command"
var/const/NETWORK_CARGO                         = "Cargo"
var/const/NETWORK_EXPLORATION_SHUTTLE_PLUTO     = "Styx (Shuttle)"
var/const/NETWORK_COURIER_SHUTTLE_PLUTO         = "Eris (Shuttle)"
var/const/NETWORK_PRISON                        = "Prison"

/datum/map/tyclo_pluto/get_network_access(var/network)
	if(network == NETWORK_COMMAND)
		return access_heads
	return ..()

/datum/map/tyclo_pluto
	station_networks = list(
		NETWORK_FIRST_DECK,
		NETWORK_SECOND_DECK,
		NETWORK_THIRD_DECK,
		NETWORK_COMMAND,
		NETWORK_ENGINEERING,
		NETWORK_MEDICAL,
		NETWORK_CARGO,
		NETWORK_EXPLORATION_SHUTTLE_PLUTO,
		NETWORK_COURIER_SHUTTLE_PLUTO,
		NETWORK_MINE,
		NETWORK_ROBOTS,
		NETWORK_SECURITY,
		NETWORK_PRISON,
		NETWORK_ALARM_ATMOS,
		NETWORK_ALARM_CAMERA,
		NETWORK_ALARM_FIRE,
		NETWORK_ALARM_MOTION,
		NETWORK_ALARM_POWER,
		NETWORK_THUNDER
	)

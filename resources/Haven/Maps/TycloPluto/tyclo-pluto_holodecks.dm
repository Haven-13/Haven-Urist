/datum/map/tyclo_pluto

	holodeck_programs = list(
		"beach sim"         = new/datum/holodeck_program(/area/holodeck/source_beach, list()),
		"boxingcourt"       = new/datum/holodeck_program(/area/holodeck/source_boxingcourt, list('resources/sound/music/THUNDERDOME.ogg')),
		"basketball"        = new/datum/holodeck_program(/area/holodeck/source_basketball, list('resources/sound/music/THUNDERDOME.ogg')),

		"turnoff"           = new/datum/holodeck_program(/area/holodeck/source_plating, list())
	)

	holodeck_supported_programs = list(
		"PlutoMainPrograms" = list(
			"Beach Simulation"   = "beach sim",
			"Basketball Court"   = "basketball",
			"Boxing Ring"        = "boxingcourt"
		)
	)

	holodeck_restricted_programs = list(

	)

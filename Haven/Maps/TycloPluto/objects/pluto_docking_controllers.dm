/obj/machinery/embedded_controller/radio/airlock/docking_port/pluto
	docking_program_type = /datum/computer/file/embedded_program/docking/airlock/pluto

//tell the docking port to start getting ready for undocking - e.g. close those doors.
/datum/computer/file/embedded_program/docking/airlock/pluto/prepare_for_undocking()
	..()
	airlock_program.begin_cycle_out()

//are we ready for undocking?
/datum/computer/file/embedded_program/docking/airlock/pluto/ready_for_undocking()
	return ..() && airlock_program.done_cycling()

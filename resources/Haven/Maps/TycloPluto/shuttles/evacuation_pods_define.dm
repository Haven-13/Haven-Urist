/*	*
	* Abstract base for escape pods
	*
	*/

/datum/shuttle/autodock/ferry/escape_pod/numbered
	category = /datum/shuttle/autodock/ferry/escape_pod/numbered
	sound_takeoff = 'resources/sound/effects/rocket.ogg'
	sound_landing = 'resources/sound/effects/rocket_backwards.ogg'
	var/number

	warmup_time = 10

/datum/shuttle/autodock/ferry/escape_pod/numbered/New()
	name = "Escape Pod [number]"
	dock_target = "escape_pod_[number]"
	arming_controller = "escape_pod_[number]_berth"
	waypoint_station = "escape_pod_[number]_start"
	landmark_transition = "escape_pod_[number]_internim"
	waypoint_offsite = "escape_pod_[number]_out"
	..()

/*	*
	* Escape pod landmarks
	*
	*/

/obj/effect/shuttle_landmark/escape_pod
	var/number

/obj/effect/shuttle_landmark/escape_pod/start
	name = "Docked"

/obj/effect/shuttle_landmark/escape_pod/start/New()
	landmark_tag = "escape_pod_[number]_start"
	docking_controller = "escape_pod_[number]_berth"
	..()

/obj/effect/shuttle_landmark/escape_pod/transit
	name = "In transit"

/obj/effect/shuttle_landmark/escape_pod/transit/New()
	landmark_tag = "escape_pod_[number]_internim"
	..()

/obj/effect/shuttle_landmark/escape_pod/out
	name = "Escaped"

/obj/effect/shuttle_landmark/escape_pod/out/New()
	landmark_tag = "escape_pod_[number]_out"
	..()

/*	*
	* Escape pod defines
	*
	*/

#define DEFINE_ESCAPE_POD(N, area_type) \
/datum/shuttle/autodock/ferry/escape_pod/numbered/pod_##N { \
	shuttle_area = area_type##N; \
	number = N; \
} \
/obj/effect/shuttle_landmark/escape_pod/start/pod_##N { \
	number = N; \
	base_turf = /turf/space; \
} \
/obj/effect/shuttle_landmark/escape_pod/out/pod_##N { \
	number = N; \
} \
/obj/effect/shuttle_landmark/escape_pod/transit/pod_##N { \
	number = N; \
} \

DEFINE_ESCAPE_POD(1, /area/pluto/lifepod/bottom)
DEFINE_ESCAPE_POD(2, /area/pluto/lifepod/bottom)
DEFINE_ESCAPE_POD(3, /area/pluto/lifepod/bottom)
DEFINE_ESCAPE_POD(4, /area/pluto/lifepod/bottom)
DEFINE_ESCAPE_POD(5, /area/pluto/lifepod/bottom)

#undef DEFINE_ESCAPE_POD

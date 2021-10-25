var/image/assigned = image('resources/icons/Testing/Zone.dmi', icon_state = "assigned")
var/image/created = image('resources/icons/Testing/Zone.dmi', icon_state = "created")
var/image/merged = image('resources/icons/Testing/Zone.dmi', icon_state = "merged")
var/image/invalid_zone = image('resources/icons/Testing/Zone.dmi', icon_state = "invalid")
var/image/air_blocked = image('resources/icons/Testing/Zone.dmi', icon_state = "block")
var/image/zone_blocked = image('resources/icons/Testing/Zone.dmi', icon_state = "zoneblock")
var/image/blocked = image('resources/icons/Testing/Zone.dmi', icon_state = "fullblock")
var/image/mark = image('resources/icons/Testing/Zone.dmi', icon_state = "mark")

/connection_edge/var/dbg_out = 0

/turf/var/tmp/dbg_img
/turf/proc/dbg(image/img, d = 0)
	if(d > 0) img.dir = d
	overlays -= dbg_img
	overlays += img
	dbg_img = img

/proc/soft_assert(thing,fail)
	if(!thing) message_admins(fail)

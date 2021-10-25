/obj/structure/tool_cart/engineering //icons http://puu.sh/cHtzk/dc132f1aa6.dmi
	name = "engineering cart"
	desc = "A cart for storing engineering items."
	icon = 'resources/icons/urist/objects/engicart.dmi'
	icon_state = "cart"

/obj/structure/tool_cart/engineering/New()
	. = ..()
	items = list(
		"myglass" = new /datum/tool_cart_item(
			"Glass sheets",
			"cart_glass",
			/obj/item/stack/material/glass
		),
		"mymetal" = new /datum/tool_cart_item(
			"Steel sheets",
			"cart_metal",
			/obj/item/stack/material/steel
		),
		"myplasteel" = new /datum/tool_cart_item(
			"Plasteel sheets",
			"cart_plasteel",
			/obj/item/stack/material/plasteel
		),
		"mytorch" = new /datum/tool_cart_item(
			"Torch",
			"cart_flashlight",
			/obj/item/device/flashlight
		),
		"mybluetoolbox" = new /datum/tool_cart_item(
			"Toolbox (blue)",
			"cart_bluetoolbox",
			/obj/item/weapon/storage/toolbox/mechanical
		),
		"myredtoolbox" = new /datum/tool_cart_item(
			"Toolbox (red)",
			"cart_redtoolbox",
			/obj/item/weapon/storage/toolbox/emergency
		),
		"myyellowtoolbox" = new /datum/tool_cart_item(
			"Toolbox (yellow)",
			"cart_yellowtoolbox",
			/obj/item/weapon/storage/toolbox/electrical
		),
		"myengitape" = new /datum/tool_cart_item(
			"Engineering tape",
			"cart_engitape",
			/obj/item/taperoll/engineering
		),
		"myinflate" = new /datum/tool_cart_item(
			"Inflatables",
			"cart_inflate",
			/obj/item/weapon/storage/briefcase/inflatable
		)
	)

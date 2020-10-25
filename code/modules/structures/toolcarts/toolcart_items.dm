/datum/tool_cart_item
	var/label
	var/overlay_name
	var/atom/item
	var/my_type

/datum/tool_cart_item/New(label, overlay_name, type)
	src.label = label
	src.overlay_name = overlay_name
	src.my_type = type

/datum/tool_cart_stack
	var/label
	var/overlay_name
	var/my_type
	var/amount
	var/maxAmount

/datum/tool_cart_stack/New(label, overlay_name, type, max)
	src.label = label
	src.overlay_name = overlay_name
	src.my_type = type
	src.maxAmount = max

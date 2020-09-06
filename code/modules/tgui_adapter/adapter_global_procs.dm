/proc/ui_default_state()
	return GLOB.tgui_default_state

/proc/ui_physical_state()
	return GLOB.tgui_physical_state

/proc/ui_inventory_state()
	return GLOB.tgui_inventory_state

/proc/ui_deep_inventory_state()
	return GLOB.tgui_deep_inventory_state

/proc/ui_self_state()
	return GLOB.tgui_self_state

/proc/ui_hands_state()
	return GLOB.tgui_hands_state

/proc/ui_interactive_state()
	return GLOB.tgui_inventory_state

/proc/ui_contained_state()
	return GLOB.tgui_contained_state

/proc/ui_conscious_state()
	return GLOB.tgui_conscious_state

/proc/ui_z_state()
	return GLOB.tgui_z_state

/proc/ui_admin_state()
	return GLOB.tgui_admin_state

/proc/CanInteractWith(datum/user, datum/target, state)
	return (target.CanUseTopic(user, state) == STATUS_INTERACTIVE)

/proc/CanPhysicallyInteractWith(user, target)
	return CanInteractWith(user, target, ui_physical_state())

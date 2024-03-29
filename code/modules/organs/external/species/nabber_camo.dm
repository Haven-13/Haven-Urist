/obj/item/organ/external/groin/nabber
	name = "abdomen"
	icon_position = UNDER
	encased = "carapace"
	action_button_name = "Toggle Active Camo"

/obj/item/organ/external/groin/nabber/refresh_action_button()
	. = ..()
	if(.)
		action.button_icon_state = "nabber-cloak-[owner && owner.is_cloaked_by(species) ? 1 : 0]"
		if(action.button) action.button.UpdateIcon()

/obj/item/organ/external/groin/nabber/attack_self(mob/user)
	. = ..()
	if(.)
		if(owner.is_cloaked_by(species))
			owner.remove_cloaking_source(species)
		else
			owner.add_cloaking_source(species)
			owner.apply_effect(2, DAMAGE_TYPE_STUN, 0)
		refresh_action_button()

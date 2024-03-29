/*
Single Use Emergency Pouches
 */

/obj/item/weapon/storage/med_pouch
	name = "emergency medical pouch"
	desc = "For use in emergency situations only."
	icon = 'resources/icons/obj/med_pouch.dmi'
	storage_slots = 8
	w_class = ITEM_SIZE_SMALL
	max_w_class = ITEM_SIZE_TINY

	var/base_icon = "white"
	var/injury_type = "generic"
	var/opened = FALSE

	var/instructions = {"
	1) Tear open the emergency medical pack using the easy open tab at the top.\n\
	\t2) Carefully remove all items from the pouch and discard the pouch.\n\
	\t3) Apply all autoinjectors to the injured party.\n\
	\t4) Use bandages to stop bleeding if required.\n\
	\t5) Force the injured party to swallow all pills.\n\
	\t6) Use ointment on any burns if required\n\
	\t7) Contact the medical team with your location.
	8) Stay in place once they respond.\
		"}

/obj/item/weapon/storage/med_pouch/Initialize()
	. = ..()
	name = "emergency [injury_type] pouch"
	for(var/obj/item/weapon/reagent_containers/pill/P in contents)
		P.icon_state = base_icon
	for(var/obj/item/weapon/reagent_containers/hypospray/autoinjector/pouch_auto/A in contents)
		A.icon_colour = base_icon
		A.update_icon()

/obj/item/weapon/storage/med_pouch/examine()
	. = ..()
	to_chat(usr, "<A href='?src=[REF(src)];show_info=1'>Please read instructions before use.</A>")

/obj/item/weapon/storage/med_pouch/CanUseTopic()
	return UI_INTERACTIVE

/obj/item/weapon/storage/med_pouch/OnTopic(user, list/href_list)
	if(href_list["show_info"])
		to_chat(user, instructions)
		return FALSE

/obj/item/weapon/storage/med_pouch/update_icon()
	if(opened)
		icon_state = base_icon + "_t"
	else
		icon_state = base_icon

/obj/item/weapon/storage/med_pouch/proc/break_seal(mob/user as mob)
	if(!opened)
		user.visible_message("<span class='notice'>\The [user] tears open [src], breaking the vacuum seal!</span>", "<span class='notice'>You tear open [src], breaking the vacuum seal!</span>")
		opened = 1
		update_icon()

/obj/item/weapon/storage/med_pouch/open(mob/user as mob)
	if(opened)
		. = ..()
	else
		break_seal(user)
		. = ..()

/obj/item/weapon/storage/med_pouch/trauma
	name = "trauma pouch"
	base_icon = "red"
	injury_type = "trauma"

	startswith = list(
	/obj/item/weapon/reagent_containers/hypospray/autoinjector/pouch_auto/inaprovaline,
	/obj/item/weapon/reagent_containers/hypospray/autoinjector/pouch_auto/deletrathol,
	/obj/item/weapon/reagent_containers/pill/pouch_pill/inaprovaline,
	/obj/item/weapon/reagent_containers/pill/pouch_pill/bicaridine,
	/obj/item/stack/medical/bruise_pack/med_pouch = 2,
		)
	instructions = {"
	1) Tear open the emergency medical pack using the easy open tab at the top.\n\
	\t2) Carefully remove all items from the pouch and discard the pouch.\n\
	\t3) Apply all autoinjectors to the injured party.\n\
	\t4) Use bandages to stop bleeding if required.\n\
	\t5) Force the injured party to swallow all pills.\n\
	\t6) Contact the medical team with your location.
	7) Stay in place once they respond.\
		"}

/obj/item/weapon/storage/med_pouch/burn
	name = "burn pouch"
	base_icon = "orange"
	injury_type = "burn"

	startswith = list(
	/obj/item/weapon/reagent_containers/hypospray/autoinjector/pouch_auto/nanoblood,
	/obj/item/weapon/reagent_containers/hypospray/autoinjector/pouch_auto/deletrathol,
	/obj/item/weapon/reagent_containers/hypospray/autoinjector/pouch_auto/adrenaline,
	/obj/item/weapon/reagent_containers/pill/pouch_pill/paracetamol,
	/obj/item/stack/medical/ointment/med_pouch = 2,
		)
	instructions = {"
	1) Tear open the emergency medical pack using the easy open tab at the top.\n\
	\t2) Carefully remove all items from the pouch and discard the pouch.\n\
	\t3) Apply the emergency deletrathol autoinjector to the injured party.\n\
	\t4) Apply all remaining autoinjectors to the injured party.\n\
	\t5) Force the injured party to swallow all pills.\n\
	\t6) Use ointment on any burns if required\n\
	\t7) Contact the medical team with your location.
	8) Stay in place once they respond.\
		"}

/obj/item/weapon/storage/med_pouch/oxyloss
	name = "low oxygen pouch"
	base_icon = "blue"
	injury_type = "low oxygen"

	startswith = list(
	/obj/item/weapon/reagent_containers/hypospray/autoinjector/pouch_auto/inaprovaline,
	/obj/item/weapon/reagent_containers/hypospray/autoinjector/pouch_auto/dexalin,
	/obj/item/weapon/reagent_containers/hypospray/autoinjector/pouch_auto/adrenaline,
	/obj/item/weapon/reagent_containers/pill/pouch_pill/inaprovaline,
	/obj/item/weapon/reagent_containers/pill/pouch_pill/dexalin,
		)
	instructions = {"
	1) Tear open the emergency medical pack using the easy open tab at the top.\n\
	\t2) Carefully remove all items from the pouch and discard the pouch.\n\
	\t3) Apply all autoinjectors to the injured party.\n\
	\t4) Force the injured party to swallow all pills.\n\
	\t5) Contact the medical team with your location.\n\
	\t6) Find a source of oxygen if possible.\n\
	\t7) Update the medical team with your new location.\n\
	8) Stay in place once they respond.\
		"}

/obj/item/weapon/storage/med_pouch/toxin
	name = "toxin pouch"
	base_icon = "green"
	injury_type = "toxin"

	startswith = list(
	/obj/item/weapon/reagent_containers/hypospray/autoinjector/pouch_auto/dylovene,
	/obj/item/weapon/reagent_containers/pill/pouch_pill/dylovene,
	/obj/item/weapon/reagent_containers/pill/pouch_pill/peridaxon,
		)
	instructions = {"
	1) Tear open the emergency medical pack using the easy open tab at the top.\n\
	\t2) Carefully remove all items from the pouch and discard the pouch.\n\
	\t3) Apply all autoinjectors to the injured party.\n\
	\t4) Force the injured party to swallow all pills.\n\
	\t5) Contact the medical team with your location.
	6) Stay in place once they respond.\
		"}

/obj/item/weapon/storage/med_pouch/radiation
	name = "radiation pouch"
	base_icon = "yellow"
	injury_type = "radiation"

	startswith = list(
	/obj/item/weapon/reagent_containers/hypospray/autoinjector/antirad,
	/obj/item/weapon/reagent_containers/pill/pouch_pill/dylovene,
		)
	instructions = {"
	1) Tear open the emergency medical pack using the easy open tab at the top.\n\
	\t2) Carefully remove all items from the pouch and discard the pouch.\n\
	\t3) Apply all autoinjectors to the injured party.\n\
	\t4) Force the injured party to swallow all pills.\n\
	\t5) Contact the medical team with your location.
	6) Stay in place once they respond.\
		"}

/obj/item/weapon/reagent_containers/pill/pouch_pill
	name = "emergency pill"
	desc = "An emergency pill from an emergency medical pouch"
	var/datum/reagent/chem_type
	var/chem_amount = 15

/obj/item/weapon/reagent_containers/pill/pouch_pill/inaprovaline
	chem_type = /datum/reagent/inaprovaline

/obj/item/weapon/reagent_containers/pill/pouch_pill/dylovene
	chem_type = /datum/reagent/dylovene

/obj/item/weapon/reagent_containers/pill/pouch_pill/dexalin
	chem_type = /datum/reagent/dexalin

/obj/item/weapon/reagent_containers/pill/pouch_pill/paracetamol
	chem_type = /datum/reagent/paracetamol

/obj/item/weapon/reagent_containers/pill/pouch_pill/bicaridine
	chem_type = /datum/reagent/bicaridine

/obj/item/weapon/reagent_containers/pill/pouch_pill/peridaxon
	chem_type = /datum/reagent/peridaxon
	chem_amount = 10

/obj/item/weapon/reagent_containers/pill/pouch_pill/New()
	..()
	reagents.add_reagent(chem_type, chem_amount)
	name = "emergency [reagents.get_master_reagent_name()] pill ([reagents.total_volume]u)"
	color = reagents.get_color()

/obj/item/weapon/reagent_containers/hypospray/autoinjector/pouch_auto
	name = "emergency autoinjector"
	desc = "An emergency autoinjector from an emergency medical pouch"
	var/icon_colour

/obj/item/weapon/reagent_containers/hypospray/autoinjector/pouch_auto/update_icon()
	if(reagents.total_volume > 0)
		icon_state = "[icon_colour]1"
	else
		icon_state = "[icon_colour]0"

/obj/item/weapon/reagent_containers/hypospray/autoinjector/pouch_auto/inaprovaline
	name = "emergency inaprovaline autoinjector"
	starts_with = list(/datum/reagent/inaprovaline = 5)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/pouch_auto/deletrathol
	name = "emergency deletrathol autoinjector"
	starts_with = list(/datum/reagent/deletrathol = 5)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/pouch_auto/dylovene
	name = "emergency dylovene autoinjector"
	starts_with = list(/datum/reagent/dylovene = 5)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/pouch_auto/dexalin
	name = "emergency dexalin autoinjector"
	starts_with = list(/datum/reagent/dexalin = 5)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/pouch_auto/adrenaline
	name = "emergency adrenaline autoinjector"
	amount_per_transfer_from_this = 8
	starts_with = list(/datum/reagent/adrenaline = 8)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/pouch_auto/nanoblood
	name = "emergency nanoblood autoinjector"
	amount_per_transfer_from_this = 5
	starts_with = list(/datum/reagent/nanoblood = 5)

//TODO: Just bring back real medkits, these things are worthless.
/obj/item/stack/medical/bruise_pack/med_pouch
	w_class = ITEM_SIZE_TINY

/obj/item/stack/medical/ointment/med_pouch
	w_class = ITEM_SIZE_TINY

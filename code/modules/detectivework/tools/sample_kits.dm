/obj/item/weapon/sample
	name = "forensic sample"
	icon = 'resources/icons/obj/forensics.dmi'
	item_flags = ITEM_FLAG_NO_PRINT
	w_class = ITEM_SIZE_TINY
	var/list/evidence = list()
	var/object

/obj/item/weapon/sample/New(newloc, atom/supplied)
	..(newloc)
	if(supplied)
		copy_evidence(supplied)
		name = "[initial(name)] (\the [supplied])"
		object = "[supplied], [get_area(supplied)]"

/obj/item/weapon/sample/examine(user)
	. = ..(user, 1)
	if(. && object)
		to_chat(user, "The label says: '[object]'")

/obj/item/weapon/sample/print/New(newloc, atom/supplied)
	..(newloc, supplied)
	if(evidence && evidence.len)
		icon_state = "fingerprint1"

/obj/item/weapon/sample/proc/copy_evidence(atom/supplied)
	if(supplied.suit_fibers && supplied.suit_fibers.len)
		evidence = supplied.suit_fibers.Copy()
		supplied.suit_fibers.Cut()

/obj/item/weapon/sample/proc/merge_evidence(obj/item/weapon/sample/supplied, mob/user)
	if(!supplied.evidence || !supplied.evidence.len)
		return 0
	evidence |= supplied.evidence
	SetName("[initial(name)] (combined)")
	object = supplied.object + ", " + object
	to_chat(user, "<span class='notice'>You transfer the contents of \the [supplied] into \the [src].</span>")
	return 1

/obj/item/weapon/sample/print/merge_evidence(obj/item/weapon/sample/supplied, mob/user)
	if(!supplied.evidence || !supplied.evidence.len)
		return 0
	for(var/print in supplied.evidence)
		if(evidence[print])
			evidence[print] = stringmerge(evidence[print],supplied.evidence[print])
		else
			evidence[print] = supplied.evidence[print]
	SetName("[initial(name)] (combined)")
	object = supplied.object + ", " + object
	to_chat(user, "<span class='notice'>You overlay \the [src] and \the [supplied], combining the print records.</span>")
	return 1

/obj/item/weapon/sample/resolve_attackby(atom/A, mob/user, click_params)
	// Fingerprints will be handled in after_attack() to not mess up the samples taken
	return A.attackby(src, user, click_params)

/obj/item/weapon/sample/attackby(obj/O, mob/user)
	if(O.type == src.type)
		if(user.unEquip(O) && merge_evidence(O, user))
			qdel(O)
		return 1
	return ..()

/obj/item/weapon/sample/fibers
	name = "fiber bag"
	desc = "Used to hold fiber evidence for the detective."
	icon_state = "fiberbag"

/obj/item/weapon/sample/print
	name = "fingerprint card"
	desc = "Records a set of fingerprints."
	icon = 'resources/icons/obj/card.dmi'
	icon_state = "fingerprint0"
	item_state = "paper"

/obj/item/weapon/sample/print/attack_self(mob/user)
	if(evidence && evidence.len)
		return
	if(!is_human_mob(user))
		return
	var/mob/living/carbon/human/H = user
	if(H.gloves)
		to_chat(user, "<span class='warning'>Take \the [H.gloves] off first.</span>")
		return

	to_chat(user, "<span class='notice'>You firmly press your fingertips onto the card.</span>")
	var/fullprint = H.get_full_print()
	evidence[fullprint] = fullprint
	SetName("[initial(name)] (\the [H])")
	icon_state = "fingerprint1"

/obj/item/weapon/sample/print/attack(mob/living/M, mob/user)

	if(!is_human_mob(M))
		return ..()

	if(evidence && evidence.len)
		return 0

	var/mob/living/carbon/human/H = M

	if(H.gloves)
		to_chat(user, "<span class='warning'>\The [H] is wearing gloves.</span>")
		return 1

	if(user != H && H.a_intent != I_HELP && !H.lying)
		user.visible_message("<span class='danger'>\The [user] tries to take prints from \the [H], but they move away.</span>")
		return 1

	if(user.zone_sel.selecting == BP_R_HAND || user.zone_sel.selecting == BP_L_HAND)
		var/has_hand
		var/obj/item/organ/external/O = H.organs_by_name[BP_R_HAND]
		if(istype(O) && !O.is_stump())
			has_hand = 1
		else
			O = H.organs_by_name[BP_L_HAND]
			if(istype(O) && !O.is_stump())
				has_hand = 1
		if(!has_hand)
			to_chat(user, "<span class='warning'>They don't have any hands.</span>")
			return 1
		user.visible_message("[user] takes a copy of \the [H]'s fingerprints.")
		var/fullprint = H.get_full_print()
		evidence[fullprint] = fullprint
		copy_evidence(src)
		SetName("[initial(name)] (\the [H])")
		icon_state = "fingerprint1"
		return 1
	return 0

/obj/item/weapon/sample/print/copy_evidence(atom/supplied)
	if(supplied.fingerprints && supplied.fingerprints.len)
		for(var/print in supplied.fingerprints)
			evidence[print] = supplied.fingerprints[print]
		supplied.fingerprints.Cut()

/obj/item/weapon/forensics
	item_flags = ITEM_FLAG_NO_PRINT

/obj/item/weapon/forensics/sample_kit
	name = "fiber collection kit"
	desc = "A magnifying glass and tweezers. Used to lift suit fibers."
	icon_state = "m_glass"
	w_class = ITEM_SIZE_SMALL
	var/evidence_type = "fiber"
	var/evidence_path = /obj/item/weapon/sample/fibers

/obj/item/weapon/forensics/sample_kit/proc/can_take_sample(mob/user, atom/supplied)
	return (supplied.suit_fibers && supplied.suit_fibers.len)

/obj/item/weapon/forensics/sample_kit/proc/take_sample(mob/user, atom/supplied)
	var/obj/item/weapon/sample/S = new evidence_path(get_turf(user), supplied)
	to_chat(user, "<span class='notice'>You transfer [S.evidence.len] [S.evidence.len > 1 ? "[evidence_type]s" : "[evidence_type]"] to \the [S].</span>")

/obj/item/weapon/forensics/sample_kit/afterattack(atom/A, mob/user, proximity)
	if(!proximity)
		return
	if(can_take_sample(user, A))
		take_sample(user,A)
		. = 1
	else
		to_chat(user, "<span class='warning'>You are unable to locate any [evidence_type]s on \the [A].</span>")
		. = ..()
	A.add_fingerprint(user)

/obj/item/weapon/forensics/sample_kit/MouseDrop(atom/over)
	if(is_mob(src.loc) && CanMouseDrop(over))
		afterattack(over, usr, TRUE)

/obj/item/weapon/forensics/sample_kit/powder
	name = "fingerprint powder"
	desc = "A jar containing aluminum powder and a specialized brush."
	icon_state = "dust"
	evidence_type = "fingerprint"
	evidence_path = /obj/item/weapon/sample/print

/obj/item/weapon/forensics/sample_kit/powder/can_take_sample(mob/user, atom/supplied)
	return (supplied.fingerprints && supplied.fingerprints.len)

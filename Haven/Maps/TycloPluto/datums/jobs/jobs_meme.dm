/decl/hierarchy/outfit/job/mime
	name = OUTFIT_JOB_NAME("Mime") //done
	uniform = /obj/item/clothing/under/mime
	head = /obj/item/clothing/head/beret
	mask = /obj/item/clothing/mask/gas/mime
	gloves = /obj/item/clothing/gloves/white
	shoes = /obj/item/clothing/shoes/black
	pda_type = /obj/item/modular_computer/pda/mime
	id_type = /obj/item/weapon/card/id/civilian/mime

/decl/hierarchy/outfit/job/clown
	name = OUTFIT_JOB_NAME("Clown") //done
	uniform = /obj/item/clothing/under/rank/clown
	mask = /obj/item/clothing/mask/gas/clown_hat
	shoes = /obj/item/clothing/shoes/clown_shoes
	backpack_contents = list(/obj/item/weapon/reagent_containers/food/snacks/grown/banana = 1, /obj/item/weapon/bikehorn = 1,
		/obj/item/weapon/stamp/clown = 1, /obj/item/weapon/pen/crayon/rainbow = 1, /obj/item/weapon/storage/fancy/crayons = 1,
		/obj/item/weapon/reagent_containers/spray/waterflower = 1)
	back = /obj/item/weapon/storage/backpack/clown
	pda_type = /obj/item/modular_computer/pda/clown
	id_type = /obj/item/weapon/card/id/civilian/clown

//Mime

/datum/job/mime
	title = "Mime"
	department = "Civilian"
	department_flag = CIV
	total_positions = 1
	spawn_positions = 1
	supervisors = "the second officer"
	selection_color = "#515151"
	access = list(access_maint_tunnels, access_theatre)
	minimal_player_age = 0
	outfit_type = /decl/hierarchy/outfit/job/mime

/datum/job/mime/equip(var/mob/living/carbon/human/H)
	. = ..()
	if(.)
		H.miming = 1
		H.verbs += /client/proc/mimespeak
		H.verbs += /client/proc/mimewall
		H.mind.special_verbs += /client/proc/mimespeak
		H.mind.special_verbs += /client/proc/mimewall

//Clown :^)

/datum/job/clown
	title = "Clown"
	department = "Civilian"
	department_flag = CIV
	total_positions = 1
	spawn_positions = 1
	supervisors = "the second officer"
	selection_color = "#515151"
	access = list(access_maint_tunnels, access_theatre)
	minimal_player_age = 1
	outfit_type = /decl/hierarchy/outfit/job/clown

/datum/job/clown/equip(var/mob/living/carbon/human/H)
	. = ..()
	if(.)
		H.mutations.Add(CLUMSY)

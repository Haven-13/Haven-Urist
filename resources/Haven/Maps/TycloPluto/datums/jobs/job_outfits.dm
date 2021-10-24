/decl/hierarchy/outfit/job/pluto
	hierarchy_type = /decl/hierarchy/outfit/job/pluto

/decl/hierarchy/outfit/job/bodyguard
	name = OUTFIT_JOB_NAME("Bodyguard") //done
	uniform = /obj/item/clothing/under/bodyguard
	suit = /obj/item/clothing/suit/armor/vest/deus_blueshield
	l_ear = /obj/item/device/radio/headset/heads/hop
	shoes = /obj/item/clothing/shoes/jackboots
	id_type = /obj/item/weapon/card/id/bodyguard
	pda_type = /obj/item/modular_computer/pda/heads/hop
	backpack_contents = list(/obj/item/weapon/storage/box/deathimp = 1)
	gloves = /obj/item/clothing/gloves/thick/combat

//fo

/decl/hierarchy/outfit/job/pluto/firstofficer
	name = OUTFIT_JOB_NAME("Pluto First Mate")
	uniform = /obj/item/clothing/under/urist/nerva/foregular
	l_ear = /obj/item/device/radio/headset/heads/firstofficer
	shoes = /obj/item/clothing/shoes/black
	id_type = /obj/item/weapon/card/id/firstofficer
	pda_type = /obj/item/modular_computer/pda/heads/hop //change
	gloves = /obj/item/clothing/gloves/color/grey
	head = /obj/item/clothing/head/urist/beret/nervafo

//so

/decl/hierarchy/outfit/job/pluto/secondofficer //done
	name = OUTFIT_JOB_NAME("Pluto Second Mate")
	uniform = /obj/item/clothing/under/urist/nerva/soregular
	l_ear = /obj/item/device/radio/headset/heads/secondofficer
	shoes = /obj/item/clothing/shoes/black
	id_type = /obj/item/weapon/card/id/secondofficer
	pda_type = /obj/item/modular_computer/pda/heads/hop
	gloves = /obj/item/clothing/gloves/color/grey
	head = /obj/item/clothing/head/urist/beret/nervaso

//cargo

/decl/hierarchy/outfit/job/pluto/supplytech
	name = OUTFIT_JOB_NAME("Pluto Supply Technician")
	uniform = /obj/item/clothing/under/urist/nerva/cargo
	suit = /obj/item/clothing/suit/storage/toggle/urist/cargojacket
	l_ear = /obj/item/device/radio/headset/headset_cargo
	shoes = /obj/item/clothing/shoes/urist/leather
	id_type = /obj/item/weapon/card/id/cargo
	pda_type = /obj/item/modular_computer/pda/cargo
	gloves = /obj/item/clothing/gloves/urist/leather

/decl/hierarchy/outfit/job/pluto/qm
	name = OUTFIT_JOB_NAME("Pluto Quartermaster")
	uniform = /obj/item/clothing/under/urist/nerva/qm
	suit = /obj/item/clothing/suit/storage/toggle/urist/qmjacket
	l_ear = /obj/item/device/radio/headset/heads/nerva_qm
	shoes = /obj/item/clothing/shoes/black
	id_type = /obj/item/weapon/card/id/cargo/head
	pda_type = /obj/item/modular_computer/pda/heads/hop
	gloves = /obj/item/clothing/gloves/color/grey

/decl/hierarchy/outfit/job/pluto/roboticist
	name = OUTFIT_JOB_NAME("Pluto Roboticist")
	uniform = /obj/item/clothing/under/rank/roboticist
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/robotics
	l_ear = /obj/item/device/radio/headset/headset_cargo
	shoes = /obj/item/clothing/shoes/black
	belt = /obj/item/weapon/storage/belt/robotics/full
	id_type = /obj/item/weapon/card/id/cargo
	pda_slot = slot_r_store
	pda_type = /obj/item/modular_computer/pda/roboticist

/decl/hierarchy/outfit/job/science/nervaroboticist/New()
	..()
	backpack_overrides.Cut()

//cappy

/decl/hierarchy/outfit/job/pluto/captain //done
	name = OUTFIT_JOB_NAME("Pluto Captain")
	uniform = /obj/item/clothing/under/urist/nerva/capregular
	suit = /obj/item/clothing/suit/storage/toggle/urist/nervacapjacket
	l_ear = /obj/item/device/radio/headset/heads/nerva_cap
	shoes = /obj/item/clothing/shoes/urist/capboots
	id_type = /obj/item/weapon/card/id/gold
	pda_type = /obj/item/modular_computer/pda/captain
	gloves = /obj/item/clothing/gloves/thick/combat
	head = /obj/item/clothing/head/urist/beret/nervacap

//sec
/decl/hierarchy/outfit/job/security/pluto
	hierarchy_type = /decl/hierarchy/outfit/job/security/pluto

/decl/hierarchy/outfit/job/security/pluto/secofficer
	name = OUTFIT_JOB_NAME("Pluto Security Officer") //done
	uniform = /obj/item/clothing/under/urist/nerva/secregular
	l_pocket = /obj/item/device/flash
	r_pocket = /obj/item/weapon/handcuffs
	id_type = /obj/item/weapon/card/id/security
	pda_type = /obj/item/modular_computer/pda/security
	head = /obj/item/clothing/head/beret/sec
	l_ear = /obj/item/device/radio/headset/nerva_sec

/decl/hierarchy/outfit/job/security/pluto/cos //done
	name = OUTFIT_JOB_NAME("Pluto Chief of Security")
	uniform = /obj/item/clothing/under/urist/nerva/cosregular
	l_ear = /obj/item/device/radio/headset/heads/nerva_cos
	id_type = /obj/item/weapon/card/id/security/head
	pda_type = /obj/item/modular_computer/pda/heads/hos
	backpack_contents = list(/obj/item/weapon/handcuffs = 1)
	head = /obj/item/clothing/head/beret/sec/nervacos

//bartender
/decl/hierarchy/outfit/job/service/pluto
	hierarchy_type = /decl/hierarchy/outfit/job/service/pluto

/decl/hierarchy/outfit/job/service/pluto/bartender
	name = OUTFIT_JOB_NAME("Pluto Bartender")
	uniform = /obj/item/clothing/under/rank/bartender
	id_type = /obj/item/weapon/card/id/civilian/chef
	pda_type = /obj/item/modular_computer/pda

//stowaway
/decl/hierarchy/outfit/job/pluto/stowaway
	name = OUTFIT_JOB_NAME("Pluto Stowaway")
	shoes = /obj/item/clothing/shoes/black
	uniform = /obj/item/clothing/under/color/grey
	id_type = null
	pda_type = null
	l_ear = null
	l_pocket = /obj/item/weapon/wrench
	r_pocket = /obj/item/weapon/crowbar
	backpack_contents = list(/obj/item/device/flashlight = 1)

//psychiatrist

/decl/hierarchy/outfit/job/medical/psychiatrist/pluto
	name = OUTFIT_JOB_NAME("Pluto Psychiatrist")
	id_type = /obj/item/weapon/card/id/medical/psychiatrist/nerva

/decl/hierarchy/outfit/job/medical/psychiatrist/psychologist/pluto
	name = OUTFIT_JOB_NAME("Pluto Psychologist")
	id_type = /obj/item/weapon/card/id/medical/psychiatrist/nerva

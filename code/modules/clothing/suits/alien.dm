//Unathi clothing.

/obj/item/clothing/suit/unathi/robe
	name = "roughspun robes"
	desc = "A traditional Unathi garment."
	icon_state = "robe-unathi"
	item_state = "robe-unathi"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS

/obj/item/clothing/suit/unathi/mantle
	name = "hide mantle"
	desc = "A rather grisly selection of cured hides and skin, sewn together to form a ragged mantle."
	icon_state = "mantle-unathi"
	item_state = "mantle-unathi"
	body_parts_covered = UPPER_TORSO

//Misc Xeno clothing.

/obj/item/clothing/suit/xeno/furs
	name = "heavy furs"
	desc = "A traditional Zhan-Khazan garment."
	icon_state = "zhan_furs"
	item_state = "zhan_furs"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS

/obj/item/clothing/head/xeno/scarf
	name = "headscarf"
	desc = "A scarf of coarse fabric. Seems to have ear-holes."
	icon_state = "zhan_scarf"
	body_parts_covered = HEAD|FACE

/obj/item/clothing/shoes/sandal/xeno/caligae
	name = "caligae"
	desc = "A pair of sandals modelled after the ancient Roman caligae."
	icon_state = "caligae"
	item_state = "caligae"
	body_parts_covered = FEET|LEGS

/obj/item/clothing/shoes/sandal/xeno/caligae/white
	desc = "A pair of sandals modelled after the ancient Roman caligae. This one has a white covering."
	icon_state = "whitecaligae"
	item_state = "whitecaligae"

/obj/item/clothing/shoes/sandal/xeno/caligae/grey
	desc = "A pair of sandals modelled after the ancient Roman caligae. This one has a grey covering."
	icon_state = "greycaligae"
	item_state = "greycaligae"

/obj/item/clothing/shoes/sandal/xeno/caligae/black
	desc = "A pair of sandals modelled after the ancient Roman caligae. This one has a black covering."
	icon_state = "blackcaligae"
	item_state = "blackcaligae"

/obj/item/clothing/accessory/shouldercape
	name = "shoulder cape"
	desc = "A simple shoulder cape."
	icon_state = "gruntcape"
	slot = ACCESSORY_SLOT_INSIGNIA // Adding again in case we want to change it in the future.

/obj/item/clothing/accessory/shouldercape/grunt
	name = "cape"
	desc = "A simple looking cape with a couple of runes woven into the fabric."
	icon_state = "gruntcape" // Again, just in case it is changed.

/obj/item/clothing/accessory/shouldercape/officer
	name = "officer's cape"
	desc = "A decorated cape. Runed patterns have been woven into the fabric."
	icon_state = "officercape"

/obj/item/clothing/accessory/shouldercape/command
	name = "command cape"
	desc = "A heavily decorated cape with rank emblems on the shoulders signifying prestige. An ornate runed design has been woven into the fabric of it"
	icon_state = "commandcape"

/obj/item/clothing/accessory/shouldercape/general
	name = "general's cape"
	desc = "An extremely decorated cape with an intricately runed design has been woven into the fabric of this cape with great care."
	icon_state = "leadercape"

//Resomi clothing

/obj/item/clothing/suit/storage/toggle/Resomicoat
 	name = "small coat"
 	desc = "A coat that seems too small to fit a human."
 	icon_state = "resomicoat"
 	item_state = "resomicoat"
 	icon_open = "resomicoat_open"
 	icon_closed = "resomicoat"
 	body_parts_covered = UPPER_TORSO|ARMS|LOWER_TORSO|LEGS
 	species_restricted = list(SPECIES_RESOMI)

/obj/item/clothing/suit/storage/toggle/Resomicoat/white
 	name = "small coat"
 	desc = "A coat that seems too small to fit a human."
 	icon_state = "resomicoatwhite"
 	item_state = "resomicoatwhite"
 	icon_open = "resomicoatwhite_open"
 	icon_closed = "resomicoatwhite"
 	body_parts_covered = UPPER_TORSO|ARMS|LOWER_TORSO|LEGS
 	species_restricted = list(SPECIES_RESOMI)

/obj/item/clothing/suit/armor/vox_scrap
	name = "rusted metal armor"
	desc = "A hodgepodge of various pieces of metal scrapped together into a rudimentary vox-shaped piece of armor."
	allowed = list(/obj/item/weapon/gun, /obj/item/weapon/tank)
	armor = list(melee = 70, bullet = 30, laser = 20,energy = 5, bomb = 40, bio = 0, rad = 0) //Higher melee armor versus lower everything else.
	icon_state = "vox-scrap"
	icon_state = "vox-scrap"
	body_parts_covered = UPPER_TORSO|ARMS|LOWER_TORSO|LEGS
	species_restricted = list(SPECIES_VOX)
	siemens_coefficient = 1 //Its literally metal

// Standard Teshari Cloaks
/obj/item/clothing/suit/storage/teshari/cloak/color
	name = "black cloak"
	desc = "It drapes over a Teshari's shoulders and closes at the neck with pockets convienently placed inside."
	icon = 'icons/mob/species/resomi/teshari_cloak.dmi'
	item_icons = list(slot_wear_suit_str = 'icons/mob/species/resomi/teshari_cloak.dmi')
	icon_state = "tesh_cloak_bn"
	item_state = "tesh_cloak_bn"
	species_restricted = list(SPECIES_RESOMI)
	body_parts_covered = UPPER_TORSO|ARMS

/obj/item/clothing/suit/storage/teshari/cloak/color/standard/black_red
	name = "black and red cloak"
	icon_state = "tesh_cloak_br"
	item_state = "tesh_cloak_br"

/obj/item/clothing/suit/storage/teshari/cloak/color/standard/black_orange
	name = "black and orange cloak"
	icon_state = "tesh_cloak_bo"
	item_state = "tesh_cloak_bo"

/obj/item/clothing/suit/storage/teshari/cloak/color/standard/black_yellow
	name = "black and yellow cloak"
	icon_state = "tesh_cloak_by"
	item_state = "tesh_cloak_by"

/obj/item/clothing/suit/storage/teshari/cloak/color/standard/black_green
	name = "black and green cloak"
	icon_state = "tesh_cloak_bgr"
	item_state = "tesh_cloak_bgr"

/obj/item/clothing/suit/storage/teshari/cloak/color/standard/black_blue
	name = "black and blue cloak"
	icon_state = "tesh_cloak_bbl"
	item_state = "tesh_cloak_bbl"

/obj/item/clothing/suit/storage/teshari/cloak/color/standard/black_purple
	name = "black and purple cloak"
	icon_state = "tesh_cloak_bp"
	item_state = "tesh_cloak_bp"

/obj/item/clothing/suit/storage/teshari/cloak/color/standard/black_pink
	name = "black and pink cloak"
	icon_state = "tesh_cloak_bpi"
	item_state = "tesh_cloak_bpi"

/obj/item/clothing/suit/storage/teshari/cloak/color/standard/black_brown
	name = "black and brown cloak"
	icon_state = "tesh_cloak_bbr"
	item_state = "tesh_cloak_bbr"

/obj/item/clothing/suit/storage/teshari/cloak/color/standard/black_grey
	name = "black and grey cloak"
	icon_state = "tesh_cloak_bg"
	item_state = "tesh_cloak_bg"

/obj/item/clothing/suit/storage/teshari/cloak/color/standard/black_white
	name = "black and white cloak"
	icon_state = "tesh_cloak_bw"
	item_state = "tesh_cloak_bw"

/obj/item/clothing/suit/storage/teshari/cloak/color/standard/white
	name = "white cloak"
	icon_state = "tesh_cloak_wn"
	item_state = "tesh_cloak_wn"

/obj/item/clothing/suit/storage/teshari/cloak/color/standard/white_grey
	name = "white and grey cloak"
	icon_state = "tesh_cloak_wg"
	item_state = "tesh_cloak_wg"

/obj/item/clothing/suit/storage/teshari/cloak/color/standard/red_grey
	name = "red and grey cloak"
	icon_state = "tesh_cloak_rg"
	item_state = "tesh_cloak_rg"

/obj/item/clothing/suit/storage/teshari/cloak/color/standard/orange_grey
	name = "orange and grey cloak"
	icon_state = "tesh_cloak_og"
	item_state = "tesh_cloak_og"

/obj/item/clothing/suit/storage/teshari/cloak/color/standard/yellow_grey
	name = "yellow and grey cloak"
	icon_state = "tesh_cloak_yg"
	item_state = "tesh_cloak_yg"

/obj/item/clothing/suit/storage/teshari/cloak/color/standard/green_grey
	name = "green and grey cloak"
	icon_state = "tesh_cloak_gg"
	item_state = "tesh_cloak_gg"

/obj/item/clothing/suit/storage/teshari/cloak/color/standard/blue_grey
	name = "blue and grey cloak"
	icon_state = "tesh_cloak_blug"
	item_state = "tesh_cloak_blug"

/obj/item/clothing/suit/storage/teshari/cloak/color/standard/purple_grey
	name = "purple and grey cloak"
	icon_state = "tesh_cloak_pg"
	item_state = "tesh_cloak_pg"

/obj/item/clothing/suit/storage/teshari/cloak/color/standard/pink_grey
	name = "pink and grey cloak"
	icon_state = "tesh_cloak_pig"
	item_state = "tesh_cloak_pig"

/obj/item/clothing/suit/storage/teshari/cloak/color/standard/brown_grey
	name = "brown and grey cloak"
	icon_state = "tesh_cloak_brg"
	item_state = "tesh_cloak_brg"

/obj/item/clothing/suit/storage/teshari/cloak/color/standard/rainbow
	name = "rainbow cloak"
	icon_state = "tesh_cloak_rainbow"
	item_state = "tesh_cloak_rainbow"

/obj/item/clothing/suit/storage/teshari/cloak/color/standard/orange
	name = "orange cloak"
	icon_state = "tesh_cloak_on"
	item_state = "tesh_cloak_on"

/obj/item/clothing/suit/storage/teshari/cloak/color/standard/dark_retrowave
	name = "dark aesthetic cloak"
	icon_state = "tesh_cloak_dretrowave"
	item_state = "tesh_cloak_dretrowave"
	icon = 'icons/mob/species/resomi/teshari_cloak.dmi'
	icon_override = 'icons/mob/species/resomi/teshari_cloak.dmi'

/obj/item/clothing/suit/storage/teshari/cloak/color/standard/black_glow
	name = "black and glowing cloak"
	desc = "It drapes over a Teshari's shoulders and closes at the neck with pockets convienently placed inside. This one has a polychromatic glowing rim at the bottom!"
	icon_state = "tesh_cloak_bglowing"
	item_state = "tesh_cloak_bglowing"
	icon = 'icons/mob/species/resomi/teshari_cloak.dmi'
	icon_override = 'icons/mob/species/resomi/teshari_cloak.dmi'


// Job Cloaks
/obj/item/clothing/suit/storage/teshari/cloak/jobs
	name = "Captain cloak"
	desc = "A soft Teshari cloak made for the Captain"
	icon = 'icons/mob/species/resomi/deptcloak.dmi'
	item_icons = list(slot_wear_suit_str = 'icons/mob/species/resomi/deptcloak.dmi')
	icon_state = "tesh_cloak_cap"
	item_state = "tesh_cloak_cap"
	species_restricted = list(SPECIES_RESOMI)
	body_parts_covered = UPPER_TORSO|ARMS

//Cargo

/obj/item/clothing/suit/storage/teshari/cloak/jobs/qm
	name = "Quartermaster cloak"
	desc = "A soft Teshari cloak made for the Quartermaster"
	icon_state = "tesh_cloak_qm"
	item_state = "tesh_cloak_qm"

/obj/item/clothing/suit/storage/teshari/cloak/jobs/cargo
	name = "Cargo cloak"
	desc = "A soft Teshari cloak made for a Cargo Technician"
	icon_state = "tesh_cloak_car"
	item_state = "tesh_cloak_car"

/obj/item/clothing/suit/storage/teshari/cloak/jobs/mining
	name = "Mining cloak"
	desc = "A soft Teshari cloak made for a Miner"
	icon_state = "tesh_cloak_mine"
	item_state = "tesh_cloak_mine"

//Engineering

/obj/item/clothing/suit/storage/teshari/cloak/jobs/ce
	name = "Chief Engineer cloak"
	desc = "A soft Teshari cloak made for the Chief Engineer"
	icon_state = "tesh_cloak_ce"
	item_state = "tesh_cloak_ce"

/obj/item/clothing/suit/storage/teshari/cloak/jobs/eningeer
	name = "engineering cloak"
	desc = "A soft Teshari cloak made for an Engineer"
	icon_state = "tesh_cloak_engie"
	item_state = "tesh_cloak_engie"

/obj/item/clothing/suit/storage/teshari/cloak/jobs/atmos
	name = "Atmospherics cloak"
	desc = "A soft Teshari cloak made for an Atmospheric Technician"
	icon_state = "tesh_cloak_atmos"
	item_state = "tesh_cloak_atmos"

//Medical

/obj/item/clothing/suit/storage/teshari/cloak/jobs/cmo
	name = "Second Mate cloak"
	desc = "A soft Teshari cloak made for the Second Mate"
	icon_state = "tesh_cloak_cmo"
	item_state = "tesh_cloak_cmo"

/obj/item/clothing/suit/storage/teshari/cloak/jobs/medical
	name = "Medical cloak"
	desc = "A soft Teshari cloak made for a Medical Doctor"
	icon_state = "tesh_cloak_doc"
	item_state = "tesh_cloak_doc"

/obj/item/clothing/suit/storage/teshari/cloak/jobs/chemistry
	name = "Chemist cloak"
	desc = "A soft Teshari cloak made for a Chemist"
	icon_state = "tesh_cloak_chem"
	item_state = "tesh_cloak_chem"

/obj/item/clothing/suit/storage/teshari/cloak/jobs/viro
	name = "Virologist cloak"
	desc = "A soft Teshari cloak made for a Virologist"
	icon_state = "tesh_cloak_viro"
	item_state = "tesh_cloak_viro"

/obj/item/clothing/suit/storage/teshari/cloak/jobs/para
	name = "Paramedic cloak"
	desc = "A soft Teshari cloak made for a Paramedic"
	icon_state = "tesh_cloak_para"
	item_state = "tesh_cloak_para"

/obj/item/clothing/suit/storage/teshari/cloak/jobs/psych
	name = " psychiatrist cloak"
	desc = "A soft Teshari cloak made for a Psychiatrist"
	icon_state = "tesh_cloak_psych"
	item_state = "tesh_cloak_psych"

//Science

/obj/item/clothing/suit/storage/teshari/cloak/jobs/rd
	name = "research director cloak"
	desc = "A soft Teshari cloak made for the Research Director"
	icon_state = "tesh_cloak_rd"
	item_state = "tesh_cloak_rd"

/obj/item/clothing/suit/storage/teshari/cloak/jobs/sci
	name = "scientist cloak"
	desc = "A soft Teshari cloak made for a Scientist"
	icon_state = "tesh_cloak_sci"
	item_state = "tesh_cloak_sci"

/obj/item/clothing/suit/storage/teshari/cloak/jobs/robo
	name = "roboticist cloak"
	desc = "A soft Teshari cloak made for a Roboticist"
	icon_state = "tesh_cloak_robo"
	item_state = "tesh_cloak_robo"

//Security

/obj/item/clothing/suit/storage/teshari/cloak/jobs/hos
	name = "head of security cloak"
	desc = "A soft Teshari cloak made for the Head of Security"
	icon_state = "tesh_cloak_hos"
	item_state = "tesh_cloak_hos"

/obj/item/clothing/suit/storage/teshari/cloak/jobs/sec
	name = "security cloak"
	desc = "A soft Teshari cloak made for a Security officer"
	icon_state = "tesh_cloak_sec"
	item_state = "tesh_cloak_sec"

/obj/item/clothing/suit/storage/teshari/cloak/jobs/ia
	name = "Second Officer cloak"
	desc = "A soft Teshari cloak made for an Internal Affairs Agent"
	icon_state = "tesh_cloak_iaa"
	item_state = "tesh_cloak_iaa"

//Service

/obj/item/clothing/suit/storage/teshari/cloak/jobs/hop
	name = "First Mate cloak"
	desc = "A soft Teshari cloak made for the First Mate"
	icon_state = "tesh_cloak_hop"
	item_state = "tesh_cloak_hop"

/obj/item/clothing/suit/storage/teshari/cloak/jobs/service
	name = "Service cloak"
	desc = "A soft Teshari cloak made for a member of the Service department"
	icon_state = "tesh_cloak_serv"
	item_state = "tesh_cloak_serv"
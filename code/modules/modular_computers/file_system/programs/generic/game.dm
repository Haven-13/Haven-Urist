// This file is used as a reference for Modular Computers Development guide on the wiki. It contains a lot of excess comments, as it is intended as explanation
// for someone who may not be as experienced in coding. When making changes, please try to keep it this way.

// An actual program definition.
/datum/computer_file/program/game
	filename = "arcadec"					// File name, as shown in the file browser program.
	filedesc = "Unknown Game"				// User-Friendly name. In this case, we will generate a random name in constructor.
	program_icon_state = "game"				// Icon state of this program's screen.
	program_menu_icon = "script"
	extended_desc = "Fun for the whole family! Probably not an AAA title, but at least you can download it on the corporate network.."		// A nice description.
	size = 5								// Size in GQ. Integers only. Smaller sizes should be used for utility/low use programs (like this one), while large sizes are for important programs.
	requires_ntnet = 0						// This particular program does not require NTNet network conectivity...
	available_on_ntnet = 1					// ... but we want it to be available for download.
	ui_module_path = /datum/ui_module/arcade_classic/	// Path of relevant nano module. The nano module is defined further in the file.
	var/picked_enemy_name
	usage_flags = PROGRAM_ALL

// Blatantly stolen and shortened version from arcade machines. Generates a random enemy name
/datum/computer_file/program/game/proc/random_enemy_name()
	var/name_part1 = pick("the Automatic ", "Farmer ", "Lord ", "Professor ", "the Cuban ", "the Evil ", "the Dread King ", "the Space ", "Lord ", "the Great ", "Duke ", "General ")
	var/name_part2 = pick("Melonoid", "Murdertron", "Sorcerer", "Ruin", "Jeff", "Ectoplasm", "Crushulon", "Uhangoid", "Vhakoid", "Peteoid", "Slime", "Lizard Man", "Unicorn")
	return "[name_part1] [name_part2]"

// When the program is first created, we generate a new enemy name and name ourselves accordingly.
/datum/computer_file/program/game/New()
	..()
	picked_enemy_name = random_enemy_name()
	filedesc = "Defeat [picked_enemy_name]"

// Important in order to ensure that copied versions will have the same enemy name.
/datum/computer_file/program/game/clone()
	var/datum/computer_file/program/game/G = ..()
	G.picked_enemy_name = picked_enemy_name
	return G

// When running the program, we also want to pass our enemy name to the nano module.
/datum/computer_file/program/game/run_program()
	. = ..()
	if(. && NM)
		var/datum/ui_module/arcade_classic/NMC = NM
		NMC.enemy_name = picked_enemy_name

#define MAX_PLANE 10000
#define MIN_PLANE -MAX_PLANE

// Background planes
#define CLICKCATCHER_PLANE MIN_PLANE

#define SPACE_PLANE -9000

#define SKYBOX_PLANE SPACE_PLANE + 1
	#define BASE_SKYBOX_LAYER 1
	#define DUST_LAYER 2

// Not for anything, but this is the default.
#define BASE_PLANE 0
	#define BASE_AREA_LAYER 999

// Used for special cameras used by tgui and other special effects
#define MAP_VIEW_PLANE 0
	#define MAP_VIEW_LAYER 0

// Visible game planes
#define DEFAULT_PLANE 1
	#define OPEN_SPACE_LAYER          0000.0

	#define BELOW_TURF_LAYER          1000.0

	#define PLATING_LAYER             2000.0

	#define ABOVE_PLATING_LAYER       3000.0
		#define DECAL_PLATING_LAYER       3010.0
		#define LATTICE_LAYER             3020.0
		#define DISPOSALS_PIPE_LAYER      3030.0
		#define PIPE_LAYER                3040.0
		#define WIRE_LAYER                3050.0
		#define TERMINAL_LAYER            3060.0
		#define ABOVE_WIRE_LAYER          3070.0

	#define TURF_LAYER                4000.00
		#define TURF_DETAIL_LAYER         4010.0
		#define TURF_DECAL_LAYER          4020.0
		#define TURF_RUNE_LAYER           4030.0
		#define ABOVE_TILE_LAYER          4040.0
		#define EXPOSED_PIPE_LAYER        4050.0
		#define EXPOSED_WIRE_LAYER        4060.0
		#define EXPOSED_TERMINAL_LAYER    4070.0
		#define CATWALK_LAYER             4080.0

	#define BELOW_OBJ_LAYER           5000.00
		#define HIDING_MOB_LAYER          5010.0
		#define SHALLOW_FLUID_LAYER       5020.0
		#define BELOW_DOOR_LAYER          5030.0
		#define OPEN_DOOR_LAYER           5040.0
		#define BELOW_TABLE_LAYER         5050.0
		#define STRUCTURE_LAYER           5060.0

	#define OBJ_LAYER                 6000.00
		#define CLOSED_DOOR_LAYER         6010.0
		#define ABOVE_DOOR_LAYER          6020.0
		#define SIDE_WINDOW_LAYER         6030.0
		#define FULL_WINDOW_LAYER         6040.0
		#define ABOVE_WINDOW_LAYER        6050.0
		#define LYING_MOB_LAYER           6060.0
		#define LYING_HUMAN_LAYER         6070.0
		#define ABOVE_OBJ_LAYER           6080.0

	#define MOB_LAYER                 7000.00
		#define HUMANOID_LAYER            7010.0
		#define ABOVE_MOB_LAYER           7020.0

// For special effects.
#define EFFECTS_PLANE  2
	#define BELOW_PROJECTILE_LAYER  1
	#define DEEP_FLUID_LAYER        2
	#define FIRE_LAYER              3
	#define PROJECTILE_LAYER        4
	#define ABOVE_PROJECTILE_LAYER  5
	#define SINGULARITY_LAYER       6
	#define POINTER_LAYER           7
	#define ALARM_LAYER             8
	#define OBSERVER_LAYER          256

// Used for masking the Lighting plane
#define VISIBLE_GAME_WORLD_PLANE      3

// For Lighting. - The highest plane (ignoring all other even higher planes)
#define LIGHTING_PLANE                4
	#define LIGHTING_LAYER         0
	#define ABOVE_LIGHTING_LAYER   1

// For glowy eyes, laser beams, etc. that shouldn't be affected by darkness
#define EMISSIVE_PLANE                5
	#define EMISSIVE_BASE_LAYER 0
	#define EMISSIVE_UNBLOCKABLE_LAYER 16384

// For visualnets, such as the AI's static.
#define OBSCURITY_PLANE               6

//This is difference between highest and lowest visible game planes
#define PLANE_DIFFERENCE              6

#define FULLSCREEN_PLANE              9000 // for fullscreen overlays that do not cover the hud.
	#define FULLSCREEN_LAYER    0
	#define DAMAGE_LAYER        1
	#define IMPAIRED_LAYER      2
	#define BLIND_LAYER         3
	#define CRIT_LAYER          4
	#define HALLUCINATION_LAYER 5

#define HUD_PLANE                     9001 // For the Head-Up Display
	#define UNDER_HUD_LAYER      0
	#define HUD_BASE_LAYER       1
	#define HUD_CLICKABLE_LAYER  2
	#define HUD_ITEM_LAYER       3
	#define HUD_ABOVE_ITEM_LAYER 4

#define ABOVE_HUD_PLANE               9002 // For things to appear over the HUD

// This is the difference between the highest and lowest visible FULLSCREEN planes
#define FULLSCREEN_PLANE_DIFFERENCE   3

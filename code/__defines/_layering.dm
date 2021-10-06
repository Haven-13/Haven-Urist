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
	#define OPEN_SPACE_LAYER          0.000
		#define Z_MIMIC_LAYER             0.010
		#define OPEN_DARKNESS_LAYER       0.020

	#define PLATING_LAYER             1.000
		#define ABOVE_PLATING_LAYER       1.010
		#define PLATING_DECAL_LAYER       1.020
		#define LATTICE_LAYER             1.030
		#define DISPOSALS_PIPE_LAYER      1.040
		#define PIPE_LAYER                1.050
		#define WIRE_LAYER                1.060
		#define TERMINAL_LAYER            1.070
		#define ABOVE_WIRE_LAYER          1.080

	#define TURF_LAYER                2.000
		#define TURF_DETAIL_LAYER         2.010
		#define TURF_DECAL_LAYER          2.020
		#define TURF_RUNE_LAYER           2.030
		#define ABOVE_TURF_LAYER          2.040
		#define EXPOSED_PIPE_LAYER        2.050
		#define EXPOSED_WIRE_LAYER        2.060
		#define EXPOSED_TERMINAL_LAYER    2.070
		#define CATWALK_LAYER             2.080
		#define TURF_BLOOD_LAYER          2.090

	#define BELOW_OBJ_LAYER           3.000
		#define HIDING_MOB_LAYER          3.010
		#define SHALLOW_FLUID_LAYER       3.020
		#define BELOW_DOOR_LAYER          3.030
		#define OPEN_DOOR_LAYER           3.040
		#define BELOW_TABLE_LAYER         3.050
		#define TABLE_LAYER               3.060
		#define STRUCTURE_LAYER           3.070

	#define OBJ_LAYER                 4.000
		#define CLOSED_DOOR_LAYER         4.010
		#define ABOVE_DOOR_LAYER          4.020
		#define SIDE_WINDOW_LAYER         4.030
		#define FULL_WINDOW_LAYER         4.040
		#define ABOVE_WINDOW_LAYER        4.050
		#define LYING_MOB_LAYER           4.060
		#define LYING_HUMAN_LAYER         4.070
		#define ABOVE_OBJ_LAYER           4.080

	#define MOB_LAYER                 5.000
		#define HUMANOID_LAYER            5.010
		#define ABOVE_MOB_LAYER           5.020
		#define ABOVE_VEHICLE_LAYER       5.030

// For special effects.
#define EFFECTS_PLANE 2
	#define BELOW_PROJECTILE_LAYER    1
	#define DEEP_FLUID_LAYER          2
	#define FIRE_LAYER                3
	#define PROJECTILE_LAYER          4
	#define ABOVE_PROJECTILE_LAYER    5
	#define SINGULARITY_LAYER         6
	#define POINTER_LAYER             7
	#define ALARM_LAYER               8
	#define WEATHER_EFFECT_LAYER      9
	#define OBSERVER_LAYER          256

// Used for masking the Lighting plane
#define VISIBLE_GAME_WORLD_PLANE 3

// For Lighting. - The highest plane (ignoring all other even higher planes)
#define LIGHTING_PLANE 4
	#define LIGHTING_LAYER 0
	#define ABOVE_LIGHTING_LAYER 1

// For glowy eyes, laser beams, etc. that shouldn't be affected by darkness
#define EMISSIVE_PLANE 5
	#define EMISSIVE_BASE_LAYER -1024
	#define EMISSIVE_UNBLOCKABLE_LAYER 1024

// For visualnets, such as the AI's static.
#define OBSCURITY_PLANE 6

//This is difference between highest and lowest visible game planes
#define PLANE_DIFFERENCE 6

// for fullscreen overlays that do not cover the hud.
#define FULLSCREEN_PLANE 9000
	#define FULLSCREEN_LAYER    0
	#define DAMAGE_LAYER        1
	#define IMPAIRED_LAYER      2
	#define BLIND_LAYER         3
	#define CRIT_LAYER          4
	#define HALLUCINATION_LAYER 5

// For the Head-Up Display
#define HUD_PLANE 9001
	#define UNDER_HUD_LAYER      0
	#define HUD_BASE_LAYER       1
	#define HUD_CLICKABLE_LAYER  2
	#define HUD_ITEM_LAYER       3
	#define HUD_ABOVE_ITEM_LAYER 4

#define ABOVE_HUD_PLANE 9002 // For things to appear over the HUD

// This is the difference between the highest and lowest visible FULLSCREEN planes
#define FULLSCREEN_PLANE_DIFFERENCE 3

/*This file is a list of all preclaimed planes & layers

All planes & layers should be given a value here instead of using a magic/arbitrary number.

After fiddling with planes and layers for some time, I figured I may as well provide some documentation:

What are planes?
	Think of Planes as a sort of layer for a layer - if plane X is a larger number than plane Y, the highest number for a layer in X will be
	below the lowest number for a layer in Y.
	Planes also have the added bonus of having planesmasters.

What are Planesmasters?
	Planesmasters, when in the sight of a player, will have its appearance properties (for example, colour matrices, alpha, transform, etc)
	applied to all the other objects in the plane. This is all client sided.
	Usually you would want to add the planesmaster as an invisible image in the client's screen.

What can I do with Planesmasters?
	You can: Make certain players not see an entire plane,
	Make an entire plane have a certain colour matrices,
	Make an entire plane transform in a certain way,
	Make players see a plane which is hidden to normal players - I intend to implement this with the antag HUDs for example.
	Planesmasters can be used as a neater way to deal with client images or potentially to do some neat things

How do planes work?
	A plane can be any integer from -10000 to 10000. (If you want more, bug lummox.)
	Overflowing that range will cause the plane to be trimmed under-the-hood
	All planes above 0, the 'base plane', are visible even when your character cannot 'see' them, for example, the HUD.
	All planes below 0, the 'base plane', are only visible when a character can see them.

How do I add a plane?
	Think of where you want the plane to appear, look through the pre-existing planes and find where it is above and where it is below
	Slot it in in that place, and change the pre-existing planes, making sure no plane shares a number.
	Add a description with a comment as to what the plane does.

How do I make something a planesmaster?
	Add the PLANE_MASTER appearance flag to the appearance_flags variable.

What is the naming convention for planes or layers?
	Make sure to use the name of your object before the _LAYER or _PLANE, eg: [NAME_OF_YOUR_OBJECT HERE]_LAYER or [NAME_OF_YOUR_OBJECT HERE]_PLANE
	Also, as it's a define, it is standard practice to use capital letters for the variable so people know this.

*/

/*
	from stddef.dm, planes & layers built into byond.

	FLOAT_LAYER = -1
	AREA_LAYER = 1
	TURF_LAYER = 2
	OBJ_LAYER = 3
	MOB_LAYER = 4
	FLY_LAYER = 5
	EFFECTS_LAYER = 5000
	TOPDOWN_LAYER = 10000
	BACKGROUND_LAYER = 20000
	------

	FLOAT_PLANE = -32767
*/

#define MAX_PLANE 10000
#define MIN_PLANE -MAX_PLANE

// Background planes
#define CLICKCATCHER_PLANE MIN_PLANE

#define SPACE_PLANE -9000

#define SKYBOX_PLANE SPACE_PLANE + 1
	#define BASE_SKYBOX_LAYER 1
	#define DUST_LAYER 2

// Used for special cameras used by tgui and other special effects
#define MAP_VIEW_PLANE                0
	#define MAP_VIEW_LAYER 0

// Visible game planes
#define OPENSPACE_PLANE               1
	#define OPENSPACE_LAYER_MOBS 3
	#define OPENSPACE_DARKNESS_LAYER 15

// objects that are below turfs. Useful for asteroid smoothing or other such magic.
#define BELOW_TURF_PLANE              2

#define PLATING_PLANE                 3

#define ABOVE_PLATING_PLANE           4
	#define HOLOMAP_LAYER        1 // NOTE: ENSURE this is equal to the one at ABOVE_TURF_PLANE!
	#define DECAL_PLATING_LAYER  2
	#define LATTICE_LAYER        3
	#define DISPOSALS_PIPE_LAYER 4
	#define PIPE_LAYER           5
	#define WIRE_LAYER           6
	#define WIRE_TERMINAL_LAYER  7
	#define ABOVE_WIRE_LAYER     8

#define TURF_PLANE                     5
	#define BASE_TURF_LAYER -999
	#define TURF_DETAIL_LAYER 1

// For items which should appear above turfs but below other objects and hiding mobs, eg: wires & pipes
#define ABOVE_TURF_PLANE               6
	#define DECAL_LAYER                 2
	#define RUNE_LAYER                  3
	#define ABOVE_TILE_LAYER            4
	#define EXPOSED_PIPE_LAYER          5
	#define EXPOSED_WIRE_LAYER          6
	#define EXPOSED_WIRE_TERMINAL_LAYER 7
	#define BLOOD_LAYER                 9
	#define MOUSETRAP_LAYER             10
	#define PLANT_LAYER                 11

#define UNDER_OBJ_PLANE                7
	#define CATWALK_LAYER               1

// for hiding mobs like MoMMIs or spiders or whatever, under most objects but over pipes & such.
#define HIDING_MOB_PLANE               8
	#define HIDING_MOB_LAYER    0
	#define SHALLOW_FLUID_LAYER 1

// For objects which appear below humans.
#define OBJ_PLANE                      9
	#define BELOW_DOOR_LAYER        0.25
	#define OPEN_DOOR_LAYER         0.5
	#define BELOW_TABLE_LAYER       0.75
	#define TABLE_LAYER             1
	#define BELOW_OBJ_LAYER         2
	#define STRUCTURE_LAYER         2.5
	// OBJ_LAYER                    3
	#define ABOVE_OBJ_LAYER         4
	#define CLOSED_DOOR_LAYER       5
	#define ABOVE_DOOR_LAYER        6
	#define SIDE_WINDOW_LAYER       7
	#define FULL_WINDOW_LAYER       8
	#define ABOVE_WINDOW_LAYER      9

// other mobs that are lying down.
#define LYING_MOB_PLANE               10
	#define LYING_MOB_LAYER 0

// humans that are lying down
#define LYING_HUMAN_PLANE             11
	#define LYING_HUMAN_LAYER 0

// for objects that are below humans when they are standing but above them when they are not. - eg, blankets.
#define ABOVE_OBJ_PLANE               12
	#define BASE_ABOVE_OBJ_LAYER 0

// For Humans that are standing up.
#define HUMAN_PLANE                   13
	// MOB_LAYER 4

// For Mobs.
#define MOB_PLANE                     14
	// MOB_LAYER 4

// For things that should appear above humans.
#define ABOVE_HUMAN_PLANE             15
	#define ABOVE_HUMAN_LAYER  0
	#define VEHICLE_LOAD_LAYER 1
	#define CAMERA_LAYER       2

// For Blobs, which are above humans.
#define BLOB_PLANE                    16
	#define BLOB_SHIELD_LAYER       1
	#define BLOB_NODE_LAYER         2
	#define BLOB_CORE_LAYER         3

// For special effects.
#define EFFECTS_BELOW_LIGHTING_PLANE  17
	#define BELOW_PROJECTILE_LAYER  1
	#define DEEP_FLUID_LAYER        2
	#define FIRE_LAYER              3
	#define PROJECTILE_LAYER        4
	#define ABOVE_PROJECTILE_LAYER  5
	#define SINGULARITY_LAYER       6
	#define POINTER_LAYER           7
	#define ALARM_LAYER             8

// For observers and ghosts
#define OBSERVER_PLANE                18

// Used for masking the Lighting plane
#define VISIBLE_GAME_WORLD_PLANE      19

// For Lighting. - The highest plane (ignoring all other even higher planes)
#define LIGHTING_PLANE                20
	#define LIGHTBULB_LAYER        0
	#define LIGHTING_LAYER         1
	#define ABOVE_LIGHTING_LAYER   2
	#define SUPER_PORTAL_LAYER     3
	#define NARSIE_GLOW            4

// For glowy eyes, laser beams, etc. that shouldn't be affected by darkness
#define EMISSIVE_PLANE                21
	#define EYE_GLOW_LAYER         1
	#define BEAM_PROJECTILE_LAYER  2
	#define SUPERMATTER_WALL_LAYER 3
	#define EMISSIVE_LAYER 13

#define EMISSIVE_BLOCKER_PLANE        22
	#define EMISSIVE_BLOCKER_LAYER 14

#define EMISSIVE_UNBLOCKABLE_PLANE    23
	#define EMISSIVE_UNBLOCKABLE_LAYER   15

// For visualnets, such as the AI's static.
#define OBSCURITY_PLANE               24

//This is difference between highest and lowest visible game planes
#define PLANE_DIFFERENCE              25

// Not for anything, but this is the default.
#define BASE_PLANE                     0
	#define BASE_AREA_LAYER 999

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

// List of all planes that should be rendered to the HUD's
// handling of rendering multi-z
//
// Planes that are not included are:
// -
// - OPENSPACE_PLANE; not needed
// - LIGHTING_PLANE; blending cause the lighting overlay to be
//       almost invisible in multi-z. Undesired effect
/proc/multiz_rendering_planes()
	return list(
		BELOW_TURF_PLANE,
		PLATING_PLANE,
		ABOVE_PLATING_PLANE,
		TURF_PLANE,
		ABOVE_TURF_PLANE,
		UNDER_OBJ_PLANE,
		HIDING_MOB_PLANE,
		OBJ_PLANE,
		LYING_MOB_PLANE,
		LYING_HUMAN_PLANE,
		ABOVE_OBJ_PLANE,
		HUMAN_PLANE,
		MOB_PLANE,
		ABOVE_HUMAN_PLANE,
		BLOB_PLANE,
		EFFECTS_BELOW_LIGHTING_PLANE,
		OBSERVER_PLANE,
		VISIBLE_GAME_WORLD_PLANE,
		EMISSIVE_PLANE,
		EMISSIVE_BLOCKER_PLANE,
		OBSCURITY_PLANE
	)

/image/proc/plating_decal_layerise(atom/target)
	plane = target.get_float_plane(ABOVE_PLATING_PLANE)
	layer = DECAL_PLATING_LAYER

/image/proc/turf_decal_layerise(atom/target)
	plane = target.get_float_plane(ABOVE_TURF_PLANE)
	layer = DECAL_LAYER

/atom/proc/hud_layerise()
	plane = HUD_PLANE
	layer = HUD_ITEM_LAYER

/atom/proc/reset_plane_and_layer()
	set_plane(initial(plane))
	layer = initial(layer)

/*
	These defines specificy screen locations.  For more information, see the byond documentation on the screen_loc var.

	The short version:

	Everything is encoded as strings because apparently that's how Byond rolls.

	"1,1" is the bottom left square of the user's screen.  This aligns perfectly with the turf grid.
	"1:2,3:4" is the square (1,3) with pixel offsets (+2, +4); slightly right and slightly above the turf grid.
	Pixel offsets are used so you don't perfectly hide the turf under them, that would be crappy.

	The size of the user's screen is defined by client.view (indirectly by world.view), in our case "15x15".
	Therefore, the top right corner (except during admin shenanigans) is at "15,15"
*/

#define UI_ENTIRE_SCREEN "WEST,SOUTH to EAST,NORTH"

//Lower left, persistant menu
#define UI_INVENTORY "WEST:6,SOUTH:5"

//Lower center, persistant menu
#define UI_HAND_RIGHT "WEST-3,CENTER-1"
#define UI_HAND_LEFT "WEST-1,CENTER-1"
#define UI_EQUIP "WEST-2,CENTER-1"
#define UI_SWAPHAND1 "WEST-2,CENTER-1"

#define UI_ALIEN_HEAD "CENTER-3:12,SOUTH:5"		//aliens
#define UI_ALIEN_OCLOTHING "CENTER-2:14,SOUTH:5"//aliens

#define UI_INVENTORY_1 "CENTER-1,SOUTH:5"			//borgs
#define UI_INVENTORY_2 "CENTER,SOUTH:5"			//borgs
#define UI_INVENTORY_3 "CENTER+1,SOUTH:5"			//borgs
#define UI_BORG_STORAGE "CENTER+2,SOUTH:5"	//borgs
#define UI_BORG_INVENTORY "CENTER-2,SOUTH:5"//borgs

#define UI_CONSTRUCT_HEALTH "EAST:00,CENTER:15" //same height as humans, hugging the right border
#define UI_CONSTRUCT_PURGE "EAST:00,CENTER-1:15"
#define UI_CONSTRUCT_FIRE "EAST-1:16,CENTER+1:13" //above health, slightly to the left
#define UI_CONSTRUCT_PULL "EAST-1:28,SOUTH+1:10" //above the zone_sel icon

//Lower right, persistant menu
#define UI_BUTTON_DROP "WEST-1,CENTER-4"
#define UI_BUTTON_THROW "WEST-1,CENTER-4"
#define UI_BUTTON_RESIST "WEST-2,CENTER-4"
#define UI_INTENT_ACTION "WEST-2,CENTER-3"
#define UI_INTENT_PACE "WEST-3,CENTER-3"
#define UI_SELECT_ZONE "WEST-1,CENTER-3"

#define UI_BORG_PULL "EAST-3:24,SOUTH+1:7"
#define UI_BORG_MODULE "EAST-2:26,SOUTH+1:7"
#define UI_BORG_PANEL "EAST-1:28,SOUTH+1:7"

//Gun buttons
#define UI_BUTTON_GUN_ALLOW_ITEM "WEST-3,CENTER-5"
#define UI_BUTTON_GUN_ALLOW_MOVE "WEST-2,CENTER-5"
#define UI_BUTTON_GUN_ALLOW_RADIO "WEST-1,CENTER-5"
#define UI_BUTTON_GUN_MODE "WEST-3,CENTER-4"

//Upper-middle right (damage indicators)
#define UI_WARNING_TOXIN "EAST+1,NORTH-1"
#define UI_WARNING_OXYGEN "EAST+1,NORTH-2"
#define UI_WARNING_FIRE "EAST+1,NORTH-3"
#define UI_WARNING_FREEZE "EAST+1,NORTH-4"

//Middle right (status indicators)
#define UI_METER_INTERNAL "EAST+1,NORTH"
#define UI_METER_PRESSURE "EAST+1,CENTER+2"
#define UI_METER_BODY_TEMPERATURE "EAST+1,CENTER+1"
#define UI_METER_HEALTH "EAST+1,CENTER"
#define UI_METER_NUTRITION "EAST+1,CENTER-2"

//borgs have the health display where humans have the pressure damage indicator.
#define UI_METER_HEALTH_BORG "EAST-1:28,CENTER-1:13"
//aliens have the health display where humans have the pressure damage indicator.
#define UI_METER_HEALTH_ALIEN "EAST-1:28,CENTER-1:13"

//Inventory
#define UI_INVENTORY_SLOT_SHOES "WEST-3,CENTER+3"

#define UI_INVENTORY_SLOT_UNDERSUIT "WEST-2,CENTER+3"
#define UI_INVENTORY_SLOT_OVERSUIT "WEST-2,CENTER+4"
#define UI_INVENTORY_SLOT_GLOVES "WEST-1,CENTER+3"

#define UI_INVENTORY_SLOT_POCKET_SUIT "WEST-3,CENTER+1:16"
#define UI_INVENTORY_SLOT_POCKET_LEFT "WEST-2,CENTER+1:16"
#define UI_INVENTORY_SLOT_POCKET_RIGHT "WEST-1,CENTER+1:16"

#define UI_INVENTORY_SLOT_CARD "WEST-1,CENTER:16"
#define UI_INVENTORY_SLOT_BELT "WEST-2,CENTER:16"
#define UI_INVENTORY_SLOT_BACK "WEST-3,CENTER:16"

#define UI_INVENTORY_SLOT_GLASSES "WEST-3,CENTER+5"
#define UI_INVENTORY_SLOT_MASK "WEST-3,CENTER+4"
#define UI_INVENTORY_SLOT_EAR_LEFT "WEST-1,CENTER+5"
#define UI_INVENTORY_SLOT_EAR_RIGHT "WEST-1,CENTER+4"

#define UI_INVENTORY_SLOT_HEADWEAR "WEST-2,CENTER+5"

#define ui_spell_master "EAST-1:16,NORTH-1:16"
#define ui_genetic_master "EAST-1:16,NORTH-3:16"

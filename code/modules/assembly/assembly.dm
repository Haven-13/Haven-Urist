/obj/item/device/assembly
	name = "assembly"
	desc = "A small electronic device that should never exist."
	icon = 'resources/icons/obj/assemblies/new_assemblies.dmi'
	icon_state = ""
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	w_class = ITEM_SIZE_SMALL
	matter = list(DEFAULT_WALL_MATERIAL = 100)
	throwforce = 2
	throw_speed = 3
	throw_range = 10
	origin_tech = list(TECH_MAGNET = 1)

	var/secured = 1
	var/list/attached_overlays = null
	var/obj/item/device/assembly_holder/holder = null
	var/cooldown = 0//To prevent spam
	var/wires = WIRE_RECEIVE | WIRE_PULSE

//Called via spawn(10) to have it count down the cooldown var
/obj/item/device/assembly/proc/process_cooldown()
	cooldown--
	if(cooldown <= 0)	return 0
	spawn(10)
		process_cooldown()
	return 1

//Called when another assembly acts on this one, var/radio will determine where it came from for wire calcs
/obj/item/device/assembly/proc/pulsed(radio = 0)
	if(holder && (wires & WIRE_RECEIVE))
		activate()
	if(radio && (wires & WIRE_RADIO_RECEIVE))
		activate()
	return 1

//Called when this device attempts to act on another device, var/radio determines if it was sent via radio or direct
/obj/item/device/assembly/proc/pulse(radio = 0)
	if(holder && (wires & WIRE_PULSE))
		holder.process_activation(src, 1, 0)
	if(holder && (wires & WIRE_PULSE_SPECIAL))
		holder.process_activation(src, 0, 1)
//		if(radio && (wires & WIRE_RADIO_PULSE))
		//Not sure what goes here quite yet send signal?
	return 1

//What the device does when turned on
/obj/item/device/assembly/proc/activate()
	if(!secured || (cooldown > 0))	return 0
	cooldown = 2
	spawn(10)
		process_cooldown()
	return 1

//Code that has to happen when the assembly is un\secured goes here
/obj/item/device/assembly/proc/toggle_secure()
	secured = !secured
	update_icon()
	return secured

//Called when an assembly is attacked by another
/obj/item/device/assembly/proc/attach_assembly(obj/item/device/assembly/A, mob/user)
	holder = new/obj/item/device/assembly_holder(get_turf(src))
	if(holder.attach(A,src,user))
		to_chat(user, "<span class='notice'>You attach \the [A] to \the [src]!</span>")
		return 1
	return 0

//Called when the holder is moved
/obj/item/device/assembly/proc/holder_movement()
	return

/obj/item/device/assembly/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(isassembly(W))
		var/obj/item/device/assembly/A = W
		if((!A.secured) && (!secured))
			attach_assembly(A,user)
			return
	if(is_screwdriver(W))
		if(toggle_secure())
			to_chat(user, "<span class='notice'>\The [src] is ready!</span>")
		else
			to_chat(user, "<span class='notice'>\The [src] can now be attached!</span>")
		return
	..()
	return

/obj/item/device/assembly/Process()
	return PROCESS_KILL

/obj/item/device/assembly/examine(mob/user)
	. = ..(user)
	if((in_range(src, user) || loc == user))
		if(secured)
			to_chat(user, "\The [src] is ready!")
		else
			to_chat(user, "\The [src] can be attached!")
	return

/obj/item/device/assembly/attack_self(mob/user as mob)
	if(!user)	return 0
	user.set_machine(src)
	interact(user)
	return 1

//Called when attack_self is called
/obj/item/device/assembly/interact(mob/user as mob)
	return //HTML MENU FOR WIRES GOES HERE

/obj/item/device/assembly/ui_host()
	if(istype(loc, /obj/item/device/assembly_holder))
		return loc.ui_host()
	return ..()

/obj/item/assembly/ui_state(mob/user)
	return ui_hands_state()

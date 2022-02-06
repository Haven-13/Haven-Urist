#define PUBLIC_GAME_MODE SSticker.master_mode

#define Clamp(value, low, high) 	(value <= low ? low : (value >= high ? high : value))
#define CLAMP01(x) 		(Clamp(x, 0, 1))

#define get_turf(A) get_step(A,0)

#define is_type(A, P) istype(A, P)
#define is_null(A) isnull(A)
#define is_num(A) isnum(A)
#define is_area(A) isarea(A)
#define is_mob(A) ismob(A)
#define is_turf(A) isturf(A)

#define is_atom(A) istype(A, /atom)
#define is_movable(A) istype(A, /atom/movable)
#define is_client(A) istype(A, /client)
#define is_list(A) istype(A, /list)

#define iscolorablegloves(A) (istype(A, /obj/item/clothing/gloves/color)||istype(A, /obj/item/clothing/gloves/insulated)||istype(A, /obj/item/clothing/gloves/thick))

#define is_obj(A) istype(A, /obj)
#define is_item(A) istype(A, /obj/item)
#define is_organ(A) istype(A, /obj/item/organ/external)
#define is_stack(A) istype(A, /obj/item/stack)
#define is_underwear(A) istype(A, /obj/item/underwear)

#define is_space(A) istype(A, /area/space)
#define is_planet(A) istype(A, /area/planet)

#define is_ai(A) istype(A, /mob/living/silicon/ai)
#define is_alien(A) istype(A, /mob/living/carbon/alien)
#define is_animal(A) istype(A, /mob/living/simple_animal)
#define is_brain(A) istype(A, /mob/living/carbon/brain)
#define is_carbon_mob(A) istype(A, /mob/living/carbon)
#define is_corgi(A) istype(A, /mob/living/simple_animal/corgi)
#define is_drone(A) istype(A, /mob/living/silicon/robot/drone)
#define is_eye(A) istype(A, /mob/observer/eye)
#define is_ghost(A) istype(A, /mob/observer/ghost)
#define is_living_mob(A) istype(A, /mob/living)
#define is_human_mob(A) istype(A, /mob/living/carbon/human)
#define is_mouse(A) istype(A, /mob/living/simple_animal/mouse)
#define is_new_player(A) istype(A, /mob/new_player)
#define is_observer(A) istype(A, /mob/observer)
#define is_pai(A) istype(A, /mob/living/silicon/pai)
#define is_robot(A) istype(A, /mob/living/silicon/robot)
#define is_silicon(A) istype(A, /mob/living/silicon)
#define is_slime(A) istype(A, /mob/living/carbon/slime)
#define is_virtual_mob(A) istype(A, /mob/observer/virtual)

#define is_open_space(A) istype(A, /turf/simulated/open)

#define is_wrench(A) istype(A, /obj/item/weapon/wrench)
#define is_welder(A) istype(A, /obj/item/weapon/weldingtool)
#define is_coil(A) istype(A, /obj/item/stack/cable_coil)
#define is_wirecutter(A) istype(A, /obj/item/weapon/wirecutters)
#define is_screwdriver(A) istype(A, /obj/item/weapon/screwdriver)
#define is_multitool(A) istype(A, /obj/item/device/multitool)
#define is_crowbar(A) istype(A, /obj/item/weapon/crowbar)

#define attack_animation(A) if(istype(A)) A.do_attack_animation(src)

#define sequential_id(key) uniqueness_repository.Generate(/datum/uniqueness_generator/id_sequential, key)

#define random_id(key,min_id,max_id) uniqueness_repository.Generate(/datum/uniqueness_generator/id_random, key, min_id, max_id)

#define to_chat(target, message)                            target << message
#define to_world(message)                                   to_chat(world, message)
#define to_world_log(message)                               to_chat(world.log, message)
#define sound_to(target, sound)                             target << sound
#define to_file(file_entry, source_var)                     file_entry << source_var
#define from_file(file_entry, target_var)                   file_entry >> target_var
#define show_browser(target, browser_content, browser_name) target << browse(browser_content, browser_name)
#define close_browser(target, browser_name)                 target << browse(null, browser_name)
#define show_image(target, image)                           target << image
#define send_rsc(target, rsc_content, rsc_name)             target << browse_rsc(rsc_content, rsc_name)
#define send_file(target, file)                             target << run(file)
#define open_link(target, url)                              target << link(url)

#define MAP_IMAGE_PATH "resources/html/images/[GLOB.using_map.path]/"

#define map_image_file_name(z_level) "[GLOB.using_map.path]-[z_level].png"

#define RANDOM_BLOOD_TYPE pick(4;"O-", 36;"O+", 3;"A-", 28;"A+", 1;"B-", 20;"B+", 1;"AB-", 5;"AB+")

#define any2ref(x) REF(x)

#define ARGS_DEBUG log_debug("[__FILE__] - [__LINE__]") ; for(var/arg in args) { log_debug("\t[log_info_line(arg)]") }

// Insert an object A into a sorted list using cmp_proc (/code/_helpers/cmp.dm) for comparison.
#define ADD_SORTED(list, A, cmp_proc) \
	if(!list.len) {list.Add(A)} else {list.Insert(FindElementIndex(A, list, cmp_proc), A)}

//Currently used in SDQL2 stuff
/proc/send_output(target, msg, control)
	target << output(msg, control)

/proc/send_link(target, url)
	open_link(target, url)

// Spawns multiple objects of the same type
#define cast_new(type, num, args...) if((num) == 1) { new type(args) } else { for(var/i=0;i<(num),i++) { new type(args) } }

#define FLAGS_EQUALS(flag, flags) ((flag & (flags)) == (flags))

#define JOINTEXT(X) jointext(X, null)

#define SPAN_NOTICE(X) "<span class='notice'>[X]</span>"

#define SPAN_WARNING(X) "<span class='warning'>[X]</span>"

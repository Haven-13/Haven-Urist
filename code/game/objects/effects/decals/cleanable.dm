/obj/effect/decal/cleanable
	var/persistent = FALSE
	var/generic_filth = FALSE
	var/age = 0
	var/list/random_icon_states

/obj/effect/decal/cleanable/Initialize(ml, _age)
	if(!isnull(_age))
		age = _age
	if(random_icon_states && length(src.random_icon_states) > 0)
		src.icon_state = pick(src.random_icon_states)
	SSpersistence.track_value(src, /datum/persistent/filth)
	. = ..()

/obj/effect/decal/cleanable/Destroy()
	SSpersistence.forget_value(src, /datum/persistent/filth)
	. = ..()
/obj/effect/decal/cleanable/water_act(depth)
	..()
	qdel(src)

/obj/effect/decal/cleanable/clean_blood(ignore = 0)
	if(!ignore)
		qdel(src)
		return
	..()

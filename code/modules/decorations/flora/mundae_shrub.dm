/obj/structure/flora/shrub
	name = "shrub"
	icon = 'icons/obj/flora/goonflora.dmi'
	icon_state = "shrub"
	anchored = 1

	plane = ABOVE_HUMAN_PLANE
	layer = ABOVE_HUMAN_LAYER

	FASTDMM_PROP(\
		dir_amount = 8,\
		pinned_vars = list("dir")\
	)

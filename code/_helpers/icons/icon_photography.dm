//For photo camera.
/proc/build_composite_icon(atom/A)
	var/icon/composite = icon(A.icon, A.icon_state, A.dir, 1)
	for(var/O in A.overlays)
		var/image/I = O
		composite.Blend(icon(I.icon, I.icon_state, I.dir, 1), ICON_OVERLAY)
	return composite

/*
generate_image function generates image of specified range and location
arguments tx, ty, tz are target coordinates (requred), range defines render distance to opposite corner (requred)
cap_mode is capturing mode (optional), user is capturing mob (requred only wehen cap_mode = CAPTURE_MODE_REGULAR),
lighting determines lighting capturing (optional), suppress_errors suppreses errors and continues to capture (optional).
*/
/proc/generate_image(var/tx as num, var/ty as num, var/tz as num, var/range as num, var/cap_mode = CAPTURE_MODE_PARTIAL, var/mob/living/user, var/lighting = 1, var/suppress_errors = 1)
	var/list/turfstocapture = list()
	//Lines below determine what tiles will be rendered
	for(var/xoff = 0 to range)
		for(var/yoff = 0 to range)
			var/turf/T = locate(tx + xoff,ty + yoff,tz)
			if(T)
				if(cap_mode == CAPTURE_MODE_REGULAR)
					if(user.can_capture_turf(T))
						turfstocapture.Add(T)
						continue
				else
					turfstocapture.Add(T)
			else
				//Capture includes non-existan turfs
				if(!suppress_errors)
					return
	//Lines below determine what objects will be rendered
	var/list/atoms = list()
	for(var/turf/T in turfstocapture)
		atoms.Add(T)
		for(var/atom/A in T)
			if(istype(A, /atom/movable/lighting_overlay) && lighting) //Special case for lighting
				atoms.Add(A)
				continue
			if(prob(90) && istype(A, /mob/observer/ghost) && round_is_spooky())
				atoms.Add(A)
				continue
			if(A.invisibility) continue
			atoms.Add(A)
	//Lines below actually render all colected data
	atoms = sort_atoms_by_layer(atoms)
	var/icon/cap = icon('resources/icons/effects/96x96.dmi', "")
	cap.Scale(range*32, range*32)
	cap.Blend("#000", ICON_OVERLAY)
	for(var/atom/A in atoms)
		if(A)
			var/icon/img = getFlatIcon(A)
			if(istype(img, /icon))
				if(istype(A, /mob/living) && A:lying)
					img.Turn(90)
					img.Shift(SOUTH,6)
					img.Shift(EAST,1)
				var/xoff = (A.x - tx) * 32
				var/yoff = (A.y - ty) * 32
				cap.Blend(img, blendMode2iconMode(A.blend_mode),  A.pixel_x + xoff, A.pixel_y + yoff)

	return cap

/*
Get flat icon by DarkCampainger. As it says on the tin, will return an icon with all the overlays
as a single icon. Useful for when you want to manipulate an icon via the above as overlays are not normally included.
The _flatIcons list is a cache for generated icon files.
*/
// Creates a single icon from a given /atom or /image.  Only the first argument is required.
/proc/getFlatIcon(image/A, defdir=2, deficon=null, defstate="", defblend=BLEND_DEFAULT, always_use_defdir = 0)
	// We start with a blank canvas, otherwise some icon procs crash silently
	var/icon/flat = icon('resources/icons/effects/effects.dmi', "nothing") // Final flattened icon
	if(!A || A.alpha <= 0)
		return flat

	var/curicon =  A.icon || deficon
	var/curstate = A.icon_state || defstate
	var/curdir =   (A.dir != SOUTH && !always_use_defdir) ? A.dir : defdir
	var/curblend = (A.blend_mode == BLEND_DEFAULT) ? defblend : A.blend_mode

	if(curicon && !check_state_in_icon(curstate, curicon))
		if(check_state_in_icon("", curicon))
			curstate = ""
		else
			curicon = null // Do not render this object.

	// Layers will be a sorted list of icons/overlays, based on the order in which they are displayed
	var/list/layers = list()
	var/image/copy
	// Add the atom's icon itself, without pixel_x/y offsets.
	if(curicon)
		copy = image(icon = curicon, icon_state = curstate, layer = A.layer, dir = curdir)
		copy.color = A.color
		copy.alpha = A.alpha
		copy.blend_mode = curblend
		layers[copy] = A.layer

	// Loop through the underlays, then overlays, sorting them into the layers list
	var/list/process = A.underlays // Current list being processed
	var/pSet=0 // Which list is being processed: 0 = underlays, 1 = overlays
	var/curIndex=1 // index of 'current' in list being processed
	var/current // Current overlay being sorted
	var/currentLayer // Calculated layer that overlay appears on (special case for FLOAT_LAYER)
	var/compare // The overlay 'add' is being compared against
	var/cmpIndex // The index in the layers list of 'compare'
	while(TRUE)
		if(curIndex<=process.len)
			current = process[curIndex]
			if(current)
				currentLayer = current:layer
				if(currentLayer<0) // Special case for FLY_LAYER
					if(currentLayer <= -1000) return flat
					if(pSet == 0) // Underlay
						currentLayer = A.layer+currentLayer/1000
					else // Overlay
						currentLayer = A.layer+(1000+currentLayer)/1000

				// Sort add into layers list
				for(cmpIndex=1,cmpIndex<=layers.len,cmpIndex++)
					compare = layers[cmpIndex]
					if(currentLayer < layers[compare]) // Associated value is the calculated layer
						layers.Insert(cmpIndex,current)
						layers[current] = currentLayer
						break
				if(cmpIndex>layers.len) // Reached end of list without inserting
					layers[current]=currentLayer // Place at end

			curIndex++
		else if(pSet == 0) // Switch to overlays
			curIndex = 1
			pSet = 1
			process = A.overlays
		else // All done
			break

	// Current dimensions of flattened icon
	var/flatX1= 1
	var/flatX2= flat.Width()
	var/flatY1= 1
	var/flatY2= flat.Height()

	// Dimensions of overlay being added
	var/addX1
	var/addX2
	var/addY1
	var/addY2

	var/icon/add // Icon of overlay being added
	for(var/image/I as anything in layers)
		if(I.alpha == 0)
			continue

		if(I == copy) // 'I' is an /image based on the object being flattened.
			curblend = BLEND_OVERLAY
			add = icon(I.icon, I.icon_state, I.dir)
			// This checks for a silent failure mode of the icon routine. If the requested dir
			// doesn't exist in this icon state it returns a 32x32 icon with 0 alpha.
			if (I.dir != SOUTH && add.Width() == 32 && add.Height() == 32)
				// Check every pixel for blank (computationally expensive, but the process is limited
				// by the amount of film on the station, only happens when we hit something that's
				// turned, and bails at the very first pixel it sees.
				var/blankpixel;
				for(var/y;y<=32;y++)
					for(var/x;x<32;x++)
						blankpixel = isnull(add.GetPixel(x,y))
						if(!blankpixel)
							break
					if(!blankpixel)
						break
				// If we ALWAYS returned a null (which happens when GetPixel encounters something with alpha 0)
				if (blankpixel)
					// Pull the default direction.
					add = icon(I.icon, I.icon_state)
		else // 'I' is an appearance object.
			if(istype(A,/obj/machinery/atmospherics) && (I in A.underlays))
				add = getFlatIcon(new /image(I), I.dir, curicon, null, curblend, 1)
			else
				/*
				The state var is null so that it uses the appearance's state, not ours or the default
				Falling back to our state if state is null would be incorrect overlay logic (overlay with null state does not inherit it from parent to which it is attached)

				If icon is null on an overlay it will inherit the icon from the attached parent, so we _do_ pass curicon ...
				but it does not do so if its icon_state is ""/null, so we check beforehand to exclude this
				*/
				var/icon_to_pass = (!I.icon_state && !I.icon) ? null : curicon
				add = getFlatIcon(new/image(I), curdir, icon_to_pass, null, curblend, always_use_defdir)

		// Find the new dimensions of the flat icon to fit the added overlay
		addX1 = min(flatX1, I.pixel_x + 1)
		addX2 = max(flatX2, I.pixel_x + add.Width())
		addY1 = min(flatY1, I.pixel_y + 1)
		addY2 = max(flatY2, I.pixel_y + add.Height())

		if(addX1 != flatX1 || addX2 != flatX2 || addY1 != flatY1 || addY2 != flatY2)
			// Resize the flattened icon so the new icon fits
			flat.Crop(addX1-flatX1+1, addY1-flatY1+1, addX2-flatX1+1, addY2-flatY1+1)
			flatX1 = addX1
			flatX2 = addX2
			flatY1 = addY1
			flatY2 = addY2

		var/iconmode
		if(I in A.overlays)
			iconmode = ICON_OVERLAY
		else if(I in A.underlays)
			iconmode = ICON_UNDERLAY
		else
			iconmode = blendMode2iconMode(curblend)
		// Blend the overlay into the flattened icon
		flat.Blend(add, iconmode, I.pixel_x + 2 - flatX1, I.pixel_y + 2 - flatY1)

	if(A.color)
		// Probably a colour matrix, could also check length(A.color) == 20 if color normalization becomes more complex in the future.
		if(is_list(A.color))
			flat.MapColors(arglist(A.color))

		// Probably a valid color, could check length_char(A.color) == 7 if color normalization becomes etc etc etc.
		else if(istext(A.color))
			flat.Blend(A.color, ICON_MULTIPLY)

	// Colour matrices track/apply alpha changes in MapColors() above, so only apply if color isn't a matrix.
	if(A.alpha < 255 && !is_list(A.color))
		flat.Blend(rgb(255, 255, 255, A.alpha), ICON_MULTIPLY)

	return icon(flat, "", SOUTH)

/proc/getIconMask(atom/A)//By yours truly. Creates a dynamic mask for a mob/whatever. /N
	var/icon/alpha_mask = new(A.icon,A.icon_state)//So we want the default icon and icon state of A.
	for(var/I in A.overlays)//For every image in overlays. var/image/I will not work, don't try it.
		if(I:layer>A.layer)	continue//If layer is greater than what we need, skip it.
		var/icon/image_overlay = new(I:icon,I:icon_state)//Blend only works with icon objects.
		//Also, icons cannot directly set icon_state. Slower than changing variables but whatever.
		alpha_mask.Blend(image_overlay,ICON_OR)//OR so they are lumped together in a nice overlay.
	return alpha_mask//And now return the mask.

/mob/proc/AddCamoOverlay(atom/A)//A is the atom which we are using as the overlay.
	var/icon/opacity_icon = new(A.icon, A.icon_state)//Don't really care for overlays/underlays.
	//Now we need to culculate overlays+underlays and add them together to form an image for a mask.
	//var/icon/alpha_mask = getFlatIcon(src)//Accurate but SLOW. Not designed for running each tick. Could have other uses I guess.
	var/icon/alpha_mask = getIconMask(src)//Which is why I created that proc. Also a little slow since it's blending a bunch of icons together but good enough.
	opacity_icon.AddAlphaMask(alpha_mask)//Likely the main source of lag for this proc. Probably not designed to run each tick.
	opacity_icon.ChangeOpacity(0.4)//Front end for MapColors so it's fast. 0.5 means half opacity and looks the best in my opinion.
	for(var/i=0,i<5,i++)//And now we add it as overlays. It's faster than creating an icon and then merging it.
		var/image/I = image("icon" = opacity_icon, "icon_state" = A.icon_state, "layer" = layer+0.8)//So it's above other stuff but below weapons and the like.
		switch(i)//Now to determine offset so the result is somewhat blurred.
			if(1)	I.pixel_x--
			if(2)	I.pixel_x++
			if(3)	I.pixel_y--
			if(4)	I.pixel_y++
		overlays += I//And finally add the overlay.

#define HOLOPAD_SHORT_RANGE 1 //For determining the color of holopads based on whether they're short or long range.
#define HOLOPAD_LONG_RANGE 2

/proc/getHologramIcon(icon/A, safety=1, noDecolor=FALSE, var/hologram_color=HOLOPAD_SHORT_RANGE)//If safety is on, a new icon is not created.
	var/icon/flat_icon = safety ? A : new(A)//Has to be a new icon to not constantly change the same icon.
	if (noDecolor == FALSE)
		if(hologram_color == HOLOPAD_LONG_RANGE)
			flat_icon.ColorTone(rgb(225,223,125)) //Light yellow if it's a call to a long-range holopad.
		else
			flat_icon.ColorTone(rgb(125,180,225))//Let's make it bluish.
	flat_icon.ChangeOpacity(0.5)//Make it half transparent.
	var/icon/alpha_mask = new('resources/icons/effects/effects.dmi', "scanline-[hologram_color]")//Scanline effect.
	flat_icon.AddAlphaMask(alpha_mask)//Finally, let's mix in a distortion effect.
	return flat_icon

/proc/adjust_brightness(var/color, var/value)
	if (!color) return "#ffffff"
	if (!value) return color

	var/list/RGB = ReadRGB(color)
	RGB[1] = Clamp(RGB[1]+value,0,255)
	RGB[2] = Clamp(RGB[2]+value,0,255)
	RGB[3] = Clamp(RGB[3]+value,0,255)
	return rgb(RGB[1],RGB[2],RGB[3])

/proc/sort_atoms_by_layer(var/list/atoms)
	// Comb sort icons based on levels
	var/list/result = atoms.Copy()
	var/gap = result.len
	var/swapped = 1
	while (gap > 1 || swapped)
		swapped = 0
		if(gap > 1)
			gap = round(gap / 1.3) // 1.3 is the emperic comb sort coefficient
		if(gap < 1)
			gap = 1
		for(var/i = 1; gap + i <= result.len; i++)
			var/atom/l = result[i]		//Fucking hate
			var/atom/r = result[gap+i]	//how lists work here
			if(l.plane > r.plane || (l.plane == r.plane && l.layer > r.layer))		//no "result[i].layer" for me
				result.Swap(i, gap + i)
				swapped = 1
	return result

/// Generate a filename for this asset
/// The same asset will always lead to the same asset name
/// (Generated names do not include file extention.)
/proc/generate_asset_name(file)
	return "asset.[md5(fcopy_rsc(file))]"

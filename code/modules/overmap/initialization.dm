#define USING_OVERMAP_GENERATOR_TYPE /datum/overmap_generator/system

GLOBAL_VAR_INIT(overmap_generator_type, USING_OVERMAP_GENERATOR_TYPE)
GLOBAL_DATUM(overmap_generator, /datum/overmap_generator)

#define IS_OVERMAP_INITIALIZED (GLOB.overmap_generator)

/proc/overmap_initialize()
	if(!GLOB.using_map.use_overmap)
		return 1

	testing("Building overmap...")

	GLOB.overmap_generator = new GLOB.overmap_generator_type()
	GLOB.overmap_generator.build_overmap()

	testing("Overmap build complete.")
	return 1
